int gridScale, grdWidth, grdHeight;
Grid griddle;
float scale;
float xPan;
float yPan;
float truMouseX;
float truMouseY;
float noiseScale;
static final int DEEPOCEAN = 0;
static final int SHALLOWOCEAN = 1;
static final int COASTLINE = 2;
static final int LIGHTGRASS = 3;
static final int GRASS = 4;
static final int LOWMONT = 5;
static final int HIGHMONT = 6;
static final int SNOW = 7;

void setup () {
  noiseDetail(8,0.6);
  int x = int(random(1000000));
  println(x);
  noiseSeed(x);
  size(1300, 720);
  gridScale = 20;
  grdWidth = 3200;
  grdHeight = 3200;
  noiseScale = .02;
  griddle = new Grid(0, 0, grdWidth/gridScale, grdHeight/gridScale);
  noStroke();
  xPan = width/2;
  yPan = height/2;
  fill(0);
  scale = 1;
  for(int i = 0; i < 5; i++){
   griddle.edgeSmoothing();
  }
  Cell[] cells = new Cell[25600];
  int counter = 0;
  for(int i = 0; i < 160; i++){
      for(int j = 0; j < 160; j++){   
          cells[counter] = griddle.Cells[i][j];
          counter++;
      }
    }
}

void draw () {
  truMouseX = (mouseX + xPan - width/2)/scale;
  truMouseY = (mouseY + yPan - height/2)/scale;
  
  if(mouseX > width - 75){
    xPan += 10; 
  } else if (mouseX < 75){
    xPan -= 10; 
  }
  
  if(mouseY > height - 75){
    yPan += 10; 
  } else if (mouseY < 75){
    yPan -= 10; 
  }
  
  
  background(150);
  pushMatrix();
  translate(-xPan, -yPan);
  translate(width/2, height/2);
  scale(scale);
  griddle.display();
  popMatrix();
}

void mouseWheel (MouseEvent event) {
  float scaleAmt = 1 + (.1 * event.getCount());
  
  scale *= scaleAmt;
  xPan *= scaleAmt;
  yPan *= scaleAmt;
}
