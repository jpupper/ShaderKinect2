void iniciarmidi() {
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this,0, 3); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
  midivalues[0] = 50;
  midivalues[1] = 1;
  midivalues[2] = 1;
  midivalues[3] = 1;
  midivalues[4] = 25;
  midivalues[5] = 1;
  midivalues[6] = 1;
  midivalues[7] = 1;

  midivalues[9] = 0;
  midivalues[10] = 0;
  midivalues[11] = 100;
  midivalues[12] = 100;
  midivalues[17] = width/2;
}


void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);


  int [] numbers = {73, 9, 10, 72, 14, 15, 16, 17, 74, 71, 18, 107, 79, 78, 26, 27, 28, 1};

  for (int x=0; x<numbers.length; x++) {
    if (number == numbers[x]) {
      midivalues[x] = value;
      shi[x] = midimap(value,0,1); //Así sería para controlarlo por midi?
      println("midivalues["+x+"]: "+ midivalues[x]);
    }
  }
  
  
  
}

float midimap(float _midivalue, float _min, float _max) {

  float var = map(_midivalue, 0, 127, _min, _max);
  return var;
}


void noteOn(int _channel, int _pitch, int _velocity) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  //showMidivalues(_channel,_pitch,_velocity);


  channel = _channel;
  pitch = _pitch;
  velocity = _velocity;

  // println("NOTE ON");
  //println("pitch", _pitch);
  // println("pitch-35", _pitch-35);
  
  coloractivo++;
  if(coloractivo == 2){
   coloractivo=0; 
    
  }
  println("COLORACTIVO : ",coloractivo);
}

void noteOff(int _channel, int _pitch, int _velocity) {
  int nota2 = pitch - 48 ;
  //notas[nota2].stop();
  // Receive a noteOff
  println("NOTE off");
  println("NOTA ", nota2);
  channel = _channel;
  pitch = _pitch;
  //instruments[nota2].ampEnv.
  // velocity = _velocity;
  
}

void midiMessage(MidiMessage message) {
 /* for (int i = 1; i < message.getMessage().length; i++) {
    // println("Param "+(i+1)+": "+(int)(message.getMessage()[i] & 0xFF));
    if (message.getStatus() == 224) { 
      globalpos.y = midimap((int)(message.getMessage()[i] & 0xFF), height, 0);
    
    }
  }*/
 // SP.updatepitch();
}