// Binary Ages II
//   Jared Tarbell
//   August 30, 2015
//   Albuquerque, New Mexico

int num = 5000;
float r;
float emitox;
float emitoy;
float emitx;
float emity;
float exp;
float theta;
boolean white = true;

Particle[] kaons;

boolean doDraw = false;


void setup() {
  size(1920,1080);
  background(0);

  emitox = width/2;
  emitoy = height/2;


  kaons = new Particle[num];
  exp = 100;
  theta = random(TWO_PI);
  
  for (int i=0;i<num;i++) {
    r = PI*i/num;
    emitx = int(exp*sin(2*r)+emitox);
    emity = int(exp*cos(2*r)+emitoy);
   
    kaons[i] = new Particle(emitox,emitoy,emitx,emity,r);
  }

}

void draw() {
  if (doDraw) {
    for (int i=0;i<num;i++) {
      kaons[i].move();
    }
    
    // grow emitter sphere
    exp += 0.02;
    if (exp>height*1.21) {
      exp = 1;
    }
    
    if (random(1000)<4) {
      white = !white;
      println("white: "+white);
    }
    
    if (random(1000)<2) {
      theta = random(TWO_PI);
      println("theta:"+round(theta*180/PI));
      //emitox = random(dim*.1,dim*.9);
      //emitoy = random(dim*.1,dim*.9);
    }
  }
  
}

void keyPressed() {
  
  if (key=='s') {
    saveFrame("binaryAge-######.png");
    println("Saved!");
  }
  white = !white; 
  doDraw = true;
}

void mousePressed() {
  white = !white; 
  println("white: "+white);
  doDraw = true;
}

float emitXat(float r) {
  return emitx = exp*sin(2*r)+emitox;
}

float emitYat(float r) {
  return emitx = exp*cos(2*r)+emitoy;
}