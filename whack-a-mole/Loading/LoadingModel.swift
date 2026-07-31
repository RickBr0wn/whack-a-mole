import Foundation

struct LoadingModel: Sendable {
    var progress: Double

    init(progress: Double = 0) {
        self.progress = progress
    }

    var isComplete: Bool { progress >= 1 }

    func advancing(by delta: Double) -> LoadingModel {
        LoadingModel(progress: min(1, progress + delta))
    }
}
