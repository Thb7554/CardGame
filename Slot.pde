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

  public void Set(int ID) {
    Set(CardDatabase.get(ID));
  }

  public void Set(Card card) {
    print(card.name);
    this.card = new Card(card.name, card.description, card.CIID, card.atk, card.maxHP, card.cost);
    this.card.effectList = card.effectList;
  }

  public void Draw() {
    translate(x, y);
    fill(50, 50, 50, 20);
    rect(0, 0, cardWid, cardHei);

    if (this.card != null) {
      this.card.Draw();
    }

    translate(-x, -y);
  }

  public void DrawAttack(float time) {
    fill(this.card.CI.c);
    stroke(this.card.CI.cc);
    strokeWeight(2);
    translate(x, y);

    int mod = 1;
    if (!turn) {
      mod = -1;
    }

    rect(0, 1.5*mod*cardHei*sin(time*PI/2)-mod*cardHei/2, cardWid, mod*cardHei*sin(time*PI/2));
    strokeWeight(1);
    noStroke();
    translate(-x, -y);
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
    }
  }

  public int ClickSlot(int cardID) {
    int slotID = -1;

    if (mouseX > x - cardWid/2 && mouseX < x+cardWid/2 && mouseY > y - cardHei/2 && mouseY < y+cardHei/2) {
      fill(255, 0, 0);
      rect(x, y, cardWid, cardHei);
      slotID = ID;

      //"Creature" only logic, doesnt allow cards that target occupied spaces
      //           |
      //           V
      if (this.card != null || !CheckCost(cardID)) {
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
