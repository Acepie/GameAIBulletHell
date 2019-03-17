public class Player {
  final int SIZE = 10;
  final int MAX_SPEED = 10;
  
  PVector position;
  
  public Player(int x, int y) {
    this.position = new PVector(x, y);
  }
  
  // move this player in the given direction
  public void move(int key_code) {
    this.position = getNextPosition(key_code);
  }
  
  // calculate where this player would be if it moved in the given direction
  public PVector getNextPosition(int key_code) {
    switch(key_code) {
      case UP:
        return new PVector(position.x, position.y - MAX_SPEED);
      case DOWN:
        return new PVector(position.x, position.y + MAX_SPEED);
      case LEFT:
        return new PVector(position.x - MAX_SPEED, position.y);
      case RIGHT:
        return new PVector(position.x + MAX_SPEED, position.y);
      default:
        return this.position.copy();
    }
  }
  
  public void draw() {
    fill(#0000ff);
    ellipse(position.x, position.y, SIZE, SIZE);
  }
}
