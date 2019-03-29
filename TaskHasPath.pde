public class TaskHasPath extends Task {
  public TaskHasPath(Blackboard bb) {
    this.blackboard = bb;
  }

  boolean execute() {
    Enemy enemy = (Enemy) blackboard.get("enemy");
    return !enemy.path.isEmpty();
  }
}
