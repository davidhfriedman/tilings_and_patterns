// "parity" - where lines cross, over, under, or not yet determined

public enum Parity {
  NA, OVER, UNDER
};

Parity toggle(Parity p) {
  if (p == Parity.NA) { return p; }
  else { return p == Parity.OVER ? Parity.UNDER : Parity.OVER; }
}

// width of ribbon

final float R = 10.0;

// numeric utilities

// for floating-point equality
float EPSilon = 0.000001;

boolean isInf(float in) {
  return in == Float.POSITIVE_INFINITY;
}

boolean isNegInf(float in) {
  return in == Float.NEGATIVE_INFINITY;
}

boolean feq(float f, float g) {
  return (isInf(f) && isInf(g)) || (isNegInf(f) && isNegInf(g)) || (abs(f-g) < EPSILON);
}

boolean veq (PVector a, PVector b) {
  return feq(a.x, b.x) && feq(a.y, b.y);
}

int nextIntersectionLabel = 0;

class Intersection {
  PVector p;
  Parity parity;
  Segment s1, s2;
  String label;
  Intersection(PVector _p, Parity _parity, Segment _s1, Segment _s2) {
    p = _p;
    parity = _parity;
    s1 = _s1;
    s2 = _s2;
    label = nf(nextIntersectionLabel++);
  }
}

import java.util.Collections;
import java.util.Comparator;

class SortIntersectionsByY implements Comparator<Intersection> {
  @Override
  public int compare(Intersection a, Intersection b) {
    float f = a.p.y - b.p.y;
    if (f < 0) return -1;
    else if (f > 0) return 1;
    else return 0;
  }
}

class SortIntersectionsByX implements Comparator<Intersection> {
  @Override
  public int compare(Intersection a, Intersection b) {
    float f = a.p.x - b.p.x;
    if (f < 0) return -1;
    else if (f > 0) return 1;
    else return 0;
  }
}

Comparator<Intersection> sortIntersectionsByX = new SortIntersectionsByX();
Comparator<Intersection> sortIntersectionsByY = new SortIntersectionsByY();

char nextSegmentLabel = 'a';

class Segment {
  Segment(PVector _a, PVector _b) {
    a = _a;
    b = _b;
    m = (b.y - a.y) / (b.x - a.x);
    yInt = a.y - m * a.x;
    intersections = new ArrayList<Intersection>();
    visited = false;
    label = nextSegmentLabel;
    nextSegmentLabel++;
  }
  void display() {
    stroke(0);
    strokeWeight(1);
    noFill();
    line(a.x, a.y, b.x, b.y);
    text(label, a.x-10, a.y+10);
  }
  String toString() {
    String s = "<Segment (" + a.x + "," + a.y +") (" + b.x + "," + b.y +") [" + intersections + "]";
    //for(int i: intersections+ "]>";
    return s;
  }
  PVector a;
  PVector b;
  float m;
  float yInt;
  ArrayList<Intersection> intersections;
  boolean visited;
  char label;
};

void displaySegments() {
  clear();
  for (Segment seg : segments) {
    //println("display ", seg.label);
    seg.display();
  }
}

ArrayList<Segment> segments = new ArrayList<Segment>();
int sX, sY, eX, eY;




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
  if (feq(s1.m, s2.m)) {
    return new MaybePVector(false, null, false);
  } else {
    float x = (s2.yInt - s1.yInt)/(s1.m - s2.m);
    float y = s1.m * x + s1.yInt;
    if (isInf(abs(s1.m)) && !isInf(abs(s2.m))) {
      // s1 is vertical
      x = s1.a.x;
      y = s2.m * x + s2.yInt;
    } else if (!isInf(abs(s1.m)) && isInf(abs(s2.m))) {
      // s2 is vertical
      x = s2.a.x;
      y = s1.m * x + s1.yInt;
    } 
    //println("Intersect: m1, m2 ", s1.m, s2.m, "; x, y ", x, y);
    // make sure it is on the segments
    boolean onsegs = inRange(s1.a.x, s1.b.x, x)
                  && inRange(s1.a.y, s1.b.y, y)
                  && inRange(s2.a.x, s2.b.x, x)
                  && inRange(s2.a.y, s2.b.y, y);
    PVector i = new PVector(x, y);
    return new MaybePVector(true, i, onsegs);
  }
}

/*
void addIntersectionToSegments(Segment s1, Segment s2, Intersection i) {
  s1.intersections.add(i);
  s2.intersections.add(Integer.valueOf(i));
}
*/


void find_all_intersections() {
  //gIntersections = new ArrayList<Intersection>();
  for(Segment s: segments) {
    s.intersections = new ArrayList<Intersection>();
  }
    
  for(int i = 0; i < segments.size(); i++) {
    for(int j = i+1; j < segments.size(); j++) {
      Segment s1 = segments.get(i);
      Segment s2 = segments.get(j);
      MaybePVector mp = intersect(s1, s2);
      if (mp.just && mp.onsegs) {
        //println("Adding intersection", mp.p.x, mp.p.y);
        s1.intersections.add(new Intersection(mp.p, Parity.NA, s1, s2));
        s2.intersections.add(new Intersection(mp.p, Parity.NA, s2, s1));
      }
    }
  }
  
  // sort the intersections on each segment by increasinging x (or y if vertical)
  
  for(Segment s: segments) {
    if (isInf(abs(s.m))) {
      //println("before by Y:", s.m, s.intersections);
      Collections.sort(s.intersections, sortIntersectionsByY);
    } else {
      //println("before by X:", s.m, s.intersections);
      Collections.sort(s.intersections, sortIntersectionsByX);
    }
    //println("after:", s.intersections);
  }
}
  
