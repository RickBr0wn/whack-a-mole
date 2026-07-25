import Foundation

enum GameConstants {
    nonisolated static let gridColumns: Int = 3
    nonisolated static let gridRows: Int = 3

    nonisolated static let defaultMoleVisibleDuration: TimeInterval = 1.5
    nonisolated static let defaultBombVisibleDuration: TimeInterval = 2.0
    nonisolated static let defaultSpawnInterval: TimeInterval = 1.0
    nonisolated static let moleHitDisplayDuration: TimeInterval = 0.3

    nonisolated static let basePointsPerHit: Int = 100

    nonisolated static let difficultyDecayFactor: Double = 0.9
    nonisolated static let minimumSpawnInterval: TimeInterval = 0.3
    nonisolated static let minimumMoleVisibleDuration: TimeInterval = 0.5
}
