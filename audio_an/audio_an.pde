import hype.*;
import de.looksgood.ani.*;
import codeanticode.syphon.*;

SyphonServer server;

AudioAnalyzer aa;

import themidibus.*; //Import the library
MidiBus myBus; // The MidiBus

HCanvas canvas;
HRect   rect;

int showW = 1280;
int showH = 720;

void settings() {
  size(showW, showH, P3D);
  PJOGL.profile=1;
}

void setup() {
  server = new SyphonServer(this, "Processing Syphon");
  aa = new AudioAnalyzer(this);
  
  H.init(this).background(#242424);

  canvas = new HCanvas().autoClear(false).fade(5);
  H.add(canvas);

  canvas.add( rect = new HRect(50).rounding(5) ).noStroke().fill(#FF3300).rotate(45);
}

void draw() {
  fill(255);
  ellipse(50, 50, 100, 100);
  
  rect.loc( (int)random(width), (int)random(height));
  H.drawStage();
  
  server.sendScreen();
}
