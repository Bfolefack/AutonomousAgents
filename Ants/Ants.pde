Zoom zoomer;
float truMouseX;
float truMouseY;
int seed = 0;
Grid farm;
void setup(){
  noiseDetail(4 , 0.5);
  if(seed == 0){
    seed = (int)random(Integer.MIN_VALUE,Integer.MAX_VALUE);
  }
  randomSeed(seed);
  noiseSeed(seed);
  size(1000, 700);
  farm = new Grid(100, 1000, 20, 0.45, 0.05);
  noStroke();
  zoomer = new Zoom(1);
}


void draw(){
  background(0);
  zoomer.pushZoom();
  zoomer.mousePan();
  farm.display();
  zoomer.popZoom();
}

void mouseWheel(MouseEvent event){
  zoomer.mouseScale(event, 0.1);
}
