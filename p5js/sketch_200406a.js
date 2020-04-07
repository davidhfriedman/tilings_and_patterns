let r = 25
let dx = 100
let dy = 100
let wide = true

const table = [
  /*  0 */ [ 0, 6,   5, 6  ],
  /*  1 */ [ 1, 11,  5, 3  ],
  /*  2 */ [ 1, 8,   0, 8  ],
  /*  3 */ [ 0, 5,   2, 1  ],
  /*  4 */ [ 1, 10,  2, 10 ],
  /*  5 */ [ 1, 7,   3, 3  ],
  /*  6 */ [ 2, 0,   3, 0  ],
  /*  7 */ [ 2, 9,   4, 5  ],
  /*  8 */ [ 3, 2,   4, 2  ],
  /*  9 */ [ 3, 11,  5, 7  ],
  /* 10 */ [ 4, 4,   5, 4  ],
  /* 11 */ [ 4, 1,   0, 9  ]
]

const circles = [
  /* 0 */ [  1, -0.5 ],
  /* 1 */ [  0,   -1 ],
  /* 2 */ [ -1, -0.5 ],
  /* 3 */ [ -1,  0.5 ],
  /* 4 */ [  0,    1 ],
  /* 5 */ [  1,  0.5 ]
]


function jTOy (i, j) {
  if (i%2 == 1) { return floor(j*dy + dy/2) }
  else          { return floor(j*dy)        }   
}

function iTOx (i) {
  return floor(i*dx)
}

function setup() {
  createCanvas(1024, 768)
/*  size(1280, 960)  // Size must be the first statement

  cp5 = new ControlP5(this)
  cp5.addSlider("r")
     .setPosition(40, 40)
     .setSize(200, 20)
     .setRange(0, 100)
     .setValue(25)
     .setColorCaptionLabel(color(20,20,20))
  cp5.addSlider("dx")
     .setPosition(40, 100)
     .setSize(200, 20)
     .setRange(0, 200)
     .setValue(100)
     .setColorCaptionLabel(color(20,20,20))
  cp5.addSlider("dy")
     .setPosition(40, 160)
     .setSize(20, 150)
     .setRange(0, 200)
     .setValue(100)
     .setColorCaptionLabel(color(20,20,20))
   cp5.addToggle("wide")
     .setPosition(80,180)
     .setSize(50,20)
     .setValue(true)
     .setColorCaptionLabel(color(20,20,20))
     debugging: draw only one pair of connection lines selectable by knob
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
     .setDragDirection(Knob.VERTICAL)
    */
}


function lattice(cx, cy) {
  for(let i = 0; i < 11; i++) {
    const fx = floor(cx + r * cos(i * PI/6))
    const fy = floor(cy - r * sin(i * PI/6))
    const cA = table[i][0]
    const pA = table[i][1]
    const cB = table[i][2]
    const pB = table[i][3]
    const tAx = floor(cx + circles[cA][0]*dx + r * cos(pA * PI/6))
    const tAy = floor(cy + circles[cA][1]*dy - r * sin(pA * PI/6))
    const tBx = floor(cx + circles[cB][0]*dx + r * cos(pB * PI/6))
    const tBy = floor(cy + circles[cB][1]*dy - r * sin(pB * PI/6))
    if (wide) {
      stroke(0)
      strokeWeight(5)
      line(fx, fy, tAx, tAy)
      line(fx, fy, tBx, tBy)
      stroke(255)
      strokeWeight(4)
      line(fx, fy, tAx, tAy)
      line(fx, fy, tBx, tBy)
    } else {
      stroke(0)
      strokeWeight(1)
      line(fx, fy, tAx, tAy)
      line(fx, fy, tBx, tBy)
    }
  }
}

function circ(i, j) {
  const cx = iTOx(i)
  const cy = jTOy(i,j)
  stroke(0)
  //strokeWeight(5)
  /* Can omit this for debugging */ circle(cx, cy, r)
  point(cx, cy)
  for(let k = 0; k < 12; k++) {
     point(cx + r * cos(k * PI/6), cy + r * sin(k * PI/6))
  }
}


function draw() { 
  ellipseMode(RADIUS)
  background(255)
  stroke(0)
  noFill()
  //frameRate(30)
  for(let i = 1; i < 10; i++) {
    for(let j = 1; j < 10; j++) { 
      //circ(i, j)
      const cx = iTOx(i)
      const cy = jTOy(i, j)
      lattice(cx, cy)
    }
  }
  //noLoop()
}
