class ClickAndDrag{
  int x,y;
  int oldX, oldY;
  
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
}
