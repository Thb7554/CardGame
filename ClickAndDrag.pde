class ClickAndDrag{
  int x,y;
  int oldX, oldY;
  
  float vel = 0;
  
  float friction = .80f;
  
  int diffX = 0;
  int offset = 0;
  
  int maxX, maxY;
  
  boolean pressing = false;
  
  
  public ClickAndDrag(){
    
  }
  
  public void ClickDown(){
    x = mouseX;
    y = mouseY;
  }
  
  public void ClickContinue(){
    vel = mouseX - oldX;
    
    if(vel >  120) {vel= 120;}
    if(vel < -120) {vel=-120;}
    
    oldX = mouseX;
    oldY = mouseY;
   
    
    diffX = oldX-x+offset; 
  }
  
  public void ClickEnd(){
    offset = diffX;
  }
  
  public void Draw(){
    fill(200,250,0);
    ellipse(x,y,50,50); 
    
    fill(150,0,250);
    ellipse(oldX,oldY,50,50); 
  }
  
  public void Reset(int min, int max){
    if(diffX < min){
      diffX += (min-diffX)/6+1;
      diffX = min(diffX, min);
      vel = 0;
    }
    else if(diffX > max){
      diffX -= (diffX-max)/6+1;
      diffX = max(diffX, max);
      vel = 0;
    }
    
    offset = diffX;
  }
  
  public void Move(){
    diffX += vel;
    offset = diffX;
    
    vel *= friction;
    
    
    if(abs(vel) < .1){
      vel=0; 
    }
  }
}
