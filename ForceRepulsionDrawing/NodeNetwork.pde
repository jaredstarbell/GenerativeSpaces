class NodeNetwork {
  String name = "TestNetwork";
  
  String version = "1.0";
  String source = "";
  String author = "";
  int year = 2012;
  
  float drag = 10;  // the larger this is the slower the nodes will attract
  float push = 10;  // the larger this is the slower the nodes will repel
 
  float spaceWindX = 0;
  float spaceWindY = 0;
 
  Node holdNode = null;
  
  Boolean saving = false;
 
  ArrayList<Node> nodes;
  ArrayList<Connection> connections;
  
  Node lastNode = null;
  

  
  NodeNetwork() {
   
    resetNetwork();
   
    //makeNodeSpiral(400);
    
    //connectNearby(11, 600);
  }
    
  void render(int multiplier) {
    if (!saving) {
      for (int k=0;k<multiplier;k++) {
        calculateForces();
        applyForces();
      }
    }
    renderConnections(); 
    renderNodes();
  }
  
  
  void calculateForces() {
    // calculate all node forces
    for (int n = 0;n<nodes.size()-1;n++) {
      // pick a node to operate on
      Node nodeA = nodes.get(n);
      
      // check against all remaining
      for (int j=n+1;j<nodes.size();j++) {
        Node nodeB = nodes.get(j);
       
        float dx = nodeA.x - nodeB.x;
        float dy = nodeA.y - nodeB.y;
        float d = sqrt(dx*dx+dy*dy);
        
        if (nodeA.isConnectedTo(nodeB)) {
          // draw closer to connections
          float fx = (nodeB.x - nodeA.x)/drag;
          float fy = (nodeB.y - nodeA.y)/drag;
          nodeA.addForce(fx,fy);
          nodeB.addForce(-fx,-fy);
        }
        
        // push away from all other nodes
        float mind = 50+(nodeA.connections.size()+nodeB.connections.size())*20;
        
        if (d<mind) {
          float ffx = (mind/d*dx/d)/push;
          float ffy = (mind/d*dy/d)/push;
          nodeA.addForce(ffx,ffy);
          nodeB.addForce(-ffx,-ffy);
        }
      }
    }
  }
  
  void calculateSpaceWindForce() {
    // calculate all node forces
    float mind = 100;
    for (int n=0;n<nodes.size();n++) {
      Node nodeA = nodes.get(n);
      
      float dx = nodeA.x - spaceWindX;
      float dy = nodeA.y - spaceWindY;
      float d = sqrt(dx*dx+dy*dy);
      
      if (d<mind) {
        float ffx = (dx/d)/push;
        float ffy = (dy/d)/push;
        nodeA.addForce(6*ffx,6*ffy);
      }
    }
  }

  void applyForces() {
    // apply all forces
    for (int n=0;n<nodes.size();n++) {
      Node nodeA = nodes.get(n);
      nodeA.absorbForce();
      
      if (nodeA==holdNode) {
        nodeA.x = mouseX;
        nodeA.y = mouseY;
      }
    }
  }
  
  void renderConnections() {
    for (int n =0;n<nodes.size();n++) {
      Node nodeA = nodes.get(n);
      for (int k = 0;k<nodeA.connections.size();k++) {
        // only render connectinos one way, using id as a specifier
        if (nodeA.id<nodeA.connections.get(k).id) {
          stroke(255,128);
          line(nodeA.x,nodeA.y,nodeA.connections.get(k).x,nodeA.connections.get(k).y);
        }
      }
    }
  }
  
  void renderNodes() {
    for (int n=0;n<nodes.size();n++) {
      Node nodeA = nodes.get(n);
      nodeA.render();
    }
  }  
  
  
  void makeNode(int id, float xpos, float ypos, color myc, boolean connectToLast) {
    Node neo = new Node(id);
    neo.x = xpos;
    neo.y = ypos;
    neo.myc = myc;
    nodes.add(neo);
    
    if (connectToLast && lastNode!=null) {
      neo.connectTo(lastNode);
      lastNode.connectTo(neo);
    }
    
    // keep track of last node made
    lastNode = neo;
    
    println("make Node:"+id);
    
  }
  
  void makeNodeSpiral(int limit) {
    Node lastneo = null;
    
    float theta = 0;
    float r = 100;
    float dr = .01;
    
    for (int k =0;k<limit;k++) {
      float xx = width/2.0 + r * cos(theta);
      float yy = height/2.0 + r * sin(theta);
      makeNode(k,xx,yy,somecolor(),false);
      
      theta+=137.5*PI/180;
      r += dr;
      
      dr+=.0001;
    }
  }
  
  void removeNode(Node somenode) {
    // remove all connections to this node
    for (int k=0;k<nodes.size();k++) {
      Node node = nodes.get(k);
      if (node!=somenode) {
        if (node.isConnectedTo(somenode)) {
          node.disconnectFrom(somenode);
        }
      }
    }
    nodes.remove(somenode);
  }
  
  Boolean connectNearby(float max_dist) {
    int ai = floor(random(nodes.size()));
    int bi = floor(random(nodes.size()));
    Node nodeA = nodes.get(ai);
    Node nodeB = nodes.get(bi);
    
    if (nodeA !=nodeB) {
      // connect nodes if within maximum distance
      float d = nodeA.distanceTo(nodeB);
      if (d<max_dist) {
        // connectNodes(nodeA,nodeB);
        nodeA.connectTo(nodeB);
        nodeB.connectTo(nodeA);
      }
    }
    
    // did not reach maximum connections allowed
    return false;
  }
  
   Boolean connectRecent(int max_time, float max_dist, int max_connections) {
    int numConnects = 0;
    
    for (int k=0;k<4;k++) {
      // iterate three time through yo
      int lowLimit = nodes.size()-max_time;
      if (lowLimit<0) lowLimit = 0;
      for (int n=lowLimit;n<nodes.size()-1;n++) {
        int ai = floor(random(lowLimit,nodes.size()));
        int bi = floor(random(lowLimit,nodes.size()));
        Node nodeA = nodes.get(ai);
        Node nodeB = nodes.get(bi);
        
        if (nodeA !=nodeB) {
          // connect nodes if within maximum distance
          float d = nodeA.distanceTo(nodeB);
          if (d<max_dist) {
            // connectNodes(nodeA,nodeB);
            nodeA.connectTo(nodeB);
            nodeB.connectTo(nodeA);
            
            // check how close we are to maximum connections
            numConnects++;
            if (numConnects>=max_connections) return true;
          }
        }
      }
    }
    // did not reach maximum connections allowed
    return false;
  }
  
  void connectRandom(int n_times) {
    // make some random connections
    for (int n =0;n<n_times;n++) {
      int ai = floor(random(nodes.size()));
      int bi = floor(random(nodes.size()));
      Node nodeA = nodes.get(ai);
      Node nodeB = nodes.get(bi);
      if (nodeA!=nodeB) {
        // connectNodes(nodeA,nodeB);
        nodeA.connectTo(nodeB);
        nodeB.connectTo(nodeA);
      }
    }
  }
  
  void connectRandomNearby(float max_distance) {
    // make one random connection of nearby nodes
    for (int n=0;n<22;n++) {
      int ai = floor(random(nodes.size()));
      int bi = floor(random(nodes.size()));
      Node nodeA = nodes.get(ai);
      Node nodeB = nodes.get(bi);
      if (nodeA!=nodeB) {
        if (nodeA.distanceTo(nodeB)<max_distance) {
          // connectNodes(nodeA,nodeB);
          nodeA.connectTo(nodeB);
          nodeB.connectTo(nodeA);
        }
      }
    }
  }
  
  void connectNodes(Node node_to, Node node_from, String connection_label) {
    if (node_to!=null) {
      if (node_from!=null) {
        if (node_to!=node_from) {
          node_to.connectTo(node_from);
          node_from.connectTo(node_to);
          
          Connection con = new Connection(node_to,node_from,connection_label,1.0,#FFFFFF,random(1.0,8.0));
          connections.add(con);
        }
      }
    }
  }
  
  void disconnectNodes(Node node_a, Node node_b) {
    Connection con = getConnection(node_a,node_b);
    if (con!=null) {
      // TODO
    }
    
    
  }
  
  Connection getConnection(Node node_a, Node node_b) {
    for (int k=0;k<connections.size();k++) {
      Connection con = connections.get(k);
      if (con.nodeA==node_a && con.nodeB==node_b) return con;
      if (con.nodeA==node_b && con.nodeB==node_a) return con;
    }
    // no such connection
    return null;
  }

  
  void saveNetwork() {
    // wait for user to select a file name and path
    saving = true;
    selectOutput("Select a file to save network to (JSON):", "fileSaveSelected");
  }

  void fileSaveSelected(File selection) {
    if (selection==null) {
      return;
    } else {  
    // create master JSON array
    JSONArray master = new JSONArray();

    String fn = selection.getAbsolutePath();
    print("Saving network "+fn+"...");
    // create JSON object for information about the network in general
    JSONObject netson = new JSONObject();
    netson.setString("source","Force Repulsion Directed Graph");
    netson.setString("author","Jared Tarbell");
    netson.setInt("year",year());
    netson.setString("name",name);
    netson.setString("version",version);
    netson.setFloat("drag",drag);
    netson.setFloat("push",push);
     
    // add network information to the master JSON array
    master.setJSONObject(0, netson);
    
    for (int k=0;k<nodes.size();k++) {
      // get reference to node
      Node node = nodes.get(k);
      
      // create JSON object for node information
      JSONObject nson = new JSONObject();
      nson.setInt("id",node.id);
      nson.setInt("myc",node.myc);
      nson.setFloat("x",node.x);
      nson.setFloat("y",node.y);
      nson.setFloat("sizeMod",node.sizeMod);
      nson.setFloat("outr",node.outr);
      nson.setFloat("inr",node.inr);
      nson.setFloat("age",node.age);
      nson.setString("label",node.label);
      nson.setInt("maxConnections",node.maxConnections);
      nson.setBoolean("fixed",node.fixed);
      
      // create JSON array for all connections
      JSONArray nsonConnects = new JSONArray();
      for (int i=0;i<node.connections.size();i++) {
        Node ncon = node.connections.get(i);
        nsonConnects.setInt(i,ncon.id);        
      }
      nson.setJSONArray("connections",nsonConnects);
      
      // add node information to master JSON array
      master.setJSONObject(k+1, nson);
    }
     
    saveJSONArray(master,fn);
    println("done.");
    saving = false;
    }
  }
  
  void loadNetwork(String networkname) {
    // create a new network 
    resetNetwork();
    // wait for user to select a file to load
    selectInput("Select a network file to load (JSON):","fileReadSelected");
  }    
  
  void fileReadSelected(File selected) {
    // read the file and create the network
    String fn = selected.getAbsolutePath();
    print("Loading network "+fn+"...");
    JSONArray master = loadJSONArray(fn);

    // get network general info    
    JSONObject netson = master.getJSONObject(0);
    try {
      source = netson.getString("source");
      author = netson.getString("author");
      year = netson.getInt("year");
      name = netson.getString("name");
      version = netson.getString("version");
      drag = netson.getFloat("drag");
      push = netson.getFloat("push");
    } catch (Exception e) {
      println("some attributes not found");
    }
    
    // get the network nodes
    for (int k=1;k<master.size();k++) {
      JSONObject nson = master.getJSONObject(k);
      
      Node neo = new Node(nson.getInt("id"));
      neo.myc = nson.getInt("myc");
      neo.x = nson.getFloat("x");
      neo.y = nson.getFloat("y");
      neo.sizeMod = nson.getFloat("sizeMod");
      neo.outr = nson.getFloat("outr");
      neo.inr = nson.getFloat("inr");
      neo.age = nson.getFloat("age");
      neo.label = nson.getString("label");
      neo.maxConnections = nson.getInt("maxConnections");
      neo.fixed = nson.getBoolean("fixed");
      nodes.add(neo);
    }
    
    // get the network node connections
    for (int k=1;k<master.size();k++) {
      JSONObject nson = master.getJSONObject(k);
      
      Node nodeA = nodes.get(nson.getInt("id"));
      
      JSONArray cons = nson.getJSONArray("connections");
      
      for (int i=0;i<cons.size();i++) {
        Node nodeB = nodes.get(cons.getInt(i));
        nodeA.connectTo(nodeB);
      }
    }
    
    println("done.");
    
  }
  
  void resetNetwork() {
    // initialize everything to nothing
    nodes = new ArrayList<Node>();
    drag = 10;  // the larger this is the slower the nodes will attract
    push = 10;  // the larger this is the slower the nodes will repel
   
    spaceWindX = 1.0;
    spaceWindY = 0;
  }
      
    
          
} 
  