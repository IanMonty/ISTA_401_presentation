public class Particle {
  
  float x;
  float y;
  float z;
  
  float gravity;
  float v_x;
  float v_y;
  float p;
  float t;
  boolean hit;
  
  Particle() {
    x = random(-75,75);
    y = 750;
    z = 700;
    
    gravity = -5;
    t = 0;
    v_x = random(-1,1);
    v_y = random(-5,0);
    hit = false;
  }
  
  void hit(){
    v_x = -v_x;
  }
  
  void bodyHit(){
    if(hit == false){
      hit = true;
      stroke(0,255,0);
      point(x,y,z);
    }
  }
  
  void update() {
    if(hit == false){
      t += .01;
      y += v_y*t + gravity * t * t;
      x += v_x;
      stroke(255*(-v_y/5),255*(-v_y/5),255);
      strokeWeight(10);
      point(x,y,z);
      hit = false;
    } else {
      stroke(0,255,0);
      point(x,y,z);
    }
      
    
     if(x <= -700) {
      v_x = -v_x;
    } else {
      if(x >= 700){
        v_x = -v_x;
      }
    }
  }
}
