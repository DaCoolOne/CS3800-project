# A python implementation of a compiler for lisp, because python is just faster for development cycles and I don't care about compile times :P

import os
from typing import Dict, Set, Tuple, Union, List, Optional
from enum import Enum, unique

_IF_IDENT_CTR = 0
_LOOP_IDENT_CTR = 0

__LISP_ASM_HEADER = """

    ; Stack pointer reg
    .ALIAS __SP 0x0

    ; Regs for allocating additional memory
    .ALIAS __ALLOC_SIZE 0x1
    .ALIAS __ALLOC_HEAD 0x2
    .ALIAS __ALLOC_POSITION 0x3
    .ALIAS __ALLOC_TEMP  0x4
    .ALIAS __ALLOC_TEMP2 0x5

    ; General purpose registers
    .ALIAS __REG_A 0xA
    .ALIAS __REG_B 0xB
    .ALIAS __REG_C 0xC
    .ALIAS __REG_D 0xD
    .ALIAS __REG_E 0xE
    .ALIAS __REG_F 0xF

    ; Startup and init
    SET __SP __STACK_BEGIN
    SET __ALLOC_HEAD __ALLOC_BEGIN
    JMP main

    ; Important functions

; Allocate a block of dynamic memory
__ALLOC_BLOCK:
    SET __ALLOC_POSITION __ALLOC_HEAD
__ALLOC_BLOCK_LOOP_START:
    LD __ALLOC_POSITION
    MOV __ALLOC_TEMP __ALLOC_POSITION
    CJMP __ALLOC_POSITION __ALLOC_BLOCK_SPOT_FOUND
    MOV __ALLOC_TEMP __ALLOC_POSITION
    MOV __ALLOC_TEMP2 __ALLOC_POSITION
    LD __ALLOC_TEMP
    ADDI __ALLOC_TEMP2 0x3
    LD __ALLOC_TEMP2
    ADD __ALLOC_TEMP __ALLOC_TEMP __ALLOC_TEMP2
    SUB __ALLOC_TEMP2 __ALLOC_TEMP __ALLOC_POSITION
    GTR __ALLOC_TEMP2 __ALLOC_SIZE __ALLOC_TEMP2
    CJMP __ALLOC_TEMP2 __ALLOC_BLOCK_SPOT_FOUND
    RJMP __ALLOC_BLOCK_LOOP_START
__ALLOC_BLOCK_SPOT_FOUND:
    SET __ALLOC_TEMP 0x0

"""

__LISP_DEFAULT_MAIN = """
main:
    RJMP main
"""

__LISP_ASM_FOOTER = """
__STACK_BEGIN:
    ; This will all get overwritten anyways. We just need to buffer the space a little so we don't overwrite the stack when creating dynamic memory
    .TEXT "EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE"

__ALLOC_BEGIN:
    ;Sentinel memory node
    .DATA 0 0 4 1
"""

@unique
class TOKEN_TYPE(Enum):
    KEYWORD = 1
    INT = 2
    PAREN_START = 3
    PAREN_END = 4
    BLOCK_START = 5
    BLOCK_END = 6
    STRING = 7
    IDENTIFIER = 8
    FLOAT = 9
    GLOBAL = 10
    EOF = 11
    
    # Tree specific
    ROOT = 12
    ARGLIST = 13
    LOOP = 14
    FOR = 15
    WHILE = 16
    SET = 17
    BLOCK = 18
    IMPORT = 19
    FUNCTION = 20
    FUNCTION_CALL = 21
    IF = 22
    IF_COND = 23
    ELSE_COND = 24
    STRUCT = 25
    ALLOC = 26

class Token:
    def __init__(self, type: TOKEN_TYPE, line: int, value: Optional[str] = None) -> None:
        self.type = type
        self.value = value
        self.line = line
    def asString(self) -> str:
        if self.value is None:
            return self.type.name
        else:
            return self.type.name + ' ' + str(self.value)

class ParserError(Exception):
    def __init__(self, text: str, line: int) -> None:
        super().__init__(f'ERR Line {line}: {text}')

class TokenParser:
    __LSP_ALLOWED_IDENT_SP_CHARS = set('.-=+_!&<>/\\?^%$@~[]*:')
    
    __KEYWORDS = {
        "if",
        "elif",
        "else",
        "returns",
        "while",
        "for",
        "loop",
        "function",
        "struct",
        "set",
        "import",
        "alloc",
        "global"
    }

    def __init__(self, digestString: str) -> None:
        self.digest = digestString
        self.index = 0
        self.line = 1
    def nextChar(self) -> Union[str, None]:
        if self.index >= len(self.digest):
            return None
        c = self.digest[self.index]
        self.index += 1
        if c == '\n':
            self.line += 1
        return c
    def peek(self) -> Union[str, None]:
        if self.index >= len(self.digest):
            return None
        return self.digest[self.index]
    def stepBack(self) -> None:
        self.index -= 1
        if self.digest[self.index] == '\n':
            self.line -= 1
    def getTokenLine(self) -> int:
        if self.index > 0 and self.digest[self.index - 1] == '\n':
            return self.line - 1
        return self.line
    def nextToken(self) -> Token:
        # pass over whitespace and comments
        c: str = self.nextChar()
        is_comment = False
        while True:
            if c is None: return Token(TOKEN_TYPE.EOF, self.line)
            elif c == '#': is_comment = True
            elif c == '\n': is_comment = False
            
            # Break out of the loop
            if not is_comment and not c.isspace():
                break

            c: str = self.nextChar()
        
        if c == '(':
            return Token(TOKEN_TYPE.PAREN_START, self.getTokenLine())
        elif c == ')':
            return Token(TOKEN_TYPE.PAREN_END, self.getTokenLine())
        elif c == '{':
            return Token(TOKEN_TYPE.BLOCK_START, self.getTokenLine())
        elif c == '}':
            return Token(TOKEN_TYPE.BLOCK_END, self.getTokenLine())
        elif c == '"':
            quote = c
            c = self.nextChar()
            s = ''
            spec_mode = False
            while spec_mode or c != quote:
                if spec_mode:
                    if c == 'n': s += '\n'
                    elif c == 't': s += '\t'
                    elif c == '0': s += '\0'
                    elif c == 'u': s += 'UwU'
                    else: s += c

                    spec_mode = False
                elif c == '\\':
                    spec_mode = True
                else:
                    s += c
                
                c = self.nextChar()
                if c is None or c == '\n':
                    raise ParserError(f"Unclosed string", self.getTokenLine())
            return Token(TOKEN_TYPE.STRING, self.getTokenLine(), s)
        
        if c.isdigit():
            if c == '0':
                s = ''
                c = self.peek()
                if c == 'x':
                    self.index += 1
                    c = self.nextChar()
                    while c is not None and (c.isdigit() or c in 'abcdefABCDEF'):
                        s += c
                        c = self.nextChar()
                    if c.isspace():
                        return Token(TOKEN_TYPE.INT, self.getTokenLine(), int(s, 16))
                    elif c in '(){}#':
                        self.stepBack()
                        return Token(TOKEN_TYPE.INT, self.line, int(s, 16))
                    else:
                        raise ParserError(f"Unexpecteed character '{c}'", self.line)
                elif c == 'b':
                    self.index += 1
                    c = self.nextChar()
                    while c is not None and (c == '0' or c == '1'):
                        s += c
                        c = self.nextChar()
                    if c.isspace():
                        return Token(TOKEN_TYPE.INT, self.getTokenLine(), int(s, 2))
                    elif c in '(){}#':
                        self.stepBack()
                        return Token(TOKEN_TYPE.INT, self.line, int(s, 2))
                    else:
                        raise ParserError(f"Unexpecteed character '{c}'", self.line)
                
                c = '0'

            # Normal decimal parsing
            s = ''
            while c is not None and c.isdigit():
                s += c
                c = self.nextChar()
            
            if c.isspace():
                return Token(TOKEN_TYPE.INT, self.getTokenLine(), int(s))
            elif c in '(){}#':
                self.stepBack()
                return Token(TOKEN_TYPE.INT, self.line, int(s))
            else:
                raise ParserError(f"Unexpecteed character '{c}'", self.line)

        # Identifier or keyword
        elif c.isalpha() or c in TokenParser.__LSP_ALLOWED_IDENT_SP_CHARS:
            s = ''
            while c is not None and (c.isalnum() or c in TokenParser.__LSP_ALLOWED_IDENT_SP_CHARS):
                s += c
                c = self.nextChar()
            if c in '(){}#':
                self.stepBack()
            elif not (c is None or c.isspace()):
                raise ParserError(f"Unexpected character '{c}'", self.line)
            
            if s in TokenParser.__KEYWORDS:
                return Token(TOKEN_TYPE.KEYWORD, self.getTokenLine(), s)
            elif s.startswith('__'):
                raise ParserError(f"{s} is a reserved word!", self.line)
            else:
                return Token(TOKEN_TYPE.IDENTIFIER, self.getTokenLine(), s)
        else:
            raise ParserError(f"Unexpected token '{c}'", self.line)

