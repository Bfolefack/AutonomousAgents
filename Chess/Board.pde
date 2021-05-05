class Board {
  float boardScale;
  int boardWidth;
  int boardHeight;
  Cell[][] cells;
  Board(int _bw, int _bh, float _bs) {
    boardWidth = _bw;
    boardHeight = _bh;
    boardScale = _bs;
    cells = new Cell[_bw][_bh];
    for (int i = 0; i < boardWidth; i++) {
      for ( int j = 0; j < boardHeight; j++) {
        cells[i][j] = new Cell(i, j);
      }
    }
  }

  void display() {
    pushMatrix();
    translate((width - (boardWidth * boardScale))/2, (height - (boardHeight * boardScale))/2);
    for (int i = 0; i < boardWidth; i++) {
      for ( int j = 0; j < boardHeight; j++) {
        cells[i][j].display(this);
      }
    }
    popMatrix();
  }
  
  void setPiece(Piece p, int x, int y) {
    cells[x][y].setPiece(p);
  }
  
  void update() {
    for (int i = 0; i < boardWidth; i++) {
      for ( int j = 0; j < boardHeight; j++) {
        cells[i][j].update(this);
      }
    }
  }
  
  PVector getMouseGridspace(Board b) {
    return new PVector(int((mouseX - (width - (b.boardWidth * b.boardScale))/2)/b.boardScale), int((mouseY - ((height - (b.boardHeight * b.boardScale))/2))/b.boardScale));
  }
}
