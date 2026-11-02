# Color Links


Act as a senior mobile game developer, game designer, and UI/UX designer. Build a complete, polished, production-quality puzzle game called **Color Links**.

## 1. Game Concept

Color Links is a relaxing but challenging grid-based puzzle game.

The objective is simple:

- The board contains pairs of colored dots.
- Connect each pair of dots using paths of the same color.
- Paths cannot cross or overlap.
- Every cell on the board must be occupied by exactly one path.
- Every colored pair must be connected.
- The puzzle is completed only when all pairs are connected and the entire board is filled.

The game should be easy to learn but progressively challenging.

## 2. Core Gameplay

Implement the following mechanics:

1. Display a square grid containing colored endpoint pairs.
2. Allow players to connect matching endpoints by dragging their finger or mouse across adjacent cells.
3. Paths must follow horizontal or vertical grid connections. No diagonal movement.
4. Paths cannot cross, overlap, or pass through endpoints belonging to other colors.
5. Players can modify or erase their existing paths.
6. If a player starts drawing from an existing path, the previous path should be updated intelligently.
7. Players can undo their last move.
8. Include a reset button to clear the entire board.
9. Include a hint system that highlights the next correct move.
10. Automatically detect when all pairs are connected and all grid cells are occupied.

Important: A path must connect two endpoints of the same color. A path cannot terminate in an empty cell.

## 3. Level Design

Create a progressive level system with at least 100 playable levels.

Difficulty progression:

- Levels 1–10: 5x5 grids, 2–3 color pairs.
- Levels 11–25: 6x6 grids, 3–4 color pairs.
- Levels 26–45: 7x7 grids, 4–5 color pairs.
- Levels 46–70: 8x8 grids, 5–6 color pairs.
- Levels 71–100: 9x9 grids, 6–7 color pairs.

Each level must have a valid solution.

Do not generate random puzzles without verifying their solvability.

For initial levels, use manually designed puzzles with known solutions. For later levels, implement a puzzle generation algorithm with a solver that verifies:
- Every endpoint has a valid matching endpoint.
- All paths are valid.
- Paths do not overlap.
- Every cell can be occupied.
- The puzzle has at least one valid solution.

Avoid repeating the same puzzle layout.

## 4. User Interface and Visual Design

Create a beautiful, minimalist, colorful mobile game interface.

Design inspiration:
- RGB Express
- Flow Free
- Monument Valley
- Modern casual puzzle games

Visual requirements:

- Clean and colorful interface.
- Rounded corners and subtle shadows.
- Smooth animations.
- Soft background colors.
- Clearly distinguishable endpoint colors.
- Smooth path drawing animations.
- Responsive grid that adapts to different screen sizes.
- Large touch-friendly buttons.
- Pleasant visual feedback for correct and incorrect moves.

Use a visually consistent color palette.

Suggested colors:
- Red: #FF5A5F
- Blue: #4285F4
- Green: #34A853
- Yellow: #F4C542
- Purple: #9B72CF
- Orange: #FF9633
- Cyan: #35BFC0

Avoid excessive visual effects. Keep the board as the main focus.

## 5. Main Menu

Create a polished main menu containing:

- Game logo: COLOR LINKS
- Play button
- Level selection
- Settings
- Sound on/off
- Music on/off
- Progress indicator

The interface should feel like a real commercial mobile game, not a prototype.

## 6. Level Selection

Implement a level selection screen.

Requirements:
- Display levels in a clean grid.
- Show completed levels with a star or checkmark.
- Lock levels that have not yet been unlocked.
- Save player progress.
- Allow players to replay completed levels.
- Show the player's current level.

## 7. Level Completion

When a puzzle is solved:

- Play a pleasant completion animation.
- Display a success message.
- Award up to three stars based on the number of hints and resets used.
- Show a Next Level button.
- Save progress automatically.

## 8. Game Mechanics and Code Architecture

Separate the code into logical modules:

- GameEngine
- BoardManager
- PathManager
- LevelManager
- PuzzleValidator
- PuzzleGenerator
- HintSystem
- SaveManager
- AudioManager
- UI components

Keep game logic independent from UI rendering.

Use clean architecture, reusable components, and maintainable code.

Avoid putting all game logic inside a single component.

## 9. Persistence

Save:
- Unlocked levels.
- Completed levels.
- Best scores.
- Star ratings.
- Game settings.
- Current progress.

Player progress must survive app restarts.

## 10. Audio and Animations

Add:
- Soft background music.
- Button interaction sounds.
- Path connection sounds.
- Invalid move feedback.
- Level completion sound.
- Smooth path drawing animations.
- Subtle endpoint animations.

Audio must be optional and configurable.

## 11. Technical Requirements

First inspect the existing project and identify its framework and architecture.

If the project is empty, use:
- React Native with Expo
- TypeScript
- React Native Gesture Handler
- React Native Reanimated

The game should support both iOS and Android.

Requirements:
- No unnecessary dependencies.
- No placeholder buttons.
- No fake level progression.
- No broken interactions.
- No hardcoded UI-only solutions.
- Proper TypeScript types.
- Reusable components.
- Efficient rendering during touch interactions.

## 12. Testing

Write unit tests for:
- Path validation.
- Endpoint matching.
- Path collision detection.
- Board completion detection.
- Puzzle solvability.
- Level progression.
- Save and restore functionality.

Test edge cases such as:
- Drawing over an existing path.
- Reversing a path.
- Connecting the wrong endpoints.
- Leaving empty cells.
- Attempting diagonal movement.
- Trying to cross another path.

## 13. Development Workflow

Work incrementally:

1. Inspect the project.
2. Set up the game architecture.
3. Implement the grid and endpoint rendering.
4. Implement touch-based path drawing.
5. Implement validation and completion logic.
6. Create the initial 20 handcrafted levels.
7. Implement level selection and persistence.
8. Add animations and audio.
9. Expand to 100 verified levels.
10. Run tests and fix all issues.

Do not stop after creating a visual mockup.

The final result must be a fully playable puzzle game with working mechanics, real levels, persistent progress, and polished visuals.

Prioritize gameplay quality, responsiveness, and a satisfying player experience.