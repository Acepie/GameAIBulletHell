public class Room {

  boolean[] doors;

  public Room () {
    doors = new boolean[4];
    for (int i = 0; i < 4; ++i) {
      doors[i] = false;
    }
  }
}
