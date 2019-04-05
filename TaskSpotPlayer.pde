public class TaskSpotPlayer extends Task {
  public TaskSpotPlayer(Blackboard bb) {
    this.blackboard = bb;
  }

  boolean execute() {
    blackboard.put("spottedPlayer", true);
    return true;
  }
}
