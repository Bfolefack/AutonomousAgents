
boolean pelletsExtant;
int INF = 999999999;
int currentAgent; 
int population = 0;
PelletPopulation p;
AgentPopulation a;


//zoom function
float scale = 1.5;
float xPan = 400;
float yPan = 300;

void setup () {
  ellipseMode(CENTER);
  size(900, 700);
  pelletsExtant = true;
  a = new AgentPopulation(5);
  p = new PelletPopulation(50);
}


void draw () {
  
  //zoom function
  translate(width/2, height/2);
  scale(scale);
  translate(-xPan, -yPan);
  
  background(200);
  noStroke();
  ellipse(width/2, height/2, 600, 600);
  p.grow();
  p.display();
  p.checkIfExtinct();
  if(pelletsExtant){
    a.seekNearestPellet(p);
    a.display();
    a.update();
  } else {
    a.calculate();
    p = new PelletPopulation(p.size);
    pelletsExtant = true;
  }
}

void mousePressed () {
  println(population);
}

//zoom function
void mouseDragged ()  {
  xPan += (pmouseX - mouseX)/scale;
  yPan += (pmouseY - mouseY)/scale;
}

void mouseWheel (MouseEvent event) {
  float scaleAmt = 1 + (.05 * event.getCount());
  println(scaleAmt);
  scale *= scaleAmt;
}
