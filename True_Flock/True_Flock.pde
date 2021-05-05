Agent[] Agents;
int maxAgents, currentAgent, agentNum;
PVector mouse;
void setup(){
  size(800, 600);
  currentAgent = 0;
  agentNum = 0;
  maxAgents = 500;
  Agents = new Agent[maxAgents];
  frameRate(60);
}

void draw() {
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
      Agents[i].separate(Agents, 30);
      Agents[i].follow(Agents);
      Agents[i].update();
      Agents[i].display();
    
  }
}
