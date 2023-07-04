class Nest {
  int xPos, yPos, size;
  float brood;
  Nest(int x_, int y_, int s_, Grid grid) {
    xPos = x_;
    yPos = y_;
    size = s_;
    for (int i = (int) -size; i < size + 1; i++) {
      for (int j = (int)  -size; j < size + 1; j++) {
        Cell cel = grid.getCell(xPos + i, yPos + j);
        if (cel  != null) {
          if (dist(xPos, yPos, (xPos + i), (yPos + j)) < size) {
            cel.nest = true;
            cel.active = true;
          }
        }
      }
    }
  }


  void display(Grid grid) {
    fill(100, 0, 255);
    ellipse(xPos * gridScale + gridScale/2, yPos * gridScale + gridScale/2, 15, 15);
    if(brood > 2.5){
      brood = 0;
      ants.add(new Ant(farm, xPos * gridScale , yPos * gridScale, 15, 2));
    }
  }
}
