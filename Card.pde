class Card {
  String name, description;
  int CIID;
  ColorIdentity CI;

  boolean creature;
  int atk, maxHP, curHP;

  boolean playable;

  public Card(String name, String description, int CIID) {
    this.name = name;
    this.description = description;
    this.CIID = CIID;
    this.CI = CIList.get(CIID);

    this.creature = true;
    this.atk = (int)random(0, 5);
    this.maxHP = (int)random(1, 12);
    this.curHP = this.maxHP;

    this.playable = true;
  }

  public void Draw() {
    stroke(0, 0, 0);
    fill(CI.c);
    rect(0, 0, 125, 200);
    fill(CI.cc);
    textAlign(CENTER);
    textSize(16);
    text(name, 0, -80);
    textSize(10);
    text(description, 0, 55);
    textSize(22);
    textAlign(LEFT);
    text(atk, -55, 90);
    textAlign(RIGHT);
    text(curHP + "/" + maxHP, 55, 90);
    fill(255);
    noStroke();
  }

  public void SmallDraw(int x, int y) {
    stroke(0, 0, 0);
    fill(CI.c);
    //if(playable){
      rect(0, 0, 100, 160);
    //}
   

    if (!playable) {
      toon.set("time", t);
      toon.set("wid", width);
      toon.set("hei", height);
      toon.set("red", (float)red(CI.c)/255);
      toon.set("green", (float)green(CI.c)/255);
      toon.set("blue", (float)blue(CI.c)/255);
      shader(toon);

      rect(0, 0, 100, 160);
      resetShader();
      /*
      loadPixels();
       
       
       for(int i = 0; i < 100; i++){
       for(int j = 0; j < 160; j++){
       
       float val = noise((float)i/50+x/15,(float)j/50+t+y/15,t/7);
       
       if(x+i-50+(j+y-80)*width < width * height) {
       float trans = -10+20*val+max(120-j,0)*.1;
       
       float rO = red(CI.c);
       float gO = red(CI.c);
       float bO = red(CI.c);
       
       int r = int((3*rO+(20*val-j))/4);
       int g = int((3*gO+(gO-250*val))/4);
       int b = int((3*bO+(150*val))/4);
       
       if(r > 255) r = 255;
       else if(r < 0) r = 0;
       if(g > 255) g = 255;
       else if(g < 0) g = 0;
       if(b > 255) b = 255;
       else if(b < 0) b = 0;
       
       pixels[x+i-50+(j+y-80)*width] = color(r,g,b);
       }
       
       }
       }
       updatePixels();
       */
    }
    fill(CI.c, 170);
    noStroke();
    rect(0,72,100,22);
    rect(0,-70,100,22);
     
    fill(CI.cc);
    textAlign(CENTER);
    textSize(14);
    text(name, 0, -65);
    textSize(6);
    text(description, 0, 55);
    textSize(16);
    textAlign(LEFT);
    text(atk, -45, 75);
    textAlign(RIGHT);
    text(curHP + "/" + maxHP, 45, 75);
    fill(255);
    noStroke();
  }
}
