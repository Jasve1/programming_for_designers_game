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
  protected CollisionType collisionType;
  private CollisionSides collisionSide;
  private PVector force = new PVector(0, 0);
  
  // Health
  protected float health;
  protected boolean isHit = false;
  private CauseOfDeath causeOfDeath;
  
  // Sound
  private AudioPlayer isHitSound;

  GameCharacter(float newMass, float x, float y, float newHealth) {
    // Size
    mass = newMass;
    dimension = new PVector(0.5, 0.5);
    cWidth = mass*dimension.x;
    cHeight = mass*dimension.y;
    halfWidth = cWidth/2;
    
    position = new PVector(x,y);
    
    health = newHealth;
    
    // Sound
    isHitSound = minim.loadFile("sounds/hitHurt.wav");
  }
  
  // GET
  PVector getLocation() { return position; }
  float getWidth() { return cWidth; }
  float getHeight() { return cHeight; }
  float getHealth() { return health; }
  CauseOfDeath getCauseOfDeath() { return causeOfDeath; }

  /** MOVEMENT LOGIC **/
  protected void initFriction() {
    if (isOnGround) {
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
    if (position.y >= height && health > 0) {
      health--;
      causeOfDeath = CauseOfDeath.FALL;
    }
  }

  protected void initBounce() {
    // Bounce off left screen
    if (position.x <= halfWidth) {
      velocity.x *= groundBounce;
      position.x = halfWidth+10;
    }
    // Bounce off right screen
    if (position.x >= width-halfWidth) {
      velocity.x *= groundBounce;
      position.x = width-halfWidth-10;
    }
  }
  
  protected void applyMovement() {
    // Add force from collision
    if (collisionType == CollisionType.PROJECTILE || collisionType == CollisionType.ENEMY) {
      collisionType = null;
      velocity.add(force);
    }

    // Move player
    PVector timedVelocity = timeSpeedWMillis(velocity); // Time fix
    position.add(timedVelocity);
  }
  
  
  /** COLLISION **/
  boolean checkCollision(float objectHeight, float objectWidth, PVector objectLocation, CollisionType type) {
    float combinedHalfWidths = (cWidth/2) + (objectWidth/2);
    float combinedHalfHeights = (cHeight/2) + (objectHeight/2);
    float horizontalDistance = getHorizontalDistance(position.x, objectLocation.x);
    float verticalDistance = getVerticalDistance(centerOrigin(position.y, cHeight), centerOrigin(objectLocation.y, objectHeight));
    
    boolean collision = verticalDistance <= combinedHalfHeights && horizontalDistance <= combinedHalfWidths;
    
    if (collision) {
      // Detect collision side
      float xCollisionBuffer = 1; // Without this player gets stuck when sliding across multiple platforms.
      float overlapX = (combinedHalfWidths - horizontalDistance) + xCollisionBuffer;
      float overlapY = combinedHalfHeights - verticalDistance;
      
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
      
      collisionType = type;
      
      switch(type) {
        case BLOCK:
          stopCollidedElement(objectHeight, objectWidth, objectLocation);
          break;
        case ENEMY:
          if (health > 0) {
            if (!isHitSound.isPlaying()) {
              isHitSound.rewind();
              isHitSound.play();
            }
            health--;
          }
          causeOfDeath = CauseOfDeath.ENEMY;
          // Push player away from enemy so as to not continue to take damage
          stopCollidedElement(objectHeight, objectWidth, objectLocation);
          pushCollidedElement();
          isHit = true;
          break;
        case PORTAL:
          gameState = GameState.LEVELCHANGE;
          break;
        case PROJECTILE:
          stopCollidedElement(objectHeight, objectWidth, objectLocation);
          pushCollidedElement();
          break;
      }
    }
    return collision;
  }
  
  private float getHorizontalDistance(float x1, float x2) { return Math.abs(x1 - x2); }
  private float getVerticalDistance(float y1, float y2) { return Math.abs(y1 - y2); }
  
  private void stopCollidedElement(float objectHeight, float objectWidth, PVector objectLocation) {
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
  
  private void pushCollidedElement() {
      switch(collisionSide) {
        case RIGHT:
          force.x = -55;
          break;
        case LEFT:
          force.x = 55;
          break;
        case TOP:
          force.y = 15;
          break;
        case BOTTOM:
          force.y = -15;
          break;
      }
  }

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
