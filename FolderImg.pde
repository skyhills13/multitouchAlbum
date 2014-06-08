import java.util.ArrayList;
import java.util.HashMap;
import java.util.Vector;

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
  // last tap id (unix time)
  long lastTapTime = 0;

  // last session id
  long lastSessionId = 0;

  FolderImg(float width, float height, float xPos, float yPos, String fileName) {
    super(width, height, xPos, yPos, fileName);

    imgs = new ArrayList<PictureImg>();
  }

  @Override
  public boolean updateImageData(TuioClient client) {
    boolean resultFromParent = super.updateImageData(client);

    if (resultFromParent == false && lastTapTime > 0) {
      for (PictureImg pictureImg : imgs) {
        pictureImg.updateImageData(client);
      }
      // obsolete from child
      return true;
    }
    // obsolete from child
    return false;
  }

  public void addImg(PictureImg pictureImg) {
    imgs.add(pictureImg);

    float individualAngle = CIRCLE_ANGLE / imgs.size();

    for (int index = 1; index <= imgs.size(); ++index) {
      PictureImg targetImg = imgs.get(index - 1);

      float newXPosition = (float) (RADIUS * Math.cos(Math
          .toRadians(index * individualAngle)));
      float newYPosition = (float) (RADIUS * Math.sin(Math
          .toRadians(index * individualAngle)));
      targetImg.setPositionX(getPositionX() + newXPosition);
      targetImg.setPositionY(getPositionY() + newYPosition);
    }
  }

  public ArrayList<PictureImg> getImgs() {
    return imgs;
  }

  @Override
  public void display() {
    super.display();

    if (lastTapTime > 0) {
      for (PictureImg img : imgs) {
        img.display();
      }
    }
  }

  @Override
  public boolean touchOneFinger(Vector<TuioCursor> cursors) {
    TuioCursor cursor = cursors.get(0);

    if (cursor.getX() * SCREEN_SIZE_X <= getxRangeMax()
        && cursor.getX() * SCREEN_SIZE_X >= getxRangeMin()
        && cursor.getY() * SCREEN_SIZE_Y >= getyRangeMin()
        && cursor.getY() * SCREEN_SIZE_Y <= getyRangeMax()) {

      // drag
      if (lastSessionId == cursor.getSessionID()) {
        setPositionX(cursor.getX() * SCREEN_SIZE_X);
        setPositionY(cursor.getY() * SCREEN_SIZE_Y);
      } else {
        // folded image
        if (lastTapTime == 0) {
          lastTapTime = System.currentTimeMillis();

          // check double click
        } else {
          long intervalTapTime = System.currentTimeMillis()
              - lastTapTime;

          System.out.println("intervalTapTime : " + intervalTapTime);
          if ((500 > intervalTapTime) && (intervalTapTime > 5)) {
            lastTapTime = 0;
          } else {
            lastTapTime = System.currentTimeMillis();
          }
        }
        lastSessionId = cursor.getSessionID();
      }
      
      //inner area
      return true;
    } else {
      //extern area
      return false;
    }
  }

  @Override
  public boolean touchTwoFingers(Vector<TuioCursor> cursors) {
    TuioCursor cursor1 = null;
    TuioCursor cursor2 = null;

    cursor1 = cursors.get(0);
    cursor2 = cursors.get(1);

    if (cursor1 != null
        && cursor2 != null
        && (
        // cursor 1 in range
        (cursor1.getX() * SCREEN_SIZE_X <= getxRangeMax()
            && cursor1.getX() * SCREEN_SIZE_X >= getxRangeMin()
            && cursor1.getY() * SCREEN_SIZE_Y >= getyRangeMin() && cursor1
            .getY() * SCREEN_SIZE_Y <= getyRangeMax()) &&
        // and cursor 2 in range
        (cursor2.getX() * SCREEN_SIZE_X <= getxRangeMax()
            && cursor2.getX() * SCREEN_SIZE_X >= getxRangeMin()
            && cursor2.getY() * SCREEN_SIZE_Y >= getyRangeMin() && cursor2
            .getY() * SCREEN_SIZE_Y <= getyRangeMax()))) {

      float newPositionX = (cursor1.getX() + cursor2.getX()) / 2;
      float newPositionY = (cursor1.getY() + cursor2.getY()) / 2;
      float previousPositionX = getPositionX();
      float previousPositionY = getPositionY();

      setPositionX(newPositionX * SCREEN_SIZE_X);
      setPositionY(newPositionY * SCREEN_SIZE_Y);

      for (int index = 1; index <= imgs.size(); ++index) {
        PictureImg targetImg = imgs.get(index - 1);

        float newImgPositionX = (newPositionX * SCREEN_SIZE_X)
            - previousPositionX;
        float newImgPositionY = (newPositionY * SCREEN_SIZE_Y)
            - previousPositionY;
        targetImg.setPositionX(targetImg.getPositionX()
            + newImgPositionX);
        targetImg.setPositionY(targetImg.getPositionY()
            + newImgPositionY);
      }
      
      //inner area
      return true;
    } else {
      //extern area
      return false;
    }
  }

  @Override
  public boolean touchThreeFingers(Vector<TuioCursor> cursors) {return false;}

  HashMap<Integer, TuioCursor> firstSqueezeData = new HashMap<Integer, TuioCursor>();
  ArrayList<Float> imgDistanceFromFolder = new ArrayList<Float>();

  float longestDistance = 0;
  boolean isInnerDirection = false;

  @Override
  public boolean touchAboveFourFingers(Vector<TuioCursor> cursors) {
    // check sessionid if successive touch action

    // if initial touch event
    // reset data for squeeze
    long currentSessionId = cursors.get(0).getSessionID();
    if (currentSessionId != lastSessionId) {
      firstSqueezeData.clear();

      for (int i = 0; i < cursors.capacity(); i++) {
        TuioCursor tuioCursor = new TuioCursor(cursors.get(i));
        // firstSqueezeData.put(i, cursors.get(i));
        firstSqueezeData.put(i, tuioCursor);
      }

      for (PictureImg pictureImg : imgs) {
        float currentDistance = getDistance(pictureImg.getPositionX()
            * SCREEN_SIZE_X, pictureImg.getPositionY()
            * SCREEN_SIZE_Y);
        imgDistanceFromFolder.add(currentDistance);

        if (longestDistance < currentDistance) {
          longestDistance = currentDistance;
        }
      }
      lastSessionId = cursors.get(0).getSessionID();

      System.out.println("first in");
      // successive touch action
    } else {
      // All cursors Total move distance
      float totalMovedDistance = 0;

      // direction check
      TuioCursor currentFirstCursor = cursors.get(0);
      float currentFirstCursorDistance = getDistance(
          currentFirstCursor.getX() * SCREEN_SIZE_X,
          currentFirstCursor.getY() * SCREEN_SIZE_Y);

      TuioCursor squeezeFirstCursor = firstSqueezeData.get(0);
      float squeezeFirstCursorDistance = getDistance(
          squeezeFirstCursor.getX() * SCREEN_SIZE_X,
          squeezeFirstCursor.getY() * SCREEN_SIZE_Y);

      // inner direction
      System.out.println("squeezeFirstCursorDistance : "
          + squeezeFirstCursorDistance);
      System.out.println("currentFirstCursorDistance : "
          + currentFirstCursorDistance);
      if (squeezeFirstCursorDistance > currentFirstCursorDistance) {
        isInnerDirection = true;

        // check all cursor
        for (int i = 1; i < cursors.capacity(); i++) {
          TuioCursor currentCursor = cursors.get(i);
          float currentCursorDistance = getDistance(
              currentCursor.getX() * SCREEN_SIZE_X,
              currentCursor.getY() * SCREEN_SIZE_Y);

          TuioCursor squeezeCursor = cursors.get(i);
          float squeezeCursorDistance = getDistance(
              squeezeCursor.getX() * SCREEN_SIZE_X,
              squeezeCursor.getY() * SCREEN_SIZE_Y);

          // if outer direction cursor exists
          if (currentCursorDistance > squeezeCursorDistance) {
            System.out.println("245 line return execute");
            return false;
          } else {
            totalMovedDistance += currentCursorDistance;
          }
        }

        // outer direction
      } else {
        isInnerDirection = false;

        // check all cursor
        for (int i = 1; i < cursors.capacity(); i++) {
          TuioCursor currentCursor = cursors.get(i);
          float currentCursorDistance = getDistance(
              currentCursor.getX() * SCREEN_SIZE_X,
              currentCursor.getY() * SCREEN_SIZE_X);

          TuioCursor squeezeCursor = cursors.get(i);
          float squeezeCursorDistance = getDistance(
              squeezeCursor.getX() * SCREEN_SIZE_X,
              squeezeCursor.getY() * SCREEN_SIZE_X);

          // if inner direction cursor exists
          if (currentCursorDistance < squeezeCursorDistance) {
            return false; // 원복하는 함수 호출
          } else {
            totalMovedDistance += currentCursorDistance;
          }
        }
      }

      // All Touch Position is Valid, beneath code execute
      float averageMovedDistance = totalMovedDistance
          / cursors.capacity();
      System.out
          .println("averageMovedDistance : " + averageMovedDistance);

      // increase movement distance, because successive coordinate is
      // micro movement

      if (isInnerDirection) {
        averageMovedDistance *= 2000;
      } else {
        averageMovedDistance *= 150;
      }

      for (int i = 0; i < imgs.size(); i++) {
        PictureImg targetImg = imgs.get(i);

        // float proportion = 0;

        if (isInnerDirection) {
          System.out.println("innerDirection");

          // inner division
          float n = averageMovedDistance;
          float temp = imgDistanceFromFolder.get(i);
          float m = temp - n;

          float newPositionX = (n * getPositionX() + m
              * targetImg.getPositionX())
              / (m + n);
          float newPositionY = (n * getPositionY() + m
              * targetImg.getPositionY())
              / (m + n);

          System.out.println("newPositionX : " + newPositionX);
          System.out.println("newPositionY : " + newPositionY);
          System.out.println("=============================");
          targetImg.setPositionX(newPositionX);
          targetImg.setPositionY(newPositionY);

        } else {
          System.out.println("outerDirection");

          // outer division
          float n = averageMovedDistance;
          float temp = imgDistanceFromFolder.get(i);
          float m = temp + n;

          float newPositionX = (m * targetImg.getPositionX() - n
              * getPositionX())
              / (m - n);
          float newPositionY = (m * targetImg.getPositionY() - n
              * getPositionY())
              / (m - n);

          System.out.println("newPositionX : " + newPositionX);
          System.out.println("newPositionY : " + newPositionY);
          System.out.println("=============================");
          targetImg.setPositionX(newPositionX);
          targetImg.setPositionY(newPositionY);
        }
      }
    }
    return true;
  }

  //
  public float getDistance(float positionX, float positionY) {
    return (float) Math.sqrt(Math.pow((getPositionX() - positionX), 2)
        + Math.pow((getPositionY() - positionY), 2));
  }
}
