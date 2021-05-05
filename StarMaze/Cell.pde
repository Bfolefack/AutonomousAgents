class Cell {
  String status = "wall";
  PVector gridPos;
  int borders;
  boolean filled;

  Cell(int x_, int y_) {
    gridPos = new PVector(x_, y_);
  }

  void display() {

    if (status == "wall") {
      fill(0);
      rect(gridPos.x * gridScale - .01, gridPos.y * gridScale - .01, gridScale + .03, gridScale + .03);
    } else if (status == "path") {
      fill(255);
      rect(gridPos.x * gridScale - .01, gridPos.y * gridScale - .01, gridScale + .03, gridScale + .03);
    } else if (status == "open") {
      fill(0, 0, 255);
      rect(gridPos.x * gridScale - .01, gridPos.y * gridScale - .01, gridScale + .03, gridScale + .03);
    } else {
      fill(255, 0, 0);
      rect(gridPos.x * gridScale - .01, gridPos.y * gridScale - .01, gridScale + .03, gridScale + .03);
    }
  }

  PVector getMouseGridspace() {
    int x, y;
    x = int(mouseX/gridScale);
    y = int(mouseY/gridScale);
    return new PVector(x, y);
  }

  boolean exists(int x, int y, Cell[][] cells) {
    boolean ifx, ify;
    ifx = true;
    ify = true;

    if (x < 0) {
      if (x + gridPos.x < 0) {
        ifx = false;
      }
    }
    if (x > 0) {
      if (x + gridPos.x > cells[0].length - 1) {
        ifx = false;
      }
    }

    if (y < 0) {
      if (y + gridPos.y < 0) {
        ify = false;
      }
    }
    if (y > 0) {
      if (y + gridPos.y > cells.length - 1) {
        ify = false;
      }
    }
    return ifx && ify;
  }

  void update() {
    PVector maus = getMouseGridspace();
    if (status == "wall") {
      filled = true;
    } else {
      filled = false;
    }
  }

  void setPath(Cell[][] cells) {
    if (status == "open") {
      ArrayList<PVector> pathCells = new ArrayList<PVector>();
      if (exists(0, -2, cells)) {
        if ( cells[int(gridPos.y) - 2][int(gridPos.x)].status == "path") {
          pathCells.add(new PVector(-1, 0));
        }
      }

      if (exists(0, 2, cells)) {
        if ( cells[int(gridPos.y) + 2][int(gridPos.x)].status == "path") {
          pathCells.add(new PVector(1, 0));
        }
      }

      if (exists(2, 0, cells)) {
        if ( cells[int(gridPos.y)][int(gridPos.x) + 2].status == "path") {
          pathCells.add(new PVector(0, 1));
        }
      }

      if (exists(-2, 0, cells)) {
        if ( cells[int(gridPos.y)][int(gridPos.x) - 2].status == "path") {
          pathCells.add(new PVector(0, -1));
        }
      }

      int pickedVector = int(random(pathCells.size()));
      PVector vector = pathCells.get(pickedVector);
      cells[int(gridPos.y + vector.x)][int(gridPos.x + vector.y)].status = "path";
    }
    status = "path";
    if (exists(0, -2, cells)) {
      if ( cells[int(gridPos.y) - 2][int(gridPos.x)].status == "wall") {
        cells[int(gridPos.y) - 2][int(gridPos.x)].status = "open";
      }
    }

    if (exists(0, 2, cells)) {
      if ( cells[int(gridPos.y) + 2][int(gridPos.x)].status == "wall") {
        cells[int(gridPos.y) + 2][int(gridPos.x)].status = "open";
      }
    }

    if (exists(2, 0, cells)) {
      if ( cells[int(gridPos.y)][int(gridPos.x) + 2].status == "wall") {
        cells[int(gridPos.y)][int(gridPos.x) + 2].status = "open";
      }
    }

    if (exists(-2, 0, cells)) {
      if ( cells[int(gridPos.y)][int(gridPos.x) - 2].status == "wall") {
        cells[int(gridPos.y)][int(gridPos.x) - 2].status = "open";
      }
    }
  }
  void clipEnds(Cell[][] cells) {
    int wallNum = 0;
    if (status == "path") {
      ArrayList<PVector> pathCells = new ArrayList<PVector>();
      if (exists(0, -1, cells)) {
        if ( cells[int(gridPos.y) - 1][int(gridPos.x)].status == "wall") {
          pathCells.add(new PVector(-1, 0));
          wallNum++;
        }
      }

      if (exists(0, 1, cells)) {
        if ( cells[int(gridPos.y) + 1][int(gridPos.x)].status == "wall") {
          pathCells.add(new PVector(1, 0));
          wallNum++;
        }
      }

      if (exists(1, 0, cells)) {
        if ( cells[int(gridPos.y)][int(gridPos.x) + 1].status == "wall") {
          pathCells.add(new PVector(0, 1));
          wallNum++;
        }
      }

      if (exists(-1, 0, cells)) {
        if ( cells[int(gridPos.y)][int(gridPos.x) - 1].status == "wall") {
          pathCells.add(new PVector(0, -1));
          wallNum++;
        }
      }
      if (wallNum == 3) {
        int pickedVector = int(random(pathCells.size()));
        PVector vector = pathCells.get(pickedVector);
        cells[int(gridPos.y + vector.x)][int(gridPos.x + vector.y)].status = "path";
      }
    } else if (status == "wall") {
      if (exists(0, -1, cells)) {
        if ( cells[int(gridPos.y) - 1][int(gridPos.x)].status == "path") {
          wallNum++;
        }
      }

      if (exists(0, 1, cells)) {
        if ( cells[int(gridPos.y) + 1][int(gridPos.x)].status == "path") {
          wallNum++;
        }
      }

      if (exists(1, 0, cells)) {
        if ( cells[int(gridPos.y)][int(gridPos.x) + 1].status == "path") {
          wallNum++;
        }
      }

      if (exists(-1, 0, cells)) {
        if ( cells[int(gridPos.y)][int(gridPos.x) - 1].status == "path") {
          wallNum++;
        }
      }
      if (wallNum == 4) {
        status = "path";
      }
    }
  }
  
  //***************************************************************************************************************************************************  


  void setArray(Cell[][] c_) {
    cells = c_;
  }


  //***************************************************************************************************************************************************


  void display() {
    if (gridType == "start" ) {
      start = true;
    }
    if (start) {
      gridType = "start";
    }
    if (gridType == "start" || gridType == "end") {
      col = new PVector(0, 100, 255); 
      displayMode = 2;
    }

    if (gridType == "path") {
      col = new PVector(0, 200, 255);
      displayMode = 2;
    }

    if (gridType == "open") {
      col = new PVector(0, 255, 50); 
      displayMode = 2;
    }

    if (gridType == "closed") {
      col = new PVector(255, 50, 0); 
      displayMode = 2;
    }

    if (gridType == "blocked") {
      col = new PVector(0, 0, 0); 
      displayMode = 2;
    }

    if (touchingMouse == true) {
      col = new PVector(0, 0, 0);
    }

    if (displayMode == 2) {

      fill(col.x, col.y, col.z);
      rectMode(CORNERS);
      rect(xCoord * gridScale, yCoord * gridScale, xCoord * gridScale + gridScale, yCoord * gridScale + gridScale);
    }

    ellipseMode(CENTER);
    fill(0);
    if (gridScale/3 >= 1) {
      circle(xCoord * gridScale + gridScale/2, yCoord * gridScale + gridScale/2, gridScale/3);
    } else {
      circle(xCoord * gridScale + gridScale/2, yCoord * gridScale + gridScale/2, 1);
    }



    if (gridType == "open" || gridType == "closed" || gridType == "path") {
      /*
        textSize(15);
        text(g, xCoord * gridScale + gridScale/5, yCoord * gridScale + gridScale/4);
        text(h, xCoord * gridScale + gridScale/1.5, yCoord * gridScale + gridScale/4);
        */
      
      
    }



    touchingMouse = false;
    displayMode = 1;
  }


  //***************************************************************************************************************************************************


  boolean exists(int y, int x) {
    boolean ifx, ify;
    ifx = true;
    ify = true;

    if (x < 0) {
      if (x + xCoord < 0) {
        ifx = false;
      }
    }
    if (x > 0) {

      if (x + xCoord > cells[0].length - 1) {
        ifx = false;
      }
    }

    if (y < 0) {
      if (y + yCoord < 0) {
        ify = false;
      }
    }
    if (y > 0) {
      if (y + yCoord > cells.length - 1) {
        ify = false;
      }
    }

    return ifx && ify;
  }


  //***************************************************************************************************************************************************


  void setGnH(int g_, Cell cell) {
    g = g_;
    h = int(dist(xCoord * gridScale + gridScale/2, yCoord * gridScale + gridScale/2, cell.xCoord * gridScale + gridScale/2, cell.yCoord * gridScale + gridScale/2)/(gridScale/10));
  }


  //***************************************************************************************************************************************************


  void startRun(Cell start, Cell end) {
    if (gridType == "start") {
      if (startRun) {
        g = 0;
        h = int(dist(xCoord * gridScale + gridScale/2, yCoord * gridScale + gridScale/2, end.xCoord * gridScale + gridScale/2, end.yCoord * gridScale + gridScale/2)/(gridScale/10));
        if (exists(1, 0)) {
          if (cells[yCoord + 1][xCoord].gridType == "empty") {
            cells[yCoord + 1][xCoord].gridType = "open";
            cells[yCoord + 1][xCoord].setGnH(g + 10, end);
            cells[yCoord + 1][xCoord].gSource = cells[yCoord][xCoord];
          }
        }

        if (exists(-1, 0)) {
          if (cells[yCoord - 1][xCoord].gridType == "empty") {
            cells[yCoord - 1][xCoord].gridType = "open";
            cells[yCoord - 1][xCoord].setGnH(g + 10, end);
            cells[yCoord - 1][xCoord].gSource = cells[yCoord][xCoord];
          }
        }

        if (exists(0, 1)) {
          if (cells[yCoord][xCoord + 1].gridType == "empty") {
            cells[yCoord][xCoord + 1].gridType = "open";
            cells[yCoord][xCoord + 1].setGnH(g + 10, end);
            cells[yCoord][xCoord + 1].gSource = cells[yCoord][xCoord];
          }
        }

        if (exists(0, -1)) {
          if (cells[yCoord][xCoord - 1].gridType == "empty") {
            cells[yCoord][xCoord - 1].gridType = "open";
            cells[yCoord][xCoord - 1].setGnH(g + 10, end);
            cells[yCoord][xCoord - 1].gSource = cells[yCoord][xCoord];
          }
        }
        if (exists(1, 1)) {
      if (cells[yCoord + 1][xCoord + 1].gridType == "empty") {
        cells[yCoord + 1][xCoord + 1].gridType = "open";
        cells[yCoord + 1][xCoord + 1].setGnH(g + 14, end);
        cells[yCoord + 1][xCoord + 1].gSource = cells[yCoord][xCoord + 1];
      }
    }

    if (exists(-1, 1)) {
      if (cells[yCoord - 1][xCoord + 1].gridType == "empty") {
        cells[yCoord - 1][xCoord + 1].gridType = "open";
        cells[yCoord - 1][xCoord + 1].setGnH(g + 14, end);
        cells[yCoord - 1][xCoord + 1].gSource = cells[yCoord][xCoord + 1];
      }
    }

    if (exists(1, -1)) {
      if (cells[yCoord + 1][xCoord - 1].gridType == "empty") {
        cells[yCoord + 1][xCoord - 1].gridType = "open";
        cells[yCoord + 1][xCoord - 1].setGnH(g + 14, end);
        cells[yCoord + 1][xCoord - 1].gSource = cells[yCoord + 1][xCoord];
      }
    }

    if (exists(-1, -1)) {
      if (cells[yCoord - 1][xCoord - 1].gridType == "empty") {
        cells[yCoord - 1][xCoord - 1].gridType = "open";
        cells[yCoord - 1][xCoord - 1].setGnH(g + 14, end);
        cells[yCoord - 1][xCoord - 1].gSource = cells[yCoord - 1][xCoord];
      }
    }
        startRun = false;
      }
    }
  }


  //***************************************************************************************************************************************************


  void infectBorders(Cell start, Cell end) {
    if (exists(1, 0)) {
      if (cells[yCoord + 1][xCoord].gridType == "empty") {
        cells[yCoord + 1][xCoord].gridType = "open";
        cells[yCoord + 1][xCoord].setGnH(g + 10, end);
        cells[yCoord + 1][xCoord].gSource = cells[yCoord][xCoord];
      }
      if (cells[yCoord + 1][xCoord].gridType == "open" || cells[yCoord + 1][xCoord].gridType == "closed") {
        if (g + 10 < cells[yCoord + 1][xCoord].g) {
          cells[yCoord + 1][xCoord].g = g + 10;
          cells[yCoord + 1][xCoord].gSource = cells[yCoord][xCoord];
        }
      }
      if (cells[yCoord + 1][xCoord].gridType == "end") {
        gridType = "path";
        pathFound = true;
      }
    }

    if (exists(-1, 0)) {
      if (cells[yCoord - 1][xCoord].gridType == "empty") {
        cells[yCoord - 1][xCoord].gridType = "open";
        cells[yCoord - 1][xCoord].setGnH(g + 10, end);
        cells[yCoord - 1][xCoord].gSource = cells[yCoord][xCoord];
      }
      if (cells[yCoord - 1][xCoord].gridType == "open" || cells[yCoord - 1][xCoord].gridType == "closed") {
        if (g + 10 < cells[yCoord - 1][xCoord].g) {
          cells[yCoord - 1][xCoord].g = g + 10;
          cells[yCoord - 1][xCoord].gSource = cells[yCoord][xCoord];
        }
      }
      if (cells[yCoord - 1][xCoord].gridType == "end") {
        gridType = "path";
        pathFound = true;
      }
    }

    if (exists(0, 1)) {
      if (cells[yCoord][xCoord + 1].gridType == "empty") {
        cells[yCoord][xCoord + 1].gridType = "open";
        cells[yCoord][xCoord + 1].setGnH(g + 10, end);
        cells[yCoord][xCoord + 1].gSource = cells[yCoord][xCoord];
      }
      if (cells[yCoord][xCoord + 1].gridType == "open" || cells[yCoord][xCoord + 1].gridType == "closed") {
        if (g + 10 < cells[yCoord][xCoord + 1].g) {
          cells[yCoord][xCoord + 1].g = g + 10;
          cells[yCoord][xCoord + 1].gSource = cells[yCoord][xCoord];
        }
      }
      if (cells[yCoord][xCoord + 1].gridType == "end") {
        gridType = "path";
        pathFound = true;
      }
    }

    if (exists(0, -1)) {
      if (cells[yCoord][xCoord - 1].gridType == "empty") {
        cells[yCoord][xCoord - 1].gridType = "open";
        cells[yCoord][xCoord - 1].setGnH(g + 10, end);
        cells[yCoord][xCoord - 1].gSource = cells[yCoord][xCoord];
      }
      if (cells[yCoord][xCoord - 1].gridType == "open" || cells[yCoord][xCoord - 1].gridType == "closed") {
        if (g + 10 < cells[yCoord][xCoord - 1].g) {
          cells[yCoord][xCoord - 1].g = g + 10;
          cells[yCoord][xCoord - 1].gSource = cells[yCoord][xCoord];
        }
      }
      if (cells[yCoord][xCoord - 1].gridType == "end") {
        gridType = "path";
        pathFound = true;
      }
    }
    
    
    if (exists(1, 1)) {
      if (cells[yCoord + 1][xCoord + 1].gridType == "empty") {
        cells[yCoord + 1][xCoord + 1].gridType = "open";
        cells[yCoord + 1][xCoord + 1].setGnH(g + 14, end);
        cells[yCoord + 1][xCoord + 1].gSource = cells[yCoord][xCoord];
      }
      if (cells[yCoord + 1][xCoord + 1].gridType == "open" || cells[yCoord + 1][xCoord + 1].gridType == "closed") {
        if (g + 14 < cells[yCoord + 1][xCoord + 1].g) {
          cells[yCoord + 1][xCoord + 1].g = g + 14;
          cells[yCoord + 1][xCoord + 1].gSource = cells[yCoord][xCoord];
        }
      }
      if (cells[yCoord + 1][xCoord + 1].gridType == "end") {
        gridType = "path";
        pathFound = true;
      }
    }

    if (exists(-1, 1)) {
      if (cells[yCoord - 1][xCoord + 1].gridType == "empty") {
        cells[yCoord - 1][xCoord + 1].gridType = "open";
        cells[yCoord - 1][xCoord + 1].setGnH(g + 14, end);
        cells[yCoord - 1][xCoord + 1].gSource = cells[yCoord][xCoord];
      }
      if (cells[yCoord - 1][xCoord + 1].gridType == "open" || cells[yCoord - 1][xCoord + 1].gridType == "closed") {
        if (g + 14 < cells[yCoord - 1][xCoord + 1].g) {
          cells[yCoord - 1][xCoord + 1].g = g + 14;
          cells[yCoord - 1][xCoord + 1].gSource = cells[yCoord][xCoord];
        }
      }
      if (cells[yCoord - 1][xCoord + 1].gridType == "end") {
        gridType = "path";
        pathFound = true;
      }
    }

    if (exists(1, -1)) {
      if (cells[yCoord + 1][xCoord - 1].gridType == "empty") {
        cells[yCoord + 1][xCoord - 1].gridType = "open";
        cells[yCoord + 1][xCoord - 1].setGnH(g + 14, end);
        cells[yCoord + 1][xCoord - 1].gSource = cells[yCoord][xCoord];
      }
      if (cells[yCoord + 1][xCoord - 1].gridType == "open" || cells[yCoord + 1][xCoord - 1].gridType == "closed") {
        if (g + 14 < cells[yCoord + 1][xCoord - 1].g) {
          cells[yCoord + 1][xCoord - 1].g = g + 14;
          cells[yCoord + 1][xCoord - 1].gSource = cells[yCoord][xCoord];
        }
      }
      if (cells[yCoord + 1][xCoord - 1].gridType == "end") {
        gridType = "path";
        pathFound = true;
      }
    }

    if (exists(-1, -1)) {
      if (cells[yCoord - 1][xCoord - 1].gridType == "empty") {
        cells[yCoord - 1][xCoord - 1].gridType = "open";
        cells[yCoord - 1][xCoord - 1].setGnH(g + 14, end);
        cells[yCoord - 1][xCoord - 1].gSource = cells[yCoord][xCoord];
      }
      if (cells[yCoord - 1][xCoord - 1].gridType == "open" || cells[yCoord - 1][xCoord - 1].gridType == "closed") {
        if (g + 14 < cells[yCoord - 1][xCoord - 1].g) {
          cells[yCoord - 1][xCoord - 1].g = g + 14;
          cells[yCoord - 1][xCoord - 1].gSource = cells[yCoord][xCoord];
        }
      }
      if (cells[yCoord - 1][xCoord - 1].gridType == "end") {
        gridType = "path";
        pathFound = true;
      }
    }

    if (gridType == "open") {
      gridType = "closed";
    }
  }
}
