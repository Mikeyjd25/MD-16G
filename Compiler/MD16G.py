#########################################
# Platform specific portion of compiler #
# Mikeyjd25 2018                        #
#########################################

import sys


ram_usage = 0
jump_skip_count = 0
variable_list = {}

def generate_asm(in_data, out_file):
    asm_out = ""
    for item in in_data:
        asm_out += "####[ "+item+" ]####" + '\n'
        chunks = item.split()
        if chunks[0] == "make":
            func_make(chunks)

        if chunks[0] == "=":
            asm_out += func_set(chunks)

        if chunks[0] == "+":
            asm_out += func_add(chunks)

        if chunks[0] == "-":
            asm_out += func_sub(chunks)

        if chunks[0] == "*":
            asm_out += func_mul(chunks)

        if chunks[0] == ":":
            asm_out += func_io(chunks)

        if chunks[0] == "<":
            asm_out += func_stack_push(chunks)

        if chunks[0] == ">":
            asm_out += func_stack_pop(chunks)

        if chunks[0] == "def":
            asm_out += func_def(chunks)

        if chunks[0] == "goto":
            asm_out += func_goto(chunks)

        if chunks[0] == "if":
            asm_out += func_if(chunks)
        
        asm_out += '\n'

    with open(out_file, "w") as text_file:
        text_file.write(asm_out)

def func_make(in_data):
    global ram_usage
    if in_data[1] == "i16":
        if in_data[2] in variable_list:
            raise Exception("Tried to make same variable twice.")
        variable_list[in_data[2]] = {"loc": ('%04x'%ram_usage), "type": in_data[1]}
        ram_usage += 1

def func_set(in_data):
    output = ""
    if get_var_type(in_data[1]) in ["glob", "stack"]:
        output += load_var_addr(in_data[1], "GP0")
        output += load_data(in_data[2], "GP1")
        output += "STR GP0 GP1"+'\n'
    else:
        raise Exception("Malformed code. [func_set]")
    return output

def func_add(in_data):
    output = ""
    output += load_data(in_data[1], "GP0")
    output += load_data(in_data[2], "GP1")
    output += "ADD GP0 GP1"+'\n'
    output += load_var_addr(in_data[3], "GP0")
    output += "STR GP0 ACC"+'\n'
    return output

def func_sub(in_data):
    output = ""
    output += load_data(in_data[1], "GP0")
    output += load_data(in_data[2], "GP1")
    output += load_var_addr(in_data[3], "GP2")
    output += "SUB GP0 GP1"+'\n'
    output += "STR GP2 ACC"+'\n'
    return output

def func_mul(in_data):
    output = ""
    output += load_data(in_data[1], "GP0")
    output += load_data(in_data[2], "GP1")
    output += "MUL GP0 GP1"+'\n'
    output += load_var_addr(in_data[3], "GP0")
    output += "STR GP0 ACC"+'\n'
    return output

def func_io(in_data):
    output = ""
    if in_data[1] == "prt":
        output += load_data(in_data[2], "GP0")
        output += "CPY GP0 CM0"+'\n'
    return output

def func_stack_push(in_data):
    output = ""
    output += "INC CSP"+'\n'
    output += load_data(in_data[1], "GP0")
    output += load_var_addr("[0]", "GP1")
    output += "STR GP1 GP0"+'\n'
    return output

def func_stack_pop(in_data):
    return "DEC CSP"+'\n'

def func_def(in_data):
    return "DEF "+in_data[1]+'\n'

def func_goto(in_data):
    return "JMP GP3 "+in_data[1]+'\n'

def func_if(in_data):
    global jump_skip_count
    output = ""
    output += load_data(in_data[1], "GP0")
    output += "ORR GP0 GP0"+'\n'
    if in_data[2] == "=":
        output += "BEZ 4"+'\n'
    elif in_data[2] == "!":
        output += "BNZ 4"+'\n'
    elif in_data[2] == "<":
        output += "BLZ 4"+'\n'
    elif in_data[2] == ">":
        output += "BGZ 4"+'\n'
    elif in_data[2] == "cs":
        output += "BCS 4"+'\n'
    elif in_data[2] == "cc":
        output += "BCC 4"+'\n'
    else:
        raise Exception("Unknown jump type. [func_if]")
    
    output += "JMP GP3 SKIP"+str(jump_skip_count)+'\n'
    output += "JMP GP3 "+in_data[3]+'\n'
    output += "DEF SKIP"+str(jump_skip_count)+'\n'
    jump_skip_count += 1

    return output

def load_data(in_data, loc):
    output = ""
    if get_var_type(in_data) in ["glob", "stack"]:
        output += load_var_addr(in_data, "GP3")
        output += "RET GP3 "+loc+'\n'
    else:
        output += "LDW "+loc+" "+in_data[1:-1]+'\n'
    return output

def load_var_addr(in_data, loc="GP3"):
    output = ""
    if get_var_type(in_data) == "glob":
        output += "LDW "+loc+" "+variable_list[in_data]["loc"]+'\n'
        return output
    if get_var_type(in_data) == "stack":
        output += "LDW "+loc+" 8000"+'\n'
        output += "ADD "+loc+" CSP"+'\n'
        output += "LDW "+loc+" "+('%04x' % ((65536+int(in_data[1:-1], 16))%65536))+'\n'
        output += "ADD "+loc+" ACC"+'\n'
        output += "CPY ACC "+loc+'\n'
        return output
    raise Exception("Malformed code. [load_var_addr]")

def get_var_type(in_data):
    if in_data in variable_list:
        return "glob"
    if in_data[0] == "(":
        return "num"
    if in_data[0] == "[":
        return "stack"
    raise Exception("Malformed code. [get_var_type]")
