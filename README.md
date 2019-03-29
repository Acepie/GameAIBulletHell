# GameAIBulletHell

A top down bullet-hell style game with a maze-like room and enemies that pursue the player and avoid obstacles.

## System Requirements

[Processing 3.5](https://processing.org/download/) or later

## How To Play

**Game Set-Up**

1. Clone repository
2. Open in Processing 3.5 or later
3. Press the Play ("▶") button

**Controls**

- Use the arrow keys or WASD to move
- Press "space" to jump
- Press "shift" to fire bullets
- Press "R" to randomly generate a new room

## Topics & Features

- Levels are procedurally generated
- Enemies use A\* to pathfind their way toward the player
- Enemies avoid walls, pits, obstacles, and each other
- Enemies jump over pits when convenient and possible based on current velocity
- Enemy behaviors utilize behavior trees
- The player can jump over pits and enemies, but not over obstacles
- Pits instantly kill the player, and re-start the game in a new room
- After getting hit, the player and enemies are briefly invulnerable to avoid continuous damage
