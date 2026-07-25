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
        ZStack {
            VStack(spacing: 16) {
                HStack {
                    Text(String(format: "Time: %.1fs", viewModel.elapsedTime))
                        .font(.title3.monospacedDigit())
                    Spacer()
                    controlButton
                }
                .padding(.horizontal)

                ScoreView(viewModel: viewModel.scoreViewModel)

                GameBoardView(viewModel: viewModel)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.ground.ignoresSafeArea())

            if viewModel.state == .gameOver {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()

                GameOverView(scoreViewModel: viewModel.scoreViewModel) {
                    viewModel.restart()
                }
            }
        }
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

#Preview("Game over") {
    let viewModel = GameViewModel(
        game: GameModel(
            state: .gameOver,
            bombs: [BombModel(position: GridPosition(column: 1, row: 1), isExploded: true)],
            elapsedTime: 18.4
        ),
        scoreViewModel: .preview
    )
    return GameView(viewModel: viewModel)
}
