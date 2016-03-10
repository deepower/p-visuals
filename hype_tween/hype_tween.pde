import hype.*;
import hype.extended.colorist.HColorPool;
import hype.extended.behavior.HRotate;
import hype.extended.behavior.HTween;

HDrawablePool pool;
HColorPool colors;

import themidibus.*; //Import the library
MidiBus myBus; // The MidiBus

CurrentShow s;

void setup() {
  size(1280,720, P3D);
  s = new CurrentShow(this);
}

void draw() {
  s.draw();
}

void controllerChange(int channel, int number, int value) {
  if (s != null) {
    s.controllerChange(channel, number, value);
  }
}

void noteOn(int channel, int pitch, int velocity) {
  if (s != null) {
    s.noteOn(channel, pitch, velocity);
  }
}

class DeepShow {
  int knobsNum = 12;

  float knobs[] = new float[knobsNum+1];

  HColorPool colors = new HColorPool(#FFFFFF, #F7F7F7, #0095a8, #00616f, #FF3300, #FF6600);

  void setupSpecific(PApplet applet) {
  }

  void setup(PApplet applet) {
    setupSpecific(applet);
    connectMIDI(applet);
    println("knobs: "+knobs);
  }
  void connectMIDI(PApplet applet) {
    MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
    myBus = new MidiBus(applet, 0, 2); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  }
  void draw() {
  }
  void resetScene() {
  }
  void controllerChange(int channel, int number, int value) {
    // Receive new value on knob modification
    if(number < knobsNum) {
      knobs[number] = value/127.000;
    }
  }
  void noteOn(int channel, int pitch, int velocity) {
    // Reset the scene when received this note
    if (channel == 0 && pitch == 0) {
      resetScene();
    }
  }
}

class CurrentShow extends DeepShow {
  float cameraRotationX;
  float cameraRotationY;
  float cameraRotationZ;

  HRect  r1, r2, r3;

  HTween t1a, t1b;
  HTween t2a, t2b;
  HTween t3a, t3b, t3c, t3d;

  CurrentShow(PApplet applet) {
    setup(applet);
  }
  void setupSpecific(PApplet applet) {
    H.init(applet).background(#000000).use3D(true);
    blendMode(ADD);
    translate(width/2, height/2, 0);
    smooth();
    
    r1 = new HRect(100).rounding(10);
    r1
    .stroke(#000000, 100)
    .fill(#FF9900)
    .anchorAt(H.CENTER)
    .loc(125,125)
    .rotation(45)
    ;
    H.add(r1);

    t1a = new HTween()
    .target(r1).property(H.LOCATION)
    .start( r1.x(), r1.y() )
    .end( r1.x(), height - 125 )
    .ease(0.4)
    .spring(0.6)
    ;

  t1b = new HTween()
    .target(r1).property(H.ALPHA)
    .start(255)
    .end(0)
    .ease(0.6)
    .spring(0.9)
    ;

  // Rect 2 and tweens

  H.add(r2 = new HRect(100)).rounding(10).stroke(#000000, 100).fill(#FF6600).anchorAt(H.CENTER).loc(width/2,125).rotation(45);

  t2a = new HTween().target(r2).property(H.LOCATION).start( r2.x(), r2.y() ).end( r2.x(), height - 125 ).ease(0.005).spring(0.95);
  t2b = new HTween().target(r2).property(H.SCALE).start(0).end(1).ease(0.005).spring(0.95);

  // Rect 3 and tweens

  H.add(r3 = new HRect(100)).rounding(10).stroke(#000000, 100).fill(#FF3300).anchorAt(H.CENTER).loc(width-125,125).rotation(45);

  t3a = new HTween().target(r3).property(H.LOCATION).start( r3.x(), r3.y() ).end( r3.x(), height - 125 ).ease(0.005).spring(0.95);
  t3b = new HTween().target(r3).property(H.SCALE).start(0).end(1).ease(0.005).spring(0.95);
  t3c = new HTween().target(r3).property(H.ALPHA).start(0).end(255).ease(0.005).spring(0.95);
  t3d = new HTween().target(r3).property(H.ROTATION).start(-45).end(405).ease(0.005).spring(0.95);

}
void draw() {
  rotateX(cameraRotationX);
  rotateY(cameraRotationY);
  rotateZ(cameraRotationZ);
  H.drawStage();
}
void resetScene() {
  float kx = random(-2, 2)/8;
  float ky = random(0, 2)/8;
  cameraRotationX = PI*kx;
  cameraRotationY = PI*ky;
}
void noteHat() {

}
void noteOn(int channel, int pitch, int velocity) {
    // Reset the scene when received this note
    if (channel == 0 && pitch == 0) {
      resetScene();
    } else if (channel == 0 && pitch == 1) {
      noteHat();
    }
  }
}