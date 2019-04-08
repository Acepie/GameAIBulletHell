Dungeon dungeon;
ArrayList<Bullet> bullets;
ArrayList<Enemy> enemies;
Player player; 
UI ui;
Score score;
boolean playerInPit;

final int ENEMIESTOSPAWN = 3;
final static float GRAVITYSTRENGTH = .02;

// Initialize game state
void init() {
  dungeon = new Dungeon();
  bullets = new ArrayList<Bullet>();
  player = new Player(Dungeon.TOTALSIZE / 2, Dungeon.TOTALSIZE / 2);
  playerInPit = false;  
  spawnEnemies();
  score = new Score();
  ui = new UI(player.health, score);
}

void spawnEnemies() {
  enemies = new ArrayList<Enemy>();
  for (int i = 0; i < ENEMIESTOSPAWN; ++i) {
    Blackboard b = new Blackboard();
    Task t = new TaskSequence(b, new Task[]{

      // Support allies attacking player (disabled because too strong)
      // new TaskSupportAllies(b),
      // Check for player
      new TaskTrue(b, new TaskSequence(b, new Task[]{
        new TaskInRangeOfPlayer(b, dungeon),
        new TaskSpotPlayer(b)
      })),
      // Get current path
      new TaskTrue(b, new TaskSelector(b, new Task[]{
        new TaskSequence(b, new Task[] {
          new TaskSpottedPlayer(b),
          new TaskUpdatePath(b, dungeon)
        }),
        new TaskSequence(b, new Task[] {
          new TaskSelector(b, new Task[]{
            new TaskNot(b, new TaskHasPath(b)),
            new TaskPathStale(b)
          }),
          new TaskRandomPath(b, dungeon)
        })
      })),
      // Move
      new TaskTrue(b, new TaskSelector(b, new Task[]{
        new TaskSequence(b, new Task[]{
          new TaskInAir(b),
          new TaskAirMovement(b, dungeon)
        }),
        new TaskSequence(b, new Task[]{
          new TaskHasPath(b),
          new TaskFollowPath(b, dungeon)
        }),
        new TaskSequence(b, new Task[]{
          new TaskSpottedPlayer(b),
          new TaskFollowPlayer(b, dungeon)
        })
      })),
      // Fire bullets
      new TaskSequence(b, new Task[]{
        new TaskInRangeOfPlayer(b, dungeon),
        new TaskIsFacingPlayer(b),
        new TaskFireBullet(b)
      })
    });
    PVector spawnloc = dungeon.getRandomTile();
    // Don't spawn too close to player
    while (spawnloc.dist(player.position) < Dungeon.TILESIZE) {
      spawnloc = dungeon.getRandomTile();
    }
    enemies.add(new Enemy(spawnloc, t, b));
  }
  
  for (Enemy e : enemies) {
    e.bb.put("enemies", enemies);
    e.bb.put("enemy", e);
    e.bb.put("player", player);
    e.bb.put("bullets", bullets);
    e.bb.put("spottedPlayer", false);
    e.bb.put("lastPathUpdate", millis());
  }
}

void settings() {
  size(Dungeon.TOTALSIZE, Dungeon.TOTALSIZE);
  init();
}

void draw() {
  if (isGameOver()) {
    drawGameOver();
  } else if (enemies.size() == 0) {
    dungeon = new Dungeon();
    spawnEnemies();
    player.position = new PVector(Dungeon.TOTALSIZE / 2, Dungeon.TOTALSIZE / 2);
    player.health.healToFull();
  } else {
    drawGame();
  }
}

boolean isGameOver() {
  return player.isDead() || playerInPit;
}  

void drawGameOver() {
  ui.gameOverScreen();
}

void drawGame() {  
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
      score.add(enemy.getPoints());
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
    playerInPit = true;
  }
  if (mousePressed) {
    player.updateBulletDirection(mouseX, mouseY);
    if (player.canShoot()) {
      bullets.add(player.shoot());
    }
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

// Applies gravity to velocity and resets z position to floor if appropriate. Returns true if object fell into pit.
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

void keyPressed() {
  if (key == 'r') {
    init();
  } else if (key == ' ') {
    player.jump();
  } else if (key == CODED && keyCode == SHIFT && player.canShoot()) {
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

void mouseMoved() {
  player.updateBulletDirection(mouseX, mouseY);
}
