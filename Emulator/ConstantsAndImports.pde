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

public static final int REG_CONST_0 = 16;
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



static boolean exec_ram = false;