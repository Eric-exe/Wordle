// letters 43 width x 58 height
// 5px width gap

// enter and backspace 65 x 58
class Key {
  int x;
  int y;
  char c;
  int w = 43;
  int h = 58;
  
  boolean notChar;
  int buttonType; // 0 - enter, 1 - backspace
  
  int buttonState = -1; // -1: default, 0: gray, 1:yellow, 2: green
  
  // for character keys
  Key(char _c, int _x, int _y) {
    notChar = false;
    c = _c;
    x = _x;
    y = _y;
  }
  
  // for enter and backspace
  Key(int _buttonType, int _x, int _y) {
    notChar = true;
    buttonType = _buttonType;
    x = _x;
    y = _y;
    w = 65;
  }
  
  void updateState(int state) {
    buttonState = state;
  }
  
  void display() {
    switch(buttonState) {
      case -1: fill(129, 131, 132); break;
      case 0: fill(58, 58, 60); break;
      case 1: fill(181, 159, 59); break;
      case 2: fill(83, 141, 78); break;
    }
    noStroke();
    rect(x, y, w, h, 6);
    
    // fill in keys
    fill(255);
    pushMatrix();
    translate(x + w/2.0, y + h/2.0);
    textSize(16);
    if (!notChar) { // for characters
      text(c, -2, -5);
    }
    else {
      if (buttonType == 0) {
        text("ENTER", -2, -5);
      }
      else {
        text("DELETE", -2, -5);
      }
    }
    popMatrix();
  }
  
  boolean pressed() {
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      return true;
    }
    return false;
  }
}
