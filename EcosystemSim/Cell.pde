class Cell {
  boolean filled;
  PVector gridPos;
  int borders;
  float n;
  
  Cell(int x_, int y_, boolean f_){
    gridPos = new PVector(x_, y_);
    filled = f_;
    n = noise(x_ * 0.1, y_ * 0.1);
  }
  
  void display(){
    if (n > .5){
      fill(100, 255, 50);
    } else {
      fill(45, 15, 200);
    }
    rect(gridPos.x * gridScale - .01, gridPos.y * gridScale - .01, gridScale + .03, gridScale + .03);
  }
  
  PVector getMouseGridspace() {
    int x, y;
    x = int(truMouseX/gridScale);
    y = int(truMouseY/gridScale);
    return new PVector(x, y);
  }
  
  boolean exists(int x, int y, Cell[][] cells) {
    boolean ifx, ify;
    ifx = true;
    ify = true;
    
    if(x < 0){
      if(x + gridPos.x < 0){
        ifx = false;
      }
    }
    if(x > 0){
      println(x + gridPos.x);
      println(cells[0].length);
      println(x + gridPos.x > cells[0].length);
      if(x + gridPos.x > cells[0].length - 1){
        ifx = false;
      }
    }
    
    if(y < 0){
      if(y + gridPos.y < 0){
        ify = false;
      }
    }
    if(y > 0){
      if(y + gridPos.y > cells.length - 1){
        ify = false;
      }
    }
    if(filled){
      println(ifx + ":" + ify);
    }
    return ifx && ify;
  }
   
  void update(){
     PVector maus = getMouseGridspace();
     if (int(maus.x) == gridPos.x && int(maus.y) == gridPos.y && mousePressed && mouseButton == LEFT){
       
     }
   }
}
