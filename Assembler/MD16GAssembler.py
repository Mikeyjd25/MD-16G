import binascii
import time

start_time = int(round(time.time() * 1000))

in_file = "D:/ROMs/MD/MD-16G/1.asm"
out_file = "D:/ROMs/MD/MD-16G/1.MDR"


def reg(reg_id):
    if reg_id == "GP0":
        return "00000"
    elif reg_id == "GP1":
        return "00001"
    elif reg_id == "GP2":
        return "00010"
    elif reg_id == "GP3":
        return "00011"
    elif reg_id == "ALU":
        return "00100"
    elif reg_id == "ALF":
        return "00101"
    elif reg_id == "AMC":
        return "00110"
    elif reg_id == "IOF":
        return "00111"
    elif reg_id == "CM0":
        return "01000"
    elif reg_id == "CM1":
        return "01001"
    elif reg_id == "CM2":
        return "01010"
    elif reg_id == "CM3":
        return "01011"
    # elif reg_id == "":
    #    return "01100"
    # elif reg_id == "":
    #    return "01101"
    elif reg_id == "CSP":
        return "01110"
    elif reg_id == "LSP":
        return "01111"
    elif reg_id == "CN0":
        return "10000"
    elif reg_id == "CN1":
        return "10001"
    elif reg_id == "CN2":
        return "10010"
    elif reg_id == "CN3":
        return "10011"
    elif reg_id == "CN4":
        return "10100"
    elif reg_id == "CN5":
        return "10101"
    elif reg_id == "CN6":
        return "10110"
    elif reg_id == "CN7":
        return "10111"
    elif reg_id == "CN8":
        return "11000"
    elif reg_id == "CN9":
        return "11001"
    elif reg_id == "CNA":
        return "11010"
    elif reg_id == "CNB":
        return "11011"
    elif reg_id == "CNC":
        return "11100"
    elif reg_id == "CND":
        return "11101"
    elif reg_id == "CNE":
        return "11110"
    elif reg_id == "CNF":
        return "11111"
    else:
        raise Exception('Unrecognised register: "' + reg_id + '" [' + str(line) + ']')


bin_count = 0
goto_list = {}


def add_hex(hex_d, reg_ax="00000", reg_bx="00000", data="00000000"):
    global bin_count
    global hex_data
    if not ((len(hex_d) == 6) & (len(reg_ax) == 5) & (len(reg_bx) == 5) & (len(data) == 8)):
        raise Exception('Something went wrong... Sorry? "' + com + '"\n[' + str(line) + '] ' + x + '\n' +
                        hex_d+' '+reg_ax+' '+reg_bx+' '+data)
    if data == "00000000":
        hex_data.append(hex_d+reg_ax+reg_bx)
    else:
        hex_data.append(hex_d + "00" + data)
    bin_count += 1


def force_add_hex(hex_d):
    global bin_count
    global hex_data
    hex_data.append(hex_d)
    bin_count += 1


def add_jump(jump_hex, use_reg, goto_id):  # TODO
    global goto_list
    if goto_id not in goto_list:
        goto_list[goto_id] = '-1'
    add_hex("000001", use_reg)
    force_add_hex("GOTO-"+goto_id)
    add_hex(jump_hex, use_reg)


def add_goto(goto_id):
    global bin_count
    global goto_list
    goto_list[goto_id] = format(bin_count, '016b')

# "%0.4x" % number
with open(in_file) as f:
    content = f.readlines()
content = [x.strip() for x in content]
hex_data = []
line = 0


