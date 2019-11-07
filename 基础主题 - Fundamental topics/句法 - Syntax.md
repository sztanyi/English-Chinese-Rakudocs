原文：https://docs.raku.org/language/syntax

# 句法 / Syntax

Raku 句法的一般规则

General rules of Raku syntax

Raku 从人类语言中借用了许多概念。这并不奇怪，因为它是由语言学家设计的。

Raku borrows many concepts from human language. Which is not surprising, considering it was designed by a linguist.

它在不同的上下文中重用公共元素，有名词（术语）和动词（运算符）的概念，是上下文敏感的（在日常意义上，不一定在计算机科学的解释中），因此一个符号可以有不同的含义，这取决于期望的是一个名词还是动词。

It reuses common elements in different contexts, has the notion of nouns (terms) and verbs (operators), is context-sensitive (in the every day sense, not necessarily in the Computer Science interpretation), so a symbol can have a different meaning depending on whether a noun or a verb is expected.

它也是自计时的，因此解析器可以检测大多数常见错误并给出良好的错误消息。

It is also self-clocking, so that the parser can detect most of the common errors and give good error messages.

<!-- MarkdownTOC -->

- [词法约定 / Lexical conventions](#%E8%AF%8D%E6%B3%95%E7%BA%A6%E5%AE%9A--lexical-conventions)
    - [自由语素 / Free form](#%E8%87%AA%E7%94%B1%E8%AF%AD%E7%B4%A0--free-form)
    - [反空格 / Unspace](#%E5%8F%8D%E7%A9%BA%E6%A0%BC--unspace)
    - [用分号分隔语句 / Separating statements with semicolons](#%E7%94%A8%E5%88%86%E5%8F%B7%E5%88%86%E9%9A%94%E8%AF%AD%E5%8F%A5--separating-statements-with-semicolons)
    - [隐式分隔符规则（以代码块结尾的语句） / Implied separator rule \(for statements ending in blocks\)](#%E9%9A%90%E5%BC%8F%E5%88%86%E9%9A%94%E7%AC%A6%E8%A7%84%E5%88%99%EF%BC%88%E4%BB%A5%E4%BB%A3%E7%A0%81%E5%9D%97%E7%BB%93%E5%B0%BE%E7%9A%84%E8%AF%AD%E5%8F%A5%EF%BC%89--implied-separator-rule-for-statements-ending-in-blocks)
    - [注释 / Comments](#%E6%B3%A8%E9%87%8A--comments)
        - [单行注释 / Single-line comments](#%E5%8D%95%E8%A1%8C%E6%B3%A8%E9%87%8A--single-line-comments)
        - [多行/嵌入注释 - Multi-line / embedded comments](#%E5%A4%9A%E8%A1%8C%E5%B5%8C%E5%85%A5%E6%B3%A8%E9%87%8A---multi-line--embedded-comments)
        - [Pod 注释 / Pod comments](#pod-%E6%B3%A8%E9%87%8A--pod-comments)
    - [标识符 / Identifiers](#%E6%A0%87%E8%AF%86%E7%AC%A6--identifiers)
        - [普通标识符 / Ordinary identifiers](#%E6%99%AE%E9%80%9A%E6%A0%87%E8%AF%86%E7%AC%A6--ordinary-identifiers)
        - [扩展标识符 / Extended identifiers](#%E6%89%A9%E5%B1%95%E6%A0%87%E8%AF%86%E7%AC%A6--extended-identifiers)
        - [复合标识符 / Compound identifiers](#%E5%A4%8D%E5%90%88%E6%A0%87%E8%AF%86%E7%AC%A6--compound-identifiers)
    - [术语 term: / term term:](#%E6%9C%AF%E8%AF%AD-term--term-term)
- [语句和表达式 / Statements and expressions](#%E8%AF%AD%E5%8F%A5%E5%92%8C%E8%A1%A8%E8%BE%BE%E5%BC%8F--statements-and-expressions)
- [术语 / Terms](#%E6%9C%AF%E8%AF%AD--terms)
    - [变量 / Variables](#%E5%8F%98%E9%87%8F--variables)
    - [裸字（常量、类型名）/ Barewords \(constants, type names\)](#%E8%A3%B8%E5%AD%97%EF%BC%88%E5%B8%B8%E9%87%8F%E3%80%81%E7%B1%BB%E5%9E%8B%E5%90%8D%EF%BC%89-barewords-constants-type-names)
    - [包和限定名 / Packages and qualified names](#%E5%8C%85%E5%92%8C%E9%99%90%E5%AE%9A%E5%90%8D--packages-and-qualified-names)
    - [字面量 / Literals](#%E5%AD%97%E9%9D%A2%E9%87%8F--literals)
        - [字符串字面量 / String literals](#%E5%AD%97%E7%AC%A6%E4%B8%B2%E5%AD%97%E9%9D%A2%E9%87%8F--string-literals)
        - [数字字面量 / Number literals](#%E6%95%B0%E5%AD%97%E5%AD%97%E9%9D%A2%E9%87%8F--number-literals)
            - [`Int` 字面量 / `Int` literals](#int-%E5%AD%97%E9%9D%A2%E9%87%8F--int-literals)
            - [`Rat` 字面量 / `Rat` literals](#rat-%E5%AD%97%E9%9D%A2%E9%87%8F--rat-literals)
            - [`Num` 字面量 / `Num` literals](#num-%E5%AD%97%E9%9D%A2%E9%87%8F--num-literals)
            - [`Complex` 字面量 / `Complex` literals](#complex-%E5%AD%97%E9%9D%A2%E9%87%8F--complex-literals)
        - [键值对字面量 / Pair literals](#%E9%94%AE%E5%80%BC%E5%AF%B9%E5%AD%97%E9%9D%A2%E9%87%8F--pair-literals)
            - [箭头键值对 / Arrow pairs](#%E7%AE%AD%E5%A4%B4%E9%94%AE%E5%80%BC%E5%AF%B9--arrow-pairs)
            - [状语键值对（冒号键值对）/ Adverbial pairs \(colon pairs\)](#%E7%8A%B6%E8%AF%AD%E9%94%AE%E5%80%BC%E5%AF%B9%EF%BC%88%E5%86%92%E5%8F%B7%E9%94%AE%E5%80%BC%E5%AF%B9%EF%BC%89-adverbial-pairs-colon-pairs)
        - [布尔值字面量 / Boolean literals](#%E5%B8%83%E5%B0%94%E5%80%BC%E5%AD%97%E9%9D%A2%E9%87%8F--boolean-literals)
        - [数组字面量 / Array literals](#%E6%95%B0%E7%BB%84%E5%AD%97%E9%9D%A2%E9%87%8F--array-literals)
        - [哈希字面量 / Hash literals](#%E5%93%88%E5%B8%8C%E5%AD%97%E9%9D%A2%E9%87%8F--hash-literals)
        - [正则字面量 / Regex literals](#%E6%AD%A3%E5%88%99%E5%AD%97%E9%9D%A2%E9%87%8F--regex-literals)
        - [签名字面量 / Signature literals](#%E7%AD%BE%E5%90%8D%E5%AD%97%E9%9D%A2%E9%87%8F--signature-literals)
    - [声明 / Declarations](#%E5%A3%B0%E6%98%8E--declarations)
        - [变量声明 / Variable declaration](#%E5%8F%98%E9%87%8F%E5%A3%B0%E6%98%8E--variable-declaration)
        - [子例程声明 / Subroutine declaration](#%E5%AD%90%E4%BE%8B%E7%A8%8B%E5%A3%B0%E6%98%8E--subroutine-declaration)
        - [包、模块、类、角色和语法声明 / `Package`, `Module`, `Class`, `Role`, and `Grammar` declaration](#%E5%8C%85%E3%80%81%E6%A8%A1%E5%9D%97%E3%80%81%E7%B1%BB%E3%80%81%E8%A7%92%E8%89%B2%E5%92%8C%E8%AF%AD%E6%B3%95%E5%A3%B0%E6%98%8E--package-module-class-role-and-grammar-declaration)
        - [多分派声明 / Multi-dispatch declaration](#%E5%A4%9A%E5%88%86%E6%B4%BE%E5%A3%B0%E6%98%8E--multi-dispatch-declaration)
- [子例程调用 / Subroutine calls](#%E5%AD%90%E4%BE%8B%E7%A8%8B%E8%B0%83%E7%94%A8--subroutine-calls)
    - [优先级丢弃 / Precedence drop](#%E4%BC%98%E5%85%88%E7%BA%A7%E4%B8%A2%E5%BC%83--precedence-drop)
- [运算符 / Operators](#%E8%BF%90%E7%AE%97%E7%AC%A6--operators)
    - [元运算符 / Metaoperators](#%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6--metaoperators)

<!-- /MarkdownTOC -->

<a id="%E8%AF%8D%E6%B3%95%E7%BA%A6%E5%AE%9A--lexical-conventions"></a>
# 词法约定 / Lexical conventions

Raku 代码是 Unicode 文本。目前的实现支持 UTF-8 作为输入编码。

Raku code is Unicode text. Current implementations support UTF-8 as the input encoding.

另请参见 [Unicode 与 ASCII 符号](https://docs.raku.org/language/unicode_ascii)。

See also [Unicode versus ASCII symbols](https://docs.raku.org/language/unicode_ascii).

<a id="%E8%87%AA%E7%94%B1%E8%AF%AD%E7%B4%A0--free-form"></a>
## 自由语素 / Free form

Raku 代码也是自由语素的，在某种意义上说，你可以自由选择使用的空白量，尽管在某些情况下，空白的存在或不存在具有意义。

Raku code is also free-form, in the sense that you are mostly free to chose the amount of whitespace you use, though in some cases, the presence or absence of whitespace carries meaning.

所以你可以写

So you can write

```Raku
if True {
    say "Hello";
}
```

或

or

```Raku
    if True {
say "Hello"; # Bad indentation intended
        }
```

或

or

```Raku
if True { say "Hello" }
```

甚至

or even

```Raku
if True {say "Hello"}
```

尽管你不能遗漏任何剩余的空白。

though you can't leave out any of the remaining whitespace.

<a id="%E5%8F%8D%E7%A9%BA%E6%A0%BC--unspace"></a>
## 反空格 / Unspace

在编译器不允许空格的许多地方，只要用反斜杠引起来，就可以使用任意数量的空格。不支持 token 中的非空格。编译器生成行号时，反空格的新行仍然算数。反空格的用例是后缀操作符和例程参数列表的分离。

In many places where the compiler would not allow a space you can use any amount of whitespace, as long as it is quoted with a backslash. Unspaces in tokens are not supported. Newlines that are unspaced still count when the compiler produces line numbers. Use cases for unspace are separation of postfix operators and routine argument lists.

```Raku
sub alignment(+@l) { +@l };
sub long-name-alignment(+@l) { +@l };
alignment\         (1,2,3,4).say;
long-name-alignment(3,5)\   .say;
say Inf+Inf\i;
```

在本例中，我们的目的是使两个语句的 `.` 和括号对齐，因此我们在用于填充的空白之前加上 `\`。

In this case, our intention was to make the `.` of both statements, as well as the parentheses, align, so we precede the whitespace used for padding with a `\`.

<a id="%E7%94%A8%E5%88%86%E5%8F%B7%E5%88%86%E9%9A%94%E8%AF%AD%E5%8F%A5--separating-statements-with-semicolons"></a>
## 用分号分隔语句 / Separating statements with semicolons

Raku 程序是一个语句列表，用分号 `;` 分隔。

A Raku program is a list of statements, separated by semicolons `;`.

```Raku
say "Hello";
say "world";
```

在最后一个语句之后（或代码块内的最后一个语句之后）的分号是可选的。

A semicolon after the final statement (or after the final statement inside a block) is optional.

```Raku
say "Hello";
say "world"
if True {
    say "Hello"
}
say "world"
```

<a id="%E9%9A%90%E5%BC%8F%E5%88%86%E9%9A%94%E7%AC%A6%E8%A7%84%E5%88%99%EF%BC%88%E4%BB%A5%E4%BB%A3%E7%A0%81%E5%9D%97%E7%BB%93%E5%B0%BE%E7%9A%84%E8%AF%AD%E5%8F%A5%EF%BC%89--implied-separator-rule-for-statements-ending-in-blocks"></a>
## 隐式分隔符规则（以代码块结尾的语句） / Implied separator rule (for statements ending in blocks)

以裸块结尾的完整语句可以省略后面的分号，如果在同一行中没有其他语句跟在块的右大括号 `}` 后面。这被称为“隐式分隔符规则”。例如，你不需要在上面和下面看到的 `if` 语句块后面写分号。

Complete statements ending in bare blocks can omit the trailing semicolon, if no additional statements on the same line follow the block's closing curly brace `}`. This is called the "implied separator rule." For example, you don't need to write a semicolon after an `if` statement block as seen above, and below.

```Raku
if True { say "Hello" }
say "world";
```

但是，要将块与同一行中的后续语句分隔开，需要分号。

However, semicolons are required to separate a block from trailing statements in the same line.

```Raku
if True { say "Hello" }; say "world";
#                     ^^^ this ; is required
```

除了控制语句之外，这个隐含语句分隔符规则还可以以其他方式应用，这些方式可以以一个裸块结束。例如，与方法调用的冒号 `:` 句法结合使用。

This implied statement separator rule applies in other ways, besides control statements, that could end with a bare block. For example, in combination with the colon `:` syntax for method calls.

```Raku
my @names = <Foo Bar Baz>;
my @upper-case-names = @names.map: { .uc }    # OUTPUT: [FOO BAR BAZ]
```

对于属于同一个 `if`/`elsif`/`else`（或类似）构造的一系列块，隐含的分隔规则仅适用于该系列最后一个块的末尾。这三个是等价的：

For a series of blocks that are part of the same `if`/`elsif`/`else` (or similar) construct, the implied separator rule only applies at the end of the last block of that series. These three are equivalent:

```Raku
if True { say "Hello" } else { say "Goodbye" }; say "world";
#                                            ^^^ this ; is required
if True { say "Hello" } else { say "Goodbye" } # <- implied statement separator
say "world";

if True { say "Hello" }   # still in the middle of an if/else statement
else    { say "Goodbye" } # <- no semicolon required because it ends in a block
                          #    without trailing statements in the same line
say "world";
```

<a id="%E6%B3%A8%E9%87%8A--comments"></a>
## 注释 / Comments

注释是程序文本的一部分，仅面向人类读者；Raku 编译器不会将它们作为程序文本进行计算。它们是*非环境*代码的一部分，包括 *Pod 6* 文本。

Comments are parts of the program text which are only intended for human readers; the Raku compilers do not evaluate them as program text. They are part of the *non-ambient* code that includes *Pod 6* text.

在缺少或存在空白可以消除可能的语法分析歧义的地方，注释算作空白。

Comments count as whitespace in places where the absence or presence of whitespace disambiguates possible parses.

<a id="%E5%8D%95%E8%A1%8C%E6%B3%A8%E9%87%8A--single-line-comments"></a>
### 单行注释 / Single-line comments

Raku 中最常见的注释形式是从单个 `#` 字符开始，一直到行尾。

The most common form of comments in Raku starts with a single hash character `#` and goes until the end of the line.

```Raku
if $age > 250 {     # catch obvious outliers
    # this is another comment!
    die "That doesn't look right"
}
```

<a id="%E5%A4%9A%E8%A1%8C%E5%B5%8C%E5%85%A5%E6%B3%A8%E9%87%8A---multi-line--embedded-comments"></a>
### 多行/嵌入注释 - Multi-line / embedded comments

多行和嵌入的注释以井号字符开头，后跟一个反撇号，然后是一些开始的括号字符，最后是匹配的结束括号字符。只有成对的字符（）、{}、[] 和 <> 才对限制注释块有效。（不同于匹配和替换，其中的成对如 !!、|| 或 @ 可以使用。）内容不仅可以跨多行，还可以内嵌。

Multi-line and embedded comments start with a hash character, followed by a backtick, and then some opening bracketing character, and end with the matching closing bracketing character. Only the paired characters (), {}, [], and <> are valid for bounding comment blocks. (Unlike matches and substitutions, where pairs such as !!, || or @ may be used.) The content can not only span multiple lines, but can also be embedded inline.

```Raku
if #`( why would I ever write an inline comment here? ) True {
    say "something stupid";
}
```

这些注释可以扩展多行

These comments can extend multiple lines

```Raku
#`[
And this is how a multi would work.
That says why we do what we do below.
]
say "No more";
```

注释中的大括号可以嵌套，因此在 `#`{ a { b } c }` 中，注释一直到字符串的最末端。你也可以使用多个大括号，例如 `#`{{ double-curly-brace }}`，这可能有助于消除嵌套分隔符的歧义。只要不在关键字或标识符中间插入这些注释，就可以将它们嵌入表达式中。

Curly braces inside the comment can be nested, so in `#`{ a { b } c }`, the comment goes until the very end of the string. You may also use multiple curly braces, such as `#`{{ double-curly-brace }}`, which might help disambiguate from nested delimiters. You can embed these comments in expressions, as long as you don't insert them in the middle of keywords or identifiers.

<a id="pod-%E6%B3%A8%E9%87%8A--pod-comments"></a>
### Pod 注释 / Pod comments

Pod 句法可用于多行注释

Pod syntax can be used for multi-line comments

```Raku
say "this is code";

=begin comment

Here are several
lines
of comment

=end comment

say 'code again';
```

<a id="%E6%A0%87%E8%AF%86%E7%AC%A6--identifiers"></a>
## 标识符 / Identifiers

标识符是语法构建块，可用于给实体/对象命名，例如常量、变量（例如“标量”和例程（例如 `Sub` 和对象方法）。在[变量名](https://docs.raku.org/language/variables)中，任何标记（和符号）都位于标识符之前，不构成标识符的一部分。

Identifiers are grammatical building blocks that may be used to give a name to entities/objects such as constants, variables (e.g. `Scalar`s) and routines (e.g. `Sub`s and Methods). In a [variable name](https://docs.raku.org/language/variables), any sigil (and twigil) precedes the identifier and does not form a part thereof.

```Raku
constant c = 299792458;     # identifier "c" names an Int
my $a = 123;                # identifier "a" in the name "$a" of a Scalar
sub hello { say "Hello!" }; # identifier "hello" names a Sub
```

标识符有不同的形式：普通标识符、扩展标识符和复合标识符。

Identifiers come in different forms: ordinary, extended, and compound identifiers.

<a id="%E6%99%AE%E9%80%9A%E6%A0%87%E8%AF%86%E7%AC%A6--ordinary-identifiers"></a>
### 普通标识符 / Ordinary identifiers

普通标识符由一个前导字母字符组成，该字符可以后跟一个或多个字母数字字符。它还可以包含独立的、嵌入的撇号 `'` 和/或连字符 `-`，前提是下一个字符是字母。

An ordinary identifier is composed of a leading alphabetic character which may be followed by one or more alphanumeric characters. It may also contain isolated, embedded apostrophes `'` and/or hyphens `-`, provided that the next character is each time alphabetic.

“字母”和“字母数字”的定义包括适当的 Unicode 字符。哪些字符“合适”取决于实现。在 Rakudo/MoarVM Raku 实现中，字母字符包括具有 Unicode 通用类别值 *Letter* (L) 和下划线 `_` 的字符。字母数字字符还包括 Unicode 通用类别值 *数字、十进制数字*（Nd）的字符。

The definitions of "alphabetic" and "alphanumeric" include appropriate Unicode characters. Which characters are "appropriate" depends on the implementation. In the Rakudo/MoarVM Raku implementation alphabetic characters include characters with the Unicode General Category value *Letter* (L), and the underscore `_`. Alphanumeric characters additionally include characters with the Unicode General Category value *Number, Decimal Digit* (Nd).

```Raku
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

<a id="%E6%89%A9%E5%B1%95%E6%A0%87%E8%AF%86%E7%AC%A6--extended-identifiers"></a>
### 扩展标识符 / Extended identifiers

通常，名称包含普通标识符中不允许使用的字符是很方便的。用例包括这样的情况：一组实体共享一个通用的“短”名称，但仍然需要单独标识其每个元素。例如，可以使用短名称为 `Dog` 的模块，而长名称包括其命名者和版本：

It is often convenient to have names that contain characters that are not allowed in ordinary identifiers. Use cases include situations where a set of entities shares a common "short" name, but still needs for each of its elements to be identifiable individually. For example, you might use a module whose short name is `Dog`, while its long name includes its naming authority and version:

```Raku
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

```Raku
infix:<+>                 # the official name of the operator in $a + $b
infix:<*>                 # the official name of the operator in $a * $b
infix:«<=»                # the official name of the operator in $a <= $b
```

对于所有这些用途，可以将一个或多个冒号分隔的字符串附加到普通标识符，以创建所谓的*扩展标识符*。当附加到标识符（即在后缀位置）时，这个冒号分隔的字符串生成该标识符的唯一变体。

For all such uses, you can append one or more colon-separated strings to an ordinary identifier to create a so-called *extended identifier*. When appended to an identifier (that is, in postfix position), this colon-separated string generates unique variants of that identifier.

这些字符串的格式为 `:key<value>`，其中 `key` *或* `value` 是可选的；也就是说，在将其与常规标识符分隔开的冒号之后，将有一个 `key` 和/或一个引号括住的结构，如 `< >`，`« »` 或 `[' ']`，它引用一个或多个任意字符 `value`.[[1]](https://docs.raku.org/language/syntax#fn-1)

These strings have the form `:key<value>`, wherein `key` *or* `value` are optional; that is, after the colon that separates it from a regular identifier, there will be a `key` and/or a quoting bracketing construct such as `< >`, `« »` or `[' ']` which quotes one or more arbitrary characters `value`.[[1]](https://docs.raku.org/language/syntax#fn-1)

```Raku
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

```Raku
infix:<+>
infix:<<+>>
infix:«+»
infix:['+']
infix:('+')
```

同样，所有这些都起作用：

Similarly, all of this works:

```Raku
my $foo:bar<baz> = 'quux';
say $foo:bar«baz»;                               # OUTPUT: «quux␤»
my $take-me:<home> = 'Where the glory has no end';
say $take-me:['home'];                           # OUTPUT: «Where [...]␤»
my $foo:bar<2> = 5;
say $foo:bar(1+1);                               # OUTPUT: «5␤»
```

如果扩展标识符包含两个或多个冒号对，则它们的顺序通常是重要的：

Where an extended identifier comprises two or more colon pairs, their order is generally significant:

```Raku
my $a:b<c>:d<e> = 100;
my $a:d<e>:b<c> = 200;
say $a:b<c>:d<e>;               # OUTPUT: «100␤», NOT: «200␤»
```

此规则的一个例外是*模块版本控制*；因此这些标识符有效地命名了同一个模块：

An exception to this rule is *module versioning*; so these identifiers effectively name the same module:

```Raku
use ThatModule:auth<Somebody>:ver<2.7.18.28.18>
use ThatModule:ver<2.7.18.28.18>:auth<Somebody>
```

此外，扩展标识符支持编译时字符串插值；这要求对插值值使用[常量](https://docs.raku.org/language/terms#Constants)：

Furthermore, extended identifiers support compile-time interpolation; this requires the use of [constants](https://docs.raku.org/language/terms#Constants) for the interpolation values:

```Raku
constant $c = 42;  # Constant binds to Int; $-sigil enables interpolation
my $a:foo<42> = "answer";
say $a:foo«$c»;    # OUTPUT: «answer␤»
```

尽管引用方括号结构在标识符上下文中通常是可互换的，但它们并不相同。特别是，尖括号 `< >`（模拟单引号插值特性）不能用于常量名称的插值。

Although quoting bracketing constructs are generally interchangeable in the context of identifiers, they are not identical. In particular, angle brackets `< >` (which mimic single quote interpolation characteristics) cannot be used for the interpolation of constant names.

```Raku
constant $what = 'are';
my @we:<are>= <the champions>;
say @we:«$what»;     # OUTPUT: «[the champions]␤»
say @we:<$what>;
# Compilation error: Variable '@we:<$what>' is not declared
```

<a id="%E5%A4%8D%E5%90%88%E6%A0%87%E8%AF%86%E7%AC%A6--compound-identifiers"></a>
### 复合标识符 / Compound identifiers

复合标识符是由两个或多个普通和/或扩展标识符组成的标识符，这些标识符之间用双冒号 `::` 分隔。

A compound identifier is an identifier that is composed of two or more ordinary and/or extended identifiers that are separated from one another by a double colon `::`.

双冒号 `::` 称为*名称空间分隔符*或*包分隔符*，它在名称中澄清了其语义功能：强制将名称的前一部分视为 [package](https://docs.raku.org/language/packages)/命名空间，通过该命名空间，查找后面部分的名称：

The double colon `::` is known as the *namespace separator* or the *package delimiter*, which clarifies its semantic function in a name: to force the preceding portion of the name to be considered a [package](https://docs.raku.org/language/packages)/namespace through which the subsequent portion of the name is to be located:

```Raku
module MyModule {               # declare a module package
    our $var = "Hello";         # declare package-scoped variable
}
say $MyModule::var              # OUTPUT: «Hello␤»
```

在上面的示例中，`MyModule::var` 是一个复合标识符，由包名标识符 `MyModule` 和变量名 `var` 的标识符部分组成。总之，`$MyModule::var` 通常被称为[包限定名](https://docs.raku.org/language/packages#Package-qualified_names)。

In the example above, `MyModule::var` is a compound identifier, composed of the package name identifier `MyModule` and the identifier part of the variable name `var`. Altogether `$MyModule::var` is often referred to as a [package-qualified name](https://docs.raku.org/language/packages#Package-qualified_names).

用双冒号分隔标识符会导致将最右边的名称插入现有的（请参见上面的示例）*或自动创建的*包：

Separating identifiers with double colons causes the rightmost name to be inserted into existing (see above example) *or automatically created* packages:

```Raku
my $foo::bar = 1;
say OUR::.keys;           # OUTPUT: «(foo)␤»
say OUR::foo.HOW          # OUTPUT: «Perl6::Metamodel::PackageHOW.new␤»
```

最后一行显示了 `foo` 包是如何自动创建的，作为该命名空间中变量的存放。

The last lines shows how the `foo` package was created automatically, as a deposit for variables in that namespace.

双冒号句法允许运行时字符串[插值](https://docs.raku.org/language/packages#Interpolating_into_names)，使用 `::($expr)` 将字符串插入到包或变量名中，通常将包或变量名放在那里：

The double colon syntax enables runtime [interpolation](https://docs.raku.org/language/packages#Interpolating_into_names) of a string into a package or variable name using `::($expr)` where you'd ordinarily put a package or variable name:

```Raku
my $buz = "quux";
my $bur::quux = 7;
say $bur::($buz);               # OUTPUT: «7␤»
```

<a id="%E6%9C%AF%E8%AF%AD-term--term-term"></a>
## 术语 term:<> / term term:<>

你可以使用 `term:<>` 引入新的术语，这对于引入违反常规标识符规则的常量非常方便：

You can use `term:<>` to introduce new terms, which is handy for introducing constants that defy the rules of normal identifiers:

```Raku
use Test; plan 1; constant &term:<👍> = &ok.assuming(True);
👍
# OUTPUT: «1..1␤ok 1 - ␤»
```

但是术语不必是常量：你还可以将它们用于不带任何参数的函数，并强制解析器在它们后面有运算符。例如：

But terms don't have to be constant: you can also use them for functions that don't take any arguments, and force the parser to expect an operator after them. For instance:

```Raku
sub term:<dice> { (1..6).pick };
say dice + dice;
```

可以打印 2 到 12 之间的任意数字。

can print any number between 2 and 12.

如果我们把 `dice` 声明为一个常规函数

If instead we had declared `dice` as a regular

```Raku
sub dice() {(1...6).pick }
```

，表达式 `dice + dice` 将被解析为 `dice(+(dice()))`，这会导致错误，因为 `sub dice` 需要零个参数。

, the expression `dice + dice` would be parsed as `dice(+(dice()))`, resulting in an error since `sub dice` expects zero arguments.

<a id="%E8%AF%AD%E5%8F%A5%E5%92%8C%E8%A1%A8%E8%BE%BE%E5%BC%8F--statements-and-expressions"></a>
# 语句和表达式 / Statements and expressions

Raku 程序由语句列表组成。语句的特殊情况是返回值的*表达式*。例如，`if True { say 42 }` 在语法上是一个语句，但不是一个表达式，而 `1 + 2` 是一个表达式（因此也是一个语句）。

Raku programs are made of lists of statements. A special case of a statement is an *expression*, which returns a value. For example `if True { say 42 }` is syntactically a statement, but not an expression, whereas `1 + 2` is an expression (and thus also a statement).

`do` 前缀将语句转换为表达式。所以

The `do` prefix turns statements into expressions. So while

```Raku
my $x = if True { 42 };     # Syntax error!
```

是错误的，

is an error,

```Raku
my $x = do if True { 42 };
```

将 if 语句（此处为 `42`）的返回值赋给变量 `$x`。

assigns the return value of the if statement (here `42`) to the variable `$x`.

<a id="%E6%9C%AF%E8%AF%AD--terms"></a>
# 术语 / Terms

术语是基本名词，可以选择与运算符一起构成表达式。例如变量（`$x`）、类型名（`Int`）、文本（`42`）、声明（`sub f() { }`）和调用（`f()`）。

Terms are the basic nouns that, optionally together with operators, can form expressions. Examples for terms are variables (`$x`), barewords such as type names (`Int`), literals (`42`), declarations (`sub f() { }`) and calls (`f()`).

例如，在表达式 `2 * $salary` 中，`2` 和 `$salary` 是两个术语（一个[整数](https://docs.raku.org/type/Int)文本和一个[变量](https://docs.raku.org/language/variables)）。

For example, in the expression `2 * $salary`, `2` and `$salary` are two terms (an [integer](https://docs.raku.org/type/Int) literal and a [variable](https://docs.raku.org/language/variables)).

<a id="%E5%8F%98%E9%87%8F--variables"></a>
## 变量 / Variables

变量通常以名为*标记*的特殊字符开头，后跟标识符。必须先声明变量，然后才能使用它们。

Variables typically start with a special character called the *sigil*, and are followed by an identifier. Variables must be declared before you can use them.

```Raku
# declaration:
my $number = 21;
# usage:
say $number * 2;
```

有关详细信息，请参阅[变量文档](https://docs.raku.org/language/variables)。

See the [documentation on variables](https://docs.raku.org/language/variables) for more details.

<a id="%E8%A3%B8%E5%AD%97%EF%BC%88%E5%B8%B8%E9%87%8F%E3%80%81%E7%B1%BB%E5%9E%8B%E5%90%8D%EF%BC%89-barewords-constants-type-names"></a>
## 裸字（常量、类型名）/ Barewords (constants, type names)

预先声明的标识符可以是自己的术语。这些通常是类型名或常量，但也有 `self` 一词，它指的是调用方法的对象（参见[对象](https://docs.raku.org/language/objects)），以及无标记变量：

Pre-declared identifiers can be terms on their own. Those are typically type names or constants, but also the term `self` which refers to an object that a method was called on (see [objects](https://docs.raku.org/language/objects)), and sigilless variables:

```Raku
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

<a id="%E5%8C%85%E5%92%8C%E9%99%90%E5%AE%9A%E5%90%8D--packages-and-qualified-names"></a>
## 包和限定名 / Packages and qualified names

命名实体（如变量、常量、类、模块或子）是命名空间的一部分。名称的嵌套部分使用 `::` 分隔层次结构。一些例子：

Named entities, such as variables, constants, classes, modules or subs, are part of a namespace. Nested parts of a name use `::` to separate the hierarchy. Some examples:

```Raku
$foo                # simple identifiers
$Foo::Bar::baz      # compound identifiers separated by ::
$Foo::($bar)::baz   # compound identifiers that perform interpolations
Foo::Bar::bob(23)   # function invocation given qualified name
```

有关详细信息，请参阅[软件包文档](https://docs.raku.org/language/packages)。

See the [documentation on packages](https://docs.raku.org/language/packages) for more details.

<a id="%E5%AD%97%E9%9D%A2%E9%87%8F--literals"></a>
## 字面量 / Literals

[字面量](https://en.wikipedia.org/wiki/Literal_%28computer_programming%29)是源代码中常量值的表示。Raku 有几个内置类型的字面量，比如 [字符串](https://docs.raku.org/type/Str)、一些数字类型、[键值对](https://docs.raku.org/type/Pair) 等等。

A [literal](https://en.wikipedia.org/wiki/Literal_%28computer_programming%29) is a representation of a constant value in source code. Raku has literals for several built-in types, like [strings](https://docs.raku.org/type/Str), several numeric types, [pairs](https://docs.raku.org/type/Pair) and more.

<a id="%E5%AD%97%E7%AC%A6%E4%B8%B2%E5%AD%97%E9%9D%A2%E9%87%8F--string-literals"></a>
### 字符串字面量 / String literals

字符串字面量由引号包围：

String literals are surrounded by quotes:

```Raku
say 'a string literal';
say "a string literal\nthat interprets escape sequences";
```

请参阅[引用](https://docs.raku.org/language/quoting)了解更多选项，包括[转义引用 `q`](https://docs.raku.org/language/quoting#Escaping:_q)。Raku 在字面量中使用标准转义符： `\a \b \t \n \f \r \e`，其含义与[设计文档](https://design.perl6.org/S02.html#Backslash_sequences)中指定的 ASCII 转义码相同。

See [quoting](https://docs.raku.org/language/quoting) for many more options, including [the escaping quoting `q`](https://docs.raku.org/language/quoting#Escaping:_q). Raku uses the standard escape characters in literals: `\a \b \t \n \f \r \e`, with the same meaning as the ASCII escape codes, specified in [the design document](https://design.perl6.org/S02.html#Backslash_sequences).

```Raku
say "🔔\a";  # OUTPUT: «🔔␇␤»
```

<a id="%E6%95%B0%E5%AD%97%E5%AD%97%E9%9D%A2%E9%87%8F--number-literals"></a>
### 数字字面量 / Number literals

数字字面值通常以十为基数指定（如果需要，可以通过前缀 `0d` 指定），除非像 `0x`（十六进制，基数 16）、`0o`（八进制，基数 8）或 `0b`（二进制，基数 2）这样的前缀或像 `:16<A0>` 这样显式指定基数。与其他编程语言不同，前导零*不*表示基数 8；反而会发出编译时告警。

Number literals are generally specified in base ten (which can be specified literally, if needed, via the prefix `0d`), unless a prefix like `0x` (he**x**adecimal, base 16), `0o` (**o**ctal, base 8) or `0b` (**b**inary, base 2) or an explicit base in adverbial notation like `:16<A0>` specifies it otherwise. Unlike other programming languages, leading zeros do *not* indicate base 8; instead a compile-time warning is issued.

在所有字面量格式中，可以使用下划线对数字进行分组，尽管它们不包含任何语义信息；以下字面量的计算结果都相同：

In all literal formats, you can use underscores to group digits, although they don't carry any semantic information; the following literals all evaluate to the same number:

```Raku
1000000
1_000_000
10_00000
100_00_00
```

<a id="int-%E5%AD%97%E9%9D%A2%E9%87%8F--int-literals"></a>
#### `Int` 字面量 / `Int` literals

整数默认为带符号的 10 进制数，但可以使用其他基数。有关详细信息，请参见 [Int](https://docs.raku.org/type/Int)。

Integers default to signed base-10, but you can use other bases. For details, see [Int](https://docs.raku.org/type/Int).

```Raku
# not a single literal, but unary - operator applied to numeric literal 2
-2
12345
0xBEEF      # base 16
0o755       # base 8
:3<1201>    # arbitrary base, here base 3
```

<a id="rat-%E5%AD%97%E9%9D%A2%E9%87%8F--rat-literals"></a>
#### `Rat` 字面量 / `Rat` literals

[Rat](https://docs.raku.org/type/Rat) 字面量（有理数）非常常见，在许多其他语言中取代了小数或浮点数。整数除法也会产生 `Rat`。

[Rat](https://docs.raku.org/type/Rat) literals (rationals) are very common, and take the place of decimals or floats in many other languages. Integer division also results in a `Rat`.

```Raku
1.0
3.14159
-2.5        # Not actually a literal, but still a Rat
:3<21.0012> # Base 3 rational
⅔
2/3         # Not actually a literal, but still a Rat
```

<a id="num-%E5%AD%97%E9%9D%A2%E9%87%8F--num-literals"></a>
#### `Num` 字面量 / `Num` literals

在 `e` 之后以十进制数为基数的指数的科学表示法生成[浮点数](https://docs.raku.org/type/Num)：

Scientific notation with an integer exponent to base ten after an `e` produces [floating point number](https://docs.raku.org/type/Num):

```Raku
1e0
6.022e23
1e-9
-2e48
2e2.5       # error
```

<a id="complex-%E5%AD%97%E9%9D%A2%E9%87%8F--complex-literals"></a>
#### `Complex` 字面量 / `Complex` literals

[复数](https://docs.raku.org/type/Complex)数字可以写成虚数（这只是一个附加后缀 `i` 的有理数），也可以写成实数和虚数之和：

[Complex](https://docs.raku.org/type/Complex) numbers are written either as an imaginary number (which is just a rational number with postfix `i` appended), or as a sum of a real and an imaginary number:

```Raku
1+2i
6.123e5i    # note that this is 6.123e5 * i, not 6.123 * 10 ** (5i)
```

<a id="%E9%94%AE%E5%80%BC%E5%AF%B9%E5%AD%97%E9%9D%A2%E9%87%8F--pair-literals"></a>
### 键值对字面量 / Pair literals

[键值对](https://docs.raku.org/type/Pair)由一个键和一个值组成，构造它们有两种基本形式：`key => 'value'` 和 `:key('value')`。

[Pairs](https://docs.raku.org/type/Pair) are made of a key and a value, and there are two basic forms for constructing them: `key => 'value' `and `:key('value')`.

<a id="%E7%AE%AD%E5%A4%B4%E9%94%AE%E5%80%BC%E5%AF%B9--arrow-pairs"></a>
#### 箭头键值对 / Arrow pairs

箭头键值对可以有一个表达式、一个字符串字面量或一个“裸标识符”，这是一个具有普通标识符语法的字符串，在左侧不需要引号：

Arrow pairs can have an expression, a string literal or a "bare identifier", which is a string with ordinary-identifier syntax that does not need quotes on the left-hand side:

```Raku
like-an-identifier-ain't-it => 42
"key" => 42
('a' ~ 'b') => 1
```

<a id="%E7%8A%B6%E8%AF%AD%E9%94%AE%E5%80%BC%E5%AF%B9%EF%BC%88%E5%86%92%E5%8F%B7%E9%94%AE%E5%80%BC%E5%AF%B9%EF%BC%89-adverbial-pairs-colon-pairs"></a>
#### 状语键值对（冒号键值对）/ Adverbial pairs (colon pairs)

没有明确值的短格式：

Short forms without explicit values:

```Raku
my $thing = 42;
:$thing                 # same as  thing => $thing
:thing                  # same as  thing => True
:!thing                 # same as  thing => False
```

变量表单还可以与其他标记一起使用，比如 `:&callback` 或 `:@elements`。如果该值是数字字面量，则也可以用以下简短形式表示：

The variable form also works with other sigils, like `:&callback` or `:@elements`. If the value is a number literal, it can also be expressed in this short form:

```Raku
:42thing            # same as  thing => 42
:٤٢thing            # same as  thing => 42
```

如果你用另一个字母表，这个顺序是颠倒的

This order is inverted if you use another alphabet

```Raku
:٤٢ث              # same as   ث => ٤٢
```

*thaa* 字母在数字前面。

the *thaa* letter precedes the number.

具有明确值的长格式：

Long forms with explicit values:

```Raku
:thing($value)              # same as  thing => $value
:thing<quoted list>         # same as  thing => <quoted list>
:thing['some', 'values']    # same as  thing => ['some', 'values']
:thing{a => 'b'}            # same as  thing => { a => 'b' }
```

<a id="%E5%B8%83%E5%B0%94%E5%80%BC%E5%AD%97%E9%9D%A2%E9%87%8F--boolean-literals"></a>
### 布尔值字面量 / Boolean literals

`True` 和 `False` 是布尔值字面量；它们的首字母总是大写。

`True` and `False` are Boolean literals; they will always have initial capital letter.

<a id="%E6%95%B0%E7%BB%84%E5%AD%97%E9%9D%A2%E9%87%8F--array-literals"></a>
### 数组字面量 / Array literals

一对方括号可以包围一个表达式以形成逐项[数组](https://docs.raku.org/type/Array)字面量；通常在以下内容中有一个逗号分隔的列表：

A pair of square brackets can surround an expression to form an itemized [Array](https://docs.raku.org/type/Array) literal; typically there is a comma-delimited list inside:

```Raku
say ['a', 'b', 42].join(' ');   # OUTPUT: «a b 42␤»
#   ^^^^^^^^^^^^^^ Array constructor
```

如果给构造函数一个 [Iterable](https://docs.raku.org/type/Iterable)，它将克隆并展平它。如果只需要一个 `Iterable` 元素的 `Array`，请确保在其后使用逗号：

If the constructor is given a single [Iterable](https://docs.raku.org/type/Iterable), it'll clone and flatten it. If you want an `Array` with just 1 element that is an `Iterable`, ensure to use a comma after it:

```Raku
my @a = 1, 2;
say [@a].perl;  # OUTPUT: «[1, 2]␤»
say [@a,].perl; # OUTPUT: «[[1, 2],]␤»
```

`Array` 构造函数不展平其他类型的内容。使用 [Slip](https://docs.raku.org/type/Slip) 前缀运算符 (`|`) 压平所需的项：

The `Array` constructor does not flatten other types of contents. Use the [Slip](https://docs.raku.org/type/Slip) prefix operator (`|`) to flatten the needed items:

```Raku
my @a = 1, 2;
say [@a, 3, 4].perl;  # OUTPUT: «[[1, 2], 3, 4]␤»
say [|@a, 3, 4].perl; # OUTPUT: «[1, 2, 3, 4]␤»
```

[列表](https://docs.raku.org/type/List)类型可以从数组字面量声明中显式创建，无需从数组强制转换，在声明时使用 **is** [特性](https://docs.raku.org/language/traits)。

[List](https://docs.raku.org/type/List) type can be explicitly created from an array literal declaration without a coercion from Array, using **is** [trait](https://docs.raku.org/language/traits) on declaration.

```Raku
my @a is List = 1, 2; # a List, not an Array
# wrong: creates an Array of Lists
my List @a;
```

<a id="%E5%93%88%E5%B8%8C%E5%AD%97%E9%9D%A2%E9%87%8F--hash-literals"></a>
### 哈希字面量 / Hash literals

一个前导的关联标记和一对圆括号 `%( )`，可以包围一个键值对的列表，形成一个[哈希](https://docs.raku.org/type/Hash)字面量；通常，里面有一个逗号分隔的键值对的列表。如果使用非键值对，则假定它是键，下一个元素是值。这通常与简单的箭头键值对一起使用。

A leading associative sigil and pair of parenthesis `%( )` can surround a `List` of `Pairs` to form a [Hash](https://docs.raku.org/type/Hash) literal; typically there is a comma-delimited `List` of `Pairs` inside. If a non-pair is used, it is assumed to be a key and the next element is the value. Most often this is used with simple arrow pairs.

```Raku
say %( a => 3, b => 23, :foo, :dog<cat>, "french", "fries" );
# OUTPUT: «a => 3, b => 23, dog => cat, foo => True, french => fries␤»

say %(a => 73, foo => "fish").keys.join(" ");   # OUTPUT: «a foo␤»
#   ^^^^^^^^^^^^^^^^^^^^^^^^^ Hash constructor
```

当赋值给左侧的 `%` 变量时，右侧键值对周围的标记和括号是可选的。

When assigning to a `%`-sigiled variable on the left-hand side, the sigil and parenthesis surrounding the right-hand side `Pairs`are optional.

```Raku
my %ages = fred => 23, jean => 87, ann => 4;
```

默认情况下，`%( )` 中的键被强制转换为字符串。若要使用非字符串键组成哈希，请使用带冒号前缀的大括号分隔符 `:{ }`：

By default, keys in `%( )` are forced to strings. To compose a hash with non-string keys, use curly brace delimiters with a colon prefix `:{ }` :

```Raku
my $when = :{ (now) => "Instant", (DateTime.now) => "DateTime" };
```

请注意，使用对象作为键时，不能用字符串访问非字符串键：

Note that with objects as keys, you cannot access non-string keys as strings:

```Raku
say :{ -1 => 41, 0 => 42, 1 => 43 }<0>;  # OUTPUT: «(Any)␤»
say :{ -1 => 41, 0 => 42, 1 => 43 }{0};  # OUTPUT: «42␤»
```

实现了 [Associative](https://docs.raku.org/type/Associative) 角色的特定类型如 [Map](https://docs.raku.org/type/Map)（包括 [Hash](https://docs.raku.org/type/Hash) 、[Stash](https://docs.raku.org/type/Stash) 子类）和 [QuantHash](https://docs.raku.org/type/QuantHash)（以及它的子类）可以在声明时使用 **is** [特性](https://docs.raku.org/language/traits)从哈希字面量显式创建，而无需强制类型转换：

Particular types that implement [Associative](https://docs.raku.org/type/Associative) role, [Map](https://docs.raku.org/type/Map) (including [Hash](https://docs.raku.org/type/Hash) and [Stash](https://docs.raku.org/type/Stash) subclasses) and [QuantHash](https://docs.raku.org/type/QuantHash) (and its subclasses), can be explicitly created from a hash literal without a coercion, using **is** [trait](https://docs.raku.org/language/traits) on declaration:

```Raku
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

请注意，对哈希标记使用常规类型声明会创建类型哈希，而不是特定类型：

Note that using a usual type declaration with a hash sigil creates a typed Hash, not a particular type:

```Raku
# This is wrong: creates a Hash of Mixes, not Mix:
my Mix %mix;
# Works with $ sigil:
my Mix $mix;
# Can be typed:
my Mix[Int] $mix-of-ints;
```

<a id="%E6%AD%A3%E5%88%99%E5%AD%97%E9%9D%A2%E9%87%8F--regex-literals"></a>
### 正则字面量 / Regex literals

一个 [Regex](https://docs.raku.org/type/Regex) 用诸如 `/foo/` 之类的斜杠声明。注意，这个 `//` 句法是完整的 `rx//` 句法的简写。

A [Regex](https://docs.raku.org/type/Regex) is declared with slashes like `/foo/`. Note that this `//` syntax is shorthand for the full `rx//` syntax.

```Raku
/foo/          # Short version
rx/foo/        # Longer version
Q :regex /foo/ # Even longer version

my $r = /foo/; # Regexes can be assigned to variables
```

<a id="%E7%AD%BE%E5%90%8D%E5%AD%97%E9%9D%A2%E9%87%8F--signature-literals"></a>
### 签名字面量 / Signature literals

除了在子声明和块声明中的典型用法外，签名还可以单独用于模式匹配。独立签名的声明以冒号开头：

Signatures can be used standalone for pattern matching, in addition to the typical usage in sub and block declarations. A standalone signature is declared starting with a colon:

```Raku
say "match!" if 5, "fish" ~~ :(Int, Str); # OUTPUT: «match!␤»

my $sig = :(Int $a, Str);
say "match!" if (5, "fish") ~~ $sig; # OUTPUT: «match!␤»

given "foo", 42 {
  when :(Str, Str) { "This won't match" }
  when :(Str, Int $n where $n > 20) { "This will!" }
}
```

有关签名的详细信息，请参阅 [Signatures](https://docs.raku.org/type/Signature) 文档。

See the [Signatures](https://docs.raku.org/type/Signature) documentation for more about signatures.

<a id="%E5%A3%B0%E6%98%8E--declarations"></a>
## 声明 / Declarations

<a id="%E5%8F%98%E9%87%8F%E5%A3%B0%E6%98%8E--variable-declaration"></a>
### 变量声明 / Variable declaration

```Raku
my $x;                          # simple lexical variable
my $x = 7;                      # initialize the variable
my Int $x = 7;                  # declare the type
my Int:D $x = 7;                # specify that the value must be defined (not undef)
my Int $x where { $_ > 3 } = 7; # constrain the value based on a function
my Int $x where * > 3 = 7;      # same constraint, but using Whatever shorthand
```

有关其他作用域（`our`，`has`）的详细信息，请参见[变量声明器和作用域](https://docs.raku.org/language/variables#Variable_declarators_and_scope)。

See [Variable Declarators and Scope](https://docs.raku.org/language/variables#Variable_declarators_and_scope) for more details on other scopes (`our`, `has`).

<a id="%E5%AD%90%E4%BE%8B%E7%A8%8B%E5%A3%B0%E6%98%8E--subroutine-declaration"></a>
### 子例程声明 / Subroutine declaration

```Raku
# The signature is optional
sub foo { say "Hello!" }

sub say-hello($to-whom) { say "Hello $to-whom!" }
```

也可以将子例程赋值给变量。

You can also assign subroutines to variables.

```Raku
my &f = sub { say "Hello!" } # Un-named sub
my &f = -> { say "Hello!" }  # Lambda style syntax. The & sigil indicates the variable holds a function
my $f = -> { say "Hello!" }  # Functions can also be put into scalars
```

<a id="%E5%8C%85%E3%80%81%E6%A8%A1%E5%9D%97%E3%80%81%E7%B1%BB%E3%80%81%E8%A7%92%E8%89%B2%E5%92%8C%E8%AF%AD%E6%B3%95%E5%A3%B0%E6%98%8E--package-module-class-role-and-grammar-declaration"></a>
### 包、模块、类、角色和语法声明 / `Package`, `Module`, `Class`, `Role`, and `Grammar` declaration

有几种类型的包，每种包都用一个关键字、一个名称、一些可选特性和一系列子例程、方法或规则声明。

There are several types of package, each declared with a keyword, a name, some optional traits, and a body of subroutines, methods, or rules.

```Raku
package P { }

module M { }

class C { }

role R { }

grammar G { }
```

几个包可以在一个文件中声明。但是，你可以在文件的开头声明一个 `unit` 包（前面只能有注释或 `use` 语句），文件的其余部分将被视为包的主体。在这种情况下，不需要花括号。

Several packages may be declared in a single file. However, you can declare a `unit` package at the start of the file (preceded only by comments or `use` statements), and the rest of the file will be taken as being the body of the package. In this case, the curly braces are not required.

```Raku
unit module M;
# ... stuff goes here instead of in {}'s
```

<a id="%E5%A4%9A%E5%88%86%E6%B4%BE%E5%A3%B0%E6%98%8E--multi-dispatch-declaration"></a>
### 多分派声明 / Multi-dispatch declaration

另请参见[多分派](https://docs.raku.org/language/functions#Multi-dispatch)。

See also [Multi-dispatch](https://docs.raku.org/language/functions#Multi-dispatch).

子例程可以用多个签名声明。

Subroutines can be declared with multiple signatures.

```Raku
multi sub foo() { say "Hello!" }
multi sub foo($name) { say "Hello $name!" }
```

在类内部，还可以声明多分派方法。

Inside of a class, you can also declare multi-dispatch methods.

```Raku
multi method greet { }
multi method greet(Str $name) { }
```

<a id="%E5%AD%90%E4%BE%8B%E7%A8%8B%E8%B0%83%E7%94%A8--subroutine-calls"></a>
# 子例程调用 / Subroutine calls

使用关键字 `sub` 创建子例程，后跟可选名称、可选签名和代码块。子例程在词法作用域范围内，因此如果在声明时指定了名称，则可以在词法范围内使用相同的名称来调用子例程。子例程是 [Sub](https://docs.raku.org/type/Sub) 类型的实例，可以分配给任何容器。

Subroutines are created with the keyword `sub` followed by an optional name, an optional signature and a code block. Subroutines are lexically scoped, so if a name is specified at the declaration time, the same name can be used in the lexical scope to invoke the subroutine. A subroutine is an instance of type [Sub](https://docs.raku.org/type/Sub) and can be assigned to any container.

```Raku
foo;   # Invoke the function foo with no arguments
foo(); # Invoke the function foo with no arguments
&f();  # Invoke &f, which contains a function
&f.(); # Same as above, needed to make the following work
my @functions = ({say 1}, {say 2}, {say 3});
@functions>>.(); # hyper method call operator
```

在类内声明时，子例程被称为 "method"：方法是针对对象（即类实例）调用的子例程。在方法中，特殊变量 `self` 包含对象实例（请参见[方法](https://docs.raku.org/language/classtut#Methods)）。

When declared within a class, a subroutine is named "method": methods are subroutines invoked against an object (i.e., a class instance). Within a method the special variable `self` contains the object instance (see [Methods](https://docs.raku.org/language/classtut#Methods)).

```Raku
# Method invocation. Object (instance) is $person, method is set-name-age
$person.set-name-age('jane', 98);   # Most common way
$person.set-name-age: 'jane', 98;   # Precedence drop
set-name-age($person: 'jane', 98);  # Invocant marker
set-name-age $person: 'jane', 98;   # Indirect invocation
```

有关更多信息，请参见[函数](https://docs.raku.org/language/functions)。

For more information, see [functions](https://docs.raku.org/language/functions).

<a id="%E4%BC%98%E5%85%88%E7%BA%A7%E4%B8%A2%E5%BC%83--precedence-drop"></a>
## 优先级丢弃 / Precedence drop

在方法调用的情况下（即，对类实例调用子例程时），可以在方法名之后和参数列表之前应用由冒号标识的“优先级丢弃”。参数列表的优先级高于方法调用，而方法调用则“丢弃”其优先级。为了更好地理解，请考虑下面的简单示例（为了对齐方法调用而添加了额外的空格）：

In the case of method invocation (i.e., when invoking a subroutine against a class instance) it is possible to apply the `precedence drop`, identified by a colon `:` just after the method name and before the argument list. The argument list takes precedence over the method call, that on the other hand "drops" its precedence. In order to better understand consider the following simple example (extra spaces have been added just to align method calls):

```Raku
my $band = 'Foo Fighters';
say $band.substr( 0, 3 ) .substr( 0, 1 ); # F
say $band.substr: 0, 3   .substr( 0, 1 ); # Foo
```

在第二个方法调用中，最右边的 `substr` 应用于 "3"，而不是最左边的 `substr` 的结果，最左边的 `substr` 将优先级让步给最右边的 `substr`。

In the second method call the rightmost `substr` is applied to "3" and not to the result of the leftmost `substr`, which on the other hand yields precedence to the rightmost one.

<a id="%E8%BF%90%E7%AE%97%E7%AC%A6--operators"></a>
# 运算符 / Operators

有关详细信息，请参见[运算符](https://docs.raku.org/language/operators)。

See [Operators](https://docs.raku.org/language/operators) for lots of details.

运算符是具有更重符号和可组合语法的函数。与其他函数一样，运算符可以是多分派，以允许特定于上下文的使用。

Operators are functions with a more symbol heavy and composable syntax. Like other functions, operators can be multi-dispatch to allow for context-specific usage.

运算符有五种类型（排列），每种类型都有一个或两个参数。

There are five types (arrangements) for operators, each taking either one or two arguments.

```Raku
++$x           # prefix, operator comes before single input
5 + 3          # infix, operator is between two inputs
$x++           # postfix, operator is after single input
<the blue sky> # circumfix, operator surrounds single input
%foo<bar>      # postcircumfix, operator comes after first input and surrounds second
```

<a id="%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6--metaoperators"></a>
## 元运算符 / Metaoperators

可以组合运算符。一个常见的例子是将中缀（二元）运算符与赋值结合起来。可以将赋值与任何二元运算符组合。

Operators can be composed. A common example of this is combining an infix (binary) operator with assignment. You can combine assignment with any binary operator.

```Raku
$x += 5     # Adds 5 to $x, same as $x = $x + 5
$x min= 3   # Sets $x to the smaller of $x and 3, same as $x = $x min 3
$x .= child # Equivalent to $x = $x.child
```

在 `[]` 中包装中缀运算符，以创建一个新的归约运算符，该运算符在单个输入列表上工作，生成单个值。

Wrap an infix operator in `[ ]` to create a new reduction operator that works on a single list of inputs, resulting in a single value.

```Raku
say [+] <1 2 3 4 5>;    # OUTPUT: «15␤»
(((1 + 2) + 3) + 4) + 5 # equivalent expanded version
```

将中缀运算符包装在 `« »`（或等效的 ASCII 表达）中，以创建在两个列表上成对工作的新超级运算符。

Wrap an infix operator in `« »` (or the ASCII equivalent) to create a new hyper operator that works pairwise on two lists.

```Raku
say <1 2 3> «+» <4 5 6> # OUTPUT: «(5 7 9)␤»
```

箭头的方向指示当列表大小不同时如何操作。

The direction of the arrows indicates what to do when the lists are not the same size.

```Raku
@a «+« @b # 结果的长度与 @b 的长度一致，@a 中的元素会被重复使用 / Result is the size of @b, elements from @a will be re-used
@a »+» @b # 结果的长度与 @a 的长度一致，@b 中的元素会被重复使用 / Result is the size of @a, elements from @b will be re-used
@a «+» @b # 结果的长度与最长的那个数组的长度一致，长度较小的数组中的元素会被重复使用 / Result is the size of the biggest input, the smaller one is re-used
@a »+« @b # 如果 @a 与 @b 长度不一致，抛出异常 / Exception if @a and @b are different sizes
```

也可以用超运算符包装一元运算符。

You can also wrap a unary operator with a hyper operator.

```Raku
say -« <1 2 3> # OUTPUT: «(-1 -2 -3)␤»
```

[[↑]](https://docs.raku.org/language/syntax#fn-ref-1) 从 Raku 语言版本 6.d 开始，保留了以 `sym` 作为 `key`（例如 `:sym<foo>` ）的冒号对，以备将来使用。

[[↑]](https://docs.raku.org/language/syntax#fn-ref-1) Starting with Raku language version 6.d, colon pairs with `sym` as the `key` (e.g. `:sym<foo>`) are reserved for possible future use.
