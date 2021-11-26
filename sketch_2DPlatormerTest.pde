Player player;
Level level;

// World Variables
boolean left, right, up, down, space;
float groundFriction = 0.9;
float groundBounce = -0.2;
float worldGravity = 0.8;

void setup() {
  size(1500, 800);
  
  player = new Player(130, #934040);
  level = new Level(1);
}

void draw() {
  background(255);
  player.display();
  player.update();
  level.display();
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
    default:
      println("Key was pressed but nothing happened");
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
    default:
      println("Key was released but nothing happened");
  }
}
