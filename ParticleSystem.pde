class ParticleSystem {
  private ArrayList<Particle> particles;
  private PVector origin;

  ParticleSystem(PVector position) {
    origin = position;
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    particles.add(new Particle(origin));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
