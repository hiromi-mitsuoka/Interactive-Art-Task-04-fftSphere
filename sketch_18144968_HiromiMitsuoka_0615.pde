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
  translate(width/2, height/2, -300);
  camera(0, 0, 200, 
    0, 0, 0, 
    0, 1.0, 0);
  rotateY(frameCount*0.008);
  rotateZ(frameCount*0.0085);
  if (soundMode%3 == 1) {
    bg = 255;
    pc = 0;
    blendMode(BLEND);
  } else if (soundMode%3 == 2) {
    bg = 0;
    pc = 255;
    blendMode(ADD);
  } else {
    bg = 0;
    blendMode(ADD);
  }
  for (int i=0; i<bands; i++) {
    r[i] = map(fft.spectrum[i], 0, 1, 10, 1500);
    r[i] *= 1+frameCount*0.001;
    sW[i] = map(fft.spectrum[i], 0, 1, 0.35, 150);
    sW[i] *= 1+frameCount*0.0001;
    strokeWeight(sW[i]*mouseX/200);
    stroke(pc);
    if (soundMode%3 == 0) {
      float pcR = random(255);
      float pcG = random(255);
      float pcB = random(255);
      stroke(pcR, pcG, pcB);
    }
    point(r[i]*x[i], r[i]*y[i], r[i]*z[i]);
  }
}

void mousePressed() {
  soundMode++;
}
