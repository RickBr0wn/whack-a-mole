import Foundation
import Observation

@Observable
final class HoleViewModel {
    let hole: HoleModel

    init(hole: HoleModel) {
        self.hole = hole
    }
}

extension HoleViewModel {
    static var preview: HoleViewModel {
        HoleViewModel(hole: HoleModel(position: GridPosition(column: 1, row: 1)))
    }
}
