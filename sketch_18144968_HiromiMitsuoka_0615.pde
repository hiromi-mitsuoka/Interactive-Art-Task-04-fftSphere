import processing.sound.*;
SoundFile sound;
FFT fft;
int bands = 1024*2;
float[] x = new float[bands];
float[] y = new float[bands];
float[] z = new float[bands];
float[] r = new float[bands];
float[] sW = new float[bands];

void setup() {
  size(700, 700, P3D);
  sound = new SoundFile(this, "sound.mp3");
  sound.loop();
  fft = new FFT(this, bands);
  fft.input(sound);
  for (int i=0; i<bands; i++) {
    z[i] = random(-1, 1);
    float ang = radians(random(360));
    x[i] = sqrt(1-z[i]*z[i])*cos(ang);
    y[i] = sqrt(1-z[i]*z[i])*sin(ang);
  }
}

void draw() {
  background(255);
  fft.analyze();
  translate(width/2, height/2, -300);
  camera(0, 0, 500, 
    0, 0, 0, 
    0, 1.0, 0);
  rotateY(frameCount*0.01);
  for (int i=0; i<bands; i++) {
    r[i] = map(fft.spectrum[i], 0, 1, 50, 5000);
    sW[i] = map(fft.spectrum[i], 0, 1, 1, 300);
    strokeWeight(sW[i]);
    point(r[i]*x[i], r[i]*y[i], r[i]*z[i]);
  }
}
