public class TaskFollowPath extends Task {
  Dungeon dungeon;

  public TaskFollowPath (Blackboard bb, Dungeon d) {
    this.blackboard = bb;
    this.dungeon = d;
  }

  boolean execute() {
    Enemy enemy = (Enemy) blackboard.get("enemy");
    if (enemy.path.isEmpty()) {
      return false;
    }

    PVector next = enemy.path.get(0);
    if (next.dist(enemy.position) < Dungeon.TILESIZE / 10) {
      enemy.path.remove(0);
      return true;
    }

    ArrayList<Integer> whiskerResults = new ArrayList<Integer>();
    for (PVector wp : enemy.getWhiskerPoints()) {
      whiskerResults.add(dungeon.getReflectingDirection(enemy.position, wp));
    }

    PVector pos = enemy.move(next, dungeon.obstacles, dungeon.pits, (ArrayList<Enemy>) blackboard.get("enemies"), whiskerResults);
    if (dungeon.canMove(enemy.position, pos)) {
      enemy.position = pos;
    } else { // Apply downward velocity but don't pass wall
      enemy.position.z += enemy.velocity.z;
    }
    enemy.steer(next);
    return true;
  }
}
