class Button {
  PVector position;
  float bWidth = 200;
  float bHeight = 50;
  float padding = 10;
  String text = "";
  ButtonType type;
  
  Button(float x, float y, String newText, ButtonType newType) {
    position = new PVector(x,y);
    text = newText;
    type = newType;
  }
  
  void display() {
    noStroke();
    fill(#982C20);
    rect(position.x, position.y, bWidth, bHeight);
    
    fill(#ffffff);
    textSize(22);
    text(text, position.x+padding, position.y+padding, bWidth-padding, bHeight-padding);
  }
  
  void handleMouseClick() {
    PVector mousePos = new PVector(mouseX, mouseY);
    if (mouseX >= position.x && mouseY >= position.y && mousePos.x <= position.x+bWidth && mousePos.y <= position.y+bHeight) {
      switch(type) {
        case SUBMIT:
          gameState = GameState.SAVESCORE;
          break;
        case START:
          gameState = GameState.LEVEL;
          break;
        case SEESCORE:
          gameState = GameState.SCOREBOARD;
          break;
        case TITLE:
          gameState = GameState.TITLE;
          break;
      }
    }
  }
}
