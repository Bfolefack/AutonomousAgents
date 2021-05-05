class Particle {
  ParticleColor pColor;
  PVector pos, vel, acc;
  Particle(ParticleColor _c) {
    pColor = _c;
    pos = new PVector(random(simWidth), random(simHeight));
    vel = new PVector(random(-100, 100), random(-100, 100));
    acc = new PVector(0, 0);
  }

  void update() {
    acc = seek().mult(5);
    acc.add(checkCollision().mult(600));
    acc.add(avoidWalls().setMag(15));
    acc.normalize();
    acc.mult(pColor.maxSpeed);
    vel.add(acc);
    vel.limit(pColor.maxSpeed);
    pos.add(vel);
    vel.mult(.7);
  }

  void display() {
    fill(pColor.particleColor.x, pColor.particleColor.y, pColor.particleColor.z);
    ellipse(pos.x, pos.y, 15, 15);
  }

  PVector seek() {
    PVector seekDir = new PVector(0, 0);
    for (int i = 0; i  < particles.length; i++) {
      int index = particles[i].pColor.index;
      if (PVector.dist(particles[i].pos, pos) < pColor.getMaxDistWeight(index) && PVector.dist(particles[i].pos, pos) > pColor.getMinDistWeight(index) && PVector.dist(particles[i].pos, pos) > 15) {
        PVector dir = PVector.sub(particles[i].pos, pos);
        dir.normalize();
        dir.mult(pColor.getForce(index));
        dir.div(PVector.dist(particles[i].pos, pos));
        seekDir.add(dir);
      }
    }
    seekDir.normalize();
    return seekDir;
  }

  PVector checkCollision() {
    PVector seekDir = new PVector(0, 0);
    for (int i = 0; i  < particles.length; i++) {
      int index = particles[i].pColor.index;
      if (PVector.dist(particles[i].pos, pos) <= 15 && PVector.dist(particles[i].pos, pos) > 0) {
        PVector dir = PVector.sub(particles[i].pos, pos);
        dir.normalize();
        dir.mult(-1);
        seekDir.add(dir);
      }
    }
    seekDir.normalize();
    return seekDir;
  }

  PVector avoidWalls() {
    PVector eh = new PVector(0, 0);
    if (pos.x < 30) {
      eh.x += 1;
    } else if (pos.x > simWidth - 30) {
      eh.x -= 1;
    }

    if (pos.y < 30) {
      eh.y += 1;
    } else if (pos.y > simHeight - 30) {
      eh.y -= 1;
    }
    eh.normalize();
    return eh;
  }
}
