// Invader Fractal
//   Jared Tarbell
//   December 13, 2014

Invader[] invaders;
ArrayList<FillRequest> reqs;

int cnt = 0;
int maxcnt = 100000;

float fastcnt = 1;

float pad = .98;
float minSubWidth = 5.0;
float minSubHeight = 5.0;

Invader test;

void setup() {
  size(2560,1440); 
  background(0);
  smooth();
  
  //test = new Invader(32767,0,0,0,100,#FF0000);
  
  invaders = new Invader[maxcnt];
  reqs = new ArrayList<FillRequest>();
  
  FillRequest init = new FillRequest(new Rectangle(0,0,width,height),0);
  tryFill(init);
 
}

void draw() {
  for (int k=0;k<fastcnt;k++) {
    if (reqs.size()>0) {
      // pull a fill reuqest out of the list and fill it
      FillRequest f = reqs.remove(0);
      invade(f);
    } else {
      fastcnt = 0;
       for (int p=0;p<1000;p++) {
         int i= floor(random(cnt));
         if (invaders[i].visible) invaders[i].destroyRefill();
       }
    }
  }
  
  fastcnt++;

    
}


Boolean tryFill(FillRequest f) {
  // given a rectangle, put an Invader in one of the corners, subdivide the remainder
  float rw = f.r.x1 - f.r.x0;
  float rh = f.r.y1 - f.r.y0;
  if (rw>minSubWidth && rh>minSubHeight) {
    reqs.add(f);
    return true;
  }
 
  // unable to grant request to fill region - too small
  return false;  
  
}

