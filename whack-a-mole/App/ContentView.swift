import SwiftUI

struct ContentView: View {
    @State private var loadingViewModel = LoadingViewModel()
    @State private var screen: AppScreen = .loading

    @State private var audioManager = AudioManager()
    @State private var scoreViewModel = ScoreViewModel()
    @State private var menuViewModel: MenuViewModel?
    @State private var gameViewModel: GameViewModel?

    var body: some View {
        switch screen {
        case .loading:
            LoadingView(viewModel: loadingViewModel)
                .task {
                    await loadingViewModel.start()
                    menuViewModel = MenuViewModel(audioManager: audioManager, scoreViewModel: scoreViewModel)
                    screen = .menu
                }
        case .menu:
            if let menuViewModel {
                MenuView(viewModel: menuViewModel) {
                    let viewModel = GameViewModel(scoreViewModel: scoreViewModel, audioManager: audioManager)
                    viewModel.start()
                    gameViewModel = viewModel
                    screen = .game
                }
            }
        case .game:
            if let gameViewModel {
                GameView(viewModel: gameViewModel) {
                    screen = .menu
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
