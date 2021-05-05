class Pellet {
  PVector pos;
  boolean eaten, e;

  Pellet () {
    e = true;
    eaten = false;
    pos = new PVector(0, 0);
  }
  
  //Initializes pellet in a random location
  void spawn() {
    while (e == true) {
      pos.x = random(150, 750);
      pos.y = random(50, 650);
      //Ensures pellet falls within the petri dish
      if(pow((pos.x - width/2), 2) + pow((pos.y - height/2), 2) < pow(290, 2)){
        e = false; 
      }
    }
  }
  
  void display() {
    push();
    fill(100, 200, 25);
    ellipse(pos.x, pos.y, 10, 10);
    pop();
  }
}
