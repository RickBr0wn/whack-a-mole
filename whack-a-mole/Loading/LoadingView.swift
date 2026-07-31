import SwiftUI

struct LoadingView: View {
    let viewModel: LoadingViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            Image("LoadingScreenBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()

            ProgressView(value: viewModel.progress)
                .tint(.yellow)
                .padding(.horizontal, 60)
                .padding(.bottom, 40)
        }
    }
}

#Preview {
    LoadingView(viewModel: .preview)
}
