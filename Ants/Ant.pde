class Ant {
  PVector pos, vel, acc, steer, randy, e;
  float maxSpeed, maxForce, r;
  float index;
  float offset;
  int[] avgExhaust;
  int avgExhaustOffset;
  boolean full;
  int exhaustionTimer = 1;
  boolean arrived;
  String status = "seeking";
  Grid thisGrid;

  Ant (Grid g, float _px, float _py, float _ms, float _mf) {
    pos = new PVector(_px, _py);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    randy = new PVector(random(-1, 1), random(-1, 1));
    e = new PVector(randy.x, randy.y);
    thisGrid = g;
    maxSpeed = _ms;
    maxForce = _mf;
    index = random(Integer.MIN_VALUE, Integer.MAX_VALUE);
    avgExhaust = new int[50];
    avgExhaustOffset = 0;
    globalIndex++;
    r = 10;
    arrived = false;
  }

  void update(Grid grid) {
    layPheremones(grid);
    float randyRad = random(-PI, PI);
    PVector draw =  new PVector(cos(randyRad), sin(randyRad));
    e.add(draw);
    e.setMag(maxSpeed/4);
    randy.add(e);
    randy.setMag(r * 10);
    PVector p = getSights(grid, (int) r);
    if (p.mag() > 0) {
      addForce(p.mult(gridScale));
    } else {
      addForce(seek(PVector.add(randy, pos)).mult(2));
    }
    addForce(avoidWalls(grid, 1).mult(500));
    //addForce(avoidNeighbors(grid));
    PVector avy = avoidWalls(grid, 3).mult(20);
    avy.setMag(randy.mag());
    randy.add(avy.mult(abs(PVector.dot(randy.normalize(null), avy.normalize(null)))));
    vel.add(acc);
    vel.limit(maxSpeed);
    vel.mult(0.8);
    pos.add(vel);
    acc.set(0, 0);
    exhaustionTimer++;
    if (exhaustionTimer > exhaustTime * 3600 || average(avgExhaust) > exhaustTime * 720) {
      status = "exhausted";
    }
    if (exhaustionTimer > exhaustTime * 3600 * 2) {
      ants.remove(this);
    }
    if (mousePressed) {
      if (dist(pos.x, pos.y, truMouseX, truMouseY) <= r * 2 && mouseButton == RIGHT) {
        followerAnt = this;
      }
    }
  }

  float average(int[] arr) {
    float total = 0;
    for (int i : arr) {
      total += i;
    }
    total/=(float)arr.length;
    return total;
  }

  void display() {
    float theta = vel.heading() + PI/2;
    fill(255, 0, 255);
    //stroke(0);
    //strokeWeight(1);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(theta);
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);
    fill(255, 0, 0);
    popMatrix();
    //ellipse(pos.x + randy.x, pos.y + randy.y, r, r);
  }


  PVector seek(PVector t) {
    PVector desired = PVector.sub(t, pos);

    float d = desired.mag();

    if (d < 20) {
      float m =  map(d, 0, 20, 0, maxSpeed);
      desired.setMag(m);
    } else {
      desired.setMag(maxSpeed);
    }

    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxForce);
    return steer;
  }

  PVector avoid(PVector t) {
    PVector desired = PVector.sub(t, pos);

    float d = desired.mag();

    if (d < 20) {
      float m =  map(d, 0, 20, 0, maxSpeed);
      desired.setMag(m);
    } else {
      desired.setMag(maxSpeed);
    }

    PVector steer = PVector.sub(desired.mult(-1), vel);
    steer.limit(maxForce);
    return steer;
  }

  PVector gridAvoid(PVector t) {
    PVector desired = PVector.sub(t, pos);

    float d = desired.mag();

    if (d < 20) {
      float m =  map(d, 0, 20, 0, maxSpeed);
      desired.setMag(m);
    } else {
      desired.setMag(maxSpeed);
    }

    PVector steer = PVector.sub(desired.mult(-1), vel);
    steer.limit(maxForce);
    return steer;
  }

  PVector avoidWalls(Grid grid, int range) {
    int xPos = (int) (pos.x/gridScale);
    int yPos = (int) (pos.y/gridScale);
    int count = 0;
    //grid.getCell(xPos, yPos).currColor = color(255, 0, 0);
    PVector sum = new PVector();
    for (int i = -range; i < range + 1; i++) {
      for (int j = -range; j < range + 1; j++) {
        if (abs(i) + abs(j) != 0) {
          Cell cel = grid.getCell(xPos + i, yPos + j);
          if (cel != null) {
            if (cel.filled) {
              sum.add(gridAvoid(new PVector((xPos + i) * gridScale, (yPos + j) * gridScale)));
              count++;
            }
          }
        }
      }
    }
    if (count > 0)
      sum.div(count);
    else
      sum = new PVector(0, 0);
    return sum.limit(maxForce);
  }

  //PVector avoidNeighbors(Grid grid) {
  //  int xPos = (int) (pos.x/gridScale);
  //  int yPos = (int) (pos.y/gridScale);
  //  int xChunkPos = (int) (pos.x/gridScale)/20;
  //  int yChunkPos = (int) (pos.y/gridScale)/20;
  //  int count = 0;
  //  //grid.getCell(xPos, yPos).currColor = color(255, 0, 0);
  //  PVector sum = new PVector();
  //  for (Ant a : grid.chunks[xChunkPos][yChunkPos].ants) {
  //    if (a != this) {
  //      if (PVector.dist(pos, a.pos) < r * 5) {
  //        sum.add(avoid(a.pos));
  //        count++;
  //      }
  //    }
  //  }
  //  if (count > 0)
  //    sum.div(count);
  //  else
  //    sum = new PVector(0, 0);
  //  return sum.limit(maxForce);
  //}

  void layPheremones(Grid grid) {
    int xPos = (int) (pos.x/gridScale);
    int yPos = (int) (pos.y/gridScale);
    Cell cel = grid.getCell(xPos, yPos);
    cel.active = true;
    cel.ant = this;
    if (status.equals("seeking")) {
      cel.homePheremone += 0.2/(exhaustionTimer/(exhaustTime * 3600));
    } else if (status.equals("returning")) {
      cel.foodPheremone += 0.2/(exhaustionTimer/(exhaustTime * 3600));
    } else if (status.equals("returningDejected")) {
      if (cel.foodPheremone > 0) {
        cel.foodPheremone -= 0.2;
      }
    }
    cel.active = true;
    if (cel.filled) {
      ants.remove(this);
    }
  }

  PVector seek(Cell cel) {
    PVector celPos = new PVector((cel.xPos * gridScale + gridScale/2) - pos.x, (cel.yPos * gridScale + gridScale/2) - pos.y);
    return celPos;
  }

  PVector getSights(Grid grid, int radius) {
    int xPos = (int) (pos.x/gridScale);
    int yPos = (int) (pos.y/gridScale);
    int count = 1;
    boolean food = false;
    float nearestTargetDist = Integer.MAX_VALUE;
    PVector pheremoneTotal = new PVector();
    Cell nearestTarget = null;
    for (int i = (int) -radius; i < radius + 1; i++) {
      for (int j = (int)  -radius; j < radius + 1; j++) {
        Cell cel = grid.getCell(xPos + i, yPos + j);
        if (cel  != null) {
          if (dist(xPos, yPos, (xPos + i), (yPos + j)) < radius) {
            cel.active = true;
            if (PVector.angleBetween(vel, new PVector(i, j)) < PI/3) {
              //cel.currColor = color(255, 0, 0);
              if (status.equals("seeking")) {
                if (cel.food > 0 || cel.foodHerePheremone > 0) {
                  if (dist(xPos, yPos, xPos + i, yPos + j) < nearestTargetDist) {
                    if (cel.food > 0 || !food) {
                      if (cel.food > 0) {
                        food = true;
                      }
                      nearestTargetDist = dist(xPos, yPos, xPos + i, yPos + j);
                      nearestTarget = cel;
                    }
                  }
                }
                if (cel.foodPheremone > 0) {
                  pheremoneTotal.add(seek(cel).mult(cel.foodPheremone * 2));
                  count++;
                }
              } else if (status.equals("returning") || status.equals("exhausted") || status.equals("returningDejected")) {
                if (cel.nest) {
                  if (dist(xPos, yPos, xPos + i, yPos + j) < nearestTargetDist) {
                    nearestTargetDist = dist(xPos, yPos, xPos + i, yPos + j);
                    nearestTarget = cel;
                  }
                }
                if (cel.homePheremone > 0) {
                  pheremoneTotal.add(seek(cel).mult(cel.homePheremone * 2));
                  count++;
                }
              }
              if (cel.ant != null) {
                avgExhaustOffset += 1;
                if (avgExhaustOffset >= 50)
                  avgExhaustOffset = 0;
                avgExhaust[avgExhaustOffset] = cel.ant.exhaustionTimer;
              }
            }
          }
        }
      }
    }
    pheremoneTotal.div(count);
    if (nearestTarget != null) {
      if (nearestTargetDist < 2) {
        if (status.equals("seeking")) {
          if (food) {
            status = "returning";
            nearestTarget.food -= 0.5;
            if (nearestTarget.foodHerePheremone < 1)
              nearestTarget.foodHerePheremone += 0.5;
            full = true;
            randy = PVector.mult(vel, -1);
          } else if (nearestTargetDist < 1) {
            status = "returningDejected";
            grid.getCell(xPos, yPos).foodHerePheremone = 0;
          }
        } else if (status.equals("returning")  || status.equals("exhausted") || status.equals("returningDejected")) {
          status = "seeking";
          randy = PVector.mult(vel, -1);
          exhaustionTimer = 1;
          if (full) {
            nest.brood += 0.15;
          }
        }
      }
      return seek(nearestTarget);
    }
    if (pheremoneTotal.mag() > r) {
      return pheremoneTotal;
    }
    return new PVector(0, 0);
  }

  void addForce(PVector force) {
    acc.add(force);
  }

  //void setChunk(Grid grid) {
  //  int xPos = (int) (pos.x/gridScale)/20;
  //  int yPos = (int) (pos.y/gridScale)/20;
  //  try {
  //    grid.chunks[xPos][yPos].ants.add(this);
  //  } 
  //  catch (Exception e) {
  //    ants.remove(this);
  //  }
  //}

  void seek(float _t1, float _t2) {
    PVector target = new PVector(_t1, _t2);
    seek(target);
  }
}
