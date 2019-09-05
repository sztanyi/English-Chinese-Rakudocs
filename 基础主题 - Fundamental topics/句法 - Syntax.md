# 句法 / Syntax

Perl 6 语法的一般规则

General rules of Perl 6 syntax

Per l6 从人类语言中借用了许多概念。这并不奇怪，因为它是由语言学家设计的。

Perl 6 borrows many concepts from human language. Which is not surprising, considering it was designed by a linguist.

它在不同的上下文中重用公共元素，有名词（术语）和动词（运算符）的概念，是上下文敏感的（在日常意义上，不一定在计算机科学的解释中），因此一个符号可以有不同的含义，这取决于一个名词或一个动词是预期的。

It reuses common elements in different contexts, has the notion of nouns (terms) and verbs (operators), is context-sensitive (in the every day sense, not necessarily in the Computer Science interpretation), so a symbol can have a different meaning depending on whether a noun or a verb is expected.

它也是自计时的，因此解析器可以检测大多数常见错误并给出良好的错误消息。

It is also self-clocking, so that the parser can detect most of the common errors and give good error messages.

# 词法约定 / Lexical conventions

Perl 6 代码是 Unicode 文本。目前的实现支持 UTF-8 作为输入编码。

Perl 6 code is Unicode text. Current implementations support UTF-8 as the input encoding.

另请参见 [Unicode 与 ASCII 符号](https://docs.perl6.org/language/unicode_ascii)。

See also [Unicode versus ASCII symbols](https://docs.perl6.org/language/unicode_ascii).

## 自由语素 / Free form

Perl 6 代码也是自由语素的，在某种意义上说，你可以自由选择使用的空白量，尽管在某些情况下，空白的存在或不存在具有意义。

Perl 6 code is also free-form, in the sense that you are mostly free to chose the amount of whitespace you use, though in some cases, the presence or absence of whitespace carries meaning.

所以你可以写

So you can write

```Perl6
if True {
    say "Hello";
}
```

或
or

```Perl6
    if True {
say "Hello"; # Bad indentation intended
        }
```

或
or

```Perl6
if True { say "Hello" }
```

甚至
or even

```Perl6
if True {say "Hello"}
```

尽管你不能遗漏任何剩余的空白。

though you can't leave out any of the remaining whitespace.

## 反空格 / Unspace

在编译器不允许空格的许多地方，只要用反斜杠引起来，就可以使用任意数量的空格。不支持标记中的非空格。编译器生成行号时，反空格的新行仍然算数。反空格的用例是后缀操作符和例程参数列表的分离。

In many places where the compiler would not allow a space you can use any amount of whitespace, as long as it is quoted with a backslash. Unspaces in tokens are not supported. Newlines that are unspaced still count when the compiler produces line numbers. Use cases for unspace are separation of postfix operators and routine argument lists.

```Perl6
sub alignment(+@l) { +@l };
sub long-name-alignment(+@l) { +@l };
alignment\         (1,2,3,4).say;
long-name-alignment(3,5)\   .say;
say Inf+Inf\i;
```

在本例中，我们的目的是使两个语句的 `.` 和括号对齐，因此我们在用于填充的空白之前加上 `\`。

In this case, our intention was to make the `.` of both statements, as well as the parentheses, align, so we precede the whitespace used for padding with a `\`.

## 用分号分隔语句 / Separating statements with semicolons

Perl 6 程序是一个语句列表，用分号 `;` 分隔。

A Perl 6 program is a list of statements, separated by semicolons `;`.

```Perl6
say "Hello";
say "world";
```

在最后一个语句之后（或代码块内的最后一个语句之后）的分号是可选的。

A semicolon after the final statement (or after the final statement inside a block) is optional.

```Perl6
say "Hello";
say "world"
if True {
    say "Hello"
}
say "world"
```

## 隐含分隔符规则（对于以代码块结尾的语句） / Implied separator rule (for statements ending in blocks)

以裸块结尾的完整语句可以省略后面的分号，如果在同一行中没有其他语句跟在块的右大括号 `}` 后面。这被称为“隐含分隔符规则”。例如，你不需要在上面和下面看到的 `if` 语句块后面写分号。

Complete statements ending in bare blocks can omit the trailing semicolon, if no additional statements on the same line follow the block's closing curly brace `}`. This is called the "implied separator rule." For example, you don't need to write a semicolon after an `if` statement block as seen above, and below.

```Perl6
if True { say "Hello" }
say "world";
```

但是，要将块与同一行中的后续语句分隔开，需要分号。

However, semicolons are required to separate a block from trailing statements in the same line.

```Perl6
if True { say "Hello" }; say "world";
#                     ^^^ this ; is required
```

除了控制语句之外，这个隐含语句分隔符规则还可以以其他方式应用，这些方式可以以一个裸块结束。例如，与方法调用的冒号 `:` 句法结合使用。

This implied statement separator rule applies in other ways, besides control statements, that could end with a bare block. For example, in combination with the colon `:` syntax for method calls.

```Perl6
my @names = <Foo Bar Baz>;
my @upper-case-names = @names.map: { .uc }    # OUTPUT: [FOO BAR BAZ]
```

对于属于同一个 `if`/`elsif`/`else`（或类似）构造的一系列块，隐含的分隔规则仅适用于该系列最后一个块的末尾。这三个是等价的：

For a series of blocks that are part of the same `if`/`elsif`/`else` (or similar) construct, the implied separator rule only applies at the end of the last block of that series. These three are equivalent:

```Perl6
if True { say "Hello" } else { say "Goodbye" }; say "world";
#                                            ^^^ this ; is required
if True { say "Hello" } else { say "Goodbye" } # <- implied statement separator
say "world";

