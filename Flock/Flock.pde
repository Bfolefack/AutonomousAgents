Agent[] Agents;
int maxAgents, currentAgent, agentNum;
PVector mouse;

//zoom function
float scale = 1.5;
float xPan = 400;
float yPan = 300;

void setup(){
  size(1366, 748);
  currentAgent = 0;
  agentNum = 0;
  maxAgents = 500;
  Agents = new Agent[maxAgents];
  frameRate(60);
}

void draw() {
  
  //zoom function
  translate(width/2, height/2);
  scale(scale);
  translate(-xPan, -yPan);
  
  
  background(175);
  mouse = new PVector(mouseX, mouseY);
  if(mousePressed){
    if((currentAgent < maxAgents) && (agentNum < maxAgents)){
      Agents[currentAgent] = new Agent(mouse, 10, .1);
      currentAgent++;
      agentNum++;
    } else if (currentAgent < maxAgents && agentNum == maxAgents) {
      Agents[currentAgent] = new Agent(mouse, 10, .1);
      currentAgent++;
    } else {
      currentAgent = 0;
      Agents[currentAgent] = new Agent(mouse, 10, .1);
    }
  }
  
  for(int i = 0; i < agentNum; i++){
      Agents[i].applyBehaviors(Agents);
      Agents[i].update();
      Agents[i].display();
    
  }
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
