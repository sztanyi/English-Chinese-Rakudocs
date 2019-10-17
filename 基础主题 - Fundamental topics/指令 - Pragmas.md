# Pragmas

Special modules that define certain aspects of the behavior of the code

In Raku, **pragmas** are directive used to either identify a specific version of Raku to be used or to modify the compiler's normal behavior in some way. The `use` keyword enables a pragma (similar to how you can `use` a module). To disable a pragma, use the `no` keyword:

```Raku
use v6.c;   # use 6.c language version 
no worries; # don't issue compile time warnings 
```

Following is a list of pragmas with a short description of each pragma's purpose or a link to more details about its use. (Note: Pragmas marked "[NYI]" are not yet implemented, and those marked "[TBD]" are to be defined later.)

## v6.x

This pragma states the version of the compiler that is going to be used, and turns on its features if they are optional.

```Raku
use v6;   # Load latest supported version (non-PREVIEW). 
          # Also, useful for producing better errors when accidentally 
          # executing the program with `perl` instead of `perl6` 
use v6.c;         # Use the "Christmas" version of Raku 
use v6.d;         # Use the "Diwali" version of Raku 
```

From 2018.11, which implemented 6.d, this pragma does not do anything.

```Raku
use v6.d.PREVIEW; # On 6.d-capable compilers, enables 6.d features, 
                  # otherwise enables the available experimental 
                  # preview features for 6.d language 
```

Since these pragmas turn on the compiler version, they should be the first statement in the file (preceding comments and Pod are fine).

## MONKEY-GUTS

This pragma is not currently part of any Raku specification, but is present in Rakudo as a synonym to `use nqp` (see below).

## MONKEY-SEE-NO-EVAL

