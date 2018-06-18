import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;  
AudioPlayer jingle;
FFT fftLin;
FFT fftLog;

class AudioAnalyzer {
  public int id;
  
  PApplet that;
  
  AudioAnalyzer(PApplet tthat) {
    id = 1;
    
    that = tthat;

    minim = new Minim(that);
    jingle = minim.loadFile("deep.mp3", 1024);
    
    // loop the file
    jingle.loop();
  }
}
