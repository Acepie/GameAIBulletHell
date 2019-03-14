public class Player {
  final int SIZE = 10;
  final int MAX_SPEED = 3;
  
  PVector position;
  
  public Player(int x, int y) {
    position = new PVector(x, y);
  }
  
  public void move(int key_code) {
    switch(key_code) {
      case UP:
        position = new PVector(position.x, position.y - MAX_SPEED);
        break;
      case DOWN:
        position = new PVector(position.x, position.y + MAX_SPEED);
        break;
      case LEFT:
        position = new PVector(position.x - MAX_SPEED, position.y);
        break;
      case RIGHT:
        position = new PVector(position.x + MAX_SPEED, position.y);
        break;
      default:
        return;
    }
  }
  
  public void draw() {
    fill(#0000ff);
    ellipse(position.x, position.y, SIZE, SIZE);
  }
}
