class GridLine {

  int id;     // unique identifing number
  
  int x;      // position
  int y;
  int lastx;
  int lasty;
  
  float drawx;    // drawing position
  float drawy;    
  boolean drawing = false;
  
  int step;   // magnitude of movement
  int dir;    // direction 0 up, 1 right, 2 down, 3 left
  
  int cnt;    // count of steps taken
  
  int maxOneDirection;
  int oneDirection;
  
  int maxTotalLength;
  int totalLength;
  
  color myc = #FFFFFF;
  
  boolean active;
  
  int initFails = 0;
  
  GridLine(int ident) {
    id = ident;
    // wait to be initialized
    active = false;
  }
  
  void init(int posx, int posy, int direction, int step_len) {
    x = posx;
    y = posy;
    lastx = x;
    lasty = y;
    dir = direction;
    step = step_len;
    maxOneDirection = 500;
    oneDirection = 0;
    cnt = 0;
    
    maxTotalLength = 5000;
    totalLength = 0;
    
    //myc = color(random(255),random(255),random(255));
    if (!isClosed(x,y)) {
      active = true;
      //stroke(#FF0000);
      //point(scl/2+x*scl,scl/2+y*scl);
    } 
  }
  
  void doDraw() {
    if (x!=lastx || y!=lasty) {
      myc = bg.get(floor(map(scl/2+x*scl,0,width,0,bg.width)),floor(map(scl/2+y*scl,0,height,0,bg.height)));
      drawx = lastx;
      drawy = lasty;
      drawing = true;
      
      // draw the whole thing immediately
      stroke(myc,16);
      line(scl/2+lastx*scl,scl/2+lasty*scl,scl/2+x*scl,scl/2+y*scl);
    }
   
    lastx = x;
    lasty = y;
  }
  
  boolean doStep() {
    if (drawing) {
      // animating line drawing to next point
      float dx = drawx;
      float dy = drawy;
      
      // ease in
      //drawx += (x-drawx)*.5;
      //drawy += (y-drawy)*.5;
      
      // linear
      if (drawx<x) {
        drawx++;
      } else if (drawx>x) {
        drawx--;
      }
      
      if (drawy<y) {
        drawy++;
      } else if (drawy>y) {
        drawy--;
      }
      
      stroke(myc);
      line(scl/2+dx*scl,scl/2+dy*scl,scl/2+drawx*scl,scl/2+drawy*scl);
      
      if ((abs(drawx-x)<1) && (abs(drawy-y)<1)) {
        drawing = false;
        stroke(255,128);
        point(scl/2+dx*scl,scl/2+dy*scl);
        

      }
      
      
    } else if (active) {
      // build an array of direction options
      int[] dirs = new int[4];
      int len = 0;
      for (int n=0;n<4;n++) {
        if (n!=(dir+2)%4) {  // do not go backwards
          if ((n==dir && oneDirection<maxOneDirection) || n!=dir) {  // do not conintue in same direction if beyond maximum allowed
            // add this direction to the list of possible directions         
            dirs[len++] = n;
          }
        }
      }
      shuffle(dirs);
      
      // search through all possible directions and move if possible
      for (int n=0;n<len;n++) {
        if (isOpenDirection(dirs[n])) {
          stepInDirection(dirs[n]);
          return true;
        }
      }

      // unable to step
      shortenStep();

    } else {
      initGridLine(id);
    }
  
    return false;

  }
  
  boolean isOpenDirection(int d) {
    switch(d) {
      case 0: 
          // check step up
          for (int py=y-1;py>=y-step;py--) {
            if (isClosed(x,py)) return false;
          }
          break;
      case 1:
          // step right
          for (int px=x+1;px<=x+step;px++) {
            if (isClosed(px,y)) return false;
          }
          break;
      case 2:
          // step down
          for (int py=y+1;py<=y+step;py++) {
            if (isClosed(x,py)) return false;
          }
          break;
      case 3:
          // step left
          for (int px=x-1;px>=x-step;px--) {
            if (isClosed(px,y)) return false;
          }
          break;
      default:
          println("WARNING unknown direction "+d);
    }
    
    // the path is clear
    return true;
  }
  
  void stepInDirection(int D) {
    // move in direction
    switch (D) {
      case 0:
          // step up
          for (int py=y;py>=y-step;py--) {
            markPoint(x,py,myc);
          }
          y-=step;
          break;
      case 1:
          // step right
          for (int px=x;px<=x+step;px++) {
            markPoint(px,y,myc);
          }
          x+=step;
          break;
      case 2:
          // step down
          for (int py=y;py<=y+step;py++) {
            markPoint(x,py,myc);
          }
          y+=step;
          break;
      case 3:
          // step left
          for (int px=x;px>=x-step;px--) {
            markPoint(px,y,myc);
          }
          x-=step;
          break;
      default:
          println("WARNING unknown dircection: "+D);
    }

    // render the vector
    doDraw();
    

    cnt++;

    // set new direction
    if (dir==D) {
      // moving in the same direction
      oneDirection+=step;
    } else {
      // moving in a new direction
      oneDirection = 0;
    } 
    
    dir = D;
    
    // add to total length
    totalLength+=step;
    if (totalLength>=maxTotalLength) doDie();
    
  }    
  
  void shortenStep() {
    step/=2;
    if (step<1) {
      doDie();
    }
    
  }
  
  void doDie() {
    //stroke(#FF0000);
    //point(scl/2+x*scl,scl/2+y*scl);
    active = false;
    initGridLine(id);
  }
  
  
  void shuffle(int[] a) { 
    int temp; 
    int pick; 
     
     for(int i=0; i<a.length; i++) { 
       temp = a[i]; 
       pick  = (int)random(a.length); 
       a[i] = a[pick]; 
       a[pick]= temp; 
     } 
  }
  
}