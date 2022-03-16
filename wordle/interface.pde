class GameInterface {
  CharBlock[][] blocks;
  GameKeyboard gKeyboard;
  Toggle button;

  GameInterface() {
    gKeyboard = new GameKeyboard();
    button = new Toggle(12, 757, 50, 25, false);
    // create the answer blocks
    blocks = new CharBlock[6][5];

    int x = 111;
    int y = 125;
    for (int i = 0; i < 6; i++) { // rows
      for (int j = 0; j < 5; j++) { // cols
        blocks[i][j] = new CharBlock(x, y);
        x += (62 + 6);
      }
      y += (62 + 6);
      x = 111;
    }
  }


  // current block being typed
  int currentRow = 0;
  int currentCol = 0;
  void updateBlock(char c) {
    if (currentCol < 5) {
      blocks[currentRow][currentCol].updateBlock(Character.toUpperCase(c));
      currentCol++;
    }
  }


  // clear character inside block
  void clearBlock() {
    if (currentCol > 0) {
      blocks[currentRow][currentCol - 1].clearBlock();
      currentCol--;
    }
  }


  // shake current row
  // call this funct
  void shakeRow() {
    shakeRow = true;
  }
  // shake for 'wrong' words
  boolean shakeRow = false;
  boolean left = true;
  int deltaPos = 0;
  int deltaMax = 6;
  int counter = 0;
  
  void shakeRowFunct() {
    if (counter < 4) {
      for (int i = 0; i < 5; i++) {
        if (left) {
          blocks[currentRow][i].x -= 2;
        } else {
          blocks[currentRow][i].x += 2;
        }
      }
      if (left) {
        deltaPos -= 2;
      } else {
        deltaPos += 2;
      }

      // shift to the other side
      if (abs(deltaPos) >= deltaMax) {
        left = !left;
        counter++;
      }
    }

    // shift to middle
    else {
      if (deltaPos != 0) {
        for (int i = 0; i < 5; i++) {
          blocks[currentRow][i].x -= 2;
        }
        deltaPos -= 2;
        if (deltaPos == 0) {
          // reset shake
          shakeRow = false;
          counter = 0;
        }
      }
    }
  }
  

  // piece chars together in the row
  String getWord() {
    String result = "";
    for (int i = 0; i < 5; i++) {
      result += blocks[currentRow][i].c;
    }
    return result.toLowerCase();
  }
  

  // display messages
  boolean msg = false;
  int maxLifetime = 75;
  int currentLifetime = 0;
  float gradient = 0.0;
  String currentMsg;
  int textSize = 0;
  
  // call this
  void message(String _msg) {
    msg = true;
    currentMsg = _msg;
    currentLifetime = 0;
    gradient = 0.0;
    textSize = 0;
  }
  
  void message(String _msg, int _textSize) {
    message(_msg);
    textSize = _textSize;
  }
  
  void displayMessage() {
    pushMatrix();
    noStroke();
    if (currentLifetime < maxLifetime) {
      fill(255);
    }
    else {
      if (gradient <= 1.0) {
        // fade out
        gradient += 0.1;
        fill(lerpColor(color(255), color(20), gradient));
      }
    }
    rect(175, 25, 150, 50, 6);
    fill(18, 18, 19);
    translate(250, 50);
    if (textSize != 0) {
      textSize(textSize);
    }
    else {
      textSize(18);
    }
    text(currentMsg, -1, -5);
    popMatrix();
    currentLifetime++;
    if (gradient >= 1.0) {
      msg = false;
    }
  }
  
  
  
  // make row jump when answer is correct
  boolean jump = false;
  
  void jumpRow() {
    jump = true;
  }
  
  void jumpRowFunct() {
    int animStartTime = 0;
    if (blocks[currentRow-1][4].anim2 == false) { // is last row block animated?
      for (int i = 0; i < 5; i++) {
        blocks[currentRow-1][i].anim3 = true;
        blocks[currentRow-1][i].startAnim2 = animStartTime;
        animStartTime += 5;
      }
      jump = false;
      
      // send a win message based on guesses
      switch (currentRow-1) {
        case 0: message("Genius"); break;
        case 1: message("Magnificent"); break;
        case 2: message("Impressive"); break;
        case 3: message("Splendid"); break;
        case 4: message("Great"); break;
        case 5: message("Phew"); break;
      }
    }
  }
  

  // process and animate results
  // flips block
  void loadResults(int[] results) {
    int animStartTime = 0;
    for (int i = 0; i < 5; i++) {
      blocks[currentRow][i].blockColor = results[i];
      blocks[currentRow][i].anim2 = true;
      blocks[currentRow][i].startAnim = animStartTime;
      animStartTime += 30;
    }
    currentRow++;
    currentCol = 0;
    keyboardUpdate = true;
  }
  
  
  // update keyboard
  boolean keyboardUpdate = false;
  void updateKeyboard() {
    if (!blocks[currentRow-1][4].anim2) {
      for (int i = 0; i < 5; i++) {
        gKeyboard.keys.get(blocks[currentRow-1][i].c).buttonState = blocks[currentRow-1][i].blockColor;
      }
      keyboardUpdate = false;
    }
  }
  
  
  // player failed, display answer
  boolean answerDisplay = false;

  // call this
  void displayAnswer() {
    answerDisplay = true;
  }
  
  void displayAnswerFunct() {
    // wait for anim
    if (!blocks[currentRow-1][4].anim2) {
      message(gEngine.answer.toUpperCase());
      answerDisplay = false;
    }
  }
  
  // new game for when current game is won
  void newGameButton() {
    stroke(58, 58, 60);
    if (gEngine.gameFinished && !blocks[currentRow-1][4].anim2) { // wait for anim
      fill(83, 141, 78);
    }
    else {
      fill(18, 18, 19);
    }
    rect(350, 750, 140, 40, 6);
    fill(255);
    textSize(18);
    text("New Game", 420, 770 - 3);
  }
  
  void newGamePressed() {
    if (mouseX > 350 && mouseX < 490 && mouseY > 750 && mouseY < 790) {
      resetGame();
    }
  }
  
  
  // show everything
  void displayInterface() {
    if (jump) {
      jumpRowFunct();
    }
    if (shakeRow) {
      shakeRowFunct();
    }
    if (msg) {
      displayMessage();
    }
    if (keyboardUpdate) {
      updateKeyboard();
    }
    if (answerDisplay) {
      displayAnswerFunct();
    }
    
    newGameButton();
    // show blocks
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 5; j++) {
        blocks[i][j].display();
      }
    }
    
    // show hard mode button
    button.display();
    textSize(16);
    text("Hard Mode", 105, 767); 
  }
}
