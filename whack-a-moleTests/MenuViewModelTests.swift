import XCTest
@testable import whack_a_mole

@MainActor
final class MenuViewModelTests: XCTestCase {

    private var userDefaults: UserDefaults!
    private let suiteName = "MenuViewModelTests"

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: suiteName)
        userDefaults.removePersistentDomain(forName: suiteName)
    }

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: suiteName)
        userDefaults = nil
        super.tearDown()
    }

    func test_init_defaultsToSoundOn() {
        let viewModel = MenuViewModel(
            audioManager: AudioManager(userDefaults: userDefaults),
            scoreViewModel: ScoreViewModel(userDefaults: userDefaults),
            userDefaults: userDefaults
        )

        XCTAssertTrue(viewModel.isSoundOn)
    }

    func test_init_reflectsHighScore_fromScoreViewModel() {
        userDefaults.set(650, forKey: "highScore")
        let viewModel = MenuViewModel(
            audioManager: AudioManager(userDefaults: userDefaults),
            scoreViewModel: ScoreViewModel(userDefaults: userDefaults),
            userDefaults: userDefaults
        )

        XCTAssertEqual(viewModel.highScore, 650)
    }

    func test_toggleSound_flipsIsSoundOn() async {
        let viewModel = MenuViewModel(
            audioManager: AudioManager(userDefaults: userDefaults),
            scoreViewModel: ScoreViewModel(userDefaults: userDefaults),
            userDefaults: userDefaults
        )

        await viewModel.toggleSound()

        XCTAssertFalse(viewModel.isSoundOn)
    }

    func test_toggleSound_mutesAudioManager() async {
        let audioManager = AudioManager(userDefaults: userDefaults)
        let viewModel = MenuViewModel(
            audioManager: audioManager,
            scoreViewModel: ScoreViewModel(userDefaults: userDefaults),
            userDefaults: userDefaults
        )

        await viewModel.toggleSound()

        XCTAssertTrue(AudioManager.loadIsMuted(userDefaults: userDefaults))
    }

    func test_toggleSound_twice_unmutesAudioManager() async {
        let audioManager = AudioManager(userDefaults: userDefaults)
        let viewModel = MenuViewModel(
            audioManager: audioManager,
            scoreViewModel: ScoreViewModel(userDefaults: userDefaults),
            userDefaults: userDefaults
        )

        await viewModel.toggleSound()
        await viewModel.toggleSound()

        XCTAssertTrue(viewModel.isSoundOn)
        XCTAssertFalse(AudioManager.loadIsMuted(userDefaults: userDefaults))
    }
}
