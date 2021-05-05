class Agent {
 PVector pos, vel, acc, steer;
 float maxSpeed, maxForce, r;
 boolean arrived;
 
 Agent (float _px,float _py, float _ms, float _mf) {
   pos = new PVector(_px, _py);
   vel = new PVector(random(-20, 20), random(-20, 20));
   acc = new PVector(0, 0);
   maxSpeed = _ms;
   maxForce = _mf;
   r = 20;
   arrived = false;
 }
 
 Agent (PVector _p, float _ms, float _mf) {
   pos = _p;
   vel = new PVector(random(-200, 200), random(-200, 200));
   acc = new PVector(0, 0);
   maxSpeed = _ms;
   maxForce = _mf;
   r = 20;
   arrived = false;
 }
 
 void update(){
  vel.add(acc);
  vel.limit(maxSpeed);
  pos.add(vel);
  acc.mult(0);
  edgeLoop();
 }
 
 void display(){
  float theta = vel.heading() + PI/2;
    fill(175);
    stroke(0);
    pushMatrix();
    translate(pos.x, pos.y);
    ellipse(0, 0, r, r);
    popMatrix();
 }
 
 
 void seek(PVector target){
   PVector desired = PVector.sub(target, pos);
   
   float d = desired.mag();;
   
   if(d < 100){
     float m =  map(d, 0, 100, 0, maxSpeed);
     desired.setMag(m);
   } else {
     desired.setMag(maxSpeed);
   }
   
   PVector steer = PVector.sub(desired, vel);
   steer.limit(maxForce);
   addForce(steer);
 }
 
 void edgeLoop(){
   if(pos.x > width){
    pos.x = 0;
   } else if(pos.x < 0){
     pos.x = width - 10;
   }
   if(pos.y > height){
    pos.y = 0;
   } else if(pos.y < 0){
     pos.y = height - 10;
   }
 }
 
 void addForce(PVector force){
   // I could add mass here if I want A = F / M
   acc.add(force);
 }
 
 void seek(float _t1, float _t2){
   PVector target = new PVector(_t1, _t2);
   seek(target);
 }
 
 void separate (Agent[] agents, float minSep) {
    float desiredseparation = minSep;
    PVector sum = new PVector();
    int count = 0;
    
    for (int i = 0; i < agentNum; i++) {
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
    // Average -- divide by how many
    if (count > 0) {
      // Our desired vector is moving away maximum speed
      sum.setMag(maxSpeed);
      PVector steer = PVector.sub(sum, vel);
      steer.limit(maxForce);
      addForce(steer);
    }
  }
  
  void follow (Agent[] agents){
    float desiredattraction = r * 2;
    PVector sum = new PVector();
    int count = 0;
    
    for (int i = 0; i < agentNum; i++) {
      float d = PVector.dist(pos, agents[i].pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredattraction)) {
        // Calculate vector pointing away from neighbor
        PVector diff = agents[i].vel;
        diff.normalize();
        diff.div(1);        // Weight by distance
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
  
  void attract (Agent[] agents, float minSep) {
    float desiredattraction = r * 2;
    PVector sum = new PVector();
    int count = 0;
    
    for (int i = 0; i < agentNum; i++) {
      float d = PVector.dist(pos, agents[i].pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredattraction)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos, agents[i].pos);
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
