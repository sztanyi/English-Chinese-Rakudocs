原文：https://docs.raku.org/language/numerics

# 数值 / Numerics

Raku 中提供的数字类型

Numeric types available in Raku
<!-- MarkdownTOC -->

- [`Int`](#int)
- [`Num`](#num)
- [`Complex`](#complex)
- [`Rational`](#rational)
    - [`Rat`](#rat)
        - [降级为 `Num` / Degradation to `Num`](#降级为-num--degradation-to-num)
    - [`FatRat`](#fatrat)
            - [打印 rationals / Printing rationals](#打印-rationals--printing-rationals)
- [除 0 / Division by zero](#除-0--division-by-zero)
    - [零分母有理数 / Zero-denominator rationals](#零分母有理数--zero-denominator-rationals)
- [语素变体 / Allomorphs](#语素变体--allomorphs)
    - [可用的语素变体 / Available allomorphs](#可用的语素变体--available-allomorphs)
    - [语素变体的强制类型转换 / Coercion of allomorphs](#语素变体的强制类型转换--coercion-of-allomorphs)
    - [对象标识 / Object identity](#对象标识--object-identity)
- [原生数字 / Native numerics](#原生数字--native-numerics)
    - [可用的原生数字 / Available native numerics](#可用的原生数字--available-native-numerics)
    - [创建原生数字 / Creating native numerics](#创建原生数字--creating-native-numerics)
    - [溢出/下溢 - Overflow/Underflow](#溢出下溢---overflowunderflow)
    - [自动装箱 / Auto-boxing](#自动装箱--auto-boxing)
    - [默认值 / Default values](#默认值--default-values)
    - [原生分派 / Native dispatch](#原生分派--native-dispatch)
    - [原子操作 / Atomic operations](#原子操作--atomic-operations)
- [数字传染性 / Numeric infectiousness](#数字传染性--numeric-infectiousness)

<!-- /MarkdownTOC -->

<a id="int"></a>
# `Int`

`Int` 类型提供任意大小的整数。它们可以像计算机内存允许的那样大，虽然有些实现在被要求生成真正惊人大小的整数时会选择抛出数字溢出错误：

The `Int` type offers arbitrary-size integer numbers. They can get as big as your computer memory allows, although some implementations choose to throw a numeric overflow error when asked to produce integers of truly staggering size:

```Raku
say 10**600**600
# OUTPUT: «Numeric overflow
» 
```

与某些语言不同，当两个操作数都是 [Int](https://docs.raku.org/type/Int) 类型时，使用 [`/` 运算符](https://docs.raku.org/routine/$SOLIDUS)执行的除法将产生一个分数，而不是取整。

Unlike some languages, division performed using [`/` operator](https://docs.raku.org/routine/$SOLIDUS) when both operands are of [Int](https://docs.raku.org/type/Int) type, would produce a fractional number, without any rounding performed.

```Raku
say 4/5; # OUTPUT: «0.8
» 
```

相除生成的类型是 [Rat](https://docs.raku.org/type/Rat) 或 [Num](https://docs.raku.org/type/Num) 类型。如果分数的分母小于 64 位，则生成 [Rat](https://docs.raku.org/type/Rat)，否则生成 [Num](https://docs.raku.org/type/Num) 类型。

The type produced by this division is either a [Rat](https://docs.raku.org/type/Rat) or a [Num](https://docs.raku.org/type/Num) type. The [Rat](https://docs.raku.org/type/Rat) is produced if, after reduction, the fraction's denominator is smaller than 64 bits, otherwise a [Num](https://docs.raku.org/type/Num) type is produced.

如果你希望尽可能得到一个 [Int](https://docs.raku.org/type/Int) 结果，则 [div](https://docs.raku.org/routine/div) 和 [narrow](https://docs.raku.org/routine/narrow) 例程可能会有所帮助。[div](https://docs.raku.org/routine/div) 运算符执行整数除法，丢弃其余部分，而 [narrow](https://docs.raku.org/routine/narrow) 将数字匹配到最窄的类型：

The [div](https://docs.raku.org/routine/div) and [narrow](https://docs.raku.org/routine/narrow) routines can be helpful if you wish to end up with an [Int](https://docs.raku.org/type/Int) result, whenever possible. The [div](https://docs.raku.org/routine/div) operator performs integer division, discarding the remainder, while [narrow](https://docs.raku.org/routine/narrow) fits the number into the narrowest type it'll fit:

```Raku
say 5 div 2; # OUTPUT: «2
» 
 
# Result `2` is narrow enough to be an Int: 
say (4/2).narrow; # OUTPUT: «2
» 
say (4/2).narrow.^name; # OUTPUT: «Int
» 
 
# But 2.5 has fractional part, so it ends up being a Rat type: 
say (5/2).narrow.^name; # OUTPUT: «Rat
» 
say (5/2).narrow;       # OUTPUT: «2.5
» 
 
# Denominator is too big for a Rat, so a Num is produced: 
say 1 / 10⁹⁹; # OUTPUT: «1e-99
» 
```

Raku 有一个 [FatRat](https://docs.raku.org/type/FatRat) 类型，提供任意精度分数。在上一个例子中，为什么会产生有限精度的 [Num](https://docs.raku.org/type/Num) 而不是 [FatRat](https://docs.raku.org/type/FatRat) 类型？原因是：性能。大多数操作降低一点精度没问题，因此不需要使用更昂贵的 [FatRat](https://docs.raku.org/type/FatRat) 类型。如果你希望有额外的精度，你需要自己实例化一个。

Raku has a [FatRat](https://docs.raku.org/type/FatRat) type that offers arbitrary precision fractions. How come a limited-precision [Num](https://docs.raku.org/type/Num) is produced instead of a [FatRat](https://docs.raku.org/type/FatRat) type in the last example above? The reason is: performance. Most operations are fine with a little bit of precision lost and so do not require the use of a more expensive [FatRat](https://docs.raku.org/type/FatRat) type. You'll need to instantiate one yourself if you wish to have the extra precision.

<a id="num"></a>
# `Num`

[Num](https://docs.raku.org/type/Num) 类型提供 [双精度浮点](https://en.wikipedia.org/wiki/Double-precision_floating-point_format)十进制数，在其他语言中有时称为 “doubles”。

The [Num](https://docs.raku.org/type/Num) type offers [double-precision floating-point](https://en.wikipedia.org/wiki/Double-precision_floating-point_format) decimal numbers, sometimes called "doubles" in other languages.

[Num](https://docs.raku.org/type/Num) 字面量的写法是使用字母 `e` 与指数分割开。请记住，即使指数为零，字母 `e` 也是*必需的*，否则你将得到一个 [Rat](https://docs.raku.org/type/Rat) 有理数字面量：

A [Num](https://docs.raku.org/type/Num) literal is written with the exponent separated using the letter `e`. Keep in mind that the letter `e` **is required** even if the exponent is zero, as otherwise you'll get a [Rat](https://docs.raku.org/type/Rat) rational literal instead:

```Raku
say 42e0.^name; # OUTPUT: «Num
» 
say 42.0.^name; # OUTPUT: «Rat
» 
```

区分大小写的单词 [Inf](https://docs.raku.org/type/Num#Inf) 和 [NaN](https://docs.raku.org/type/Num#NaN) 分别表示特殊值无穷大和非数字。可以使用 U+221E 表示无限（`∞`）字符而不是 [Inf](https://docs.raku.org/type/Num#Inf)：

Case-sensitive words [Inf](https://docs.raku.org/type/Num#Inf) and [NaN](https://docs.raku.org/type/Num#NaN) represent the special values infinity and not-a-number respectively. The U+221E INFINITY (`∞`) character can be used instead of [Inf](https://docs.raku.org/type/Num#Inf):

Raku 尽可能遵循 [IEEE 754-2008 浮点算术标准](https://en.wikipedia.org/wiki/IEEE_754)，计划在以后的语言版本中实现更多的一致性。该语言保证为任何给定的 [Num](https://docs.raku.org/type/Num) 文本选择最接近的可表示数字，并支持负零和[非规格化数字](https://en.wikipedia.org/wiki/Denormal_number)（也称为 “subnormals”）。

Raku follows the [IEEE 754-2008 Standard for Floating-Point Arithmetic](https://en.wikipedia.org/wiki/IEEE_754) as much as possible, with more conformance planned to be implemented in later language versions. The language guarantees the closest representable number is chosen for any given [Num](https://docs.raku.org/type/Num) literal and does offer support for negative zero and [denormals](https://en.wikipedia.org/wiki/Denormal_number) (also known as "subnormals").

请记住，输出例程（如 [say](https://docs.raku.org/routine/say) 或 [put](https://docs.raku.org/routine/put) 不会很难区分 [Numeric](https://docs.raku.org/type/Numeric) 类型是如何输出的，并且可以选择显示 [Num](https://docs.raku.org/type/Num) 作为 [Int](https://docs.raku.org/type/Int) 或 [Rat](https://docs.raku.org/type/Rat)。要输出更明确的字符串，请使用 [raku](https://docs.raku.org/routine/raku) 方法：

Keep in mind that output routines like [say](https://docs.raku.org/routine/say) or [put](https://docs.raku.org/routine/put) do not try very hard to distinguish between how [Numeric](https://docs.raku.org/type/Numeric) types are output and may choose to display a [Num](https://docs.raku.org/type/Num) as an [Int](https://docs.raku.org/type/Int) or a [Rat](https://docs.raku.org/type/Rat) number. For a more definitive string to output, use the [raku](https://docs.raku.org/routine/raku) method:

```Raku
say  1e0;      # OUTPUT: «1
» 
say .5e0;      # OUTPUT: «0.5
» 
say  1e0.raku; # OUTPUT: «1e0
» 
say .5e0.raku; # OUTPUT: «0.5e0
» 
```

<a id="complex"></a>
# `Complex`

[复平面](https://en.wikipedia.org/wiki/Complex_plane)的[复数](https://docs.raku.org/type/Complex)型数值。[复数](https://docs.raku.org/type/Complex)对象由两个 [Num](https://docs.raku.org/type/Num) 对象组成，表示复数的[实部](https://docs.raku.org/routine/re)和[虚部](https://docs.raku.org/routine/im)部分。

The [Complex](https://docs.raku.org/type/Complex) type numerics of the [complex plane](https://en.wikipedia.org/wiki/Complex_plane). The [Complex](https://docs.raku.org/type/Complex) objects consist of two [Num](https://docs.raku.org/type/Num) objects representing the [real](https://docs.raku.org/routine/re) and [imaginary](https://docs.raku.org/routine/im) portions of the complex number.

要创建[复数](https://docs.raku.org/type/Complex)，可以在任何其他非复数上使用[后缀 `i` 运算符](https://docs.raku.org/routine/i)，可选择使用加法设置实部。要使用 `i` 运算符作用在 `NaN` 或 `Inf` 字面量上，请使用反斜杠将其与它们分开。

To create a [Complex](https://docs.raku.org/type/Complex), you can use the [postfix `i` operator](https://docs.raku.org/routine/i) on any other non-complex number, optionally setting the real part with addition. To use the `i` operator on `NaN` or `Inf` literals, separate it from them with a backslash.

```Raku
say 42i;      # OUTPUT: «0+42i
» 
say 73+42i;   # OUTPUT: «73+42i
» 
say 73+Inf\i; # OUTPUT: «73+Inf\i
» 
```

请记住，上面的语法只是一个附加表达式和优先级规则适用。它也不能用于禁止表达式的地方，例如常规参数中的字面量。

Keep in mind the above syntax is just an addition expression and precedence rules apply. It also cannot be used in places that forbid expressions, such as literals in routine parameters.

```Raku
# Precedence of `*` is higher than that of `+` 
say 2 * 73+10i; # OUTPUT: «146+10i
» 
```

为了避免这些问题，你可以选择使用[复数](https://docs.raku.org/type/Complex)字面量语法，其中包括使用尖括号包围实部和虚部，**而不包含任何空格**：

To avoid these issues, you can choose to use the [Complex](https://docs.raku.org/type/Complex) literal syntax instead, which involves surrounding the real and imaginary parts with angle brackets, *without any spaces*:

```Raku
say 2 * <73+10i>; # OUTPUT: «146+20i
» 
 
multi how-is-it (<2+4i>) { say "that's my favorite number!" }
multi how-is-it (|)      { say "meh"                        }
how-is-it 2+4i;  # OUTPUT: «that's my favorite number!
» 
how-is-it 3+2i;  # OUTPUT: «meh
» 
```

<a id="rational"></a>
# `Rational`

执行 [Rational](https://docs.raku.org/type/Rational) 角色的类型提供高精度和任意精度的十进制数。由于精度越高，性能损失越大，[Rational](https://docs.raku.org/type/Rational) 类型有两种形式：[Rat](https://docs.raku.org/type/Rat) 和 [FatRat](https://docs.raku.org/type/FatRat)。[Rat](https://docs.raku.org/type/Rat) 是最常用的变体, 其在大多数情况下降级成 [Num](https://docs.raku.org/type/Num)，当它不再能容纳所有的要求精度时。[FatRat](https://docs.raku.org/type/FatRat) 是保持增长提供所有所需的精度任意精度的变体。

The types that do the [Rational](https://docs.raku.org/type/Rational) role offer high-precision and arbitrary-precision decimal numbers. Since the higher the precision the larger the performance penalty, the [Rational](https://docs.raku.org/type/Rational) types come in two flavors: [Rat](https://docs.raku.org/type/Rat) and [FatRat](https://docs.raku.org/type/FatRat). The [Rat](https://docs.raku.org/type/Rat) is the most often-used variant that degrades into a [Num](https://docs.raku.org/type/Num) in most cases, when it can no longer hold all of the requested precision. The [FatRat](https://docs.raku.org/type/FatRat) is the arbitrary-precision variant that keeps growing to provide all of the requested precision.

<a id="rat"></a>
## `Rat`

最常见的 [Rational](https://docs.raku.org/type/Rational) 类型。它支持有 64 位分母的有理数（在将分数换算到最小分母之后）。`Rat` 可以直接创建具有较大分母的对象，但是，当具有这样的分母的 `Rat` 是数学运算的结果时，它们会降级为 [Num](https://docs.raku.org/type/Num) 对象。

The most common of [Rational](https://docs.raku.org/type/Rational) types. It supports rationals with denominators as large as 64 bits (after reduction of the fraction to the lowest denominator). `Rat` objects with larger denominators can be created directly, however, when `Rat`s with such denominators are the result of mathematical operations, they degrade to a [Num](https://docs.raku.org/type/Num) object.

在许多其他语言中 [Rat](https://docs.raku.org/type/Rat) 字面量使用和 [Num](https://docs.raku.org/type/Num) 字面量类似的语法，使用点来表示数字是十进制：

The [Rat](https://docs.raku.org/type/Rat) literals use syntax similar to [Num](https://docs.raku.org/type/Num) literals in many other languages, using the dot to indicate the number is a decimal:

```Raku
say .1 + .2 == .3; # OUTPUT: «True
» 
```

如果你在许多常用语言中执行与上述类似的语句, 由于浮点数学的精度，你将得到 `False` 作为答案。要在 Raku 中获得相同的结果，你必须使用 [Num](https://docs.raku.org/type/Num) 字面量：

If you try to execute a statement similar to the above in many common languages, you'll get `False` as the answer, due to imprecision of floating point math. To get the same result in Raku, you'd have to use [Num](https://docs.raku.org/type/Num) literals instead:

```Raku
say .1e0 + .2e0 == .3e0; # OUTPUT: «False
» 
```

你还可以使用具有 [Int](https://docs.raku.org/type/Int) 或 [Rat](https://docs.raku.org/type/Rat) 对象的 [`/` 除法运算符](https://docs.raku.org/routine/$SOLIDUS)来生成 [Rat](https://docs.raku.org/type/Rat)：

You can also use [`/` division operator](https://docs.raku.org/routine/$SOLIDUS) with [Int](https://docs.raku.org/type/Int) or [Rat](https://docs.raku.org/type/Rat) objects to produce a [Rat](https://docs.raku.org/type/Rat):

```Raku
say 3/4;     # OUTPUT: «0.75
» 
say 3/4.2;   # OUTPUT: «0.714286
» 
say 1.1/4.2; # OUTPUT: «0.261905
» 
```

请记住，上面的语法只是一个应用了优先级规则的除法表达式。它也不能用于禁止表达式的地方，例如例程参数中的字面量。

Keep in mind the above syntax is just a division expression and precedence rules apply. It also cannot be used in places that forbid expressions, such as literals in routine parameters.

```Raku
# Precedence of power operators is higher than division 
say 3/2²; # OUTPUT: «0.75
» 
```

为了避免这些问题，你可以选择使用 [Rational](https://docs.raku.org/type/Rational) 字面量语法，它用尖括号括起分子和分母，**不带任何空格**：

To avoid these issues, you can choose to use the [Rational](https://docs.raku.org/type/Rational) literal syntax instead, which involves surrounding the numerator and denominator with angle brackets, *without any spaces*:

```Raku
say <3/2>²; # OUTPUT: «2.25
» 
 
multi how-is-it (<3/2>) { say "that's my favorite number!" }
multi how-is-it (|)     { say "meh"                        }
how-is-it 3/2;  # OUTPUT: «that's my favorite number!
» 
how-is-it 1/3;  # OUTPUT: «meh
» 
```

最后，任何具有 `No` 属性的表示小数的 Unicode 字符都可以用作 [Rat](https://docs.raku.org/type/Rat) 字面量：

Lastly, any Unicode character with property `No` that represents a fractional number can be used as a [Rat](https://docs.raku.org/type/Rat) literal:

```Raku
say ½ + ⅓ + ⅝ + ⅙; # OUTPUT: «1.625
» 
```

<a id="降级为-num--degradation-to-num"></a>
### 降级为 `Num` / Degradation to `Num`

如果产生 [Rat](https://docs.raku.org/type/Rat) 答案的*数学运算*会产生分母大于 64 位的 [Rat](https://docs.raku.org/type/Rat)，则该操作将返回 [Num](https://docs.raku.org/type/Num) 对象。当*构建*一个[Rat](https://docs.raku.org/type/Rat)（即，当它不是一些数学表达式的结果）时，但是，可以使用更大的分母：

If a *mathematical operation* that produces a [Rat](https://docs.raku.org/type/Rat) answer would produce a [Rat](https://docs.raku.org/type/Rat) with denominator larger than 64 bits, that operation would instead return a [Num](https://docs.raku.org/type/Num) object. When *constructing* a [Rat](https://docs.raku.org/type/Rat) (i.e. when it is not a result of some mathematical expression), however, a larger denominator can be used:

```Raku
my $a = 1 / (2⁶⁴ - 1);
say $a;                   # OUTPUT: «0.000000000000000000054
» 
say $a.^name;             # OUTPUT: «Rat
» 
say $a.nude;              # OUTPUT: «(1 18446744073709551615)
» 
 
my $b = 1 / 2⁶⁴;
say $b;                   # OUTPUT: «5.421010862427522e-20
» 
say $b.^name;             # OUTPUT: «Num
» 
 
my $c = Rat.new(1, 2⁶⁴);
say $c;                   # OUTPUT: «0.000000000000000000054
» 
say $c.^name;             # OUTPUT: «Rat
» 
say $c.nude;              # OUTPUT: «(1 18446744073709551616)
» 
say $c.Num;               # OUTPUT: «5.421010862427522e-20
»
```

<a id="fatrat"></a>
## `FatRat`

最后一个 [Rational](https://docs.raku.org/type/Rational) 类型 - [FatRat](https://docs.raku.org/type/FatRat) - 保留你所要求的所有精度，将分子和分母存储为两个 [Int](https://docs.raku.org/type/Int) 对象。[FatRat](https://docs.raku.org/type/FatRat) 比 [Rat](https://docs.raku.org/type/Rat) 更具传染性，有这么多的 [FatRat](https://docs.raku.org/type/FatRat) 数学运算会产生另一个 [FatRat](https://docs.raku.org/type/FatRat)，保留所有可用的精度。当 [Rat](https://docs.raku.org/type/Rat) 退化为 [Num](https://docs.raku.org/type/Num) 时，使用 [FatRat ](https://docs.raku.org/type/FatRat)的数学运算会持续不断：

The last [Rational](https://docs.raku.org/type/Rational) type—[FatRat](https://docs.raku.org/type/FatRat)—keeps all of the precision you ask of it, storing the numerator and denominator as two [Int](https://docs.raku.org/type/Int) objects. A [FatRat](https://docs.raku.org/type/FatRat) is more infectious than a [Rat](https://docs.raku.org/type/Rat), so many math operations with a [FatRat](https://docs.raku.org/type/FatRat) will produce another [FatRat](https://docs.raku.org/type/FatRat), preserving all of the available precision. Where a [Rat](https://docs.raku.org/type/Rat) degrades to a [Num](https://docs.raku.org/type/Num), math with a [FatRat](https://docs.raku.org/type/FatRat) keeps chugging along:

```Raku
say ((42 + Rat.new(1,2))/999999999999999999).^name;         # OUTPUT: «Rat
» 
say ((42 + Rat.new(1,2))/9999999999999999999).^name;        # OUTPUT: «Num
» 
say ((42 + FatRat.new(1,2))/999999999999999999).^name;      # OUTPUT: «FatRat
» 
say ((42 + FatRat.new(1,2))/99999999999999999999999).^name; # OUTPUT: «FatRat
» 
```

没有特殊的运算符或语法可用于构造 [FatRat](https://docs.raku.org/type/FatRat) 对象。只需使用 [`FatRat.new`](https://docs.raku.org/type/FatRat#%28Rational%29_method_new) 方法，将分子作为第一个位置参数，将分母作为第二个位置参数。

There's no special operator or syntax available for construction of [FatRat](https://docs.raku.org/type/FatRat) objects. Simply use [`FatRat.new` method](https://docs.raku.org/type/FatRat#%28Rational%29_method_new), giving numerator as first positional argument and denominator as the second.

如果你的程序需要大量的 [FatRat](https://docs.raku.org/type/FatRat) 创建，你可以创建自己的自定义运算符：

If your program requires a significant amount of [FatRat](https://docs.raku.org/type/FatRat) creation, you could create your own custom operator:

```Raku
sub infix:<🙼> { FatRat.new: $^a, $^b }
say (1🙼3).raku; # OUTPUT: «FatRat.new(1, 3)
» 
```

<a id="打印-rationals--printing-rationals"></a>
#### 打印 rationals / Printing rationals

请记住，像 [say](https://docs.raku.org/routine/say) 或 [put](https://docs.raku.org/routine/put) 这样的输出例程不会力图区分[数字](https://docs.raku.org/type/Numeric)类型如何输出，并且可能选择将 [Num](https://docs.raku.org/type/Num) 显示为 [Int](https://docs.raku.org/type/Int) 或 [Rat](https://docs.raku.org/type/Rat) 数字。要获得更明确的输出字符串，请使用 [raku](https://docs.raku.org/routine/raku) 方法：

Keep in mind that output routines like [say](https://docs.raku.org/routine/say) or [put](https://docs.raku.org/routine/put) do not try very hard to distinguish between how [Numeric](https://docs.raku.org/type/Numeric) types are output and may choose to display a [Num](https://docs.raku.org/type/Num) as an [Int](https://docs.raku.org/type/Int) or a [Rat](https://docs.raku.org/type/Rat) number. For a more definitive string to output, use the [raku](https://docs.raku.org/routine/raku) method:

```Raku
say 1.0;        # OUTPUT: «1
» 
say ⅓;          # OUTPUT: «0.333333
» 
say 1.0.raku;   # OUTPUT: «1.0
» 
say ⅓.raku;     # OUTPUT: «<1/3>
» 
```

有关更多信息，你可以选择用 [nude](https://docs.raku.org/routine/nude) 方法查看 [Rational](https://docs.raku.org/type/Rational) 对象，显示其分子和分母：

For even more information, you may choose to see the [Rational](https://docs.raku.org/type/Rational) object in the [nude](https://docs.raku.org/routine/nude), displaying its **nu**merator and **de**nominator:

```Raku
say ⅓;          # OUTPUT: «0.333333
» 
say 4/2;        # OUTPUT: «2
» 
say ⅓.raku;     # OUTPUT: «<1/3>
» 
say <4/2>.nude; # OUTPUT: «(2 1)
» 
```

<a id="除-0--division-by-zero"></a>
# 除 0 / Division by zero

在许多语言中，除以零立马会抛出一个异常。在 Raku 中，会发生什么取决于你要除的东西以及你如何使用结果。

In many languages division by zero is an immediate exception. In Raku, what happens depends on what you're dividing and how you use the result.

Raku 遵循 [IEEE 754-2008 浮点运算标准](https://en.wikipedia.org/wiki/IEEE_754)，但由于历史原因，6.c 和 6.d 语言版本不完全符合。[Num](https://docs.raku.org/type/Num) 被零除产生 [Failure](https://docs.raku.org/type/Failure)，而[复数](https://docs.raku.org/type/Complex)被零除产生 `NaN`, 无论分子是什么。

Raku follows [IEEE 754-2008 Standard for Floating-Point Arithmetic](https://en.wikipedia.org/wiki/IEEE_754), but for historical reasons 6.c and 6.d language versions do not comply fully. [Num](https://docs.raku.org/type/Num) division by zero produces a [Failure](https://docs.raku.org/type/Failure), while [Complex](https://docs.raku.org/type/Complex) division by zero produces `NaN`components, regardless of what the numerator is.

从 6.e 语言开始，[Num](https://docs.raku.org/type/Num) 和 [Complex](https://docs.raku.org/type/Complex) 除以零将产生[-Inf](https://docs.raku.org/type/Num#Inf)，`+Inf` 或 [NaN](https://docs.raku.org/type/Num#NaN), 这取决于分子是负数，正数还是零（对于[复数](https://docs.raku.org/type/Complex)，实部和虚部是 [Num](https://docs.raku.org/type/Num) 并且被分别考虑）。

As of 6.e language, both [Num](https://docs.raku.org/type/Num) and [Complex](https://docs.raku.org/type/Complex) division by zero will produce a -[Inf](https://docs.raku.org/type/Num#Inf), `+Inf`, or [NaN](https://docs.raku.org/type/Num#NaN) depending on whether the numerator was negative, positive, or zero, respectively (for [Complex](https://docs.raku.org/type/Complex) the real and imaginary components are [Num](https://docs.raku.org/type/Num) and are considered separately).

[Int](https://docs.raku.org/type/Int) 相除产生 [Rat](https://docs.raku.org/type/Rat) 对象（或 [Num](https://docs.raku.org/type/Num)，如果在换算之后分母大于 64 位，当你除以零时就不是这种情况）。这意味着这种除法永远不会产生 [Exception](https://docs.raku.org/type/Exception) 或 [Failure](https://docs.raku.org/type/Failure)。结果是零分母有理数，这可能是爆炸性的。

Division of [Int](https://docs.raku.org/type/Int) numerics produces a [Rat](https://docs.raku.org/type/Rat) object (or a [Num](https://docs.raku.org/type/Num), if after reduction the denominator is larger than 64-bits, which isn't the case when you're dividing by zero). This means such division never produces an [Exception](https://docs.raku.org/type/Exception) or a [Failure](https://docs.raku.org/type/Failure). The result is a Zero-Denominator Rational, which can be explosive.

<a id="零分母有理数--zero-denominator-rationals"></a>
## 零分母有理数 / Zero-denominator rationals

[零分母](https://docs.raku.org/type/FatRat) 有理数是一个扮演 [Rational](https://docs.raku.org/type/Rational) 角色的数字，它在核心数字中将是 [Rat](https://docs.raku.org/type/Rat) 和 [FatRat](https://docs.raku.org/type/FatRat) 对象，其分母为零。这样根据原始分子是否为负，零或正数, 有理数的分子被归为 `-1`、`0` 或 `1`。

A Zero-Denominator Rational is a numeric that does role [Rational](https://docs.raku.org/type/Rational), which among core numerics would be [Rat](https://docs.raku.org/type/Rat) and [FatRat](https://docs.raku.org/type/FatRat)objects, which has denominator of zero. The numerator of such Rationals is normalized to `-1`, `0`, or `1` depending on whether the original numerator is negative, zero or positive, respectively.

可以在不需要实际除法的情况下执行的操作是非爆炸性的。例如，你可以单独检查 [nude](https://docs.raku.org/routine/nude) 方法结果中的[分子](https://docs.raku.org/routine/numerator)和[分母](https://docs.raku.org/routine/denominator)，或执行数学运算，而不会出现任何异常或失败。

Operations that can be performed without requiring actual division to occur are non-explosive. For example, you can separately examine [numerator](https://docs.raku.org/routine/numerator) and [denominator](https://docs.raku.org/routine/denominator) in the [nude](https://docs.raku.org/routine/nude) or perform mathematical operations without any exceptions or failures popping up.

转换零分母有理数到 [Num](https://docs.raku.org/type/Num) 遵循 [IEEE](https://en.wikipedia.org/wiki/IEEE_754) 公约，结果是 `-Inf`，`Inf`，或 `NaN`，这取决于分子是否分别是负、正、或零。从另一个方面来看也是如此：转换 `±Inf`/ `NaN` 到其中一个 [Rational](https://docs.raku.org/type/Rational) 类型将产生具有适当分子的零分母有理数：

Converting zero-denominator rationals to [Num](https://docs.raku.org/type/Num) follows the [IEEE](https://en.wikipedia.org/wiki/IEEE_754) conventions, and the result is a `-Inf`, `Inf`, or `NaN`, depending on whether the numerator is negative, positive, or zero, respectively. The same is true going the other way: converting `±Inf`/`NaN` to one of the [Rational](https://docs.raku.org/type/Rational) types will produce a zero-denominator rational with an appropriate numerator:

```Raku
say  <1/0>.Num;   # OUTPUT: «Inf
» 
say <-1/0>.Num;   # OUTPUT: «-Inf
» 
say  <0/0>.Num;   # OUTPUT: «NaN
» 
say Inf.Rat.nude; # OUTPUT: «(1 0)
» 
```

要求非 [IEEE](https://en.wikipedia.org/wiki/IEEE_754) 除法的分子和分母的所有其他操作将导致抛出异常 `X::Numeric::DivideByZero`。最常见的此类操作可能是尝试打印或字符串化零分母有理数：

All other operations that require non-[IEEE](https://en.wikipedia.org/wiki/IEEE_754) division of the numerator and denominator to occur will result in `X::Numeric::DivideByZero` exception to be thrown. The most common of such operations would likely be trying to print or stringify a zero-denominator rational:

```Raku
say 0/0;
# OUTPUT: 
# Attempt to divide by zero using div 
#  in block <unit> at -e line 1 
```

<a id="语素变体--allomorphs"></a>
# 语素变体 / Allomorphs

[Allomorphs](https://docs.raku.org/language/glossary#index-entry-Allomorph) 是两种类型的子类，可以表现为它们中的任何一种。例如，[IntStr](https://docs.raku.org/type/IntStr) 是 [Int](https://docs.raku.org/type/Int) 和 [Str](https://docs.raku.org/type/Str) 类型的子类，并且将被需要 [Int](https://docs.raku.org/type/Int) 或 [Str](https://docs.raku.org/type/Str) 对象的任何类型约束所接受。

[Allomorphs](https://docs.raku.org/language/glossary#index-entry-Allomorph) are subclasses of two types that can behave as either of them. For example, the allomorph [IntStr](https://docs.raku.org/type/IntStr) is the subclass of [Int](https://docs.raku.org/type/Int) and [Str](https://docs.raku.org/type/Str) types and will be accepted by any type constraint that requires an [Int](https://docs.raku.org/type/Int) or [Str](https://docs.raku.org/type/Str) object.

语素变体可以使用[尖括号](https://docs.raku.org/language/quoting#Word_quoting%3A_%3C_%3E)创建，可以单独使用或作为散列键查找的一部分使用; 直接使用方法 `.new` 生成，也可以由一些结构提供，如 [`sub MAIN`](https://docs.raku.org/language/functions#sub_MAIN) 的参数。

Allomorphs can be created using [angle brackets](https://docs.raku.org/language/quoting#Word_quoting%3A_%3C_%3E), either used standalone or as part of a hash key lookup; directly using method `.new` and are also provided by some constructs such as parameters of [`sub MAIN`](https://docs.raku.org/language/functions#sub_MAIN).

```Raku
say <42>.^name;                 # OUTPUT: «IntStr
» 
say <42e0>.^name;               # OUTPUT: «NumStr
» 
say < 42+42i>.^name;            # OUTPUT: «ComplexStr
» 
say < 1/2>.^name;               # OUTPUT: «RatStr
» 
say <0.5>.^name;                # OUTPUT: «RatStr
» 
 
@*ARGS = "42";
sub MAIN($x) { say $x.^name }   # OUTPUT: «IntStr
» 
 
say IntStr.new(42, "42").^name; # OUTPUT: «IntStr
» 
```

上面的几个结构在开角括号之后有一个空格。那个空格不是意外。通常含运算符的数字，例如 `1/2`（[Rat](https://docs.raku.org/type/Rat)，除法运算）和 `1+2i`（[复数](https://docs.raku.org/type/Complex)，加法运算）可以写成不使用运算符的字面值：在尖括号和尖括号里面的字符之间*没有*任何空格。通过在尖括号中添加空格，我们告诉编译器我们不仅需要 [Rat](https://docs.raku.org/type/Rat) 或 [Complex](https://docs.raku.org/type/Complex) 字面量，而且我们还希望它是一个语素变体：是 [RatStr](https://docs.raku.org/type/RatStr) 或 [ComplexStr](https://docs.raku.org/type/ComplexStr)。

A couple of constructs above have a space after the opening angle bracket. That space isn't accidental. Numerics that are often written using an operator, such as `1/2` ([Rat](https://docs.raku.org/type/Rat), division operator) and `1+2i` ([Complex](https://docs.raku.org/type/Complex), addition) can be written as a literal that doesn't involve the use of an operator: angle brackets *without* any spaces between the angle brackets and the characters inside. By adding spaces within the angle brackets, we tell the compiler that not only we want a [Rat](https://docs.raku.org/type/Rat) or [Complex](https://docs.raku.org/type/Complex)literal, but we also want it to be an allomorph: the [RatStr](https://docs.raku.org/type/RatStr) or [ComplexStr](https://docs.raku.org/type/ComplexStr), in this case.

如果数字字面量不使用任何运算符，则将其写入尖括号内，即使不包含任何空格，也会产生语素变体。（逻辑：如果你不想要语素变体，别使用尖括号。对于使用运算符的数字也是如此，因为某些结构，例如函数签名字面量，不允许你使用运算符，所以你不能只为这些数字字面量省略尖括号）。

If the numeric literal doesn't use any operators, then writing it inside the angle brackets, even without including any spaces within, would produce the allomorph. (Logic: if you didn't want the allomorph, you wouldn't use the angle brackets. The same isn't true for operator-using numbers as some constructs, such as signature literals, do not let you use operators, so you can't just omit angle brackets for such numeric literals).

<a id="可用的语素变体--available-allomorphs"></a>
## 可用的语素变体 / Available allomorphs

核心语言提供以下语素变体：

The core language offers the following allomorphs:

| Type       | Allomorph of    | Example |
| ---------- | --------------- | ------- |
| IntStr     | Int and Str     | <42>    |
| NumStr     | Num and Str     | <42e0>  |
| ComplexStr | Complex and Str | < 1+2i> |
| RatStr     | Rat and Str     | <1.5>   |

注意：没有 `FatRatStr` 这种类型。

Note: there is no `FatRatStr` type.

<a id="语素变体的强制类型转换--coercion-of-allomorphs"></a>
## 语素变体的强制类型转换 / Coercion of allomorphs

请记住，语素变体只是它们所代表的两种（或三种）类型的子类。正如变量或参数类型约束为 `Foo` 可以接受任何 `Foo` 子类一样，所以变量或参数类型约束为 [Int](https://docs.raku.org/type/Int) 的将接受 [IntStr](https://docs.raku.org/type/IntStr) 语素变体：

Keep in mind that allomorphs are simply subclasses of the two (or three) types they represent. Just as a variable or parameter type-constrained to `Foo` can accept any subclass of `Foo`, so will a variable or parameter type-constrained to [Int](https://docs.raku.org/type/Int) will accept an [IntStr](https://docs.raku.org/type/IntStr) allomorph:

```Raku
sub foo(Int $x) { say $x.^name }
foo <42>;                          # OUTPUT: «IntStr
» 
my Num $y = <42e0>;
say $y.^name;                      # OUTPUT: «NumStr
» 
```

当然，这也适用于参数[强制类型转换器](https://docs.raku.org/type/Signature#Coercion_type)：

This, of course, also applies to parameter [coercers](https://docs.raku.org/type/Signature#Coercion_type):

```Raku
sub foo(Int(Cool) $x) { say $x.^name }
foo <42>;  # OUTPUT: «IntStr
» 
```

给定的语素变体*已经*是 [Int](https://docs.raku.org/type/Int) 类型的对象，因此在这种情况下它不会转换为“普通的” [Int](https://docs.raku.org/type/Int)。

The given allomorph is *already* an object of type [Int](https://docs.raku.org/type/Int), so it does not get converted to a "plain" [Int](https://docs.raku.org/type/Int) in this case.

当然，如果没有办法将它们“折叠”到其中一个组件，那么同质异形体的力量将会严重减弱。因此，如果你使用所要强制到的类型的名字显式调用方法，那么你将获得该组件。这同样适用于任何代理方法，例如调用方法 [`.Numeric`](https://docs.raku.org/routine/Numeric) 而不是 [`.Int`](https://docs.raku.org/routine/Int) 或使用 [`prefix:<~>` 运算符](https://docs.raku.org/routine/~) 而不是 [`.Str`](https://docs.raku.org/routine/Str) 方法调用。

Of course, the power of allomorphs would be severely diminished if there were no way to "collapse" them to one of their components. Thus, if you explicitly call a method with the name of the type to coerce to, you'll get just that component. The same applies to any proxy methods, such as calling method [`.Numeric`](https://docs.raku.org/routine/Numeric) instead of [`.Int`](https://docs.raku.org/routine/Int) or using the [`prefix:<~>` operator](https://docs.raku.org/routine/~) instead of [`.Str`](https://docs.raku.org/routine/Str) method call.

```Raku
my $al := IntStr.new: 42, "forty two";
say $al.Str;  # OUTPUT: «forty two
» 
say +$al;     # OUTPUT: «42
» 
 
say <1/99999999999999999999>.Rat.^name;    # OUTPUT: «Rat
» 
say <1/99999999999999999999>.FatRat.^name; # OUTPUT: «FatRat
» 
```

强制整个语素变体列表的一种方便方法是将[超运算符](https://docs.raku.org/language/operators#Hyper_operators)应用于适当的前缀：

A handy way to coerce a whole list of allomorphs is by applying the [hyper operator](https://docs.raku.org/language/operators#Hyper_operators) to the appropriate prefix:

```Raku
say map *.^name,   <42 50e0 100>;  # OUTPUT: «(IntStr NumStr IntStr)
» 
say map *.^name, +«<42 50e0 100>;  # OUTPUT: «(Int Num Int)
» 
say map *.^name, ~«<42 50e0 100>;  # OUTPUT: «(Str Str Str)
» 
```

<a id="对象标识--object-identity"></a>
## 对象标识 / Object identity

当我们考虑对象一致性时，上面关于强制类型转换为语素变体的讨论变得更加重要。一些构造利用它来确定两个对象是否“相同”。而对于人类而言，语素变体 `42` 和常规的 `42` 可能看起来“相同”，对于那些构造，它们是完全不同的对象：

The above discussion on coercing allomorphs becomes more important when we consider object identity. Some constructs utilize it to ascertain whether two objects are "the same". And while to humans an allomorphic `42` and regular `42` might appear "the same", to those constructs, they're entirely different objects:

```Raku
# "42" shows up twice in the result: 42 and <42> are different objects: 
say unique 1, 1, 1, 42, <42>; # OUTPUT: «(1 42 42)
» 
# Use a different operator to `unique` with: 
say unique :with(&[==]), 1, 1, 1, 42, <42>; # OUTPUT: «(1 42)
» 
# Or coerce the input instead (faster than using a different `unique` operator): 
say unique :as(*.Int), 1, 1, 1, 42, <42>; # OUTPUT: «(1 42)
» 
say unique +«(1, 1, 1, 42, <42>);         # OUTPUT: «(1 42)
» 
 
# Parameterized Hash with `Any` keys does not stringify them; our key is of type `Int`: 
my %h{Any} = 42 => "foo";
# But we use the allomorphic key of type `IntStr`, which is not in the Hash: 
say %h<42>:exists;           # OUTPUT: «False
» 
# Must use curly braces to avoid the allomorph: 
say %h{42}:exists;           # OUTPUT: «True
» 
 
# We are using a set operator to look up an `Int` object in a list of `IntStr` objects: 
say 42 ∈ <42 100 200>; # OUTPUT: «False
» 
# Convert it to an allomorph: 
say <42> ∈ <42 100 200>; # OUTPUT: «True
» 
# Or convert the items in the list to plain `Int` objects: 
say 42 ∈ +«<42 100 200>; # OUTPUT: «True
» 
```

注意这些对象一致性的差异，并根据需要强制类型转换你的语素变体。

Be mindful of these object identity differences and coerce your allomorphs as needed.

<a id="原生数字--native-numerics"></a>
# 原生数字 / Native numerics

顾名思义，原生数字可以访问原生数字 - 即由硬件直接提供的数字。这反过来又提供两个功能：溢出/下溢和更好的性能。

As the name suggests, native numerics offer access to native numerics—i.e. those offered directly by your hardware. This in turn offers two features: overflow/underflow and better performance.

**注意：**在撰写本文时（2018.05），某些实现（例如 Rakudo）提供了有关原生类型的一些细节，例如 `int64` 是否可用且在 32 位计算机上具有 64 位大小，以及如何检测何时你的程序正在这样的硬件上运行。

**NOTE:** at the time of this writing (2018.05), certain implementations (such as Rakudo) offer somewhat spotty details on native types, such as whether `int64` is available and is of 64-bit size on 32-bit machines, and how to detect when your program is running on such hardware.

<a id="可用的原生数字--available-native-numerics"></a>
## 可用的原生数字 / Available native numerics

| Native type | Base numeric     | Size                                                         |
| ----------- | ---------------- | ------------------------------------------------------------ |
| atomicint   | integer          | sized to offer CPU-provided atomic operations. (typically 64 bits on 64-bit platforms and 32 bits on 32-bit ones) |
| int         | integer          | 64-bits                                                      |
| int16       | integer          | 16-bits                                                      |
| int32       | integer          | 32-bits                                                      |
| int64       | integer          | 64-bits                                                      |
| int8        | integer          | 8-bits                                                       |
| num         | floating point   | 64-bits                                                      |
| num32       | floating point   | 32-bits                                                      |
| num64       | floating point   | 64-bits                                                      |
| uint        | unsigned integer | 64-bits                                                      |
| uint16      | unsigned integer | 16-bits                                                      |
| uint32      | unsigned integer | 32-bits                                                      |
| uint64      | unsigned integer | 64-bits                                                      |
| uint8       | unsigned integer | 8-bits                                                       |

<a id="创建原生数字--creating-native-numerics"></a>
## 创建原生数字 / Creating native numerics

要创建原生类型的变量或参数，只需使用其中一个可用数字的名称作为类型约束：

To create a natively-typed variable or parameter, simply use the name of one of the available numerics as the type constraint:

```Raku
my int32 $x = 42;
sub foo(num $y) {}
class { has int8 $.z }
```

有时，你可能希望在不创建任何可用变量的情况下将某些值强制转换为原生类型。没有 `.int` 或类似的强制方法（方法调用是后期的，所以它们不适合这个目的）。相反，只需使用匿名变量：

At times, you may wish to coerce some value to a native type without creating any usable variables. There are no `.int` or similar coercion methods (method calls are latebound, so they're not well-suited for this purpose). Instead, simply use an anonymous variable:

```Raku
some-native-taking-sub (my int $ = $y), (my int32 $ = $z)
```

<a id="溢出下溢---overflowunderflow"></a>
## 溢出/下溢 - Overflow/Underflow

尝试**赋值**不适合特定原生类型的值会产生异常。这包括尝试为原生参数提供过大的参数：

Trying to **assign** a value that does not fit into a particular native type, produces an exception. This includes attempting to give too large an argument to a native parameter:

```Raku
my int $x = 2¹⁰⁰;
# OUTPUT: 
# Cannot unbox 101 bit wide bigint into native integer 
#  in block <unit> at -e line 1 
 
sub f(int $x) { $x }; say f 2⁶⁴
# OUTPUT: 
# Cannot unbox 65 bit wide bigint into native integer 
#   in sub f at -e line 1 
#   in block <unit> at -e line 1 
```

但是，以这样一种太大/太小的方式修改已存在的值会产生溢出/下溢行为：

However, modifying an already-existing value in such a way that it becomes too big/small, produces overflow/underflow behavior:

```Raku
my int $x = 2⁶³-1;
say $x;             # OUTPUT: «9223372036854775807
» 
say ++$x;           # OUTPUT: «-9223372036854775808
» 
 
my uint8 $x;
say $x;             # OUTPUT: «0
» 
say $x -= 100;      # OUTPUT: «156
» 
```

创建使用原生类型的对象不涉及直接赋值; 这就是为什么这些构造提供溢出/下溢行为而不是抛出异常。

Creating objects that utilize native types does not involve direct assignment by the programmer; that is why these constructs offer overflow/underflow behavior instead of throwing exceptions.

```Raku
say Buf.new(1000, 2000, 3000).List; # OUTPUT: «(232 208 184)
» 
say my uint8 @a = 1000, 2000, 3000; # OUTPUT: «232 208 184
» 
```

<a id="自动装箱--auto-boxing"></a>
## 自动装箱 / Auto-boxing

虽然它们可以被称为“**原生类型** ”，但原生数字实际上并不是具有任何可用方法的类。但是，你*可以*调用这些数字的非原生版本上可用的任何方法。这是怎么回事？

While they can be referred to as "native *types*", native numerics are not actually classes that have any sort of methods available. However, you *can* call any of the methods available on non-native versions of these numerics. What's going on?

```Raku
my int8 $x = -42;
say $x.abs; # OUTPUT: «42
» 
```

此行为称为“自动装箱”。编译器使用所有方法自动将原生类型“装箱”为功能齐全的高级类型。换句话说，`int8` 上面的内容自动转换为 [Int](https://docs.raku.org/type/Int) 然后它是 [Int](https://docs.raku.org/type/Int) 类，然后提供被调用的 [abs](https://docs.raku.org/routine/abs) 方法。

This behavior is known as "auto-boxing". The compiler automatically "boxes" the native type into a full-featured higher-level type with all the methods. In other words, the `int8` above was automatically converted to an [Int](https://docs.raku.org/type/Int) and it's the [Int](https://docs.raku.org/type/Int) class that then provided the [abs](https://docs.raku.org/routine/abs) method that was called.

当你使用原生类型获得性能提升时，此细节非常重要。如果你正在使用的代码导致执行大量自动装箱，那么使用原生类型的性能可能会比使用非原生类型时*更差*：

This detail is significant when you're using native types for performance gains. If the code you're using results in a lot of auto-boxing being performed you might get *worse* performance with native types than you would with non-natives:

```Raku
my $a = -42;
my int $a-native = -42;
{ for ^1000_000 { $a.abs        }; say now - ENTER now } # OUTPUT: «0.38180862
» 
{ for ^1000_000 { $a-native.abs }; say now - ENTER now } # OUTPUT: «0.938720
» 
```

如你所见，原生变体的执行时间是两倍多。原因是方法调用需要将原生类型装箱，而非原生变体不需要这样的东西，因此性能损失。

As you can see above, the native variant is more than twice slower. The reason is the method call requires the native type to be boxed, while no such thing is needed in the non-native variant, hence the performance loss.

在这种特殊情况下，我们可以简单地切换到 [abs](https://docs.raku.org/routine/abs) 的子程序形式，它可以使用原生类型而无需装箱。在其他情况下，你可能需要寻找其他解决方案以避免过多的自动装箱，包括切换到部分代码的非原生类型。

In this particular case, we can simply switch to a subroutine form of [abs](https://docs.raku.org/routine/abs), which can work with native types without boxing them. In other cases, you may need to seek out other solutions to avoid excessive autoboxing, including switching to non-native types for a portion of the code.

```Raku
my $a = -42;
my int $a-native = -42;
{ for ^1000_000 { abs $a        }; say now - ENTER now } # OUTPUT: «0.38229177
» 
{ for ^1000_000 { abs $a-native }; say now - ENTER now } # OUTPUT: «0.3088305
» 
```

<a id="默认值--default-values"></a>
## 默认值 / Default values

由于原生类型没有类，因此通常没有使用尚未初始化的变量获得的类型对象。因此，原生类型自动初始化为零。在 6.c 语言版本，原生的浮点类型（`num`、 `num32` 和 `num64`）被初始化为值 `NaN`; 在 6.d 语言版本中默认为 `0e0`。

Since there are no classes behind native types, there are no type objects you'd normally get with variables that haven't been initialized. Thus, native types are automatically initialized to zero. In 6.c language, native floating point types (`num`, `num32`, and `num64`) were initialized to value `NaN`; in 6.d language the default is `0e0`.

<a id="原生分派--native-dispatch"></a>
## 原生分派 / Native dispatch

例如，当大小可预测时，可以使用原生候选者提供更快算法，否则回退到较慢的非原生候选者。以下是涉及原生候选者的多重分派的规则。

It is possible to have native candidates alongside non-native candidates to, for example, offer faster algorithms with native candidates when sizes are predictable, but to fallback to slower non-native alternatives otherwise. The following are the rules concerning multi-dispatch involving native candidates.

首先，原生类型的大小在调度中不起作用，并且 `int8` 被认为与 `int16` 或 `int` 相同：

First, the size of the native type does not play a role in dispatch and an `int8` is considered to be the same as `int16` or `int`:

```Raku
multi foo(int   $x) { say "int" }
multi foo(int32 $x) { say "int32" }
foo my int $x = 42;
# OUTPUT: 
# Ambiguous call to 'foo(Int)'; these signatures all match: 
# :(int $x) 
# :(int32 $x) 
```

其次，如果例程是一个 `only` - 也就是说，它不是一个接受非原生类型的 [`multi`](https://docs.raku.org/language/functions#Multi-dispatch) 例程，但是在调用期间给了例程一个原生类型，反之亦然，那么参数将被自动装箱或自动取消装箱以使可以被调用。如果给定的参数太大而无法放入原生参数，则会抛出异常：

Second, if a routine is an `only`—i.e. it is not a [`multi`](https://docs.raku.org/language/functions#Multi-dispatch)—that takes a non-native type but a native one was given during the call, or vice-versa, then the argument will be auto-boxed or auto-unboxed to make the call possible. If the given argument is too large to fit into the native parameter, an exception will be thrown:

```Raku
-> int {}( 42 );            # OK; auto-unboxing 
-> int {}( 2¹⁰⁰ );          # Too large; exception 
-> Int {}( 2¹⁰⁰ );          # OK; non-native parameter 
-> Int {}( my int $ = 42 ); # OK; auto-boxing 
```

当涉及到 [`multi`](https://docs.raku.org/language/functions#Multi-dispatch) 例程，如果没有原生类型候选，原生类型的参数将始终自动装箱。

When it comes to [`multi`](https://docs.raku.org/language/functions#Multi-dispatch) routines, native arguments will always be auto-boxed if no native candidates are available to take them:

```Raku
multi foo (Int $x) { $x }
say foo my int $ = 42; # OUTPUT: «42
» 
```

反过来，同样的奢侈却是无法承受的。如果只有原生候选对象可用，则非原生参数将*不*自动取消装箱，而将引发一个异常，指示不会引发任何匹配的候选对象（这种不对称的原因是原生类型始终可以装箱，但非原生类型可能太大，不适合原生类型）：

The same luxury is not afforded when going the other way. If only a native candidate is available, a non-native argument will *not* be auto-unboxed and instead an exception indicating no candidates matched will be thrown (the reason for this asymmetry is a native type can always be boxed, but a non-native may be too large to fit into a native):

```Raku
multi f(int $x) { $x }
my $x = 2;
say f $x;
# OUTPUT: 
# Cannot resolve caller f(Int); none of these signatures match: 
#     (int $x) 
#   in block <unit> at -e line 1 
```

但是，如果正在进行调用，其中一个参数是原生类型而另一个是[数字字面量](https://docs.raku.org/language/syntax#Number_literals)，则放弃此规则：

However, this rule is waived if a call is being made where one of the arguments is a native type and another one is a [numeric literal](https://docs.raku.org/language/syntax#Number_literals):

```Raku
multi f(int, int) {}
f 42, my int $x; # Successful call 
```

这样，你就不必不断将诸如 `$n +> 2` 写为 `$n +> (my int $ = 2)` 了。编译器知道字面量小到足以适合原生类型并将其转换为原生类型。

This way you do not have to constantly write, for example, `$n +> 2` as `$n +> (my int $ = 2)`. The compiler knows the literal is small enough to fit to a native type and converts it to a native.

<a id="原子操作--atomic-operations"></a>
## 原子操作 / Atomic operations

该语言提供了保证以原子方式执行的[一些操作](https://docs.raku.org/type/atomicint)，即安全地由多个线程执行而无需锁定而没有数据争用的风险。

The language offers [some operations](https://docs.raku.org/type/atomicint) that are guaranteed to be performed atomically, i.e. safe to be executed by multiple threads without the need for locking with no risk of data races.

对于此类操作，需要 [atomicint](https://docs.raku.org/type/atomicint) 原生类型。此类型与普通原生 [int](https://docs.raku.org/type/int) 类似，不同之处在于它的大小使得可以对其执行 CPU 提供的原子操作。在 32 位 CPU 上，它通常是 32 位大小，而在 64 位 CPU 上，它通常是 64 位大小。

For such operations, the [atomicint](https://docs.raku.org/type/atomicint) native type is required. This type is similar to a plain native [int](https://docs.raku.org/type/int), except it is sized such that CPU-provided atomic operations can be performed upon it. On a 32-bit CPU it will typically be 32 bits in size, and on an a 64-bit CPU it will typically be 64 bits in size.

```Raku
# !!WRONG!! Might be non-atomic on some systems 
my int $x;
await ^100 .map: { start $x⚛++ };
say $x; # OUTPUT: «98
» 
 
# RIGHT! The use of `atomicint` type guarantees operation is atomic 
my atomicint $x;
await ^100 .map: { start $x⚛++ };
say $x; # OUTPUT: «100
» 
```

`int` 相似性也存在于多重分派中： `atomicint`、 普通的 `int` 和固定大小的 `int` 变量都是相同的，并且不能通过多重分派来区分。

The similarity to `int` is present in multi dispatch as well: an `atomicint`, plain `int`, and the sized `int` variants are all considered to be the same by the dispatcher and cannot be differentiated through multi-dispatch.

<a id="数字传染性--numeric-infectiousness"></a>
# 数字传染性 / Numeric infectiousness

当一些数学运算中涉及两个不同类型的数字时，数字“传染性”决定了结果类型。如果结果是该类型而不是其他操作数的类型，则认为类型比其他类型更具传染性。例如，[Num](https://docs.raku.org/type/Num) 类型比 [Int](https://docs.raku.org/type/Int) 更具传染性，因此我们可以期望 `42e0 + 42` 产生 [Num](https://docs.raku.org/type/Num) 作为结果。

Numeric "infectiousness" dictates the resultant type when two numerics of different types are involved in some mathematical operations. A type is said to be more infectious than the other type if the result is of that type rather than the type of the other operand. For example, [Num](https://docs.raku.org/type/Num) type is more infectious than an [Int](https://docs.raku.org/type/Int), thus we can expect `42e0 + 42` to produce a [Num](https://docs.raku.org/type/Num) as the result.

传递性如下，首先列出最具传染性的类型

The infectiousness is as follows, with the most infectious type listed first:

- Complex
- Num
- FatRat
- Rat
- Int

```Raku
say (2 + 2e0).^name; # Int + Num => OUTPUT: «Num
» 
say (½ + ½).^name; # Rat + Rat => OUTPUT: «Rat
» 
say (FatRat.new(1,2) + ½).^name; # FatRat + Rat => OUTPUT: «FatRat
» 
```

语素变体具有与其数字成分相同的传递性。原生类型获得自动装箱，并具有与其盒装变体相同的传递性。

The allomorphs have the same infectiousness as their numeric component. Native types get autoboxed and have the same infectiousness as their boxed variant.
