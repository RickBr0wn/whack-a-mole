import Foundation
import Observation

@Observable
final class MoleViewModel {
    private(set) var mole: MoleModel

    var isHit: Bool { mole.isHit }
    var position: GridPosition { mole.position }
    var visibleDuration: TimeInterval { mole.visibleDuration }

    init(mole: MoleModel) {
        self.mole = mole
    }

    func whack() {
        mole.isHit = true
    }
}

extension MoleViewModel {
    static var preview: MoleViewModel {
        MoleViewModel(
            mole: MoleModel(position: GridPosition(column: 1, row: 1), visibleDuration: 1.5)
        )
    }
}
