class Zoom {
  float scale;
  float xPan;
  float yPan;

  Zoom(float _s){
   xPan = width/2;
   yPan = height/2;
   scale = _s;
  }
  
  
  void edgePan(){
    if(mouseX > width - 75){
      xPan += 10; 
    } else if (mouseX < 75){
      xPan -= 10; 
    }
    
    if(mouseY > height - 75){
      yPan += 10; 
    } else if (mouseY < 75){
      yPan -= 10; 
    }
  }
  
  void pushZoom(){
    truMouseX = (mouseX + xPan - width/2)/scale;
    truMouseY = (mouseY + yPan - height/2)/scale;
    pushMatrix();
    translate(-xPan, -yPan);
    translate(width/2, height/2);
    scale(scale);
  }
  
  void popZoom(){
    popMatrix();
  }
  
  void keyScale() {
    if(keyPressed){
      if(key == 'w'){
        scale *= 1.02;
        xPan *= 1.02;
        yPan *= 1.02;
      }
      if(key == 's'){
        scale *= .98;
        xPan *= .98;
        yPan *= .98;
      }
    }
  }
  
  void mousePan()  {
    if(mousePressed){
      xPan += (pmouseX - mouseX);
      yPan += (pmouseY - mouseY);
    }
  }
  
  //
  //MUST BE PLACED INSIDE mouseWheel() METHOD  
  void mouseScale(MouseEvent event, float scaleScale) {
    float scaleAmt = 1 + (scaleScale * event.getCount());
    
    scale *= scaleAmt;
    xPan *= scaleAmt;
    yPan *= scaleAmt;
  }
}
