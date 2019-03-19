public class Pit {
  public PVector position;
  public int size;

  public Pit (PVector position, int size) {
    this.position = position;
    this.size = size;
  }

  public void draw() {
    fill(#000000);
    stroke(#000000);
    circle(position.x, position.y, size);
  }
}
