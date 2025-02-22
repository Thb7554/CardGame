class TextArea {
  float x,y,w,h;
  String strText;
  String computedText = "";
  String[] textArray;
  
  float pW, pH;
  
  int tSize;
   
  public TextArea(String test, int tSizeIN, int xIN, int yIN, int wIN, int hIN){
    tSize = tSizeIN;
    x = xIN;
    y = yIN;
    w = wIN;
    h = hIN;
    
    strText = test;
    
    CalcAndCut();
  }
  
  public void CalcAndCut(){
    //String[] output = {strText};
    //saveStrings("data/debugLog.txt", output);

    //if(strText == null || strText.trim().isEmpty()) { return; }
    computedText = "";
   
    textArray = strText.split(" ");

    textSize(12);
    float totalWid = textWidth(strText);
    
    tSize = (int)(60-totalWid/4);
    tSize = min((int)(w*h)/400, tSize);
    tSize = max(12, tSize);
    
    textSize(tSize);
    
    float wCur = 0;
    for(int i = 0; i < textArray.length; i++){
      print(textArray[i]);
      print(" " + textWidth(textArray[i] + " ") + " ");
      
      wCur += textWidth(textArray[i] + " ");
      
      if(wCur+4 >= w){
        //computedText += wCur + "/" +  (w - 8) + "\n" + textArray[i] + " ";
        computedText += "\n";
        wCur = textWidth(textArray[i] + " ");
      }
      computedText += textArray[i] + " ";
    }
    
   
  }
  
  public void Draw(){
     InnerDraw(255);
  }
  
  public void Draw(int hoverTimer){
    InnerDraw(hoverTimer);
  }
  
  public void InnerDraw(int hoverTimer){
    textAlign(LEFT);
    fill(0,0,0,150);
    noStroke();
    rect(x,y,w,h);
    stroke(0,0,0);
    fill(255,255,255,hoverTimer);
    textSize(tSize);
    textLeading(tSize);
    text(computedText, x-w/2+4,y-h/2+tSize*2/3+5);
    fill(0,0,0);
  }
  
  public void Resize(float x, float y, float w, float h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    this.CalcAndCut();
  }
}
