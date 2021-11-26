class Level {
  private GameObject[] platforms = new GameObject[480];
  
  Level(int level) {
    PImage levelImage = loadImage("images/lvl" + level + ".jpg");
    int currentPlatform = 0;
    color pxCol = color(0,0,0);
    int avgCol = 0;
    int tileSize = 50;
    
    for(int i = 0; i < platforms.length; i++) {
      platforms[i] = new GameObject(tileSize, tileSize, 0, 0, #6B938C, Type.Platform);
    }
    
    for(int x = 0; x < levelImage.width; x += tileSize) {
      for(int y = 0; y < levelImage.height; y += tileSize) {
        pxCol = levelImage.get(x,y);
        avgCol = (int)(red(pxCol) + green(pxCol) + blue(pxCol)) / 3;
        if (avgCol < 200 && currentPlatform < platforms.length) {
          platforms[currentPlatform].setLocation(x,y);
          currentPlatform++;
        }
      }
    }
  }
  
  void display() {
    for(int i = 0; i < platforms.length; i++) {
      platforms[i].display();
      player.checkCollision(platforms[i]);
    }
  }
}
