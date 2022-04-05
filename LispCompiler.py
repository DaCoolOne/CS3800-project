# A python implementation of a compiler for lisp, because python is just faster for development cycles and I don't care about compile times :P

from lib2to3.pgen2 import token
from typing import Union, List
from enum import Enum, unique
from typing import Optional


__LISP_ASM_HEADER = """
"""

# __SP = 0x

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
    # BIN = 10
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
    def __init__(self, type: TOKEN_TYPE, value: Optional[str] = None) -> None:
        self.type = type
        self.value = value
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
        "alloc"
    }

    __RESERVED = {
        "__PUSH_STACK",
        "__STACK_MEM",
        "__SP",
        "__SP_BOTTOM",
        "__SP2",
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
            if c is None: return Token(TOKEN_TYPE.EOF)
            elif c == '#': is_comment = True
            elif c == '\n': is_comment = False
            
            # Break out of the loop
            if not is_comment and not c.isspace():
                break

            c: str = self.nextChar()
        
        if c == '(':
            return Token(TOKEN_TYPE.PAREN_START)
        elif c == ')':
            return Token(TOKEN_TYPE.PAREN_END)
        elif c == '{':
            return Token(TOKEN_TYPE.BLOCK_START)
        elif c == '}':
            return Token(TOKEN_TYPE.BLOCK_END)
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
                    self.stepBack()
                    raise ParserError(f"Unclosed string", self.line)
            return Token(TOKEN_TYPE.STRING, s)
        
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
                        return Token(TOKEN_TYPE.INT, int(s, 16))
                    elif c in '(){}#':
                        self.stepBack()
                        return Token(TOKEN_TYPE.INT, int(s, 16))
                    else:
                        raise ParserError(f"Unexpecteed character '{c}'", self.line)
                elif c == 'b':
                    self.index += 1
                    c = self.nextChar()
                    while c is not None and (c == '0' or c == '1'):
                        s += c
                        c = self.nextChar()
                    if c.isspace():
                        return Token(TOKEN_TYPE.INT, int(s, 2))
                    elif c in '(){}#':
                        self.stepBack()
                        return Token(TOKEN_TYPE.INT, int(s, 2))
                    else:
                        raise ParserError(f"Unexpecteed character '{c}'", self.line)
            
            # Normal decimal parsing
            s = ''
            while c is not None and c.isdigit():
                s += c
                c = self.nextChar()
            
            if c.isspace():
                return Token(TOKEN_TYPE.INT, int(s))
            elif c in '(){}#':
                self.stepBack()
                return Token(TOKEN_TYPE.INT, int(s))
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
                return Token(TOKEN_TYPE.KEYWORD, s)
            elif s in TokenParser.__RESERVED:
                raise ParserError(f"{s} is a reserved word!", self.line)
            else:
                return Token(TOKEN_TYPE.IDENTIFIER, s)
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
        self.root = ParseNode(Token(TOKEN_TYPE.ROOT))
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
        self.tree.push(Token(TOKEN_TYPE.IMPORT))
        self.parse_IDENTIFIER()

        if self.token.type == TOKEN_TYPE.STRING:
            self.tree.shift(self.token)
            self.getToken()
        else:
            raise ParserError("Expected string", self.tk_gen.getTokenLine())
        
        self.tree.pop()
    # Parse set statements
    def parse_SET(self):
        self.tree.push(Token(TOKEN_TYPE.SET))
        self.parse_IDENTIFIER()
        self.parse_EXPRESSION()
        self.tree.pop()
    def parse_ALLOC(self):
        self.tree.push(Token(TOKEN_TYPE.ALLOC))
        self.parse_IDENTIFIER()
        self.parse_EXPRESSION()
        self.tree.pop()
    def parse_ARGLIST(self):
        if self.token.type != TOKEN_TYPE.PAREN_START:
            raise ParserError("Expected Opening Parenthesis", self.tk_gen.getTokenLine())
        
        self.getToken()

        self.tree.push(Token(TOKEN_TYPE.ARGLIST))

        while self.token.type == TOKEN_TYPE.IDENTIFIER:
            self.tree.shift(self.token)
            self.getToken()
        
        self.tree.pop()
        
        if self.token.type != TOKEN_TYPE.PAREN_END:
            raise ParserError("Expected Closing Parenthesis", self.tk_gen.getTokenLine())
        
        self.getToken()

    def parse_STRUCT(self):
        self.tree.push(Token(TOKEN_TYPE.STRUCT))
        self.parse_IDENTIFIER()
        self.parse_ARGLIST()
        self.tree.pop()

        # Todo: implement structs & arrays
        raise ParserError("Structs are a planned feature and have not been implemented yet!", self.tk_gen.getTokenLine())
    # Parse function statements.
    def parse_FUNCTION(self):
        self.tree.push(Token(TOKEN_TYPE.FUNCTION))
        self.parse_IDENTIFIER()

        self.parse_ARGLIST()

        self.parse_BLOCK()

        if self.token.type == TOKEN_TYPE.KEYWORD and self.token.value == 'returns':
            self.getToken()
            self.parse_IDENTIFIER()

        self.tree.pop()

    # Parse for loop.
    def parse_WHILE(self):
        self.tree.push(Token(TOKEN_TYPE.WHILE))
        self.parse_IDENTIFIER()
        self.parse_FUNCTION_CALL()
        self.parse_BLOCK()
        self.tree.pop()
    # Parse if statement.
    def parse_IF(self):
        self.tree.push(Token(TOKEN_TYPE.IF))
        self.tree.push(Token(TOKEN_TYPE.IF_COND))
        self.parse_FUNCTION_CALL()
        self.parse_BLOCK()
        self.tree.pop()
        while self.token.type == TOKEN_TYPE.KEYWORD:
            if self.token.value == 'elif':
                self.getToken()
                self.tree.push(Token(TOKEN_TYPE.IF_COND))
                self.parse_FUNCTION_CALL()
                self.parse_BLOCK()
                self.tree.pop()
            elif self.token.value == 'else':
                self.getToken()
                self.tree.push(Token(TOKEN_TYPE.ELSE_COND))
                self.parse_BLOCK()
                self.tree.pop()
            else:
                break
        
        self.tree.pop()

    # Parse for loop.
    def parse_FOR(self):
        self.tree.push(Token(TOKEN_TYPE.FOR))
        self.parse_IDENTIFIER()
        self.parse_FUNCTION_CALL()
        self.parse_FUNCTION_CALL()
        self.parse_BLOCK()
        self.tree.pop()
    # Parse an infinite loop.
    def parse_LOOP(self):
        self.tree.push(Token(TOKEN_TYPE.LOOP))
        self.parse_BLOCK()
        self.tree.pop()
    # Parse a block
    def parse_BLOCK(self):
        if self.token.type != TOKEN_TYPE.BLOCK_START:
            raise ParserError("Expected Block", self.tk_gen.getTokenLine())
        self.getToken()

        self.tree.push(Token(TOKEN_TYPE.BLOCK))

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

        self.tree.push(Token(TOKEN_TYPE.FUNCTION_CALL))

        self.parse_IDENTIFIER()

        self.tree.push(Token(TOKEN_TYPE.ARGLIST))
        while self.token.type != TOKEN_TYPE.PAREN_END:
            self.parse_EXPRESSION()
        
        self.getToken()
        self.tree.pop()

        self.tree.pop()

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
    except ParserError as e:
        print(e)
    print('\nParse tree:')
    parser.tree.print()

