class Car {
  public PImage carImage;  // Top view image of the car
  public PImage obstacleImage;  // Image of the obstacle car
  public float carSpeed = 10;  // Speed of the player car
  public float obstacleSpeed = 5;  // Speed of the obstacle cars
  public PVector carPosition;  // Position of the car
  
  
  void randomizeOpposition ( ArrayList <PVector> oppositionList) {
   if (random(1) < 0.005) {  // Adjust the probability
    PVector obstaclePosition = new PVector(random(width/2 - laneCreator.roadHeight/2 + laneCreator.laneWidth, width/2 + laneCreator.roadHeight/2 -  obstacleImage.width - laneCreator.laneWidth), -  obstacleImage.height);
    
    // Check for overlap with existing obstacle cars
    boolean overlap = false;
    for (PVector pos : oppositionList) {
      if (dist(obstaclePosition.x, obstaclePosition.y, pos.x, pos.y) <  obstacleImage.width) {
        overlap = true;
        break;
      }
    }
    
    // Add the obstacle car to the list if no overlap
    if (!overlap) {
      oppositionList.add(obstaclePosition);
    }
  } 
  }
  
  boolean collisionDetected( float x2, float y2) {
  return carPosition.x < x2 + obstacleImage.width &&
         carPosition.x + carImage.width > x2 &&
         carPosition.y < y2 + obstacleImage.height &&
         carPosition.y + carImage.height > y2;
  }
  
}
