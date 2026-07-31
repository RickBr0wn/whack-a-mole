import Foundation

struct GameModel: Sendable {
    var state: GameState
    var moles: [MoleModel]
    var bombs: [BombModel]
    var elapsedTime: TimeInterval

    init(
        state: GameState = .idle,
        moles: [MoleModel] = [],
        bombs: [BombModel] = [],
        elapsedTime: TimeInterval = 0
    ) {
        self.state = state
        self.moles = moles
        self.bombs = bombs
        self.elapsedTime = elapsedTime
    }
}

struct ScorePopEvent: Identifiable, Equatable, Sendable {
    let id = UUID()
    let position: GridPosition
    let points: Int
}
