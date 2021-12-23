class Enemy extends GameCharacter {
  private EnemyType type;
  private float speed = 2;

  private PVector primaryPosition;
  private float moveDistance = 200;
  private int targetPosition = 0;
  
  private PVector goToPos = null;
  private PVector dirToPoint = null;
  
  private boolean isActive = false;
  
  Enemy(float x, float y, EnemyType newType) {
    super(130, x, y, 1);
    primaryPosition = new PVector(x,y);
    type = newType;
  }
  
  void update() {
    // TODO: IMPLEMENT DIFFERENT ENEMY TYPES
      // ENEMY TYPE: Archer, shoots deadly projectiles.
    changeState();
    initActions();
    
    if (goToPos != null && dirToPoint != null) {
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
        case ARCHER:
          break;
      }
    } else {
      super.mass = 130;
      dirToPoint = PVector.sub(primaryPosition, super.position);
    }
  }
  
  void patrolerAction() {
    PVector[] patrolPoints = new PVector[] {
       new PVector(primaryPosition.x,primaryPosition.y),
       new PVector(primaryPosition.x+moveDistance,primaryPosition.y)
    };
    goToPos = patrolPoints[targetPosition];
    dirToPoint = PVector.sub(goToPos, super.position);
    
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
    fill(0);
    
    if (isActive && type == EnemyType.CHASER) {
      playChaseAnimation();
    } else if (isActive && type == EnemyType.SPIKE) {
      playSpikeAnimation();
    } else if (super.isOnGround) {
      playMoveAnimation();
    }
    
    rect(calcLocationX(super.position.x), calcLocationY(super.position.y), super.cWidth, super.cHeight);
  }
  
  /** ANIMATION **/
  private void playChaseAnimation() {
    if (frameNumber == 1) {
      fill(0);
      super.animateSize(0.5, 0.5);
    } else if (frameNumber == (maxFrames * 0.35)) {
      fill(#831010);
      super.animateSize(0.6, 0.4);
    } else if (frameNumber == (maxFrames * 0.7)) {
      fill(#C91010);
      super.animateSize(0.65, 0.35);
    } else if (frameNumber == maxFrames) {
      fill(#831010);
      super.animateSize(0.6, 0.4);
    }
  }
  
  private void playSpikeAnimation() {
    if (frameNumber == 1) {
      fill(0);
      super.animateSize(0.35, 0.35);
    } else if (frameNumber == (maxFrames * 0.25)) {
      fill(#0E3105);
      super.animateSize(0.4, 0.4);
    } else if (frameNumber == (maxFrames * 0.5)) {
      fill(#1A5809);
      super.animateSize(0.5, 0.5);
    } else if (frameNumber == (maxFrames * 0.75)) {
      fill(#2A930D);
      super.animateSize(0.55, 0.55);
    } else if (frameNumber == maxFrames) {
      fill(#0E3105);
      super.animateSize(0.4, 0.4);
    }
  }
  
  private void playMoveAnimation() {
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
}
