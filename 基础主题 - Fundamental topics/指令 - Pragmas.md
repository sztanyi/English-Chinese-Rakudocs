原文：https://docs.raku.org/language/pragmas

# 指令 / Pragmas

定义代码某些方面行为的特殊模组

Special modules that define certain aspects of the behavior of the code

在 Raku 中，**指令**是用于标识要使用的 Raku 的特定版本或以某种方式修改编译器的正常行为的指令。`use` 关键字启用了一个指令（类似于你如何 `use` 一个模组）。若要禁用指令，请使用 `no` 关键字：

In Raku, **pragmas** are directive used to either identify a specific version of Raku to be used or to modify the compiler's normal behavior in some way. The `use` keyword enables a pragma (similar to how you can `use` a module). To disable a pragma, use the `no` keyword:

```Raku
use v6.c;   # use 6.c language version 
no worries; # don't issue compile time warnings 
```

以下是一份指令清单，并简要描述每一种指令的用途，或链接到更多关于其使用的细节。(注：标有 “[NYI]” 的指令尚未实现，标记为 “[TBD]” 的将在以后定义)。

Following is a list of pragmas with a short description of each pragma's purpose or a link to more details about its use. (Note: Pragmas marked "[NYI]" are not yet implemented, and those marked "[TBD]" are to be defined later.)

<!-- MarkdownTOC -->

