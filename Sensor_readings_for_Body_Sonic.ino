/*This program will capture data from sensors. As written, the program will
work for two sensors. However, you can easily change this by simply initializing
more variables for the sensors. Depending on the model of Arduino you use,
connecting more than two sensors may be difficult (or impossible).*/

int firstSensor = 0;
int secondSensor = 0;

/* The inByte variable is not necessary to run on all
Arduinos. However, if you are having trouble, using
the inByte variable to check that you are getting a
valid byte may be useful.*/ 

// int inByte = 0; 


void setup()
{
  // start serial port at 9600 bps and wait for port to open:
  Serial.begin(9600);  
  pinMode(2, INPUT);   // digital sensor is on digital pin 2; modify for your sensors
  establishContact();  // send a byte to establish contact until receiver responds 
}

void loop()
{
  if (Serial.available() > 0) {
    
    /*If you are having trouble, consider using the inByte variable to test here*/
    // inByte = Serial.read();
    
    /*make sure to use the pin name that you have the sensors connected to. As an example, this uses
    pins A0 and A1. Again, you may initialize more variables above and assign more pins here.*/
    
    firstSensor = analogRead(A0);
    
    secondSensor = analogRead(A1);
    
    /*The included processing script uses ',' to delineate the pieces of data.*/
    Serial.print(firstSensor);
    Serial.print(",");
    Serial.print(secondSensor);
    Serial.print('\n');
  }
}

 void establishContact() {
  while (Serial.available() <= 0) {
    
    /*Printing this initial string will let you see whether your computer is connecting to the
    Arduino. If you do not receive anything in the terminal, something is wrong with the Arduino
    or the connectio to the Arduino. If you only receive 0,0 and it does not change, something is
    wrong with the Processing script or with the sensors themselves. The sensors can be finicky.*/
    Serial.println("0,0");
    
    /*You may change the delay. A longer delay will be slightly easier for the Processing script to
    work with. However, longer delays will also not produce as clear of tones.*/
    
    delay(300);
  }
} 
