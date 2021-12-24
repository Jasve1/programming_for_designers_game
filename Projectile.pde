// TODO: CREATE PROJECTILE CLASS THAT CAN BE USED FOR BOTH PLAYER AND ENEMY
public class Projectile {
  private PVector location, initLocation; //starting postion of projectile.
  private PVector velocity = new PVector(0, 0); //update location of projectile.
  private float w, h; //size of projectile; 
  private float speed = 2; //speed of projectile.
  private color col;//color of projectile.
  private float projectileRange = 200;
  private boolean isActive = false;

  //constructor
  Projectile (PVector temp_initLocation) {
    initLocation = temp_initLocation;
    location = initLocation;
  }

  //The horizontal movement of a projectile.
  void moveProjectile() { 
    //if projectile is not active.
    if (!isActive) {
      //player faces right side.
      if (!player.getIsFacingLeft()) {
        velocity.x= speed;
      }
      //player faces left side.
      else if (player.getIsFacingLeft()) {
        velocity.x= -speed;
      }
    }
  }


  //check condtion after travling a distance of X pixels.
  void projectileReturn() {
    if ((location.x > initLocation.x + projectileRange) || (location.x < initLocation.x - projectileRange)) {
      PVector dirToPlayer = PVector.sub(player.getLocation(), location);
      dirToPlayer.normalize();
      velocity = PVector.mult(dirToPlayer, speed);
    }
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
    location = player.getLocation();
    location.add(velocity);
  }
}
