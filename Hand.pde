class Hand {
  ArrayList<Card> cards = new ArrayList<Card>();
  ArrayList<Boolean> playable = new ArrayList<Boolean>();

  public Hand() {
  }

  public void Set(int ID) {
    Set(CardDatabase.get(ID));
  }


  public void Set(Card card) {
    Card tempCard = card;
    Card c = new Card(tempCard.name, tempCard.description, tempCard.CIID, tempCard.atk, tempCard.maxHP, tempCard.cost);
    c.effectList = tempCard.effectList;
    if(card.img != null){
      c.img = card.img;
    }
    this.cards.add(c);
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

  public int ClickCard() {
    int cardID = -1;
    for (int i = 0; i < cards.size(); i++) {
      int x = (i+1)*width/(cards.size()+1);
      int y = height-150;

      if (this.cards.get(i).playable && mouseX < x + 50 && mouseX > x - 50 && mouseY > y-80 && mouseY < y+80) {
        fill(255, 0, 0);
        rect(x, y, 100, 160);
        this.cards.get(i).selected = true;
        cardID = i;
      } else {
        this.cards.get(i).selected = false;
      }
    }
    return cardID;
  }
}
