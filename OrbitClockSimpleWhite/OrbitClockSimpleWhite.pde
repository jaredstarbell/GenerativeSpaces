Orbit[] orbits;
int max = 1000;
int num = 0;

int tick = 1000;
float theta = random(TWO_PI);
float omega = PI/44;
float r = random(width*.2,width*.45);
float rd = 0;
float td = PI/random(100,300);



void setup() {
  //size(1200,1200);
  fullScreen();
  background(0);
  smooth(4);
 
  orbits = new Orbit[max];
}

void draw() {
  background(0);
  for (int i=0;i<num;i++) {
    orbits[i].move();
    orbits[i].connect();
  }
  for (int i=0;i<num;i++) orbits[i].render();
  
  for (int k=0;k<4;k++) {
    if (num<max) {
      orbits[num] = new Orbit(num,theta,td,r,0,tick);
      
      float b = 101;
      if (random(b)<2) tick=1000;
      if (random(b)<3) tick+=3000;
      if (random(b)<1) tick/=4;
      if (random(b)<6) r = random(width*.05,width*.45);
      if (random(b)<4) td = PI/random(100,300);
      if (random(b)<2) {
        theta = random(TWO_PI);
        omega = PI/random(r*.01,r*.1); 
        rd= 0;
      }
      if (random(b)<1) {
        theta = random(TWO_PI);
        omega = 0;
        rd = random(width*.01,width*.05);
        r = random(width*.05,width*.45);
      }
      theta+=omega;
      r+=rd;
      num++;
    }
  }    
}