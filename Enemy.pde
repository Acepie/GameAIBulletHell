public class Enemy {
  public static final int SIZE = 10;
  final int TARGET_RADIUS = 10;
  final int SLOW_RADIUS = 40;
  final float TARGET_ROT_RADIUS = PI/30;
  final float SLOW_ROT_RADIUS = PI/15;
  final int MAX_SPEED = 2;
  final int MAX_ACCELERATION = 1; 
  final float MAX_ANGULAR_SPEED = PI/20;
  final float MAX_ANGULAR_ACCELERATION = PI/40;
  final int AVOID_RADIUS = 50;
  final float AVOID_FORCE = 200;
  final float MAX_HEALTH = 80;
  public PVector position;
  PVector velocity;
  float rotation = 0;
  float rotationalVelocity = 0;

  final int damage = 5; // how much damage this enemy deals

  ArrayList<PVector> path;
  private Health health;

  public Enemy (PVector position) {
    this.position = position;
    this.velocity = new PVector(0, 0);
    this.path = new ArrayList<PVector>();
    this.health = new Health(MAX_HEALTH);
  }

  public void loseHealth(float damage) {
    this.health.loseHealth(damage);
  }

  boolean isInvulnerable() {
    return this.health.isInvulnerable();
  }

  public boolean isDead() {
    return this.health.isDead();
  }

  public int getDamage() {
    return this.damage;
  }

  public void setPath(ArrayList<PVector> path) {
    this.path = path;
  }

  public void draw() {
    if (isDead()) {
      fill(#000000);
    } else {
      fill(#DDDDDD);
    }
    stroke(#000000);
    ellipse(position.x, position.y, SIZE, SIZE);
    line(position.x, position.y, position.x + cos(rotation) * SIZE / 2, position.y + sin(rotation) * SIZE / 2);
  }

  public void update(PVector player_position, ArrayList<Obstacle> obstacles) {
    if (!path.isEmpty()) {
      PVector next = path.get(0);
      if (position.dist(next) < TARGET_RADIUS || (path.size() > 1 && position.dist(next) < SLOW_RADIUS)) {
        path.remove(0);
      } else {
        move(next, obstacles);
        steer(next);
      }
    } else {
      move(player_position, obstacles);
      steer(player_position);
    }
  }

  // converts radian amount to be between -PI and PI
  float clampRadians(float inputRadians) {
    while (inputRadians < -PI) {
      inputRadians += 2 * PI;
    }

    while (inputRadians > PI) {
      inputRadians -= 2 * PI;
    }

    return inputRadians;
  }

  // Update position and velocity based on distance from target
  void move(PVector target, ArrayList<Obstacle> obstacles) {
    PVector dir = PVector.sub(target, position);
    float dist = dir.mag();

    // In range do not move
    if (dist < TARGET_RADIUS) {
      return;
    }

    float targetSpeed = dist > SLOW_RADIUS ? MAX_SPEED : MAX_SPEED * dist / SLOW_RADIUS;

    dir.normalize();
    PVector targetVelocity = dir;
    targetVelocity = targetVelocity.mult(targetSpeed);

    PVector acceleration = targetVelocity.sub(velocity);
    if (acceleration.mag() > MAX_ACCELERATION) {
      acceleration.normalize();
      acceleration.mult(MAX_ACCELERATION);
    }

    // avoid obstacles
    for (Obstacle o : obstacles) { 
      PVector o_dir = PVector.sub(this.position, o.position);
      float distance = o_dir.mag();
      if (distance < AVOID_RADIUS) {
        float repulsionStrength = min(AVOID_FORCE / (distance * distance), MAX_ACCELERATION);
        o_dir.normalize();
        acceleration.add(o_dir.mult(repulsionStrength));
      }
    }

    velocity = velocity.add(acceleration);
    position = position.add(velocity);
  }

  // Update rotation and rotational velocity to face velocity
  void steer(PVector target) {
    PVector dir = PVector.sub(target, position);
    float dist = dir.mag();

    float targetRotation = dist < TARGET_RADIUS ? dir.heading() : velocity.heading();
    float rotationDiff = clampRadians(targetRotation - rotation);
    float rotationMag = abs(rotationDiff);

    // In range do not rotate
    if (rotationMag < TARGET_ROT_RADIUS) {
      return;
    }

    float targetRotationalVelocity = rotationMag > SLOW_ROT_RADIUS ? 
      MAX_ANGULAR_SPEED : 
      MAX_ANGULAR_SPEED * rotationMag / SLOW_ROT_RADIUS;

    targetRotationalVelocity *= rotationDiff / rotationMag;

    float rotationalAcceleration = targetRotationalVelocity - rotationalVelocity;
    float rotationalAccelMag = abs(rotationalAcceleration);

    if (rotationalAccelMag > MAX_ANGULAR_ACCELERATION) {
      rotationalAcceleration *= MAX_ANGULAR_ACCELERATION / rotationalAccelMag;
    }

    rotationalVelocity += rotationalAcceleration;
    rotation += rotationalVelocity;
  }
}
