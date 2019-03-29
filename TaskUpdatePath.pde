public class TaskUpdatePath extends Task {
  Dungeon dungeon;

  public TaskUpdatePath(Blackboard bb, Dungeon d) {
    this.blackboard = bb;
    this.dungeon = d;
  }

  boolean execute() {
    Enemy enemy = (Enemy) blackboard.get("enemy");
    Player player = (Player) blackboard.get("player");
    Tile t = dungeon.getNearestTile(player.position.x, player.position.y);
    Tile start = dungeon.getNearestTile(enemy.position.x, enemy.position.y);

    ArrayList<PVector> path = dungeon.pathTo(start, t);
    if (!path.isEmpty()) {
      path.remove(path.size() - 1); // last tile is not needed since player is there
    }
    enemy.setPath(path);
    return true;
  }
}
