class Slot {
  int cardID;
  int ID;
  int x, y;

  Card card;

  public Slot(int ID, int x, int y) {
    this.ID = ID;
    cardID = -1;
    this.x = x;
    this.y = y;
  }
  
  public int adjustedX(){
    return (int)(x*cardWid-2*cardWid);
  }
  
  public int adjustedY(){
    return (int)(y*cardHei - cardHei*3/2 + height/2);
  }

  public void Set(int ID) {
    Set(CardDatabase.get(ID));
  }

  public void Set(Card card) {
    print(card.name);
    this.card = new Card(card.ID, card.name, card.description,card.flavor, card.CIID, card.atk, card.maxHP, card.cost);
    this.card.effectList = card.effectList;
    if(card.img != null){
      this.card.img = card.img;
    }
  }

  public void Draw() {
    translate(x*cardWid-2*cardWid + width/2, (1+y)*cardHei);
    fill(50, 50, 50, 20);
    rect(0, 0, cardWid, cardHei);

    if (this.card != null) {
      this.card.Draw(false, false);
    }
    else{
      fill(0,0,0,180);
      textSize(24);
      text(ID,10,10); 
    }


    translate(-x*cardWid+2*cardWid - width/2, -((1+y)*cardHei));
    //translate(-x, -y);
  }

  public void DrawAttack(float time) {
    fill(this.card.CI.c);
    stroke(this.card.CI.cc);
    strokeWeight(2);
    translate(x*cardWid-2*cardWid + width/2, (1+y)*cardHei);

    int mod = 1;
    if (!turn) {
      mod = -1;
    }

    //rect(0, 1.5*mod*cardHei*sin(time*PI/2)-mod*cardHei/2, cardWid, mod*cardHei*sin(time*PI/2));
    rect(0,  0 + cardHei*sin(time*PI/2)*mod, cardWid, cardHei);
    strokeWeight(1);
    noStroke();
    translate(-x*cardWid+2*cardWid - width/2, -((1+y)*cardHei));
  }

  public void Die() {
    print(this.card.name + " died");

    this.cardID = -1;
    this.card = null;
  }

  public void Attack(int defenderID) {
    Slot Defender = SlotList.get(defenderID);

    if (Defender.card != null) {
      Defender.card.curHP -= this.card.atk;

      if (Defender.card.curHP <= 0) {
        Defender.Die();
      }
    } else {
      if (!turn) {
        player1HP -= this.card.atk;
      } else {
        player2HP -= this.card.atk;
      }
      
      if(player1HP <= 0 || player2HP <= 0){
        gameStatus = GameStatus.RESULTS;
        if(player1HP <= 0 && player2HP > 0){
        winStatus = WinStatus.PLAYER2;
        mones += 100;
        }
        else if(player2HP <= 0 && player1HP > 0){
          winStatus = WinStatus.PLAYER1;
        }
        else if (player1HP <= 0 && player2HP <= 0)
        {
          winStatus = WinStatus.TIED;
        }
      }
    }
  }

  public int ClickSlot(int cardID) {
    int slotID = -1;

    int calcMouseX = mouseX - width/2;
    int calcMouseY = mouseY + (int)cardHei - height/2;
    
    print("      ");
    print(ID + ":");
    print(calcMouseX + "|x");
    
    int xmin = (int)(((x)*cardWid)-cardWid*5/2);
    int xmax = (int)(((x)*cardWid)-cardWid*3/2);
    
    print(xmin + "|");
    print(xmax + "| ");
    
    int ymin = (int)(y*cardHei - cardHei/2);
    int ymax = (int)(y*cardHei + cardHei/2);
    
    print(calcMouseY + "|y");
    print(ymin + "|");
    print(ymax + "|");

    //(int)(((x-5)*cardWid)-cardWid*2), 200+y*cardHei

    if (calcMouseX > xmin && 
        calcMouseX < xmax && 
        calcMouseY > ymin && 
        calcMouseY < ymax) {
      fill(255, 0, 0);
      rect(x*cardWid-cardWid*2, y*cardHei + (int)cardHei, cardWid, cardHei);
      slotID = ID;

      //"Creature" only logic, doesnt allow cards that target occupied spaces
      //           |
      //           V
      if (this.card != null || cardID == -1 || !CheckCost(cardID)) {
        return -1;
      };
    }

    return slotID;
  }

  public boolean CheckCost(int cardID) {
    Card card = player1Hand.cards.get(cardID);

    for (int i = 0; i < player1ManaList.size(); i++) {
      if (card.CI == player1ManaList.get(i).CI) {
        if (card.cost <= player1ManaList.get(i).number) {
          player1ManaList.get(i).number = player1ManaList.get(i).number - card.cost;

          return true;
        }
      }
    }

    return false;
  }
}
