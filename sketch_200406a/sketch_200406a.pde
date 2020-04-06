int r = 50;
int dx = 100;
int dy = 100;

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
  /* 0 */ {  dx/2,   -dy },
  /* 1 */ {     0, -2*dy },
  /* 2 */ { -dx/2,   -dy },
  /* 3 */ { -dx/2,    dy },
  /* 4 */ {     0,  2*dy },
  /* 5 */ {  dx/2,    dy }
};

void setup() {
  size(1280, 960);  // Size must be the first statement
  background(255);
  stroke(0);
  noFill();
  //frameRate(30);
  for(int x = r; x < width-r; x+=dx) {
    for(int y = r; y < height-r; y+=dy) {
       circle(x, y, r);  
    }
  }
  
  int cx = r + 5 * dx;
  int cy = r + 5 * dy;
  
  for(int i = 0; i < 12; i++) {
    int fx = floor(cx + r * cos(i * PI/6));
    int fy = floor(cy + r * sin(i * PI/6));
    int cA = table[i][0];
    int pA = table[i][1];
    int cB = table[i][2];
    int pB = table[i][3];
    int tAx = floor(cx + circles[cA][0] + r * cos(pA * PI/6));
    int tAy = floor(cy + circles[cA][1] + r * sin(pA * PI/6));
    int tBx = floor(cx + circles[cB][0] + r * cos(pB * PI/6));
    int tBy = floor(cy + circles[cB][1] + r * sin(pB * PI/6));
    line(fx, fy, tAx, tAy);
    line(fx, fy, tBx, tBy);
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
