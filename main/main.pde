public enum GameState {
  GAME_STATE_MENU, 
    GAME_STATE_SETTINGS, 
    GAME_STATE_RUN, 
    GAME_STATE_GA, 
    GAME_STATE_END
}

// Main state
public GameState state = GameState.GAME_STATE_MENU;

// Game variable
Game game = new Game(true, 100);

// GA variable
GeneticAlgorithm geneticAlgorithm;

// Buttons
Button startButton = new Button(150, 200, 500, 100, color(50, 200, 50), "Start normal game");
Button startGAButton = new Button(150, 350, 500, 100, color(50, 50, 200), "Start genetic algorithm");
Button exitButton = new Button(150, 500, 500, 100, color(250, 50, 50), "Exit");

// Background color hash
public color[] backgroundColorHash = {color(200, 200, 200), color(100), color(0, 0, 0), color(0, 0, 0), color (200, 0, 0)};

color getBackgroundColor(GameState state) {
  return backgroundColorHash[state.ordinal()];
}


void setup() {
  // Create window
  size(800, 800);

  // Init text font
  PFont font = createFont("Arial", 16, true);
  textFont(font);
  
  frame.setResizable(true);
}

void loop() {
  switch(state) {
  case GAME_STATE_MENU: 
    {
      // Draw buttons
      startButton.draw();
      startGAButton.draw();
      exitButton.draw();

      // Start normal game if 'game start' button pressed
      if (startButton.isPressed()) {
        System.out.println("Game started!");
        state = GameState.GAME_STATE_RUN;
        
      // Start genetic algorithm if GA button pressed
      } else if (startGAButton.isPressed()) {
        System.out.println("GA started!");
        state = GameState.GAME_STATE_SETTINGS;
        
      // Exit if exit button pressed
      } else if (exitButton.isPressed()) {
        System.out.println("Exiting");
        exit();
      }
    } 
    break;

  case GAME_STATE_SETTINGS: 
    {
      // Set genetic algorithm parameters
      geneticAlgorithm = new GeneticAlgorithm(200, 500, 0.006, 0.02);
      state = GameState.GAME_STATE_GA;
      
      println("Running generation 0");
    } 
    break;

  case GAME_STATE_RUN: 
    {
      // Run and show frame
      game.loop();
      game.draw();

      // Check for game ended
      if (game.hasEnded()) {
        System.out.println("Game ended!");
        state = GameState.GAME_STATE_END;
      }
    } 
    break;

  case GAME_STATE_GA: 
    {
      // Run and show GA frame
      geneticAlgorithm.runGA();
      geneticAlgorithm.draw();
    } 
    break;

  case GAME_STATE_END: 
    {
      // If space pressed, restart game
      game.draw();
      if (keyPressed) {
        if (key == ' ') {
          game.restart();
          state = GameState.GAME_STATE_RUN;
        }
      }
    } 
    break;
  }
}

void draw() {
  background(getBackgroundColor(state));
  loop();
}
