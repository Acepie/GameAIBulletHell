public class Player {
  public static final int SIZE = 10;
  final int MAX_SPEED = 5;
  final int MAX_HEALTH = 100;
  final float JUMP_POW = .2;
  final int BULLET_RATE = 120; // # milliseconds between each shot

  PVector position;
  PVector bulletDirection;
  PVector velocity;
  Health health;
  private int last_bullet;

  public Player(int x, int y) {
    this.position = new PVector(x, y);
    this.bulletDirection = new PVector(1, 0);
    this.velocity = new PVector(0, 0);
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

  // Updates player velocity based on keys pressed
  public void arrowDown(int key_code) {    
    switch(key_code) {
    case UP:
      velocity.y = -MAX_SPEED;
      break;
    case DOWN:
      velocity.y = MAX_SPEED;
      break;
    case LEFT:
      velocity.x = -MAX_SPEED;
      break;
    case RIGHT:
      velocity.x = MAX_SPEED;
      break;
    }
  }

  // Updates player velocity based on keys released
  public void arrowUp(int key_code) {
    switch(key_code) {
    case UP:
    case DOWN:
      velocity.y = 0;
      break;
    case LEFT:
    case RIGHT:
      velocity.x = 0;
      break;
    }
  }


  // Updates player velocity based on keys pressed
  public void arrowDown(char key) {    
    switch(key) {
    case 'w':
      velocity.y = -MAX_SPEED;
      break;
    case 's':
      velocity.y = MAX_SPEED;
      break;
    case 'a':
      velocity.x = -MAX_SPEED;
      break;
    case 'd':
      velocity.x = MAX_SPEED;
      break;
    }
  }

  // Updates player velocity based on keys released
  public void arrowUp(char key) {
    switch(key) {
    case 'w':
    case 's':
      velocity.y = 0;
      break;
    case 'a':
    case 'd':
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
