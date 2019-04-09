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
  public static final color ROOM_COLOR = #cbe3ed;
  public static final color WALL_COLOR = #42aad6;
  
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
    
    fill(ROOM_COLOR);
    stroke(ROOM_COLOR);
    rect(left, top, size, size);
    
    strokeWeight(4);
    stroke(60);
    line(right + 2, top, right + 2, bot);
    line(left + 3, bot + 2, right + 2, bot + 2);
    strokeWeight(3);
    stroke(100);
    line(right + 1, top, right + 1, bot);
    line(left + 2, bot + 1, right + 1, bot + 1);
    
    stroke(WALL_COLOR);
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
