# A python implementation of a compiler for lisp, because python is just faster for development cycles and I don't care about compile times :P

from lib2to3.pgen2 import token
from typing import Dict, Set, Union, List
from enum import Enum, unique
from typing import Optional
from unicodedata import name


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
        if self.index > 0 and self.digest[self.index] == '\n':
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

    # Parse for loop.
    def parse_WHILE(self):
        self.tree.push(Token(TOKEN_TYPE.WHILE, self.tk_gen.getTokenLine()))
        self.parse_IDENTIFIER()
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

class Function:
    def compile(self, destReg: int, argRegs: List[int]) -> str:
        raise NotImplementedError

class SetFunction(Function):
    def compile(self, destReg: int, argRegs: List[int]) -> str:
        return ' '.join("    SET", destReg, argRegs[0])

# Because there are a lot of these
class BinaryIntFunction(Function):
    def __init__(self, name: str, rev: bool = False) -> None:
        self.name = name
        self.rev = rev
    def compile(self, destReg: int, argRegs: List[int]) -> str:
        if self.rev:
            return ' '.join("   ", self.name, destReg, argRegs[1], argRegs[0])
        else:
            return ' '.join("   ", self.name, destReg, argRegs[0], argRegs[1])

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

        self.globalDefs = []
        self.globalInit = []
        self.string_consts = []
    # Returns the register to use for this variable
    def newGlobal(self, name: str, value: Optional[int] = None) -> int:
        if name not in self.scope:
            self.scope[name] = self.counter
            self.globalDefs.append(f"    .ALIAS {name} {self.counter}")
            if value is not None:
                self.globalInit.append(f"    SET {name} {value}")
            self.counter += 1
        return self.scope[name]
    
    def constString(self, name: str, data: str) -> str:
        d_san = data.replace('\\', '\\\\').replace('\0', '\\0').replace('\n', '\\n').replace('\t', '\\t').replace('\'', '\\\'').replace('\"', '\\\"')
        self.string_consts.append(f'{name}:\n    .TEXT "{d_san}"')

    def globalCode(self) -> str:
        return '\n'.join(self.globalDefs)
    
    def isGlobal(self, name: str) -> int:
        return name in self.scope

class LocalScopeTracker:
    def __init__(self, globals: KernelCompilerGlobalVars) -> None:
        self.gl = globals
        self.regStack = []
        self.locals = []
        self.regTop = 0
        self.maxReg = 0
    def tempPush(self):
        self.regStack.append(self.regTop)
    def tempPop(self):
        self.regTop = self.regStack.pop()
    def tempAlloc(self) -> int:
        rt = self.regTop
        self.regTop += 1
        self.maxReg = max(self.maxReg, rt)
        return rt
    def isGlobal(self, name: str):
        return name in self.gl.scope
    def newLocal(self, name: str):
        if len(self.regStack) > 0:
            raise Exception()
        self.locals.append(name)
        self.tempAlloc()
    def getLocal(self, name: str):
        return self.locals.index(name)

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
        return offset + self.index if self.relative else self.index

class CompileKernelInstruction:
    def __init__(self, f: Function, args: List[CompileKernelPartialVar]) -> None:
        self.function = f
        self.args = args
        self.outputReg: CompileKernelPartialVar = None
    def output(self, offset: int):
        return self.function.compile(self.outputReg.get(offset), [ a.get(offset) for a in self.args ])

