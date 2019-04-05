public class TaskIsFacingPlayer extends Task {
  public TaskIsFacingPlayer (Blackboard bb) {
    this.blackboard = bb;
  }

  boolean execute() {
    Enemy enemy = (Enemy) blackboard.get("enemy");
    Player player = (Player) blackboard.get("player");

    PVector target = new PVector(player.position.x - enemy.position.x, player.position.y - enemy.position.y);
    target.mult(target.dot(PVector.fromAngle(enemy.rotation)) / target.mag());
    target.add(new PVector(enemy.position.x, enemy.position.y));

    float displacement = PVector.dist(target, new PVector(player.position.x, player.position.y));

    return displacement < player.SIZE / 2;
  }
}
