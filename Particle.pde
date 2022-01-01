//The particle system and the particle classes are based on the code of Daniel Shiffman: https://processing.org/examples/simpleparticlesystem.html

class Particle {
  PVector position; //postion of a particle
  PVector velocity; //velocity of a particle
  PVector acceleration; //change in velocity of particle
  float lifespan; //duration of particle on screen

  Particle(PVector p) {
    acceleration = new PVector(random(-0.05, 0.05), random(-0.07, 0.02));
    velocity = new PVector(random(-1, 1), random(-2, 0));
    position = p.copy(); //instantiating particles in the constructor vector p.
    lifespan = 255.0;
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
    stroke(150, 0, 0, lifespan);
    fill(150, 0, 0, lifespan);
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
