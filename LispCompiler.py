# A python implementation of a compiler for lisp, because python is just faster for development cycles and I don't care about compile times :P

__KEYWORDS = {
    "if": 1,
    "else": 1,
    "return": 1, # Returns outside the function.
    "while": 1,
    "loop": 1,

}

class TokenParser:
    def __init__(self, digestString: str) -> None:
        self.digest = digestString
        self.index = 0

if __name__ == "__main__":
    pass

