class Hand {
  ArrayList<Card> cards = new ArrayList<Card>();
  ArrayList<Boolean> playable = new ArrayList<Boolean>();

  public Hand() {
  }

  public void Set(int ID) {
    Card tempCard = CardDatabase.get(ID);
    this.cards.add(new Card(tempCard.name, tempCard.description, tempCard.CIID, tempCard.atk, tempCard.maxHP, tempCard.cost));
  }
  
  public void Set(Card card) {
    Card tempCard = card;
    this.cards.add(new Card(tempCard.name, tempCard.description, tempCard.CIID, tempCard.atk, tempCard.maxHP, tempCard.cost));
  }

  public void Draw() {
    for (int i = 0; i < cards.size(); i++) {

      int x = (i+1)*width/(cards.size()+1);
      int y = height-150;

      translate(x, y);

      if (i < cards.size()) {
        cards.get(i).SmallDraw(x, y);
      }

      translate(-x, -y);
    }
    //translate(-width/2,0);
  }
  
  public int ClickCard(){
    int cardID = -1;
    for (int i = 0; i < cards.size(); i++) {
      int x = (i+1)*width/(cards.size()+1);
      int y = height-150;
        
      if(this.cards.get(i).playable && mouseX < x + 50 && mouseX > x - 50 && mouseY > y-80 && mouseY < y+80){
        fill(255,0,0);
        rect(x,y,100,160);
        this.cards.get(i).selected = true;
        cardID = i;
      }
      else {
        this.cards.get(i).selected = false;   
      }
      
    }
    return cardID;
  }
}
