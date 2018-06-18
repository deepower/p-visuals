import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;  
AudioPlayer jingle;
FFT fftLin;

float height3;
float height23;
float spectrumScale = 4;
int levelAverages = 8;


class AudioAnalyzer {
  public int id;
  public float[] levels = new float[levelAverages];
  
  PApplet that;
  
  AudioAnalyzer(PApplet tthat) {
    id = 1;
    
    height3 = showH/3;
    height23 = 2*showH/3;
    
    that = tthat;

    minim = new Minim(that);
    jingle = minim.loadFile("deep.mp3", 1024);
    
    // loop the file
    jingle.loop();
    
    // create an FFT object that has a time-domain buffer the same size as jingle's sample buffer
    // note that this needs to be a power of two 
    // and that it means the size of the spectrum will be 1024. 
    // see the online tutorial for more info.
    fftLin = new FFT( jingle.bufferSize(), jingle.sampleRate() );
    
    // calculate the averages by grouping frequency bands linearly. use 8 averages.
    fftLin.linAverages( levelAverages );
    
  }
  
  void draw() {
    fftLin.forward( jingle.mix );
    for(int i = 0; i < levelAverages; i++)
    {
      levels[i] = fftLin.getBand(i);
    }
  }
}
