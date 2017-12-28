############################################
# First generation compiler for the MD-16G #
# Made by Mikeyjd25                        #
############################################
import time
import sys
import pprint

NUMBER_CHARS = "0123456789"
TEXT_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_"
ALLOWED_CHARECTERS = "!@#%^&*()[]{}+-=<>.,:;|'\"\\/? "+NUMBER_CHARS+TEXT_CHARS
pp = pprint.PrettyPrinter(indent=4)

def main(in_file, out_file):
    """Take in a file, compile it, and output a file."""
    start_time = int(round(time.time() * 1000))  # START


    print("Wait, you want ME to do WORK?", in_file, out_file)
    print("Okay, fine. Compiling...")
    with open(in_file) as f:
        content = f.readlines()
    content = [x.strip() for x in content]

    print("Starting stage 1...")
    stage_1 = clean_strings(content)

    print("Starting stage 2...")
    stage_2 = lexical_analyser(stage_1)
    stage_2_1 = more_lex(stage_2)

    pp.pprint(stage_2_1)

    end_time = int(round(time.time() * 1000))  # END
    print("Compilation Took: " + str(end_time-start_time) + "ms")


def clean_strings(s):
    """Take array of strings, remove comments, replace all whitespace
    with 'space', remove excess whitespace."""
    out = [" "]
    for each in s:
        x = each.strip()+' '
        for i in range(0, len(x)):
            if(x[i] in ALLOWED_CHARECTERS):
                if(x[i]=="#" and out[-1]!="\\"):
                    break
                out.append(x[i])
    return ' '.join(''.join(out).split())


def lexical_analyser(s):  # !@#%^&*()[]{}+-=<>.,:;|'\"\\/? 
    lex = Lexeme()
    out = []
    for i, char in enumerate(s):
        if((char in TEXT_CHARS and (lex.lex_type == "" or lex.lex_type == "text")) or (lex.text_len() > 0 and char in NUMBER_CHARS and lex.lex_type == "text")):
            lex.append_text(char)
            lex.set_type("text")
            continue
        if(lex.text_len()>0 and lex.lex_type == "text"):
            out.append(lex.output())
        if(char in NUMBER_CHARS and (lex.lex_type == "" or lex.lex_type == "number")):
            lex.append_text(char)
            lex.set_type("number")
            continue
        if(lex.lex_type == "number" and lex.text_len > 0):
            out.append(lex.output())
        if(char in TEXT_CHARS or char in NUMBER_CHARS):  # If number or text something went wrong
            raise Exception("Something went wrong (CODE-1)")
        if(lex.text_len()):  # Len > 0 catch error
            raise Exception("Something went wrong (CODE-2)")
        if(char in ALLOWED_CHARECTERS):
            lex.set_type("symbol")
            lex.append_text(char)
            out.append(lex.output())
            continue
            
    return out


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print "Please enter two arguments. \"Compiler.py <in_file> <out_file>\""
        sys.exit()
    else:
        main(sys.argv[1], sys.argv[2])


class Lexeme:
    def __init__(self, l_type="", l_text=""):
        self.lex_type = l_type
        self.lex_text = l_text

    def text_len(self):
        """Return length of lex text"""
        return len(self.lex_text)

    def append_text(self,char):
        self.lex_text += char
    
    def set_type(self, l_type):
        self.lex_type = l_type
    
    def output(self):
        out_dict = {"type": self.lex_type, "text": self.lex_text}
        self.lex_type = ""
        self.lex_text = ""
        return out_dict


def more_lex(s):
    return s
