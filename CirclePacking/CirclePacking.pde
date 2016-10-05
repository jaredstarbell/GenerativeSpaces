// Inscribed circles
//   jared Tarbell
//   August 6, 2015

Circle[] circles;
int max = 5000;
int num = 0;

float pad = 4.0;
float growth = .5;

int delay = 0;
int basedelay = 10;

void setup() {
  size(1920,1080);
  background(0);
  
  smooth(4);
  
  circles = new Circle[max];
}

void draw() {
  if (delay>0) {
    delay--;
  } else {
    int fails = 0;
    for (int n=0;n<10001;n++) {
      boolean success = growCircle();
      if (!success) fails++;
    } 
    
    if (fails>10000) {
      println("done.");
      noLoop();
    }
    delay = basedelay;
  }
  
}

void mousePressed() {
  circles = new Circle[max];
  num=0;
  background(0);
  loop();
}


boolean growCircle() {
  if (num<max) {
    float x = random(width-2)+1;
    float y = random(height-2)+1;
    float r = 1.0;
    int hit = isFree(x,y,r);
    while (hit<0) {
      r+=growth;
      hit = isFree(x,y,r);
    }

    if (r>1.0) {
      if (hit>0 && hit<num) {
        //stroke(255);
        //strokeWeight(2.0);
        //float theta = atan2(circles[hit].y-y,circles[hit].x-x);
        //line(x+r*cos(theta),y+r*sin(theta),circles[hit].x-circles[hit].r*cos(theta),circles[hit].y-circles[hit].r*sin(theta));
//        line(x,y,circles[hit].x,circles[hit].y);
      }      
      // place the circle
      circles[num] = new Circle(num,x,y,r,#FFFFFF,1);
      num++;
      
      return true;
    }
  }    
  return false;
    
}

int isFree(float sx, float sy, float sr) {
  // check border
  if (sx-sr<0) return 0;
  if (sx+sr>width) return 0;
  if (sy-sr<0) return 0;
  if (sy+sr>height) return 0;
  
  // check other circles
  for (int n=0;n<num;n++) {
    float d = dist(circles[n].x,circles[n].y,sx,sy);
    if (d<circles[n].r+sr+growth+pad) return n;
  }
  
  return -1;
}

class Circle {
  int id;
  float x;
  float y;
  float r;
  color myc;
  
  int gen;
  int max;
  int num;
  Circle[] kids; 
  
  Circle(int ident, float xpos, float ypos, float radius, color mycolor, int generation) {
    id = ident;
    x = xpos;
    y = ypos;
    r = radius;
    myc = mycolor;
    
    render();
    
    gen = generation;
    if (gen<100 && r>pad*2) {
      max = round(.5*PI*r*r);
      num = 0;
      kids = new Circle[max];
      inscribeKids();
      
    }
  }
  
  void render() {
    noStroke();
    fill(myc);
    ellipse(x,y,r*2,r*2); 
  }
  
  int isKidFree(float ksx, float ksy, float ksr) {
    // check parental border
    float d = dist(x,y,ksx,ksy);
    if (d+ksr+growth+pad>r) return id;
   
    // check other circles
    for (int n=0;n<num;n++) {
      if (dist(ksx,ksy,kids[n].x,kids[n].y)<kids[n].r+ksr+growth+pad) return n;
    }
    return -1;
  }
  
  void inscribeKids() {
    color kmyc = #FFFFFF;
    if (myc==#FFFFFF) kmyc = #000000;
    
    // make one child right nearly in the center
    //float ix = x + random(-r*.2,r*.2);
    //float iy = y + random(-r*.2,r*.2);
    //float ir = 1.0;
    //while (isKidFree(ix,iy,ir)) {
    //  ir+=growth;
    //}
    //if (ir>1.0) {
    //  // place the kid circle
    //  kids[num] = new Circle(num,ix,iy,ir,kmyc,gen+1);
    //  num++;
    //}
    
    // fill with children
    int fails = 0;
    while (fails<10000 && num<max) {
      float kx = x + random(-r,r);
      float ky = y + random(-r,r);
      float kr = 1.0;
      int hit = isKidFree(kx,ky,kr);
      while (hit<0) {
        kr+=growth;
        hit = isKidFree(kx,ky,kr);
      }
      if (kr>1.0) {
        if (kmyc==#FFFFFF) {
          if (hit>0 && hit<num) {
            stroke(255);
            strokeWeight(2.0);
            float theta = atan2(kids[hit].y-ky,kids[hit].x-kx);
            //line(kx+kr*cos(theta),ky+kr*sin(theta),kids[hit].x-kids[hit].r*cos(theta),kids[hit].y-kids[hit].r*sin(theta));
          } else if (hit==id) {
            stroke(255);
            strokeWeight(2.0);
            float theta = atan2(ky-y,kx-x);
            //line(x+r*cos(theta),y+r*sin(theta),kx-kr*cos(theta),ky-kr*sin(theta));
          }
        } 
        // place the kid circle
        kids[num] = new Circle(num,kx,ky,kr,kmyc,gen+1);
        num++;
      } else {
        fails++;
      }
    } 
  }
}
  
  