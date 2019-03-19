Dungeon dungeon;
ArrayList<Enemy> enemies;
Player player; 
final int ENEMIESTOSPAWN = 3;

// Initialize game state
void init() {
  dungeon = new Dungeon();
  enemies = new ArrayList<Enemy>();
  for (int i = 0; i < ENEMIESTOSPAWN; ++i) {
    PVector spawnloc = dungeon.getRandomTile();
    enemies.add(new Enemy(spawnloc));
  }
  player = new Player(Dungeon.TOTALSIZE / 2, Dungeon.TOTALSIZE / 2);
}

void settings() {
  size(Dungeon.TOTALSIZE, Dungeon.TOTALSIZE);
  init();
}

void draw() {  
  for (Enemy enemy : enemies) {
    enemy.update(player.position);
    enemy_follows_player(enemy);
  }
  if (dungeon.canMove(player.position, player.getNextPosition())) {
    player.move();
  }
  
  for (Obstacle o : dungeon.obstacles) {
    if (o.collision(player.position, Player.SIZE)) {
      player.loseHealth(o.getDamage());
    }
    for (Enemy enemy : enemies) {
      if (o.collision(enemy.position, Enemy.SIZE)) {
        enemy.loseHealth(o.getDamage());
      }
    }
  }

  dungeon.draw();
  for (Enemy enemy : enemies) {
    enemy.draw();
  }
  player.draw();
}

// Generates the path the enemy should follow if necessary
void enemy_follows_player(Enemy enemy) {
  Tile t = dungeon.getNearestTile(player.position.x, player.position.y);
  Tile start = dungeon.getNearestTile(enemy.position.x, enemy.position.y);
  
  // Don't recalculate path if player and enemy are in same tile
  if (t.equals(start)) return;
  
  ArrayList<PVector> path = dungeon.pathTo(start, t);
  path.remove(path.size() - 1); // last tile is not needed since player is there
  enemy.setPath(path);
}

void keyPressed() {
  // TODO: delete random room generator for final game
  if (key == 'r') {
    init();
  } else if (key == CODED) {
    player.arrowDown(keyCode);
  }
}

void keyReleased() {
  if (key == CODED) {
    player.arrowUp(keyCode);
  }
}
