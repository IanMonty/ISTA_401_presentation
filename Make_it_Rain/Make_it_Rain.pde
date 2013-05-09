import java.util.*;
import SimpleOpenNI.*;
int wide = 1024;
int tall = 768;
Particle[] particle = new Particle[0];  //moving particles array
BodyParticle[] bodyParticle = new BodyParticle[500]; //particles of body
int  takePicture;


//kinect setup see SimpleOpenNI examples
SimpleOpenNI context;
float zoomF = 0.3f;
float rotX = radians(180);
float rotY = radians(0);
boolean startup;

void setup()
{
  frameRate(60);
  startup = true;
  
  size(wide,tall,P3D);
  
  context = new SimpleOpenNI(this);
  context.setMirror(false);
  
  if(context.enableDepth() == false)
  {
    println("You fucked up");
    exit();
    return;
  }
  
  if(context.enableRGB() == false)
  { 
    println("camera not working");
    exit();
    return;
  }
  
  
  context.alternativeViewPointDepthToImage();
  
   stroke(255,255,255);
   smooth();
   perspective(radians(45),
               float(width)/float(height),
               10,150000);
}

void draw()
{
  background(0,0,0);
  
  translate(width/2,height/2,0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);
  
  PImage rgbImage = context.rgbImage();
  int[] depthMap = context.depthMap();
  int step = 4;
  int index;
  PVector realWorldPoint;
  color pixelColor;
  
  translate(0,0,-1000);
  if(startup == true) {  //moving particle start up
    for(int i = 0; i <= 100; i++){
      particle = (Particle[]) append(particle, new Particle());
    }
    startup = false;
  }
  

  for(int i = 0; i < particle.length; i++) {  
    if(particle[i].y < -700) {  //if particle leave screen, remove and create a new particle
      particle[i] = null;
      particle[i] = new Particle();
    }
  }
  
  for(int i=0; i < particle.length-1; i++) {  //if particles hit, reverse direction f x
    for(int j = i + 1; j <particle.length; j++){
      if(abs(abs(particle[i].x)-abs(particle[j].x)) < 5){
        if(abs(abs(particle[i].y)-abs(particle[j].y)) < 5){
          particle[i].hit();
          particle[j].hit();
        }
      }
    }
  }
  
  
  PVector[] realWorldMap = context.depthMapRealWorld();  //get data from kinect
  int k = 0;
  for(int y = 0; y < context.depthHeight(); y += step)
  {
    for(int x = 0; x < context.depthWidth(); x += step)
    {
      index = x + y * context.depthWidth();
      if (depthMap[index] > 0 && depthMap[index] < 2000)
      {
       pixelColor = rgbImage.pixels[index];
       realWorldPoint = realWorldMap[index];
       bodyParticle[k]= new BodyParticle(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z,pixelColor); //creates body particle
       bodyParticle[k].update();  //updates body particle
       k = k++;
       
      }
    }
  }
  
  for(int i = 0; i < particle.length; i++){  //collision detection with body
    for(int q = 0; k < bodyParticle.length; k++){
      if(bodyParticle[q] != null){
        if(abs(abs(particle[i].x) - abs(bodyParticle[q].x)) < 100){
          if(abs(abs(particle[i].y) - abs(bodyParticle[q].y)) < 100){
            particle[i].bodyHit();
          }
        }
      }
    }
   }
   
  //takePicture = int(random(0,100));
  //if(takePicture == 50){
    context.update();  //update kinect
  //}
  
  for(int i = 0; i<particle.length; i++) {  //update moving particles
    particle[i].update();
  }
  


}

void keyPressed()
{
  switch(key)
  {
  case ' ':
    context.setMirror(!context.mirror());
    break;
  }

  switch(keyCode)
  {
  case LEFT:
    rotY += 0.1f;
    break;
  case RIGHT:
    // zoom out
    rotY -= 0.1f;
    break;
  case UP:
    if(keyEvent.isShiftDown())
      zoomF += 0.02f;
    else
      rotX += 0.1f;
    break;
  case DOWN:
    if(keyEvent.isShiftDown())
    {
      zoomF -= 0.02f;
      if(zoomF < 0.01)
        zoomF = 0.01;
    }
    else
      rotX -= 0.1f;
    break;
  }
}

