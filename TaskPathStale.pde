public class TaskPathStale extends Task {
  public TaskPathStale(Blackboard bb) {
    this.blackboard = bb;
  }

  boolean execute() {
    int lastPathUpdate = (int) blackboard.get("lastPathUpdate");
    return lastPathUpdate + 1000 < millis();
  }
}
