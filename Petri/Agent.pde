class Agent {
  PVector pos, vel, acc, steer;
  PVector seekPoint = new PVector(0, 0);
  float maxSpeed, maxForce, r, senseDist, energyCost;
  int frames, energy;
  boolean arrived, alive, initiated;

  Agent (float _px, float _py, float _ms, float _mf, float _sd) {
    pos = new PVector(_px, _py);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    frames = 0;
    energy = 1;
    maxSpeed = _ms;
    maxForce = _mf;
    senseDist = _sd;
    r = 6;
    population++;
    alive = true;
    arrived = false;
    initiated = false;
    energyCost = (pow(maxSpeed/2, 2) + (senseDist/400))/1.25;
    if (maxSpeed < 0){
     maxSpeed = 0; 
    }
    if (maxForce < 0){
     maxForce = 0; 
    }
    if (senseDist < 0){
     senseDist = 0; 
    }
  }

  void update() {
      frames++;
      addForce(seekNearestPellet(p));
      addForce(avoidEdges().mult(100));
      vel.add(acc);
      vel.limit(maxSpeed);
      pos.add(vel);
      acc.set(0, 0);
    }
  
  void calculate(Agent[] agents) {
    if (energy < energyCost /*&& initiated*/){
      alive = false;
      population--;
    } else if (energy > energyCost * 2){
      if (currentAgent < 200){
        agents[currentAgent] = new Agent(pos.x, pos.y, maxSpeed + random(-0.2, 0.2), maxForce + random(-0.05, 0.05), senseDist + random(-10, 10));
        currentAgent++;
      } else {
        for (int i = 0; i < 200; i++){
          if (!agents[i].alive){
            agents[i] = new Agent(pos.x + random(-50, 50), pos.y + random(-50, 50), maxSpeed + random(-0.2, 0.2), maxForce + random(-0.05, 0.05), senseDist + random(-10, 10));
          }
        }
      }
    }
    energy = 0;
  }

  void display() {
    float theta = vel.heading() + PI/2;
    push();
    fill(maxSpeed * 50, maxForce * 1000, senseDist);
    /* 
     fill(50);
     textSize(20);
     */
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(theta);

    //text("Bruh", 0, 0);

    beginShape();
    vertex(0, -r*2);
    vertex(-r, r * 2 * maxSpeed/2);
    vertex(r, r * 2 * maxSpeed/2);
    endShape(CLOSE);
    popMatrix();
    pop();
  }


  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, pos);
    desired.setMag(maxSpeed);

    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxForce);
    return steer;
  }

  void edgeLoop() {
    if (pos.x > width) {
      pos.x = 0;
    } else if (pos.x < 0) {
      pos.x = width - 10;
    } else if (pos.y > height) {
      pos.y = 0;
    } else if (pos.y < 0) {
      pos.y = height - 10;
    }
  }

  void addForce(PVector force) {
    // I could add mass here if I want A = F / M
    acc.add(force);
  }

  PVector seek(float _t1, float _t2) {
    PVector target = new PVector(_t1, _t2);
    return seek(target);
  }
  
  PVector wander(){
    if (frames >= 60){
      seekPoint.set(random(-1000000f, 1000000f), random(-1000000f, 1000000f));
      frames = 0;
    }
    return seek(seekPoint);
  }

  PVector seekNearestPellet(PelletPopulation p) {
    initiated = true;
    PVector nearestPellet = new PVector(INF, INF);
    
    if(dist(pos.x, pos.y, mouseX, mouseY) < 20){
      println("[" + maxSpeed + "][" + maxForce + "][" + senseDist + "][" + energyCost + "]");
      println(maxSpeed * 50, maxForce * 1000, senseDist);
    }
    
    for (int i = 0; i < p.size; i++) {
      
      if ((PVector.dist(p.pellets[i].pos, pos) < PVector.dist(nearestPellet, pos)) && p.pellets[i].eaten == false && PVector.dist(p.pellets[i].pos, pos) < senseDist) {
        nearestPellet = p.pellets[i].pos;
      }
      
      if (PVector.dist(p.pellets[i].pos, pos) < 15) {
        
        if(!p.pellets[i].eaten){
          p.pellets[i].eaten = true;
          energy++;
        }
        
      }
      
    }
    
    if (nearestPellet.x == INF) {
      return wander();
    }
    
    return seek(nearestPellet);
  }
  
  PVector avoidEdges(){
    if(dist(pos.x, pos.y, width/2, height/2) > 290){
       return seek(width/2, height/2);
    }
    return new PVector(0, 0);
  }
}
