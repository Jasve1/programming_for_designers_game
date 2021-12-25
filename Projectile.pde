// TODO: CREATE PROJECTILE CLASS THAT CAN BE USED FOR BOTH PLAYER AND ENEMY
public class Projectile {
  private PVector location, initLocation; //starting postion of projectile.
  private PVector velocity = new PVector(0, 0); //update location of projectile.
  private float w, h; //size of projectile; 
  private float speed = 5; //speed of projectile.
  private color col;//color of projectile.
  private float projectileRange = 400;
  private boolean isReturning = false;
  private Player player;

  //constructor
  Projectile (Player player) {
    this.player = player;
    PVector playerPosition = player.getLocation();
    location = new PVector(playerPosition.x, playerPosition.y);
    println("Projectile initlocation: " + initLocation);
    initLocation = new PVector(playerPosition.x, playerPosition.y);
    setVelocity();
    display();
  }

  //The horizontal movement of a projectile.
  void setVelocity() { 
    //player faces left side.
    if (player.getIsFacingLeft()) {
      velocity.x = -speed;
    }
    //player faces right side.
    else {
      velocity.x = speed;
    }
  }


  //check condtion after travling a distance of X pixels.
  void projectileReturn() {
    println("initLocation.x + range: " + initLocation.x + projectileRange);
    if (passedRange() || isReturning) {
      isReturning = true;
      setVelocityToPlayer();
    }
  }
  
  boolean passedRange() {
    return (location.x > initLocation.x + projectileRange) || (location.x < initLocation.x - projectileRange);
  }
 
  void setVelocityToPlayer() {
      PVector dirToPlayer = PVector.sub(player.getLocation(), location);
      dirToPlayer.normalize();
      velocity = PVector.mult(dirToPlayer, speed);
  }

  //Projectile display: shape, color and location.  
  void display() {
    w = 15;
    h = 15;
    col = color (0, 255, 0);
    stroke(0);
    fill(col);
    ellipse (location.x, location.y, w, h);
    strokeWeight (2);
    fill(220, 0, 0);
  }

  void update () {
    projectileReturn();
    location.add(velocity);
    display();
    println("Projectile location: after addition: " + location);
  }
}
