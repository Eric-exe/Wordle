class Toggle {
  float x;
  float y;
  float w;
  float h;
  
  float xButton;
  float yButton;
  float wButton;
  float hButton;
  
  boolean on;
  
  Toggle(float _x, float _y, float _w, float _h, boolean _on) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    on = _on;
    if (_on) {
      xButton = x + w/2.0;
    }
    else {
      xButton = x;
    }
    yButton = y;
    wButton = w/2.0;
    hButton = h;
  }
  
  void display() {
    noStroke();
    // whole slider
    if (!on) {
      fill(129, 131, 132);
    }
    else {
      fill(83, 141, 78);
    }
    
    rect(x, y, w, h, 6);
    
    fill(255);
    if (anim) {
      if (!on) {
        xButton += 2;
        if (xButton > x + w/2.0) {
          anim = false;
        }
      }
      else {
        xButton -= 2;
        if (xButton < x) {
          anim = false;
        }
      }
      if (!anim) {
        on = !on;
      }
    }
    if (!on) { // smaller slider inside
      rect(xButton, yButton, wButton, hButton, 6);
    }
    else {
      rect(xButton, yButton, wButton, hButton, 6);
    }
  }
  
  boolean anim = false;
  
  void pressed() {
    if (mouseX > x && mouseX < x + w && mouseY >y && mouseY < y + h) {
      if (gInterface.currentRow == 0) {
        anim = true;
        gEngine.hardMode = true;
      }
      else {
        gInterface.message("Hard mode can only be toggled\n at the start of a round", 11);
      }
    }
  }
}
