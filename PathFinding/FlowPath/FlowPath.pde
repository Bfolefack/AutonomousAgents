float scale;
float xPan;
float yPan;
float truMouseX;
float truMouseY;
int gridScale;
Grid griddle;
void setup () {
  size(1300, 700);
  gridScale = 50;
  griddle = new Grid(0, 0, 75, 75);
  xPan = width/2;
  yPan = height/2;
  scale = 1;
  noiseDetail(8, .6);
  int x = int(random(2147483647));
  println(x);
  noiseSeed(x);
}

void draw() {
  truMouseX = (mouseX + xPan - width/2)/scale;
  truMouseY = (mouseY + yPan - height/2)/scale;

  background(255);
  pushMatrix();
  translate(-xPan, -yPan);
  translate(width/2, height/2);
  scale(scale);
  background(150);
  griddle.update();
  griddle.display();
  popMatrix();
}

void mouseDragged () {
  xPan += (pmouseX - mouseX);
  yPan += (pmouseY - mouseY);
}

void mouseWheel (MouseEvent event) {
  float scaleAmt = 1 + (.1 * event.getCount());

  scale *= scaleAmt;
  xPan *= scaleAmt;
  yPan *= scaleAmt;
}

void mousePressed () {
  if (mouseButton == 37) {
    griddle.newTarget();
  }
}
