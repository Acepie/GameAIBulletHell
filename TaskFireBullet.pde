public class TaskFireBullet extends Task {
  final float WAIT_TIME = 200;

  public TaskFireBullet (Blackboard bb) {
    this.blackboard = bb;
  }

  boolean execute() {
    Enemy enemy = (Enemy) blackboard.get("enemy");
    ArrayList<Bullet> bullets = (ArrayList<Bullet>) blackboard.get("bullets");

    if (enemy.lastFire + WAIT_TIME > millis()) {
      return false;
    }

    bullets.add(enemy.shoot());
    return true;
  }
}
