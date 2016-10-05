class Orbit {
  int id;
  float x,y;
  float ox,oy;
  float r;
  float rd;
  float c;  // clock
  float cd;
  float theta;
  float td;
  float body;
  
  int tick;
  
  color myc;
  
  int maxconnects = 5;
  OrbitConnection[] cons;
  
  Orbit(int unique_id, float theta_angle, float omega_angle, float radius, float radius_delta, int tick_offset) {
    id = unique_id;
    
    
    ox = width/2;
    oy = height/2;
    x = ox;
    y = oy;
    r = radius;
    rd = radius_delta;
    theta = theta_angle;
    td = omega_angle;
    tick = tick_offset;
    
    body = random(1.0,1.7);
    body = body*body*body;
    
    //myc = goodcolor[floor(random(goodcolor.length))];
    myc = #FFFFFF;
    cons = new OrbitConnection[maxconnects];
    for (int i=0;i<maxconnects;i++) cons[i] = new OrbitConnection();
    
    
  } 
  
  void render() {
    noStroke();
    fill(255);
    ellipse(x,y,body,body);

  }
  
  void move() {
    float tm = millis()%tick;
    float tdd = 0;
    if (tm<tick*.2) tdd = td*(cos(PI*tm/(tick*.2))+1);
    theta+=tdd;
    r+=rd;
    x = ox+r*cos(theta);
    y = oy+r*sin(theta);
    
  }
  
  void connect() {
    // assume no connections are possible
    for (int k=0;k<maxconnects;k++) {
      cons[k].reset(400);
    }
    // connect to nearest three orbits
    for (int i=0;i<num;i++) {
      if (i!=id) {
        float d = dist(orbits[i].x,orbits[i].y,x,y);
        for (int n=0;n<maxconnects;n++) {
          if (d<cons[n].distance) {
            // shift all connections outward
            for (int s=maxconnects-1;s>n;s--) {
              cons[s].cid = cons[s-1].cid;
              cons[s].distance = cons[s-1].distance;
              cons[s].age = cons[s-1].age;
            }
            cons[n].distance = d;
            cons[n].cid = i;
            n=maxconnects;
          }
        }
      }
    }
    
    renderConnections();
    
  }
  
  void renderConnections() {
    for (int i=0;i<maxconnects;i++) {
      if (cons[i].cid>=0) {
        //stroke(myc,64);
        //stroke(myc,8);
        stroke(64,128);
        line(orbits[cons[i].cid].x,orbits[cons[i].cid].y,x,y);
      }
    }
  }
}
