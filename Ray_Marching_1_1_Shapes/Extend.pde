class Color{
  float r, g, b;
  Color(float _r, float _g, float _b){
    r = _r;
    g = _g;
    b = _b;
  }
  
  color getColor(){
    return color(r, g, b);
  }
  
  Color add(Color c){
    return new Color(r+c.r, g+c.g, b+c.b);
  }
  
  Color sub(Color c){
    return new Color(r-c.r, g-c.g, b-c.b);
  }
  
  Color mult(Color c){
    return new Color(r*c.r, g*c.g, b*c.b);
  }
  
  Color div(Color c){
    return new Color(r/c.r, g/c.g, b/c.b);
  }
  
  Color mult(float x){
    return new Color(r*x, g*x, b*x);
  }
  
  Color div(float x){
    return new Color(r/x, g/x, b/x);
  }
}

PVector abs(PVector a){
  return new PVector(abs(a.x), abs(a.y), abs(a.z));
}

PVector max(PVector a, PVector b){
  return new PVector(max(a.x, b.x), max(a.y, b.y), max(a.z, b.z));
}