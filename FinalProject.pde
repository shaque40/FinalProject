// main class  

//YourCar controlCar = new YourCar();
//BackgroundForProject  currentBackground = new BackgroundForProject();

PImage carImage;  // Top view image of the car
float roadHeight = 600;  // Height of the road
float laneWidth = 40;   // Width of each lane
float laneSpeed = 50;     // Speed of the moving lanes

float laneY1, laneY2, laneY3, laneY4;  // Y position of each lane

void setup() {
  size(1000, 1000);
  
  //carImage = loadImage("car.png");  // Replace with the path to your car image
  
  laneY1 = -laneWidth;
  laneY2 = 0;
  laneY3 = height;
  laneY4 = height + laneWidth;
}

void draw() {
  background(0,255,0);
  
  // Draw main road
  fill(100);
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
}
