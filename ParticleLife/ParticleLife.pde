float scale;
float xPan;
float yPan;
float truMouseX;
float truMouseY;

int colorNum;
int particleNum;
int simWidth, simHeight;
ParticleColor[] knownParticles;
Particle[] particles;

void setup() {
  size(1000, 700);
  xPan = width/2;
  yPan = height/2;
  scale = 1;
  noStroke();
  colorNum = 10;
  simWidth = 3000;
  simHeight = 2000;
  particleNum = 700;
  knownParticles = new ParticleColor[colorNum];
  for (int i = 0; i < colorNum; i++) {
    knownParticles[i] = new ParticleColor(new PVector(random(100, 255), random(100, 255), random(100, 255)));
  }
  for (int i = 0; i < colorNum; i++) {
    knownParticles[i].setupParticle(i);
  }
  particles = new Particle[particleNum];
  for (int i = 0; i < particleNum; i++) {
    particles[i] = new Particle(knownParticles[int(random(colorNum))]);
  }
}

void draw() {
  truMouseX = (mouseX + xPan - width/2)/scale;
  truMouseY = (mouseY + yPan - height/2)/scale;
  pushMatrix();
  translate(-xPan, -yPan);
  translate(width/2, height/2);
  scale(scale);
  background(0);
  for (int i = 0; i < particleNum; i++) {
    particles[i].update();
  }
  for (int i = 0; i < particleNum; i++) {
    particles[i].display();
  }
  popMatrix();
}

void mouseDragged () {
  xPan += (pmouseX - mouseX);
  yPan += (pmouseY - mouseY);
}

void mouseWheel (MouseEvent event) {
  float scaleAmt = 1 + (.1 * event.getCount());

  scale *= scaleAmt;
  xPan *= scaleAmt;
  yPan *= scaleAmt;
}
