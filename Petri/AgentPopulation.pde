class AgentPopulation {
  int startingSize;
  Agent[] agents;
  AgentPopulation(int s_){
    currentAgent = 0;
    startingSize = s_;
    agents = new Agent[200];
    for(int i = 0; i < startingSize; i++){
      if (currentAgent < 100){
        agents[currentAgent] = new Agent(width/2 + random(-200, 200), height/2 + random(-200, 200), 2, .1, 100);
        currentAgent++;
      } else {
        currentAgent = 0;
        agents[currentAgent] = new Agent(width/2 + random(-200, 200), height/2 + random(-200, 200), 2, .1, 100);
      }
    }
  }
  
  void seekNearestPellet(PelletPopulation p){
    for(int i = 0; i < currentAgent ; i++){
      agents[i].seekNearestPellet(p);
    }
  }
  
  void display(){
    for(int i = 0; i < currentAgent ; i++){
      if(agents[i].alive){
        agents[i].display();
      }
    }
  }
  
  void update(){
    for(int i = 0; i < currentAgent ; i++){
      if(agents[i].alive){
        agents[i].update();
      }
    }
  }
  
  void calculate(){
    for(int i = 0; i < currentAgent ; i++){
      if(agents[i].alive){
        agents[i].calculate(agents);
      }
    }
  }
}
