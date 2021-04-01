原文：https://docs.raku.org/language/math

# 使用 Raku 做数学 / Doing math with Raku

不同的数学范式及其在这种语言中的实现方式

Different mathematical paradigms and how they are implemented in this language

# 集合 / Sets

Raku 包含 [Set](https://docs.raku.org/type/Set) 数据类型，以及对[大多数集合运算符](https://docs.raku.org/language/setbagmix#Set/Bag_operators)的支持。[并集和交集](https://en.wikipedia.org/wiki/Algebra_of_sets)不仅仅是原生运算符，而是使用它们的*天然*符号 ∩ 和 ∪。例如，该代码将检查有限数量的集合的集合算术的基本规律：

Raku includes the [Set](https://docs.raku.org/type/Set) data type, as well as support for [most set operations](https://docs.raku.org/language/setbagmix#Set/Bag_operators). [Union and intersection](https://en.wikipedia.org/wiki/Algebra_of_sets) are not only native operations, they use their *natural* symbols, ∩ and ∪. For instance, this code would check the fundamental laws of the arithmetic of sets for a limited number of sets:

```Raku
my @arbitrary-numbers = ^100;
my \U = @arbitrary-numbers.Set;
 
my @sets;
 
@sets.push: Set.new( @arbitrary-numbers.pick( @arbitrary-numbers.elems.rand)) for @arbitrary-numbers;
 
my (@union, @intersection);
 
for @sets -> $set {
    @union.push: $set ∩ $set === $set;
    @intersection.push: $set ∪ $set === $set;
}
 
say "Idempotent union is ", so @union.all;
# OUTPUT: «Idempotent union is True» 
say "Idempotent intersection is ", so @intersection.all;
# OUTPUT: «Idempotent intersection is True» 
my (@universe, @empty-set, @id-universe, @id-empty);
 
for @sets -> \A {
    @universe.push: A ∪ U === U;
    @id-universe.push: A ∩ U === A;
    @empty-set.push: A ∩ ∅ === ∅;
    @id-empty.push: A ∪ ∅ === A;
}
 
say "Universe dominates ", so @universe.all;    # OUTPUT: «Universe dominates True» 
say "Empty set dominates ", so @empty-set.all;  # OUTPUT: «Empty set dominates True» 
 
say "Identity with U ", so @id-universe.all;    # OUTPUT: «Identity with U True» 
say "Identity with ∅ ", so @id-empty.all;       # OUTPUT: «Identity with ∅ True» 
```

在这个代码中，我们使用已由 Raku 定义的[空集合](https://docs.raku.org/language/setbagmix#term_%E2%88%85)。不仅检查集合代数中的等式是否成立，还通过[无标记变量](https://docs.raku.org/language/variables#index-entry-\_(sigilless_variables))和集合运算符的 Unicode 形式。使用尽可能接近原始形式的表达式，例如 `A ∪ U === U`。除了使用[恒等运算符 `===`](https://docs.raku.org/routine/===)，但它非常接近[维基百科条目](https://en.wikipedia.org/wiki/Algebra_of_sets)中实际的数学表达式。

In this code, which uses the [empty set](https://docs.raku.org/language/setbagmix#term_%E2%88%85) which is already defined by Raku, not only do we check if the equalities in the algebra of sets hold, we also use, via [sigilless variables](https://docs.raku.org/language/variables#index-entry-\_(sigilless_variables)) and the Unicode form of the set operators, expressions that are as close as possible to the original form; `A ∪ U === U`, for example, except for the use of the [value identity operator `===`](https://docs.raku.org/routine/===) is very close to the actual mathematical expression in the [Wikipedia entry](https://en.wikipedia.org/wiki/Algebra_of_sets).

我们甚至可以测试德摩根定律，如下代码所示：

We can even test De Morgan's law, as in the code below:

```Raku
my @alphabet = 'a'..'z';
my \U = @alphabet.Set;
sub postfix:<⁻>(Set $a) { U ⊖ $a }
my @sets;
@sets.push: Set.new( @alphabet.pick( @alphabet.elems.rand)) for @alphabet;
my ($de-Morgan1,$de-Morgan2) = (True,True);
for @sets X @sets -> (\A, \B){
    $de-Morgan1 &&= (A ∪ B)⁻  === A⁻ ∩ B⁻;
    $de-Morgan2 &&= (A ∩ B)⁻  === A⁻ ∪ B⁻;
}
say "1st De Morgan is ", $de-Morgan1;
say "2nd De Morgan is ", $de-Morgan2;
```

我们定义 `⁻` 为*补集*操作符，它计算全集 `U` 和我们的集合之间的对称差。一旦声明了这一点，就可以相对容易地用与原始数学表示法非常接近的表示法来表示运算，例如 A 和 B 的结合 `(A ∪ B)⁻` 的补集运算。

We declare `⁻` as the *complement* operation, which computes the symmetrical difference ⊖ between the Universal set `U` and our set. Once that is declared, it is relatively easy to express operations such as the complementary of the union of A and B, `(A ∪ B)⁻`, with a notation that is very close to the original mathematical notation.

# 算术 / Arithmetic

Raku 可以使用不同的数据类型进行算术。[Num](https://docs.raku.org/type/Num)、[Rat](https://docs.raku.org/type/Rat) 和 [Complex](https://docs.raku.org/type/Complex) 都可以作为[加法、减法、乘法和除法运算符的字段](https://en.wikipedia.org/wiki/Field_(mathematics))（从技术上讲，处理浮点数表示的数据类型由于其算术本身的不精确性而不是数学意义上的字段。然而，在大多数情况下，它们构成了这类数学对象的一个足够近似的、计算机友好的版本）。等价的数学字段是：

Raku can do arithmetic using different data types. [Num](https://docs.raku.org/type/Num), [Rat](https://docs.raku.org/type/Rat) and [Complex](https://docs.raku.org/type/Complex) can all operate as a [field under the operations of addition, subtraction, multiplication and division](https://en.wikipedia.org/wiki/Field_(mathematics)) (technically, it should be noted that data types dealing with floating point number representations are not a field in the mathematical sense due to the inherent imprecisions of their arithmetic. However, they constitute an approximate enough, computer friendly version of such mathematical objects for most of the cases). The equivalent mathematical fields are:

| Raku class | Field |
| ---------- | ----- |
| Rat        | ℚ     |
| Num        | ℝ     |
| Complex    | ℂ     |

`Int` 或 ℤ，不是一个数学字段，而是一个环，因为它们不是在乘法逆运算下封闭的。但是，如果使用整数除法 `div`，则它们的操作总是会产生其他整数；而如果使用 `/`，则结果通常是 [Rat](https://docs.raku.org/type/Rat)。

The `Int`s or ℤ, as they're usually called in mathematics, are not a mathematical field but rather a ring, since they are not closed under multiplicative inverses. However, if the integer division `div` is used, their operations will always yield other integers; if `/` is used, on the other hand, in general the result will be a [Rat](https://docs.raku.org/type/Rat).

此外，`Int` 可以执行无限精度运算（或至少在内存允许的范围内；“数字溢出”仍可发生），如果数字太大，则不回退到 [Num](https://docs.raku.org/type/Num)：

Besides, `Int` can do infinite-precision arithmetic (or at least infinite as memory allows; `Numeric overflow` can still occur), without falling back to [Num](https://docs.raku.org/type/Num) if the number is too big:

```Raku
my @powers = 2, 2 ** * ... Inf; say @powers[4].chars; # OUTPUT: «19729␤»
```

严格地说，行为像数学字段的 Rational 类是 [FatRat](https://docs.raku.org/type/FatRat)。出于效率原因，当数字足够大或分子和分母之间有很大差异时，使用 `Rat` 的操作将回退到 `Num`。`FatRat` 可以以任意精度工作，与默认的 `Int` 类相同。

Also strictly speaking, the Rational class that behaves like a mathematical field is [FatRat](https://docs.raku.org/type/FatRat). For efficiency reasons, operating with `Rat`s will fall back to `Num` when the numbers are big enough or when there is a big difference between numerator and denominator. `FatRat` can work with arbitrary precision, the same as the default `Int` class.

生态系统中的某些模块可以在数学上处理其他数据类型：

Some modules in the ecosystem can work with additional data types mathematically:

- [`Math::Vector`](https://github.com/colomon/Math-Vector) 可以对 [vectors](https://en.wikipedia.org/wiki/Coordinate_vector) 执行基本运算。
- [`Math::Matrix`](https://github.com/pierre-vigier/Perl6-Math-Matrix) 对[数值环上的矩阵环](https://en.wikipedia.org/wiki/Matrix_(mathematics))运算。
- [`Math::Quaternion`](https://github.com/Util/Perl6-Math-Quaternion) 为[四元数代数, ℍ](https://en.wikipedia.org/wiki/Quaternion) 运算。
- [`Math::Polynomial`](https://github.com/colomon/Math-Polynomial) 处理多项式并且能够用它们做简单的算术。
- [`Math::Symbolic`](https://github.com/raydiak/Math-Symbolic) 处理符号数学。

##

- [`Math::Vector`](https://github.com/colomon/Math-Vector) basic operations for [vectors](https://en.wikipedia.org/wiki/Coordinate_vector).
- [`Math::Matrix`](https://github.com/pierre-vigier/Perl6-Math-Matrix) operates on [matrices rings over numeric rings](https://en.wikipedia.org/wiki/Matrix_(mathematics)).
- [`Math::Quaternion`](https://github.com/Util/Perl6-Math-Quaternion) operates on the [quaternion algebra, ℍ](https://en.wikipedia.org/wiki/Quaternion), which are a generalization of complex numbers.
- [`Math::Polynomial`](https://github.com/colomon/Math-Polynomial) works with polynomials, and is able to do simple arithmetic with them.
- [`Math::Symbolic`](https://github.com/raydiak/Math-Symbolic), for symbolic math.

数字将被自动类型转换到实际表示的数字类：

Numbers are duck-typed automatically to the numeric class they actually represent:

```Raku
.^name.say for (4, ⅗, 1e-9, 3+.1i); # OUTPUT: «Int␤Rat␤Num␤Complex␤»
```

算术运算是通过考虑操作数的类型来执行的：

Arithmetic operations are performed by taking into account the type of operands:

```Raku
say .33 - .22 - .11 == 0; # OUTPUT: «True␤»
```

在这种情况下，所有数字都被解释为 `Rat`，这使得操作准确。一般来说，大多数其他语言都会将它们解释为浮点数，如果需要，也可以用 Raku 语言实现：

In this case, all numbers are interpreted as `Rat`s, which makes the operation exact. In general, most other languages would interpret them as floating point numbers, which can also be achieved in Raku if needed:

```Raku
say .33.Num - .22.Num - .11.Num; # OUTPUT: «1.3877787807814457e-17␤»
```

对于这种情况，Raku 还包括一个“近似相等”运算符 [≅](https://docs.raku.org/language/operators#infix_=~=)

For cases such as this, Raku also includes an `approximately equal` operator, [≅](https://docs.raku.org/language/operators#infix_=~=)

```Raku
say .33.Num - .22.Num - .11.Num ≅ 0; # OUTPUT: «True␤»
```

# 序列 / Sequences

[sequence](https://en.wikipedia.org/wiki/Sequence) 是允许重复的*枚举*对象集合，也是 Raku 中名为 [Seq](https://docs.raku.org/type/Seq) 的一级数据类型。`Seq` 能够表示无限序列，就像自然数一样：

A [sequence](https://en.wikipedia.org/wiki/Sequence) is an *enumerated* collection of objects in which repetitions are allowed, and also a first-class data type in Raku called [Seq](https://docs.raku.org/type/Seq). `Seq` is able to represent infinite sequences, like the natural numbers:

```Raku
my \𝕟 = 1,2 … ∞;
say 𝕟[3];         # OUTPUT: «4␤»
```

无限序列使用 ∞、`Inf` 或 `*` （Whatever）作为终止符。[…](https://docs.raku.org/language/operators#infix_...) 为列表生成器，实际上，只要插入第一个数字，它就可以理解算术序列和几何级数序列：

Infinite sequences use ∞, `Inf` or `*` (Whatever) as terminator. […](https://docs.raku.org/language/operators#infix_...) is the list generator, which in fact can understand arithmetic and geometric progression sequences as long as you insert the first numbers:

```Raku
say 1,5,9 … * > 100;
# OUTPUT: «(1 5 9 13 17 21 25 29 33 37 41 45 49 53 57 61 65 69 73 77 81 85 89 93 97 101)␤» 
say 1,3,9 … * > 337; # OUTPUT: «(1 3 9 27 81 243 729)␤»
```

当生成的数大于 100 时，第一序列将终止；第二序列，即几何级数，当它大于 337 时终止。

The first sequence will be terminated when the generated number is bigger than 100; the second sequence, which is a geometric progression, when it is bigger than 337.

可以使用任意生成器这一事实使得生成诸如[斐波纳契数列](https://en.wikipedia.org/wiki/Fibonacci_number)这样的序列变得非常容易。

The fact that an arbitrary generator can be used makes easy to generate sequences such as [Fibonacci numbers](https://en.wikipedia.org/wiki/Fibonacci_number):

```Raku
say 1,1, * + * … * > 50;#  OUTPUT: «(1 1 2 3 5 8 13 21 34 55)␤»
```

实际上，我们可以这样计算[黄金比例](https://en.wikipedia.org/wiki/Golden_ratio)的近似：

We can, in fact, compute the approximation to the [golden ratio](https://en.wikipedia.org/wiki/Golden_ratio) this way:

```Raku
my @phis = (2.FatRat, 1 + 1 / * ... *);
my @otherphi = (1 - @phis[200], 1 + 1 / * ... *);
say @otherphi[^10, |(20, 30 ... 100)];  # OUTPUT: 
# «((-0.61803398874989484820458683436563811772030918 
# -0.61803398874989484820458683436563811772030918 
# -0.61803398874989484820458683436563811772030918 
# -0.61803398874989484820458683436563811772030918 
# -0.61803398874989484820458683436563811772030918 
# -0.618033…»
```

[Math::Sequences](https://github.com/ajs/perl6-Math-Sequences) 模块包括许多已经为你定义的数学序列。它有许多[百科全书中的序列](https://oeis.org/)，其中有些有它们的原名，如 ℤ。

The [Math::Sequences](https://github.com/ajs/perl6-Math-Sequences) module includes many mathematical sequences, already defined for you. It has many [sequences from the encyclopedia](https://oeis.org/), some of them with their original name, such as ℤ.

一些集合操作符也对序列进行操作，它们可以用来确定一个对象是否是它的一部分：
 
Some set operators also operate on sequences, and they can be used to find out if an object is part of it:

```Raku
say 876 ∈ (7,14 … * > 1000) ; # OUTPUT: «False␤»
```

在这种特殊情况下，我们可以直接找出 `876` 是否为 7 的倍数，但对于其他使用复杂生成器的序列，同样的原理也适用。我们也可以使用集合包含操作符：

In this particular case, we can find out if `876` is a multiple of 7 straight away, but the same principle holds for other sequences using complicated generators. And we can use set inclusion operators too:

```Raku
say (55,89).Set ⊂ (1,1, * + * … * > 200); # OUTPUT: «True␤»
```

尽管如此，它并没有考虑到如果它是一个有效的子序列，只是这两个元素。集合没有顺序，即使没有显式地将子序列转换为集合或显式地将其转换为 `Seq`，也会强制将子序列转换为包含运算符的应用程序。

That said, it does not take into account if it is effectively a subsequence, just the presence of the two elements here. Sets have no order, and even if you don't explicitly cast the subsequence into a Set or explicitly cast it into a `Seq` it will be coerced into such for the application of the inclusion operator.

# 数学常数 / Mathematical constants

Raku 包含一组数学常数：

Raku includes a set of mathematical constants:

```Raku
say π; # OUTPUT: «3.141592653589793» 
say τ; # Equivalent to 2π; OUTPUT: «6.283185307179586» 
say 𝑒; # OUTPUT: «2.718281828459045␤»
```

这些常数也可通过 [ASCII 等价物](https://docs.raku.org/language/unicode_ascii)：`e`、`pi` 和 `tau` 提供。

These constants are also available through [ASCII equivalents](https://docs.raku.org/language/unicode_ascii): `e`, `pi` and `tau`.

[Math::Constants](https://github.com/JJ/p6-math-constants/pulls) 模块还包括一系列物理和数学常数，例如前面提到的黄金比例 φ 或普朗克常数 ℎ。

The [Math::Constants](https://github.com/JJ/p6-math-constants/pulls) module includes an additional series of physical and mathematical constants such as the previously mentioned golden ratio φ or the Planck's constant ℎ.

由于 Raku 允许定义使用 Unicode 语义图的变量，并且也允许没有任何类型标记的变量和常量名称，所以在可能的情况下，使用实际的数学名称来命名它们是很好的做法。

Since Raku allows for definition of variables that use Unicode graphemes, and also variable and constant names without any kind of sigil, it is considered a good practice to use the actual mathematical name of concepts to denominate them wherever possible.

# 常微分方程的数值积分方程 / Numerical integration of ordinary differential equations

Raku 是一种惊人的编程语言，当然，你可以用它做很多很酷的数学。在应用数学家作品中，大量的作品是模拟他们创建的模型。因此，在每种编码语言中，数字积分器必须具有。在 Raku 中学习如何做到这一点是非常有用的。

Raku is an amazing programming language, and of course, you can do a lot of cool math with it. A great amount of work during an applied mathematician's work is to simulate the models they create. For this reason, in every coding language, a numerical integrator is a must-have. Learning how to do this in Raku can be very useful.

## 必要条件 / Requirements

在 Raku 中，生态系统中的一些模块可以使其更容易：

In Raku there are some modules in the ecosystem that can make it easier:

- [`Math::Model`](https://github.com/moritz/Math-Model) 用于以简单和自然的方式编写数学和物理模型。
- [`Math::RungeKutta`](https://github.com/moritz/Math-RungeKutta) 用于线性常微分方程组的龙格-库塔积分.

##

- [`Math::Model`](https://github.com/moritz/Math-Model) which lets you write mathematical and physical models in an easy and natural way.
- [`Math::RungeKutta`](https://github.com/moritz/Math-RungeKutta) Runge-Kutta integration for systems of ordinary, linear differential equations.

对于本例，我们将使用 [`Math::Model`](https://github.com/moritz/Math-Model) 来实现其有用的语法，但请记住，这个模块也需要 [`Math::RungeKutta`](https://github.com/moritz/Math-RungeKutta)。在使用这些示例之前，只需使用 *zef* 安装它们即可。

For this example we are going to use [`Math::Model`](https://github.com/moritz/Math-Model) for its useful syntax, but remember that this module requires [`Math::RungeKutta`](https://github.com/moritz/Math-RungeKutta) as well. Simply install them with *zef* before using these examples.

## 马尔萨斯模型 / Malthus model

让我们从数学生态学的 *'Hello World'* 开始：[马尔萨斯增长模型](https://en.wikipedia.org/wiki/Malthusian_growth_model)。有时称为简单指数增长模型的马尔萨斯增长模型是基于函数与函数增长的速度成比例的指数增长。等式如下：

Let's start with the *'Hello World'* of mathematical Ecology: [Malthusian growth model](https://en.wikipedia.org/wiki/Malthusian_growth_model). A Malthusian growth model, sometimes called a simple exponential growth model, is essentially exponential growth based on the idea of the function being proportional to the speed to which the function grows. The equation, then, looks like this:

*dx/dt = g\*x*

*x(0) = x_0*

其中 *g* 是人口增长率，有时称为马尔萨斯参数。

Where *g* is the population growth rate, sometimes called Malthusian parameter.

我们怎么才能把它翻译成 Raku 代码呢？ Math::Model 以一种非常容易理解的方式提供了一些帮助：

How can we translate that into Raku? Well Math::Model brings some help with a very understandable way to do that:

```Raku
use Math::Model;
 
my $m = Math::Model.new(
    derivatives => {
        velocity => 'x',
    },
    variables   => {
        velocity           => { $:growth_constant * $:x },
        growth_constant    => { 1 }, # basal growth rate 
    },
    initials    => {
        x       => 3,
    },
    captures    => ('x'),
);
 
$m.integrate(:from(0), :to(8), :min-resolution(0.5));
$m.render-svg('population growth malthus.svg', :title('population growth'));
```

为了充分了解正在发生的事情，让我们一步一步地看一遍。

To fully understand what is going on, let's go through it step by step.

### 逐步解释 / Step by step explanation

- 首先加载进行计算的模块：[`Math::Model`](https://github.com/moritz/Math-Model).

- First we load the module that make the calculations: [`Math::Model`](https://github.com/moritz/Math-Model).

```Raku
use Math::Model;
```

- 我们创建模型以添加其中的所有信息。

- We create the model to add all the information in it.

```Raku
my $m = Math::Model.new(
```

- 我们声明我们的模型中的衍生产品。在这种情况下，如果你记得我们的方程，我们有我们的变量 *x* 和它的导数 *x'*（通常称为速度）。

- We declare the derivatives that are in our model. In this case, if you remember our equation, we have our variable *x* and its derivative *x'* (usually know as the velocity).

```Raku
derivatives => {
    velocity => 'x',
},
```

- 在此之后，我们声明我们的模型是如何演变的。我们只需要那些也不是积分变量的导数的公式（在这种情况下，只需要 *x*），以及我们在公式中使用的其他变量（增长率）。

- After that, we declare how our models evolve. We just need formulas for the derivatives that are not also integration variables (in this case, only *x*), and for other variables we use in the formulas (the growth rate).

```Raku
variables   => {
    velocity           => { $:growth_constant * $:x},
    growth_constant    => { 1 }, # basal growth rate 
},
```

- 最后，我们声明我们的初始条件，并使用 *captures* 告诉 [`Math::Model`](https://github.com/moritz/Math-Model)在模拟运行时要记录哪个或哪些变量。

- Finally we declare our initial conditions and use *captures* to tell [`Math::Model`](https://github.com/moritz/Math-Model) which variable or variables to record while the simulation is running.

```Raku
initials    => {
    x       => 3,
},
captures    => ('x'),
```

在这一点上，我们的模型建立了。我们需要运行模拟，并对我们的结果绘制一个很酷的图表：

At this point our model is set. We need to run the simulation and render a cool plot about our results:

```Raku
$m.integrate(:from(0), :to(8), :min-resolution(0.5));
$m.render-svg('population growth malthus.svg', :title('population growth'));
```

在那里，我们选择我们的时限和分辨率。接下来，我们生成一个图表。都明白了吗？好吧，让我们看看结果！

There, we select our time limits and the resolution. Next, we generate a plot. All understood? Well, let's see our result!

[图片的链接](https://rawgit.com/thebooort/perl-6-math-model-tutorial/master/population%20growth%20malthus.svg)

[link to the image](https://rawgit.com/thebooort/perl-6-math-model-tutorial/master/population%20growth%20malthus.svg)

真不错！但老实说，这是完全没有代表性的。让我们从更复杂的情况中探索其他示例！

Looks great! But to be honest, it is quite unrepresentative. Let's explore other examples from more complex situations!

## Logistic 模型 / Logistic model

资源不是无限的，我们的人口也不会永远增长。皮埃尔·弗朗索瓦·韦吕勒也是这么想的，所以他提出了 [Logistic 模型](https://en.wikipedia.org/wiki/Logistic_function)。这一模式是一种普遍的人口增长模式，在这一模式中，生殖率与现有人口和现有资源的数量成正比，所有这些都是平等的。看起来是这样的：

Resources aren't infinite and our population is not going to grow forever. P-F Verhulst thought the same thing, so he presented the [logistic model](https://en.wikipedia.org/wiki/Logistic_function). This model is a common model of population growth, where the rate of reproduction is proportional to both the existing population and the amount of available resources, all else being equal. It looks like this:

*dx/dt = g\*x*(1-x/k)*

*x(0)=x_0*

其中常数 g 定义了生长速率, k 是承载容量。修改上述代码，我们可以及时模拟其行为：

where the constant g defines the growth rate and k is the carrying capacity. Modifying the above code we can simulate its behavior in time:

```Raku
use Math::Model;
 
my $m = Math::Model.new(
    derivatives => {
        velocity => 'x',
    },
    variables   => {
        velocity           => { $:growth_constant * $:x - $:growth_constant * $:x * $:x / $:k },
        growth_constant    => { 1 },   # basal growth rate 
        k                  => { 100 }, # carrying capacity 
    },
    initials    => {
        x       => 3,
    },
    captures    => ('x'),
);
 
$m.integrate(:from(0), :to(8), :min-resolution(0.5));
$m.render-svg('population growth logistic.svg', :title('population growth'));
```

让我们看看我们的很酷的图片：[图像链接](https://rawgit.com/thebooort/perl-6-math-model-tutorial/master/population%20growth%20logistic.svg)

Let's look at our cool plot: [link to the image](https://rawgit.com/thebooort/perl-6-math-model-tutorial/master/population%20growth%20logistic.svg)

因为你可以看到人口增长到最大。

As you can see population growths till a maximum.

## 强阿利效应 / Strong Allee Effect

有意思，不是吗？即使这些方程似乎是基本的，但它们与我们这个世界上的许多行为有关，比如肿瘤的生长。但是，在结束之前，让我给你看一个奇怪的案例。Logistic 模型可能是准确的但是如果从某一临界值来看，人口规模太小，以致于由于个人找不到其他人而使存活率和/或生殖率下降，会发生什么情况？

Interesting, isn't it? Even if these equations seem basic they are linked to a lot of behaviors in our world, like tumor growth. But, before end, let me show you a curious case. Logistic model could be accurate but... What happens when, from a certain threshold, the population size is so small that the survival rate and / or the reproductive rate drops due to the individual's inability to find other ones?

这是阿利描述的一个有趣的现象，通常被称为[阿利效应](https://en.wikipedia.org/wiki/Allee_effect)。要获得与这种效应相关的不同行为，一个简单的方法是使用 Logistic 模型作为出口，添加一些条件，并得到一个像这样的立方增长模型：

Well, this is an interesting phenomenon described by W.C.Allee, usually known as [Allee effect](https://en.wikipedia.org/wiki/Allee_effect). A simple way to obtain different behaviors associated with this effect is to use the logistic model as a departure, add some terms, and get a cubic growth model like this one:

*dx/dt=r\*x*(x/a-1)\*(1-x/k)*

其中所有常量都与以前相同，而 A 被称为*临界点*。

where all the constants are the same as before and A is called *critical point*.

我们的代码可以是：

Our code would be:

```Raku
use Math::Model;
 
my $m = Math::Model.new(
    derivatives => {
        velocity_x    => 'x',
    },
    variables   => {
        velocity_x           => { $:growth_constant * $:x *($:x/$:a -1)*(1- $:x/$:k) },
        growth_constant    => { 0.7 },   # basal growth rate 
        k                  => { 100 }, # carrying capacity 
        a                  => { 15 },  # critical point 
    },
    initials    => {
        x       => 15,
    },
    captures    => ('x'),
);
 
$m.integrate(:from(0), :to(100), :min-resolution(0.5));
$m.render-svg('population growth allee.svg', :title('population growth'));
```

试着自己执行这个命令，看看当你在临界点周围改变初始条件时会出现哪些不同的行为！

Try to execute this one yourself to see the different behaviors that arise when you change the initial condition around the critical point!

## 弱阿利效应 / Weak Allee Effect

强阿利效应是具有临界人口规模或密度的人口阿利效应，弱阿利效应是没有临界人口规模或密度的人口阿利效应，即当人口密度或人口规模较低时，表现出弱阿利效应的人口人均增长率将降低。然而，即使在人口数量或密度如此低的情况下，人口的人均增长率也始终是正的。这个模型与强模型略有不同，得到了一个新的公式：

Whilst the strong Allee effect is a demographic Allee effect with a critical population size or density, the weak Allee effect is a demographic Allee effect without a critical population size or density, i.e., a population exhibiting a weak Allee effect will possess a reduced per capita growth rate at lower population density or size. However, even at this low population size or density, the population will always exhibit a positive per capita growth rate. This model differs lightly from the strong one, getting a new formula:

*dx/dt=r\*x*(1-x/k)\*(x/a)**n*, with n>0

我们的代码可以是：

Our code would be:

```Raku
use Math::Model;
 
my $m = Math::Model.new(
    derivatives => {
        velocity_x => 'x',
    },
    variables   => {
        velocity_x           => { $:growth_constant * $:x *(1- $:x/$:k)*($:x/$:a)**$:n },
        growth_constant    => { 0.7 },   # basal growth rate 
        k                  => { 100 }, # carrying capacity 
        a                  => { 15 },  # critical point 
        n                  => { 4  }
    },
    initials    => {
        x       => 15,
    },
    captures    => ('x'),
);
 
$m.integrate(:from(0), :to(100), :min-resolution(0.5));
$m.render-svg('population growth allee.svg', :title('population growth'));
```

## 额外信息 / Extra info

你喜欢物理吗？查看刚才使用的模块的创建者 Moritz Lenz 的原始帖子: <https://perlgeek.de/blog-en/perl-6/physical-modelling.html>。

Do you like physics? Check the original post by the creator of the modules that have been used, Moritz Lenz: <https://perlgeek.de/blog-en/perl-6/physical-modelling.html>.
