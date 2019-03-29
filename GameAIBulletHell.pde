Dungeon dungeon;
ArrayList<Bullet> bullets;
ArrayList<Enemy> enemies;
Player player; 
UI ui;
final int ENEMIESTOSPAWN = 3;
final static float GRAVITYSTRENGTH = .02;

// Initialize game state
void init() {
  dungeon = new Dungeon();
  bullets = new ArrayList<Bullet>();
  player = new Player(Dungeon.TOTALSIZE / 2, Dungeon.TOTALSIZE / 2);
  enemies = new ArrayList<Enemy>();
  for (int i = 0; i < ENEMIESTOSPAWN; ++i) {
    Blackboard b = new Blackboard();
    Task t = new TaskSequence(b, new Task[]{
      new TaskUpdatePath(b, dungeon),
      new TaskSelector(b, new Task[]{
        new TaskSequence(b, new Task[]{
          new TaskInAir(b),
          new TaskAirMovement(b, dungeon)
        }),
        new TaskSequence(b, new Task[]{
          new TaskHasPath(b),
          new TaskFollowPath(b, dungeon)
        }),
        new TaskFollowPlayer(b, dungeon)
      })
    });
    PVector spawnloc = dungeon.getRandomTile();
    enemies.add(new Enemy(spawnloc, t, b));
  }
  for (Enemy e : enemies) {
    e.bb.put("enemies", enemies);
    e.bb.put("enemy", e);
    e.bb.put("player", player);
  }
  ui = new UI(player.health);
}

void settings() {
  size(Dungeon.TOTALSIZE, Dungeon.TOTALSIZE);
  init();
}

void draw() {  
  // Update enemy states
  ArrayList<Enemy> dead = new ArrayList<Enemy>();
  for (Enemy enemy : enemies) {
    enemy.update();
    if (applyGravity(enemy.position, enemy.velocity)) {
      dead.add(enemy);
      continue;
    }
    if (player.collidesWith(enemy.position, Enemy.SIZE)) {
      player.loseHealth(enemy.getDamage());
    }
    takeDamageFromObstacles(enemy.position, Enemy.SIZE, enemy.health);
    if (enemy.isDead()) {
      dead.add(enemy);
    }
  }
  enemies.removeAll(dead);

  // Update bullets
  updateBullets();
  
  // Update player
  movePlayer();
  takeDamageFromObstacles(player.position, Player.SIZE, player.health);
  if (applyGravity(player.position, player.velocity)) {
    init();
  }

  // Drawing
  background(#000000);
  dungeon.draw();
  for (Enemy enemy : enemies) {
    enemy.draw();
  }
  for (Bullet bullet : bullets) {
    bullet.draw();
  }
  player.draw();
  ui.draw();
}

void updateBullets() {
  ArrayList<Bullet> expired = new ArrayList<Bullet>();
  for (Bullet bullet : bullets) {
    if (bullet.isExpired()) {
      expired.add(bullet);
      continue;
    }
    
    // check if bullet collides with walls, player, enemies, obstacles
    boolean collision = !dungeon.canMove(bullet.position, bullet.getNextPosition());
    if (!collision && !bullet.belongsToPlayer && bullet.collidesWith(player.position, Player.SIZE)) {
      player.loseHealth(bullet.getDamage());
    }
    
    if (!collision) {
      for (Enemy e : enemies) {
        if (bullet.belongsToPlayer && bullet.collidesWith(e.position, Enemy.SIZE)) {
          e.loseHealth(bullet.getDamage());
          collision = true;
          break;
        }
      }
    }
    if (!collision) {
      for (Obstacle o : dungeon.obstacles) {
        if (bullet.collidesWith(o.position, Obstacle.SIZE)) {
          collision = true;
          break;
        }
      }
    }
    
    if (!collision) {
      bullet.update();
    } else {
      expired.add(bullet);
    }
  }
  bullets.removeAll(expired);
}

// Attempts to apply player movement
void movePlayer() {
  if (dungeon.canMove(player.position, player.getNextPosition())) {
    player.move();
  } else { // Apply downward velocity but don't pass wall
    player.position.z += player.velocity.z;
  }
}

// Applies gravity to velocity and resets z position to floor if appropriate. Returns if object fell into pit
boolean applyGravity(PVector position, PVector velocity) {
  velocity.z -= GRAVITYSTRENGTH;
  if (position.z <= 0 && !dungeon.overPit(position)) {
    position.z = 0;
  } else if (position.z <= 0) {
    return true;
  }

  return false;
}

// Apply damage to target healthpool when too close to obstacles
void takeDamageFromObstacles(PVector position, float size, Health health) {
  for (Obstacle o : dungeon.obstacles) {
    if (o.collidesWith(position, size)) {
      health.loseHealth(o.getDamage());
    }
  }
}

// Generates the path the enemy should follow if necessary
void followPlayer(Enemy enemy) {
  Tile t = dungeon.getNearestTile(player.position.x, player.position.y);
  Tile start = dungeon.getNearestTile(enemy.position.x, enemy.position.y);

  ArrayList<PVector> path = dungeon.pathTo(start, t);
  if (!path.isEmpty()) {
    path.remove(path.size() - 1); // last tile is not needed since player is there
  }
  enemy.setPath(path);
}

void keyPressed() {
  if (key == 'r') {
    init();
  } else if (key == ' ') {
    player.jump();
  } else if (key == 'x') {
    for (Enemy e : enemies) {
      bullets.add(e.shoot());
    }
  } else if (key == CODED && keyCode == SHIFT) {
    bullets.add(player.shoot());
  } else if (key == CODED) {
    player.arrowDown(keyCode);
  } else if (key == 'w' || key == 'a' || key == 's' || key == 'd' ) {
    player.arrowDown(key);
  }
}

void keyReleased() {
  if (key == CODED) {
    player.arrowUp(keyCode);
  } else if (key == 'w' || key == 'a' || key == 's' || key == 'd' ) {
    player.arrowUp(key);
  }
}
