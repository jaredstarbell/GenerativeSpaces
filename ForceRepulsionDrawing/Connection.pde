class Connection {
  
  Node nodeA = null;
  Node nodeB = null;
  
  String label = "";
  
  float strength = 1.0;
  float thickness = 1.0;
  
  color myc;
  
  Boolean visible = true;
  
  Connection(Node node_a, Node node_b, String text_label, float connection_strength, color line_color, float line_thickness) {
    nodeA = node_a;
    nodeB = node_b;
    label = text_label;
    strength = connection_strength;
    myc = line_color;
    thickness = line_thickness;
  }
  
  void render() {
    if (nodeA!=null && nodeB!=null) {
      stroke(myc);
      strokeWeight(thickness);
      line(nodeA.x,nodeA.y,nodeB.x,nodeB.y);
    }
  }
}