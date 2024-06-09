class Mana {
  float x,y;
  int number;
  ColorIdentity CI;
  
  
  public Mana(ColorIdentity CI) {
    this.CI = CI;
    x = width-250;
    y = height/2+25;
    number = 0;
  }
  
  public void Draw(int offset){
    fill(CI.c);
    ellipse(x+offset,y+2*sin(t+offset),25,25);
    fill(CI.cc);
    textAlign(CENTER);
    text(number,x+offset,y+2*sin(t+offset)+5);
  }
}