# Helper functions / classes
class Lsp_Function:
    pass

# A simple function is one which can be written inline
class Lsp_SimpleFunction(Lsp_Function):
    pass

class Lsp_SimpleBinaryFunction(Lsp_SimpleFunction):
    pass

# User functions are collections of smaller functions
class Lsp_UserFunction(Lsp_Function):
    pass

class ParseNode:
    def __init__(self, token: Token) -> None:
        self.token: Token = token
        self.children: List[ParseNode] = []

class ParseTree:
    def __init__(self) -> None:
        self.root = ParseNode(Token(TOKEN_TYPE.ROOT, 0))
        self.stack = [ self.root ]
    def push(self, token: Token) -> None:
        current = self.stack[-1]
        newChild = ParseNode(token)
        current.children.append(newChild)
        self.stack.append(newChild)
    def pop(self):
        self.stack.pop()
    def shift(self, token: Token):
        self.stack[-1].children.append(ParseNode(token))
    def __print_rec(self, node: ParseNode, prefix: str, isFinal: bool):
        c = ('└─' if isFinal else '├─')
        if node is self.root:
            c = '╶─'
        c += ('┬╴' if len(node.children) > 0 else '─╴')
        print(prefix + c + node.token.asString())
        for i, n in enumerate(node.children):
            pf = prefix + '  ' if isFinal else prefix + '│ '
            self.__print_rec(n, pf, i + 1 == len(node.children))
    def print(self):
        self.__print_rec(self.root, '', True)

