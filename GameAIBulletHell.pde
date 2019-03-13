Dungeon dungeon;

// TODO: remove proof of concept A* test rendering
Tile start;
Tile end;
ArrayList<Tile> path;

void settings() {
  size(Dungeon.TOTALSIZE, Dungeon.TOTALSIZE);
  dungeon = new Dungeon();
  path = new ArrayList<Tile>();
}

void draw() {

  // TODO: delete random room generator for final game
  if (keyPressed && key == 'r') {
    dungeon = new Dungeon();
    start = null;
    end = null;
    path = null;
  }

  dungeon.draw();

  if (path != null) {
    fill(#00FF00);
    stroke(#FFFFFF);
    for (Tile t : path) {
      int top = t.y * Dungeon.TILESIZE;
      int left = t.x * Dungeon.TILESIZE;
      
      rect(left, top, Dungeon.TILESIZE, Dungeon.TILESIZE);
    }
  }

  if (start != null) {
    fill(#0000FF);
    stroke(#FFFFFF);

    int top = start.y * Dungeon.TILESIZE;
    int left = start.x * Dungeon.TILESIZE;
    
    rect(left, top, Dungeon.TILESIZE, Dungeon.TILESIZE);
  }

  if (end != null) {
    fill(#FF0000);
    stroke(#FFFFFF);

    int top = end.y * Dungeon.TILESIZE;
    int left = end.x * Dungeon.TILESIZE;
    
    rect(left, top, Dungeon.TILESIZE, Dungeon.TILESIZE);
  }
}

void mouseReleased() {
  Tile t = dungeon.getNearestTile(mouseX, mouseY);
  if (dungeon.rooms[t.x][t.y] != null) {
    if (end == null && start != null) {
      end = t;
      path = dungeon.pathTo(start, end);
    } else {
      start = t;
      end = null;
      path = null;
    }
  }
}