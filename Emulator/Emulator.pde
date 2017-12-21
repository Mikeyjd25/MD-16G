static int ROM[] = new int[65536]; //64KB of ROM
static int REG[] = new int[32];    //32 Registers
static int RAM[] = new int[65536]; //64KB of RAM
static int PROC = 0; //Program counter

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.InputStream;
import java.util.Properties;



//---REGISTERS---
public static final int REG_GP_0 = 0;
public static final int REG_GP_1 = 1;
public static final int REG_GP_2 = 2;
public static final int REG_GP_3 = 3;
public static final int REG_ACC = 4;
public static final int REG_ALU_FLAGS = 5;
public static final int REG_ALU_MULT_CARRY = 6;
public static final int REG_IO_FLAGS = 7;
public static final int REG_COM_0 = 8;
public static final int REG_COM_1 = 9;
public static final int REG_COM_2 = 10;
public static final int REG_COM_3 = 11;
//public static final int REG_LUT_MATCH_TABLE = 12;
//public static final int REG_LUT_FIRST_MATCH = 13;
public static final int REG_CURRENT_STACK_POINTER = 14;
public static final int REG_LAST_STACK_POINTER = 15;

public static final int REG_CONST_0 = 16; //TODO Fix this section
public static final int REG_CONST_1 = 17;
public static final int REG_CONST_2 = 18;
public static final int REG_CONST_3 = 19;
public static final int REG_CONST_4 = 20;
public static final int REG_CONST_5 = 21;
public static final int REG_CONST_6 = 22;
public static final int REG_CONST_7 = 23;
public static final int REG_CONST_8 = 24;
public static final int REG_CONST_9 = 25;
public static final int REG_CONST_10 = 26;
public static final int REG_CONST_11 = 27;
public static final int REG_CONST_12 = 28;
public static final int REG_CONST_13 = 29;
public static final int REG_CONST_14 = 30;
public static final int REG_CONST_15 = 31;


public static String cur_path;
PImage main_font;
public static int[][] terminal_data = new int[80][45];



boolean exec_ram = false;
void setup() {
  // Open a file and read its binary data
  cur_path = sketchPath("");
  MakeConfig();

  GetConfig();

  size(640, 360, P2D);
  surface.setSize(640*scaling,360*scaling);
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
}





int delta = 0;
int last = 0;
int last2 = 0;
int insrt_count = 0;


