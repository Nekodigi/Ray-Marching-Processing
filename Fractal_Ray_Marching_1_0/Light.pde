class Light{
  PVector data;//If point light, data is position. If directional light, data is direction
  boolean isPoint;
  
  Light(PVector data, boolean isPoint){
    this.data = data;
    this.isPoint = isPoint;
  }
}