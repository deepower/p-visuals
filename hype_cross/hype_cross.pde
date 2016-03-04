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

  HRect rDrums, rBass;
  float drumSize;

  int hatPosition;
  int hatsCount = 10;

  HRect[] hats = new HRect[hatsCount];

  float hatDuration = 0.2;

  HTween t1a, t2a;

  CurrentShow(PApplet applet) {
    setup(applet);
  }
  void setupSpecific(PApplet applet) {
    H.init(applet).background(#000000).use3D(true);
    ortho();
    translate(width/2, height/2, 0);
    smooth();
    
    rDrums = new HRect(width*3);

    rDrums
      .noStroke()
      .fill(colors.getColor())
      .loc(width/2, height/2)
      .anchorAt(H.CENTER)
    ;

    H.add(rDrums);
    
    rBass = new HRect(width*3);

    rBass
      .noStroke()
      .fill(colors.getColor())
      .loc(width/2, height/2, 10)
      .anchorAt(H.CENTER)
    ;

    H.add(rBass);

    for (int i = 0; i < hats.length; ++i) {
      hats[i] = new HRect(width*3);
      hats[i]
        .noStroke()
        .fill(#FF9900)
        .loc(width/2 + random(-width/2, width/2), height/2, 20 + i)
        .anchorAt(H.CENTER)
        .size(width/50, height*3)
      ;
      H.add(hats[i]);
    }

  }
  void draw() {
    rotateX(cameraRotationX);
    rotateY(cameraRotationY);
    rotateZ(cameraRotationZ);
    rDrums.width(width*map(knobs[0], 0, 1, 0.2, 1));
    rBass.height(height*map(knobs[1], 0, 1, 0.2, 1));
    H.drawStage();
  }
  void resetScene() {
    float kx = random(-1, 1)/8;
    float ky = random(0, 1)/8;
    drumSize = random(0, 1);
    /*
    cameraRotationX = PI*kx;
    cameraRotationY = PI*ky;
    */
  }
  void noteHat() {
    hatPosition++;
    if (hatPosition > (hatsCount-1)) {
      hatPosition = 0;
    }

    println("hatPosition: "+hatPosition);

    t1a = new HTween()
      .target(hats[hatPosition]).property(H.SCALE)
      .start( 0 )
      .end( 1 )
      .ease(0.9)
      .spring(0.95)
    ;

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