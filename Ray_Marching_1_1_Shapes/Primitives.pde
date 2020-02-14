class Shape{
  PVector o;
  PVector size;
  float r;
  float r2;
  Color col;
  int shapeType;
  
  Shape(int shapeType, Color col, PVector o , float r){
    this.shapeType = shapeType;
    this.col = col;
    this.o = o;
    this.r = r;
  }
  
  Shape(int shapeType, Color col, PVector o , PVector size){
    this.shapeType = shapeType;
    this.col = col;
    this.o = o;
    this.size = size;
  }
  
  Shape(int shapeType, Color col, PVector o , float r, float r2){
    this.shapeType = shapeType;
    this.col = col;
    this.o = o;
    this.r = r;
    this.r2 = r2;
  }
  
  float getDistance(PVector eye){
    switch(shapeType){
      case 0:
        return SphereDistance(eye);
      case 1:
        return CubeDistance(eye);
      case 2:
        return TorusDistance(eye);
      case 3:
        return CylinderDistance(eye);
    }
    return Float.NaN;
  }
  
  float SphereDistance(PVector eye){
    return PVector.dist(eye, o) - r;
  }
  
  float CubeDistance(PVector eye){
    PVector t = abs(PVector.sub(eye, o)).sub(size);
    float ud = max(t, new PVector()).mag();//unsigned distance
    float n = max(max(min(t.x, 0), min(t.y, 0)), min(t.z, 0));//distance inside box
    return ud+n;
  }
  
  float TorusDistance(PVector eye){
    PVector t = PVector.sub(eye, o);
    PVector q = new PVector(new PVector(t.x, t.z).mag()-r,eye.y-o.y);
    return q.mag()-r2;
  }
  
  float CylinderDistance(PVector eye){
    PVector t = PVector.sub(eye, o);
    PVector d = PVector.sub(abs(new PVector(new PVector(t.x, t.z).mag(), t.y)), size);
    return max(d,new PVector()).mag() + max(min(d.x, 0), min(d.y, 0));
  }
}