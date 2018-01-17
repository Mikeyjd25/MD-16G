public static class heart{
public  static void beat(){
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
    PROC++;
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
  case 9: //09 Branch
    emulate.branch(data&0xFF);
    break;
  case 10: //0A Branch if zero
    if((REG[REG_ALU_FLAGS]&0x0001)>0) emulate.branch(data&0xFF);
    break;
  case 11: //0B Branch if not zero
    if((REG[REG_ALU_FLAGS]&0x0002)>0) emulate.branch(data&0xFF);
    break;
  case 12: //0C Branch if less than zero
    if((REG[REG_ALU_FLAGS]&0x0004)>0) emulate.branch(data&0xFF);
    break;
  case 13: //0D Branch if greater than zero
    if((REG[REG_ALU_FLAGS]&0x0008)>0) emulate.branch(data&0xFF);
    break;
  case 14: //0E Branch if carry set
    if((REG[REG_ALU_FLAGS]&0x0010)>0) emulate.branch(data&0xFF);
    break;
  case 15: //0F Branch if carry clear
    if((REG[REG_ALU_FLAGS]&0x0020)>0) emulate.branch(data&0xFF);
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
  case 19: //13 Copy
    emulate.regw(regB, emulate.regr(regA));
    break;
  case 20: //14 Shift Left
    emulate.alu_out((emulate.regr(regA)<<1)&0xFFFF);
    break;
  case 21: //15 Shift Right
    emulate.alu_out((emulate.regr(regA)>>1)&0xFFFF);
    break;
  case 22: //16 Rotate Left TODO
    break;
  case 23: //17 Rotate Right TODO
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
    emulate.regw(regA,(emulate.regr(regA)+1)&0xFFFF, true); //TODO Catch carry
    break;
  case 41: //29 decrement
    emulate.regw(regA,(emulate.regr(regA)-1)&0xFFFF, true); //TODO Catch carry
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
