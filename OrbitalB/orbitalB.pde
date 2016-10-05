// Orbitals, Machine Series
// June 2005

// j.tarbell August, 2004
// Albuquerque, New Mexico
// complexification.net

// Processing 0090 Beta

int num=1111;

Orbital[] orbitals;

int maxpal = 512;
int numpal = 0;
color[] goodcolor = new color[maxpal];

int count;


void setup() {
  fullScreen();
  takecolor("longConejo.gif");
  noFill();
  
  orbitals = new Orbital[num];

  resetAll();
}
 
void draw() {
  if (count%100==0) print(".");
  if (count++>1200) {
    println("done.");
    saveFrame();
    resetAll();
  } else {
    // k loop is accelerator
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
  }
}
 
 
void keyPressed() {
  if (key=='s') {
    resetAll();
  }
}
 
void resetAll() {
  // make orbitals
  count = 0;
  for (int n=0;n<num;n++) {
    // pick orbit origin node
    int npid = n;
    if (n>num*0.1) {
      npid = int(random(n));
    }
    orbitals[n] = new Orbital(n,npid);
    if (n==npid) {
      orbitals[n].setPosition(width/2,height/2);
    }
  }
  background(255);
}


// OBJECTS ---------------------------------------------------------------------
   
class Orbital {
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
      r=random(1,1+0.4*width/d);
      // angle theta
      t=-HALF_PI;
      t=random(TWO_PI);
      // theta velocity
      tv=random(0.0001,0.02/(d+1));
      if (random(100)<50) tv*=-1;
      // theta differential
      tvd=random(1.001,1.010);
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
    tv*=0.99955;
//    r*=1.00022;
  }
  
  void draw() {
    // fuzz
    float fzx = random(-0.22,0.22);
    float fzy = random(-0.22,0.22);
    
    // draw translucent pixel
    tpoint(x+fzx,y+fzy,myc,0.03777777);
    
    if (sumtv()<1.00001) {
      // draw orbit path
      float o = random(TWO_PI);
      fzx = orbitals[pid].x+r*cos(o);
      fzy = orbitals[pid].y+r*sin(o);
      tpoint(fzx,fzy,myc,0.082);
    
      // draw parent line
      o = random(1.0);
      fzx = x+o*(orbitals[pid].x-x);
      fzy = y+o*(orbitals[pid].y-y);
      tpoint(fzx,fzy,#000000,0.04);
    }
  }
  
  float sumtv() {
    if (pid!=id) {
      return (orbitals[pid].sumtv() + tv);
    } else {
      return tv+1;
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
          } else {
            goodcolor[numpal] = #000000;
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


// j.tarbell August, 2004
// Albuquerque, New Mexico
// complexification.net