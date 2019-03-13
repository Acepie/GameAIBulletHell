Dungeon dungeon;
Enemy enemy;

void settings() {
  size(Dungeon.TOTALSIZE, Dungeon.TOTALSIZE);
  enemy = new Enemy(Dungeon.TOTALSIZE / 2, Dungeon.TOTALSIZE / 2);
  dungeon = new Dungeon();
}

void draw() {

  // TODO: delete random room generator for final game
  if (keyPressed && key == 'r') {
    dungeon = new Dungeon();
    enemy = new Enemy(Dungeon.TOTALSIZE / 2, Dungeon.TOTALSIZE / 2);
  }

  enemy.update();

  dungeon.draw();
  enemy.draw();
}

void mouseReleased() {
  Tile t = dungeon.getNearestTile(mouseX, mouseY);
  if (dungeon.rooms[t.x][t.y] != null) {
    Tile start = dungeon.getNearestTile(enemy.position.x, enemy.position.y);
    enemy.setPath(dungeon.pathTo(start, t));
  }
}