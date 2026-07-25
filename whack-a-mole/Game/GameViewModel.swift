import Foundation
import Observation

@Observable
@MainActor
final class GameViewModel {
    private(set) var game: GameModel
    private(set) var difficulty: DifficultyModel = DifficultyModel()
    let scoreViewModel: ScoreViewModel

    let spawnInterval: TimeInterval
    let bombProbability: Double
    let hatMoleProbability: Double

    private var spawnTask: Task<Void, Never>?
    private var timerTask: Task<Void, Never>?

    @ObservationIgnored
    private var nextLevelUpTime: TimeInterval = GameConstants.levelUpInterval

    @ObservationIgnored
    private var moleViewModels: [UUID: MoleViewModel] = [:]

    @ObservationIgnored
    private var bombViewModels: [UUID: BombViewModel] = [:]

    @ObservationIgnored
    private var moleDespawnTasks: [UUID: Task<Void, Never>] = [:]

    @ObservationIgnored
    private var bombDespawnTasks: [UUID: Task<Void, Never>] = [:]

    var state: GameState { game.state }
    var moles: [MoleModel] { game.moles }
    var bombs: [BombModel] { game.bombs }
    var elapsedTime: TimeInterval { game.elapsedTime }
    var level: Int { difficulty.level }

    var effectiveBombProbability: Double {
        min(
            GameConstants.maxBombProbability,
            bombProbability + Double(difficulty.level - 1) * GameConstants.bombProbabilityIncreasePerLevel
        )
    }

    init(
        game: GameModel? = nil,
        scoreViewModel: ScoreViewModel = ScoreViewModel(),
        spawnInterval: TimeInterval = GameConstants.defaultSpawnInterval,
        bombProbability: Double = 0.15,
        hatMoleProbability: Double = 0.2
    ) {
        self.game = game ?? GameModel()
        self.scoreViewModel = scoreViewModel
        self.spawnInterval = spawnInterval
        self.bombProbability = bombProbability
        self.hatMoleProbability = hatMoleProbability
    }

    func start() {
        guard state != .playing else { return }
        game = GameModel(state: .playing)
        difficulty = DifficultyModel(spawnInterval: spawnInterval)
        nextLevelUpTime = GameConstants.levelUpInterval
        startSpawnLoop()
        startTimer()
    }

    func stop() {
        spawnTask?.cancel()
        timerTask?.cancel()
        spawnTask = nil
        timerTask = nil

        moleDespawnTasks.values.forEach { $0.cancel() }
        bombDespawnTasks.values.forEach { $0.cancel() }
        moleDespawnTasks.removeAll()
        bombDespawnTasks.removeAll()

        moleViewModels.removeAll()
        bombViewModels.removeAll()

        game.state = .idle
        game.moles.removeAll()
        game.bombs.removeAll()

        difficulty = DifficultyModel(spawnInterval: spawnInterval)
        nextLevelUpTime = GameConstants.levelUpInterval
    }

    func restart() {
        stop()
        scoreViewModel.reset()
        start()
    }

    func moleViewModel(for mole: MoleModel) -> MoleViewModel {
        moleViewModels[mole.id] ?? MoleViewModel(mole: mole)
    }

    func bombViewModel(for bomb: BombModel) -> BombViewModel {
        bombViewModels[bomb.id] ?? BombViewModel(bomb: bomb)
    }

    private func startSpawnLoop() {
        spawnTask?.cancel()
        spawnTask = Task { [weak self] in
            while !Task.isCancelled {
                guard let self else { return }
                try? await Task.sleep(for: .seconds(self.difficulty.spawnInterval))
                guard !Task.isCancelled else { return }
                guard self.state == .playing else { return }
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
                guard !Task.isCancelled else { return }
                guard let self, self.state == .playing else { return }
                self.tick(by: tickSeconds)
            }
        }
    }

    func tick(by seconds: TimeInterval) {
        game.elapsedTime += seconds
        if game.elapsedTime >= nextLevelUpTime {
            difficulty = difficulty.nextLevel()
            nextLevelUpTime += GameConstants.levelUpInterval
        }
    }

