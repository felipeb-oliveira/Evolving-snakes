public enum Direction{
  LEFT, RIGHT, UP, DOWN; 
}

class SnakePart{
  int posX;
  int posY;
  Direction dir;

  public SnakePart(int x, int y){
    // Set variables
    this.posX = x;
    this.posY = y;
    
    // Default starting direction
    this.dir = Direction.UP;
  }
  
  // Constructor overload to set starting direction
  public SnakePart(int x, int y, Direction direction){
    // Set variables
    this.posX = x;
    this.posY = y;
    
    // Set starting direction
    this.dir = direction;
  }
  
  public void move(){
    // Adjust position based on current direction
    switch(this.dir){
      default:
      case UP: {
        this.posY -= 1;
      } break;
      case DOWN: {
        this.posY += 1;
      } break;
      case LEFT: {
        this.posX -= 1;
      } break;
      case RIGHT: {
        this.posX += 1;
      } break;
    }
  }
  
  public int getLastX(){
    // Get last X based on current direction
    switch(this.dir){
      default:
      case UP: {
        return this.posX;
      }
      case DOWN: {
        return this.posX;
      }
      case LEFT: {
        return this.posX + 1;
      }
      case RIGHT: {
        return this.posX - 1;
      }
    }
  }
  
  public int getLastY(){
    // Get last Y based on current direction
    switch(this.dir){
      default:
      case UP: {
        return this.posY + 1;
      }
      case DOWN: {
        return this.posY - 1;
      }
      case LEFT: {
        return this.posY;
      }
      case RIGHT: {
        return this.posY;
      }
    }
  }
  
  public int getX(){
    return this.posX; 
  }
  
  public void setDirection(Direction d){
    this.dir = d; 
  }
  
  public Direction getDirection(){
    return this.dir; 
  }
  
  public int getY(){
    return this.posY; 
  }
  
  public void draw(color c){
    // Draw body part as a rectangle
    fill(c);
    rect(this.posX*gridSize, this.posY*gridSize, gridSize, gridSize);
  }
}

class Snake{
  private ArrayList<SnakePart> body;
  private color Color;
  Boolean alive;
   
  public Snake(int startX, int startY, color c){
    // Init variables
    this.body = new ArrayList<SnakePart>();
    this.Color = c;
    this.alive = true;
    
    // Add snake head
    this.body.add(0, new SnakePart(startX, startY));
    
    // Starting size: 4
    this.grow();
    this.grow();
    this.grow();
  }
  
  public void draw(){
    // Display body
    for(int i = 1; i < body.size(); i++){
       body.get(i).draw(this.Color);
    }
    
    // Set head color as red if dead and normal color if alive
    if(!this.isAlive()){
      body.get(0).draw(color(255, 0, 0));
    } else {
      body.get(0).draw(this.Color);  
    }
  }
  
  public void move(){   
    // Move head
    this.body.get(0).move();
    
    // Update body
    for(int i = body.size()-1; i > 0; i--){
      // Move body part 
       this.body.get(i).move();
       
       // Update direction
       this.body.get(i).setDirection(this.body.get(i-1).getDirection());
    }
    
    // Update alive boolean
    this.checkAlive();
  }
  
  public void grow(){
    // Get last body part's previous position 
    int x = this.body.get(this.body.size()-1).getLastX();
    int y = this.body.get(this.body.size()-1).getLastY();
    Direction dir = this.body.get(this.body.size()-1).getDirection();
    
    // Add new body part
    this.body.add(this.body.size(), new SnakePart(x, y, dir));
  }
  
  public void setDirection(Direction dir) {
    // If valid direction, set to head
    if(isDirectionValid(dir)){
      this.body.get(0).setDirection(dir);
    }
  }
  
