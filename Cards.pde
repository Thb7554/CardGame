ArrayList<ColorIdentity> CIList = new ArrayList<ColorIdentity>();

ArrayList<Card> CardDatabase = new ArrayList<Card>();
ArrayList<Card> CardList = new ArrayList<Card>();

ArrayList<Slot> SlotList = new ArrayList<Slot>();

ArrayList<Mana> player1ManaList = new ArrayList<Mana>();
ArrayList<Mana> player2ManaList = new ArrayList<Mana>();

ArrayList<Trigger> TriggerList = new ArrayList<Trigger>();

ArrayList<Animation> AnimationDatabase = new ArrayList<Animation>();
ArrayList<Animation> AnimationList = new ArrayList<Animation>();

static final int KEYS = 0500;
final boolean[] keysDown = new boolean[KEYS];

float cardWid = 125;
float cardHei = 200;
int ATC = 0;

Button startGame; 
enum GameStatus {
  OPENING,
  START,
  MAIN, //Player actions
  COMBAT,
  END
}

enum SystemStatus {
  MENU,
  GAME
}

GameStatus gameStatus = GameStatus.MAIN;

SystemStatus systemStatus = SystemStatus.MENU;

int curSlot = 0;
int curSlotMax = 5;
int slotAnimation = 0;
float animationTime = 0;
float t = 0;

boolean turn;

int player1HP = 40;
int player2HP = 40;

Hand player1Hand = new Hand();
Hand player2Hand = new Hand();

int currentCardID = 0;

PShader toon;

boolean small = false;

boolean cardSelected = false;
int cardID = -1;

int turnButtonTimeout = 0;

void setup() {
  size(5, 5, P2D);
  int size = 900;
  if (!small) {
    size = 900;
    cardWid = 125;
    cardHei = 200;
  }
  if (small) {
    size = 690;
    cardWid = 110;
    cardHei = 170;
  }
  windowResize(1200, size);

  rectMode(CENTER);
  imageMode(CENTER);
  textSize(16); 

  startGame = new Button("Start Game", true, width/2,height/2,200,50);


  ///toon = loadShader("ToonFrag.glsl");
  //toon.set("fraction", 1.0);

  CIList.add(new ColorIdentity("Red", color(255, 200, 200), color(120, 5, 0)));
  CIList.add(new ColorIdentity("Blue", color(230, 230, 255), color(5, 5, 100)));
  CIList.add(new ColorIdentity("Green", color(230, 255, 230), color(5, 100, 5)));
  CIList.add(new ColorIdentity("White", color(255, 255, 250), color(50, 50, 50)));
  CIList.add(new ColorIdentity("Black", color(200, 180, 200), color(40, 5, 40)));
  CIList.add(new ColorIdentity("Brown", color(240, 220, 150), color(80, 60, 0)));


  AnimationDatabase.add(new flameSpitter_TargettedAnimation());

  CardDatabase.add(new Card("Rust Soldier", "Lacking all but honor.", 0, 3, 1, 1));
  
  Card card_FlameSpitter = new Card("Flame Spitter", "Deals 2 Dmg to Opponent at the end of turn.", 0, 0, 2, 2);
  card_FlameSpitter.effectList.add(new effect_DamageOpponent(2, TriggerType.ENDBOTH));
  card_FlameSpitter.SetImage("flamespitter.png");
  CardDatabase.add(card_FlameSpitter);
  
  Card card_Bright = new Card("Bright", "Deals 1 Dmg to Opponent at the start of your turn.", 0, 2, 1, 2);
  card_Bright.effectList.add(new effect_DamageOpponent(1, TriggerType.START));
  card_Bright.SetImage("bright.png");
  CardDatabase.add(card_Bright);
  
  Card card_HellWall = new Card("Hell Wall", "Deals 3 Dmg to Opponent at the end of your turn.", 0, 0, 6, 4);
  card_HellWall.effectList.add(new effect_DamageOpponent(3, TriggerType.END));
  card_HellWall.SetImage("hellwall.png");
  CardDatabase.add(card_HellWall);
  
  CardDatabase.add(new Card("Fountain", "Ocean calls.", 1, 0, 4, 1));
  CardDatabase.add(new Card("Vineyard", "Tree.", 2, 0, 2, 1));
  
  Card card_Inn = new Card("Inn", "Heals.", 3, 0, 8, 2);
  card_Inn.SetImage("inn.png");
  CardDatabase.add(card_Inn);
  
  CardDatabase.add(new Card("Skeleton", "Rahhhhhh.", 4, 2, 2, 1));
  CardDatabase.add(new Card("Lightning", "Shock shock.", 5, 6, 1, 3));
  CardDatabase.add(new Card("Captain", "Big guy.", 3, 0, 5, 1));
  CardDatabase.add(new Card("Wave", "Wave calls.", 1, 1, 6, 2));

  player1ManaList.add(new Mana(CIList.get(0)));
  player1ManaList.add(new Mana(CIList.get(1)));

  player2ManaList.add(new Mana(CIList.get(3)));

  int wid = 5;
  for (int i = 0; i < wid*2; i++) {
    if (i < wid) {
      //SlotList.add(new Slot(i,(i+1)*width/(wid+1),250));
      SlotList.add(new Slot(i, (int)((i*cardWid)-cardWid*2+width/2), 200));
    } else {
      //SlotList.add(new Slot(i,(i-wid+1)*width/(wid+1),450));
      SlotList.add(new Slot(i, (int)(((i-wid)*cardWid)-cardWid*2+width/2), (int)(200+cardHei)));
    }
  }

  //Set player hands
  for (int i = 0; i < 6; i++) {
    player1Hand.Set(CardDatabase.get((int)random(0, CardDatabase.size())));
  }
  player1Hand.Set(CardDatabase.get(1));

  for (int i = 0; i < 7; i++) {
    if (random(0, 1) > .5) {
      player2Hand.Set(4);
    } else {
      player2Hand.Set(7);
    }
  }

  StartTurn();
}

