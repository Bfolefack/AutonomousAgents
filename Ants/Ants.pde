Zoom zoomer;
ArrayList<Ant> ants;
float truMouseX;
float truMouseY;
int seed = 0;
int globalIndex = 0;
Grid farm;
void setup() {
  noiseDetail(4, 0.5);
  if (seed == 0) {
    seed = (int)random(Integer.MIN_VALUE, Integer.MAX_VALUE);
  }
  ants = new ArrayList<Ant>();
  randomSeed(seed);
  noiseSeed(seed);
  size(1000, 700);
  farm = new Grid(500, 500, 20, 0.45, 0.05);
  noStroke();
  zoomer = new Zoom(1);
}


void draw() {
  background(155);
  if (keyPressed && key == 'w') {
    ants.add(new Ant(farm, truMouseX, truMouseY, 15, 0.9));
  }
  if (keyPressed && key == 'a') {
    for (int i = 0; i < 50; i++)
      ants.add(new Ant(farm, truMouseX, truMouseY, 15, 0.9));
  }
  zoomer.pushZoom();
  zoomer.mousePan();
  farm.display();
  for (int i = ants.size() - 1; i >= 0; i--) {
    ants.get(i).setChunk(farm);
  }
  for (Ant a : ants) {
    a.update(farm);
    a.display();
  }
  zoomer.popZoom();
}

void mouseWheel(MouseEvent event) {
  zoomer.mouseScale(event, 0.1);
}
