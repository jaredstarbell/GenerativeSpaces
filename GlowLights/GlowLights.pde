GlowLight[] glows;
int num = 0;
int max = 2000;
float minr = 4.0;
float maxr = 14.0;

void setup() {
  //size(1920,1080);
  fullScreen();
  //smooth(8);
  background(0);
  makeGlows();
}

void draw() {
  background(0);
   for (int i=0;i<num;i++) {
    glows[i].drift();
    glows[i].render();
  }
  
  
}


void makeGlows() {
  float r = (width*1.0)/height;
  int dim = floor(sqrt(max/r));
  println("r:"+r+"  dim:"+dim);
  glows = new GlowLight[max];
  float spcx = height/dim;
  float spcy = height/dim;
  for (int xx=0;xx<dim*r;xx++) {
    for (int yy=0;yy<dim;yy++) {
      glows[num] = new GlowLight(spcx/2+spcx*xx,spcy/2+spcy*yy,random(minr,maxr));
      num++;
    }
  }

}

void mousePressed() {
  background(0);
  num=0;
  makeGlows();

}