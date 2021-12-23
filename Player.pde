class Player extends GameCharacter {
  // Controls
  private boolean left, right, up, down, space;

  // Movement
  private float xAcceleration = 0;
  private float speed = 0.2;
  private float jumpForce = -20;
  
  // Color
  private color pColor;

  // Animation
  private boolean hasPlayed = false;

  Player(float mass, float x, float y, color colorValue) {
    super(mass, x, y, 1);
    
    // Player color
    pColor = colorValue;
  }
  
  void update() {
    initHorizontalMovement();
    super.initGravity();
    if (!right && !left) { super.initFriction(); }
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
    } else if (right && !left) {
      xAcceleration = speed;
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
    fill(pColor);

    // TODO: USE SPRITE SHEET
    initAnimations();
    
    rect(calcLocationX(super.position.x), calcLocationY(super.position.y), super.cWidth, super.cHeight);
  }
 

  /** ANIMATIONS **/

  private void initAnimations() {
    if (!right && !left && !up && !down && super.isOnGround) {
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
      hasPlayed = false;
    }
  }

  private void playIdleAnimation() {
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
    if (!hasPlayed) {
      if (frameNumber == 1) {
        super.animateSize(0.61, 0.39);
      } else if (frameNumber == (maxFrames * 0.5)) {
        super.animateSize(0.42, 0.58);
      } else if (frameNumber == (maxFrames * 0.75)) {
        super.animateSize(0.3, 0.7);
      } else if (frameNumber == maxFrames) {
        super.animateSize(0.39, 0.61);
        hasPlayed = true;
      }
    }
  }
}