[EVAL](https://rakudocs.github.io/routine/EVAL)

## MONKEY-TYPING

[augment](https://rakudocs.github.io/syntax/augment)

## MONKEY

```Raku
use MONKEY;
```

Turns on all available `MONKEY` pragmas, currently the three above; thus, it would be equivalent to

```Raku
use MONKEY-TYPING;
use MONKEY-SEE-NO-EVAL;
use MONKEY-GUTS;
```

dynamic-scope, pragma

## dynamic-scope

Applies the [is dynamic](https://rakudocs.github.io/type/Variable#trait_is_dynamic) trait to variables in the pragma's lexical scope. The effect can be restricted to a subset of variables by listing their names as arguments. By default applies to *all* variables.

```Raku
# Apply is dynamic only to $x, but not to $y
use dynamic-scope <$x>;

sub poke {
    say $CALLER::x;
    say $CALLER::y;
}

my $x = 23;
my $y = 34;
poke;

# OUTPUT:
# 23
# Cannot access '$y' through CALLER, because it is not declared as dynamic
```

This pragma is not currently part of any Raku specification and was added in Rakudo 2019.03.

## experimental

Allows use of [experimental features](https://rakudocs.github.io/language/experimental)

## fatal

A lexical pragma that makes [Failures](https://rakudocs.github.io/type/Failure) returned from routines fatal. For example, prefix `+` on a [Str](https://rakudocs.github.io/type/Str) coerces it to [Numeric](https://rakudocs.github.io/type/Numeric), but will return a [Failure](https://rakudocs.github.io/type/Failure) if the string contains non-numeric characters. Saving that [Failure](https://rakudocs.github.io/type/Failure) in a variable prevents it from being sunk, and so the first code block below reaches the `say $x.^name;` line and prints `Failure` in output.

In the second block, the `use fatal` pragma is enabled, so the `say` line is never reached because the [Exception](https://rakudocs.github.io/type/Exception) contained in the [Failure](https://rakudocs.github.io/type/Failure) returned from prefix `+` gets thrown and the `CATCH` block gets run, printing the `Caught...` line. Note that both blocks are the same program and `use fatal` only affects the lexical block it was used in:

```Raku
{
    my $x = +"a";
    say $x.^name;
    CATCH { default { say "Caught {.^name}" } }
} # OUTPUT: «Failure␤» 
 
{
    use fatal;
    my $x = +"a";
    say $x.^name;
    CATCH { default { say "Caught {.^name}" } }
} # OUTPUT: «Caught X::Str::Numeric␤»
```

Inside [`try` blocks](https://rakudocs.github.io/language/exceptions#index-entry-try_blocks-try), the `fatal` pragma is enabled by default, and you can *disable* it with `no fatal`:

```Raku
try {
    my $x = +"a";
    say $x.^name;
    CATCH { default { say "Caught {.^name}" } }
} # OUTPUT: «Caught X::Str::Numeric␤» 
 
try {
    no fatal;
    my $x = +"a";
    say $x.^name;
    CATCH { default { say "Caught {.^name}" } }
} # OUTPUT: «Failure␤»
```

## internals

[NYI]

## invocant

[NYI]

## isms

```Raku
[2018.09 and later]
```

Allow for some other language constructs that were deemed to be a trap that warranted a warning and/or an error in normal Raku programming. Currently, `Perl5` and `C++` are allowed.

```Raku
sub abs() { say "foo" }
abs;
# Unsupported use of bare "abs"; in Raku please use .abs if you meant 
# to call it as a method on $_, or use an explicit invocant or argument, 
# or use &abs to refer to the function as a noun 
```

In this case, providing an `abs` sub that doesn't take any arguments, did not make the compilation error go away.

```Raku
use isms <Perl5>;
sub abs() { say "foo" }
abs;   # foo
```

With this, the compiler will allow the offending Perl 5 construct, allowing the code to actually be executed.

If you do not specify any language, all known language constructs are allowed.

```Raku
use isms;   # allow for Perl5 and C++ isms
```

## lib

This pragma adds subdirectories to the library search path so that the interpreter can [find the modules](https://rakudocs.github.io/language/modules#Finding_modules).

```Raku
use lib <lib /opt/lib /usr/local/lib>;
```

This will search the directories passed in a list. Please check [the modules documentation](https://rakudocs.github.io/language/modules#use) for more examples.

## newline

Set the value of the [$?NL](https://rakudocs.github.io/language/variables#Compile-time_variables) constant in the scope it is called. Possible values are `:lf` (which is the default, indicating Line Feed), `:crlf` (indicating Carriage Return, Line Feed) and `:cr` (indicating Carriage Return).

## nqp

Use at your own risk.

This is a Rakudo-specific pragma. With it, Rakudo provides access to the [nqp opcodes](https://github.com/perl6/nqp/blob/master/docs/ops.markdown) in a top level namespace:

```Raku
use nqp;
nqp::say("hello world");
```

This uses the underlying nqp `say` opcode instead of the Raku routine. This pragma may make your code rely on a particular version of nqp, and since that code is not part of the Raku specification, it's not guaranteed to be stable. You may find a large number of usages in the Rakudo core, which are used to make the core functionality as fast as possible. Future optimizations in the code generation of Rakudo may obsolete these usages.

## parameters

[NYI]

## precompilation

The default allows precompilation of source code, specifically if used in a module. If for whatever reason you do not want the code (of your module) to be precompiled, you can use `no precompilation`. This will prevent the entire compilation unit (usually a file) from being precompiled.

## soft

[Re-dispatching](https://rakudocs.github.io/language/functions#Re-dispatching), [inlining](https://rakudocs.github.io/language/functions#index-entry-use_soft_(pragma))

## strict

`strict` is the default behavior, and requires that you declare variables before using them. You can relax this restriction with `no`.

```Raku
no strict; $x = 42; # OK 
```

## trace

When `use trace` is activated, any line of code executing will be written to STDERR. You can use `no trace` to switch off the feature, so this only happens for certain sections of code.

## v6

[Writing Tests](https://rakudocs.github.io/language/testing#Writing_tests)

## variables

[Defined Variables Pragma](https://rakudocs.github.io/language/variables#Default_defined_variables_pragma)

## worries

Lexically controls whether compile-time warnings generated by the compiler get shown. Enabled by default.

```Raku
$ perl6 -e 'say :foo<>.Pair'
Potential difficulties:
  Pair with <> really means an empty list, not null string; use :foo('') to represent the null string,
    or :foo() to represent the empty list more accurately
  at -e:1
  ------> say :foo<>⏏.Pair
foo => Nil
 
$ perl6 -e 'no worries; say :foo<>.Pair'
foo => Nil
```
