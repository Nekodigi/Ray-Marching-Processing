int pixelSize = 2;

Light pointLight = new Light(new PVector(20, 20, 20), true);
DistanceEstimator DE = new DistanceEstimator(pointLight);
PVector eye = new PVector(0, 50, 100);
PVector focal = new PVector(0, 0, 0);
PVector up = new PVector(0, 1, 0);
float view_distance = 1000;
Camera cam;

void setup(){
  size(500, 500);
  //fullScreen();
  cam = new Camera(eye, focal, view_distance, up, DE);  
  DE.shapes.add(new Shape(0, new Color(1, 1, 1), new PVector(-15, 0, 0), 5));
  DE.shapes.add(new Shape(1, new Color(1, 1, 1), new PVector(0, 15, 0), new PVector(3, 3, 5)));
  DE.shapes.add(new Shape(2, new Color(1, 1, 1), new PVector(15, 0, 0), 5, 2));
  DE.shapes.add(new Shape(3, new Color(1, 1, 1), new PVector(0, -15, 0), new PVector(3, 5)));
}

void draw(){
  noStroke();
  cam.render();
  pointLight.data = new PVector(float(mouseX-width/2)/10, float(-mouseY+height/2)/10, 20);
}