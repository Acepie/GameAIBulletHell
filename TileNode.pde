public class TileNode implements Comparable<TileNode> {
  Tile t;
  double cost;
  Tile prev;

  public TileNode (Tile t, double cost, Tile prev) {
    this.t = t;
    this.cost = cost;
    this.prev = prev;
  }

  int compareTo(TileNode other) {
    return (int) (cost - other.cost);
  }
}