# Recursive descent parser
class Parser:
    def __init__(self, tokenizer: TokenParser, tree: ParseTree = None) -> None:
        self.tk_gen = tokenizer
        self.token: Token = tokenizer.nextToken()
        if tree is not None:
            self.tree = tree
        else:
            self.tree = ParseTree()
    def getToken(self):
        self.token = self.tk_gen.nextToken()
    # Parse the outer level of a file.
    def parse_S(self):
        while self.token.type != TOKEN_TYPE.EOF:
            # print(self.token.type, self.token.value)
            if self.token.type == TOKEN_TYPE.KEYWORD:
                if self.token.value == "import":
                    self.getToken()
                    self.parse_IMPORT()
                elif self.token.value == "function":
                    self.getToken()
                    self.parse_FUNCTION()
                elif self.token.value == "global":
                    self.getToken()
                    self.parse_GLOBAL()
                elif self.token.value == "struct":
                    self.getToken()
                    self.parse_STRUCT()
                else:
                    raise ParserError("Expected struct, import, or function", self.tk_gen.getTokenLine())
            else:
                raise ParserError("Expected keyword", self.tk_gen.getTokenLine())
    def parse_IDENTIFIER(self):
        if self.token.type == TOKEN_TYPE.IDENTIFIER:
            self.tree.shift(self.token)
            self.getToken()
        else:
            raise ParserError("Expected identifier", self.tk_gen.getTokenLine())
    # Parse imports from other files.
    def parse_IMPORT(self):
        self.tree.push(Token(TOKEN_TYPE.IMPORT, self.tk_gen.getTokenLine()))
        self.parse_IDENTIFIER()

        if self.token.type == TOKEN_TYPE.STRING:
            self.tree.shift(self.token)
            self.getToken()
        else:
            raise ParserError("Expected string", self.tk_gen.getTokenLine())
        
        self.tree.pop()
    # Parse global statements
    def parse_GLOBAL(self):
        self.tree.push(Token(TOKEN_TYPE.GLOBAL, self.tk_gen.getTokenLine()))
        self.parse_IDENTIFIER()
        if self.token.type == TOKEN_TYPE.INT or self.token.type == TOKEN_TYPE.FLOAT or self.token.type == TOKEN_TYPE.STRING:
            self.tree.shift(self.token)
            self.getToken()
        self.tree.pop()
    # Parse set statements
    def parse_SET(self):
        self.tree.push(Token(TOKEN_TYPE.SET, self.tk_gen.getTokenLine()))
        self.parse_IDENTIFIER()
        self.parse_EXPRESSION()
        self.tree.pop()
    def parse_ALLOC(self):
        self.tree.push(Token(TOKEN_TYPE.ALLOC, self.tk_gen.getTokenLine()))
        self.parse_IDENTIFIER()
        self.parse_EXPRESSION()
        self.tree.pop()
    def parse_ARGLIST(self):
        if self.token.type != TOKEN_TYPE.PAREN_START:
            raise ParserError("Expected Opening Parenthesis", self.tk_gen.getTokenLine())
        
        self.getToken()

        self.tree.push(Token(TOKEN_TYPE.ARGLIST, self.tk_gen.getTokenLine()))

        while self.token.type == TOKEN_TYPE.IDENTIFIER:
            self.tree.shift(self.token)
            self.getToken()
        
        self.tree.pop()
        
        if self.token.type != TOKEN_TYPE.PAREN_END:
            raise ParserError("Expected Closing Parenthesis", self.tk_gen.getTokenLine())
        
        self.getToken()

    def parse_STRUCT(self):
        self.tree.push(Token(TOKEN_TYPE.STRUCT, self.tk_gen.getTokenLine()))
        self.parse_IDENTIFIER()
        self.parse_ARGLIST()
        self.tree.pop()

        # Todo: implement structs & arrays
        raise ParserError("Structs are a planned feature and have not been implemented yet!", self.tk_gen.getTokenLine())
    # Parse function statements.
    def parse_FUNCTION(self):
        self.tree.push(Token(TOKEN_TYPE.FUNCTION, self.tk_gen.getTokenLine()))
        self.parse_IDENTIFIER()

        self.parse_ARGLIST()

        self.parse_BLOCK()

        if self.token.type == TOKEN_TYPE.KEYWORD and self.token.value == 'returns':
            self.getToken()
            self.parse_IDENTIFIER()

        self.tree.pop()

    # Parse while loop.
    def parse_WHILE(self):
        self.tree.push(Token(TOKEN_TYPE.WHILE, self.tk_gen.getTokenLine()))
        self.parse_FUNCTION_CALL()
        self.parse_BLOCK()
        self.tree.pop()
    # Parse if statement.
    def parse_IF(self):
        self.tree.push(Token(TOKEN_TYPE.IF, self.tk_gen.getTokenLine()))
        self.tree.push(Token(TOKEN_TYPE.IF_COND, self.tk_gen.getTokenLine()))
        self.parse_FUNCTION_CALL()
        self.parse_BLOCK()
        self.tree.pop()
        while self.token.type == TOKEN_TYPE.KEYWORD:
            if self.token.value == 'elif':
                self.getToken()
                self.tree.push(Token(TOKEN_TYPE.IF_COND, self.tk_gen.getTokenLine()))
                self.parse_FUNCTION_CALL()
                self.parse_BLOCK()
                self.tree.pop()
            elif self.token.value == 'else':
                self.getToken()
                self.tree.push(Token(TOKEN_TYPE.ELSE_COND, self.tk_gen.getTokenLine()))
                self.parse_BLOCK()
                self.tree.pop()
            else:
                break
        
        self.tree.pop()

    # Parse for loop.
    def parse_FOR(self):
        self.tree.push(Token(TOKEN_TYPE.FOR, self.tk_gen.getTokenLine()))
        self.parse_IDENTIFIER()
        self.parse_FUNCTION_CALL()
        self.parse_FUNCTION_CALL()
        self.parse_BLOCK()
        self.tree.pop()
    # Parse an infinite loop.
    def parse_LOOP(self):
        self.tree.push(Token(TOKEN_TYPE.LOOP, self.tk_gen.getTokenLine()))
        self.parse_BLOCK()
        self.tree.pop()
    # Parse a block
    def parse_BLOCK(self):
        if self.token.type != TOKEN_TYPE.BLOCK_START:
            raise ParserError("Expected Block", self.tk_gen.getTokenLine())
        self.getToken()

        self.tree.push(Token(TOKEN_TYPE.BLOCK, self.tk_gen.getTokenLine()))

        while self.token.type != TOKEN_TYPE.BLOCK_END:
            if self.token.type == TOKEN_TYPE.KEYWORD:
                if self.token.value == 'set':
                    self.getToken()
                    self.parse_SET()
                elif self.token.value == 'alloc':
                    self.getToken()
                    self.parse_ALLOC()
                elif self.token.value == 'while':
                    self.getToken()
                    self.parse_WHILE()
                elif self.token.value == 'for':
                    self.getToken()
                    self.parse_FOR()
                elif self.token.value == 'loop':
                    self.getToken()
                    self.parse_LOOP()
                elif self.token.value == 'if':
                    self.getToken()
                    self.parse_IF()
                else:
                    raise ParserError("Expected statement", self.tk_gen.getTokenLine())
            elif self.token.type == TOKEN_TYPE.PAREN_START:
                self.parse_FUNCTION_CALL()
            else:
                raise ParserError("Expected statement or expression", self.tk_gen.getTokenLine())
        
        self.getToken()

        self.tree.pop()
    def parse_EXPRESSION(self):
        if self.token.type == TOKEN_TYPE.IDENTIFIER:
            self.parse_IDENTIFIER()
        elif self.token.type == TOKEN_TYPE.PAREN_START:
            self.parse_FUNCTION_CALL()
        elif self.token.type == TOKEN_TYPE.INT or self.token.type == TOKEN_TYPE.FLOAT or self.token.type == TOKEN_TYPE.STRING:
            self.tree.shift(self.token)
            self.getToken()
        else:
            raise ParserError(f"Unexpected {self.token.type}", self.tk_gen.getTokenLine())
    # Parse function
    def parse_FUNCTION_CALL(self):
        if self.token.type != TOKEN_TYPE.PAREN_START:
            raise ParserError("Expected Function Start", self.tk_gen.getTokenLine())
        self.getToken()

        self.tree.push(Token(TOKEN_TYPE.FUNCTION_CALL, self.tk_gen.getTokenLine()))

        self.parse_IDENTIFIER()

        self.tree.push(Token(TOKEN_TYPE.ARGLIST, self.tk_gen.getTokenLine()))
        while self.token.type != TOKEN_TYPE.PAREN_END:
            self.parse_EXPRESSION()
        
        self.getToken()
        self.tree.pop()

        self.tree.pop()

def toStr(*a):
    return [ str(_a) for _a in a ]

class Function:
    def getSignature(self) -> Tuple[str, List[str], bool]: # Bool = last arg can be repeated
        raise NotImplementedError
    def compile(self, destReg: int, argRegs: List[int]) -> str:
        raise NotImplementedError

class SetFunction(Function):
    def __init__(self, name: str = "SET") -> None:
        self.name = name
    def compile(self, destReg: int, argRegs: List[int]) -> str:
        return ' '.join(toStr("   ", self.name, destReg, argRegs[0]))
    def getSignature(self) -> Tuple[str, List[str], bool]:
        return ("int", [], False)

class JumpFunction(Function):
    def __init__(self, tag: str, cond: bool = False) -> None:
        self.tag = tag
        self.cond = cond
    def compile(self, destReg: int, argRegs: List[int]) -> str:
        if self.cond:
            return ' '.join(toStr("    CJMP", argRegs[0], self.tag))
        else:
            return ' '.join(toStr("    JMP", self.tag))
    def getSignature(self) -> Tuple[str, List[str], bool]:
        return ("", ["int"], False) if self.cond else ("", [], False)

class VoidFunction(Function):
    def __init__(self, name: str) -> None:
        self.name = name
    def compile(self, destReg: int, argRegs: List[int]) -> str:
        return ' '.join(toStr("   ", self.name))
    def getSignature(self) -> Tuple[str, List[str], bool]:
        return ("", [], False)

