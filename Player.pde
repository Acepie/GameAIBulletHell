public class Player {
  public static final int SIZE = 10;
  final int MAX_SPEED = 4;
  final float ACCELERATION = MAX_SPEED / 6.0;
  final int MAX_HEALTH = 100;
  final float JUMP_POW = .2;
  final int BULLET_RATE = 120; // # milliseconds between each shot

  PVector position;
  PVector bulletDirection;
  PVector velocity;
  PVector acceleration;
  Health health;
  private int last_bullet;

  public Player(int x, int y) {
    this.position = new PVector(x, y);
    this.bulletDirection = new PVector(1, 0);
    this.velocity = new PVector(0, 0);
    this.acceleration = new PVector(0, 0);
    this.health = new Health(MAX_HEALTH);
    this.last_bullet = 0;
  }

  public boolean canShoot() {
    return last_bullet + BULLET_RATE <= millis();
  }

  public Bullet shoot() {
    this.last_bullet = millis();
    return new Bullet(position.copy(), bulletDirection.copy(), true);
  }

  public void loseHealth(float damage) {
    this.health.loseHealth(damage);
  }

  boolean isInvulnerable() {
    return this.health.isInvulnerable();
  }

  boolean collidesWith(PVector position, int size) {
    // can only collide while on the ground
    return player.position.z == 0 && player.position.dist(position) < Player.SIZE / 2 + size / 2;
  }

  public boolean isDead() {
    return this.health.isDead();
  }

  // move this player based on current velocity
  public void move() {
    position.add(velocity);
  }

  // Updates velocity based on acceleration
  public void updateVelocity() {
    PVector newVelocity = PVector.add(velocity, acceleration);
    newVelocity.z = 0;
    newVelocity.limit(MAX_SPEED);
    velocity.x = newVelocity.x;
    velocity.y = newVelocity.y;
  }

  // calculate where the front of this player would be if they moved according to their velocity
  public PVector getNextPosition() {
    PVector facing = velocity.copy().normalize().mult(SIZE / 2);
    return PVector.add(position, velocity).add(facing);
  }

  // Attempt to jump
  public void jump() {
    if (position.z == 0 && velocity.z <= 0) {
      velocity.z = JUMP_POW;
    }
  }

  // Updates player acceleration based on keys pressed
  public void arrowDown(int key_code) {    
    switch(key_code) {
    case UP:
      acceleration.y = -ACCELERATION;
      break;
    case DOWN:
      acceleration.y = ACCELERATION;
      break;
    case LEFT:
      acceleration.x = -ACCELERATION;
      break;
    case RIGHT:
      acceleration.x = ACCELERATION;
      break;
    }
  }

  // Updates player acceleration based on keys released
  public void arrowUp(int key_code) {
    switch(key_code) {
    case UP:
    case DOWN:
      acceleration.y = 0;
      velocity.y = 0;
      break;
    case LEFT:
    case RIGHT:
      acceleration.x = 0;
      velocity.x = 0;
      break;
    }
  }


  // Updates player acceleration based on keys pressed
  public void arrowDown(char key) {    
    switch(key) {
    case 'w':
      acceleration.y = -ACCELERATION;
      break;
    case 's':
      acceleration.y = ACCELERATION;
      break;
    case 'a':
      acceleration.x = -ACCELERATION;
      break;
    case 'd':
      acceleration.x = ACCELERATION;
      break;
    }
  }

  // Updates player acceleration based on keys released
  public void arrowUp(char key) {
    switch(key) {
    case 'w':
    case 's':
      acceleration.y = 0;
      velocity.y = 0;
      break;
    case 'a':
    case 'd':
      acceleration.x = 0;
      velocity.x = 0;
      break;
    }
  }

  public void draw() {
    if (isDead()) {
      fill(#000000);
    } else if (isInvulnerable()) {
      fill(#4c4cff);
    } else {
      fill(#0000ff);
    }

    stroke(#000000);
    float sizeToDraw = max(pow(SIZE, 1.0 + position.z / 4), SIZE / 2.0);
    ellipse(position.x, position.y, sizeToDraw, sizeToDraw);
  }

  void updateBulletDirection(int x, int y) {
    bulletDirection = new PVector(x - position.x, y - position.y);
  }
}
