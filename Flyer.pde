public class Flyer {
  public int userID;
  public SimpleOpenNI kinect;
  public OPC opc;
  
  Flyer()
  {
  }
  
  private PVector screenPositionForJoint(int joint)
  {
    PVector jointPos3D = new PVector();
    kinect.getJointPositionSkeleton(userID, joint, jointPos3D);
    
    PVector jointPos = new PVector();
    kinect.convertRealWorldToProjective(jointPos3D, jointPos);
    return jointPos;    
  }
  
  private PVector wingPositionForJoint(int joint, boolean isLeft)
  {
    PVector jointPx = screenPositionForJoint(joint);
    PVector wingPos = new PVector();
    wingPos.x = (jointPx.x * strandWidth / 2 / imageWidth) + (isLeft ? strandWidth / 2.0 : 0.0);
    wingPos.y = (jointPx.y * strandHeight / imageHeight); 
    return wingPos;
  }
  
  public void update()
  {
    if (userID == -1) {
      return;      
    }
    
    PVector leftHandPx = wingPositionForJoint(SimpleOpenNI.SKEL_LEFT_HAND, true);
    PVector leftElbowPx = wingPositionForJoint(SimpleOpenNI.SKEL_LEFT_ELBOW, true);
    PVector rightHandPx = wingPositionForJoint(SimpleOpenNI.SKEL_RIGHT_HAND, false);
    PVector rightElbowPx = wingPositionForJoint(SimpleOpenNI.SKEL_RIGHT_ELBOW, false);
    
    colorMode(HSB, strandHeight, 100, 100);
    stroke(leftHandPx.y, 100, 100);
    drawLongLineThrough(leftHandPx, leftElbowPx);
    stroke(rightHandPx.y, 100, 100);
    drawLongLineThrough(rightHandPx, rightElbowPx);
  }
  
  private void drawLongLineThrough(PVector p1, PVector p2)
  {
    float slope = (p1.y - p2.y) / (p1.x - p2.x);
    int sign = (slope > 0 ? 1 : -1);
    
    p1.x -= sign * strandWidth;
    p1.y -= sign * strandWidth * slope;
    
    p2.x += sign * strandWidth;
    p2.y += sign * strandWidth * slope;
        
    line(p2.x, p2.y, p1.x, p1.y);
  }
}

// GESTURE_CLICK, GESTURE_HAND_RAISE, GESTURE_WAVE, IMG_MODE_DEFAULT, 
// IMG_MODE_RGB_FADE, NODE_DEPTH, NODE_GESTURE, NODE_HANDS, NODE_IMAGE, NODE_IR, NODE_NONE, 
// NODE_PLAYER, NODE_RECORDER, NODE_SCENE, NODE_USER, 
// RUN_MODE_DEFAULT, RUN_MODE_MULTI_THREADED, RUN_MODE_SINGLE_THREADED, 

// SKEL_HEAD, SKEL_LEFT_ELBOW, SKEL_LEFT_FINGERTIP, SKEL_LEFT_FOOT, SKEL_LEFT_HAND, SKEL_LEFT_HIP, 
// SKEL_LEFT_KNEE, SKEL_LEFT_SHOULDER, SKEL_NECK, SKEL_RIGHT_ELBOW, SKEL_RIGHT_FINGERTIP, SKEL_RIGHT_FOOT, 
// SKEL_RIGHT_HAND, SKEL_RIGHT_HIP, SKEL_RIGHT_KNEE, SKEL_RIGHT_SHOULDER, SKEL_TORSO
