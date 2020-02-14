class Color{
  float r, g, b;
  
  Color(){}
  Color(float _r, float _g, float _b){
    r = _r;
    g = _g;
    b = _b;
  }
  
  public int getColor(){
    return color(r, g, b);
  }
  
  public Color add(Color c){
    return new Color(r+c.r, g+c.g, b+c.b);
  }
  
  public Color sub(Color c){
    return new Color(r-c.r, g-c.g, b-c.b);
  }
  
  public Color mult(Color c){
    return new Color(r*c.r, g*c.g, b*c.b);
  }
  
  public Color div(Color c){
    return new Color(r/c.r, g/c.g, b/c.b);
  }
  
  public Color mult(float x){
    return new Color(r*x, g*x, b*x);
  }
  
  public Color div(float x){
    return new Color(r/x, g/x, b/x);
  }
  
  public Color Clerp(Color colA, Color colB, float f){
    return new Color(lerp(colA.r, colB.r, f), lerp(colA.g, colB.g, f), lerp(colA.b, colB.b, f));
  }
}

PVector abs(PVector a){
  return new PVector(abs(a.x), abs(a.y), abs(a.z));
}

PVector max(PVector a, PVector b){
  return new PVector(max(a.x, b.x), max(a.y, b.y), max(a.z, b.z));
}

public ColDst blend(float a, float b, Color colA, Color colB, float k){
  float h = constrain(0.5+0.5*(b-a)/k, 0, 1);
  float blendDst = lerp(b, a, h) - k*h*(1-h);
  Color blendCol = new Color();
  blendCol = blendCol.Clerp(colB, colA, h);
  return new ColDst(blendCol, blendDst);
}