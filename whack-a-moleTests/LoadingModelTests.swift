import XCTest
@testable import whack_a_mole

final class LoadingModelTests: XCTestCase {

    func test_advancing_increasesProgressByDelta() {
        let model = LoadingModel(progress: 0.2)

        let advanced = model.advancing(by: 0.3)

        XCTAssertEqual(advanced.progress, 0.5, accuracy: 0.0001)
    }

    func test_advancing_clampsProgressToOne() {
        let model = LoadingModel(progress: 0.9)

        let advanced = model.advancing(by: 0.5)

        XCTAssertEqual(advanced.progress, 1)
    }

    func test_isComplete_isFalse_belowOne() {
        let model = LoadingModel(progress: 0.99)

        XCTAssertFalse(model.isComplete)
    }

    func test_isComplete_isTrue_atOne() {
        let model = LoadingModel(progress: 1)

        XCTAssertTrue(model.isComplete)
    }
}
