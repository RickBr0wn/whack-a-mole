import SwiftUI

struct HoleView: View {
    let viewModel: HoleViewModel

    var body: some View {
        ZStack {
            Image("HoleBack")
                .resizable()
                .aspectRatio(contentMode: .fit)

            Image("HoleFront")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

#Preview {
    HoleView(viewModel: .preview)
        .padding()
}
