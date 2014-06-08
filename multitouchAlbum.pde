import java.awt.Image;
import java.util.Vector;

import processing.core.*;
import TUIO.*;


TuioClient client = null;

// Window Size
final static int SCREEN_SIZE_X = 1280;
final static int SCREEN_SIZE_Y = 800;

ArrayList<FileObject> fileObjectList = new ArrayList<FileObject>();

// 1. Setup
public void setup() {
  // 1. Create TuioClient
  client = new TuioClient();
  client.connect(); 

  //call frame rate per seconds?? 
  frameRate(10);
  //PictureImg(float pictureWidth, float pictureHeight, float xPos, float yPos, String fileName){

  FolderImg conyFolder = new FolderImg(100.0f, 100.0f, 300.0F, 300.0F, "folder.jpeg");
  conyFolder.addImg (new PictureImg(100.0f, 100.0f, 100.0F, 100.0F, "brown1.jpg"));
  conyFolder.addImg (new PictureImg(100.0f, 100.0f, 100.0F, 100.0F, "brown2.jpg"));

  FolderImg brownFolder = new FolderImg(100.0f, 100.0f, 800.0F, 600.0F, "folder.jpeg");
  brownFolder.addImg (new PictureImg(100.0f, 100.0f, 100.0F, 100.0F, "cony1.jpg"));
  brownFolder.addImg (new PictureImg(100.0f, 100.0f, 100.0F, 100.0F, "cony2.jpg"));

  FolderImg allFolder = new FolderImg(100.0f, 100.0f, 500.0F, 500.0F, "folder.jpeg");
  allFolder.addImg (new PictureImg(100.0f, 100.0f, 100.0F, 100.0F, "brown1.jpg"));
  allFolder.addImg (new PictureImg(100.0f, 100.0f, 100.0F, 100.0F, "brown2.jpg"));
  allFolder.addImg (new PictureImg(100.0f, 100.0f, 100.0F, 100.0F, "cony1.jpg"));
  allFolder.addImg (new PictureImg(100.0f, 100.0f, 100.0F, 100.0F, "cony2.jpg"));

  fileObjectList.add(allFolder);
  fileObjectList.add(brownFolder);
  fileObjectList.add(conyFolder); 

  size(SCREEN_SIZE_X, SCREEN_SIZE_Y);
}

// 2. draw
public void draw() {
  // set Background color
  background(100);

  // drawing
  for (FileObject fileObject : fileObjectList) {
    // call multi-touch values and update
    //return execute boolean result 
    fileObject.updateImageData(client);
    fileObject.display();
  }
}

