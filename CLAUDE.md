# LogicFlow — agent map

Educational top-down RPG built in MATLAB for ENGR 100 at State U. Players explore a 100x100 tile world, solve logic gate puzzles (AND, OR, XNOR, NAND) by flipping levers to satisfy truth tables, collect four keys, and unlock a final door to win. Built as a teaching tool for middle/high school students learning digital logic.

## Run

**Requirements:** MATLAB R2020a or later (no extra toolboxes)

1. Open MATLAB, set working directory to `src/`
2. Run: `logic_flow_main`

> `retro_pack.png` must be in `assets/` (one level up from `src/`), or copied into `src/`.

## File map

- `src/logic_flow_main.m` — entry point: world setup, tile placement, game loop orchestration
- `src/gameLoop.m` — core loop: input handling, player movement, collision, camera scrolling, lever/key/door logic
- `src/buildFrame.m` — composes each rendered frame (viewport slice + HUD + sprites)
- `src/simpleGameEngine.m` — sprite rendering engine (OOP, course-provided)
- `src/gameStartFunction.m` — start screen
- `src/gameOverFunction.m` — game over screen
- `src/gameWinFunction.m` — win screen
- `src/pauseScreen.m` — pause overlay
- `src/showMessage.m` — blocking message display utility
- `src/TileBrowser.m` — dev tool: browse tile IDs from sprite sheet (not used at runtime)
- `assets/retro_pack.png` — 16x16 sprite sheet (~1000+ tiles), single asset for everything
- `docs/` — screenshots referenced in README

## Key design notes

- Camera is an 11x11 viewport over the 100x100 world. Border-lock state (`borderLockRow`/`borderLockCol`) handles edges — Zelda-style scrolling. Logic lives in `gameLoop.m`.
- Each key has a 3-state integer: `0` = unsolved, `1` = dropped on ground, `2` = in inventory.
- HUD arrows render on viewport border pointing toward the door when it's off-screen.
- Menu screens apply runtime RGB channel overrides to sprite data for tinting (no separate assets needed).
- Biomes: AND = top-left, OR = top-right, XNOR = bottom-left, NAND = bottom-right.

## Gotchas

- No toolboxes required, but MATLAB itself is required — no free runtime equivalent.
- `simpleGameEngine.m` is course-provided boilerplate; treat it as a black box.
- `TileBrowser.m` is a dev/debug utility, not part of the game flow.
- `SETUP.md` is a one-time GitHub push guide — ignore for development.
- Project is complete (final submission). No build step, no dependencies to install.
