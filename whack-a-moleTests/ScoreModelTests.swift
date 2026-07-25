import XCTest
@testable import whack_a_mole

final class ScoreModelTests: XCTestCase {

    func test_adding_hit_incrementsComboAndAddsPoints() {
        let score = ScoreModel()

        let result = score.adding(hit: true)

        XCTAssertEqual(result.combo, 1)
        XCTAssertEqual(result.points, GameConstants.basePointsPerHit)
    }

    func test_adding_consecutiveHits_multiplyPointsByComboLevel() {
        let score = ScoreModel()

        let afterFirstHit = score.adding(hit: true)
        let afterSecondHit = afterFirstHit.adding(hit: true)

        XCTAssertEqual(afterSecondHit.combo, 2)
        XCTAssertEqual(afterSecondHit.points, GameConstants.basePointsPerHit + GameConstants.basePointsPerHit * 2)
    }

    func test_adding_miss_resetsComboToZero_keepsPoints() {
        let score = ScoreModel(points: 300, combo: 3, highScore: 300)

        let result = score.adding(hit: false)

        XCTAssertEqual(result.combo, 0)
        XCTAssertEqual(result.points, 300)
    }

    func test_adding_hit_updatesHighScore_whenPointsExceedPrevious() {
        let score = ScoreModel(points: 0, combo: 0, highScore: 50)

        let result = score.adding(hit: true)

        XCTAssertEqual(result.highScore, GameConstants.basePointsPerHit)
    }

    func test_adding_hit_keepsHighScore_whenPointsDoNotExceedPrevious() {
        let score = ScoreModel(points: 0, combo: 0, highScore: 1000)

        let result = score.adding(hit: true)

        XCTAssertEqual(result.highScore, 1000)
    }

    func test_adding_miss_keepsHighScore() {
        let score = ScoreModel(points: 300, combo: 3, highScore: 500)

        let result = score.adding(hit: false)

        XCTAssertEqual(result.highScore, 500)
    }
}
