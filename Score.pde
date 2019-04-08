class Score {
  private int points;
  
  Score() {
    this.points = 0;
  }
  
  void add(int points) {
    this.points += points;
  }
  
  void lose(int points) {
    this.points = (this.points - points < 0) ? 0 : this.points - points;
  }
  
  int get() {
    return this.points;
  }
}
