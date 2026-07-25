import XCTest
@testable import whack_a_mole

final class MoleViewModelTests: XCTestCase {

    func test_markHit_setsIsHitToTrue() {
        let viewModel = MoleViewModel(mole: MoleModel(position: GridPosition(column: 0, row: 0)))

        viewModel.markHit()

        XCTAssertTrue(viewModel.isHit)
    }
}
