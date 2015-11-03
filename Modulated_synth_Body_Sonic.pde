/*This script uses the Beads library to create a virtual modulated synthesizer.
This creates a much less melodic and much more aggressive sound.*/


// Importing serial library and Beads library
import processing.serial.*;
import beads.*;

// Setting up AudioContext. The audio context acts as the main "output" for the
// virtual synthesizers.
AudioContext ac;

// Setting up WavePlayers. WavePlayers generate tones in the virtual synthesizer.
// In a modulated synthesizer, the carrier WavePlayers are "modulated" by the
// modulator WavePlayers to create a more complex sound.
WavePlayer modulator;
WavePlayer modulator2;
WavePlayer carrier;
WavePlayer carrier2;

// Setting up glides for the synths. Glides are able to make changes in the
// virtual synthesizers, the way keys or knobs might in a physical synth.
Glide modulatorFrequency;
Glide modulatorFrequency2;

// Setting up gain. Gains control volume.
Gain g;

// Setting up mapped values. This allows us to change the values from the
// sensors to values that would be in the frequency range you want to produce.
// This is an alternative to setting specific frequencies for specific sensor
// readings as is done in Tuned_synth_Body_Sonic
float mapped1;
float mapped2;

//Setting up serial port
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
  
  // create audio context, necessary as the main output
  ac = new AudioContext();
  
  // create glides for the modulator frequencies
  // (context, setting, time in milliseconds)
  // the "setting" in this case is frequency in Hz. The milliseconds is the
  // delay in changing from one value to the next.
  modulatorFrequency = new Glide(ac, 20, 30);
  modulatorFrequency2 = new Glide(ac, 20, 30);
  
  // create Wave Players to generate sound
  // (context, frequency, type)
  modulator = new WavePlayer(ac, modulatorFrequency, Buffer.SINE);
  modulator2 = new WavePlayer(ac, modulatorFrequency2, Buffer.SINE);
  
  // Set up functions to create modulation
  // This takes the WavePlayer "modulator" and adds modulation to it
  Function frequencyModulation = new Function(modulator) {
    public float calculate() {     // overriding the standard calculation for sound
      return (x[0]) + mapped1;  // returns the modulator's original value
                                  // multiplied by 100 so that it oscillates in
                                  // a wider range and then adding the mouseY
                                  //to change it up
    }
  };
    
    // Second modulator is same as the first (basically)
    // but it allows you to change the parameters of the modulation for a
    // second unit generator
  Function frequencyModulation2 = new Function(modulator2) {
    public float calculate() {
      return(x[0]) + mapped2;
      }
    };
    
  // set up carrier Wave Players to take the modulator Wave Player
  carrier = new WavePlayer(ac, frequencyModulation, Buffer.SINE);
  carrier2 = new WavePlayer(ac, frequencyModulation2, Buffer.SINE);
  
  // set the main volume (context, number of outputs, value in percent)
  g = new Gain(ac, 1, 0.5);
  
  // connect up elements of the synthesizer
  // adding sound inputs to the gain, the two carrier signals
  g.addInput(carrier);
  g.addInput(carrier2);
  
  // add volume to the main audio context
  ac.out.addInput(g);
  
  // begin audio
  ac.start();
}

void draw() {
  // set frequency glide values to the numbers stored in the array
  if ((sensors[0] <=80) && (sensors[1] <=80)) {
    g.setGain(0);
    modulatorFrequency.setValue(0);
    modulatorFrequency2.setValue(0);
  }
  
  else if ((sensors[0] > 80 && sensors[0] <=500) && (sensors[1] > 80 && sensors[1] <=500)) {
    g.setGain(50);
    mapped1 = map(sensors[0], 80, 1023, 500, 2000);
    modulatorFrequency.setValue(mapped1);
    mapped2 = map(sensors[1], 80, 1023, 500, 2000);
    modulatorFrequency2.setValue(mapped2);
  }
  
  else {
    g.setGain(100);
    mapped1 = map(sensors[0], 501, 1023, 50, 200);
    mapped2 = map(sensors[1], 501, 1023, 50, 200);
  }
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
    
  port.write("A");
}
