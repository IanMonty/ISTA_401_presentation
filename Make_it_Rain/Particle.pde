public class Particle {
  
  float x;
  float y;
  float z;
  
  float gravity;
  float v_x;
  float v_y;
  float p;
  float t;
  
  Particle() {
    x = random(-700,700);
    y = 700;
    z = 700;
    
    gravity = -10;
    t = 1;
    v_x = random(-5,5);
    v_y = random(-5,0);
  }
  
  void hit(){
    v_x = -v_x;
  }
  
  void bodyHit(){
    v_x = -v_x;
    //v_y = ((v_y + gravity * t)*10);
    
  }
  
  void update() {
    t = t++;
    y += v_y*t + gravity * t * t;
    x += v_x;
    fill(0,255,0);
    stroke(0);
    strokeWeight(1);
    rect(x,y,26,61);
    rotateY(PI*t);
    
    if(x <= -600) {
      v_x = -v_x;
    } else {
      if(x >= 600){
        v_x = -v_x;
      }
    }
  }
}
