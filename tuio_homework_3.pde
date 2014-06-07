import java.awt.Image;
import java.util.Vector;
// Processing & TUIO import
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
     
    //PictureImg(float pictureWidth, float pictureHeight, float xPos, float yPos, String fileName){
     
     FolderImg folderImg = new FolderImg(100.0f, 100.0f, 600.0F, 400.0F,"folder.jpeg");
     folderImg.addImg (new PictureImg(100.0f, 100.0f, 100.0F, 100.0F,"brown1.jpg"));
     folderImg.addImg (new PictureImg(100.0f, 100.0f, 100.0F, 100.0F,"brown2.jpg"));
     folderImg.addImg (new PictureImg(100.0f, 100.0f, 100.0F, 100.0F,"cony1.jpg"));
     folderImg.addImg (new PictureImg(100.0f, 100.0f, 100.0F, 100.0F,"cony2.jpg"));
     
    fileObjectList.add(folderImg); 
    
    size(SCREEN_SIZE_X, SCREEN_SIZE_Y);
  }

  // 2. draw
  public void draw() {
    // set Background color
    background(100);
    
    // drawing
    for(FileObject fileObject : fileObjectList){
        // call multi-touch values and update
        fileObject.updateImageData(client);
        fileObject.display();
    }
  }
