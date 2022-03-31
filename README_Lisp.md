
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
(import stdio "stdio")

(set n 3) # Can change the 3 to anything

if (< n 5) {
    (stdio.print "N is less than 5")
}
elseif (= n 5) {
    (stdio.print "N is equal to 5")
}
else {
    (stdio.print "N is greater than 5")
}
```

# Types

While there is planned support for all types in this language, to start off with the language will only support signed ints
and string constants.

Integers can be written using hexidecimal (0xAF), binary (0b1100), or decimal (100). Boolean expressions will evaluate to
true (1) or false (0).

Strings are immutable objects, meaning that in order to modify strings a copy of the string must be created. This can be
done through the string library (planned).

When writing code for the kernel, the first instruction must be to import the standard KERNEL library. The KERNEL library
includes many preprocessor directives that allow the kernel to deal with interrupts. It also includes a few constants that
are used by the processor for storing variables and gives access to those values. Additionally, there are several functions
that are included as well. Furthermore, developing in kernel mode gives you access to a different set of registers that would
normally be protected.

# Scope
Scope does not exist in this language, since it is very rudimentary. The only scopes that exist are between scripts. However, all
names are contained in the same global namespace, so be careful that you don't blow up your memory constraints!

# Keywords

The keywords that have been added to the language are as follows:

`if` - declares an if statement. Should be followed by two expressions, the first is an evaluator and the second function is only
called if the first function evaluates to any value that isn't zero. This second function can also be an anonymous function block
defined with `{}`.

`elseif` - declares an elseif statement. Should be followed by two expressions, the first is an evaluator and the second is only
called if the first evaluates to non-zero. Should be preceeded by an if or elseif statement.

`else` - declares an else statement. Should be followed by an expression and preceeded by an if or elseif statement.

```
if (< n 5) {
    (stdio.print "N is less than 5")
}
elseif (= n 5) {
    (stdio.print "N is equal to 5")
}
else {
    (stdio.print "N is greater than 5")
}
```

`while` - declares a while loop. Every iteration of the while loop, the first expression is evaluated and if truthy
(not zero) will execute the second expression. The second expression will continue to be executed until the first evaluates
to false.

```
(set n 0)
while (< n 5) {
    (stdio.print n)
    (++ n)
}
```

`for` -  declares a for loop. A for loop has four expressions. The first is an initializer, then a comparitor,
then an incrementer, and finally the loop body.

```
for (set i 0) (< i 5) (++ i) {
    (stdio.print i)
}

for (set j 20) (>= j 0) (set j (- j 2)) {
    (stdio.print j)
}
```

