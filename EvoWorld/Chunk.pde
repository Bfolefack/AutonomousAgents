class Chunk {
  
  PVector chunkPos;
  Cell[][] chunkCells;
  boolean selected;
  ArrayList<Dorp> dorps;
  
  Chunk(float x_, float y_) {
    chunkCells = new Cell[chunkScale][chunkScale];
    chunkPos = new PVector(x_, y_);
    for (int i = 0; i < chunkScale; i++) {
      Cell[] tempCells = new Cell[chunkScale];
      for (int j = 0; j < chunkScale; j++) {
        tempCells[j] = new Cell(j, i, noise((j + int(chunkPos.x * chunkScale)) * noiseScale, (i + int(chunkPos.y * chunkScale)) * noiseScale));
      }
      chunkCells[i] = tempCells;
    }
    dorps = new ArrayList<Dorp>();
  }
  void display() {
    pushMatrix();
    translate(chunkPos.x * chunkScale * gridScale, chunkPos.y * chunkScale * gridScale);
    for (int i = 0; i < chunkScale; i++) {
      for (int j = 0; j < chunkScale; j++) {
        chunkCells[i][j].display();
      }
    }
    
    if(showChunkBorders){
      fill(0);
      if (selected){
        fill(255, 0, 0);
      }
      rectMode(CORNERS);
      rect(-5, -5, 5, chunkScale * gridScale);
      rect(-5, -5, chunkScale * gridScale, 5);
      rect(- 5, chunkScale * gridScale - 5, chunkScale * gridScale, chunkScale * gridScale + 5);
      rect(chunkScale * gridScale - 5, -5, chunkScale * gridScale + 5, chunkScale * gridScale);
      rectMode(CORNER);
    }
    
    popMatrix();
    selected = false;
    
    //stroke(0);

    //for(int i = 0; i < chunkScale; i++){
    //  line(chunkPos.x + gridScale * i, chunkPos.y, chunkPos.x + gridScale * i, chunkPos.y + chunkScale * gridScale);
    //}

    //for(int i = 0; i < chunkScale; i++){
    //  line(chunkPos.x, chunkPos.y + gridScale * i, chunkPos.x + chunkScale * gridScale, chunkPos.y + gridScale * i);
    //}
  }
}
