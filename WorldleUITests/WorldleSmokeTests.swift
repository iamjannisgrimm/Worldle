import XCTest

final class WorldleSmokeTests: XCTestCase {
    @MainActor
    func testGuessShowsResultAndCanReplay() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        defer { app.terminate() }

        let heading = app.staticTexts["TODAY'S CITY"]
        XCTAssertTrue(heading.waitForExistence(timeout: 20), "Daily city heading should appear")
        // The existing heading gesture enables replay without deleting app preferences.
        heading.tap()
        let map = app.maps.firstMatch
        XCTAssertTrue(map.waitForExistence(timeout: 15), "The game globe should be available")
        map.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.55)).tap()
        let confirm = app.buttons["Confirm Guess"]
        XCTAssertTrue(confirm.waitForExistence(timeout: 10), "Placing a pin should enable confirmation")
        confirm.tap()

        let share = app.buttons["Share Result"]
        XCTAssertTrue(share.waitForExistence(timeout: 60), "Submitting a guess should show its result")
        let replay = app.buttons["Play Again"]
        XCTAssertTrue(replay.exists, "Testing mode should allow another game")
        attach(app, name: "Guess result")
        replay.tap()
        XCTAssertTrue(share.waitForNonExistence(timeout: 10), "Replay should dismiss the result")
        XCTAssertTrue(heading.exists, "Replay should return to the game")
        XCTAssertFalse(confirm.exists, "Replay should clear the old guess")
        attach(app, name: "Ready for another guess")
    }

    @MainActor
    private func attach(_ app: XCUIApplication, name: String) {
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = name
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }
}
