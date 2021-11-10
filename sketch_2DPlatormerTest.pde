// Player Movement

Player player;
ArrayList<GameObject> platforms = new ArrayList<GameObject>();

boolean left, right, up, down, space;
float groundFriction, groundBounce, worldGravity;

void setup() {
  size(1500, 800);
  
  groundFriction = 0.9;
  groundBounce = -0.2;
  worldGravity = 0.8;
  player = new Player(130, #934040);
  
  /* TEST PLATFORMS */
  HashMap<Integer, Integer> colors_map = new HashMap<Integer, Integer>();
  colors_map.put(0, #5B97B4);
  colors_map.put(1, #B44747);
  colors_map.put(2, #65AA7E);
  colors_map.put(3, #B97FBC);
  colors_map.put(4, #B7A24F);
  for (int i = 0; i < 5; i++) {
    float platformHeight = random(40, 70);
    float platformWidth = random(100, 500);
    float platformX = random(10, 1000);
    float platformY = random(300, 950);
    color platformColor = #000000;
    
    if (colors_map.get(i) != null) { platformColor = colors_map.get(i); }
    GameObject platform = new GameObject(platformWidth, platformHeight, platformX, platformY, platformColor, Type.Platform);
    
    platforms.add(platform);
  }
  /* TEST PLATFORMS */
}

void draw() {
  background(255);
  player.update();
  player.display();
  
  for (GameObject platform : platforms) {
    platform.display();
  }
  for (GameObject platform : platforms) {
    player.checkCollision(platform);
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
