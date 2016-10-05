// Orbital C
//   Jared S Tarbell
//   Ghost rendering update:
//     September 3, 2016
//     Reykjavic, Iceland

int num = 2000;
int time = 0;

OrbitNode[] nodes;

int maxpal = 512;
int numpal = 0;
color[] goodcolor = new color[maxpal];


void setup() {
  //size(1920,1080,P3D);
  fullScreen(P3D);
  colorMode(HSB);
  takecolor("longConejo.gif");

  background(0);

  nodes = new OrbitNode[num];
  
  for (int n=0;n<num;n++) {
    nodes[n] = new OrbitNode(n);
  }
}

void draw() {
  float klim = 1 + time*.001;
  if (klim>10) klim = 10;
  for (int k=0;k<1+time*.001;k++) {
    //background(0);
    if (time%4==0) {
      fill(0,5);
      rect(0,0,width,height);
    }
    for (int n=0;n<num;n++) {
      nodes[n].move();
    }
    time++;
  }
}



class OrbitNode {
  int id;
  int idStar;
  int colorShift;
  
  float x;
  float y;
  float vx;
  float vy;
  
  color myc;
  
  OrbitNode(int Id) {
    id = Id;
    idStar = Id;
    
    x = random(width);
    y = random(height);
    
    vx = 0;
    vy = 0;
    
    myc = somecolor();
    
    colorShift = 175;
  }
	
  void orbit() {
    // calculate distance
    float d = distanceTo(idStar);
    float dx = nodes[idStar].x-x;
    float dy = nodes[idStar].y-y;
    
    if (d>width/2) {
      // break the connection
      idStar = id;
      return;
    }
	
    //float t = atan2(dy,dx) + PI/1.6;
    float t = atan2(dy,dx);
    float v = 0.01;
    vx += v*cos(t*1.01);
    vy += v*sin(t*1.01);
    
    // draw line to orbit star
    stroke(colorShift,255,192,64);
    //stroke(myc,64);
    //stroke(colorShift,255,255,128);
    //noFill();
    line(x,y,nodes[idStar].x,nodes[idStar].y);
    
    //stroke(255);
    //noStroke();
    //fill(255);
    //ellipse(x,y,4,4);
    //point(x,y);
    //point(nodes[idStar].x,nodes[idStar].y);
    
  }
	
  void move() {
    // draw
    //stroke(255,32);
    //point(x,y);
    x+=vx;
    y+=vy;
    vx*=.988;
    vy*=.988;
	
    boundCheck();
   	
    // draw
//    stroke(255);
//    point(x,y);
  
		
    if (idStar!=id) {
      orbit();
    } else {
      findCloseOrbit();
    }  
    
    // occassionally loose orbit
    if (random(1000)<1) {
      idStar=id;
      colorShift++;
    }
    
  }
  
  void boundCheck() {
    if (x<0) {
      x = width;
      idStar = id;
    }
    if (x>width) {
      x = 0;
      idStar = id;
    }
    if (y<0) {
      y = height;
      idStar = id;
    }
    if (y>height) {
      y = 0;
      idStar = id;
    }
  }
	
  void findOrbit() {
    int idNew = int(random(num));
		
    if (idNew!=id) {
      idStar = idNew;
    }
  }
  
  void findCloseOrbit() {
    int mini = -1;
    float mind = height*height;
    for (int n=0;n<num;n++) {
      if (n!=id) {
        float d = distanceTo(n);
        if (d<mind) {
          // found close node
          if (nodes[n].idStar!=id) {
            mind = d;
            mini = n;
          }
        }
      }
    }
    if (mini>=0) {
      idStar = mini;
      colorShift++;
    }
  }
  
  float distanceTo(int Id) {
    float dx = x - nodes[Id].x;
    float dy = y - nodes[Id].y;
    return sqrt(dx*dx+dy*dy);
  }
  

}



// COLOR ROUTINES -----------------------------------------------------------

color somecolor() {
  // pick some random good color
  return goodcolor[int(random(numpal))];
}

void takecolor(String fn) {
  PImage b;
  b = loadImage(fn);
  image(b,0,0);

  for (int x=0;x<b.width;x++){
    for (int y=0;y<b.height;y++) {
      color c = get(x,y);
      boolean exists = false;
      for (int n=0;n<numpal;n++) {
        if (c==goodcolor[n]) {
          exists = true;
          break;
        }
      }
      if (!exists) {
        // add color to pal
        if (numpal<maxpal) {
          goodcolor[numpal] = c;
          numpal++;
        } else {
          break;
        }
      }
      if (random(10000)<100) {
        if (numpal<maxpal) {
          // pump black or white into palette
          if (random(100)<50) {
            goodcolor[numpal] = #FFFFFF;
          } else {
            goodcolor[numpal] = #000000;
          }
          numpal++;
        }
      }
    }
  }
  

}