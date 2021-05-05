class Grid {
  Cell[][] Cells;
  int gridWidth, gridHeight;
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
        tempCells[j] = new Cell(j, i, false);
      }
      Cells[i] = tempCells;
    }
    
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
  }
  
  void update() {
    for(int i = 0; i < gridHeight; i++){
      for(int j = 0; j < gridWidth; j++){   
          Cells[i][j].update(Cells);
      }
    }
  }
  
  void iterate(){
    for(int i = 0; i < gridHeight; i++){
      for(int j = 0; j < gridWidth; j++){   
          Cells[i][j].iterate();
      }
    }
  }
}
