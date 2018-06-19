import hype.*;
import hype.extended.behavior.HTween;

import de.looksgood.ani.*;
import codeanticode.syphon.*;

SyphonServer server;

AudioAnalyzer aa;

import themidibus.*; //Import the library
MidiBus myBus; // The MidiBus

HCanvas canvas;
HRect   rect;

HTween t1a;

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

  rect = new HRect(50);

  t1a = new HTween()
    .target(rect).property(H.HEIGHT)
    .start(1)
    .end(50)
    .ease(0.005)
    .spring(0.95)
  ;

  canvas.add(rect).noStroke().fill(#FFFFFF).rotate(45);
}

void draw() {
  rect.height(100*aa.levels[0]).loc( (int)random(width), (int)random(height));
  aa.draw();
  H.drawStage();
  
  server.sendScreen();
}