class Unit {
  Segment s;
  int i;
  Parity p;
  Unit(Segment _s, int _i, Parity _p) {
    s = _s;
    i = _i;
    p = _p;
  }
}

Stack stack;
Parity p;

boolean mark(Segment segment, int i, Parity p) {
  //println("mark \"", segment.label, "\"", i, "\"", segment.intersections.get(i).label, "\"", p);
  Intersection intersection = segment.intersections.get(i);
  Segment otherSegment = intersection.s2;
  if (intersection.parity == Parity.NA) {
    //println("  NA, marking", p, "...");
    intersection.parity = p;
    for(int k = 0; k < otherSegment.intersections.size(); k++) {
      if (otherSegment.intersections.get(k).s2 == segment) {
        //print("  found other segment \"", otherSegment.label);
        //print(k, "\"", otherSegment.intersections.get(k).label, "\"");
        //println(otherSegment.intersections.get(k).parity);  
        if (otherSegment.intersections.get(k).parity == Parity.NA) {
          stack.push(otherSegment, k, toggle(p));
          break;
        } else {
          //println("  already marked, skipping  ");
        }
      }
    }
    return true;
  } else if (intersection.parity == p) {
    //println("  already marked ", p, "returning true... ");
    return true;
  } else {
    //println("  inconsistency: want to mark ", p, " already marked ", intersection.parity);
    return false;
  }
}


class Stack {
  ArrayList<Unit> s;
  Stack() {
    s = new ArrayList<Unit>();
  }
  void push(Segment seg, int i, Parity p) {
    //println("PUSH segment \"", seg.label, "\" intersection ", i, "\"", seg.intersections.get(i).label, "\"", p);
    s.add(new Unit(seg, i, p));
  }
  Unit pop() {
    Unit u = s.remove(s.size()-1);
    //println("POP segment \"", u.s.label, "\" intersection ", u.i, "\"", u.s.intersections.get(u.i).label, "\"", u.p);
    return u;
  }
  boolean empty() {
    return s.size() == 0;
  }
}

void flood() {

  println("flood.");

  while (!stack.empty()) {
    Unit u = stack.pop();
    Segment s = u.s;
    p = u.p;
    if (mark(s, u.i, p)) {
      p = toggle(p);
      Parity savedParity = p;
      for(int k = u.i+1; k < s.intersections.size(); k++) {
        if (mark(s, k, p)) {
          p = toggle(p);
          } else {
            break;
          }
        }
        p = savedParity;
        for(int k = u.i-1; k >= 0; k--) {
          if (mark(s, k, p)) {
            p = toggle(p);
          } else {
            break;
          }
        }
      } else {
        break;
      }
      s.visited = true;
  }
}

void weave() {
  
  println("weave.");
  
  find_all_intersections();
  
  for(Segment s: segments) {
    s.visited = false;
  }
  
  stack = new Stack();
  p = Parity.OVER;
  
  while (true) {
    // any disconnected regions not yet visited?
    int seg = -1;
    for(int i = 0; i < segments.size(); i++) {
      if (segments.get(i).intersections.size() > 0 && !segments.get(i).visited) {
        seg = i;
        break;
      }
    }
    if (seg == -1) {
      // none left, done
      break;
    }
    stack.push(segments.get(seg), 0, p);
    flood();
  }  
  
  render();
}

void Line(float ax, float ay, float bx, float by, float m, float r) {
  stroke(0);
  strokeWeight(1);
  if (isInf(abs(m))) {
    float R = r/2;
    line(ax + R, ay, bx + R, by);
    line(ax - R, ay, bx - R, by);
  } else if (feq(m, 0)) {
    float R = r/2;
    line(ax, ay - R, bx, by - R);
    line(ax, ay + R, bx, by + R);
  } else {
    float dx =  (r/2) / sqrt(1 + 1/(m*m));
    float dy = (-1/m) * dx;
    //println("width:", r, "slope:", m, "dx:", dx, "dy:", dy);
    line(ax, ay, bx, by);
    line(ax + dx, ay + dy, bx + dx, by + dy);
    line(ax - dx, ay - dy, bx - dx, by - dy);
  }
}

void render() {
  clear();
  for(Segment s: segments) {
    Line(s.a.x, s.a.y, s.b.x, s.b.y, s.m, R);
    for(Intersection i: s.intersections) {
      switch (i.parity) {
        case NA: {
          //println("NA: ", s.label, i.label);
          fill(color(200, 200, 200));
          circle(i.p.x, i.p.y, 5);
          //fill(0);
          text(i.label, i.p.x+10, i.p.y+10);
          break;
        }
        case OVER: {
          //println("OVER: ", s.label, i.label);
          fill(color(255, 0, 0));
          circle(i.p.x, i.p.y, 5);
          //fill(0);
          text(i.label, i.p.x+10, i.p.y+10);
          break;
        }
        case UNDER: {
          //println("UNDER: ", s.label, i.label);
          fill(color(0, 255, 0));
          circle(i.p.x+3, i.p.y+3, 5);
          //fill(0);
          text(i.label, i.p.x+10, i.p.y+25);
          break;
        }
        default: {
          println("ERROR: ", s.label, i.label);
          fill(color(0, 150, 150));
          circle(i.p.x, i.p.y, 8);
          fill(0);
          text(i.label, i.p.x+10, i.p.y+10);
          break;
        }
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
