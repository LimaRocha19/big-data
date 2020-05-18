#include <Wire.h>
#include <Adafruit_ADS1015.h>
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <EmonLib.h>

EnergyMonitor emon;

const char* ssid     = "UBUNTU";
const char* password = "amanuense";
const char* mqtt_server = "test.mosquitto.org";

//const int analogInPin = A0;  // ESP8266 Analog Pin ADC0 = A0
 
#define   ADC_16BIT_MAX   65536
 
Adafruit_ADS1115 ads(0x48);
 
float ads_bit_Voltage;

WiFiClient espClient;
PubSubClient client(espClient);
unsigned long lastMsg = 0;
#define MSG_BUFFER_SIZE  (50)
char msg[MSG_BUFFER_SIZE];
int value = 0;

void setup_wifi() {

//  emon.current(analogInPin, 90);

  delay(10);
  // We start by connecting to a WiFi network
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  randomSeed(micros());

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println();

  // Switch on the LED if an 1 was received as first character
  if ((char)payload[0] == '1') {
    digitalWrite(BUILTIN_LED, LOW);   // Turn the LED on (Note that LOW is the voltage level
    // but actually the LED is on; this is because
    // it is active low on the ESP-01)
  } else {
    digitalWrite(BUILTIN_LED, HIGH);  // Turn the LED off by making the voltage HIGH
  }

}

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Create a random client ID
    String clientId = "ESP8266Client-";
    clientId += String(random(0xffff), HEX);
    // Attempt to connect
    if (client.connect(clientId.c_str())) {
      Serial.println("connected");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 1 second");
      // Wait 1 second before retrying
      delay(1000);
    }
  }
}
 
void setup(void) {

  pinMode(LED_BUILTIN, OUTPUT);
  
  Serial.begin(115200);
  while (!Serial);

  ads.setGain(GAIN_ONE);        // 1x gain   +/- 4.096V  1 bit = 2mV      0.125mV
  ads.begin();
 
  float ads_InputRange = 4.096f;
 
  ads_bit_Voltage = (ads_InputRange * 2) / (ADC_16BIT_MAX - 1);

  setup_wifi();
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
}

void readPower() {
  int16_t ads_ch0 = 0;
  float ads_Voltage_ch0 = 0.0f;

  int16_t ads_ref = 0;
  float ads_Voltage_ref = 0.0f;

  ads_ref = ads.readADC_SingleEnded(0);
  ads_Voltage_ref = ads_ref * ads_bit_Voltage;

  /* loop para amostragem do sinal e cálculo do valor eficaz 
     por hora estou calculando valor direto da tensão do ADC 
     mas depois preciso converter conforme as grandezas do
     sensor de corrente instalado */

  int i;
  int n = 200;
  float squares = 0;
  float rms;
  float power;

  for (i = 0; i < n; i++) {
    ads_ch0 = ads.readADC_SingleEnded(2);
    ads_Voltage_ch0 = 1.5 * ((ads_ch0 * ads_bit_Voltage - ads_Voltage_ref)) * 2000 / 44;
    
    squares = squares + ads_Voltage_ch0 * ads_Voltage_ch0;
//    delayMicroseconds(1);
  }

  rms = sqrt(squares * 1 / n);
  power = 127 * rms;

  Serial.print("Reading RMS A: ");
  Serial.println(rms, 3);

  squares = 0;

  for (i = 0; i < n; i++) {
    ads_ch0 = ads.readADC_SingleEnded(3);
    ads_Voltage_ch0 = 1.5 * ((ads_ch0 * ads_bit_Voltage - ads_Voltage_ref)) * 2000 / 44;
    
    squares = squares + ads_Voltage_ch0 * ads_Voltage_ch0;
//    delayMicroseconds(1);
  }

  rms = sqrt(squares * 1 / n);
  power = power + 127 * rms;

  Serial.print("Reading RMS B: ");
  Serial.println(rms, 3);

  Serial.print("Reading Watts: ");
  Serial.println(power, 3);
  Serial.print("\t");

  snprintf (msg, MSG_BUFFER_SIZE, "{\"watts\":%f,\"phase\":\"both\"}", power);

  Serial.println(msg);
  Serial.print("\t");

  client.publish("lima", msg);
}
 
void loop(void) { 
  
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
   
  readPower();
  
}
