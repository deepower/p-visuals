import hype.*;

HCanvas canvas;
HRect   rectHats;
HRect   rectDrum;
HRect   rectPiano;

import themidibus.*; //Import the library
MidiBus myBus; // The MidiBus

import com.hamoid.*; // Saving video
VideoExport videoExport;

int knobsNum = 8;

float knobValues[] = new float[knobsNum+1];

void setupDeep() {
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, 0, 3); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
}

public void settings() {
  fullScreen(2);
}

/*
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
  canvas.add( rectPiano = new HRect(100).rounding(0) ).noStroke().fill(#0099ff).rotate(45).stroke(#0099ff);

  videoExport = new VideoExport(this, "basic.mp4");
}
*/

/*
void draw() {
  rectHats.loc( (int)random(width), (int)random(height));
  rectHats.strokeWeight(map(knobValues[1], 0, 1, 10, 20));
  rectHats.size(map(knobValues[1], 0, 1, 0, 20), map(knobValues[1], 0, 1, 0, 5000));
  rectDrum.loc( (int)random(width), heightOut);
  rectDrum.strokeWeight(map(knobValues[0], 0, 1, 50, 100));
  rectDrum.size(map(knobValues[0], 0, 1, 20, 50), map(knobValues[0], 0, 1, 0, 5000));
  rectPiano.loc( (int)random(width), heightOut);
  rectPiano.strokeWeight(map(knobValues[2], 0.1, 1, 0, 50));
  rectPiano.size(0, 5000);
  H.drawStage();
  // videoExport.saveFrame();
}
*/

void controllerChange(int channel, int number, int value) {
  // Receive new value on knob modification
  if(number < knobsNum) {
    knobValues[number] = value/127.000;
  }
}


int xspacing = 16;   // How far apart should each horizontal location be spaced
int w;              // Width of entire wave

float theta = 0.0;  // Start angle at 0
float amplitude = 75.0;  // Height of wave
float period = 500.0;  // How many pixels before the wave repeats
float dx;  // Value for incrementing X, a function of period and xspacing
float[] yvalues;  // Using an array to store height values for the wave

void setup() {
  setupDeep();
  w = width+16;
  dx = (TWO_PI / period) * xspacing;
  yvalues = new float[w/xspacing];
}

void draw() {
  background(0);
  calcWave();
  renderWave();
}

void calcWave() {
  // Increment theta (try different values for 'angular velocity' here
  theta += 0.02;

  // For every x value, calculate a y value with sine function
  float x = theta;
  for (int i = 0; i < yvalues.length; i++) {
    yvalues[i] = sin(x)*amplitude;
    x+=dx;
  }
}

void renderWave() {
  noStroke();
  fill(255);
  // A simple way to draw the wave with an ellipse at each location
  for (int x = 0; x < yvalues.length; x++) {
    ellipse(x*xspacing, height/2+yvalues[x], 16, 16);
  }
}
