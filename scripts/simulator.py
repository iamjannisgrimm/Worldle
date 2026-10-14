#!/usr/bin/env python3
"""Small Worldle simulator runner. Does not erase devices, publish, or alter Codex config."""
import argparse
from datetime import datetime, timezone
import json
from pathlib import Path
import signal
import subprocess
import sys
import uuid

ROOT = Path(__file__).resolve().parents[1]
PROFILE = json.loads((ROOT / 'config/testing.json').read_text())
CACHE = Path.home() / 'Library/Caches/Sevolu/Worldle'


def output(*args):
    return subprocess.check_output(args, cwd=ROOT, text=True, stderr=subprocess.STDOUT).strip()


def sim(*args):
    return output('xcrun', 'simctl', *args)


def devices():
    return [(runtime, device) for runtime, group in json.loads(sim('list', 'devices', 'available', '--json'))['devices'].items() for device in group]


def selected(udid):
    matches = [(runtime, d) for runtime, d in devices() if d['udid'] == udid]
    if len(matches) != 1 or matches[0][1]['name'] != PROFILE['simulator_name']:
        raise ValueError('Use the dedicated Worldle Agent Test UDID returned by prepare; other devices are not modified.')
    runtime, device = matches[0]
    expected = f"com.apple.CoreSimulator.SimRuntime.iOS-{PROFILE['runtime_major']}-"
    if not runtime.startswith(expected):
        raise ValueError('Simulator runtime does not match config/testing.json.')
    return runtime, device


def boot(udid):
    _, device = selected(udid)
    if device['state'] != 'Booted':
        sim('boot', udid)
    subprocess.run(['xcrun', 'simctl', 'bootstatus', udid, '-b'], cwd=ROOT, check=True, timeout=180)


def run_directory():
    name = datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ') + '-' + uuid.uuid4().hex[:8]
    path = CACHE / 'runs' / name
    path.mkdir(parents=True, exist_ok=False)
    return path


