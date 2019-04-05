public class TaskSpottedPlayer extends Task {
  public TaskSpottedPlayer(Blackboard bb) {
    this.blackboard = bb;
  }

  boolean execute() {
    ArrayList<Enemy> enemies = (ArrayList<Enemy>) blackboard.get("enemies");

    return (boolean) blackboard.get("spottedPlayer");
  }
}
