import SwiftUI

struct MoleView: View {
    let viewModel: MoleViewModel

    private var imageName: String {
        guard viewModel.wearsHat else {
            return viewModel.isHit ? "MoleHit" : "Mole"
        }

        if viewModel.isHit {
            return "MoleHatHit"
        }
        return viewModel.isCracked ? "MoleHatCracks" : "MoleHat"
    }

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

#Preview("Mole in hole") {
    ZStack {
        Image("HoleBack")
            .resizable()
            .aspectRatio(contentMode: .fit)

        MoleView(viewModel: .preview)

        Image("HoleFront")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    .padding()
}

#Preview("Mole hit") {
    let viewModel = MoleViewModel(
        mole: MoleModel(position: GridPosition(column: 1, row: 1), isHit: true, visibleDuration: 1.5)
    )
    return ZStack {
        Image("HoleBack")
            .resizable()
            .aspectRatio(contentMode: .fit)

        MoleView(viewModel: viewModel)

        Image("HoleFront")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    .padding()
}

#Preview("Hat mole") {
    let viewModel = MoleViewModel(
        mole: MoleModel(position: GridPosition(column: 1, row: 1), wearsHat: true, visibleDuration: 1.5)
    )
    return ZStack {
        Image("HoleBack")
            .resizable()
            .aspectRatio(contentMode: .fit)

        MoleView(viewModel: viewModel)

        Image("HoleFront")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    .padding()
}

#Preview("Hat mole cracked") {
    let viewModel = MoleViewModel(
        mole: MoleModel(position: GridPosition(column: 1, row: 1), isCracked: true, wearsHat: true, visibleDuration: 1.5)
    )
    return ZStack {
        Image("HoleBack")
            .resizable()
            .aspectRatio(contentMode: .fit)

        MoleView(viewModel: viewModel)

        Image("HoleFront")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    .padding()
}

#Preview("Hat mole hit") {
    let viewModel = MoleViewModel(
        mole: MoleModel(position: GridPosition(column: 1, row: 1), isHit: true, wearsHat: true, visibleDuration: 1.5)
    )
    return ZStack {
        Image("HoleBack")
            .resizable()
            .aspectRatio(contentMode: .fit)

        MoleView(viewModel: viewModel)

        Image("HoleFront")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    .padding()
}
