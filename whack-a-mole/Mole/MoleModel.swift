import Foundation

struct MoleModel: Identifiable, Hashable, Sendable {
    let id: UUID
    let position: GridPosition
    var isHit: Bool
    var isCracked: Bool
    let wearsHat: Bool
    let visibleDuration: TimeInterval

    init(
        id: UUID = UUID(),
        position: GridPosition,
        isHit: Bool = false,
        isCracked: Bool = false,
        wearsHat: Bool = false,
        visibleDuration: TimeInterval = GameConstants.defaultMoleVisibleDuration
    ) {
        self.id = id
        self.position = position
        self.isHit = isHit
        self.isCracked = isCracked
        self.wearsHat = wearsHat
        self.visibleDuration = visibleDuration
    }
}
