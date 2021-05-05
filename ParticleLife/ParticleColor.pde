class ParticleColor{
  PVector particleColor;
  String pColor;
  float[] forces;
  int index;
  float[] minDistWeight;
  float[] maxDistWeight;
  float maxSpeed;
  ParticleColor(PVector _p){
    particleColor = _p;
    forces = new float[colorNum];
    minDistWeight = new float[colorNum];
    maxDistWeight = new float[colorNum];
    maxSpeed = 5;
  }
  /*
  ParticleColor(PVector _p, String _pc){
    pColor = _pc;
    particleColor = _p;
    forces = new float[colorNum];
  }
  */
  void setupParticle(int in){
    for(int i = 0; i < colorNum; i++){
      forces[i] = random(-1, 1);
      minDistWeight[i] = random(15, 40);
      maxDistWeight[i] = random(20, 70);
    }
    index = in;
  }
  
  float getForce(int i){
    return forces[i];
  }
  float getMinDistWeight(int i){
    return minDistWeight[i];
  }
  float getMaxDistWeight(int i){
    return maxDistWeight[i];
  }
}
