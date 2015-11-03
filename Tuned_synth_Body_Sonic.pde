/*This script uses the Beads library to create two virtual synthesizers
connected to two muscle sensors. One could expand this program by creating
additional glides and waveplayers to accommodate more sensors. This script
sets tones to mimic the key of G Major*/

// Importing serial library and Beads library
import processing.serial.*;
import beads.*;

// Setting up AudioContext. The audio context acts as the main "output" for the
// virtual synthesizers.
AudioContext ac;

// Setting up WavePlayers. WavePlayers generate tones in the virtual synthesizer.
WavePlayer synth1;
WavePlayer synth2;

// Setting up glides for the synths. Glides are able to make changes in the
// virtual synthesizers, the way keys or knobs might in a physical synth.
Glide synthFrequency1;
Glide synthFrequency2;

// Setting up gain. Gains control volume.
Gain g;

// Setting up serial port
Serial port;

// Setting up variable to capture readings from sensors
String sensorReading;

// Setting up array to hold values from sensors. Because this script uses two
// sensors, the array is set to hold two values. You will need to enlarge
// the array to deal with more sensors.
float sensors[] = new float[1];

void setup() {

  // setup for serial if you are using a different baud rate in
  // Sensor_readings_for_Body_Sonic, you will need to set the same rate here.
  port = new Serial(this, Serial.list()[0], 9600);
  port.bufferUntil('\n');
  
  ac = new AudioContext();
  
  // create glides for the synthesizer frequencies
  // (context, setting, time in milliseconds)
  // the "setting" in this case is frequency in Hz. The milliseconds is the
  // delay in changing from one value to the next.
  synthFrequency1 = new Glide(ac, 20, 30);
  synthFrequency2 = new Glide(ac, 20, 30);
  
  // create Wave Players to generate sound
  // (context, frequency, type)
  // Here the frequency is determined by the synthFrequency Glide, defined
  // above. You can experiment with different settings beyond Buffer.SINE.
  // Beads also includes Buffer.NOISE, Buffer.SAW, Buffer.TRIANGLE, and
  // Buffer.SQUARE. Each will produce a different tone in the synthesizer.
  // the SINE setting is perhaps the "cleanest" sound.
  synth1 = new WavePlayer(ac, synthFrequency, Buffer.SINE);
  synth2 = new WavePlayer(ac, synthFrequency2, Buffer.SINE);
  
  
  // set the main volume (context, number of outputs, value as fraction of 1)
  // at 0.5 this is at 50 percent maximum Gain.
  g = new Gain(ac, 1, 0.5);
  
  // add sound inputs to the gain
  g.addInput(synth1);
  g.addInput(modulator2);
  
  // add volume to the main audio context
  ac.out.addInput(g);  
  
  // begin audio
  ac.start();
}

void draw() {
  // set frequency glide values to the numbers stored in the array. Sensors
  // will in theory return values between 0 and 1028. However, you will want
  // to try your sensors and "tune" them. Depending on the connection to the
  // muscles and the person using it, you may not see very low or very high
  // values. In our experience, we rarely saw sensors returning values over
  // 800. The settings here will move down to a much lower bass note at the
  // maximum sensor readings. The sensor readings at less than 50 will set to
  // 1, which is essentially inaudible.
  // If you would like to tune the sensors to a different key, you may find
  // frequencies for different notes at http://www.phy.mtu.edu/~suits/notefreqs.html
  if (sensors[0] < 50) synthFrequency1.setValue(1);
  else if (sensors[0] >=50 && sensors[0] < 100) synthFrequency1.setValue(261);
  else if (sensors[0] >=100 && sensors[0] < 150) synthFrequency1.setValue(294);
  else if (sensors[0] >=150 && sensors[0] < 200) synthFrequency1.setValue(330);
  else if (sensors[0] >=200 && sensors[0] < 250) synthFrequency1.setValue(370);
  else if (sensors[0] >=250 && sensors[0] < 300) synthFrequency1.setValue(392);  
  else if (sensors[0] >=300 && sensors[0] < 350) synthFrequency1.setValue(440);
  else if (sensors[0] >=350 && sensors[0] < 400) synthFrequency1.setValue(494);
  else if (sensors[0] >=400 && sensors[0] < 450) synthFrequency1.setValue(523);
  else if (sensors[0] >=450 && sensors[0] < 500) synthFrequency1.setValue(587);
  else if (sensors[0] >=500 && sensors[0] < 550) synthFrequency1.setValue(659);
  else if (sensors[0] >=550 && sensors[0] < 600) synthFrequency1.setValue(698);
  else if (sensors[0] >=600 && sensors[0] < 650) synthFrequency1.setValue(784);  
  else if (sensors[0] >=650 && sensors[0] < 700) synthFrequency1.setValue(880);
  else if (sensors[0] >=700 && sensors[0] < 750) synthFrequency1.setValue(988);
  else if (sensors[0] >=750) synthFrequency1.setValue(41.2);

  
  if (sensors[1] < 50) synthFrequency2.setValue(1);
  else if (sensors[1] >=50 && sensors[1] < 100) synthFrequency2.setValue(261);
  else if (sensors[1] >=100 && sensors[1] < 150) synthFrequency2.setValue(294);
  else if (sensors[1] >=150 && sensors[1] < 200) synthFrequency2.setValue(330);
  else if (sensors[1] >=200 && sensors[1] < 250) synthFrequency2.setValue(370);
  else if (sensors[1] >=250 && sensors[1] < 300) synthFrequency2.setValue(392);  
  else if (sensors[1] >=300 && sensors[1] < 350) synthFrequency2.setValue(440);
  else if (sensors[1] >=350 && sensors[1] < 400) synthFrequency2.setValue(494);
  else if (sensors[1] >=400 && sensors[1] < 450) synthFrequency2.setValue(523);
  else if (sensors[1] >=450 && sensors[1] < 500) synthFrequency2.setValue(587);
  else if (sensors[1] >=500 && sensors[1] < 550) synthFrequency2.setValue(659);
  else if (sensors[1] >=550 && sensors[1] < 600) synthFrequency2.setValue(698);
  else if (sensors[1] >=600 && sensors[1] < 650) synthFrequency2.setValue(784);  
  else if (sensors[1] >=650 && sensors[1] < 700) synthFrequency2.setValue(880);
  else if (sensors[1] >=700 && sensors[1] < 750) synthFrequency2.setValue(988);
  else if (sensors[1] >=750) synthFrequency2.setValue(49);


}
  
void serialEvent(Serial port) {
  String sensorReading = port.readStringUntil('\n');
  sensorReading = trim(sensorReading);
  
  sensors = float(split(sensorReading, ','));   // Splint sensor input at the
                                                // comma and render as a float
                                                // and enter into the array 
  
  for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++) {
    print ("Sensor " + sensorNum + ": " + sensors[sensorNum] + "\n");
  }
    
  port.write("A"); // Sending data to the port will ensure that the script
                   // is communicating with the Arduino.
}
