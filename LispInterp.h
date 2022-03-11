#ifndef LISP_INTERP
#define LISP_INTERP

#include <cstdint>
#include <vector>
#include <map>
#include <string>

const uint32_t MAX_STACK_SIZE = 255;

class LispInterp {
    std::vector<std::map<std::string, int>> m_scope;

    void parseExpr();
public:
    LispInterp();

    void parse(std::istream stream);
};

#endif