if True { say "Hello" }   # still in the middle of an if/else statement
else    { say "Goodbye" } # <- no semicolon required because it ends in a block
                          #    without trailing statements in the same line
say "world";
```

## 注释 / Comments

注释是程序文本的一部分，仅面向人类读者；Perl 6 编译器不会将它们作为程序文本进行计算。它们是*非环境*代码的一部分，包括 *Pod 6* 文本。

Comments are parts of the program text which are only intended for human readers; the Perl 6 compilers do not evaluate them as program text. They are part of the *non-ambient* code that includes *Pod 6* text.

在缺少或存在空白可以消除可能的语法分析歧义的地方，注释算作空白。

Comments count as whitespace in places where the absence or presence of whitespace disambiguates possible parses.

### 单行注释 / Single-line comments

Perl 6 中最常见的注释形式是从单个 `#` 字符开始，一直到行尾。

The most common form of comments in Perl 6 starts with a single hash character `#` and goes until the end of the line.

```Perl6
if $age > 250 {     # catch obvious outliers
    # this is another comment!
    die "That doesn't look right"
}
```

### 多行/嵌入注释 - Multi-line / embedded comments

多行和嵌入的注释以散列字符开头，后跟一个反撇号，然后是一些开始的括号字符，最后是匹配的结束括号字符。只有成对的字符（）、{}、[] 和 <> 才对限制注释块有效。（不同于匹配和替换，其中的成对如 !!、|| 或 @ 可以使用。）内容不仅可以跨多行，还可以内嵌。

Multi-line and embedded comments start with a hash character, followed by a backtick, and then some opening bracketing character, and end with the matching closing bracketing character. Only the paired characters (), {}, [], and <> are valid for bounding comment blocks. (Unlike matches and substitutions, where pairs such as !!, || or @ may be used.) The content can not only span multiple lines, but can also be embedded inline.

```Perl6
if #`( why would I ever write an inline comment here? ) True {
    say "something stupid";
}
```

这些注释可以扩展多行

These comments can extend multiple lines

```Perl6
#`[
And this is how a multi would work.
That says why we do what we do below.
]
say "No more";
```

注释中的大括号可以嵌套，因此在 `#`{ a { b } c }` 中，注释一直到字符串的最末端。你也可以使用多个大括号，例如 `#`{{ double-curly-brace }}`，这可能有助于消除嵌套分隔符的歧义。只要不在关键字或标识符中间插入这些注释，就可以将它们嵌入表达式中。

Curly braces inside the comment can be nested, so in `#`{ a { b } c }`, the comment goes until the very end of the string. You may also use multiple curly braces, such as `#`{{ double-curly-brace }}`, which might help disambiguate from nested delimiters. You can embed these comments in expressions, as long as you don't insert them in the middle of keywords or identifiers.

### Pod 注释 / Pod comments

Pod 句法可用于多行注释

Pod syntax can be used for multi-line comments

```Perl6
say "this is code";

=begin comment

Here are several
lines
of comment

=end comment

say 'code again';
```

## 标识符 / Identifiers

