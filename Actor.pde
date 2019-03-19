public class Actor {
  final int INVULNERABILITY = 1000;
  
  private float health;
  private int last_hit;
  
  
  public Actor(float max_health) {
    this.health = max_health;
    this.last_hit = 0;
  }
  
  public boolean isInvulnerable() {
    return last_hit + INVULNERABILITY > millis();
  }
  
  public void loseHealth(float damage) {
    if (!isInvulnerable()) {
      health = health - damage < 0 ? 0 : health - damage;
      last_hit = millis();  
    }
  }
  
  public boolean isDead() {
    return health == 0;
  }
}