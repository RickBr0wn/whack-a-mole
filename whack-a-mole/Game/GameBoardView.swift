import SwiftUI

struct GameBoardView: View {
    let viewModel: GameViewModel

    private static let minSpacing: CGFloat = 16
    private static let holeAspectRatio: CGFloat = 261.0 / 107.0
    private static let clipInset: CGFloat = 2
    private static let boardWidthFraction: CGFloat = 2.0 / 3.0

    var body: some View {
        GeometryReader { geometry in
            let boardWidth = geometry.size.width * Self.boardWidthFraction
            let columns = CGFloat(GameConstants.gridColumns)
            let rows = CGFloat(GameConstants.gridRows)
            let cellWidth = (boardWidth - Self.minSpacing * (columns - 1)) / columns
            let cellHeight = (geometry.size.height - Self.minSpacing * (rows - 1)) / rows
            let cellSize = min(cellWidth, cellHeight)
            let leftoverWidth = boardWidth - cellSize * columns
            let horizontalSpacing = columns > 1 ? max(Self.minSpacing, leftoverWidth / (columns - 1)) : Self.minSpacing

            VStack(spacing: Self.minSpacing) {
                ForEach(0..<GameConstants.gridRows, id: \.self) { row in
                    HStack(spacing: horizontalSpacing) {
                        ForEach(0..<GameConstants.gridColumns, id: \.self) { column in
                            cell(at: GridPosition(column: column, row: row), size: cellSize)
                        }
                    }
                }
            }
            .frame(width: boardWidth, height: geometry.size.height)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .padding()
    }

    @ViewBuilder
    private func cell(at position: GridPosition, size: CGFloat) -> some View {
        let holeHeight = size / Self.holeAspectRatio
        let holeTop = (size - holeHeight) / 2
        let visibleHeight = holeTop + holeHeight - Self.clipInset

        ZStack(alignment: .top) {
            Image("HoleBack")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: holeHeight)
                .offset(y: holeTop)

            occupant(at: position)
                .frame(width: size, height: visibleHeight, alignment: .top)
                .clipped()

            Image("HoleFront")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: holeHeight)
                .offset(y: holeTop)
        }
        .frame(width: size, height: size, alignment: .top)
    }

    @ViewBuilder
    private func occupant(at position: GridPosition) -> some View {
        if let mole = viewModel.moles.first(where: { $0.position == position }) {
            MoleView(viewModel: viewModel.moleViewModel(for: mole))
        } else if let bomb = viewModel.bombs.first(where: { $0.position == position }) {
            BombView(viewModel: viewModel.bombViewModel(for: bomb))
        }
    }
}

#Preview {
    GameBoardView(viewModel: .preview)
}
