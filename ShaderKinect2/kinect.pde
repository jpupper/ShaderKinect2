void initkinect() {
  kinect = new KinectPV2(this);
  //Enables depth and Body tracking (mask image)
  kinect.enableDepthMaskImg(true);
  kinect.enableSkeletonDepthMap(true);
  kinect.enableBodyTrackImg(true);

  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);
  kinect.init();

  manoder1 = new PVector(0, 0, 0);
  manoizq1 = new PVector(0, 0, 0);

  manoder2 = new PVector(0, 0, 0);
  manoizq2 = new PVector(0, 0, 0);
}
void setkinectpoints() {
  int PERSONAS  = 1 ;
  float zmin = 800;
  float zmax = 1600;
  float amt = 0.5;
  
  puntosx[0] = lerp(puntosx[0], manoder1.x, amt) ;
  puntosx[1] = lerp(puntosx[1], manoizq1.x, amt) ;

  puntosx[2] = lerp(puntosx[2], manoder2.x, amt) ;
  puntosx[3] = lerp(puntosx[3], manoizq2.x, amt) ;

  puntosy[0] = lerp(puntosy[0], manoder1.y, amt) ;
  puntosy[1] = lerp(puntosy[1], manoizq1.y, amt) ;

  puntosy[2] = lerp(puntosy[2], manoder2.y, amt) ;
  puntosy[3] = lerp(puntosy[3], manoder2.y, amt) ;

  //Esto es para que se maneje desde un solo lugar , digamos desde donde se esta parado noma, le tiro ahí un constrain y to the verg
  //aca probablemente haya que ajustar dependiendo del lugar digamo.
  puntosz[0] =  lerp(puntosz[0], zmap(manoder1.z, zmin, zmax), amt);
  puntosz[1] =  lerp(puntosz[1], zmap(manoizq1.z, zmin, zmax), amt);
  puntosz[2] =  lerp(puntosz[2], zmap(manoder2.z, zmin, zmax), amt);
  puntosz[3] =  lerp(puntosz[3], zmap(manoizq2.z, zmin, zmax), amt);


  if (PERSONAS == 2) {
    if ( kinect.getSkeletonDepthMap().size() == 0) {
      puntosz[0] = 0;
      puntosz[1] = 0;
      puntosz[2] = 0;
      puntosz[3] =0;
    }
    if ( kinect.getSkeletonDepthMap().size() == 1) {
      puntosz[2] = 0;
      puntosz[3]  =0;
    }
  }
  if (PERSONAS == 1) {
    puntosx[2] = 0 ;
    puntosx[3] = 0;

    puntosy[2] = 0;
    puntosy[3] = 0;

    puntosz[2] =  0;
    puntosz[3] =  0;
  }
  
  for (int i = 4; i<cant; i++){
       puntosx[i] = 0.;
       puntosy[i] = 0.;
       puntosz[i] = 0.;
  }
  
  
  
}

float zmap(float _input, float _min, float _max) {

  float result = _input;
  result = constrain(_input, _min, _max);
  result = norm(result, _min, _max);
  //result = norm(result,_max,_min);
  return 1.- result;
}



void dibujaresqueleto() {
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();

      color col  = skeleton.getIndexColor();
      fill(col);
      stroke(col);
      drawBody(joints);
      drawHandState(joints[KinectPV2.JointType_HandRight]);
      drawHandState(joints[KinectPV2.JointType_HandLeft]);
    }
  }
}

//draw hand state
void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
  ellipse(0, 0, 70, 70);
  popMatrix();
}

//Depending on the hand state change the color
int handState(int handState) {

  int var = 0;
  switch(handState) {
  case KinectPV2.HandState_Open:
    //fill(0, 255, 0);
    var = 0;
    break;
  case KinectPV2.HandState_Closed:
    fill(255, 0, 0);
    var = 1;
    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);
    var = 2;
    break;
  case KinectPV2.HandState_NotTracked:
    fill(100, 100, 100);
    var = 3;
    break;
  }
  return var;
}

