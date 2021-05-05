static class chunkLib {
  static Chunk getChunkAt(Grid g,int x, int y) {
    int chunkX = 0;
    int chunkY = 0;
    chunkX = floor(x/float(g.chunkSize));
    chunkY = floor(y/float(g.chunkSize));
    if (chunkExists(g, chunkX, chunkY)) {
      return g.chunks[chunkY][chunkX];
    }
    return null;
  }
  
  static Cell getCellAt(Grid g, int x, int y) {
    int chunkX = 0;
    int chunkY = 0;
    chunkX = floor(x/float(g.chunkSize));
    chunkY = floor(y/float(g.chunkSize));
    int cellX = x - chunkX * g.chunkSize;
    int cellY = y - chunkY * g.chunkSize;
    if (chunkExists(g, chunkX, chunkY)) {
      return g.chunks[chunkY][chunkX].chunkCells[cellY][cellX];
    }
    return null;
  }
  
  static boolean chunkExists(Grid g, int x_, int y_) {
    boolean ifx, ify;
    int x = y_;
    int y = x_;
    
    ifx = true;
    ify = true;

    if (x < 0) {
      if (x < 0) {
        ifx = false;
      }
    }
    if (x > 0) {
      if (x > g.chunks.length - 1) {
        ifx = false;
      }
    }

    if (y < 0) {
      if (y < 0) {
        ify = false;
      }
    }
    if (y > 0) {
      if (y > g.chunks[0].length - 1) {
        ify = false;
      }
    }
    return ifx && ify;
  }
  
  static boolean cellExists(Grid g, int x_, int y_) {
    int x = y_;
    int y = x_;
    
    boolean ifx, ify;
    ifx = true;
    ify = true;

    if (x < 0) {
      if (x < 0) {
        ifx = false;
      }
    }
    if (x > 0) {
      if (x > g.chunkSize * g.chunks.length - 1) {
        ifx = false;
      }
    }

    if (y < 0) {
      if (y < 0) {
        ify = false;
      }
    }
    if (y > 0) {
      if (y > g.chunkSize * g.chunks[0].length - 1) {
        ify = false;
      }
    }
    return ifx && ify;
  }
}
