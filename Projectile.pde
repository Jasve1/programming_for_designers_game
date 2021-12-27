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
    //println("Projectile initlocation: " + initLocation);
    initLocation = new PVector(playerPosition.x, playerPosition.y);
    setDirection();
    display();
  }

  //The horizontal movement of a projectile.
  void setDirection() { 
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
  
  boolean hasReturned() {
    PVector playerPosition = player.getLocation();
    float d = dist(playerPosition.x, playerPosition.y,location.x, location.y);
    println("dist is: " + d);
    return d < 5 && isReturning;
  }

  //Projectile display: shape, color and location.  
  void display() {
    col = color(0, 255, 0);
    w = 15;
    h = 15;
    stroke(0);
    fill(col);
    ellipse (location.x, location.y-20, w, h);
    fill(200, 0, 0);
  }
 

  void update () {
    projectileReturn();
    location.add(velocity);
    display();
  }
}
