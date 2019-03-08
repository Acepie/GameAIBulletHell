Dungeon dungeon;

void settings() {
  size(Dungeon.TOTALSIZE, Dungeon.TOTALSIZE);
  dungeon = new Dungeon();
}

void draw() {

  if (keyPressed && key == 'r') {
    dungeon = new Dungeon();
  }

  dungeon.draw();
}