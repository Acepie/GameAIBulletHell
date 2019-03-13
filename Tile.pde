// Data class representing a tile in a grid
public class Tile {
  public int x;
  public int y;

  public Tile (int x, int y) {
    this.x = x;
    this.y = y;
  }

  public double distance(Tile other) {
    return Math.sqrt(Math.pow(x - other.x, 2) + Math.pow(y - other.y, 2));
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    Tile other = (Tile) o;
    return other.x == x && other.y == y;
  }

  @Override
  public int hashCode() {
    int result = 7;
    result = 31 * result + x;
    result = 31 * result + y;
    return result;
  }
}
