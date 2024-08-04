enum TriggerType {
  END,
  ENDBOTH,
  DAMAGE,
  ATTACK
}

class Trigger{
  TriggerType type;
  String name;
  int slotID;
  
  public Trigger(String name, TriggerType type, int slotID){
    this.name = name;
    this.type = type;
    this.slotID = slotID;
  }
}
