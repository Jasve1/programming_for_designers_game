//The particle system and the particle classes are based on the code of Daniel Shiffman: https://processing.org/examples/simpleparticlesystem.html

class Particle {
  private PVector position; //postion of a particle
  private PVector velocity; //velocity of a particle
  private PVector acceleration; //change in velocity of particle
  private float lifespan; //duration of particle on screen
  private float r,g,b;

  Particle(PVector p) {
    acceleration = new PVector(random(-0.05, 0.05), random(-0.07, 0.02));
    velocity = new PVector(random(-1, 1), random(-2, 0));
    position = p.copy(); //instantiating particles in the constructor vector p.
    lifespan = 255.0;
    r = random(0,255);
    g = random(0,255);
    b = random(0,255);
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    PVector timedVelocity = timeSpeedWMillis(velocity);
    position.add(timedVelocity);
    lifespan -= 15/score;
  }

  // Method to display
  void display() {
    fill(r, g, b, lifespan);
    ellipse(position.x, position.y, lifespan*0.5, lifespan*0.5);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 32) {
      return true;
    } else {
      return false;
    }
  }
  private PVector timeSpeedWMillis(PVector velocity) {
    float timedXPos = velocity.x * (millis() - ticksLastUpdate) * 0.05;
    float timedYPos = velocity.y * (millis() - ticksLastUpdate) * 0.05;
    PVector timedSpeed = new PVector(timedXPos, timedYPos);
    return timedSpeed;
  }
}
