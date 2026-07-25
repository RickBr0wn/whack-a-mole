import Foundation

struct ScoreModel: Equatable, Sendable {
    var points: Int
    var combo: Int
    var highScore: Int

    init(points: Int = 0, combo: Int = 0, highScore: Int = 0) {
        self.points = points
        self.combo = combo
        self.highScore = highScore
    }

    func adding(hit: Bool, multiplier: Int = 1) -> ScoreModel {
        guard hit else {
            return ScoreModel(points: points, combo: 0, highScore: highScore)
        }

        let newCombo = combo + 1
        let newPoints = points + GameConstants.basePointsPerHit * newCombo * multiplier
        return ScoreModel(points: newPoints, combo: newCombo, highScore: max(highScore, newPoints))
    }
}
