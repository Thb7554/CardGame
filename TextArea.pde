class TextArea {
  float x,y,w,h;
  String strText;
  String[] textArray;
 
  public TextArea(String test){
    x = 50;
    y = 50;
    w = 200;
    h = 200;
    
    strText = test;
  }
  
  public void CalcAndCut(){
    textSize(12);
    
    print(strText);
    textArray = strText.split(" ");
    
    for(int i = 0; i < textArray.length; i++){
      print(textArray[i]);
      print(" " + textWidth(textArray[i]) + " ");
    }
    
  }
  
  public void Draw(){
    fill(200,200,230);
    rect(x,y,w,h);
    fill(50,50,50);
    textSize(12);
    text(strText, x, y);
  }
}
