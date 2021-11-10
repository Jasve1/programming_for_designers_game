class Projectile {
  private PVector projectileLocation, startLocation;
  private float size, maxDistance, speed;

  Projectile(PVector playerLocation) {
    maxDistance = 100;
    size = 20;
    speed = 30;
    projectileLocation = playerLocation;
    startLocation = projectileLocation;
  }
  
  void display() {
    fill(#69B2D3);
    
    if (space) {
      projectileLocation.x += speed;
    }
    
    rect(calcLocation(projectileLocation.x), calcLocation(projectileLocation.y), size, size);
  }
  
  float calcLocation(float pos) {
    return pos - (size * 0.5);
  }
}
