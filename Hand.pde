class Hand {
  ArrayList<Card> cards = new ArrayList<Card>();
  ArrayList<Boolean> playable = new ArrayList<Boolean>();

  public Hand() {
  }

  public void Set(int ID) {
    Card tempCard = CardDatabase.get(ID);
    this.cards.add(new Card(tempCard.name, tempCard.description, tempCard.CIID));
  }

  public void Draw() {
    //translate(width/2,0);
    cards.get(2).playable = false;
    cards.get(3).playable = false;
    cards.get(4).playable = false;
    cards.get(5).playable = false;

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
}
