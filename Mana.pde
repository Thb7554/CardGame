class Mana {
  float x, y;
  int number;
  ColorIdentity CI;

  public Mana(ColorIdentity CI) {
    this.CI = CI;
    x = 0;
    y = height/2+25;
    number = 0;
  }

  public void Draw(int xOff, int yOff) {
    xOff = xOff * 40;
    float xCalc = x+xOff + cardWid * SlotList.size()/4 + 20 + width/2-2;
    stroke(CI.cc);
    strokeWeight(3);
    fill(CI.c);
    
    int sizeInfluence = 0;
    sizeInfluence = number*2;
    sizeInfluence = min(sizeInfluence,12);
    
    ellipse(xCalc, y+2*sin(t+xOff)+yOff, 26+sizeInfluence, 26+sizeInfluence);
    strokeWeight(1);
    noStroke();
    fill(CI.cc);
    

    
    textAlign(CENTER);
    text(number, xCalc, y+2*sin(t+xOff)+7+yOff);
  }
}
