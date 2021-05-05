int gridScale, grdWidth, grdHeight;
Grid griddle;
int INF = 999999999;
boolean begin = false;
boolean pathFound = false;

void setup () {
  size(1300, 700);
  gridScale = 10;
  griddle = new Grid(0, 0, width/gridScale, height/gridScale);
  noStroke();
  frameRate(1200);
  fill(0);
}

void draw () {
  griddle.update();
  griddle.update();
  griddle.update();
  griddle.update();
  griddle.update();
  griddle.update();
  griddle.display();
}
