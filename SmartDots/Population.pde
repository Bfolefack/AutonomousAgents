class Population {
  float mutRate;
  int popSize, counter;
  int steps;
  Dot[] dots;
  Population( int p_, int s_, float m_) {
    popSize = p_;
    steps = s_;
    counter = 0;
    mutRate = m_ * 1000;
  }

  void generate() {
    dots = new Dot[popSize];
    for ( int i = 0; i < popSize; i++ ) {
      dots[i] = new Dot(steps, width/2, height - (height/10), 10, .1);
      dots[i].generateArray();
    }
  }
  
  void nextGen() {
    calcFitness();
    Dot temp = new Dot(1, 0, 0, 0, 0);
    for (int i = 0; i < popSize; i++){
      if(dots[i].fitness >= temp.fitness){
        temp = dots[i];
      }
    }
    /*
    println("Max Fitness: " + temp.fitness * 100);
    println("Best Candidate: " + temp.path);
    */
    
    for (int i = 0; i < popSize; i++){
        dots[i].fitness = map(dots[i].fitness, 0, temp.fitness, 0, 1);
        dots[i].fitness *= 100;
        dots[i].fitness++;
    }
    
    
    int matingPoolLength = 0;
    for (int i = 0; i < popSize; i++){
        matingPoolLength  += Math.floor((double)dots[i].fitness);
    }
    Dot[] matingPool = new Dot[matingPoolLength];
    int count = 0;
    for (int i = 0; i < popSize; i++){
      for(int j = 0; j < Math.floor((double)dots[i].fitness); j++){
        matingPool[count] = dots[i];
        count++;
      }
    }
    
    
    
    Dot[] nextGen = new Dot[popSize];
    
    for (int i = 0; i < popSize; i++){
      nextGen[i] = mate(matingPool[int(random(matingPool.length))], matingPool[int(random(matingPool.length))]);
      mutate(nextGen[i]);
    }
    dots = nextGen;
    counter = 0;
  }
  
  Dot mate(Dot a, Dot b){
    Dot temp = new Dot(steps, width/2, height - (height/10), 10, .1);
    for(int i = 0; i < 600; i++){
      int coinFlip = round(1);
      if(coinFlip == 0){
         temp.path[i] = a.path[i];
      }
      if(coinFlip == 1){
         temp.path[i] = b.path[i];
      }
    }
    
    return temp;
  }
  
  Dot mutate( Dot a ){
    Dot temp = a;
    for(int i = 0; i < temp.path.length; i++){
      if(random(1000) < mutRate){
        temp.path[i] = PVector.fromAngle(random(360));
      }
    }
    return temp;
  }

  void update() {
    if ( counter < 600 ){
      for ( int i = 0; i < popSize; i++ ) {
        dots[i].update();
      }
      
    } else if(counter > 630){
      nextGen();
    }
    
    counter++;
  }
  
  void calcFitness(){
    for ( int i = 0; i < popSize; i++ ) {
        dots[i].calcFitness();
      }
  }

  void display() {
    for ( int i = 0; i < popSize; i++ ) {
      dots[i].display();
    }
  }
}
