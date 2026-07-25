import XCTest
@testable import whack_a_mole

final class BombViewModelTests: XCTestCase {

    func test_explode_setsIsExplodedToTrue() {
        let viewModel = BombViewModel(bomb: BombModel(position: GridPosition(column: 0, row: 0)))

        viewModel.explode()

        XCTAssertTrue(viewModel.isExploded)
    }

    func test_explode_setsCurrentFrameToFour() {
        let viewModel = BombViewModel(bomb: BombModel(position: GridPosition(column: 0, row: 0)))

        viewModel.explode()

        XCTAssertEqual(viewModel.currentImageName, "Bomb4")
    }
}
