class Button {
  int posX;
  int posY;
  int boxWidth;
  int boxHeight;
  color Color;
  String text;
  
  public Button(int x, int y, int w, int h, color Color){
    this.posX = x;
    this.posY = y;
    this.boxWidth = w;
    this.boxHeight = h;
    this.Color = Color;
    this.text = "";
  }
  public Button(int x, int y, int w, int h, color Color, String text){
    this.posX = x;
    this.posY = y;
    this.boxWidth = w;
    this.boxHeight = h;
    this.Color = Color;
    this.text = text;
  }
  
  public void draw(){
    // Draw rectangle with selected color
    fill(this.Color);
    rect(posX, posY, boxWidth, boxHeight);
    
    // Choose text color based on brightness
    if(brightness(this.Color) > 127){
      fill(20);
    } else {
      fill(230);
    }
    
    // Set button text
    textAlign(CENTER, CENTER);
    textSize(30);
    text(this.text, this.posX + (this.boxWidth/2), this.posY + (this.boxHeight/2));
    
  }
  
  public Boolean isPressed(){
    // If mouse pressed
    if(mousePressed) {
      
      // If mouse pressed inside button area
      if(mouseX >= this.posX && mouseX <= this.posX+this.boxWidth){
        if(mouseY >= this.posY && mouseY <= this.posY+this.boxHeight){
          return true;
        }
      }
    }
    return false;
  }
  
  
}
