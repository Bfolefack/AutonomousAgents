class Starfield {
  ArrayList<Star> field;
  ArrayList<Ship> fleet;
  Star focusStar;

  Starfield(Star s) {
    field = new ArrayList<Star>();
    s.getLinks(field);
    fleet = new ArrayList<Ship>();
  }

  void display() {
    for (Star s : field) {
      s.update(this);
      s.display(this);
    }
    for (Ship s : fleet) {
      s.update();
      s.display();
    }
    for (int i = fleet.size() - 1; i >= 0; i--) {
      if (fleet.get(i).done) {
        fleet.remove(i);
      }
    }
    if (random(1) < 0.02) {
      fleet.add(new Ship(field.get((int) random(field.size())), field.get((int) random(field.size()))));
    }
  }

  void updateColors() {
    for (Star s : field) {
      s.updateStarColor(this);
    }
  }
}
