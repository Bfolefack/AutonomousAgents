class Cell {
  boolean filled, nest, active;
  int xPos;
  int yPos;
  float scale;
  float homePheremone;
  float foodPheremone;
  float foodHerePheremone;
  float food;
  int cavernID;
  color currColor;
  Ant ant;
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
    //fill (currColor);
    //rect(xPos * scale, yPos * scale, scale, scale);
  }
  void update() {
    homePheremone *= 0.999;
    foodPheremone *= 0.999;
    if (homePheremone == 0 && foodPheremone == 0 && foodHerePheremone == 0) {
      active = false;
    }
    if (homePheremone > 1)
      homePheremone = 1;
    if (foodPheremone > 1)
      foodPheremone = 1;
    if (filled) {
      currColor = color(0);
      foodPheremone = 0;
      homePheremone = 0;
    } else {
      currColor = color((255 - homePheremone * 255 + 255)/2, ((255 - homePheremone * 255) + (255 - foodPheremone * 255))/2, (255 + (255 - foodPheremone * 255))/2 - (foodHerePheremone * 255));
      if (food > 0) {
        currColor = color(255 - food * 255, 255, 255 - food * 255);
      }
      if (nest) {
        currColor = color(200, 0, 255);
      }
    }
    if(ant != null){
      currColor = color(255, 0, 0);
    }
    ant = null;
  }

  void floodFill(Grid grid, ArrayList<Cell> cels, int id) {
    if (cavernID == 0 && !filled) {
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
