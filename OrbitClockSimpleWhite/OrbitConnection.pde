class OrbitConnection {
  
  int cid = -1;
  float distance = 0;
  float age = 0;
  
  OrbitConnection() {
  }
  
  void reset(float min_distance) {
    age = 0.0;
    cid = -1;
    distance = min_distance;
  }
}
