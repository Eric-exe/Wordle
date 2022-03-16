GameEngine gEngine;
GameInterface gInterface;

void setup() {
  gEngine = new GameEngine();
  gInterface = new GameInterface();
  
  size(500, 800);
  textAlign(CENTER, CENTER);
  
}

boolean win = false;
boolean winJumped = false;
boolean answerDisplayed = false;

void draw() {
  background(18, 18, 19);
  
  // title
  fill(255);
  textSize(30);
  text("Wordle", 250, 45);

  gInterface.gKeyboard.display();
  gInterface.displayInterface();
  
  // jump last row if word is guessed
  if (gEngine.wordGuessed) {
    winJumped = true;
  }
  if (!win && winJumped) {
    gInterface.jumpRow();
    win = true;
  }
  
  // player failed, show answer
  if (!gEngine.wordGuessed && gInterface.currentRow > 5 && !answerDisplayed) {
    answerDisplayed = true;
    gEngine.gameFinished = true;
    gInterface.displayAnswer();
  }
 
}


void keyPressed() {
  if (gInterface.currentRow >= 6 || gEngine.wordGuessed) {
    return;
  }
  
  if (key == BACKSPACE) { 
    gInterface.clearBlock();
  }
  else if (key == RETURN || key == ENTER) {
    if (gInterface.currentCol == 5) {
      // verify word
      if (gEngine.verifyWord(gInterface.getWord())) { 
        // its a word!
        // show results
        if (!gEngine.hardMode) {
          gInterface.loadResults(gEngine.getResults(gInterface.getWord()));
        }
        else { // hard mode
          if (gEngine.checkHard(gInterface.getWord())) {
            String word = gInterface.getWord();
            int[] results = gEngine.getResults(word);
            gInterface.loadResults(results);
            gEngine.setHard(word, results); //<>//
          }
        }
      }
      else {
        // not a word
        gInterface.shakeRow();
        gInterface.message("Not in wordlist");
      }
    }
    else {
      // not 5 letters
      gInterface.message("Not enough letters");
      gInterface.shakeRow();
    }
  }
  else if ((keyCode >= 65 && keyCode <= 90) || (keyCode >= 97 && keyCode <= 122)) {
    gInterface.updateBlock(key);
  }
  //println(keyCode);
}

void mousePressed() {
  gInterface.gKeyboard.pressed();
  gInterface.newGamePressed();
  gInterface.button.pressed();
}

void resetGame() {
  win = false;
  winJumped = false;
  answerDisplayed = false;
  
  // memorize hardmode
  boolean hardMode = gEngine.hardMode;
  gEngine = new GameEngine();
  gEngine.hardMode = hardMode;
  gInterface = new GameInterface();
  if (hardMode) {
    gInterface.button = new Toggle(12, 757, 50, 25, true);
  }
}
