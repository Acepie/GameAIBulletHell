public class TaskSupportAllies extends Task {
  public TaskSupportAllies(Blackboard bb) {
    this.blackboard = bb;
  }

  boolean execute() {
    ArrayList<Enemy> enemies = (ArrayList<Enemy>) blackboard.get("enemies");

    for (Enemy e : enemies) {
      if ((boolean) e.bb.get("spottedPlayer")) {
        blackboard.put("spottedPlayer", true);
      }
    }

    return true;
  }
}
