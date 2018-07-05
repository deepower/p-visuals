import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;  
AudioPlayer song;
FFT fftLin;

float kickSize, snareSize, hatSize;

class AudioAnalyzer {
  
  PApplet that;
  public BeatDetect beat;
  
  AudioAnalyzer(PApplet tthat) {
    
    that = tthat;

    minim = new Minim(that);
    song = minim.loadFile("deep.mp3", 1024);
    
    // loop the file
    song.loop();
    
    beat = new BeatDetect(song.bufferSize(), song.sampleRate());

    beat.setSensitivity(300);  

    kickSize = snareSize = hatSize = 16;
    // make a new beat listener, so that we won't miss any buffers for the analysis
    bl = new BeatListener(beat, song);  
  }
  
  void draw() {
    
  }
}
