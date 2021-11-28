class Player {
  // Player movement
  private PVector location = new PVector(400, 700);
  private PVector velocity = new PVector(0, 0);
  private float xAcceleration = 0;
  private float speed = 0.2;
  private float speedLimit = 5;
  private float jumpForce = -20;
  private float gravity = worldGravity;
  private int ticksLastUpdate = 0;

  // Player Size
  private float pWidth, pHeight, playerMass, halfWidth;
  private PVector playerDimension;
    
  private color pColor;

  // Collision Variables
  private boolean isOnGround = false;
  private CollisionSides collisionSide;
  
  // Objects
  private GameObject collidedObject;

  // Player animation
  private float maxFrames = 28;
  private float frameNumber = 1;
  private boolean hasPlayed = false;
  private int animationUpdate = millis();
  private int durationOneFrame = 10;

  Player(float mass, color colorValue) {
    // Player size
    playerMass = mass;
    playerDimension = new PVector(0.5, 0.5);
    pWidth = playerMass*playerDimension.x;
    pHeight = playerMass*playerDimension.y;
    halfWidth = pWidth/2;
    
    // Player color
    pColor = colorValue;
  }

  void update() {
    initHorizontalMovement();
    initFriction();
    initSpeedLimit();
    initBounce();
    initJumping();
    initGravity();
    applyMovement();
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

  void applyMovement() {
    // Move player
    PVector alignedVelocity = alignWMillis(velocity);
    location.add(alignedVelocity);
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
    int delta = millis() - animationUpdate;
    if (delta >= durationOneFrame) {
      frameNumber++;
      if (frameNumber > maxFrames) { frameNumber = 1; }
      animationUpdate += delta;
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
      float xCollisionBuffer = 1; // Without this player gets stuck when sliding across multiple platforms.
      float overlapX = (combinedHalfWidths - (float)horizontalDistance) + xCollisionBuffer;
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
          collisionSide = CollisionSides.Right;
        } else {
          location.x -= overlapX;
          collisionSide = CollisionSides.Left;
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
      println(collisionSide);
      
      switch(collisionSide) {
        case Right:
          velocity.x *= groundBounce;
          location.x = platformLocation.x - (platformWidth/2) - (pWidth/2);
          break;
        case Left:
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
  
  PVector alignWMillis(PVector speed) {
    float alignedXPos = speed.x * (millis() - ticksLastUpdate) * 0.05;
    float alignedYPos = speed.y * (millis() - ticksLastUpdate) * 0.05;
    PVector alignedSpeed = new PVector(alignedXPos, alignedYPos);
    ticksLastUpdate = millis();
    return alignedSpeed;
  }
}
