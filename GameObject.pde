// TODO: MAYBE CHANGE CLASS NAME TO PLATFORM
class GameObject {
  private float pWidth, pHeight;
  private color pColor;
  
  private PVector location;
  
  private CollisionType type;
  
  private int spriteSize;
  private PImage idleImage;
  private PImage animationImage;
  
  GameObject(float w, float h, float x, float y, color colorValue, CollisionType newType) {
    pWidth = w;
    pHeight = h;
    location = new PVector(x, y);
    pColor = colorValue;
    type = newType;
    
    if (type == CollisionType.PORTAL) {
      idleImage = loadImage("images/coin(16X16).png");
      spriteSize = 16;
    } else if (type == CollisionType.BLOCK) {
      idleImage = loadImage("images/Terrain (32x32).png");
      spriteSize = 32;
    }
  }
  
  // Get methods
  float getPWidth() { return pWidth; }
  float getPHeight() { return pHeight; }
  PVector getLocation() { return location; }
  CollisionType getType() { return type; }
  
  // Set methods
  void setLocation(float x, float y) { location = new PVector(x, y); }
  
  void display() {
    if (idleImage != null) {
      if (type == CollisionType.PORTAL) {
        animationImage = idleImage.get(calcFrameNumber(idleImage.width, spriteSize)*spriteSize, 0, spriteSize, spriteSize);
      } else if (type == CollisionType.BLOCK) {
        animationImage = idleImage.get(spriteSize, 0, spriteSize, spriteSize);
      }
      image(animationImage, calcLocationX(location.x), calcLocationY(location.y), pWidth, pHeight);
    }
  }
  
  /** HELPER METHODS **/
  int calcFrameNumber(float imageWidth, float spriteSize) {
    float numOfSprites = (imageWidth/spriteSize)-1;
    float frameDifference = numOfSprites/maxFrames;
    return int(frameNumber*frameDifference);
  }

  float calcLocationX(float x) {
    return x - (pWidth * 0.5);
  }

  float calcLocationY(float y) {
    return y - pHeight;
  }
}
