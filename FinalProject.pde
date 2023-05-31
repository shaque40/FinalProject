PImage carImage;  // Top view image of the car
float roadHeight = 600;  // Height of the road
float laneWidth = 40;   // Width of each lane
float laneSpeed = 50;     // Speed of the moving lanes

float laneY1, laneY2, laneY3, laneY4;  // Y position of each lane

color roadColor;  // Color of the road
int lastColorChange;  // Time of the last color change

float carX;  // X position of the car
float carY;  // Y position of the car
float carSpeed = 5;  // Speed of the car

void setup() {
  size(1000, 1000);
  
  carImage = loadImage("PlayerCar.png");
  
  laneY1 = -laneWidth;
  laneY2 = 0;
  laneY3 = height;
  laneY4 = height + laneWidth;
  
  roadColor = color(100);
  lastColorChange = millis();
  
  carX = width / 2;
  carY = height - roadHeight / 2 - carImage.height / 2;
}

void draw() {
  background(0, 255, 0);  // Set the default background color as green
  
  // Check if it's time to change the road color
  if (millis() - lastColorChange >= 15000) {
    roadColor = generateRandomColor();
    lastColorChange = millis();
  }
  
  // Draw main road with the updated color
  background(lastColorChange);
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
  
  // Draw the car
  image(carImage, carX, carY);
}

void keyPressed() {
  // Move the car left or right with arrow keys
  if (keyCode == LEFT) {
    carX -= carSpeed;
    // Ensure the car stays within the left boundary of the road
    if (carX < width / 2 - roadHeight / 2 + laneWidth / 2) {
      carX = width / 2 - roadHeight / 2 + laneWidth / 2;
    }
  } else if (keyCode == RIGHT) {
    carX += carSpeed;
    // Ensure the car stays within the right boundary of the road
    if (carX > width / 2 + roadHeight / 2 - carImage.width - laneWidth / 2) {
      carX = width / 2 + roadHeight / 2 - carImage.width - laneWidth / 2;
    }
  }
}

color generateRandomColor() {
  return color(random(255), random(255), random(255));
}

