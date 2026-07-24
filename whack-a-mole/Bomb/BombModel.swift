import Foundation

struct BombModel: Identifiable, Hashable, Sendable {
    let id: UUID
    let position: GridPosition
    var isExploded: Bool
    let visibleDuration: TimeInterval

    init(
        id: UUID = UUID(),
        position: GridPosition,
        isExploded: Bool = false,
        visibleDuration: TimeInterval = GameConstants.defaultBombVisibleDuration
    ) {
        self.id = id
        self.position = position
        self.isExploded = isExploded
        self.visibleDuration = visibleDuration
    }
}
