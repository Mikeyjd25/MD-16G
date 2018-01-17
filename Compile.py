#################################
# Compilation automation script #
# Made by Mikeyjd25             #
# 2017                          #
#################################

import os
from Assembler import MD16GAssembler
from Compiler import Compiler, MD16G

#MD16GAssembler.main("TestCode/HelloWorld.asm", "TestCode/Bootloader.rom")
DATA = ["make i16 aaa",
        "make i16 aab",
        "make i16 aac",
        "make i16 aad",
        "make i16 aae",
        "= aaa (20)",
        "= aab (28)",
        "= aad (65)",
        "= aae (5)",
        "+ aaa aab aac",
        ": prt aac",
        "< aae",
        "< (1)",
        "def j0",
        ": prt aad",
        "- [-1] [0] [-1]",
        "if [-1] > j0",
        ">",
        ">",
        "def end",
        "goto end"]
#DATA = ["make i16 a",
#        "= a (48)",
#        ": prt a",
#        "def loop",
#        "goto loop"
#]
if not os.path.exists("TEMP"):
    os.makedirs("TEMP")
#Compiler.main("OS/MAIN.GYB", "TEMP/MAIN.ASM")
MD16G.generate_asm(DATA, "TEMP/MAIN.ASM")
MD16GAssembler.main("TEMP/MAIN.ASM", "TestCode/Bootloader.rom")
