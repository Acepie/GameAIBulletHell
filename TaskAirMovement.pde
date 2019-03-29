public class TaskAirMovement extends Task {
  Dungeon dungeon;

  public TaskAirMovement (Blackboard bb, Dungeon d) {
    this.blackboard = bb;
    this.dungeon = d;
  }

  boolean execute() {
    Enemy enemy = (Enemy) blackboard.get("enemy");

    ArrayList<Integer> whiskerResults = new ArrayList<Integer>();
    for (PVector wp : enemy.getWhiskerPoints()) {
      whiskerResults.add(dungeon.getReflectingDirection(enemy.position, wp));
    }

    PVector pos = PVector.add(enemy.position, enemy.velocity);
    if (dungeon.canMove(enemy.position, pos)) {
      enemy.position = pos;
    } else { // Apply downward velocity but don't pass wall
      enemy.position.z += enemy.velocity.z;
    }
    return true;
  }
}
