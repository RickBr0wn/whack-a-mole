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

    func test_whack_marksMoleAsHitImmediately() {
        let viewModel = GameViewModel()
        viewModel.spawnMole(at: GridPosition(column: 0, row: 0))
        defer { viewModel.stop() }

        guard let mole = viewModel.moles.first else {
            return XCTFail("Expected a spawned mole")
        }

        viewModel.whack(mole: mole)

        XCTAssertTrue(viewModel.moles.first?.isHit ?? false)
        XCTAssertTrue(viewModel.moleViewModel(for: mole).isHit)
    }

    func test_whack_doesNothing_forUnknownMole() {
        let viewModel = GameViewModel()
        defer { viewModel.stop() }
        let unknownMole = MoleModel(position: GridPosition(column: 2, row: 2))

        viewModel.whack(mole: unknownMole)

        XCTAssertTrue(viewModel.moles.isEmpty)
    }

    func test_whack_removesMole_afterHitDisplayDuration() async {
        let viewModel = GameViewModel()
        viewModel.spawnMole(at: GridPosition(column: 0, row: 0))
        defer { viewModel.stop() }

        guard let mole = viewModel.moles.first else {
            return XCTFail("Expected a spawned mole")
        }

        viewModel.whack(mole: mole)
        try? await Task.sleep(for: .seconds(GameConstants.moleHitDisplayDuration + 0.2))

        XCTAssertTrue(viewModel.moles.isEmpty)
    }

    func test_triggerBomb_marksBombAsExplodedAndEndsGame() {
        let viewModel = GameViewModel()
        viewModel.spawnBomb(at: GridPosition(column: 0, row: 0))
        defer { viewModel.stop() }

        guard let bomb = viewModel.bombs.first else {
            return XCTFail("Expected a spawned bomb")
        }

        viewModel.triggerBomb(bomb: bomb)

        XCTAssertTrue(viewModel.bombs.first?.isExploded ?? false)
        XCTAssertTrue(viewModel.bombViewModel(for: bomb).isExploded)
        XCTAssertEqual(viewModel.state, .gameOver)
    }

    func test_triggerBomb_doesNothing_forUnknownBomb() {
        let viewModel = GameViewModel(game: GameModel(state: .playing))
        defer { viewModel.stop() }
        let unknownBomb = BombModel(position: GridPosition(column: 2, row: 2))

        viewModel.triggerBomb(bomb: unknownBomb)

        XCTAssertEqual(viewModel.state, .playing)
    }

    func test_triggerBomb_doesNothing_ifAlreadyExploded() {
        let explodedBomb = BombModel(position: GridPosition(column: 0, row: 0), isExploded: true)
        let viewModel = GameViewModel(game: GameModel(state: .gameOver, bombs: [explodedBomb]))
        defer { viewModel.stop() }

        viewModel.triggerBomb(bomb: explodedBomb)

        XCTAssertEqual(viewModel.state, .gameOver)
    }
}
