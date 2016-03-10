import de.looksgood.ani.*;
import hype.*;

float x, y;

HRect rect1;

void setup() {
  size(1280,720);
  smooth();
  noStroke();
  Ani.init(this);

  H.init(this).background(#242424);

  rect1 = new HRect(100);
  rect1.rounding(10);         // set corner rounding
  rect1.strokeWeight(6);      // set stroke weight
  rect1.stroke(#000000, 150); // set stroke color and alpha
  rect1.fill(#FF6600);        // set fill color
  rect1.anchorAt(H.CENTER);   // set where anchor point is / key point for rotation and positioning
  rect1.rotation(45);         // set rotation of the rect
  rect1.loc(100,height / 2);  // set x and y location
  H.add(rect1);
}

void draw() {
  rect1.loc(x, y);
  H.drawStage();
}

void mouseReleased() {
  println("mouse!");
  Ani.to(this, 0.5, "x", mouseX, Ani.BOUNCE_OUT);
  Ani.to(this, 0.5, "y", mouseY, Ani.BOUNCE_OUT);
}