int[] depth ;
int cantskel;
void updatemanos() {

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

  // ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();

  depth = kinect.getRawDepthData();
  cantskel = kinect.getSkeletonDepthMap().size();
  for (int i = 0; i < kinect.getSkeletonDepthMap().size(); i++) {

    KSkeleton skeleton = (KSkeleton)kinect.getSkeletonDepthMap().get(i);

    if (skeleton.isTracked()) {
      if (kinect.getSkeletonDepthMap().size() > 1 ) {
        KJoint[] joints = skeleton.getJoints();
        manoizq1.x = joints[KinectPV2.JointType_HandLeft].getX(); 
        manoizq1.y = joints[KinectPV2.JointType_HandLeft].getY();
        manoizq1.z = getdepthvalue(manoizq1.x, manoizq1.y);

        //MAPEAR LAS MANOS
        manoizq1.x  = map(manoizq1.x, 0, kinect.WIDTHDepth, 0, width);
        manoizq1.y  = map(manoizq1.y, 0, kinect.HEIGHTDepth, 0, height);


        manoder1.x = joints[KinectPV2.JointType_HandRight].getX(); 
        manoder1.y = joints[KinectPV2.JointType_HandRight].getY();
        manoder1.z = getdepthvalue(manoder1.x, manoder1.y);

        manoder1.x = map(manoder1.x, 0, kinect.WIDTHDepth, 0, width);
        manoder1.y = map(manoder1.y, 0, kinect.HEIGHTDepth, 0, height);

        if (i < 1) {

          manoizq2.x = joints[KinectPV2.JointType_HandLeft].getX(); 
          manoizq2.y = joints[KinectPV2.JointType_HandLeft].getY();
          manoizq2.z = getdepthvalue(manoizq2.x, manoizq2.y);

          //MAPEAR LAS MANOS
          manoizq2.x  = map(manoizq2.x, 0, kinect.WIDTHDepth, 0, width);
          manoizq2.y  = map(manoizq2.y, 0, kinect.HEIGHTDepth, 0, height);

          manoder2.x = joints[KinectPV2.JointType_HandRight].getX(); 
          manoder2.y = joints[KinectPV2.JointType_HandRight].getY();
          manoder2.z = getdepthvalue(manoder2.x, manoder2.y);

          manoder2.x = map(manoder2.x, 0, kinect.WIDTHDepth, 0, width);
          manoder2.y = map(manoder2.y, 0, kinect.HEIGHTDepth, 0, height);
        }
      } else {
        KJoint[] joints = skeleton.getJoints();
        manoizq1.x = joints[KinectPV2.JointType_HandLeft].getX(); 
        manoizq1.y = joints[KinectPV2.JointType_HandLeft].getY();
        manoizq1.z = getdepthvalue(manoizq1.x, manoizq1.y);

        //MAPEAR LAS MANOS
        manoizq1.x  = map(manoizq1.x, 0, kinect.WIDTHDepth, 0, width);
        manoizq1.y  = map(manoizq1.y, 0, kinect.HEIGHTDepth, 0, height);


        manoder1.x = joints[KinectPV2.JointType_HandRight].getX(); 
        manoder1.y = joints[KinectPV2.JointType_HandRight].getY();
        manoder1.z = getdepthvalue(manoder1.x, manoder1.y);

        manoder1.x = map(manoder1.x, 0, kinect.WIDTHDepth, 0, width);
        manoder1.y = map(manoder1.y, 0, kinect.HEIGHTDepth, 0, height);

        manoizq2.set(0, 0, 0);
        manoder2.set(0, 0, 0);
      }
    }
  }
}

float getdepthvalue(float  x, float  y) {
  float result = 0;
  int zindex = int(x) + int(y) * kinect.WIDTHDepth;
  if (zindex < 217098 && zindex > -1148) {
    result =  depth[zindex];
  }
  return result;
}

PVector getmano(int _nummano) {

  float manox = -width;
  float manoy = -height;
  float manoz = 0;
  int[] depth = kinect.getRawDepthData();
  for (int i = 0; i <  kinect.getSkeletonDepthMap().size(); i++) {
    KSkeleton skeleton = (KSkeleton)kinect.getSkeletonDepthMap().get(i);
    if (skeleton.isTracked()) {

      KJoint[] joints = skeleton.getJoints();
      KJoint manoderecha = joints[KinectPV2.JointType_HandRight];
      KJoint manoizquierda = joints[KinectPV2.JointType_HandLeft];

      int zindex =0;
      if (_nummano == 0) {
        zindex = int(manoderecha.getX()) + int(manoderecha.getY()) * kinect.WIDTHDepth;
      } else {
        zindex = int(manoizquierda.getX()) + int(manoizquierda.getY()) * kinect.WIDTHDepth;
      }

      int manoizquierdaZ = 0;
      int manoderechaZ = 0;
      if (zindex < 219140 && zindex > -10235) {
        manoizquierdaZ = depth[zindex];
        manoderechaZ = depth[zindex];
      }

      float mapmanoizq = map(manoizquierdaZ, 0, 1500, 600, 0); //MAPEA LA POSICION Z ANIMAL
      float mapmanoder = map(manoderechaZ, 0, 1500, 600, 0);//MAPEA LA POSICION Z ANIMAL

      if (_nummano == 0) {
        manox = map(manoderecha.getX(), 0, 512, 0, width);
        manoy = map(manoderecha.getY(), 0, 424, 0, height);
        manoz = mapmanoder;
      } else {
        manox = map(manoizquierda.getX(), 0, 512, 0, width);
        manoy = map(manoizquierda.getY(), 0, 424, 0, height);
        manoz = mapmanoizq;
      }
    }
  }

  PVector pos = new PVector(manox, manoy, manoz);
  return pos;
}


//DRAW BODY
void drawBody(KJoint[] joints) {
  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  // Right Arm
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

  drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  drawJoint(joints, KinectPV2.JointType_HandTipRight);
  drawJoint(joints, KinectPV2.JointType_FootLeft);
  drawJoint(joints, KinectPV2.JointType_FootRight);

  drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  drawJoint(joints, KinectPV2.JointType_ThumbRight);

  drawJoint(joints, KinectPV2.JointType_Head);
}

//draw joint
void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
}

//draw bone
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
}




/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */