Rocket r;

void setup(){
  size(1000, 800);
  r = new Rocket(true, 6);
}

void draw(){
  background(0);
  r.display();
  r.update();
}
