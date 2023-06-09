class BackgroundForProject {
  
public float laneWidth ;   // Width of the lane
public float laneSpeed ;     // Speed of the moving lane  
public float laneY1 ;  // Y position of  lane
public final float roadHeight = 600;
public float lastColorChange = 0;
public color roadColor;

void backgroundColorCheck () {
 if (millis() - laneCreator.lastColorChange >= 15000) {
    laneCreator.roadColor = generateRandomColor();
    laneCreator.lastColorChange = millis();
  } 
  
  
}

void DrawLanes () {
fill(255, 204, 0);
  rect(width/2 - laneWidth/2 + 10, laneY1, laneWidth, 300);
  rect(width/2 - laneWidth/2 - 10, laneY1, laneWidth, 300);
  //rect(width/2 - laneWidth/2, laneY3, laneWidth, laneWidth);
  //rect(width/2 - laneWidth/2, laneY4, laneWidth, laneWidth); 
}

void DrawRoad () {
  
  background(roadColor);
  fill(0);
  rect(width/2 - roadHeight/2, 0, roadHeight, height);
}

public BackgroundForProject ( int varwidth, int varspeed, int lanesize ) {
  laneWidth = varwidth;
  laneSpeed = varspeed;
  laneY1 = lanesize;
  
}

color generateRandomColor() {
  return color(random(255), random(255), random(255));
}


}
