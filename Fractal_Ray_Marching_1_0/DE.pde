class DistanceEstimator {
  Light light;
  int maxStepCount = 250;
  float maxDst = 200;
  float shadowIntensity = 0.2;
  float shadowBias = EPSILON * 50;
  float power = 2;
  float darkness = 20;

  DistanceEstimator(Light light) {
    this.light = light;
  }

  ColDst Estimate(Ray ray) {

    ColDst result = new ColDst(new Color(0, 0, 0), 0);
    float rayDst = 0;
    int marchSteps = 0;
    while (rayDst < maxDst && marchSteps < maxStepCount) {
      marchSteps++;
      IterDst sceneInfo = SceneInfo(ray.o);
      float dst = sceneInfo.dst;
      if (dst <= EPSILON) {
        PVector normal = EstimateNormal(PVector.sub(ray.o, PVector.mult(ray.d, EPSILON*2)));
        PVector lightDir = light.isPoint ? PVector.sub(light.data, ray.o).normalize() : PVector.mult(light.data, -1);
        float fa = constrain(PVector.dot(normal, lightDir), 0, 1);
        float fb = constrain(sceneInfo.iter/16, 0, 1);

        result = new ColDst(new Color(fb, fa, 1), rayDst);
      }
      ray.o.add(PVector.mult(ray.d, dst));
      rayDst += dst;
    }
    float rim = marchSteps/darkness;
    return result.mult(result, rim);
  }

  PVector EstimateNormal(PVector eye) {//Get normal with difference method
    float x = SceneInfo(new PVector(eye.x+EPSILON, eye.y, eye.z)).dst - SceneInfo(new PVector(eye.x-EPSILON, eye.y, eye.z)).dst;
    float y = SceneInfo(new PVector(eye.x, eye.y+EPSILON, eye.z)).dst - SceneInfo(new PVector(eye.x, eye.y-EPSILON, eye.z)).dst;
    float z = SceneInfo(new PVector(eye.x, eye.y, eye.z+EPSILON)).dst - SceneInfo(new PVector(eye.x, eye.y, eye.z-EPSILON)).dst;
    return new PVector(x, y, z).normalize();
  }

  IterDst SceneInfo(PVector pos) {//get distance and color
    PVector z = pos.copy();
    float dr = 1.0;
    float r = 0;
    int iterations = 0;

    for (int i = 0; i < 15; i++) {
      iterations = i;
      r = z.mag();

      if (r > 2) {
        break;
      }

      //convert to polar coordinates
      float theta = acos(z.z/r);
      float phi = atan2(z.y, z.x);
      dr = pow(r, power-1)*power*dr + 1.0;//powered length(distance from origin)

      //scale and rotate the point
      float zr = pow(r, power);
      theta = theta*power;
      phi = phi*power;

      //convert back to certesian coordinated
      z = new PVector(sin(theta)*cos(phi), sin(theta)*sin(phi), cos(theta)).mult(zr);
      z = z.add(pos);
    }
    float dst = 0.5*log(r)*r/dr;
    return new IterDst(iterations, dst);
  }
}


class ColDst {//data container
  Color col;
  float dst;
  ColDst() {
  }

  ColDst(Color col, float dst) {
    this.col = col;
    this.dst = dst;
  }

  ColDst Clerp(ColDst a, ColDst b, float f) {
    return new ColDst(new Color(lerp(a.col.r, b.col.r, f), lerp(a.col.g, b.col.g, f), lerp(a.col.b, b.col.b, f)), lerp(a.dst, b.dst, f));
  }

  ColDst mult(ColDst c, float f) {
    return new ColDst(new Color(c.col.r*f, c.col.g*f, c.col.b*f), c.dst*f);
  }
}

class IterDst {//data container
  float iter, dst;
  IterDst(float iter, float dst) {
    this.iter = iter;
    this.dst = dst;
  }
}