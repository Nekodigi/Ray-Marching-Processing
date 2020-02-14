class DistanceEstimator{
  ArrayList<Shape> shapes = new ArrayList<Shape>();
  Light light;
  float maxDst = 10000;
  
  DistanceEstimator(Light light){
    this.light = light;
  }
  
  ColDst Estimate(Ray ray){
    float rayDst = 0;
    while(rayDst < maxDst){
      ColDst sceneInfo = SceneInfo(ray.o);
      float dst = sceneInfo.dst;
      if(dst <= EPSILON){
        PVector pointOnSurface = PVector.add(ray.o, PVector.mult(ray.d, dst));
        PVector normal = EstimateNormal(PVector.sub(pointOnSurface, PVector.mult(ray.d, EPSILON)));
        PVector lightDir = light.isPoint ? PVector.sub(light.data, ray.o).normalize() : PVector.mult(light.data, -1);
        float lighting = constrain(PVector.dot(normal, lightDir), 0, 1);//1 when light enters vertically, 0 when inserted horizontally. cos(theta)
        Color col = sceneInfo.col;
        return new ColDst(col.mult(lighting), rayDst);
      }
      ray.o.add(PVector.mult(ray.d, dst));
      rayDst += dst;
    }
    return new ColDst(new Color(0, 0, 0), 0);
  }
  
  PVector EstimateNormal(PVector eye){//Get normal with difference method
    float x = SceneInfo(new PVector(eye.x+EPSILON, eye.y, eye.z)).dst - SceneInfo(new PVector(eye.x-EPSILON, eye.y, eye.z)).dst;
    float y = SceneInfo(new PVector(eye.x, eye.y+EPSILON, eye.z)).dst - SceneInfo(new PVector(eye.x, eye.y-EPSILON, eye.z)).dst;
    float z = SceneInfo(new PVector(eye.x, eye.y, eye.z+EPSILON)).dst - SceneInfo(new PVector(eye.x, eye.y, eye.z-EPSILON)).dst;
    return new PVector(x, y, z).normalize();
  }
  
  ColDst SceneInfo(PVector eye){//get distance and color
    float dst = maxDst;
    Color col = new Color(0, 0, 0);
    
    for(Shape shape : shapes){
      float tDst = shape.getDistance(eye);
      //combine
      if(tDst < dst){
        dst = tDst;
        col = shape.col;
      }
    }
    return new ColDst(col, dst);
  }
}

class ColDst{//data container
  Color col;
  float dst;
  ColDst(Color col, float dst){
    this.col = col;
    this.dst = dst;
  }
}