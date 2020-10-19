class Food{
  color colour;
  PVector pos;
  float size; 
  
  Food(color colour_, PVector pos_, float size_){
    colour = colour_;
    pos = pos_;
    size = size_;
  }

  void show(){
    fill(colour);
    ellipse(pos.x, pos.y, size,size);
  }
}
