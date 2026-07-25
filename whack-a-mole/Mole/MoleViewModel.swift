import Foundation
import Observation

@Observable
final class MoleViewModel {
    private(set) var mole: MoleModel

    var isHit: Bool { mole.isHit }
    var isCracked: Bool { mole.isCracked }
    var wearsHat: Bool { mole.wearsHat }
    var position: GridPosition { mole.position }
    var visibleDuration: TimeInterval { mole.visibleDuration }

    init(mole: MoleModel) {
        self.mole = mole
    }

    func markHit() {
        mole.isHit = true
    }

    func markCracked() {
        mole.isCracked = true
    }
}

extension MoleViewModel {
    static var preview: MoleViewModel {
        MoleViewModel(
            mole: MoleModel(position: GridPosition(column: 1, row: 1), visibleDuration: 1.5)
        )
    }
}
