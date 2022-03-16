class GameEngine {
  String answer;
  ArrayList<Character> currentWord;
  ArrayList<String> allWords;
  
  boolean wordGuessed = false;
  boolean gameFinished = false;
  
  boolean hardMode = false;

  GameEngine() {
    allWords = new ArrayList<String>();

    // read allWords.txt and store in ArrayList
    String[] data = loadStrings("allWords.txt");
    for (int i = 0; i < data.length; i++) {
      allWords.add(data[i]);
    }

    // read sensibleWords.txt and select a random word
    // this will be our target word
    String[] possibleAnswers = loadStrings("sensibleWords.txt");
    answer = possibleAnswers[int((random(possibleAnswers.length)))];
    
    println(answer);
    
    // String to charArray for easier processing
    currentWord = new ArrayList<Character>();
    for (int i = 0; i < answer.length(); i++) {
      currentWord.add(answer.charAt(i));
    }
    
    // for hard mode
    hardInit();
  }

  // check if word exists
  boolean verifyWord(String word) {
    boolean result = allWords.contains(word);
    if (result) {
      return true;
    }
    return false;
  }

  // returns the colors sorta
  // 0 - gray, 1 - yellow, 2 - green
  int[] getResults(String word) {
    ArrayList<Character> tempAnswer = new ArrayList<>(currentWord);
    int[] results = new int[5];
    // set every result to -1, nothing has been set
    for (int i = 0; i < 5; i++) {
      results[i] = -1;
    }

    // loop through it, checking for correct letter & position
    for (int i = 0; i < 5; i++) {
      if (word.charAt(i) == tempAnswer.get(i)) {
        results[i] = 2;
        tempAnswer.set(i, ' '); // clear letter that we checked
      }
    }

    // loop through it again, checking for the rest
    for (int i = 0; i < 5; i++) {
      if (results[i] != 2) { // result already set
        if (tempAnswer.contains(word.charAt(i))) {
          results[i] = 1;
          tempAnswer.set(tempAnswer.indexOf(word.charAt(i)), ' '); // clear letter
        } else {
          results[i] = 0;
        }
      }
    }
    
    // check if its the correct word
    for (int i = 0; i < 5; i++) {
      if (results[i] == 2) {
        wordGuessed = true;
      }
      else {
        wordGuessed = false;
        break;
      }
    }
    
    if (wordGuessed) {
      gameFinished = true;
    }
    
    return results;
  }
  
  // for hard mode
  char[] greens;
  ArrayList<Character> yellows;
  void hardInit() {
    greens = new char[5];
    for (int i = 0; i < greens.length; i++) {
      greens[i] = '_';
    }
    
    yellows = new ArrayList<Character>();
  }
  
  boolean checkHard(String word) {
    char[] tempWord = new char[5];
    for (int i = 0; i < word.length(); i++) {
      tempWord[i] = word.charAt(i);
    }
    // check greens
    for (int i = 0; i < greens.length; i++) {
      if (greens[i] != '_') {
        if (greens[i] != tempWord[i]) {
          gInterface.message("Letter " + (i + 1) + " must be " + Character.toUpperCase(greens[i]), 16); //<>//
          return false;
        }
        else {
          tempWord[i] = '_';
        }
      }
    }
    // check yellows
    boolean in = false;
    for (int i = 0; i < yellows.size(); i++) {
      in = false;
      for (int j = 0; j < tempWord.length; j++) {
        if (yellows.get(i) == tempWord[j]) {
          in = true;
        }
      }
      if (!in) {
        gInterface.message("Word must contain " + Character.toUpperCase(yellows.get(i)), 16);
        return false;
      }
    }
    
    return true;
  }
  
  void setHard(String word, int[] results) {
    for (int i = 0; i < word.length(); i++) { //<>//
      switch (results[i]) {
        case 0: break;
        case 1: yellows.add(word.charAt(i)); break;
        case 2: 
          greens[i] = word.charAt(i);
          // remove from yellow if it exists
          if (yellows.contains(greens[i])) {
            yellows.remove(yellows.indexOf(greens[i]));
          }
          break;
      }
    }
  }
  
}
