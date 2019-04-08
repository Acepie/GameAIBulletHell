public class UI {
  private Health health;
  private Score score;
  
  private final int HP_X = 22;
  private final int SCORE_X = 200;
  
  public UI(Health health, Score score) {
    this.health = health;
    this.score = score;
  }
  
  public void draw() {
    noStroke();
    fill(0x66000000);
    rect(0, 0, width, 36); 
    
    // draw health bar
    fill(#28e200);
    rect(35, HP_X + 2, health.health, 10);
    fill(255);
    textSize(14);
    text("HP:", 10, HP_X);
    // draw score
    text("Score:", SCORE_X, 22);
    text(score.points, SCORE_X + 100, 26);
  }
}
