class Grid {
  Cell[][] Cells;
  int gridWidth, gridHeight, counter;
  float xPos, yPos;
  
  Grid(float x_, float y_, int gw_, int gh_){
    Cells = new Cell[gh_][gw_];
    gridWidth = gw_;
    gridHeight = gh_;
    xPos = x_;
    yPos = y_;
    for(int i = 0; i < gridHeight; i++){
      Cell[] tempCells = new Cell[gridWidth];
      for(int j = 0; j < gridWidth; j++){
        tempCells[j] = new Cell(j, i, noise(j * noiseScale, i * noiseScale));
        counter++;
      }
      Cells[i] = tempCells;
    }
    println(counter);
  }
  
  
  
  void display(){
    
    for(int i = 0; i < gridHeight; i++){
      for(int j = 0; j < gridWidth; j++){   
          Cells[i][j].display();
      }
    }
    
    //stroke(0);
    
    for(int i = 0; i < gridWidth; i++){
      line(xPos + gridScale * i, yPos, xPos + gridScale * i, yPos + gridHeight * gridScale);
    }
    
    for(int i = 0; i < gridHeight; i++){
      line(xPos, yPos + gridScale * i, xPos + gridWidth * gridScale, yPos + gridScale * i);
    }
    
    rectMode(CORNERS);
    fill(0);
    rect(-5, -5, 5, gridHeight * gridScale);
    rect(-5, -5, gridWidth * gridScale, 5);
    rect(- 5, gridHeight * gridScale - 5, gridWidth * gridScale, gridHeight * gridScale + 5);
    rect(gridWidth * gridScale - 5, -5, gridWidth * gridScale + 5, gridHeight * gridScale);
    rectMode(CORNER);
    
  }
  
  
  void edgeSmoothing() {
     for(int i = 0; i < gridHeight; i++){
      for(int j = 0; j < gridWidth; j++){   
          Cells[i][j].smoothEdges(Cells);
      }
    }
    for(int i = 0; i < gridHeight; i++){
      for(int j = 0; j < gridWidth; j++){   
          Cells[i][j].type = Cells[i][j].nextType;
      }
    }
  }
}
