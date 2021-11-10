class Player {
  // Player variables
  private float pWidth, pHeight, playerMass,
    xAcceleration, 
    speed, 
    speedLimit, 
    frameNumber, maxFrames,
    jumpForce,
    halfWidth,
    gravity;
    
  private PVector velocity, location, playerDimension;

  private boolean hasPlayed, isOnGround;
  
  private color pColor;
  
  private CollisionSides collisionSide;
  private GameObject collidedObject;

  Player(float mass, color colorValue) {
    // Player size
    playerMass = mass;
    playerDimension = new PVector(0.5, 0.5);
    pWidth = playerMass*playerDimension.x;
    pHeight = playerMass*playerDimension.y;
    halfWidth = pWidth/2;

    // Player movement
    location = new PVector(400, height -100);
    velocity = new PVector(0, 0);
    xAcceleration = 0;
    speed = 0.2;
    speedLimit = 5;
    jumpForce = -20;
    gravity = worldGravity;

    // Player animation
    maxFrames = 28;
    frameNumber = 1;
    hasPlayed = false;
    
    // Player color
    pColor = colorValue;
    
    // Collision
    isOnGround = false;
  }

  void update() {
    initHorizontalMovement();
    initFriction();
    initSpeedLimit();
    initBounce();
    initJumping();
    initGravity();
    applyMovementToPlayer();
  }
 

  /** Movement Logic **/

  void initHorizontalMovement() {
    // Horizontal Movement
    if (left && !right) {
      xAcceleration = -speed;
    } else if (right && !left) {
      xAcceleration = speed;
    } else {
      xAcceleration = 0;
    }

    velocity.x += xAcceleration;
  }

  void initFriction() {
    if (!right && !left && isOnGround) {
      // Apply friction
      velocity.x *= groundFriction;
    }
  }

  void initSpeedLimit() {
    // Speedlimit
    if (velocity.x > speedLimit) {
      velocity.x = speedLimit;
    } else if (velocity.x < -speedLimit) {
      velocity.x = -speedLimit;
    }
  }

  void initJumping() {
    // Jumping
    if (up && isOnGround) {
      isOnGround = false;
      velocity.y = jumpForce;
      gravity = 0;
      hasPlayed = false;
    } else {
      gravity = worldGravity;
    }
  }

  void initGravity() {
    // Apply gravity
    velocity.y += gravity;
  }

  void applyMovementToPlayer() {
    // Move player
    location.add(velocity);
  }

  void initBounce() {
    // Bounce off left screen
    if (location.x <= halfWidth) {
      velocity.x *= groundBounce;
      location.x = halfWidth;
    }
    // Bounce off bottom screen
    if (location.y >= height) {
      velocity.y *= groundBounce;
      location.y = height;
      isOnGround = true;
    }
  }
 

  /** VISUALS **/

  void display() {
    fill(pColor);

    initAnimations();
    
    rect(calcLocationX(location.x), calcLocationY(location.y), pWidth, pHeight);
  }
 

  /** ANIMATIONS **/

  void initAnimations() {
    if (!right && !left && !up && !down && isOnGround) {
      // Idle animation
      playIdleAnimation();
    } else if (down && isOnGround) {
      // Down animation
      setSize(0.65, 0.35);
    } else if (isOnGround && !down) {
      // Move animation
      playMoveAnimation();
    } else if (!isOnGround) {
      // Jump animation
      playJumpAnimation();
    } else {
      // Reset
      setSize(playerDimension.x, playerDimension.y);
    }

    // Animation frames
    if (frameNumber < maxFrames) {
      frameNumber++;
    } else {
      frameNumber = 1;
    }
  }

  void playMoveAnimation() {
    if (frameNumber == 1) {
      setSize(0.46, 0.54);
    } else if (frameNumber == (maxFrames * 0.15)) {
      setSize(0.39, 0.61);
    } else if (frameNumber == (maxFrames * 0.25)) {
      setSize(0.46, 0.54);
    } else if (frameNumber == (maxFrames * 0.5)) {
      setSize(0.54, 0.46);
    } else if (frameNumber == (maxFrames * 0.75)) {
      setSize(0.61, 0.39);
    } else if (frameNumber == maxFrames) {
      setSize(0.54, 0.46);
    }
  }

  void playIdleAnimation() {
    if (frameNumber == 1) {
      setSize(0.52, 0.48);
    } else if (frameNumber == (maxFrames * 0.5)) {
      setSize(0.51, 0.49);
    } else if (frameNumber == (maxFrames * 0.75)) {
      setSize(0.48, 0.52);
    } else if (frameNumber == maxFrames) {
      setSize(playerDimension.x, playerDimension.y);
    }
  }

  void playJumpAnimation() {
    if (!hasPlayed) {
      if (frameNumber == 1) {
        setSize(0.61, 0.39);
      } else if (frameNumber == (maxFrames * 0.5)) {
        setSize(0.42, 0.58);
      } else if (frameNumber == (maxFrames * 0.75)) {
        setSize(0.3, 0.7);
      } else if (frameNumber == maxFrames) {
        setSize(0.39, 0.61);
        hasPlayed = true;
      }
    }
  }
  
  
  /** COLLISION **/
  
  void checkCollision(GameObject object) {
    float objectHeight = object.getPHeight();
    float objectWidth = object.getPWidth();
    PVector objectLocation = object.getLocation();
    
    float combinedHalfWidths = (pWidth/2) + (objectWidth/2);
    float combinedHalfHeights = (pHeight/2) + (objectHeight/2);
    double horizontalDistance = getHorizontalDistance(location.x, objectLocation.x);
    double verticalDistance = getVerticalDistance(centerOrigin(location.y, pHeight), centerOrigin(objectLocation.y, objectHeight));
    
    boolean collision = verticalDistance <= combinedHalfHeights && horizontalDistance <= combinedHalfWidths;
    object.checkCollision(collision);
    
    if (collision) {
      collidedObject = object;
      
      // Detect collision side
      float overlapX = combinedHalfWidths - (float)horizontalDistance;
      float overlapY = combinedHalfHeights - (float)verticalDistance;
      
      if (overlapX >= overlapY) {
        // Vertical Collision (Y)
        if (location.y < objectLocation.y) {
          location.y += overlapY;
          collisionSide = CollisionSides.Bottom;
        } else {
          location.y -= overlapY;
          collisionSide = CollisionSides.Top;
        }
      } else {
        // Horizontal Collision (X)
        if (location.x < objectLocation.x) {
          location.x += overlapX;
          collisionSide = CollisionSides.Left;
        } else {
          location.x -= overlapX;
          collisionSide = CollisionSides.Right;
        }
      }
      
      handlePlaformCollisions();
    }
  }
  
  double getHorizontalDistance(float x1, float x2) {
    float xDistance = x1 - x2;
    
    return Math.sqrt(Math.pow(xDistance, 2));
  }
  double getVerticalDistance(float y1, float y2) {
    float yDistance = y1 - y2;
    
    return Math.sqrt(Math.pow(yDistance, 2));
  }
  
  void handlePlaformCollisions() {
    if (collidedObject != null && collidedObject.getType() == Type.Platform) {
      float platformHeight = collidedObject.getPHeight();
      float platformWidth = collidedObject.getPWidth();
      PVector platformLocation = collidedObject.getLocation();
      
      switch(collisionSide) {
        case Left:
          velocity.x *= groundBounce;
          location.x = platformLocation.x - (platformWidth/2) - (pWidth/2);
          break;
        case Right:
          velocity.x *= groundBounce;
          location.x = platformLocation.x + (platformWidth/2) + (pWidth/2);
          break;
        case Top:
          velocity.y *= groundBounce;
          location.y = platformLocation.y + pHeight;
          break;
        case Bottom:
          velocity.y *= groundBounce;
          location.y = platformLocation.y - platformHeight;
          isOnGround = true;
          break;
      }
    }
  }


  /** HELPER METHODS **/
 
  void setSize(float widthDimension, float heightDimension) {
    pWidth = playerMass*widthDimension;
    pHeight = playerMass*heightDimension;
  }

  float calcLocationX(float x) {
    return x - (pWidth * 0.5);
  }

  float calcLocationY(float y) {
    return y - pHeight;
  }
  
  float centerOrigin(float origin, float objectSize) {
    return origin - (objectSize/2);
  }
}
