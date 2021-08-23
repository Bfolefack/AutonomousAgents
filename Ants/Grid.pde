import java.util.*;
class Grid {
  Cell[][] grid;
  //Chunk[][] chunks;
  int gridWidth;
  int gridHeight;
  float gridScale;
  PImage map;
  ArrayList<ArrayList<Cell>> caverns;
  Grid(int gW, int gH, float gS, float d, float sc) {
    gridWidth = gW;
    gridHeight = gH;
    map = createImage(gridWidth, gridHeight, RGB);
    map.loadPixels();
    gridScale = gS;
    grid = new Cell[gridWidth][gridHeight];
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        if (noise(i * sc, j * sc, (i * sc * 0.5 + j * sc * 0.5)) < d) {
          grid[i][j] = new Cell(i, j, gridScale, true);
        } else {
          grid[i][j] = new Cell(i, j, gridScale, false);
          if (noise(i * sc, j * sc, (i * sc * 0.5 + j * sc * 0.5)) > 0.7) {
            grid[i][j].food = 1;
          }
        }
      }
    }
    buildCave();
    caverns = new ArrayList<ArrayList<Cell>>();
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        if (!grid[i][j].filled && grid[i][j].cavernID == 0) {
          floodFill(i, j);
        }
      }
    }
    ArrayList<Cell> biggest = new ArrayList<Cell>();
    for (int i = 0; i < caverns.size(); i++) {
      if (caverns.get(i).size() > biggest.size()) {
        biggest = caverns.get(i);
      }
    }
    for (int i = 0; i < caverns.size(); i++) {
      if (caverns.get(i) != biggest) {
        for (Cell c : caverns.get(i)) {
          c.filled = true;
        }
      }
    }
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        grid[i][j].update();
      }
    }
    //chunks = new Chunk[gridWidth/20][gridHeight/20];
    //for (int i = 0; i < gridWidth/20; i++) {
    //  for (int j = 0; j < gridHeight/20; j++) {
    //    chunks[i][j] = new Chunk();
    //  }
    //}
  }

  void display() {
    if (frameCount % shutterSpeed == 0 && ants.size() > 1 && saveTimelapse) {
      map.save(timeLapseID + "/" + (frameCount/shutterSpeed) + ".jpg");
    }
    float slice = (frameCount % shutterSpeed)/(shutterSpeed * 1.0);
    int count = (int)(slice * map.pixels.length);
    for (int i = (int)(slice * gridHeight); i < (int)(slice * gridHeight) + gridHeight/shutterSpeed; i++) {
      for (int j = 0; j < gridWidth; j++) {
        grid[j][i].display();
        map.pixels[count] = grid[j][i].currColor;
        count++;
      }
    }
    map.updatePixels();
    if (showFarm) {
      pushMatrix();
      scale(gridScale);
      image(map, 0, 0);
      popMatrix();
    }

    //for (int i = 0; i < gridWidth/20; i++) {
    //  for (int j = 0; j < gridHeight/20; j++) {
    //    chunks[i][j].clear();
    //  }
    //}
  }
  
  void update(){
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        if(grid[i][j].active){
          grid[i][j].update();
        }
      }
    }
  }

  void floodFill(int x, int y) {
    ArrayList<Cell> active = new ArrayList<Cell>();
    ArrayList<Cell> nextActive = new ArrayList<Cell>();
    ArrayList<Cell> cavern = new ArrayList<Cell>();
    int id = (int) random(1, Integer.MAX_VALUE);
    active.add(getCell(x, y));
    while (active.size() > 0) {
      nextActive = new ArrayList<Cell>();
      for (Cell c : active) {
        c.floodFill(this, nextActive, id);
        cavern.add(c);
      }
      active = (ArrayList) nextActive.clone();
    }
    caverns.add(cavern);
  }

  void buildCave() {
    Random randy = new Random(seed);
    ArrayList<Cell> tempCells = new ArrayList<Cell>();
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        tempCells.add(grid[i][j]);
      }
    }
    Collections.shuffle(tempCells, randy);
    for (int i = 0; i < 30; i++) {
      println(i);
      for (Cell c : tempCells) {
        c.buildCave(this);
      }
    }
    for (int i = 0; i < 10; i++) {
      println(i);
      for (Cell c : tempCells) {
        c.smoothWalls(this);
      }
    }
  }

  Cell getCell (float x_, float y_) {
    int x = (int) x_;
    int y = (int) y_;
    if (x >= 0 && y >= 0 && x < gridWidth && y < gridHeight) {
      return grid[x][y];
    }
    return null;
  }
}