void draw() {
  delta = millis()-last;
  if (delta>=1000) {
    surface.setTitle("PROC: " + Integer.toString(insrt_count/delta/1000) + "MHz");
    insrt_count = 0;
    last = millis();
  }
  last2=millis();
  while(millis()-last2<20) {
    for(int i = 0; i<1000; i++) {
      insrt_count++;
      int word = 0;
      if(exec_ram) word = RAM[PROC]; else word = ROM[PROC];
      int word2 = 0;
      if(exec_ram) word2 = RAM[(PROC+1)%65536]; else word2 = ROM[(PROC+1)%65536];
      int command = ((word >> 10) & 0x003F);
      int regA = ((word >> 5) & 0x001F);
      int regB = (word & 0x001F);
      int data = (word & 0x00FF);
      switch (command) {
      case 0: //00 No op
        break;
      case 1: //01 Load Word
        emulate.regw(regA,word2);
        insrt_count++;
        break;
      case 2: //02 Load half word, lower
        emulate.alu_out(data);
        break;
      case 3: //03 Load half word, upper
        emulate.alu_out(data<<8);
        break;
      case 4: //04 Store
        RAM[emulate.regr(regA)] = emulate.regr(regB);
        break;
      case 5: //05 Retrieve
        emulate.regw(regB, RAM[emulate.regr(regA)]);
        break;
      case 6: //06 Execute ROM
        exec_ram = false;
        PROC = 0;
        break;
      case 7: //07 Execute RAM
        exec_ram = true;
        PROC = 0;
        break;
      case 8: //08 Jump
        PROC = emulate.regr(regA)-1;
        break;
      case 9: //09 Branch TODO
        //if((REG[REG_ALU_FLAGS]&0x0002)>0) PROC = emulate.regr(regA)-1;
        break;
      case 10: //0A Branch if zero TODO
        //if((REG[REG_ALU_FLAGS]&0x0004)>0) PROC = emulate.regr(regA)-1;
        break;
      case 11: //0B Branch if not zero TODO
        //if((REG[REG_ALU_FLAGS]&0x0008)>0) PROC = emulate.regr(regA)-1;
        break;
      case 12: //0C Branch if less than zero TODO
        //if((REG[REG_ALU_FLAGS]&0x0010)>0) PROC = emulate.regr(regA)-1;
        break;
      case 13: //0D Branch if greater than zero TODO
        //if((REG[REG_ALU_FLAGS]&0x0001)>0) PROC = emulate.regr(regA)-1;
        break;
      case 14: //0E Branch if carry set TODO
        break;
      case 15: //0F Branch if carry clear TODO
        break;
      case 16: //10 Add
        emulate.alu_out((emulate.regr(regA)+emulate.regr(regB))&0xFFFF);
        break;
      case 17: //11 Subtract
        emulate.alu_out((emulate.regr(regA)-emulate.regr(regB))&0xFFFF);
        break;
      case 18: //12 Multiply
        emulate.alu_out((emulate.regr(regA)*emulate.regr(regB))&0xFFFF);
        break;
      case 19: //13 Copy TODO add all exceptions
        if(regA>=0 && regA<32) {
          if(regB>=0 && regB<4) {
            emulate.regw(regB,emulate.regr(regA));
          }else if(regB==8) {emulate.TerminalController((emulate.regr(regA)&0xFF));}
        }
        break;
      case 20: //14 Shift Left
        emulate.alu_out((emulate.regr(regA)<<1)&0xFFFF);
        break;
      case 21: //15 Shift Right
        emulate.alu_out((emulate.regr(regA)>>1)&0xFFFF);
        break;
      case 22: //16 Rotate Left
        break;
      case 23: //17 Rotate Right
        break;
      case 24: //18 AND
        emulate.alu_out((emulate.regr(regA)&emulate.regr(regB))&0xFFFF);
        break;
      case 25: //19 NAND
        emulate.alu_out((~(emulate.regr(regA)&emulate.regr(regB)))&0xFFFF);
        break;
      case 26: //1A OR
        emulate.alu_out((emulate.regr(regA)|emulate.regr(regB))&0xFFFF);
        break;
      case 27: //1B NOR
        emulate.alu_out((~(emulate.regr(regA)|emulate.regr(regB)))&0xFFFF);
        break;
      case 28: //1C XOR
        emulate.alu_out((emulate.regr(regA)^emulate.regr(regB))&0xFFFF);
        break;
      case 29: //1D XNOR
        emulate.alu_out((~(emulate.regr(regA)^emulate.regr(regB)))&0xFFFF);
        break;
      case 30: //1E NOT
        emulate.alu_out((~emulate.regr(regA))&0xFFFF);
        break;
      case 31: //1F Reverse
        emulate.alu_out((Integer.reverse(emulate.regr(regA))>>16)&0xFFFF);
        break;
      case 32: //20 Add With Carry TODO
        break;
      case 33: //21 Subtract with carry TODO
        break;
      case 34: //22
        break;
      case 35: //23
        break;
      case 36: //24 Shift Left into carry TODO
        break;
      case 37: //25 Shift right into carry TODO
        break;
      case 38: //26 Rotate left though carry TODO
        break;
      case 39: //27 Rotate right through carry TODO
        break;
      case 40: //28 increment
        emulate.regw(regA,(emulate.regr(regA)+1)&0xFFFF);
        break;
      case 41: //29 decrement
        emulate.regw(regA,(emulate.regr(regA)-1)&0xFFFF);
        break;
      case 42: //2A
        break;
      case 43: //2B Swap upper and lower byte TODO
        break;
      case 44: //2C extract lower byte TODO
        break;
      case 45: //2D extract upper byte TODO
        break;
      case 46: //2E write lower byte TODO
        break;
      case 47: //2F write upper byte TODO
        break;
      case 48: //30
        break;
      case 49: //31
        break;
      case 50: //32
        break;
      case 51: //33
        break;
      case 52: //34
        break;
      case 53: //35
        break;
      case 54: //36
        break;
      case 55: //37
        break;
      case 56: //38
        break;
      case 57: //39
        break;
      case 58: //3A
        break;
      case 59: //3B
        break;
      case 60: //3C
        break;
      case 61: //3D
        break;
      case 62: //3E
        break;
      case 63: //3F
        break;
      }
      PROC++;
      PROC %= 65536;
    }
  }
  background(242, 65, 239);
  noStroke();
  for (int x = 0; x < 80; x++) {
    for (int y = 0; y < 45; y++) {
      int tempCord = terminal_data[x][y]&0xFF;
      int xCord = tempCord%16; //X cord
      int yCord = (tempCord-xCord)/16; //Y cord
      beginShape();
      texture(main_font);
      vertex(x*scaling*8, y*scaling*8, xCord*8, yCord*8);
      vertex((x+1)*scaling*8, y*scaling*8, (xCord+1)*8, yCord*8);
      vertex((x+1)*scaling*8, (y+1)*scaling*8, (xCord+1)*8, (yCord+1)*8);
      vertex(x*scaling*8, (y+1)*scaling*8, xCord*8, (yCord+1)*8);
      endShape();
    }
  }
}

