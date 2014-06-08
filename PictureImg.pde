import java.util.Vector;

import TUIO.TuioCursor;

public class PictureImg extends FileObject {
  // TODO DELETE
  // Window Size
  final static int SCREEN_SIZE_X = 1280;
  final static int SCREEN_SIZE_Y = 800;

  PictureImg(float width, float height, float xPos, float yPos,
      String fileName) {
    super(width, height, xPos, yPos, fileName);
  }

  @Override
  public boolean touchOneFinger(Vector<TuioCursor> cursors) {
    for (TuioCursor tuioCursor : cursors) {
      if (0 == tuioCursor.getCursorID()) {
        // print my fingers X and Y
        // System.out.println(tuioCursor.getX()* SCREEN_SIZE_X);
        // System.out.println(tuioCursor.getY()* SCREEN_SIZE_Y);
        if (tuioCursor.getX() * SCREEN_SIZE_X <= getxRangeMax()
            && tuioCursor.getX() * SCREEN_SIZE_X >= getxRangeMin()
            && tuioCursor.getY() * SCREEN_SIZE_Y >= getyRangeMin()
            && tuioCursor.getY() * SCREEN_SIZE_Y <= getyRangeMax()) {

          //System.out.println("got ya");

          setPositionX(tuioCursor.getX() * SCREEN_SIZE_X);
          setPositionY(tuioCursor.getY() * SCREEN_SIZE_Y);
          
          //inner area
          return true;
        } else {
          //outer area
          return false;
          //System.out.println("there is no picture baby");
        }
      }
    }
  return false;
  }

  @Override
  public boolean touchTwoFingers(Vector<TuioCursor> cursors) {
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
        ||
        //or cursor 2 in range
        (cursor2.getX() * SCREEN_SIZE_X <= getxRangeMax()
        && cursor2.getX() * SCREEN_SIZE_X >= getxRangeMin()
        && cursor2.getY() * SCREEN_SIZE_Y >= getyRangeMin()
        && cursor2.getY() * SCREEN_SIZE_Y <= getyRangeMax())
      )
    ) {      
    // satisfy above all condition
    
    // Change Image Size
      setObjectWidth(Math.abs(cursor1.getX() - cursor2.getX())
          * SCREEN_SIZE_X);
      setObjectHeight(Math.abs(cursor1.getY() - cursor2.getY())
          * SCREEN_SIZE_Y);
      
      //inner area
      return true;
    } else {
      //outer area
      return false;
    }
  }

  @Override
  public boolean touchThreeFingers(Vector<TuioCursor> cursors) {
    
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
        ||
        //or cursor 2 in range
        (cursor2.getX() * SCREEN_SIZE_X <= getxRangeMax()
        && cursor2.getX() * SCREEN_SIZE_X >= getxRangeMin()
        && cursor2.getY() * SCREEN_SIZE_Y >= getyRangeMin()
        && cursor2.getY() * SCREEN_SIZE_Y <= getyRangeMax())
      )
    ) {    
      // check
      // calculate two cursors's gradient and rotate Image
      // (X1, Y1) , (X2, Y2)
      // (Y2 - Y1) / (X2 - X1) == gradient
      // atan(gradient) == angle ( radian )
      // angle( radian ) * 180 / Pi == angle ( degree )
      float gradient = (cursor1.getY() - cursor2.getY()) / (cursor1.getX() - cursor2.getX());
      setObjectRotate((float) (Math.atan(gradient) * 180.0 / Math.PI));
      
      //inner area
      return true;
    } else {
      //outer area
      return false;
    }
  }

  @Override
  public boolean touchAboveFourFingers(Vector<TuioCursor> cursors) {return false;}
}
