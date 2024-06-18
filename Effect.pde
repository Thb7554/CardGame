enum EffectType {
  ONEND,
  ONSTART
}

abstract class Effect {
  EffectType type;

  public abstract void Trigger(Slot slot);

  public abstract void Draw(Slot slot);
}

class effect_DamageOpponent extends Effect {
  int dmg;

  public effect_DamageOpponent(int dmg) {
    type = EffectType.ONEND;
    this.dmg = dmg;
  }

  public void Trigger(Slot slot) {
    if (slot.ID < 5) {
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
