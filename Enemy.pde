public class Enemy {
  public static final int SIZE = 10;
  final int TARGET_RADIUS = 10;
  final int SLOW_RADIUS = 40;
  final float TARGET_ROT_RADIUS = PI/30;
  final float SLOW_ROT_RADIUS = PI/15;
  final int MAX_SPEED = 2;
  final int WHISKER_LENGTH = 20;
  final int MAX_ACCELERATION = 1; 
  final float MAX_ANGULAR_SPEED = PI/20;
  final float MAX_ANGULAR_ACCELERATION = PI/40;
  final int AVOID_RADIUS = 50;
  final float AVOID_FORCE = 200;
  final int CLUSTER_RADIUS = 20;
  final float CLUSTER_FORCE = 100;
  final float WALL_AVOID_FORCE = MAX_ACCELERATION;
  final float MAX_HEALTH = 80;
  public PVector position;
  PVector velocity;
  float rotation = 0;
  float rotationalVelocity = 0;

  final int damage = 5; // how much damage this enemy deals

  ArrayList<PVector> path;
  Health health;

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

  // Determines next move and returns new position
  public PVector update(PVector player_position, ArrayList<Obstacle> obstacles, ArrayList<Enemy> enemies, ArrayList<Integer> whiskerResult) {
    if (!path.isEmpty()) {
      PVector next = path.get(0);
      if (position.dist(next) < TARGET_RADIUS || (path.size() > 1 && position.dist(next) < SLOW_RADIUS)) {
        path.remove(0);
      } else {
        PVector pos = move(next, obstacles, enemies, whiskerResult);
        steer(next);
        return pos;
      }
    } else {
      PVector pos = move(player_position, obstacles, enemies, whiskerResult);
      steer(player_position);
      return pos;
    }

    return null;
  }

  // Gets projected whisker points at 45 degree angles from current velocity
  public ArrayList<PVector> getWhiskerPoints() {
    ArrayList<PVector> points = new ArrayList<PVector>();
    PVector dir = velocity.copy();
    dir.normalize();
    dir.mult(WHISKER_LENGTH);
    dir.rotate(PI / 4);
    points.add(PVector.add(dir, position));
    dir.rotate(-PI / 2);
    points.add(PVector.add(dir, position));

    return points;
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
  PVector move(PVector target, ArrayList<Obstacle> obstacles, ArrayList<Enemy> enemies, ArrayList<Integer> whiskerResults) {
    PVector dir = PVector.sub(target, position);
    float dist = dir.mag();

    // In range do not move
    if (dist < TARGET_RADIUS) {
      return null;
    }

    float targetSpeed = dist > SLOW_RADIUS ? MAX_SPEED : MAX_SPEED * dist / SLOW_RADIUS;

    dir.normalize();
    PVector targetVelocity = dir;
    targetVelocity = targetVelocity.mult(targetSpeed);

    PVector acceleration = targetVelocity.sub(velocity);

    // avoid obstacles
    for (Obstacle o : obstacles) { 
      avoidThingAtPosition(o.position, acceleration, AVOID_FORCE, AVOID_RADIUS);
    }
    
    // avoid other enemies
    for (Enemy e : enemies) { 
      if (e.equals(this)) {
        continue;
      }
      avoidThingAtPosition(e.position, acceleration, CLUSTER_FORCE, CLUSTER_RADIUS);
    }

    if (acceleration.mag() > MAX_ACCELERATION) {
      acceleration.normalize();
      acceleration.mult(MAX_ACCELERATION);
    }

    for (int wp : whiskerResults) {
      switch (wp) {
        case Room.LEFT:
          acceleration.add(new PVector(-WALL_AVOID_FORCE, 0));
          break;
        case Room.RIGHT:
          acceleration.add(new PVector(WALL_AVOID_FORCE, 0));
          break;
        case Room.BOT:
          acceleration.add(new PVector(0, WALL_AVOID_FORCE));
          break;
        case Room.TOP:
          acceleration.add(new PVector(0, -WALL_AVOID_FORCE));
          break;
        case Room.TOPLEFT:
          acceleration.add(new PVector(-WALL_AVOID_FORCE, -WALL_AVOID_FORCE));
          break;
        case Room.TOPRIGHT:
          acceleration.add(new PVector(WALL_AVOID_FORCE, -WALL_AVOID_FORCE));
          break;
        case Room.BOTLEFT:
          acceleration.add(new PVector(-WALL_AVOID_FORCE, WALL_AVOID_FORCE));
          break;
        case Room.BOTRIGHT:
          acceleration.add(new PVector(WALL_AVOID_FORCE, WALL_AVOID_FORCE));
          break;
      }
    }

    if (acceleration.mag() > MAX_ACCELERATION) {
      acceleration.normalize();
      acceleration.mult(MAX_ACCELERATION);
    }

    velocity = velocity.add(acceleration);
    return PVector.add(position, velocity);
  }
  
  void avoidThingAtPosition(PVector pos, PVector acceleration, float force, int radius) {
    PVector dir = PVector.sub(this.position, pos);
    float distance = dir.mag();
    if (distance < radius) {
      float repulsionStrength = min(force / (distance * distance), MAX_ACCELERATION);
      dir.normalize();
      acceleration.add(dir.mult(repulsionStrength));
    }
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
