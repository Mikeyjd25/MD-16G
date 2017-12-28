#################################
# Compilation automation script #
# Made by Mikeyjd25             #
# 2017                          #
#################################

#from Assembler import MD16GAssembler
from Compiler import Compiler

#MD16GAssembler.main("TestCode/HelloWorld.asm", "TestCode/Bootloader.rom")
Compiler.main("OS/MAIN.GYB", "TEMP/MAIN.ASM")
