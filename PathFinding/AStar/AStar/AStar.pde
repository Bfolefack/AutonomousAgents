int gridScale;
int INF = 999999999;
boolean begin = false;
boolean pathFound = false;
Grid grid;

void setup() {
  noStroke();
  frameRate(600);
  size(700, 700);
  gridScale = 25;
  grid = new Grid(gridScale, 1, 1, int(width/gridScale) - 2, int(height/gridScale) - 2);
}

void draw() {
  background(255);
  grid.highlightGridspace();
  grid.display();
  if (begin) {
    grid.update();
  }
}

void mouseClicked() {
  if (mouseButton == RIGHT) {
    if (begin) {
      begin = false;
    } else {
      begin = true;
    }
  }
}
