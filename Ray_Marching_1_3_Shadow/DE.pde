class DistanceEstimator{
  ArrayList<Shape> shapes = new ArrayList<Shape>();
  Light light;
  float maxDst = 10000;
  float shadowIntensity = 0.2;
  float shadowBias = EPSILON * 50;
  
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
        
        PVector offsetPos = PVector.add(pointOnSurface, PVector.mult(normal, shadowBias));//Measures for re-collision
        PVector dirToLight = light.isPoint ? PVector.sub(light.data, offsetPos) : PVector.mult(light.data, -1);
        float dstToLight = light.isPoint ? PVector.dist(offsetPos, light.data) : maxDst;
        
        ray.o = offsetPos;
        ray.d = dirToLight;
        
        float shadow = CalcShadow(ray, dstToLight);
        return new ColDst(col.mult(lighting).mult(shadow), rayDst);
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
  
  ColDst SceneInfo(PVector eye){
    return SceneInfo(eye, shapes, maxDst, new Color(0, 0, 0));
  }
  
  ColDst SceneInfo(PVector eye, ArrayList<Shape> list, float dst, Color col){//get distance and color
    for(Shape shape : list){
      float tDst = shape.getDistance(eye);
      Color tCol = shape.col;
      
      if(shape.child.size() > 0){
        ColDst colDst = SceneInfo(eye, shape.child, tDst, tCol);
        tDst = colDst.dst;
        tCol = colDst.col;
      }
      ColDst combined = Combine(dst, tDst, col, tCol, shape.operation, shape.blendStrength);
      col = combined.col;
      dst = combined.dst;
    }
    return new ColDst(col, dst);
  }
  
  float CalcShadow(Ray ray, float dstToShadePoint){
    float rayDst = 0;
    float brightness = 1;
    
    while(rayDst < dstToShadePoint){
      float dst = SceneInfo(ray.o).dst;
      
      if(dst <= EPSILON){
        return shadowIntensity;
      }
      
      brightness = min(brightness, dst*200);
      
      ray.o.add(PVector.mult(ray.d, dst));
      rayDst += dst;
    }
    return shadowIntensity + (1-shadowIntensity) * brightness;
  }
  
  ColDst Combine(float dstA, float dstB, Color colA, Color colB, int operation, float blendStrength){
    float dst = dstA;
    Color col = colA;
    
    switch(operation){
      case 0://min(None)
        if(dstB < dstA){
          dst = dstB;
          col = colB;
        }
        break;
      case 1://lerp(Blend)
        ColDst colDst = blend(dstA, dstB, colA, colB, blendStrength);
        dst = colDst.dst;
        col = colDst.col;
        break;
      case 2://max(Cut)
        if(-dstB > dst){
          dst = -dstB;
          col = colB;
        }
        break;
      case 3:
        if(dstB > dst){
          dst = dstB;
          col = colB;
        }
        break;
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