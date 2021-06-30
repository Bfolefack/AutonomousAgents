class Firefly {
  PVector pos, vel, acc, steer;
  float maxSpeed, maxForce, r;
  int flashCount = (int) random(20);
  boolean flashing;
  boolean arrived;

  Firefly (float _px, float _py, float _ms, float _mf) {
    pos = new PVector(_px, _py);
    vel = new PVector(random(-20, 20), random(-20, 20));
    acc = new PVector(0, 0);
    maxSpeed = _ms;
    maxForce = _mf;
    r = 20;
    arrived = false;
  }

  Firefly (PVector _p, float _ms, float _mf) {
    pos = _p;
    vel = new PVector(random(-200, 200), random(-200, 200));
    acc = new PVector(0, 0);
    maxSpeed = _ms;
    maxForce = _mf;
    r = 5;
    arrived = false;
  }

  void update() {
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);
    edgeLoop();
    if (((frameCount/10) % 20) - flashCount == 0) {
      flashing = true;
    } else {
      flashing = false;
    }
  }

  void display() {
    float theta = vel.heading() + PI/2;
    if (flashing)
      fill(255, 255, 0);
    else 
      fill(0);
    pushMatrix();
    translate(pos.x, pos.y);
    ellipse(0, 0, r, r);
    popMatrix();
  }


  void seek(PVector target) {
    PVector desired = PVector.sub(target, pos);

    float d = desired.mag();
    ;

    if (d < 100) {
      float m =  map(d, 0, 100, 0, maxSpeed);
      desired.setMag(m);
    } else {
      desired.setMag(maxSpeed);
    }

    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxForce);
    addForce(steer);
  }

  void edgeLoop() {
    if (pos.x > width) {
      pos.x = 0;
    } else if (pos.x < 0) {
      pos.x = width - 10;
    }
    if (pos.y > height) {
      pos.y = 0;
    } else if (pos.y < 0) {
      pos.y = height - 10;
    }
  }

  void addForce(PVector force) {
    // I could add mass here if I want A = F / M
    acc.add(force);
  }

  void seek(float _t1, float _t2) {
    PVector target = new PVector(_t1, _t2);
    seek(target);
  }

  void separate (Firefly[] fireflies, float minSep) {
    float desiredseparation = minSep;
    PVector sum = new PVector();
    int count = 0;

    for (int i = 0; i < agentNum; i++) {
      float d = PVector.dist(pos, fireflies[i].pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos, fireflies[i].pos);
        diff.normalize();
        diff.div(d);        // Weight by distance
        sum.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      // Our desired vector is moving away maximum speed
      sum.setMag(maxSpeed);
      PVector steer = PVector.sub(sum, vel);
      steer.limit(maxForce);
      addForce(steer);
    }
  }

  void follow (Firefly[] fireflies, float followDist) {
    float desiredattraction = followDist;
    PVector sum = new PVector();
    int count = 0;

    for (int i = 0; i < agentNum; i++) {
      float d = PVector.dist(pos, fireflies[i].pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredattraction)) {
        // Calculate vector pointing away from neighbor
        PVector diff = fireflies[i].vel;
        if(fireflies[i].flashing && !flashing){
          flashCount -= 1;
          if(flashCount < 0){
            flashCount += 20;
          }
        }
        diff.normalize();
        //diff.div(d);        // Weight by distance
        sum.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      // Our desired vector is moving away maximum speed
      sum.setMag(maxSpeed);
      PVector steer = PVector.sub(sum, vel);
      steer.limit(maxForce);
      addForce(steer);
    }
  }

  void attract (Firefly[] fireflies, float minSep) {
    float desiredattraction = minSep;
    PVector sum = new PVector();
    int count = 0;

    for (int i = 0; i < agentNum; i++) {
      float d = PVector.dist(pos, fireflies[i].pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredattraction)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos, fireflies[i].pos);
        diff.normalize();
        diff.div(d);        // Weight by distance
        sum.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      // Our desired vector is moving away maximum speed
      sum.setMag(-maxSpeed);
      PVector steer = PVector.sub(sum, vel);
      steer.limit(maxForce);
      addForce(steer);
    }
  }
}
