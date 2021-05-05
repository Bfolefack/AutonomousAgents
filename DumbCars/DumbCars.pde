PVector VERTICAL = PVector.fromAngle(0);
PVector end;
Population pop;
void setup(){
  size(1200, 600);
  end = new PVector(width/2, height/10);
  pop = new Population(500, 600);
  pop.generate();
  noStroke();
}

void draw(){
  background(200);
  fill(255, 0, 0);
  ellipse(end.x, end.y, 40, 40);
  pop.update();
  pop.display();
}
