class Dot {
  PVector pos, vel, acc, steer;
  float maxSpeed, maxForce, r, fitness;
  String status = "alive";

  PVector[] path;
  int stepCount;
  Dot(int arraySize, float _px, float _py, float _ms, float _mf) {
    path = new PVector[arraySize];
    pos = new PVector(_px, _py);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    maxSpeed = _ms;
    maxForce = _mf;
    stepCount = 0;
    fitness = 0;
    r = 6;
  }
  
  Dot() {
    fitness = 0;
  }

  void generateArray() {
    for (int i = 0; i < path.length; i++) {
      path[i] = PVector.fromAngle(random(TWO_PI));
    }
  }

  void seek() {
    path[stepCount].normalize();
    path[stepCount].mult(10);
    seek(pos.add(path[stepCount]));
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

  void update() {
    if(status == "alive"){
      seek();
      //acc.mult(100);
      vel.add(acc);
      vel.limit(maxSpeed);
      pos.add(vel);
      //println(acc + " " + vel + " " + pos);
      acc.set(0, 0);
    } else if (status == "complete"){
      fitness += 2;
    }
    checkStatus();
    stepCount++;
  }
  
  void checkStatus(){
    if(pos.x < 5 || pos.x > width - 5 || pos.y < 5 || pos.y > height - 5){
     status = "dead"; 
    }
    if(PVector.dist(pos, end) < 20){
     status = "complete"; 
    }
  }

  void addForce(PVector force) {
    acc.add(force);
  }

  void display() {
    fill(0);
    rectMode(CENTER);
    rect(pos.x, pos.y, 5, 5);
  }
  
  void calcFitness(){
    fitness += 806 - PVector.dist(end, pos);
    fitness += 10;
    //fitness *= fitness;
  }
}
