import hype.*;
import hype.extended.colorist.HColorPool;
import hype.extended.behavior.HRotate;

HDrawablePool pool;
HColorPool colors;

import themidibus.*; //Import the library
MidiBus myBus; // The MidiBus

CurrentShow s;

void setup() {
  size(1280,720);
  s = new CurrentShow(this);
}

void draw() {
  s.draw();
}

void controllerChange(int channel, int number, int value) {
  s.controllerChange(channel, number, value);
}

void noteOn(int channel, int pitch, int velocity) {
  s.noteOn(channel, pitch, velocity);
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
    // MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
    myBus = new MidiBus(applet, 0, 3); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
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
  CurrentShow(PApplet applet) {
    setup(applet);
  }
  void setupSpecific(PApplet applet) {
    H.init(applet).background(#000000);
    smooth();
    colors = new HColorPool(#FFFFFF, #F7F7F7, #ECECEC, #333333, #0095a8, #00616f, #FF3300, #FF6600);

    pool = new HDrawablePool(100);
    pool.autoAddToStage()
      .add (
        new HRect()
        .rounding(10)
      )

      .add (
        new HEllipse(), 25
      )

      .onCreate (
        new HCallback() {
          public void run(Object obj) {
            HDrawable d = (HDrawable) obj;
            d
              .noStroke()
              .fill( colors.getColor() )
              .loc( (int)random(width), (int)random(height) )
              .anchor( new PVector(25,25) )
              .rotation( (int)random(360) )
              .size( 25+((int)random(3)*25) )
            ;

            HRotate r = new HRotate();
            r.target(d).speed( random(-4,4) );
          }
        }
      )
      .onRequest(
        new HCallback() {
          public void run(Object obj) {
            HDrawable d = (HDrawable) obj;
            d.scale(2,2);
          }
        }
      )

      .requestAll()
    ;
  }
  void draw() {
    H.drawStage();
  }
  void resetScene() {
    pool.drain();
    pool.shuffleRequestAll();
  }

}