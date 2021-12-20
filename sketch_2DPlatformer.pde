Player player;
Level level = null;

GameState gameState = GameState.TITLE;
int currentLevel = 1;
int maxLevels = 5;
HashMap<Integer,Integer> numOfEnemies = new HashMap<Integer,Integer>() {{
  put(1, 3);
}};
HashMap<Integer,Integer> numOfPlatforms = new HashMap<Integer,Integer>() {{
  put(1, 41);
}};

// World Variables
boolean left, right, up, down, space;
float groundFriction = 0.9;
float groundBounce = -0.2;
float worldGravity = 0.8;
int ticksLastUpdate = 0;

// Animation
float maxFrames = 28;
float frameNumber = 1;
int animationUpdate = millis();
int durationOneFrame = 10;

PFont ubuntu;

void setup() {
  size(1500, 800);
  
  ubuntu = createFont("fonts/Ubuntu-Bold.ttf", 24);
  textFont(ubuntu);
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
      // TODO: CREATE TITLE MENU WITH ACCESS TO SCOREBOARD
      textSize(128);
      fill(#982C20);
      textAlign(CENTER);
      text("Hello!", 0, (height/2)-200, width, 200);
      textSize(50);
      text("Press R to start", 0, (height/2), width, 300);
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
      // TODO: CREATE SCOREBOARD WITH INPUT FIELD, SORTED BY SCORE
      textSize(128);
      fill(#982C20);
      textAlign(CENTER);
      text("YOU WON", 0, (height/2)-200, width, 200);
      textSize(50);
      text("Press R to try again", 0, (height/2), width, 300);
      break;
    case GAMEOVER:
      textSize(128);
      fill(#982C20);
      textAlign(CENTER);
      text("Game Over", 0, (height/2)-200, width, 200);
      textSize(50);
      text("Press R to restart", 0, (height/2), width, 300);
      level = null;
      break;
  }
}

void keyPressed() {
  switch(keyCode) {
    case 37: //left
      left = true;
      break;
    case 39: //right
      right = true;
      break;
    case 38: //up
      up = true;
      break;
    case 40: //down
      down = true;
      break;
    case 32: //space
      space = true;
      break;
  }
}

void keyReleased() {
  switch(keyCode) {
    case 37: //left
      left = false;
      break;
    case 39: //right
      right = false;
      break;
    case 38: //up
      up = false;
    case 40: //down
      down = false;
      break;
    case 32: //space
      space = false;
      break;
    case 82: //r
      gameState = GameState.LEVEL;
      break;
    default:
      println("Key was released but nothing happened");
  }
}
