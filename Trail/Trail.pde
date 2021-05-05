Agent[] Agents;
int maxAgents, currentAgent, agentNum;
PVector mouse;
void setup(){
  size(800, 600);
  currentAgent = 0;
  agentNum = 0;
  maxAgents = 20000;
  Agents = new Agent[maxAgents];
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
  
  println(currentAgent);
  
  for(int i = 0; i < agentNum; i++){
    if (i == 0){
      Agents[i].seek(mouse);
      Agents[i].update();
      Agents[i].display();
    } else {
      Agents[i].seek(Agents[i-1].pos);
      Agents[i].update();
      Agents[i].display();
    }
    
  }
}
