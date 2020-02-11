class Shape{
  PVector o;
  PVector size;
  float r;
  Color col;
  int shapeType;
  
  Shape(int shapeType, PVector o , float r, Color col){
    this.shapeType = shapeType;
    this.o = o;
    this.r = r;
    this.col = col;
  }
  
  float getDistance(PVector eye){
    switch(shapeType){
      case 0:
        return SphereDistance(eye);
    }
    return Float.NaN;
  }
  
  float SphereDistance(PVector eye){
    return PVector.dist(eye, o) - r;
  }
}