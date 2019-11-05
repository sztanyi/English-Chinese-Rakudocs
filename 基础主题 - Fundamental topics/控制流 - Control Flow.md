原文：https://docs.raku.org/language/control

# 控制流（Control Flow）

控制执行流程的语句

Statements used to control the flow of execution

# 目录 / Table of Contents

<!-- MarkdownTOC -->

- [语句/ statements](#%E8%AF%AD%E5%8F%A5-statements)
- [代码块 / blocks](#%E4%BB%A3%E7%A0%81%E5%9D%97--blocks)
- [do](#do)
- [if](#if)
    - [else/elsif](#elseelsif)
    - [unless](#unless)
    - [with, orwith, without](#with-orwith-without)
- [when](#when)
- [for](#for)
- [gather/take](#gathertake)
- [given](#given)
    - [default and when](#default-and-when)
    - [proceed](#proceed)
    - [succeed](#succeed)
    - [given 作为语句 / given as a statement](#given-%E4%BD%9C%E4%B8%BA%E8%AF%AD%E5%8F%A5--given-as-a-statement)
- [loop](#loop)
- [while, until](#while-until)
- [repeat/while, repeat/until](#repeatwhile-repeatuntil)
- [return](#return)
- [return-rw](#return-rw)
- [fail](#fail)
- [once](#once)
- [quietly](#quietly)
- [标签 / LABELs](#%E6%A0%87%E7%AD%BE--labels)
- [next](#next)
- [last](#last)
- [redo](#redo)

<!-- /MarkdownTOC -->

<a id="%E8%AF%AD%E5%8F%A5-statements"></a>
# 语句/ statements

Raku 成语由一个或多个语句组成。简单语句由分号分隔。下面的这个程序会打印 ”Hello“ 然后再下一行打印 ”World“。

Raku programs consists of one or more statements. Simple statements are separated by semicolons. The following program will say "Hello" and then say "World" on the next line.

```Raku
say "Hello";
say "World";
```

大多数情况下出现在分号前面的空格可能被分隔成许多行。而且，多条语句可能出现在同一行上。可能显得有点笨拙，但上面也可以写为：

In most places where spaces appear in a statement, and before the semicolon, it may be split up over many lines. Also, multiple statements may appear on the same line. It would be awkward, but the above could also be written as:

```Raku
say
"Hello"; say "World";
```

<a id="%E4%BB%A3%E7%A0%81%E5%9D%97--blocks"></a>
# 代码块 / blocks

像许多语言一样，Raku 使用用 `{` 和 `}` 包含的代码块讲多个语句转变为单个语句。 代码块最后一个语句的分号可以省略。

Like many languages, Raku uses `blocks` enclosed by `{` and `}` to turn multiple statements into a single statement. It is ok to skip the semicolon between the last statement in a block and the closing `}`.

```Raku
{ say "Hello"; say "World" }
```

代码块作为语句时，它将在上一个语句执行完后立即执行，里面的语句也会被执行。

When a block stands alone as a statement, it will be entered immediately after the previous statement finishes, and the statements inside it will be executed.

```Raku
say 1;                    # OUTPUT: «1
» 
{ say 2; say 3 };         # OUTPUT: «2
3
» 
say 4;                    # OUTPUT: «4
» 
```

除非代码块仅作为语句，不然会产一个闭包。代码块里面的语句将不会马上执行。闭包时另外一个话题，它的使用将会在[其他地方](https://docs.raku.org/language/functions#Blocks_and_Lambdas)说明。现在最重要的是要知道代码块什么时候执行以及什么时候不执行。

Unless it stands alone as a statement, a block simply creates a closure. The statements inside are not executed immediately. Closures are another topic and how they are used is explained [elsewhere](https://docs.raku.org/language/functions#Blocks_and_Lambdas). For now it is just important to understand when blocks run and when they do not:

```Raku
say "We get here"; { say "then here." }; { say "not here"; 0; } or die;
```

上例中，执行完第一个语句后，第一个代码块作为第二个语句独立存在，因此我们执行里面的语句。第二个代码块不是作为一个独立语句，它产生了一个 `Block` 类型的对象而不是直接运行它。对象实例通常被当作真值，所以代码并没有死亡，尽管代码块最后的返回值为 0，如果执行的话。示例并没有说明 `Block` 对象的后续使用，所以对象被马上丢弃了。

In the above example, after running the first statement, the first block stands alone as a second statement, so we run the statement inside it. The second block does not stand alone as a statement, so instead, it makes an object of type `Block` but does not run it. Object instances are usually considered to be true, so the code does not die, even though that block would evaluate to 0, were it to be executed. The example does not say what to do with the `Block` object, so it just gets thrown away.

大多数下面提到的控制流讲述了 Raku 什么时候，以什么方式以及几次进入像上面提到的第二段代码块。

Most of the flow control constructs covered below are just ways to tell Perl6 when, how, and how many times, to enter blocks like that second block.

在这之前，说一下语法上的一个注意点：如果在闭大括号之后什么都没有或者只有注释，分号是可以不要的：

Before we go into those, an important side-note on syntax: If there is nothing (or nothing but comments) on a line after a closing curly brace where you would normally put semicolon, then you do not need the semicolon:

```Raku
# All three of these lines can appear as a group, as is, in a program 
{ 42.say }                # OUTPUT: «42
» 
{ 43.say }                # OUTPUT: «43
» 
{ 42.say }; { 43.say }    # OUTPUT: «42
43
» 
```

...but:

。。。然而：

```Raku
{ 42.say }  { 43.say }    # Syntax error 
{ 42.say; } { 43.say }    # Also a syntax error, of course 
```

因此，在自动换行的编辑器时按退格时要小心。

So, be careful when you backspace in a line-wrapping editor:

```Raku
{ "Without semicolons line-wrapping can be a bit treacherous.".say } \
{ 43.say } # Syntax error 
```

你需要小心点，不要将代码意外注释掉，虽然在大多数其他语言中也一样。下面的例子有许多多余的分号，为了清晰起见。

You have to watch out for this in most languages anyway to prevent things from getting accidentally commented out. Many of the examples below may have unnecessary semicolons for clarity.

<a id="do"></a>
# do

最简单的方式执行一个代码块并使他不能成为一个独立的语句就时在它之前加上 `do`。

The simplest way to run a block where it cannot be a stand-alone statement is by writing `do` before it:

```Raku
# This dies half of the time 
do { say "Heads I win, tails I die."; Bool.pick } or die; say "I win.";
```

注意你需要在 do 与代码块之间加上空格。

Note that you need a space between the do and the block.

`do {…}` 返回值为代码块最后一个语句的值。当返回值被需要用来计算整个表达式的返回值时这个代码块才会被执行。

The whole `do {...}` evaluates to the final value of the block. The block will be run when that value is needed in order to evaluate the rest of the expression. So:

```Raku
False and do { 42.say };
```

。。。然而上面代码的不会打印 42。只有当代码块所在的表达式需要被计算时才会代码块才会计算。

...will not say 42. However, the block is only evaluated once each time the expression it is contained in is evaluated:

```Raku
# This says "(..1 ..2 ..3)" not "(..1 ...2 ....3)" 
my $f = "."; say do { $f ~= "." } X~ 1, 2, 3;
```

换句话说，它与所有的其他东西一样，遵循同样的物化规则。

In other words, it follows the same reification rules as everything else.

从技术上说，`do` 相当于只运行一次的循环。

Technically, `do` is a loop which runs exactly one iteration.

`do` 也可应用于裸语句（没有大括号）但这仅语义上对省去用括号括起来表达式最后一个语句有点用处：

A `do` may also be used on a bare statement (without curly braces) but this is mainly just useful for avoiding the syntactical need to parenthesize a statement if it is the last thing in an expression:

```Raku
3, do if 1 { 2 }  ; # OUTPUT: «(3, 2)
» 
3,   (if 1 { 2 }) ; # OUTPUT: «(3, 2)
» 
```

```Raku
3,    if 1 { 2 }  ; # Syntax error 
```

。。。接下来就是 `if` 了。

...which brings us to `if`.

<a id="if"></a>
# if

有条件地运行一段代码块，使用 `if` 接一个条件。这个条件是一个表达式，在 `if` 之前的语句结束后立即求值。附加的代码块只有在当条件表达式的值为真并强转为 `Bool` 值时才执行。不像有些语言一样，条件表达式不需要括号，然而代码块中的 `{` 和 `}` 是必须要的：

To conditionally run a block of code, use an `if` followed by a condition. The condition, an expression, will be evaluated immediately after the statement before the `if` finishes. The block attached to the condition will only be evaluated if the condition means True when coerced to `Bool`. Unlike some languages the condition does not have to be parenthesized, instead the `{` and `}` around the block are mandatory:

```Raku
if 1 { "1 is true".say }  ; # says "1 is true" 
```

```Raku
if 1   "1 is true".say    ; # syntax error, missing block 
```

```Raku
if 0 { "0 is true".say }  ; # does not say anything, because 0 is false 
```

```Raku
if 42.say and 0 { 43.say }; # says "42" but does not say "43" 
```

也有一种叫做语句修饰符形式的 `if`。在这种形式中，if 以及其后的条件表达式在需要依条件执行的代码之前。注意，条件表达式仍然总是最先被求值的。

There is also a form of `if` called a "statement modifier" form. In this case, the if and then the condition come after the code you want to run conditionally. Do note that the condition is still always evaluated first:

```Raku
43.say if 42.say and 0;     # says "42" but does not say "43" 
43.say if 42.say and 1;     # says "42" and then says "43" 
say "It is easier to read code when 'if's are kept on left of screen"
    if True;                # says the above, because it is true 
{ 43.say } if True;         # says "43" as well 
```

语句修饰符形式最好保守使用。

The statement modifier form is probably best used sparingly.

如果代码块没有被执行，`if` 语句本身要么 [slip](https://docs.raku.org/type/Slip) 给我们一个空列表，要么返回代码块产生的值。

The `if` statement itself will either [slip](https://docs.raku.org/type/Slip) us an empty list, if it does not run the block, or it will return the value which the block produces:

```Raku
my $d = 0; say (1, (if 0 { $d += 42; 2; }), 3, $d); # says "(1 3 0)" 
my $c = 0; say (1, (if 1 { $c += 42; 2; }), 3, $c); # says "(1 2 3 42)" 
say (1, (if 1 { 2, 2 }), 3);         # does not slip, says "(1 (2 2) 3)" 
```

对于语句修饰符也一样，除非 if 后是语句值而非代码块：

For the statement modifier it is the same, except you have the value of the statement instead of a block:

```Raku
say (1, (42 if True) , 2); # says "(1 42 2)" 
say (1, (42 if False), 2); # says "(1 2)" 
say (1,  42 if False , 2); # says "(1 42)" because "if False, 2" is true 
```

`if` 默认不会改变主题（`$_`)。要访问条件语句产生的值，需要更强力的请求：

The `if` does not change the topic (`$_`) by default. In order to access the value which the conditional expression produced, you have to ask for it more strongly:

```Raku
$_ = 1; if 42 { $_.say }                ; # says "1" 
$_ = 1; if 42 -> $_ { $_.say }          ; # says "42" 
$_ = 1; if 42 -> $a { $_.say;  $a.say } ; # says "1" then says "42" 
$_ = 1; if 42       { $_.say; $^a.say } ; # says "1" then says "42" 
```

<a id="elseelsif"></a>
## else/elsif

复合条件可以由 `if` 条件后跟随 `else` 产生。当条件表达式为假时，提供另外一个代码块来运行。

A compound conditional may be produced by following an `if` conditional with `else` to provide an alternative block to run when the conditional expression is false:

```Raku
if 0 { say "no" } else { say "yes" }   ; # says "yes" 
if 0 { say "no" } else{ say "yes" }    ; # says "yes", space is not required 
```

`else` 不能从条件语句中由分号分隔开头，但是可以另起一行。

The `else` cannot be separated from the conditional statement by a semicolon, but as a special case, it is OK to have a newline.

```Raku
if 0 { say "no" }; else { say "yes" }  ; # syntax error 
```

```Raku
if 0 { say "no" }
else { say "yes" }                     ; # says "yes" 
```

其他的条件语句可以在 `if` 和 `else` 中间使用 `elsif`。额外的条件语句只会在它之前的条件全部为假时才被计算。只有第一个为真的条件语句旁的代码块会执行。如果你想，你可以用 `elsif` 替代 `else` 结尾。

Additional conditions may be sandwiched between the `if` and the `else` using `elsif`. An extra condition will only be evaluated if all the conditions before it were false, and only the block next to the first true condition will be run. You can end with an `elsif` instead of an `else` if you want.

```Raku
if 0 { say "no" } elsif False { say "NO" } else { say "yes" } # says "yes" 
if 0 { say "no" } elsif True { say "YES" } else { say "yes" } # says "YES" 
 
if 0 { say "no" } elsif False { say "NO" } # does not say anything 
 
sub right { "Right!".say; True }
sub wrong { "Wrong!".say; False }
if wrong() { say "no" } elsif right() { say "yes" } else { say "maybe" }
# The above says "Wrong!" then says "Right!" then says "yes" 
```

语句修饰符形式不可以使用 `else` 或者 `elsif`：

You cannot use the statement modifier form with `else` or `elsif`:

```Raku
42.say if 0 else { 43.say }            # syntax error 
```

适用于分号和换行符的规则同样适用：

All the same rules for semicolons and newlines apply, consistently

```Raku
if 0 { say 0 }; elsif 1 { say 1 }  else { say "how?" } ; # syntax error 
if 0 { say 0 }  elsif 1 { say 1 }; else { say "how?" } ; # syntax error 
if 0 { say 0 }  elsif 1 { say 1 }  else { say "how?" } ; # says "1" 
```

```Raku
if 0 { say 0 } elsif 1 { say 1 }
else { say "how?" }                                    ; # says "1" 
 
if 0 { say 0 }
elsif 1 { say 1 } else { say "how?" }                  ; # says "1" 
 
if        0 { say "no" }
elsif False { say "NO" }
else        { say "yes" }                              ; # says "yes" 
```

整个代码要么 [slips](https://docs.raku.org/type/Slip) 给我们一个空列表（如果没有代码块被运行）或者返回执行了的代码块产生的值。

The whole thing either [slips](https://docs.raku.org/type/Slip) us an empty list (if no blocks were run) or returns the value produced by the block that did run:

```Raku
my $d = 0; say (1,
                (if 0 { $d += 42; "two"; } elsif False { $d += 43; 2; }),
                3, $d); # says "(1 3 0)" 
my $c = 0; say (1,
                (if 0 { $c += 42; "two"; } else { $c += 43; 2; }),
                3, $c); # says "(1 2 3 43)" 
```

可以从 `else` 里获得之前表达式的值，可能是从 `if` 或者上一个 `elsif` 那获得，如果有的话。

It's possible to obtain the value of the previous expression inside an `else`, which could be from `if` or the last `elsif` if any are present:

```Raku
$_ = 1; if 0     { } else -> $a { "$_ $a".say } ; # says "1 0" 
$_ = 1; if False { } else -> $a { "$_ $a".say } ; # says "1 False" 
 
if False { } elsif 0 { } else -> $a { $a.say }  ; # says "0" 
```

<a id="unless"></a>
## unless

如果你厌烦敲代码 “if not (x)“ 你可以使用 `unless` 来反转条件语句。`unless` 不能同时使用 `else` 或者 `elsif` ，因为这会引发困惑。除了这两个区别之外，`unless` 和 [if](https://docs.raku.org/language/control#if) 效果一样。

When you get sick of typing "if not (X)" you may use `unless` to invert the sense of a conditional statement. You cannot use `else` or `elsif` with `unless` because that ends up getting confusing. Other than those two differences `unless` works the same as [if](https://docs.raku.org/language/control#if):

```Raku
unless 1 { "1 is false".say }  ; # does not say anything, since 1 is true 
```

```Raku
unless 1   "1 is false".say    ; # syntax error, missing block 
```

```Raku
unless 0 { "0 is false".say }  ; # says "0 is false" 
```

```Raku
unless 42.say and 1 { 43.say } ; # says "42" but does not say "43" 
43.say unless 42.say and 0;      # says "42" and then says "43" 
43.say unless 42.say and 1;      # says "42" but does not say "43" 
 
$_ = 1; unless 0 { $_.say }           ; # says "1" 
$_ = 1; unless 0 -> $_ { $_.say }     ; # says "0" 
$_ = 1; unless False -> $a { $a.say } ; # says "False" 
 
my $c = 0; say (1, (unless 0 { $c += 42; 2; }), 3, $c); # says "(1 2 3 42)" 
my $d = 0; say (1, (unless 1 { $d += 42; 2; }), 3, $d); # says "(1 3 0)" 
```

<a id="with-orwith-without"></a>
## with, orwith, without

`with` 语句有点像 `if` 但是检查定义而不是真值。额外的，它指明了条件的主题，这点很像 `given` ：

The `with` statement is like `if` but tests for definedness rather than truth. In addition, it topicalizes on the condition, much like `given`:

```Raku
with "abc".index("a") { .say }      # prints 0 
```

`orwith` 可用作链式已定义检查测试，替代 `elsif`。

Instead of `elsif`, `orwith` may be used to chain definedness tests:

```Raku
# The below code says "Found a at 0" 
my $s = "abc";
with   $s.index("a") { say "Found a at $_" }
orwith $s.index("b") { say "Found b at $_" }
orwith $s.index("c") { say "Found c at $_" }
else                 { say "Didn't find a, b or c" }
```

基于 `if` 和基于 `with` 的分句可以混合使用。

You may intermix `if`-based and `with`-based clauses.

```Raku
# This says "Yes" 
if 0 { say "No" } orwith Nil { say "No" } orwith 0 { say "Yes" };
```

如 `unless` ，你可以使用 `without` 去检查无定义，但是你无法加 `else` 分句：

As with `unless`, you may use `without` to check for undefinedness, but you may not add an `else` clause:

```Raku
my $answer = Any;
without $answer { warn "Got: $_" }
```

也存在 `with` 和 `without` 的语句修饰符：

There are also `with` and `without` statement modifiers:

```Raku
my $answer = (Any, True).roll;
say 42 with $answer;
warn "undefined answer" without $answer;
```

<a id="when"></a>
# when

`when` 代码块类似于 `if` 代码块，两者都能在外部代码块使用，也有“语句修饰符” 形式。下面的代码展示了相同情况下外部代码块是被怎样处理的：当 `when` 代码块执行完，控制权交给外层大括号代码块，when 之后外层大括号代码块之前的代码都会被略过；但是当 `if` 代码块执行完时，后续的代码会继续执行。（注两者都有其他的方式改变默认行为，这个将会在其他章节讨论。）下面的示例代码展示了 `if` 或者 `when` 代码块的默认行为，假设代码块中没有特殊退出或者其他副作用的语句。

The `when` block is similar to an `if` block and either or both can be used in an outer block, they also both have a "statement modifier" form. But there is a difference in how following code in the same, outer block is handled: When the `when` block is executed, control is passed to the enclosing block and following statements are ignored; but when the `if`block is executed, following statements are executed. (Note there are other ways to modify the default behavior of each which are discussed in other sections.) The following examples should illustrate the `if` or `when` block's default behavior assuming no special exit or other side effect statements are included in the `if` or `when` blocks:

```Raku
{
    if X {...} # if X is true in boolean context, block is executed 
    # following statements are executed regardless 
}
{
    when X {...} # if X is true in boolean context, block is executed 
                 # and control passes to the outer block 
    # following statements are NOT executed 
}
```

如果上面的 `if` 和 `when` 代码块出现在文件作用域，下面的语句将在每种情况下执行。

Should the `if` and `when` blocks above appear at file scope, following statements would be executed in each case.

另外一个 `when` 有但是 `if` 没有的特性是：`when` 的布尔上下文测试默认为 `$_ ~~` 但是 `if` 的不是。这会影响 `$_` 没有值的 `when` 代码块中 X 条件语句的使用（这时 `$_` 是 `Any` ，它的聪明匹配返回 `True` ：`Any ~~ True` 返回 `True`  ）。请看如下代码：

There is one other feature a `when` has that `if` doesn't: the `when`'s boolean context test defaults to `$_ ~~` while the `if`'s does not. That has an effect on how one uses the X in the `when` block without a value for `$_` (it's `Any` in that case and `Any` smart matches on `True`: `Any ~~ True` yields `True`). Consider the following:

```Raku
{
    my $a = 1;
    my $b = True;
    when $a    { say 'a' }; # no output 
    when so $a { say 'a' }  # a (in "so $a" 'so' coerces $a to Boolean context True 
                            # which matches with Any) 
    when $b    { say 'b' }; # no output (this statement won't be run) 
}
```

最后，`when` 的语句修饰符形式不会影响其他代码块内部或外部的的执行。

Finally, `when`'s statement modifier form does not effect execution of following statements either inside or outside of another block:

```Raku
say "foo" when X; # if X is true statement is executed 
                  # following statements are not affected 
```

<a id="for"></a>
# for

`for` 循环遍历数组，每次循环执行一次 [block](https://docs.raku.org/type/Block) 中的语句。如果代码块接收参数，数组中的元素将作为参数。

The `for` loop iterates over a list, running the statements inside a [block](https://docs.raku.org/type/Block) once on each iteration. If the block takes parameters, the elements of the list are provided as arguments.

```Raku
my @foo = 1..3;
for @foo { $_.print } # prints each value contained in @foo 
for @foo { .print }   # same thing, because .print implies a $_ argument 
for @foo { 42.print } # prints 42 as many times as @foo has elements 
```

带箭头的代码块语法或者 [placeholder](https://docs.raku.org/language/variables#The_%5E_Twigil) 当然也可以用来命名参数。

Pointy block syntax or a [placeholder](https://docs.raku.org/language/variables#The_%5E_Twigil) may be used to name the parameter, of course.

```Raku
my @foo = 1..3;
for @foo -> $item { print $item }
for @foo { print $^item }            # same thing 
```

可以声明多个参数，在这种情况下，迭代器在运行块之前根据需要从列表中获取尽可能多的元素。

Multiple parameters can be declared, in which case the iterator takes as many elements from the list as needed before running the block.

```Raku
my @foo = 1..3;
for @foo.kv -> $idx, $val { say "$idx: $val" }
my %hash = <a b c> Z=> 1,2,3;
for %hash.kv -> $key, $val { say "$key => $val" }
for 1, 1.1, 2, 2.1 { say "$^x < $^y" }  # says "1 < 1.1" then says "2 < 2.1" 
```

带箭头代码块的参数可以有默认值，可以处理缺少元素的列表。

Parameters of a pointy block can have default values, allowing to handle lists with missing elements.

```Raku
my @list = 1,2,3,4;
for @list -> $a, $b = 'N/A', $c = 'N/A' {
    say "$a $b $c"
}
# OUTPUT: «1 2 3
4 N/A N/A
» 
```

如果使用 `for` 的后缀形式，则不需要块，并且为语句列表设置主题。

If the postfix form of `for` is used a block is not required and the topic is set for the statement list.

```Raku
say „I $_ butterflies!“ for <♥ ♥ ♥>;
# OUTPUT«I ♥ butterflies!
I ♥ butterflies!
I ♥ butterflies!
» 
```

`for` 可以用在懒惰列表上，它会按需拿列表中的元素，因此要逐行读取文件，可以使用：

A `for` may be used on lazy lists – it will only take elements from the list when they are needed, so to read a file line by line, you could use:

```Raku
for $*IN.lines -> $line { .say }
```

迭代变量总是词法上的，所以你不需要用 `my` 。而且，它们是只读别名。如果你需要它们是可读写的，请使用 `<->` 而不是 `->` 。如果你需要在 `for` 循环中创建可读写的 `$_` 变量，请明确指明。

Iteration variables are always lexical, so you don't need to use `my` to give them the appropriate scope. Also, they are read-only aliases. If you need them to be read-write, use `<->` instead of `->`. If you need to make `$_` read-write in a for loop, do so explicitly.

```Raku
my @foo = 1..3;
for @foo <-> $_ { $_++ }
```

`for` 循环可以生成每个附加块运行产生的值列表。要捕获这些值，请将 `for` 循环放在括号中或将它们分配给数组：

A for loop can produce a `List` of the values produced by each run of the attached block. To capture these values, put the for loop in parenthesis or assign them to an array:

```Raku
(for 1, 2, 3 { $_ * 2 }).say;              # says "(2 4 6)" 
my @a = do for 1, 2, 3 { $_ * 2 }; @a.say; # says "[2 4 6]" 
my @b = (for 1, 2, 3 { $_ * 2 }); @a.say;  # same thing 
```

<a id="gathertake"></a>
# gather/take

gather 是一个返回值序列的语句或块前缀。这些值由 `gather` 代码块动态作用域中 `take` 返回。

`gather` is a statement or block prefix that returns a [sequence](https://docs.raku.org/type/Seq) of values. The values come from calls to [take](https://docs.raku.org/type/Mu#routine_take) in the dynamic scope of the `gather` block.

```Raku
my @a = gather {
    take 1;
    take 5;
    take 42;
}
say join ', ', @a;          # OUTPUT: «1, 5, 42
» 
```

`gather/take` 根据上下文惰性求值。如果你想强制惰性求值，使用 `lazy` 子程序或方法。绑定到一个标量或无符号的容器也会迫使惰性求值。

`gather/take` can generate values lazily, depending on context. If you want to force lazy evaluation use the [lazy](https://docs.raku.org/type/Iterable#method_lazy) subroutine or method. Binding to a scalar or sigilless container will also force laziness.

例如

For example

```Raku
my @vals = lazy gather {
    take 1;
    say "Produced a value";
    take 2;
}
say @vals[0];
say 'between consumption of two values';
say @vals[1];
 
# OUTPUT: 
# 1 
# between consumption of two values 
# Produced a value 
# 2 
```

`gather/take` 是动态作用域，所以你可以从 `gather` 中的函数或方法中调用 `take` 。

`gather/take` is scoped dynamically, so you can call `take` from subs or methods that are called from within `gather`:

```Raku
sub weird(@elems, :$direction = 'forward') {
    my %direction = (
        forward  => sub { take $_ for @elems },
        backward => sub { take $_ for @elems.reverse },
        random   => sub { take $_ for @elems.pick(*) },
    );
    return gather %direction{$direction}();
}
 
say weird(<a b c>, :direction<backward> );          # OUTPUT: «(c b a)
» 
```

如果值需要在调用方可改变，使用 [take-rw](https://docs.raku.org/type/Mu#routine_take-rw)。

If values need to be mutable on the caller side, use [take-rw](https://docs.raku.org/type/Mu#routine_take-rw).

<a id="given"></a>
# given

`given` 语句是 Raku 的主题化关键字，类似于 C 语言中 `switch` 的主题化功能。换句话说，`given` 设置了紧随其后代码块中 `$_` 的值。单个条件的关键词是 `when` 和 `default`。通常的习语看起来像这样：

The `given` statement is Raku's topicalizing keyword in a similar way that `switch` topicalizes in languages such as C. In other words, `given` sets `$_` inside the following block. The keywords for individual cases are `when` and `default`. The usual idiom looks like this:

```Raku
my $var = (Any, 21, any <answer lie>).pick;
given $var {
    when 21 { say $_ * 2 }
    when 'lie' { .say }
    default { say 'default' }
}
```

`given` 语句通常单独使用:

The `given` statement is often used alone:

```Raku
given 42 { .say; .Numeric; }
```

比这个可读性更强：

This is a lot more understandable than:

```Raku
{ .say; .Numeric; }(42)
```

<a id="default-and-when"></a>
## default and when

当 `default` 语句之后的子块离开时，包裹 `default` 语句的块将立即离开。就好像块中其余的语句被跳过了一样。

A block containing a `default` statement will be left immediately when the sub-block after the `default` statement is left. It is as though the rest of the statements in the block are skipped.

```Raku
given 42 {
    "This says".say;
    $_ == 42 and ( default { "This says, too".say; 43; } );
    "This never says".say;
}
# The above block evaluates to 43 
```

`when` 语句也可以这样做（但是 `when` 语句修饰符不会）。

A `when` statement will also do this (but a `when` statement modifier will *not*.)

另外，`when` 语句提供的表达式智能匹配主题（ `$_` ），因此可以检查主题的值，正则表达式和类型。

In addition, `when` statements `smartmatch` the topic (`$_`) against a supplied expression such that it is possible to check against values, regular expressions, and types when specifying a match.

```Raku
for 42, 43, "foo", 44, "bar" {
    when Int { .say }
    when /:i ^Bar/ { .say }
    default  { say "Not an Int or a Bar" }
}
# OUTPUT: «42
43
Not an Int or a Bar
44
Bar
» 
```

以这种形式，`given/when` 结构和 `if/elsif/else` 语句相似。请注意 `when` 语句的顺序。以下代码表示 `Int` 而不是 `42`。

In this form, the `given`/`when` construct acts much like a set of `if`/`elsif`/`else` statements. Be careful with the order of the `when` statements. The following code says `"Int"` not `42`.

```Raku
given 42 {
    when Int { say "Int" }
    when 42  { say 42 }
    default  { say "huh?" }
}
# OUTPUT: «Int
» 
```

当 `when` 语句或 `default` 语句导致外部块返回时，嵌套 `when` 或 `default` 块不会被视为外部块，因此你可以嵌套这些语句，并且只要你不新建代码块，仍然处于相同的“开关”中：

When a `when` statement or `default` statement causes the outer block to return, nesting `when` or `default` blocks do not count as the outer block, so you can nest these statements and still be in the same "switch" just so long as you do not open a new block:

```Raku
given 42 {
    when Int {
      when 42  { say 42 }
      say "Int"
    }
    default  { say "huh?" }
}
# OUTPUT: «42» 
```

`when` statements can smart match against [Signatures](https://docs.raku.org/language/syntax#Signature_literals).

<a id="proceed"></a>
## proceed

<a id="succeed"></a>
## succeed

`proceed` 和 `succeed` 都只能在 `when` 或者 `default` 代码块里使用。

Both `proceed` and `succeed` are meant to be used only from inside `when` or `default` blocks.

`proceed` 语句会立即离开 `when` 或者 `default` 代码块，跳过其余语句，并在块后继续。这样防止 `when` 或者 `default` 退出外部代码块。

The `proceed` statement will immediately leave the `when` or `default` block, skipping the rest of the statements, and resuming after the block. This prevents the `when` or `default` from exiting the outer block.

```Raku
given * {
    default {
        proceed;
        "This never says".say
    }
}
"This says".say;
```

这通常用于输入多个 `when` 块。`继续`将在成功匹配后恢复匹配，如下所示：

This is most often used to enter multiple `when` blocks. `proceed` will resume matching after a successful match, like so:

```Raku
given 42 {
    when Int   { say "Int"; proceed }
    when 42    { say 42 }
    when 40..* { say "greater than 40" }
    default    { say "huh?" }
}
# OUTPUT: «Int
» 
# OUTPUT: «42
» 
```

注意 `when 40..*` 匹配没有发生。为了使这种情况也匹配，需要在 `when 42` 块中有一个 `proceed`。

Note that the `when 40..*` match didn't occur. For this to match such cases as well, one would need a `proceed` in the `when 42` block.

这不像是 `C` 中的 `switch` 语句，因为 `proceed` 不只是直接进入下面的块，它试图再次匹配 `given` 值，请考虑此代码：

This is not like a `C` `switch` statement, because the `proceed` does not merely enter the directly following block, it attempts to match the `given` value once more, consider this code:

```Raku
given 42 {
    when Int { "Int".say; proceed }
    when 43  { 43.say }
    when 42  { 42.say }
    default  { "got change for an existential answer?".say }
}
# OUTPUT: «Int
» 
# OUTPUT: «42
» 
```

…匹配 `int`，跳过 `43`，因为值不匹配，匹配 `42`，因为这是下一个正匹配，但不进入 `default` 块，因为 `when 42` 块不包含 `proceed`。

...which matches the `Int`, skips `43` since the value doesn't match, matches `42` since this is the next positive match, but doesn't enter the `default` block since the `when 42` block doesn't contain a `proceed`.

相反，`succeed` 关键字会短路执行，并在该点退出整个 `given` 块。它还可能需要一个参数来指定块的最终值。

By contrast, the `succeed` keyword short-circuits execution and exits the entire `given` block at that point. It may also take an argument to specify a final value for the block.

```Raku
given 42 {
    when Int {
        say "Int";
        succeed "Found";
        say "never this!";
    }
    when 42 { say 42 }
    default { say "dunno?" }
}
# OUTPUT: «Int
» 
```

如果不在 when 或 default 块中，则尝试使用 `proceed` 或 `succeed` 是一个错误。还请记住，`when` 语句修饰符形式不会导致任何块被留下，并且此类语句中的任何 `succeed` 或 `proceed` 都适用于周围的子句（如果有）：

If you are not inside a when or default block, it is an error to try to use `proceed` or `succeed`. Also remember, the `when` statement modifier form does not cause any blocks to be left, and any `succeed` or `proceed` in such a statement applies to the surrounding clause, if there is one:

```Raku
given 42 {
    { say "This says" } when Int;
    "This says too".say;
    when * > 41 {
       { "And this says".say; proceed } when * > 41;
       "This never says".say;
    }
    "This also says".say;
}
```

<a id="given-%E4%BD%9C%E4%B8%BA%E8%AF%AD%E5%8F%A5--given-as-a-statement"></a>
## given 作为语句 / given as a statement

`given` 可以跟在一个语句后面，以在它后面的语句中设置主题。

`given` can follow a statement to set the topic in the statement it follows.

```Raku
.say given "foo";
# OUTPUT: «foo
» 
 
printf "%s %02i.%02i.%i",
        <Mo Tu We Th Fr Sa Su>[.day-of-week - 1],
        .day,
        .month,
        .year
    given DateTime.now;
# OUTPUT: «Sa 03.06.2016» 
```

<a id="loop"></a>
# loop

`loop` 语句接收三个被`分号`分隔的语句，它们扮演初始化器，条件和增量器。初始化程序执行一次，任何变量声明都将溢出到周围的块中。每次迭代执行一次条件并强制转换为 `Bool`，如果 `False` 则循环停止。每次迭代执行一次增量器。

The `loop` statement takes three statements in parentheses separated by `;` that take the role of initializer, conditional and incrementer. The initializer is executed once and any variable declaration will spill into the surrounding block. The conditional is executed once per iteration and coerced to `Bool`, if `False` the loop is stopped. The incrementer is executed once per iteration.

```Raku
loop (my $i = 0; $i < 10; $i++) {
    say $i;
}
```

无限循环不需要括号。

The infinite loop does not require parentheses.

```Raku
loop { say 'forever' }
```

如果出现在列表中，`loop` 语句可用于从附加块的每次运行结果中生成值：

The `loop` statement may be used to produce values from the result of each run of the attached block if it appears in lists:

```Raku
(loop ( my $i = 0; $i++ < 3;) { $i * 2 }).say;               # OUTPUT: «(2 4 6)
» 
my @a = (loop ( my $j = 0; $j++ < 3;) { $j * 2 }); @a.say;   # OUTPUT: «[2 4 6]
» 
my @b = do loop ( my $k = 0; $k++ < 3;) { $k * 2 }; @b.say;  # same thing 
```

与 `for` 循环不同，目前不应该依赖于返回值是否惰性生成。最好使用 `eager` 来保证返回值可能要使用的循环会实际运行：

Unlike a `for` loop, one should not rely on whether returned values are produced lazily, for now. It would probably be best to use `eager` to guarantee that a loop whose return value may be used actually runs:

```Raku
sub heads-in-a-row {
    (eager loop (; 2.rand < 1;) { "heads".say })
}
```

<a id="while-until"></a>
# while, until

只要条件为真，`while` 语句就会执行该代码块。所以

The `while` statement executes the block as long as its condition is true. So

```Raku
my $x = 1;
while $x < 4 {
    print $x++;
}
print "\n";
 
# OUTPUT: «123
» 
```

类似地，只要表达式为假，`until` 语句就会执行该块。

Similarly, the `until` statement executes the block as long as the expression is false.

```Raku
my $x = 1;
until $x > 3 {
    print $x++;
}
print "\n";
 
# OUTPUT: «123
» 
```

 `while` 或 `until` 的条件可以用括号括起来，但是在关键字和条件的左括号之间必须有一个空格。

The condition for `while` or `until` can be parenthesized, but there must be a space between the keyword and the opening parenthesis of the condition.

`while` 和 `until` 都可以用作语句修饰符。例如：

Both `while` and `until` can be used as statement modifiers. E. g.

```Raku
my $x = 42;
$x-- while $x > 12
```

另请参阅下面的 `repeat/while` 和 `repeat/until`。

Also see `repeat/while` and `repeat/until` below.

所有这些形式都可以像 `loop` 一样产生返回值。

All these forms may produce a return value the same way `loop` does.

<a id="repeatwhile-repeatuntil"></a>
# repeat/while, repeat/until

执行代码块*至少一次*，如果条件允许，则重复执行。这与 `while`/`until` 的不同之处在于条件在循环结束时进行评估，即使它出现在前面。

Executes the block *at least once* and, if the condition allows, repeats that execution. This differs from `while`/`until` in that the condition is evaluated at the end of the loop, even if it appears at the front.

```Raku
my $x = -42;
repeat {
    $x++;
} while $x < 5;
$x.say; # OUTPUT: «5
» 
 
repeat {
    $x++;
} while $x < 5;
$x.say; # OUTPUT: «6
» 
 
repeat while $x < 10 {
    $x++;
}
$x.say; # OUTPUT: «10
» 
 
repeat while $x < 10 {
    $x++;
}
$x.say; # OUTPUT: «11
» 
 
repeat {
    $x++;
} until $x >= 15;
$x.say; # OUTPUT: «15
» 
 
repeat {
    $x++;
} until $x >= 15;
$x.say; # OUTPUT: «16
» 
 
repeat until $x >= 20 {
    $x++;
}
$x.say; # OUTPUT: «20
» 
 
repeat until $x >= 20 {
    $x++;
}
$x.say; # OUTPUT: «21
» 
```

所有这些形式都可以像 `loop` 一样产生返回值。

All these forms may produce a return value the same way `loop` does.

<a id="return"></a>
# return

`return` 将停止执行子程序或方法，运行所有相关的[阶段](https://docs.raku.org/language/phasers#Block_Phasers) 并向调用者提供给定的返回值。默认返回值为 `Nil`。如果提供了返回[类型约束](https://docs.raku.org/type/Signature#Constraining_Return_Types) ，则将检查它，除非返回值为 `Nil`。如果类型检查失败，则抛出异常 [X::TypeCheck::Return](https://docs.raku.org/type/X::TypeCheck::Return)。如果它通过了类型检查，则引发`控制`异常并可以使用 [CONTROL](https://docs.raku.org/language/phasers#CONTROL) 捕获。

The sub `return` will stop execution of a subroutine or method, run all relevant [phasers](https://docs.raku.org/language/phasers#Block_Phasers) and provide the given return value to the caller. The default return value is `Nil`. If a return [type constraint](https://docs.raku.org/type/Signature#Constraining_Return_Types) is provided it will be checked unless the return value is `Nil`. If the type check fails the exception [X::TypeCheck::Return](https://docs.raku.org/type/X::TypeCheck::Return) is thrown. If it passes a control exception is raised and can be caught with [CONTROL](https://docs.raku.org/language/phasers#CONTROL).

块中的任何 `return` 都与该块的外部词法范围中的第一个`例程`相关联，无论嵌套有多深。请注意，根包中的 `return` 将在运行时失败。在惰性代码块中的 `return`（例如在 `map` 内部）可能发现在执行块时外部词法例程已经消失。几乎在任何情况下， `last` 都是更好的选择。

Any `return` in a block is tied to the first `Routine` in the outer lexical scope of that block, no matter how deeply nested. Please note that a `return` in the root of a package will fail at runtime. A `return` in a block that is evaluated lazily (e.g. inside `map`) may find the outer lexical routine gone by the time the block is executed. In almost any case `last` is the better alternative.

<a id="return-rw"></a>
# return-rw

`return` 将返回值，而不是容器。这些是不可变的，并且在尝试变异时会导致运行时错误。

The sub `return` will return values, not containers. Those are immutable and will lead to runtime errors when attempted to be mutated.

```Raku
sub s(){ my $a = 41; return $a };
say ++s();
CATCH { default { say .^name, ': ', .Str } };
# OUTPUT: «X::Multi::NoMatch.new(dispatcher … 
```

要返回一个可变容器，请使用 `return-rw`。

To return a mutable container, use `return-rw`.

```Raku
sub s(){ my $a = 41; return-rw $a };
say ++s();
# OUTPUT: «42
» 
```

The same rules as for `return` regarding phasers and control exceptions apply.

<a id="fail"></a>
# fail

离开当前例程并返回提供的 [Exception](https://docs.raku.org/type/Exception) 或包含在 [Failure](https://docs.raku.org/type/Failure) 中的 `Str`，执行所有相关的[阶段](https://docs.raku.org/language/phasers#Block_Phasers)之后。如果调用者通过编译指示 `use fatal;` 激活了致命异常，则抛出异常而不是作为 `Failure` 返回。

Leaves the current routine and returns the provided [Exception](https://docs.raku.org/type/Exception) or `Str` wrapped inside a [Failure](https://docs.raku.org/type/Failure), after all relevant [phasers](https://docs.raku.org/language/phasers#Block_Phasers)are executed. If the caller activated fatal exceptions via the pragma `use fatal;`, the exception is thrown instead of being returned as a `Failure`.

```Raku
sub f { fail "WELP!" };
say f;
CATCH { default { say .^name, ': ', .Str } }
# OUTPUT: «X::AdHoc: WELP!
» 
```

<a id="once"></a>
# once

带有 `once` 的代码块前缀只执行一次，即使放在循环或递归例程中也是如此。

A block prefix with `once` will be executed exactly once, even if placed inside a loop or a recursive routine.

```Raku
my $guard = 3;
loop {
    last if $guard-- <= 0;
    once { put 'once' };
    print 'many'
} # OUTPUT: «once
manymanymany» 
```

这适用于包含代码对象的每个“克隆”，因此：

This works per "clone" of the containing code object, so:

```Raku
({ once 42.say } xx 3).map: {$_(), $_()}; # says 42 thrice 
```

请注意，当多个线程运行同一块的同一个克隆时，这不是一个线程安全的构造。还要记住，方法每个类只有一个克隆，而不是每个对象。

Note that this is **not** a thread-safe construct when the same clone of the same block is run by multiple threads. Also remember that methods only have one clone per class, not per object.

<a id="quietly"></a>
# quietly

`安静的`代码块会抑制警告。

A `quietly` block will suppress warnings.

```Raku
quietly { warn 'kaput!' };
warn 'still kaput!';
# OUTPUT: «still kaput! [...]
» 
```

<a id="%E6%A0%87%E7%AD%BE--labels"></a>
# 标签 / LABELs

`while`, `until`, `loop` and `for` loops can all take a label, which can be used to identify them for `next`, `last`, and `redo`. Nested loops are supported, for instance:

```Raku
OUTAHERE: while True  {
    for 1,2,3 -> $n {
        last OUTAHERE if $n == 2;
    }
}
```

标签也可以在嵌套循环中用于命名每个循环，例如：

Labels can be used also within nested loops to name each loop, for instance:

```Raku
OUTAHERE:
loop ( my $i = 1; True; $i++ ) {
  OUTFOR:
    for 1,2,3 -> $n {
      # exits the for loop before its natural end 
      last OUTFOR if $n == 2;
  }
 
  # exits the infinite loop 
  last OUTAHERE if $i >= 2;
}
```

<a id="next"></a>
# next

`next` 命令启动循环的下一次迭代。所以代码

The `next` command starts the next iteration of the loop. So the code

```Raku
my @x = 1, 2, 3, 4, 5;
for @x -> $x {
    next if $x == 3;
    print $x;
}
```

输出 “1245”。

prints "1245".

<a id="last"></a>
# last

`last`命令立即退出有问题的循环。

The `last` command immediately exits the loop in question.

```Raku
my @x = 1, 2, 3, 4, 5;
for @x -> $x {
    last if $x == 3;
    print $x;
}
```

输出 “12”。

prints "12".

<a id="redo"></a>
# redo

`redo` 命令重新开始循环块而不再评估条件。

The `redo` command restarts the loop block without evaluating the conditional again.

```Raku
loop {
    my $x = prompt("Enter a number");
    redo unless $x ~~ /\d+/;
    last;
}
```