class VoidIntFunction(Function):
    def __init__(self, name: str, argLen: int = 1) -> None:
        self.name = name
    def compile(self, destReg: int, argRegs: List[int]) -> str:
        return ' '.join(toStr("   ", self.name, argRegs[0]))
    def getSignature(self) -> Tuple[str, List[str], bool]:
        return ("", ["int"], False)

class VoidInt3Function(Function):
    def __init__(self, name: str) -> None:
        self.name = name
    def compile(self, destReg: int, argRegs: List[int]) -> str:
        return ' '.join(toStr("   ", self.name, argRegs[0], argRegs[1], argRegs[2]))
    def getSignature(self) -> Tuple[str, List[str], bool]:
        return ("", ["int", "int", "int"], False)

class UnaryIntFunction(Function):
    def __init__(self, name: str = None, rev: bool = False) -> None:
        self.name = name
    def compile(self, destReg: int, argRegs: List[int]) -> str:
        if self.name is None:
            if destReg == argRegs[0]: return ''
            else:
                return ' '.join(toStr("    MOV", destReg, argRegs[0]))
        else:
            if destReg == argRegs[0]:
                return ' '.join(toStr("   ", self.name, destReg))
            else:
                return ' '.join(toStr("    MOV", destReg, argRegs[0])) + '\n' + ' '.join(toStr("   ", self.name, destReg))
    def getSignature(self) -> Tuple[str, List[str], bool]:
        return ("int", ["int"], False)

# Because there are a lot of these
class BinaryIntFunction(Function):
    def __init__(self, name: str, rev: bool = False) -> None:
        self.name = name
        self.rev = rev
    def compile(self, destReg: int, argRegs: List[int]) -> str:
        if self.rev:
            return ' '.join(toStr("   ", self.name, destReg, argRegs[1], argRegs[0]))
        else:
            return ' '.join(toStr("   ", self.name, destReg, argRegs[0], argRegs[1]))
    def getSignature(self) -> Tuple[str, List[str], bool]:
        return ("int", ["int","int"], False)

class NnaryIntFunction(Function):
    def __init__(self, name: str) -> None:
        self.name = name
    def compile(self, destReg: int, argRegs: List[int]) -> str:
        a = [ ' '.join(toStr("   ", self.name, destReg, argRegs[0], argRegs[1])) ]
        for i in range(2, len(argRegs), 1):
            a.append(' '.join(toStr("   ", self.name, destReg, destReg, argRegs[i])))
        return '\n'.join(a)
    def getSignature(self) -> Tuple[str, List[str], bool]:
        return ("int", ["int","int"], True)

class GetStrPairFunction(Function):
    def compile(self, destReg: int, argRegs: List[int]) -> str:
        a = []
        if destReg != argRegs[0]:
            a.append(' '.join(toStr("    MOV", destReg, argRegs[0])))
        a.append(' '.join(toStr("    ADD", destReg, destReg, argRegs[1])))
        a.append(' '.join(toStr("    LD", destReg)))
        return '\n'.join(a)
    def getSignature(self) -> Tuple[str, List[str], bool]:
        return ("int", ["str", "int"], False)

def GetVariableType(var: str):
    vname = var.split('.')[-1]
    if '_' not in vname:
        return ''
    return vname.split('_')[0]

# Computes the actual name of the variable
def GetVariableName(var: str):
    pass

class UserFunction(Function):
    def __init__(self, function: "CompileKernelFunctionBuilder") -> None:
        self.name = function.imports.getTaggedName(function.base.children[0].token.value)
        self.sig = (function.returns, [ GetVariableType(v) for v in function.args ], False)
        self.function = function
    def compile(self, destReg: int, argRegs: List[int]) -> str:
        a = [  ]
        for i, arg in enumerate(argRegs):
            if i + self.function.offset != arg:
                a.append(f"MOV {i + self.function.offset} {arg}")
        a.reverse()
        a.append(f"CALL __FCALL_{self.name}")
        if self.sig[0] != "":
            ret_pos = self.function.getReturnReg() + self.function.offset
            if destReg != ret_pos:
                a.append(f"MOV {destReg} {ret_pos}")
        return '    '+'\n    '.join(a)
    def getSignature(self) -> Tuple[str, List[str], bool]:
        return self.sig


# Todo
class Compiler:
    def __init__(self, tree: ParseTree) -> None:
        self.tree = tree
        self.output = ''
    def compile(self) -> str:
        self.output = __LISP_ASM_HEADER

# Keeps trace of which variables are which.
class KernelCompilerGlobalVars:
    def __init__(self) -> None:
        self.scope = {}
        self.counter = 0

        self.globalInit = []
        self.string_consts = []
        self.global_str_count = 0
        self.str_map: Dict[str, str] = {}

    # Returns the register to use for this variable
    def newGlobal(self, name: str, value: Optional[int] = None) -> int:
        if name not in self.scope:
            self.scope[name] = self.counter
            if value is not None:
                self.globalInit.append(f"    SET {name} {value}\n")
            self.counter += 1
        return self.scope[name]
    
    def constString(self, data: str) -> str:
        if data in self.str_map:
            return self.str_map[data]
        name = f"__STR_CONST_{self.global_str_count}"
        self.global_str_count += 1
        d_san = data.replace('\\', '\\\\').replace('\0', '\\0').replace('\n', '\\n').replace('\t', '\\t').replace('\'', '\\\'').replace('\"', '\\\"')
        self.string_consts.append(f'{name}:\n    .TEXT "{d_san}"')
        return name
    
    def isGlobal(self, name: str) -> bool:
        return name in self.scope

class LocalScopeTracker:
    def __init__(self, globals: KernelCompilerGlobalVars) -> None:
        self.gl = globals
        self.regStack = []
        self.locals = []
        self.regTop = 0
        #self.maxReg = 0
    def tempPush(self):
        self.regStack.append(self.regTop)
    def tempPop(self):
        self.regTop = self.regStack.pop()
    def tempAlloc(self) -> int:
        rt = self.regTop
        self.regTop += 1
        #self.maxReg = max(self.maxReg, rt)
        return rt
    def isGlobal(self, name: str) -> bool:
        return self.gl.isGlobal(name)
    def newLocal(self, name: str) -> int:
        if len(self.regStack) > 0:
            raise Exception()
        if name not in self.locals:
            self.locals.append(name)
            return self.tempAlloc()
        else:
            return self.getLocal(name)
    def getLocal(self, name: str) -> int:
        return self.locals.index(name)
    def getGlobal(self, name: str) -> int:
        return self.gl.scope[name]

class CompileKernelTreeNode:
    def __init__(self, size: int, deps: List[str]) -> None:
        self.size = size
        self.deps = deps
        self.minReg = 0

