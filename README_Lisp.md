
# Lisp high level language specification

The variant of lisp that is being used in this project is designed to make using lisp easy. As a result, the lisp variant
has several nuances over a pure lisp implementation that need to be addressed.

For example, in a pure lisp implementation, statements like if statements, loops, etc are defined as functions. This can
make writing in lisp somewhat confusing. To remedy this, this version of lisp contains a few keywords and a few new structs
to make things simpler.

The most useful struct is a block, written with curly brackets `{}`. These allow you to write sequential groups of function
calls. These blocks can be used to define functions, control statements, and so much more.

```
# An example of using the new lisp flavor
import stdio "stdio"

function main () {
    set n 3 # Can change the 3 to anything

    if (< n 5) {
        (stdio.print "N is less than 5")
    }
    elif (= n 5) {
        (stdio.print "N is equal to 5")
    }
    else {
        (stdio.print "N is greater than 5")
    }
}
```

# Types

A type is always tacked onto the front of an identifier. For example, int_x will be forced to be an integer by the language.
If an identifier does not have a type written in front of the name, then it is a function.

While there is planned support for all types in this language, to start off with the language will only support signed ints,
arrays, and string constants.

`int_` - Integers can be written using hexidecimal (0xAF), binary (0b1100), or decimal (100, -200, etc). Boolean expressions
will evaluate to the integers 1 (true) or 0 (false).

`str_` - Strings are immutable objects, meaning that in order to modify strings a copy of the string must be created. This can
be done through the string library (planned).

`float_` - Floating point values (planned).

`*int_` `*str_` - Pointers / arrays (planned).

When writing code for the kernel, the first instruction must be to import the standard KERNEL library. The KERNEL library
includes many preprocessor directives that allow the kernel to deal with interrupts. It also includes a few constants that
are used by the processor for storing variables and gives access to those values. Additionally, there are several functions
that are included as well. Furthermore, developing in kernel mode gives you access to a different set of registers that would
normally be protected.

# Scope
Scope is tied directly to the functions. Every function has its own scope.

# Keywords

The keywords that have been added to the language are as follows:

`set` - Sets an identifier to the result of an expression
```
function main() {
    set int_x 3

    set float_a float_b
}
```

`if` - declares an if statement. Should be followed by two expressions, the first is an evaluator and the second function is only
called if the first function evaluates to any value that isn't zero. This second function can also be an anonymous function block
defined with `{}`.

`elseif` - declares an elseif statement. Should be followed by two expressions, the first is an evaluator and the second is only
called if the first evaluates to non-zero. Should be preceeded by an if or elseif statement.

`else` - declares an else statement. Should be followed by an expression and preceeded by an if or elseif statement.

```
import stdio "stdio"

function main() {
    set int_n 3

    if (< int_n 5) {
        (stdio.print "N is less than 5")
    }
    elseif (= int_n 5) {
        (stdio.print "N is equal to 5")
    }
    else {
        (stdio.print "N is greater than 5")
    }
}
```

`while` - declares a while loop. Every iteration of the while loop, the first expression is evaluated and if truthy
(not zero) will execute the second expression. The second expression will continue to be executed until the first evaluates
to false.

```
import stdio "stdio"

function main() {
    set int_n 0
    while (< int_n 5) {
        (stdio.print int_n)
        set int_n (++ int_n)
    }
}
```

`for` -  declares a for loop. A for loop has three arguments and a block. The first is an identifier/iterator (which will be declared
to 0 if it doesn't exist yet), the next is a comparitor, and the third is an updater.

Every iteration of the for loop, the loop checks the comparitor. If the value of the comparitor is not zero, then the loop body is
executed. After execution of the loop, the iterator will loop back to the updater and set the iterator to the value returned by the
updater. This loop continues until the comparitor returns 0.

```
import stdio "stdio"

function main() {
    for int_i (< int_i 5) (++ int_i) {
        (stdio.print int_i)
    }

    set int_j 20
    for int_j (> int_j 0) (- int_j 2) {
        (stdio.print int_j)
    }
}
```

`loop` - declares an infinite loop. You can't break out of a for loop, as there is no break statement. No I will not add a
break statement.

```
import stdio "stdio"

function main() {
    set int_x 0
    loop {
        (stdio.print int_x)
        set int_x (++ int_x)
    }
}
```

`function` - declares a function. A function definition takes the form `function IDENTIFIER (ARG1 ARG2 ARG3) { } [returns IDENTIFIER]`
```
import stdio "stdio"

# Some dumb functions for demonstration purposes.
function output(int_n) {
    (stdio.print int_n)
}
function add(int_a int_b) {
    set int_n (+ int_a int_b)
} returns int_n

function main() {
    # outputs 3
    (output (add 1 2))
}
```

Functions can also be recursive, like so:
```
import stdio "stdio"

function factorial(int_n) {
    if (> int_n 1) {
        set int_n (* n (factorial (- int_n 1)))
    }
    else {
        set int_n 1
    }
} returns int_n
```

`struct` - Creates a struct (planned). There is no OOP in this language, and no plans to implement OOP
either. However, using structs and functions you can get pretty close to OOP.
```
struct vec2i (int_x int_y)
struct vec2 (float_x float_y)

function cartesianProd(vec2i_v) {
    set int_res (+ vec2i_v.int_x vec2i_v.int_y)
} returns int_res
```

# Arrays (planned)

```
import stdio "stdio"

function main() {
    alloc *int_ex 20 # Creates a new int array with 20 elements

    # Initialize the array
    for int_i 20 {
        set *int_ex:int_i i # Pointers can be decomposed into real values like so.
    }

    # Add eight to the eigth element
    set *int_ex:8 (+ *int_ex:8 8)

    # Print the elements of the array
    for int_i 20 {
        (stdio.print *int_ex:int_i)
    }
}
```

Since array access is technically a part of the identifier, this leads to some wacky things. For example,
you can access a 2d array like this:

`**int_ARRAY:int_x:int_y`

However, accessing an array with a function is forbidden.

`*int_ARR:(+ int_x 1) # Not allowed!`

Instead, use a temp variable:

```
set int_t (+ int_x 1)
(+ *int_ARR:int_t 1)
```

