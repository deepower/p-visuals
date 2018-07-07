import hype.*;
import hype.extended.behavior.HTween;

import de.looksgood.ani.*;
import codeanticode.syphon.*;

SyphonServer server;

AudioAnalyzer aa;
BeatDetect beat;
BeatListener bl;

HCanvas canvas;
HRect   rect, rectLevel;

HTween t1a, t2a;
HCallback cb;

int showW = 1280;
int showH = 720;

float tweenEase = 0.2;

void settings() {
  size(showW, showH, P3D);
  PJOGL.profile=1;
}

void setup() {
  server = new SyphonServer(this, "Processing Syphon");
  aa = new AudioAnalyzer(this);
  
  H.init(this).background(#000000);

  canvas = new HCanvas().autoClear(true);
  H.add(canvas);

  rect = new HRect(50);
  rect.anchorAt(H.CENTER);

  rectLevel = new HRect(100);
  rectLevel.noStroke().fill(#FF9900).anchorAt(H.CENTER).loc(width/2, height/2);

  t1a = new HTween()
    .target(rectLevel).property(H.HEIGHT)
    .start(showH)
    .end(10)
    .ease(0.1)
  ;

  t2a = new HTween()
    .target(rect).property(H.HEIGHT).start(1).end(100).ease(tweenEase)
  ;

  cb = new HCallback() {
    public void run(Object obj) {
      t2a.start(100).end(1).ease(tweenEase).register();
      println("obj: "+obj);
    }
  };

  t2a.register().callback(cb);

  canvas.add(rect).noStroke().fill(#FFFFFF);
  canvas.add(rectLevel);
}

void draw() {
  aa.draw();

  if ( aa.beat.isRange(2, 5, 3) ) {
    t1a.unregister();
    t1a.start(showH).end(10).register();
  }

  if (aa.beat.isRange(25, 26, 1)) {
    t2a.unregister();
    rect.height(100).loc( (int)random(width), (int)random(height));
    t2a.start(1).end(100).register().callback(cb);
  }

  H.drawStage();
  
  server.sendScreen();
}