void draw() {
  noStroke();
  t += .04;

  processInput();
  
  if(systemStatus == SystemStatus.MENU){
    background(150,250,150);
    
    startGame.Draw();
    if(mousePressed && startGame.Click()){ 
      systemStatus = SystemStatus.GAME;
    }
    
    return; 
  }
  
  if(gameStatus == GameStatus.OPENING){
    gameStatus = GameStatus.START;
    return;
  }
  
  if (turnButtonTimeout > 0) {
    turnButtonTimeout--;
  }
  
  if (!turn) {
    background(250+5*sin(t/2));
  } else {
    background(230+5*sin(t/2));
  }

  for (int i = 0; i < TriggerList.size(); i++) {
    fill(250,220,100);
    ellipse(40,15*(i+1),15,15);
    fill(0,0,0);
    text(TriggerList.get(i).slotID,40,15*(i+1));
  }



  for (int i = 0; i < SlotList.size(); i++) {
    SlotList.get(i).Draw();
  }
  
    if(AnimationList.size() > 0){
      AnimationList.get(0).Draw(ATC);
      ATC++;
      if(ATC > AnimationList.get(0).maxFrame) { 
        AnimationList.remove(0);
        ATC = 0;
      }
    }
  
  if(gameStatus==GameStatus.END){
    handlePhaseTriggers(TriggerType.END, TriggerType.ENDBOTH);
  }
  
  if(gameStatus==GameStatus.START){
    handlePhaseTriggers(TriggerType.START, TriggerType.STARTBOTH); 
  }
  

  fill(240, 200, 250);
  if (turn) {
    ellipse(50, 230, 50, 50);

    if (gameStatus==GameStatus.MAIN) {
      int rand = (int)random(0, 6);
      int max = rand-1;
      if (rand == 0) {
        max = 6;
      }

      for (int i = rand; i != max; i++) {
        Card c = player2Hand.cards.get(i);
        if (c.playable) {
          for (int j = 0; j < player2ManaList.size(); j++) {
            if (c.CI == player2ManaList.get(j).CI) {
              if (c.cost <= player2ManaList.get(j).number) {
                int randIndex = (int)random(0, 5);
                if (SlotList.get(randIndex).card == null) {
                  player2ManaList.get(j).number -= c.cost;
                  SlotList.get(randIndex).Set(c);
                  c.playable = false;
                }
              }
            }
          }
        }
        if (i > 5) {
          i = -1;
        }
      }
    }

    if (gameStatus == GameStatus.MAIN) {
      GoToCombat();
    }
  } else {
    ellipse(50, 350, 50, 50);
  }


  if (gameStatus == GameStatus.COMBAT) {
    if (SlotList.get(curSlot).card != null && SlotList.get(curSlot).card.atk > 0) {
      if (slotAnimation == 0) {
        SlotList.get(curSlot).DrawAttack(animationTime);
        animationTime+=.05;

        if (animationTime >= 1) {
          animationTime = 0;
          slotAnimation = 1;
        }
      } else {
        if (curSlot>4) {
          SlotList.get(curSlot).Attack(curSlot-5);
        } else {
          SlotList.get(curSlot).Attack(curSlot+5);
        }

        curSlot++;
        slotAnimation = 0;
      }
      if (curSlot > curSlotMax) {
        GoToEndPhase();
      }
    } else
    {
      curSlot++;
      if (curSlot > curSlotMax) {
        GoToEndPhase();
      }
    }
  }

  player1Hand.Draw();

  textSize(10);
  fill(0);
  //text(gameStatus, 15,15);

  textSize(24);
  text(player1HP, width/2, 50);
  text(player2HP, width/2, height-50);

  for (int i = 0; i < player1ManaList.size(); i++) {
    player1ManaList.get(i).Draw(i*30, 0);
  }

  for (int i = 0; i < player2ManaList.size(); i++) {
    player2ManaList.get(i).Draw(i*30, -400);
  }

  fill(140, 140, 140);
  ellipse(width-100, height/2+50, 50, 50);
  textSize(46);
  fill(0, 0, 0);
  text("R", width-100, height/2+65);
  fill(255, 255, 255);
  text("R", width-100, height/2+63);

  fill(220, 220, 220);
  rect(width-80, height/2+70, 20, 20);
  textSize(20);
  fill(0, 0, 0);

  text("2", width-80, height/2+75);

  textSize(24);


  fill(0, 0, 0, 200);
  textAlign(RIGHT);
  text(frameRate, width-10, 30);
  
  if (gameStatus == GameStatus.START && TriggerList.size() == 0 && AnimationList.size() == 0) {
    gameStatus = GameStatus.MAIN;
    if(!turn){
      print("| YOUR TURN |");
    }
    else{
      print("| THEIR TURN |");
    }
    return;
  }
  
  if (gameStatus == GameStatus.END && TriggerList.size() == 0 && AnimationList.size() == 0) {
    EndTurn();

    return;
  }
}

