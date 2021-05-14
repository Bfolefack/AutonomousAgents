class Ant {
  PVector pos, vel, acc, steer, randy, e;
  float maxSpeed, maxForce, r;
  float index;
  float offset;
  boolean arrived;
  Grid thisGrid;

  Ant (Grid g, float _px, float _py, float _ms, float _mf) {
    pos = new PVector(_px, _py);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    randy = new PVector(random(-1, 1), random(-1, 1));
    e = new PVector(randy.x, randy.y);
    thisGrid = g;
    maxSpeed = _ms;
    maxForce = _mf;
    index = random(Integer.MIN_VALUE, Integer.MAX_VALUE);
    globalIndex++;
    r = 10;
    arrived = false;
  }

  void update(Grid grid) {
    float randyRad = random(-PI, PI);
    PVector draw =  new PVector(cos(randyRad), sin(randyRad));
    e.add(draw);
    e.setMag(maxSpeed/4);
    randy.add(e);
    randy.setMag(r * 10);
    //addForce(seek(new PVector(truMouseX, truMouseY)));
    addForce(seek(PVector.add(randy, pos)));
    PVector avy = avoidWalls(grid);
    addForce(avy.mult(5));
    addForce(avoidNeighbors(grid));
    randy.add(avy.setMag(r * 20));
    vel.add(acc);
    vel.limit(maxSpeed);
    vel.mult(0.95);
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
    fill(255, 0, 0);
    popMatrix();
    //ellipse(pos.x + randy.x, pos.y + randy.y, r, r);
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

  PVector gridAvoid(PVector t) {
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
    int xPos = (int) (pos.x/20);
    int yPos = (int) (pos.y/20);
    int count = 0;
    //grid.getCell(xPos, yPos).currColor = color(255, 0, 0);
    PVector sum = new PVector();
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (abs(i) + abs(j) != 0) {
          Cell cel = grid.getCell(xPos + i, yPos + j);
          if (cel != null) {
            if (cel.filled) {
              sum.add(gridAvoid(new PVector((xPos + i) * 20, (yPos + j) * 20)));
              count++;
            }
          }
        }
      }
    }
    if (count > 0)
      sum.div(count);
    else
      sum = new PVector(0, 0);
    return sum.limit(maxForce);
  }

  PVector avoidNeighbors(Grid grid) {
    int xPos = (int) (pos.x/20);
    int yPos = (int) (pos.y/20);
    int xChunkPos = (int) (pos.x/20)/20;
    int yChunkPos = (int) (pos.y/20)/20;
    int count = 0;
    //grid.getCell(xPos, yPos).currColor = color(255, 0, 0);
    PVector sum = new PVector();
    for (Ant a : grid.chunks[xChunkPos][yChunkPos].ants) {
      if (a != this) {
        if(PVector.dist(pos, a.pos) < r * 5){
          sum.add(avoid(a.pos));
          count++;
        }
      }
    }
    if (count > 0)
      sum.div(count);
    else
      sum = new PVector(0, 0);
    return sum.limit(maxForce);
  }

  void addForce(PVector force) {
    acc.add(force);
  }

  void setChunk(Grid grid) {
    int xPos = (int) (pos.x/20)/20;
    int yPos = (int) (pos.y/20)/20;
    grid.chunks[xPos][yPos].ants.add(this);
  }

  void seek(float _t1, float _t2) {
    PVector target = new PVector(_t1, _t2);
    seek(target);
  }
}
