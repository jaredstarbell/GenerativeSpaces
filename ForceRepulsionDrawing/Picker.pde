class Picker {
  
  float x;
  float y;
  
  Boolean pulling = false;
  
  Node target = null;
  
  Picker() {
  }

  void render() {
    x = mouseX;
    y = mouseY;
    
    if (pulling) {
      // pull target towards mouse
      if (target!=null) {
        float fx = (x-target.x)/2.0;
        float fy = (y-target.y)/2.0;
        target.addForce(fx,fy);
        
        // render line to target
        stroke(#00FF00,128);
        line(x,y,target.x,target.y);
      }
    } else {
      target = getNearestNode();
    }
      
    
  }
  
  Node getNearestNode() {
    Node t = null;
    float min = width*height;
    for (int k=0;k<network.nodes.size();k++) {
      Node neo = network.nodes.get(k);
      float d = dist(x,y,neo.x,neo.y);
      if (d<min) {
        min = d;
        t = neo;
      }
    }
    return t;
  }
  
  void mousePressedLeft() {
    pulling = true;
  }
  
  void mouseReleasedLeft() {
    pulling = false;
  }
  
  void mousePressedRight() {
    //target.delete();
    //target.fixed = !target.fixed;
  }
  
  void mouseReleasedRight() {
  }
    

  
}