//======================
//PROCESS INPUT
//======================
void processInput() {

  //Q
  if (isKeyDown(81) && turnButtonTimeout == 0) {
    turnButtonTimeout = 50;
    GoToCombat();
    return;
  }

  //R
  else if (isKeyDown(82) && turnButtonTimeout == 0 && refreshHand() ) {
    turnButtonTimeout = 50;
    for (int i = 0; i < player1Hand.cards.size(); i++) {
      player1Hand.cards.get(i).playable = true;
    }
  }
}

void GoToCombat() {
  if (gameStatus == GameStatus.MAIN) {//Main
    gameStatus = GameStatus.COMBAT; //Combat

    if (turn) {
      curSlot=0;
      curSlotMax=4;
    } else {
      curSlot=5;
      curSlotMax=9;
    }
  }
}


void GoToEndPhase() {
  gameStatus = GameStatus.END;

  TriggerList = new ArrayList<Trigger>();
  for(int i = 0; i < 10; i++){
    TriggerList.add(new Trigger(i + " end", TriggerType.END,i));
  }
  

  if (turn) {
    curSlot=0;
    curSlotMax=4;
    
  } else {
    curSlot=5;
    curSlotMax=9;
  }
}

void EndTurn() {
  /*
  for(int i = 0; i < 10; i++){
   Card c = SlotList.get(i).card;
   
   if(c != null && c.effectList.size() > 0){
   print(c.effectList);
   for(int j = 0; j < c.effectList.size(); j++){
   Effect e = c.effectList.get(j);
   if(e.type == EffectType.ONEND){
   e.Trigger(SlotList.get(i));
   }
   }
   }
   }
   */
  turn = !turn;

  StartTurn();
}