"""
class CompileKernelFunctionCallBuilder:
    def __init__(self, base: ParseNode, functions: Dict[str, BinaryIntFunction], scope: LocalScopeTracker) -> None:
        if base.token.type == TOKEN_TYPE.FUNCTION_CALL:
            self.type = 0
            arglist = base.children[1].children
            self.children = [ CompileKernelFunctionCallBuilder(child, functions, scope) for child in arglist ]
            lens = [ c.regCount for c in self.children ]
            lens.sort(reverse=True)
            self.regCount = max([ len(arglist) ] + [ l + i for i, l in enumerate(lens) ])
            self.value = base.children[0].token.value
        elif base.token.type == TOKEN_TYPE.IDENTIFIER:
            self.regCount = 0
            self.children = []
            self.type = 1
            vname = base.token.value
            if not scope.exists(vname):
                raise ParserError(f"Unknown identifier {vname}", base.token.line)
            self.value = scope.getReg(vname)
        elif base.token.type == TOKEN_TYPE.INT:
            self.regCount = 1
            self.type = 2
            self.value: int = base.token.value
        elif base.token.type == TOKEN_TYPE.STRING:
            self.regCount = 0
            self.type = 3
            # self.value =  # Todo: figure out how to calculate this
        else:
            raise ParserError(base.token.type, -1)
"""

class CompileKernelPartialVar:
    def __init__(self, index: int, relative: bool = True) -> None:
        self.index = index
        self.relative = relative
    def get(self, offset: int):
        return (offset + self.index) if self.relative else self.index

class CompileKernelInstruction:
    def __init__(self, baseF: "CompileKernelFunctionBuilder", f: Function, args: List[CompileKernelPartialVar]) -> None:
        self.function = f
        self.args = args
        self.outputReg = CompileKernelPartialVar(0)
        self.baseF = baseF
    def output(self):
        return self.function.compile(self.outputReg.get(self.baseF.offset), [ a.get(self.baseF.offset) for a in self.args ])

class CompileKernelLiteral:
    def __init__(self, v: str) -> None:
        self.v = v
    def output(self):
        return self.v

class CompileKernelFunctionBuilderDep:
    def __init__(self, child: "CompileKernelFunctionBuilder", offset: int) -> None:
        self.child = child
        self.offset = offset

class CompileKernelImportTree:
    def __init__(self) -> None:
        self.importOrder = []
        self.tree: Dict[str, Dict[str, str]] = {}
    def newImport(self, importPath: str) -> None:
        self.importOrder.append(importPath)
        self.tree[importPath] = {}
    def link(self, start: str, end: str, name: str) -> None:
        self.tree[start][name] = end
    def getTaggedName(self, start: str, var: str) -> str:
        if '.' in var:
            i = var.index('.')
            return self.getTaggedName(self.tree[start][var[0:i]],var[i+1:])
        else:
            return str(self.importOrder.index(start)) + '_' + var

class CompileKernelImportTreeNode:
    def __init__(self, tree: CompileKernelImportTree, fp: str) -> None:
        self.tree = tree
        self.fp = fp
    def getTaggedName(self, var: str) -> str:
        return self.tree.getTaggedName(self.fp, var)
    def link(self, end: str, name: str) -> None:
        self.tree.link(self.fp, end, name)

