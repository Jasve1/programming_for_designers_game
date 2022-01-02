public class Projectile {
  private PVector location, initLocation; //starting postion of projectile.
  private PVector velocity = new PVector(0, 0); //update location of projectile.
  private float w = 30;
  private float h = 30;
  private float speed = 7; //speed of projectile.
  private float projectileRange = 400;
  private boolean isReturning = false;
  private Player player;
  
  private PImage idleImage;
  private PImage animationImage;

  //constructor
  Projectile (Player player) {
    this.player = player;
    PVector playerPosition = player.getLocation();
    location = new PVector(playerPosition.x, playerPosition.y);
    initLocation = new PVector(playerPosition.x, playerPosition.y);
    setDirection();
    
    idleImage = loadImage("images/bulb(32X32).png");
  }
  
  // GET
  PVector getLocation() { return location; }
  float getWidth() { return w; }
  float getHeight() { return h; }

  //The horizontal movement of a projectile.
  void setDirection() { 
    //player faces left side.
    if (player.getIsFacingLeft()) {
      velocity.x = -speed;
    }
    //player faces right side.
    else {
      velocity.x = speed;
    }
  }


  //check condtion after travling a distance of X pixels.
  void projectileReturn() {
    if (passedRange() || isReturning) {
      isReturning = true;
      setVelocityToPlayer();
    }
  }
  
  boolean passedRange() {
    return (location.x > initLocation.x + projectileRange) || (location.x < initLocation.x - projectileRange);
  }
 
  void setVelocityToPlayer() {
      PVector dirToPlayer = PVector.sub(player.getLocation(), location);
      dirToPlayer.normalize();
      velocity = PVector.mult(dirToPlayer, speed);
  }
  
  boolean hasReturned() {
    PVector playerPosition = player.getLocation();
    float d = dist(playerPosition.x, playerPosition.y,location.x, location.y);
    return d < 40 && isReturning;
  }

  //Projectile display: shape, color and location.  
  void display() {
    if (idleImage != null) {
      animationImage = idleImage.get(calcFrameNumber(idleImage.width, 32)*32, 0, 32, 32);
      image(animationImage, calcLocationX(location.x), calcLocationY(location.y-30), w+5, h+5);
    }
  }
 

  void update () {
    projectileReturn();
    PVector timedVelocity = timeSpeedWMillis(velocity);
    location.add(timedVelocity);
  }
  
  /* HELPER METHODS */
  private PVector timeSpeedWMillis(PVector speed) {
    float timedXPos = speed.x * (millis() - ticksLastUpdate) * 0.05;
    float timedYPos = speed.y * (millis() - ticksLastUpdate) * 0.05;
    PVector timedSpeed = new PVector(timedXPos, timedYPos);
    return timedSpeed;
  }
  
  int calcFrameNumber(float imageWidth, float spriteSize) {
    float numOfSprites = (imageWidth/spriteSize)-1;
    float frameDifference = numOfSprites/maxFrames;
    return int(frameNumber*frameDifference);
  }
  
  float calcLocationX(float x) {
    return x - (w * 0.5);
  }

  float calcLocationY(float y) {
    return y - (h * 0.5);
  }
}
