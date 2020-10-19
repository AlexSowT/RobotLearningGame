ArrayList<Robot> robots = new ArrayList<Robot>();
Hub[] hub = new Hub[20];
int robotNum =50;
int foodNum = 100;
int foodSize = 5;
int botMax = 80;
int bNum;
int rNum;
int gNum;
int botSize;
int greenWin, redWin;
int maxFood = 20;
int lifeSpan;
int fertileSpan;
int growAge;
Button addRob;
String msg1;
int msg2;
boolean paused = false;
float mouseXInit, mouseYInit;
float[] greenDNA = new float[1];
float[] redDNA = new float[1];


void setup()
{
  //fullScreen();
  size(800, 800);
  textAlign(CENTER, CENTER);
  textSize(15);

  greenWin = 0;
  redWin = 0;
  redDNA[0] = random(1);
  greenDNA[0] = random(1);
  lifeSpan = 35;
  fertileSpan = 30;
  growAge = 5;
  msg1 = "Add Bot";
  addRob = new Button(width-75, 100);
  botSize = 5;

  restartGame();
}
//Handels the main loop of the program. 
void draw() {
  background(51);
  
  checkWin();
  drawUI();
  updateBots();
  countBots();
  updateHub();

  if (!paused) {
    hubChangeColour();
    botBirth();
    
    for (int i = 0; i < hub.length; i++) {
      if (hub[i].food.size()<maxFood) {
        if (hub[i].colour == color(255, 0, 0) ) {
          addFood(color(255, 0, 0), hub[i]);
          hub[i].foodInRadius++;
        } else if (hub[i].colour == color(0, 255, 0)) {
          addFood(color(0, 255, 0), hub[i]);
          hub[i].foodInRadius++;
        }
      }
    }
  }
}

//Used to add a bot of any colour to the Robots ArrayList.
void addBot(color colour) {
  if (robots.size()<botMax) {
    for (int i = 0; i < hub.length; i++) {
      if (hub[i].colour == colour) {
        robots.add(new Robot(new PVector(random((hub[i].pos.x+hub[i].size/2)-50, (hub[i].pos.x+hub[i].size/2)+50), random((hub[i].pos.y+hub[i].size/2)-50, (hub[i].pos.y+hub[i].size/2)+50)), botSize, colour, true, 0));
      }
    }
  }
}
//Spawns a bot at a specific hub. 

void spawnBot(color colour, int id) {
  if (robots.size()<botMax) {    
    robots.add(new Robot(new PVector(random((hub[id].pos.x+hub[id].size/2)-50, (hub[id].pos.x+hub[id].size/2)+50), random((hub[id].pos.y+hub[id].size/2)-50, (hub[id].pos.y+hub[id].size/2)+50)), botSize, colour, true, 0));
  }
}

//Shows the hubs.
void updateHub() {
  for (int i = 0; i < hub.length; i++) {
    hub[i].show();
    hub[i].showFood();
  }
}

//Runs all the functions used to update the robots, that is showing them, moving them, and their logics. 
void updateBots() {
  for (int i = 0; i < robots.size(); i++) {
    Robot robot = robots.get(i);
    robot.show();
    removeFood(i);

    if (!paused) {
      applySteering(i);
      robot.move();
      botDeposit();
    }
  }
}


void mousePressed() {
  //Add Robot button
  if (addRob.contains(mouseX, mouseY)) {
    addBot(color(255, 0, 0));
  }
  //Checks if the mouse is over a robot.
  for (int i = 0; i < robots.size(); i++) {
    Robot robot = robots.get(i);
    if (robot.contains()) {
      //println("Robot Colour: "+ robot.colour + "/n Robot Birth: "+ robot.birth + "/n Robot Added: " + robot.added);
    }
  }
}

//Pauses the game if any key is pressed
void keyPressed() {
  if (paused) {
    paused = false;
    save("robot1.jpg");
  } else {
    paused = true;
  }
}

