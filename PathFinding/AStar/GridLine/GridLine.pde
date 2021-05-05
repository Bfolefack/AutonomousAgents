int gridScale, grdWidth, grdHeight;
Grid griddle;
float scale = 1;
float xPan = 0 /* width/2 */;
float yPan = 0 /* height/2 */;
float truMouseX;
float truMouseY;
LineObj line;

void setup () {
  size(1300, 720);
  
  gridScale = 10;
  grdWidth = 5000;
  grdHeight = 5000;
  griddle = new Grid(0, 0, grdWidth/gridScale, grdHeight/gridScale);
  
  stroke(0);
  
  float xPan = width/2;
  float yPan = height/2;
  
  line = new LineObj(0, 0, mouseX, mouseY);
}

void draw () {
  truMouseX = (mouseX + xPan)/scale;
  truMouseY = (mouseY + yPan)/scale;
  background(150);
  translate(-width/2, -height/2);
  pushMatrix();
  translate(-xPan, -yPan);
  translate(width/2, height/2);
  scale(scale);
  
  line.update(0, 0, truMouseX, truMouseY);
  for(int i = 0; i < griddle.gridHeight; i++){
      for(int j = 0; j < griddle.gridWidth; j++){   
          if (line.intersect(griddle.Cells[i][j])){
            griddle.Cells[i][j].filled = true;
          }
      }
    }
  
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
