import hype.*;

HCanvas canvas;
HRect   rect;

import themidibus.*; //Import the library
MidiBus myBus; // The MidiBus

int knobsNum = 8;

float knobValues[] = new float[knobsNum+1];

void setup() {
    size(1280, 720);
    H.init(this).background(#000000);
    
    MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
    myBus = new MidiBus(this, 0, 3); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.

    canvas = new HCanvas().autoClear(true).fade(100);
    H.add(canvas);

    canvas.add( rect = new HRect(100).rounding(0) ).noStroke().fill(#ffffff).rotate(45).stroke(#99ff00);
}

void draw() {
    rect.loc( (int)random(width), (int)random(height));
    rect.strokeWeight(knobValues[0]*45);
    rect.size(10*knobValues[0], knobValues[0]*5000);
    H.drawStage();
}

void controllerChange(int channel, int number, int value) {
  // Receive new value on knob modification
  knobValues[number] = value/127.000;
}