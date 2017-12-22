PGraphics pg;

void setup() {
  // Open a file and read its binary data
  cur_path = sketchPath("");
  MakeConfig();

  GetConfig();

  size(680, 400, P2D);
  surface.setSize(680*scaling,400*scaling);
  pg = createGraphics(640, 360, P2D);
  main_font = loadImage("../Fonts/Main.png");
  byte b[] = loadBytes(Rom_Location);

  // Print each value, from 0 to 255
  for (int i = 0; i < b.length; i+=2) {
    // bytes are from -128 to 127, this converts to 0 to 255
    int a = ((b[i] & 0xff)<<8)|(b[i+1] & 0xff);
    ROM[i/2] = a;
  }

  for (int x = 0; x < 80; x++) {
    for (int y = 0; y < 45; y++) {
      terminal_data[x][y] = 32;
    }
  }

  //Load constants
  REG[16] = 0x0000; //0
  REG[17] = 0x0001; //1
  REG[18] = 0x00FF; //255 or -128
  REG[19] = 0xFFFF; //65535 or -32768
  REG[20] = 0xFF00; //65280 or 32512
  REG[21] = 0x000A; //10
  REG[22] = 0x0064; //100
  REG[23] = 0x0004; //4
}


int delta = 0;
int last = 0;
int last2 = 0;
int last_framecount = 0;
static int insrt_count = 0;


void draw() {
  delta = millis()-last;
  if (delta>=1000) {
    surface.setTitle("PROC: " + Integer.toString(insrt_count/delta/1000) + "MHz, " +
    Integer.toString(((frameCount-last_framecount)*1000)/delta) + "FPS");
    last_framecount = frameCount;
    insrt_count = 0;
    last = millis();
  }
  last2=millis();
  do {
    for(int i = 0; i<2500000; i++) {
      heart.beat();
    }
  } while(millis()-last2<20);
  background(50);
  noStroke();
  pg.beginDraw();
  pg.background(100);
  for (int x = 0; x < 80; x++) {
    for (int y = 0; y < 45; y++) {
      int tempCord = terminal_data[x][y]&0xFF;
      int xCord = tempCord%16; //X cord
      int yCord = (tempCord-xCord)/16; //Y cord
      pg.beginShape();
      pg.texture(main_font);
      pg.vertex(x*8, y*8, xCord*8, yCord*8);
      pg.vertex((x+1)*8, y*8, (xCord+1)*8, yCord*8);
      pg.vertex((x+1)*8, (y+1)*8, (xCord+1)*8, (yCord+1)*8);
      pg.vertex(x*8, (y+1)*8, xCord*8, (yCord+1)*8);
      pg.endShape();
    }
  }
  pg.endDraw();
  image(pg, 20*scaling, 20*scaling, 640*scaling, 360*scaling);
}
