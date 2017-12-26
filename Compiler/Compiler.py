############################################
# First generation compiler for the MD-16G #
# Made by Mikeyjd25                        #
############################################
import time
import sys

NUMBER_CHARS = "0123456789"
TEXT_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_"
ALLOWED_CHARECTERS = "!@#%^&*()[]{}+-=<>.,:;|'\"\\/? "+NUMBER_CHARS+TEXT_CHARS

def main(in_file, out_file):
    start_time = int(round(time.time() * 1000))  # START


    print("Wait, you want ME to do WORK?", in_file, out_file)
    print("Okay, fine. Compiling...")
    with open(in_file) as f:
        content = f.readlines()
    content = [x.strip() for x in content]
    print("Starting stage 1...")

    stage_1 = clean_strings(content)
    stage_2 = lexical_analyser(stage_1)

    print(stage_2)

    end_time = int(round(time.time() * 1000))  # END
    print("Compilation Took: " + str(end_time-start_time) + "ms")


def clean_strings(s):
    out = [" "]
    for each in s:
        x = each.strip()+' '
        for i in range(0, len(x)):
            if(x[i] in ALLOWED_CHARECTERS):
                if(x[i]=="#" and out[-1]!="\\"):
                    break
                out.append(x[i])
#        if(len(x)>0):
#            out.append(x)
    return ' '.join(''.join(out).split())


def lexical_analyser(s):
    lex = ""
    out = []
    for i in range(0,len(s)):
        lex += s[i]
    return s


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print "Please enter two arguments. \"Compiler.py <in_file> <out_file>\""
        sys.exit()
    else:
        main(sys.argv[1], sys.argv[2])
