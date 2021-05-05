class Grid {
  Chunk[][] chunks;
  int gridHeight, gridWidth, chunkSize;

  Grid(int x_, int y_) {
    chunkSize = chunkScale;
    chunks = new Chunk[y_][x_];
    gridHeight = y_;
    gridWidth = x_;
    for (int i = 0; i < gridHeight; i++) {
      Chunk[] tempChunks = new Chunk[gridWidth];
      for (int j = 0; j < gridWidth; j++) {
        tempChunks[j] = new Chunk(j, i);
      }
      chunks[i] = tempChunks;
    }
  }

  void display() {
    for (int i = 0; i < chunks.length; i++) {
      for (int j = 0; j < chunks[i].length; j++) {
        chunks[i][j].display();
      }
    }
  }
}
