import SimpleOpenNI.*;
boolean depth = false;
boolean colorDepth = false;
boolean rgb = false;
boolean ir = false;

SimpleOpenNI context;
float zoomF =0.3f;
float rotX = radians(180);  //by default the hole scene 180deg around 
                            //the x-axis, (SimplOpenNI library)
float rotY = radians(0);

void setup()
{
  size(1024,768,P3D);
  
  context = new SimpleOpenNI(this);  //initialize kinect as an object
  context.setMirror(false);  // not sure what that means
  
  if(context.enableDepth() == false)
  {
    println("depthMap not working, is Kinect connected properly?");
    exit();
    return;
  }
  
  if(context.enableRGB() == false)
  {
    println("rgbMap not working, is Kinect connected properly?");
    exit();
    return;
  }
  
  if(context.enableIR() == false)
  {
    println("irMap not working, is Kinect connected properly?");
    exit();
    return;
  }
  
  //align depth data to image data (SimpleOpenNI library)
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
  
  background(0);
  
  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);
  
  PImage rgbImage = context.rgbImage();
  int[] depthMap = context.depthMap();
  int steps = 3;
  int index;
  PVector realWorldPoint;
  color pixelColor;
  
  strokeWeight(steps);
  
  translate(0,0,-1000); //Shifts viewpoint to center of image
  PVector[] realWorldMap = context.depthMapRealWorld();
  
  if(depth == true){
    
    for(int y = 0 ; y < context.depthHeight(); y+=steps)
    {
      for(int x = 0; x < context.depthWidth(); x += steps)
      {
        index = x + y * context.depthWidth();
        if(depthMap[index] > 0)
        {
          stroke(255);
          
          realWorldPoint = realWorldMap[index];
          point(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z);
        }
      }
    }
  }
  
  else {
    if(colorDepth == true)
    {
      for(int y = 0 ; y < context.depthHeight(); y+=steps)
      {
        for(int x = 0; x < context.depthWidth(); x += steps)
        {
          index = x + y * context.depthWidth();
          if(depthMap[index] > 0)
          {
            pixelColor = rgbImage.pixels[index];
            stroke(pixelColor);
          
            realWorldPoint = realWorldMap[index];
            point(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z);
          }
        }
      }
    }
    
    else {
      if(rgb == true){
        image(context.rgbImage(),0,0);
      }
      else {
        if(ir == true){
          rotate(radians(180));
          image(context.irImage(),0,0);
        }
      }
    }
  }
  
}


void keyPressed()
{
  switch(key)
  {
    case 'd':
      depth = true;
      colorDepth = false;
      rgb = false;
      ir = false;
      break;
    case 'c':
      depth = false;
      colorDepth = true;
      rgb = false;
      ir = false;
      break;
    case 'r':
      depth = false;
      colorDepth = false;
      rgb = true;
      ir = false;
      break;
    case 'i':
      depth = false;
      colorDepth = false;
      rgb = false;
      ir = true;
      context.setMirror(true);
      break;
  }
}
