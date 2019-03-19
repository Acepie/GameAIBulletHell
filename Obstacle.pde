public class Obstacle {
  public static final int SIZE = 6;
  final int damage = 10; // how much damage this obstacle deals
  
  PVector position;
  
  public Obstacle(float x, float y) {
    position = new PVector(x, y);
  }
  
  public boolean collision(PVector other, float radius) {
    return dist(position.x, position.y, other.x, other.y) < radius + SIZE;
  }
  
  public int getDamage() {
    return this.damage;
  }
  
  public void draw() {
    fill(#f4424b);
    stroke(#f4424b);
    circle(position.x, position.y, SIZE);
  }
}
