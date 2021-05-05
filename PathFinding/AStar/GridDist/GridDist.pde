int gridScale, grdWidth, grdHeight;
Grid griddle;
float scale = 1;
float xPan = 0 /* width/2 */;
float yPan = 0 /* height/2 */;
float truMouseX;
float truMouseY;

void setup () {
  size(1300, 720);
  gridScale = 100;
  grdWidth = 5000;
  grdHeight = 5000;
  griddle = new Grid(0, 0, grdWidth/gridScale, grdHeight/gridScale);
  stroke(0);
  float xPan = width/2;
  float yPan = height/2;
}

void draw () {
  truMouseX = (mouseX + xPan - width/2)/scale;
  truMouseY = (mouseY + yPan - height/2)/scale;
  background(150);
  pushMatrix();
  translate(-xPan, -yPan);
  translate(width/2, height/2);
  scale(scale);
  griddle.update();
  griddle.display();
  popMatrix();
}

void keyPressed() {
  if(key == 'w'){
    yPan -= 5;
  }
  if(key == 's'){
    yPan += 5;
  }
  if(key == 'a'){
    xPan -= 5;
  }
  if(key == 'd'){
    xPan += 5;
  }
}

void mouseDragged ()  {
  /*
  xPan += (pmouseX - mouseX);
  yPan += (pmouseY - mouseY);
  */
}

void mouseWheel (MouseEvent event) {
  float scaleAmt = 1 + (.05 * event.getCount());
  
  scale *= scaleAmt;
}
