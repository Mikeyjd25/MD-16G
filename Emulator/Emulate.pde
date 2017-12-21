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