标识符是语法构建块，可用于给实体/对象命名，例如常量、变量（例如“标量”和例程（例如 `Sub` 和对象方法）。在[变量名](https://docs.perl6.org/language/variables)中，任何标记（和符号）都位于标识符之前，不构成标识符的一部分。

Identifiers are grammatical building blocks that may be used to give a name to entities/objects such as constants, variables (e.g. `Scalar`s) and routines (e.g. `Sub`s and Methods). In a [variable name](https://docs.perl6.org/language/variables), any sigil (and twigil) precedes the identifier and does not form a part thereof.

```Perl6
constant c = 299792458;     # identifier "c" names an Int
my $a = 123;                # identifier "a" in the name "$a" of a Scalar
sub hello { say "Hello!" }; # identifier "hello" names a Sub
```

标识符有不同的形式：普通标识符、扩展标识符和复合标识符。

Identifiers come in different forms: ordinary, extended, and compound identifiers.

### 普通标识符 / Ordinary identifiers

普通标识符由一个前导字母字符组成，该字符可以后跟一个或多个字母数字字符。它还可以包含独立的、嵌入的撇号 `'` 和/或连字符 `-`，前提是下一个字符是字母。

An ordinary identifier is composed of a leading alphabetic character which may be followed by one or more alphanumeric characters. It may also contain isolated, embedded apostrophes `'` and/or hyphens `-`, provided that the next character is each time alphabetic.

“字母”和“字母数字”的定义包括适当的 Unicode 字符。哪些字符“合适”取决于实现。在 Rakudo/MoarVM Perl 6 实现中，字母字符包括具有 Unicode 通用类别值 *Letter* (L) 和下划线 `_` 的字符。字母数字字符还包括 Unicode 通用类别值 *数字、十进制数字*（Nd）的字符。

The definitions of "alphabetic" and "alphanumeric" include appropriate Unicode characters. Which characters are "appropriate" depends on the implementation. In the Rakudo/MoarVM Perl 6 implementation alphabetic characters include characters with the Unicode General Category value *Letter* (L), and the underscore `_`. Alphanumeric characters additionally include characters with the Unicode General Category value *Number, Decimal Digit* (Nd).

```Perl6
# valid ordinary identifiers:
x
_snake_oil
something-longer
with-numbers1234
don't-do-that
piece_of_π
駱駝道              # "Rakuda-dō", Japanese for "Way of the camel"
# invalid ordinary identifiers:
42                 # identifier does not start with alphabetic character
with-numbers1234-5 # embedded hyphen not followed by alphabetic character
is-prime?          # question mark is not alphanumeric
x²                 # superscript 2 is not alphanumeric (explained above)
```

### 扩展标识符 / Extended identifiers

通常，名称包含普通标识符中不允许使用的字符是很方便的。用例包括这样的情况：一组实体共享一个通用的“短”名称，但仍然需要单独标识其每个元素。例如，可以使用短名称为 `Dog` 的模块，而长名称包括其命名机构和版本：

It is often convenient to have names that contain characters that are not allowed in ordinary identifiers. Use cases include situations where a set of entities shares a common "short" name, but still needs for each of its elements to be identifiable individually. For example, you might use a module whose short name is `Dog`, while its long name includes its naming authority and version:

```Perl6
Dog:auth<Somebody>:ver<1.0>  # long module names including author and version
Dog:auth<Somebody>:ver<2.0>

use Dog:auth<Somebody>:ver<2.0>;
# Selection of second module causes its full name to be aliased to the
# short name for the rest of # the lexical scope, allowing a declaration
# like this.
my Dog $spot .= new("woof");
```

类似地，一组运算符在不同的语法类别中协同工作，它们的名称有 `prefix`、`infix` 和 `postfix`。这些运算符的正式名称通常包含从普通标识符中排除的字符。长名称是扩展标识符的组成部分，包含此语法类别；短名称将包含在定义中的引号中：

Similarly, sets of operators work together in various syntactic categories with names like `prefix`, `infix` and `postfix`. The official names of these operators often contain characters that are excluded from ordinary identifiers. The long name is what constitutes the extended identifier, and includes this syntactic category; the short name will be included in quotes in the definition:

```Perl6
infix:<+>                 # the official name of the operator in $a + $b
infix:<*>                 # the official name of the operator in $a * $b
infix:«<=»                # the official name of the operator in $a <= $b
```

对于所有这些用途，可以将一个或多个冒号分隔的字符串附加到普通标识符，以创建所谓的*扩展标识符*。当附加到标识符（即在后缀位置）时，这个冒号分隔的字符串生成该标识符的唯一变体。

For all such uses, you can append one or more colon-separated strings to an ordinary identifier to create a so-called *extended identifier*. When appended to an identifier (that is, in postfix position), this colon-separated string generates unique variants of that identifier.

这些字符串的格式为 `:key<value>`，其中 `key` *或* `value` 是可选的；也就是说，在将其与常规标识符分隔开的冒号之后，将有一个 `key` 和/或一个引号括住的结构，如 `< >`，`« »` 或 `[' ']`，它引用一个或多个任意字符 `value`.[[1\]](https://docs.perl6.org/language/syntax#fn-1)

These strings have the form `:key<value>`, wherein `key` *or* `value` are optional; that is, after the colon that separates it from a regular identifier, there will be a `key` and/or a quoting bracketing construct such as `< >`, `« »` or `[' ']` which quotes one or more arbitrary characters `value`.[[1\]](https://docs.perl6.org/language/syntax#fn-1)

```Perl6
# exemplary valid extended identifiers:
postfix:<²>               # the official long name of the operator in $x²
WOW:That'sAwesome
WOW:That's<<🆒>>
party:sweet<16>

# exemplary invalid extended identifiers:
party:16<sweet>           # 16 is not an ordinary identifier
party:16sweet
party:!a                  # ...and neither is !a
party:$a                  # ...nor $a
```

在扩展标识符中，后缀字符串被视为名称的不可分割的一部分，因此 `infix:<+>` 和 `infix:<->` 是两个不同的运算符。但是，使用的括号字符不算作其中的一部分；只有引用的数据才重要。所以这些都是同一个名字：

In an extended identifier, the postfix string is considered an integral part of the name, so `infix:<+>` and `infix:<->` are two different operators. The bracketing characters used, however, do not count as part of it; only the quoted data matters. So these are all the same name:

```Perl6
infix:<+>
infix:<<+>>
infix:«+»
infix:['+']
infix:('+')
```

同样，所有这些都起作用：

Similarly, all of this works:

```Perl6
my $foo:bar<baz> = 'quux';
say $foo:bar«baz»;                               # OUTPUT: «quux␤»
my $take-me:<home> = 'Where the glory has no end';
say $take-me:['home'];                           # OUTPUT: «Where [...]␤»
my $foo:bar<2> = 5;
say $foo:bar(1+1);                               # OUTPUT: «5␤»
```

如果扩展标识符包含两个或多个冒号对，则它们的顺序通常是重要的：

Where an extended identifier comprises two or more colon pairs, their order is generally significant:

```Perl6
my $a:b<c>:d<e> = 100;
my $a:d<e>:b<c> = 200;
say $a:b<c>:d<e>;               # OUTPUT: «100␤», NOT: «200␤»
```

此规则的一个例外是*模块版本控制*；因此这些标识符有效地命名了同一个模块：

An exception to this rule is *module versioning*; so these identifiers effectively name the same module:

```Perl6
use ThatModule:auth<Somebody>:ver<2.7.18.28.18>
use ThatModule:ver<2.7.18.28.18>:auth<Somebody>
```

此外，扩展标识符支持编译时插值；这要求对插值值使用[常量](https://docs.perl6.org/language/terms#Constants)：

Furthermore, extended identifiers support compile-time interpolation; this requires the use of [constants](https://docs.perl6.org/language/terms#Constants) for the interpolation values:

```Perl6
constant $c = 42;  # Constant binds to Int; $-sigil enables interpolation
my $a:foo<42> = "answer";
say $a:foo«$c»;    # OUTPUT: «answer␤»
```

尽管引用方括号结构在标识符上下文中通常是可互换的，但它们并不相同。特别是，尖括号 `< >`（模拟单引号插值特性）不能用于常量名称的插值。

Although quoting bracketing constructs are generally interchangeable in the context of identifiers, they are not identical. In particular, angle brackets `< >` (which mimic single quote interpolation characteristics) cannot be used for the interpolation of constant names.

```Perl6
constant $what = 'are';
my @we:<are>= <the champions>;
say @we:«$what»;     # OUTPUT: «[the champions]␤»
say @we:<$what>;
# Compilation error: Variable '@we:<$what>' is not declared
```

### 复合标识符 / Compound identifiers

复合标识符是由两个或多个普通和/或扩展标识符组成的标识符，这些标识符之间用双冒号 `::`。

A compound identifier is an identifier that is composed of two or more ordinary and/or extended identifiers that are separated from one another by a double colon `::`.

双冒号 `::` 称为*名称空间分隔符*或*包分隔符*，它在名称中澄清了其语义功能：强制将名称的前一部分视为[包](https://docs.perl6.org/language/packages)/名称空间，通过该名称空间，后面的部分如果要查找名称：

The double colon `::` is known as the *namespace separator* or the *package delimiter*, which clarifies its semantic function in a name: to force the preceding portion of the name to be considered a [package](https://docs.perl6.org/language/packages)/namespace through which the subsequent portion of the name is to be located:

```Perl6
module MyModule {               # declare a module package
    our $var = "Hello";         # declare package-scoped variable
}
say $MyModule::var              # OUTPUT: «Hello␤»
```

在上面的示例中，`MyModule::var` 是一个复合标识符，由包名标识符 `MyModule` 和变量名 `var` 的标识符部分组成。总之，`$MyModule::var` 通常被称为[包限定名](https://docs.perl6.org/language/packages#Package-qualified_names)。

In the example above, `MyModule::var` is a compound identifier, composed of the package name identifier `MyModule` and the identifier part of the variable name `var`. Altogether `$MyModule::var` is often referred to as a [package-qualified name](https://docs.perl6.org/language/packages#Package-qualified_names).

用双冒号分隔标识符会导致将最右边的名称插入现有的（请参见上面的示例）*或自动创建的*包：

Separating identifiers with double colons causes the rightmost name to be inserted into existing (see above example) *or automatically created* packages:

```Perl6
my $foo::bar = 1;
say OUR::.keys;           # OUTPUT: «(foo)␤»
say OUR::foo.HOW          # OUTPUT: «Perl6::Metamodel::PackageHOW.new␤»
```

最后一行显示了 `foo` 包是如何自动创建的，作为该命名空间中变量的存放。

The last lines shows how the `foo` package was created automatically, as a deposit for variables in that namespace.

双冒号句法允许将字符串的运行时[插值](https://docs.perl6.org/language/packages#Interpolating_into_names)使用 `::($expr)` 将字符串插入到包或变量名中，通常将包或变量名放在那里：

The double colon syntax enables runtime [interpolation](https://docs.perl6.org/language/packages#Interpolating_into_names) of a string into a package or variable name using `::($expr)` where you'd ordinarily put a package or variable name:

```Perl6
my $buz = "quux";
my $bur::quux = 7;
say $bur::($buz);               # OUTPUT: «7␤»
```

## 术语 term:<> / term term:<>

你可以使用 `term:<>` 引入新的术语，这对于引入违反常规标识符规则的常量非常方便：

You can use `term:<>` to introduce new terms, which is handy for introducing constants that defy the rules of normal identifiers:

```Perl6
use Test; plan 1; constant &term:<👍> = &ok.assuming(True);
👍
# OUTPUT: «1..1␤ok 1 - ␤»
```

但是术语不必是常量：你还可以将它们用于不带任何参数的函数，并强制解析器在它们后面有运算符。例如：

But terms don't have to be constant: you can also use them for functions that don't take any arguments, and force the parser to expect an operator after them. For instance:

```Perl6
sub term:<dice> { (1..6).pick };
say dice + dice;
```

可以打印 2 到 12 之间的任意数字。

can print any number between 2 and 12.

如果我们把“骰子”声明为

If instead we had declared `dice` as a regular

```Perl6
sub dice() {(1...6).pick }
```

，表达式 `dice + dice` 将被解析为 `dice(+(dice()))`，这会导致错误，因为 `sub dice` 需要零个参数。

, the expression `dice + dice` would be parsed as `dice(+(dice()))`, resulting in an error since `sub dice` expects zero arguments.

# 语句和表达式 / Statements and expressions

Perl 6 程序由语句列表组成。语句的特殊情况是返回值的*表达式*。例如，`if True { say 42 }` 在语法上是一个语句，但不是一个表达式，而 `1 + 2` 是一个表达式（因此也是一个语句）。

Perl 6 programs are made of lists of statements. A special case of a statement is an *expression*, which returns a value. For example `if True { say 42 }` is syntactically a statement, but not an expression, whereas `1 + 2` is an expression (and thus also a statement).

`do` 前缀将语句转换为表达式。所以

The `do` prefix turns statements into expressions. So while

```Perl6
my $x = if True { 42 };     # Syntax error!
```

是错误的，

is an error,

```Perl6
my $x = do if True { 42 };
```

将 if 语句（此处为 `42`）的返回值赋给变量 `$x`。

assigns the return value of the if statement (here `42`) to the variable `$x`.

# 术语 / Terms

术语是基本名词，可以选择与运算符一起构成表达式。例如变量（`$x`）、类型名（`Int`）、文本（`42`）、声明（`sub f() { }`）和调用（`f()`）。

Terms are the basic nouns that, optionally together with operators, can form expressions. Examples for terms are variables (`$x`), barewords such as type names (`Int`), literals (`42`), declarations (`sub f() { }`) and calls (`f()`).

例如，在表达式 `2 * $salary` 中，`2` 和 `$salary` 是两个术语（一个[整数](https://docs.perl6.org/type/Int)文本和一个[变量](https://docs.perl6.org/language/variables)）。

For example, in the expression `2 * $salary`, `2` and `$salary` are two terms (an [integer](https://docs.perl6.org/type/Int) literal and a [variable](https://docs.perl6.org/language/variables)).

## 变量 / Variables

变量通常以名为 *sigil* 的特殊字符开头，后跟标识符。必须先声明变量，然后才能使用它们。

Variables typically start with a special character called the *sigil*, and are followed by an identifier. Variables must be declared before you can use them.

```Perl6
# declaration:
my $number = 21;
# usage:
say $number * 2;
```

有关详细信息，请参阅[变量文档](https://docs.perl6.org/language/variables)。

See the [documentation on variables](https://docs.perl6.org/language/variables) for more details.

## 裸字（常量、类型名）/ Barewords (constants, type names)

预先声明的标识符可以是自己的术语。这些通常是类型名或常量，但也有 `self` 一词，它指的是调用方法的对象（参见[对象](https://docs.perl6.org/language/objects)），以及无标记变量：

Pre-declared identifiers can be terms on their own. Those are typically type names or constants, but also the term `self` which refers to an object that a method was called on (see [objects](https://docs.perl6.org/language/objects)), and sigilless variables:

```Perl6
say Int;                # OUTPUT: «(Int)␤»
#   ^^^ type name (built in)

constant answer = 42;
say answer;
#   ^^^^^^ constant

class Foo {
    method type-name {
        self.^name;
      # ^^^^ built-in term 'self'
    }
}
say Foo.type-name;     # OUTPUT: «Foo␤»
#   ^^^ type name
```

## 包和限定名 / Packages and qualified names

命名实体（如变量、常量、类、模块或子）是命名空间的一部分。名称的嵌套部分使用 `::` 分隔层次结构。一些例子：

Named entities, such as variables, constants, classes, modules or subs, are part of a namespace. Nested parts of a name use `::` to separate the hierarchy. Some examples:

```Perl6
$foo                # simple identifiers
$Foo::Bar::baz      # compound identifiers separated by ::
$Foo::($bar)::baz   # compound identifiers that perform interpolations
Foo::Bar::bob(23)   # function invocation given qualified name
```

有关详细信息，请参阅[软件包文档](https://docs.perl6.org/language/packages)。

See the [documentation on packages](https://docs.perl6.org/language/packages) for more details.

## 字面量 / Literals

[字面量](https://en.wikipedia.org/wiki/Literal_%28computer_programming%29)是源代码中常量值的表示。Perl 6 有几个内置类型的字面量，比如 [字符](https://docs.perl6.org/type/Str)、几个数字类型、[键值对](https://docs.perl6.org/type/Pair) 等等。

A [literal](https://en.wikipedia.org/wiki/Literal_%28computer_programming%29) is a representation of a constant value in source code. Perl 6 has literals for several built-in types, like [strings](https://docs.perl6.org/type/Str), several numeric types, [pairs](https://docs.perl6.org/type/Pair) and more.

### 字符串字面量 / String literals

字符串字面量由引号包围：

String literals are surrounded by quotes:

```Perl6
say 'a string literal';
say "a string literal\nthat interprets escape sequences";
```

请参阅[引用](https://docs.perl6.org/language/quoting)了解更多选项，包括[转义引用 `q`](https://docs.perl6.org/language/quoting#Escaping:_q)。Perl 6 在字面量中使用标准转义符： `\a \b \t \n \f \r \e`，其含义与[设计文档](https://design.perl6.org/S02.html#Backslash_sequences)中指定的ASCII转义码相同。

See [quoting](https://docs.perl6.org/language/quoting) for many more options, including [the escaping quoting `q`](https://docs.perl6.org/language/quoting#Escaping:_q). Perl 6 uses the standard escape characters in literals: `\a \b \t \n \f \r \e`, with the same meaning as the ASCII escape codes, specified in [the design document](https://design.perl6.org/S02.html#Backslash_sequences).

```Perl6
say "🔔\a";  # OUTPUT: «🔔␇␤»
```

### 数字字面量 / Number literals

数字字面值通常以十为基数指定（如果需要，可以通过前缀 `0d` 逐字指定），除非像 `0x`（he**x**adecimal，基数 16）、`0o`（**o**ctal，基数 8）或 `0b`（**b**inary，基数 2）这样的前缀或像 `:16<A0>` 这样显式指定基数。与其他编程语言不同，前导零*不*表示基数 8；而是发出编译时警告。

Number literals are generally specified in base ten (which can be specified literally, if needed, via the prefix `0d`), unless a prefix like `0x` (he**x**adecimal, base 16), `0o` (**o**ctal, base 8) or `0b` (**b**inary, base 2) or an explicit base in adverbial notation like `:16<A0>` specifies it otherwise. Unlike other programming languages, leading zeros do *not* indicate base 8; instead a compile-time warning is issued.

在所有文字格式中，可以使用下划线对数字进行分组，尽管它们不包含任何语义信息；以下文字的计算结果都相同：

In all literal formats, you can use underscores to group digits, although they don't carry any semantic information; the following literals all evaluate to the same number:

```Perl6
1000000
1_000_000
10_00000
100_00_00
```

#### `Int` 字面量 / `Int` literals

整数默认为带符号的 10 进制数，但可以使用其他基数。有关详细信息，请参见 [Int](https://docs.perl6.org/type/Int)。

Integers default to signed base-10, but you can use other bases. For details, see [Int](https://docs.perl6.org/type/Int).

```Perl6
# not a single literal, but unary - operator applied to numeric literal 2
-2
12345
0xBEEF      # base 16
0o755       # base 8
:3<1201>    # arbitrary base, here base 3
```

#### `Rat` 字面量 / `Rat` literals

[Rat](https://docs.perl6.org/type/Rat) 字面量（有理数）非常常见，在许多其他语言中取代了小数或浮点数。整数除法也会产生 `Rat`。

[Rat](https://docs.perl6.org/type/Rat) literals (rationals) are very common, and take the place of decimals or floats in many other languages. Integer division also results in a `Rat`.

```Perl6
1.0
3.14159
-2.5        # Not actually a literal, but still a Rat
:3<21.0012> # Base 3 rational
⅔
2/3         # Not actually a literal, but still a Rat
```

#### `Num` 字面量 / `Num` literals

在 `e` 之后以十进制数为基数的指数的科学表示法生成[浮点数](https://docs.perl6.org/type/Num)：

Scientific notation with an integer exponent to base ten after an `e` produces [floating point number](https://docs.perl6.org/type/Num):

```Perl6
1e0
6.022e23
1e-9
-2e48
2e2.5       # error
```

#### `Complex` 字面量 / `Complex` literals

[复数](https://docs.perl6.org/type/Complex)数字可以写成虚数（这只是一个附加后缀 `i` 的有理数），也可以写成实数和虚数之和：

[Complex](https://docs.perl6.org/type/Complex) numbers are written either as an imaginary number (which is just a rational number with postfix `i` appended), or as a sum of a real and an imaginary number:

```Perl6
1+2i
6.123e5i    # note that this is 6.123e5 * i, not 6.123 * 10 ** (5i)
```

### 键值对字面量 / Pair literals

[键值对](https://docs.perl6.org/type/Pair)由一个键和一个值组成，构造它们有两种基本形式：`key => 'value'` 和 `:key('value')`。

[Pairs](https://docs.perl6.org/type/Pair) are made of a key and a value, and there are two basic forms for constructing them: `key => 'value' `and `:key('value')`.

#### 箭头键值对 / Arrow pairs

箭头键值对可以有一个表达式、一个字符串字面量或一个“裸标识符”，这是一个具有普通标识符语法的字符串，在左侧不需要引号：

Arrow pairs can have an expression, a string literal or a "bare identifier", which is a string with ordinary-identifier syntax that does not need quotes on the left-hand side:

```Perl6
like-an-identifier-ain't-it => 42
"key" => 42
('a' ~ 'b') => 1
```

#### 状语键值对（冒号键值对）/ Adverbial pairs (colon pairs)

没有明确值的短格式：

Short forms without explicit values:

```Perl6
my $thing = 42;
:$thing                 # same as  thing => $thing
:thing                  # same as  thing => True
:!thing                 # same as  thing => False
```

变量表单还可以与其他标记一起使用，比如 `:&callback` 或 `:@elements`。如果该值是数字字面量，则也可以用以下简短形式表示：

The variable form also works with other sigils, like `:&callback` or `:@elements`. If the value is a number literal, it can also be expressed in this short form:

```Perl6
:42thing            # same as  thing => 42
:٤٢thing            # same as  thing => 42
```

如果你用另一个字母表，这个顺序是颠倒的

This order is inverted if you use another alphabet

```Perl6
:٤٢ث              # same as   ث => ٤٢
```

*thaa* 字母在数字前面。

the *thaa* letter precedes the number.

具有明确值的长格式：

Long forms with explicit values:

```Perl6
:thing($value)              # same as  thing => $value
:thing<quoted list>         # same as  thing => <quoted list>
:thing['some', 'values']    # same as  thing => ['some', 'values']
:thing{a => 'b'}            # same as  thing => { a => 'b' }
```

### 布尔值字面量 / Boolean literals

`True` 和 `False` 是布尔值字面量；它们的首字母总是大写。

`True` and `False` are Boolean literals; they will always have initial capital letter.

### 数组字面量 / Array literals

一对方括号可以包围一个表达式以形成逐项[数组](https://docs.perl6.org/type/Array)字面量；通常在以下内容中有一个逗号分隔的列表：

A pair of square brackets can surround an expression to form an itemized [Array](https://docs.perl6.org/type/Array) literal; typically there is a comma-delimited list inside:

```Perl6
say ['a', 'b', 42].join(' ');   # OUTPUT: «a b 42␤»
#   ^^^^^^^^^^^^^^ Array constructor
```

如果给构造函数一个 [Iterable](https://docs.perl6.org/type/Iterable)，它将克隆并展平它。如果只需要一个 `Iterable` 元素的 `Array`，请确保在其后使用逗号：

If the constructor is given a single [Iterable](https://docs.perl6.org/type/Iterable), it'll clone and flatten it. If you want an `Array` with just 1 element that is an `Iterable`, ensure to use a comma after it:

```Perl6
my @a = 1, 2;
say [@a].perl;  # OUTPUT: «[1, 2]␤»
say [@a,].perl; # OUTPUT: «[[1, 2],]␤»
```

`Array` 构造函数不展平其他类型的内容。使用 [Slip](https://docs.perl6.org/type/Slip) 前缀运算符 (`|`) 压平所需的项：

The `Array` constructor does not flatten other types of contents. Use the [Slip](https://docs.perl6.org/type/Slip) prefix operator (`|`) to flatten the needed items:

```Perl6
my @a = 1, 2;
say [@a, 3, 4].perl;  # OUTPUT: «[[1, 2], 3, 4]␤»
say [|@a, 3, 4].perl; # OUTPUT: «[1, 2, 3, 4]␤»
```

[列表](https://docs.perl6.org/type/List)类型可以从数组字面量声明中显式创建，无需从数组强制，在声明时使用**is** [特性](https://docs.perl6.org/language/traits)。

[List](https://docs.perl6.org/type/List) type can be explicitly created from an array literal declaration without a coercion from Array, using **is** [trait](https://docs.perl6.org/language/traits) on declaration.

```Perl6
my @a is List = 1, 2; # a List, not an Array
# wrong: creates an Array of Lists
my List @a;
```

### Hash literals

A leading associative sigil and pair of parenthesis `%( )` can surround a `List` of `Pairs` to form a [Hash](https://docs.perl6.org/type/Hash) literal; typically there is a comma-delimited `List` of `Pairs` inside. If a non-pair is used, it is assumed to be a key and the next element is the value. Most often this is used with simple arrow pairs.

```Perl6
say %( a => 3, b => 23, :foo, :dog<cat>, "french", "fries" );
# OUTPUT: «a => 3, b => 23, dog => cat, foo => True, french => fries␤»

say %(a => 73, foo => "fish").keys.join(" ");   # OUTPUT: «a foo␤»
#   ^^^^^^^^^^^^^^^^^^^^^^^^^ Hash constructor
```

When assigning to a `%`-sigiled variable on the left-hand side, the sigil and parenthesis surrounding the right-hand side `Pairs`are optional.

```Perl6
my %ages = fred => 23, jean => 87, ann => 4;
```

By default, keys in `%( )` are forced to strings. To compose a hash with non-string keys, use curly brace delimiters with a colon prefix `:{ }` :

```Perl6
my $when = :{ (now) => "Instant", (DateTime.now) => "DateTime" };
```

Note that with objects as keys, you cannot access non-string keys as strings:

```Perl6
say :{ -1 => 41, 0 => 42, 1 => 43 }<0>;  # OUTPUT: «(Any)␤»
say :{ -1 => 41, 0 => 42, 1 => 43 }{0};  # OUTPUT: «42␤»
```

Particular types that implement [Associative](https://docs.perl6.org/type/Associative) role, [Map](https://docs.perl6.org/type/Map) (including [Hash](https://docs.perl6.org/type/Hash) and [Stash](https://docs.perl6.org/type/Stash) subclasses) and [QuantHash](https://docs.perl6.org/type/QuantHash) (and its subclasses), can be explicitly created from a hash literal without a coercion, using **is** [trait](https://docs.perl6.org/language/traits) on declaration:

```Perl6
my %hash;                    # Hash
my %hash is Hash;            # explicit Hash
my %map is Map;              # Map
my %stash is Stash;          # Stash

my %quant-hash is QuantHash; # QuantHash

my %setty is Setty;          # Setty
my %set is Set;              # Set
my %set-hash is SetHash;     # SetHash

my %baggy is Baggy;          # Baggy
my %bag is Bag;              # Bag
my %bag-hash is BagHash;     # BagHash

my %mixy is Mixy;            # Mixy
my %mix is Mix;              # Mix
my %mix-hash is MixHash;     # MixHash
```

Note that using a usual type declaration with a hash sigil creates a typed Hash, not a particular type:

```Perl6
# This is wrong: creates a Hash of Mixes, not Mix:
my Mix %mix;
# Works with $ sigil:
my Mix $mix;
# Can be typed:
my Mix[Int] $mix-of-ints;
```

### Regex literals

A [Regex](https://docs.perl6.org/type/Regex) is declared with slashes like `/foo/`. Note that this `//` syntax is shorthand for the full `rx//` syntax.

```Perl6
/foo/          # Short version
rx/foo/        # Longer version
Q :regex /foo/ # Even longer version

my $r = /foo/; # Regexes can be assigned to variables
```

### Signature literals

Signatures can be used standalone for pattern matching, in addition to the typical usage in sub and block declarations. A standalone signature is declared starting with a colon:

```Perl6
say "match!" if 5, "fish" ~~ :(Int, Str); # OUTPUT: «match!␤»

my $sig = :(Int $a, Str);
say "match!" if (5, "fish") ~~ $sig; # OUTPUT: «match!␤»

given "foo", 42 {
  when :(Str, Str) { "This won't match" }
  when :(Str, Int $n where $n > 20) { "This will!" }
}
```

See the [Signatures](https://docs.perl6.org/type/Signature) documentation for more about signatures.

## Declarations

### Variable declaration

```Perl6
my $x;                          # simple lexical variable
my $x = 7;                      # initialize the variable
my Int $x = 7;                  # declare the type
my Int:D $x = 7;                # specify that the value must be defined (not undef)
my Int $x where { $_ > 3 } = 7; # constrain the value based on a function
my Int $x where * > 3 = 7;      # same constraint, but using Whatever shorthand
```

See [Variable Declarators and Scope](https://docs.perl6.org/language/variables#Variable_declarators_and_scope) for more details on other scopes (`our`, `has`).

### Subroutine declaration

```Perl6
# The signature is optional
sub foo { say "Hello!" }

sub say-hello($to-whom) { say "Hello $to-whom!" }
```

You can also assign subroutines to variables.

```Perl6
my &f = sub { say "Hello!" } # Un-named sub
my &f = -> { say "Hello!" }  # Lambda style syntax. The & sigil indicates the variable holds a function
my $f = -> { say "Hello!" }  # Functions can also be put into scalars
```

### `Package`, `Module`, `Class`, `Role`, and `Grammar` declaration

There are several types of package, each declared with a keyword, a name, some optional traits, and a body of subroutines, methods, or rules.

```Perl6
package P { }

module M { }

class C { }

role R { }

grammar G { }
```

Several packages may be declared in a single file. However, you can declare a `unit` package at the start of the file (preceded only by comments or `use` statements), and the rest of the file will be taken as being the body of the package. In this case, the curly braces are not required.

```Perl6
unit module M;
# ... stuff goes here instead of in {}'s
```

### Multi-dispatch declaration

See also [Multi-dispatch](https://docs.perl6.org/language/functions#Multi-dispatch).

Subroutines can be declared with multiple signatures.

```Perl6
multi sub foo() { say "Hello!" }
multi sub foo($name) { say "Hello $name!" }
```

Inside of a class, you can also declare multi-dispatch methods.

```Perl6
multi method greet { }
multi method greet(Str $name) { }
```

# Subroutine calls

Subroutines are created with the keyword `sub` followed by an optional name, an optional signature and a code block. Subroutines are lexically scoped, so if a name is specified at the declaration time, the same name can be used in the lexical scope to invoke the subroutine. A subroutine is an instance of type [Sub](https://docs.perl6.org/type/Sub) and can be assigned to any container.

```Perl6
foo;   # Invoke the function foo with no arguments
foo(); # Invoke the function foo with no arguments
&f();  # Invoke &f, which contains a function
&f.(); # Same as above, needed to make the following work
my @functions = ({say 1}, {say 2}, {say 3});
@functions>>.(); # hyper method call operator
```

When declared within a class, a subroutine is named "method": methods are subroutines invoked against an object (i.e., a class instance). Within a method the special variable `self` contains the object instance (see [Methods](https://docs.perl6.org/language/classtut#Methods)).

```Perl6
# Method invocation. Object (instance) is $person, method is set-name-age
$person.set-name-age('jane', 98);   # Most common way
$person.set-name-age: 'jane', 98;   # Precedence drop
set-name-age($person: 'jane', 98);  # Invocant marker
set-name-age $person: 'jane', 98;   # Indirect invocation
```

For more information, see [functions](https://docs.perl6.org/language/functions).

## Precedence drop

In the case of method invocation (i.e., when invoking a subroutine against a class instance) it is possible to apply the `precedence drop`, identified by a colon `:` just after the method name and before the argument list. The argument list takes precedence over the method call, that on the other hand "drops" its precedence. In order to better understand consider the following simple example (extra spaces have been added just to align method calls):

```Perl6
my $band = 'Foo Fighters';
say $band.substr( 0, 3 ) .substr( 0, 1 ); # F
say $band.substr: 0, 3   .substr( 0, 1 ); # Foo
```

In the second method call the rightmost `substr` is applied to "3" and not to the result of the leftmost `substr`, which on the other hand yields precedence to the rightmost one.

# Operators

See [Operators](https://docs.perl6.org/language/operators) for lots of details.

Operators are functions with a more symbol heavy and composable syntax. Like other functions, operators can be multi-dispatch to allow for context-specific usage.

There are five types (arrangements) for operators, each taking either one or two arguments.

```Perl6
++$x           # prefix, operator comes before single input
5 + 3          # infix, operator is between two inputs
$x++           # postfix, operator is after single input
<the blue sky> # circumfix, operator surrounds single input
%foo<bar>      # postcircumfix, operator comes after first input and surrounds second
```

## Metaoperators

Operators can be composed. A common example of this is combining an infix (binary) operator with assignment. You can combine assignment with any binary operator.

```Perl6
$x += 5     # Adds 5 to $x, same as $x = $x + 5
$x min= 3   # Sets $x to the smaller of $x and 3, same as $x = $x min 3
$x .= child # Equivalent to $x = $x.child
```

Wrap an infix operator in `[ ]` to create a new reduction operator that works on a single list of inputs, resulting in a single value.

```Perl6
say [+] <1 2 3 4 5>;    # OUTPUT: «15␤»
(((1 + 2) + 3) + 4) + 5 # equivalent expanded version
```

Wrap an infix operator in `« »` (or the ASCII equivalent ``) to create a new hyper operator that works pairwise on two lists.

```Perl6
say <1 2 3> «+» <4 5 6> # OUTPUT: «(5 7 9)␤»
```

The direction of the arrows indicates what to do when the lists are not the same size.

```Perl6
@a «+« @b # Result is the size of @b, elements from @a will be re-used
@a »+» @b # Result is the size of @a, elements from @b will be re-used
@a «+» @b # Result is the size of the biggest input, the smaller one is re-used
@a »+« @b # Exception if @a and @b are different sizes
```

You can also wrap a unary operator with a hyper operator.

```Perl6
say -« <1 2 3> # OUTPUT: «(-1 -2 -3)␤»
```

[[↑\]](https://docs.perl6.org/language/syntax#fn-ref-1) Starting with Perl 6 language version 6.d, colon pairs with `sym` as the `key` (e.g. `:sym<foo>`) are reserved for possible future use.
