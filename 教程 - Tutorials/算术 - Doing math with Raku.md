原文：https://docs.raku.org/language/math

# 使用 Raku 做数学 / Doing math with Raku

不同的数学范式及其在这种语言中的实现方式

Different mathematical paradigms and how they are implemented in this language

# 集合 / Sets

Raku 包含 [Set](https://docs.raku.org/type/Set) 数据类型，以及对[大多数集合运算符](https://docs.raku.org/language/setbagmix#Set/Bag_operators)的支持。[并集和交集](https://en.wikipedia.org/wiki/Algebra_of_sets)不仅仅是原生运算符，并且使用它们的*天然*符号、∩ 和 ∪。例如，该代码将检查有限数量的集合的集合算术的基本规律：

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

Raku 可以使用不同的数据类型进行算术。[Num](https://docs.raku.org/type/Num)、[Rat](https://docs.raku.org/type/Rat) 和 [Complex](https://docs.raku.org/type/Complex) 都可以作为[加法、减法、乘法和除法运算符的字段](https://en.wikipedia.org/wiki/Field_(mathematics))（从技术上讲，处理浮点数表示的数据类型由于其算术本身的不精确性而不是数学意义上的领域。然而，在大多数情况下，它们构成了这类数学对象的一个足够近似的、计算机友好的版本）。等价的数学领域是：

Raku can do arithmetic using different data types. [Num](https://docs.raku.org/type/Num), [Rat](https://docs.raku.org/type/Rat) and [Complex](https://docs.raku.org/type/Complex) can all operate as a [field under the operations of addition, subtraction, multiplication and division](https://en.wikipedia.org/wiki/Field_(mathematics)) (technically, it should be noted that data types dealing with floating point number representations are not a field in the mathematical sense due to the inherent imprecisions of their arithmetic. However, they constitute an approximate enough, computer friendly version of such mathematical objects for most of the cases). The equivalent mathematical fields are:

| Raku class | Field |
| ---------- | ----- |
| Rat        | ℚ     |
| Num        | ℝ     |
| Complex    | ℂ     |

The `Int`s or ℤ, as they're usually called in mathematics, are not a mathematical field but rather a ring, since they are not closed under multiplicative inverses. However, if the integer division `div` is used, their operations will always yield other integers; if `/` is used, on the other hand, in general the result will be a [Rat](https://docs.raku.org/type/Rat).

Besides, `Int` can do infinite-precision arithmetic (or at least infinite as memory allows; `Numeric overflow` can still occur), without falling back to [Num](https://docs.raku.org/type/Num) if the number is too big:

```Raku
my @powers = 2, 2 ** * ... Inf; say @powers[4].chars; # OUTPUT: «19729␤»
```

Also strictly speaking, the Rational class that behaves like a mathematical field is [FatRat](https://docs.raku.org/type/FatRat). For efficiency reasons, operating with `Rat`s will fall back to `Num` when the numbers are big enough or when there is a big difference between numerator and denominator. `FatRat` can work with arbitrary precision, the same as the default `Int` class.

Some modules in the ecosystem can work with additional data types mathematically:

- [`Math::Vector`](https://github.com/colomon/Math-Vector) basic operations for [vectors](https://en.wikipedia.org/wiki/Coordinate_vector).
- [`Math::Matrix`](https://github.com/pierre-vigier/Perl6-Math-Matrix) operates on [matrices rings over numeric rings](https://en.wikipedia.org/wiki/Matrix_(mathematics)).
- [`Math::Quaternion`](https://github.com/Util/Perl6-Math-Quaternion) operates on the [quaternion algebra, ℍ](https://en.wikipedia.org/wiki/Quaternion), which are a generalization of complex numbers.
- [`Math::Polynomial`](https://github.com/colomon/Math-Polynomial) works with polynomials, and is able to do simple arithmetic with them.
- [`Math::Symbolic`](https://github.com/raydiak/Math-Symbolic), for symbolic math.

Numbers are duck-typed automatically to the numeric class they actually represent:

```Raku
.^name.say for (4, ⅗, 1e-9, 3+.1i); # OUTPUT: «Int␤Rat␤Num␤Complex␤»
```

Arithmetic operations are performed by taking into account the type of operands:

```Raku
say .33-.22-.11 == 0; # OUTPUT: «True␤»
```

In this case, all numbers are interpreted as `Rat`s, which makes the operation exact. In general, most other languages would interpret them as floating point numbers, which can also be achieved in Raku if needed:

```Raku
say .33.Num -.22.Num - .11.Num; # OUTPUT: «1.3877787807814457e-17␤»
```

For cases such as this, Raku also includes an `approximately equal` operator, [≅](https://docs.raku.org/language/operators#infix_=~=)

```Raku
say .33.Num -.22.Num - .11.Num ≅ 0; # OUTPUT: «True␤»
```

# Sequences

A [sequence](https://en.wikipedia.org/wiki/Sequence) is an *enumerated* collection of objects in which repetitions are allowed, and also a first-class data type in Raku called [Seq](https://docs.raku.org/type/Seq). `Seq` is able to represent infinite sequences, like the natural numbers:

```Raku
my \𝕟 = 1,2 … ∞;
say 𝕟[3];         # OUTPUT: «4␤»
```

Infinite sequences use ∞, `Inf` or `*` (Whatever) as terminator. […](https://docs.raku.org/language/operators#infix_...) is the list generator, which in fact can understand arithmetic and geometric progression sequences as long as you insert the first numbers:

```Raku
say 1,5,9 … * > 100;
# OUTPUT: «(1 5 9 13 17 21 25 29 33 37 41 45 49 53 57 61 65 69 73 77 81 85 89 93 97 101)␤» 
say 1,3,9 … * > 337; # OUTPUT: «(1 3 9 27 81 243 729)␤»
```

The first sequence will be terminated when the generated number is bigger than 100; the second sequence, which is a geometric progression, when it is bigger than 337.

The fact that an arbitrary generator can be used makes easy to generate sequences such as [Fibonacci numbers](https://en.wikipedia.org/wiki/Fibonacci_number):

```Raku
say 1,1, * + * … * > 50;#  OUTPUT: «(1 1 2 3 5 8 13 21 34 55)␤»
```

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

The [Math::Sequences](https://github.com/ajs/perl6-Math-Sequences) module includes many mathematical sequences, already defined for you. It has many [sequences from the encyclopedia](https://oeis.org/), some of them with their original name, such as ℤ.

Some set operators also operate on sequences, and they can be used to find out if an object is part of it:

```Raku
say 876 ∈ (7,14 … * > 1000) ; # OUTPUT: «False␤»
```

In this particular case, we can find out if `876` is a multiple of 7 straight away, but the same principle holds for other sequences using complicated generators. And we can use set inclusion operators too:

```Raku
say (55,89).Set ⊂ (1,1, * + * … * > 200); # OUTPUT: «True␤»
```

That said, it does not take into account if it is effectively a subsequence, just the presence of the two elements here. Sets have no order, and even if you don't explicitly cast the subsequence into a Set or explicitly cast it into a `Seq` it will be coerced into such for the application of the inclusion operator.

# Mathematical constants

Raku includes a set of mathematical constants:

```Raku
say π; # OUTPUT: «3.141592653589793» 
say τ; # Equivalent to 2π; OUTPUT: «6.283185307179586» 
say 𝑒; # OUTPUT: «2.718281828459045␤»
```

These constants are also available through [ASCII equivalents](https://docs.raku.org/language/unicode_ascii): `e`, `pi` and `tau`.

The [Math::Constants](https://github.com/JJ/p6-math-constants/pulls) module includes an additional series of physical and mathematical constants such as the previously mentioned golden ratio φ or the Planck's constant ℎ.

Since Raku allows for definition of variables that use Unicode graphemes, and also variable and constant names without any kind of sigil, it is considered a good practice to use the actual mathematical name of concepts to denominate them wherever possible.

# Numerical integration of ordinary differential equations

Raku is an amazing programming language, and of course, you can do a lot of cool math with it. A great amount of work during an applied mathematician's work is to simulate the models they create. For this reason, in every coding language, a numerical integrator is a must-have. Learning how to do this in Raku can be very useful.

## Requirements

In Raku there are some modules in the ecosystem that can make it easier:

- [`Math::Model`](https://github.com/moritz/Math-Model) which lets you write mathematical and physical models in an easy and natural way.
- [`Math::RungeKutta`](https://github.com/moritz/Math-RungeKutta) Runge-Kutta integration for systems of ordinary, linear differential equations.

For this example we are going to use [`Math::Model`](https://github.com/moritz/Math-Model) for its useful syntax, but remember that this module requires [`Math::RungeKutta`](https://github.com/moritz/Math-RungeKutta) as well. Simply install them with *zef* before using these examples.

## Malthus model

Let's start with the *'Hello World'* of mathematical Ecology: [Malthusian growth model](https://en.wikipedia.org/wiki/Malthusian_growth_model). A Malthusian growth model, sometimes called a simple exponential growth model, is essentially exponential growth based on the idea of the function being proportional to the speed to which the function grows. The equation, then, looks like this:

*dx/dt = g\*x*

*x(0) = x_0*

Where *g* is the population growth rate, sometimes called Malthusian parameter.

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

To fully understand what is going on, let's go through it step by step.

### Step by step explanation

- First we load the module that make the calculations: [`Math::Model`](https://github.com/moritz/Math-Model).

  ```
  use Math::Model;
  ```

- We create the model to add all the information in it.

  ```
  my $m = Math::Model.new(
  ```

- We declare the derivatives that are in our model. In this case, if you remember our equation, we have our variable *x* and its derivative *x'* (usually know as the velocity).

  ```
  derivatives => {
      velocity => 'x',
  },
  ```

- After that, we declare how our models evolve. We just need formulas for the derivatives that are not also integration variables (in this case, only *x*), and for other variables we use in the formulas (the growth rate).

  ```
  variables   => {
      velocity           => { $:growth_constant * $:x},
      growth_constant    => { 1 }, # basal growth rate 
  },
  ```

- Finally we declare our initial conditions and use *captures* to tell [`Math::Model`](https://github.com/moritz/Math-Model) which variable or variables to record while the simulation is running.

  ```
  initials    => {
      x       => 3,
  },
  captures    => ('x'),
  ```

At this point our model is set. We need to run the simulation and render a cool plot about our results:

```Raku
$m.integrate(:from(0), :to(8), :min-resolution(0.5));
$m.render-svg('population growth malthus.svg', :title('population growth'));
```

There, we select our time limits and the resolution. Next, we generate a plot. All understood? Well, let's see our result!

[link to the image](https://rawgit.com/thebooort/perl-6-math-model-tutorial/master/population%20growth%20malthus.svg)

Looks great! But to be honest, it is quite unrepresentative. Let's explore other examples from more complex situations!

## Logistic model

Resources aren't infinite and our population is not going to grow forever. P-F Verhulst thought the same thing, so he presented the [logistic model](https://en.wikipedia.org/wiki/Logistic_function). This model is a common model of population growth, where the rate of reproduction is proportional to both the existing population and the amount of available resources, all else being equal. It looks like this:

*dx/dt = g\*x*(1-x/k)*

*x(0)=x_0*

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

Let's look at our cool plot: [link to the image](https://rawgit.com/thebooort/perl-6-math-model-tutorial/master/population%20growth%20logistic.svg)

As you can see population growths till a maximum.

## Strong Allee Effect

Interesting, isn't it? Even if these equations seem basic they are linked to a lot of behaviors in our world, like tumor growth. But, before end, let me show you a curious case. Logistic model could be accurate but... What happens when, from a certain threshold, the population size is so small that the survival rate and / or the reproductive rate drops due to the individual's inability to find other ones?

Well, this is an interesting phenomenon described by W.C.Allee, usually known as [Allee effect](https://en.wikipedia.org/wiki/Allee_effect). A simple way to obtain different behaviors associated with this effect is to use the logistic model as a departure, add some terms, and get a cubic growth model like this one:

*dx/dt=r\*x*(x/a-1)\*(1-x/k)*

where all the constants are the same as before and A is called *critical point*.

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

Try to execute this one yourself to see the different behaviors that arise when you change the initial condition around the critical point!

## Weak Allee Effect

Whilst the strong Allee effect is a demographic Allee effect with a critical population size or density, the weak Allee effect is a demographic Allee effect without a critical population size or density, i.e., a population exhibiting a weak Allee effect will possess a reduced per capita growth rate at lower population density or size. However, even at this low population size or density, the population will always exhibit a positive per capita growth rate. This model differs lightly from the strong one, getting a new formula:

*dx/dt=r\*x*(1-x/k)\*(x/a)**n*, with n>0

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

## Extra info

Do you like physics? Check the original post by the creator of the modules that have been used, Moritz Lenz: <https://perlgeek.de/blog-en/perl-6/physical-modelling.html>.
