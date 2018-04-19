class dot
{
  int x,y; // location
  int speed; // number of pixles per frame 
  int direction; // +1 or -1
  boolean turned = false;
  
  dot()
  {
  }
  
  void init(int d)
  {
    direction = d;
    x = width/2;
    y = height/2;
  }
  
  void animate(int s)
  {
    speed = s;
    x += direction * speed;
    if(x > (width-dotsize))
    {
      direction = -1*direction; // change direction
      turned = true;
    }
    if(x<(dotsize))
    {
      direction = -1*direction; // change direction
      turned = true;  
    }
    fill(255); // draw a dot
    noStroke();
    ellipse(x, y, dotsize, dotsize);
  }
  
  void stay(){
    fill(255); // draw a dot
    noStroke();
    ellipse(x, y, dotsize, dotsize);
  }
}