  private Boolean checkAlive(){
     int headX = this.body.get(0).getX();
     int headY = this.body.get(0).getY();
     
     // Check for self eating
     for(int i = 1; i < this.body.size(); i++) {
       if(this.body.get(i).getX() == headX && this.body.get(i).getY() == headY){
         this.alive = false;
         return false;  
       }
     }
     
     // Check for board limits
     if(headX*gridSize < gridSize || headY*gridSize < gridSize || headX*gridSize > gridSize*(gridLimit-2) || headY*gridSize > gridSize*(gridLimit-2)){
       this.alive = false;
       return false;
     }
     return true;
  }
  
  // Alive check
  public Boolean isAlive(){
    return this.alive;  
  }
  
  // Check if snake is on tile
  public Boolean isOnTile(int x, int y){
    // Iterate snake
    for(int i = 0; i < this.body.size(); i++) {
      // If check if has body part is on position
      if(this.body.get(i).getX() == x && this.body.get(i).getY() == y){
        return true;  
      }
    }
    return false;
  }
  
  private Boolean isDirectionValid(Direction dir){
    // Check if new direction isn't the opposite of current 
    switch(dir){
      default:
      case UP: {
        return (this.body.get(0).getDirection().ordinal() != Direction.DOWN.ordinal());
      }
      
      case DOWN: {
        return (this.body.get(0).getDirection().ordinal() != Direction.UP.ordinal());
      }
      
      case LEFT: {
        return (this.body.get(0).getDirection().ordinal() != Direction.RIGHT.ordinal());
      }
      
      case RIGHT: {
        return (this.body.get(0).getDirection().ordinal() != Direction.LEFT.ordinal());
      }
    }
  }
  
  public ArrayList<Integer> getBodySensorData(){
    // Sensors data (respectively up, left, down, right)
    ArrayList<Integer> obstacleSensor = new ArrayList<Integer>();
    
    for(int i = 0; i < 4; i++){
      obstacleSensor.add(0);  
    }
    
    // Check body up information
    for(int i = this.body.get(0).getY()-1; i >= 0; i--){
      if(this.isOnTile(this.body.get(0).getX(), i) || i == 0){
        // Add distance to body part or wall on sensor array
        obstacleSensor.set(0, this.body.get(0).getY() - i);
        break;
      }
    }
    
    // Check body left information
    for(int i = this.body.get(0).getX()-1; i >= 0; i--){
      if(this.isOnTile(i, this.body.get(0).getY()) || i == 0){
        // Add distance to body part or wall on sensor array
        obstacleSensor.set(1, this.body.get(0).getX() - i);
        break;
      }
    }
    
    // Check body down information
    for(int i = this.body.get(0).getY()+1; i <= 40; i++){
      if(this.isOnTile(this.body.get(0).getX(), i) || i == 40){
        // Add distance to body part or wall on sensor array
        obstacleSensor.set(2, i - this.body.get(0).getY());
        break;
      }
    }
    
    // Check body right information
    for(int i = this.body.get(0).getX()+1; i <= 40; i++){
      if(this.isOnTile(i, this.body.get(0).getY()) || i == 40){
        // Add distance to body part or wall on sensor array
        obstacleSensor.set(3, i - this.body.get(0).getX());
        break;
      }
    }

    return obstacleSensor;
  }
  
  public ArrayList<Integer> getFoodSensorData(int foodX, int foodY){
    // Sensors data (respectively up, left, down, right)
    ArrayList<Integer> foodSensor = new ArrayList<Integer>();
 
    // Store food distance variable
    foodSensor.add(this.body.get(0).getY() - foodY);

    // Store food distance variable
    foodSensor.add(this.body.get(0).getX() - foodX);
       
    return foodSensor;
  }
  
  public ArrayList<Integer> getSensorData(int foodX, int foodY){
    // Sensors data (respectively up, left, down, right)
    ArrayList<Integer> output = new ArrayList<Integer>();
    
    // Add body and food sensors respectively
    output.addAll(this.getBodySensorData());
    output.addAll(this.getFoodSensorData(foodX, foodY));
   
   return output;
  }
}
