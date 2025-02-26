import processing.sound.*;
SoundFile shopTheme;
SoundFile buttonPress;
SoundFile fireSFX;

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

float baseCardWid, baseCardHei;

float cardWid = 125;
float cardHei = 260;
int ATC = 0;

int mones = 0;
PImage goldImg;


Button startGame, editDeck, backToMenu, toSettings, fromSettings; //Menu Buttons
Button returnToMenu;

Overlay OL = new Overlay();
MainLogic ML = new MainLogic();



enum GameStatus {
  OPENING,
  START,
  MAIN, //Player actions
  COMBAT,
  END,
  RESULTS
}

enum SystemStatus {
  MENU,
  EDIT,
  GAME,
  SETT
}

enum WinStatus {
  ONGOING,
  PLAYER1,
  PLAYER2,
  TIED
}

GameStatus gameStatus = GameStatus.MAIN;

SystemStatus systemStatus = SystemStatus.MENU;

WinStatus winStatus = WinStatus.ONGOING;

int curSlot = 0;
int curSlotMax = 5;
int slotAnimation = 0;
float animationTime = 0;
float t = 0;

boolean turn;

int player1HP = 10;
int player2HP = 10;

Hand player1Hand = new Hand();
Hand player2Hand = new Hand();

int currentCardID = 0;

PShader toon;

boolean small = false;

boolean cardSelected = false;
int cardID = -1;

int turnButtonTimeout = 0;

int editDeckHover = 0;

ClickAndDrag CAD = new ClickAndDrag();

int selectedCard = -1;


int tijiWidth, tijiHeight;

int cardIDCurIndex = -1;

