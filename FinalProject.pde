import processing.serial.*;
import gifAnimation.*;


PImage explosionImage;  // Image of the explosion

Car carCreator = new Car();
BackgroundForProject laneCreator = new BackgroundForProject(10, 5, 0); 

PVector targetPosition;  // Target position for interpolation

ArrayList<PVector> obstaclePositions;  // Positions of the obstacle cars

int highScore;
String[] highScoreSaver = new String[1]; 
int score = 0;  // Score counter
int lastScoreUpdate;  // Time of the last score update

boolean gameOver = false;  // Game over state
int gameOverTime;  // Time when game over occurred

Gif explosionGif;  // Explosion animation



void setup() {
  size(1000, 1000);
  
  carCreator.carImage = loadImage("PlayerCar.png");
  carCreator.obstacleImage = loadImage("ObstacleCar.png");
  explosionGif = new Gif(this, "Explosion.gif");
  
  laneCreator.lastColorChange = millis();
  
  carCreator.carPosition = new PVector(width / 2, height - laneCreator.roadHeight / 2 -  carCreator.carImage.height / 2);
  targetPosition = new PVector( carCreator.carPosition.x,  carCreator.carPosition.y);
  
  obstaclePositions = new ArrayList<PVector>();
  
  lastScoreUpdate = millis();
  highScore = Integer.parseInt(loadStrings("highscore.txt") [0]);
  
}

void draw() {
  
  
  
  
  laneCreator.backgroundColorCheck ();
  
  laneCreator.DrawRoad();
  
  
  // Draw moving lanes
  laneCreator.DrawLanes(); 
  
  
  // Update lane positions
  laneCreator.laneY1 += laneCreator.laneSpeed;
  
  
  // Wrap around the moving lanes
  if (laneCreator.laneY1  > height ) {
    laneCreator.laneY1 = 0;
  }
  
  
  // Generate new obstacle cars randomly

 
 carCreator.randomizeOpposition(obstaclePositions);
  
  // Update obstacle car positions and remove off-screen obstacle cars
  for (int i = obstaclePositions.size() - 1; i >= 0; i--) {
    PVector obstaclePosition = obstaclePositions.get(i);
    obstaclePosition.y +=  carCreator.obstacleSpeed;
    
    if (obstaclePosition.y > height) {
      obstaclePositions.remove(i);
      score += 1000;  // Add 1000 points for passing an obstacle car
    }
  }
  
  // Check for collision between player car and obstacle cars
  for (PVector obstaclePosition : obstaclePositions) {
    if (carCreator.collisionDetected( obstaclePosition.x, obstaclePosition.y)) {
      gameOver = true;
      gameOverTime = millis();
      break;
    }
  }
  
  // Draw obstacle cars
  for (PVector obstaclePosition : obstaclePositions) {
    image( carCreator.obstacleImage, obstaclePosition.x, obstaclePosition.y);
  }
  
  // Interpolate the car position for smooth movement
  float interpolationFactor = 0.1;  // Adjust the interpolation factor for smoothness
  
   carCreator.carPosition.x = lerp( carCreator.carPosition.x, targetPosition.x, interpolationFactor);
   carCreator.carPosition.y = lerp( carCreator.carPosition.y, targetPosition.y, interpolationFactor);
  
  // Draw the car
  image( carCreator.carImage,  carCreator.carPosition.x,  carCreator.carPosition.y);
  
  // Update the score every 10 milliseconds
  if (millis() - lastScoreUpdate >= 10 && !gameOver) {
    score += 1;
    lastScoreUpdate = millis();
    if (score > highScore) {
      highScore = score;
    }
  }
  
  
  // Display the score
  textAlign(LEFT);
  textSize(24);
  fill(255);
  text("Score: " + score, 20, 40);
  
  textAlign(LEFT);
  textSize(24);
  fill(255); 
  text("Previous High Score: " + highScore, 20, 60);
  
  
  // Check if game over
  if (gameOver) {
    // Display explosion at collision site
    float explosionX =  carCreator.carPosition.x +  carCreator.carImage.width / 2 - explosionGif.width / 2;
    float explosionY =  carCreator.carPosition.y +  carCreator.carImage.height / 2 - explosionGif.height / 2;
    image(explosionGif, explosionX, explosionY);
    
    // Display "YOU LOSE" message for 5 seconds
    int elapsedTime = millis() - gameOverTime;
    if (elapsedTime < 5000) {
      laneCreator.laneSpeed = 0;
       carCreator.carSpeed = 0;
       carCreator.obstacleSpeed = 0;
      textAlign(CENTER, CENTER);
      textSize(64);
      fill(255, 0, 0);
      text("YOU LOSE, Press SHIFT to reset", width / 2, height / 2);
      
      highScoreSaver[0] = Integer.toString(highScore);
      saveStrings("highscore.txt", highScoreSaver);

    } else {
      // Reset the game
      resetGame();
    }
  }
}

void resetGame() {
  score = 0;
   carCreator.carSpeed = 10;
  laneCreator.laneSpeed = 5;
   carCreator.obstacleSpeed = 5;
   carCreator.carPosition = new PVector(width / 2, height - laneCreator.roadHeight / 2 -  carCreator.carImage.height / 2);
  targetPosition = new PVector( carCreator.carPosition.x,  carCreator.carPosition.y);
  obstaclePositions.clear();
  gameOver = false;
}

void keyPressed() {
  // Move the car left or right with arrow keys
  if (keyCode == LEFT) {
    targetPosition.x -=  carCreator.carSpeed;
    // Ensure the car stays within the left boundary of the road
    if (targetPosition.x < width / 2 - laneCreator.roadHeight / 2 + laneCreator.laneWidth / 2) {
      targetPosition.x = width / 2 - laneCreator.roadHeight / 2 + laneCreator.laneWidth  / 2;
    }
  } else if (keyCode == RIGHT) {
    targetPosition.x +=  carCreator.carSpeed;
    // Ensure the car stays within the right boundary of the road
    if (targetPosition.x > width / 2 + laneCreator.roadHeight / 2 -  carCreator.carImage.width - laneCreator.laneWidth  / 2) {
      targetPosition.x = width / 2 + laneCreator.roadHeight / 2 -  carCreator.carImage.width - laneCreator.laneWidth  / 2;
    }
  } else if (keyCode == UP) {
    
     carCreator.carSpeed += 5;
    laneCreator.laneSpeed += 5;
     carCreator.obstacleSpeed += 5;
  } else if (keyCode == DOWN) {
     carCreator.carSpeed -= 5;
    laneCreator.laneSpeed -= 5;
     carCreator.obstacleSpeed -= 5;
    
    // Ensure the speeds don't go below zero
    if ( carCreator.carSpeed < 0) {
       carCreator.carSpeed = 0;
    }
    if (laneCreator.laneSpeed < 0) {
      laneCreator.laneSpeed = 0;
    }
    if ( carCreator.obstacleSpeed < 0) {
       carCreator.obstacleSpeed = 0;
    }
  }
  else if (keyCode == SHIFT) {
    resetGame();
  }
}

void dispose() {
  explosionGif.dispose();
}