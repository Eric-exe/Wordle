class Score {
  PrintWriter resultWriter;
  ArrayList<Integer> res;

  Score() {
    // load results if exists
    res = new ArrayList<Integer>();

    File file = dataFile("Stats.txt");
    if (file.isFile()) {
      String[] results = loadStrings("data/Stats.txt");
      if (results.length != 0) {
        for (int i = 0; i < results[0].length(); i++) {
          res.add(Character.getNumericValue(results[0].charAt(i)));
        }
      }
    }
  }

  void write() {
    resultWriter = createWriter("data/Stats.txt");
  }

  void newScore(int score) {
    res.add(score);
  }

  void saveScores() {
    for (int i = 0; i < res.size(); i++) {
      resultWriter.print(res.get(i));
    }
    resultWriter.flush();
    resultWriter.close();
  }
  
  int currentStreak;
  int maxStreak;
  int percent;
  int wins;
  int consistent;
  HashMap<Integer, Integer> scores;
  void processScores() {
    currentStreak = 0;
    maxStreak = 0;
    wins = 0;
    consistent = -1;
    
    scores = new HashMap<Integer, Integer>();
    
    scores.put(0, 0);
    scores.put(1, 0);
    scores.put(2, 0);
    scores.put(3, 0);
    scores.put(4, 0);
    scores.put(5, 0);
    scores.put(6, 0);
    
    for (int i = 0; i < res.size(); i++) {
      if (res.get(i) != 6) {
        currentStreak++;
        if (currentStreak > maxStreak) {
          maxStreak = currentStreak;
        }
        wins++;
      }
      else {
        currentStreak = 0;
      }
      
      scores.put(res.get(i), scores.get(res.get(i)) + 1);
    }
    percent = int(float(wins)/res.size() * 100);
    
    for (int i = 0; i < 6; i++) {
      if (scores.get(i) > consistent) {
        consistent = scores.get(i);
      }
    }
  }
  
  void displayChart() {
    fill(25);
    stroke(40);
    rect(100, 75, 300, 340, 6);
    fill(255);
    
    textSize(20);
    text("STATISTICS", 250, 110);
    
    textSize(26);
    text(str(res.size()), 160, 150); // played
    text(str(percent), 220, 150); // percent won
    text(str(currentStreak), 280, 150); // current streak
    text(str(maxStreak), 340, 150); // max streak
    
    textSize(12);
    text("Played", 160, 175);
    text("Win %", 220, 175);
    text("Current\nStreak", 280, 185);
    text("Max\nStreak", 340, 185);
    
    textSize(20);
    text("GUESS CONTRIBUTIONS", 250, 225);
    
    // add bars
    textSize(16);
    text("1", 130, 255);
    text("2", 130, 280);
    text("3", 130, 305);
    text("4", 130, 330);
    text("5", 130, 355);
    text("6", 130, 380);
    
    noStroke();
    int beginY = 255;
    int inc = 25;
    for (int i = 0; i < 6; i++) {
      fill(56);
      if (scores.get(i) == 0) {
        rect(140, beginY - 7, 18, 18);
        fill(255);
        text("0", 158 - textWidth("0"), beginY - 1);
      }
      else {
        rect(140, beginY - 7, float(scores.get(i))/consistent * 230, 18);
        fill(255);
        String guessCount = str(scores.get(i));
        text(guessCount, (140 + float(scores.get(i))/consistent * 230) - textWidth(guessCount), beginY - 1);
      }
      beginY += inc;
    }
  }
}
