import SwiftUI

struct ResultSheet: View {
    let distance: Double
    let score: Int
    let cityName: String
    let scoreCategory: ScoreCategory
    let viewModel: GameViewModel
    @State private var showingShareSheet = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header with score category
                VStack(spacing: 12) {
                    Text(scoreCategory.title)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(scoreCategory.color)
                    
                    Text(scoreCategory.description)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // Visual target display
                TargetView(scoreCategory: scoreCategory)
                    .padding(.vertical, 20)
                
                
                // Share button
                Button(action: {
                    showingShareSheet = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title2)
                        Text("Share Result")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .blue.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
                }
                .padding(.vertical, 8)
                
                Spacer()
                
                // Testing mode controls or come back tomorrow message
                if viewModel.isTestingMode {
                    Button(action: {
                        viewModel.resetGame()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.clockwise")
                                .font(.title2)
                            Text("Play Again")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [.green, .green.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
                        )
                    }
                    .padding(.bottom, 40)
                } else {
                    VStack(spacing: 8) {
                        Text("🌅 See you tomorrow!")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        Text("A new city awaits")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                    )
                    .padding(.bottom, 40)
                }
            }
            .padding(.horizontal, 24)
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: [createShareText()])
        }
    }
    
    private func createShareText() -> String {
        let dateString = DateFormatter.shareDate.string(from: Date())
        let targetEmoji = createTargetVisualization()
        
        return """
        🌍 \(Constants.Sharing.appName) \(dateString)
        
        \(targetEmoji)
        """
    }
    
    private func createTargetVisualization() -> String {
        // Create a simple symmetric target with 4 layers
        switch scoreCategory {
        case .perfect:
            return """
            ⚫⚫⚫⚫⚫⚫⚫
            ⚫⚪⚪⚪⚪⚪⚫
            ⚫⚪⚪⚪⚪⚪⚫
            ⚫⚪⚪🔴⚪⚪⚫
            ⚫⚪⚪⚪⚪⚪⚫
            ⚫⚪⚪⚪⚪⚪⚫
            ⚫⚫⚫⚫⚫⚫⚫
            """
            
        case .excellent:
            return """
            ⚫⚫⚫⚫⚫⚫⚫
            ⚫⚪⚪⚪⚪⚪⚫
            ⚫⚪🔴🔴🔴⚪⚫
            ⚫⚪🔴⚪🔴⚪⚫
            ⚫⚪🔴🔴🔴⚪⚫
            ⚫⚪⚪⚪⚪⚪⚫
            ⚫⚫⚫⚫⚫⚫⚫
            """
            
        case .sameCountry:
            return """
            ⚫⚫⚫⚫⚫⚫⚫
            ⚫🔴🔴🔴🔴🔴⚫
            ⚫🔴⚪⚪⚪🔴⚫
            ⚫🔴⚪⚪⚪🔴⚫
            ⚫🔴⚪⚪⚪🔴⚫
            ⚫🔴🔴🔴🔴🔴⚫
            ⚫⚫⚫⚫⚫⚫⚫
            """
            
        case .sameContinent:
            return """
            🔴🔴🔴🔴🔴🔴🔴
            🔴⚪⚪⚪⚪⚪🔴
            🔴⚪⚪⚪⚪⚪🔴
            🔴⚪⚪⚪⚪⚪🔴
            🔴⚪⚪⚪⚪⚪🔴
            🔴⚪⚪⚪⚪⚪🔴
            🔴🔴🔴🔴🔴🔴🔴
            """
            
        case .miss:
            return """
            ⚫⚫⚫⚫⚫⚫⚫
            ⚫⚪⚪⚪⚪⚪⚫
            ⚫⚪⚪⚪⚪⚪⚫
            ⚫⚪⚪⚪⚪⚪⚫
            ⚫⚪⚪⚪⚪⚪⚫
            ⚫⚪⚪⚪⚪⚪⚫
            ⚫⚫⚫⚫⚫⚫⚫
            
            🔴 Miss
            """
        }
    }
}

#if canImport(UIKit)
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#else

struct ShareSheet: View {
    let activityItems: [Any]
    
    var body: some View {
        Text("Sharing not available on this platform")
            .padding()
    }
}

#endif