void setup() {
  size(5, 5, P2D);
  
  int size = 900;
  frameRate(360);

  PFont pfont = createFont("Arial", 32, true);
  textFont(pfont);

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

  goldImg = loadImage("images/gold.png");

  shopTheme = new SoundFile(this, "sound/ShopTheme.wav");
  
  //shopTheme.loop(); //UNCOMMENT FOR MUSIC
  
  buttonPress = new SoundFile(this, "sound/ButtonPress.wav");
  
  fireSFX = new SoundFile(this, "sound/FireSound.wav");
  
  baseCardWid = cardWid;
  baseCardHei = cardHei;

  rectMode(CENTER);
  imageMode(CENTER);
  textSize(16);

  tijiWidth = width;
  tijiHeight = height;


  startGame = new Button("Start Game", true, width/2, height/2, 200, 50);
  editDeck = new Button("Edit Deck", true, width/2, height/2+100, 200, 50);
  backToMenu = new Button("Back to Menu", true, width/2, height/2-200, 200, 50);
  toSettings = new Button("Settings", true, width/2, height/2+300,150,45);
  fromSettings = new Button("Back to Menu", true, width/2, height/2-200,200,50);
  
  returnToMenu = new Button("Return to Menu", true, width/2, height/2+200,250,80);
  
  String words = "start";
  String[] list = split(words, ' ');

  // Writes the strings to a file, each on a separate line
  saveStrings("data/debugLog.txt", list);

  ///toon = loadShader("ToonFrag.glsl");
  //toon.set("fraction", 1.0);

  CIList.add(new ColorIdentity("Red", color(255, 200, 200), color(120, 5, 0)));
  CIList.add(new ColorIdentity("Blue", color(230, 230, 255), color(5, 5, 100)));
  CIList.add(new ColorIdentity("Green", color(230, 255, 230), color(5, 100, 5)));
  CIList.add(new ColorIdentity("White", color(255, 255, 250), color(50, 50, 50)));
  CIList.add(new ColorIdentity("Black", color(200, 180, 200), color(40, 5, 40)));
  CIList.add(new ColorIdentity("Brown", color(240, 220, 150), color(80, 60, 0)));
  CIList.add(new ColorIdentity("Empty", color(100, 100, 100, 100), color(25, 25, 25, 150)));

  AnimationDatabase.add(new flameSpitter_TargettedAnimation());

  CardDatabase.add(new Card("", "", false, 6, 0, 0, 0));

  Card card_RustSoldier = new Card("Rust Soldier", "Lacking all but honor.", true, 0, 3, 1, 1);
  card_RustSoldier.SetImage("rustsoldier.png");
  CardDatabase.add(card_RustSoldier);

  Card card_FlameSpitter = new Card("Flame Spitter", "Deals 2 Dmg to Opponent at the end of each turn.", false, 0, 0, 2, 2);
  card_FlameSpitter.effectList.add(new effect_DamageOpponent(2, TriggerType.ENDBOTH));
  card_FlameSpitter.SetImage("flamespitter.png");
  CardDatabase.add(card_FlameSpitter);

  Card card_Bright = new Card("Bright", "Deals 1 Dmg to Opponent at the start of your turn.", false, 0, 2, 1, 2);
  card_Bright.effectList.add(new effect_DamageOpponent(1, TriggerType.START));
  card_Bright.SetImage("bright.png");
  CardDatabase.add(card_Bright);

  Card card_HellWall = new Card("Hell Wall", "Deals 3 Dmg to Opponent at the end of your turn.", false, 0, 0, 6, 4);
  card_HellWall.effectList.add(new effect_DamageOpponent(3, TriggerType.END));
  card_HellWall.SetImage("hellwall.png");
  CardDatabase.add(card_HellWall);

  Card card_BonFire = new Card("Bonfire", "Add 1 Red Mana at the end of your turn.", false, 0, 0, 4, 2);
  card_BonFire.effectList.add(new effect_AddMana(1, 0, TriggerType.END));
  card_BonFire.SetImage("bonfire.png");
  CardDatabase.add(card_BonFire);
  
  Card card_Pillager = new Card("Pillager", "Gain 1 Power after dealing damage to opponent.", false, 0, 2, 2, 2);
  //card_Pillager.effectList.add(new effect_AddMana(1, 0, TriggerType.END));
  card_Pillager.SetImage("pillager.png");
  CardDatabase.add(card_Pillager);

  Card card_Fountain = new Card("Fountain", "Ocean calls.", true, 1, 0, 4, 1);
  card_Fountain.SetImage("fountain.png");
  CardDatabase.add(card_Fountain);
  
  Card card_WetOrb = new Card("Wet Orb", "Lower Opposing Card's Attack at the end of your turn.", false, 1, 0,6, 3);
  //card_Pillager.effectList.add(new effect_AddMana(1, 0, TriggerType.END));
  card_WetOrb.SetImage("wetorb.png");
  CardDatabase.add(card_WetOrb);
  
  Card card_Wave = new Card("Wave", "Wave calls.", true, 1, 1, 6, 2);
  card_Wave.SetImage("wave.png");
  CardDatabase.add(card_Wave);
  
  //GREEN
  Card card_Vineyard = new Card("Vineyard", "Tree.", true, 2, 0, 2, 1);
  card_Vineyard.SetImage("vineyard.png");
  CardDatabase.add(card_Vineyard);
  
  //WHITE
  Card card_Captain = new Card("Captain", "Big guy.", true, 3, 0, 5, 1);
  card_Captain.SetImage("captain.png");
  CardDatabase.add(card_Captain);

  Card card_Inn = new Card("Inn", "Heals.", true, 3, 0, 8, 2);
  card_Inn.SetImage("inn.png");
  CardDatabase.add(card_Inn);

  //PURPLE
  Card card_Skeleton = new Card("Skeleton", "Rahhhhhh.", true, 4, 2, 2, 1);
  card_Skeleton.SetImage("skeleton.png");
  CardDatabase.add(card_Skeleton);
  
  //YELLOW
  Card card_Lightning = new Card("Lightning", "Shock shock.", true, 5, 6, 1, 3);
  card_Lightning.SetImage("lightning.png");
  CardDatabase.add(card_Lightning);
  
  Card card_SparkGenerator = new Card("Spark Generator", "At the start of your turn a random card gets 1 charge.", false,5, 0,3, 1);
  //card_Pillager.effectList.add(new effect_AddMana(1, 0, TriggerType.END));
  card_SparkGenerator.SetImage("sparkgenerator.png");
  CardDatabase.add(card_SparkGenerator);
  
 

  //player1ManaList.add(new Mana(CIList.get(0)));
  //player1ManaList.add(new Mana(CIList.get(1)));

  player2ManaList.add(new Mana(CIList.get(3)));

  int wid = 5;
  for (int i = 0; i < wid*2; i++) {
    if (i < wid) {
      //SlotList.add(new Slot(i,(i+1)*width/(wid+1),250));
      //SlotList.add(new Slot(i, (int)((i*cardWid)-cardWid*2), 200));
      SlotList.add(new Slot(i, i, 0));
    } else {
      //SlotList.add(new Slot(i,(i-wid+1)*width/(wid+1),450));
      //SlotList.add(new Slot(i, (int)(((i-wid)*cardWid)-cardWid*2), (int)(200+cardHei)));
      SlotList.add(new Slot(i, i-5, 1));
    }
  }

  //Set player hands
  for (int i = 0; i < 7; i++) {
    player1Hand.Set(CardDatabase.get(0));
  }

  for (int i = 0; i < 7; i++) {
    player2Hand.Set((int)random(0, CardDatabase.size()));
  }
  
  ArrayList colorID2 = new ArrayList<Integer>();
  player2ManaList = new ArrayList<Mana>();
  for(int i = 0; i < player2Hand.cards.size(); i++){
        int compare = player2Hand.cards.get(i).CIID;
        
        if(compare != 6 && !colorID2.contains(compare)){
          colorID2.add(compare);
          player2ManaList.add(new Mana(CIList.get(compare)));
        }
      }

  //StartTurn();
}

