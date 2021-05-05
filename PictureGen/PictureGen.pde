PImage sauce;
int popSize;
int e;
int pixelDetail;
Population pop;

void setup() {
  size(520, 620);
  pixelDetail = 50;
  sauce = loadImage("lisa.jpg");
  sauce = grayScale(sauce);
  flatten(sauce, pixelDetail);
  println(sauce.width, sauce.height);
  popSize = 1000;
  pop = new Population(popSize, .0001, sauce);
  e = 0;
  frameRate(1000);
  noSmooth();
}

PImage grayScale(PImage input){
  PImage img = createImage(input.width, input.height, RGB);
    img.loadPixels();
    for (int i = 0; i < img.pixels.length; i++) {
      img.pixels[i] = color(brightness(input.pixels[i]));
    }
    img.updatePixels();
    return img;
}

void flatten(PImage img, int flattenScale) {
  img.loadPixels();
  for (int i=0; i<img.pixels.length; i++)
  {
    color c= img.pixels[i];
    c = color(int(red(c))/flattenScale * flattenScale, int(green(c))/flattenScale * flattenScale, int(blue(c))/flattenScale * flattenScale);
    img.pixels[i] = c;
  }
  img.updatePixels();
}

void draw() {
  scale(10);
  if (!pop.answerFound) {
    pop.newGeneration();
    //image(pop.bestCandidate, 0, 0);
    image(sauce, 0, 0);
    e++;
    println("Generation: " + e);
    println("Best Fitness: " + pop.bestFitness);
  }
}
