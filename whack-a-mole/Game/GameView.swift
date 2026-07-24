import SwiftUI

struct GameView: View {
    @State private var viewModel: GameViewModel

    init(viewModel: GameViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    init() {
        self._viewModel = State(initialValue: GameViewModel())
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(String(format: "Time: %.1fs", viewModel.elapsedTime))
                    .font(.title3.monospacedDigit())
                Spacer()
                controlButton
            }
            .padding(.horizontal)

            GameBoardView(viewModel: viewModel)
        }
        .padding()
    }

    @ViewBuilder
    private var controlButton: some View {
        switch viewModel.state {
        case .playing:
            Button("Stop") { viewModel.stop() }
                .buttonStyle(.borderedProminent)
        case .idle, .gameOver:
            Button("Start") { viewModel.start() }
                .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    GameView(viewModel: .preview)
}
