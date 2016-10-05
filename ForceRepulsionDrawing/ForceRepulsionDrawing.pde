//  Force Repulsion network
//    Jared Tarbell
//    December 28, 2014

NodeNetwork network;
Picker picker;
ColorPicker cp;

Boolean drawing = false;

int globalID = 0;

void setup() {
  size(1920,1080);
  //fullScreen();
  
  background(0);
  
  picker = new Picker();
  cp = new ColorPicker(128,"pollockFFF.gif");
  
  network = new NodeNetwork();
}

void draw() {
  background(0);
  picker.render();
  network.render(1);
  
  if (drawing) {
    float xx = mouseX+random(-2.0,2.0);
    float yy = mouseY+random(-2.0,2.0);
    if (random(100)<100) network.makeNode(globalID++,xx,yy,somecolor(),true);
    if (random(100)<10) network.connectRecent(10,100,3);
    
  }
  
  // connect nearby nodes at random
  for (int k=0;k<network.nodes.size()*.5;k++) network.connectNearby(100);
  
  // randomly delete old nodes 
  int d = floor(random(network.nodes.size()*.2)-20);
  if (d>=0) {
    Node olde = network.nodes.get(d);
    if (olde!=null) {
      network.removeNode(olde);
    }
  }
  
  
}

void mousePressed() {
  if (mouseButton==LEFT) {
    //picker.mousePressedLeft();
  } else if (mouseButton==RIGHT) {
    //picker.mousePressedRight();
    drawing = true;
  }
  
}

void mouseReleased() {
  if (mouseButton==LEFT) {
    //picker.mouseReleasedLeft();
  } else if (mouseButton==RIGHT) {
    //picker.mouseReleasedRight();
    drawing = false;
    network.lastNode = null;
  }
}

void keyPressed() {
  if (key=='s') { 
    network.saveNetwork();
  } else if (key=='l') {
    network.loadNetwork("TestNetwork");
  } else {
    //println("keypressed: "+key);
  }
}
  
void fileSaveSelected(File selected) {
  network.fileSaveSelected(selected);
}

void fileReadSelected(File selected) {
  network.fileReadSelected(selected);
}

color somecolor() {
  return cp.somecolor();
}