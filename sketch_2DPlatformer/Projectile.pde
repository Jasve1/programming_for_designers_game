// TODO: CREATE PROJECTILE CLASS THAT CAN BE USED FOR BOTH PLAYER AND ENEMY
// TODO: CREATE PROJECTILE CLASS THAT CAN BE USED FOR BOTH PLAYER AND ENEMY
public class projectile {
  private PVector location, initLocation, dist; //starting postion of projectile.
  private PVector velocity; //speed of projectile.
  private float w, h; //size of projectile.
  private color col;//color of projectile.
  private float projectileRange = 200;

  //constructor
  projectile () {
    location = initLocation;
  }

  //Shoot: when space pressed, shoot a projectile- in the main program.
  void Projectile() {
    initLocation = new PVector(player.getLocation().x, player.getLocation().y);
  }

  //The horizontal movement of a projectile.
  void moveProjectile() { 
    //player faces right side.
    if (!player.getIsFacingLeft()) {
      velocity = new PVector(2, 0);
    }
    //player faces left side.
    else if (player.getIsFacingLeft()) {
      velocity = new PVector(-2, 0);
    }
    location.add(velocity);
  }


  //check condtion after travling a distance of X pixels.
  void projectileReturn() {
    dist = new PVector (player.getLocation().x, player.getLocation().y);
    dist.sub(location.x, location.y);
    dist.normalize();
    dist.mult(2);
    
    if ((location.x > initLocation.x + projectileRange) || (location.x < initLocation.x - projectileRange)) {
    }
  }

  //Projectile display: shape, color and location.  
  void display() {
    w = 15;
    h = 15;
    col = color (0, 255, 0);
    stroke(0);
    fill(col);
    ellipse (initLocation.x, initLocation.y, w, h);
    strokeWeight (2);
    fill(220, 0, 0);
  }
}
