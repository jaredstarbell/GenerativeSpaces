class Space {
  float tx;
  float ty;
  float tz;
  
  Space() {
    // define extents of visible space
    tx = width*6;
    ty = height*6;
    tz = 10000;
  }
}