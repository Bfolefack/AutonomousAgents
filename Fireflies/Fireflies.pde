Firefly[] fireflies;
int maxfireflies, currentAgent, agentNum;
PVector mouse;
void setup(){
  size(1000, 700);
  currentAgent = 0;
  agentNum = 0;
  maxfireflies = 1000;
  fireflies = new Firefly[maxfireflies];
  noStroke();
  //frameRate(60);
}

void draw() {
  background(175);
  mouse = new PVector(mouseX, mouseY);
  if(mousePressed){
    if((currentAgent < maxfireflies) && (agentNum < maxfireflies)){
      fireflies[currentAgent] = new Firefly(mouse, 8, .1);
      currentAgent++;
      agentNum++;
    } else if (currentAgent < maxfireflies && agentNum == maxfireflies) {
      fireflies[currentAgent] = new Firefly(mouse, 8, .1);
      currentAgent++;
    } else {
      currentAgent = 0;
      fireflies[currentAgent] = new Firefly(mouse, 8, .1);
    }
  }
  
  for(int i = 0; i < agentNum; i++){
      fireflies[i].separate(fireflies, 10);
      fireflies[i].follow(fireflies, 20);
      fireflies[i].update();
      fireflies[i].display();
    
  }
}
