class Enemy extends GameCharacter {
  private EnemyState state = EnemyState.PATROL;
  float speed = 2;
  
  PVector[] patrolPoints = null;
  int targetPosition = 0;
  
  Enemy(float x, float y) {
    super(130, x, y, 1);
    patrolPoints = new PVector[] {
       new PVector(x,y),
       new PVector(x+200,y)
    };
    targetPosition = 1;
  }
  
  void display() {
    // TODO: CREATE SEARCHING FOR PLAYER ANIMATION
    fill(0);
    if (super.health > 0) {
      rect(calcLocationX(super.position.x), calcLocationY(super.position.y), super.cWidth, super.cHeight);
    }
  }
  
  void update() {
    PVector goToPos = null;
    PVector dirToPoint = null;
    
    PVector dirToPlayer = PVector.sub(player.getLocation(), super.position);
    
    if (dirToPlayer.magSq() < (300*300)) {
      state = EnemyState.CHASE;
    } else {
      state = EnemyState.PATROL;
    }
    
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
    
    if (goToPos != null && dirToPoint != null) {
      dirToPoint.normalize();
        
      super.velocity.x = PVector.mult(dirToPoint, speed).x;
    }
    
    initFriction();
    initSpeedLimit();
    initBounce();
    initGravity();
    applyMovement();
  }
}
