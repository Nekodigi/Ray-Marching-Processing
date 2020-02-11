

void setup(){
  size(1000, 500);
}

void draw(){
  background(0);
  stroke(255);
  noFill();
  //show obstacle
  rect(width/2-350, height/2-100, 200, 200);
  ellipse(width/2+250, height/2, 200, 200);
  
  //ray
  PVector o = new PVector(mouseX, mouseY);
  PVector v = PVector.fromAngle((float)frameCount/1000);
  float dst = 1;
  while(dst > 0.1 && dst < 1000){
    //distance to obstacle
    dst = signedDstToCircle(o, new PVector(width/2+250, height/2), 100);
    dst = min(dst, signedDstToBox(o, new PVector(width/2-250, height/2), new PVector(100, 100)));
    
    ellipse(o.x, o.y, dst*2, dst*2);
    line(o.x, o.y, o.x+v.x*dst, o.y+v.y*dst);
    //march ray in v
    o.add(PVector.mult(v, dst));
  }
}

float signedDstToCircle(PVector p, PVector centre, float radius){
  return PVector.dist(p, centre) - radius;
}

float signedDstToBox(PVector p , PVector centre, PVector size){
  PVector offset = new PVector(abs(p.x-centre.x), abs(p.y-centre.y)).sub(size);
  
  float unsignedDst = new PVector(max(offset.x, 0), max(offset.y, 0)).mag();
  
  float dstInsideBox = max(min(offset.x, 0), min(offset.y, 0));
  return unsignedDst + dstInsideBox;
}