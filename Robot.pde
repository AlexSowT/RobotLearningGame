class Robot
{
  PVector position;   // Position of the robot.
  PVector velocity; // Amount it moves on each redraw.
  PVector acc;
  float size;         // Size of robot.
  color colour;       // Colour of robot.
  float age;
  float sec;
  float maxspeed, maxforce;
  int birthAmount;
  int foodAmount;
  int maxFood;
  float[] DNA = new float[4] ;


  // Initialises the robot's state.
  Robot(PVector pos, float size_, color col, boolean birth_, int age_)
  {
    position = pos;
    velocity = new PVector(random(-4, 4), random(-4, 4));
    acc = new PVector(0, 0);
    age = age_;
    sec = 0;
    size = size_;
    colour = col;
    birthAmount = floor(random(1, 3));
    //[0] - Chance to breed with grey, [1] Chance to capture with grey [ 2] - Chance to breed with without grey [3] - Chance to capture w/ grey
    //Per Robot DNA not currently implemented, using a team wide DNA right now.
    DNA[0] = random(0, 1);
    DNA[1] = 1 - DNA[0];
    DNA[2] = random(0, 1);
    DNA[3] = 1 - DNA[2];

    maxspeed =3;
    maxforce  = 0.5;
    foodAmount = 0;
    maxFood = 10;

  }

  // Draws the robot at its current position.
  void show()
  {
    noStroke();
    fill(colour);
    ellipse(position.x+size/2.5, position.y-size/2, size*1.5, size*1.5);
    rect(position.x-size, position.y, size*2.8, size/3);
    rect(position.x, position.y, size, size*1.5);
    rect(position.x - size/4, position.y, size/3, size*2);
    rect(position.x + 3*size/4, position.y, size/3, size*2);
    fill(255);
    ellipse(position.x+size/7.5, position.y-size/2, size/3, size/3);
    ellipse(position.x+size/1.5, position.y-size/2, size/3, size/3);
  }

  //Updates the robots position, according to the velocity, and updates the velocity
  // according to the acc. 
  void move()
  {
    velocity.add(acc);
    velocity.limit(maxspeed);
    position.add(velocity);
    acc.mult(0);
  }

  //Used to increase the acc. 
  void applyForce(PVector force) {
    acc.add(force);
  }

  // Creates the vector of acc that the robot will follow. See Steering Behaviours - Dan(Coding Train) 
  void seek(PVector target) {
    PVector desired = PVector.sub(target, position);
    desired.setMag(maxspeed);
    PVector steering =  PVector.sub(desired, velocity);
    steering.limit(maxforce);
    applyForce(steering);
  }

  //Detects if the robot has collided with whatever position is passed in as a paramater
  boolean collide(PVector pos) {
    boolean hit = false;
    if (position.x > pos.x && position.x < pos.x+size && position.y > pos.y && position.y < pos.y+(size*1.5)) {
      hit = true;
    }
    return hit;
  }

  boolean hubCollide(PVector pos, float size_) {
    boolean hit = false;
    if (position.x > pos.x && position.x < pos.x+size_ && position.y > pos.y && position.y < pos.y+size_) {
      hit = true;
      //println("Hit");
    }
    return hit;
  }

  //Keeps track of how long a robot has been on the screen in seconds, not used but useful. 
  float checkAge() {
    sec++;
    sec/=60;
    age += sec; 
    return age;
  }

  boolean contains() {
    boolean hit = false;
    if (mouseX > position.x && mouseX < position.x+size && mouseY > position.y && mouseY < position.y+(size)) {
      hit = true;
      //println("Hit");
    }
    return hit;
  }

  //Handels the transaction of food between the Robots and the Hubs. 
  void depositFood(int hubIndex) {
    foodAmount-=10;
    if (colour == color(255, 0, 0)) {
      hub[hubIndex].foodAmount[0]+=10;
    } else if (colour == color(0, 255, 0)) {
      hub[hubIndex].foodAmount[1]+=10;
    }
  }


  //Finds the closest food to the robot, and returns the index of the hub it is around and its own index. 
  int[] findClosestFood() {
    float closest = 10000;
    int[] closestIndex= new int[2];
    closestIndex[0] = -1;
    closestIndex[1] = -1;

    for (int hubID = 0; hubID < hub.length; hubID++) {
      for (int i = 0; i < hub[hubID].food.size(); i++) {
        Food f = hub[hubID].food.get(i);
        float distance = dist(position.x, position.y, f.pos.x, f.pos.y);
        if (distance < closest && colour == f.colour) {
          closest = distance;
          closestIndex[0] = i;
          closestIndex[1] = hubID;
        }
      }
    }
    return closestIndex;
  }
}
