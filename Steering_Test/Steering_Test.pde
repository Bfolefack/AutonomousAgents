Agent p;
PVector mouse;
void setup(){
  size(800, 600);
  p = new Agent(width/2, height/2, 4, .1);
}

void draw() {
  background(175);
  mouse = new PVector(mouseX, mouseY);
  p.seek(mouse);
  p.update();
  p.display();
}
