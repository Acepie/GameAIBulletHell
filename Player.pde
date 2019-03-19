public class Player {
  public static final int SIZE = 10;
  final int MAX_SPEED = 5;
  final int MAX_HEALTH = 100;
  
  PVector position;
  PVector velocity;
  Actor actor;
  
  public Player(int x, int y) {
    this.position = new PVector(x, y);
    this.velocity = new PVector(0, 0);
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
  
  // move this player based on current velocity
  public void move() {
    position.add(velocity);
  }
  
  // calculate where this player would be if it moved in the given direction
  public PVector getNextPosition() {
    return PVector.add(position, velocity);
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
  
  public void draw() {
    if (isDead()) {
      fill(#bababa);
    } else if (isInvulnerable()) {
      fill(#4c4cff);
    } else {
      fill(#0000ff);
    }
    
    ellipse(position.x, position.y, SIZE, SIZE);
  }
}
