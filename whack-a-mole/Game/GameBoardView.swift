import SwiftUI

struct GameBoardView: View {
    let viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 16) {
            ForEach(0..<GameConstants.gridRows, id: \.self) { row in
                HStack(spacing: 16) {
                    ForEach(0..<GameConstants.gridColumns, id: \.self) { column in
                        cell(at: GridPosition(column: column, row: row))
                    }
                }
            }
        }
        .padding()
    }

    @ViewBuilder
    private func cell(at position: GridPosition) -> some View {
        ZStack {
            Image("HoleBack")
                .resizable()
                .aspectRatio(contentMode: .fit)

            if let mole = viewModel.moles.first(where: { $0.position == position }) {
                MoleView(viewModel: viewModel.moleViewModel(for: mole))
                    .scaleEffect(1.4)
                    .offset(y: -8)
            } else if let bomb = viewModel.bombs.first(where: { $0.position == position }) {
                BombView(viewModel: viewModel.bombViewModel(for: bomb))
                    .scaleEffect(1.4)
                    .offset(y: -8)
            }

            Image("HoleFront")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

#Preview {
    GameBoardView(viewModel: .preview)
}
