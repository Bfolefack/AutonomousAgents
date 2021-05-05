class Pic {
  color[] myPixels;
  float fitness = 0;
  float truFitness = 0;
  float  score;
  float accuracy;

  Pic(color[] c) {
    myPixels = c;
    for (int i = 0; i < myPixels.length; i++){
     myPixels[i] = color(int(red(myPixels[i] ))/pixelDetail * pixelDetail, int(green(myPixels[i] ))/pixelDetail * pixelDetail, int(blue(myPixels[i] ))/pixelDetail * pixelDetail);
     println(brightness(myPixels[i]));
    }
  }
  
  Pic(){
    myPixels = new color[sauce.pixels.length];
  }

  void calcFitness() {
    color[] target = sauce.pixels;
    int score = 0;
    accuracy = 0;
    float scoreMultiplier = 1;
    for ( int i = 0; i < target.length; i++ ) {
      boolean one, two, three;
      //score += (255 - abs(red(myPixels[i]) - red(target[i])))/255;
      //score += (255 - abs(green(myPixels[i]) - green(target[i])))/255;
      //score += (255 - abs(blue(myPixels[i]) - blue(target[i])))/255;
      
      //score += (255 - abs(hue(myPixels[i]) - hue(target[i])))/255;
      //score += (255 - abs(saturation(myPixels[i]) - saturation(target[i])))/255;
      //score += (255 - abs(brightness(myPixels[i]) - brightness(target[i])))/255;
      
      if (int(brightness(target[i])) == int(brightness(myPixels[i]))) {
        scoreMultiplier += 1;
        accuracy += 1;
        score += int(1 * scoreMultiplier);
      }
    }

    float a = score;
    float b = target.length;
    float c = accuracy;
    accuracy = c/b;
    fitness = a/b;
  }
}                                                        
