enum AnimationType {
  DEFAULT,
    TARGETTED
}

abstract class Animation {
  int maxFrame;
  boolean active;
  AnimationType animType;

  public abstract void Draw(int frame);
}

abstract class TargettedAnimation extends Animation {
  int sourceID;
  int targetID;

  public abstract void Draw(int frame);
}

class flameSpitter_TargettedAnimation extends TargettedAnimation {
  public flameSpitter_TargettedAnimation(){
    animType = AnimationType.TARGETTED;
    maxFrame = 25;
  }
  

  public void Draw(int frame) {
    float l = frame;

    float lX = lerp(SlotList.get(currentCardID).x, width/2, l/maxFrame);
    float lY = lerp(SlotList.get(currentCardID).y, 50, l/maxFrame);

    fill(255, 150, 0);
    ellipse(lX, lY, 40, 40);
  }
}
