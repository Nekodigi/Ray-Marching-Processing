int pixelSize = 4;

Light pointLight = new Light(new PVector(20, 20, 20), true);
DistanceEstimator DE = new DistanceEstimator(pointLight);
PVector eye = new PVector(0, 0, 100);
PVector focal = new PVector(0, 0, 0);
PVector up = new PVector(0, 1, 0);
float view_distance = 1000;
Camera cam;

void setup(){
  size(500, 500);
  //fullScreen();
  cam = new Camera(eye, focal, view_distance, up, DE);  
  DE.shapes.add(new Shape(0, new PVector(-10, 0, 0), 10, new Color(1, 1, 1)));
  DE.shapes.add(new Shape(0, new PVector(10, 5, 0), 5, new Color(1, 0, 0)));
}

void draw(){
  noStroke();
  cam.render();
  pointLight.data = new PVector(float(mouseX-width/2)/10, float(-mouseY+height/2)/10, 20);
}