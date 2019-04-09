public class UI {
  private Health health;
  private Score score;
  
  private final int HP_X = 22;
  private final int SCORE_X = width - 100;
  private final int H1 = 40;
  private final int H2 = 30;
  private final int H3 = 22;
  private final int H4 = 18;
  private final int P = 14;
  
  private final String GAME_OVER = "GAME OVER";
  private final String FINAL_SCORE = "Final Score: ";
  private final String RESTART = "Press 'R' to play again";
  private final String TITLE = "BULLET HECK";
  private final String START = "Press 'SPACE' to start";
  private final String CTRL = "Controls";
  private final String CTRL_MOVE = "Use arrow keys or WASD to move";
  private final String CTRL_JUMP = "Press SPACE to jump";
  private final String CTRL_SHOOT = "Click or press SHIFT to shoot";
  
  public UI(Health health, Score score) {
    this.health = health;
    this.score = score;
  }
  
  public void startScreen() {
    fill(15);
    rect(0, 0, width, height);
    textSize(H1);
    fill(255);
    textFont(font_minecraftia);
    text(TITLE, centerText(TITLE), height / 2 + 5);
    textFont(font_worksans);
    textSize(H4);
    text(START, centerText(START), height / 2 + 20);
    
    // controls
    fill(150);
    text(CTRL, centerText(CTRL), height / 2 + 200);
    textSize(P);
    text(CTRL_MOVE, centerText(CTRL_MOVE), height / 2 + 225);
    text(CTRL_JUMP, centerText(CTRL_JUMP), height / 2 + 245);
    text(CTRL_SHOOT, centerText(CTRL_SHOOT), height / 2 + 265);
  }
  
  public void gameOverScreen(String causeOfDeath) {
    fill(15);
    rect(0, 0, width, height);
    fill(#e20000);
    textSize(H2);
    textFont(font_minecraftia);
    text(GAME_OVER, centerText(GAME_OVER), height / 2 - 25);
    textSize(H3);
    textFont(font_worksans);
    text(causeOfDeath, centerText(causeOfDeath), height / 2 - 15);
    fill(255);
    String s = FINAL_SCORE + score.get();
    text(s, centerText(s), height / 2 + 45);
    textSize(H4);
    text(RESTART, centerText(RESTART), height / 2 + 70);
  }
  
  public void draw() {
    noStroke();
    fill(0x66000000);
    rect(0, 0, width, 36); 
    
    // draw health bar
    fill(#28e200);
    rect(HP_X + 15, 12, health.health, 10);
    fill(255);
    textSize(P);
    text("HP:", 10, HP_X);
    // draw score
    text("Score:", SCORE_X, 22);
    text(score.points, SCORE_X + 45, 22);
  }
  
  float centerText(String txt) {
    return width / 2 - textWidth(txt) / 2;
  }
}
