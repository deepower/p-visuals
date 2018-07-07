import hype.*;
import hype.extended.behavior.HOscillator;
import hype.extended.colorist.HColorPool;
import hype.extended.layout.HGridLayout;

HDrawablePool pool1, pool2;
HColorPool    colors;
HRect rect1;
HGridLayout layout1;

int showW = 1280;
int showH = 720;
void settings() {
  size(showW, showH, P2D);
  PJOGL.profile=1;
}

void setup() {
	H.init(this).background(#242424);

	colors = new HColorPool(#FFFFFF);

	pool1 = new HDrawablePool(100);
	pool1.autoAddToStage();

	rect1 = new HRect(4);
	rect1.rounding(3).anchorAt(H.CENTER).noStroke().height(2000);

	pool1.add(rect1);

	layout1 = new HGridLayout();
	layout1.startLoc(-width/2, height/2).spacing(40, 0).cols(320);

	pool1.layout(layout1)
		.onCreate(
			new HCallback() {
				public void run(Object obj) {
					int i = pool1.currentIndex();

					HDrawable d = (HDrawable) obj;
					d.fill( colors.getColor(i*100) );

					new HOscillator()
						.target(d)
						.property(H.Y)
						.relativeVal(d.y())
						.range(-200, 200)
						.speed(2)
						.freq(0.5)
						.currentStep(i)
					;

					new HOscillator()
						.target(d)
						.property(H.WIDTH)
						.range(4, 16)
						.speed(2)
						.freq(0.5)
						.currentStep(i) 
					;

					new HOscillator()
						.target(d)
						.property(H.ROTATION)
						.range(-45, 45)
						.speed(1)
						.freq(0.5)
						.currentStep(i)
					;
				}
			}
		)
		.requestAll()
	;

	pool2 = new HDrawablePool(100);
	pool2.autoAddToStage()
		.add(new HRect(4).rounding(3).anchorAt(H.CENTER).noStroke().height(2000))
		.layout(new HGridLayout().startLoc(-width/2, height/2).spacing(40, 0).cols(320))
		.onCreate(
			new HCallback() {
				public void run(Object obj) {
					int i = pool1.currentIndex();

					HDrawable d = (HDrawable) obj;
					d.fill( colors.getColor(i*100) );

					new HOscillator()
						.target(d)
						.property(H.ROTATION)
						.range(-30, 30)
						.speed(1)
						.freq(0.5)
						.currentStep(i)
					;
				}
			}
		)
		.requestAll()
	;
}

void draw() {
	H.drawStage();
	layout1.spacing(1, 0);
}
