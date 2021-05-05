class Grid {

  int gridWidth;
  int gridHeight;
  int startX, startY, endX, endY;
  boolean displayed;
  GridCell[][] gridCells;

  Grid(float gridScale, int x2_, int y2_, int x3_, int y3_) {
    displayed = false;
    gridWidth = int(width/gridScale);
    gridHeight = int(height/gridScale);
    gridCells = new GridCell[gridHeight][gridWidth];
    GridCell[] tempArray;
    for ( int i = 0; i < gridHeight; i++ ) {
      tempArray = new GridCell[gridWidth];
      for ( int j = 0; j < gridWidth; j++) {
        tempArray[j] = new GridCell(j, i);
      }
      gridCells[i] = tempArray;
    }
    startX = x2_;
    startY = y2_;
    endX = x3_;
    endY = y3_;

    for ( int i = 0; i < gridHeight; i++ ) {
      for ( int j = 0; j < gridWidth; j++ ) {
        gridCells[i][j].setArray(gridCells);
      }
    }

    gridCells[startY][startX].gridType = "start";
    gridCells[endY][endX].gridType = "end";

    gridCells[startX][startY].startRun(gridCells[startY][startX], gridCells[endY][endX]);
  }

  void display() {
    for ( int i = 0; i < gridHeight; i++ ) {
      for ( int j = 0; j < gridWidth; j++ ) {
        gridCells[i][j].display();
        displayed = true;
      }
    }
  }

  PVector smallestF() {
    GridCell smallestCell = new GridCell(-100, -100);
    int gh = INF;

    for ( int i = 0; i < gridHeight; i++ ) {
      for ( int j = 0; j < gridWidth; j++ ) {
        if (gridCells[i][j].gridType == "open") {
          if (gridCells[i][j].g + gridCells[i][j].h < gh) {
            gh = gridCells[i][j].g + gridCells[i][j].h;
            smallestCell = gridCells[i][j];
          }
        }
      }
    }

    return new PVector(smallestCell.xCoord, smallestCell.yCoord);
  }

  void update() {
    if (displayed) {
      if (pathFound == false) {
        if (smallestF().x > -1) {
          GridCell tinyCell;
          tinyCell = gridCells[int(smallestF().y)][int(smallestF().x)];
          tinyCell.infectBorders(gridCells[startY][startX], gridCells[endY][endX]);
        }
      } else {
        pathfinder();
      }
    }
  }
  
  void pathfinder(){
    for ( int i = 0; i < gridHeight; i++ ) {
      for ( int j = 0; j < gridWidth; j++ ) {
        if(gridCells[i][j].gridType == "path"){
          gridCells[i][j].gSource.gridType = "path";
        }
      }
    }
  }

  PVector getMouseGridspace() {
    return new PVector(int(mouseX/gridScale), int(mouseY/gridScale));
  }

  void highlightGridspace () {
    PVector mouse = getMouseGridspace();

    if (mouse.x < 0) {
      mouse.x = 0;
    }

    if (mouse.y < 0) {
      mouse.y = 0;
    }
    
    if (mouse.x > gridWidth - 1) {
      mouse.x = gridWidth - 1;
    }

    if (mouse.y > gridHeight - 1) {
      mouse.y = gridHeight - 1;
    }

    gridCells[int(mouse.y)][int(mouse.x)].displayMode = 2;
    gridCells[int(mouse.y)][int(mouse.x)].touchingMouse = true;
    if (mousePressed && mouseButton == LEFT) {
      gridCells[int(mouse.y)][int(mouse.x)].gridType = "blocked";
    }
  }
}
