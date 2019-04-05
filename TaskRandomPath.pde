public class TaskRandomPath extends Task {
  Dungeon dungeon;

  public TaskRandomPath (Blackboard bb, Dungeon d) {
    this.blackboard = bb;
    this.dungeon = d;
  }

  boolean execute() {
    Random rng = new Random();
    Enemy enemy = (Enemy) blackboard.get("enemy");

    Room r = dungeon.getNearestRoom(enemy.position.x, enemy.position.y);
    int dir = rng.nextInt(8);
    while (!r.doors[dir]) {
      dir = rng.nextInt(8);
    }

    ArrayList<PVector> path = new ArrayList<PVector>();
    Tile t = dungeon.getNearestTile(enemy.position.x, enemy.position.y);
    path.add(dungeon.tileToPosition(dungeon.nextRoom(t.x, t.y, dir)));

    enemy.setPath(path);
    blackboard.put("lastPathUpdate", millis());
    return true;
  }
}