class CompileKernelFunctionBuilder:
    def __init__(self, base: ParseNode, functions: Dict[str, Function], scope: LocalScopeTracker) -> None:
        if base.token.type != TOKEN_TYPE.FUNCTION:
            raise ParserError("Yo, wut", -1)
        
        self.insList: List[CompileKernelPartialVar] = []
        self.regs = 0

        self.functions = functions
        self.scope = scope

        for child in base.children[2].children:
            if child.token.type == TOKEN_TYPE.FUNCTION_CALL:
                self.FUNCTION_CALL(child)
            elif child.token.type == TOKEN_TYPE.SET:
                c = self.FUNCTION_CALL(child.children[1])
    
    def FUNCTION_CALL(self, base: ParseNode) -> CompileKernelPartialVar:
        if base.token.type == TOKEN_TYPE.FUNCTION_CALL:
            self.scope.tempPush()
            # Todo: pick compute order smartly
            fname = base.children[0].token.value
            if fname in self.functions:
                args = base.children[1].children
                for arg in args:
                    self.FUNCTION_CALL(arg)
                    self.insList[-1].outputReg = CompileKernelPartialVar(self.scope.tempAlloc())
                self.scope.tempPop()
            reg = CompileKernelPartialVar(self.scope.tempAlloc())
            self.insList.append(CompileKernelInstruction(self.functions[fname], [reg]))
        elif base.token.type == TOKEN_TYPE.INT:
            self.insList.append(CompileKernelInstruction(self.functions["__INT"], []))
            reg = CompileKernelPartialVar(0, False)
        elif base.token.type == TOKEN_TYPE.IDENTIFIER:
            if self.scope.isGlobal(base.token.value):
                reg = CompileKernelPartialVar(self.scope.gl.scope[base.token.value], False)
            else:
                reg = CompileKernelPartialVar(self.scope.getLocal(base.token.value))
        else:
            raise ParserError("Bruh", 1)
        return reg

    def compile(self):
        pass

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
        "+": BinaryIntFunction("ADD"),
        "-": BinaryIntFunction("SUB"),
        "*": BinaryIntFunction("LMUL"),
        "/": BinaryIntFunction("DIV"),
        "&": BinaryIntFunction("AND"),
        "&&": BinaryIntFunction("BAND"),
        "|": BinaryIntFunction("OR"),
        "||": BinaryIntFunction("BOR"),
        "^": BinaryIntFunction("XOR"),
        ">": BinaryIntFunction("GTR"),
        ">=": BinaryIntFunction("GTEQ"),
        "<": BinaryIntFunction("GTR", True),
        "<=": BinaryIntFunction("GTEQ", True),
        "=": BinaryIntFunction("EQ"),
        "__INT": SetFunction(),
    }
    __LISP_ASM_KERNEL_HEADER = """
    ; Interrupts
    JMP KERNEL_init
    JMP KERNEL_TimerTick
    JMP KERNEL_BadMemAccess
    JMP KERNEL_StackOverflow
    JMP KERNEL_StackUnderflow
    JMP KERNEL_BadIns
    JMP KERNEL_FailedExtAccess
    JMP KERNEL_UserDefined1
    JMP KERNEL_UserDefined2
    JMP KERNEL_UserDefined3
    JMP KERNEL_UserDefined4
    JMP KERNEL_UserDefined5
    JMP KERNEL_UserDefined6
    JMP KERNEL_UserDefined7
    JMP KERNEL_UserDefined8
    JMP KERNEL_UserDefined9
    JMP KERNEL_UserDefined10

KERNEL_init:
"""

    def __init__(self, tree: ParseTree) -> None:
        self.tree = tree
        self.output = ''
        self.vars = KernelCompilerGlobalVars()

        self.vars.newGlobal("KERNEL.int_UserReg0")
        self.vars.newGlobal("KERNEL.int_UserReg1")
        self.vars.newGlobal("KERNEL.int_UserReg2")
        self.vars.newGlobal("KERNEL.int_UserReg3")
        self.vars.newGlobal("KERNEL.int_UserReg4")
        self.vars.newGlobal("KERNEL.int_UserReg5")
        self.vars.newGlobal("KERNEL.int_UserReg6")
        self.vars.newGlobal("KERNEL.int_UserReg7")
        self.vars.newGlobal("KERNEL.int_UserReg8")
        self.vars.newGlobal("KERNEL.int_UserReg9")
        self.vars.newGlobal("KERNEL.int_UserRegA")
        self.vars.newGlobal("KERNEL.int_UserRegB")
        self.vars.newGlobal("KERNEL.int_UserRegC")
        self.vars.newGlobal("KERNEL.int_UserRegD")
        self.vars.newGlobal("KERNEL.int_UserRegE")
        self.vars.newGlobal("KERNEL.int_UserRegF")
        
        self.vars.newGlobal("KERNEL.int_PageStackSize")
        self.vars.newGlobal("KERNEL.int_StackSize")
        self.vars.newGlobal("KERNEL.int_ExtBufferIn")
        self.vars.newGlobal("KERNEL.int_ExtBufferOut")
        self.vars.newGlobal("KERNEL.int_AluStatus")
        self.vars.newGlobal("KERNEL.int_ExtDevices")
        self.vars.newGlobal("KERNEL.int_LastUserIns")

    def compile(self) -> "CompileKernelMode":
        self.output = ""

        # Do a quick scan of the file to see if there are any issues, like return statements or function args
        for node in self.tree.root.children:
            if node.token.type == TOKEN_TYPE.FUNCTION:
                if len(node.children[1].children) > 0:
                    raise ParserError(f"Function {node.children[0].token.value} cannot have arguments in KERNEL mode.", node.token.line)
                if len(node.children) == 4:
                    raise ParserError(f"Function {node.children[0].token.value} cannot have returns in KERNEL mode.", node.children[3].token.line)
        
        # Initialize globals
        for node in self.tree.root.children:
            if node.token.type == TOKEN_TYPE.GLOBAL:
                if len(node.children) == 1:
                    self.vars.newGlobal(node.children[0].token.value)
                else:
                    if node.children[1].token.type == TOKEN_TYPE.INT:
                        self.vars.newGlobal(node.children[0].token.value, node.children[1].token.value)
                    elif node.children[1].token.type == TOKEN_TYPE.STRING:
                        sVal = '__CONSTANTS.' + node.children[0].token.value
                        self.vars.constString(sVal, node.children[1].token.value)
                        self.vars.newGlobal(node.children[0].token.value, sVal)
        
        self.output = self.vars.globalCode() + '\n\n' + CompileKernelMode.__LISP_ASM_KERNEL_HEADER + '\n'.join(self.vars.globalInit) + '\n\n' + '\n'.join(self.vars.string_consts)

        ALL_F = set( node.children[0].token.value for node in self.tree.root.children if node.token.type == TOKEN_TYPE.FUNCTION )

        # Compile each function
        for node in self.tree.root.children:
            if node.token.type == TOKEN_TYPE.IMPORT:
                pass
            elif node.token.type == TOKEN_TYPE.FUNCTION:
                # Compile the function
                deps = CompileKernelTree.findAllFunctionDeps(node, ALL_F)
                builder = CompileKernelFunctionBuilder(node, CompileKernelMode.__DECLARED_FUNCTIONS, LocalScopeTracker(self.vars))

                builder.compile()

                # print(builder.regCount)

        return self

if __name__ == "__main__":
    with open('test.lispp') as f:
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

        print("Generated asm")
        print("------------------------")
        ckm = CompileKernelMode(parser.tree).compile()
        # print(ckm.output)
    except ParserError as e:
        print(e)