public static class emulate {

public static int terminal_x_pointer = 0;
public static int terminal_y_pointer = 0;

public static void TerminalController(int input) {
  if(input>=32 && input<256) {
    terminal_data[terminal_x_pointer][terminal_y_pointer] = input;
    terminal_x_pointer++;
    TerminalOverflow();

  }else if(input==10){
    terminal_x_pointer = 0;
    terminal_y_pointer++;
    TerminalOverflow();
  }
}

static void TerminalOverflow() {
  if(terminal_x_pointer>=80) {
    terminal_x_pointer = 0;
    terminal_y_pointer++;
  }
  if(terminal_y_pointer>=45) {
    terminal_y_pointer=44;
  }
}

public static void alu_out(int a){
  alu_out(a, false);
}
public static void alu_out(int a, boolean carry){   //TODO Update this
  REG[REG_ACC] = a;
  int flags_temp = 0;
  if(carry) flags_temp |= 0x0001;
  if((a&0x8000)!=0) flags_temp |= 0x0002;
  if((a&0x8000)==0&&a!=0) flags_temp |= 0x0004;
  if(a==0) flags_temp |= 0x0008;
  if(a!=0) flags_temp |= 0x0010;
  REG[REG_ALU_FLAGS] = flags_temp;
}
public static int regr(int a){   //TODO Fix this
  if(a!=11) if(a>=0&&a<32) return REG[a];
  return 0;
}
public static void regw(int a, int b){   //TODO fix this
  if(a!=11) if(a>=0&&a<32) REG[a]=b;
}

}

public static void MakeConfig() {
  String props_file ="defaults.properties";
  String full_path = cur_path + props_file;
  File file = new File(full_path);

  boolean b = false;

  if(!file.exists()) {
    println("The file does not exsist creating file...");

    Properties prop = new Properties();
    OutputStream output = null;

    try {
      output = new FileOutputStream(full_path);

      // set the properties value
      prop.setProperty("Rom_Location", "../TestCode/Bootloader.rom");
      prop.setProperty("scaling", "2");

      // save properties
      prop.store(output, null);

    } catch (IOException io) {
      io.printStackTrace();
    } finally {
      if (output != null) {
        try {
          output.close();
        } catch (IOException e) {
          e.printStackTrace();
        }
      }
    }
  }
}

public static String Rom_Location;
public static int scaling = 1;


public static void GetConfig(){
  String props_file ="defaults.properties";
  String full_path = cur_path + props_file;
  File file = new File(full_path);

  Properties prop = new Properties();
  InputStream input = null;

  try {

    input = new FileInputStream(full_path);

    // load a properties file
    prop.load(input);

    // get the property value and print it out
    Rom_Location = prop.getProperty("Rom_Location");

    try {
      scaling = Integer.parseInt(prop.getProperty("scaling"));
    } catch (NumberFormatException e) {
      e.printStackTrace();
    }


  } catch (IOException ex) {
    ex.printStackTrace();
  } finally {
    if (input != null) {
      try {
        input.close();
      } catch (IOException e) {
        e.printStackTrace();
      }
    }
  }


}
