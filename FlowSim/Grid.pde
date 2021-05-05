class Grid {
  Cell[][] Cells;
  int gridWidth, gridHeight;
  float xPos, yPos;



  Grid(float x_, float y_, int gw_, int gh_) {
    
    Cells = new Cell[gh_][gw_];
    gridWidth = gw_;
    gridHeight = gh_;
    xPos = x_;
    yPos = y_;
    for (int i = 0; i < gridHeight; i++) {
      Cell[] tempCells = new Cell[gridWidth];
      for (int j = 0; j < gridWidth; j++) {
        /*
        tempCells[j] = new Cell(j, i, noise(i * .07, j * .07));
         */
        if (noise(i * .2, j * .2) <= .45) {
          tempCells[j] = new Cell(j, i, 1);
        } else {
          tempCells[j] = new Cell(j, i, .5);
        }
      }
      Cells[i] = tempCells;
    }
    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {   
        Cells[i][j].setArray(Cells);
      }
    }

    for (int i = 0; i < 100; i++) {
      smoothImpassables();
    }
    for (int i = 0; i < 15; i++) {
      nipBuds();
    }
  }

  //*******************************************************************************************************

  PVector getMouseGridspace() {
    int x, y;
    x = int(truMouseX/gridScale);
    y = int(truMouseY/gridScale);
    return new PVector(x, y);
  }

  //*******************************************************************************************************

  void display() {
    for (int i = 0; i < gridWidth; i++) {
      line(xPos + gridScale * i, yPos, xPos + gridScale * i, yPos + gridHeight * gridScale);
    }

    for (int i = 0; i < gridHeight; i++) {
      line(xPos, yPos + gridScale * i, xPos + gridWidth * gridScale, yPos + gridScale * i);
    }

    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {   
        Cells[i][j].display();
      }
    }
    
    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {   
        Cells[i][j].showRadius();
      }
    }
  }

  //*******************************************************************************************************

  void smoothImpassables() {
    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {
        //if (Cells[i][j].impassable) {
        Cells[i][j].smoothEdges();
        //}
      }
    }
  }

  //*******************************************************************************************************

  void nipBuds(){
    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {
        Cells[i][j].nipBuds();
      }
    }
  }

  //*******************************************************************************************************
  
  void newTarget() {
    PVector maus = getMouseGridspace();
    if (maus.x < 0) {
      maus.x = 0;
    } else if (maus.x > gridWidth - 1) {
      maus.x = gridWidth - 1;
    }
    if (maus.y < 0) {
      maus.y = 0;
    } else if (maus.y > gridWidth - 1) {
      maus.y = gridWidth - 1;
    }
    if (!Cells[int(maus.y)][int(maus.x)].impassable) {

      for (int i = 0; i < gridHeight; i++) {
        for (int j = 0; j < gridWidth; j++) {   
          Cells[i][j].clearTarget();
        }
      }

      Cells[int(maus.y)][int(maus.x)].target = true;
      Cells[int(maus.y)][int(maus.x)].type = "open";
      Cells[int(maus.y)][int(maus.x)].cost = 0;
      Cells[int(maus.y)][int(maus.x)].updateNeighbors(Cells);

      for (int i = 0; i < ((gridWidth + gridHeight)/2) * 2; i++) {
        update();
      }
    }
  }

  //*******************************************************************************************************

  void update() {
    
    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {   
        if (Cells[i][j].type == "open") {
          Cells[i][j].updateNeighbors(Cells);
        }
      }
    }

    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {   
        if (!Cells[i][j].impassable) {
          Cells[i][j].getVector();
        }
      }
    }
    
  }
  
  //*******************************************************************************************************
  
  ArrayList<PVector> getDodgeVectors(){
    ArrayList<PVector> e = new ArrayList<PVector>();
    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {   
        if (Cells[i][j].impassable) {
          e.add(new PVector(Cells[i][j].gridPos.x * gridScale + gridScale/2, Cells[i][j].gridPos.y * gridScale + gridScale/2));
        }
      }
    }
    
    return e;
  }
  
  //*******************************************************************************************************
  
  PVector[][] getField(){
    PVector[][] field = new PVector[gridHeight][gridWidth];
    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {   
        field[i][j] = Cells[i][j].vector;
      }
    }
    return field;
  }
  
}
