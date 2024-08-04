abstract class Effect {
  TriggerType type;

  String name;

  public abstract void Trigger(Slot slot);

  public abstract void Trigger(int slotID);

  public abstract void Draw(Slot slot);
}

class effect_DamageOpponent extends Effect {
  int dmg;

  public effect_DamageOpponent(int dmg) {
    type = TriggerType.END;
    this.dmg = dmg;
    name = "effect_DamageOpponent";
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
