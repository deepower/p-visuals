import de.looksgood.ani.*;
import hype.*;

float x, y;
int alpha = 255;

int[] anims = new int[10];

int apos = 0;

DRect rect1;

void setup() {
  size(1280,720);
  smooth();
  noStroke();
  Ani.init(this);

  H.init(this).background(#242424);

  rect1 = new DRect(100);
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
  rect1.animDraw();
  H.drawStage();
}

void mouseReleased() {
  rect1.animStart();
}

class DRect extends HRect {
  float x, y;
  int alpha;
  Ani a1, a2, a3;

  DRect(int size) {
    super(size);
  }
  void animStart() {
    alpha = 0;
    a1 = new Ani(this, 0.5, "x", mouseX, Ani.CIRC_IN_OUT);
    a2 = new Ani(this, 0.5, "y", mouseY, Ani.CIRC_IN_OUT);
    a3 = new Ani(this, 0.5, "alpha", 255, Ani.CIRC_IN_OUT);
  }
  void animDraw() {
    rect1.loc(x, y).alpha(alpha);
  }
} 