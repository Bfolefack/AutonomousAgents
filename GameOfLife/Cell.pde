class Cell {
  boolean filled;
  PVector gridPos;
  int borders;
  
  Cell(int x_, int y_, boolean f_){
    gridPos = new PVector(x_, y_);
    filled = f_;
  }
  
  void display(){
    if (filled){
      fill(0);
      rect(gridPos.x * gridScale, gridPos.y * gridScale, gridScale, gridScale);
      /*
      fill(255);
      textSize(10);
      text(borders, gridPos.x * gridScale + gridScale/2, gridPos.y * gridScale + gridScale/2);
      */
      
    } else {
      /*
      fill(0);
      textSize(10);
      text(borders, gridPos.x * gridScale + gridScale/2, gridPos.y * gridScale + gridScale/2);
      */
      
    }
  }
  
  PVector getMouseGridspace() {
    int x, y;
    x = int(truMouseX/gridScale);
    y = int(truMouseY/gridScale);
    return new PVector(x, y);
  }
  
  void fillUp(){
     filled = true;
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
    
    return ifx && ify;
  }
  
  
   
   void update(Cell[][] cells){
    PVector maus = getMouseGridspace();
     if (int(maus.x) == gridPos.x && int(maus.y) == gridPos.y && mousePressed && mouseButton == LEFT){
       filled = true;
     }
     borders = 0;
     if(exists(-1, 0, cells)){
       if (cells[int(gridPos.y)][int(gridPos.x - 1)].filled){
         borders++;
       }
     }
     
     if(exists(1, 0, cells)){
       if (cells[int(gridPos.y)][int(gridPos.x + 1)].filled){
         borders++;
       }
     }
     
     if(exists(0, -1, cells)){
       if (cells[int(gridPos.y - 1)][int(gridPos.x)].filled){
         borders++;
       }
     }
     
     if(exists(0, 1, cells)){
       if (cells[int(gridPos.y + 1)][int(gridPos.x)].filled){
         borders++;
       }
     }
     
     if(exists(-1, -1, cells)){
       if (cells[int(gridPos.y - 1)][int(gridPos.x - 1)].filled){
         borders++;
       }
     }
     
     if(exists(-1, 1, cells)){
       if (cells[int(gridPos.y + 1)][int(gridPos.x - 1)].filled){
         borders++;
       }
     }
     
     if(exists(1, -1, cells)){
       if (cells[int(gridPos.y - 1)][int(gridPos.x + 1)].filled){
         borders++;
       }
     }
     
     if(exists(1, 1, cells)){
       if (cells[int(gridPos.y + 1)][int(gridPos.x + 1)].filled){
         borders++;
       }
     }
   }


  void iterate(){
    if(filled){
      if(borders < 2){
       filled = false; 
      } else if(borders > 3){
       filled = false; 
      }
    } else if(borders == 3){
     fillUp(); 
    }
  }
}
