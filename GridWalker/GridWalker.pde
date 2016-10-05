import processing.pdf.*;

int gridx;    // total number of vertical intervals
int gridy;    // total number of horizontal intervals

int scl;            // the scale distance betwen lines

int max = 555;       // maximum number of grid walking objects
int num = 0;

GridLine[] gridlines;

PImage space;
color bgcolor = #000000;

boolean doDraw = false;

PImage bg;

int countdown = 0;
int time = 0;

void setup() {
  size(1920,1080);
  background(bgcolor);
  
  bg = loadImage("waters.jpg");
  //bg = loadImage("rainbow.jpg");
  //bg = loadImage("moth.jpg");
  //image(bg,0,0);
  
  gridx = width/2;
  gridy = height/2;
  
  scl = floor(min(width/gridx,height/gridy));
  
  space = createImage(gridx,gridy,RGB);
  space.loadPixels();
  for (int i = 0; i < space.pixels.length; i++) {
    space.pixels[i] = bgcolor; 
  }
  space.updatePixels();
  
  
  gridlines = new GridLine[max];
  
  // make em all at once
  //while (num<max) {
  //  gridlines[num] = new GridLine(num);
  //  initGridLine(num);
  //  num++;
  //}  
  
  // make a PDF vector file
  //beginRecord(PDF, "gridWalker-"+str(hour())+"-"+str(minute())+"-"+str(second())+".pdf");
  
}


void draw() {
  if (doDraw) {
    if (num<max && countdown<0) {
      gridlines[num] = new GridLine(num);
      initGridLine(num);
      num++;
      countdown = floor(200-time*.1);
      println("countdown:"+countdown);
    }  
    countdown--;
    
    time++;
    
    for (int k=0;k<1;k++) {
      // move all the grid walkers
      for (int n=0;n<num;n++) {
        gridlines[n].doStep();
      }
    }
  }
  //image(space,0,0,500,500);
}


void keyPressed() {
  //makePDF();
  //saveFrame("gridWalker_sage####.tga");
  doDraw = true;
}


void initGridLine(int index) {
  int step = 128;
  if (random(2)<1) step/=2;
  if (random(2)<1) step/=2;
  if (random(2)<1) step/=2;
  if (random(2)<1) step/=2;
  int dir = floor(random(4));
  int x = floor(random(gridx/(1.0*step))*step);
  int y = floor(random(gridy/(1.0*step))*step);
  
  gridlines[index].init(x,y,dir,step);
  
}

boolean isClosed(int x, int y) {
  if (x<0) return true;
  if (x>=space.width) return true;
  if (y<0) return true;
  if (y>=space.height) return true;
  space.loadPixels();
  if (space.pixels[y*space.width+x]!=bgcolor) return true;
  return false;
}

void markPoint(int x, int y, color c) {
  space.loadPixels();
  space.pixels[y*space.width+x] = c;
  space.updatePixels();
}


void makePDF() {
  print("making PDF...");
  
  // draw vector versions of the gridWalker objects
  //drawGrid();
  //drawLabels();
  //for (int i=0;i<numstars;i++) {
  //  stars[i].draft();
  // }
  endRecord();
  println("done.");
}