Player player;
Level level = null;

GameState gameState = GameState.TITLE;
int currentLevel = 1;
int maxLevels = 5;

// World Variables
boolean left, right, up, down, space;
float groundFriction = 0.9;
float groundBounce = -0.2;
float worldGravity = 0.8;
boolean applyGravity = false;
int ticksLastUpdate = 0;

void setup() {
  size(1500, 800);
}

void draw() {
  background(255);
  switch(gameState) {
    case TITLE:
      textSize(128);
      fill(#982C20);
      textAlign(CENTER);
      text("Hello!", (width/2)-500, (height/2)-200, 1000, 200);
      textSize(50);
      text("Press R to start", (width/2)-250, (height/2), 500, 300);
      break;
    case LEVEL:
      if (level == null) { level = new Level(currentLevel, 3, 41); }
      level.display();
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
      textSize(128);
      fill(#982C20);
      textAlign(CENTER);
      text("YOU WON", (width/2)-500, (height/2)-200, 1000, 200);
      textSize(50);
      text("Press R to try again", (width/2)-250, (height/2), 500, 300);
      break;
    case GAMEOVER:
      textSize(128);
      fill(#982C20);
      textAlign(CENTER);
      text("Game Over", (width/2)-500, (height/2)-200, 1000, 200);
      textSize(50);
      text("Press R to restart", (width/2)-250, (height/2), 500, 300);
      level = null;
      break;
  }
  
  // TIMING FIX
  ticksLastUpdate = millis();
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
