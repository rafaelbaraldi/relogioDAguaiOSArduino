/*
Arduino Water flow meter
YF- S201 Hall Effect Water Flow Sensor
Water Flow Sensor output processed to read in litres/hour
*/
volatile int flow_frequency; // Measures flow sensor pulses
unsigned int l_hour; // Calculated litres/hour
unsigned char flowsensor = 2; // Sensor Input
unsigned long currentTime;
unsigned long cloopTime;
unsigned long totalMilliLitres;
byte statusLed    = 13;

int val;
void flow () // Interrupt function
{
   flow_frequency++;
}
void setup()
{

   
  // Set up the status LED line as an output
  pinMode(statusLed, OUTPUT);
  digitalWrite(statusLed, HIGH);  // We have an active-low LED attached
  
   pinMode(flowsensor, INPUT);
   digitalWrite(flowsensor, HIGH); // Optional Internal Pull-Up
   Serial.begin(9600);
   attachInterrupt(0, flow, RISING); // Setup Interrupt
   sei(); // Enable interrupts
   currentTime = millis();
   cloopTime = currentTime;
}
void loop ()
{

  if(Serial.available()) //
  {
    val = Serial.read();
    if(val =='A')  //if comes a 'A',LED on control board will blink
    {
      totalMilliLitres=0;
      digitalWrite(statusLed, HIGH);
//      Serial.println("ligado");  //print on Serial debugging assistant on computer
    }
    else if(val == 'B'){
      totalMilliLitres=0;
      digitalWrite(statusLed, LOW);
//      Serial.println("desligado");  //print on Serial debugging assistant on computer
    }
  }
  
   currentTime = millis();
   // Every second, calculate and print litres/hour
   if(currentTime >= (cloopTime + 1000))
   {
      cloopTime = currentTime; // Updates cloopTime
      // Pulse frequency (Hz) = 7.5Q, Q is flow rate in L/min.
      l_hour = (flow_frequency * 60 / 7.5); // (Pulse frequency x 60 min) / 7.5Q = flowrate in L/hour

      totalMilliLitres += l_hour / 3.6;
    
      flow_frequency = 0; // Reset Counter
//      Serial.print(l_hour, DEC); // Print litres/hour
//      Serial.println(" L/hour");
      Serial.print(totalMilliLitres, DEC);
      Serial.print("ml");
//      Serial.println("ml total \n");
   }
}
