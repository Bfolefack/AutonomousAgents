class Population {
  int popSize, steps, counter;
  Car[] cars;
  Population( int p_, int s_) {
    popSize = p_;
    steps = s_;
    counter = 0;
  }

  void generate() {
    cars = new Car[popSize];
    for ( int i = 0; i < popSize; i++ ) {
      cars[i] = new Car(steps, width/2, height - (height/10),  10);
      cars[i].generateArray();
    }
  }

  void update() {
    if ( counter < 600 ){
      for ( int i = 0; i < popSize; i++ ) {
        cars[i].update();
      }
      
    } else if(counter > 630){
      nextGen();
    }
    
    counter++;
  }


  void display() {
    for ( int i = 0; i < popSize; i++ ) {
      cars[i].display();
    }
  }
  
  void calcFitness(){
    for ( int i = 0; i < popSize; i++ ) {
        cars[i].calcFitness();
      }
  }
  
  void nextGen() {
    calcFitness();
    Car temp = new Car(1, 0, 0, 0);
    for (int i = 0; i < popSize; i++){
      if(cars[i].fitness >= temp.fitness){
        temp = cars[i];
      }
    }
    
    println("Max Fitness: " + temp.fitness * 100);
    println("Best Candidate: " + temp.path);
    
    
    for (int i = 0; i < popSize; i++){
        cars[i].fitness = map(cars[i].fitness, 0, temp.fitness, 0, 1);
        cars[i].fitness *= 100;
        cars[i].fitness++;
    }
    
    
    int matingPoolLength = 0;
    for (int i = 0; i < popSize; i++){
        matingPoolLength  += Math.floor((double)cars[i].fitness);
    }
    Car[] matingPool = new Car[matingPoolLength];
    int count = 0;
    for (int i = 0; i < popSize; i++){
      for(int j = 0; j < Math.floor((double)cars[i].fitness); j++){
        matingPool[count] = cars[i];
        count++;
      }
    }
    
    
    
    Car[] nextGen = new Car[popSize];
    
    for (int i = 0; i < popSize; i++){
      nextGen[i] = mate(matingPool[int(random(matingPool.length))], matingPool[int(random(matingPool.length))]);
      mutate(nextGen[i]);
    }
    cars = nextGen;
    counter = 0;
  }
  
  Car mate(Car a, Car b){
    Car temp = new Car(steps, width/2, height - (height/10),  10);
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
  
  Car mutate( Car a ){
    Car temp = a;
    for(int i = 0; i < temp.path.length; i++){
      if(random(1000) < 10){
       temp.path[i] = PVector.fromAngle(random(360)); 
      }
    }
    return temp;
  }
  
  
}
