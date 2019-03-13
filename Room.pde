// Data class representing a rooms with doors on each side
public class Room {

  boolean[] doors;

  public Room () {
    doors = new boolean[4];
    for (int i = 0; i < 4; ++i) {
      doors[i] = false;
    }
  }
}
