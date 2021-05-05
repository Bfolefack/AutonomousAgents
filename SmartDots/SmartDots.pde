PVector VERTICAL = PVector.fromAngle(0);
PVector end;
Population pop;
void setup(){
  end = new PVector(width/2, height/10);
  ellipseMode(CENTER);
  println(CENTER);
  size(1200, 600);
  pop = new Population(1000, 600, .01);
  pop.generate();
  noStroke();
}

void draw(){
  background(200);
  ellipse(end.x, end.y, 40, 40);
  pop.update();
  pop.display();
  fill(255, 0, 0);
}
