Zoom zoomer;
ArrayList<Ant> ants;
float truMouseX;
float truMouseY;
int seed = 0;
int gridScale = 15;
int gridSize = 1000;
int globalIndex = 0;
int timeLapseID = (int) random(Integer.MIN_VALUE, Integer.MAX_VALUE);
int shutterSpeed = 20; //time in frames
float exhaustTime = 2.5; //time in minutes
boolean showAnts = true;
boolean showFarm = true;
boolean saveTimelapse = true;
Ant followerAnt;
Grid farm;
Nest nest;

void settings() {
  size(gridSize, gridSize);
}

void setup() {
  noiseDetail(4, 0.5);
  frameRate(144);
  if (seed == 0) {
    seed = (int)random(Integer.MIN_VALUE, Integer.MAX_VALUE);
  }
  ants = new ArrayList<Ant>();
  randomSeed(seed);
  noiseSeed(seed);
  farm = new Grid(gridSize, gridSize, gridScale, 0.45, 0.025);
  noStroke();
  zoomer = new Zoom(1.0/gridScale);
}


void draw() {
  background(155);
  zoomer.pushZoom();
  zoomer.mousePan();
  farm.display();
  farm.update();
  //for (int i = ants.size() - 1; i >= 0; i--) {
  //  ants.get(i).setChunk(farm);
  //}
  for (int i = ants.size() - 1; i >= 0; i--) {
    if (showAnts)
      ants.get(i).display();
    ants.get(i).update(farm);
  }
  if (nest != null) {
    nest.display(farm);
  }
  if(followerAnt != null){
    zoomer.xPan = followerAnt.pos.x * zoomer.scale;
    zoomer.yPan = followerAnt.pos.y * zoomer.scale;
  }
  zoomer.popZoom();
}

void mouseWheel(MouseEvent event) {
  zoomer.mouseScale(event, 0.1);
}

void keyPressed(){
  if (key == 'w') {
      ants.add(new Ant(farm, truMouseX, truMouseY, 15, 2));
    } else if (key == 'p') {
      for (int i = 0; i < 50; i++)
        ants.add(new Ant(farm, truMouseX, truMouseY, 15, 2));
    } else if (key == 'n') {
      nest = new Nest((int)truMouseX/gridScale, (int)truMouseY/gridScale, 5, farm);
    } else if (key == 'f') {
      println(frameRate);
      println(ants.size());
      println();
    } else if (key == 'a') {
      showAnts = !showAnts;
    } else if (key == 'g') {
      showFarm = !showFarm;
    } else if (key == 'r') {
      followerAnt = null;
    }
}
