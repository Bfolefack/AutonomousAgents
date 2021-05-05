class Cell extends Entity{
  PVector gridPos;
  float noise, dTC, noise2;
  int type, nextType;

  Cell(int x_, int y_, float n_) {
    super(new PVector(x_ * gridScale + gridScale/2, y_ * gridScale + gridScale/2), "hey");
    gridPos = new PVector(x_, y_);
    noise = n_;
    if (gridPos.y < gridPos.x && gridPos.x < -gridPos.y + grdHeight/gridScale) {
      //Top
      dTC = dist(gridPos.x, gridPos.y, gridPos.x, 0);
    } else if (gridPos.y < gridPos.x && gridPos.x >= -gridPos.y + grdHeight/gridScale) {
      //Right
      dTC = dist(gridPos.x, gridPos.y, grdWidth/gridScale, gridPos.y);
    } else if (gridPos.y >= gridPos.x && gridPos.x < -gridPos.y + grdHeight/gridScale) {
      //Left
      dTC = dist(gridPos.x, gridPos.y, 0, gridPos.y);
    } else if (gridPos.y >= gridPos.x && gridPos.x >= -gridPos.y + grdHeight/gridScale) {
      //Bottom
      dTC = dist(gridPos.x, gridPos.y, gridPos.x, grdHeight/gridScale);
    }
    dTC = map(dTC, 0, grdWidth/(gridScale * 2), 0, 1);
    if (dTC < 0) {
      dTC = 0;
    } else if (dTC > 1) {
      dTC = 1;
    }
    
    if(dTC > .7){
      dTC = .7; 
    }
    
    
    noise = (noise + dTC)/2;
    //noise *= dTC + .5;
    
    if (noise < .5) {
      fill(25, 40, 220);
      type = DEEPOCEAN;
    } else if (noise < .54) {
      fill(80, 100, 235);
      type = SHALLOWOCEAN;
    } else if (noise < .6) {
      fill(200, 230, 100);
      type = COASTLINE;
    } else if (noise < .65) {
      fill(20, 225, 45);
      type = LIGHTGRASS;
    } else if (noise < .7) {
      type = GRASS;
      fill(20, 150, 45);
    } else if (noise < .8) {
      fill(100, 50, 0);
      type = LOWMONT;
    } else if (noise < .9) {
      fill(50, 25, 0);
      type = HIGHMONT;
    } else if (noise > .9) {
      fill(255);
      type = SNOW;
    } else {
      fill(noise * 255);
    }
    
  }

  void display() {
    
    if (type == DEEPOCEAN) {
      fill(25, 40, 220);
    } else if (type == SHALLOWOCEAN) {
      fill(45, 85, 220);
    } else if (type == COASTLINE) {
      fill(200, 230, 100);
    } else if (type == LIGHTGRASS) {
      fill(20, 225, 45);
    } else if (type == GRASS) {
      fill(20, 150, 45);
    } else if (type == LOWMONT) {
      fill(100, 50, 0);
    } else if (type == HIGHMONT) {
      fill(50, 25, 0);
    } else if (type == SNOW) {
      fill(255);
    } else {
      fill(noise * 255);
    }
    
    
    //fill(dTC * 255);

    rect(gridPos.x * gridScale - .02, gridPos.y * gridScale - .02, gridScale + .04, gridScale + .04);
    fill(0);
    ellipse(pos.x, pos.y, 2, 2);
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
  }
  
  void smoothEdges(Cell[][] cells) {
    int smooth = 0;
    int count = 0;
    float avg = 0;
    boolean smoothings = false;
    if(exists(-1, 0, cells)){
      count++;
       if (cells[int(gridPos.y)][int(gridPos.x - 1)].type == type){
         smooth++;
       }
       avg += cells[int(gridPos.y)][int(gridPos.x - 1)].type;
     }
     
     if(exists(1, 0, cells)){
       count++;
       if (cells[int(gridPos.y)][int(gridPos.x + 1)].type == type){
         smooth++;
       }
       avg += cells[int(gridPos.y)][int(gridPos.x + 1)].type;
     }
     
     if(exists(0, -1, cells)){
       count++;
       if (cells[int(gridPos.y - 1)][int(gridPos.x)].type == type){
         smooth++;
       }
       avg += cells[int(gridPos.y - 1)][int(gridPos.x)].type;
     }
     
     if(exists(0, 1, cells)){
       count++;
       if (cells[int(gridPos.y + 1)][int(gridPos.x)].type == type){
         smooth++;
       }
       avg += cells[int(gridPos.y + 1)][int(gridPos.x)].type;
     }
     
     if(exists(-1, -1, cells)){
       count++;
       if (cells[int(gridPos.y - 1)][int(gridPos.x - 1)].type == type){
         smooth++;
       }
       avg += cells[int(gridPos.y - 1)][int(gridPos.x - 1)].type;
     }
     
     if(exists(-1, 1, cells)){
       count++;
       if (cells[int(gridPos.y + 1)][int(gridPos.x - 1)].type == type){
         smooth++;
       }
       avg += cells[int(gridPos.y + 1)][int(gridPos.x - 1)].type;
     }
     
     if(exists(1, -1, cells)){
       count++;
       if (cells[int(gridPos.y - 1)][int(gridPos.x + 1)].type == type){
         smooth++;
       }
       avg += cells[int(gridPos.y - 1)][int(gridPos.x + 1)].type;
     }
     
     if(exists(1, 1, cells)){
       count++;
       if (cells[int(gridPos.y + 1)][int(gridPos.x + 1)].type == type){
         smooth++;
       }
       avg += cells[int(gridPos.y + 1)][int(gridPos.x + 1)].type;
     }
    if(count < 8){
     type = 0; 
    }
    avg /= 8;
    
     if(smooth <= 4){
       smoothings = true;
     } else {
       smoothings = false;
     }
     
     if(smoothings){
       nextType = int(avg);
     } else {
      nextType = type; 
     }
   }
  }
  
  
