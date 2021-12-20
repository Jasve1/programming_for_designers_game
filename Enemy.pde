class Enemy extends GameCharacter {
  private EnemyState state = EnemyState.PATROL;
  private float speed = 2;
  
  private PVector[] patrolPoints = null;
  private int targetPosition = 0;
  
  private PVector goToPos = null;
  private PVector dirToPoint = null;
  
  Enemy(float x, float y) {
    super(130, x, y, 1);
    patrolPoints = new PVector[] {
       new PVector(x,y),
       new PVector(x+200,y)
    };
    targetPosition = 1;
  }
  
  void update() {
    // TODO: IMPLEMENT DIFFERENT ENEMY TYPES
      // ENEMY TYPE: Chaser, stands still untill the player is close.
      // ENEMY TYPE: Patrol, jumps 3 times then quickly launches to another spot.
      // ENEMY TYPE: Spike, when something comes close it erupts its spikes.
      // ENEMY TYPE: Archer, shoots deadly projectiles.
    changeState();
    handleState();
    
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

    if (dirToPlayer.magSq() < (300*300)) {
      state = EnemyState.CHASE;
    } else {
      state = EnemyState.PATROL;
    }
  }
  
  void handleState() {
    switch(state) {
      case PATROL: {
        goToPos = patrolPoints[targetPosition];
        dirToPoint = PVector.sub(goToPos, super.position);
        
        if (Math.abs(dirToPoint.x) <= 25) {
          targetPosition++;
          if (patrolPoints.length <= targetPosition) {
            targetPosition = 0;
          }
        }
      }
      break;
      case CHASE: {
        goToPos = player.getLocation();
        dirToPoint = PVector.sub(goToPos, super.position);
      }
      break;
    }
  }
  
  void display() {
    fill(0);
    
    if (state == EnemyState.CHASE) {
      playChaseAnimation();
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
