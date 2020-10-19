class Hub {
  PVector pos;
  color colour;
  float foodRadius;
  float size;
  int[] foodAmount = new int[2];
  int foodInRadius, maxFood;
  ArrayList<Food> food = new ArrayList<Food>();


  Hub(PVector pos_, color colour_) {
    pos = pos_;
    colour = colour_;
    size = 30;
    foodRadius = 100;
    foodAmount[0] = 0;   
    foodAmount[1] = 0;
    foodInRadius = 0;
    maxFood = 20;
  }

  void show() {
    fill(colour);
    rect(pos.x, pos.y, size, size);
  }

  boolean contains() {
    boolean hit = false;
    if (mouseX > pos.x && mouseX < pos.x+size && mouseY > pos.y && mouseY < pos.y+(size)) {
      hit = true;
      //println("Hit");
    }
    return hit;
  }

  void showFood() {
    for (Food f : food) {
      f.show();
    }
  }
}