void draw() {
  ML.PreLoop();
  
  ML.Loop();

  ML.End();
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
  for (int i = 0; i < 10; i++) {
    TriggerList.add(new Trigger(i + " end", TriggerType.END, i));
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

  for (int i = 0; i < 10; i++) {
    TriggerList.add(new Trigger(i + " end", TriggerType.START, i));
  }
}

void handlePhaseTriggers(TriggerType friendly, TriggerType both) {
  if (TriggerList.size() > 0) {
    print("[" + TriggerList.get(0).name + "]");

    int triggeredSlotID = TriggerList.get(0).slotID;
    Card triggeredCard = SlotList.get(triggeredSlotID).card;

    int e = 0;

    if (triggeredCard != null && triggeredCard.effectList.size() > 0 && ATC == 0) {
      if (e < triggeredCard.effectList.size()) {
        TriggerType tempType = triggeredCard.effectList.get(e).type;
        if (tempType == both || (tempType == friendly && friendlyTurn(triggeredSlotID)))
        {
          triggeredCard.effectList.get(e).Trigger(triggeredSlotID);
          print(triggeredCard.effectList.get(e).name);

          currentCardID = triggeredSlotID;
          if (triggeredCard.effectList.get(e).anim != null) {
            AnimationList.add(triggeredCard.effectList.get(e).anim);
          }
        }

        e++;
      }

      if (e >= triggeredCard.effectList.size()) {
        TriggerList.remove(0);
        e = 0;
      }
    } else if (ATC == 0) {
      TriggerList.remove(0);
      e = 0;
    }
  }
}

boolean friendlyTurn(int slotID) {
  if (slotID < 5 && turn || slotID >= 5 && !turn) {
    return true;
  } else return false;
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

void Resized(){
  
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
  if (systemStatus == SystemStatus.GAME && gameStatus == GameStatus.MAIN) {
    translate(width/2,0);
    for (int i = SlotList.size()/2; i < SlotList.size(); i++) {
      if (SlotList.get(i).ClickSlot(cardID) != -1) {
        SlotList.get(i).Set(player1Hand.cards.get(cardID));
        player1Hand.cards.get(cardID).playable = false;
      }
    }
    translate(-width/2,0);

    cardID = player1Hand.ClickCard();
    if (cardID != -1) {
      //print(player1Hand.cards.get(cardID).name);
      cardSelected = true;
    } else {
      cardSelected = false;
    }
  }
}
