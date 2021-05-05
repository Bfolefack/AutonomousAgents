class Dorp{
  
  PVector pos;
  int age;
  float speed;
  float sense;
  float size;
  float diet;
  float energy;
  
  Dorp(Grid g, float sp_, float se_, float sz_, float d_){
    pos = new PVector(random(chunkScale * gridScale * worldX), random(chunkScale * gridScale * worldY));
    Chunk c = chunkLib.getChunkAt(g, (int)pos.x/gridScale, (int)pos.y/gridScale);
    c.dorps.add(this);
  }
  
  Dorp(Grid g, float x_, float y_, float sp_, float se_, float sz_, float d_){
    pos = new PVector(x_, y_);
    Chunk c = chunkLib.getChunkAt(g, (int)pos.x/gridScale, (int)pos.y/gridScale);
    c.dorps.add(this);
  }
  
  /*
  
  
  */
}
