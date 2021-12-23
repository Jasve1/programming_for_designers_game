// TODO: MAYBE CHANGE CLASS NAME TO PLATFORM
class GameObject {
  private float pWidth, pHeight;
  private color pColor;
  
  private PVector location;
  
  private CollisionType type;
  
  GameObject(float w, float h, float x, float y, color colorValue, CollisionType newType) {
    pWidth = w;
    pHeight = h;
    location = new PVector(x, y);
    pColor = colorValue;
    type = newType;
  }
  
  // Get methods
  float getPWidth() { return pWidth; }
  float getPHeight() { return pHeight; }
  PVector getLocation() { return location; }
  CollisionType getType() { return type; }
  
  // Set methods
  void setLocation(float x, float y) { location = new PVector(x, y); }
  
  void display() {
    noStroke();
    fill(pColor);
    rect(calcLocationX(location.x), calcLocationY(location.y), pWidth, pHeight);
  }
  
  /** HELPER METHODS **/
  float calcLocationX(float x) {
    return x - (pWidth * 0.5);
  }

  float calcLocationY(float y) {
    return y - pHeight;
  }
}
