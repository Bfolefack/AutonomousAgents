class Agent {
  PVector pos, vel, acc, steer;
  float maxSpeed, maxForce, r;
  boolean arrived, dead;
  int index, senseDist;

  Agent (float _px, float _py, float _ms, float _mf) {
    pos = new PVector(_px, _py);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    maxSpeed = _ms;
    maxForce = _mf;
    r = 6;
    arrived = false;
    index = int(random(100000));
    if(maxSpeed < 0){
       maxSpeed = 0; 
    }
  }

  void think(ArrayList<PVector> dodge, ArrayList<PVector> allies) {
    PVector dod = separate(dodge, gridScale);
    PVector sep = separate(allies, 40);
    PVector phys = separate(allies, 25);
    PVector grdSpace = getGridspace();
    PVector tile = flowField[int(grdSpace.y)][int(grdSpace.x)];
    PVector edge = dodgeEdges();
    PVector align = matchVel(agents, 250);
    PVector sum = new PVector(0, 0);
    dod.normalize();
    sep.normalize();
    tile.normalize();
    phys.normalize();
    edge.normalize();
    tile.normalize();
    align.normalize();
    align.mult(tile.mag());
    dod.mult(25);
    sep.mult(12);
    tile.mult(6);
    phys.mult(50);
    edge.mult(100);
    align.mult(7);
    sum.add(dod);
    sum.add(sep);
    sum.add(tile);
    sum.add(phys);
    sum.add(edge);
    sum.add(align);
    sum.setMag(maxSpeed);
    addForce(sum);
  }

  void update(ArrayList<PVector> dodge, ArrayList<PVector> allies) {
    
    think(dodge, allies);
    
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    vel.mult(.9);
    acc.set(0, 0);
    
  }
  
  PVector getGridspace() {
    int x, y;
    x = int(pos.x/gridScale);
    y = int(pos.y/gridScale);
    if(x < 0){
     x = 0; 
    } else if (x > gridWidth - 1){
      x = gridWidth - 1;
    }
    if(y < 0){
     y = 0; 
    } else if (y > gridHeight - 1){
      y = gridHeight - 1;
    }
    return new PVector(x, y);
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

    fill(255, 0, 255);
    ellipse(pos.x, pos.y, 15, 15);
    fill(0);
    stroke(0);
    
  }

  PVector dodgeEdges() {
    PVector dodge = new PVector(0, 0);

    if (pos.x < 40) {
      dodge.add(new PVector(1, 0));
    } else if (pos.x > gridWidth * gridScale - 20) {
      dodge.add(new PVector(-1, 0));
    }

    if (pos.y < 40) {
      dodge.add(new PVector(0, 1));
    } else if (pos.y > gridHeight * gridScale - 20) {
      dodge.add(new PVector(0, -1));
    }

    return dodge;
  }
  
  PVector matchVel(ArrayList<Agent> agents, int senseDist){
    PVector totalVel = new PVector(0, 0);
    int count = 0;
    for(Agent a: agents){
      float d = PVector.dist(pos, a.pos);
      if(d > 0 && d < senseDist){
        totalVel.add(PVector.div(a.vel, d));
        count++;
      }
      if(count > 0){
        totalVel.div(count);
      }
      totalVel.normalize();
    }
    return totalVel;
  }
  
  /*
  PVector seekNearest(ArrayList<Leaf> leaves) {
    float dist = 9999;
    Leaf munched = new Leaf(-1, -1);
    PVector nearest = new PVector(-1, -1);
    for (Leaf l : leaves) {
      if (PVector.dist(pos, l.pos) < senseDist) {
        if (PVector.dist(pos, l.pos) < 20) {
          munched = l;
          energy += 500;
        } else if (PVector.dist(pos, l.pos) <= dist ) {
          dist = PVector.dist(pos, l.pos);
          nearest = l.pos;
        }
      }
    }
    if (munched.pos.x > -1) {
      leaves.remove(munched);
      leafPop--;
    }
    if (nearest.x == -1) {
      return new PVector(0, 0);
    }

    PVector desired = PVector.sub(nearest, pos);

    PVector steer = PVector.sub(desired, vel);
    steer.normalize();
    return steer;
  }
  */
  
  /*
  PVector seek(PVector t) {
    PVector desired = PVector.sub(t, pos);

    float d = desired.mag();


    if (d < 100) {
      float m =  map(d, 0, 100, 0, maxSpeed);
      desired.setMag(m);
    }

    PVector steer = PVector.sub(desired, vel);
    steer.normalize();
    return steer;
  }
  */

  /*
  PVector evade(PVector t) {

    PVector desired = PVector.sub(t, pos);
    desired.mult(-1);
    flee = desired;

    PVector steer = PVector.sub(desired, vel);
    steer.normalize();
    return steer;
  }
  */

  PVector separate (ArrayList<PVector> vectors, float minSep) {
    float desiredseparation = minSep;
    PVector sum = new PVector();
    int count = 0;

    for (PVector v : vectors) {
      float d = PVector.dist(pos, v);
      if ((d > 0) && (d < desiredseparation)) {
        PVector diff = PVector.sub(pos, v);
        diff.normalize();
        diff.div(d);
        sum.add(diff);
        count++;
      }
    }
    
    PVector steer = new PVector(0, 0);
    // Average -- divide by how many
    if (count > 0) {
      // Our desired vector is moving away maximum speed
      sum.setMag(maxSpeed);
      steer = PVector.sub(sum, vel);
      steer.limit(maxForce);
    }
    return steer;
  }
  
  /*
  PVector seek(float _t1, float _t2) {
    PVector target = new PVector(_t1, _t2);
    return seek(target);
  }

  PVector evade(float _t1, float _t2) {
    PVector target = new PVector(_t1, _t2);
    return evade(target);
  }
  */

  void addForce(PVector force) {
    // I could add mass here if I want A = F / M
    acc.add(force);
  }
}
