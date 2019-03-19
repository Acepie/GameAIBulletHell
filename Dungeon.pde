import java.util.Random;
import java.util.PriorityQueue;

// Represents game dungeon with several different rooms
public class Dungeon {
  public static final int DUNGEONSIZE = 7;
  public static final int TILESIZE = 100;
  public static final int TOTALSIZE = DUNGEONSIZE * TILESIZE;
  public static final int OBSTACLEGAP = TILESIZE / 3;
  final int CENTER = DUNGEONSIZE / 2;
  final int MAXDEPTH = DUNGEONSIZE;
  final float ROOMRATE = .8;
  final float BREAKRATE = .3;
  final float OBSTACLERATE = .5;
  final int OBSTACLELIMIT = 4;
  Random rng = new Random(); 

  Room[][] rooms;
  ArrayList<Obstacle> obstacles;

  public Dungeon() {
    rooms = new Room[DUNGEONSIZE][DUNGEONSIZE];
    obstacles = new ArrayList<Obstacle>();
    generateRooms(CENTER, CENTER, 0, 0);
    generateObstacles();
    breakWalls();
  }

  // Draws the dungeon
  public void draw() {
    background(#000000);
    strokeWeight(1);
    
    // Draw the rooms
    for (int x = 0; x < DUNGEONSIZE; ++x) {
      for (int y = 0; y < DUNGEONSIZE; ++y) {
        Room r = rooms[x][y];

        if (r != null) {
          r.draw(x, y, TILESIZE);
        }
      }
    }
    
    // Draw the obstacles
    for (Obstacle o : obstacles) {
      o.draw();
    }
  }

  // Gets the tile at the given x y coordinate
  public Tile getNearestTile(double x, double y) {
    return new Tile((int) (x / TILESIZE), (int) (y / TILESIZE));
  }
  
  // Gets the room at the given x y coordinate
  public Room getNearestRoom(double x, double y) {
    return rooms[(int) (x / TILESIZE)][(int) (y / TILESIZE)];
  }
  
  // Determines if moving from one position to another is possible
  boolean canMove(PVector from, PVector to) {
    if (outOfBounds(to.x, to.y)) return false;
    
    Tile current = getNearestTile(from.x, from.y);
    Tile next = getNearestTile(to.x, to.y);

    if (getNearestRoom(from.x, from.y) == null || getNearestRoom(to.x, to.y) == null) return false;
    
    return current.equals(next) || (getNearestRoom(from.x, from.y).doors[determineDirection(current, next)]);
  }

  // Uses A* to compute path from start to end through dungeon
  public ArrayList<PVector> pathTo(Tile start, Tile end) {
    PriorityQueue<TileNode> worklist = new PriorityQueue<TileNode>();

    HashMap<Tile, TileNode> soFar = new HashMap<Tile, TileNode>();
    soFar.put(start, new TileNode(start, 0.0, null));

    worklist.add(new TileNode(start, start.distance(end), null));
    while(!worklist.isEmpty()) {
      TileNode cur = worklist.poll();
      Tile t = cur.t;

      if (cur.prev != null) {
        double realCost = soFar.get(cur.prev).cost + t.distance(cur.prev);
        if (soFar.get(t) == null || (soFar.get(t).cost > realCost)) {
          soFar.put(t, new TileNode(t, realCost, cur.prev));
        } else {
          continue;
        }
      }

      if (t.equals(end)) {
        return pathFromCosts(soFar, t);
      }

      Room r = rooms[t.x][t.y];
      for (int i = 0; i < 4; ++i) {
        if (r != null && r.doors[i]) { // TODO double check this r != null thing
          Tile next = nextRoom(t.x, t.y, i);
          worklist.add(new TileNode(next, cur.cost + next.distance(end), t));
        }
      }
    }

    return new ArrayList<PVector>();
  }

  // Gets the position at the center of a random tile
  public PVector getRandomTile() {
    Tile t = new Tile(rng.nextInt(DUNGEONSIZE), rng.nextInt(DUNGEONSIZE));
    while (rooms[t.x][t.y] == null) {
      t = new Tile(rng.nextInt(DUNGEONSIZE), rng.nextInt(DUNGEONSIZE));
    }
    return tileToPosition(t);
  }

  // Creates a room at the given location and attempts to randomly expand neighbors
  void generateRooms(int x, int y, int depth, int prev) {
    Room r = new Room();

    rooms[x][y] = r;
    if (depth != 0) {
      r.doors[prev] = true;
    }

    for (int i = 0; i < 4; ++i) {
      if (i == prev && depth != 0) {
        continue;
      }

      Tile newRoomCoord = nextRoom(x, y, i);
      if (outOfBounds(newRoomCoord)) {
        continue;
      }

      Room newRoom = rooms[newRoomCoord.x][newRoomCoord.y];
      if (newRoom != null || depth + 1 > MAXDEPTH) {
        continue;
      } else if (rng.nextFloat() < ROOMRATE) {
        int rev = inverseDir(i);
        r.doors[i] = true;
        generateRooms(newRoomCoord.x, newRoomCoord.y, depth + 1, rev);
      }
    }
  }

  // Randomly breaks down walls
  void breakWalls() {
    for (int x = 0; x < DUNGEONSIZE - 1; ++x) {
      for (int y = 0; y < DUNGEONSIZE - 1; ++y) {
        Room r = rooms[x][y];
        if (r == null) {
          continue;
        }

        if (!r.doors[Room.RIGHT] && rooms[x + 1][y] != null && rng.nextFloat() < BREAKRATE) {
          r.doors[Room.RIGHT] = true;
          rooms[x + 1][y].doors[Room.LEFT] = true;
        }

        if (!r.doors[Room.BOT] && rooms[x][y + 1] != null && rng.nextFloat() < BREAKRATE) {
          r.doors[Room.BOT] = true;
          rooms[x][y + 1].doors[Room.TOP] = true;
        }
      }
    }
  }
  
  // Creates obstacles in random rooms in the dungeon 
  void generateObstacles() {
    for (int x = 0; x < DUNGEONSIZE; ++x) {
      for (int y = 0; y < DUNGEONSIZE; ++y) {
        if (rooms[x][y] != null && rng.nextFloat() < OBSTACLERATE) {
          PVector pos = indexToTopLeft(x, y);
          int obstacle_count = rng.nextInt(OBSTACLELIMIT);
          for (int o = 0; o < obstacle_count; ++o) {
            int x_offset = rng.nextInt(TILESIZE);
            int y_offset = rng.nextInt(TILESIZE);
            obstacles.add(new Obstacle(pos.x + x_offset, pos.y + y_offset));
          }
        }
      }
    }
  }
  
  // ASSUME: the two tiles are adjacent and not identical
  int determineDirection(Tile from, Tile to) {
    if (from.x == to.x && from.y < to.y) return Room.BOT;   // ↓
    if (from.x < to.x && from.y < to.y) return Room.BOT;    // ↘
    if (from.x == to.x && from.y > to.y) return Room.TOP;   // ↑
    if (from.x > to.x && from.y > to.y) return Room.TOP;    // ↖   
    if (from.x < to.x && from.y == to.y) return Room.RIGHT; // →
    if (from.x < to.x && from.y > to.y) return Room.RIGHT;  // ↗
    if (from.x > to.x && from.y == to.y) return Room.LEFT;  // ←
    if (from.x > to.x && from.y < to.y) return Room.LEFT;   // ↙
    return -1;
  }

  // Given a direction finds the inverse direction
  int inverseDir(int dir) {
    switch (dir) {
      case Room.LEFT:
        return Room.RIGHT;
      case Room.RIGHT:
        return Room.LEFT;
      case Room.BOT:
        return Room.TOP;
      default:
        return Room.BOT;
    }
  }

  // Gets the room next to the given one in the given direction
  Tile nextRoom(int x, int y, int dir) {
    Tile res = new Tile(x, y);
    switch (dir) {
      case Room.LEFT:
        res.x = x - 1;
        break;
      case Room.RIGHT:
        res.x = x + 1;
        break;
      case Room.TOP:
        res.y = y - 1;
        break;
      case Room.BOT:
        res.y = y + 1;
        break;
    }

    return res;
  }

  // Checks a room is out of bounds
  boolean outOfBounds(Tile room) {
    return room.x < 0 || room.x >= DUNGEONSIZE || room.y < 0 || room.y >= DUNGEONSIZE;
  }
  
  // Checks if a coordinate is out of bounds
  boolean outOfBounds(float x, float y) {
    return x < 0 || x >= TOTALSIZE || y < 0 || y >= TOTALSIZE;
  }

  // Compute path to end based backtracking using costs so far
  ArrayList<PVector> pathFromCosts(HashMap<Tile, TileNode> soFar, Tile end) {
    ArrayList<PVector> path = new ArrayList<PVector>();
    TileNode curNode = soFar.get(end);
    while (curNode.prev != null) {
      path.add(0, tileToPosition(curNode.t));
      curNode = soFar.get(curNode.prev);
    }

    return path;
  }

  // Converts from tile position to map position
  PVector tileToPosition(Tile t) {
    return new PVector(t.x * TILESIZE + TILESIZE / 2, t.y * TILESIZE + TILESIZE / 2);
  }
  
  PVector indexToTopLeft(int x, int y) {
    return new PVector(x * TILESIZE, y * TILESIZE);
  }
}
