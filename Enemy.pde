class Enemy extends GameCharacter {
  private EnemyType type;
  private float speed = 2;

  private PVector primaryPosition;
  private float moveDistance = 200;
  private int targetPosition = 0;
  
  private PVector goToPos = null;
  private PVector dirToPoint = null;
  
  private boolean isActive = false;
  private boolean isHit = false;
  
  private boolean isFacingLeft = false;
  private PImage idleChaserImage;
  private PImage moveChaserImage;
  private PImage movePatrolerImage;
  private PImage idleSpikeImage;
  private PImage activeSpikeImage;
  private PImage animationImage;
  
  Enemy(float x, float y, EnemyType newType) {
    super(130, x, y, 1, 20);
    primaryPosition = new PVector(x,y);
    type = newType;
    
    // Animation
    idleChaserImage = loadImage("images/AngryPig/Idle (36x30).png");
    moveChaserImage = loadImage("images/AngryPig/Run (36x30).png");
    movePatrolerImage = loadImage("images/Turtle/Idle 1 (44x26).png");
    idleSpikeImage = loadImage("images/Skull/Idle 2 (52x54).png");
    activeSpikeImage = loadImage("images/Skull/Idle 1 (52x54).png");
  }
  
  void update() {
    changeState();
    initActions();
    
    // Stop enemy movement when hit by projectile for the duration of maxFrames
    if (super.collisionType == CollisionType.PROJECTILE) {
      isHit = true;
      frameNumber = 1;
    } else if (frameNumber == maxFrames) {
      isHit = false;
    }
    
    if (goToPos != null && dirToPoint != null && !isHit) {
      dirToPoint.normalize();
      super.velocity.x = PVector.mult(dirToPoint, speed).x;
    }
    
    super.initGravity();
    super.initFriction();
    super.initSpeedLimit();
    super.initBounce();
    super.applyMovement();
  }
  
  /** STATE MANAGEMENT **/
  void changeState() {
    PVector dirToPlayer = PVector.sub(player.getLocation(), super.position);

    if (dirToPlayer.magSq() < (400*400) || type == EnemyType.PATROLER) {
      isFacingLeft = player.getLocation().x > super.position.x;
      isActive = true;
    } else {
      isActive = false;
    }
  }
  
  void initActions() {
    if (isActive) {
      switch (type) {
        case PATROLER:
          patrolerAction();
          break;
        case CHASER:
          chaserAction();
          break;
        case SPIKE:
          spikeAction();
          break;
      }
    } else {
      super.mass = 130;
      dirToPoint = PVector.sub(primaryPosition, super.position);
      isFacingLeft = super.position.x < primaryPosition.x;
    }
  }
  
  void patrolerAction() {
    PVector[] patrolPoints = new PVector[] {
       new PVector(primaryPosition.x,primaryPosition.y),
       new PVector(primaryPosition.x+moveDistance,primaryPosition.y)
    };
    goToPos = patrolPoints[targetPosition];
    dirToPoint = PVector.sub(goToPos, super.position);
    
    isFacingLeft = super.position.x < goToPos.x;
    
    if (Math.abs(dirToPoint.x) <= 25) {
      targetPosition++;
      if (patrolPoints.length <= targetPosition) {
        targetPosition = 0;
      }
    }
  }
  
  void chaserAction() {
    goToPos = player.getLocation();
    dirToPoint = PVector.sub(goToPos, super.position);
  }
  
  void spikeAction() {
    super.mass = 200;
  }
  
  void display() {
    initAnimations();
    if (animationImage != null) {
      if (isFacingLeft) {
        pushMatrix();
        translate(super.cWidth,0);
        scale(-1,1);
        image(animationImage, -calcLocationX(super.position.x), calcLocationY(super.position.y), super.cWidth, super.cHeight);
        popMatrix();
      } else {
        image(animationImage, calcLocationX(super.position.x), calcLocationY(super.position.y), super.cWidth, super.cHeight);
      }
    }
  }
  
  /** ANIMATION **/
  void initAnimations() {
    if(isActive) {
      switch (type) {
        case PATROLER:
          animationImage = movePatrolerImage.get(calcFrameNumber(movePatrolerImage.width, 44)*44, 0, 44, 26);
          playIdleAnimation();
          break;
        case CHASER:
          playChaseAnimation();
          break;
        case SPIKE:
          playSpikeAnimation();
          break;
      }
    } else {
      switch (type) {
        case PATROLER:
          animationImage = movePatrolerImage.get(calcFrameNumber(movePatrolerImage.width, 44)*44, 0, 44, 26);
          break;
        case CHASER:
          animationImage = idleChaserImage.get(calcFrameNumber(idleChaserImage.width, 36)*36, 0, 36, 30);
          break;
        case SPIKE:
          animationImage = idleSpikeImage.get(calcFrameNumber(idleSpikeImage.width, 52)*52, 0, 52, 54);
          break;
      }
      playIdleAnimation();
    }
  }
  
  private void playChaseAnimation() {
    animationImage = moveChaserImage.get(calcFrameNumber(idleChaserImage.width, 36)*36, 0, 36, 30);
    if (frameNumber == 1) {
      super.animateSize(0.5, 0.5);
    } else if (frameNumber == (maxFrames * 0.35)) {
      super.animateSize(0.6, 0.4);
    } else if (frameNumber == (maxFrames * 0.7)) {
      super.animateSize(0.65, 0.35);
    } else if (frameNumber == maxFrames) {
      super.animateSize(0.6, 0.4);
    }
  }
  
  private void playSpikeAnimation() {
    animationImage = activeSpikeImage.get(calcFrameNumber(activeSpikeImage.width, 52)*52, 0, 52, 54);
    if (frameNumber == 1) {
      super.animateSize(0.35, 0.35);
    } else if (frameNumber == (maxFrames * 0.25)) {
      super.animateSize(0.4, 0.4);
    } else if (frameNumber == (maxFrames * 0.5)) {
      super.animateSize(0.5, 0.5);
    } else if (frameNumber == (maxFrames * 0.75)) {
      super.animateSize(0.55, 0.55);
    } else if (frameNumber == maxFrames) {
      super.animateSize(0.4, 0.4);
    }
  }
  
  private void playIdleAnimation() {
    if (frameNumber == 1) {
      super.animateSize(0.6, 0.4);
    } else if (frameNumber == (maxFrames * 0.15)) {
      super.animateSize(0.63, 0.37);
    } else if (frameNumber == (maxFrames * 0.25)) {
      super.animateSize(0.6, 0.4);
    } else if (frameNumber == (maxFrames * 0.5)) {
      super.animateSize(0.57, 0.43);
    } else if (frameNumber == (maxFrames * 0.75)) {
      super.animateSize(0.55, 0.45);
    } else if (frameNumber == maxFrames) {
      super.animateSize(0.57, 0.43);
    }
  }
  
  /* HELPER METHODS */
  int calcFrameNumber(float imageWidth, float spriteSize) {
    float numOfSprites = (imageWidth/spriteSize)-1;
    float frameDifference = numOfSprites/maxFrames;
    return int(frameNumber*frameDifference);
  }
}
