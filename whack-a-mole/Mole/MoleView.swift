import SwiftUI

struct MoleView: View {
    let viewModel: MoleViewModel

    var body: some View {
        Image(viewModel.isHit ? "MoleHit" : "Mole")
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
    let viewModel = MoleViewModel.preview
    viewModel.whack()
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
