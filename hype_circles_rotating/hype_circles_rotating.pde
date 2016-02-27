import hype.*;
import hype.extended.colorist.HColorPool;
import hype.extended.behavior.HRotate;

HDrawablePool pool;
HColorPool colors;

import themidibus.*; //Import the library
MidiBus myBus; // The MidiBus

DeepShow myShow;

void setup() {
  size(1280,720);
  H.init(this).background(#000000);
  smooth();

  myShow = new DeepShow();
  myShow.setup(this);

  colors = new HColorPool(#FFFFFF, #F7F7F7, #ECECEC, #333333, #0095a8, #00616f, #FF3300, #FF6600);

  resetStage();
}

void resetStage() {
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

    .requestAll()
  ;

}

void draw() {
  myShow.draw();
  H.drawStage();
}

void controllerChange(int channel, int number, int value) {
  myShow.controllerChange(channel, number, value);
}

void noteOn(int channel, int pitch, int velocity) {
  myShow.noteOn(channel, pitch, velocity);
}

class DeepShow {

  int knobsNum = 12;

  float knobs[] = new float[knobsNum+1];

  void setup(PApplet applet) {
    connectMIDI(applet);
  }
  void connectMIDI(PApplet applet) {
    // MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
    myBus = new MidiBus(applet, 0, 3); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  }
  void draw() {
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
      pool.drain();
      pool.shuffleRequestAll();
    }
  }
}