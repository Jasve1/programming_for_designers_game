Player player;
Level level = null;

GameState gameState = GameState.TITLE;
int currentLevel = 1;
int maxLevels = 1;
HashMap<Integer,Integer> numOfEnemies = new HashMap<Integer,Integer>() {{
  put(1, 2);
  put(2, 3);
  put(3, 4);
}};
HashMap<Integer,Integer> numOfPlatforms = new HashMap<Integer,Integer>() {{
  put(1, 28);
  put(2, 50);
  put(3, 69);
}};

// World Variables
float groundFriction = 0.9;
float groundBounce = -0.3;
float worldGravity = 0.8;
int ticksLastUpdate = 0;
int score = 0;

// Animation
float maxFrames = 32;
float frameNumber = 1;
int animationUpdate = millis();
int durationOneFrame = 10;

PFont ubuntu;

String textInput = "";
Button submitButton;
Button startButton;
Button titleButton;
Button scoreButton;
Scoreboard scoreboard;

void setup() {
  size(1500, 850);
  
  ubuntu = createFont("fonts/Ubuntu-Bold.ttf", 24);
  textFont(ubuntu);
  
  submitButton = new Button((width/2)-100, (height/2)+90, "Save score", ButtonType.SUBMIT);
  startButton = new Button((width/2)-100, (height/2), "Start Game", ButtonType.START);
  titleButton = new Button(50, 50, "Go to tile menu", ButtonType.TITLE);
  scoreButton = new Button((width/2)-100, (height/2)+90, "Scoreboard", ButtonType.SEESCORE);
  scoreboard = new Scoreboard();
}

void draw() {
  background(255);
  
  gameStateManager();
  
  // Update animation frames
  int delta = millis() - animationUpdate;
  if (delta >= durationOneFrame) {
    frameNumber++;
    if (frameNumber > maxFrames) { frameNumber = 1; }
    animationUpdate += delta;
  }
  
  // TIMING FIX
  ticksLastUpdate = millis();
}

void gameStateManager() {
  switch(gameState) {
    case TITLE:
      textSize(128);
      fill(#982C20);
      textAlign(CENTER);
      text("Hello!", 0, (height/2)-200, width, 200);
      
      startButton.display();
      scoreButton.display();
      break;
    case LEVEL:
      if (level == null) {
        level = new Level(currentLevel, numOfEnemies.get(currentLevel), numOfPlatforms.get(currentLevel));
      }
      level.display();
      level.update();
      break;
    case LEVELCHANGE:
      level = null;
      if (currentLevel < maxLevels) {
        currentLevel++;
        gameState = GameState.LEVEL;
      } else {
        currentLevel = 1;
        gameState = GameState.WIN;
      }
      break;
    case WIN:
      // Input box
      fill(#F5F4F2);
      stroke(#5F5C54);
      rect((width/2)-200, (height/2), 400, 70);

      textAlign(CENTER);
      fill(#982C20);

      textSize(128);
      text("YOU WON", 0, (height/2)-250, width, 200);

      textSize(50);
      text("Write your name", 0, (height/2)-70, width, 300);

      // Input text
      textSize(40);
      text(textInput, (width/2)-190, (height/2)+10, 390, 60);
      
      submitButton.display();
      
      fill(#982C20);
      textSize(50);
      text("Score: "+score, 0, (height/2)+150, width, 300);
      break;
    case SAVESCORE:
      scoreboard.saveNewScore(textInput, score);
      textInput = "";
      score = 0;
      gameState = GameState.SCOREBOARD;
      break;
    case SCOREBOARD:
      scoreboard.display();
      titleButton.display();
      break;
    case GAMEOVER:
      textSize(128);
      fill(#982C20);
      textAlign(CENTER);
      text("Game Over", 0, (height/2)-200, width, 200);
      textSize(50);
      text("Press R to restart", 0, (height/2), width, 300);
      level = null;
      score = 0;
      titleButton.display();
      break;
  }
}

void mouseReleased() {
  if (gameState == GameState.WIN) {
    submitButton.handleMouseClick();
  } else if (gameState == GameState.TITLE) {
    startButton.handleMouseClick();
    scoreButton.handleMouseClick();
  }
  titleButton.handleMouseClick();
}

void keyPressed() {
  if (player != null) { player.buttonPressed(keyCode); }
  if (gameState == GameState.WIN) {
    if (keyCode == 8) {
      textInput = textInput.substring( 0, textInput.length()-1 );
    } else if (keyCode == 10) {
      gameState = GameState.SAVESCORE;
    } else {
      textInput = textInput + key;
    }
  }
}

void keyReleased() {
  if (player != null) { player.buttonReleased(keyCode); }
  
  if (gameState == GameState.GAMEOVER && keyCode == 82) {
    gameState = GameState.LEVEL;
  }
}
