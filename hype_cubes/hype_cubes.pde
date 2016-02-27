import hype.*;
import hype.extended.layout.HGridLayout;
import hype.extended.behavior.HRotate;

HDrawablePool pool;

int spaceBetween = 100;
int startX, startY;

void setup() {
  size(1280,720,P3D);
  H.init(this).background(#000000).use3D(true);

  colorMode(HSB, 360, 100, 100);

  pool = new HDrawablePool(100);
  pool.autoAddToStage()
    .add(new HBox())
    .layout(new HGridLayout().startX(100).startY(100).spacing(100,100).cols(10))
    .onCreate(
       new HCallback() {
        public void run(Object obj) {
          int ranSize = 25;
          
          HBox d = (HBox) obj;
          d.depth(ranSize).width(ranSize).height(ranSize).noStroke();
        }
      }
    )
    .requestAll()
  ;
}

void draw() {
  pointLight(360, 100, 100, 0, height/2, -300);
  pointLight(240, 100, 50, width, height/2, -300);
  pointLight(120, 100, 50, width/2, height/2, -400);

  H.drawStage();
}
