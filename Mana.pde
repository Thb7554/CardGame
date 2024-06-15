class Mana {
  float x, y;
  int number;
  ColorIdentity CI;

  public Mana(ColorIdentity CI) {
    this.CI = CI;
    x = width-250;
    y = height/2+25;
    number = 0;
  }

  public void Draw(int xOff, int yOff) {
    stroke(CI.cc);
    strokeWeight(2);
    fill(CI.c);
    ellipse(x+xOff, y+2*sin(t+xOff)+yOff, 25, 25);
    strokeWeight(1);
    noStroke();
    fill(CI.cc);
    textAlign(CENTER);
    text(number, x+xOff, y+2*sin(t+xOff)+7+yOff);
  }
}
