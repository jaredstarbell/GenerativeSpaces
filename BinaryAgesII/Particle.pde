class Particle {
  float ox, oy;
  float x, y;
  float xx, yy;
  float atx, aty;
  float btx, bty;

  float vx;
  float vy;
  int age;
  int maxage; 
  color myc;
  
  float myTheta;
  boolean isTheta = false;
  boolean drawLine = false;

  Particle(float origin_x, float origin_y, float pos_x, float pos_y, float r) {
    // initialize particle
    init(origin_x, origin_y, pos_x, pos_y, r);
    age = floor(random(maxage));
  }

  void move() {
    xx=x;
    yy=y;

    x+=vx;
    y+=vy;

    vx += (random(100)-random(100))*0.005;
    vy += (random(100)-random(100))*0.005;

    if (isTheta) {
      // rotate this particle's line of symmetry
      stroke(myc,64);
      float ax = ox+x;
      float bx = ox-x;
      float yy = oy+y;
      
      float latx = atx;
      float laty = aty;
      float lbtx = btx;
      float lbty = bty;
      atx = ox + (ax-ox)*cos(myTheta) - (yy-oy)*sin(myTheta);
      aty = oy + (ax-ox)*sin(myTheta) + (yy-oy)*cos(myTheta);
      btx = ox + (bx-ox)*cos(myTheta) - (yy-oy)*sin(myTheta);
      bty = oy + (bx-ox)*sin(myTheta) + (yy-oy)*cos(myTheta);
      if (drawLine) {
        if (dist(atx,aty,latx,laty)<10) {
          line(atx,aty,latx,laty);
          line(btx,bty,lbtx,lbty);
        }
      } else {
        point(atx,aty);
        point(btx,bty);
      }
    } else {
      stroke(myc,64);
      if (drawLine) {
        line(ox+x,oy+y,ox+xx,oy+yy);
        line(ox-x,oy+y,ox-xx,oy+yy);
      } else {
        point(ox+x,oy+y);
        point(ox-x,oy+y);
      }
    }

    // grow old
    age++;
    if (age>maxage) {
      // die and be reborn
      float r = random(TWO_PI);
      init(ox,oy,emitXat(r),emitYat(r),r);
    }
  }
  
  void init(float origin_x, float origin_y, float pos_x, float pos_y, float r) {
    ox = origin_x;
    oy = origin_y;
    x = ox - pos_x;
    y = oy - pos_y;
    xx = 0;
    yy = 0;
    atx = x;
    aty = y;
    btx = x;
    bty = y;
 
    //vx = 2*cos(r);            // velocity x
    //vy = 2*sin(r);            // velocity y
    vx = 0;
    vy = 0;

    if (white) {
      myc = #FFFFFF;
    } else {
      myc = #000000;
    }
    
    age = 0;
    maxage = round(random(100,200));
    
    if (random(100)<50) {
      isTheta = true;
      myTheta = theta;
    } else {
      isTheta = false;
    }
     
  }
}

