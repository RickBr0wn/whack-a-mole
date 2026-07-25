import SwiftUI

struct GameView: View {
    @State private var viewModel: GameViewModel
    @State private var scoreViewModel: ScoreViewModel

    init(viewModel: GameViewModel, scoreViewModel: ScoreViewModel = ScoreViewModel()) {
        self._viewModel = State(initialValue: viewModel)
        self._scoreViewModel = State(initialValue: scoreViewModel)
    }

    init() {
        self._viewModel = State(initialValue: GameViewModel())
        self._scoreViewModel = State(initialValue: ScoreViewModel())
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

            ScoreView(viewModel: scoreViewModel)

            GameBoardView(viewModel: viewModel)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.ground.ignoresSafeArea())
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
    GameView(viewModel: .preview, scoreViewModel: .preview)
}
