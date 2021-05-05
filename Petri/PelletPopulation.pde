class PelletPopulation { 
  int size, timer;
  boolean extinct;
  Pellet[] pellets;
  PelletPopulation(int s_) {
    size = s_;
    pellets = new Pellet[size];
    for (int i = 0; i < size; i++) {
      pellets[i] = new Pellet();
    }
    
    extinct = false;
  }

  void grow() {
    for (int i = 0; i < size; i++) {
      pellets[i].spawn();
    }
  }

  void display() {
    for (int i = 0; i < size; i++) {
      if (!pellets[i].eaten) {
        pellets[i].display();
      }
    }
  }

  void checkIfExtinct() {
    /*
    boolean e  = true;
    for (int i = 0; i < size; i++) {
      if (!pellets[i].eaten) {
        e = false;
      }
    }
    if (e) {
      extinct = true;
      pelletsExtant = !extinct;
    }
    */
    timer++;
    if(timer > 600){
      pelletsExtant = false;
      timer = 0;
    }
  }
}
