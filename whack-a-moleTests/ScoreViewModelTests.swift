import XCTest
@testable import whack_a_mole

final class ScoreViewModelTests: XCTestCase {

    private var userDefaults: UserDefaults!
    private let suiteName = "ScoreViewModelTests"

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

    func test_init_loadsPersistedHighScore_fromUserDefaults() {
        userDefaults.set(750, forKey: "highScore")

        let viewModel = ScoreViewModel(userDefaults: userDefaults)

        XCTAssertEqual(viewModel.highScore, 750)
    }

    func test_register_hit_incrementsComboAndPoints() {
        let viewModel = ScoreViewModel(userDefaults: userDefaults)

        viewModel.register(hit: true)

        XCTAssertEqual(viewModel.combo, 1)
        XCTAssertEqual(viewModel.points, GameConstants.basePointsPerHit)
    }

    func test_register_miss_resetsCombo() {
        let viewModel = ScoreViewModel(userDefaults: userDefaults)
        viewModel.register(hit: true)

        viewModel.register(hit: false)

        XCTAssertEqual(viewModel.combo, 0)
    }

    func test_register_hit_persistsNewHighScore_toUserDefaults() {
        let viewModel = ScoreViewModel(userDefaults: userDefaults)

        viewModel.register(hit: true)

        XCTAssertEqual(userDefaults.integer(forKey: "highScore"), GameConstants.basePointsPerHit)
    }

    func test_register_hit_withMultiplier_doublesPoints() {
        let viewModel = ScoreViewModel(userDefaults: userDefaults)

        viewModel.register(hit: true, multiplier: 2)

        XCTAssertEqual(viewModel.points, GameConstants.basePointsPerHit * 2)
    }

    func test_register_hit_returnsPointsAwarded() {
        let viewModel = ScoreViewModel(userDefaults: userDefaults)
        viewModel.register(hit: true)

        let awarded = viewModel.register(hit: true, multiplier: 2)

        XCTAssertEqual(awarded, GameConstants.basePointsPerHit * 2 * 2)
    }

    func test_register_miss_returnsZeroPointsAwarded() {
        let viewModel = ScoreViewModel(userDefaults: userDefaults)

        let awarded = viewModel.register(hit: false)

        XCTAssertEqual(awarded, 0)
    }

    func test_reset_zeroesPointsAndCombo_keepsHighScore() {
        let viewModel = ScoreViewModel(userDefaults: userDefaults)
        viewModel.register(hit: true)
        viewModel.register(hit: true)
        let highScoreBeforeReset = viewModel.highScore

        viewModel.reset()

        XCTAssertEqual(viewModel.points, 0)
        XCTAssertEqual(viewModel.combo, 0)
        XCTAssertEqual(viewModel.highScore, highScoreBeforeReset)
    }
}
