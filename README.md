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
* Use the arrow keys to move
* Press "space" to jump
* Press "R" to randomly generate a new room

## Topics & Features

* Levels are procedurally generated
* Enemies use A* to pathfind their way toward the player
* Enemies avoid walls, pits, obstacles, and each other 
* In a future milestone, enemies will be able to jump over pits
* The player can jump over pits and enemies, but not over obstacles
* Pits instantly kill the player, and re-start the game in a new room
* After getting hit, the player is briefly invulnerable to avoid continuous damage from collisions with obstacles or enemies