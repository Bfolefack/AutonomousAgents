class Cell {
  boolean filled;
  String state = "none";
  String erosionState = "none";
  PVector gridPos, fillColor, vector;
  int borders, cost;
  boolean erode;
  String type;
  boolean target;
  int leastIndex;
  Cell[][] cells;

  Cell(int x_, int y_, boolean f_) {
    gridPos = new PVector(x_, y_);
    filled = f_;
    target = false;
    vector = new PVector(0, 0);
  }

  Cell(int x_, int y_) {
    gridPos = new PVector(x_, y_);
    if (random(0, 1) < .4) {
      filled = true;
    } else {
      filled = false;
    }
    target = false;
    vector = new PVector(0, 0);
  }

  Cell() {
    gridPos = new PVector(-1, -1);
    cost = 65535;
    filled = true;
    target = false;
    //vector = new PVector(0, 0);
  }

  void display() {
    noStroke();
    //noStroke();
    //if (filled) {
    //} else if (state == "open") {
    //  fill(0, 255, 0);
    //  rect(gridPos.x * gridScale, gridPos.y * gridScale, gridScale, gridScale);
    //} else if (state == "closed") {
    //  fill(fillColor.x, fillColor.y, fillColor.z);
    //  rect(gridPos.x * gridScale, gridPos.y * gridScale, gridScale, gridScale);
    //}
    //switch(state) {
    //case "open":
    //  fill(0, 255, 0);
    //  rect(gridPos.x * gridScale, gridPos.y * gridScale, gridScale, gridScale);
    //  break;
    //case "closed":
    //  fill(fillColor.x, fillColor.y, fillColor.z);
    //  rect(gridPos.x * gridScale, gridPos.y * gridScale, gridScale, gridScale);
    //  break;
    //default:
    //  if (filled) {
    //    fill(0);
    //    rect(gridPos.x * gridScale, gridPos.y * gridScale, gridScale, gridScale);
    //    break;
    //  }
    //}
    //fill(0, 255, 0);
    //textSize(10);
    //text(borders, gridPos.x * gridScale + gridScale/2, gridPos.y * gridScale + gridScale/2);
    PVector maus = getMouseGridspace();
    //println(gridPos); 
    //if (mouseInside()) {
    //  println(vector);
    //}

    if (filled /* || cost > 65534*/) {
      fill(50, 25, 0);
    } else if (target) {
      fill(200, 0, 255);
    } else if (type == "open") {
      fill(0, 255, 0);
    } else if (type == "closed") {
      fill(150, 75, 0);
    } else {
      fill(100, 50, 0);
    }
    rect(gridPos.x * gridScale, gridPos.y * gridScale, gridScale, gridScale);
    fill(255);
    textSize(gridScale/5);
    
    fill(0);
    rect(gridPos.x * gridScale + gridScale/2 - 1, gridPos.y * gridScale + gridScale/2 - 1, 2, 2);
    if (cost < 65535) {
      text(cost, gridPos.x * gridScale + 10, gridPos.y * gridScale + 10);
    } else {
      text("MAX", gridPos.x * gridScale + gridScale/5, gridPos.y * gridScale + gridScale/5);
    }
    stroke(0);
    line(gridPos.x * gridScale + gridScale/2, gridPos.y * gridScale + gridScale/2, gridPos.x * gridScale + gridScale/2 + vector.x * gridScale, gridPos.y * gridScale + gridScale/2 + vector.y * gridScale);
  }

  void setArray(Cell[][] c_) {
    cells = c_;
  }

  void updateNeighbors(Cell[][] cells) {


    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if ((abs(i) + abs(j) < 2) && !( i ==0 && j == 0)) {

          if (exists(i, j, cells)) {
            if (!cells[int(gridPos.y) + j][int(gridPos.x) + i].filled && (cost + 1) < cells[int(gridPos.y) + j][int(gridPos.x) + i].cost) {
              cells[int(gridPos.y) + j][int(gridPos.x) + i].cost = cost + 1;
              cells[int(gridPos.y) + j][int(gridPos.x) + i].type = "open";
            }
          }
        }
      }
    }

    type = "closed";
  }

  void getVector() {
    ArrayList<Cell> ops = new ArrayList<Cell>();
    PVector leastVector = new PVector(0, 0);
    int leastCost = 65535;
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (exists(i, j, cells)) {
          if (cells[int(gridPos.y) + j][int(gridPos.x) + i].cost < leastCost) {
            leastCost = cells[int(gridPos.y) + j][int(gridPos.x) + i].cost;
            leastVector = new PVector(i, j);
          }
        }
      }
    }

    vector = leastVector;
    if (target) {
      vector = new PVector(0, 0);
    }

    //vector = PVector.sub(least.gridPos, gridPos);
    vector.normalize();
  }

  void clearTarget() {
    target = false;
    type = "";
    cost = 65535;
  }

  void showRadius() {

    if (showRadii && filled) {
      fill(255, 0, 0, 50);
      ellipse(gridPos.x * gridScale + gridScale/2, gridPos.y * gridScale + gridScale/2, gridScale * sqrt(2) + 5, gridScale * sqrt(2) + 5);
    }
  }

  //*************************************************************************************************************************************************************************8

  PVector getMouseGridspace() {
    int x, y;
    x = int(truMouseX/gridScale);
    y = int(truMouseY/gridScale);
    return new PVector(x, y);
  }

  void fillUp() {
    filled = true;
  }

  boolean exists(int x, int y, Cell[][] cells) {
    boolean ifx = true, ify = true;
    if (gridPos.x + x < 0 || gridPos.x + x > cells[0].length - 1) {
      ifx = false;
    }
    if (gridPos.y + y < 0 || gridPos.y + y > cells.length - 1) {
      ify = false;
    }
    return ifx && ify;
  }

  boolean exists2(int y, int x, Cell[][] cells) {
    boolean ifx, ify;
    ifx = true;
    ify = true;


    if (x + gridPos.x < 0) {
      ifx = false;
    }


    if (x + gridPos.x > cells[0].length - 1) {
      ifx = false;
    }



    if (y + gridPos.y < 0) {
      ify = false;
    }



    if (y + gridPos.y > cells.length - 1) {
      ify = false;
    }


    return ifx && ify;
  }

  void update(Cell[][] cells) {
    PVector maus = getMouseGridspace();
    if (int(maus.x) == gridPos.x && int(maus.y) == gridPos.y && mousePressed && !filled) {
      if (state == "none") {
        //state = "open";
      }
    }
  }

  void smoothCavern(Cell[][] cells) {
    borders = 0;
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!( i ==0 && j == 0)) {

          if (exists(i, j, cells)) {
            if (cells[int(gridPos.y + j)][int(gridPos.x + i)].filled) {
              borders++;
            }
          } else {
            borders++;
          }
        }
      }
    }
    if (borders < 3) {
      filled = false;
    } else if (borders > 4) {
      filled = true;
    }
  }

  void nipBuds(Cell[][] cells) {
    borders = 0;
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!( i ==0 && j == 0)) {

          if (exists(i, j, cells)) {
            if (cells[int(gridPos.y + j)][int(gridPos.x + i)].filled) {
              borders++;
            }
          } else {
            borders++;
          }
        }
      }
    }

    if ( borders < 4) {
      filled = false;
    }
  }

  void floodFill(Cell[][] cells, ArrayList<Cell> cellss) {
    if (state == "open") {
      for (int i = -1; i < 2; i++) {
        for (int j = -1; j < 2; j++) {
          if ((abs(i) + abs(j) < 2) && !( i ==0 && j == 0)) {

            if (exists(i, j, cells)) {
              if (!cells[int(gridPos.y + j)][int(gridPos.x + i)].filled && cells[int(gridPos.y + j)][int(gridPos.x + i)].state == "none") {
                cells[int(gridPos.y + j)][int(gridPos.x + i)].state = "open";
                cells[int(gridPos.y + j)][int(gridPos.x + i)].fillColor = fillColor;
                cellss.add(cells[int(gridPos.y + j)][int(gridPos.x + i)]);
              }
            }
          }
        }
      }
      state = "closed";
    }
  }

  void erode(float erosionFactor, Cell[][] cells, ArrayList<Cell> cells2) {
    if (erosionFactor > 1) {
      filled = false;
    } else if (random(0, 1) <= erosionFactor) {
      filled = false;
    } else {
      filled = true;
    }

    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if ((abs(i) + abs(j) < 2) && !( i ==0 && j == 0)) {

          if (exists(i, j, cells)) {
            if (cells[int(gridPos.y + j)][int(gridPos.x + i)].erosionState == "none" && cells[int(gridPos.y + j)][int(gridPos.x + i)].filled) {
              cells2.add(cells[int(gridPos.y + j)][int(gridPos.x + i)]);
            }
          }
        }
      }
    }
    erosionState = "done";
  }
}
