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
  
  // Don't both if player and enemy in same tile
  if (t.equals(start)) return;
  
  // TODO: Delete this if statement once wall collision is done
  if (dungeon.rooms[t.x][t.y] != null && dungeon.rooms[start.x][start.y] != null) { 
    ArrayList<PVector> path = dungeon.pathTo(start, t);
    path.remove(path.size() - 1); // last tile is not needed since player is there
    enemy.setPath(path);
  }
}

void keyPressed() {
  // TODO: delete random room generator for final game
  if (key == 'r') {
    init();
  } else if (key == CODED) {
    player.move(keyCode);
  }
}
