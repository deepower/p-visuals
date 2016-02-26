import hype.*;

HCanvas canvas;
HRect   rectHats;
HRect   rectDrum;

import themidibus.*; //Import the library
MidiBus myBus; // The MidiBus

import com.hamoid.*; // Saving video
VideoExport videoExport;

int knobsNum = 8;

float knobValues[] = new float[knobsNum+1];

void setup() {
  // size(1280, 720);
  fullScreen(2);
  H.init(this).background(#000000);
  
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, 0, 3); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.

  canvas = new HCanvas().autoClear(false).fade(10);
  H.add(canvas);

  canvas.add( rectHats = new HRect(100).rounding(0) ).noStroke().fill(#99ff00).rotate(45).stroke(#99ff00);
  canvas.add( rectDrum = new HRect(100).rounding(0) ).noStroke().fill(#ffffff).rotate(45).stroke(#ffffff);

  videoExport = new VideoExport(this, "basic.mp4");
}

void draw() {
  rectHats.loc( (int)random(width), (int)random(height));
  rectHats.strokeWeight(map(knobValues[1], 0, 1, 10, 20));
  rectHats.size(map(knobValues[1], 0, 1, 0, 20), map(knobValues[1], 0, 1, 0, 5000));
  rectDrum.loc( (int)random(width), -50);
  rectDrum.strokeWeight(map(knobValues[0], 0, 1, 50, 100));
  rectDrum.size(map(knobValues[0], 0, 1, 20, 50), map(knobValues[0], 0, 1, 0, 5000));
  H.drawStage();
  // videoExport.saveFrame();
}

void controllerChange(int channel, int number, int value) {
  // Receive new value on knob modification
  knobValues[number] = value/127.000;
}