class CompileKernelFunctionBuilder:
    def __init__(self, base: ParseNode, functions: Dict[str, Function], scope: LocalScopeTracker, imports: CompileKernelImportTreeNode) -> None:
        if base.token.type != TOKEN_TYPE.FUNCTION:
            raise ParserError("Yo, wut. Call this on a function node you nark", -1)

        self.insList: List[CompileKernelInstruction] = []
        self.regs = 0

        self.functions = functions
        self.scope = scope

        self.offset = scope.gl.counter
        self.base = base

        self.imports = imports

        # Construct positions for the return values and the arguments
        if len(base.children) == 4:
            self.returns = GetVariableType(base.children[3].token.value)
        else:
            self.returns = ""
        
        # Construct argument list
        for a in base.children[1].children:
            self.scope.newLocal(a.token.value)
        self.args = [ a.token.value for a in base.children[1].children ]

        self.deps: Set[CompileKernelFunctionBuilderDep] = set()

        self.constructed = False

    def getReturnReg(self):
        return self.scope.getLocal(self.base.children[3].token.value)

    # Building the function
    def construct(self, offset: int, userFunctions: Dict[str, "CompileKernelFunctionBuilder"]):
        self.offset = max(offset, self.offset)

        if not self.constructed:
            self.BLOCK(self.base.children[2], userFunctions)
            self.constructed = True
    
    def getReturnType(self, node: ParseNode, userFunctions: Dict[str, "CompileKernelFunctionBuilder"]):
        if node.token.type == TOKEN_TYPE.FUNCTION_CALL:
            fname, f = self.getFunction(node.children[0].token.value, userFunctions)
            ret, _, _ = f.getSignature()
            return ret
        elif node.token.type == TOKEN_TYPE.INT:
            return 'int'
        elif node.token.type == TOKEN_TYPE.STRING:
            return 'str'
        elif node.token.type == TOKEN_TYPE.IDENTIFIER:
            return GetVariableType(node.token.value)
        
        raise ParserError(f"What {node.token.type.name}", -1)

    def BLOCK(self, base: ParseNode, userFunctions: Dict[str, "CompileKernelFunctionBuilder"]):
        global _IF_IDENT_CTR    
        global _LOOP_IDENT_CTR

        if base.token.type != TOKEN_TYPE.BLOCK:
            raise ParserError("Bruh4", -1)

        for child in base.children:
            if child.token.type == TOKEN_TYPE.FUNCTION_CALL:
                # Make sure that we intend to discard the function return
                ret_type = self.getReturnType(child.children[0], userFunctions)
                if ret_type != '':
                    raise ParserError(f"Discarded return value", child.children[-1].token.line)
                self.FUNCTION_CALL(child, userFunctions)
            elif child.token.type == TOKEN_TYPE.SET:
                token = child.children[1].token
                if token.type == TOKEN_TYPE.FUNCTION_CALL:
                    ret_type = self.getReturnType(child.children[1], userFunctions)
                    c = self.FUNCTION_CALL(child.children[1], userFunctions)
                    if c is None:
                        raise ParserError(f"Expected return value", token.line)
                    name = child.children[0].token.value
                    if GetVariableType(name) != ret_type:
                        raise ParserError(f'Cannot assign type {ret_type} to {GetVariableType(name)}', child.children[0].token.line)
                    if self.scope.isGlobal(name):
                        c.index = self.scope.getGlobal(name)
                        c.relative = False
                    else:
                        c.index = self.scope.newLocal(name)
                elif token.type == TOKEN_TYPE.INT:
                    ins = CompileKernelInstruction(self, self.functions["__INT"], [ CompileKernelPartialVar(token.value, False) ])
                    c = ins.outputReg
                    self.insList.append(ins)
                    name = child.children[0].token.value
                    if GetVariableType(name) != 'int':
                        raise ParserError(f'Incorrect variable type "{GetVariableType(name)}"', child.children[0].token.line)
                    if self.scope.isGlobal(name):
                        c.index = self.scope.getGlobal(name)
                        c.relative = False
                    else:
                        c.index = self.scope.newLocal(name)
                elif token.type == TOKEN_TYPE.IDENTIFIER:
                    name = child.children[0].token.value
                    name2 = child.children[1].token.value
                    if self.scope.isGlobal(name2):
                        ins = CompileKernelInstruction(self, self.functions["__MOV"], [
                            CompileKernelPartialVar(self.scope.getGlobal(name2), False)
                        ])
                    else:
                        ins = CompileKernelInstruction(self, self.functions["__MOV"], [
                            CompileKernelPartialVar(self.scope.getLocal(name2))
                        ])
                    c = ins.outputReg
                    self.insList.append(ins)
                    if GetVariableType(name) != GetVariableType(name2):
                        raise ParserError(f'Incorrect variable type "{GetVariableType(name)}"', child.children[0].token.line)
                    if self.scope.isGlobal(name):
                        c.index = self.scope.getGlobal(name)
                        c.relative = False
                    else:
                        c.index = self.scope.newLocal(name)
                else:
                    raise ParserError("Bruh3", 1)
            
            elif child.token.type == TOKEN_TYPE.IF:
                if_id = _IF_IDENT_CTR
                _IF_IDENT_CTR += 1
                
                if_ctr = 0

                for i, val in enumerate(child.children):
                    if val.token.type == TOKEN_TYPE.IF_COND:
                        ret_type = self.getReturnType(val.children[0], userFunctions)
                        if ret_type != "int":
                            raise ParserError(f"If condition must evaluate to an integer", val.token.line)
                        
                        self.scope.tempPush()
                        c = self.FUNCTION_CALL(val.children[0], userFunctions)
                        c.index = self.scope.tempAlloc()
                        self.insList.append(CompileKernelInstruction(self, JumpFunction(f"__IF_{if_id}_C{i}_BODY", True), [c]))
                        self.scope.tempPop()
                        
                        if_ctr += 1
                    else: # ELSE_COND
                        self.BLOCK(child.children[-1].children[0], userFunctions)
                
                self.insList.append(CompileKernelInstruction(self, JumpFunction(f"__IF_{if_id}_END"), []))
            
                for i, val in enumerate(child.children):
                    if val.token.type == TOKEN_TYPE.IF_COND:
                        self.insList.append(CompileKernelLiteral(f"__IF_{if_id}_C{i}_BODY:"))
                        self.BLOCK(val.children[1], userFunctions)
                        if i < if_ctr - 1:
                            self.insList.append(CompileKernelInstruction(self, JumpFunction(f"__IF_{if_id}_END"), []))
                
                self.insList.append(CompileKernelLiteral(f"__IF_{if_id}_END:"))

            elif child.token.type == TOKEN_TYPE.WHILE:
                loop_id = _LOOP_IDENT_CTR
                _LOOP_IDENT_CTR += 1
                
                ret_type = self.getReturnType(child.children[0], userFunctions)
                if ret_type != "int":
                    raise ParserError(f"While condition must evaluate to an integer", child.token.line)
                    
                self.insList.append(CompileKernelInstruction(self, JumpFunction(f"__LOOP_{loop_id}_EVAL"), []))
                self.insList.append(CompileKernelLiteral(f"__LOOP_{loop_id}_BODY:"))
                self.BLOCK(child.children[1], userFunctions)
                self.insList.append(CompileKernelLiteral(f"__LOOP_{loop_id}_EVAL:"))
                self.scope.tempPush()
                c = self.FUNCTION_CALL(child.children[0], userFunctions)
                c.index = self.scope.tempAlloc()
                self.insList.append(CompileKernelInstruction(self, JumpFunction(f"__LOOP_{loop_id}_BODY", True), [c]))
                self.scope.tempPop()
            
            elif child.token.type == TOKEN_TYPE.LOOP:
                loop_id = _LOOP_IDENT_CTR
                _LOOP_IDENT_CTR += 1
                
                self.insList.append(CompileKernelLiteral(f"__LOOP_{loop_id}_BODY:"))
                self.BLOCK(child.children[0], userFunctions)
                self.insList.append(CompileKernelInstruction(self, JumpFunction(f"__LOOP_{loop_id}_BODY"), []))

            elif child.token.type == TOKEN_TYPE.FOR:
                loop_id = _LOOP_IDENT_CTR
                _LOOP_IDENT_CTR += 1
                
                vname = child.children[0].token.value
                if GetVariableType(vname) != "int":
                    raise ParserError(f"For loop variable must be an integer", child.token.line)
                
                if vname not in self.scope.locals:
                    ins = CompileKernelInstruction(self, self.functions['__INT'], [CompileKernelPartialVar(0, False)])
                    ins.outputReg.index = self.scope.newLocal(vname)
                    self.insList.append(ins)

                ret_type = self.getReturnType(child.children[1], userFunctions)
                if ret_type != "int":
                    raise ParserError(f"If condition must evaluate to an integer", child.token.line)
                ret_type = self.getReturnType(child.children[2], userFunctions)
                if ret_type != "int":
                    raise ParserError(f"If generator must evaluate to an integer", child.token.line)
                
                self.insList.append(CompileKernelInstruction(self, JumpFunction(f"__LOOP_{loop_id}_EVAL"), []))
                
                self.insList.append(CompileKernelLiteral(f"__LOOP_{loop_id}_BODY:"))
                self.BLOCK(child.children[3], userFunctions)
                c = self.FUNCTION_CALL(child.children[2], userFunctions)
                c.index = self.scope.getLocal(vname)

                self.insList.append(CompileKernelLiteral(f"__LOOP_{loop_id}_EVAL:"))
                self.scope.tempPush()
                c = self.FUNCTION_CALL(child.children[1], userFunctions)
                c.index = self.scope.tempAlloc()
                self.scope.tempPop()
                self.insList.append(CompileKernelInstruction(self, JumpFunction(f"__LOOP_{loop_id}_BODY", True), [c]))

            else:
                raise ParserError("Bruh2", 1)

    def getFunction(self, fname: str, userFunctions) -> Tuple[str, Function]:
        if fname in self.functions:
            return fname, self.functions[fname]
        else:
            fname = self.imports.getTaggedName(fname)
            return fname, UserFunction(userFunctions[fname])

    def FUNCTION_CALL(self, base: ParseNode, userFunctions: Dict[str, "CompileKernelFunctionBuilder"]) -> Optional[CompileKernelPartialVar]:
        reg: CompileKernelPartialVar = None
        if base.token.type == TOKEN_TYPE.FUNCTION_CALL:
            self.scope.tempPush()
            # Todo: pick compute order smartly
            fname, f = self.getFunction(base.children[0].token.value, userFunctions)
            args = base.children[1].children

            _, sig_a, sig_rep = f.getSignature()

            a = []
            if (not sig_rep and len(args) > len(sig_a)) or len(args) < len(sig_a):
                raise ParserError(f"Incorrect number of arguments! " +
                    f"Expected {str(len(sig_a))+'+' if sig_rep else len(sig_a)} got {len(args)}", base.token.line)

            for i, arg in enumerate(args):
                arg_sig = sig_a[min(i, len(sig_a) - 1)]
                if arg.token.type == TOKEN_TYPE.FUNCTION_CALL:
                    ins: CompileKernelPartialVar = self.FUNCTION_CALL(arg, userFunctions)
                    if ins is None:
                        raise ParserError(f"Expected return value", arg.token.line)
                    _, f_ret_type = self.getFunction(arg.children[0].token.value, userFunctions)
                    if f_ret_type.getSignature()[0] != arg_sig:
                        raise ParserError(f"Incorrect argument type. Expected {arg_sig} got {f_ret_type.getSignature()[0]}", arg.token.line)
                    ins.index = self.scope.tempAlloc()
                    a.append(ins)
                elif arg.token.type == TOKEN_TYPE.INT:
                    if 'int' != arg_sig:
                        raise ParserError(f"Incorrect argument type. Expected {arg_sig} got int", arg.token.line)
                    ins = CompileKernelInstruction(self, self.functions["__INT"], [ CompileKernelPartialVar(arg.token.value, False) ])
                    self.insList.append(ins)
                    reg = ins.outputReg
                    reg.index = self.scope.tempAlloc()
                    a.append(reg)
                elif arg.token.type == TOKEN_TYPE.IDENTIFIER:
                    if self.scope.isGlobal(arg.token.value):
                        a.append(CompileKernelPartialVar(self.scope.getGlobal(arg.token.value), False))
                    else:
                        a.append(CompileKernelPartialVar(self.scope.getLocal(arg.token.value)))
                elif arg.token.type == TOKEN_TYPE.STRING:
                    if 'str' != arg_sig:
                        raise ParserError(f"Incorrect argument type. Expected {arg_sig} got str", arg.token.line)
                    ins = CompileKernelInstruction(self, self.functions["__INT"], [
                        CompileKernelPartialVar(self.scope.gl.constString(arg.token.value), False)
                    ])
                    self.insList.append(ins)
                    reg = ins.outputReg
                    reg.index = self.scope.tempAlloc()
                    a.append(reg)
                else:
                    raise ParserError("Bruh4", -1)
            self.scope.tempPop()
            
            if fname not in self.functions:
                self.deps.add(userFunctions[fname])
                userFunctions[fname].construct(self.offset + self.scope.regTop, userFunctions)
            ins = CompileKernelInstruction(self, f, a)
            reg = ins.outputReg
            self.insList.append(ins)
        else:
            raise ParserError("Bruh", 1)
        return reg

    def compile(self, isInterrupt: bool = False) -> str:
        a = [ dep.compile() for dep in self.deps ]
        if isInterrupt:
            a.append(f"""
{self.base.children[0].token.value}:
""" + '\n'.join([i.output() for i in self.insList]) + "\n    RETI")
        else:
            a.append(f"""
__FCALL_{self.imports.getTaggedName(self.base.children[0].token.value)}:
""" + '\n'.join([i.output() for i in self.insList]) + "\n    RET")
        return '\n'.join(a)

