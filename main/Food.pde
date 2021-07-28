class Food{
  int posX;
  int posY;
  color Color;
  
  public Food(int x, int y){
    // Init variables
    this.posX = x;
    this.posY = y;
    this.Color = color(int(random(255)), int(random(255)), int(random(255)));
  }
  
  public void draw(){
    // Draw rectangle at desired position
    fill(this.Color);
    rect(this.posX*gridSize, this.posY*gridSize, gridSize, gridSize);
  }
  
  public int getX(){
    return this.posX;
  }
  
  public int getY(){
    return this.posY;
  }
}
