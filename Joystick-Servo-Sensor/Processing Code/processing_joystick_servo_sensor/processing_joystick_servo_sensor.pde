import processing.serial.*;
import java.awt.event.KeyEvent;
import java.io.IOException;

Serial port;

// Incoming data
String rawData = "";
int parsedAngle = 90;
int parsedDistance = 0;

// Smooth transitions
float smoothAngle = 90;
float smoothDistance = 0;

// Radar constants
color radarGreen = color(98, 245, 31);
int maxDistance = 40; // in cm

void setup() {
  size(1200, 700);
  smooth(8);
  frameRate(60);
  
  // Initialize serial connection
  port = new Serial(this, "COM4", 9600);
  port.bufferUntil('.');
}

void draw() {
  // Create smooth fading background for motion trails
  noStroke();
  fill(0, 20);   // Slightly higher alpha for a cleaner trailing effect
  rect(0, 0, width, height);

  drawRadar();
  drawDirectionLine();
  drawDetectedObject();
  drawHUD();
}

// ⬇️ Serial Event Handler
void serialEvent(Serial port) {
  rawData = port.readStringUntil('.');
  if (rawData != null) {
    rawData = trim(rawData.substring(0, rawData.length() - 1));
    int commaIndex = rawData.indexOf(',');
    if (commaIndex > 0) {
      try {
        parsedAngle = int(rawData.substring(0, commaIndex));
        parsedDistance = int(rawData.substring(commaIndex + 1));
      } catch (Exception e) {
        // Ignore malformed data
      }
    }
  }
}

// ⬇️ Draw radar arcs and guides
void drawRadar() {
  pushMatrix();
  translate(width / 2, height - height * 0.074);
  noFill();
  stroke(radarGreen);
  strokeWeight(2);

  float[] arcScales = {0.0625, 0.27, 0.479, 0.687};
  for (float scale : arcScales) {
    arc(0, 0, width - width * scale, width - width * scale, PI, TWO_PI);
  }

  // Horizontal line and angled guides
  line(-width / 2, 0, width / 2, 0);
  for (int angle = 30; angle <= 150; angle += 30) {
    line(0, 0,
      (-width / 2) * cos(radians(angle)),
      (-width / 2) * sin(radians(angle))
    );
  }

  // Angle labels (30°, 60°, 90°, 120°, 150°)
  fill(radarGreen);
  textSize(18);
  textAlign(CENTER, CENTER);
  for (int angle = 30; angle <= 150; angle += 30) {
    float labelX = (width / 2 - 60) * cos(radians(angle));
    float labelY = -(width / 2 - 60) * sin(radians(angle));
    text(angle + "°", labelX, labelY);
  }

  popMatrix();
}

// ⬇️ Draw the sweeping direction line
void drawDirectionLine() {
  smoothAngle = lerp(smoothAngle, parsedAngle, 0.4);

  pushMatrix();
  translate(width / 2, height - height * 0.074);
  stroke(30, 250, 60);
  strokeWeight(4);
  line(0, 0,
    (height - height * 0.12) * cos(radians(smoothAngle)),
    -(height - height * 0.12) * sin(radians(smoothAngle))
  );
  popMatrix();
}

// ⬇️ Draw the detected object based on distance
void drawDetectedObject() {
  smoothDistance = lerp(smoothDistance, parsedDistance, 0.25);

  if (smoothDistance <= maxDistance) {
    float distancePixels = smoothDistance * ((height - height * 0.1666) * 0.025);

    pushMatrix();
    translate(width / 2, height - height * 0.074);
    stroke(255, 50, 50);
    strokeWeight(7);
    line(
      distancePixels * cos(radians(smoothAngle)),
      -distancePixels * sin(radians(smoothAngle)),
      (width - width * 0.505) * cos(radians(smoothAngle)),
      -(width - width * 0.505) * sin(radians(smoothAngle))
    );
    popMatrix();
  }
}

// ⬇️ Draw the bottom info panel (HUD)
void drawHUD() {
  fill(0);
  noStroke();
  rect(0, height - height * 0.0648, width, height);

  fill(radarGreen);
  textSize(25);
  textAlign(LEFT, CENTER);

  // Distance markers along bottom
  text("10cm", width - width * 0.3854, height - height * 0.0833);
  text("20cm", width - width * 0.281, height - height * 0.0833);
  text("30cm", width - width * 0.177, height - height * 0.0833);
  text("40cm", width - width * 0.0729, height - height * 0.0833);

  // Live data display
  textSize(40);
  text("Angle: " + int(smoothAngle) + "°", width * 0.05, height - height * 0.03);
  text("Distance: " + int(smoothDistance) + " cm", width * 0.35, height - height * 0.03);

  // Status (In Range / Out of Range)
  String status = (parsedDistance > maxDistance) ? "OUT OF RANGE" : "IN RANGE";
  fill((parsedDistance > maxDistance) ? color(255, 60, 60) : radarGreen);
  text(status, width * 0.7, height - height * 0.03);
}
