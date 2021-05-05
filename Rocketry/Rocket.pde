public class Rocket {

  public float[] path;
  public boolean[] thrust;

  PVector pos;
  PVector vel;
  PVector acc;
  float heading;

  int timeStep;
  int lifespan;
  int thrustPower;
  float fitness;

  boolean manualControl;

  Rocket(int l, int tp) {
    lifespan = l;
    thrustPower = tp;

    acc = new PVector(0, 0.2);
    vel = new PVector(0, 0);
    pos = new PVector(width/2, height * 9/10);

    path = new float[lifespan];
    thrust = new boolean[lifespan];

    for (int i = 0; i < path.length; i++) {
      path[i] = random(-PI/10, PI/10);
    }

    for (int i = 0; i < 600; i++) {
      if (random(1) < 0.2) {
        thrust[i] = false;
      } else {
        thrust[i] = true;
      }
    }

    heading = -HALF_PI;
  }

  Rocket(float[] p, boolean[] t, int tp) {
    path = p;
    thrust = t;
    thrustPower = tp;
    lifespan = p.length;
  }

  Rocket(boolean t, int tp) {
    acc = new PVector(0, 3);
    vel = new PVector(0, 0);
    pos = new PVector(width/2, 0);
    
    heading = -HALF_PI;
    manualControl = t;
    thrustPower = tp;
  }

  void update() {
    if (!manualControl) {
      if (lifespan > timeStep) {
        calcVel();
        pos.add(vel);
        timeStep++;
      }
    } else {
      vel.add(acc);
      if (mousePressed) {
          vel.add(cos(heading) * thrustPower, sin(heading) * thrustPower);
        }
      if (keyPressed){
        switch(key) {
        case 'd':
          heading += PI/30;
          break;
        case 'a':
          heading -= PI/30;
          break;
        }
      }
      pos.add(vel);
      vel.limit(10);
    }
  }
  
  void display(){
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(heading + PI/2);
    fill(200, 200, 200, 150);
    rect(-5, -15, 10, 30);
    popMatrix();
  }

  void calcVel() {
    heading += path[timeStep];
    vel.add(acc);
    if (thrust[timeStep]) {
      vel.add(cos(heading) * thrustPower, sin(heading) * thrustPower);
    }
    vel.limit(10);
  }
}
