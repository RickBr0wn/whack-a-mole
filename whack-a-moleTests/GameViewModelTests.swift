import XCTest
@testable import whack_a_mole

@MainActor
final class GameViewModelTests: XCTestCase {

    func test_start_transitionsStateToPlaying() {
        let viewModel = GameViewModel()

        viewModel.start()
        defer { viewModel.stop() }

        XCTAssertEqual(viewModel.state, .playing)
    }

    func test_start_doesNothing_whenAlreadyPlaying() {
        let existingMole = MoleModel(position: GridPosition(column: 0, row: 0))
        let viewModel = GameViewModel(game: GameModel(state: .playing, moles: [existingMole]))

        viewModel.start()
        defer { viewModel.stop() }

        XCTAssertEqual(viewModel.moles, [existingMole])
    }

    func test_stop_resetsStateToIdle() {
        let viewModel = GameViewModel(game: GameModel(state: .playing))

        viewModel.stop()

        XCTAssertEqual(viewModel.state, .idle)
    }

    func test_stop_clearsMolesAndBombs() {
        let mole = MoleModel(position: GridPosition(column: 0, row: 0))
        let bomb = BombModel(position: GridPosition(column: 1, row: 1))
        let viewModel = GameViewModel(game: GameModel(state: .playing, moles: [mole], bombs: [bomb]))

        viewModel.stop()

        XCTAssertTrue(viewModel.moles.isEmpty)
        XCTAssertTrue(viewModel.bombs.isEmpty)
    }

    func test_moleViewModel_returnsSameCachedInstance_forSpawnedMole() {
        let viewModel = GameViewModel()
        viewModel.spawnMole(at: GridPosition(column: 0, row: 0))
        defer { viewModel.stop() }

        guard let mole = viewModel.moles.first else {
            return XCTFail("Expected a spawned mole")
        }

        XCTAssertTrue(viewModel.moleViewModel(for: mole) === viewModel.moleViewModel(for: mole))
    }

    func test_bombViewModel_returnsSameCachedInstance_forSpawnedBomb() {
        let viewModel = GameViewModel()
        viewModel.spawnBomb(at: GridPosition(column: 1, row: 1))
        defer { viewModel.stop() }

        guard let bomb = viewModel.bombs.first else {
            return XCTFail("Expected a spawned bomb")
        }

        XCTAssertTrue(viewModel.bombViewModel(for: bomb) === viewModel.bombViewModel(for: bomb))
    }
}
