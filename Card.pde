class Card {
  String name, description;
  int CIID;
  ColorIdentity CI;

  int ID;

  boolean creature;
  int atk, maxHP, curHP;

  int cost;
  boolean p1Owner = true;

  boolean playable;
  boolean selected;
  boolean hovering;

  ArrayList<Effect> effectList;

  PImage img;
  
  int hoverTimer = 0;

  TextArea textArea;

  public Card(int ID, String name, String description, int CIID) {
    this.ID = ID;
    this.name = name;
    
    this.description = description;
    this.textArea = new TextArea(description);
    
    this.CIID = CIID;
    this.CI = CIList.get(CIID);

    this.creature = true;
    this.atk = (int)random(0, 5);
    this.maxHP = (int)random(1, 12);
    this.curHP = this.maxHP;

    this.playable = true;
    this.selected = false;



    cost = 0;
    this.effectList = new ArrayList<Effect>();
  }

  public Card(int ID, String name, String description, int CIID, int ATK, int HP, int Cost) {
    this.ID = ID;
    this.name = name;
    
    this.description = description;
    this.textArea = new TextArea(description);
    
    this.CIID = CIID;
    this.CI = CIList.get(CIID);

    this.creature = true;
    this.atk = ATK;
    this.maxHP = HP;
    this.curHP = this.maxHP;

    this.playable = true;
    this.selected = false;

    this.cost = Cost;
    this.effectList = new ArrayList<Effect>();
  }

  public void SetImage(String fileName){
    print("SETIMAGE " + fileName);
    img = loadImage("images/" + fileName);
  }

  public void Draw(boolean showMana) {
    stroke(0, 0, 0);
    fill(CI.c);
    rect(0, 0, cardWid, cardHei);
    fill(CI.cc);
    
    if(img != null){
      image(img, 0,-20,cardWid,cardWid);
    }

    
    textAlign(CENTER);
    textSize(16);
    text(name, 0, -cardHei/2+15);
    textSize(10);
    text(description, 0, cardHei/2-35);
    textSize(34);
    textAlign(LEFT);

    int cB = (int)(cardHei/2-7);

    text(atk, -cardWid/2+4, cB);
    textAlign(RIGHT);


    if(curHP != maxHP){
      //text(curHP + "/" + maxHP, cardWid/2-4, cB);
      text(curHP + " ", cardWid/2-8, cB);
      textSize(14);
      text("/" + maxHP, cardWid/2-4, cB);
    }
    else{
      text(curHP, cardWid/2-4, cB);
    }

    fill(255);

    if(showMana){
      for (int i = 0; i < cost; i++) {
        strokeWeight(1);
        fill(CI.cc);
        ellipse(-50+(i+1)*100/(cost+1), -70, 10, 10);
        fill(CI.c);
        ellipse(-50+(i+1)*100/(cost+1), -70, 8, 8);
      }
    }

    noStroke();
  }

  public void Preview(int hoverTimer) {
    translate(width/2,height/2);

    stroke(0, 0, 0, hoverTimer);
    fill(CI.c, hoverTimer*2);
    //if(playable){
    rect(0, 0, 400, 600);
    fill(CI.cc, hoverTimer);
    textAlign(CENTER);
    textSize(45);
    text(name, 0, -250);
    //textSize(22);
    //text(description, 0, 205);
    textSize(40);
    textAlign(LEFT);
    text(atk, -145, 250);
    textAlign(RIGHT);
    if(curHP != maxHP){
      text(curHP + "/" + maxHP, 145, 250);
    }
    else{
      text(curHP, 145, 250);
    }
    if((int)this.textArea.x != 0 && (int)this.textArea.x != 105){ //TEMPORARY CHECK PLEASE CHANGE
      this.textArea.Resize(0,105,300,200);
    }
    
    this.textArea.Draw(hoverTimer);
    
    
    fill(255, hoverTimer*2);

    for (int i = 0; i < cost; i++) {
      fill(CI.cc, hoverTimer*2);
      ellipse(-150+(i+1)*300/(cost+1), -200, 40, 40);
      fill(CI.c, hoverTimer*2);
      ellipse(-150+(i+1)*300/(cost+1), -200, 25, 25);
    }
    

    noStroke();
  }

  public void SmallDraw(int x, int y) {
    stroke(0, 0, 0);
    fill(CI.c);
    //if(playable){
    rect(0, 0, 100, 160);
    //}

    if (!playable) {
      //NEED FASTER SHADER
      /*
      toon.set("time", t);
      toon.set("wid", width);
      toon.set("hei", height);
      toon.set("red", (float)red(CI.c)/255);
      toon.set("green", (float)green(CI.c)/255);
      toon.set("blue", (float)blue(CI.c)/255);
      shader(toon);
      */
      
      fill(70,70,70);
      
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
    rect(0, 72, 100, 22);
    rect(0, -70, 100, 22);

    if(img != null){
      image(img, 0,-10,100,100);  
    }

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
    if(curHP != maxHP){
      text(curHP + "/" + maxHP, 45, 75);
    }
    else{
      text(curHP, 45, 75);
    }
    fill(255);

    for (int i = 0; i < cost; i++) {
      fill(CI.cc);
      ellipse(-25+(i+1)*50/(cost+1), -50, 10, 10);
      fill(CI.c);
      ellipse(-25+(i+1)*50/(cost+1), -50, 7, 7);
    }

    if (selected) {
      fill(255, 255, 255, 80+60*sin(t*2));
      rect(0, 0, 100, 160);
      fill(255);
    }
    noStroke();
  }
  
  public void Hover(int x, int y){
    
    if (mouseX < x + 50 && mouseX > x - 50 && mouseY > y-80 && mouseY < y+80) {
      hoverTimer++;
      if(hoverTimer > 40){
        this.Preview(hoverTimer*3-120);
      }
    }
    else{
      hoverTimer = 0;
    }
  }
}