class CompileKernelTree:
    def __init__(self) -> None:
        self.functions: Dict[str, CompileKernelTreeNode] = {}
    def createFunction(self, name: str, space: int, deps: List[str]) -> None:
        self.functions[name] = CompileKernelTreeNode(space, deps)
    def generateRegisters(self, base: str, stack: List[str]) -> None:
        if base in stack:
            raise ParserError(f"Function {base} cannot be called recursively!", -1)
        self.functions[base].minReg = max(self.functions[base].minReg, sum(self.functions[s].size for s in stack))
        stack2 = stack + [base]
        for f in self.functions[base].deps:
            self.generateRegisters(f, stack2)
    def getRegOffset(self, fname: str) -> None:
        return self.functions[fname].minReg
    @staticmethod
    def findAllFunctionDeps(node: ParseNode, fs: Set[str]) -> None:
        o = []
        if node.token.type == TOKEN_TYPE.FUNCTION_CALL:
            v = node.children[0].token.value
            if v in fs:
                o.append(v)
        for child in node.children:
            o += CompileKernelTree.findAllFunctionDeps(child, fs)
        return o
    @staticmethod
    def compilePartialBytecode(node: ParseNode) -> None:
        if node.token.type != TOKEN_TYPE.FUNCTION:
            raise "BRUH"