void StartTurn() {
  gameStatus = GameStatus.START;
  
  if (!turn) {
    for (int i=0; i<2; i++) {
      player1ManaList.get((int)random(0, player1ManaList.size())).number++;
    }
  } else {
    for (int i=0; i<2; i++) {
      player2ManaList.get((int)random(0, player2ManaList.size())).number++;
    }
  }
  
  for(int i = 0; i < 10; i++){
    TriggerList.add(new Trigger(i + " end", TriggerType.START,i));
  }
  
}

void handlePhaseTriggers(TriggerType friendly, TriggerType both){
 if(TriggerList.size() > 0) { 
    print("[" + TriggerList.get(0).name + "]");
      
    int triggeredSlotID = TriggerList.get(0).slotID;
    Card triggeredCard = SlotList.get(triggeredSlotID).card;
    
    int e = 0;
    
    if(triggeredCard != null && triggeredCard.effectList.size() > 0 && ATC == 0){
      if(e < triggeredCard.effectList.size()) {
        TriggerType tempType = triggeredCard.effectList.get(e).type;
        if(tempType == both || (tempType == friendly && friendlyTurn(triggeredSlotID)))
        {
          triggeredCard.effectList.get(e).Trigger(triggeredSlotID);
          print(triggeredCard.effectList.get(e).name);
          
          currentCardID = triggeredSlotID;
          AnimationList.add(triggeredCard.effectList.get(e).anim);
        }
        
        e++;
      }
      
      if(e >= triggeredCard.effectList.size()){
        TriggerList.remove(0); 
        e = 0;
      }
    }
    else if(ATC == 0){
      TriggerList.remove(0); 
      e = 0;
    }
  } 
}

boolean friendlyTurn(int slotID){
  if(slotID < 5 && turn || slotID >= 5 && !turn){
    return true;
  }
  else return false;
}

boolean refreshHand() {
  ArrayList<Integer> nonZeroMana = new ArrayList<Integer>();

  for (int i = 0; i < player1ManaList.size(); i++) {
    if (player1ManaList.get(i).number > 0) {
      nonZeroMana.add(i);
    }
  }

  if (nonZeroMana.size() < 1) {
    return false;
  }

  int chosenIndex = (int)random(0, nonZeroMana.size());
  int manaIndex = nonZeroMana.get(chosenIndex);
  player1ManaList.get(manaIndex).number--;

  nonZeroMana = new ArrayList<Integer>();

  for (int i = 0; i < player1ManaList.size(); i++) {
    if (player1ManaList.get(i).number > 0) {
      nonZeroMana.add(i);
    }
  }

  if (nonZeroMana.size() < 1) {
    player1ManaList.get(manaIndex).number++;
    return false;
  }

  chosenIndex = (int)random(0, nonZeroMana.size());
  manaIndex = nonZeroMana.get(chosenIndex);
  player1ManaList.get(manaIndex).number--;

  return true;
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

void ProcessKey(final int k, final boolean isDown) {
  if (k < KEYS)  keysDown[k] = isDown;
}

boolean isKeyDown(final int k) {
  return keysDown[k];
}

void mouseClicked() {
  //PLACE CARD
  if (!turn && cardSelected) {
    for (int i = SlotList.size()/2; i < SlotList.size(); i++) {
      if (SlotList.get(i).ClickSlot(cardID) != -1) {
        SlotList.get(i).Set(player1Hand.cards.get(cardID));
        player1Hand.cards.get(cardID).playable = false;
      }
    }
  }

  cardID = player1Hand.ClickCard();
  if (cardID != -1) {
    //print(player1Hand.cards.get(cardID).name);
    cardSelected = true;
  } else {
    cardSelected = false;
  }
}
