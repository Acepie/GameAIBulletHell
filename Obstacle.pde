public class Obstacle {
  public static final int SIZE = 6;
  final int damage = 10; // how much damage this obstacle deals
  
  PVector position;
  
  public Obstacle(PVector pos) {
    position = pos.copy();
  }
  
  public Obstacle(float x, float y) {
    position = new PVector(x, y);
  }
  
  public boolean collidesWith(PVector other, float size) {
    return dist(position.x, position.y, other.x, other.y) < size / 2 + SIZE / 2;
  }
  
  public int getDamage() {
    return this.damage;
  }
  
  public void draw() {
    fill(#f4424b);
    stroke(#f4424b);
    circle(position.x, position.y, SIZE);
    int d = 4;
    int p = 5;
    line(position.x - d, position.y - d, position.x + d, position.y + d);
    line(position.x - d,  position.y + d, position.x + d, position.y - d);
    line(position.x,  position.y - p, position.x, position.y + 5);
    line(position.x - p,  position.y, position.x + p, position.y);
  }
}
