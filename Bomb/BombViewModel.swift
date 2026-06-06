import Foundation
import Observation

@Observable
final class BombViewModel {
    private(set) var bomb: BombModel
    private(set) var currentFrame: Int = 1

    private var animationTask: Task<Void, Never>?

    var isExploded: Bool { bomb.isExploded }
    var position: GridPosition { bomb.position }
    var visibleDuration: TimeInterval { bomb.visibleDuration }
    var currentImageName: String { "Bomb\(currentFrame)" }

    init(bomb: BombModel) {
        self.bomb = bomb
    }

    func startAnimating(frameInterval: Duration = .milliseconds(180)) {
        animationTask?.cancel()
        animationTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: frameInterval)
                guard let self, !self.bomb.isExploded else { return }
                self.currentFrame = self.currentFrame % 4 + 1
            }
        }
    }

    func stopAnimating() {
        animationTask?.cancel()
        animationTask = nil
    }

    func explode() {
        bomb.isExploded = true
        currentFrame = 4
        stopAnimating()
    }
}

extension BombViewModel {
    static var preview: BombViewModel {
        BombViewModel(
            bomb: BombModel(position: GridPosition(column: 1, row: 1), visibleDuration: 2.0)
        )
    }
}
