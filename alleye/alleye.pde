import hype.*;
import hype.extended.colorist.HColorPool;
import hype.extended.behavior.HRotate;
import hype.extended.behavior.HTween;
import de.looksgood.ani.*;
import codeanticode.syphon.*;

HDrawablePool pool;
HColorPool colors;

import themidibus.*; //Import the library
MidiBus myBus; // The MidiBus

CurrentShow s;

int showW = 1280;
int showH = 720;

PGraphics canvas;
SyphonServer server;

void setup() {
  size(1280, 720, P3D);
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
    streamSyphon(applet);
  }
  void connectMIDI(PApplet applet) {
    MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
    myBus = new MidiBus(applet, 0, 2); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  }
  void streamSyphon(PApplet applet) {
    canvas = createGraphics(1280, 720, P3D);
  }
  void drawSyphon() {
    image(canvas, 0, 0);
    server.sendImage(canvas);
  }
  void draw() {
    drawSyphon();
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
  int bassCount = 5;

  BassRect[] basses = new BassRect[bassCount];

  EyePulse eye;

  int rotateIncrement = 10;

  CurrentShow(PApplet applet) {
    setup(applet);
  }
  void setupSpecific(PApplet applet) {
    H.init(applet).background(#000000).use3D(true);
    blendMode(BLEND);
    translate(width/2, height/2, 0);
    smooth();

    Ani.init(applet);

    eye = new EyePulse(loadImage("eye.png"));
    eye
      .anchorAt(H.CENTER)
      .loc(showW/2, showH/2)
      .size(272, 222)
      .z(100);
    H.add(eye);

    for (int i = 0; i < basses.length; ++i) {
      basses[i] = new BassRect(10);
      basses[i]
        .loc(showW/2, showH/2)
        .locAt(H.CENTER)
        .anchorAt(H.CENTER)
        .noStroke()
        .transformsChildren(true)
        .alpha(0)
        .rotation(rotateIncrement*(i-basses.length/2));
      basses[i].add(
        new HRect(showH/10)
          .noStroke()
          .fill(#000000)
          .anchorAt(H.CENTER)
          .locAt(H.CENTER)
          .height(showH/10)
          .width(showW/2)
          .z(20)
        );
      basses[i].add(
        new HRect(showH/10)
          .noStroke()
          .fill(#FFFFFF)
          .anchorAt(H.CENTER)
          .height(showH/10)
          .width(showW*2)
          .z(-10)
        );
      H.add(basses[i]);
    }


  }
  void draw() {
    eye.animDraw();
    for (int i = 0; i < basses.length; ++i) {
      basses[i].animDraw();
    }
    H.drawStage();
  }
  void resetScene() {
    for (int i = 0; i < basses.length; ++i) {
      basses[i].animStart();
    }
  }
  void noteOn(int channel, int pitch, int velocity) {
    // Reset the scene when received this note
    if (channel == 0 && pitch == 0) {
      resetScene();
    } else if (channel == 0 && pitch == 2) {
      note1B();
    }
  }
  void note1B() {
  }
}

class BassRect extends HRect {
  float scaleMax = 2;
  float scaleMin = 0.1;

  BassRect(int size) {
    super(size);
  }
  void animStart() {
  }
  void animDraw() {
    this
      .height(map(s.knobs[1], 0, 0.5, showH/300, showH/150))
      .alpha(int(map(s.knobs[1], 0, 0.5, 0, 255)));
  }
} 

class EyePulse extends HImage {
  float scaleMax = 1.5;
  int initW = 272;
  int initH = 222;

  EyePulse(PImage pimg) {
    super(pimg);
  }


  void animDraw() {
    this
      .width(map(s.knobs[0], 0, 1, initW, initW*scaleMax))
      .height(map(s.knobs[0], 0, 1, initH, initH*scaleMax));
  } 
}

