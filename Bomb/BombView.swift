import SwiftUI

struct BombView: View {
    let viewModel: BombViewModel

    var body: some View {
        Image(viewModel.currentImageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onAppear { viewModel.startAnimating() }
            .onDisappear { viewModel.stopAnimating() }
    }
}

#Preview("Bomb in hole") {
    ZStack {
        Image("HoleBack")
            .resizable()
            .aspectRatio(contentMode: .fit)

        BombView(viewModel: .preview)

        Image("HoleFront")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    .padding()
}
