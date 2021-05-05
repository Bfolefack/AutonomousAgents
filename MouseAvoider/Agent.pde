class Agent {
  PVector pos, vel, acc, steer, randy, flee, dir, sep;
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
    flee = new PVector(0, 0);
  }
  
  void think(){
    randy = new PVector(map(noise(index, frameCount * .005, 0), 0, 1, -1, 1), map(noise(index, frameCount * .005, 1), 0, 1, -1, 1));
    randy.normalize();
    
    sep = separate(agents, 25);
    sep.normalize();
    
    seek(PVector.add(pos, randy));
    //seek(width/2, height/2, 5);
    PVector evasion = new PVector(0, 0);
    if (dist(mouseX, mouseY, pos.x, pos.y) < 100 && mousePressed) {
      evasion = evade(mouseX, mouseY);
      evasion.normalize();
    }
    
    PVector look = dodgeEdges();
    look.normalize();
    
    acc = new PVector(0, 0);
    acc.add(randy.mult(maxSpeed * 2));
    acc.add(evasion.mult(maxSpeed * 2.5));
    acc.add(sep.mult(maxSpeed * 10));
    //acc.add(look.mult(maxSpeed * 4.5));
    acc.setMag(maxSpeed);
  }

  void update() {
    think();
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
    fill(200);
    ellipse(pos.x, pos.y, 25, 25);
    fill(0);
    stroke(0);
    randy.normalize();
    line(pos.x, pos.y, pos.x + (randy.x * 12.5), pos.y + (randy.y * 12.5));
    stroke(255, 0, 0);
    flee.normalize();
    line(pos.x, pos.y, pos.x + (flee.x * 12.5), pos.y + (flee.y * 12.5));
    flee = new PVector(0, 0);
    stroke(0, 255, 0);
    sep.normalize();
    line(pos.x, pos.y, pos.x + (sep.x * 12.5), pos.y + (sep.y * 12.5));
    sep = new PVector(0, 0);
    stroke(0);
    ellipse(pos.x, pos.y, 5, 5);
  }
  
  PVector dodgeEdges(){
    PVector dodge = new PVector(0, 0);
    
    if(pos.x < 40){
      dodge.add(new PVector(1, 0));
    }else if(pos.x > width - 40){
      dodge.add(new PVector(-1, 0));
    }
    
    if(pos.y < 40){
      dodge.add(new PVector(0, 1));
    }else if(pos.y > height - 40){
      dodge.add(new PVector(0, -1));
    }
    
    return dodge;
  }


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

  PVector evade(PVector t) {

    PVector desired = PVector.sub(t, pos);
    desired.mult(-1);
    flee = desired;

    PVector steer = PVector.sub(desired, vel);
    steer.normalize();
    return steer;
  }
  
  PVector separate (Agent[] agents, float minSep) {
    float desiredseparation = minSep;
    PVector sum = new PVector();
    int count = 0;
    
    for (int i = 0; i < agents.length; i++) {
      float d = PVector.dist(pos, agents[i].pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos, agents[i].pos);
        diff.normalize();
        diff.div(d);        // Weight by distance
        sum.add(diff);
        count++;            // Keep track of how many
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

  PVector seek(float _t1, float _t2) {
    PVector target = new PVector(_t1, _t2);
    return seek(target);
  }

  PVector evade(float _t1, float _t2) {
    PVector target = new PVector(_t1, _t2);
    return evade(target);
  }

  void addForce(PVector force) {
    // I could add mass here if I want A = F / M
    acc.add(force);
  }
}
