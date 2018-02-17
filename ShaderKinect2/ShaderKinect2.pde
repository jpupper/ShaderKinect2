import apsync.*;

import com.hamoid.*;
import themidibus.*; //Import the library
import spout.*;
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html

import KinectPV2.*;
KinectPV2 kinect;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;


PShader sh;

float [] midivalues = new float [18];
int channel, pitch, velocity;
boolean soundOn;


int coloractivo = 0;
MidiBus myBus; // The MidiBus

int cant = 5;
float [] puntosx = new  float [cant];
float [] puntosy = new  float [cant];
float [] puntosz = new  float [cant];

boolean showgui = true;
int controlmode = 1; // 0 mouse
// 1 kinect


int am = 0; //posición actual del mouse;

PVector manoder1;
PVector manoizq1;

PVector manoder2;
PVector manoizq2;

//SHADERS INPUTS !!!! 
float [] shi = new float[17];
void setup() {
  //size(600, 600, P2D);
  fullScreen(P3D);
  iniciarmidi(); 
  initkinect();

  sh = loadShader("sh1.glsl");
  oscP5 = new OscP5(this, 2445);
  setvaluesrandom();
}

void draw() {
  rectMode(CENTER);
  updatemanos();//Esta de aca seria todo lo de la kinect
  setearpuntos();
  runshader();
  if (showgui) {
    rungui();
  }
 
} 

void setearpuntos() {
  if (controlmode == 1) {
    setkinectpoints();
  } else {
    puntosx[am] = mouseX;
    puntosy[am] = mouseY;
    for (int i=0; i<cant; i++) {
      puntosz[i] = 1.;
    }
  }
}

void setPuntosRandom() {
  for (int i=0; i<cant; i++) {
    puntosx[i] = random(width);
    puntosy[i] = random(height);
  }
}

float [] normArray(float [] array_, int cant, float min, float max) {
  float [] normray = new float [cant]; 
  for (int i=0; i<cant; i++) {
    normray[i] = norm(array_[i], min, max);
  }
  return normray;
}
void runshader() {
  background(0);
  sh.set("time", (float)millis() / 1000);
  sh.set("resolution", (float)width, (float)height);
  sh.set("mouse", map(mouseX, 0, width, 0.0, 1.0), map(mouseY, 0, height, 0.0, 1.0));
  sh.set("midi1", shi[0]);
  sh.set("midi2", shi[1]);
  sh.set("midi3", shi[2]);
  sh.set("midi4", shi[3]);
  sh.set("midi5", shi[4]);
  sh.set("midi6", shi[5]);
  sh.set("midi7", shi[6]);
  sh.set("midi8", shi[7]);
  sh.set("midi9", shi[8]);
  sh.set("midi10", shi[9]);
  sh.set("midi11", shi[10]);
  sh.set("midi12", shi[11]);
  sh.set("midi13", shi[12]);
  sh.set("midi14", shi[13]);
  sh.set("midi15", shi[14]);
  sh.set("midi16", shi[15]);
  sh.set("midi17", shi[16]);
  sh.set("coloractivo", coloractivo);
  sh.set("mouse", map(mouseX, 0, width, 0.0, 1.0), map(mouseY, 0, height, 0, 1));
  //sh.set("puntosx",puntosx);
  //sh.set("puntosy",puntosy);

  sh.set("puntosx", normArray(puntosx, cant, 0, width));
  sh.set("puntosy", normArray(puntosy, cant, 0, height));
  sh.set("puntosz", puntosz);
  sh.set("cant", 15);

  textSize(30);
  noStroke();
  shader(sh);
  rectMode(CENTER);
  rect(width/2, height/2, width, height);
  resetShader();
}

void rungui() {

  fill(0, 255, 0);
  ellipse(mouseX, mouseY, 10, 10);

  for (int i=0; i<cant; i++) {
    fill(200, 100, 100, 120);
    ellipse(puntosx[i], puntosy[i], 30, 30);
    textAlign(CENTER, CENTER);
    textSize(12);
    fill(0, 255, 255);
    text("P"+i, puntosx[i], puntosy[i]);
  }
  fill(random(255), 200, 200);

  fill(255);
  textSize(20);
  textAlign(LEFT);
  float txtposx = 100;
  float sepy = 20;
  float posy = 30;
  //text(frameRate, txtposx, height-100);

  //float Z [] = new float [2];
  text("Z DERECHA 1:" +manoder1.z, txtposx, posy+=sepy);
  text("Z IZQUIERDA 1:"+manoizq1.z, txtposx, posy+=sepy);

  text("Z DERECHA 2:" +manoder2.z, txtposx, posy+=sepy);
  text("Z IZQUIERDA 2:"+manoizq2.z, txtposx, posy+=sepy);
  text("Cantidad de esqueletos "+ kinect.getSkeletonDepthMap().size(), txtposx, posy+=sepy);

  text(" Norm derz1 "+puntosz[0], txtposx, posy+=sepy);

  text(" Norm izqz1 "+puntosz[1], txtposx, posy+=sepy);

  text(" Norm derz2 "+puntosz[2], txtposx, posy+=sepy);

  text(" Norm izqz2 "+puntosz[3], txtposx, posy+=sepy);
}

void setvaluesrandom() {
  for (int i =0; i<shi.length; i++) {
    shi[i] = random(1);
  }
}
void mousePressed() {
  am++;
  if (am >= cant) {
    am = 0;
  }
}

void keyPressed() {
  if (key == 'e') {
    sh = loadShader("sh1.glsl");
  }
  if (key == 'r') {
    setPuntosRandom();
    setvaluesrandom();  
  }
  if (key == 'g') {

    showgui = !showgui;
  }
  if (key == 'c') {
    controlmode++;
    if (controlmode > 1) {
      controlmode = 0;
    }
  }
}