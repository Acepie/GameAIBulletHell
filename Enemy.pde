public class Enemy {
  final int SIZE = 10;
  PVector position;

  ArrayList<PVector> path;

  public Enemy (int x, int y) {
    position = new PVector(x, y);
    this.path = new ArrayList<PVector>();
  }

  public void setPath(ArrayList<PVector> path) {
    this.path = path;
  }

  public void draw() {
    fill(#00FF00);
    stroke(#FFFFFF);
    for (PVector t : path) {
      ellipse(t.x, t.y, SIZE, SIZE);
    }

    fill(#222222);
    stroke(#000000);
    ellipse(position.x, position.y, SIZE, SIZE);
  }

  public void update() {
    if (!path.isEmpty()) {
      PVector next = path.get(0);
      if (position.dist(next) < 1) {
        path.remove(0);
      } else {
        PVector diff = PVector.sub(next, position);
        if (diff.x != 0) {
          position.x += diff.x / abs(diff.x);
        }
        if (diff.y != 0) {
          position.y += diff.y / abs(diff.y);
        }
      }
    }
  }
}