void invade(FillRequest f) {
  int id = floor(random(32768));
  
  // assume filling the whole space right in the center
  float blockSize = min(f.w,f.h);
  float invaderX = f.r.x0+f.w/2.0;
  float invaderY = f.r.y0+f.h/2.0;
  
  // calculate size of invader
  float percent = random(10,80)/100;
  
  // if close to the minimal side, go to 100%
  if (min(f.w,f.h)<min(minSubWidth,minSubHeight)*2.0) {
    percent = 1;
  }
  
  // calculate aspect ratio
  float rAspect = f.h / f.w;
  if (rAspect<1.0) {
    // region is landscape
    blockSize = percent*f.h;
  } else {
    // region is portrait
    blockSize = percent*f.w;
  }
  
  float invaderSize = blockSize * (.98-(.02*f.gen));
  invaderSize = blockSize - 2;
  
  if (random(100)<50) {
    // place left
    if (random(100)<50) {
      // place top left
      invaderX = f.r.x0+blockSize/2.0;
      invaderY = f.r.y0+blockSize/2.0;
      // subdivide
      if (rAspect>1.0) {
        tryFill(new FillRequest(new Rectangle(f.r.x0+blockSize,f.r.y0,f.r.x1,f.r.y0+blockSize),f.gen+1));
        tryFill(new FillRequest(new Rectangle(f.r.x0,f.r.y0+blockSize,f.r.x1,f.r.y1),f.gen+1));
      } else {
        tryFill(new FillRequest(new Rectangle(f.r.x0,f.r.y0+blockSize,f.r.x0+blockSize,f.r.y1),f.gen+1));
        tryFill(new FillRequest(new Rectangle(f.r.x0+blockSize,f.r.y0,f.r.x1,f.r.y1),f.gen+1));
      }
    } else {
      // place bottom left
      invaderX = f.r.x0+blockSize/2.0;
      invaderY = f.r.y1-blockSize/2.0;
      // subdivide
      if (rAspect>1.0) {
        tryFill(new FillRequest(new Rectangle(f.r.x0,f.r.y0,f.r.x1,f.r.y1-blockSize),f.gen+1));
        tryFill(new FillRequest(new Rectangle(f.r.x0+blockSize,f.r.y1-blockSize,f.r.x1,f.r.y1),f.gen+1));
      } else {
        tryFill(new FillRequest(new Rectangle(f.r.x0,f.r.y0,f.r.x0+blockSize,f.r.y1-blockSize),f.gen+1));
        tryFill(new FillRequest(new Rectangle(f.r.x0+blockSize,f.r.y0,f.r.x1,f.r.y1),f.gen+1));
      }
    }     
  } else {
    // place right
    if (random(100)<50) {
      // place top right
      invaderX = f.r.x1-blockSize/2.0;
      invaderY = f.r.y0+blockSize/2.0;
      // subdivide
      if (rAspect>1.0) {
        tryFill(new FillRequest(new Rectangle(f.r.x0,f.r.y0,f.r.x1-blockSize,f.r.y0+blockSize),f.gen+1));
        tryFill(new FillRequest(new Rectangle(f.r.x0,f.r.y0+blockSize,f.r.x1,f.r.y1),f.gen+1));
      } else {
        tryFill(new FillRequest(new Rectangle(f.r.x0,f.r.y0,f.r.x1-blockSize,f.r.y1),f.gen+1));
        tryFill(new FillRequest(new Rectangle(f.r.x1-blockSize,f.r.y0+blockSize,f.r.x1,f.r.y1),f.gen+1));
      }
    } else {
      // place bottom right
      invaderX = f.r.x1-blockSize/2.0;
      invaderY = f.r.y1-blockSize/2.0;
      // subdivide
      if (rAspect>1.0) {
        tryFill(new FillRequest(new Rectangle(f.r.x0,f.r.y0,f.r.x1,f.r.y1-blockSize),f.gen+1));
        tryFill(new FillRequest(new Rectangle(f.r.x0,f.r.y1-blockSize,f.r.x1-blockSize,f.r.y1),f.gen+1));
      } else {
        tryFill(new FillRequest(new Rectangle(f.r.x0,f.r.y0,f.r.x1-blockSize,f.r.y1),f.gen+1));
        tryFill(new FillRequest(new Rectangle(f.r.x1-blockSize,f.r.y0,f.r.x1,f.r.y1-blockSize),f.gen+1));
      }
    }
  }
  
  // generate and render the invader
  //   Invader(int uid, float x_pos, float y_pos, float rotation, float square_width, color c) {
  Invader neo = new Invader(id, invaderX, invaderY, 0, invaderSize/5.0, #FFFFFF, f.gen, new Rectangle(invaderX-blockSize/2.0,invaderY-blockSize/2.0,invaderX+blockSize/2.0,invaderY+blockSize/2.0));
  if (cnt<maxcnt) {
    invaders[cnt] = neo;  
    cnt++;
  }  
}


void mousePressed() {
   // find closest Invader clicked
   println("mousepressed");
  for (int k=0;k<cnt;k++) {
    invaders[k].mousePressed();
    
  }

}

void keyPressed() {
  /*
  // save the image
  String fname = "InvaderFractal-"+str(floor(random(1000000000)))+".png";
  print("Saving "+fname+"...");
  saveFrame(fname);
  println("done!");
  
  // start fresh
  invaders = new Invader[maxcnt];
  reqs = new ArrayList<FillRequest>();
  cnt = 0;
  background(0);
  FillRequest init = new FillRequest(new Rectangle(0,0,width,height),0);
  tryFill(init);
  */
  
}

float setOmegaIncrement(float isize, float ipad, float radius) {
  float om = asin((isize+ipad)/radius);
  // recalculate om to fit invaders perfectly
  int ticks = floor(TWO_PI/om);
  om = TWO_PI/ticks;
  return om; 
}

class Rectangle {
  float x0, x1, y0, y1;
  
  Rectangle(float x_left, float y_top, float x_right, float y_bottom) {
    x0 = x_left;
    y0 = y_top;
    x1 = x_right;
    y1 = y_bottom;
    
    // bound check
    if (x1<x0) x1 = x0;
    if (y1<y0) y1 = y0;
  }
}


class FillRequest {
  Rectangle r;
  int gen;
  
  float w, h;
  
  FillRequest(Rectangle rect_region, int generation) {
    r = rect_region;
    gen = generation;
    w = r.x1-r.x0;
    h = r.y1-r.y0;
  }
}


class Invader {
  int id;
  String bid;
  float u;
  
  float x, y;
  float r;
  color myc;
  
  int gen;
  Rectangle rect;
  
  Boolean visible = true;
  
  Invader(int uid, float x_pos, float y_pos, float rotation, float square_width, color c, int generation, Rectangle fr) {
    myc = c;
    x = x_pos;
    y = y_pos;
    r = rotation;
    
    u = square_width;
    
    gen = generation;
    rect = fr;
    
    setId(uid);
  }
  
  void setId(int new_id) {
    id = new_id;
    bid = binary(id,15);
    render();
  }
   
  void render() {
    
    pushMatrix();
    noStroke();
    fill(myc);

    translate(x,y);
    rotate(r);
    for (int xx = 0; xx < 3;xx++) {
      for (int yy = 0; yy < 5; yy++) {
        if (bid.charAt(xx*5+yy)=='1') {
          rect((xx-.5)*u, (yy-2.5)*u, u, u);
          if (xx!=0) rect(-(xx+.5)*u, (yy-2.5)*u, u, u);
        }
      }
    }
    popMatrix();
    
  }

  void mousePressed() {
    if (visible) {
      if (dist(mouseX,mouseY,x,y)<u*3) {
        destroyRefill();
      }
    }
  }
  
  void destroyRefill() {
    if (u>5.0) {
      // erase old invader
      pushMatrix();
      noStroke();
      fill(0);
      translate(x,y);
      rotate(r);
      rect(-2.5*u-1,-2.5*u-1,5*u+2,5*u+2);
      popMatrix();
      
      // reset id
      //setId(floor(random(32768)));
      visible = false;
      
      tryFill(new FillRequest(rect,gen+1));
    }
  }

}






class InvaderImg {
  
  // trying to speed things up using a precached bitmap image of the Invader
  // tests show same speed as regular Invader, without added benefit of smoothness
  int id;
  String bid;
  float u;
  
  float x, y;

  float r;

  color myc;
  
  PGraphics img;
  
  
  InvaderImg(int uid, float x_pos, float y_pos, float rotation, float square_width, color c) {

    myc = c;
    x = x_pos;
    y = y_pos;
    r = rotation;
    
    u = square_width;
    
    img = createGraphics(round(u*5),round(u*5));
   
    setId(uid);
  }
  
  void setId(int new_id) {
    id = new_id;
    bid = binary(id,15);
    renderImage();
    render();
  }
  
  void renderImage() {
    img.beginDraw();
    img.noStroke();
    img.fill(myc);
    for (int xx = 0; xx < 3;xx++) {
      for (int yy = 0; yy < 5; yy++) {
        if (bid.charAt(xx*5+yy)=='1') {
          img.rect((xx+2)*u, yy*u, u, u);
          if (xx!=0) img.rect((2-xx)*u, yy*u, u, u);
        }
      }
    }
    img.endDraw();
    
  }
  void render() {
    
    pushMatrix();
    translate(x,y);
    rotate(r);
    image(img,-u*2.5,-u*2.5);
    popMatrix();
    
  }

  void mousePressed() {
    if (dist(mouseX,mouseY,x,y)<u*3) {
      setId(floor(random(32768)));
    }
  }
}
