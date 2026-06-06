import Foundation
import Observation

@Observable
@MainActor
final class GameViewModel {
    private(set) var game: GameModel

    let spawnInterval: TimeInterval
    let bombProbability: Double

    private var spawnTask: Task<Void, Never>?
    private var timerTask: Task<Void, Never>?

    var state: GameState { game.state }
    var moles: [MoleModel] { game.moles }
    var bombs: [BombModel] { game.bombs }
    var elapsedTime: TimeInterval { game.elapsedTime }

    init(
        game: GameModel = GameModel(),
        spawnInterval: TimeInterval = GameConstants.defaultSpawnInterval,
        bombProbability: Double = 0.15
    ) {
        self.game = game
        self.spawnInterval = spawnInterval
        self.bombProbability = bombProbability
    }

    func start() {
        guard state != .playing else { return }
        game = GameModel(state: .playing)
        startSpawnLoop()
        startTimer()
    }

    func stop() {
        spawnTask?.cancel()
        timerTask?.cancel()
        spawnTask = nil
        timerTask = nil
    }

    private func startSpawnLoop() {
        spawnTask?.cancel()
        let interval = spawnInterval
        spawnTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(interval))
                guard let self, self.state == .playing else { return }
                self.spawn()
            }
        }
    }

    private func startTimer() {
        timerTask?.cancel()
        let tickInterval: Duration = .milliseconds(100)
        let tickSeconds: TimeInterval = 0.1
        timerTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: tickInterval)
                guard let self, self.state == .playing else { return }
                self.game.elapsedTime += tickSeconds
            }
        }
    }

    private func spawn() {
        guard let position = pickFreePosition() else { return }
        if Double.random(in: 0..<1) < bombProbability {
            spawnBomb(at: position)
        } else {
            spawnMole(at: position)
        }
    }

    private func pickFreePosition() -> GridPosition? {
        let occupied = Set(game.moles.map(\.position) + game.bombs.map(\.position))
        let allPositions = (0..<GameConstants.gridRows).flatMap { row in
            (0..<GameConstants.gridColumns).map { column in
                GridPosition(column: column, row: row)
            }
        }
        return allPositions.filter { !occupied.contains($0) }.randomElement()
    }

    private func spawnMole(at position: GridPosition) {
        let mole = MoleModel(position: position)
        game.moles.append(mole)
        let id = mole.id
        let duration = mole.visibleDuration
        Task { [weak self] in
            try? await Task.sleep(for: .seconds(duration))
            guard let self else { return }
            self.game.moles.removeAll { $0.id == id }
        }
    }

    private func spawnBomb(at position: GridPosition) {
        let bomb = BombModel(position: position)
        game.bombs.append(bomb)
        let id = bomb.id
        let duration = bomb.visibleDuration
        Task { [weak self] in
            try? await Task.sleep(for: .seconds(duration))
            guard let self else { return }
            self.game.bombs.removeAll { $0.id == id }
        }
    }
}

extension GameViewModel {
    static var preview: GameViewModel {
        let viewModel = GameViewModel()
        viewModel.game = GameModel(
            state: .playing,
            moles: [MoleModel(position: GridPosition(column: 0, row: 0))],
            bombs: [BombModel(position: GridPosition(column: 2, row: 2))],
            elapsedTime: 3.0
        )
        return viewModel
    }
}
