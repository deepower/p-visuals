import hype.*;
import de.looksgood.ani.*;
import codeanticode.syphon.*;

SyphonServer server;

import themidibus.*; //Import the library
MidiBus myBus; // The MidiBus

CurrentShow s;

int showW = 2560;
int showH = 720;

void settings() {
  size(showW, showH, P3D);
  PJOGL.profile=1;
}

void setup() {
  s = new CurrentShow(this);
  server = new SyphonServer(this, "Processing Syphon");
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

  DRect[] hats = new DRect[hatsCount];

  float hatDuration = 0.2;

  int at;

  CurrentShow(PApplet applet) {
    setup(applet);
  }
  void setupSpecific(PApplet applet) {
    H.init(applet).background(#000000).use3D(true);
    blendMode(ADD);
    translate(width/2, height/2, 0);
    smooth();

    Ani.init(applet);
    
    rDrums = new HRect(width*3);

    rDrums
      .noStroke()
      .fill(#bb0000)
      .loc(width*0.25, height/2)
      .anchorAt(H.CENTER)
    ;

    H.add(rDrums);
    
    rBass = new HRect(width*3);

    rBass
      .noStroke()
      .fill(#0040ff)
      .loc(width*0.75, height/2, 10)
      .anchorAt(H.CENTER)
    ;

    H.add(rBass);

    for (int i = 0; i < hats.length; ++i) {
      hats[i] = new DRect(width*3);
      hats[i]
        .noStroke()
        .fill(#ffffff)
        .anchorAt(H.CENTER)
        .size(width/10, height*3)
        .alpha(255)
      ;
      H.add(hats[i]);
    }

    fill(255);
    ellipse(50, 50, 100, 100);

  }
  void draw() {
    rotateX(cameraRotationX);
    rotateY(cameraRotationY);
    rotateZ(cameraRotationZ);
    rDrums.width(width*map(knobs[0], 0, 1, 0.01, 0.3));
    rBass.width(width*map(knobs[1], 0, 1, 0.01, 0.15));
    for (int i = 0; i < hats.length; ++i) {
      hats[i].animDraw();
    }
    H.drawStage();
    server.sendScreen();
  }
  void resetScene() {
    float kx = random(-2, 2)/8;
    float ky = random(0, 2)/8;
    drumSize = random(0, 1);
    cameraRotationX = PI*kx;
    cameraRotationY = PI*ky;
  }
  void noteHat() {
    hatPosition++;
    if (hatPosition > (hatsCount-1)) {
      hatPosition = 0;
    }

    hats[hatPosition].animStart();

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

class DRect extends HRect {
  float xscale, xwidth;
  int alpha;
  Ani a1, a2, a3;

  DRect(int size) {
    super(size);
  }
  void animStart() {
    this.loc(showW/2 + random(-showW/2, showW/2), showH/2, 20 + random(20));
    alpha = 255;
    a1 = new Ani(this, 2, "alpha", 0, Ani.EXPO_OUT);

    xwidth = 50;
    a2 = new Ani(this, 2, "xwidth", 0, Ani.EXPO_OUT);
  }
  void animDraw() {
    this.alpha(alpha).width(xwidth);
  }
} 