class Orbital {
  float radius = 100;
  float vel = .01;
  float mass = 10;
  
  float rx = random(TWO_PI);
  float ry = random(TWO_PI);
  float rz = 0;
  
  
  Orbital(float xrotation, float yrotation, float zrotation, float orbit_radius, float orbit_velocity, float object_mass ) {
    rx = xrotation;
    ry = yrotation;
    rz = zrotation;
    
    radius = orbit_radius;
    vel = orbit_velocity;
    mass = object_mass;
    
  }
  
  void render(float x, float y, float s) {
    noStroke();
    fill(#FFFFFF);
    pushMatrix();
    translate(x,y);
    scale(s);
    rotateX(rx);
    rotateY(ry);
    rotateZ(rz);
    translate(radius,0);
    sphere(mass);
    popMatrix();  
    
    // orbit
    rz+=vel;
  }
  
  
}