def build(udid, testing=False):
    runtime, device = selected(udid)
    boot(udid)
    run = run_directory()
    derived = run / 'DerivedData'
    command = ['xcodebuild', '-project', PROFILE['project'], '-scheme', PROFILE['scheme'],
               '-configuration', PROFILE['configuration'], '-destination', f'platform=iOS Simulator,id={udid}',
               '-derivedDataPath', str(derived), 'CODE_SIGNING_ALLOWED=NO']
    if testing:
        command += ['-resultBundlePath', str(run / 'tests.xcresult'), '-parallel-testing-enabled', 'NO',
                    '-only-testing:' + PROFILE['ui_test'], 'test']
    else:
        command += ['build']
    revision = output('git', 'rev-parse', 'HEAD')
    dirty = bool(output('git', 'status', '--porcelain'))
    print('Build log:', run / 'build.log', flush=True)
    try:
        with (run / 'build.log').open('w') as log:
            result = subprocess.run(command, cwd=ROOT, stdout=log, stderr=subprocess.STDOUT, timeout=600)
        code = result.returncode
    except subprocess.TimeoutExpired:
        code = 124
    summary = None
    summary_error = None
    if testing:
        try:
            summary = json.loads(output('xcrun', 'xcresulttool', 'get', 'test-results', 'summary',
                                        '--path', str(run / 'tests.xcresult'), '--compact'))
            (run / 'test-summary.json').write_text(json.dumps(summary, indent=2) + '\n')
        except (ValueError, subprocess.SubprocessError) as error:
            summary_error = str(error)
    passed = code == 0 and (not testing or (summary is not None
                           and summary.get('passedTests', 0) > 0
                           and summary.get('failedTests') == 0
                           and summary.get('skippedTests') == 0
                           and summary.get('result') == 'Passed'))
    receipt = {'checked_at': datetime.now(timezone.utc).isoformat(), 'check': 'ui-smoke' if testing else 'build',
               'repository': str(ROOT), 'revision': revision, 'dirty': dirty, 'udid': udid, 'runtime': runtime,
               'device': device['name'], 'command': command, 'exit_code': code, 'passed': passed,
               'test_summary': summary, 'test_summary_error': summary_error}
    (run / 'result.json').write_text(json.dumps(receipt, indent=2) + '\n')
    print('Evidence:', run, flush=True)
    if not passed:
        print((run / 'build.log').read_text()[-6000:], file=sys.stderr)
        raise RuntimeError(f'Check did not pass (build exit {code}); inspect the retained log/result bundle and test summary.')
    return derived / f"Build/Products/{PROFILE['configuration']}-iphonesimulator/Worldle.app"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=['doctor', 'prepare', 'build', 'test', 'launch', 'screenshot', 'record'])
    parser.add_argument('--udid')
    parser.add_argument('--seconds', type=int, default=20)
    args = parser.parse_args()
    if args.action == 'doctor':
        print(output('xcodebuild', '-version'))
        runtimes = json.loads(sim('list', 'runtimes', '--json'))['runtimes']
        valid = [r for r in runtimes if r.get('isAvailable') and r['identifier'].startswith(f"com.apple.CoreSimulator.SimRuntime.iOS-{PROFILE['runtime_major']}-")]
        print(json.dumps({'python': sys.version.split()[0], 'project_exists': (ROOT / PROFILE['project']).is_dir(),
                          'available_matching_runtimes': [r['identifier'] for r in valid],
                          'account': PROFILE['account'], 'interactive_ui_control': 'Check the current Codex session; not tested by doctor',
                          'ui_smoke': 'Not run by doctor'}, indent=2))
        return 0 if valid and (ROOT / PROFILE['project']).is_dir() else 1
    if args.action == 'prepare':
        matches = [d for _, d in devices() if d['name'] == PROFILE['simulator_name']]
        if len(matches) > 1:
            raise ValueError('Multiple Worldle test simulators exist; resolve the naming conflict explicitly.')
        if matches:
            udid = matches[0]['udid']
        else:
            runtimes = json.loads(sim('list', 'runtimes', '--json'))['runtimes']
            valid = [r for r in runtimes if r.get('isAvailable') and r['identifier'].startswith(f"com.apple.CoreSimulator.SimRuntime.iOS-{PROFILE['runtime_major']}-")]
            if not valid:
                raise ValueError('Install an iOS 26 simulator runtime in Xcode before preparing this profile.')
            runtime = max(valid, key=lambda r: tuple(int(p) for p in r['version'].split('.')))
            udid = sim('create', PROFILE['simulator_name'], PROFILE['preferred_device_type'], runtime['identifier'])
        selected(udid)
        print(udid, flush=True)
        boot(udid)
        return 0
    if not args.udid:
        parser.error('--udid is required; run prepare first')
    selected(args.udid)
    if args.action in ['build', 'test', 'launch']:
        app = build(args.udid, testing=args.action == 'test')
        if args.action == 'launch':
            sim('install', args.udid, str(app))
            print(sim('launch', args.udid, PROFILE['bundle_id']))
        return 0
    boot(args.udid)
    run = run_directory()
    if args.action == 'screenshot':
        sim('io', args.udid, 'screenshot', str(run / 'screen.png'))
        print(run / 'screen.png')
    else:
        if not 1 <= args.seconds <= 120:
            parser.error('--seconds must be between 1 and 120')
        path = run / 'interaction.mov'
        process = subprocess.Popen(['xcrun', 'simctl', 'io', args.udid, 'recordVideo', str(path)], cwd=ROOT)
        try:
            try:
                code = process.wait(timeout=args.seconds)
            except subprocess.TimeoutExpired:
                process.send_signal(signal.SIGINT)
                code = process.wait(timeout=20)
        finally:
            if process.poll() is None:
                process.kill()
                process.wait()
        if code != 0 or not path.exists() or path.stat().st_size == 0:
            raise RuntimeError('Video capture failed; inspect simulator state.')
        print(path)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (ValueError, RuntimeError, subprocess.SubprocessError, OSError) as error:
        sys.exit(str(error))
