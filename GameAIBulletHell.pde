Dungeon dungeon;
Enemy enemy;
Player player; 

void settings() {
  size(Dungeon.TOTALSIZE, Dungeon.TOTALSIZE);
  enemy = new Enemy(Dungeon.TOTALSIZE / 2, Dungeon.TOTALSIZE / 2);
  player = new Player(Dungeon.TOTALSIZE / 2, Dungeon.TOTALSIZE / 2);
  dungeon = new Dungeon();
}

void draw() {

  // TODO: delete random room generator for final game
  if (keyPressed && key == 'r') {
    dungeon = new Dungeon();
    enemy = new Enemy(Dungeon.TOTALSIZE / 2, Dungeon.TOTALSIZE / 2);
  }
  
  enemy.update(player.position);
  enemy_follows_player();

  dungeon.draw();
  enemy.draw();
  player.draw();

}

void enemy_follows_player() {
  Tile t = dungeon.getNearestTile(player.position.x, player.position.y);
  Tile start = dungeon.getNearestTile(enemy.position.x, enemy.position.y);
  
  if (t.equals(start)) return;
  
  if (!enemy.path.isEmpty()) {
    PVector last = enemy.path.get(enemy.path.size() - 1);
    if (dungeon.getNearestTile(last.x, last.y).equals(t)) return;
  }
  
  if (dungeon.rooms[t.x][t.y] != null) { 
    ArrayList<PVector> path = dungeon.pathTo(start, t);
    path.remove(0); // first tile is where enemy is located
    enemy.setPath(path);
  }
}

void keyPressed() {
  if (key == CODED) {
    player.move(keyCode);
  }
}
