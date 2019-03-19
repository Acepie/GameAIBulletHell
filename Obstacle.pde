public class Obstacle {
  public static final int SIZE = 6;
  public static final int DAMAGE = 10; // how much damage this obstacle deals
  
  PVector position;
  
  public Obstacle(float x, float y) {
    position = new PVector(x, y);
  }
  
  public void draw() {
    fill(#f4424b);
    stroke(#f4424b);
    circle(position.x, position.y, SIZE);
  }
}
