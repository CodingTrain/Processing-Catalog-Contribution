
// Source image
PImage p5Image;
// Resize it
PImage smaller;
// Giant array of images
ArrayList<ImageTile> allImages = new ArrayList<ImageTile>();
ArrayList<ImageTile> backup = new ArrayList<ImageTile>();
// Size of each "cell"
int sclw = 80;
int sclh = 45;
int w, h;

int factor = 10;

class Pix {
  int x, y, index;

  Pix(int x, int y) {
    this.x = x;
    this.y = y;
    this.index = x + y * w;
  }
}

ArrayList<Pix> allpix = new ArrayList<Pix>();



void loadImages() {
  // Find all the images
  File[] files = listFiles(sketchPath("data/thumbs"));
  printArray(files);
  // Use a smaller amount just for testing
  // allImages = new PImage[100];
  // Need brightness average for each image
  // brightness = new float[allImages.length];  // Deal with all the images
  for (int i = 0; i < files.length; i++) {
    String filename = files[i].toString();
    if (filename.indexOf(".jpg") > -1) {
      // Load the image
      PImage img = loadImage(filename);
      img.loadPixels();
      if (img.pixels.length > 1) {
        ImageTile tile = new ImageTile(img);
        allImages.add(tile);
      }
    } else {
      println("not a valid image");
    }
  }
}

void settings() {
  size(225*factor, 300*factor);
}

void setup() {
  p5Image = loadImage("p5-train-final.png");

  loadImages();

  // how many cols and rows
  w = width/sclw;
  h = height/sclh;


  smaller = createImage(w, h, RGB);
  smaller.copy(p5Image, 0, 0, p5Image.width, p5Image.height, 0, 0, w, h);

  for (int x =0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      allpix.add(new Pix(x, y));
    }
  }
  background(255);
}


void draw() {
  smaller.loadPixels();
  // Columns and rows
  //while (allpix.size() > 0) {
  for (int k = 0; k < 10; k++) {
    int r = int(random(allpix.size()));
    Pix pix = allpix.remove(r);


    // Draw an image with equivalent brightness to source pixel
    int x = pix.x;
    int y = pix.y;
    int index = pix.index;
    color c = smaller.pixels[index];
    int b = int(brightness(c));
    float record = 255;
    ImageTile selected = null;
    int selectedIndex = -1;

    // Swap
    if (allImages.size() == 0) {
      loadImages();
    }

    // Find the closest image for each brightness value
    for (int i = 0; i < allImages.size(); i++) {
      ImageTile candidate = allImages.get(i);
      float diff = abs(b - candidate.brightness);
      if (diff < record) {
        selected = candidate;
        selectedIndex = i;
        record = diff;
      }
    }


    //fill(brightness(c));
    //stroke(0);
    //strokeWeight(1);
    //rect(x*sclw, y*sclh, sclw, sclh);
    if (selected != null) {
      float diff = b - selected.brightness;
      //tint(min(255, 255+diff));
      image(selected.img, x*sclw, y*sclh, sclw, sclh);
      allImages.remove(selectedIndex);
    }



    if (allpix.size() == 0) {
      break;
    }
  }
  // long unixTime = System.currentTimeMillis() / 1000L;
  saveFrame("animate/codingtrain####.png");

  if (allpix.size() == 0) {
    exit();
  }
  //noLoop();
}


// Function to list all the files in a directory
File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}
