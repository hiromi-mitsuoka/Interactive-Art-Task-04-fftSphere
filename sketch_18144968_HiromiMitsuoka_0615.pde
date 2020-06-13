import processing.sound.*;
SoundFile sound;
FFT fft;
int bands = 1024*8;
float[] x = new float[bands];
float[] y = new float[bands];
float[] z = new float[bands];
float[] r = new float[bands];
float[] sW = new float[bands];
float[] c = new float[bands];
int bg = 0;
int pc = 255;
int soundMode = 0;

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
  background(bg);
  fft.analyze();
  pushMatrix();
  translate(width/2, height/2, -300);
  camera(0, 0, 200, 
    0, 0, 0, 
    0, 1.0, 0);
  rotateY(frameCount*0.008);
  rotateZ(frameCount*0.0085);
  for (int i=0; i<bands; i++) {
    r[i] = map(fft.spectrum[i], 0, 1, 10, 800);
    sW[i] = map(fft.spectrum[i], 0, 1, 0.25, 100);
    //c[i] = map(fft.spectrum[i], 0, 1, 25, 0);
    strokeWeight(sW[i]*mouseX/200);
    //stroke(255-c[i], 255-c[i], 255);
    stroke(pc, 220);
    point(r[i]*x[i], r[i]*y[i], r[i]*z[i]);
  }
  popMatrix();
}

void mousePressed() {
  soundMode++;
  if (soundMode%2 == 1) {
    bg = 255;
    pc = 0;
  } else {
    bg = 0;
    pc = 255;
  }
}
