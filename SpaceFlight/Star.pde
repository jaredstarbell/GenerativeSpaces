class Star {
  float x = 0;
  float y = 0;
  float z = 0;

  float ls = 0;
  float lx = 0;
  float ly = 0;
  float lr = 0;
  
  float w;
  
  color c = #FFFFFF;
  
  float id;
  int nid;
  
  Boolean hasOrbs = false;
  Orbital[] orbs;
  int numo = 0;
  int maxo = 16;
  


 
  Star(int ident, float pos_x, float pos_y, float pos_z) {
    nid = ident;
    x = pos_x;
    y = pos_y;
    z = pos_z;
    
    w = 1.0 + random(1);
    w = w*w*w;
    
    id = random(10.0);
    
    //c = goodColor.someColor();
    c = color(id*25.5,id*5,255);
    
    orbs = new Orbital[maxo];
  }
  
  void render() {
    // move forward
    z-=starSpeed;
    
    // flyer
    if (nid<flyers) {
      z+=32;
      if (z>space.tz*3) {
        z = cam.z;
        x = cam.x+ .1*random(-space.tx,space.tx);
        y = cam.y+ .1*random(-space.ty,space.ty);
      }
    }
    
    float zActual = cam.fl - cam.z + z;
    if (zActual>0) {
      // object is in front of camera
      float scale = cam.fl/zActual;
      float dx = width*.5 + (x - cam.x)*scale;
      float dy = height*.5 + (y - cam.y)*scale;
      
      float dr = .5 + scale*w;

      // compute brightness
      float b = 255;
      if (nid>flyers) {
        if (space.tz-z<space.tz*.4) {
          b = 255*(space.tz-z)/(space.tz*.4);
        }
      }

      if (renderConnections) {
        if (z<space.tz*.1) {
          // draw a connection line
          temps[numt] = nid;
          numt++;
        }
      }
      
      // draw additional detail for stars close to camera
      if (dr>7) {
        // render some special effects
        for (int k=0;k<3;k++) {
          noStroke();
          fill(255,b*(.4-.1*k));
          beginShape();
          float omega = TWO_PI/15;
          for (int t=0;t<15;t++) {
            float theta = omega*t+random(omega);
            float tr = dr*random(.55,.6+.11*k);
            float tx = dx + tr*cos(theta);
            float ty = dy + tr*sin(theta);
            vertex(tx,ty);
          }
          endShape();
        }
        if (showOrbitals) {
          // render orbitals
          if (numo>0) {
            for (int k=0;k<numo;k++) {
              orbs[k].render(dx,dy,.01*dr);
            }
          } else {
            // make some orbs
            float rx = random(TWO_PI);
            float ry = random(TWO_PI);
            int lim = floor(random(maxo));
            for (int n=0;n<lim;n++) {
              // Orbital(float xrotation, float yrotation, float zrotation, float orbit_radius, float orbit_velocity, float object_mass ) {
  
              orbs[n] = new Orbital(rx,ry,random(TWO_PI), random(2,200), random(.01,.05), random(2,10));
              numo++;
            }
          }
        }
      }

      noStroke();
      // color halo
      //fill(25*id,0,255,b*.22);
      fill(c,b*.22);
      ellipse(dx,dy,dr*3,dr*3);
      // white circle
      fill(255,b);
      ellipse(dx,dy,dr,dr);
      
      
      // track last position
      ls = scale;
      lx = dx;
      ly = dy;
      lr = dr;

      // rebirth if offscreen
      if (dx+dr<0) rebirth();
      if (dx-dr>width) rebirth();
      if (dy+dr<-height*4) rebirth();
      if (dy-dr>height*4) rebirth();
      
      //println("star scale: "+scale+"   xyz: "+x+","+y+","+z+"  ::  da:"+da+"   dr:"+dr+",   dxyz:"+dx+","+dy);
      
    } else {
      // object is behind camera
      rebirth();
    }
 
  }
  
  void rebirth() {
    if (nid>flyers) {
      z = space.tz;
      
      // reset orbitals
      numo = 0;
      
      if (random(100)<90) {
        // place x y with noise and fuzz
        float fuzzx = 20*random(-id,id);
        float fuzzy = 20*random(-id,id);
        x = 2*(noise(time,id)-.5)*space.tx + fuzzx;
        y = 2*(noise(id,time)-.5)*space.ty + fuzzy;
      } else {
        x = random(-space.tx,space.tx);
        y = random(-space.ty,space.ty);
      }
    }
  }
}