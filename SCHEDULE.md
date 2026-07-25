# Build Schedule

Each item below is one commit. Work top to bottom. Do not skip ahead.

---

## Phase 10: Game over and restart

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
