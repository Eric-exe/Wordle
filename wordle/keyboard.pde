class GameKeyboard {
  String letters = "QWERTYUIOP|ASDFGHJKL|>ZXCVBNM<";

  HashMap<Character, Key> keys = new HashMap<Character, Key>();

  boolean third = false;
  int x = 10;
  int y = 550;
  int xInc = 43 + 5;
  int yInc = 58 + 8;

  GameKeyboard() {
    for (int i = 0; i < letters.length(); i++) {
      if (letters.charAt(i) == '|') { // new line
        y += yInc;
        if (third) {
          x = 10;
          third = false;
        } else {
          x = 34;
          third = true;
        }
        continue;
      }
      if (letters.charAt(i) == '>') { // enter
        keys.put('>', new Key(0, x, y));
        x += 22;
      } else if (letters.charAt(i) == '<') { // backspace
        keys.put('<', new Key(1, x, y));
        x += 22;
      } else { // chars
        keys.put(letters.charAt(i), new Key(letters.charAt(i), x, y));
      }
      x += xInc;
    }
  }

  void display() {
    for (int i = 0; i < letters.length(); i++) {
      if (letters.charAt(i) == '|') {
        continue;
      }
      keys.get(letters.charAt(i)).display();
    }
  }

  void pressed() {
    if (gEngine.gameFinished) {
      return;
    }
    
    for (int i = 0; i < letters.length(); i++) {
      if (letters.charAt(i) == '|') {
        continue;
      }
      if (keys.get(letters.charAt(i)).pressed()) {
        if (letters.charAt(i) == '<') {
          gInterface.clearBlock();
        } else if (letters.charAt(i) == '>') {
          if (gInterface.currentCol == 5) {
            // verify word
            if (gEngine.verifyWord(gInterface.getWord())) {
              // its a word!
              // show results
              gInterface.loadResults(gEngine.getResults(gInterface.getWord()));
            } else {
              // not a word
              gInterface.shakeRow();
              gInterface.message("Not in wordlist");
            }
          } else {
            // not 5 letters
            gInterface.message("Not enough letters");
            gInterface.shakeRow();
          } 
        } 
        else {
          gInterface.updateBlock(letters.charAt(i));
        }
      }
    }
  }
}
