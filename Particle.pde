class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;

  Particle(PVector P) {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    location = P.get();
  }
  
  //update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
  }
  
  //display particle
  void display() {
    ellipse(location.x, location.y, 10, 10);
  }
}