//This method draws every aspect of the ui, the text, button, and sideline display.
void drawUI() {
  msg2 = robots.size();

  stroke(0);
  strokeWeight(5);
  line(width-150, 0, width-150, height);
  fill(0);
  text("Number of Robots: " + "\n" + msg2, width-75, 200 );
  text("Red Bots: " + rNum, width-75, 275 );
  text("Green Bots: " + gNum, width-75, 300 );
  addRob.display();
  addRob.buttonText(msg1);

  //If mouse is over a bot, shows how much food it is carrying.
  for (int i=0; i<robots.size(); i++) {
    Robot bot = robots.get(i);
    if (bot.contains()) {
      text(bot.foodAmount, width-75, 325);
    }
    
    pushStyle();
    fill(255, 0, 0);
    textSize(40);
    text(redWin, width-100, 400);
    fill(0, 255, 0);
    textSize(40);
    text(" : " +greenWin, width-50, 400);
    popStyle();
  }

// If mouse is over a hub, shows how much food it contains and the amount of food in its ArrayList.
  for (int i = 0; i <hub.length; i++) {
    if (hub[i].contains()) {
      text("Red Food: " +hub[i].foodAmount[0], width-75, 325);
      text("Green Food: " +hub[i].foodAmount[1], width-75, 350);
      text("Food in Raduis: " +hub[i].foodInRadius, width-75, 375);
    }
  }

  text("gDNA: " + greenDNA[0], width-75, 450);
  text("rDNA: " + redDNA[0], width-75, 475);
}

//Runs the robot.steering() method, with the paramater detemined in the method. 
//Calls apon findClosestHub/Food() method to determine what vector should be applied to the 
//robot.
void applySteering(int botIndex) {
  Robot bot = robots.get(botIndex);

  if (bot.foodAmount == bot.maxFood) {
    if (findClosestHub(botIndex) != -1) {
      int hubIndex = findClosestHub(botIndex);
      bot.seek(new PVector(hub[hubIndex].pos.x+hub[hubIndex].size/2, hub[hubIndex].pos.y+hub[hubIndex].size/2));
    }
  } else {
    for (int i = 0; i < hub.length; i++) {
      if (bot.findClosestFood()[0] != -1) {
        Food closestFood = hub[bot.findClosestFood()[1]].food.get(bot.findClosestFood()[0]);
        bot.seek(new PVector(closestFood.pos.x, closestFood.pos.y));
      }
    }
  }
}


//Finds the closest hub and runs through the logic of the game, this is where most of the logic happens, and possibly this should be re-written.
int findClosestHub(int botIndex) {
  float closest = 100000;
  int closestIndex= -1;
  Robot bot = robots.get(botIndex);

  if (bot.colour == color(255, 0, 0)) {
    if (redDNA[0] > random(1)) {
      for (int i = 0; i < hub.length; i++) {
        float distance = dist(bot.position.x, bot.position.y, hub[i].pos.x, hub[i].pos.y);
        //Capturing AI
        if (countGrey() > 0) {
          if (distance < closest && hub[i].colour == color(110)) {
            closest = distance;
            closestIndex = i;
          }
        } else if (bot.colour == color(255, 0, 0)) {
          if (distance < closest && hub[i].colour == color(0, 255, 0)) {
            closest = distance;
            closestIndex = i;
          }
        }
      }
      // Breading
    } else {
      for (int i = 0; i < hub.length; i++) {
        float distance = dist(bot.position.x, bot.position.y, hub[i].pos.x+hub[i].size/2, hub[i].pos.y+hub[i].size/2);
        if (distance < closest && hub[i].colour == color(255, 0, 0)) {
          closest = distance;
          closestIndex = i;
        }
      }
    }
  } else if (bot.colour == color(0, 255, 0)) {
    if (greenDNA[0] > random(1)) {
      for (int i = 0; i < hub.length; i++) {
        float distance = dist(bot.position.x, bot.position.y, hub[i].pos.x+hub[i].size/2, hub[i].pos.y+hub[i].size/2);
        //Capturing AI
        if (countGrey() > 0) {
          if (distance < closest && hub[i].colour == color(110)) {
            closest = distance;
            closestIndex = i;
          }
        } else if (bot.colour == color(0, 255, 0)) {
          if (distance < closest && hub[i].colour == color(255, 0, 0)) {
            closest = distance;
            closestIndex = i;
          }
        }
      }
      // Breading
    } else {
      for (int i = 0; i < hub.length; i++) {
        float distance = dist(bot.position.x, bot.position.y, hub[i].pos.x+hub[i].size/2, hub[i].pos.y+hub[i].size/2);
        if (distance < closest && hub[i].colour == color(0, 255, 0)) {
          closest = distance;
          closestIndex = i;
        }
      }
    }
  }
  return closestIndex;
}



void addFood(color c, Hub hub) {
  //int sec = (frameCount/60)%60;
  //if (sec == 3)
  //hubCountFoodRadius(hub);
  hub.food.add(new Food(c, new PVector(random((hub.pos.x+hub.size/2)-hub.foodRadius, (hub.pos.x+hub.size/2)+hub.foodRadius ), random((hub.pos.y+hub.size/2)-hub.foodRadius, (hub.pos.y+hub.size/2)+hub.foodRadius )), foodSize));
}

