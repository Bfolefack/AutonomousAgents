class Cavern {
  ArrayList<Cell> myCells = new ArrayList<Cell>();
  PVector fillColor;
  boolean cavernAvailible;
  LineObj nearestLine;
  Cavern(Cell[][] cells) {
    fillColor = new PVector(random(255), random(255), random(255));
    Cell c = getStarterCell(cells);
    nearestLine = new LineObj(-1, -1, -1,-1);
    nearestLine.lineColor = fillColor;
    if (c.gridPos.x >= 0) {
      cavernAvailible = true;
      c.state = "open";
      c.fillColor = fillColor;
      myCells.add(c);
      for (int i = 0; i < (cells.length + cells[0].length)/.5; i++) {
        ArrayList<Cell> fakeCells = (ArrayList<Cell>)myCells.clone();
        for (Cell cs : fakeCells) {
          cs.floodFill(cells, myCells);
        }
        //myCells = fakeCells;
        fakeCells.clear();
      }
      println(myCells.size());
    } else {
      cavernAvailible = false;
      println("wah");
    }
  }

  Cell getStarterCell(Cell[][] cells) {
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[0].length; j++) {   
        if (cells[i][j].state == "none" && !cells[i][j].filled) {
          return cells[i][j];
        }
      }
    }
    return new Cell(-1, -1);
  }

  void fillIn() {
    for (Cell cs : myCells) {
      cs.fillUp();
      cs.state = "none";
      cs.fillColor = new PVector();
    }
  }

  void getNearestLine(Cell[][] cells) {
    println("getting lines...");
    float smallestDist = int(pow(2, 32) - 1);
    Cell ourCell = new Cell(-1, -1);
    Cell theirCell = new Cell(-1, -1);
    for (Cell c : myCells) {
      for (int i = 0; i < cells.length; i++) {
        for (int j = 0; j < cells[0].length; j++) {
          if(!cells[i][j].filled && !cells[i][j].fillColor.equals(c.fillColor)){
            PVector theirPos = new PVector(cells[i][j].gridPos.x * gridScale + gridScale/2, cells[i][j].gridPos.y * gridScale + gridScale/2);
            PVector ourPos = new PVector(c.gridPos.x * gridScale + gridScale/2, c.gridPos.y * gridScale + gridScale/2);
            if(PVector.dist(ourPos, theirPos) < smallestDist){
              ourCell = c;
              theirCell = cells[i][j];
              nearestLine.update(ourCell.gridPos, theirCell.gridPos);
              smallestDist = PVector.dist(ourPos, theirPos);
            }
          }
        }
      }
    }
  }
  
  ArrayList<Cell> getErosionCells(Cell[][] cells){
    ArrayList<Cell> erodingCells = new ArrayList<Cell>();
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[0].length; j++) {   
        if (nearestLine.intersect(cells[i][j])){
          erodingCells.add(cells[i][j]);
        }
      }
    }
    return erodingCells;
  }
  
  void display(){
    nearestLine.display();
  }
}
