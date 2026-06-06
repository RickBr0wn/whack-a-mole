# Build Schedule

Each item below is one commit. Work top to bottom. Do not skip ahead.

---

## Phase 3: Mole

- [ ] **MoleView:** Renders `Mole` or `MoleHit` based on `isHit`. Sits inside a hole. Include preview.
- [ ] **MoleViewModel tests:** `test_isHit_isFalse_onInit`, `test_whack_setsIsHitToTrue`

---

## Phase 4: Bomb

- [ ] **BombModel:** Struct with `id`, `GridPosition`, `isExploded: Bool`, `visibleDuration: TimeInterval`
- [ ] **BombViewModel:** `@Observable`. Cycles through `Bomb1`-`Bomb4` frames on a timer to animate. `.preview` factory.
- [ ] **BombView:** Renders animated bomb frames. Include preview.
- [ ] **BombViewModel tests:** `test_isExploded_isFalse_onInit`, `test_explode_setsIsExplodedToTrue`

---

## Phase 5: Core game loop

- [ ] **GameModel:** Struct holding the current array of active `MoleModel`s and `BombModel`s, elapsed time, and `GameState`
- [ ] **GameViewModel:** `@Observable` + `@MainActor`. Owns the game loop — spawns moles and bombs on a timer, removes them when their `visibleDuration` expires, transitions `GameState`. `.preview` factory.
- [ ] **GameView:** Wires `GameBoardView` to `GameViewModel`. Moles and bombs appear in holes. Include preview.
- [ ] **GameViewModel tests:** `test_gameState_isIdle_onInit`, `test_start_transitionsStateTo_playing`, `test_mole_isRemovedAfterVisibleDuration`

---

## Phase 6: Tap interaction

- [ ] **Whack a mole:** Tap a `MoleView` calls `GameViewModel.whack(mole:)`. Mole switches to `MoleHit`, then disappears. Tests: `test_whack_removesActiveMole`
- [ ] **Tap a bomb:** Tap a `BombView` calls `GameViewModel.triggerBomb(bomb:)`. Bomb explodes (shows `Bomb4`), game ends. Tests: `test_triggerBomb_transitionsStateTo_gameOver`
- [ ] **Miss penalty:** Tapping an empty hole (or missing) does nothing — no penalty yet, just ensure no crash

---

## Phase 7: Scoring

- [ ] **ScoreModel:** Struct with `points: Int`, `combo: Int`, `highScore: Int`. Pure logic: `func adding(hit:) -> ScoreModel`
- [ ] **ScoreViewModel:** `@Observable`. Wraps `ScoreModel`. Persists `highScore` to `UserDefaults`. `.preview` factory.
- [ ] **ScoreView:** Displays current points, combo multiplier, and high score. Include preview.
- [ ] **Wire scoring into GameViewModel:** `whack(mole:)` increments score. Combo increments on consecutive hits, resets on miss or timeout.
- [ ] **ScoreModel tests:** `test_points_incrementCorrectly`, `test_combo_resetsOnMiss`, `test_highScore_persistsAcrossSessions`

---

## Phase 8: Hat mole variant

- [ ] **HatMole:** Extend `MoleModel` with `wearsHat: Bool`. `MoleView` renders `MoleHat`, `MoleHatHit`, or `MoleHatCracks` variants. Hat moles are worth double points.
- [ ] **Hat mole tests:** `test_hatMole_awardsDoublePoints`

---

## Phase 9: Difficulty progression

- [ ] **DifficultyModel:** Struct with `level: Int`, `spawnInterval: TimeInterval`, `visibleDuration: TimeInterval`. Pure function: `func nextLevel() -> DifficultyModel`
- [ ] **Wire difficulty into GameViewModel:** Level increases every 30 seconds. Spawn interval shortens, visible duration shortens. Bomb frequency increases with level.
- [ ] **DifficultyModel tests:** `test_spawnInterval_decreasesEachLevel`, `test_visibleDuration_decreasesEachLevel`

---

## Phase 10: Game over and restart

- [ ] **GameOverView:** Displays final score, high score, and a restart button. Shown when `GameState == .gameOver`. Include preview.
- [ ] **Restart flow:** `GameViewModel.restart()` resets all state cleanly. Tests: `test_restart_clearsActiveMoles`, `test_restart_resetsScore`, `test_restart_resetsdifficulty`

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
