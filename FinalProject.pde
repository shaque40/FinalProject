import processing.serial.*;
import gifAnimation.*;

PImage carImage;  // Top view image of the car
PImage obstacleImage;  // Image of the obstacle car
PImage explosionImage;  // Image of the explosion

float roadHeight = 600;  // Height of the road
float laneWidth = 40;   // Width of each lane
float laneSpeed = 5;     // Speed of the moving lanes
float carSpeed = 10;  // Speed of the player car
float obstacleSpeed = 5;  // Speed of the obstacle cars

float laneY1, laneY2, laneY3, laneY4;  // Y position of each lane

color roadColor;  // Color of the road
int lastColorChange;  // Time of the last color change

PVector carPosition;  // Position of the car
PVector targetPosition;  // Target position for interpolation

ArrayList<PVector> obstaclePositions;  // Positions of the obstacle cars

int score = 0;  // Score counter
int lastScoreUpdate;  // Time of the last score update

boolean gameOver = false;  // Game over state
int gameOverTime;  // Time when game over occurred

Gif explosionGif;  // Explosion animation

void setup() {
  size(1000, 1000);
  
  carImage = loadImage("PlayerCar.png");
  obstacleImage = loadImage("ObstacleCar.png");
  explosionGif = new Gif(this, "Explosion.gif");
  
  laneY1 = -laneWidth;
  laneY2 = 0;
  laneY3 = height;
  laneY4 = height + laneWidth;
  
  roadColor = color(100);
  lastColorChange = millis();
  
  carPosition = new PVector(width / 2, height - roadHeight / 2 - carImage.height / 2);
  targetPosition = new PVector(carPosition.x, carPosition.y);
  
  obstaclePositions = new ArrayList<PVector>();
  
  lastScoreUpdate = millis();
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
  laneY1 += laneSpeed;
  laneY2 += laneSpeed;
  laneY3 += laneSpeed;
  laneY4 += laneSpeed;
  
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
  if (random(1) < 0.005) {  // Adjust the probability
    PVector obstaclePosition = new PVector(random(width/2 - roadHeight/2 + laneWidth, width/2 + roadHeight/2 - obstacleImage.width - laneWidth), -obstacleImage.height);
    
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
    obstaclePosition.y += obstacleSpeed;
    
    if (obstaclePosition.y > height) {
      obstaclePositions.remove(i);
      score += 1000;  // Add 1000 points for passing an obstacle car
    }
  }
  
  // Check for collision between player car and obstacle cars
  for (PVector obstaclePosition : obstaclePositions) {
    if (collisionDetected(carPosition.x, carPosition.y, carImage.width, carImage.height, obstaclePosition.x, obstaclePosition.y, obstacleImage.width, obstacleImage.height)) {
      gameOver = true;
      gameOverTime = millis();
      break;
    }
  }
  
  // Draw obstacle cars
  for (PVector obstaclePosition : obstaclePositions) {
    image(obstacleImage, obstaclePosition.x, obstaclePosition.y);
  }
  
  // Interpolate the car position for smooth movement
  float interpolationFactor = 0.1;  // Adjust the interpolation factor for smoothness
  
  carPosition.x = lerp(carPosition.x, targetPosition.x, interpolationFactor);
  carPosition.y = lerp(carPosition.y, targetPosition.y, interpolationFactor);
  
  // Draw the car
  image(carImage, carPosition.x, carPosition.y);
  
  // Update the score every 10 milliseconds
  if (millis() - lastScoreUpdate >= 10 && !gameOver) {
    score += 1;
    lastScoreUpdate = millis();
  }
  
  // Display the score
  textAlign(LEFT);
  textSize(24);
  fill(255);
  text("Score: " + score, 20, 40);
  
  // Check if game over
  if (gameOver) {
    // Display explosion at collision site
    float explosionX = carPosition.x + carImage.width / 2 - explosionGif.width / 2;
    float explosionY = carPosition.y + carImage.height / 2 - explosionGif.height / 2;
    image(explosionGif, explosionX, explosionY);
    
    // Display "YOU LOSE" message for 5 seconds
    int elapsedTime = millis() - gameOverTime;
    if (elapsedTime < 5000) {
      laneSpeed = 0;
      carSpeed = 0;
      obstacleSpeed = 0;
      textAlign(CENTER, CENTER);
      textSize(64);
      fill(255, 0, 0);
      text("YOU LOSE, Press SHIFT to reset", width / 2, height / 2);

    } else {
      // Reset the game
      resetGame();
    }
  }
}

void resetGame() {
  score = 0;
  carSpeed = 10;
  laneSpeed = 5;
  obstacleSpeed = 5;
  carPosition = new PVector(width / 2, height - roadHeight / 2 - carImage.height / 2);
  targetPosition = new PVector(carPosition.x, carPosition.y);
  obstaclePositions.clear();
  gameOver = false;
}

void keyPressed() {
  // Move the car left or right with arrow keys
  if (keyCode == LEFT) {
    targetPosition.x -= carSpeed;
    // Ensure the car stays within the left boundary of the road
    if (targetPosition.x < width / 2 - roadHeight / 2 + laneWidth / 2) {
      targetPosition.x = width / 2 - roadHeight / 2 + laneWidth / 2;
    }
  } else if (keyCode == RIGHT) {
    targetPosition.x += carSpeed;
    // Ensure the car stays within the right boundary of the road
    if (targetPosition.x > width / 2 + roadHeight / 2 - carImage.width - laneWidth / 2) {
      targetPosition.x = width / 2 + roadHeight / 2 - carImage.width - laneWidth / 2;
    }
  } else if (keyCode == UP) {
    carSpeed += 5;
    laneSpeed += 5;
    obstacleSpeed += 5;
  } else if (keyCode == DOWN) {
    carSpeed -= 5;
    laneSpeed -= 5;
    obstacleSpeed -= 5;
    
    // Ensure the speeds don't go below zero
    if (carSpeed < 0) {
      carSpeed = 0;
    }
    if (laneSpeed < 0) {
      laneSpeed = 0;
    }
    if (obstacleSpeed < 0) {
      obstacleSpeed = 0;
    }
  }
  else if (keyCode == SHIFT) {
    resetGame();
  }
}

color generateRandomColor() {
  return color(random(255), random(255), random(255));
}

boolean collisionDetected(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
  return x1 < x2 + w2 &&
         x1 + w1 > x2 &&
         y1 < y2 + h2 &&
         y1 + h1 > y2;
}

void dispose() {
  explosionGif.dispose();
}
