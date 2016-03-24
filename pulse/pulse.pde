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
  int drumCount = 5;
  int bassCount = 10;
  int mainCount = 2;

  DRect[] drums = new DRect[drumCount];
  BassRect[] basses = new BassRect[bassCount];
  DRect[] mains = new DRect[mainCount];

  CurrentShow(PApplet applet) {
    setup(applet);
  }
  void setupSpecific(PApplet applet) {
    H.init(applet).background(#000000).use3D(true);
    blendMode(ADD);
    hint(DISABLE_DEPTH_TEST);
    translate(width/2, height/2, 0);
    smooth();

    Ani.init(applet);

    for (int i = 0; i < drums.length; ++i) {
      drums[i] = new DRect(10);
      drums[i]
        .noStroke()
        .fill(#ffffff)
        .anchorAt(H.CENTER)
        .height(showH/2)
        .z(5)
      ;
      H.add(drums[i]);
    }

    for (int i = 0; i < basses.length; ++i) {
      basses[i] = new BassRect(10);
      basses[i]
        .noStroke()
        .fill(#F12016)
        .anchorAt(H.CENTER)
        .height(showH/2)
        .z(-10)
        .width(showW/10)
      ;
      basses[i].animStart();
      H.add(basses[i]);
    }


  }
  void draw() {
    for (int i = 0; i < drums.length; ++i) {
      drums[i].animDraw();
    }
    for (int i = 0; i < basses.length; ++i) {
      basses[i].animDraw();
    }
    H.drawStage();
    server.sendScreen();
  }
  void resetScene() {
    for (int i = 0; i < basses.length; ++i) {
      basses[i].animStart();
    }
  }
  void noteOn(int channel, int pitch, int velocity) {
    // Reset the scene when received this note
    if (channel == 10 && pitch == 0) {
      resetScene();
    } else if (channel == 10 && pitch == 2) {
      note1B();
    }
  }
  void note1B() {
    for (int i = 0; i < drums.length; ++i) {
      drums[i].animStart();
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
    this.loc(showW/2 + random(-showW/2, showW/2), random(showH), 20 + random(20));
    alpha = 255;
    a1 = new Ani(this, 0.5, "alpha", 0, Ani.CUBIC_IN_OUT);

    xwidth = showW/3;
    a2 = new Ani(this, 0.5, "xwidth", 0, Ani.CUBIC_IN_OUT);
  }
  void animDraw() {
    this.alpha(alpha).width(xwidth);
  }
} 

class BassRect extends HRect {
  BassRect(int size) {
    super(size);
  }
  void animStart() {
    this.loc(showW/2 + random(-showW/2, showW/2), random(showH));
  }
  void animDraw() {
    this.alpha(int(map(s.knobs[1], 0, 1, 0, 255)));
  }
} 