void countBots() {
  rNum = 0;
  gNum = 0;
  bNum = 0;
  for (Robot bot : robots) {
    if (bot.colour == color(255, 0, 0)) {
      rNum++;
    } else if (bot.colour == color(0, 255, 0)) {
      gNum++;
    } else if (bot.colour == color(0, 0, 255)) {
      bNum++;
    }
  }
}

void botDeposit() {
  for (int i = robots.size()-1; i >= 0; i--) {
    Robot bot = robots.get(i);
    if (bot.foodAmount == bot.maxFood) {
      if (findClosestHub(i) != -1 && countRed() != hub.length || countGreen() != hub.length) {
        if (bot.hubCollide(hub[findClosestHub(i)].pos, hub[findClosestHub(i)].size)) {
          bot.depositFood(findClosestHub(i));
        } else {
        }
      }
    }
  }
}

void hubChangeColour() {
  for (int i = 0; i < hub.length; i++) {
    if (hub[i].foodAmount[0] >= 100 && hub[i].colour != color(255, 0, 0)) {
      hub[i].colour = color(255, 0, 0);
      hub[i].foodAmount[0] = 0;
      hub[i].foodAmount[1] = 0;
    } else  if (hub[i].foodAmount[1] >= 100&& hub[i].colour != color(0, 255, 0)) {
      hub[i].colour = color(0, 255, 0);
      hub[i].foodAmount[0] = 0;
      hub[i].foodAmount[1] = 0;
    }
  }
}

void botBirth() {
  for (int i = 0; i < hub.length; i++) {
    if (hub[i].foodAmount[0] >= 100 && hub[i].colour == color(255, 0, 0)) {
      spawnBot(color(255, 0, 0), i);
      hub[i].foodAmount[0] = 0;
      hub[i].foodAmount[1] = 0;
    } else if (hub[i].foodAmount[1] >= 100 && hub[i].colour == color(0, 255, 0)) {
      spawnBot(color(0, 255, 0), i);
      hub[i].foodAmount[0] = 0;
      hub[i].foodAmount[1] = 0;
    }
  }
}


void removeFood(int botIndex) {
  Robot bot = robots.get(botIndex);
  for (int j = 0; j <hub.length; j++) {
    for (int i = hub[j].food.size()-1; i >= 0; i--) {
      Food f = hub[j].food.get(i);
      if (bot.foodAmount < bot.maxFood ) {
        if (dist(bot.position.x, bot.position.y, f.pos.x, f.pos.y) < f.size && bot.colour == f.colour) {
          hub[j].food.remove(f);
          hub[j].foodInRadius--;
          bot.foodAmount++;
        }
      }
    }
  }
}

int countGrey() {
  int greyCount = 0;
  for (int i = 0; i < hub.length; i++) {
    if (hub[i].colour == color(110)) {
      greyCount++;
    }
  }
  return greyCount;
}

int countGreen() {
  int count = 0;
  for (int i = 0; i < hub.length; i++) {
    if (hub[i].colour == color(0, 255, 0)) {
      count++;
    }
  }
  return count;
}

int countRed() {
  int count = 0;
  for (int i = 0; i < hub.length; i++) {
    if (hub[i].colour == color(255, 0, 0)) {
      count++;
    }
  }
  return count;
}
void checkWin() {
  if (countRed() == hub.length) {
    //greenDNA[0] = redDNA[0];
    greenDNA[0] = random(1);
    redWin++;
    restartGame();
  } else if (countGreen() == hub.length) {
    //redDNA[0] = greenDNA[0];
    redDNA[0] = random(1);
    greenWin++;
    restartGame();
  }
}

void restartGame() {
  for (int i = robots.size()-1; i >= 0; i--) {
    robots.remove(i);
  }

  hub[0] =  new Hub(new PVector(width/2-50, 100), color(255, 0, 0));
  hub[1] =  new Hub(new PVector(width/2-50, height-100), color(0, 255, 0));
  for (int i = 2; i < hub.length; i++) {
    hub[i] =  new Hub(new PVector(random(0, width-200), random(150, height-150)), color(110));
  }

  for (int i = 0; i < robotNum; i++) {
    if (i < robotNum/2) {
      addBot(color(255, 0, 0));
      //} //else if (random(1) > 0.) {
      //addBot(color(0, 0, 255));
    } else {
      addBot(color(0, 255, 0));
    }
  }
}
