Starfield starfield;
float truMouseX;
float truMouseY;
Zoom zoomer;
void setup() {
  size(1000, 600);
  zoomer = new Zoom(1);
  background(0);
  fill(255);
  strokeWeight(0.1);
  ArrayList<Star> tempStarfield = new ArrayList<Star>();
  ArrayList<Starfield> constellations = new ArrayList<Starfield>();
  for (int i = 0; i < 100; i++) {
    tempStarfield.add(new Star(random(width * 1), random(height * 1)));
  }
  for (int i = tempStarfield.size() - 1; i >= 0; i--) {
    tempStarfield.get(i).checkDist(tempStarfield);
  }
  ArrayList<Star> tempStars = (ArrayList) tempStarfield.clone();
  for (int i = tempStars.size() - 1; i >= 0; i--) {
    tempStars.remove(i).link(tempStars);
  }
  while (tempStarfield.size() > 0) {
    constellations.add(0, new Starfield(tempStarfield.get(0)));
    for (Star s : constellations.get(0).field) {
      tempStarfield.remove(s);
    }
  }
  int biggest = 0;
  for(Starfield sf : constellations){
    if(sf.field.size() > biggest){
      biggest = sf.field.size();  
      starfield = sf;
    }
  }
  println("ready!");
}

void draw() {
  background(0);
  fill(255);
  text(frameRate, 0, 10);
  zoomer.mousePan();
  zoomer.pushZoom();
  starfield.display();
  zoomer.popZoom();
}

void mouseWheel(MouseEvent event){
  zoomer.mouseScale(event, 0.05);
}
