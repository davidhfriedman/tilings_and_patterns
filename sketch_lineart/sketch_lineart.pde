void setup() {
  size(640, 360);
  noSmooth();
  fill(0);
  background(255);
}

int X;
int Y;

void mousePressed() {
  ellipseMode(RADIUS);
  stroke(0);
  strokeWeight(1);
  fill(0);
  X = mouseX;
  Y = mouseY;
  circle(X, Y, 5);
}

void mouseDragged() {
  stroke(0);
  strokeWeight(1);
  line(X, Y, mouseX, mouseY);
}

void mouseReleased() {
  ellipseMode(RADIUS);
  stroke(0);
  strokeWeight(1);
  fill(0);
  circle(mouseX, mouseY, 5);
}
  
void draw() {
}
