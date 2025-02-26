class MainLogic {
 public MainLogic(){
   
 }
 
 void PreLoop(){
  if(tijiWidth != width || tijiWidth != height){
    startGame.x = width/2;
    startGame.y = height/2;
    
    editDeck.x = width/2;
    editDeck.y = height/2+100;
    
    backToMenu.x = width/2;
    backToMenu.y = height/2-200;
    
    toSettings.x = width/2;
    toSettings.y = height/2+300;
    
    fromSettings.x = width/2;
    fromSettings.y = height/2-200;
    
    returnToMenu.x = width/2;
    returnToMenu.y = height/2-200;
  }
  
  cardWid = baseCardWid * width/1200;
  cardHei = baseCardHei * height/900;
  

    
  noStroke();
  t += .04;

  processInput();
 }
 
 void PrepareGame(){
     player1HP = 10;
     player2HP = 10;


     player1ManaList = new ArrayList<Mana>();
     
     ArrayList colorID = new ArrayList<Integer>();
     for(int i = 0; i < player1Hand.cards.size(); i++){
       int compare = player1Hand.cards.get(i).CIID;
        
       if(compare != 6 && !colorID.contains(compare)){
         colorID.add(compare);
         player1ManaList.add(new Mana(CIList.get(compare)));
       }
     }
     
     for (int i = 0; i < player1Hand.cards.size(); i++) {
       player1Hand.cards.get(i).playable = true;
     }
     
     
     player2ManaList = new ArrayList<Mana>();
   
     for (int i = 0; i < 7; i++) {
      player2Hand.Set((int)random(0, CardDatabase.size()));
     }
  
     for (int i = 0; i < player2Hand.cards.size(); i++) {
       player2Hand.cards.get(i).playable = true;
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
     
      SlotList = new ArrayList<Slot>();
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
 }
 
 void Loop(){
   //-------------------------------------------------------------------------------------------MENU
  if (systemStatus == SystemStatus.MENU) {
    background(230+6*cos(t/5), 230+6*cos(t/5), 230+6*cos(t/5));

    startGame.Draw();
    editDeck.Draw();
    toSettings.Draw();
    

    
    textAlign(RIGHT);
    fill(150,110,25);
    image(goldImg,58,33,18,18);
    text(mones, 50, 40);
    fill(0,0,0);
    
    if(player1ManaList.size() > 0){
      startGame.enabled = true;
    }
    else{
      startGame.enabled = false;
    }
    
    if (mousePressed && startGame.Click()) {
      systemStatus = SystemStatus.GAME;
      winStatus = WinStatus.ONGOING;
      
      PrepareGame();
      
      StartTurn();
    }
    if (mousePressed && editDeck.Click()) {
     for (int i = 0; i < player1Hand.cards.size(); i++) {
       player1Hand.cards.get(i).playable = true;
     }
      
      systemStatus = SystemStatus.EDIT;
    }
    if (mousePressed && toSettings.Click()) {
      systemStatus = SystemStatus.SETT;
    }

    return;
  }


  //-------------------------------------------------------------------------------------------SETTINGS
  if (systemStatus == SystemStatus.SETT) {
    background(200, 220, 180);
    
    fromSettings.Draw();
    if (mousePressed && fromSettings.Click()) {
      systemStatus = SystemStatus.MENU;
    }

    return;
  }
  
  //-------------------------------------------------------------------------------------------EDIT
  if (systemStatus == SystemStatus.EDIT) {
    
    pushMatrix();
    
    background(150, 150, 250);
     
    int xDis = (int)cardWid + 10;
     
    backToMenu.Draw();

    if (mousePressed && mouseY < height/2 + 125 && !CAD.pressing) {
      CAD.ClickDown();
      CAD.pressing = true;
    } else if (mousePressed && CAD.pressing) {
      CAD.ClickContinue();
    } else if (!mousePressed && CAD.pressing) {
      CAD.ClickEnd();
      CAD.pressing = false;
    }

    fill(0, 0, 0, 60);
    rect(width/2, height/2, width*2, 230);
    
    translate(width/2, 250+height/2);
    
    int[] IDList = new int[7];
       

    translate(-3.5*150+75,0);
    
    for (int i = 0; i < player1Hand.cards.size(); i++) {
      player1Hand.cards.get(i).SmallDraw(0, 0);
      textAlign(CENTER);
      
      if(player1Hand.cards.get(i).ID != -1){
        fill(250, 255, 0);
        rect(-50, -80, 20, 20);
        fill(0, 0, 0);
        text(player1Hand.cards.get(i).ID, -50, -75);
      }
      
      IDList[i] = player1Hand.cards.get(i).ID;
      
      translate(150, 0);
    }
    translate(-3.5*150-75, 0);
    translate(0, -250);

    fill(255, 255, 255);
    rect(0, 0, 150, 150);

    translate(CAD.diffX, 0);
    

    if (mousePressed && mouseY > height/2+cardHei/2) {
      float i = (width/2 + -3.5*150 - mouseX)/-150;

      print("xX" + (int)i + "Xx");
      
      if(i >= 0 && i < 7){
        if(mouseButton == LEFT && selectedCard != -1){
          player1Hand.Set(selectedCard, (int)(i));
          selectedCard = -1;
        }
        if(mouseButton == RIGHT){
          player1Hand.Set(0, (int)(i));
        }
      }
    }
    
    if (mousePressed && mouseY < height/2+cardHei/2) {
      float i = ((-(float)CAD.diffX + mouseX-width/2 + 80)/xDis);

      //ellipse(i,20,140,140);

      if (i >= 0 && i < CardDatabase.size()-1) {
        print(" -" + CardDatabase.get((int)i+1).ID + "- ");
        selectedCard = (int)i+1;
      }
    }
    else if(!mousePressed){
      CAD.Reset(-(int)xDis * (CardDatabase.size()-1)+(int)xDis,0);
      CAD.Move();
    }

    //translate(200*sin(t),0);

    for (int i = 1; i < CardDatabase.size(); i++) {
      int cardsSeen = -CAD.diffX/xDis+5;
      
      if(cardsSeen - 11 < i && i < cardsSeen+2){
        CardDatabase.get(i).Draw(true, true);
        textAlign(CENTER);
      }
      

      
      if(selectedCard == i){
        fill(240,240,240,100);
        ellipse(0,0,150,200);
      }
      
      fill(250, 255, 0);
      
      for (int j = 0; j < IDList.length; j++) {
        if(IDList[j] == CardDatabase.get(i).ID){
          fill(15,255,15);
        }
      }
      
      rect(-55, -115, 40, 30);
      fill(0, 0, 0);
      text(CardDatabase.get(i).ID, -55, -105);
      translate(xDis, 0);
    }
    
    popMatrix();


    if (mousePressed && backToMenu.Click()) {
      selectedCard = -1;
      systemStatus = SystemStatus.MENU;
      
      ArrayList colorID = new ArrayList<Integer>();
      player1ManaList = new ArrayList<Mana>();
      
      for(int i = 0; i < player1Hand.cards.size(); i++){
        int compare = player1Hand.cards.get(i).CIID;
        
        if(compare != 6 && !colorID.contains(compare)){
          colorID.add(compare);
          player1ManaList.add(new Mana(CIList.get(compare)));
        }
      }
    }

    return;
  }

  //-------------------------------------------------------------------------------------------GAME
  if (gameStatus == GameStatus.OPENING) {
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
    fill(250, 220, 100);
    ellipse(40, 15*(i+1), 15, 15);
    fill(0, 0, 0);
    text(TriggerList.get(i).slotID, 40, 15*(i+1));
  }


  for (int i = 0; i < SlotList.size(); i++) {
    SlotList.get(i).Draw();
  }

  if (AnimationList.size() > 0) {
    AnimationList.get(0).Draw(ATC);
    ATC++;
    if (ATC > AnimationList.get(0).maxFrame) {
      AnimationList.remove(0);
      ATC = 0;
    }
  }

  if (gameStatus==GameStatus.END) {
    handlePhaseTriggers(TriggerType.END, TriggerType.ENDBOTH);
  }

  if (gameStatus==GameStatus.START) {
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
  textAlign(CENTER);
  text(player1HP, width/2, 50);
  text(player2HP, width/2, height-50);

  for (int i = 0; i < player1ManaList.size(); i++) {
    player1ManaList.get(i).Draw(i, 0);
  }

  for (int i = 0; i < player2ManaList.size(); i++) {
    player2ManaList.get(i).Draw(i, -400);
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

  for (int i = 0; i < player1Hand.cards.size(); i++) {
    int cardX = (i+1)*width/(player1Hand.cards.size()+1);
    int cardY = height-150;
    if (mouseX < cardX + 50 && mouseX > cardX - 50 && mouseY > cardY-80 && mouseY < cardY+80){
      player1Hand.cards.get(i).Hover(cardX, cardY);
    }
    else{
      player1Hand.cards.get(i).hoverTimer = 0;
    }
  }
  
    if(winStatus != WinStatus.ONGOING){
    noStroke();
    if(winStatus == WinStatus.PLAYER2){
      fill(0,0,200,150);
    }
    else if(winStatus == WinStatus.PLAYER1){
      fill(200,0,0,150);
    }
    else{
      fill(150,150,150,150);
    }
    
    rect(width/2,height/2,width,height);
  }
  

  if(gameStatus == GameStatus.RESULTS){
    returnToMenu.hidden = false;
    
    returnToMenu.Draw();
    
    if (mousePressed && returnToMenu.Click()) {
      returnToMenu.hidden = true;
      systemStatus = SystemStatus.MENU;
      gameStatus = GameStatus.MAIN;
    }
  }


  if (gameStatus == GameStatus.START && TriggerList.size() == 0 && AnimationList.size() == 0) {
    gameStatus = GameStatus.MAIN;
    if (!turn) {
      print("| YOUR TURN |");
    } else {
      print("| THEIR TURN |");
    }
    return;
  }

  if (gameStatus == GameStatus.END && TriggerList.size() == 0 && AnimationList.size() == 0) {
    EndTurn();

    return;
  }
  
  
 }
 
 void End(){
  textSize(15);
  fill(0, 0, 0, 200);
  textAlign(RIGHT);
  text(frameRate, width-10, 30);

  
  fill(0,0,0,200);
  text(width, 40,40);
  text(height, 40,80);
 }
}
