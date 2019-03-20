// Data class representing a rooms with doors on each side
public class Room {
  public static final int LEFT = 0;
  public static final int RIGHT = 1;
  public static final int TOP = 2;
  public static final int BOT = 3;
  public static final int TOPLEFT = 4;
  public static final int TOPRIGHT = 5;
  public static final int BOTLEFT = 6;
  public static final int BOTRIGHT = 7;
  
  boolean[] doors;

  public Room () {
    doors = new boolean[8];
    for (int i = 0; i < 8; ++i) {
      doors[i] = false;
    }
  }
  
  public void draw(int x, int y, int size) {
    int top = y * size;
    int bot = (y + 1) * size;
    int left = x * size;
    int right = (x + 1) * size;
    
    fill(#FFFFFF);
    stroke(#FFFFFF);
    rect(left, top, size, size);
    
    stroke(#FF0000);
    strokeWeight(2);
    if (!this.doors[Room.LEFT]) {
      line(left, top, left, bot);
    }
    if (!this.doors[Room.RIGHT]) {
      line(right, top, right, bot);
    }
    if (!this.doors[Room.TOP]) {
      line(left, top, right, top);
    }
    if (!this.doors[Room.BOT]) {
      line(left, bot, right, bot);
    }
  }
}
