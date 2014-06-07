import java.util.ArrayList;
import java.util.Vector;

import processing.core.PImage;
import TUIO.TuioCursor;

public class FolderImg extends FileObject {

  // TODO DELETE
  // Window Size
  final static int SCREEN_SIZE_X = 1280;
  final static int SCREEN_SIZE_Y = 800;

  final static float RADIUS = 200.0f;
  final static float CIRCLE_ANGLE = 360.0f; 
  
  private ArrayList<PictureImg> imgs;
  
  FolderImg(float width, float height, float xPos, float yPos, String fileName) {
    super(width, height, xPos, yPos, fileName);
    
    imgs = new ArrayList<PictureImg>();
  }


  
  public void addImg(PictureImg pictureImg) {
    imgs.add(pictureImg);
  }

  public ArrayList<PictureImg> getImgs() {
    return imgs;
  }

  @Override
  public void display() {
    super.display();
  }
  
  @Override
  public void touchOneFinger(Vector<TuioCursor> cursors) {
    
    float individualAngle = CIRCLE_ANGLE / imgs.size();
    
    for (int index = 1 ; index <= imgs.size() ; ++index ) {
      
      PictureImg targetImg = imgs.get(index-1);
      
      float newXPosition = (float) (RADIUS * Math.cos(Math.toRadians( index * individualAngle)));
      float newYPosition = (float) (RADIUS * Math.sin(Math.toRadians( index * individualAngle)));
      targetImg.setPositionX(getPositionX()+newXPosition);
      targetImg.setPositionY(getPositionY()+newYPosition);
    }
    
    for (PictureImg pictureImg: imgs) {
      pictureImg.display();
    }
  }

  @Override
  public void touchTwoFingers(Vector<TuioCursor> cursors) {
    // TODO Auto-generated method stub

  }

  @Override
  public void touchThreeFingers(Vector<TuioCursor> cursors) {
    // TODO Auto-generated method stub

  }
}

