
/*

TODO:
Implement sexual reproduction:
  Implement crossing over of genes
  Neural Networks?
Implement ArrayList replication for the sake of Astar pathfinding
Implement Dorps
Solve issues with performance
Drink some tea

*/


float scale;
float xPan;
float yPan;
float truMouseX;
float truMouseY;

boolean showChunkBorders;

int worldX = 8;
int worldY = 4;
int chunkScale = 16;
int gridScale = 20;
float noiseScale = .02;
Grid g;

void setup() {
  size(1000, 700);
  xPan = width/2;
  yPan = height/2;
  scale = 1;
  
  noiseDetail(4, .7);
  int x = int(random(10000));
  noiseSeed(9005);
  println(x);
  g = new Grid(worldX, worldY);
  noStroke();
  frameRate(60);
}

void draw() {
  truMouseX = (mouseX + xPan - width/2)/scale;
  truMouseY = (mouseY + yPan - height/2)/scale;
  
  //if(mouseX > width - 75){
  //  xPan += 10; 
  //} else if (mouseX < 75){
  //  xPan -= 10; 
  //}
  
  //if(mouseY > height - 75){
  //  yPan += 10; 
  //} else if (mouseY < 75){
  //  yPan -= 10; 
  //}
  
  background(150);
  pushMatrix();
  translate(-xPan, -yPan);
  translate(width/2, height/2);
  scale(scale);
  
  g.display();
  Chunk c = chunkLib.getChunkAt(g,(int)truMouseX/gridScale, (int)truMouseY/gridScale);
  if(c != null){
    c.selected = true;
  }
  Cell c1 = chunkLib.getCellAt(g, (int)truMouseX/gridScale, (int)truMouseY/gridScale);
  if(c1 != null){
    c1.selected = true;
  }
  
  popMatrix();
  
  fill(0);
  text(frameRate, 0, 30);
}

void keyPressed() {
  switch(key){
    case 'c':
    showChunkBorders = !showChunkBorders;
    return;
  }
}

void mouseDragged ()  {
  xPan += (pmouseX - mouseX);
  yPan += (pmouseY - mouseY);
}

void mouseWheel (MouseEvent event) {
  float scaleAmt = 1 + (.1 * event.getCount());
  
  scale *= scaleAmt;
  xPan *= scaleAmt;
  yPan *= scaleAmt;
}
