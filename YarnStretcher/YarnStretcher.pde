// yarn stretcher
//   jared tarbell

float theta;
float omega;
float mag0;
float mag1;
int cnt;

int divs;

int sides = 3;

float dx;
float dy;

int state = 0;

int time = 0;

// state 8 vars
float xx = width/2;
float yy = height/2;
float axx = random(width);
float ayy = random(height);
float bxx = random(width);
float byy = random(height);

void setup() {
  size(2880,2880);
  background(0);
  
  divs = 16;
  theta = 0;
  omega = TWO_PI/divs;
  
  mag0 = width*.48;
  mag1 = width*.48;
  
  dx = 10;
  dy = 10;
  
  cnt = 22;
 
 // state 8 initiates
  xx = width/2;
  yy = height/2;
  axx = random(width);
  ayy = random(height);
  bxx = random(width);
  byy = random(height);
  
  state = 9;
}


void draw() {
  if (state==0) {
    // do nothing
  } else if (state==1) {
    // mandala
    if (theta+omega<=TWO_PI*1.001) {
      // pick an origin location
      float x0 = width/2;
      float y0 = height/2;
    
      mag0 = mag1;
      mag1 += random(-10,10);
    
      createStretch(x0,y0,theta,omega,mag0,mag1,cnt);
      theta += omega;
    }
  } else if (state==2) {
    // step iteration from corner
    createStretch(1+dx*time,1+dy*time,0,HALF_PI,width-1-dx*time,height-1-dy*time,100-time);
    if (dx*time>=width) state=0;
  } else if (state==3) {

    float rad = width*.47;
    for (int n=0;n<sides;n++) {
      float th = n*TWO_PI/sides - HALF_PI;
      float ax = width/2+rad*cos(th);
      float ay = height/2+rad*sin(th);
      float om = PI*(sides-2)/sides;
      float slen = 2*rad*sin(PI/sides);
      createStretch(ax,ay,th-PI-om/2,om,slen,slen,50);
      
    }
    // render each one just once
    sides++;
    if (sides>22) state = 0;
    
  } else if (state==4) {
    // growing peaks
    float dh = time*dx;
    createStretchAB(width/2.0,dh,0,height-1.0,width-1.0,height-1.0,11);
    createStretchAB(width/2.0,height-dh,0,0,width-1.0,0,11);
    if (time*dx>height) state = 0;
    //if (time>0) state = 0;
    
  } else if (state==5) {
    // growing inverted peak
    float dh = time*dx;
    createStretchAB(width/2.0,dh,0,height-dh,width-1.0,height-dh,11);
    if (time*dx>height) state = 0;
    //if (time>0) state = 0;
    
  } else if (state==6) {
    // growing inverted peak
    float dh = time*100;
    createStretchAB(width/2.0,dh,0,height-dh,width-1.0,height-dh,55);
    if (time*dx>height) state = 0;
    //if (time>0) state = 0;
    
  } else if (state==7) {
    // growing inverted peak
    float dw = time*80;
    createStretchAB(dw,height/2.0,width*2-dw,0,width*2-dw,height-1.0,55);
    //if (time*dw>width) state = 0;
    if (dw>width*4) state = 0;
    
  } else if (state==8) {
    // random walk
    float step = 400;
    createStretchAB(xx,yy,axx,ayy,bxx,byy,100);
    xx+=random(-step,step);
    yy+=random(-step,step);
    axx+=random(-step,step);
    ayy+=random(-step,step);
    bxx+=random(-step,step);
    byy+=random(-step,step);
    if (time>1000) state=0;
  } else if (state==9) {
    // mandala with point to point connections
    // pick an origin location
    float x0 = width/2;
    float y0 = height/2;    
    
    if (time<divs) {
      mag0 = mag1;
      mag1 = mag1;
    
      createStretch(x0,y0,theta,omega,mag0,mag1,cnt);
      theta += omega;
    }
    
    // random connection between two points
    int p0 = floor(random(divs));
    int p1 = p0 + round(random(-4,4));
    //int p1 = p0+1;//floor(random(divs));
    //if (random(100)<50) p1 = p0-1;
    if (p0==p1) p1 = p0+1;
    
    createStretchAB(x0+mag0*cos(p0*omega),x0+mag0*sin(p0*omega),x0,y0,x0+mag1*cos(p1*omega),y0+mag1*sin(p1*omega),floor(random(11,30)));
  }
  
  time++;
}

void createStretch(float x0, float y0, float theta, float omega, float mag0, float mag1, int cnt) {
  println("createStretch");
  if (cnt<=0) return;
  
  // compute the axial deltas
  float dax = mag0*cos(theta);
  float day = mag0*sin(theta);
  float dbx = mag1*cos(theta+omega);
  float dby = mag1*sin(theta+omega);
  
  // list the number of pin heads

  float[][] pointsA = new float[cnt][2];
  float[][] pointsB = new float[cnt][2];
  

  
  // draw the pin heads
  stroke(255,192);
  point(x0,y0);
  for (int i=0;i<cnt;i++) {
    // lerp between the  control points 0 and A
    pointsA[i][0] = x0+(i+1)*dax/cnt;
    pointsA[i][1] = y0+(i+1)*day/cnt;
    pointsB[i][0] = x0+(i+1)*dbx/cnt;
    pointsB[i][1] = y0+(i+1)*dby/cnt;
   
    point(pointsA[i][0],pointsA[i][1]);
    point(pointsB[i][0],pointsB[i][1]);
    
  }
  
  // draw the yarn between pin heads
  stroke(255,0,random(255),64);
  stroke(255,64);
  for (int i=0;i<cnt;i++) {
    int b = cnt-i-1;
    //println("i:"+i+"  b:"+b);
    line(pointsA[i][0],pointsA[i][1],pointsB[b][0],pointsB[b][1]);
    
  }
  
  
}

void createStretchAB(float x0, float y0, float dax_, float day_, float dbx_, float dby_, int cnt) {
  println("createStretch");
  if (cnt<=0) return;
 
  float dax = dax_-x0;
  float day = day_-y0;
  float dbx = dbx_-x0;
  float dby = dby_-y0;
 
  // list the number of pin heads
  float[][] pointsA = new float[cnt][2];
  float[][] pointsB = new float[cnt][2];
  
  // draw the pin heads
  stroke(255,192);
  point(x0,y0);
  for (int i=0;i<cnt;i++) {
    // lerp between the  control points 0 and A
    pointsA[i][0] = x0+(i+1)*dax/cnt;
    pointsA[i][1] = y0+(i+1)*day/cnt;
    pointsB[i][0] = x0+(i+1)*dbx/cnt;
    pointsB[i][1] = y0+(i+1)*dby/cnt;
   
    point(pointsA[i][0],pointsA[i][1]);
    point(pointsB[i][0],pointsB[i][1]);
    
  }
  
  // draw the yarn between pin heads
  stroke(255,0,random(255),64);
  stroke(255,64);
  for (int i=0;i<cnt;i++) {
    int b = cnt-i-1;
    //println("i:"+i+"  b:"+b);
    line(pointsA[i][0],pointsA[i][1],pointsB[b][0],pointsB[b][1]);
    
  }
  
  // draw the edge
  stroke(255,64);
  line(dax_,day_,x0,y0);
  line(x0,y0,dbx_,dby_);
  
  
}
