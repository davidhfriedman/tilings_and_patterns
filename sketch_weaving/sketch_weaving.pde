// "parity" - where lines cross, over, under, or not yet determined

final int NA = 0;
final int OVER = 1;
final int UNDER = 2;

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

ArrayList<Intersection> gIntersections = new ArrayList<Intersection>();

import java.util.Collections;
import java.util.Comparator;

class SortIntersectionsByY implements Comparator<Integer> {
  @Override
  public int compare(Integer a, Integer b) {
    float f = gIntersections.get(a).p.y - gIntersections.get(b).p.y;
    if (f < 0) return -1;
    else if (f > 0) return 1;
    else return 0;
  }
}

class SortIntersectionsByX implements Comparator<Integer> {
  @Override
  public int compare(Integer a, Integer b) {
    float f = gIntersections.get(a).p.x - gIntersections.get(b).p.x;
    if (f < 0) return -1;
    else if (f > 0) return 1;
    else return 0;
  }
}

Comparator<Integer> sortIntersectionsByX = new SortIntersectionsByX();
Comparator<Integer> sortIntersectionsByY = new SortIntersectionsByY();

char nextSegmentName = 'a';

class Segment {
  Segment(PVector _a, PVector _b) {
    a = _a;
    b = _b;
    m = (b.y - a.y) / (b.x - a.x);
    yInt = a.y - m * a.x;
    intersections = new ArrayList<Integer>();
    visited = false;
    name = nextSegmentName;
    nextSegmentName++;
  }
  void display() {
    stroke(0);
    strokeWeight(1);
    noFill();
    line(a.x, a.y, b.x, b.y);
    text(name, a.x-10, a.y+10);
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
  ArrayList<Integer> intersections;
  boolean visited;
  char name;
};

void displaySegments() {
  clear();
  for (Segment seg : segments) {
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

void addIntersectionToSegments(Segment s1, Segment s2, int i) {
  s1.intersections.add(Integer.valueOf(i));
  s2.intersections.add(Integer.valueOf(i));
}



void find_all_intersections() {
  gIntersections = new ArrayList<Intersection>();
  for(Segment s: segments) {
    s.intersections = new ArrayList<Integer>();
  }
    
  for(int i = 0; i < segments.size(); i++) {
    for(int j = i+1; j < segments.size(); j++) {
      Segment s1 = segments.get(i);
      Segment s2 = segments.get(j);
      MaybePVector mp = intersect(s1, s2);
      if (mp.just && mp.onsegs) {
        //println("Adding intersection", mp.p.x, mp.p.y);
        gIntersections.add(new Intersection(mp.p, NA, i, j));
        int I = gIntersections.size()-1;
        addIntersectionToSegments(s1, s2, I);
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
  int s;
  int i;
  int p;
  Unit(int _s, int _i, int _p) {
    s = _s;
    i = _i;
    p = _p;
  }
}

ArrayList<Unit> stack;

boolean mark(int s, int i, int p) {
  /* mark the ith intersection on segment s with parity p */
  Segment segment = segments.get(s);
  int intersectionIndex = segment.intersections.get(i);
  Intersection intersection = gIntersections.get(intersectionIndex); 
  if (intersection.parity == NA) {
    println("mark ", s, "(", segment.name, ")", i, "(", intersectionIndex, ")", p);
    intersection.parity = p;
    int other = intersection.s1 == s ? intersection.s2 : intersection.s1;
    Segment otherSegment = segments.get(other);
    for(int k = 0; k < otherSegment.intersections.size(); k++) {
      if (otherSegment.intersections.get(k) == intersectionIndex) {
        //int pp = ((p == OVER) ? UNDER : OVER);
        stack.add(new Unit(other, k, p));
        println("mark push", other, otherSegment.name, ")", k, "(", intersectionIndex, ")", p);
        break;
      }
    }
    return true;
  } else if (intersection.parity == p) {
    return true;
  } else {
    println("MARK ERROR - inconsistency ", s, "(", segment.name, ")", i, "(", intersectionIndex, ")", p);
    return false;
  }
}

int time;

void weave() {
  println("weave.");
  time = millis();
  find_all_intersections();
  println("after find all intersections:", millis()-time);
  time = millis();
  for(Segment s: segments) {
    s.visited = false;
  }
  /*
  // put all the Segments with any intersections on a list
  IntList segmentsToDo = new IntList();
  for(int i = 0; i < segments.size(); i++) {
    //print(segments.get(i));
    if (segments.get(i).intersections.size() > 0) {
      segmentsToDo.append(i);
      //println(" - ADDING");
    } else {
      //println(" - Skipping");
    }
  }
  
  println("segments: ", segments);
  println("segments to do: ", segmentsToDo);
  for(int i = 0; i < segmentsToDo.size(); i++) {
    stroke(80);
    strokeWeight(3);
    line(segments.get(i).a.x, segments.get(i).a.y, segments.get(i).b.x, segments.get(i).b.y);
  }
  */
  
  /*
    parity <- OVER
    choose an intersection i
    for each segment s on i, push (s,i) on stack
    while (stack not empty) {
      (s,i, parity) <- pop stack
      mark i with parity
      toggle parity
      save parity
      for each intersection k to right of i on s
        if k unmarked
         mark k with parity
         for each segment s' other than s on k, push (s', k, parity) on stack
         toggle parity
        else if k marked with parity
         continue
        else
         ERROR - inconsistency
      restore parity
      for each intersection k to the left of i on s
        if k unmarked
         mark k with parity
         for each segment s' other than s on k, push (s', k, parity) on stack
         toggle parity
        else if k marked with parity
         continue
        else
         ERROR - inconsistency
      mark s visited
    }
    optional check: if any segments with intersections are unvisitied, raise an ERROR
  */  
  
  stack = new ArrayList<Unit>();
  int p = OVER;
  int seg = -1;
  for(int i = 0; i < segments.size(); i++) {
    if (segments.get(i).intersections.size() > 0) {
      seg = i;
      break;
    }
  }
  if (seg == -1) { // no intersections
    return;
  }
 
  stack.add(new Unit(seg, 0, p));
  while (stack.size() > 0) {
      Unit u = stack.remove(stack.size()-1);
      int s = u.s;
      int i = u.i;
      println("stack step:", millis()-time, segments.get(u.s).name, i);
      time = millis();

      p = u.p;
      if (mark(s, i, p)) {
        p = ((p == OVER) ? UNDER : OVER);
        int savedParity = p;
        for(int k = i+1; k < segments.get(s).intersections.size(); k++) {
          if (mark(s, k, p)) {
            p = ((p == OVER) ? UNDER : OVER);
          } else {
            break;
          }
        }
        p = savedParity;
        for(int k = 0; k < i; k++) {
          if (mark(s, k, p)) {
            p = ((p == OVER) ? UNDER : OVER);
          } else {
            break;
          }
        }
      } else {
        break;
      }
      segments.get(s).visited = true;
  }
  //optional check: if any segments with intersections are unvisitied, raise an ERROR
  
  /*
  int parity = OVER;
  while (segmentsToDo.size() > 0) {
    int s = segmentsToDo.remove(segmentsToDo.size()-1);
    for(int i = 0; i < segments.get(s).intersections.size(); i++) {
      int p = gIntersections.get(segments.get(s).intersections.get(i)).parity;
      if (p == NA) {
        gIntersections.get(segments.get(s).intersections.get(i)).parity = parity;
        println("Assign", s, i, parity);
        parity = ((parity == OVER) ? UNDER : OVER);
      } else if (p != parity) {
        println("ERROR: ", s, i, p, parity);
      } else {
        println("Already set, skipping", s, i);
      }
    }
    break;
  }
  */
  
  for(int k = 0; k < gIntersections.size(); k++) { 
    Intersection i = gIntersections.get(k);
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
    fill(0);
    text(nf(k), i.p.x+10, i.p.y+10);
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
