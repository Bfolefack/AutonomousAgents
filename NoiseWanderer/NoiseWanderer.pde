Agent[] agents = new Agent[100];
PVector mouse;
void setup(){
  size(800, 600);
  for (int i = 0; i < agents.length; i++){
    agents[i] = new Agent(width/2, height/2, 10, .2, i);
  }
}

void draw() {
  background(175);
  for (int i = 0; i < agents.length; i++){
    agents[i].update();
  }
  for (int i = 0; i < agents.length; i++){
    agents[i].display();
  }
}
