class Game {
  Snake snake;
  int score;
  
  int gameTick; //ms
  float gameTimer;
  float lastTickTimer;
  Food food;
  char lastKeyPressed;
  
  int tickCounter;
  int tickLimit;
  
  Boolean humanPlayer;
  
  public Game(Boolean humanPlayer, int tick){
     // Init game variables
     this.snake = new Snake(20, 20, color(255, 255, 255));
     this.gameTimer = 0;
     this.food = this.generateFood();
     this.humanPlayer = humanPlayer;
     
     // Steps counter
     this.tickCounter = 0;
     
     // Game tick time
     this.gameTick = tick;
     
     // Max steps before dying
     this.tickLimit = 400;
  }
  
  public void loop(){
    // Check pressed key
    if(keyPressed && this.humanPlayer){
      this.lastKeyPressed = key;
    }
    
    // Update game timer
    gameTimer = millis();
    
    // Check game tick
    if(gameTimer - lastTickTimer > gameTick){
      // Save last tick timer
      lastTickTimer = millis();
      this.tickCounter++;
      
      // Get pressed key and set direction
      switch(this.lastKeyPressed){
        case 'w': {
          this.snake.setDirection(Direction.UP);
        } break;
        
        case 'a': {
          this.snake.setDirection(Direction.LEFT);
        } break;
        
        case 's': {
          this.snake.setDirection(Direction.DOWN);
        } break;
        
        case 'd': {
          this.snake.setDirection(Direction.RIGHT);
        } break;
        
        case 'q': {
          this.snake.grow();
        } break;
      }
      
      // Erase last pressed key
      this.lastKeyPressed = '\0';
      
      // Move snake
      this.snake.move();
      
      // Check for food eaten
      if(this.eatenFood()){
        this.food = this.generateFood();
        this.snake.grow();
        this.tickCounter = 0;
        score++;
      }
    }
    
    if(this.humanPlayer){
      println("MLP input: " + this.getMLPData());
    }
  }
  
  public Boolean hasEnded() {
    return !this.snake.isAlive() || this.hasLooped();  
  }
  
  public Boolean hasLooped(){
    return this.tickCounter > this.tickLimit;
  }
  
  public void draw(){
    // Draw board
    fill(100);
    rect(gridSize, gridSize, gridSize*(gridLimit-2), gridSize*(gridLimit-2));
    
    // Draw snake
    this.snake.draw();
    
    // Draw food
    this.food.draw();
    
    // Draw score if human player
    if(this.humanPlayer){
      // Draw score
      fill(255);
      textAlign(LEFT, CENTER);
      textSize(16);
      text("Score: " + Integer.toString(this.score), 100, 10);
    }
  }
  
  private Food generateFood(){
    int posX = 0;
    int posY = 0;
    
    // Select food position
    do {
      posX = int(random(40));
      posY = int(random(40));
      
    // If selected position has snake, retry
    } while (this.snake.isOnTile(posX, posY) || posX < 1 || posY < 1 || posX > 38 || posY > 38);
    
    
    return new Food(posX, posY);
  }
  
  private Boolean eatenFood(){
    // If snake touched food
    if(this.snake.isOnTile(this.food.getX(), this.food.getY())){
      return true;  
    }
    return false;
  }
  
  public void restart(){
    // Reset variables and recreate snake
    this.snake = new Snake(20, 20, color(255, 255, 255));
    this.gameTimer = 0;
    this.food = this.generateFood();
    this.score = 0;
    this.tickCounter = 0;
  }
  
  public void setControl(int control){ 
    switch(control){
      // Forward
      case 0: {
        // Does nothing
      } break;
      
      // Left
      case 1: {
        switch(this.snake.getDirection()){
          case UP: {
            // Set pressed key
            this.lastKeyPressed = 'a';    
          } break;
          
          case LEFT: {
            // Set pressed key
            this.lastKeyPressed = 's';    
          } break;
          
          case DOWN: {
            // Set pressed key
            this.lastKeyPressed = 'd';    
          } break;
          
          case RIGHT: {
            // Set pressed key
            this.lastKeyPressed = 'w';    
          } break;
        }
      } break;
      
      // Right
      case 2: {
        switch(this.snake.getDirection()){
          case UP: {
            // Set pressed key
            this.lastKeyPressed = 'd';    
          } break;
          
          case LEFT: {
            // Set pressed key
            this.lastKeyPressed = 'w';    
          } break;
          
          case DOWN: {
            // Set pressed key
            this.lastKeyPressed = 'a';    
          } break;
          
          case RIGHT: {
            // Set pressed key
            this.lastKeyPressed = 's';    
          } break;
        }
      } break;
      
      // Invalid
      default: {
        println("ERROR ERROR ERROR");
      } break;
    }
  }
  
  public int getScore(){
    return this.score;
  }
  
  public int getTickCounter(){
    return this.tickCounter;  
  }
  
  public ArrayList<Integer> getMLPData(){
    // Get data for MLP input  
   return this.snake.getSensorData(this.food.getX(), this.food.getY());
  }

}
