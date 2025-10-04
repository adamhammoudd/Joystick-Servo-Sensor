# Joystick-Servo-Sensor

A real-time radar simulation using an Arduino, servo motor, ultrasonic sensor, joystick module, and a Processing sketch for visualization. This project reads distance data from an ultrasonic sensor, controls a servo motor based on a joystick, and displays the radar sweep and detected objects on a computer screen.

---

## 📸 Circuit Diagram

![Image](./Joystick-Servo-Sensor/Joystick-Servo-Sensor/Circuit Image.png)  

---

## ⚙️ Hardware Required

- Arduino Uno (or compatible)
- HC-SR04 Ultrasonic Distance Sensor
- Servo Motor (e.g., SG90)
- Joystick Module (X-axis used for servo control)
- Breadboard & jumper wires
- USB cable for Arduino connection

---

## 🧩 Circuit Connections

**Ultrasonic Sensor (HC-SR04):**
- VCC → 5V
- GND → GND
- TRIG → Pin 12
- ECHO → Pin 11

**Servo Motor:**
- Signal → Pin 9
- VCC → 5V
- GND → GND

**Joystick Module:**
- X-axis → A0
- Y-axis → (unused)
- SW → Pin 2
- VCC → 5V
- GND → GND

---

## 💻 Software Required

- [Arduino IDE](https://www.arduino.cc/en/software)
- [Processing](https://processing.org/download/)
- Arduino libraries:
  - `Servo`
  - `SR04` (HC-SR04 sensor library)

---

## ⚡ Arduino Setup

1. Open the Arduino IDE.
2. Install the `SR04` and `Servo` libraries if you haven’t already.
3. Copy the Arduino code (`.ino`) into a new sketch.
4. Connect your Arduino via USB.
5. Select the correct board and port in **Tools > Board** and **Tools > Port**.
6. Upload the sketch to your Arduino.

---

## 🖥️ Processing Setup

1. Install [Processing](https://processing.org/download/).
2. Open a new sketch and paste the Processing code (`.pde`) into it.
3. Ensure the serial port in the code matches your Arduino connection:

```java
port = new Serial(this, "COM4", 9600);
```
Replace "COM4" with your Arduino’s actual serial port.

4. Run the Processing sketch. You should see:
   - A radar sweep line moving with the joystick
   - Red beams when objects are detected
   - Angle and distance displayed on the bottom panel

## 🚀 How It Works
1. Arduino reads distance from the HC-SR04 ultrasonic sensor.
2. Joystick input controls the servo angle.
3. Arduino sends data to the computer via serial in the format:
```matlab
angle,distance.
```
4. Processing reads the serial data and:
   - Smoothly animates the radar sweep
   - Draws a fading beam trail
   - Displays detected objects as red lines
   - Updates the HUD with angle, distance, and range status

## 🖌️ Features
- Smooth radar sweep with color-preserving beam trails
- Real-time distance detection visualization
- Bright red lines for detected objects
- Informative HUD with distance and angle markers
- Adjustable smoothing and trail length

## 📦 Folder Structure
```
Joystick-Servo-Sensor/
├─ Joystick-Servo-Sensor/
│ ├─ Libraries/
│ │  ├─ HC-SR04.zip
│ │  └─ Servo.zip
│ ├─ Processing Code/
│ │  └─ processing_joystick_servo_sensor/
│ │     └─ processing_joystick_servo_sensor.pde
│ ├─ Circuit Image.png
│ ├─ Joystick-Servo-Sensor.ino
├─ LICENSE
└─ README.md
```
## 🔧 Customization
- Adjust trail length: change maxTrailLength in the Processing code.
- Adjust beam persistence: change fill(0, 8) in draw() for longer/shorter fading.
- Adjust servo response: tweak the easing factor in the Arduino code for smoother or faster movement.

⚡ License
This project is open-source and free to use under the MIT License.
