import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;  
AudioPlayer song;
FFT fftLin;

class AudioAnalyzer {
  
  PApplet that;
  
  AudioAnalyzer(PApplet tthat) {
    
    that = tthat;

    minim = new Minim(that);
    song = minim.loadFile("deep.mp3", 1024);
    
    // loop the file
    song.loop();
    
    beat = new BeatDetect(song.bufferSize(), song.sampleRate());
    
  }
  
  void draw() {
    
  }
}
