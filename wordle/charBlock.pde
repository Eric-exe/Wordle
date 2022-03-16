// blocks are 62 x 62 with 6 pixel gaps
class CharBlock {
  int x;
  int y;
  char c;
  boolean charSet = false;
  
  // animation for when letter is typed
  boolean anim = false;
  boolean increasing = false;
  float currentScale = 1.0f;
  float maxScale = 1.2f;
  
  // -1: default, 0: gray, 1: yellow, 2: green
  int blockColor = -1;
  CharBlock(int _x, int _y) {
    x = _x;
    y = _y;
  }
  
  void display() {
    strokeWeight(1);
    stroke(58, 58, 60);
    switch (blockColor) {
      case -1: fill(18, 18, 19); break;
      case 0: fill(58, 58, 60); break;
      case 1: fill(181, 159, 59); break;
      case 2: fill(83, 141, 78); break;
    }
    pushMatrix();
    translate(x, y);
    scale(currentScale);
    
    // animation for when a letter is typed
    if (anim) {
      if (!increasing) {
        if (currentScale > 1.0f) {
          currentScale -= 0.05f;
        }
        else {
          anim = false;
        }
      }
      if (increasing && currentScale < maxScale) {
        currentScale += 0.05f;
      }
      else {
        increasing = false;
      }
    }
    if (anim2) {
      // answer is submitted, now to flip
      // blocks are default color before flip
      if (!halfway) {
        fill(18, 18, 19);
      }
      flipBlock();
    }
    if (anim3) {
      // jump
      jumpBlock();
    }
    if (mini) {
      // tiny jump after jump
      miniJump();
    }
    
    square(-31, -31, 62);
    
    if (charSet) {
      fill(color(255));
      textSize(40);
      text(c, 0, -5);
    }
    popMatrix();
  }
  
  // animation for when guess is entered
  boolean anim2 = false;
  boolean halfway = false;
  int startAnim = 0;
  int currentFrame = 0;
  float flipScale = 1.0;
  
  void flipBlock() {
    currentFrame++;
    if (currentFrame >= startAnim) {
      // start animating
      if (!halfway) {
        // decrease y
        flipScale -= 0.1;
      }
      else {
        // increase y
        flipScale += 0.1;
      }
      scale(1.0, flipScale);
      
      if (!halfway && flipScale < 0) {
        // start increasing
        halfway = true;
      }
      
      if (halfway && flipScale == 1) {
        // animation finished
        // reset vars
        anim2 = false;
        halfway = false;
        currentFrame = 0;
      }
    }
    else {
      // gotta wait
      currentFrame++;
    }
  }
  
  // when the answer is correct
  boolean anim3 = false;
  boolean halfway2 = false;
  int startAnim2 = 0;
  int currentFrame2 = 0;
  int currentJumpHeight = 0;
  int maxJumpHeight = 40;
  
  void jumpBlock() {
    currentFrame2++;
    if (currentFrame2 >= startAnim2) {
      // start animating
      if (!halfway2) {
        currentJumpHeight += 4;
        y -= 4;
      }
      else {
        currentJumpHeight -= 4;
        y += 4;
      }
      
      if (!halfway2 && currentJumpHeight >= maxJumpHeight) {
        halfway2 = true;
      }
      if (halfway2 && currentJumpHeight <= 0) {
        // finished animating
        anim3 = false;
        halfway2 = false;
        currentFrame2 = 0;
        mini = true;
      }
    }
  }
  
  boolean mini = false;
  boolean mHalfway = false;
  int maxMiniJump = 20;
  int deltaJump = 0;
  void miniJump() {
    if (!mHalfway && abs(deltaJump) <= maxMiniJump) {
      y -= 4;
      deltaJump -= 4;
    }
    else if (deltaJump <= 0) {
      mHalfway = true;
      y += 4;
      deltaJump += 4;
    }
    
    if (deltaJump >= 0) {
      mini = false;
    }
  }
  
  void updateBlock(char _c) {
    c = _c;
    charSet = true;
    anim = true;
    increasing = true;
  }
  
  void clearBlock() {
    charSet = false;
  }
}
