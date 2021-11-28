class Level {
  private GameObject[] tiles = new GameObject[480];
  
  Level(int level) {
    PImage levelImage = loadImage("images/lvl" + level + ".jpg");
    int currentTile = 0;
    color pixelColor = color(0,0,0);
    int averageColor = 0;
    int tileSize = 50;
    
    for(int i = 0; i < tiles.length; i++) {
      tiles[i] = new GameObject(tileSize, tileSize, 0, 0, #6B938C, Type.Platform);
    }
    
    for(int x = 0; x < levelImage.width; x += tileSize) {
      for(int y = 0; y < levelImage.height; y += tileSize) {
        pixelColor = levelImage.get(x,y);
        averageColor = (int)(red(pixelColor) + green(pixelColor) + blue(pixelColor)) / 3;

        if (averageColor < 200 && currentTile < tiles.length) {
          tiles[currentTile].setLocation(x,y);
          currentTile++;
        }
      }
    }
  }
  
  void display() {
    for(int i = 0; i < tiles.length; i++) {
      tiles[i].display();
      player.checkCollision(tiles[i]);
    }
  }
}