for x in content:
    line += 1
    x = x.split('#')[0].strip()
    if len(x) == 0:
        continue
    cdata = x.split()
    if len(cdata[0].strip()) > 0:
        com = cdata[0].strip().upper()
        reg_a = ""
        reg_b = ""
        if len(cdata) > 1:
            reg_a = cdata[1].strip().upper()
        if len(cdata) > 2:
            reg_b = cdata[2].strip().upper()
        if com == "NOP":  # No op
            add_hex("000000")
        elif com == "LDW":  # Load Word
            add_hex("000001", reg(reg_a))
            temp_bin = format(int(reg_b, 16), '016b')
            add_hex(temp_bin[0:6], temp_bin[6:11], temp_bin[11:16])
        elif com == "LDL":  # Load half word, lower
            add_hex("000010", data=format(int(reg_a, 16), '08b'))
        elif com == "LDU":  # Load half word, upper
            add_hex("000011", data=format(int(reg_a, 16), '08b'))
        elif com == "STR":  # Store
            add_hex("000100")
        elif com == "RET":  # Retrieve
            add_hex("000101")
        elif com == "JMP":  # Jump
            add_jump("001000", reg(reg_a), reg_b)
        # elif com == "JLZ":  # Jump if less than zero
        #    add_jump("001001", reg(reg_a), reg_b)
        # elif com == "JGZ":  # Jump if greater than zero
        #    add_jump("001010", reg(reg_a), reg_b)
        # elif com == "JEZ":  # Jump if zero
        #    add_jump("001011", reg(reg_a), reg_b) # TODO Add branching.
        # elif com == "JNZ":  # Jump if not zero
        #    add_jump("001100", reg(reg_a), reg_b)
        # elif com == "JCS":  # Jump if carry set
        #    add_jump("001101", reg(reg_a), reg_b)
        # elif com == "STR":  # Store
        #    add_hex("001110", reg(reg_a), reg(reg_b))
        # elif com == "RET":  # Retrieve
        #    add_hex("001111", reg(reg_a), reg(reg_b))

        elif com == "ADD":  # Add
            add_hex("010000", reg(reg_a), reg(reg_b))
        elif com == "SUB":  # Subtract
            add_hex("010001", reg(reg_a), reg(reg_b))
        elif com == "MUL":  # Multiply
            add_hex("010010", reg(reg_a), reg(reg_b))
        elif com == "CPY":  # Copy
            add_hex("010011", reg(reg_a), reg(reg_b))
        elif com == "SHL":  # Shift Left
            add_hex("010100", reg(reg_a))
        elif com == "SHR":  # Shift Right
            add_hex("010101", reg(reg_a))
        elif com == "ROL":  # Rotate Left
            add_hex("010110", reg(reg_a))
        elif com == "ROR":  # Rotate Right
            add_hex("010111", reg(reg_a))
        elif com == "AND":  # AND
            add_hex("011000", reg(reg_a), reg(reg_b))
        elif com == "NAN":  # NAND
            add_hex("011001", reg(reg_a), reg(reg_b))
        elif com == "ORR":  # OR
            add_hex("011010", reg(reg_a), reg(reg_b))
        elif com == "NOR":  # NOR
            add_hex("011011", reg(reg_a), reg(reg_b))
        elif com == "XOR":  # XOR
            add_hex("011100", reg(reg_a), reg(reg_b))
        elif com == "XNR":  # XNOR
            add_hex("011101", reg(reg_a), reg(reg_b))
        elif com == "NOT":  # NOT
            add_hex("011110", reg(reg_a))
        elif com == "REV":  # Reverse
            add_hex("011111", reg(reg_a))

        elif com == "AWC":  # Add With Carry
            add_hex("100000", reg(reg_a), reg(reg_b))
        elif com == "SWC":  # Subtract With Carry
            add_hex("100001", reg(reg_a), reg(reg_b))
        elif com == "SLC":  # Shift Left into carry
            add_hex("100100", reg(reg_a))
        elif com == "SRC":  # Shift right into carry
            add_hex("100101", reg(reg_a))
        elif com == "RLC":  # Rotate left though carry
            add_hex("100110", reg(reg_a))
        elif com == "RRC":  # Rotate right through carry
            add_hex("100111", reg(reg_a))
        elif com == "INC":  # increment
            add_hex("101000", reg(reg_a))
        elif com == "DEC":  # decrement
            add_hex("101001", reg(reg_a))
        elif com == "SWB":  # Swap upper and lower bytes
            add_hex("101011", reg(reg_a))
        elif com == "ELB":  # extract lower byte
            add_hex("101100", reg(reg_a))
        elif com == "EUB":  # extract upper byte
            add_hex("101101", reg(reg_a))
        elif com == "WLB":  # write lower byte
            add_hex("101110", reg(reg_a), reg(reg_b))
        elif com == "WUB":  # write upper byte
            add_hex("101111", reg(reg_a), reg(reg_b))

        elif com == "DEF":  # Add jump location
            add_goto(reg_a)
        else:
            raise Exception('Unrecognised command: "' + com + '"\n[' + str(line) + '] ' + x)

program_len = len(hex_data)

for key in goto_list:
    if goto_list[key] == '-1':
        raise Exception('Missing GOTO: "' + str(key) + '"')
    else:
        hex_data = [w.replace("GOTO-"+key, goto_list[key]) for w in hex_data]

hex_data2 = []
for each in hex_data:
    hex_data2.append(("%0.4x" % int(each, 2)).upper())

with open(out_file, 'wb') as f:
    f.write(binascii.unhexlify(''.join(hex_data2)))


print("Size: ["+str(program_len)+"/65536]")
end_time = int(round(time.time() * 1000))

print("Took: " + str(end_time-start_time) + "ms")
