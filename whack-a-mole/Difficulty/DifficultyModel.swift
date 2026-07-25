import Foundation

struct DifficultyModel: Equatable, Sendable {
    var level: Int
    var spawnInterval: TimeInterval
    var visibleDuration: TimeInterval

    init(
        level: Int = 1,
        spawnInterval: TimeInterval = GameConstants.defaultSpawnInterval,
        visibleDuration: TimeInterval = GameConstants.defaultMoleVisibleDuration
    ) {
        self.level = level
        self.spawnInterval = spawnInterval
        self.visibleDuration = visibleDuration
    }

    func nextLevel() -> DifficultyModel {
        DifficultyModel(
            level: level + 1,
            spawnInterval: max(
                GameConstants.minimumSpawnInterval,
                spawnInterval * GameConstants.difficultyDecayFactor
            ),
            visibleDuration: max(
                GameConstants.minimumMoleVisibleDuration,
                visibleDuration * GameConstants.difficultyDecayFactor
            )
        )
    }
}
