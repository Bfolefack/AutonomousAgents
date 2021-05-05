class Grid {
  Cell[][] Cells;
  int gridWidth, gridHeight;
  float xPos, yPos;
  ArrayList<Cavern> caverns = new ArrayList<Cavern>();

  Grid(float x_, float y_, int gw_, int gh_) {
    Cells = new Cell[gh_][gw_];
    gridWidth = gw_;
    gridHeight = gh_;
    xPos = x_;
    yPos = y_;

    for (int i = 0; i < gridHeight; i++) {
      Cell[] tempCells = new Cell[gridWidth];
      for (int j = 0; j < gridWidth; j++) {
        tempCells[j] = new Cell(j, i);
      }
      Cells[i] = tempCells;
    }

    smoothCavern();


    while (true) {
      caverns();
      if (caverns.size() <= 1) {
        break;
      }
      resetGrid();
    }
    
    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {   
        Cells[i][j].setArray(Cells);
      }
    }
  }

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
    //for(Cavern c: caverns){
    //  c.display();
    //}
  }

  PVector getMouseGridspace() {
    int x, y;
    x = int(truMouseX/gridScale);
    y = int(truMouseY/gridScale);
    return new PVector(x, y);
  }

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
    if (!Cells[int(maus.y)][int(maus.x)].filled) {

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
        if (!Cells[i][j].filled) {
          Cells[i][j].getVector();
        }
      }
    }
  }

  ArrayList<PVector> getDodgeVectors() {
    ArrayList<PVector> e = new ArrayList<PVector>();
    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {   
        if (Cells[i][j].filled) {
          e.add(new PVector(Cells[i][j].gridPos.x * gridScale + gridScale/2, Cells[i][j].gridPos.y * gridScale + gridScale/2));
        }
      }
    }
  
    return e;
  }
  
  PVector[][] getField() {
      PVector[][] field = new PVector[gridHeight][gridWidth];
      for (int i = 0; i < gridHeight; i++) {
        for (int j = 0; j < gridWidth; j++) {   
          field[i][j] = Cells[i][j].vector;
        }
      }
      return field;
    }
  




  //******************************************************************************************************

  void smoothCavern() {
    for (int k = 0; k < 40; k++) {
      for (int i = 0; i < gridHeight; i++) {
        for (int j = 0; j < gridWidth; j++) {   
          Cells[i][j].smoothCavern(Cells);
        }
      }
    }

    for (int k = 0; k < 25; k++) {
      for (int i = 0; i < gridHeight; i++) {
        for (int j = 0; j < gridWidth; j++) {   
          Cells[i][j].nipBuds(Cells);
        }
      }
    }
  }

  boolean createCaverns() {
    Cavern c = new Cavern(Cells);
    if (c.cavernAvailible) {
      caverns.add(c);
    }
    return c.cavernAvailible;
  }

  void caverns() {

    while (true) {
      if (!createCaverns()) {
        break;
      }
    }

    if (caverns.size() <= 1) {
      return;
    }

    ArrayList<Cavern> cavernsToBeRemoved = new ArrayList<Cavern>();

    for (Cavern c : caverns) {
      if (c.myCells.size() < 30) {
        c.fillIn();
        cavernsToBeRemoved.add(c);
      }
    }

    for (Cavern c : cavernsToBeRemoved) {
      caverns.remove(c);
    }
    cavernsToBeRemoved.clear();

    for (Cavern c : caverns) {
      c.getNearestLine(Cells);
    } 
    ArrayList<Cell> erodingCells = new ArrayList<Cell>();
    for (Cavern c : caverns) {
      ArrayList<Cell> tempCells = c.getErosionCells(Cells);
      for (Cell cl : tempCells) {
        erodingCells.add(cl);
      }
    }
    float erosionFactor = 1;
    for (int i = 0; i < 15; i++) {

      ArrayList<Cell> tempCells = new ArrayList<Cell>();
      for (Cell c : erodingCells) {
        c.erode(erosionFactor, Cells, tempCells);
      }
      erodingCells.clear();
      for (Cell c : tempCells) {
        erodingCells.add(c);
      }
      if (i < 1) {
        erosionFactor = 1;
      } else {
        erosionFactor *= .75;
      }
    }

    smoothCavern();
  }

  void resetGrid() {
    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {   
        Cells[i][j] = new Cell(int(Cells[i][j].gridPos.x), int(Cells[i][j].gridPos.y), Cells[i][j].filled);
      }
    }
    caverns = new ArrayList<Cavern>();
  }
}
