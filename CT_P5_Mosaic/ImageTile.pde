class ImageTile {
  PImage img;
  float brightness;

  ImageTile(PImage img_) {
    img = createImage(sclw, sclh, RGB);
    img.copy(img_, 0, 0, img_.width, img_.height, 0, 0, sclw, sclh);
    img.loadPixels();
    // Calculate average brightness
    float avg = 0;
    for (int j = 0; j <img.pixels.length; j++) {
      float b =  brightness(img.pixels[j]);
      avg += b;
    }
    avg /= img.pixels.length;
    brightness = avg;
  }
}