class CompileKernelMode:
    
    __DECLARED_FUNCTIONS = {
        "+": NnaryIntFunction("ADD"),
        "-": BinaryIntFunction("SUB"),
        "*": NnaryIntFunction("LMUL"),
        "/": BinaryIntFunction("DIV"),
        "&": NnaryIntFunction("AND"),
        "&&": NnaryIntFunction("BAND"),
        "|": NnaryIntFunction("OR"),
        "||": NnaryIntFunction("BOR"),
        "^": NnaryIntFunction("XOR"),
        ">": BinaryIntFunction("GTR"),
        ">=": BinaryIntFunction("GTEQ"),
        "<": BinaryIntFunction("GTR", True),
        "<=": BinaryIntFunction("GTEQ", True),
        ">>": BinaryIntFunction("RSHIFT"),
        "<<": BinaryIntFunction("LSHIFT"),
        "=": BinaryIntFunction("EQ"),
        "__INT": SetFunction(),
        "__SET": SetFunction(),
        "__MOV": SetFunction("MOV"),
        "RAISE": VoidIntFunction("RAISE"),
        "PRINTH": VoidIntFunction("PRINTH"),
        "PRINTL": VoidIntFunction("PRINTL"),
        "PUSH": VoidIntFunction("PUSH"),
        "POP": VoidIntFunction("POP"),
        "LOCK": VoidIntFunction("LOCK"),
        "UNLOCK": VoidIntFunction("UNLOCK"),
        "USRADDR": UnaryIntFunction("USR_ADDR"),
        "EXTFETCH": VoidInt3Function("EXTFETCH"),
        "EXTWRITE": VoidInt3Function("EXTWRITE"),
        "PRINTFLUSH": VoidFunction("PRINTFLUSH"),
        "++": UnaryIntFunction("INC"),
        "i": UnaryIntFunction(),
        "--": UnaryIntFunction("DEC"),
        "GetStrPair": GetStrPairFunction(),
    }

    __LISP_ASM_KERNEL_INTERRUPTS = [
        "0_init",
        "0_TimerTick",
        "0_BadMemAccess",
        "0_StackOverflow",
        "0_StackUnderflow",
        "0_BadIns",
        "0_FailedExtAccess",
        "0_UserDefined1",
        "0_UserDefined2",
        "0_UserDefined3",
        "0_UserDefined4",
        "0_UserDefined5",
        "0_UserDefined6",
        "0_UserDefined7",
        "0_UserDefined8",
        "0_UserDefined9",
        "0_UserDefined10",
    ]

    __IMPORT_DEPTH = 1
    __IMPORT_FILES: Dict[str, int] = {}

    def __init__(self, tree: ParseTree, filePath: str, imports: CompileKernelImportTree = None) -> None:
        self.tree = tree
        self.output = ''
        self.vars = KernelCompilerGlobalVars()

        self.importTag = str(CompileKernelMode.__IMPORT_DEPTH) + '_'
        CompileKernelMode.__IMPORT_DEPTH += 1

        self.filePath = filePath

        if imports is None:
            self.imports = CompileKernelImportTree()
            self.imports.newImport('KERNEL')
            self.imports.newImport(filePath)
        else:
            self.imports = imports
            self.imports.newImport(filePath)
        
        self.compNode = CompileKernelImportTreeNode(self.imports, self.filePath)

        # Compile each function
        self.FUNCTION_LIST: Dict[str, CompileKernelFunctionBuilder] = {}

    def initGlobals(self) -> "CompileKernelMode":
        self.vars.newGlobal("0_int_UserReg0")
        self.vars.newGlobal("0_int_UserReg1")
        self.vars.newGlobal("0_int_UserReg2")
        self.vars.newGlobal("0_int_UserReg3")
        self.vars.newGlobal("0_int_UserReg4")
        self.vars.newGlobal("0_int_UserReg5")
        self.vars.newGlobal("0_int_UserReg6")
        self.vars.newGlobal("0_int_UserReg7")
        self.vars.newGlobal("0_int_UserReg8")
        self.vars.newGlobal("0_int_UserReg9")
        self.vars.newGlobal("0_int_UserRegA")
        self.vars.newGlobal("0_int_UserRegB")
        self.vars.newGlobal("0_int_UserRegC")
        self.vars.newGlobal("0_int_UserRegD")
        self.vars.newGlobal("0_int_UserRegE")
        self.vars.newGlobal("0_int_UserRegF")
        
        self.vars.newGlobal("0_int_PageStackSize")
        self.vars.newGlobal("0_int_StackSize")
        self.vars.newGlobal("0_int_ExtBufferIn")
        self.vars.newGlobal("0_int_ExtBufferOut")
        self.vars.newGlobal("0_int_AluStatus")
        self.vars.newGlobal("0_int_ExtDevices")
        self.vars.newGlobal("0_int_LastUserIns")

        return self

    def compile(self) -> "CompileKernelMode":
        self.output = ""

        # Initialize globals
        for node in self.tree.root.children:
            if node.token.type == TOKEN_TYPE.GLOBAL:
                if len(node.children) == 1:
                    self.vars.newGlobal(node.children[0].token.value)
                else:
                    if node.children[1].token.type == TOKEN_TYPE.INT:
                        self.vars.newGlobal(node.children[0].token.value, node.children[1].token.value)
                    elif node.children[1].token.type == TOKEN_TYPE.STRING:
                        sVal = self.vars.constString(node.children[1].token.value)
                        self.vars.newGlobal(node.children[0].token.value, sVal)

        # ALL_F = set( node.children[0].token.value for node in self.tree.root.children if node.token.type == TOKEN_TYPE.FUNCTION )

        basePath = os.path.dirname(self.filePath)
        for node in self.tree.root.children:
            if node.token.type == TOKEN_TYPE.IMPORT:
                # Parse the path to see if this is an stlib
                path = node.children[1].token.value
                prefix = node.children[0].token.value
                
                if '.' in prefix:
                    raise ParserError(f"Invalid import name {prefix}", node.token.line)

                if '.' not in path:
                    path = 'lisp_stl/' + path + '.lispp'
                
                fullPath = os.path.abspath(os.path.join(basePath, path))
                if fullPath not in CompileKernelMode.__IMPORT_FILES:
                    with open(fullPath) as f:
                        token_parser = TokenParser(f.read())
                    
                    parser = Parser(token_parser)
                    parser.parse_S()
                    parser.tree.print()

                    imported = CompileKernelMode(parser.tree, fullPath, self.imports)
                    
                    self.compNode.link(fullPath, prefix)

                    imported.vars = self.vars
                    imported.FUNCTION_LIST = self.FUNCTION_LIST
                    CompileKernelMode.__IMPORT_FILES[fullPath] = CompileKernelMode.__IMPORT_DEPTH
                    imported.compile()
        
        for node in self.tree.root.children:
            if node.token.type == TOKEN_TYPE.FUNCTION:
                # Compile the function
                # deps = CompileKernelTree.findAllFunctionDeps(node, ALL_F)
                builder = CompileKernelFunctionBuilder(node, CompileKernelMode.__DECLARED_FUNCTIONS, LocalScopeTracker(self.vars), self.compNode)

                self.FUNCTION_LIST[self.imports.getTaggedName(self.filePath, node.children[0].token.value)] = builder

        return self
        
    def buildAsm(self) -> "CompileKernelMode":
        
        if '1_main' not in self.FUNCTION_LIST:
            raise ParserError(f"Could not find main function", -1)
        __MAIN = self.FUNCTION_LIST['1_main']

        if len(__MAIN.base.children[1].children) > 0:
            raise ParserError(f"Main function must have at least one ", -1)

        __MAIN.construct(self.vars.counter, self.FUNCTION_LIST)

        interrupts = [
            (i if i in self.FUNCTION_LIST else '0_defaultInterrupt')
            for i in CompileKernelMode.__LISP_ASM_KERNEL_INTERRUPTS
        ]
        interrupts[0] = '0_init'

        self.output = '\n    ' + '\n    '.join(f"JMP {i}" for i in interrupts)
        self.output += '\n\n0_init:\n' + ''.join(self.vars.globalInit) + '    CALL __FCALL_main\n    SHUTDOWN 0\n'

        for interrupt in interrupts:
            if interrupt in self.FUNCTION_LIST:
                self.FUNCTION_LIST[interrupt].construct(self.vars.counter, self.FUNCTION_LIST)

        for interrupt in interrupts:
            if interrupt in self.FUNCTION_LIST:
                self.output += self.FUNCTION_LIST[interrupt].compile(True)

        if '0_defaultInterrupt' not in self.FUNCTION_LIST:
            self.output += """\n0_defaultInterrupt:
    RETI\n"""

        self.output += __MAIN.compile()
        
        self.output += '\n' + '\n'.join(self.vars.string_consts)

        CompileKernelMode.__IMPORT_DEPTH = 1
        CompileKernelMode.__IMPORT_FILES = {}

        return self

if __name__ == "__main__":
    FULL_PATH = os.path.abspath('test.lispp')

    with open(FULL_PATH) as f:
        tsp = TokenParser(f.read())
    print("Parsing program:")
    print('-----------------------')
    print(tsp.digest)
    print('-----------------------')
    parser = Parser(tsp)
    try:
        parser.parse_S()
        print('\nParse tree:')
        parser.tree.print()

        ckm = CompileKernelMode(parser.tree, FULL_PATH).initGlobals().compile().buildAsm()
        print("Generated asm")
        print("------------------------")
        print(ckm.output)
    except ParserError as e:
        print(e)

