import SwiftUI

struct MenuView: View {
    let viewModel: MenuViewModel
    var onStart: () -> Void = {}

    var body: some View {
        ZStack(alignment: .bottom) {
            Image("LoadingScreenBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea()

            LinearGradient(
                colors: [.black.opacity(0.3), .black.opacity(0.55), .black.opacity(0.94)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Best: \(viewModel.highScore)")
                    .font(.title3.monospacedDigit())
                    .foregroundStyle(.white)

                Button("Start", action: onStart)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                Button {
                    Task { await viewModel.toggleSound() }
                } label: {
                    Label(
                        viewModel.isSoundOn ? "Sound On" : "Sound Off",
                        systemImage: viewModel.isSoundOn ? "speaker.wave.2.fill" : "speaker.slash.fill"
                    )
                }
                .buttonStyle(.bordered)
                .tint(.white)
            }
            .padding(.bottom, 32)
        }
    }
}

#Preview {
    MenuView(viewModel: .preview)
}
