import SwiftUI

struct MoleView: View {
    let viewModel: MoleViewModel

    private var imageName: String {
        guard viewModel.wearsHat else {
            return viewModel.isHit ? "MoleHit" : "Mole"
        }

        if viewModel.isHit {
            return "MoleHatHit"
        }
        return viewModel.isCracked ? "MoleHatCracks" : "MoleHat"
    }

    private var hitPhase: Int {
        (viewModel.isCracked ? 1 : 0) + (viewModel.isHit ? 1 : 0)
    }

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .keyframeAnimator(initialValue: HitAnimationValues(), trigger: hitPhase) { content, value in
                content
                    .scaleEffect(value.scale)
                    .offset(x: value.shakeOffset)
            } keyframes: { _ in
                KeyframeTrack(\.scale) {
                    LinearKeyframe(0.8, duration: 0.08)
                    SpringKeyframe(1.0, duration: 0.15)
                }
                KeyframeTrack(\.shakeOffset) {
                    LinearKeyframe(-4, duration: 0.04)
                    LinearKeyframe(4, duration: 0.04)
                    LinearKeyframe(-4, duration: 0.04)
                    LinearKeyframe(4, duration: 0.04)
                    LinearKeyframe(0, duration: 0.04)
                }
            }
    }
}

private struct HitAnimationValues {
    var scale: CGFloat = 1.0
    var shakeOffset: CGFloat = 0
}

#Preview("Mole in hole") {
    ZStack {
        Image("HoleBack")
            .resizable()
            .aspectRatio(contentMode: .fit)

        MoleView(viewModel: .preview)

        Image("HoleFront")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    .padding()
}

#Preview("Mole hit") {
    let viewModel = MoleViewModel(
        mole: MoleModel(position: GridPosition(column: 1, row: 1), isHit: true, visibleDuration: 1.5)
    )
    return ZStack {
        Image("HoleBack")
            .resizable()
            .aspectRatio(contentMode: .fit)

        MoleView(viewModel: viewModel)

        Image("HoleFront")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    .padding()
}

#Preview("Hat mole") {
    let viewModel = MoleViewModel(
        mole: MoleModel(position: GridPosition(column: 1, row: 1), wearsHat: true, visibleDuration: 1.5)
    )
    return ZStack {
        Image("HoleBack")
            .resizable()
            .aspectRatio(contentMode: .fit)

        MoleView(viewModel: viewModel)

        Image("HoleFront")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    .padding()
}

#Preview("Hat mole cracked") {
    let viewModel = MoleViewModel(
        mole: MoleModel(position: GridPosition(column: 1, row: 1), isCracked: true, wearsHat: true, visibleDuration: 1.5)
    )
    return ZStack {
        Image("HoleBack")
            .resizable()
            .aspectRatio(contentMode: .fit)

        MoleView(viewModel: viewModel)

        Image("HoleFront")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    .padding()
}

#Preview("Hat mole hit") {
    let viewModel = MoleViewModel(
        mole: MoleModel(position: GridPosition(column: 1, row: 1), isHit: true, wearsHat: true, visibleDuration: 1.5)
    )
    return ZStack {
        Image("HoleBack")
            .resizable()
            .aspectRatio(contentMode: .fit)

        MoleView(viewModel: viewModel)

        Image("HoleFront")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    .padding()
}
