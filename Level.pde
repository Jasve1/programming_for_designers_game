class Level {
  private GameObject[] platforms;
  private Enemy[] enemies;
  private GameObject portal;
  private int tileSize = 50;
  
  //projectile
  private Projectile projectile;
  
  // Sound
  private AudioPlayer succesSound;
  
  Level(int level, int numOfEnemies, int numOfPlatforms) {
    PImage levelImage = loadImage("images/lvl" + level + ".jpg");

    platforms = new GameObject[numOfPlatforms];
    enemies = new Enemy[numOfEnemies];
    
    // Sound
    succesSound = minim.loadFile("sounds/pickupCoin.wav");
    
    renderLevel(levelImage);
  }
  
  private void renderLevel(PImage levelImage) {
    color pixelColor = color(0,0,0);
    int averageColor = 0;

    int currentPlatform = 0;
    int currentEnemy = 0;

    for(int x = 0; x < levelImage.width; x += tileSize) {
      for(int y = 0; y < levelImage.height; y += tileSize) {
        pixelColor = levelImage.get(x,y);
        averageColor = (int)(red(pixelColor) + green(pixelColor) + blue(pixelColor)) / 3;
        
        // ADD PLATFORMS
        if (averageColor == 0) {
          platforms[currentPlatform] = new GameObject(tileSize, tileSize, calcLocationX(x), calcLocationY(y), CollisionType.BLOCK);
          currentPlatform++;
        }
        
        // ADD PORTAL
        if (pixelColor == color(255,255,0)) {
          portal = new GameObject(40, 40, x, y, CollisionType.PORTAL);
        }

        // Add PLAYER
        if (pixelColor == color(0,255,0)) {
          player = new Player(130, x, y);
        }
        
        // ADD ENEMIES
        if (pixelColor == color(255,0,0)) {
          enemies[currentEnemy] = new Enemy(x, y, EnemyType.PATROLER);
          currentEnemy++;
        } else if (pixelColor == color(186,34,23)) {
          enemies[currentEnemy] = new Enemy(x, y, EnemyType.CHASER);
          currentEnemy++;
        } else if (pixelColor == color(168,0,0)) {
          enemies[currentEnemy] = new Enemy(x, y, EnemyType.SPIKE);
          currentEnemy++;
        }
      }
    }
  }
  
  void display() {
    if (projectile != null) {
      projectile.display();
    }

    player.display();
    
    portal.display();

    for(int i = 0; i < enemies.length; i++) {
      enemies[i].display();
    }

    for(int i = 0; i < platforms.length; i++) {
      platforms[i].display();
    }
    
    fill(#000000);
    textAlign(LEFT);
    textSize(28);
    text("Score: "+score, 30, 50);
  }
  
  void update() {
    player.update();
    
    if (projectile != null) {
      projectile.update();
      checkProjectileCollision();
      if (projectile.hasReturned()) {
        projectile = null;
      }
    } else if (player.getSpace()) {
      projectile = new Projectile(player);
    }
    
    for(int i = 0; i < enemies.length; i++) {
      enemies[i].update();
    }
    
    checkPortalCollision();
    checkPlatformCollision();
    checkEnemyCollision();
    
    // Remove dead enemies
    for(int i = 0; i < enemies.length; i++) {
      if (enemies[i].getHealth() == 0) {
        removeDeadEnemy(i);
      }
    }
  }
  
  private void checkProjectileCollision() {
    float projectileHeight = projectile.getHeight();
    float projectileWidth = projectile.getWidth();
    PVector projectileLocation = projectile.getLocation();

    for(int e = 0; e < enemies.length; e++) {
      boolean hasCollided = enemies[e].checkCollision(projectileHeight, projectileWidth, projectileLocation, CollisionType.PROJECTILE);
      // Return projectile when collided with enemy;
      if (hasCollided) { projectile.setIsReturning(hasCollided); }
    }
  }
  
  private void checkPortalCollision() {
    float portalHeight = portal.getPHeight();
    float portalWidth = portal.getPWidth();
    PVector portalLocation = portal.getLocation();

    player.checkCollision(portalHeight, portalWidth, portalLocation, CollisionType.PORTAL);
  }
  
  private void checkPlatformCollision() {
    for(int i = 0; i < platforms.length; i++) {
      float platformHeight = platforms[i].getPHeight();
      float platformWidth = platforms[i].getPWidth();
      PVector platformLocation = platforms[i].getLocation();

      player.checkCollision(platformHeight, platformWidth, platformLocation, CollisionType.BLOCK);
      for(int e = 0; e < enemies.length; e++) {
        enemies[e].checkCollision(platformHeight, platformWidth, platformLocation, CollisionType.BLOCK);
      }
    }
  }
  
  private void checkEnemyCollision() {
    for(int i = 0; i < enemies.length; i++) {
      float enemyHeight = enemies[i].getHeight();
      float enemyWidth = enemies[i].getWidth();
      PVector enemyLocation = enemies[i].getLocation();

      player.checkCollision(enemyHeight, enemyWidth, enemyLocation, CollisionType.ENEMY);

      // Enemies can collide with other enemies potentially destroying them
      for(int e = 0; e < enemies.length; e++) {
        if (e != i) {
          enemies[e].checkCollision(enemyHeight, enemyWidth, enemyLocation, CollisionType.ENEMY);
        }
      }
    }
  }
  
  private void removeDeadEnemy(int indexOfDead) {
    // Play succes sound
    if (!succesSound.isPlaying()) {
      succesSound.rewind();
      succesSound.play();
    }
    
    // Get point
    if (enemies[indexOfDead].getCauseOfDeath() == CauseOfDeath.ENEMY) {
      score += 2;
    } else {
      score++;
    }
 
    Enemy[] tempEnemyList = new Enemy[enemies.length - 1];
    int currentEnemy = 0;
    for(int i = 0; i < enemies.length; i++) {
      if (i != indexOfDead) {
        tempEnemyList[currentEnemy] = enemies[i];
        currentEnemy++;
      }
    }
    enemies = tempEnemyList;
  }
  
  /** HELPER METHODS **/
  float calcLocationX(float x) {
    return x + (tileSize * 0.5);
  }

  float calcLocationY(float y) {
    return y + tileSize;
  }
}
