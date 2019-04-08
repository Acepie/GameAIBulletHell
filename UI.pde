public class UI {
  private Health health;
  private Score score;
  
  private final int HP_X = 22;
  private final int SCORE_X = width - 100;
  
  final String GAME_OVER = "GAME OVER";
  final String FINAL_SCORE = "Final Score: ";
  final String RESTART = "Press 'R' to play again";
  
  public UI(Health health, Score score) {
    this.health = health;
    this.score = score;
  }
  
  public void gameOverScreen(String causeOfDeath) {
    fill(15);
    rect(0, 0, width, height);
    fill(#e20000);
    textSize(30);
    text(GAME_OVER, width / 2 - textWidth(GAME_OVER) / 2, height / 2 - 75);
    textSize(22);
    text(causeOfDeath, width / 2 - textWidth(causeOfDeath) / 2, height / 2 - 35);
    fill(255);
    String s = FINAL_SCORE + score.get();
    textSize(22);
    text(s, width / 2 - textWidth(s) / 2, height / 2 + 15);
    textSize(14);
    text(RESTART, width / 2 - textWidth(RESTART) / 2, height / 2 + 45);
  }
  
  public void draw() {
    noStroke();
    fill(0x66000000);
    rect(0, 0, width, 36); 
    
    // draw health bar
    fill(#28e200);
    rect(HP_X + 15, 12, health.health, 10);
    fill(255);
    textSize(14);
    text("HP:", 10, HP_X);
    // draw score
    text("Score:", SCORE_X, 22);
    text(score.points, SCORE_X + 45, 22);
  }
}
