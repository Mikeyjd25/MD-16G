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

public static void branch(int data) {
  if(data>=128) {
    PROC -= (256-data)+1;
  }else{
    PROC += data-1;
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

public static void alu_out(int a){alu_out(a, false);}
public static void alu_out(int a, boolean carry){
  regw(REG_ACC, a, true, carry);
}
public static void set_flags(int a){set_flags(a, false);}
public static void set_flags(int a, boolean carry){
  int flags_temp = 0;
  if(a==0) flags_temp |= 0x0001; //Zero
  if(a!=0) flags_temp |= 0x0002; //Not zero
  if((a&0x8000)!=0) flags_temp |= 0x0004; //Less than zero
  if((a&0x8000)==0&&a!=0) flags_temp |= 0x0008; //Greater than zero
  if(carry) flags_temp |= 0x0010; //Carry set
  if(!carry) flags_temp |= 0x0020; //Carry clear
  REG[REG_ALU_FLAGS] = flags_temp;
}
public static int regr(int a){
  if(a>=0&&a<32){
    if(a>=0&&a<7){
      return REG[a];
    }
    //TODO Implement coms handling
    if(a>=16&&a<32){
      return REG[a];
    }
  }
  return 0;
}
public static void regw(int a, int b){regw(a, b, false);}
public static void regw(int a, int b, boolean set_flags){regw(a, b, set_flags, false);}
public static void regw(int a, int b, boolean set_flags, boolean carry){// TODO add all exceptions
  if(a>=0 && a<4) {
    REG[a]=b;
  }else if(a==8) {TerminalController(b&0xFF);}
  if(set_flags){
    set_flags(b, carry);
  }
}

}