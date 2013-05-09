public class BodyParticle extends Particle{
  float x;
  float y;
  float z;
  color c;
  
  
  BodyParticle(float _x,float _y,float _z, color _c){
    x = _x;
    y = _y;
    z = _z;
    c = _c;
  }
  
  void update(){
    stroke(c);
    strokeWeight(4);
    point(x,y,z);
  }
}
