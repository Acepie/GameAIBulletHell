public class TaskInRangeOfPlayer extends Task {
  Dungeon dungeon;

  public TaskInRangeOfPlayer (Blackboard bb, Dungeon d) {
    this.blackboard = bb;
    this.dungeon = d;
  }

  boolean execute() {
    Enemy enemy = (Enemy) blackboard.get("enemy");
    Player player = (Player) blackboard.get("player");

    Tile s = dungeon.getNearestTile(enemy.position.x, enemy.position.y);
    Tile e = dungeon.getNearestTile(player.position.x, player.position.y);

    return (abs(s.x - e.x) <= 1 && 
    abs(s.y - e.y) <= 1 && 
    dungeon.canMove(enemy.position, player.position) &&
    enemy.position.dist(player.position) < Dungeon.TILESIZE / 2);
  }
}
