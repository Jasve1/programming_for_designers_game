class GameObject {
  private float pWidth, pHeight;
  private color pColor;
  
  private PVector location;
  
  private Type type;
  
  GameObject(float w, float h, float x, float y, color colorValue, Type newType) {
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
  Type getType() { return type; }
  
  // Set methods
  void setLocation(float x, float y) { location = new PVector(x, y); }
  
  void changeColor(color newColor) {
    pColor = newColor;
  }
  
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
