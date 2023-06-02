PImage carImage;  // Top view image of the car
PImage obstacleImage;  // Image of the obstacle car
float roadHeight = 600;  // Height of the road
float laneWidth = 40;   // Width of each lane
float laneSpeed = 5;     // Speed of the moving lanes

float laneY1, laneY2, laneY3, laneY4;  // Y position of each lane

color roadColor;  // Color of the road
int lastColorChange;  // Time of the last color change

PVector carPosition;  // Position of the car
float carSpeed = 5;  // Speed of the car

ArrayList<PVector> obstaclePositions;  // Positions of the obstacle cars

void setup() {
  size(1000, 1000);
  
  carImage = loadImage("PlayerCar.png");
  obstacleImage = loadImage("ObstacleCar.png");
  
  laneY1 = -laneWidth;
  laneY2 = 0;
  laneY3 = height;
  laneY4 = height + laneWidth;
  
  roadColor = color(100);
  lastColorChange = millis();
  
  carPosition = new PVector(width / 2, height - roadHeight / 2 - carImage.height / 2);
  
  obstaclePositions = new ArrayList<PVector>();
}

void draw() {
  background(0, 255, 0);  // Set the default background color as green
  
  // Check if it's time to change the road color
  if (millis() - lastColorChange >= 15000) {
    roadColor = generateRandomColor();
    lastColorChange = millis();
  }
  
  // Draw main road with the updated color
  background(roadColor);
  fill(0);
  rect(width/2 - roadHeight/2, 0, roadHeight, height);
  
  // Draw moving lanes
  fill(255, 204, 0);
  rect(width/2 - laneWidth/2, laneY1, laneWidth, laneWidth);
  rect(width/2 - laneWidth/2, laneY2, laneWidth, laneWidth);
  rect(width/2 - laneWidth/2, laneY3, laneWidth, laneWidth);
  rect(width/2 - laneWidth/2, laneY4, laneWidth, laneWidth);
  
  // Update lane positions
  laneY1 -= laneSpeed;
  laneY2 -= laneSpeed;
  laneY3 -= laneSpeed;
  laneY4 -= laneSpeed;
  
  // Wrap around the moving lanes
  if (laneY1 > height + laneWidth) {
    laneY1 = -laneWidth;
  }
  if (laneY2 > height + laneWidth) {
    laneY2 = -laneWidth;
  }
  if (laneY3 < -laneWidth) {
    laneY3 = height;
  }
  if (laneY4 < -laneWidth) {
    laneY4 = height;
  }
  
  // Generate new obstacle cars randomly
  if (random(1) < 0.01) {  // Adjust the probability as needed
    float obstacleX = random(width / 2 - roadHeight / 2 + laneWidth / 2, width / 2 + roadHeight / 2 - laneWidth / 2 - obstacleImage.width);
    PVector obstaclePosition = new PVector(obstacleX, -obstacleImage.height);
    
    // Check for overlap with existing obstacle cars
    boolean overlap = false;
    for (PVector pos : obstaclePositions) {
      if (dist(obstaclePosition.x, obstaclePosition.y, pos.x, pos.y) < obstacleImage.width) {
        overlap = true;
        break;
      }
    }
    
    // Add the obstacle car to the list if no overlap
    if (!overlap) {
      obstaclePositions.add(obstaclePosition);
    }
  }
  
  // Update obstacle car positions and remove off-screen obstacle cars
  for (int i = obstaclePositions.size() - 1; i >= 0; i--) {
    PVector obstaclePosition = obstaclePositions.get(i);
    obstaclePosition.y += laneSpeed;
    
    if (obstaclePosition.y > height) {
      obstaclePositions.remove(i);
    }
  }
  
  // Draw obstacle cars
  for (PVector obstaclePosition : obstaclePositions) {
    image(obstacleImage, obstaclePosition.x, obstaclePosition.y);
  }
  
  // Draw the car
  image(carImage, carPosition.x, carPosition.y);
}

void keyPressed() {
  // Move the car left or right with arrow keys
  if (keyCode == LEFT) {
    carPosition.x -= carSpeed;
    // Ensure the car stays within the left boundary of the road
    if (carPosition.x < width / 2 - roadHeight / 2 + laneWidth / 2) {
      carPosition.x = width / 2 - roadHeight / 2 + laneWidth / 2;
    }
  } else if (keyCode == RIGHT) {
    carPosition.x += carSpeed;
    // Ensure the car stays within the right boundary of the road
    if (carPosition.x > width / 2 + roadHeight / 2 - carImage.width - laneWidth / 2) {
      carPosition.x = width / 2 + roadHeight / 2 - carImage.width - laneWidth / 2;
    }
  }
}

color generateRandomColor() {
  return color(random(255), random(255), random(255));
}
