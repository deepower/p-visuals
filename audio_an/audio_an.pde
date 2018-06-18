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
  
  H.init(this).background(#000000);

  canvas = new HCanvas().autoClear(false).fade(10);
  H.add(canvas);

  canvas.add( rect = new HRect(50)).noStroke().fill(#FFFFFF).rotate(45);
}

void draw() {
  rect.height(100*aa.levels[0]).loc( (int)random(width), (int)random(height));
  aa.draw();
  H.drawStage();
  
  server.sendScreen();
}
