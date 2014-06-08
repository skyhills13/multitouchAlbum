import java.util.Vector;

import processing.core.PApplet;
import processing.core.PImage;
// Processing & TUIO import
import TUIO.TuioClient;
import TUIO.TuioCursor;


public abstract class FileObject implements Touchable {

  PImage picture;

  float positionX;
  float positionY;
  float objectWidth = 100.0f;
  float objectHeight = 100.0f;

  // set approximate range of image
  float xRangeMin;
  float xRangeMax;
  float yRangeMin;
  float yRangeMax;
  float objectRotate;

  // constructor
  FileObject(float width, float height, float xPos, float yPos,
      String fileName) {
    this.objectWidth = width;
    this.objectHeight = height;

    positionX = xPos;
    positionY = yPos;

    xRangeMin = positionX - width / 2;
    xRangeMax = positionX + width / 2;
    yRangeMin = positionY - height / 2;
    yRangeMax = positionY + height;

    picture = loadImage(fileName);
  }

  public void display() {
    pushMatrix();
    // Positioning Image
    translate(this.getPositionX(), this.getPositionY());
    // Rotate Image
    rotate(radians(getObjectRotate()));

    translate(-this.getObjectWidth() / 2.0f, -this.getObjectHeight() / 2.0f);
    // draw Image
    image(this.getPicture(), 0, 0, this.getObjectWidth(), this.getObjectHeight());
    popMatrix();
  }

  public boolean updateImageData(TuioClient client) {

    Vector<TuioCursor> cursors = client.getTuioCursors();
    int aliveCursor = cursors.size();

    switch (aliveCursor) {
      case 7:
      case 6:
      case 5:
      case 4:
        return touchAboveFour(cursors);
      case 3:
        return touchThree(cursors);
      case 2:
        return touchTwo(cursors);
      case 1:
        return touchOne(cursors);
      default:
        break;
    }
    
    return false;
  }

  @Override
  public boolean touchOne(Vector<TuioCursor> cursors) {
    return touchOneFinger(cursors);
  }

  @Override
  public boolean touchTwo(Vector<TuioCursor> cursors) {
    return touchTwoFingers(cursors);
  }

  @Override
  public boolean touchThree(Vector<TuioCursor> cursors) {
    return touchThreeFingers(cursors);
  }

  @Override
  public boolean touchAboveFour(Vector<TuioCursor> cursors) {
    return touchAboveFourFingers(cursors);
  }
  
  public abstract boolean touchOneFinger(Vector<TuioCursor> cursors);

  public abstract boolean touchTwoFingers(Vector<TuioCursor> cursors);

  public abstract boolean touchThreeFingers(Vector<TuioCursor> cursors);
  
  public abstract boolean touchAboveFourFingers(Vector<TuioCursor> cursors);

  // ************************************************************

  public PImage getPicture() {
    return picture;
  }

  public void setPicture(PImage picture) {
    this.picture = picture;
  }

  public float getPositionX() {
    return positionX;
  }

  public void setPositionX(float positionX) {
    this.positionX = positionX;

    xRangeMin = positionX - objectWidth / 2;
    xRangeMax = positionX + objectWidth / 2;
  }

  public float getPositionY() {
    return positionY;
  }

  public void setPositionY(float positionY) {
    this.positionY = positionY;

    yRangeMin = positionY - objectHeight / 2;
    yRangeMax = positionY + objectHeight;
  }

  public float getObjectWidth() {
    return objectWidth;
  }

  public void setObjectWidth(float objectWidth) {
    this.objectWidth = objectWidth;

    xRangeMin = positionX - objectWidth / 2;
    xRangeMax = positionX + objectWidth;
  }

  public float getObjectHeight() {
    return objectHeight;
  }

  public void setObjectHeight(float objectHeight) {
    this.objectHeight = objectHeight;

    yRangeMin = positionY - objectHeight / 2;
    yRangeMax = positionY + objectHeight;
  }

  public float getxRangeMin() {
    return xRangeMin;
  }

  public void setxRangeMin(float xRangeMin) {
    this.xRangeMin = xRangeMin;
  }

  public float getxRangeMax() {
    return xRangeMax;
  }

  public void setxRangeMax(float xRangeMax) {
    this.xRangeMax = xRangeMax;
  }

  public float getyRangeMin() {
    return yRangeMin;
  }

  public void setyRangeMin(float yRangeMin) {
    this.yRangeMin = yRangeMin;
  }

  public float getyRangeMax() {
    return yRangeMax;
  }

  public void setyRangeMax(float yRangeMax) {
    this.yRangeMax = yRangeMax;
  }

  public float getObjectRotate() {
    return objectRotate;
  }

  public void setObjectRotate(float objectRotate) {
    this.objectRotate = objectRotate;
  }
}

