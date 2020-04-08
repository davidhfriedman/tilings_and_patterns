class Segment {
  Segment(PVector _a, PVector _b) {
    a = _a;
    b = _b;
  }
  void display() {
    stroke(0);
    strokeWeight(1);
    noFill();
    line(a.x, a.y, b.x, b.y);
  }
  PVector a;
  PVector b;
};

void displaySegments() {
  clear();
  for (Segment seg : segments) {
    seg.display();
  }
}

ArrayList<Segment> segments = new ArrayList<Segment>();
int sX, sY, eX, eY;

ArrayList<PVector> intersections = new ArrayList<PVector>();

void setup() {
  size(640, 360);
  noSmooth();
  fill(0);
  clear();
}

void clear() {
    background(255);
  /*for(int i = 0; i < 7; i++) {
    segments.add(new Segment(new PVector(int(random(width)), int(random((height)))), new PVector(int(random(width)), int(random(height)))));
  }*/
  noStroke();
  fill(color(90,16,16));
  rect(10,10,80,50);
}

float EPS = 0.000001;

boolean feq(float f, float g) {
  return abs(f-g) < EPS;
}

class MaybePVector {
  boolean just;
  PVector p;
  MaybePVector(boolean _j, PVector _p) {
    just = _j;
    if (just) {
      p = _p;
    }
  }
}

MaybePVector intersect(Segment s1, Segment s2) {
  /*
  y = m1x + b1
  y = m2x + b2
  
  if m1 = m2 and b1 = b2 the lines are identical
  if m1 = m2 and b1 != b2 the lines are parallel
  otherwise, the lines intersect at (x,y):
  
  m1x + b1 = m2x + b2
  (m1-m2)x = b2 - b1
  x = (b2 - b1)/(m1 - m2)
  y = m1[(b2 - b1)/(m1 - m2)] + b1
  
  y = mx + b
  m = (y1-y0)/(x1-x0)
  b = y0 - mx0
  
           /|(x1,y1)
          / |
         /  |
  (x0,y0)----
  */
  
  float m1 = (s1.b.y - s1.a.y) / (s1.b.x - s1.a.x);
  float b1 = s1.a.y - m1 * s1.a.x;
  float m2 = (s2.b.y - s2.a.y) / (s2.b.x - s2.a.x);
  float b2 = s2.a.y - m2 * s2.a.x;
  if (feq(m1, m2)) {
    return new MaybePVector(false, null);
  } else {
    float x = (b2 - b1)/(m1 - m2);
    float y = m1 * x + b1;
    PVector i = new PVector(x, y);
    return new MaybePVector(true, i);
  }
}

void weave() {
  for(Segment s1: segments) {
    for(Segment s2: segments) {
      if (s1.a == s2.a && s1.b == s2.b) {
        continue;
      }
      MaybePVector mp = intersect(s1, s2);
      if (mp.just) {
         fill(color(255, 0, 0));
         circle(mp.p.x, mp.p.y, 5);
      }
    }
  }
}

void mousePressed() {
  if (10 <= mouseX && mouseX < 80 && 10 < mouseY && mouseY < 50) {
    return;
  } else {
    ellipseMode(RADIUS);
    stroke(0);
    strokeWeight(1);
    fill(0);
    sX = mouseX;
    sY = mouseY;
    circle(sX, sY, 5);
  }
}

void drawNewSegment() {
  ellipseMode(RADIUS);
  displaySegments();
  eX = mouseX;
  eY = mouseY;
  stroke(0);
  strokeWeight(1);
  fill(0);
  circle(sX, sY, 5);
  line(sX, sY, eX, eY);
  circle(eX, eY, 5);
}

void mouseDragged() {
  if (mouseX < 80 && mouseY < 50) {
    return;
  } else {
    drawNewSegment();
  }
}

void mouseReleased() {
  if (10 <= mouseX && mouseX < 80 && 10 < mouseY && mouseY < 50) {
    weave();
  } else {
    segments.add(new Segment(new PVector(sX, sY), new PVector(eX, eY)));
    displaySegments();
  }
}
  
void draw() {
}
