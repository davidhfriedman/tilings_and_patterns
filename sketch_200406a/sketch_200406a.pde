int r = 25;
int dx = 100;
int dy = 100;
boolean wide = true;

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

int[][] circles = {
  /* 0 */ {    dx, -dy/2 },
  /* 1 */ {     0,   -dy },
  /* 2 */ {   -dx, -dy/2 },
  /* 3 */ {   -dx,  dy/2 },
  /* 4 */ {     0,    dy },
  /* 5 */ {    dx,  dy/2 }
};

int jTOy (int i, int j) {
  if (i%2 == 1) { return floor(j*dy + dy/2); }
  else          { return floor(j*dy);        }   
}

int iTOx (int i) {
  return floor(i*dx);
}

void lattice(int cx, int cy) {
  for(int i = 0; i < 12; i++) {
    int fx = floor(cx + r * cos(i * PI/6));
    int fy = floor(cy - r * sin(i * PI/6));
    int cA = table[i][0];
    int pA = table[i][1];
    int cB = table[i][2];
    int pB = table[i][3];
    int tAx = floor(cx + circles[cA][0] + r * cos(pA * PI/6));
    int tAy = floor(cy + circles[cA][1] - r * sin(pA * PI/6));
    int tBx = floor(cx + circles[cB][0] + r * cos(pB * PI/6));
    int tBy = floor(cy + circles[cB][1] - r * sin(pB * PI/6));
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
      line(fx, fy, tAx, tAy);
      line(fx, fy, tBx, tBy);
    }
  }
}

void circ(int i, int j) {
  int cx = iTOx(i);
  int cy = jTOy(i,j);
  circle(cx, cy, r);
  strokeWeight(5);
  point(cx, cy);
  for(int k = 0; k < 12; k++) {
     point(cx + r * cos(k * PI/6), cy + r * sin(k * PI/6));
  }
  strokeWeight(1);
}

void setup() {
  size(1280, 960);  // Size must be the first statement
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
 
}

/*
void draw() { 
  background(0);   // Clear the screen with a black background
  y = y - 1; 
  if (y < 0) { 
    y = height; 
  } 
  line(0, y, width, y);  
} 
*/
