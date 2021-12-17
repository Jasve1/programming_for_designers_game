class Level {
  private GameObject[] platforms;
  private Enemy[] enemies;
  
  Level(int level, int numOfEnemies, int numOfPlatforms) {
    PImage levelImage = loadImage("images/lvl" + level + ".jpg");

    platforms = new GameObject[numOfPlatforms];
    enemies = new Enemy[numOfEnemies];
    
    renderLevel(levelImage);
  }
  
  void renderLevel(PImage levelImage) {
    color pixelColor = color(0,0,0);
    int averageColor = 0;
    int tileSize = 50;

    int currentPlatform = 0;
    int currentEnemy = 0;

    for(int x = 0; x < levelImage.width; x += tileSize) {
      for(int y = 0; y < levelImage.height; y += tileSize) {
        pixelColor = levelImage.get(x,y);
        averageColor = (int)(red(pixelColor) + green(pixelColor) + blue(pixelColor)) / 3;
        
        // ADD PLATFORMS
        if (averageColor == 0) {
          platforms[currentPlatform] = new GameObject(tileSize, tileSize, x, y, #6B938C, Type.PLATFORM);
          currentPlatform++;
        }

        // SET PLAYER POSITION
        if (pixelColor == color(0,255,0)) {
          player = new Player(130, x, y, #934040);
        }
        
        // ADD ENEMIES
        if (pixelColor == color(255,0,0)) {
          enemies[currentEnemy] = new Enemy(x,y);
          currentEnemy++;
        }
      }
    }
  }
  
  void display() {
    player.display();
    player.update();

    for(int i = 0; i < enemies.length; i++) {
      enemies[i].display();
    }

    for(int i = 0; i < platforms.length; i++) {
      platforms[i].display();
    }
    
    for(int i = 0; i < platforms.length; i++) {
      float platformHeight = platforms[i].getPHeight();
      float platformWidth = platforms[i].getPWidth();
      PVector platformLocation = platforms[i].getLocation();

      player.checkCollision(platformHeight, platformWidth, platformLocation, Type.PLATFORM);

      for(int e = 0; e < enemies.length; e++) {
        enemies[e].checkCollision(platformHeight, platformWidth, platformLocation, Type.PLATFORM);
      }
    }
    
    for(int i = 0; i < enemies.length; i++) {
      enemies[i].update();
      float enemyHeight = enemies[i].getHeight();
      float enemyWidth = enemies[i].getWidth();
      PVector enemyLocation = enemies[i].getLocation();
      player.checkCollision(enemyHeight, enemyWidth, enemyLocation, Type.ENEMY);
    }
  }
}
