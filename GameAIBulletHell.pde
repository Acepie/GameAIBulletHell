Dungeon dungeon;
ArrayList<Enemy> enemies;
Player player; 
final int ENEMIESTOSPAWN = 3;
final float GRAVITYSTRENGTH = .02;

// Initialize game state
void init() {
  dungeon = new Dungeon();
  enemies = new ArrayList<Enemy>();
  for (int i = 0; i < ENEMIESTOSPAWN; ++i) {
    PVector spawnloc = dungeon.getRandomTile();
    enemies.add(new Enemy(spawnloc));
  }
  player = new Player(Dungeon.TOTALSIZE / 2, Dungeon.TOTALSIZE / 2);
}

void settings() {
  size(Dungeon.TOTALSIZE, Dungeon.TOTALSIZE);
  init();
}

void draw() {  
  // Update enemy states
  ArrayList<Enemy> dead = new ArrayList<Enemy>();
  for (Enemy enemy : enemies) {
    enemy.update(player.position, dungeon.obstacles, enemies);
    follow_player(enemy);
    if (player.position.dist(enemy.position) < Player.SIZE + Enemy.SIZE) {
      player.loseHealth(enemy.getDamage());
    }
    
    take_damage_from_obstacles(enemy.position, enemy.health);
    if (enemy.isDead()) dead.add(enemy);
  }
  enemies.removeAll(dead);

  // Update player
  move_player();
  take_damage_from_obstacles(player.position, player.health);
  applyGravity(player.position, player.velocity);

  // Drawing
  background(#000000);
  dungeon.draw();
  player.draw();
  for (Enemy enemy : enemies) {
    enemy.draw();
  }
}

// Attempts to apply player movement
void move_player() {
  if (dungeon.canMove(player.position, player.getNextPosition())) {
    player.move();
  }
}

// Applies gravity to velocity and resets z position to floor if appropriate
void applyGravity(PVector position, PVector velocity) {
  velocity.z -= GRAVITYSTRENGTH;
  if (position.z <= 0 && !dungeon.overPit(position)) {
    position.z = 0;
  } else if (position.z <= 0) {
    init();
  }
}

// Apply damage to target healthpool when too close to obstacles
void take_damage_from_obstacles(PVector position, Health health) {
  for (Obstacle o : dungeon.obstacles) {
    if (o.collision(position, Enemy.SIZE)) {
      health.loseHealth(o.getDamage());
    }
  }
}

// Generates the path the enemy should follow if necessary
void follow_player(Enemy enemy) {
  Tile t = dungeon.getNearestTile(player.position.x, player.position.y);
  Tile start = dungeon.getNearestTile(enemy.position.x, enemy.position.y);

  ArrayList<PVector> path = dungeon.pathTo(start, t);
  if (!path.isEmpty()) {
    path.remove(path.size() - 1); // last tile is not needed since player is there
  }
  enemy.setPath(path);
}

void keyPressed() {
  // TODO: delete random room generator for final game
  if (key == 'r') {
    init();
  } else if (key == ' ') {
    player.jump();
  } else if (key == CODED) {
    player.arrowDown(keyCode);
  }
}

void keyReleased() {
  if (key == CODED) {
    player.arrowUp(keyCode);
  }
}
