import SwiftUI

struct ScoreView: View {
    let viewModel: ScoreViewModel

    var body: some View {
        HStack(spacing: 16) {
            Text("Score: \(viewModel.points)")
                .font(.title3.monospacedDigit())

            if viewModel.combo > 1 {
                Text("×\(viewModel.combo)")
                    .font(.title3.monospacedDigit())
                    .foregroundStyle(.yellow)
            }

            Text("Best: \(viewModel.highScore)")
                .font(.title3.monospacedDigit())
        }
    }
}

#Preview {
    ScoreView(viewModel: .preview)
        .padding()
        .background(Theme.ground)
}
