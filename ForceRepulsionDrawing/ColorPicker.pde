class ColorPicker {
  int numpal = 0;
  int maxpal;
  color[] goodcolor;
  
  ColorPicker(int max_colors, String file_name) {
    maxpal = max_colors;
    goodcolor = new color[maxpal];
    if (file_name!="") takeColor(file_name);
  }
  
    
  
  // color methods --------------------------------------------
  
  color somecolor() {
    // pick some random good color
    return goodcolor[int(random(numpal))];
  }
  
  void addColor(color c, int quantity) {
    for (int k=0;k<quantity;k++) {
      if (numpal<maxpal) {
        goodcolor[numpal] = c;
        numpal++;
      }
    }
  }
  
  void takeColor(String fn) {
    // clear background to begin
    background(0);
    
    // load color source
    PImage b;
    b = loadImage(fn);
    image(b,0,0);
    
    // initialize palette length
    numpal=0;
  
    // find all distinct colors
    for (int x=0;x<b.width;x++){
      for (int y=0;y<b.height;y++) {
        color c = get(x,y);
        boolean exists = false;
        for (int n=0;n<numpal;n++) {
          if (c==goodcolor[n]) {
            exists = true;
            break;
          }
        }
        if (!exists) {
          // add color to palette
          if (numpal<maxpal) {
            goodcolor[numpal] = c;
            numpal++;
          } else {
            break;
          }
        }
      }
    }
  }
  
}