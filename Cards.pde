ArrayList<ColorIdentity> CIList = new ArrayList<ColorIdentity>();
ArrayList<Card> CardDatabase = new ArrayList<Card>();
ArrayList<Card> CardList = new ArrayList<Card>();
ArrayList<Slot> SlotList = new ArrayList<Slot>();

static final int KEYS = 0500;
final boolean[] keysDown = new boolean[KEYS];

float cardWid = 125;
float cardHei = 200;

int gameStatus = 0;
int curSlot = 0;
int curSlotMax = 5;
int slotAnimation = 0;
int animationTime = 0;
float t = 0;

boolean turn;

int player1HP = 40;
int player2HP = 40;

Hand player1Hand = new Hand();

PShader toon;

boolean small = true;

void setup(){
  if(!small){
    size(1000,900,P2D);
    cardWid = 125;
    cardHei = 200;
  }
  if(small){
    size(1000,700,P2D);
    cardWid = 110;
    cardHei = 170;
  }

  rectMode(CENTER);
  textSize(16);
  
  toon = loadShader("ToonFrag.glsl");
  toon.set("fraction", 1.0);
  
  CIList.add(new ColorIdentity("Red", color(255,200,200), color(120,5,0)));
  CIList.add(new ColorIdentity("Blue", color(230,230,255), color(5,5,100)));
  CIList.add(new ColorIdentity("Green", color(230,255,230), color(5,100,5)));
  CIList.add(new ColorIdentity("White", color(255,255,250), color(50,50,50)));
  CIList.add(new ColorIdentity("Black", color(200,180,200), color(40,5,40)));
  CIList.add(new ColorIdentity("Brown", color(240,220,150), color(80,60,0)));
  
  CardDatabase.add(new Card("Rust Soldier", "Lacking all but honor.",0));
  CardDatabase.add(new Card("Fountain", "Ocean calls.",1));
  CardDatabase.add(new Card("Vineyard", "Tree.",2));
  CardDatabase.add(new Card("Inn", "Heals.",3));
  CardDatabase.add(new Card("Skeleton", "Rahhhhhh.",4));
  CardDatabase.add(new Card("Lightning", "Shock shock.",5));
  
  int wid = 5;
  for(int i = 0; i < wid*2; i++){
    if(i < wid){
      //SlotList.add(new Slot(i,(i+1)*width/(wid+1),250));
      SlotList.add(new Slot(i,(int)((i*cardWid)-cardWid*2+width/2),200));
    }
    else {
      //SlotList.add(new Slot(i,(i-wid+1)*width/(wid+1),450));
      SlotList.add(new Slot(i,(int)(((i-wid)*cardWid)-cardWid*2+width/2),(int)(200+cardHei)));
    }
  }
  
  player1Hand.Set((int)random(0,CardDatabase.size()));
  player1Hand.Set((int)random(0,CardDatabase.size()));
  player1Hand.Set((int)random(0,CardDatabase.size()));
  player1Hand.Set((int)random(0,CardDatabase.size()));
  player1Hand.Set((int)random(0,CardDatabase.size()));
  player1Hand.Set((int)random(0,CardDatabase.size()));
  player1Hand.Set((int)random(0,CardDatabase.size()));
  
  
  SlotList.get(0).Set(0);
  SlotList.get(5).Set(0);
  SlotList.get(6).Set(1);
}

void draw(){
  noStroke();
  t += .04;
  processInput();
  
  background(250+5*sin(t/2));
  
  for(int i = 0; i < SlotList.size(); i++){
    SlotList.get(i).Draw();
  }
  
  fill(240,200,250);
  if(turn){
    ellipse(50,280,50,50);
  }
  else{
    ellipse(50,500,50,50);
  }
  
  if(gameStatus == 1){
    if(SlotList.get(curSlot).card != null && SlotList.get(curSlot).card.atk > 0) {
      if(slotAnimation == 0){
        SlotList.get(curSlot).DrawAttack(animationTime);
        animationTime++;
        
        if(animationTime > 25){
          animationTime = 0;
          slotAnimation = 1;
        }
      }
      else{
        if(curSlot>4){
          SlotList.get(curSlot).Attack(curSlot-5);
        }
        else{
          SlotList.get(curSlot).Attack(curSlot+5);
        }
        
        curSlot++;
        slotAnimation = 0;
      }
      if(curSlot > curSlotMax){
        gameStatus = 0;
        turn = !turn;
      }
    }
    else
    {
      curSlot++;
      if(curSlot > curSlotMax){
        gameStatus = 0;
        turn = !turn;
      }
    }
  }
  
  player1Hand.Draw();
  
  textSize(10);
  fill(0);
  text(gameStatus, 15,15);
  
  textSize(24);
  text(player1HP, width/2, 50);
  text(player2HP, width/2, height-50);
  
  text(frameRate, width-20, 30);
}

//======================
//PROCESS INPUT
//======================
void processInput(){

  //Q
  if(isKeyDown(81)){
    if(gameStatus == 0){
      gameStatus = 1;
      
      if(turn){
        curSlot=0;
        curSlotMax=4;
      }
      else{
        curSlot=5;
        curSlotMax=9;
      }
    }

  }
}

//======================
//KEY PROCESSING WHATEVER
//======================
void keyPressed() {
  print("kP:" + keyCode + " ");
  ProcessKey(keyCode, true);
}

void keyReleased() {
  ProcessKey(keyCode, false); 
}

void ProcessKey(final int k, final boolean isDown){
  if (k < KEYS)  keysDown[k] = isDown;
}

boolean isKeyDown(final int k) {
  return keysDown[k];
}
