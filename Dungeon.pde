import java.util.Random;

public class Dungeon {
  public static final int DUNGEONSIZE = 7;
  public static final int TILESIZE = 130;
  public static final int TOTALSIZE = DUNGEONSIZE * TILESIZE;
  final int CENTER = DUNGEONSIZE / 2;
  final int MAXDEPTH = DUNGEONSIZE;
  final int LEFT = 0;
  final int RIGHT = 1;
  final int TOP = 2;
  final int BOT = 3;
  final float ROOMRATE = .8;
  final float BREAKRATE = .3;
  Random rng = new Random(); 

  Room[][] dungeon;

  public Dungeon() {
    dungeon = new Room[DUNGEONSIZE][DUNGEONSIZE];
    generateRooms(CENTER, CENTER, 0, 0);
    breakWalls();
  }

  // Draws the dungeon
  public void draw() {
    background(#000000);
    strokeWeight(1);
    
    for (int x = 0; x < DUNGEONSIZE; ++x) {
      for (int y = 0; y < DUNGEONSIZE; ++y) {
        int top = y * TILESIZE;
        int bot = (y + 1) * TILESIZE;
        int left = x * TILESIZE;
        int right = (x + 1) * TILESIZE;

        Room r = dungeon[x][y];

        if (r != null) {
          fill(#FFFFFF);
          stroke(#FFFFFF);
          rect(left, top, TILESIZE, TILESIZE);
          
          stroke(#FF0000);
          strokeWeight(2);
          if (!r.doors[LEFT]) {
            line(left, top, left, bot);
          }
          if (!r.doors[RIGHT]) {
            line(right, top, right, bot);
          }
          if (!r.doors[TOP]) {
            line(left, top, right, top);
          }
          if (!r.doors[BOT]) {
            line(left, bot, right, bot);
          }
        }
      }
    }
  }

  // Creates a room at the given location and attempts to randomly expand neighbors
  void generateRooms(int x, int y, int depth, int prev) {
    Room r = new Room();

    dungeon[x][y] = r;
    if (depth != 0) {
      r.doors[prev] = true;
    }

    for (int i = 0; i < 4; ++i) {
      if (i == prev && depth != 0) {
        continue;
      }

      PVector newRoomCoord = nextRoom(x, y, i);
      if (outOfBounds(newRoomCoord)) {
        continue;
      }

      Room newRoom = dungeon[(int) newRoomCoord.x][(int) newRoomCoord.y];
      if (newRoom != null || depth + 1 > MAXDEPTH) {
        continue;
      } else if (rng.nextFloat() < ROOMRATE) {
        int rev = inverseDir(i);
        r.doors[i] = true;
        generateRooms((int) newRoomCoord.x, (int) newRoomCoord.y, depth + 1, rev);
      }
    }
  }

  // Randomly breaks down walls
  void breakWalls() {
    for (int x = 0; x < DUNGEONSIZE - 1; ++x) {
      for (int y = 0; y < DUNGEONSIZE - 1; ++y) {
        Room r = dungeon[x][y];
        if (r == null) {
          continue;
        }

        if (!r.doors[RIGHT] && dungeon[x + 1][y] != null && rng.nextFloat() < BREAKRATE) {
          r.doors[RIGHT] = true;
          dungeon[x + 1][y].doors[LEFT] = true;
        }

        if (!r.doors[BOT] && dungeon[x][y + 1] != null && rng.nextFloat() < BREAKRATE) {
          r.doors[BOT] = true;
          dungeon[x][y + 1].doors[TOP] = true;
        }
      }
    }
  }

  // Given a direction finds the inverse direction
  int inverseDir(int dir) {
    switch (dir) {
      case LEFT:
        return RIGHT;
      case RIGHT:
        return LEFT;
      case BOT:
        return TOP;
      default:
        return BOT;
    }
  }

  // Gets the room next to the given one in the given direction
  PVector nextRoom(int x, int y, int dir) {
    PVector res = new PVector(x, y);
    switch (dir) {
      case LEFT:
        res.x = x - 1;
        break;
      case RIGHT:
        res.x = x + 1;
        break;
      case TOP:
        res.y = y - 1;
        break;
      case BOT:
        res.y = y + 1;
        break;
    }

    return res;
  }

  // Checks a room is out of bounds
  boolean outOfBounds(PVector room) {
    return room.x < 0 || room.x >= DUNGEONSIZE || room.y < 0 || room.y >= DUNGEONSIZE;
  }
}
