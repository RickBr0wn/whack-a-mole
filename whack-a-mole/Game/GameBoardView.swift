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
            let cellWidth = max(0, (boardWidth - Self.minSpacing * (columns - 1)) / columns)
            let cellHeight = max(0, (geometry.size.height - Self.minSpacing * (rows - 1)) / rows)
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
        let mole = viewModel.moles.first(where: { $0.position == position })
        let bomb = viewModel.bombs.first(where: { $0.position == position })
        let scorePopEvent = viewModel.lastScorePop.flatMap { $0.position == position ? $0 : nil }

        ZStack(alignment: .top) {
            Image("HoleBack")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: holeHeight)
                .offset(y: holeTop)

            HoleOccupantView(
                mole: mole,
                bomb: bomb,
                size: size,
                visibleHeight: visibleHeight,
                moleViewModel: viewModel.moleViewModel(for:),
                bombViewModel: viewModel.bombViewModel(for:)
            )

            Image("HoleFront")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: holeHeight)
                .offset(y: holeTop)

            ScorePopView(event: scorePopEvent)
                .frame(width: size, alignment: .top)
                .offset(y: holeTop)
        }
        .frame(width: size, height: size, alignment: .top)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.handleTap(at: position)
        }
    }
}

/// Owns the pop-up/pop-down animation for a single hole. The clip window stays
/// permanently present so it always masks content correctly; only the mole's
/// offset inside it is animated. A retreating mole is retained briefly in
/// `displayedMole` after `GameViewModel` removes it from the model, so there's
/// something left to animate sliding back down.
private struct HoleOccupantView: View {
    let mole: MoleModel?
    let bomb: BombModel?
    let size: CGFloat
    let visibleHeight: CGFloat
    let moleViewModel: (MoleModel) -> MoleViewModel
    let bombViewModel: (BombModel) -> BombViewModel

    @State private var displayedMole: MoleModel?
    @State private var isMoleRisen: Bool

    private static let popDuration: TimeInterval = 0.3

    init(
        mole: MoleModel?,
        bomb: BombModel?,
        size: CGFloat,
        visibleHeight: CGFloat,
        moleViewModel: @escaping (MoleModel) -> MoleViewModel,
        bombViewModel: @escaping (BombModel) -> BombViewModel
    ) {
        self.mole = mole
        self.bomb = bomb
        self.size = size
        self.visibleHeight = visibleHeight
        self.moleViewModel = moleViewModel
        self.bombViewModel = bombViewModel
        _displayedMole = State(initialValue: mole)
        _isMoleRisen = State(initialValue: mole != nil)
    }

    var body: some View {
        ZStack(alignment: .top) {
            if let displayedMole {
                MoleView(viewModel: moleViewModel(displayedMole))
                    .offset(y: isMoleRisen ? 0 : visibleHeight)
            }
            if let bomb {
                BombView(viewModel: bombViewModel(bomb))
            }
        }
        .frame(width: size, height: visibleHeight, alignment: .top)
        .clipped()
        .onChange(of: mole) { _, newMole in
            syncMole(newMole)
        }
    }

    private func syncMole(_ newMole: MoleModel?) {
        guard newMole?.id != displayedMole?.id else {
            displayedMole = newMole
            return
        }

        if let newMole {
            displayedMole = newMole
            isMoleRisen = false
            withAnimation(.easeOut(duration: Self.popDuration)) {
                isMoleRisen = true
            }
        } else {
            withAnimation(.easeOut(duration: Self.popDuration)) {
                isMoleRisen = false
            }
            let staleMoleID = displayedMole?.id
            Task {
                try? await Task.sleep(for: .seconds(Self.popDuration))
                if displayedMole?.id == staleMoleID {
                    displayedMole = nil
                }
            }
        }
    }
}

/// Floats "+N" up from a hole and fades it out when a `ScorePopEvent` arrives
/// for that position. Retains the event briefly in local state after it's
/// consumed, the same "hold, animate, then self-clear" pattern used by
/// `HoleOccupantView` for the mole retreat animation.
private struct ScorePopView: View {
    let event: ScorePopEvent?

    @State private var displayedEvent: ScorePopEvent?
    @State private var riseOffset: CGFloat = 0
    @State private var opacity: Double = 0

    private static let duration: TimeInterval = 0.6
    private static let riseDistance: CGFloat = 40

    var body: some View {
        Group {
            if let displayedEvent {
                Text("+\(displayedEvent.points)")
                    .font(.headline.bold())
                    .foregroundStyle(.yellow)
                    .offset(y: riseOffset)
                    .opacity(opacity)
            }
        }
        .onChange(of: event) { _, newEvent in
            guard let newEvent else { return }
            displayedEvent = newEvent
            riseOffset = 0
            opacity = 1
            withAnimation(.easeOut(duration: Self.duration)) {
                riseOffset = -Self.riseDistance
                opacity = 0
            }
            let eventID = newEvent.id
            Task {
                try? await Task.sleep(for: .seconds(Self.duration))
                if displayedEvent?.id == eventID {
                    displayedEvent = nil
                }
            }
        }
    }
}

#Preview {
    GameBoardView(viewModel: .preview)
}
