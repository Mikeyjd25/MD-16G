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
    stage_2_2 = lex_3(stage_2_1)

    pp.pprint(stage_2_2)

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


def lexical_analyser(s):
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
    out = []
    for item in s:
        if(len(item['text']) == 0):
            print("WARNING: Something went wrong (CODE-3)")
            continue
        if(item['type'] == "text"):
            out.append({"type": "text", "value": item['text']})
            continue
        if(item['type'] == "number"):
            out.append({"type": "number", "value": int(item['text'])})
            continue
        if(item['type'] == "symbol"):
            if(item['text'] in '+-%*/'):
                out.append({"type": "arithmetic", "value": item['text']})
                continue
            if(item['text'] in ',;.'):
                out.append({"type": "punctuation", "value": item['text']})
                continue
            if(item['text'] in '='):
                out.append({"type": "assignment", "value": item['text']})
                continue
            if(item['text'] in '@'):
                out.append({"type": "pointer", "value": item['text']})
                continue
            if(item['text'] in '<>'):
                out.append({"type": "comparison", "value": item['text']})
                continue
            if(item['text'] in '\'"'):
                out.append({"type": "quotation", "value": item['text']})
                continue
            if(item['text'] in '!|&'):
                out.append({"type": "logical", "value": item['text']})
                continue
            if(item['text'] in '{[]()}'):
                out.append({"type": "bracket", "value": item['text']})
                continue
            if(item['text'] in '\\'):
                out.append({"type": "escape", "value": item['text']})
                continue
            if(item['text'] in ' '):
                out.append({"type": "whitespace", "value": item['text']})
                continue
            if(item['text'] in '#?^:'):
                out.append({"type": "misc", "value": item['text']})
                continue
    return out

def lex_3(s):
    escape = False
    skip = False
    out = []
    for i, lex in enumerate(s):
        if escape:
            escape = False
            out.append({'type': 'text', 'value': str(lex['value'])})
            continue
        if skip:
            skip = False
            continue
        if lex['type'] == 'escape':
            escape = True
            continue
        if lex['type'] == 'arithmetic':
            if lex['value'] in "+-*/":
                if s[i+1]['type'] == 'assignment':
                    skip = True
                    out.append({'type': 'special_assignment', 'value': lex['value'] + s[i+1]['value']})
                    continue
            if lex['value'] in '+-':
                if s[i+1]['type'] == 'arithmetic':
                    if lex['value'] == s[i+1]['value']:
                        if lex['value'] == '+':
                            skip = True
                            out.append({'type': 'increment', 'value': lex['value'] + s[i+1]['value']})
                            continue
                        if lex['value'] == '-':
                            skip = True
                            out.append({'type': 'decrement', 'value': lex['value'] + s[i+1]['value']})
                            continue
        if lex['type'] == 'comparison':
            if s[i+1]['type'] == 'assignment':
                skip = True
                out.append({'type': 'comparison', 'value': lex['value'] + s[i+1]['value']})
                continue
            if s[i+1]['type'] == 'comparison':
                if s[i+2]['type'] == 'comparison':
                    if lex['value'] == s[i+1]['value']:
                        skip = True
                        out.append({'type': 'shift', 'value': lex['value'] + s[i+1]['value'] + s[i+2]['value']})
                        continue
                if lex['value'] == s[i+1]['value'] == s[i+2]['value']:
                    skip = True
                    out.append({'type': 'shift', 'value': lex['value'] + s[i+1]['value']})
                    continue
        out.append(lex)
    return out
