public class Pit {
  public PVector position;
  public int size;

  public Pit (PVector position, int size) {
    this.position = position;
    this.size = size;
  }

  public void draw() {
    noStroke();
    fill(150);
    circle(position.x - 2, position.y - 2, size + 1);
    fill(60);
    circle(position.x - 1, position.y - 1, size + 1);
    fill(0);
    circle(position.x, position.y, size);
  }
}
