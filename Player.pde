class Player extends GameCharacter {
  // Controls
  private boolean left, right, up, down, space;

  // Movement
  private float xAcceleration = 0;
  private float speed = 0.2;
  private float jumpForce = -20;

  //direction
  private boolean isFacingLeft = false;

  // Animation
  private boolean jumpHasPlayed = false;
  private boolean hitHasPlayed = false;
  private PImage idleImage;
  private PImage moveImage;
  private PImage damageImage;
  private PImage animationSprite;
  private PImage lifeImage;
  private PImage lifeSprite;

  Player(float mass, float x, float y) {
    super(mass, x, y, 3, 5);

    // Animation
    idleImage = loadImage("images/Ninja Frog/Idle (32x32).png");
    moveImage = loadImage("images/Ninja Frog/Run (32x32).png");
    lifeImage = loadImage("images/Big Heart Idle (18x14).png");
    damageImage = loadImage("images/Ninja Frog/Hit (32x32).png");
  }
  
  // GET
  boolean getSpace() { return space; }
  boolean getIsFacingLeft() { return isFacingLeft; }

  void update() {
    initHorizontalMovement();
    super.initGravity();
    if (!right && !left) { 
      super.initFriction();
    }
    super.initSpeedLimit();
    super.initBounce();
    initJumping();
    super.applyMovement();
    if (super.health == 0) {
      gameState = GameState.GAMEOVER;
    }
  }

  /** CONTROLS **/
  void buttonPressed(int input) {
    switch(input) {
    case 37: //left
      left = true;
      break;
    case 39: //right
      right = true;
      break;
    case 38: //up
      up = true;
      break;
    case 40: //down
      down = true;
      break;
    case 32: //space
      space = true;
      break;
    }
  }

  void buttonReleased(int input) {
    switch(input) {
    case 37: //left
      left = false;
      break;
    case 39: //right
      right = false;
      break;
    case 38: //up
      up = false;
      break;
    case 40: //down
      down = false;
      break;
    case 32: //space
      space = false;
      break;
    }
  }

  /** MOVEMENT **/

  private void initHorizontalMovement() {
    // Horizontal Movement
    if (left && !right) {
      xAcceleration = -speed;
      isFacingLeft = true;
    } else if (right && !left) {
      xAcceleration = speed;
      isFacingLeft = false;
    } else {
      xAcceleration = 0;
    }

    super.velocity.x += xAcceleration;
  }

  private void initJumping() {
    // Jumping
    if (up && super.isOnGround) {
      super.isOnGround = false;
      super.velocity.y = jumpForce;
      super.gravity = 0;
    } else {
      super.gravity = worldGravity;
    }
  }

  /** VISUALS **/

  void display() {
    if (lifeImage != null) {
      lifeSprite = lifeImage.get(calcFrameNumber(lifeImage.width, 18)*18, 0, 18, 14);
      for(int i = 0; i < super.health; i++) {
        image(lifeSprite, width-(50*i)-50, 30, 30, 30);
      }
    }
    
    initAnimations();
    if (animationSprite != null) {
      if (isFacingLeft) {
        pushMatrix();
        translate(super.cWidth,0);
        scale(-1,1);
        image(animationSprite, -calcLocationX(super.position.x), calcLocationY(super.position.y), super.cWidth, super.cHeight);
        popMatrix();
      } else {
        image(animationSprite, calcLocationX(super.position.x), calcLocationY(super.position.y), super.cWidth, super.cHeight);
      }
    }
  }


  /** ANIMATIONS **/

  private void initAnimations() {
    if (super.isHit) {
      animationSprite = damageImage.get(calcFrameNumber(damageImage.width, 32)*32, 0, 32, 32);
      if (!hitHasPlayed) {
        frameNumber = 1;
        hitHasPlayed = true;
      } else if (frameNumber == maxFrames) {
        super.isHit = false;
      }
    } else if (!right && !left && !up && !down && super.isOnGround) {
      // Idle animation
      playIdleAnimation();
    } else if (down && super.isOnGround) {
      // Down animation
      super.animateSize(0.65, 0.35);
    } else if (super.isOnGround && !down) {
      // Move animation
      playMoveAnimation();
    } else if (!super.isOnGround) {
      // Jump animation
      playJumpAnimation();
    } else {
      // Reset
      super.animateSize(super.dimension.x, super.dimension.y);
    }

    if (up && super.isOnGround) {
      jumpHasPlayed = false;
    }
    if (!super.isHit) {
      hitHasPlayed = false;
    }
  }

  private void playIdleAnimation() {
    animationSprite = idleImage.get(frameNumber*32, 0, 32, 32);
    if (frameNumber == 1) {
      super.animateSize(0.52, 0.48);
    } else if (frameNumber == (maxFrames * 0.5)) {
      super.animateSize(0.51, 0.49);
    } else if (frameNumber == (maxFrames * 0.75)) {
      super.animateSize(0.48, 0.52);
    } else if (frameNumber == maxFrames) {
      super.animateSize(super.dimension.x, super.dimension.y);
    }
  }

  private void playMoveAnimation() {
    animationSprite = moveImage.get(frameNumber*32, 0, 32, 32);
    if (frameNumber == 1) {
      super.animateSize(0.46, 0.54);
    } else if (frameNumber == (maxFrames * 0.15)) {
      super.animateSize(0.39, 0.61);
    } else if (frameNumber == (maxFrames * 0.25)) {
      super.animateSize(0.46, 0.54);
    } else if (frameNumber == (maxFrames * 0.5)) {
      super.animateSize(0.54, 0.46);
    } else if (frameNumber == (maxFrames * 0.75)) {
      super.animateSize(0.61, 0.39);
    } else if (frameNumber == maxFrames) {
      super.animateSize(0.54, 0.46);
    }
  }

  private void playJumpAnimation() {
    if (!jumpHasPlayed) {
      if (frameNumber == 1) {
        super.animateSize(0.61, 0.39);
      } else if (frameNumber == (maxFrames * 0.5)) {
        super.animateSize(0.42, 0.58);
      } else if (frameNumber == (maxFrames * 0.75)) {
        super.animateSize(0.3, 0.7);
      } else if (frameNumber == maxFrames) {
        super.animateSize(0.39, 0.61);
        jumpHasPlayed = true;
      }
    }
  }
  
  /* HELPER METHODS */
  int calcFrameNumber(float imageWidth, float spriteSize) {
    float numOfSprites = (imageWidth/spriteSize)-1;
    float frameDifference = numOfSprites/maxFrames;
    return int(frameNumber*frameDifference);
  }
}
