# Build Schedule

Each item below is one commit. Work top to bottom. Do not skip ahead.

---

## Phase 7: Scoring

- [ ] **Wire scoring into GameViewModel:** `whack(mole:)` increments score. Combo increments on consecutive hits, resets on miss or timeout.

---

## Phase 8: Hat mole variant

- [ ] **HatMole:** Extend `MoleModel` with `wearsHat: Bool`. `MoleView` renders `MoleHat`, `MoleHatHit`, or `MoleHatCracks` variants. Hat moles are worth double points.

---

## Phase 9: Difficulty progression

- [ ] **DifficultyModel:** Struct with `level: Int`, `spawnInterval: TimeInterval`, `visibleDuration: TimeInterval`. Pure function: `func nextLevel() -> DifficultyModel`
- [ ] **Wire difficulty into GameViewModel:** Level increases every 30 seconds. Spawn interval shortens, visible duration shortens. Bomb frequency increases with level.

---

## Phase 10: Game over and restart

- [ ] **GameOverView:** Displays final score, high score, and a restart button. Shown when `GameState == .gameOver`. Include preview.
- [ ] **Restart flow:** `GameViewModel.restart()` resets all state cleanly.

---

## Phase 11: Audio

- [ ] **AudioManager:** `actor`. Loads and plays sounds using `AVFoundation`. Methods: `playWhack()`, `playBombExplosion()`, `playGameOver()`.
- [ ] **Wire audio into GameViewModel:** Call `AudioManager` on whack, bomb trigger, and game over.

---

## Phase 12: Animations

- [ ] **Mole pop animation:** Mole slides up from the hole on spawn, slides down on retreat. Use `withAnimation` + offset.
- [ ] **Hit animation:** Brief scale-down + shake on whack.
- [ ] **Bomb pulse animation:** Bomb scales up/down while active as a visual warning.
- [ ] **Score pop:** Points value briefly floats up from the tapped hole on a successful whack.
