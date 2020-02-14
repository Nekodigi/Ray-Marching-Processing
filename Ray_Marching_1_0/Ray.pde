class Ray{
  PVector o,d;
  
  Ray(){}
  Ray(PVector o, PVector d){
    this.o = o;
    this.d = d;
  }
  
  Ray copy(){
    return new Ray(o.copy(), d.copy());
  }
}