class TextArea {
  float x,y,w,h;
  String strText;
  String computedText = "";
  String[] textArray;
 
  public TextArea(String test){
    x = 200;
    y = 250;
    w = random(50,200);
    h = 200;
    
    strText = test;
    
    CalcAndCut();
  }
  
  public void CalcAndCut(){
    //String[] output = {strText};
    //saveStrings("data/debugLog.txt", output);

    //if(strText == null || strText.trim().isEmpty()) { return; }
    computedText = "";
   
    textArray = strText.split(" ");

    textSize(25);
    
    float wCur = 0;
    for(int i = 0; i < textArray.length; i++){
      print(textArray[i]);
      print(" " + textWidth(textArray[i] + " ") + " ");
      
      wCur += textWidth(textArray[i] + " ");
      
      if(wCur >= w){
        //computedText += wCur + "/" +  (w - 8) + "\n" + textArray[i] + " ";
        computedText += "\n";
        wCur = textWidth(textArray[i] + " ");
      }
      computedText += textArray[i] + " ";
    }
    
   
  }
  
  public void Draw(){
    textAlign(LEFT);
    fill(5,5,5,10);
    rect(x,y,w,h);
    fill(50,50,50);
    textSize(25);
    text(computedText, x-w/2+2,y-h/2+25);
  }
  
  public void Resize(float x, float y, float w, float h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    this.CalcAndCut();
  }
}
