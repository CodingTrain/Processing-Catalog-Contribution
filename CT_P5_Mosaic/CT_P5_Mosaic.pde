
// Source image
PImage p5Image;
// Resize it
PImage smaller;
// Giant array of images
ArrayList<ImageTile> allImages = new ArrayList<ImageTile>();
// Corresponding brightness value
// Images by brightness
ArrayList<ImageTile>[] brightImages;

// Size of each "cell"
int scl = 32;
int w, h;

int factor = 4;

void settings() {
  size(225*factor, 300*factor);
}

void setup() {
  p5Image = loadImage("p5.png");

  // Find all the images
  File[] files = listFiles(sketchPath("data/photos"));
  printArray(files);
  // Use a smaller amount just for testing
  // allImages = new PImage[100];
  // Need brightness average for each image
  // brightness = new float[allImages.length];

  // Only 256 brightness values
  brightImages = new ArrayList[256];
  // Deal with all the images
  for (int i = 0; i < files.length; i++) {
    String filename = files[i].toString();
    println(filename);
    if (filename.indexOf(".jpg") > -1) {
      // Load the image
      PImage img = loadImage(filename);
      img.loadPixels();
      println(img.pixels.length);
      if (img.pixels.length > 1) {
        ImageTile tile = new ImageTile(img);
        allImages.add(tile);
      }
    } else {
      println("not a valid image");
    }
  }

  int threshold = 150;

  // Find the closest image for each brightness value
  for (int i = 0; i < brightImages.length; i++) {
    brightImages[i] = new ArrayList<ImageTile>();
    for (int j = 0; j < allImages.size(); j++) {
      float diff = abs(i - allImages.get(j).brightness);
      if (diff < threshold) {
        brightImages[i].add(allImages.get(j));
      }
    }
  }

  // how many cols and rows
  w = width/scl;
  h = height/scl;

  smaller = createImage(w, h, RGB);
  smaller.copy(p5Image, 0, 0, p5Image.width, p5Image.height, 0, 0, w, h);
}


void draw() {
  background(0);
  smaller.loadPixels();
  // Columns and rows
  for (int x =0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      // Draw an image with equivalent brightness to source pixel
      int index = x + y * w;
      color c = smaller.pixels[index];
      int imageIndex = int(brightness(c));

      ArrayList<ImageTile> options = brightImages[imageIndex];
      int randomIndex = int(random(options.size()));
      PImage img = options.get(randomIndex).img;

      fill(brightness(c));
      noStroke();
      rect(x*scl, y*scl, scl, scl);
      image(img, x*scl, y*scl, scl, scl);
    }
  }
  noLoop();
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
