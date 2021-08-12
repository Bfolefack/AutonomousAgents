class Ship {
  Star star;
  Star destination;
  Star nextStop;
  int state;
  int timer;
  int queuePos;
  int age;
  color col;
  boolean done;

  PVector pos = new PVector();
  Ship(Star s, Star d) {
    star = s;
    star.queue.add(this);
    destination = d;
    col = color(random(255), random(255), random(225));
  }
  void update() {
    if (state == 0) {
      pos = PVector.add(star.pos, new PVector(0, -queuePos * 10));
      if (queuePos == 0) {
        timer++;
        if (timer > 20) {
          if (star == destination || age > 30) {
            star.queue.remove(this);
            done = true;
            return;
          }
          int min = Integer.MAX_VALUE;
          for (Link l : star.links) {
            Star temp = l.getOtherStar(star);
            int dist = temp.getStarDist(destination);
            if (dist < min) {
              min = dist;
              nextStop = temp;
            }
          }
          star.queue.remove(this);
          timer = 0;
          state = 1;
        }
      }
    } else if (state == 1) {
      timer++;
      if (timer < 10) {
        pos = PVector.add(star.pos, PVector.sub(nextStop.pos, star.pos).mult(timer/10.0));
      } else {
        state = 0;
        timer = 0;
        star = nextStop;
        star.queue.add(this);
        age++;
        queuePos = star.queue.indexOf(this);
        nextStop = null;
      }
    }
  }

  void display() {
    fill(col);
    noStroke();
    ellipse(pos.x, pos.y, 5, 5);
    //text(queuePos, pos.x - 15, pos.y);
  }
}
