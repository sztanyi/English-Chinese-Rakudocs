原文：https://docs.raku.org/language/traps

# 避坑指南 / Traps to avoid

开始使用 Raku 时要避免的陷阱

Traps to avoid when getting started with Raku

当学习一种编程语言时，可能是在熟悉另一种编程语言的背景下，总会有一些事情会给你带来惊喜，并可能在调试和发现方面花费宝贵的时间。

When learning a programming language, possibly with the background of being familiar with another programming language, there are always some things that can surprise you and might cost valuable time in debugging and discovery.

本文件旨在展示常见的误解，以避免他们。

This document aims to show common misconceptions in order to avoid them.

在 Raku 的制作过程中，我们付出了很大的努力来消除语法上的缺陷。但是，当你击打一个缺陷时，有时会弹出另一个缺陷。因此，我们花了很多时间去寻找最少数量的缺陷，或者试图把它们放置在很少被发现的地方。正因为如此，Raku 的缺陷可能出现在意想不到的不同地方，当用户从另一种语言那过来时。

During the making of Raku great pains were taken to get rid of warts in the syntax. When you whack one wart, though, sometimes another pops up. So a lot of time was spent finding the minimum number of warts or trying to put them where they would rarely be seen. Because of this, Raku's warts are in different places than you may expect them to be when coming from another language.

# 变量和常量 / Variables and constants

## 常量在编译时计算 / Constants are computed at compile time

常量是在编译时计算的，因此，如果在模组中使用常量，请记住，由于预编译模块本身，它们的值将被冻结：

Constants are computed at compile time, so if you use them in modules keep in mind that their values will be frozen due to precompilation of the module itself:

```Raku
# WRONG (most likely): 
unit module Something::Or::Other;
constant $config-file = "config.txt".IO.slurp;
```

在预编译过程中，`$config-file` 将被删除，当您再次启动脚本时，对 `config.txt` 文件的更改不会被重新加载；只有当模块被重新编译时，才会重新加载文件。

The `$config-file` will be slurped during precompilation and changes to `config.txt` file won't be re-loaded when you start the script again; only when the module is re-compiled.

