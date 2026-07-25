import XCTest
@testable import whack_a_mole

final class DifficultyModelTests: XCTestCase {

    func test_nextLevel_incrementsLevel() {
        let difficulty = DifficultyModel()

        let result = difficulty.nextLevel()

        XCTAssertEqual(result.level, 2)
    }

    func test_nextLevel_shortensSpawnIntervalByDecayFactor() {
        let difficulty = DifficultyModel(spawnInterval: 1.0)

        let result = difficulty.nextLevel()

        XCTAssertEqual(result.spawnInterval, 1.0 * GameConstants.difficultyDecayFactor, accuracy: 0.0001)
    }

    func test_nextLevel_shortensVisibleDurationByDecayFactor() {
        let difficulty = DifficultyModel(visibleDuration: 1.5)

        let result = difficulty.nextLevel()

        XCTAssertEqual(result.visibleDuration, 1.5 * GameConstants.difficultyDecayFactor, accuracy: 0.0001)
    }

    func test_nextLevel_clampsSpawnInterval_toMinimum() {
        let difficulty = DifficultyModel(spawnInterval: GameConstants.minimumSpawnInterval)

        let result = difficulty.nextLevel()

        XCTAssertEqual(result.spawnInterval, GameConstants.minimumSpawnInterval)
    }

    func test_nextLevel_clampsVisibleDuration_toMinimum() {
        let difficulty = DifficultyModel(visibleDuration: GameConstants.minimumMoleVisibleDuration)

        let result = difficulty.nextLevel()

        XCTAssertEqual(result.visibleDuration, GameConstants.minimumMoleVisibleDuration)
    }
}
