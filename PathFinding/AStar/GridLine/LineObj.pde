class LineObj {
  float x1, y1, x2, y2;
  LineObj(float x1_,float y1_,float x2_,float y2_){
      x1 = x1_;
      y1 = y1_;
      x2 = x2_;
      y2 = y2_;
  }
  LineObj(PVector pos1, PVector pos2){
    x1 = pos1.x;
    y1 = pos1.y;
    x2 = pos2.x;
    y2 = pos2.y;
  }
  boolean intersect(float x3, float x4, float y3, float y4){
    float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
    float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
      if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
        return true;
      }
    return false;
  }
  
  boolean intersect(LineObj line){
    return intersect(line.x1, line.x2, line.y1, line.y2);
  }
  
  boolean intersect(PVector p1, PVector p2){
    return intersect(p1.x, p2.x, p1.y, p2.y);
  }
  
  boolean intersect(Cell cell){
    float x = cell.gridPos.x * gridScale;
    float y = cell.gridPos.y * gridScale;
    PVector tl, tr, bl, br;
    tl = new PVector(x, y);
    tr = new PVector(x + gridScale, y);
    bl = new PVector(x, y + gridScale);
    br = new PVector(x + gridScale, y + gridScale);
    
    boolean b1 = intersect(tl, br);
    boolean b2 = intersect(bl, tr);
    
    return b1 || b2;
  }
  
  void display(){
    line(x1, y1, x2, y2);
  }
  
  void update(float nx1, float ny1, float nx2, float ny2){
      x1 = nx1;
      y1 = ny1;
      x2 = nx2;
      y2 = ny2;
  }
}
