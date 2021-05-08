//Created by Boueny Folefack
//TODO: Interconnect full cave network
//TODO: Arrival Function

float scale;
float xPan;
float yPan;
float truMouseX;
float truMouseY;
int gridScale, gridWidth, gridHeight;
Grid griddle;
boolean showRadii;
ArrayList<Agent> agents;
PVector[][] flowField;

void setup () {
  size(1300, 700);
  gridScale = 50;
  gridWidth = 100;
  gridHeight= 100;
  griddle = new Grid(0, 0, gridWidth, gridHeight);
  xPan = width/2;
  yPan = height/2;
  scale = 1;
  agents = new ArrayList<Agent>();
  noiseDetail(1);
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
  ArrayList<PVector> dodge = griddle.getDodgeVectors();
  ArrayList<PVector> allies = new ArrayList<PVector>();
  flowField = griddle.getField();
  
  for(Agent a : agents){
      allies.add(a.pos);
  }
  
  for(Agent a : agents){
      a.update(dodge, allies);
  }
  for(Agent a : agents){
      a.display();
  }
  
  if(keyPressed && key == 'q'){
    agents.add(new Agent(truMouseX, truMouseY, 15, .2));
  }
  
  popMatrix();
  textSize(30);
  text("FrameRate: " + int(frameRate), 50, 50);
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
  
void keyPressed() {
  if(key == 'r'){
    showRadii = !showRadii;
  }
}
