int pixelSize = 1;

Light pointLight = new Light(new PVector(1, 1, 1).normalize(), false);
DistanceEstimator DE = new DistanceEstimator(pointLight);
PVector eye = new PVector(0, 0, 2);
PVector focal = new PVector(0, 0, 0);
PVector up = new PVector(0, 1, 0);
float view_distance = 1000;
Camera cam;

void setup() {
  //size(500, 500);
  fullScreen();
  colorMode(HSB, 360, 100, 100);
  cam = new Camera(eye, focal, view_distance, up, DE);
  noStroke();
  cam.render();
}

void draw() {
}