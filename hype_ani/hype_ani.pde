import de.looksgood.ani.*;
import hype.*;

float x, y;
int alpha = 255;

int[] anims = new int[10];

int apos = 0;

HRect rect1;

Show s;

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

  anims[0] = 5;

  s = new Show();
}

void draw() {
  rect1.loc(x, y).alpha(s.alpha);
  H.drawStage();
  println("s.alpha: "+s.alpha);
  println("s.anims[s.apos]: "+s.anims[s.apos]);
  println("s.anims[1]: "+s.anims[1]);
}

void mouseReleased() {
  Ani.to(this, 0.5, "x", mouseX, Ani.BOUNCE_OUT);
  Ani.to(this, 0.5, "y", mouseY, Ani.BOUNCE_OUT);
  s.startAnim();
}

class Show {
  int[] anims = new int[10];
  int apos = 0;
  Ani a1, a2;
  int alpha = 0;
  void startAnim() {
    println("startAnim!");
    anims[apos] = 255;
    alpha = 255;
    a1 = new Ani(this, 2, "anims[apos]", 0, Ani.BOUNCE_OUT);
    a2 = new Ani(this, 2, "alpha", 0, Ani.BOUNCE_OUT);
    anims[apos + 1] = 100;
  }
}