import SwiftUI

struct GameBoardView: View {
    let viewModel: GameViewModel

    private static let spacing: CGFloat = 16
    private static let holeAspectRatio: CGFloat = 261.0 / 107.0

    var body: some View {
        GeometryReader { geometry in
            let columns = CGFloat(GameConstants.gridColumns)
            let rows = CGFloat(GameConstants.gridRows)
            let cellWidth = (geometry.size.width - Self.spacing * (columns - 1)) / columns
            let cellHeight = (geometry.size.height - Self.spacing * (rows - 1)) / rows
            let cellSize = min(cellWidth, cellHeight)

            VStack(spacing: Self.spacing) {
                ForEach(0..<GameConstants.gridRows, id: \.self) { row in
                    HStack(spacing: Self.spacing) {
                        ForEach(0..<GameConstants.gridColumns, id: \.self) { column in
                            cell(at: GridPosition(column: column, row: row), size: cellSize)
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .padding()
    }

    @ViewBuilder
    private func cell(at position: GridPosition, size: CGFloat) -> some View {
        let holeHeight = size / Self.holeAspectRatio
        let visibleHeight = (size + holeHeight) / 2

        ZStack {
            Image("HoleBack")
                .resizable()
                .aspectRatio(contentMode: .fit)

            occupant(at: position)
                .frame(width: size, height: visibleHeight, alignment: .top)
                .clipped()

            Image("HoleFront")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .frame(width: size, height: size)
    }

    @ViewBuilder
    private func occupant(at position: GridPosition) -> some View {
        if let mole = viewModel.moles.first(where: { $0.position == position }) {
            MoleView(viewModel: viewModel.moleViewModel(for: mole))
                .scaleEffect(1.4)
                .offset(y: -8)
        } else if let bomb = viewModel.bombs.first(where: { $0.position == position }) {
            BombView(viewModel: viewModel.bombViewModel(for: bomb))
                .scaleEffect(1.4)
                .offset(y: -8)
        }
    }
}

#Preview {
    GameBoardView(viewModel: .preview)
}
