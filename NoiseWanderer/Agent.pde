class Agent {
  PVector pos, vel, acc, steer, randy;
  float maxSpeed, maxForce, r;
  boolean arrived;
  int index;

  Agent (float _px, float _py, float _ms, float _mf, int i_) {
    pos = new PVector(_px, _py);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    maxSpeed = _ms;
    maxForce = _mf;
    r = 6;
    arrived = false;
    index = i_;
  }

  void update() {
    randy = new PVector(map(noise(index, frameCount * .005, 0), 0, 1, -1, 1), map(noise(index, frameCount * .005, 1), 0, 1, -1, 1));
    randy.normalize();
    randy.setMag(maxSpeed * 5);
    
    seek(PVector.add(pos, randy), 2);
    seek(width/2, height/2, 5);
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.set(0, 0);
    if ( pos.x > width ) {
      pos.x = 0;
    } else if (pos.x < 0) {
      pos.x = width;
    }
    if ( pos.y > width ) {
      pos.y = 0;
    } else if (pos.y < 0) {
      pos.y = width;
    }
  }

  void display() {
    /*
    float theta = vel.heading() + PI/2;
    fill(127);
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(theta);
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);
    popMatrix();
    */
    ellipseMode(CENTER);
    fill(175);
    ellipse(pos.x, pos.y, 25, 25);
    fill(0);
    ellipse(pos.x, pos.y, 5, 5);
    randy.normalize();
    line(pos.x, pos.y,pos.x + (randy.x * 12.5),pos.y + (randy.y * 12.5));
  }


  void seek(PVector t, float weight) {
    PVector desired = PVector.sub(t, pos);

    float d = desired.mag();

    if (d < 100) {
      float m =  map(d, 0, 100, 0, maxSpeed);
      desired.setMag(m);
    } else {
      desired.setMag(maxSpeed);
      desired.mult(weight);
    }

    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxForce);
    addForce(steer);
  }

  void addForce(PVector force) {
    // I could add mass here if I want A = F / M
    acc.add(force);
  }

  void seek(float _t1, float _t2, float weight) {
    PVector target = new PVector(_t1, _t2);
    seek(target, weight);
  }
}
