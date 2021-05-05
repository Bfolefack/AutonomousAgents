class Population {

  int popSize;
  float mutRate;
  boolean answerFound = false;
  PImage target;
  PImage bestCandidate;
  float bestFitness;
  Pic[] genePool;

  Population(int p_, float m_, PImage t_) {
    popSize = p_;
    mutRate = m_;
    target = t_;
    mutRate *= 10000;
    System.out.println(mutRate);

    genePool = new Pic[popSize];

    for ( int i = 0; i < popSize; i++) {
      genePool[i] = new Pic(generatePic());
    }
  }

  color[] generatePic() {
    color[] temp = new color[sauce.pixels.length];
    for (int i = 0; i < sauce.pixels.length; i++) {
      temp[i] = color(int(random(255)));
    }
    return temp;
  }

  void calcFitness() {
    for ( int i = 0; i < popSize; i++ ) {
      genePool[i].calcFitness();
    }
  }

  void newGeneration() {
    calcFitness();
    Pic temp = new Pic(new color[0]);
    temp.fitness = 0;
    for (int i = 0; i < popSize; i++) {
      if (genePool[i].fitness >= temp.fitness) {
        temp = genePool[i];
      }
    }

    float tempFitness = temp.fitness;
    bestFitness = temp.accuracy * 100;
    bestCandidate = generateImage(temp.myPixels);
    answerFound = temp.accuracy * 100 == 100;

    for (int i = 0; i < popSize; i++) {
      map(genePool[i].fitness, 0, tempFitness, 0, 1);
      genePool[i].fitness *= 100;
      genePool[i].fitness++;
    }


    int matingPoolLength = 0;
    for (int i = 0; i < popSize; i++) {
      matingPoolLength  += Math.floor((double)genePool[i].fitness);
    }
    Pic[] matingPool = new Pic[matingPoolLength];
    int counter = 0;
    for (int i = 0; i < popSize; i++) {
      for (int j = 0; j < Math.floor((double)genePool[i].fitness); j++) {
        matingPool[counter] = genePool[i];
        counter++;
      }
    }



    Pic[] nextGen = new Pic[popSize];

    for (int i = 0; i < popSize; i++) {
      nextGen[i] = mate(matingPool[int(random(matingPool.length))], matingPool[int(random(matingPool.length))]);
    }
    genePool = nextGen;
  }

  Pic mate(Pic a, Pic b) {
    Pic child;
    child = new Pic();

    for (int i = 0; i < target.pixels.length; i++) {
      int coinToss = int(random(2));
      if (coinToss == 0) {    
        child.myPixels[i] = a.myPixels[i];
      } else {
        child.myPixels[i] = b.myPixels[i];
      }
    }

    child = mutate(child);
    return child;
  }

  Pic mutate(Pic child) {
    for (int i = 0; i < child.myPixels.length; i++) {
      if (random(10000) < mutRate) {
        child.myPixels[i] = color(int(random(255)));
      }
    }

    return child;
  }

  float map (float s, float a1, float a2, float b1, float b2) {
    return b1 + (s-a1)*(b2-b1)/(a2-a1);
  }

  PImage generateImage(color[] c) {
    PImage img = createImage(sauce.width, sauce.height, RGB);
    img.loadPixels();
    for (int i = 0; i < img.pixels.length; i++) {
      img.pixels[i] = color(red(c[i]) * 10, green(c[i]) * 10, blue(c[i]) * 10);
    }
    img.updatePixels();
    return img;
  }
}
