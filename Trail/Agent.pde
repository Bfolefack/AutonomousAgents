class Agent {
 PVector pos, vel, acc, steer;
 float maxSpeed, maxForce, r;
 boolean arrived;
 
 Agent (float _px,float _py, float _ms, float _mf) {
   pos = new PVector(_px, _py);
   vel = new PVector(0, 0);
   acc = new PVector(0, 0);
   maxSpeed = _ms;
   maxForce = _mf;
   r = 6;
   arrived = false;
 }
 
 Agent (PVector _p, float _ms, float _mf) {
   pos = _p;
   vel = new PVector(0, 0);
   acc = new PVector(0, 0);
   maxSpeed = _ms;
   maxForce = _mf;
   r = 6;
   arrived = false;
 }
 
 void update(){
  vel.add(acc);
  vel.limit(maxSpeed);
  pos.add(vel);
  acc.set(0, 0);
 }
 
 void display(){
  float theta = vel.heading() + PI/2;
    fill(127);
   /* 
    fill(50);
    textSize(20);
   */
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(theta);
    
    //text("Bruh", 0, 0);
    
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);
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
   } else if(pos.y > height){
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
}
