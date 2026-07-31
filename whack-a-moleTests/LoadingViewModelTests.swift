import XCTest
@testable import whack_a_mole

@MainActor
final class LoadingViewModelTests: XCTestCase {

    func test_init_progressStartsAtZero() {
        let viewModel = LoadingViewModel(duration: 1, tickInterval: 0.05)

        XCTAssertEqual(viewModel.progress, 0)
        XCTAssertFalse(viewModel.isComplete)
    }

    func test_start_progressReachesComplete_afterDuration() async {
        let viewModel = LoadingViewModel(duration: 0.2, tickInterval: 0.05)

        await viewModel.start()

        XCTAssertTrue(viewModel.isComplete)
        XCTAssertEqual(viewModel.progress, 1)
    }
}
