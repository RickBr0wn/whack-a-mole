import Foundation
import Observation

@Observable
@MainActor
final class LoadingViewModel {
    private(set) var loading: LoadingModel

    private let duration: TimeInterval
    private let tickInterval: TimeInterval

    var progress: Double { loading.progress }
    var isComplete: Bool { loading.isComplete }

    init(duration: TimeInterval = GameConstants.loadingScreenDuration, tickInterval: TimeInterval = 0.05) {
        self.duration = duration
        self.tickInterval = tickInterval
        self.loading = LoadingModel()
    }

    func start() async {
        let delta = tickInterval / duration
        while !loading.isComplete {
            try? await Task.sleep(for: .seconds(tickInterval))
            loading = loading.advancing(by: delta)
        }
    }
}

extension LoadingViewModel {
    static var preview: LoadingViewModel {
        let viewModel = LoadingViewModel()
        viewModel.loading = LoadingModel(progress: 0.45)
        return viewModel
    }
}
