public class BodyParticle extends Particle{
  float x;
  float y;
  float z;
  
  
  BodyParticle(float _x,float _y,float _z){
    x = _x;
    y = _y;
    z = _z;
  }
  
  void update(){
    stroke(255);
    strokeWeight(10);
    point(x,y,z);
  }
}
