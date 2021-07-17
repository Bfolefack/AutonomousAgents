class Ship {
  Star star;
  Star destination;
  Star nextStop;
  int state;
  int timer;
  int queuePos;
  int prevStarQueueSize = 0;
  boolean done;

  PVector pos = new PVector();
  Starfield field;
  Ship(Star s, Star d) {
    star = s;
    star.queueSize++;
    destination = d;
  }
  void update() {
    if (star == destination) {
      star.queueSize--;
      done = true;
    }
    if (state == 0) {
      pos = PVector.add(star.pos, new PVector(0, -queuePos * 10));
      if (queuePos == 0) {
        timer++;
        if (timer > 20) {
          int min = Integer.MAX_VALUE;
          for (Link l : star.links) {
            Star temp = l.getOtherStar(star);
            int dist = temp.getStarDist(destination);
            if (dist < min) {
              min = dist;
              nextStop = temp;
            }
          }
          star.queueSize--;
          timer = 0;
          state = 1;
        }
      } else {
        if (prevStarQueueSize > star.queueSize) {
          queuePos--;
        }
        prevStarQueueSize = star.queueSize;
      }
    } else if (state == 1) {
      timer++;
      if (timer < 10) {
        pos = PVector.add(star.pos, PVector.sub(nextStop.pos, star.pos).mult(timer/10.0));
      } else {
        state = 0;
        timer = 0;
        star = nextStop;
        queuePos = star.queueSize;
        star.queueSize++;
        nextStop = null;
      }
    }
  }

  void display() {
    fill(0, 0, 255);
    ellipse(pos.x, pos.y, 5, 5);
    text(queuePos, pos.x - 15, pos.y);
  }
}
