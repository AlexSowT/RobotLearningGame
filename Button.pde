class Button{
 boolean on ;
 float x, y;
 
 Button(float x_, float y_){
   on = false;
   x = x_;
   y = y_;
 
 }
  
  void display(){
    if(contains(mouseX,mouseY)){
      fill(#EAA313);
    } else {
      fill(255,255,0,50);
    }
    ellipse(x,y,100,100);
  
  }
  
  boolean contains(float xPos, float yPos){
    boolean con = false;
    if(dist(xPos, yPos, x, y)<50){
      fill(255,255,0,255);
      con = true;
    }
    return con;
  }
  
  void buttonText(String msg){
    fill(0);
    text(msg,x,y);
  
  }

}
