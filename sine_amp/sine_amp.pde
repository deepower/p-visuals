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

void controllerChange(int channel, int number, int value) {
  // Receive new value on knob modification
  if(number < knobsNum) {
    knobValues[number] = value/127.000;
  }
}


int xspacing = 180;   // How far apart should each horizontal location be spaced
int w;              // Width of entire wave

float theta = 0.0;  // Start angle at 0
float dtheta = 0.2;
float amplitude = 200.0;  // Height of wave
float period = 2000.0;  // How many pixels before the wave repeats
float dx;  // Value for incrementing X, a function of period and xspacing
float[] yvalues;  // Using an array to store height values for the wave
float ellipseSize = 0;

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
  theta += dtheta;

  // For every x value, calculate a y value with sine function
  float x = theta;
  for (int i = 0; i < yvalues.length; i++) {
    yvalues[i] = sin(x)*amplitude*map(knobValues[0],0,1,1,1.5);
    x+=dx;
  }
}

void renderWave() {
  noStroke();
  fill(255);
  ellipseSize = map(knobValues[0],0,1,30,300);
  // A simple way to draw the wave with an ellipse at each location
  for (int x = 0; x < yvalues.length; x++) {
    ellipse(x*xspacing, height/2+yvalues[x], ellipseSize, ellipseSize);
  }
}
