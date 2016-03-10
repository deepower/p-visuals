import de.looksgood.ani.*;

float x = 256;
float y = 256;
int diameter = 50;

void setup() {
  size(1280,720);
  smooth();
  noStroke();
  Ani.init(this);
}

void draw() {
  background(255);
  fill(0);
  ellipse(x,y,diameter,diameter);
}

void mouseReleased() {
  println("mouse!");
  Ani.to(this, 1.0, "x1", mouseX, Ani.BOUNCE_OUT);
  Ani.to(this, 1.0, "y", mouseY, Ani.BOUNCE_OUT);
}