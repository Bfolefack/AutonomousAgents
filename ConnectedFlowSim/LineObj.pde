class LineObj {
  float x1, y1, x2, y2;
  PVector lineColor;
  LineObj(float x1_,float y1_,float x2_,float y2_){
      x1 = x1_;
      y1 = y1_;
      x2 = x2_;
      y2 = y2_;
      lineColor = new PVector(0, 0, 0);
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
    stroke(lineColor.x, lineColor.y, lineColor.z);
    line(x1, y1, x2, y2);
  }
  
  void update(PVector n1, PVector n2){
      x1 = n1.x * gridScale + gridScale/2;
      y1 = n1.y * gridScale + gridScale/2;
      x2 = n2.x * gridScale + gridScale/2;
      y2 = n2.y * gridScale + gridScale/2;
  }
}
