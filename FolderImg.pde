import java.util.ArrayList;
import java.util.Vector;

import com.jogamp.common.util.RunnableExecutor.CurrentThreadExecutor;

import processing.core.PImage;
import TUIO.TuioClient;
import TUIO.TuioCursor;

public class FolderImg extends FileObject {

  // TODO DELETE
  // Window Size
  final static int SCREEN_SIZE_X = 1280;
  final static int SCREEN_SIZE_Y = 800;

  final static float RADIUS = 200.0f;
  final static float CIRCLE_ANGLE = 360.0f; 
  
  private ArrayList<PictureImg> imgs;
  //last tap id (unix time)
  long lastTapTime = 0;
  
  //last session id
  long lastSessionId = 0;
  
  FolderImg(float width, float height, float xPos, float yPos, String fileName) {
    super(width, height, xPos, yPos, fileName);
    
    imgs = new ArrayList<PictureImg>();
  }

  @Override
  public void updateImageData(TuioClient client) {
    super.updateImageData(client);
    
    if (lastTapTime > 0) {
      for (PictureImg pictureImg : imgs) {
        pictureImg.updateImageData(client);
      }
    }
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
    
    if ( lastTapTime > 0 ) {
      for (PictureImg img : imgs ) {
        img.display();
      } 
    }
  }
  
  @Override
  public void touchOneFinger(Vector<TuioCursor> cursors) {
   TuioCursor cursor = cursors.get(0);
   
   if (cursor.getX() * SCREEN_SIZE_X <= getxRangeMax()
      && cursor.getX() * SCREEN_SIZE_X >= getxRangeMin()
      && cursor.getY() * SCREEN_SIZE_Y >= getyRangeMin()
      && cursor.getY() * SCREEN_SIZE_Y <= getyRangeMax()) {
     
    //drag
    if ( lastSessionId == cursor.getSessionID() ) {
      setPositionX(cursor.getX() * SCREEN_SIZE_X);
      setPositionY(cursor.getY() * SCREEN_SIZE_Y);
    } else {
      //folded image
      if ( lastTapTime == 0 ) {
        float individualAngle = CIRCLE_ANGLE / imgs.size();
        
        for (int index = 1; index <= imgs.size(); ++index) {
          PictureImg targetImg = imgs.get(index - 1);
          
          float newXPosition = (float) (RADIUS * Math.cos(Math.toRadians(index * individualAngle)));
          float newYPosition = (float) (RADIUS * Math.sin(Math.toRadians(index * individualAngle)));
          targetImg.setPositionX(getPositionX() + newXPosition);
          targetImg.setPositionY(getPositionY() + newYPosition);
        }
        lastTapTime = System.currentTimeMillis();
        
      //check double click
      } else {
        long intervalTapTime = System.currentTimeMillis() - lastTapTime;
       
        System.out.println("intervalTapTime : "+intervalTapTime);
        if ( (1000 > intervalTapTime) && (intervalTapTime > 5) ) {
          lastTapTime = 0;
        } else {
          lastTapTime = System.currentTimeMillis();
        }
      }
      lastSessionId = cursor.getSessionID();
    }
    
//    setPositionX(cursor.getX() * SCREEN_SIZE_X);
//    setPositionY(cursor.getY() * SCREEN_SIZE_Y);
//    
//    System.out.println("sessionId : "+cursor.getSessionID());
//    
//    if ( lastTapTime == 0 ) {
//      float individualAngle = CIRCLE_ANGLE / imgs.size();
//      
//      for (int index = 1; index <= imgs.size(); ++index) {
//        PictureImg targetImg = imgs.get(index - 1);
//        
//        float newXPosition = (float) (RADIUS * Math.cos(Math.toRadians(index * individualAngle)));
//        float newYPosition = (float) (RADIUS * Math.sin(Math.toRadians(index * individualAngle)));
//        targetImg.setPositionX(getPositionX() + newXPosition);
//        targetImg.setPositionY(getPositionY() + newYPosition);
//      }
//      lastTapTime = System.currentTimeMillis();
//      
//    } else {
//      long intervalTapTime = System.currentTimeMillis() - lastTapTime;
//      System.out.println("intervalTapTime : "+intervalTapTime);
//      if ( (500 > intervalTapTime) && (intervalTapTime > 5) ) {
//        lastTapTime = 0;
//      }
//    }
    
     }
  }

  @Override
  public void touchTwoFingers(Vector<TuioCursor> cursors) {
    TuioCursor cursor1 = null;
    TuioCursor cursor2 = null;
    
    cursor1 = cursors.get(0);
    cursor2 = cursors.get(1);
    
    if (cursor1 != null && cursor2 != null 
      && ( 
        //cursor 1 in range
        (cursor1.getX() * SCREEN_SIZE_X <= getxRangeMax()
        && cursor1.getX() * SCREEN_SIZE_X >= getxRangeMin()
        && cursor1.getY() * SCREEN_SIZE_Y >= getyRangeMin()
        && cursor1.getY() * SCREEN_SIZE_Y <= getyRangeMax()) 
      &&
        //and cursor 2 in range
        (cursor2.getX() * SCREEN_SIZE_X <= getxRangeMax()
        && cursor2.getX() * SCREEN_SIZE_X >= getxRangeMin()
        && cursor2.getY() * SCREEN_SIZE_Y >= getyRangeMin()
        && cursor2.getY() * SCREEN_SIZE_Y <= getyRangeMax())
      )
    ) {      
      
      float newPositionX = (cursor1.getX() + cursor2.getX()) / 2;
      float newPositionY = (cursor1.getY() + cursor2.getY()) / 2; 
      float previousPositionX = getPositionX();
      float previousPositionY = getPositionY();
      
      setPositionX( newPositionX * SCREEN_SIZE_X);
      setPositionY( newPositionY * SCREEN_SIZE_Y);
      
      for (int index = 1; index <= imgs.size(); ++index) {
        PictureImg targetImg = imgs.get(index - 1);
        
        float newImgPositionX = (newPositionX* SCREEN_SIZE_X) - previousPositionX;
        float newImgPositionY = (newPositionY* SCREEN_SIZE_Y) - previousPositionY;
        targetImg.setPositionX( targetImg.getPositionX() + newImgPositionX);
        targetImg.setPositionY( targetImg.getPositionY() + newImgPositionY);
      }
      }
  }

  @Override
  public void touchThreeFingers(Vector<TuioCursor> cursors) {
    // TODO Auto-generated method stub

  }
}

