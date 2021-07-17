import javafx.util.Pair;
class Star {
  ArrayList<Link> links;
  ArrayList<Link> pointAs;
  ArrayList<Pair<Star, Integer>> starDists;
  PVector pos;
  int greatestStarDist;
  int queueSize;
  color col;
  Star(float x, float y) {
    pos = new PVector();
    pos.x = x;
    pos.y = y;
    col = color(255);
    links = new ArrayList<Link>();
    pointAs = new ArrayList<Link>();
  }

  void link (ArrayList<Star> stars) {
    for (Star s : stars) {
      if (dist(pos.x, pos.y, s.pos.x, s.pos.y) < random(50, 200) && s.links.size() < 4 && links.size() < 4) {
        pointAs.add(new Link(this, s));
      }
    }
  }

  void checkDist(ArrayList<Star> stars) {
    for (int i = 0; i < stars.size(); i++) {
      if (dist(pos.x, pos.y, stars.get(i).pos.x, stars.get(i).pos.y) < 50) {
        if (stars.get(i) != this) {
          stars.remove(this);
          return;
        }
      }
    }
  }

  void getLinks(ArrayList field) {
    field.add(this);
    for (Link l : links) {
      if (!field.contains(l.getOtherStar(this))) {
        l.getOtherStar(this).getLinks(field);
      }
    }
  }

  void getLinks(ArrayList field, color c) {
    field.add(this);
    col = c;
    for (Link l : links) {
      if (!field.contains(l.getOtherStar(this))) {
        l.getOtherStar(this).getLinks(field, c);
      }
    }
  }

  int getStarDist(Star s) {
    for (Pair<Star, Integer> p : starDists) {
      if (p.getKey() == s) {
        return p.getValue();
      }
    }
    return -1;
  }

  void measureStarDists() {
    starDists = new ArrayList<Pair<Star, Integer>>();
    starDists.add(createPair(this, 0));
    greatestStarDist = 0;
    for (Link l : links) {
      Star star = l.getOtherStar(this);
      starDists.add(createPair(star, 1));
      star.measureStarDists(starDists, this, 1);
    }
  }

  void measureStarDists(ArrayList<Pair<Star, Integer>> stars, Star s, int runningTotal) {
    runningTotal += 1;
    for (Link l : links) {
      Star star = l.getOtherStar(this);
      int num = s.getStarDist(star);
      if (num < 0) {
        stars.add(createPair(star, runningTotal));
        star.measureStarDists(stars, s, runningTotal);
      } else if (runningTotal < num) {
        stars.set(stars.indexOf(createPair(star, num)), createPair(star, runningTotal));
        star.measureStarDists(stars, s, runningTotal);
      }
    }
  }

  Pair<Star, Integer> createPair(Star s, int i) {
    return new Pair<Star, Integer> (s, i);
  }

  void display(Starfield sf) {
    noStroke();
    fill(col);
    ellipse(pos.x, pos.y, 10, 10);
    stroke(col);
    for (Link l : links) {
      Star other = l.getOtherStar(this);
      if (red(col) <= red(other.col)) {
        line(pos.x, pos.y, other.pos.x, other.pos.y);
      }
    }
    text(queueSize, pos.x, pos.y + 15);
  }

  void update(Starfield sf) {
    measureStarDists();
    if (mousePressed && dist(truMouseX, truMouseY, pos.x, pos.y) < 15) {
      for (Pair <Star, Integer> si : starDists) {
        if (si.getValue() > greatestStarDist) {
          greatestStarDist = si.getValue();
        }
      }
      sf.focusStar = this;
      sf.updateColors();
      println(greatestStarDist);
    }
  }
  
  void updateStarColor(Starfield sf){
    if (sf.focusStar != null && mousePressed) {
      float num = sf.focusStar.getStarDist(this)/ (float) sf.focusStar.greatestStarDist;
      col = color(255, 255 - (num * 255), 255 - (num * 255));
    }
  }
}