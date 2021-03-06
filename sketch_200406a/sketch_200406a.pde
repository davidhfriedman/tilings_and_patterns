
import controlP5.*;
ControlP5 cp5;

int r = 25;
int dx = 100;
int dy = 100;
boolean wide = true;
// DEBUGGING int p = 0;

int[][] table = {
  /*  0 */ { 0, 6,   5, 6  },
  /*  1 */ { 1, 11,  5, 3  },
  /*  2 */ { 1, 8,   0, 8  },
  /*  3 */ { 0, 5,   2, 1  },
  /*  4 */ { 1, 10,  2, 10 },
  /*  5 */ { 1, 7,   3, 3  },
  /*  6 */ { 2, 0,   3, 0  },
  /*  7 */ { 2, 9,   4, 5  },
  /*  8 */ { 3, 2,   4, 2  },
  /*  9 */ { 3, 11,  5, 7  },
  /* 10 */ { 4, 4,   5, 4  },
  /* 11 */ { 4, 1,   0, 9  }
};

float[][] circles = {
  /* 0 */ /* {    dx, -dy/2 }, */ {  1, -0.5 },
  /* 1 */ /* {     0,   -dy }, */ {  0,   -1 },
  /* 2 */ /* {   -dx, -dy/2 }, */ { -1, -0.5 },
  /* 3 */ /* {   -dx,  dy/2 }, */ { -1,  0.5 },
  /* 4 */ /* {     0,    dy }, */ {  0,    1 },
  /* 5 */ /* {    dx,  dy/2 }  */ {  1,  0.5 }
};

int jTOy (int i, int j) {
  if (i%2 == 1) { return floor(j*dy + dy/2); }
  else          { return floor(j*dy);        }   
}

int iTOx (int i) {
  return floor(i*dx);
}

void lattice(int cx, int cy) {
  // DEBUGGING for(int i = p; i < p+1; i++) {
  for(int i = 0; i < 11; i++) {
    int fx = floor(cx + r * cos(i * PI/6));
    int fy = floor(cy - r * sin(i * PI/6));
    int cA = table[i][0];
    int pA = table[i][1];
    int cB = table[i][2];
    int pB = table[i][3];
    int tAx = floor(cx + circles[cA][0]*dx + r * cos(pA * PI/6));
    int tAy = floor(cy + circles[cA][1]*dy - r * sin(pA * PI/6));
    int tBx = floor(cx + circles[cB][0]*dx + r * cos(pB * PI/6));
    int tBy = floor(cy + circles[cB][1]*dy - r * sin(pB * PI/6));
    if (wide) {
      stroke(0);
      strokeWeight(5);
      line(fx, fy, tAx, tAy);
      line(fx, fy, tBx, tBy);
      stroke(255);
      strokeWeight(4);
      line(fx, fy, tAx, tAy);
      line(fx, fy, tBx, tBy);
    } else {
      stroke(0);
      strokeWeight(1);
      line(fx, fy, tAx, tAy);
      line(fx, fy, tBx, tBy);
    }
  }
}

void circ(int i, int j) {
  int cx = iTOx(i);
  int cy = jTOy(i,j);
  stroke(0);
  //strokeWeight(5);
  /* Can omit this for debugging */ circle(cx, cy, r);
  point(cx, cy);
  for(int k = 0; k < 12; k++) {
     point(cx + r * cos(k * PI/6), cy + r * sin(k * PI/6));
  }
}

void setup() {
  size(1280, 960);  // Size must be the first statement
  
  cp5 = new ControlP5(this);
  cp5.addSlider("r")
     .setPosition(40, 40)
     .setSize(200, 20)
     .setRange(0, 100)
     .setValue(25)
     .setColorCaptionLabel(color(20,20,20));
  cp5.addSlider("dx")
     .setPosition(40, 100)
     .setSize(200, 20)
     .setRange(0, 200)
     .setValue(100)
     .setColorCaptionLabel(color(20,20,20));
  cp5.addSlider("dy")
     .setPosition(40, 160)
     .setSize(20, 150)
     .setRange(0, 200)
     .setValue(100)
     .setColorCaptionLabel(color(20,20,20));
   cp5.addToggle("wide")
     .setPosition(80,180)
     .setSize(50,20)
     .setValue(true)
     .setColorCaptionLabel(color(20,20,20));
    /* debugging: draw only one pair of connection lines selectable by knob
    cp5.addKnob("p")
     .setRange(0,11)
     .setValue(0)
     .setPosition(40,250)
     .setRadius(25)
     .setNumberOfTickMarks(12)
     .setTickMarkLength(4)
     .snapToTickMarks(true)
     .setColorForeground(color(255))
     .setColorBackground(color(20,20,190)) // color(0, 160, 100))
     .setColorActive(color(255,255,0))
     .setDragDirection(Knob.VERTICAL);
    */
}

void draw() { 
  ellipseMode(RADIUS);
  background(255);
  stroke(0);
  noFill();
  //frameRate(30);
  for(int i = 1; i < 10; i++) {
    for(int j = 1; j < 10; j++) { 
      //circ(i, j);
      int cx = iTOx(i);
      int cy = jTOy(i, j);
      lattice(cx, cy);
    }
  }
  //noLoop();
}
