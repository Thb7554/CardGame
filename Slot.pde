class Slot {
  int cardID;
  int ID;
  int x,y;
  
  Card card;
  
  public Slot(int ID, int x, int y){
    this.ID = ID;
    cardID = -1;
    this.x = x;
    this.y = y;
  }
  
  public void Set(int ID){
    cardID = ID;
    Card tempCard = CardDatabase.get(ID);
    this.card = new Card(tempCard.name, tempCard.description, tempCard.CIID);
  }
  
  public void Draw(){
    translate(x,y);
    fill(50,50,50,20);
    rect(0,0,cardWid,cardHei);
    
    if(cardID != -1){
      this.card.Draw();
    }
    
    translate(-x,-y);
  }
  
  public void DrawAttack(int t){
    fill(240,200,250);
    translate(x,y);
    rect(0,0,50,t*4);
    
    translate(-x,-y);
  }
  
  public void Die(){
    print(this.card.name + " died");
    
    this.cardID = -1;
    this.card = null;
  }
  
  public void Attack(int defenderID){
    
    
    Slot Defender = SlotList.get(defenderID);
    
    if(Defender.card != null){
      Defender.card.curHP -= this.card.atk;
      
      if(Defender.card.curHP < 0){
        Defender.Die();
      }
      
    }
    else{
      if(!turn){
        player1HP -= this.card.atk;
      }
      else{
        player2HP -= this.card.atk;
      }
    }
  }
  
  public int ClickSlot(){
    int slotID = -1;
    
    if(mouseX > x - cardWid/2 && mouseX < x+cardWid/2 && mouseY > y - cardHei/2 && mouseY < y+cardHei/2){
      fill(255,0,0);
      rect(x,y,cardWid,cardHei);
      slotID = ID;
    }
    
    return slotID;
  }
}
