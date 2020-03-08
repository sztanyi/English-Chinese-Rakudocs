原文：https://docs.raku.org/language/terms

# 术语 - Terms

Raku 术语

Raku terms

Raku 的大多数句法结构可以分为*术语*和[运算符](https://docs.raku.org/language/operators)。

Most syntactic constructs in Raku can be categorized in *terms* and [operators](https://docs.raku.org/language/operators).

在这里，你可以找到不同类型术语的概述。

Here you can find an overview of different kinds of terms.

<!-- MarkdownTOC -->

- [字面量 / Literals](#%E5%AD%97%E9%9D%A2%E9%87%8F--literals)
    - [整数 / Int](#%E6%95%B4%E6%95%B0--int)
    - [有理数 / Rat](#%E6%9C%89%E7%90%86%E6%95%B0--rat)
    - [浮点数 / Num](#%E6%B5%AE%E7%82%B9%E6%95%B0--num)
    - [字符串 / Str](#%E5%AD%97%E7%AC%A6%E4%B8%B2--str)
    - [正则 / Regex](#%E6%AD%A3%E5%88%99--regex)
    - [键值对 / Pair](#%E9%94%AE%E5%80%BC%E5%AF%B9--pair)
    - [列表 / List](#%E5%88%97%E8%A1%A8--list)
    - [术语 * / term *](#%E6%9C%AF%E8%AF%AD---term-)
- [标识符术语 / Identifier terms](#%E6%A0%87%E8%AF%86%E7%AC%A6%E6%9C%AF%E8%AF%AD--identifier-terms)
    - [术语 self / term self](#%E6%9C%AF%E8%AF%AD-self--term-self)
    - [术语 now / term now](#%E6%9C%AF%E8%AF%AD-now--term-now)
    - [术语 time / term time](#%E6%9C%AF%E8%AF%AD-time--term-time)
    - [术语 rand / term rand](#%E6%9C%AF%E8%AF%AD-rand--term-rand)
    - [术语 π / term π](#%E6%9C%AF%E8%AF%AD-%CF%80--term-%CF%80)
    - [术语 pi / term pi](#%E6%9C%AF%E8%AF%AD-pi--term-pi)
    - [术语 τ / term τ](#%E6%9C%AF%E8%AF%AD-%CF%84--term-%CF%84)
    - [术语 tau / term tau](#%E6%9C%AF%E8%AF%AD-tau--term-tau)
    - [术语 𝑒 / term 𝑒](#%E6%9C%AF%E8%AF%AD-%F0%9D%91%92--term-%F0%9D%91%92)
    - [术语 e / term e](#%E6%9C%AF%E8%AF%AD-e--term-e)
    - [术语 i / term i](#%E6%9C%AF%E8%AF%AD-i--term-i)
    - [术语 ∅ / term ∅](#%E6%9C%AF%E8%AF%AD-%E2%88%85--term-%E2%88%85)
- [变量 / Variables](#%E5%8F%98%E9%87%8F--variables)
- [常量 / Constants](#%E5%B8%B8%E9%87%8F--constants)

<!-- /MarkdownTOC -->


<a id="%E5%AD%97%E9%9D%A2%E9%87%8F--literals"></a>
# 字面量 / Literals

<a id="%E6%95%B4%E6%95%B0--int"></a>
## 整数 / Int

```Raku
42
12_300_00
:16<DEAD_BEEF>
```

[Int](https://docs.raku.org/type/Int) 字面量由数字组成，可以包含任意两个数字之间的下划线。

[Int](https://docs.raku.org/type/Int) literals consist of digits and can contain underscores between any two digits.

若要指定十个以外的基数，请使用冒号对形式 `:radix<number> `。

To specify a base other than ten, use the colonpair form `:radix<number> `.

<a id="%E6%9C%89%E7%90%86%E6%95%B0--rat"></a>
## 有理数 / Rat

```Raku
12.34
1_200.345_678
```

[Rat](https://docs.raku.org/type/Rat) 字面量包含由点连接的两个整数部分。

[Rat](https://docs.raku.org/type/Rat) literals (rational numbers) contain two integer parts joined by a dot.

请注意，末尾不允许有点，因此你必须写 `1.0` 而不是 `1.`（这一规则很重要，因为有以点开头的固定运算符，例如 `..` [范围](https://docs.raku.org/type/Range)运算符）。

Note that trailing dots are not allowed, so you have to write `1.0` instead of `1.` (this rule is important because there are infix operators starting with a dot, for example the `..` [Range](https://docs.raku.org/type/Range) operator).

<a id="%E6%B5%AE%E7%82%B9%E6%95%B0--num"></a>
## 浮点数 / Num

```Raku
12.3e-32
3e8
```

[Num](https://docs.raku.org/type/Num) 字面量（浮点数）由 [Rat](https://docs.raku.org/type/Rat) 或者 [Int](https://docs.raku.org/type/Int) 字面量后跟一个 `e` 和一个（可能为负的）指数。`3e8` 由值 `3 * 10**8` 组成了一个 [Num](https://docs.raku.org/type/Num)。

[Num](https://docs.raku.org/type/Num) literals (floating point numbers) consist of [Rat](https://docs.raku.org/type/Rat) or [Int](https://docs.raku.org/type/Int) literals followed by an `e` and a (possibly negative) exponent. `3e8` constructs a [Num](https://docs.raku.org/type/Num) with value `3 * 10**8`.

<a id="%E5%AD%97%E7%AC%A6%E4%B8%B2--str"></a>
## 字符串 / Str

```Raku
'a string'
'I\'m escaped!'
"I don't need to be"
"\"But I still can be,\" he said."
q|Other delimiters can be used too!|
```

字符串文字通常是用 `'` 或 `"` 创建的，但是字符串实际上是 Raku 的一种强大的子语言。参见[引用构造](https://docs.raku.org/language/quoting)。

String literals are most often created with `'` or `"`, however strings are actually a powerful sub-language of Raku. See [Quoting Constructs](https://docs.raku.org/language/quoting).

<a id="%E6%AD%A3%E5%88%99--regex"></a>
## 正则 / Regex

```Raku
/ match some text /
rx/slurp \s rest (.*) $/
```

这些是正则字面量。参见[引用结构](https://docs.raku.org/language/quoting)。

These forms produce regex literals. See [quoting constructs](https://docs.raku.org/language/quoting).

<a id="%E9%94%AE%E5%80%BC%E5%AF%B9--pair"></a>
## 键值对 / Pair

```Raku
a => 1
'a' => 'b'
:identifier
:!identifier
:identifier<value>
:identifier<value1 value2>
:identifier($value)
:identifier['val1', 'val2']
:identifier{key1 => 'val1', key2 => 'value2'}
:valueidentifier
:$item
:@array
:%hash
:&callable
```

[Pair](https://docs.raku.org/type/Pair) 对象可以用 `infix:«=>»`（如果它是一个标识符，它自动括起左手边）创建，也可以用各种冒号对形式创建。它们几乎总是以冒号开头，然后后面跟着一个标识符或一个已经存在的变量的名称（它的名称去掉标记被用作键，变量的值被用作对的值）。有一种特殊的形式，其中整数值在冒号之后，键在值之后。

[Pair](https://docs.raku.org/type/Pair) objects can be created either with `infix:«=>»`(which auto-quotes the left-hand side if it is an identifier), or with the various colon-pair forms. Those almost always start with a colon and then are followed either by an identifier or the name of an already existing variable (whose name without the sigil is used as the key and value of the variable is used as the value of the pair). There is a special form where an integer value is immediately after the colon and the key is immediately after the value.

在冒号对的标识符形式中，可选值可以是环缀运算符。如果空白，则值为 `Bool::True`。`:!identifier` 形式的值是 `Bool::False`。

In the identifier form of a colon-pair, the optional value can be any circumfix. If it is left blank, the value is `Bool::True`. The value of the `:!identifier` form is `Bool::False`.

如果在参数列表中使用，所有这些形式都算作命名参数，但 `'quoted string' => $value` 除外。

If used in an argument list, all of these forms count as named arguments, with the exception of `'quoted string' => $value`.

<a id="%E5%88%97%E8%A1%A8--list"></a>
## 列表 / List

```Raku
()
1, 2, 3
<a b c>
«a b c»
qw/a b c/
```

[List](https://docs.raku.org/type/List) 字面是：空括号 `()`、逗号分隔的列表或者一些引用结构。

[List](https://docs.raku.org/type/List) literals are: the empty pair of parentheses `()`, a comma-separated list, or several quoting constructs.

<a id="%E6%9C%AF%E8%AF%AD---term-"></a>
## 术语 * / term *

创建一个 `Whatever` 类型的对象。有关更多细节，请参见 [Whatever](https://docs.raku.org/type/Whatever) 文档。

Creates an object of type `Whatever`. See [Whatever](https://docs.raku.org/type/Whatever) documentation for more details.

<a id="%E6%A0%87%E8%AF%86%E7%AC%A6%E6%9C%AF%E8%AF%AD--identifier-terms"></a>
# 标识符术语 / Identifier terms

在 Raku 中有内置的标识符术语，如下所示。此外，还可以使用这样的句法添加新的标识符术语：

There are built-in identifier terms in Raku, which are listed below. In addition one can add new identifier terms with the syntax:

```Raku
sub term:<forty-two> { 42 };
say forty-two
```

或者作为常量：

or as constants:

```Raku
constant forty-two = 42;
say forty-two;
```

<a id="%E6%9C%AF%E8%AF%AD-self--term-self"></a>
## 术语 self / term self

在一个方法中，`self` 指的是调用者（即方法被调用的对象）。如果在没有意义的上下文中使用，则会引发 [X::Syntax::NoSelf](https://docs.raku.org/type/X::Syntax::NoSelf) 类型的编译时异常。

Inside a method, `self` refers to the invocant (i.e. the object the method was called on). If used in a context where it doesn't make sense, a compile-time exception of type [X::Syntax::NoSelf](https://docs.raku.org/type/X::Syntax::NoSelf) is thrown.

<a id="%E6%9C%AF%E8%AF%AD-now--term-now"></a>
## 术语 now / term now

返回表示当前时间的 [Instant](https://docs.raku.org/type/Instant) 对象.它包括[闰秒](https://en.wikipedia.org/wiki/Leap_second)，因此比 [time](https://docs.raku.org/language/terms#term_time) 大几十秒：

Returns an [Instant](https://docs.raku.org/type/Instant) object representing the current time. It includes [leap seconds](https://en.wikipedia.org/wiki/Leap_second) and as such a few dozen seconds larger than [time](https://docs.raku.org/language/terms#term_time):

```Raku
say (now - time).Int; # OUTPUT: «37␤»
```

<a id="%E6%9C%AF%E8%AF%AD-time--term-time"></a>
## 术语 time / term time

将当前 POSIX 时间作为 [Int](https://docs.raku.org/type/Int) 返回。有关包含[闰秒](https://en.wikipedia.org/wiki/Leap_second)的高精度时间戳，请参见 [now](https://docs.raku.org/language/terms#term_now)。

Returns the current POSIX time as an [Int](https://docs.raku.org/type/Int). See [now](https://docs.raku.org/language/terms#term_now) for high-resolution timestamp that includes [leap seconds](https://en.wikipedia.org/wiki/Leap_second).

<a id="%E6%9C%AF%E8%AF%AD-rand--term-rand"></a>
## 术语 rand / term rand

返回范围 `0..^1` 中的一个随机数 [Num](https://docs.raku.org/type/Num)。

Returns a pseudo-random [Num](https://docs.raku.org/type/Num) in the range `0..^1`.

<a id="%E6%9C%AF%E8%AF%AD-%CF%80--term-%CF%80"></a>
## 术语 π / term π

返回码点 U+03C0（GREEK SMALL Letter PI）的数字 `π`，即圆的周长和直径之间的比率。`π` 的 ASCII 等价物是 `pi`。

Returns the number `π` at codepoint U+03C0 (GREEK SMALL LETTER PI), i.e. the ratio between circumference and diameter of a circle. The ASCII equivalent of `π` is `pi`.

<a id="%E6%9C%AF%E8%AF%AD-pi--term-pi"></a>
## 术语 pi / term pi

返回数字 `π`，即圆的周长与直径之比。`pi` 是 `π` 的 ASCII 等价物。

Returns the number `π`, i.e., the ratio between circumference and diameter of a circle. `pi` is the ASCII equivalent of `π`.

<a id="%E6%9C%AF%E8%AF%AD-%CF%84--term-%CF%84"></a>
## 术语 τ / term τ

返回 U+03C4 码点（GREEK SMALL Letter TAU）的数字 `τ`，即圆的周长和半径之间的比率。`τ` 的 ASCII 等价物是 `tau`。

Returns the number `τ` at codepoint U+03C4 (GREEK SMALL LETTER TAU), i.e. the ratio between circumference and radius of a circle. The ASCII equivalent of `τ` is `tau`.

<a id="%E6%9C%AF%E8%AF%AD-tau--term-tau"></a>
## 术语 tau / term tau

返回数字 `τ`，即圆的周长和半径之间的比率。`tau` 是 `τ` 的 ASCII 等价物。

Returns the number `τ`, i.e. the ratio between circumference and radius of a circle. `tau` is the ASCII equivalent of `τ`.

<a id="%E6%9C%AF%E8%AF%AD-%F0%9D%91%92--term-%F0%9D%91%92"></a>
## 术语 𝑒 / term 𝑒

返回 U+1D452 码点处的欧拉数（MATHEMATICAL ITALIC SMALL E）。`𝑒` 的 ASCII 等价物是 `e`。

Returns Euler's number at codepoint U+1D452 (MATHEMATICAL ITALIC SMALL E). The ASCII equivalent of `𝑒` is `e`.

<a id="%E6%9C%AF%E8%AF%AD-e--term-e"></a>
## 术语 e / term e

返回欧拉数。`e` 就是 `𝑒` 的 ASCII 等价物。

Returns Euler's number. `e` is the ASCII equivalent of `𝑒`.

<a id="%E6%9C%AF%E8%AF%AD-i--term-i"></a>
## 术语 i / term i

返回虚数单位（用于[复数](https://docs.raku.org/type/Complex)）。

Returns the imaginary unit (for [Complex](https://docs.raku.org/type/Complex) numbers).

<a id="%E6%9C%AF%E8%AF%AD-%E2%88%85--term-%E2%88%85"></a>
## 术语 ∅ / term ∅

返回 `set()`，也就是空集，在 U+2205 码点（EMPTY SET）。

Returns `set()`, aka the empty set, at codepoint U+2205 (EMPTY SET).

<a id="%E5%8F%98%E9%87%8F--variables"></a>
# 变量 / Variables

变量将在[变量语言文档](https://docs.raku.org/language/variables)中讨论。

Variables are discussed in the [variable language docs](https://docs.raku.org/language/variables).

<a id="%E5%B8%B8%E9%87%8F--constants"></a>
# 常量 / Constants

常量类似于[变量](https://docs.raku.org/language/variables)，没有[容器](https://docs.raku.org/language/containers)，因此不能绑定。然而，它们的初始化式在 [BEGIN]（https://docs.raku.org/syntax/BEGIN）时进行求值：

Constants are similar to [variables](https://docs.raku.org/language/variables) without a [container](https://docs.raku.org/language/containers), and thus cannot be rebound. However, their initializers are evaluated at [BEGIN](https://docs.raku.org/syntax/BEGIN) time:

```Raku
constant speed-of-light = 299792458; # m/s 
constant @foo  = 1, 2, 3;
constant &talk = &say;
talk speed-of-light²; # OUTPUT: «89875517873681764␤» 
talk @foo;            # OUTPUT: «(1 2 3)␤»
```

编译时求值意味着[你应该小心](https://docs.raku.org/language/traps#Constants_are_Compile_Time)在模块内部使用常量，这些常量会自动预编译，因此即使在程序的多次执行之间，常量的值也不会改变：

Compile-time evaluation means [you should be careful](https://docs.raku.org/language/traps#Constants_are_Compile_Time) with using constants inside modules, which get automatically precompiled, and so the value of the constant would not change even between multiple executions of the program:

```Raku
# Foo.pm6 
unit module Foo;
constant comp-time = DateTime.now;
# The value of the constant remains the same even though our script 
# is executed multiple times: 
$ raku -I. -MFoo -e 'say Foo::comp-time'
2018-06-17T18:18:50.021484-04:00
$ raku -I. -MFoo -e 'say Foo::comp-time'
2018-06-17T18:18:50.021484-04:00
```

常量用关键字 `constant` 声明，后面跟着一个[标识符](https://docs.raku.org/language/syntax#Identifiers)，带有一个*可选*标记。常量默认情况下是 [`our` 作用域](https://docs.raku.org/language/variables#The_our_declarator)。

Constants are declared with keyword `constant` followed by an [identifier](https://docs.raku.org/language/syntax#Identifiers) with an *optional* sigil. Constants are [`our` scoped](https://docs.raku.org/language/variables#The_our_declarator) by default.

```Raku
    constant foo  = 42;
my  constant $baz = rand;
our constant @foo = 1, 2, 3;
    constant %bar = %(:42foo, :100bar);
```

*注意：如果你正在使用 Rakudo 编译器，你需要 2018.08 以上的版本才有类型约束和自动类型强制转换的常量。对带 % 符号的常数的自动类型转换需要 6.d* 以上的版本。

*NOTE: if you're using the Rakudo compiler, you need version 2018.08 or newer for type constraints and auto-coercion on constants to be available. Auto-coercion on %-sigiled constants requires 6.d*.

可以使用可选类型约束，在这种情况下，需要使用作用域声明器：

An optional type constraint can be used, in which case the use of scope declarator is required:

```Raku
# !!WRONG!! missing scope declarator before type: 
Int constant bar = 42;
 
# RIGHT: 
our Int constant bar = 42;
```

与[变量](https://docs.raku.org/language/variables)不同，你不能在声明带 `@`、 `%` 和 `&` 标记的常量时指定类型：

Unlike [variables](https://docs.raku.org/language/variables), you cannot parameterize `@`-, `%`-, and `&`-sigiled constants by specifying the parameterization type in the declarator itself:

```Raku
# !!WRONG!! cannot parameterize @-sigiled constant with Int 
our Int constant @foo = 42;
 
# OK: parameterized types as values are fine 
constant @foo = Array[Int].new: 42;
```

限制的原因是，带有 `@` 和 `%` 标记的常量默认为 [List](https://docs.raku.org/type/List) 和 [Map](https://docs.raku.org/type/Map) 类型，不支持参数形式。为了保持事物的简单性和一致性，参数形式指定类型在这些构造中被禁止。

The reason for the restriction is that constants with `@` and `%` sigils default to [List](https://docs.raku.org/type/List) and [Map](https://docs.raku.org/type/Map) types, which cannot be parameterized. To keep things simple and consistent, parameterization was simply disallowed in these constructs.

带 `@`、 `%` 和 `&` 标记的常量分别为 [Positional](https://docs.raku.org/type/Positional)、 [Associative](https://docs.raku.org/type/Associative) 和 [Callable](https://docs.raku.org/type/Callable) 角色指定给定值的隐含类型检查。带 `@` 标记的常量以及在 `6.d` 版本中带 `%` 标记的常量-如果它无法通过隐含的类型检查，则执行自动强制类型转换。

The `@`-, `%`-, and `&`-sigiled constants specify implied typecheck of the given value for [Positional](https://docs.raku.org/type/Positional), [Associative](https://docs.raku.org/type/Associative), and [Callable](https://docs.raku.org/type/Callable) roles respectively. The `@`-sigiled constants—and as of `6.d` language version, the `%`-sigiled constants as well—perform auto-coercion of the value if it does not pass the implied typecheck. The `@`-sigiled constants will coerce using method [cache](https://docs.raku.org/routine/cache) and `%`-sigiled constants coerce using method [Map](https://docs.raku.org/type/Map).

```Raku
constant @foo = 42;
@foo.perl.say; # OUTPUT: «(42,)» 
 
constant @bar = [<a b c>];
@bar.perl.say; # OUTPUT: «["a", "b", "c"]» 
 
constant %foo = <foo bar>;
%foo.perl.say; # OUTPUT: «Map.new((:foo("bar")))» 
 
constant %bar = {:10foo, :72bar};
%bar.perl.say; # OUTPUT: «{:bar(72), :foo(10)}» 
 
# Pair is already Associative, so it remains a Pair 
constant %baz = :72baz;
%baz.perl.say; # OUTPUT: «:baz(72)» 
```

出于方便和一致性的原因，你可以使用[绑定运算符(`:=`)](https://docs.raku.org/routine/:=)而不是赋值运算符，在无标记的常量名称之前使用反斜杠（与[无标记变量](https://docs.raku.org/language/variables#Sigilless_variables)相同），甚至可以完全省略常量名称来得到匿名常量。由于你不能引用匿名实体，因此你最好使用 [`BEGIN`相位器](https://docs.raku.org/language/phasers#BEGIN)，这样更清晰。

For convenience and consistency reasons, you can use the [binding operator (`:=`)](https://docs.raku.org/routine/:=) instead of the assignment operator, use backslash before sigilless name of the constant variable (same as with [sigilless variables](https://docs.raku.org/language/variables#Sigilless_variables)), and even omit the name of the constant entirely to have an anonymous constant. Since you can't refer to anonymous entities, you may be better off using a [`BEGIN` phaser](https://docs.raku.org/language/phasers#BEGIN) instead, for clarity.

```Raku
constant %foo := :{:42foo};
constant \foo = 42;
constant = 'anon';
```
