class Cell {
  boolean filled;
  int xPos;
  int yPos;
  float scale;
  int cavernID;
  Cell(int x, int y, float s, boolean b) {
    xPos = x;
    yPos = y;
    scale = s;
    filled = b;
    cavernID = 0;
  }

  void buildCave(Grid grid) {
    int neighbors = 0;
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        Cell cell = grid.getCell(xPos + i, yPos + j);
        if (cell != null) {
          if (cell.filled) {
            neighbors++;
          }
        } else {
          neighbors += 10;
        }
      }
    }
    if (neighbors < 3) {
      filled = false;
    } else if (neighbors > 4) {
      filled = true;
    }
  }

  void smoothWalls(Grid grid) {
    int neighbors = 0;
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (abs(i) + abs(j)  != 0) {
          Cell cell = grid.getCell(xPos + i, yPos + j);
          if (cell != null) {
            if (cell.filled) {
              neighbors++;
            }
          } else {
            neighbors += 10;
          }
        }
      }
    }
    if (neighbors < 4) {
      filled = false;
    }
  }

  void display() {
    if (filled) {
      fill(0);
    } else {
      fill(255);
    }
    rect(xPos * scale, yPos * scale, scale, scale);
  }

  void floodFill(Grid grid, ArrayList<Cell> cels, int id) {
    if (cavernID == 0 && !filled){
      cavernID = id;
      for (int i = -1; i < 2; i++) {
        for (int j = -1; j < 2; j++) {
          if (abs(i) + abs(j)  == 1) {
            Cell cel = grid.getCell(xPos + i, yPos + j);
            if (cel != null) {
              if (cel.cavernID == 0 && !cel.filled) {
                cels.add(cel);
              }
            }
          }
        }
      }
    }
  }
}
