Star[] stars;
int num = 0;
int max = 5000;

int[] temps;
int numt = 0;

float fl;
float camz;

Space space;
Camera cam;
GoodColor goodColor = new GoodColor();

float time = 0;

Boolean renderConnections = true;
Boolean recordVideo = false;
Boolean showOrbitals = true;

float starSpeed = 8;
  
int flyers = 0;

PImage bg;

void setup() {
  fullScreen(P3D);
  //size(1920,1080,P3D);
  background(0);
  space = new Space();
  cam = new Camera(0,0,0,1000);
  stars = new Star[max];
  temps = new int[max];
  
  while (num<max) {
    float x = random(-space.tx,space.tx);
    float y = random(-space.ty,space.ty);
    float z = random(space.tz);
    stars[num] = new Star(num,x,y,z);
    num++;
  }
    
  //bg = loadImage("galactic-nebula.jpg");
    
}

void draw() {
  if (num<max) {
    float x = random(-space.tx,space.tx);
    float y = random(-space.ty,space.ty);
    float z = random(space.tz);
    stars[num] = new Star(num,x,y,z);
    num++;
  }
  background(0);
  //image(bg,0,0);
  render();
  
  // manage temporary stars
  if (renderConnections) renderCon();
  
  cam.fly();
  //println("fps:"+frameRate);
  
  time+=.001;
  //starSpeed = 22*(1+sin(time));
  starSpeed = (100.0*mouseY)/height;
  
  if (recordVideo) {
    saveFrame("output/spaceFlight-#####.tga");
    print(".");
    if (random(100)<10) print("!");
  }
}

void keyPressed() {
  // stop and start video
  if (recordVideo) {
    recordVideo=false;
    println("...stop recording.");
  } else if (key=='r') {
    recordVideo=true;
    println("recording");
  }
}

void render() {
  for (int n=0;n<num;n++) {
    stars[n].render();
  }
}

void renderCon() {

  for (int n=0;n<numt-1;n++) {
    if (stars[temps[n]].nid%3==0) {
      for (int j=n+1;j<numt;j++) {
      //if (n%2!=j%2) {  // blinking effect
        if (stars[temps[j]].nid%2==0) {
          float d = dist(stars[temps[n]].lx,stars[temps[n]].ly,stars[temps[j]].lx,stars[temps[j]].ly);
        //  float d = dist(stars[temps[n]].x,stars[temps[n]].y,stars[temps[n]].z,stars[temps[j]].x,stars[temps[j]].y,stars[temps[j]].z);
          if (d<200) {
            stroke(255,64-64*d/200);
            line(stars[temps[n]].lx,stars[temps[n]].ly,stars[temps[j]].lx,stars[temps[j]].ly);
          }
        }
      }
    }
  }
  numt = 0;
}
  
    