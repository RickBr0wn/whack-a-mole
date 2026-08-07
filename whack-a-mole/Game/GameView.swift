import SwiftUI

struct GameView: View {
    @State private var viewModel: GameViewModel
    var onExitToMenu: () -> Void = {}

    init(viewModel: GameViewModel, onExitToMenu: @escaping () -> Void = {}) {
        self._viewModel = State(initialValue: viewModel)
        self.onExitToMenu = onExitToMenu
    }

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                HStack {
                    Text(String(format: "Time: %.1fs", viewModel.elapsedTime))
                        .font(.title3.monospacedDigit())
                    Spacer()
                    Button("Menu") {
                        viewModel.stop()
                        onExitToMenu()
                    }
                    .buttonStyle(.bordered)
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

                GameOverView(
                    scoreViewModel: viewModel.scoreViewModel,
                    onRestart: { viewModel.restart() },
                    onMainMenu: onExitToMenu
                )
            }
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
