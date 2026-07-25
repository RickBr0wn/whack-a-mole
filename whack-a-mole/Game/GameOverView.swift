import SwiftUI

struct GameOverView: View {
    let scoreViewModel: ScoreViewModel
    var onRestart: () -> Void = {}

    var body: some View {
        VStack(spacing: 24) {
            Text("Game Over")
                .font(.largeTitle.bold())

            VStack(spacing: 8) {
                Text("Score: \(scoreViewModel.points)")
                    .font(.title2.monospacedDigit())
                Text("Best: \(scoreViewModel.highScore)")
                    .font(.title3.monospacedDigit())
            }

            Button("Restart", action: onRestart)
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .foregroundStyle(.white)
    }
}

#Preview {
    GameOverView(scoreViewModel: .preview)
        .padding()
        .background(Theme.ground)
}
