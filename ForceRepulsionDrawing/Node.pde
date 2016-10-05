class Node {
  int id;
  color myc;
  
  ArrayList<Node> connections;
  
  float x = 0;
  float y = 0;
  
  float vx = 0;
  float vy = 0;
  float ax = 0;
  float ay = 0;
  
  float ah = 0;
  float heading = 0;
  float v = 0;
  
  // node body sizes
  float sizeMod = 1.5;
  float aoutr;
  float ainr;
  float outr;
  float inr;
  
  float age = 0;
  
  String label = "";
  
  int maxConnections = 5;
  
  boolean fixed = false;
  boolean thinking = false;
  
  
  
  Node(int unique_id) {
    id = unique_id;
    
    connections = new ArrayList<Node>();
    
    maxConnections = floor(3+pow(2,random(3.0)));
    
    
    
    label = str(id);
    
    render();
  }
  
  void didClick() {
    fixed = true;
    // randomize color
    render();
  }
  
  void render() {
    // calculate current size based on connection count and other factors
    calculateSize();
    
    // draw from the back to the front
    noStroke();
    fill(myc,192);
    // smooth animation towards outer radius
    aoutr += (outr-aoutr)*.1;
    ainr += (inr-ainr)*.1; 
    ellipse(x,y,aoutr,aoutr);
    fill(0);
    ellipse(x,y,ainr,ainr);
    //fill(255);
    //ellipse(x,y,5,5);
    stroke(255);
    point(x,y);
    
    
    if (picker.target == this) {
      textAlign(CENTER,TOP);
      if (label!="") {
        noStroke();
        fill(255);
        text(label,x,y+aoutr/2.0);
      }
    }
  }
  
  void calculateSize() {
    // more connections means bigger size
    outr = sizeMod*(connections.size()*connections.size())*.5+4; 
    inr = sizeMod*(connections.size()*connections.size())*.2+2;
    if (aoutr==0) aoutr=outr;
    if (ainr==0) ainr=inr;
  }
    
  
  void connectTo(Node some_node) {
    if (connections.size()<maxConnections) {
      if (some_node.connections.size()<maxConnections) {
        if (!isConnectedTo(some_node)) connections.add(some_node);
        render();
      }
    }
  }
  
  void disconnectFrom(Node someNode) {
    connections.remove(someNode);
  }
  
  boolean isConnectedTo(Node some_node) {
    for (int n=0;n<connections.size();n++) {
      if (some_node==connections.get(n)) return true;
    }
    return false;
  }
  
  void addForce(float fx, float fy) {
    vx+=fx;
    vy+=fy;
  }
  
  void absorbForce() {
    if (!fixed) {
      x+=vx;
      y+=vy;
    }
    
    vx = 0;
    vy = 0;
  
  }
  
  float distanceTo(Node some_node) {
    float dx = some_node.x - x;
    float dy = some_node.y - y;
    return sqrt(dx*dx+dy*dy);
  }
  
  void delete() {
    // remove this node
    network.removeNode(this);
  }
  
  
}