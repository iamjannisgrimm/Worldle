import SwiftUI

struct TargetView: View {
    let scoreCategory: ScoreCategory
    @State private var animateRings = false
    @State private var showPin = false
    
    var body: some View {
        ZStack {
            // Target rings from outside to inside
            ForEach(Array([ScoreCategory.miss, .sameContinent, .sameCountry, .excellent, .perfect].enumerated()), id: \.offset) { index, category in
                Circle()
                    .stroke(category.color.opacity(0.3), lineWidth: 2)
                    .fill(category.color.opacity(scoreCategory == category ? 0.3 : 0.1))
                    .frame(width: ringSize(for: category), height: ringSize(for: category))
                    .scaleEffect(animateRings ? 1.0 : 0.0)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.7)
                        .delay(Double(index) * 0.1),
                        value: animateRings
                    )
                
                // Category labels
                Text(category.description)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(category.color)
                    .offset(y: -ringSize(for: category) / 2 - 10)
                    .opacity(animateRings ? 1.0 : 0.0)
                    .animation(
                        .easeInOut(duration: 0.5)
                        .delay(Double(index) * 0.1 + 0.3),
                        value: animateRings
                    )
            }
            
            // Center bullseye
            Circle()
                .fill(ScoreCategory.perfect.color)
                .frame(width: 20, height: 20)
                .scaleEffect(animateRings ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: animateRings)
            
            // Pin marker showing where user hit
            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundColor(scoreCategory.color)
                .scaleEffect(showPin ? 1.2 : 0.0)
                .offset(pinOffset(for: scoreCategory))
                .animation(
                    .spring(response: 0.5, dampingFraction: 0.6)
                    .delay(0.8),
                    value: showPin
                )
        }
        .frame(width: 300, height: 300)
        .onAppear {
            animateRings = true
            showPin = true
        }
    }
    
    private func ringSize(for category: ScoreCategory) -> CGFloat {
        switch category {
        case .perfect:
            return 60
        case .excellent:
            return 120
        case .sameCountry:
            return 180
        case .sameContinent:
            return 240
        case .miss:
            return 300
        }
    }
    
    private func pinOffset(for category: ScoreCategory) -> CGSize {
        let distance = ringSize(for: category) / 2 - 10
        let angle = Double.random(in: 0...(2 * .pi))
        
        return CGSize(
            width: Foundation.cos(angle) * distance,
            height: Foundation.sin(angle) * distance
        )
    }
}