- [v6.x](#v6x)
- [MONKEY-GUTS](#monkey-guts)
- [MONKEY-SEE-NO-EVAL](#monkey-see-no-eval)
- [MONKEY-TYPING](#monkey-typing)
- [MONKEY](#monkey)
- [dynamic-scope](#dynamic-scope)
- [experimental](#experimental)
- [fatal](#fatal)
- [internals](#internals)
- [invocant](#invocant)
- [isms](#isms)
- [lib](#lib)
- [newline](#newline)
- [nqp](#nqp)
- [parameters](#parameters)
- [precompilation](#precompilation)
- [soft](#soft)
- [strict](#strict)
- [trace](#trace)
- [v6](#v6)
- [variables](#variables)
- [worries](#worries)

<!-- /MarkdownTOC -->


<a id="v6x"></a>
## v6.x

此指令声明了将要使用的编译器的版本，如果它们是可选的，则打开它的特性。

This pragma states the version of the compiler that is going to be used, and turns on its features if they are optional.

```Raku
use v6;   # Load latest supported version (non-PREVIEW). 
          # Also, useful for producing better errors when accidentally 
          # executing the program with `perl` instead of `raku` 
use v6.c;         # Use the "Christmas" version of Raku 
use v6.d;         # Use the "Diwali" version of Raku 
```

因为在 2018.11 实现了 6.d 版本，这之后这个指令什么也不做。

From 2018.11, which implemented 6.d, this pragma does not do anything.

```Raku
use v6.d.PREVIEW; # On 6.d-capable compilers, enables 6.d features, 
                  # otherwise enables the available experimental 
                  # preview features for 6.d language 
```

因为这些指令开启了编译器版本，所以它们应该是文件中的第一个语句（前面可以有注释和 Pod）。

Since these pragmas turn on the compiler version, they should be the first statement in the file (preceding comments and Pod are fine).

<a id="monkey-guts"></a>
## MONKEY-GUTS

此指令目前不是任何 Raku 规范的一部分，但在 Rakudo 中作为 `use nqp` 的同义词存在（见下文）。

This pragma is not currently part of any Raku specification, but is present in Rakudo as a synonym to `use nqp` (see below).

<a id="monkey-see-no-eval"></a>
## MONKEY-SEE-NO-EVAL

[EVAL](https://docs.raku.org/routine/EVAL)

<a id="monkey-typing"></a>
## MONKEY-TYPING

[augment](https://docs.raku.org/syntax/augment)

<a id="monkey"></a>
## MONKEY

```Raku
use MONKEY;
```

打开所有可用的 `MONKEY` 指令，目前为上述三种；因此，它相当于

Turns on all available `MONKEY` pragmas, currently the three above; thus, it would be equivalent to

```Raku
use MONKEY-TYPING;
use MONKEY-SEE-NO-EVAL;
use MONKEY-GUTS;
```

动态作用域，指令

dynamic-scope, pragma

<a id="dynamic-scope"></a>
## dynamic-scope

将 [is dynamic](https://docs.raku.org/type/Variable#trait_is_dynamic) 特性应用于指令的词法作用域中的变量。通过将变量的名称作为参数列出，效果可以限制在变量的子集上。默认情况下，适用于*所有*变量。

Applies the [is dynamic](https://docs.raku.org/type/Variable#trait_is_dynamic) trait to variables in the pragma's lexical scope. The effect can be restricted to a subset of variables by listing their names as arguments. By default applies to *all* variables.

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

此指令目前并不是任何 Raku 规范的一部分，而是在 Rakudo 2019.03 中添加的。

This pragma is not currently part of any Raku specification and was added in Rakudo 2019.03.

<a id="experimental"></a>
## experimental

允许使用[实验特性](https://docs.raku.org/language/experimental)

Allows use of [experimental features](https://docs.raku.org/language/experimental)

<a id="fatal"></a>
## fatal

一种词法指令，使例程发生致命错误时返回 [Failure](https://docs.raku.org/type/Failure)。例如，前缀 `+` 在一个 [Str](https://docs.raku.org/type/Str) 上将其类型强制转换到 [Numeric](https://docs.raku.org/type/Numeric)，但如果字符串包含非数字字符，则返回一个 [Failure](https://docs.raku.org/type/Failure)。保存那个 [Failure](https://docs.raku.org/type/Failure) 至变量中可以防止它成为 sink 上下文，因此下面的第一个代码块到达 `say $x.^name;` 行并在输出中打印 `Failure`。

A lexical pragma that makes [Failures](https://docs.raku.org/type/Failure) returned from routines fatal. For example, prefix `+` on a [Str](https://docs.raku.org/type/Str) coerces it to [Numeric](https://docs.raku.org/type/Numeric), but will return a [Failure](https://docs.raku.org/type/Failure) if the string contains non-numeric characters. Saving that [Failure](https://docs.raku.org/type/Failure) in a variable prevents it from being sunk, and so the first code block below reaches the `say $x.^name;` line and prints `Failure` in output.

在第二个块中，启用了 `use fatal` 指令，永远不会到达 `say` 行，因为从前缀运算符 `+` 返回的 [Failure](https://docs.raku.org/type/Failure) 中的 [Exception](https://docs.raku.org/type/Exception) 被抛出，引发 `CATCH` 块会运行，输出 `Caught...` 行。请注意，这两个块都是相同的程序，`use fatal` 只会影响它在其中使用的词法块：

In the second block, the `use fatal` pragma is enabled, so the `say` line is never reached because the [Exception](https://docs.raku.org/type/Exception) contained in the [Failure](https://docs.raku.org/type/Failure) returned from prefix `+` gets thrown and the `CATCH` block gets run, printing the `Caught...` line. Note that both blocks are the same program and `use fatal` only affects the lexical block it was used in:

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

在 [`try` 代码块](https://docs.raku.org/language/exceptions#index-entry-try_blocks-try)中，`fatal` 指令是默认开启的，你可以用 `no fatal` *禁用*它：

Inside [`try` blocks](https://docs.raku.org/language/exceptions#index-entry-try_blocks-try), the `fatal` pragma is enabled by default, and you can *disable* it with `no fatal`:

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

<a id="internals"></a>
## internals

[NYI]

<a id="invocant"></a>
## invocant

[NYI]

<a id="isms"></a>
## isms

```Raku
[2018.09 and later]
```

允许一些其他语言结构，这些构造被认为是需要在正常的 Raku 编程中发出警告和/或错误的陷阱。目前，允许 `Perl5` 和 `C++`。

Allow for some other language constructs that were deemed to be a trap that warranted a warning and/or an error in normal Raku programming. Currently, `Perl5` and `C++` are allowed.

```Raku
sub abs() { say "foo" }
abs;
# Unsupported use of bare "abs"; in Raku please use .abs if you meant 
# to call it as a method on $_, or use an explicit invocant or argument, 
# or use &abs to refer to the function as a noun 
```

在这种情况下，提供一个不带任何参数的 `abs` 子程序，不会使编译错误消失。

In this case, providing an `abs` sub that doesn't take any arguments, did not make the compilation error go away.

```Raku
use isms <Perl5>;
sub abs() { say "foo" }
abs;   # foo
```

这样，编译器将允许违规的 Perl 5 构造，从而允许实际执行代码。

With this, the compiler will allow the offending Perl 5 construct, allowing the code to actually be executed.

如果不指定任何语言，则允许所有已知的语言结构。

If you do not specify any language, all known language constructs are allowed.

```Raku
use isms;   # allow for Perl5 and C++ isms
```

<a id="lib"></a>
## lib

此指令将子目录添加到库搜索路径中，以便解释器能够[找到模组](https://docs.raku.org/language/modules#Finding_modules)。

This pragma adds subdirectories to the library search path so that the interpreter can [find the modules](https://docs.raku.org/language/modules#Finding_modules).

```Raku
use lib <lib /opt/lib /usr/local/lib>;
```

这将搜索列表中传递的目录。请查看[模组文档](https://docs.raku.org/language/modules#use)以获得更多示例。

This will search the directories passed in a list. Please check [the modules documentation](https://docs.raku.org/language/modules#use) for more examples.

<a id="newline"></a>
## newline

在调用的作用域中设置 [$?NL](https://docs.raku.org/language/variables#Compile-time_variables) 常量的值。可能的值是 `:lf`（这是默认的，表示 Line Feed），`:crlf`（表示回车，line Feed）和 `:cr`（表示 Carriage Return）。

Set the value of the [$?NL](https://docs.raku.org/language/variables#Compile-time_variables) constant in the scope it is called. Possible values are `:lf` (which is the default, indicating Line Feed), `:crlf` (indicating Carriage Return, Line Feed) and `:cr` (indicating Carriage Return).

<a id="nqp"></a>
## nqp

自担风险使用。

Use at your own risk.

这是一种特定于 Rakudo 的指令。使用它，Rakudo 可以在顶级名称空间中访问 [nqp opcode](https://github.com/perl6/nqp/blob/master/docs/ops.markdown)：

This is a Rakudo-specific pragma. With it, Rakudo provides access to the [nqp opcodes](https://github.com/perl6/nqp/blob/master/docs/ops.markdown) in a top level namespace:

```Raku
use nqp;
nqp::say("hello world");
```

这将使用底层 nqp 的 `say` 操作码而不是 Raku 例程。这种指令可能会使你的代码依赖于特定版本的 nqp，而且由于该代码不是 Raku 规范的一部分，因此不能保证它是稳定的。你可能会在 Rakudo 内核中发现大量的使用，这些用法用于使核心功能尽可能快。Rakudo 代码生成中的未来优化可能会使这些用法过时。

This uses the underlying nqp `say` opcode instead of the Raku routine. This pragma may make your code rely on a particular version of nqp, and since that code is not part of the Raku specification, it's not guaranteed to be stable. You may find a large number of usages in the Rakudo core, which are used to make the core functionality as fast as possible. Future optimizations in the code generation of Rakudo may obsolete these usages.

<a id="parameters"></a>
## parameters

[NYI]

<a id="precompilation"></a>
## precompilation

默认允许预编译源代码，特别是在模组中使用时。如果出于任何原因，你不希望预编译(模组的代码)，则可以使用 `no precompilation`。这将防止整个编译单元(通常是一个文件)被预编译。

The default allows precompilation of source code, specifically if used in a module. If for whatever reason you do not want the code (of your module) to be precompiled, you can use `no precompilation`. This will prevent the entire compilation unit (usually a file) from being precompiled.

<a id="soft"></a>
## soft

[重新调度](https://docs.raku.org/language/functions#Re-dispatching)，[内联](https://docs.raku.org/language/functions#index-entry-use_soft_(pragma))

[Re-dispatching](https://docs.raku.org/language/functions#Re-dispatching), [inlining](https://docs.raku.org/language/functions#index-entry-use_soft_(pragma))

<a id="strict"></a>
## strict

`strict` 是默认行为，需要在使用变量之前声明它们。你可以用 `no` 来放宽这个限制。

`strict` is the default behavior, and requires that you declare variables before using them. You can relax this restriction with `no`.

```Raku
no strict; $x = 42; # OK 
```

<a id="trace"></a>
## trace

当 `use trace` 被激活时，执行的任何代码行都将写入 STDERR。你可以使用 `no trace` 关闭该特性，因此这只发生在代码的某些部分。

When `use trace` is activated, any line of code executing will be written to STDERR. You can use `no trace` to switch off the feature, so this only happens for certain sections of code.

<a id="v6"></a>
## v6

[Writing Tests](https://docs.raku.org/language/testing#Writing_tests)

<a id="variables"></a>
## variables

[已定义变量指令](https://docs.raku.org/language/variables#Default_defined_variables_pragma)

[Defined Variables Pragma](https://docs.raku.org/language/variables#Default_defined_variables_pragma)

<a id="worries"></a>
## worries

从词汇上控制编译器生成的编译时警告是否显示出来。默认情况下启用。

Lexically controls whether compile-time warnings generated by the compiler get shown. Enabled by default.

```Raku
$ raku -e 'say :foo<>.Pair'
Potential difficulties:
  Pair with <> really means an empty list, not null string; use :foo('') to represent the null string,
    or :foo() to represent the empty list more accurately
  at -e:1
  ------> say :foo<>⏏.Pair
foo => Nil
 
$ raku -e 'no worries; say :foo<>.Pair'
foo => Nil
```
