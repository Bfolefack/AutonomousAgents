class Cell {
  float noise;
  PVector gridPos, vector;
  int borders, cost;
  String type;
  boolean impassable, target;
  int leastIndex;
  Cell[][] cells;



  Cell(int x_, int y_, float n_) {
    gridPos = new PVector(x_, y_);
    noise = n_;
    impassable = false;
    target = false;
    vector = new PVector(0, 0);
    if (noise > .65 || noise < .35) {
      impassable = true;
    }
  }

  //****************************************************************************************************

  Cell() {
    gridPos = new PVector(-1, -1);
    cost = 65535;
    impassable = true;
    target = false;
    //vector = new PVector(0, 0);
  }

  //***************************************************************************************************

  boolean mouseInside() {
    /*
    boolean ifx = false;
    boolean ify = false;
    if (truMouseX > gridPos.x * gridScale && truMouseX < gridPos.x * gridScale + gridScale) {
      ifx = true;
    }
    if (truMouseY > gridPos.y * gridScale && truMouseY < gridPos.y * gridScale + gridScale) {
      ify = true;
    }
    return ifx && ify;
    */
    return false;
  }

  //****************************************************************************************************

  void display() {
    PVector maus = getMouseGridspace();
    //println(gridPos); 
    if (mouseInside()) {
      println(vector);
    }

    if (impassable /* || cost > 65534*/) {
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
    textSize(10);
    if (cost < 65535) {
      text(cost, gridPos.x * gridScale + 10, gridPos.y * gridScale + 10);
    } else {
      text("MAX", gridPos.x * gridScale + 10, gridPos.y * gridScale + 10);
    }
    fill(0);
    rect(gridPos.x * gridScale + gridScale/2 - 1, gridPos.y * gridScale + gridScale/2 - 1, 2, 2);
    if (leastIndex != 8) {
      line(gridPos.x * gridScale + gridScale/2, gridPos.y * gridScale + gridScale/2, gridPos.x * gridScale + gridScale/2 + vector.x * 25, gridPos.y * gridScale + gridScale/2 + vector.y * 25);
    }
  }

  //****************************************************************************************************

  PVector getMouseGridspace() {
    int x, y;
    x = int(truMouseX/gridScale);
    y = int(truMouseY/gridScale);
    return new PVector(x, y);
  }

  //**************************************************************************************************

  void setArray(Cell[][] c_) {
    cells = c_;
  }

  //*************************************************************************************************

  boolean exists(int y, int x, Cell[][] cells) {
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

  //***************************************************************************************************************************

  void updateNeighbors(Cell[][] cells) {


    if (exists(1, 0, cells)) {
      if (!cells[int(gridPos.y) + 1][int(gridPos.x)].impassable && (cost + 1) < cells[int(gridPos.y) + 1][int(gridPos.x)].cost) {
        cells[int(gridPos.y) + 1][int(gridPos.x)].cost = cost + 1;
        cells[int(gridPos.y) + 1][int(gridPos.x)].type = "open";
      }
    }

    if (exists(-1, 0, cells)) {
      if (!cells[int(gridPos.y) - 1][int(gridPos.x)].impassable && (cost + 1) < cells[int(gridPos.y) - 1][int(gridPos.x)].cost) {
        cells[int(gridPos.y) - 1][int(gridPos.x)].cost = cost + 1;
        cells[int(gridPos.y) - 1][int(gridPos.x)].type = "open";
      }
    }

    if (exists(0, 1, cells)) {
      if (!cells[int(gridPos.y)][int(gridPos.x) + 1].impassable && (cost + 1) < cells[int(gridPos.y)][int(gridPos.x) + 1].cost) {
        cells[int(gridPos.y)][int(gridPos.x) + 1].cost = cost + 1;
        cells[int(gridPos.y)][int(gridPos.x) + 1].type = "open";
      }
    }

    if (exists(0, -1, cells)) {
      if (!cells[int(gridPos.y)][int(gridPos.x) - 1].impassable && (cost + 1) < cells[int(gridPos.y)][int(gridPos.x) - 1].cost) {
        cells[int(gridPos.y)][int(gridPos.x) - 1].cost = cost + 1;
        cells[int(gridPos.y)][int(gridPos.x) - 1].type = "open";
      }
    }
    /*
    if (exists(1, 1, cells)) {
     if (!cells[int(gridPos.y) + 1][int(gridPos.x) + 1].impassable && (cost + 1) < cells[int(gridPos.y) + 1][int(gridPos.x) + 1].cost) {
     cells[int(gridPos.y) + 1][int(gridPos.x) + 1].cost = cost + 1;
     cells[int(gridPos.y) + 1][int(gridPos.x) + 1].type = "open";
     }
     }
     
     if (exists(-1, 1, cells)) {
     if (!cells[int(gridPos.y) - 1][int(gridPos.x) + 1].impassable && (cost + 1) < cells[int(gridPos.y) - 1][int(gridPos.x) + 1].cost) {
     cells[int(gridPos.y) - 1][int(gridPos.x) + 1].cost = cost + 1;
     cells[int(gridPos.y) - 1][int(gridPos.x) + 1].type = "open";
     }
     }
     
     if (exists(1, -1, cells)) {
     if (!cells[int(gridPos.y) + 1][int(gridPos.x) - 1].impassable && (cost + 1) < cells[int(gridPos.y) + 1][int(gridPos.x) - 1].cost) {
     cells[int(gridPos.y) + 1][int(gridPos.x) - 1].cost = cost + 1;
     cells[int(gridPos.y) + 1][int(gridPos.x) - 1].type = "open";
     }
     }
     
     if (exists(-1, -1, cells)) {
     if (!cells[int(gridPos.y) - 1][int(gridPos.x) - 1].impassable && (cost + 1) < cells[int(gridPos.y) - 1][int(gridPos.x) - 1].cost) {
     cells[int(gridPos.y) - 1][int(gridPos.x) - 1].cost = cost + 1;
     cells[int(gridPos.y) - 1][int(gridPos.x) - 1].type = "open";
     }
     }
     */

    type = "closed";
  }

  //***************************************************************************************************************************
  void getVector() {
    Cell[] ops = new Cell[8];
    for (int i = 0; i < 8; i++) {
      ops[i] = new Cell();
    }
    if (exists(1, 0, cells)) {
      //if (cells[int(gridPos.y) + 1][int(gridPos.x)].type == "closed") {
      ops[0] = (cells[int(gridPos.y) + 1][int(gridPos.x)]);
      //}
    } else {
      ops[0] = new Cell();
    }

    if (exists(-1, 0, cells)) {
      //if (cells[int(gridPos.y) - 1][int(gridPos.x)].type == "closed") {
      ops[1] = (cells[int(gridPos.y) - 1][int(gridPos.x)]);
      //}
    } else {
      ops[1] = new Cell();
    }

    if (exists(0, 1, cells)) {
      //if (cells[int(gridPos.y)][int(gridPos.x) + 1].type == "closed") {
      ops[2] = (cells[int(gridPos.y)][int(gridPos.x) + 1]);
      //}
    } else {
      ops[2] = new Cell();
    }

    if (exists(0, -1, cells)) {
      //if (cells[int(gridPos.y)][int(gridPos.x) - 1].type == "closed") {
      ops[3] = (cells[int(gridPos.y)][int(gridPos.x) - 1]);
      // }
    } else {
      ops[3] = new Cell();
    }

    if (exists(1, 1, cells)) {
      //if (cells[int(gridPos.y) + 1][int(gridPos.x) + 1].type == "closed") {
      ops[4] = (cells[int(gridPos.y) + 1][int(gridPos.x) + 1]);
      //}
    } else {
      ops[4] = new Cell();
    }

    if (exists(-1, 1, cells)) {
      //if (cells[int(gridPos.y) - 1][int(gridPos.x) + 1].type == "closed") {
      ops[5] = (cells[int(gridPos.y) - 1][int(gridPos.x) + 1]);
      //}
    } else {
      ops[5] = new Cell();
    }

    if (exists(1, -1, cells)) {
      //if (cells[int(gridPos.y) + 1][int(gridPos.x) - 1].type == "closed") {
      ops[6] = (cells[int(gridPos.y) + 1][int(gridPos.x) - 1]);
      //}
    } else {
      ops[6] = new Cell();
    }

    if (exists(-1, -1, cells)) {
      //if (cells[int(gridPos.y) - 1][int(gridPos.x) - 1].type == "closed") {
      ops[7] = (cells[int(gridPos.y) - 1][int(gridPos.x) - 1]);
      //}
    } else {
      ops[7] = new Cell();
    }
    Cell least = new Cell();
    least.cost = 65536;
    leastIndex = 8;
    for (int i = 0; i < 8; i++) {
      if (ops[i].cost < least.cost && ops[i].cost != cost && !target) {
        least = ops[i];
        leastIndex = i;
      }
    }
    if (mouseInside()) {
      println( leastIndex );
    }


    if (target) {
      leastIndex = 8;
    }
    if (leastIndex == 0) {
      vector = new PVector(0, 1);
    } else if (leastIndex == 1) {
      vector = new PVector(0, -1);
    } else if (leastIndex == 2) {
      vector = new PVector(1, 0);
    } else if (leastIndex == 3) {
      vector = new PVector(-1, 0);
    } else if (leastIndex == 4) {
      vector = new PVector(1, 1);
    } else if (leastIndex == 5) {
      vector = new PVector(1, -1);
    } else if (leastIndex == 6) {
      vector = new PVector(-1, 1);
    } else if (leastIndex == 7) {
      vector = new PVector(-1, -1);
    } else {
      vector = new PVector(0, 0);
    }

    //vector = PVector.sub(least.gridPos, gridPos);
    vector.normalize();
  }

  //***************************************************************************************************************************

  void smoothEdges() {
    borders = 0;
    if (exists(1, 0, cells)) {
      if (cells[int(gridPos.y) + 1][int(gridPos.x)].impassable) {
        borders ++;
      }
    } else {
        borders ++; 
    }

    if (exists(-1, 0, cells)) {
      if (cells[int(gridPos.y) - 1][int(gridPos.x)].impassable) {
        borders ++;
      }
    } else {
        borders ++; 
    }

    if (exists(0, 1, cells)) {
      if (cells[int(gridPos.y)][int(gridPos.x) + 1].impassable) {
        borders ++;
      }
    } else {
        borders ++; 
    }

    if (exists(0, -1, cells)) {
      if (cells[int(gridPos.y)][int(gridPos.x) - 1].impassable) {
        borders ++;
      }
    } else {
        borders ++; 
    } 

    if (exists(1, 1, cells)) {
      if (cells[int(gridPos.y) + 1][int(gridPos.x) + 1].impassable) {
        borders ++;
      }
    } else {
        borders ++; 
    } 

    if (exists(-1, 1, cells)) {
      if (cells[int(gridPos.y) - 1][int(gridPos.x) + 1].impassable) {
        borders ++;
      }
    } else {
        borders ++; 
    }

    if (exists(1, -1, cells)) {
      if (cells[int(gridPos.y) + 1][int(gridPos.x) - 1].impassable) {
        borders ++;
      }
    } else {
        borders ++; 
    }

    if (exists(-1, -1, cells)) {
      if (cells[int(gridPos.y) - 1][int(gridPos.x) - 1].impassable) {
        borders ++;
      }
    } else {
        borders ++; 
    }
    if(borders < 3){
      impassable = false;
      clearTarget();
      cost = 0;
    }
    if(borders > 4){
      impassable = true;
      clearTarget();
      cost = 0;
    }
  }
  
  //***************************************************************************************************************************
  
  void nipBuds() {
    borders = 0;
    if (exists(1, 0, cells)) {
      if (cells[int(gridPos.y) + 1][int(gridPos.x)].impassable) {
        borders ++;
      }
    } else {
        borders ++; 
    }

    if (exists(-1, 0, cells)) {
      if (cells[int(gridPos.y) - 1][int(gridPos.x)].impassable) {
        borders ++;
      }
    } else {
        borders ++; 
    }

    if (exists(0, 1, cells)) {
      if (cells[int(gridPos.y)][int(gridPos.x) + 1].impassable) {
        borders ++;
      }
    } else {
        borders ++; 
    }

    if (exists(0, -1, cells)) {
      if (cells[int(gridPos.y)][int(gridPos.x) - 1].impassable) {
        borders ++;
      }
    } else {
        borders ++; 
    } 

    if (exists(1, 1, cells)) {
      if (cells[int(gridPos.y) + 1][int(gridPos.x) + 1].impassable) {
        borders ++;
      }
    } else {
        borders ++; 
    } 

    if (exists(-1, 1, cells)) {
      if (cells[int(gridPos.y) - 1][int(gridPos.x) + 1].impassable) {
        borders ++;
      }
    } else {
        borders ++; 
    }

    if (exists(1, -1, cells)) {
      if (cells[int(gridPos.y) + 1][int(gridPos.x) - 1].impassable) {
        borders ++;
      }
    } else {
        borders ++; 
    }

    if (exists(-1, -1, cells)) {
      if (cells[int(gridPos.y) - 1][int(gridPos.x) - 1].impassable) {
        borders ++;
      }
    } else {
        borders ++; 
    }
    if(borders < 4){
      impassable = false;
      clearTarget();
      cost = 0;
    }
  }

  //***************************************************************************************************************************

  void clearTarget() {
    target = false;
    type = "";
    cost = 65535;
  }
  
  //***************************************************************************************************************************
  
  void showRadius() {
    
    if(showRadii && impassable){
       fill(255, 0, 0, 50);
       ellipse(gridPos.x * gridScale + gridScale/2, gridPos.y * gridScale + gridScale/2, gridScale * sqrt(2) + 5, gridScale * sqrt(2) + 5);
    }
    
  }
  
}