避免[使用容器](https://docs.raku.org/language/containers)，而更偏向[绑定一个值](https://docs.raku.org/language/containers#Binding)至变量，该变量提供类似于常量的行为，但允许更新该值：

Avoid [using a container](https://docs.raku.org/language/containers) and prefer [binding a value](https://docs.raku.org/language/containers#Binding) to a variable that offers a behavior similar to a constant, but allowing the value to get updated:

```Raku
# Good; file gets updated from 'config.txt' file on each script run: 
unit module Something::Or::Other;
my $config-file := "config.txt".IO.slurp;
```

## 分配给 `Nil` 会产生一个不同的值，通常为 `Any` / Assigning to `Nil` produces a different value, usually `Any`

实际上，赋值 `Nil` [将变量恢复为其默认值](https://docs.raku.org/type/Nil)。所以：

Actually, assigning to `Nil` [reverts the variable to its default value](https://docs.raku.org/type/Nil). So:

```Raku
my @a = 4, 8, 15, 16;
@a[2] = Nil;
say @a; # OUTPUT: «[4 8 (Any) 16]␤» 
```

在这种情况下，`Any` 是 `Array` 元素的默认值。

In this case, `Any` is the default value of an `Array` element.

您可以有意地将 `Nil` 赋值为默认值：

You can purposefully assign `Nil` as a default value:

```Raku
my %h is default(Nil) = a => Nil;
say %h; # OUTPUT: «Hash %h = {:a(Nil)}␤» 
```

或者将一个值绑定到 `Nil`，如果这是您想要的结果：

Or bind a value to `Nil` if that is the result you want:

```Raku
@a[3] := Nil;
say @a; # OUTPUT: «[4 8 (Any) Nil]␤» 
```

这个陷阱可能隐藏在函数的结果中，例如匹配：

This trap might be hidden in the result of functions, such as matches:

```Raku
my $result2 = 'abcdef' ~~ / dex /;
say "Result2 is { $result2.^name }"; # OUTPUT: «Result2 is Any␤» 
```

如果没有发现任何结果，则 [`Match` 将是 `Nil`](https://docs.raku.org/language/regexes#Literals)；但是，将 `Nil` 赋值给 `$result2` 将导致其值为默认值，即 `Any`。

A [`Match` will be `Nil`](https://docs.raku.org/language/regexes#Literals) if it finds nothing; however assigning `Nil` to `$result2` above will result in its default value, which is `Any` as shown.

## 使用代码块插值一个匿名状态变量 / Using a block to interpolate anon state vars

程序员打算让代码计算调用例程的次数，但是计数器没有增加：

The programmer intended for the code to count the number of times the routine is called, but the counter is not increasing:

```Raku
sub count-it { say "Count is {$++}" }
count-it;
count-it;

# OUTPUT:
# Count is 0
# Count is 0
```

当涉及状态变量时，每当重新进入代码块中的代码块时，就会克隆声明变量的块，并重新初始化变量。这允许像下面这样的构造行为；每次调用子例程时，循环中的状态变量都会重新初始化：

When it comes to state variables, the block in which the vars are declared gets cloned —and vars get initialized anew— whenever that block's block is re-entered. This lets constructs like the one below behave appropriately; the state variable inside the loop gets initialized anew each time the sub is called:

```Raku
sub count-it {
    for ^3 {
        state $count = 0;
        say "Count is $count";
        $count++;
    }
}

count-it;
say "…and again…";
count-it;


# OUTPUT: 
# Count is 0
# Count is 1
# Count is 2
# …and again…
# Count is 0
# Count is 1
# Count is 2
```

同样的布局存在于我们的有缺陷的程序中。双引号字符串中的 `{ }` 不仅仅是执行一段代码的插值。它实际上是它自己的块，就像上面的例子一样，每次输入子时都会被克隆，重新初始化我们的状态变量。为了得到正确的计数，我们需要去掉这个内部块，使用标量上下文化器来插值我们的代码：

The same layout exists in our buggy program. The `{ }` inside a double-quoted string isn't merely an interpolation to execute a piece of code. It's actually its own block, which is just as in the example above gets cloned each time the sub is entered, re-initializing our state variable. To get the right count, we need to get rid of that inner block, using a scalar contextualizer to interpolate our piece of code instead:

```Raku
sub count-it { say "Count is $($++)" }
count-it;
count-it;
 
# OUTPUT: 
# Count is 0 
# Count is 1 
```

或者，你也可以使用[连接运算符](https://docs.raku.org/routine/~)，而不是：

Alternatively, you can also use the [concatenation operator](https://docs.raku.org/routine/~) instead:

```Raku
sub count-it { say "Count is " ~ $++ }
```

## 当值为假时，在 `Associative` 上使用集合子例程 / Using set subroutines on `Associative` when the value is falsy

对实现了 [Associative](https://docs.raku.org/type/Associative) 的类使用 [(cont)](https://docs.raku.org/routine/(cont)%20,%20infix%20%20%E2%88%8B)、 [∋](https://docs.raku.org/routine/(cont),%20infix%20%E2%88%8B)、 [∌](https://docs.raku.org/routine/%E2%88%8C)、 [(elem)](https://docs.raku.org/routine/(elem),%20infix%20%E2%88%88)、 [∈](https://docs.raku.org/routine/(elem),%20infix%20%E2%88%88) 或者 [∉](https://docs.raku.org/routine/%E2%88%89) 将返回 `False` 如果键的值为假。

Using [(cont)](https://docs.raku.org/routine/(cont)%20,%20infix%20%20%E2%88%8B), [∋](https://docs.raku.org/routine/(cont),%20infix%20%E2%88%8B), [∌](https://docs.raku.org/routine/%E2%88%8C), [(elem)](https://docs.raku.org/routine/(elem),%20infix%20%E2%88%88), [∈](https://docs.raku.org/routine/(elem),%20infix%20%E2%88%88), or [∉](https://docs.raku.org/routine/%E2%88%89) on classes implementing [Associative](https://docs.raku.org/type/Associative) will return `False` if the value of the key is falsy:

```Raku
enum Foo «a b»;
say Foo.enums ∋ 'a';

# OUTPUT:
# False
```

使用 `:exists` 时：

Instead, use `:exists`:

```Raku
enum Foo «a b»;
say Foo.enums<a>:exists;

# OUTPUT:
# True
```

# 代码块 / Blocks

## 小心空“代码块” / Beware of empty "blocks"

花括号用于声明块。但是，空大括号将声明散列。

Curly braces are used to declare blocks. However, empty curly braces will declare a hash.

```Raku
$ = {say 42;} # Block 
$ = {;}       # Block 
$ = {…}       # Block 
$ = { }       # Hash 
```

如果您有效地想要声明空的块，则可以使用第二种形式：

You can use the second form if you effectively want to declare an empty block:

```Raku
my &does-nothing = {;};
say does-nothing(33); # OUTPUT: «Nil␤»
```

# 对象 / Objects

## 赋值给属性 / Assigning to attributes

新手通常认为，因为具有访问器的属性被声明为 `has $.x`，所以它们可以赋值给类内部的 `$.x`。不是这样。

Newcomers often think that, because attributes with accessors are declared as `has $.x`, they can assign to `$.x` inside the class. That's not the case.

例如

For example

```Raku
class Point {
    has $.x;
    has $.y;
    method double {
        $.x *= 2;   # WRONG 
        $.y *= 2;   # WRONG 
        self;
    }
}
 
say Point.new(x => 1, y => -2).double.x
# OUTPUT: «Cannot assign to an immutable value␤» 
```

方法 `double` 中的第一行被标记为 `# WRONG`，因为 `$.x` 是 `$( self.x )` 的缩写，它是对只读访问器的调用。

the first line inside the method `double` is marked with `# WRONG` because `$.x`, short for `$( self.x )`, is a call to a read-only accessor.

语法 `has $.x` 是类似于 `has $!x; method x() { $!x }` 的缩写，因此实际的属性称为 `$!x`，并且自动生成只读访问器方法。

The syntax `has $.x` is short for something like `has $!x; method x() { $!x }`, so the actual attribute is called `$!x`, and a read-only accessor method is automatically generated.

因此，编写 `double` 方法的正确方法是

Thus the correct way to write the method `double` is

```Raku
method double {
    $!x *= 2;
    $!y *= 2;
    self;
}
```

直接对属性进行操作。

which operates on the attributes directly.

## `BUILD` 防止构造函数参数的自动属性初始化 / `BUILD` prevents automatic attribute initialization from constructor arguments

定义自己的 `BUILD` 子方法时，必须自己初始化所有属性。例如

When you define your own `BUILD` submethod, you must take care of initializing all attributes by yourself. For example

```Raku
class A {
    has $.x;
    has $.y;
    submethod BUILD {
        $!y = 18;
    }
}
 
say A.new(x => 42).x;       # OUTPUT: «Any␤» 
```

`$!x` 未初始化，因为自定义 `BUILD` 没有初始化它。

leaves `$!x` uninitialized, because the custom `BUILD` doesn't initialize it.

**注意：**考虑使用 [TWEAK](https://docs.raku.org/language/objects#index-entry-TWEAK) 代替。自 2016.11 版以来，[Rakudo](https://docs.raku.org/language/glossary#Rakudo) 支持 [TWEAK](https://docs.raku.org/language/objects#index-entry-TWEAK) 方法。

**Note:** Consider using [TWEAK](https://docs.raku.org/language/objects#index-entry-TWEAK) instead. [Rakudo](https://docs.raku.org/language/glossary#Rakudo) supports [TWEAK](https://docs.raku.org/language/objects#index-entry-TWEAK) method since release 2016.11.

一个可能的补救办法是在 `BUILD` 中显式初始化属性：

One possible remedy is to explicitly initialize the attribute in `BUILD`:

```Raku
submethod BUILD(:$x) {
    $!y = 18;
    $!x := $x;
}
```

可缩短为：

which can be shortened to:

```Raku
submethod BUILD(:$!x) {
    $!y = 18;
}
```

# 空格 / Whitespace

## 正则表达式中的空格不匹配 / Whitespace in regexes does not match literally

```Raku
say 'a b' ~~ /a b/; # OUTPUT: «False␤» 
```

默认情况下，正则中的空格被认为是没有语义的可选填充，就像 Raku 语言的其他部分一样。

Whitespace in regexes is, by default, considered an optional filler without semantics, just like in the rest of the Raku language.

匹配空格的方法：

Ways to match whitespace:

- `\s` 匹配任意一个空格，`\s` 匹配至少一个空格
- `' '`（引号中的空格）匹配单一空格
- `\t`, `\n` 匹配特定的空额（制表符、换行符）
- `\h`, `\v` 匹配垂直、水平空格
- `.ws`，这是一个内置的匹配空格 rule，它经常做你想要它做的事情。
- 使用 `m:s/a b/` 或者 `m:sigspace/a b/`， 正则中的空白匹配任意空格

- `\s` to match any one whitespace, `\s+` to match at least one
- `' '` (a blank in quotes) to match a single blank
- `\t`, `\n` for specific whitespace (tab, newline)
- `\h`, `\v` for horizontal, vertical whitespace
- `.ws`, a built-in rule for whitespace that oftentimes does what you actually want it to do
- with `m:s/a b/` or `m:sigspace/a b/`, the blank in the regexes matches arbitrary whitespace

## 句法分析中的歧义 / Ambiguities in parsing

虽然有些语言可以让您尽可能地移除标记之间的空白，但 Raku 就不那么宽容了。最重要的口号是我们不鼓励代码高尔夫，所以不要限制空格（这些限制背后更严重的根本原因是单程解析和解析 Raku 程序的能力，而实际上没有[回溯](https://en.wikipedia.org/wiki/Backtracking)）。

While some languages will let you get away with removing as much whitespace between tokens as possible, Raku is less forgiving. The overarching mantra is we discourage code golf, so don't scrimp on whitespace (the more serious underlying reason behind these restrictions is single-pass parsing and ability to parse Raku programs with virtually no [backtracking](https://en.wikipedia.org/wiki/Backtracking)).

你应该注意的共同领域是：

The common areas you should watch out for are:

### 代码块与哈希切片模糊度 / Block vs. Hash slice ambiguity

```Raku
# 错误；试图哈希切片一个布尔值
# WRONG; trying to hash-slice a Bool: 
while ($++ > 5){ .say }
# RIGHT: 
while ($++ > 5) { .say }

# EVEN BETTER; Raku does not require parentheses there: 
while $++ > 5 { .say }
```

### 约简与数组构造函数歧义 / Reduction vs. Array constructor ambiguity

```Raku
# 错误；`[<]` 元运算符歧义
# WRONG; ambiguity with `[<]` metaop: 
my @a = [[<foo>],];
# 正确；约简中不能有空格，所以在里面放置一个：
# RIGHT; reductions cannot have spaces in them, so put one in: 
my @a = [[ <foo>],];

# 这里没有歧义，项目之间的自然空间足以解决这一问题：
# No ambiguity here, natural spaces between items suffice to resolve it: 
my @a = [[<foo bar ber>],];
```

### 少于运算符与词引文/关联数组索引 - Less than vs. Word quoting/Associative indexing

```Raku
# 错误；试图用索引关联数组的方式求 3 的索引
# WRONG; trying to index 3 associatively: 
say 3<5>4
# 正确；在中缀运算符周围添加一些额外的空格：
# RIGHT; prefer some extra whitespace around infix operators: 
say 3 < 5 > 4
```

### 排他序列与范围序列 / Exclusive sequences vs. sequences with Ranges

有关 `...^` 运算符如何会被误认为是 `...` 运算符后紧跟 `^` 运算符的更多信息，请参见[运算符陷阱](https://docs.raku.org/language/traps#Exclusive_sequence_operator)一节。您必须正确地使用空格来指示后续的解释执行。

See the section on [operator traps](https://docs.raku.org/language/traps#Exclusive_sequence_operator) for more information about how the `...^` operator can be mistaken for the `...` operator with a `^` operator immediately following it. You must use whitespace correctly to indicate which interpretation will be followed.

# Captures

## 容器与 capture 中的值相对应的值 / Containers versus values in a capture

初学者可能期望 `Capture` 中的一个变量在以后使用 `Capture` 时提供它的当前值。例如：

Beginners might expect a variable in a `Capture` to supply its current value when that `Capture` is later used. For example:

```Raku
my $a = 2; say join ",", ($a, ++$a);  # OUTPUT: «3,3␤» 
```

在这里，`Capture` 包含由 `$a` 和表达式 `++$a` 的结果的**值**指向的**容器**。因为 `Capture` 必须在 `&say` 能使用它之前具体化，`++$a` 可能发生在 `&say` 查看 `$a` 中的容器（并且在 `List` 被创建之前）之前，因此它可能已经增加了。

Here the `Capture` contained the **container** pointed to by `$a` and the **value** of the result of the expression `++$a`. Since the `Capture` must be reified before `&say` can use it, the `++$a` may happen before `&say` looks inside the container in `$a` (and before the `List` is created with the two terms) and so it may already be incremented.

相反，当您想要一个值时，使用一个产生一个值的表达式。

Instead, use an expression that produces a value when you want a value.

```Raku
my $a = 2; say join ",", (+$a, ++$a); # OUTPUT: «2,3␤» 
```

甚至更简单

Or even simpler

```Raku
my $a = 2; say  "$a, {++$a}"; # OUTPUT: «2, 3␤» 
```

同样的情况也发生在这种情况下：

The same happens in this case:

```Raku
my @arr;
my ($a, $b) = (1,1);
for ^5 {
    ($a,$b) = ($b, $a+$b);
    @arr.push: ($a, $b);
    say @arr
};
```

输出 `«[(1 2)]␤[(2 3) (2 3)]␤[(3 5) (3 5) (3 5)]␤...`。`$a` 和 `$b` 直到 `say` 被调用才被具体化，它们在那个精确时刻所具有的价值是印刷出来的。为了避免这种情况，在使用之前，用某种方式解除值的容器或将它们从变量中取出。

Outputs `«[(1 2)]␤[(2 3) (2 3)]␤[(3 5) (3 5) (3 5)]␤...`. `$a` and `$b` are not reified until `say` is called, the value that they have in that precise moment is the one printed. To avoid that, decontainerize values or take them out of the variable in some way before using them.

```Raku
my @arr;
my ($a, $b) = (1,1);
for ^5 {
    ($a,$b) = ($b, $a+$b);
    @arr.push: ($a.item, $b.item);
    say @arr
};
```

使用 [item](https://docs.raku.org/routine/item)，容器将在项目上下文中进行求值，提取其值，并获得预期的结果。

With [item](https://docs.raku.org/routine/item), the container will be evaluated in item context, its value extracted, and the desired outcome achieved.

# `Cool` 技巧 / `Cool` tricks

Raku 包含一个 [Cool](https://docs.raku.org/type/Cool) 类，它提供了一些我们在必要时通过强制参数来习惯的 DWIM 行为。然而，DWIM 从来都不是完美的。特别是在 [List](https://docs.raku.org/type/List)，即 `Cool`，有许多方法不可能完成您可能认为它们所做的工作，包括 `contains`、`starts-with` 或 `index`。请参阅下面一节中的一些例子。

Raku includes a [Cool](https://docs.raku.org/type/Cool) class, which provides some of the DWIM behaviors we got used to by coercing arguments when necessary. However, DWIM is never perfect. Especially with [List](https://docs.raku.org/type/List)s, which are `Cool`, there are many methods that will not do what you probably think they do, including `contains`, `starts-with` or `index`. Please see some examples in the section below.

## 字符串不是“列表”，当心索引 / Strings are not `List`s, so beware indexing

在 Raku 中，[字符串](https://docs.raku.org/type/Str)不是字符列表。不能像处理列表一样[遍历](https://docs.raku.org/language/traps#Strings_are_not_iterable)，尽管有名为 [.index 的子例程](https://docs.raku.org/type/Str#routine_index)。

In Raku, [strings](https://docs.raku.org/type/Str) are not lists of characters. One [cannot iterate](https://docs.raku.org/language/traps#Strings_are_not_iterable) over them or index into them as you can with [lists](https://docs.raku.org/type/List), despite the name of the [.index routine](https://docs.raku.org/type/Str#routine_index).

## `List` 变成字符串，所以 `.index()` 时小心 / `List`s become strings, so beware `.index()`ing

[list](https://docs.raku.org/type/List) 继承自 [Cool](https://docs.raku.org/type/Cool)，能使用 [.index](https://docs.raku.org/type/Str#routine_index) 子例程。由于 `.index` [强制转换](https://docs.raku.org/type/List#method_Str)数组类型至 [Str](https://docs.raku.org/type/Str)，这个有时返回列表元素的索引，但行为不是这样定义的。

[List](https://docs.raku.org/type/List) inherits from [Cool](https://docs.raku.org/type/Cool), which provides access to [.index](https://docs.raku.org/type/Str#routine_index). Because of the way `.index` [coerces](https://docs.raku.org/type/List#method_Str) a `List` into a [Str](https://docs.raku.org/type/Str), this can sometimes appear to be returning the index of an element in the list, but that is not how the behavior is defined.

```Raku
my @a = <a b c d>;
say @a.index(‘a’);    # 0 
say @a.index('c');    # 4 -- not 2! 
say @a.index('b c');  # 2 -- not undefined! 
say @a.index(<a b>);  # 0 -- not undefined! 
```

这些警告同样的也适用于 [.rindex](https://docs.raku.org/type/Str#routine_rindex).

These same caveats apply to [.rindex](https://docs.raku.org/type/Str#routine_rindex).

## 列表变为字符串，当心 `.contains()` / `List`s become strings, so beware `.contains()`

同样的，[.contains](https://docs.raku.org/type/List#(Cool)_method_contains) 方法不会查找列表里面的元素。

Similarly, [.contains](https://docs.raku.org/type/List#(Cool)_method_contains) does not look for elements in the list.

```Raku
my @menu = <hamburger fries milkshake>;
say @menu.contains('hamburger');            # True 
say @menu.contains('hot dog');              # False 
say @menu.contains('milk');                 # True! 
say @menu.contains('er fr');                # True! 
say @menu.contains(<es mi>);                # True! 
```

如果您实际上想检查是否存在一个元素，那么对单个元素使用 [(cont)](https://docs.raku.org/routine/(elem),%20infix%20%E2%88%88) 运算符，对多个元素使用 [superset](https://docs.raku.org/language/operators#infix_(%3E=),_infix_%E2%8A%87) 和 [strict superset](https://docs.raku.org/language/operators#infix_(%3E),_infix_%E2%8A%83) 运算符。

If you actually want to check for the presence of an element, use the [(cont)](https://docs.raku.org/routine/(elem),%20infix%20%E2%88%88) operator for single elements, and the [superset](https://docs.raku.org/language/operators#infix_(%3E=),_infix_%E2%8A%87) and [strict superset](https://docs.raku.org/language/operators#infix_(%3E),_infix_%E2%8A%83) operators for multiple elements.

```Raku
my @menu = <hamburger fries milkshake>;
say @menu (cont) 'fries';                   # True 
say @menu (cont) 'milk';                    # False 
say @menu (>) <hamburger fries>;            # True 
say @menu (>) <milkshake fries>;            # True (! NB: order doesn't matter) 
```

如果您正在进行大量元素测试，则可以使用 [Set](https://docs.raku.org/type/Set) 更安逸。

If you are doing a lot of element testing, you may be better off using a [Set](https://docs.raku.org/type/Set).

## `Numeric` 字面量在强制类型转换前被解析 / `Numeric` literals are parsed before coercion

经验丰富的程序员可能不会对此感到惊讶，但数字文字在被强制放入字符串之前将被解析为数字值，这可能会产生非直观的结果。

Experienced programmers will probably not be surprised by this, but Numeric literals will be parsed into their numeric value before being coerced into a string, which may create nonintuitive results.

```Raku
say 0xff.contains(55);      # True 
say 0xff.contains(0xf);     # False 
say 12_345.contains("23");  # True 
say 12_345.contains("2_");  # False 
```

## 从列表中获取一个随机项 / Getting a random item from a `List`

一个常见的任务是从一个集合中检索一个或多个随机元素，但 `List.rand` 做不到。[Cool](https://docs.raku.org/type/Cool) 提供了 [rand](https://docs.raku.org/routine/rand#class_Cool)，但它首先将 `List` 转换为列表中的项目数，并返回 0 到该值之间的随机实数。要获得随机元素，请参见 [pick](https://docs.raku.org/routine/pick) 和 [roll](https://docs.raku.org/routine/roll)。

A common task is to retrieve one or more random elements from a collection, but `List.rand` isn't the way to do that. [Cool](https://docs.raku.org/type/Cool) provides [rand](https://docs.raku.org/routine/rand#class_Cool), but that first coerces the `List` into the number of items in the list, and returns a random real number between 0 and that value. To get random elements, see [pick](https://docs.raku.org/routine/pick) and [roll](https://docs.raku.org/routine/roll).

```Raku
my @colors = <red orange yellow green blue indigo violet>;
say @colors.rand;       # 2.21921955680514 
say @colors.pick;       # orange 
say @colors.roll;       # blue 
say @colors.pick(2);    # yellow violet  (cannot repeat) 
say @colors.roll(3);    # red green red  (can repeat) 
```

## 列表中数字上下文中元素的个数 / `List`s numify to their number of elements in numeric context

您要检查一个数字是否可被一组数字中的任何一个整除：

You want to check whether a number is divisible by any of a set of numbers:

```Raku
say 42 %% <11 33 88 55 111 20325>; # OUTPUT: «True␤»
```

什么？没有一个数字可整除 42。然而，这个列表有 6 个元素，42 可以被 6 整除，这就是为什么输出是真的。在这种情况下，您应该将列表转换为 [Junction](https://docs.raku.org/type/Junction)：

What? There's no single number 42 should be divisible by. However, that list has 6 elements, and 42 is divisible by 6. That's why the output is true. In this case, you should turn the `List` into a [Junction](https://docs.raku.org/type/Junction):

```Raku
say 42 %% <11 33 88 55 111 20325>.any;
# OUTPUT: «any(False, False, False, False, False, False)␤» 
```

这将清楚地揭示列表中所有数字的可否整除 42 的真假值。

which will clearly reveal the falsehood of the divisiveness of all the numbers in the list, which will be numified separately.

# 数组 / Arrays

## 引用数组中的最后一个元素 / Referencing the last element of an array

在某些语言中，可以通过请求阵列的 "-1th" 元素来引用数组的最后一个元素，例如：

In some languages one could reference the last element of an array by asking for the "-1th" element of the array, e.g.:

```Perl
my @array = qw{victor alice bob charlie eve};
say @array[-1];    # OUTPUT: «eve␤» 
```

在 Raku 中，不能使用负的下标，然而，实际上可以使用函数，即 `*-1` 来实现相同的下标。因此，访问阵列的最后一个元素变为：

In Raku it is not possible to use negative subscripts, however the same is achieved by actually using a function, namely `*-1`. Thus, accessing the last element of an array becomes:

```Raku
my @array = qw{victor alice bob charlie eve};
say @array[*-1];   # OUTPUT: «eve␤» 
```

另一种方法是利用数组的 `tail` 方法：

Yet another way is to utilize the array's tail method:

```Raku
my @array = qw{victor alice bob charlie eve};
say @array.tail;      # OUTPUT: «eve␤» 
say @array.tail(2);   # OUTPUT: «(charlie eve)␤» 
```

## 类型化数组参数 / Typed array parameters

很常见的是，新用户可能会这样写：

Quite often new users will happen to write something like:

```Raku
sub foo(Array @a) { ... }
```

在文档中得到足够多的信息之前，他们会意识到这是在要求数组的数组。要 `@a` 只接受数组，请使用：

...before they have gotten far enough in the documentation to realize that this is asking for an Array of Arrays. To say that `@a` should only accept Arrays, use instead:

```Raku
sub foo(@a where Array) { ... }
```

同样常见的是，期望它能起作用，但实际没有：

It is also common to expect this to work, when it does not:

```Raku
sub bar(Int @a) { 42.say };
bar([1, 2, 3]);             # expected Positional[Int] but got Array 
```

这里的问题是，[1, 2, 3] 不是一个 `Array[Int]`，它是一个普通的数组，恰好里面有 Int。为了使其工作，该参数也必须是 `Array[Int]`。

The problem here is that [1, 2, 3] is not an `Array[Int]`, it is a plain old Array that just happens to have Ints in it. To get it to work, the argument must also be an `Array[Int]`.

```Raku
my Int @b = 1, 2, 3;
bar(@b);                    # OUTPUT: «42␤» 
bar(Array[Int].new(1, 2, 3));
```

这似乎是不方便的，但是好处是它将类型检查从将什么赋值给 `@b` 移到了赋值发生的位置，而不是要求在每次调用上检查每个元素。

This may seem inconvenient, but on the upside it moves the type-check on what is assigned to `@b` to where the assignment happens, rather than requiring every element to be checked on every call.

## 在不需要时使用 `«»` 引用 / Using `«»` quoting when you don't need it

这个陷阱可以从不同的变种中看到。以下是其中一些：

This trap can be seen in different varieties. Here are some of them:

```Raku
my $x = ‘hello’;
my $y = ‘foo bar’;
 
my %h = $x => 42, $y => 99;
say %h«$x»;   # ← WRONG; assumption that $x has no whitespace 
say %h«$y»;   # ← WRONG; splits ‘foo bar’ by whitespace 
say %h«"$y"»; # ← KINDA OK; it works but there is no good reason to do that 
say %h{$y};   # ← RIGHT; this is what should be used 
 
run «touch $x»;        # ← WRONG; assumption that only one file will be created 
run «touch $y»;        # ← WRONG; will touch file ‘foo’ and ‘bar’ 
run «touch "$y"»;      # ← WRONG; better, but has a different issue if $y starts with - 
run «touch -- "$y"»;   # ← KINDA OK; it works but there is no good enough reason to do that 
run ‘touch’, ‘--’, $y; # ← RIGHT; explicit and *always* correct 
run <touch -->, $y;    # ← RIGHT; < > are OK, this is short and correct 
```

基本上，`«»` 引用只有在你记得*始终*用引号括起来你的变量时才是安全的。问题是，它将默认行为转换为不安全的变体，因此，只要忘记一些引号，你就有可能引入一个错误，甚至是一个安全漏洞。为了安全起见，不要使用 `«»`。

Basically, `«»` quoting is only safe to use if you remember to *always* quote your variables. The problem is that it inverts the default behavior to unsafe variant, so just by forgetting some quotes you are risking to introduce either a bug or maybe even a security hole. To stay on the safe side, refrain from using `«»`.

# 字符串 / Strings

处理[字符串](https://docs.raku.org/type/Str)时可能出现的一些问题

Some problems that might arise when dealing with [strings](https://docs.raku.org/type/Str).

## 引用和插值 / Quotes and interpolation

字符串字面量的插值对于你自己来说可能太聪明了。

Interpolation in string literals can be too clever for your own good.

```Raku
# "HTML tags" interpreted as associative indexing: 
"$foo<html></html>" eq
"$foo{'html'}{'/html'}"
# Parentheses interpreted as call with argument: 
"$foo(" ~ @args ~ ")" eq
"$foo(' ~ @args ~ ')"
```

您可以使用非插值单引号和使用 `\qq[]` 转义序列切换到更自由的插值操作来避免这些问题：

You can avoid those problems using non-interpolating single quotes and switching to more liberal interpolation with `\qq[]` escape sequence:

```Raku
my $a = 1;
say '\qq[$a]()$b()';
# OUTPUT: «1()$b()␤» 
```

另一种选择是对所有插值使用 `Q:c` 引用符号，并使用代码块 `{}` 来进行字符串插值操作：

Another alternative is to use `Q:c` quoter, and use code blocks `{}` for all interpolation:

```Raku
my $a = 1;
say Q:c«{$a}()$b()»;
# OUTPUT: «1()$b()␤» 
```

## 字符串不是 Iterable / Strings are not iterable

有些方法是 [Str](https://docs.raku.org/type/Str) 继承自 [Any](https://docs.raku.org/type/Any)，用于处理列表之类的可迭代性。字符串上的迭代器包含一个元素，即整个字符串。若要使用基于列表的方法，如 `sort` 和 `reverse`，您需要首先将字符串转换为列表。

There are methods that [Str](https://docs.raku.org/type/Str) inherits from [Any](https://docs.raku.org/type/Any) that work on iterables like lists. Iterators on strings contain one element that is the whole string. To use list-based methods like `sort`, `reverse`, you need to convert the string into a list first.

```Raku
say "cba".sort;              # OUTPUT: «(cba)␤» 
say "cba".comb.sort.join;    # OUTPUT: «abc␤» 
```

## `.chars` gets the number of graphemes, not Codepoints

In Raku, [`.chars`](https://docs.raku.org/routine/chars) returns the number of graphemes, or user visible characters. These graphemes could be made up of a letter plus an accent for example. If you need the number of codepoints, you should use [`.codes`](https://docs.raku.org/routine/codes). If you need the number of bytes when encoded as UTF8, you should use `.encode.bytes` to encode the string as UTF8 and then get the number of bytes.

```Raku
say "\c[LATIN SMALL LETTER J WITH CARON, COMBINING DOT BELOW]"; # OUTPUT: «ǰ̣» 
say 'ǰ̣'.codes;        # OUTPUT: «2» 
say 'ǰ̣'.chars;        # OUTPUT: «1» 
say 'ǰ̣'.encode.bytes; # OUTPUT: «4»
```

For more information on how strings work in Raku, see the [Unicode page](https://docs.raku.org/language/unicode).

## All text is normalized by default

Raku normalizes all text into Unicode NFC form (Normalization Form Canonical). Filenames are the only text not normalized by default. If you are expecting your strings to maintain a byte for byte representation as the original, you need to use [`UTF8-C8`](https://docs.raku.org/language/unicode#UTF8-C8) when reading or writing to any filehandles.

## Allomorphs generally follow numeric semantics

[Str](https://docs.raku.org/type/Str) `"0"` is `True`, while [Numeric](https://docs.raku.org/type/Numeric) is `False`. So what's the [Bool](https://docs.raku.org/type/Bool) value of [allomorph](https://docs.raku.org/language/glossary#index-entry-Allomorph) `<0>`?

In general, allomorphs follow [Numeric](https://docs.raku.org/type/Numeric) semantics, so the ones that *numerically* evaluate to zero are `False`:

```Raku
say so   <0>; # OUTPUT: «False␤» 
say so <0e0>; # OUTPUT: «False␤» 
say so <0.0>; # OUTPUT: «False␤»
```

To force comparison being done for the [Stringy](https://docs.raku.org/type/Stringy) part of the allomorph, use [prefix `~` operator](https://docs.raku.org/routine/~) or the [Str](https://docs.raku.org/type/Str) method to coerce the allomorph to [Str](https://docs.raku.org/type/Str), or use the [chars](https://docs.raku.org/routine/chars) routine to test whether the allomorph has any length:

```Raku
say so      ~<0>;     # OUTPUT: «True␤» 
say so       <0>.Str; # OUTPUT: «True␤» 
say so chars <0>;     # OUTPUT: «True␤»
```

## Case-insensitive comparison of strings

In order to do case-insensitive comparison, you can use `.fc` (fold-case). The problem is that people tend to use `.lc` or `.uc`, and it does seem to work within the ASCII range, but fails on other characters. This is not just a Raku trap, the same applies to other languages.

```Raku
say ‘groß’.lc eq ‘GROSS’.lc; # ← WRONG; False 
say ‘groß’.uc eq ‘GROSS’.uc; # ← WRONG; True, but that's just luck 
say ‘groß’.fc eq ‘GROSS’.fc; # ← RIGHT; True 
```

If you are working with regexes, then there is no need to use `.fc` and you can use `:i` (`:ignorecase`) adverb instead.

# Pairs

## Constants on the left-hand side of pair notation

Consider this code:

```Raku
enum Animals <Dog Cat>;
my %h := :{ Dog => 42 };
say %h{Dog}; # OUTPUT: «(Any)␤» 
```

The `:{ … }` syntax is used to create [object hashes](https://docs.raku.org/type/Hash#Non-string_keys_(object_hash)). The intentions of someone who wrote that code were to create a hash with Enum objects as keys (and `say %h{Dog}` attempts to get a value using the Enum object to perform the lookup). However, that's not how pair notation works.

For example, in `Dog => 42` the key will be a `Str`. That is, it doesn't matter if there is a constant, or an enumeration with the same name. The pair notation will always use the left-hand side as a string literal, as long as it looks like an identifier.

To avoid this, use `(Dog) => 42` or `::Dog => 42`.

## Scalar values within `Pair`

When dealing with [Scalar](https://docs.raku.org/type/Scalar) values, the `Pair` holds the container to the value. This means that it is possible to reflect changes to the `Scalar` value from outside the `Pair`:

```Raku
my $v = 'value A';
my $pair = Pair.new( 'a', $v );
$pair.say;  # OUTPUT: a => value A 
 
$v = 'value B';
$pair.say; # OUTPUT: a => value B 
```

Use the method [freeze](https://docs.raku.org/type/Pair#method_freeze) to force the removal of the `Scalar` container from the `Pair`. For more details see the documentation about [Pair](https://docs.raku.org/type/Pair).

# Sets, bags and mixes

## Sets, bags and mixes do not have a fixed order

When iterating over this kind of objects, an order is not defined.

```Raku
my $set = <a b c>.Set;
.say for $set.list; # OUTPUT: «a => True␤c => True␤b => True␤» 
# OUTPUT: «a => True␤c => True␤b => True␤» 
# OUTPUT: «c => True␤b => True␤a => True␤» 
```

Every iteration might (and will) yield a different order, so you cannot trust a particular sequence of the elements of a set. If order does not matter, just use them that way. If it does, use `sort`

```Raku
my $set = <a b c>.Set;
.say for $set.list.sort;  # OUTPUT: «a => True␤b => True␤c => True␤»
```

In general, sets, bags and mixes are unordered, so you should not depend on them having a particular order.

# Operators

Some operators commonly shared among other languages were repurposed in Raku for other, more common, things:

## Junctions

The `^`, `|`, and `&` are *not* bitwise operators, they create [Junctions](https://docs.raku.org/type/Junction). The corresponding bitwise operators in Raku are: `+^`, `+|`, `+&` for integers and `?^`, `?|`, `?&` for booleans.

## Exclusive sequence operator

Lavish use of whitespace helps readability, but keep in mind infix operators cannot have any whitespace in them. One such operator is the sequence operator that excludes right point: `...^` (or its [Unicode equivalent](https://docs.raku.org/language/unicode_ascii) `…^`).

```Raku
say 1... ^5; # OUTPUT: «(1 0 1 2 3 4)␤» 
say 1...^5;  # OUTPUT: «(1 2 3 4)␤»
```

If you place whitespace between the ellipsis (`…`) and the caret (`^`), it's no longer a single infix operator, but an infix inclusive sequence operator (`…`) and a prefix [Range](https://docs.raku.org/type/Range) operator (`^`). [Iterables](https://docs.raku.org/type/Iterable) are valid endpoints for the sequence operator, so the result you'll get might not be what you expected.

## String ranges/Sequences

In some languages, using strings as range end points, considers the entire string when figuring out what the next string should be; loosely treating the strings as numbers in a large base. Here's Perl 5 version:

```Raku
say join ", ", "az".."bc";
# OUTPUT: «az, ba, bb, bc␤» 
```

Such a range in Raku will produce a different result, where *each letter* will be ranged to a corresponding letter in the end point, producing more complex sequences:

```Raku
say join ", ", "az".."bc";
#`{ OUTPUT: «
    az, ay, ax, aw, av, au, at, as, ar, aq, ap, ao, an, am, al, ak, aj, ai, ah,
    ag, af, ae, ad, ac, bz, by, bx, bw, bv, bu, bt, bs, br, bq, bp, bo, bn, bm,
    bl, bk, bj, bi, bh, bg, bf, be, bd, bc
␤»}
say join ", ", "r2".."t3";
# OUTPUT: «r2, r3, s2, s3, t2, t3␤» 
```

To achieve simpler behavior, similar to the Perl 5 example above, use a sequence operator that calls `.succ` method on the starting string:

```Raku
say join ", ", ("az", *.succ ... "bc");
# OUTPUT: «az, ba, bb, bc␤» 
```

## Topicalizing operators

The smartmatch operator `~~` and `andthen` set the topic `$_` to their left-hand-side. In conjunction with implicit method calls on the topic this can lead to surprising results.

```Raku
my &method = { note $_; $_ };
$_ = 'object';
say .&method;
# OUTPUT: «object␤object␤» 
say 'topic' ~~ .&method;
# OUTPUT: «topic␤True␤» 
```

In many cases flipping the method call to the LHS will work.

```Raku
my &method = { note $_; $_ };
$_ = 'object';
say .&method;
# OUTPUT: «object␤object␤» 
say .&method ~~ 'topic';
# OUTPUT: «object␤False␤» 
```

## Fat arrow and constants

The fat arrow operator `=>` will turn words on its left-hand side to `Str` without checking the scope for constants or `\`-sigiled variables. Use explicit scoping to get what you mean.

```Raku
constant V = 'x';
my %h = V => 'oi‽', ::V => 42;
say %h.perl
# OUTPUT: «{:V("oi‽"), :x(42)}␤» 
```

## Infix operator assignment

Infix operators, both built in and user defined, can be combined with the assignment operator as this addition example demonstrates:

```Raku
my $x = 10;
$x += 20;
say $x;     # OUTPUT: «30␤»
```

For any given infix operator `op`, `L op= R` is equivalent to `L = L op R` (where `L` and `R` are the left and right arguments, respectively). This means that the following code may not behave as expected:

```Raku
my @a = 1, 2, 3;
@a += 10;
say @a;  # OUTPUT: «[13]␤»
```

Coming from a language like C++, this might seem odd. It is important to bear in mind that `+=` isn't defined as method on the left hand argument (here the `@a` array) but is simply shorthand for:

```Raku
my @a = 1, 2, 3;
@a = @a + 10;
say @a;  # OUTPUT: «[13]␤»
```

Here `@a` is assigned the result of adding `@a` (which has three elements) and `10`; `13` is therefore placed in `@a`.

Use the [hyper form](https://docs.raku.org/language/operators#Hyper_operators) of the assignment operators instead:

```Raku
my @a = 1, 2, 3;
@a »+=» 10;
say @a;  # OUTPUT: «[11 12 13]␤»
```

# Regexes

## `$x` vs `<$x>`, and `$(code)` vs `<{code}>`

Raku offers several constructs to generate regexes at runtime through interpolation (see their detailed description [here](https://docs.raku.org/language/regexes#Regex_interpolation)). When a regex generated this way contains only literals, the above constructs behave (pairwise) identically, as if they are equivalent alternatives. As soon as the generated regex contains metacharacters, however, they behave differently, which may come as a confusing surprise.

The first two constructs that may easily be confused with each other are `$variable` and `<$variable>`:

```Raku
my $variable = 'camelia';
say ‘I ♥ camelia’ ~~ /  $variable  /;   # OUTPUT: ｢camelia｣ 
say ‘I ♥ camelia’ ~~ / <$variable> /;   # OUTPUT: ｢camelia｣
```

Here they act the same because the value of `$variable` consists of literals. But when the variable is changed to comprise regex metacharacters the outputs become different:

```Raku
my $variable = '#camelia';
say ‘I ♥ #camelia’ ~~ /  $variable  /;   # OUTPUT: ｢#camelia｣ 
say ‘I ♥ #camelia’ ~~ / <$variable> /;   # !! Error: malformed regex
```

What happens here is that the string `#camelia` contains the metacharacter `#`. In the context of a regex, this character should be quoted to match literally; without quoting, the `#` is parsed as the start of a comment that runs until the end of the line, which in turn causes the regex not to be terminated, and thus to be malformed.

Two other constructs that must similarly be distinguished from one another are `$(code)` and `<{code}>`. Like before, as long as the (stringified) return value of `code` comprises only literals, there is no distinction between the two:

```Raku
my $variable = 'ailemac';
say ‘I ♥ camelia’ ~~ / $($variable.flip)   /;   # OUTPUT: ｢camelia｣ 
say ‘I ♥ camelia’ ~~ / <{$variable.flip}>  /;   # OUTPUT: ｢camelia｣
```

But when the return value is changed to comprise regex metacharacters, the outputs diverge:

```Raku
my $variable = 'ailema.';
say ‘I ♥ camelia’ ~~ / $($variable.flip)   /;   # OUTPUT: Nil 
say ‘I ♥ camelia’ ~~ / <{$variable.flip}>  /;   # OUTPUT: ｢camelia｣
```

In this case the return value of the code is the string `.amelia`, which contains the metacharacter `.`. The above attempt by `$(code)` to match the dot literally fails; the attempt by `<{code}>` to match the dot as a regex wildcard succeeds. Hence the different outputs.

## `|` vs `||`: which branch will win

To match one of several possible alternatives, `||` or `|` will be used. But they are so different.

When there are multiple matching alternations, for those separated by `||`, the first matching alternation wins; for those separated by `|`, which to win is decided by LTM strategy. See also: [documentation on `||`](https://docs.raku.org/language/regexes#Alternation:_||) and [documentation on `|`](https://docs.raku.org/language/regexes#Longest_alternation:_|).

For simple regexes just using `||` instead of `|` will get you familiar semantics, but if writing grammars then it's useful to learn about LTM and declarative prefixes and prefer `|`. And keep yourself away from using them in one regex. When you have to do that, add parentheses and ensure that you know how LTM strategy works to make the code do what you want.

The trap typically arises when you try to mix both `|` and `||` in the same regex:

```Raku
say 42 ~~ / [  0 || 42 ] | 4/; # OUTPUT: «｢4｣␤» 
say 42 ~~ / [ 42 ||  0 ] | 4/; # OUTPUT: «｢42｣␤» 
```

The code above may seem like it is producing a wrong result, but the implementation is actually right.

## `$/` changes each time a regular expression is matched

Each time a regular expression is matched against something, the special variable `$/` holding the result [Match object](https://docs.raku.org/type/Match) is changed accordingly to the result of the match (that could also be `Nil`).

The `$/` is changed without any regard to the scope the regular expression is matched within.

For further information and examples please see the [related section in the Regular Expressions documentation](https://docs.raku.org/language/regexes.html#$/_changes_each_time_a_regular_expression_is_matched).

## `` vs. `< foo>`: named rules vs. quoted lists

Regexes can contain quoted lists; longest token matching is performed on the list's elements as if a `|` alternation had been specified (see [here](https://docs.raku.org/language/regexes#Quoted_lists_are_LTM_matches) for further information).

Within a regex, the following are lists with a single item, `'foo'`:

```Raku
say 'foo' ~~ /< foo >/;  # OUTPUT: «｢foo｣␤» 
say 'foo' ~~ /< foo>/;   # OUTPUT: «｢foo｣␤»
```

but this is a call to the named rule `foo`:

```Raku
say 'foo' ~~ /<foo>/;
# OUTPUT: «No such method 'foo' for invocant of type 'Match'␤ in block <unit> at <unknown file> line 1␤» 
```

Be wary of the difference; if you intend to use a quoted list, ensure that whitespace follows the initial `<`.

## Non-capturing, non-global matching in list context

Unlike Perl 5, non-capturing and non-global matching in list context doesn't produce any values:

```Raku
if  'x' ~~ /./ { say 'yes' }  # OUTPUT: «yes␤» 
for 'x' ~~ /./ { say 'yes' }  # NO OUTPUT
```

This is because its 'list' slot (inherited from Capture class) doesn't get populated with the original Match object:

```Raku
say ('x' ~~ /./).list  # OUTPUT: «()␤»
```

To achieve the desired result, use global matching, capturing parentheses or a list with a trailing comma:

```Raku
for 'x' ~~ m:g/./ { say 'yes' }  # OUTPUT: «yes␤» 
for 'x' ~~ /(.)/  { say 'yes' }  # OUTPUT: «yes␤» 
for ('x' ~~ /./,) { say 'yes' }  # OUTPUT: «yes␤»
```

# Common precedence mistakes

## Adverbs and precedence

Adverbs do have a precedence that may not follow the order of operators that is displayed on your screen. If two operators of equal precedence are followed by an adverb it will pick the first operator it finds in the abstract syntax tree. Use parentheses to help Raku understand what you mean or use operators with looser precedence.

```Raku
my %x = a => 42;
say !%x<b>:exists;            # dies with X::AdHoc 
say %x<b>:!exists;            # this works 
say !(%x<b>:exists);          # works too 
say not %x<b>:exists;         # works as well 
say True unless %x<b>:exists; # avoid negation altogether 
```

## Ranges and precedence

The loose precedence of `..` can lead to some errors. It is usually best to parenthesize ranges when you want to operate on the entire range.

```Raku
1..3.say;    # says "3" (and warns about useless "..") 
(1..3).say;  # says "1..3" 
```

## Loose boolean operators

The precedence of `and`, `or`, etc. is looser than routine calls. This can have surprising results for calls to routines that would be operators or statements in other languages like `return`, `last` and many others.

```Raku
sub f {
    return True and False;
    # this is actually 
    # (return True) and False; 
}
say f; # OUTPUT: «True␤» 
```

## Exponentiation operator and prefix minus

```Raku
say -1²;   # OUTPUT: «-1␤» 
say -1**2; # OUTPUT: «-1␤» 
```

When performing a [regular mathematical calculation](https://www.wolframalpha.com/input/?i=-1%C2%B2), the power takes precedence over the minus; so `-1²` can be written as `-(1²)`. Raku matches these rules of mathematics and the precedence of `**` operator is tighter than that of the prefix `-`. If you wish to raise a negative number to a power, use parentheses:

```Raku
say (-1)²;   # OUTPUT: «1␤» 
say (-1)**2; # OUTPUT: «1␤» 
```

## Method operator calls and prefix minus

Prefix minus binds looser than dotty method op calls. The prefix minus will be applied to the return value from the method. To ensure the minus gets passed as part of the argument, enclose in parenthesis.

```Raku
say  -1.abs;  # OUTPUT: «-1␤» 
say (-1).abs; # OUTPUT: «1␤» 
```

# Subroutine and method calls

Subroutine and method calls can be made using one of two forms:

```Raku
foo(...); # function call form, where ... represent the required arguments 
foo ...;  # list op form, where ... represent the required arguments 
```

The function call form can cause problems for the unwary when whitespace is added after the function or method name and before the opening parenthesis.

First we consider functions with zero or one parameter:

```Raku
sub foo() { say 'no arg' }
sub bar($a) { say "one arg: $a" }
```

Then execute each with and without a space after the name:

```Raku
foo();    # okay: no arg 
foo ();   # FAIL: Too many positionals passed; expected 0 arguments but got 1 
bar($a);  # okay: one arg: 1 
bar ($a); # okay: one arg: 1 
```

Now declare a function of two parameters:

```Raku
sub foo($a, $b) { say "two args: $a, $b" }
```

Execute it with and without the space after the name:

```Raku
foo($a, $b);  # okay: two args: 1, 2 
foo ($a, $b); # FAIL: Too few positionals passed; expected 2 arguments but got 1 
```

The lesson is: "be careful with spaces following sub and method names when using the function call format." As a general rule, good practice might be to avoid the space after a function name when using the function call format.

Note that there are clever ways to eliminate the error with the function call format and the space, but that is bordering on hackery and will not be mentioned here. For more information, consult [Functions](https://docs.raku.org/language/functions#Functions).

Finally, note that, currently, when declaring the functions whitespace may be used between a function or method name and the parentheses surrounding the parameter list without problems.

## Named parameters

Many built-in subroutines and method calls accept named parameters and your own code may accept them as well, but be sure the arguments you pass when calling your routines are actually named parameters:

```Raku
sub foo($a, :$b) { ... }
foo(1, 'b' => 2); # FAIL: Too many positionals passed; expected 1 argument but got 2 
```

What happened? That second argument is not a named parameter argument, but a [Pair](https://docs.raku.org/type/Pair) passed as a positional argument. If you want a named parameter it has to look like a name to Perl:

```Raku
foo(1, b => 2); # okay 
foo(1, :b(2));  # okay 
foo(1, :b<it>); # okay 
 
my $b = 2;
foo(1, :b($b)); # okay, but redundant 
foo(1, :$b);    # okay 
 
# Or even... 
my %arg = 'b' => 2;
foo(1, |%arg);  # okay too 
```

That last one may be confusing, but since it uses the `|` prefix on a [Hash](https://docs.raku.org/type/Hash), which is a special compiler construct indicating you want to use *the contents* of the variable as arguments, which for hashes means to treat them as named arguments.

If you really do want to pass them as pairs you should use a [List](https://docs.raku.org/type/List) or [Capture](https://docs.raku.org/type/Capture) instead:

```Raku
my $list = ('b' => 2),; # this is a List containing a single Pair 
foo(|$list, :$b);       # okay: we passed the pair 'b' => 2 to the first argument 
foo(1, |$list);         # FAIL: Too many positionals passed; expected 1 argument but got 2 
foo(1, |$list.Capture); # OK: .Capture call converts all Pair objects to named args in a Capture 
my $cap = \('b' => 2); # a Capture with a single positional value 
foo(|$cap, :$b); # okay: we passed the pair 'b' => 2 to the first argument 
foo(1, |$cap);   # FAIL: Too many positionals passed; expected 1 argument but got 2 
```

A Capture is usually the best option for this as it works exactly like the usual capturing of routine arguments during a regular call.

The nice thing about the distinction here is that it gives the developer the option of passing pairs as either named or positional arguments, which can be handy in various instances.

## Argument count limit

While it is typically unnoticeable, there is a backend-dependent argument count limit. Any code that does flattening of arbitrarily sized arrays into arguments won't work if there are too many elements.

```Raku
my @a = 1 xx 9999;
my @b;
@b.push: |@a;
say @b.elems # OUTPUT: «9999␤» 
my @a = 1 xx 999999;
my @b;
@b.push: |@a; # OUTPUT: «Too many arguments in flattening array.␤  in block <unit> at <tmp> line 1␤␤» 
```

Avoid this trap by rewriting the code so that there is no flattening. In the example above, you can replace `push` with `append`. This way, no flattening is required because the array can be passed as is.

```Raku
my @a = 1 xx 999999;
my @b;
@b.append: @a;
say @b.elems # OUTPUT: «999999␤» 
```

## Phasers and implicit return

```Raku
sub returns-ret () {
    CATCH {
        default {}
    }
    "ret";
}
 
sub doesn't-return-ret () {
    "ret";
    CATCH {
        default {}
    }
}
 
say returns-ret;        # OUTPUT: «ret» 
say doesn't-return-ret;
# BAD: outputs «Nil» and a warning «Useless use of constant string "ret" in sink context (line 13)» 
```

Code for `returns-ret` and `doesn't-return-ret` might look exactly the same, since in principle it does not matter where the [`CATCH`](https://docs.raku.org/language/phasers#index-entry-Phasers__CATCH-CATCH) block goes. However, a block is an object and the last object in a `sub` will be returned, so the `doesn't-return-ret` will return `Nil`, and, besides, since "ret" will be now in sink context, it will issue a warning. In case you want to place phasers last for conventional reasons, use the explicit form of `return`.

```Raku
sub explicitly-return-ret () {
    return "ret";
    CATCH {
        default {}
    }
}
```

# Input and output

## Closing open filehandles and pipes

Unlike some other languages, Raku does not use reference counting, and so **the filehandles are NOT closed when they go out of scope**. You have to explicitly close them either by using [close](https://docs.raku.org/routine/close) routine or using the `:close` argument several of [IO::Handle's](https://docs.raku.org/type/IO::Handle) methods accept. See [`IO::Handle.close`](https://docs.raku.org/type/IO::Handle#routine_close) for details.

The same rules apply to [IO::Handle's](https://docs.raku.org/type/IO::Handle) subclass [IO::Pipe](https://docs.raku.org/type/IO::Pipe), which is what you operate on when reading from a [Proc](https://docs.raku.org/type/Proc) you get with routines [run](https://docs.raku.org/routine/run) and [shell](https://docs.raku.org/routine/shell).

The caveat applies to [IO::CatHandle](https://docs.raku.org/type/IO::CatHandle) type as well, though not as severely. See [`IO::CatHandle.close`](https://docs.raku.org/type/IO::CatHandle#method_close) for details.

## IO::Path stringification

Partly for historical reasons and partly by design, an [IO::Path](https://docs.raku.org/type/IO::Path) object [stringifies](https://docs.raku.org/type/IO::Path#method_Str) without considering its [`CWD` attribute](https://docs.raku.org/type/IO::Path#attribute_CWD), which means if you [chdir](https://docs.raku.org/routine/chdir) and then stringify an [IO::Path](https://docs.raku.org/type/IO::Path), or stringify an [IO::Path](https://docs.raku.org/type/IO::Path) with custom `$!CWD` attribute, the resultant string won't reference the original filesystem object:

```Raku
with 'foo'.IO {
    .Str.say;       # OUTPUT: «foo␤» 
    .relative.say;  # OUTPUT: «foo␤» 
 
    chdir "/tmp";
    .Str.say;       # OUTPUT: «foo␤» 
    .relative.say   # OUTPUT: «../home/camelia/foo␤» 
}
 
# Deletes ./foo, not /bar/foo 
unlink IO::Path.new("foo", :CWD</bar>).Str
```

The easy way to avoid this issue is to not stringify an [IO::Path](https://docs.raku.org/type/IO::Path) object at all. Core routines that work with paths can take an [IO::Path](https://docs.raku.org/type/IO::Path) object, so you don't need to stringify the paths.

If you do have a case where you need a stringified version of an [IO::Path](https://docs.raku.org/type/IO::Path), use [absolute](https://docs.raku.org/routine/absolute) or [relative](https://docs.raku.org/routine/relative) methods to stringify it into an absolute or relative path, respectively.

If you are facing this issue because you use [chdir](https://docs.raku.org/routine/chdir) in your code, consider rewriting it in a way that does not involve changing the current directory. For example, you can pass `cwd` named argument to [run](https://docs.raku.org/routine/run) without having to use `chdir` around it.

## Splitting the input data into lines

There is a difference between using `.lines` on [`IO::Handle`](https://docs.raku.org/type/IO::Handle#routine_lines) and on a [`Str`](https://docs.raku.org/type/Str#routine_lines). The trap arises if you start assuming that both split data the same way.

```Raku
say $_.perl for $*IN.lines # .lines called on IO::Handle 
# OUTPUT: 
# "foox" 
# "fooy\rbar" 
# "fooz" 
```

As you can see in the example above, there was a line which contained `\r` (“carriage return” control character). However, the input is split strictly by `\n`, so `\r` was kept as part of the string.

On the other hand, [`Str.lines`](https://docs.raku.org/type/Str#routine_lines) attempts to be “smart” about processing data from different operating systems. Therefore, it will split by all possible variations of a newline.

```Raku
say $_.perl for $*IN.slurp(:bin).decode.lines # .lines called on a Str 
# OUTPUT: 
# "foox" 
# "fooy" 
# "bar" 
# "fooz" 
```

The rule is quite simple: use [`IO::Handle.lines`](https://docs.raku.org/type/IO::Handle#routine_lines) when working with programmatically generated output, and [`Str.lines`](https://docs.raku.org/type/Str#routine_lines) when working with user-written texts.

Use `$data.split(“\n”)` in cases where you need the behavior of [`IO::Handle.lines`](https://docs.raku.org/type/IO::Handle#routine_lines) but the original [IO::Handle](https://docs.raku.org/type/IO::Handle) is not available.

Note that if you really want to slurp the data first, then you will have to use `.IO.slurp(:bin).decode.split(“\n”)`. Notice how we use `:bin` to prevent it from doing the decoding, only to call `.decode` later anyway. All that is needed because `.slurp` is assuming that you are working with text and therefore it attempts to be smart about newlines.

If you are using [Proc::Async](https://docs.raku.org/type/Proc::Async), then there is currently no easy way to make it split data the right way. You can try reading the whole output and then using [`Str.split`](https://docs.raku.org/type/Str#routine_split) (not viable if you are dealing with large data) or writing your own logic to split the incoming data the way you need. Same applies if your data is null-separated.

## Proc::Async and `print`

When using Proc::Async you should not assume that `.print` (or any other similar method) is synchronous. The biggest issue of this trap is that you will likely not notice the problem by running the code once, so it may cause a hard-to-detect intermittent fail.

Here is an example that demonstrates the issue:

```Raku
loop {
    my $proc = Proc::Async.new: :w, ‘head’, ‘-n’, ‘1’;
    my $got-something;
    react {
        whenever $proc.stdout.lines { $got-something = True }
        whenever $proc.start        { die ‘FAIL!’ unless $got-something }
 
        $proc.print: “one\ntwo\nthree\nfour”;
        $proc.close-stdin;
    }
    say $++;
}
```

And the output it may produce:

```Raku
0
1
2
3
An operation first awaited:
  in block <unit> at print.p6 line 4
 
Died with the exception:
    FAIL!
      in block  at print.p6 line 6
```

Resolving this is easy because `.print` returns a promise that you can await on. The solution is even more beautiful if you are working in a [react](https://docs.raku.org/language/concurrency#index-entry-react) block:

```Raku
whenever $proc.print: “one\ntwo\nthree\nfour” {
    $proc.close-stdin;
}
```

## Using `.stdout` without `.lines`

Method `.stdout` of [Proc::Async](https://docs.raku.org/type/Proc::Async) returns a supply that emits *chunks* of data, not lines. The trap is that sometimes people assume it to give lines right away.

```Raku
my $proc = Proc::Async.new(‘cat’, ‘/usr/share/dict/words’);
react {
    whenever $proc.stdout.head(1) { .say } # ← WRONG (most likely) 
    whenever $proc.start { }
}
```

The output is clearly not just 1 line:

```Raku
A
A's
AMD
AMD's
AOL
AOL's
Aachen
Aachen's
Aaliyah
Aaliyah's
Aaron
Aaron's
Abbas
Abbas's
Abbasid
Abbasid's
Abbott
Abbott's
Abby
```

If you want to work with lines, then use `$proc.stdout.lines`. If you're after the whole output, then something like this should do the trick: `whenever $proc.stdout { $out ~= $_ }`.

# Exception handling

## Sunk `Proc`

Some methods return a [Proc](https://docs.raku.org/type/Proc) object. If it represents a failed process, `Proc` itself won't be exception-like, but **sinking it** will cause an [X::Proc::Unsuccessful](https://docs.raku.org/type/X::Proc::Unsuccessful) exception to be thrown. That means this construct will throw, despite the `try` in place:

```Raku
try run("perl6", "-e", "exit 42");
say "still alive";
# OUTPUT: «The spawned process exited unsuccessfully (exit code: 42)␤» 
```

This is because `try` receives a `Proc` and returns it, at which point it sinks and throws. Explicitly sinking it inside the `try` avoids the issue and ensures the exception is thrown inside the `try`:

```Raku
try sink run("perl6", "-e", "exit 42");
say "still alive";
# OUTPUT: «still alive␤» 
```

If you're not interested in catching any exceptions, then use an anonymous variable to keep the returned `Proc` in; this way it'll never sink:

```Raku
$ = run("perl6", "-e", "exit 42");
say "still alive";
# OUTPUT: «still alive␤» 
```

# Using shortcuts

## The ^ twigil

Using the `^` twigil can save a fair amount of time and space when writing out small blocks of code. As an example:

```Raku
for 1..8 -> $a, $b { say $a + $b; }
```

can be shortened to just

```Raku
for 1..8 { say $^a + $^b; }
```

The trouble arises when a person wants to use more complex names for the variables, instead of just one letter. The `^` twigil is able to have the positional variables be out of order and named whatever you want, but assigns values based on the variable's Unicode ordering. In the above example, we can have `$^a` and `$^b` switch places, and those variables will keep their positional values. This is because the Unicode character 'a' comes before the character 'b'. For example:

```Raku
# In order 
sub f1 { say "$^first $^second"; }
f1 "Hello", "there";    # OUTPUT: «Hello there␤» 
# Out of order 
sub f2 { say "$^second $^first"; }
f2 "Hello", "there";    # OUTPUT: «there Hello␤» 
```

Due to the variables allowed to be called anything, this can cause some problems if you are not accustomed to how Raku handles these variables.

```Raku
# BAD NAMING: alphabetically `four` comes first and gets value `1` in it: 
for 1..4 { say "$^one $^two $^three $^four"; }    # OUTPUT: «2 4 3 1␤» 
 
# GOOD NAMING: variables' naming makes it clear how they sort alphabetically: 
for 1..4 { say "$^a $^b $^c $^d"; }               # OUTPUT: «1 2 3 4␤» 
```

## Using `»` and `map` interchangeably

While [`»`](https://docs.raku.org/language/operators#index-entry-hyper_%3C%3C-hyper_%3E%3E-hyper_%C2%AB-hyper_%C2%BB-Hyper_Operators) may look like a shorter way to write `map`, they differ in some key aspects.

First, the `»` includes a *hint* to the compiler that it may autothread the execution, thus if you're using it to call a routine that produces side effects, those side effects may be produced out of order (the result of the operator *is* kept in order, however). Also if the routine being invoked accesses a resource, there's the possibility of a race condition, as multiple invocations may happen simultaneously, from different threads.

```Raku
<a b c d>».say # OUTPUT: «d␤b␤c␤a␤» 
```

Second, `»` checks the [nodality](https://docs.raku.org/routine/is%20nodal) of the routine being invoked and based on that will use either [deepmap](https://docs.raku.org/routine/deepmap) or [nodemap](https://docs.raku.org/routine/nodemap) to map over the list, which can be different from how a [map](https://docs.raku.org/routine/map) call would map over it:

```Raku
say ((1, 2, 3), [^4], '5')».Numeric;       # OUTPUT: «((1 2 3) [0 1 2 3] 5)␤» 
say ((1, 2, 3), [^4], '5').map: *.Numeric; # OUTPUT: «(3 4 5)␤» 
```

The bottom line is that `map` and `»` are not interchangeable, but using one instead of the other is OK as long as you understand the differences.

## Word splitting in `« »`

Keep in mind that `« »` performs word splitting similarly to how shells do it, so [many shell pitfalls](https://mywiki.wooledge.org/BashPitfalls) apply here as well (especially when using in combination with `run`):

```Raku
my $file = ‘--my arbitrary filename’;
run ‘touch’, ‘--’, $file;  # RIGHT 
run <touch -->, $file;     # RIGHT 
 
run «touch -- "$file"»;    # RIGHT but WRONG if you forget quotes 
run «touch -- $file»;      # WRONG; touches ‘--my’, ‘arbitrary’ and ‘filename’ 
run ‘touch’, $file;        # WRONG; error from `touch` 
run «touch "$file"»;       # WRONG; error from `touch`
```

Note that `--` is required for many programs to disambiguate between command-line arguments and [filenames that begin with hyphens](https://mywiki.wooledge.org/BashPitfalls#Filenames_with_leading_dashes).

# Scope

## Using a `once` block

The `once` block is a block of code that will only run once when its parent block is run. As an example:

```Raku
my $var = 0;
for 1..10 {
    once { $var++; }
}
say "Variable = $var";    # OUTPUT: «Variable = 1␤» 
```

This functionality also applies to other code blocks like `sub` and `while`, not just `for` loops. Problems arise though, when trying to nest `once` blocks inside of other code blocks:

```Raku
my $var = 0;
for 1..10 {
    do { once { $var++; } }
}
say "Variable = $var";    # OUTPUT: «Variable = 10␤» 
```

In the above example, the `once` block was nested inside of a code block which was inside of a `for` loop code block. This causes the `once` block to run multiple times, because the `once` block uses state variables to determine whether it has run previously. This means that if the parent code block goes out of scope, then the state variable the `once` block uses to keep track of if it has run previously, goes out of scope as well. This is why `once` blocks and `state` variables can cause some unwanted behavior when buried within more than one code block.

If you want to have something that will emulate the functionality of a once block, but still work when buried a few code blocks deep, we can manually build the functionality of a `once` block. Using the above example, we can change it so that it will only run once, even when inside the `do` block by changing the scope of the `state` variable.

```Raku
my $var = 0;
for 1..10 {
    state $run-code = True;
    do { if ($run-code) { $run-code = False; $var++; } }
}
say "Variable = $var";    # OUTPUT: «Variable = 1␤» 
```

In this example, we essentially manually build a `once` block by making a `state` variable called `$run-code` at the highest level that will be run more than once, then checking to see if `$run-code` is `True` using a regular `if`. If the variable `$run-code` is `True`, then make the variable `False` and continue with the code that should only be completed once.

The main difference between using a `state` variable like the above example and using a regular `once` block is what scope the `state` variable is in. The scope for the `state` variable created by the `once` block, is the same as where you put the block (imagine that the word '`once`' is replaced with a state variable and an `if` to look at the variable). The example above using `state` variables works because the variable is at the highest scope that will be repeated; whereas the example that has a `once` block inside of a `do`, made the variable within the `do` block which is not the highest scope that is repeated.

Using a `once` block inside a class method will cause the once state to carry across all instances of that class. For example:

```Raku
class A {
    method sayit() { once say 'hi' }
}
my $a = A.new;
$a.sayit;      # OUTPUT: «hi␤» 
my $b = A.new;
$b.sayit;      # nothing 
```

## `LEAVE` phaser and `exit`

Using [`LEAVE`](https://docs.raku.org/language/phasers#LEAVE) phaser to perform graceful resource termination is a common pattern, but it does not cover the case when the program is stopped with [`exit`](https://docs.raku.org/routine/exit).

The following nondeterministic example should demonstrate the complications of this trap:

```Raku
my $x = say ‘Opened some resource’;
LEAVE say ‘Closing the resource gracefully’ with $x;
 
exit 42 if rand < ⅓; # ① ｢exit｣ is bad 
die ‘Dying because of unhandled exception’ if rand < ½; # ② ｢die｣ is ok 
# fallthru ③ 
```

There are three possible results:

```Raku
①
Opened some resource
 
②
Opened some resource
Closing the resource gracefully
Dying because of unhandled exception
  in block <unit> at print.p6 line 5
 
③
Opened some resource
Closing the resource gracefully
```

A call to `exit` is part of normal operation for many programs, so beware unintentional combination of `LEAVE` phasers and `exit` calls.

## `LEAVE` phaser may run sooner than you think

Parameter binding is executed when we're "inside" the routine's block, which means `LEAVE` phaser would run when we leave that block if parameter binding fails when wrong arguments are given:

```Raku
sub foo(Int) {
    my $x = 42;
    LEAVE say $x.Int; # ← WRONG; assumes that $x is set 
}
say foo rand; # OUTPUT: «No such method 'Int' for invocant of type 'Any'␤» 
```

A simple way to avoid this issue is to declare your sub or method a multi, so the candidate is eliminated during dispatch and the code never gets to binding anything inside the sub, thus never entering the routine's body:

```Raku
multi foo(Int) {
    my $x = 42;
    LEAVE say $x.Int;
}
say foo rand; # OUTPUT: «Cannot resolve caller foo(Num); none of these signatures match: (Int)␤» 
```

Another alternative is placing the `LEAVE` into another block (assuming it's appropriate for it to be executed when *that* block is left, not the routine's body:

```Raku
sub foo(Int) {
    my $x = 42;
    { LEAVE say $x.Int; }
}
say foo rand; # OUTPUT: «Type check failed in binding to parameter '<anon>'; expected Int but got Num (0.7289418947969465e0)␤» 
```

You can also ensure `LEAVE` can be executed even if the routine is left due to failed argument binding. In our example, we check `$x` [is defined](https://docs.raku.org/routine/andthen) before doing anything with it.

```Raku
sub foo(Int) {
    my $x = 42;
    LEAVE $x andthen .Int.say;
}
say foo rand; # OUTPUT: «Type check failed in binding to parameter '<anon>'; expected Int but got Num (0.8517160389079508e0)␤» 
```

# Grammars

## Using regexes within grammar's actions

```Raku
grammar will-fail {
    token TOP {^ <word> $}
    token word { \w+ }
}
 
class will-fail-actions {
    method TOP ($/) { my $foo = ~$/; say $foo ~~ /foo/;  }
}
```

Will fail with `Cannot assign to a readonly variable ($/) or a value` on method `TOP`. The problem here is that regular expressions also affect `$/`. Since it is in `TOP`'s signature, it is a read-only variable, which is what produces the error. You can safely either use another variable in the signature or add `is copy`, this way:

```Raku
method TOP ($/ is copy) { my $foo = ~$/; my $v = $foo ~~ /foo/;  }
```

## Using certain names for rules/token/regexes

Grammars are actually a type of classes.

```Raku
grammar G {};
say G.^mro; # OUTPUT: «((G) (Grammar) (Match) (Capture) (Cool) (Any) (Mu))␤»
```

`^mro` prints the class hierarchy of this empty grammar, showing all the superclasses. And these superclasses have their very own methods. Defining a method in that grammar might clash with the ones inhabiting the class hierarchy:

```Raku
grammar g {
    token TOP { <item> };
    token item { 'defined' }
};
say g.parse('defined');
# OUTPUT: «Too many positionals passed; expected 1 argument but got 2␤  in regex item at /tmp/grammar-clash.p6 line 3␤  in regex TOP at /tmp/grammar-clash.p6 line 2␤  in block <unit> at /tmp/grammar-clash.p6 line 5» 
```

`item` seems innocuous enough, but it is a [`sub` defined in class `Mu`](https://docs.raku.org/routine/item). The message is a bit cryptic and totally unrelated to that fact, but that is why this is listed as a trap. In general, all subs defined in any part of the hierarchy are going to cause problems; some methods will too. For instance, `CREATE`, `take` and `defined` (which are defined in [Mu](https://docs.raku.org/type/Mu)). In general, multi methods and simple methods will not have any problem, but it might not be a good practice to use them as rule names.

Also avoid [phasers](https://docs.raku.org/language/objects#Object_construction) for rule/token/regex names: `TWEAK`, `BUILD`, `BUILD-ALL` will throw another kind of exception if you do that: `Cannot find method 'match': no method cache and no .^find_method`, once again only slightly related to what is actually going on.

# Unfortunate generalization

## `:exists` with more than one key

Let's say you have a hash and you want to use `:exists` on more than one element:

```Raku
my %h = a => 1, b => 2;
say ‘a exists’ if %h<a>:exists;   # ← OK; True 
say ‘y exists’ if %h<y>:exists;   # ← OK; False 
say ‘Huh‽’     if %h<x y>:exists; # ← WRONG; returns a 2-item list 
```

Did you mean “if `any` of them exists”, or did you mean that `all` of them should exist? Use `any` or `all` [Junction](https://docs.raku.org/type/Junction) to clarify:

```Raku
my %h = a => 1, b => 2;
say ‘x or y’     if any %h<x y>:exists;   # ← RIGHT (any); False 
say ‘a, x or y’  if any %h<a x y>:exists; # ← RIGHT (any); True 
say ‘a, x and y’ if all %h<a x y>:exists; # ← RIGHT (all); False 
say ‘a and b’    if all %h<a b>:exists;   # ← RIGHT (all); True 
```

The reason why it is always `True` (without using a junction) is that it returns a list with [Bool](https://docs.raku.org/type/Bool) values for each requested lookup. Non-empty lists always give `True` when you [Bool](https://docs.raku.org/type/Bool)ify them, so the check always succeeds no matter what keys you give it.

## Using `[…\]` metaoperator with a list of lists

Every now and then, someone gets the idea that they can use `[Z]` to create the transpose of a list-of-lists:

```Raku
my @matrix = <X Y>, <a b>, <1 2>;
my @transpose = [Z] @matrix; # ← WRONG; but so far so good ↙ 
say @transpose;              # [(X a 1) (Y b 2)] 
```

And everything works fine, until you get an input @matrix with *exactly one* row (child list):

```Raku
my @matrix = <X Y>,;
my @transpose = [Z] @matrix; # ← WRONG; ↙ 
say @transpose;              # [(X Y)] – not the expected transpose [(X) (Y)] 
```

This happens partly because of the [single argument rule](https://docs.raku.org/language/functions#Slurpy_conventions), and there are other cases when this kind of a generalization may not work.

## Using [~\] for concatenating a list of blobs

The [`~` infix operator](https://docs.raku.org/routine/~#(Operators)_infix_~) can be used to concatenate [Str](https://docs.raku.org/type/Str)s *or* [Blob](https://docs.raku.org/type/Blob)s. However, an empty list will *always* be reduced to an empty `Str`. This is due to the fact that, in the presence of a list with no elements, the [reduction](https://docs.raku.org/language/operators#Reduction_operators) metaoperator returns the [identity element](https://docs.raku.org/language/operators#Identity) for the given operator. Identity element for `~` is an empty string, regardless of the kind of elements the list could be populated with.

```Raku
my Blob @chunks;
say ([~] @chunks).perl; # OUTPUT: «""␤» 
```

This might cause a problem if you attempt to use the result while assuming that it is a Blob:

```Raku
my Blob @chunks;
say ([~] @chunks).decode;
# OUTPUT: «No such method 'decode' for invocant of type 'Str'. Did you mean 'encode'?␤…» 
```

There are many ways to cover that case. You can avoid `[ ]` metaoperator altogether:

```Raku
my @chunks;
# … 
say Blob.new: |«@chunks; # OUTPUT: «Blob:0x<>␤» 
```

Alternatively, you can initialize the array with an empty Blob:

```Raku
my @chunks = Blob.new;
# … 
say [~] @chunks; # OUTPUT: «Blob:0x<>␤» 
```

Or you can utilize [`||`](https://docs.raku.org/language/operators#infix%20||) operator to make it use an empty Blob in case the list is empty:

```Raku
my @chunks;
# … 
say [~] @chunks || Blob.new; # OUTPUT: «Blob:0x<>␤» 
```

Please note that a similar issue may arise when reducing lists with other operators.

# Maps

## Beware of nesting `Map`s in sink context

Maps apply an expression to every element of a [List](https://docs.raku.org/type/List) and return a [Seq](https://docs.raku.org/type/Seq):

```Raku
say <þor oðin loki>.map: *.codes; # OUTPUT: «(3 4 4)␤»
```

Maps are often used as a compact substitute for a loop, performing some kind of action in the map code block:

```Raku
<þor oðin loki>.map: *.codes.say; # OUTPUT: «3␤4␤4␤»
```

The problem might arise when maps are nested and [in a sink context](https://docs.raku.org/language/contexts#index-entry-sink_context).

```Raku
<foo bar ber>.map: { $^a.comb.map: { $^b.say}}; # OUTPUT: «»
```

You might expect the innermost map to *bubble* the result up to the outermost map, but it simply does nothing. Maps return `Seq`s, and in sink context the innermost map will iterate and discard the produced values, which is why it yields nothing.

Simply using `say` at the beginning of the sentence will save the result from sink context:

```Raku
say <foo bar ber>.map: *.comb.map: *.say ;
# OUTPUT: «f␤o␤o␤b␤a␤r␤b␤e␤r␤((True True True) (True True True) (True True True))␤»
```

However, it will not be working as intended; the first `f␤o␤o␤b␤a␤r␤b␤e␤r␤` is the result of the innermost `say`, but then [`say` returns a `Bool`](https://docs.raku.org/routine/say#(Mu)_method_say), `True` in this case. Those `True`s are what get printed by the outermost `say`, one for every letter. A much better option would be to `flat`ten the outermost sequence:

```Raku
<foo bar ber>.map({ $^a.comb.map: { $^b.say}}).flat
# OUTPUT: «f␤o␤o␤b␤a␤r␤b␤e␤r␤»
```

Of course, saving `say` for the result will also produce the intended result, as it will be saving the two nested sequences from void context:

```Raku
say <foo bar ber>.map: { $^þ.comb }; # OUTPUT: « ((f o o) (b a r) (b e r))»
```

# Smartmatching

The [smartmatch operator](https://docs.raku.org/language/operators#index-entry-smartmatch_operator) shortcuts to the right hand side *accepting* the left hand side. This may cause some confusion.

## Smartmatch and `WhateverCode`

Using `WhateverCode` in the left hand side of a smartmatch does not work as expected, or at all:

```Raku
my @a = <1 2 3>;
say @a.grep( *.Int ~~ 2 );
# OUTPUT: «Cannot use Bool as Matcher with '.grep'.  Did you mean to 
# use $_ inside a block?␤␤␤» 
```

The error message does not make a lot of sense. It does, however, if you put it in terms of the `ACCEPTS` method: that code is equivalent to `2.ACCEPTS( *.Int )`, but `*.Int` cannot be [coerced to `Numeric`](https://docs.raku.org/routine/ACCEPTS#(Numeric)_method_ACCEPTS), being as it is a `Block`.

Solution: don't use `WhateverCode` in the left hand side of a smartmatch:

```Raku
my @a = <1 2 3>;
say @a.grep( 2 ~~ *.Int ); # OUTPUT: «(2)␤» 
```