    private func spawn() {
        guard let position = pickFreePosition() else { return }
        if Double.random(in: 0..<1) < effectiveBombProbability {
            spawnBomb(at: position)
        } else {
            let wearsHat = Double.random(in: 0..<1) < hatMoleProbability
            spawnMole(at: position, wearsHat: wearsHat)
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

    private func scheduleDespawn(after duration: TimeInterval, onFire: @escaping () -> Void) -> Task<Void, Never> {
        Task {
            try? await Task.sleep(for: .seconds(duration))
            guard !Task.isCancelled else { return }
            onFire()
        }
    }

    func spawnMole(at position: GridPosition, wearsHat: Bool = false) {
        let mole = MoleModel(position: position, wearsHat: wearsHat, visibleDuration: difficulty.visibleDuration)
        game.moles.append(mole)
        let id = mole.id
        moleViewModels[id] = MoleViewModel(mole: mole)
        moleDespawnTasks[id] = scheduleDespawn(after: mole.visibleDuration) { [weak self] in
            guard let self else { return }
            self.game.moles.removeAll { $0.id == id }
            self.moleViewModels[id] = nil
            self.moleDespawnTasks[id] = nil
            self.scoreViewModel.register(hit: false)
        }
    }

    func handleTap(at position: GridPosition) {
        if let mole = game.moles.first(where: { $0.position == position }) {
            whack(mole: mole)
        } else if let bomb = game.bombs.first(where: { $0.position == position }) {
            triggerBomb(bomb: bomb)
        } else {
            scoreViewModel.register(hit: false)
        }
    }

    func whack(mole: MoleModel) {
        guard let index = game.moles.firstIndex(where: { $0.id == mole.id }), !game.moles[index].isHit else {
            return
        }

        let id = mole.id

        if game.moles[index].wearsHat, !game.moles[index].isCracked {
            game.moles[index].isCracked = true
            moleViewModels[id]?.markCracked()
            return
        }

        moleDespawnTasks[id]?.cancel()

        game.moles[index].isHit = true
        moleViewModels[id]?.markHit()
        scoreViewModel.register(hit: true, multiplier: game.moles[index].wearsHat ? 2 : 1)

        moleDespawnTasks[id] = scheduleDespawn(after: GameConstants.moleHitDisplayDuration) { [weak self] in
            guard let self else { return }
            self.game.moles.removeAll { $0.id == id }
            self.moleViewModels[id] = nil
            self.moleDespawnTasks[id] = nil
        }
    }

    func triggerBomb(bomb: BombModel) {
        guard let index = game.bombs.firstIndex(where: { $0.id == bomb.id }), !game.bombs[index].isExploded else {
            return
        }

        let id = bomb.id
        bombDespawnTasks[id]?.cancel()
        bombDespawnTasks[id] = nil

        game.bombs[index].isExploded = true
        bombViewModels[id]?.explode()

        spawnTask?.cancel()
        timerTask?.cancel()
        spawnTask = nil
        timerTask = nil

        game.state = .gameOver
    }

    func spawnBomb(at position: GridPosition) {
        let bomb = BombModel(position: position)
        game.bombs.append(bomb)
        let id = bomb.id
        bombViewModels[id] = BombViewModel(bomb: bomb)
        bombDespawnTasks[id] = scheduleDespawn(after: bomb.visibleDuration) { [weak self] in
            guard let self else { return }
            self.game.bombs.removeAll { $0.id == id }
            self.bombViewModels[id] = nil
            self.bombDespawnTasks[id] = nil
        }
    }
}

extension GameViewModel {
    static var preview: GameViewModel {
        let viewModel = GameViewModel(scoreViewModel: .preview)
        viewModel.game = GameModel(
            state: .playing,
            moles: [MoleModel(position: GridPosition(column: 0, row: 0))],
            bombs: [BombModel(position: GridPosition(column: 2, row: 2))],
            elapsedTime: 3.0
        )
        return viewModel
    }
}
