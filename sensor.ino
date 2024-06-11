#include <WiFi.h>
#include <Wire.h>
#include "MAX30105.h"

MAX30105 particleSensor1;
MAX30105 particleSensor2;
MAX30105 particleSensor3;

#define debug Serial
#define TCAADDR 0x70

const char *ssid = "your_wifi_name"; //  OnePlus 7T
const char *password = "password"; // 12345678
const char* server_ip = "192.168.53.212";  // 192.168.25.212
const int server_port = 12345;  

WiFiClient client;

void tcaselect(uint8_t i) { 
  if (i > 7) return;
  Wire.beginTransmission(TCAADDR);
  Wire.write(1 << i);
  Wire.endTransmission();
}


void setup()
{
  debug.begin(115200);
  //debug.println("MAX30105 Basic Readings Example");
  Wire.begin();
  WiFi.begin(ssid,password);
  while(WiFi.status()!=WL_CONNECTED)  
  {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  byte ledBrightness = 0xBB; //Options: 0=Off to 255=50mA
  byte sampleAverage = 4; //Options: 1, 2, 4, 8, 16, 32
  byte ledMode = 3; //Options: 1 = Red only, 2 = Red + IR, 3 = Red + IR + Green
  int sampleRate = 800; //Options: 50, 100, 200, 400, 800, 1000, 1600, 3200
  int pulseWidth = 411; //Options: 69, 118, 215, 411
  int adcRange = 16384; //Options: 2048, 4096, 8192, 16384
  tcaselect(1);
  if (particleSensor1.begin() == false)
  {
    while (1);
  }
  particleSensor1.setup(ledBrightness, sampleAverage, ledMode, sampleRate, pulseWidth, adcRange); //Configure sensor with these settings

  tcaselect(2);
  if (particleSensor2.begin() == false)
  {
    while (1);
  }
  particleSensor2.setup(ledBrightness, sampleAverage, ledMode, sampleRate, pulseWidth, adcRange); //Configure sensor with these settings

  tcaselect(4);
  if (particleSensor3.begin() == false)
  {
    while (1);
  }
  particleSensor3.setup(ledBrightness, sampleAverage, ledMode, sampleRate, pulseWidth, adcRange); //Configure sensor with these settings
}



void loop()
{
  String final, s1,s2,s3;
  if (client.connect(server_ip, server_port)) 
  {
    tcaselect(1);
    s1 = String(particleSensor1.getIR()) ;
    
    tcaselect(2);
    s2 = String(particleSensor2.getIR());
    
    tcaselect(4);
    s3 = String(particleSensor3.getIR());
  }
  final = s1 + "," + s2 + "," + s3 ;
  client.print(final);
  client.stop();
}
