import Foundation

struct HoleModel: Identifiable, Hashable, Sendable {
    let id: UUID
    let position: GridPosition

    init(id: UUID = UUID(), position: GridPosition) {
        self.id = id
        self.position = position
    }
}
