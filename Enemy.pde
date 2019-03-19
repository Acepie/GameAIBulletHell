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
  final int AVOID_RADIUS = 250;
  final float AVOID_FORCE = 4000;
  final float MAX_HEALTH = 80;
  public PVector position;
  PVector velocity;
  float rotation = 0;
  float rotationalVelocity = 0;

  ArrayList<PVector> path;
  Actor actor;

  public Enemy (PVector position) {
    this.position = position;
    this.velocity = new PVector(0, 0);
    this.path = new ArrayList<PVector>();
    this.actor = new Actor(MAX_HEALTH);
  }
  
  public void loseHealth(float damage) {
    this.actor.loseHealth(damage);
  }
  
  boolean isInvulnerable() {
    return this.actor.isInvulnerable();
  }
  
  public boolean isDead() {
    return this.actor.isDead();
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

  public void update(PVector player_position) {
    if (!path.isEmpty()) {
      PVector next = path.get(0);
      if (position.dist(next) < TARGET_RADIUS || (path.size() > 1 && position.dist(next) < SLOW_RADIUS)) {
        path.remove(0);
      } else {
        move(next);
        steer(next);
      }
    } else {
      move(player_position);
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
  void move(PVector target) {
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
