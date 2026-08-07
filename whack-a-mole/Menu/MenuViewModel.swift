import Foundation
import Observation

@Observable
@MainActor
final class MenuViewModel {
    private(set) var menu: MenuModel
    let audioManager: AudioManager
    let scoreViewModel: ScoreViewModel

    var isSoundOn: Bool { menu.isSoundOn }
    var highScore: Int { scoreViewModel.highScore }

    init(audioManager: AudioManager, scoreViewModel: ScoreViewModel, userDefaults: UserDefaults = .standard) {
        self.audioManager = audioManager
        self.scoreViewModel = scoreViewModel
        self.menu = MenuModel(isSoundOn: !AudioManager.loadIsMuted(userDefaults: userDefaults))
    }

    func toggleSound() async {
        menu.isSoundOn.toggle()
        await audioManager.setMuted(!menu.isSoundOn)
    }
}

extension MenuViewModel {
    static var preview: MenuViewModel {
        MenuViewModel(audioManager: AudioManager(), scoreViewModel: .preview)
    }
}
