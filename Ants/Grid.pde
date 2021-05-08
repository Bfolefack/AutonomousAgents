import java.util.*;
class Grid {
  Cell[][] grid;
  int gridWidth;
  int gridHeight;
  float gridScale;
  Grid(int gW, int gH, float gS, float d, float sc){
    gridWidth = gW;
    gridHeight = gH;
    gridScale = gS;
    grid = new Cell[gridWidth][gridHeight];
    for(int i = 0; i < gridWidth; i++){
      for(int j = 0; j < gridHeight; j++){
        if(noise(i * sc, j * sc, (i + j) * sc * 0.5) < d){
          grid[i][j] = new Cell(i, j, gridScale, true);
        } else {
          grid[i][j] = new Cell(i, j, gridScale, false);
        }
      }
    }
    buildCave();
  }
  
  void display(){
    for(int i = 0; i < gridWidth; i++){
      for(int j = 0; j < gridHeight; j++){
        grid[i][j].display();
      }
    }
  }
  
  void buildCave(){
    Random randy = new Random(seed);
    ArrayList<Cell> tempCells = new ArrayList<Cell>();
    for(int i = 0; i < gridWidth; i++){
      for(int j = 0; j < gridHeight; j++){
        tempCells.add(grid[i][j]);
      }
    }
    Collections.shuffle(tempCells);
    for(int i = 0; i < 50; i++){
      println(i);
      for(Cell c : tempCells){
        c.buildCave(this);
      }    
    }
    for(int i = 0; i < 10; i++){
      println(i);
      for(Cell c : tempCells){
        c.smoothWalls(this);
      }    
    }
  }
  
  Cell getCell (float x_, float y_){
    int x = (int) x_;
    int y = (int) y_;
    if(x >= 0 && y >= 0 && x < gridWidth && y < gridHeight){
      return grid[x][y];
    }
    return null;
  }
}
