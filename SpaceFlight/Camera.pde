class Camera {
  float x;
  float y;
  float z;
  
  float fl;
  
  float t = 0;
  
  Camera(float pos_x, float pos_y, float pos_z, float focal_length) {
    x = pos_x;
    y = pos_y;
    z = pos_z;
    fl = focal_length;
  }
  
  void fly() {
    // drift up and down slowly
    t+=.001;
    
    y+=(space.ty*.00033)*cos(t);
    //y = 1 * space.ty * noise(t);
  }    
}