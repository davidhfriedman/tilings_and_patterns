class Segment {
  Segment(PVector _a, PVector _b) {
    a = _a;
    b = _b;
    intersections = new IntList();
  }
  void display() {
    stroke(0);
    strokeWeight(1);
    noFill();
    line(a.x, a.y, b.x, b.y);
  }
  String toString() {
    String s = "<Segment (" + a.x + "," + a.y +") (" + b.x + "," + b.y +") [" + intersections + "]";
    //for(int i: intersections+ "]>";
    return s;
  }
  PVector a;
  PVector b;
  IntList intersections;
};

void displaySegments() {
  clear();
  for (Segment seg : segments) {
    seg.display();
  }
}

ArrayList<Segment> segments = new ArrayList<Segment>();
int sX, sY, eX, eY;

final int NA = 0;
final int OVER = 1;
final int UNDER = 2;

class Intersection {
  PVector p;
  int parity;
  int s1, s2;
  Intersection(PVector _p, int _parity, int _s1, int _s2) {
    p = _p;
    parity = _parity;
    s1 = _s1;
    s2 = _s2;
  }
}

ArrayList<Intersection> intersections = new ArrayList<Intersection>();

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
  boolean onsegs;
  boolean just;
  PVector p;
  MaybePVector(boolean _j, PVector _p, boolean _o) {
    just = _j;
    onsegs = _o;
    if (just) {
      p = _p;
    }
  }
}

boolean inRange(float a, float b, float x) {
  if (a < b) {
    return a <= x && x <= b;
  } else {
    return b <= x && x <= a;
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
    return new MaybePVector(false, null, false);
  } else {
    float x = (b2 - b1)/(m1 - m2);
    float y = m1 * x + b1;
    // make sure it is on the segments
    boolean onsegs = inRange(s1.a.x, s1.b.x, x)
                  && inRange(s1.a.y, s1.b.y, y)
                  && inRange(s2.a.x, s2.b.x, x)
                  && inRange(s2.a.y, s2.b.y, y);
    PVector i = new PVector(x, y);
    return new MaybePVector(true, i, onsegs);
  }
}

void addIntersectionToSegments(Segment s1, Segment s2, int i) {
  s1.intersections.append(i);
  s2.intersections.append(i);
}

boolean veq (PVector a, PVector b) {
  return feq(a.x, b.x) && feq(a.y, b.y);
}

void weave() {
  intersections = new ArrayList<Intersection>();
  for(Segment s: segments) {
    s.intersections = new IntList();
  }
    
  for(int i = 0; i < segments.size(); i++) {
    for(int j = i+1; j < segments.size(); j++) {
      Segment s1 = segments.get(i);
      Segment s2 = segments.get(j);
      MaybePVector mp = intersect(s1, s2);
      if (mp.just && mp.onsegs) {
        println("Adding intersection", mp.p.x, mp.p.y);
        intersections.add(new Intersection(mp.p, NA, i, j));
        int I = intersections.size()-1;
        addIntersectionToSegments(s1, s2, I);
      }
    }
  }
  
  // put all the Segments with any intersections on a list
  IntList segmentsToDo = new IntList();
  for(int i = 0; i < segments.size(); i++) {
    print(segments.get(i));
    if (segments.get(i).intersections.size() > 0) {
      segmentsToDo.append(i);
      println(" - ADDING");
    } else {
      println(" - Skipping");
    }
  }

  println("segments to do: ", segments);
  
  for(int i = 0; i < segmentsToDo.size(); i++) {
    stroke(80);
    strokeWeight(3);
    line(segments.get(i).a.x, segments.get(i).a.y, segments.get(i).b.x, segments.get(i).b.y);
  }
  
  /*
  int parity = OVER;
  while (segmentsToDo.size() > 0) {
    int s = segmentsToDo.remove(segmentsToDo.size()-1);
    for(int i = 0; i < segments.get(s).intersections.size(); i++) {
      intersections.get(segments.get(s).intersections.get(i)).parity = parity;
      parity = parity == OVER ? UNDER : OVER;
    }
    break;
  }
  */
  
  for(Intersection i: intersections) {
    println(i, i.p.x, i.p.y, i.parity);
    if (i.parity == NA) {
      fill(color(200, 200, 200));
    } else if (i.parity == OVER) {
      fill(color(255, 0, 0));
    } else if (i.parity == UNDER) {
      fill(color(0, 255, 0));
    } else {
      fill(color(0, 150, 150));
    }
    circle(i.p.x, i.p.y, 5);
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
