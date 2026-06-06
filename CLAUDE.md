# Whack-a-Mole iOS - Claude Instructions

## Build schedule

Before starting any new work, read `SCHEDULE.md` in the project root. It defines the exact order of commits. Always work on the next unchecked item. Mark it `[x]` when the commit is done.

## Project overview

This is an iOS game built with SwiftUI and pure Apple frameworks. It starts as a classic Whack-a-Mole game and will grow into an enterprise-level product over many iterations. Scope includes: core gameplay (moles and bombs), a scoring system, difficulty progression, and sound effects.

## Stack

- **Language:** Swift (latest)
- **UI:** SwiftUI
- **Concurrency:** async/await and actors — never use callbacks or DispatchQueue unless bridging legacy APIs
- **Audio:** AVFoundation
- **No third-party packages** — use only Apple frameworks

## Architecture: MVVM

Every feature must follow MVVM strictly:

- **Model:** Plain Swift structs/classes. Pure data and business logic, no SwiftUI imports.
- **ViewModel:** `@Observable` classes (Swift 5.9+). Owns state and game logic. Injected into views via the environment or initialiser.
- **View:** SwiftUI structs. Thin — no logic beyond presentation. Reads from the ViewModel only.

```
// Correct
struct MoleView: View {
    var viewModel: MoleViewModel
}

// Wrong — logic does not belong in a View
struct MoleView: View {
    func calculateScore() { ... }
}
```

## File and folder organisation

Group files by feature, not by type. Each feature folder contains its Model, ViewModel, and View together.

```
whack-a-mole/
  App/
    whack_a_moleApp.swift
    ContentView.swift
  Game/
    GameModel.swift
    GameViewModel.swift
    GameView.swift
  Mole/
    MoleModel.swift
    MoleViewModel.swift
    MoleView.swift
  Bomb/
    BombModel.swift
    BombViewModel.swift
    BombView.swift
  Scoring/
    ScoreModel.swift
    ScoreViewModel.swift
    ScoreView.swift
  Audio/
    AudioManager.swift
  Shared/
    (shared utilities, extensions, constants)
```

Create this structure proactively when adding new features. Do not dump new files into the root of the project folder.

## Code comments

Write no comments by default. Well-named types, properties, and functions should be self-explanatory. Only add a comment when the logic is genuinely complex and the WHY would not be obvious to another Swift developer reading it cold.

## SwiftUI Previews

Every view file must include a `#Preview` block with realistic sample data. Never use an empty or placeholder preview.

```swift
#Preview {
    MoleView(viewModel: MoleViewModel.preview)
}
```

Define a static `.preview` factory on every ViewModel to supply sample data:

```swift
extension MoleViewModel {
    /// A pre-configured instance for use in SwiftUI Previews.
    static var preview: MoleViewModel {
        let vm = MoleViewModel(mole: .init(position: .init(column: 1, row: 1), visibleDuration: 1.5))
        return vm
    }
}
```

## Concurrency

- Use `async/await` for all asynchronous work.
- Use `actor` to protect shared mutable state (e.g. score tracking, game timer).
- Mark UI updates with `@MainActor`.
- Never use `DispatchQueue.main.async` — use `await MainActor.run { }` or `@MainActor` annotations instead.

## Testing

Write unit tests alongside every new piece of game logic. Tests live in the `whack-a-moleTests` target.

- Test every ViewModel method that affects state.
- Test every Model computed property or function.
- Do not test Views directly.
- Use `XCTest` — no third-party testing frameworks.
- Name tests descriptively: `test_score_incrementsBy100_whenMoleIsWhacked()`

## Assets

All image assets are in `Assets.xcassets` as named imagesets:

- `Mole` — standard mole
- `MoleHit` — mole after being whacked
- `MoleHat` -- mole wearing a hat
- `MoleHatHit` -- hat mole after being whacked
- `MoleHatCracks` -- cracked hat variant
- `HoleFront` -- foreground of a hole
- `HoleBack` -- background of a hole
- `Bomb1`, `Bomb2`, `Bomb3`, `Bomb4` -- bomb animation frames

Reference images using `Image("AssetName")` or `UIImage(named:)`.

## General rules

- Never use `var` when `let` will do.
- Prefer `@Observable` over `ObservableObject`/`@Published` (requires iOS 17+).
- Use Swift's structured concurrency (`async let`, `TaskGroup`) for parallel work.
- Do not introduce any third-party dependencies. If you think one is needed, flag it and ask first.
- When adding a new feature, create the full MVVM stack (Model + ViewModel + View + Tests) in one pass.
- Do not leave `TODO` comments or stub implementations. Either implement it fully or ask for scope clarification.
