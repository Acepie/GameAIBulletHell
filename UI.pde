public class UI {
  Health health;
  
  public UI(Health health) {
    this.health = health;
  }
  
  public void draw() {
    fill(127);
    textSize(14);
    text("HP", 10, 22);
    rect(35, 12, health.health, 10);
  }
}
