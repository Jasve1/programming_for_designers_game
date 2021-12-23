class Scoreboard {
  JSONArray scoreData;
  String dataPath = "data/scoreData.json";
  
  void display() {
    scoreData = loadJSONArray(dataPath);
    textSize(128);
    fill(#982C20);
    textAlign(CENTER);
    text("Scoreboard", 0, 50, width, 200);

    textSize(50);
    float yPos = 100;
    for (int i = 0; i < scoreData.size(); i++) {
      JSONObject scoreItem = scoreData.getJSONObject(i); 
      String name = scoreItem.getString("name");
      int score = scoreItem.getInt("score");
      
      text(name+": "+str(score), 0, yPos*i+250, width, 100);
    }
  }
  
  void saveNewScore(String newName, int newScore) {
    scoreData = loadJSONArray(dataPath);
    
    // Add new score
    JSONObject newPlayer = new JSONObject();

    newPlayer.setInt("score", newScore);
    newPlayer.setString("name", newName);
    
    scoreData.setJSONObject(scoreData.size(), newPlayer);
    
    // Sort score values
    int[] scores = new int[scoreData.size()];
    for (int i = 0; i < scoreData.size(); i++) {
      JSONObject scoreItem = scoreData.getJSONObject(i); 
      int score = scoreItem.getInt("score");
      
      scores[i] = score;
    }
    int[] sortedScores = reverse(sort(scores));
    
    // Sort JSON array based on score values
    JSONArray newScoreData = new JSONArray();
    for (int i = 0; i < sortedScores.length; i++) {
      for (int j = 0; j < scoreData.size(); j++) {
        JSONObject scoreItem = scoreData.getJSONObject(j); 
        int score = scoreItem.getInt("score");
        if (score == sortedScores[i]) {
          String name = scoreItem.getString("name");
          JSONObject newObject = new JSONObject();
    
          newObject.setInt("score", score);
          newObject.setString("name", name);
          
          newScoreData.setJSONObject(i, newObject);
          scoreData.remove(j);
          break;
        }
      }
    }

    saveJSONArray(newScoreData, dataPath);
  }
}
