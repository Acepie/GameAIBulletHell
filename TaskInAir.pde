public class TaskInAir extends Task {
  public TaskInAir(Blackboard bb) {
    this.blackboard = bb;
  }

  boolean execute() {
    Enemy enemy = (Enemy) blackboard.get("enemy");
    return enemy.position.z > 0;
  }
}
