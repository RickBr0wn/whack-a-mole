import SwiftUI

struct GameBoardView: View {
    var body: some View {
        VStack(spacing: 16) {
            ForEach(0..<GameConstants.gridRows, id: \.self) { row in
                HStack(spacing: 16) {
                    ForEach(0..<GameConstants.gridColumns, id: \.self) { column in
                        HoleView(
                            viewModel: HoleViewModel(
                                hole: HoleModel(position: GridPosition(column: column, row: row))
                            )
                        )
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    GameBoardView()
}
