// main class  

//YourCar controlCar = new YourCar();
//BackgroundForProject  currentBackground = new BackgroundForProject();

float roadWidth = 200;  // Width of the main road
float roadHeight = 50; // Height of the main road
float laneWidth = 50;   // Width of each lane
float laneHeight = 10;  // Height of each lane
float laneSpeed = 2;    // Speed of the moving lanes

float laneX1, laneX2, laneX3, laneX4;  // X position of each lane

void setup() {
  size(800, 400);
  
  laneX1 = -laneWidth;
  laneX2 = 0;
  laneX3 = width;
  laneX4 = width + laneWidth;
}

void draw() {
  background(255);
  
  // Draw main road
  fill(100);
  rect(0, height/2 - roadHeight/2, width, roadHeight);
  
  // Draw moving lanes
  fill(200);
  rect(laneX1, height/2 - laneHeight/2, laneWidth, laneHeight);
  rect(laneX2, height/2 - laneHeight/2, laneWidth, laneHeight);
  rect(laneX3, height/2 - laneHeight/2, laneWidth, laneHeight);
  rect(laneX4, height/2 - laneHeight/2, laneWidth, laneHeight);
  
  // Update lane positions
  laneX1 += laneSpeed;
  laneX2 += laneSpeed;
  laneX3 -= laneSpeed;
  laneX4 -= laneSpeed;
  
  // Wrap around the moving lanes
  if (laneX1 > width + laneWidth) {
    laneX1 = -laneWidth;
  }
  if (laneX2 > width + laneWidth) {
    laneX2 = -laneWidth;
  }
  if (laneX3 < -laneWidth) {
    laneX3 = width;
  }
  if (laneX4 < -laneWidth) {
    laneX4 = width;
  }
}

