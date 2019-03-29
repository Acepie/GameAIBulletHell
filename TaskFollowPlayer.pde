public class TaskFollowPlayer extends Task {
  Dungeon dungeon;

  public TaskFollowPlayer (Blackboard bb, Dungeon d) {
    this.blackboard = bb;
    this.dungeon = d;
  }

  boolean execute() {
    Enemy enemy = (Enemy) blackboard.get("enemy");
    Player player = (Player) blackboard.get("player");

    ArrayList<Integer> whiskerResults = new ArrayList<Integer>();
    for (PVector wp : enemy.getWhiskerPoints()) {
      whiskerResults.add(dungeon.getReflectingDirection(enemy.position, wp));
    }

    PVector target = player.position.copy();
    target.z = 0;

    PVector pos = enemy.move(target, dungeon.obstacles, dungeon.pits, (ArrayList<Enemy>) blackboard.get("enemies"), whiskerResults);
    if (dungeon.canMove(enemy.position, pos)) {
      enemy.position = pos;
    } else { // Apply downward velocity but don't pass wall
      enemy.position.z += enemy.velocity.z;
    }
    enemy.steer(target);
    return true;
  }
}
