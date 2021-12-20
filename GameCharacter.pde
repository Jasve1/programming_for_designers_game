class GameCharacter {
  // Movement
  protected PVector velocity = new PVector(0, 0);
  protected float gravity = worldGravity;
  protected PVector position;
  private float speedLimit = 5;

  // Size
  protected PVector dimension;
  protected float cWidth, cHeight;
  private float mass, halfWidth;

  // Collision Variables
  protected boolean isOnGround = false;
  private CollisionSides collisionSide;
  
  // Health
  protected float health;

  GameCharacter(float newMass, float x, float y, float newHealth) {
    // Size
    mass = newMass;
    dimension = new PVector(0.5, 0.5);
    cWidth = mass*dimension.x;
    cHeight = mass*dimension.y;
    halfWidth = cWidth/2;
    
    position = new PVector(x,y);
    
    health = newHealth;
  }
  
  // GET
  PVector getLocation() { return position; }
  float getWidth() { return cWidth; }
  float getHeight() { return cHeight; }
  float getHealth() { return health; }
  
  // SET
  void setLocation(PVector newPosition) { position = newPosition; }

  /** MOVEMENT LOGIC **/
  protected void initFriction() {
    if (!right && !left && isOnGround) {
      // Apply friction
      velocity.x *= groundFriction;
    }
  }

  protected void initSpeedLimit() {
    // Speedlimit
    if (velocity.x > speedLimit) {
      velocity.x = speedLimit;
    } else if (velocity.x < -speedLimit) {
      velocity.x = -speedLimit;
    }
  }

  protected void initGravity() {
    // Apply gravity
    velocity.y += gravity;
  }

  protected void initBounce() {
    // Bounce off left screen
    if (position.x <= halfWidth) {
      velocity.x *= groundBounce;
      position.x = halfWidth;
    }
    // Bounce off bottom screen
    if (position.y >= height) {
      velocity.y *= groundBounce;
      position.y = height;
      isOnGround = true;
    }
  }
  
  protected void applyMovement() {
    // Move player
    PVector timedVelocity = timeSpeedWMillis(velocity);
    position.add(timedVelocity);
  }
  
  
  /** COLLISION **/
  void checkCollision(float objectHeight, float objectWidth, PVector objectLocation, CollisionType type) {
    float combinedHalfWidths = (cWidth/2) + (objectWidth/2);
    float combinedHalfHeights = (cHeight/2) + (objectHeight/2);
    double horizontalDistance = getHorizontalDistance(position.x, objectLocation.x);
    double verticalDistance = getVerticalDistance(centerOrigin(position.y, cHeight), centerOrigin(objectLocation.y, objectHeight));
    
    boolean collision = verticalDistance <= combinedHalfHeights && horizontalDistance <= combinedHalfWidths;
    
    if (collision) {
      // Detect collision side
      float xCollisionBuffer = 1; // Without this player gets stuck when sliding across multiple platforms.
      float overlapX = (combinedHalfWidths - (float)horizontalDistance) + xCollisionBuffer;
      float overlapY = combinedHalfHeights - (float)verticalDistance;
      
      if (overlapX >= overlapY) {
        // Vertical Collision (Y)
        if (position.y < objectLocation.y) {
          position.y += overlapY;
          collisionSide = CollisionSides.BOTTOM;
        } else {
          position.y -= overlapY;
          collisionSide = CollisionSides.TOP;
        }
      } else {
        // Horizontal Collision (X)
        if (position.x < objectLocation.x) {
          position.x += overlapX;
          collisionSide = CollisionSides.RIGHT;
        } else {
          position.x -= overlapX;
          collisionSide = CollisionSides.LEFT;
        }
      }
      
      switch(type) {
        case PLATFORM:
          handlePlaformCollisions(objectHeight, objectWidth, objectLocation);
          break;
        case ENEMY:
          if (health > 0) { health--; }
          break;
      }
    }
  }
  
  private double getHorizontalDistance(float x1, float x2) {
    float xDistance = x1 - x2;
    
    return Math.sqrt(Math.pow(xDistance, 2));
  }
  private double getVerticalDistance(float y1, float y2) {
    float yDistance = y1 - y2;
    
    return Math.sqrt(Math.pow(yDistance, 2));
  }
  
  private void handlePlaformCollisions(float objectHeight, float objectWidth, PVector objectLocation) {
      switch(collisionSide) {
        case RIGHT:
          velocity.x *= groundBounce;
          position.x = objectLocation.x - (objectWidth/2) - (cWidth/2);
          break;
        case LEFT:
          velocity.x *= groundBounce;
          position.x = objectLocation.x + (objectWidth/2) + (cWidth/2);
          break;
        case TOP:
          velocity.y *= groundBounce;
          position.y = objectLocation.y + cHeight;
          break;
        case BOTTOM:
          velocity.y *= groundBounce;
          position.y = objectLocation.y - objectHeight;
          isOnGround = true;
          break;
      }
  }
  
  /** ANIMATIONS **/
  
  // TODO: ADD DAMAGE ANIMATION THAT TAKES COLOR PARAMS
  
  // TODO: DEATH ANIMATION USING PARTICLE EFFECT


  /** HELPER METHODS **/
  float centerOrigin(float origin, float objectSize) {
    return origin - (objectSize/2);
  }
  
  float calcLocationX(float x) {
    return x - (cWidth * 0.5);
  }

  float calcLocationY(float y) {
    return y - cHeight;
  }
 
  protected void animateSize(float widthDimension, float heightDimension) {
    cWidth = mass*widthDimension;
    cHeight = mass*heightDimension;
  }
  
  private PVector timeSpeedWMillis(PVector speed) {
    float timedXPos = speed.x * (millis() - ticksLastUpdate) * 0.05;
    float timedYPos = speed.y * (millis() - ticksLastUpdate) * 0.05;
    PVector timedSpeed = new PVector(timedXPos, timedYPos);
    return timedSpeed;
  }
}
