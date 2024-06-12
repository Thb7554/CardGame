enum EffectType {
  ONEND,
  ONSTART
}

abstract class Effect{
  EffectType type;
  
  public abstract void Trigger(Slot slot);
}

class effect_DamageOpponent extends Effect{
  int dmg;
  
  public effect_DamageOpponent(int dmg){
    type = EffectType.ONEND;
    this.dmg = dmg;
  }
  
  public void Trigger(Slot slot){
    if(slot.ID < 5){
      print("HIT");
      player1HP -= dmg; 
    }
    else{
      print("HIT");
      player2HP -= dmg; 
    }
  }
}
