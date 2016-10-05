class GlowLight {
  
  float x;
  float y;
  float r;
  float t;
  
  float vx;
  float vy;
  float vt;
  
  int podnum;    // number of pods
  float podw;    // diameter of pod
  float podr;    // radius of pod from center of glowlight
  float podt;    // spacing angle between pods
  
  float ringr = 0;   // radius of ring
  float ringw;       // weight of ring
  float ringo;       // arc segment
  
  int fillstyle;
  
  float id;
  
  color myc;
  
  GlowLight(float _x, float _y, float _r) {
    x = _x;
    y = _y;
    r = _r;
    t = random(TWO_PI);
    
    vx = 0;
    vy = 0;
    vt = 0;
    
    //myc = color(128+random(128),192,192);
    //myc = color(255-random(64),192,192);
    myc = #FFFFFF;
    
    id = random(10.0);
    
    // choose fill style
    fillstyle = floor(random(4));
    
    // choose size of perimeter pods
    podw = 1 + random(r*.3);
    
    // choose number of pods
    float omega = atan(podw/r);
    int maxnum = floor(TWO_PI/(4*omega));
    podnum = floor(random(maxnum));
    if (podnum>0) {
      
      podr = r/2 + podw*1.618;
      if (random(100)<50) {
        // space pods equally around circumference
        podt = TWO_PI/podnum;
      } else {
        // space pods linearly
        podt = atan(3*podw/r);
      }
    } else if (random(100)<80) {
      ringr = r*.618;
      ringw = r*.05;
      ringo = PI/4 + random(TWO_PI-PI/4);
    }
      
  }

  void drift() {
    x+=vx;
    y+=vy;
    
    //vx+=random(-.010,.010);
    //vy+=random(-.010,.010);
    //vx+=.1 * (noise(x*.01,y*.01)-.5);
    //vy+=.1 * (noise(y*.01,x*.01)-.5);
    
    //vx*=.979;
    //vy*=.979;
    
    t+=vt;
    vt+=random(-.01,.01);
    vt*=.99;
    
    // bound check
    if (x+r*2<0) x = width+r*2;
    if (x-r*2>width) x = -r*2;
    if (y+r*2<0) y = height+r*2;
    if (y-r*2>height) y = -r*2;
  }
  

  void render() {
    noStroke();
    if (fillstyle==0) {
      fill(myc);
      ellipse(x,y,r,r);
    } else {
      for (int i=0;i<fillstyle;i++) {
        float weight = r*.1;
        stroke(myc);
        strokeWeight(weight);
        noFill();
        ellipse(x,y,r-(i*weight*4)-weight*2,r-(i*weight*4)-weight*2);
      }
      
    }
    
    for (int k=0;k<podnum;k++) {
      float px = x + podr*cos(podt*k + t);
      float py = y + podr*sin(podt*k + t);
      noStroke();
      fill(myc);
      ellipse(px, py, podw, podw);
    }
    
    if (ringr>0) {
      stroke(myc);
      strokeWeight(ringw);
      noFill();
      arc(x,y,ringr*2,ringr*2,t,t+ringo);
      //ellipse(x,y,ringr*2,ringr*2);
    }
  }
  
}