
import processing.core.PImage;
import TUIO.TuioCursor;

public class PictureImg extends FileObject{


  
  PictureImg(float width, float height, float xPos, float yPos, String fileName) {
    super(width, height, xPos, yPos, fileName);
  }
  
  @Override
  public void touchOneFinger(Vector<TuioCursor> cursors) {
    for ( TuioCursor tuioCursor : cursors ) {
      if (0 == tuioCursor.getCursorID()) {
            // print my fingers X and Y
//            System.out.println(tuioCursor.getX()* SCREEN_SIZE_X);
//            System.out.println(tuioCursor.getY()* SCREEN_SIZE_Y);
            if(tuioCursor.getX()* SCREEN_SIZE_X <= getxRangeMax() && 
               tuioCursor.getX()* SCREEN_SIZE_X >= getxRangeMin() &&
               tuioCursor.getY()* SCREEN_SIZE_Y >= getyRangeMin() &&
               tuioCursor.getY()* SCREEN_SIZE_Y <= getyRangeMax() ) {
                 
                  System.out.println("got ya");
                  
                  setPositionX(tuioCursor.getX() * SCREEN_SIZE_X);
                  setPositionY(tuioCursor.getY() * SCREEN_SIZE_Y);
               } else {
                  System.out.println("there is no picture baby");
               }
          } 
    }
  }

  @Override
  public void touchTwoFingers(Vector<TuioCursor> cursors) {
    TuioCursor cursor1 = null;
    TuioCursor cursor2 = null;
    
    for (TuioCursor tuioCursor : cursors) {
        if (0 == tuioCursor.getCursorID()) {
          cursor1 = tuioCursor;
        }
        if (1 == tuioCursor.getCursorID()) {
          cursor2 = tuioCursor;
        }
      }
      // check
      // Change Image Size
      if (cursor1 != null && cursor2 != null) {
        setObjectWidth( Math.abs(cursor1.getX() - cursor2.getX()) * SCREEN_SIZE_X );
        setObjectHeight( Math.abs(cursor1.getY() - cursor2.getY()) * SCREEN_SIZE_Y );
      }
  }

  @Override
  public void touchThreeFingers(Vector<TuioCursor> cursors) {
     TuioCursor cursor1 = null;
    TuioCursor cursor2 = null;
    
    for (TuioCursor tuioCursor : cursors) {
        if (0 == tuioCursor.getCursorID()) {
          cursor1 = tuioCursor;
        }
        if (1 == tuioCursor.getCursorID()) {
          cursor2 = tuioCursor;
        }
      }
      // check
      // calculate two cursors's gradient and rotate Image
      if (cursor1 != null && cursor2 != null) {
        // (X1, Y1) , (X2, Y2)
        // (Y2 - Y1) / (X2 - X1) == gradient
        // atan(gradient) == angle ( radian )
        // angle( radian ) * 180 / Pi == angle ( degree )
        float gradient = (cursor1.getY() - cursor2.getY())
            / (cursor1.getX() - cursor2.getX());
        setObjectRotate( (float)(Math.atan(gradient) * 180.0 /  Math.PI) );
      }
  }
}

