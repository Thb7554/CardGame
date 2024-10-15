abstract class Effect {
  TriggerType type;

  String name;

  Animation anim;

  public abstract void Trigger(Slot slot);

  public abstract void Trigger(int slotID);

  public abstract void Draw(Slot slot);
}

class effect_DamageOpponent extends Effect {
  int dmg;

  public effect_DamageOpponent(int dmg, TriggerType triggerT) {
    type = triggerT;
    this.dmg = dmg;
    name = "effect_DamageOpponent";
    anim = AnimationDatabase.get(0);
  }

  public void Trigger(Slot slot) {
    if (slot.ID < 5) {
      player2HP -= dmg;
    } else {
      player1HP -= dmg;
    }
  }

  public void Trigger(int slotID) {
    if (slotID < 5) {
      player2HP -= dmg;
    } else {
      player1HP -= dmg;
    }
  }

  public void Draw(Slot slot) {
    fill(255,0,0);
    ellipse(slot.x, slot.y, 100, 100);
  }
}

class effect_AddMana extends Effect {
  int amount;
  int colorID;

  public effect_AddMana(int amount, int colorID, TriggerType triggerT) {
    type = triggerT;
    this.amount = amount;
    this.colorID = colorID;
    name = "effect_AddMana";
    anim = null;
  }

  public void Trigger(Slot slot) {
    if (slot.ID >= 5) {
      for(int i = 0; i < player1ManaList.size(); i++){
        if(player1ManaList.get(i).CI == CIList.get(colorID)){
          player1ManaList.get(i).number+=amount; 
        }
      }
      
    } else {
       for(int i = 0; i < player2ManaList.size(); i++){
        if(player2ManaList.get(i).CI == CIList.get(colorID)){
          player2ManaList.get(i).number+=amount; 
        }
      }
    }
  }

  public void Trigger(int slotID) {
    if (slotID >= 5) {
      for(int i = 0; i < player1ManaList.size(); i++){
        if(player1ManaList.get(i).CI == CIList.get(colorID)){
          player1ManaList.get(i).number+=amount; 
        }
      }
      
    } else {
       for(int i = 0; i < player2ManaList.size(); i++){
        if(player2ManaList.get(i).CI == CIList.get(colorID)){
          player2ManaList.get(i).number+=amount; 
        }
      }
    }
  }

  public void Draw(Slot slot) {
    //fill(255,0,0);
    //ellipse(slot.x, slot.y, 100, 100);
  }
}
