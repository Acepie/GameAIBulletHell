class Bullet {
  static final int TTL = 20;
  static final int SIZE = 6;
  static final float SPEED = 5;
  static final int PLAYER_DAMAGE = 10;
  static final int ENEMY_DAMAGE = 5;
  
  PVector position;
  PVector direction;
  boolean belongsToPlayer;
  int timeAlive;
  
  public Bullet(PVector position, PVector direction, boolean belongsToPlayer) {
    this.position = position;
    this.direction = direction.normalize();
    this.belongsToPlayer = belongsToPlayer;
    this.timeAlive = 0;
  }
  
  int getDamage() {
    return belongsToPlayer ? PLAYER_DAMAGE : ENEMY_DAMAGE;
  }
  
  boolean isExpired() {
    return timeAlive >= TTL;
  }

  boolean collidesWith(PVector position, int size) {
    return this.position.dist(position) < SIZE / 2 + size / 2;
  }
  
  PVector getNextPosition() {
    return PVector.add(position, PVector.mult(this.direction, SPEED));
  }

  void update() {
    this.position = getNextPosition();
    this.timeAlive++;
  }
      
  void draw() {
    noStroke();
    if (belongsToPlayer) {
      fill(#3030ff);
    } else {
      fill(#000000);
    }
    circle(position.x, position.y, SIZE);
  }
}
