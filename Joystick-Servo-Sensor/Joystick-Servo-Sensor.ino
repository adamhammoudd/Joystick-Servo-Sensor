#include <SR04.h>
#include <Servo.h>

// Ultrasonic Sensor Pins
#define TRIG_PIN 12
#define ECHO_PIN 11 

SR04 sr04 = SR04(ECHO_PIN, TRIG_PIN);

// Servo
Servo servo;

// Joystick Pins
const int SW_pin = 2;
const int X_pin = A0;
const int Y_pin = A1;

// Variables
long distance;
float currentPos = 90;  // start centered
int targetPos = 90;

void setup() {
  servo.attach(9);
  pinMode(SW_pin, INPUT_PULLUP);
  Serial.begin(9600);
}

void loop() {
  // 🔸 1. Read distance
  distance = sr04.Distance();

  // 🔸 2. Read joystick and map to angle (0–180)
  int xValue = analogRead(X_pin);
  targetPos = map(xValue, 0, 1023, 0, 180);

  // 🔸 3. Smooth and fast movement using easing
  // 0.4 = faster reaction, still smooth
  currentPos += (targetPos - currentPos) * 0.4;
  servo.write(currentPos);

  // 🔸 4. Send data to Processing in "angle,distance." format
  Serial.print((int)currentPos);
  Serial.print(",");
  Serial.print(distance);
  Serial.print(".");

  // 🔸 5. Small delay for stability and responsiveness
  delay(5);
}
