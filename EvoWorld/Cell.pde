class Cell {
  PVector gridPos;
  float noise;
  boolean selected, grassy;
  float berrySize;

  Cell(int x_, int y_, float n_) {
    gridPos = new PVector(x_, y_);
    noise = n_;
    if(noise > .7 && noise < .85){
      grassy = true;
    }
  }

  void display() {

    if (noise < .6) {
      fill(25, 40, 220);
    } else if (noise < .65) {
      fill(45, 85, 220);
    } else if (noise < .7) {
      fill(200, 230, 100);
    } else if (noise < .78) {
      fill(20, 225, 45);
    } else if (noise < .85) {
      fill(20, 150, 45);
    } else if (noise < .9) {
      fill(100, 50, 0);
    } else if (noise < .95) {
      fill(50, 25, 0);
    } else if (noise < 1) {
      fill(255);
    } else {
      fill(noise * 255);
    }
    
    if(selected){
      fill(255, 0, 0);
    }

    rect(gridPos.x * gridScale, gridPos.y * gridScale, gridScale, gridScale);
    selected = false;
    
    fill(255, 0, 0);
    circle(gridPos.x * gridScale + gridScale/2, gridPos.y * gridScale + gridScale/2, berrySize);
    
    update();
  }
  
  void update(){
    if (grassy){
      if(random(30000) < 1){
        if(berrySize == 0){
          berrySize = 5;
          return;
        }
      }
      if (berrySize > 0){
        berrySize += .05;
      }
      if (berrySize > 30){
        berrySize = 0;
      }
    }
  }
}
