import Foundation
import Observation

@Observable
final class ScoreViewModel {
    private static let highScoreKey = "highScore"

    private(set) var score: ScoreModel

    private let userDefaults: UserDefaults

    var points: Int { score.points }
    var combo: Int { score.combo }
    var highScore: Int { score.highScore }

    init(score: ScoreModel = ScoreModel(), userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        let persistedHighScore = userDefaults.integer(forKey: Self.highScoreKey)
        self.score = ScoreModel(
            points: score.points,
            combo: score.combo,
            highScore: max(score.highScore, persistedHighScore)
        )
    }

    @discardableResult
    func register(hit: Bool, multiplier: Int = 1) -> Int {
        let previousPoints = score.points
        score = score.adding(hit: hit, multiplier: multiplier)
        userDefaults.set(score.highScore, forKey: Self.highScoreKey)
        return score.points - previousPoints
    }

    func reset() {
        score = ScoreModel(points: 0, combo: 0, highScore: score.highScore)
    }
}

extension ScoreViewModel {
    static var preview: ScoreViewModel {
        ScoreViewModel(score: ScoreModel(points: 450, combo: 3, highScore: 800))
    }
}
