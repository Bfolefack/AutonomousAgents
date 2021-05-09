class Ant {
  PVector pos, vel, acc, steer;
  float maxSpeed, maxForce, r;
  boolean arrived;
  Grid thisGrid;

  Ant (Grid g, float _px, float _py, float _ms, float _mf) {
    pos = new PVector(_px, _py);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    thisGrid = g;
    maxSpeed = _ms;
    maxForce = _mf;
    r = 10;
    arrived = false;
  }

  void update(Grid grid) {
    PVector sum = new PVector();
    sum.add(seek(new PVector(truMouseX, truMouseY)).mult(3));
    sum.add(avoidWalls(grid).mult(300));
    sum.limit(maxForce);
    println(sum);
    addForce(sum);
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.set(0, 0);
  }

  void display() {
    float theta = vel.heading() + PI/2;
    fill(255, 0, 255);
    //stroke(0);
    //strokeWeight(1);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(theta);
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);
    popMatrix();
  }


  PVector seek(PVector t) {
    PVector desired = PVector.sub(t, pos);

    float d = desired.mag();

    if (d < 20) {
      float m =  map(d, 0, 20, 0, maxSpeed);
      desired.setMag(m);
    } else {
      desired.setMag(maxSpeed);
    }

    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxForce);
    return steer;
  }

  PVector avoid(PVector t) {
    PVector desired = PVector.sub(t, pos);

    float d = desired.mag();

    if (d < 20) {
      float m =  map(d, 0, 20, 0, maxSpeed);
      desired.setMag(m);
    } else {
      desired.setMag(maxSpeed);
    }

    PVector steer = PVector.sub(desired.mult(-1), vel);
    steer.limit(maxForce);
    return steer;
  }

  PVector avoidWalls(Grid grid) {
    int xPos = (int) (pos.x/20.0);
    int yPos = (int) (pos.y/20.0);
    int count = 0;
    PVector sum = new PVector();
    for (int i = -2; i < 3; i++) {
      for (int j = -2; j < 3; j++) {
        Cell cel = grid.getCell(xPos + i, yPos + j);
        if (cel != null) {
          if (cel.filled) {
            sum.add(avoid(new PVector((xPos + i) * 20, (yPos + j) * 20)));
            count++;
          }
        }
      }
    }
    if (count > 0) {
      sum.div(count);
    }
    return sum;
  }

  void addForce(PVector force) {
    // I could add mass here if I want A = F / M
    acc.add(force);
  }

  void seek(float _t1, float _t2) {
    PVector target = new PVector(_t1, _t2);
    seek(target);
  }
}
