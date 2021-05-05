class Car {
  PVector pos;
  int maxSpeed, step;
  float fitness;
  String status;

  PVector[] path;
  int stepCount = 0;
  Car(int arraySize, float _px,float _py, float _ms) {
    path = new PVector[arraySize];
    pos = new PVector(_px, _py);
    maxSpeed = int(_ms);
    status = "alive";
  }

  void generateArray() {
    for (int i = 0; i < path.length; i++) {
      path[i] = new PVector(random(-maxSpeed, maxSpeed), random(-maxSpeed, maxSpeed));
    }
  }
  
  void display() {
    rectMode(CENTER);
    fill(0);
    rect(pos.x, pos.y, 5, 5);
  }
  
  void update() {
   if(status == "alive"){
     pos.add(path[step]);
   } else if (status == "complete"){
      fitness += 2;
   }
   checkStatus();
   step++;
  }
  
  void checkStatus(){
    if(pos.x < 5 || pos.x > width - 5 || pos.y < 5 || pos.y > height - 5){
     status = "dead"; 
    }
    if(PVector.dist(pos, end) < 20){
     status = "complete"; 
    }
  }
  
  void calcFitness(){
    fitness += 806 - PVector.dist(end, pos);
    fitness += 10;
    //fitness *= fitness;
  }
}
