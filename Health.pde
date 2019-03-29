public class Health {
  final int INVULNERABILITY = 100;
  
  private float health;
  private int last_hit;
  
  public Health(float max_health) {
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
