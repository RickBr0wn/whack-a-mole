import SwiftUI

struct BombView: View {
    let viewModel: BombViewModel

    @State private var isPulsing = false

    private static let pulseScale: CGFloat = 1.15
    private static let pulseDuration: TimeInterval = 0.4

    var body: some View {
        Image(viewModel.currentImageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(isPulsing ? Self.pulseScale : 1.0)
            .onAppear {
                viewModel.startAnimating()
                withAnimation(.easeInOut(duration: Self.pulseDuration).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
            .onDisappear { viewModel.stopAnimating() }
            .onChange(of: viewModel.isExploded) { _, isExploded in
                guard isExploded else { return }
                withAnimation(.easeOut(duration: 0.1)) {
                    isPulsing = false
                }
            }
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
