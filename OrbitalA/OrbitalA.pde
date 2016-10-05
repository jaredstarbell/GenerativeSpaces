// Orbitals, Machine Series
// June 2005

// j.tarbell   August, 2004
// Albuquerque, New Mexico
// complexification.net


// Objects
int num=500;

int cnt;

Orbital[] orbitals;

boolean baked;

int maxpal = 512;
int numpal = 0;
color[] goodcolor = new color[maxpal];

void setup() {
  fullScreen();
  // get some good colors externally
  takecolor("longConejo.gif");
  background(255);
  
  noFill();
  
  // make some orbital objects
  orbitals = new Orbital[num];
  
  // construct a new orbitalsystem
  resetAll();
}
 
void draw() {
  // k loop is an accelerator
  for (int k=0;k<20;k++) {
    // orbit all orbitals
    for (int n=0;n<num;n++) {
      orbitals[n].orbit();
    }
    // draw all orbitals
    for (int n=0;n<num;n++) {
      orbitals[n].draw();
    }
  }
  cnt++;
  if (cnt%100==0) print(".");
  if (baked) {
    println("done.");
    resetAll();
    background(255);
  }
}
 
void keyPressed() {
  if (key=='s') {
    print("Saving frame...");
    saveFrame();
    println("done.");
    resetAll();
    background(255);
  }
} 
 
void resetAll() {
  cnt = 0;
  // initialize new orbitals
  for (int n=0;n<num;n++) {
    // default self as orbit origin
    int npid = n;
    if (n>num*0.1) {
      // choose another orbital as orbit origin
      npid = int(random(n));
    }
    
    orbitals[n] = new Orbital(n,npid);
    
    if (n==npid) {
      // move origin orbital to somewhere along top of screen
      orbitals[n].setPosition(random(width),0);
    }
  }
  baked=false;
}


// OBJECTS ---------------------------------------------------------------------
   
class Orbital 
{
  int id;
  int pid;
  float r;
  float t;  
  float tv, tvd;
  float x,y;
  int d;
  color myc;
 
  Orbital(int Id, int Pid) {
    id=Id;
    pid=Pid;
    if (id!=pid) {
      // calculate depth
      d=orbitals[pid].d+1;
      // radius inversely proportional to depth
      r=random(1,1+width*0.0366/d);
      // angle theta
      t=HALF_PI;
      // theta velocity
      tv=random(0.001,0.2/(d+1));
      if (random(100)<50) tv*=-1;
      // theta differential
      //tvd=random(1.001,1.010);
    } else {
      // is central node
      r = 0; 
    }
    // choose arbitrary color
    myc = somecolor();
  }

  void setPosition(float X, float Y) {
    x = X;
    y = Y;
  }
 
  void orbit() {
    t+=tv;
    x = orbitals[pid].x+r*cos(t);
    y = orbitals[pid].y+r*sin(t);
    // heeheh
//    tv*=tvd;
//    r*=1.00022;
  }
  
  void draw() {
    // fuzz
    float fzx = random(-0.42,0.42);
    float fzy = random(-0.42,0.42);
    
    // draw translucent pixel
    tpoint(x+fzx,y+fzy,myc,0.1777777);
    
    // draw orbit path
//    float o = random(TWO_PI);
//    fzx = orbitals[pid].x+r*cos(o);
//    fzy = orbitals[pid].y+r*sin(o);
//    tpoint(fzx,fzy,myc,0.11);
    
    // draw parent line
//    o = random(1.0);
//    fzx = x+o*(orbitals[pid].x-x);
//    fzy = y+o*(orbitals[pid].y-y);
//    tpoint(fzx,fzy,#000000,0.05);

    // shift orbit origin down
    if (id==pid) {
       y+=0.1;
        if (y>height*1.1) {
         baked=true;
       }
    }
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
            //print("w");
          } else {
            goodcolor[numpal] = #000000;
            //print("b");
          }
          numpal++;
        }
      }
    }
  }
  

}
// translucent point
void tpoint(float x1, float y1, color myc, float a) {
  stroke(red(myc),green(myc),blue(myc),a*256);
  point(x1,y1);
}


// Albuquerque, New Mexico
// complexification.net