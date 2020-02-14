int pixelSize = 5;

Light pointLight = new Light(new PVector(20, 20, 20), true);
DistanceEstimator DE = new DistanceEstimator(pointLight);
PVector eye = new PVector(0, 50, 100);
PVector focal = new PVector(0, 0, 0);
PVector up = new PVector(0, 1, 0);
float view_distance = 1000;
Camera cam;
Shape sphere;
Shape sphere2;
Shape sphere3;

void setup(){
  size(1000, 500);
  //fullScreen();
  cam = new Camera(eye, focal, view_distance, up, DE);  
  Shape cube = new Shape(1, new Color(1, 1, 1), new PVector(0, -10, 0), new PVector(30, 15, 15));
  DE.shapes.add(cube);
  sphere = new Shape(0, new Color(1, 0, 0), new PVector(-20, 10, 0), 10);
  sphere.setOperation(1,10);
  cube.child.add(sphere);
  sphere2 = new Shape(0, new Color(0, 1, 0), new PVector(0, 10, 0), 10);
  sphere2.setOperation(2,0);
  cube.child.add(sphere2);
  sphere3 = new Shape(0, new Color(0, 0, 1), new PVector(20, 10, 0), 10);
  DE.shapes.add(sphere3);
  Shape cube2 = new Shape(1, new Color(1, 1, 1), new PVector(0, 0, 0), new PVector(30, 15, 15));
  cube2.setOperation(3,0);
  sphere3.child.add(cube2);
  //DE.shapes.add(sphere);
}

void draw(){
  noStroke();
  cam.render();
  sphere.o = new PVector(-20, sin((float)frameCount/100)*20+5, 0);
  sphere2.o = new PVector(0, sin((float)frameCount/100+1)*20+5, 0);
  sphere3.o = new PVector(20, sin((float)frameCount/100+2)*20+5, 0);
  pointLight.data = new PVector(float(mouseX-width/2)/10, float(-mouseY+height/2)/10, 20);
}