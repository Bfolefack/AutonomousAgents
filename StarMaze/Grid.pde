class Grid {
  Cell[][] Cells;
  Cell currentCell;
  int gridWidth, gridHeight;
  float xPos, yPos;
  int startX, startY, endX, endY;
  boolean displayed;


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
    currentCell = Cells[int(random(gridHeight))][int(random(gridWidth))];
    currentCell.setPath(Cells);
  }



  void display() {

    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {   
        Cells[i][j].display();
      }
    }

    //stroke(0);

    for (int i = 0; i < gridWidth; i++) {
      line(xPos + gridScale * i, yPos, xPos + gridScale * i, yPos + gridHeight * gridScale);
    }

    for (int i = 0; i < gridHeight; i++) {
      line(xPos, yPos + gridScale * i, xPos + gridWidth * gridScale, yPos + gridScale * i);
    }

    //fill(0);
    //rectMode(CORNERS);
    //rect(-5, -5, 5, gridHeight * gridScale);
    //rect(-5, -5, gridWidth * gridScale, 5);
    //rect(- 5, gridHeight * gridScale - 5, gridWidth * gridScale, gridHeight * gridScale + 5);
    //rect(gridWidth * gridScale - 5, -5, gridWidth * gridScale + 5, gridHeight * gridScale);
    //rectMode(CORNER);
  }

  void update() {

    ArrayList<Cell> openCells = new ArrayList<Cell>();

    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {
        if (Cells[i][j].status == "open") {
          openCells.add(Cells[i][j]);
        }
      }
    }
    if (openCells.size() > 0) {
      int pickedCell = int(random(openCells.size() - 1));
      openCells.get(pickedCell).setPath(Cells);
    } else {
      for (int i = 0; i < gridHeight; i++) {
        for (int j = 0; j < gridWidth; j++) {   
          Cells[i][j].clipEnds(Cells);
        }
      }
    }

    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {   
        Cells[i][j].update();
      }
    }
  }
}
