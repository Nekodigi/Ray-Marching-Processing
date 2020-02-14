class Camera{
  PVector eye;
  PVector focal;
  float view_dst;
  PVector up;
  int wid, hei;
  DistanceEstimator distanceEstimator;
  PVector u, v, w;
  
  Camera(PVector eye, PVector focal, float view_dst, PVector up, DistanceEstimator distanceEstimator){
    this.eye = eye;
    this.focal = focal;
    this.view_dst = view_dst;
    this.up = up;
    this.wid = width;
    this.hei = height;
    this.distanceEstimator = distanceEstimator;
    compute_uvw();
  }
  
  void render(){
    Ray ray = new Ray();
    ray.o = eye;
    for(float x = 0; x < wid; x+=pixelSize){
      for(float y = 0; y < hei; y+=pixelSize){
        ray.d = get_direction(x-wid/2, y-hei/2);
        fill(distanceEstimator.Estimate(ray.copy()).col.mult(255).getColor());//you must copy ray
        rect(x*1, hei-y*1-1, pixelSize, pixelSize);
      }
    }
  }
  
  PVector get_direction(float x, float y){
    return PVector.mult(u, x).add(PVector.mult(v, y)).sub(PVector.mult(w, view_dst)).normalize();
  }
  
  void compute_uvw(){
    w = PVector.sub(eye, focal).normalize();
    u = new PVector();PVector.cross(up, w, u);u.normalize();
    v = new PVector(); PVector.cross(w, u, v);v.normalize();
    //check for singularity. if condition met, camera orientation are hardcoded
    //camera Looking straight down
    if (eye.x == focal.x && eye.z == focal.z && focal.y < eye.y){
      u = new PVector(0, 0, 1);
      v = new PVector(1, 0, 0);
      w = new PVector(0, 1, 0);
    }
    if (eye.x == focal.x && eye.z == focal.z && focal.y > eye.y){
      u = new PVector(1, 0, 0);
      v = new PVector(0, 0, 1);
      w = new PVector(0, -1, 0);
    }
  }
}