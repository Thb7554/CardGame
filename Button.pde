class Button{
  int x,y,w,h;
  String bText = "test";
  Boolean enabled = true;
  Boolean hidden = false;
  Boolean centered;
  
  Boolean widthAnchor = false;
  Boolean heightAnchor = false;
  
  
  color bColor = color(255,255,255);
  
  public Button(String bText, Boolean centered, int x, int y, int w, int h){
    this.bText = bText;
    this.centered = centered;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  public Boolean Click(){
    if(enabled && !hidden){
      if(centered){
        if(x-w/2 <= mouseX && mouseX <= (x + w/2) && y-h/2 <= mouseY && mouseY <= (y + h/2)){
          ProcessClick();
          return true; 
        }
      }
      else{
        if(x <= mouseX && mouseX <= (x + w) && y <= mouseY && mouseY <= (y + h)){
          ProcessClick();
          return true; 
        }
      }
    }
    return false;
  }
  
  public void ProcessClick(){
        //print("# x" + x + "|" + mouseX + " #");
        //print("# y" + y + "|" + mouseY + " #");
        //print("# x+w" + (x + w) + "|" + mouseY + " #");
        //print("# y+h" + (y + h) + "|" + mouseY + " #");
        
        print(bText);
        
        buttonPress.play();
        
        
        //enabled = false;
        bColor = color(255,255,0);   
  }
  
  public void Draw(){
    textSize(20);
    if(hidden){
      return; 
    }

    
    if(centered){
      rectMode(CENTER); 
    }
    else{
      rectMode(CORNER); 
    }
    if(enabled){
      fill(bColor);
      rect(x,y,w,h); 
      fill(0,0,0);
      textAlign(CENTER);
      text(bText,x,y);
      bColor = color(255,255,255);
    }
    else{
      fill(200,200,200);
      rect(x,y,w,h); 
      fill(85,85,85);
      textAlign(CENTER);
      text(bText,x,y);
    }

  }
}
