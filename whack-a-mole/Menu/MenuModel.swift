import Foundation

struct MenuModel: Sendable {
    var isSoundOn: Bool

    init(isSoundOn: Bool = true) {
        self.isSoundOn = isSoundOn
    }
}
