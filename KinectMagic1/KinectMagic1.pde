import SimpleOpenNI.*;

SimpleOpenNI context;
float zoomF = 0.3f;
float ratX = radians(180);
float ratY = radians(0);

void setup()
{
  frameRate(30);
  
  size(1024,768,OPENGL);
  
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
  context.update();
  
  background(255,255,255);
  
  translate(width/2,height/2,0);
  rotateX(ratX);
  rotateY(ratY);
  scale(zoomF);
  
  PImage rgbImage = context.rgbImage();
  int[] depthMap = context.depthMap();
  int steps = 4;
  int index;
  PVector realWorldPoint;
  color pixelColor;
  
  translate(0,0,-500);
  
  //strokeWeight(steps);
  
  
 // sphereDetail(5,5);
 // sphere(20);
  
  PVector[] realWorldMap = context.depthMapRealWorld();
  for(int y=0;y < context.depthHeight(); y += steps)
  {
    for(int x = 0; x < context.depthWidth();x+=steps)
    {
      index = x + y * context.depthWidth();
      if (depthMap[index] > 0 && depthMap[index] < 1500)
      {
        pixelColor = rgbImage.pixels[index];
        stroke(pixelColor);
        //stroke(0);
        realWorldPoint = realWorldMap[index];
        strokeWeight(steps);
        point(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z);
        strokeWeight(steps+2);
        //point(realWorldPoint.x,realWorldPoint.y,-realWorldPoint.z+1900);
        //if (realWorldPoint.z == 600)
        //{
        //   translate(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z);
        //   sphere(20);
        //}
      }
    }
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
    ratY += 0.1f;
    break;
  case RIGHT:
    // zoom out
    ratY -= 0.1f;
    break;
  case UP:
    if(keyEvent.isShiftDown())
      zoomF += 0.02f;
    else
      ratX += 0.1f;
    break;
  case DOWN:
    if(keyEvent.isShiftDown())
    {
      zoomF -= 0.02f;
      if(zoomF < 0.01)
        zoomF = 0.01;
    }
    else
      ratX -= 0.1f;
    break;
  }
}

