原文：https://rakudocs.github.io/language/statement-prefixes

# 语句前缀 / Statement prefixes

更改语句或一组语句的行为的前缀

Prefixes that alter the behavior of a statement or a set of them

语句前缀是在语句前面编写的，并更改它们的含义、输出或将运行的时间。由于它们有特定的行为，它们有时也是特定于某些语句或一组语句的。

Statement prefixes are written in front of a statement, and change their meaning, their output, or the moment they are going to be run. Since they have a specific behavior, they are also sometimes specific to some statement or group of statements.

<!-- MarkdownTOC -->

- [`lazy`](#lazy)
- [`eager`](#eager)
- [`hyper`, `race`](#hyper-race)
- [`quietly`](#quietly)
- [`try`](#try)
- [`do`](#do)
- [`sink`](#sink)
- [`once`](#once)
- [`gather`](#gather)
- [`start`](#start)
- [`react`](#react)
- [`supply`](#supply)

<!-- /MarkdownTOC -->

<a id="lazy"></a>
## `lazy`

作为语句前缀，`lazy` 在任何语句(包括 `for` 循环)前面活动，将执行保存到实际需要分配给它们的变量时。

As a statement prefix, `lazy` acts in front of any statement, including `for` loops, saving the execution for when the variable they are assigned to is actually needed.

```Raku
my $incremented = 0;
my $var = lazy for <1 2 3 4> -> $d {
    $incremented++
};
say $incremented; # OUTPUT: «0␤» 
say eager $var;   # OUTPUT: «(0 1 2 3)␤» 
say $incremented; # OUTPUT: «4␤» 
```

`$incremented` 变量只会递增，也就是说，只有当我们急切地计算包含延迟循环的变量 `$var` 时，循环的内部部分才会运行。急切可以用其他方式应用于变量，例如调用它的 `.eager` 方法。

The `$incremented` variable is only incremented, that is, the internal part of the loop is only run when we eagerly evaluate the variable `$var` that contains the lazy loop. Eagerness can be applied on a variable in other ways, such as calling the `.eager` method on it.

```Raku
my @array = lazy { (^3).map( *² )  };
say @array;       # OUTPUT: «[...]» 
say @array.eager; # OUTPUT: «[0 1 4]␤» 
```

这个前缀也可以被使用[在 `gather` 前面](https://rakudocs.github.io/language/control#gather/take)来使内部语句惰性求值；通常，任何返回值的语句都会使用这个前缀来延迟操作。

This prefix can also be used [in front of `gather`](https://rakudocs.github.io/language/control#gather/take) to make the inner statements behave lazily; in general, any set of statements that returns a value will be made lazy using this.

<a id="eager"></a>
## `eager`

`eager` 语句前缀将急切地返回后面语句的结果，抛弃懒惰，并返回结果。

The `eager` statement prefix will eagerly return the result of the statements behind, throwing away laziness and returning the result.

```Raku
my $result := eager gather { for 1..3 { say "Hey"; take $_² } };
say $result[0]; # OUTPUT: «Hey␤Hey␤Hey␤1␤» 
```

`gather` 是[绑定到标量时隐含的懒惰](https://rakudocs.github.io/syntax/gather%20take)。但是，如果使用 `eager` 作为语句前缀，它将运行循环中的所有三个迭代，如打印的 "Hey" 所示，即使我们只是连续请求第一个迭代。

`gather` is [implicitly lazy when bound to a scalar](https://rakudocs.github.io/syntax/gather%20take). However, with `eager` as a statement prefix it will run all three iterations in the loop, as shown by the printed "Hey", even if we are just requesting the first one in a row.

<a id="hyper-race"></a>
## `hyper`, `race`

`hyper` 和 `race` 使用（可能同时）线程在循环中运行不同的迭代：

`hyper` and `race` use (maybe simultaneous) threads to run different iterations in a loop:

```Raku
my @a = hyper for ^100_000 { .is-prime }
```

这个代码比裸跑快 3 倍左右。但这里有几个警告：

This code is around 3x faster than the bare for. But there are a couple of caveats here:

- 循环内的操作应花费足够的时间进行线程处理才有意义。
- 不应在循环内读取或写入相同的数据结构。让循环产生一个结果，并赋值给它。
- 如果循环中有 I/O 操作，可能会有一些竞争，所以请避免。

- The operation inside the loop should take enough time for threading to make sense.
- There should be no read or write access to the same data structure inside the loop. Let the loop produce a result, and assign it.
- If there's an I/O operation inside the loop, there might be some contention so please avoid it.

`hyper` 和 `race` 的主要区别是结果的顺序。如果您需要按顺序生成循环结果，则使用 `hyper`，如果您不关心，则使用 `race`。

Main difference between `hyper` and `race` is the ordering of results. Use `hyper` if you need the loop results to be produced in order, `race` if you don't care.

<a id="quietly"></a>
## `quietly`

作为语句前缀，`quietly` 抑制它前面的语句产生的所有警告。

As a statement prefix, `quietly` suppresses all warnings produced by the statement it precedes.

```Raku
sub marine() {};
quietly say ~&marine; # OUTPUT: «marine␤» 
```

对 [`code` 调用 `.Str` 产生告警](https://rakudocs.github.io/type/Code#method_Str)。在语句之前使用 `quietly` 没有告警只产生输出，即例程的名字。

Calling [`.Str` on `code` produces a warning](https://rakudocs.github.io/type/Code#method_Str). Preceding the statement with `quietly` will just produce the output, the name of the routine.

<a id="try"></a>
## `try`

如果在语句前面使用 `try`，它将包含其中产生的异常，并将其存储在 `$!` 变量中，就像[在块前面使用它](https://rakudocs.github.io/language/language/exceptions#try_blocks)一样。

If you use `try` in front of a statement, it will contain the exception produced in it and store it in the `$!` variable, just like when [it's used in front of a block](https://rakudocs.github.io/language/language/exceptions#try_blocks).

```Raku
try [].pop;
say $!; # OUTPUT: «Cannot pop from an empty Array␤..» 
```

<a id="do"></a>
## `do`

`do` 可用作语句前缀，以消除它们前面的语句的歧义；例如，如果要将 `for` 语句的结果赋值给其他变量，则需要这样做。一个光秃秃的 `for` 会失败，但这会奏效：

`do` can be used as an statement prefix to disambiguate the statement they precede; this is needed, for instance, if you want to assign the result of a `for` statement. A bare `for` will fail, but this will work:

```Raku
my $counter = 0;
my $result = do for ^5 { $counter++ };
say $counter; # OUTPUT: «5␤» 
say $result;  # OUTPUT: «(0 1 2 3 4)␤» 
```

`do` 与其他情况一样，等同于用圆括号围绕语句。它可以作为一种(可能更直截了当的)语法的替代。

`do` is equivalent, as in other cases, to surrounding a statement with a parenthesis. It can be used as an alternative with a (possibly more) straightforward syntax.

<a id="sink"></a>
## `sink`

与[例程的情况](https://rakudocs.github.io/routine/sink)一样，`sink` 将语句的运行结果扔掉。当你想要的是语句的副作用，使用它。

As in the [case of the routine](https://rakudocs.github.io/routine/sink), `sink` will run the statement throwing away the result. Use it in case you want to run some statement for the side effects it produces.

```Raku
my $counter = 0;
my $result = sink for ^5 { $counter++ };
say $counter; #  OUTPUT: «5␤» 
say $result;  #  OUTPUT: «(Any)␤» 
```

<a id="once"></a>
## `once`

在循环中，只运行一次前缀语句。

Within a loop, runs the prefixed statement only once.

```Raku
my $counter;
my $result = do for ^5 { once $counter = 0; $counter++ };
say $result; # OUTPUT: «(0 1 2 3 4)␤» 
```

<a id="gather"></a>
## `gather`

`gather` 可在语句前面使用，在列表中接收和收集从该语句发出的 `take` 中发出的所有数据结构：

`gather` can be used in front of a statement, receiving and gathering in a list all data structures emitted from a `take` run anywhere from that statement:

```Raku
proto sub fact( Int ) {*}
multi sub fact( 1 --> 1 ) {}
multi sub fact( $x ) { take $x * fact( $x-1 ) }
 
my @factors = gather say fact(13); # OUTPUT: «6227020800» 
say @factors;
# OUTPUT: «[2 6 24 120 720 5040 40320 362880 3628800 ...]» 
```

在这个例子中，`gather` 在 `say` 之前，它打印了阶乘的第一个结果；同时，它从对 `fact` 的每次调用中获取结果，后者转到 `@factor`。

In this example, `gather` precedes `say`, which prints the first result of the factorial; at the same time, it's harvesting the result from every call to `fact`, which goes to `@factor`.

<a id="start"></a>
## `start`

作为语句前缀，`start` 以与[在块前面](https://rakudocs.github.io/language/control#flow%29_start)相同的方式运行，也就是说，它以异步方式运行语句，并返回一个 promise。

As a statement prefix, `start` behaves in the same way as [in front of a block](https://rakudocs.github.io/language/control#flow%29_start), that is, it runs the statement asynchronously, and returns a promise.

```Raku
proto sub fact( Int ) {*}
multi sub fact( 1 --> 1 ) {}
multi sub fact( $x ) {  $x * fact( $x-1 ) }
 
my @promises = gather {
    for <3 4> {
        take start fact( 10 ** $_ );
    }
}
 
say await @promises;
```

start 创建的 [`Promise`](https://rakudocs.github.io/type/Promise) 被收集到一个数组中，该数组在 promise 完成后返回操作的结果。

The [`Promise`s](https://rakudocs.github.io/type/Promise) created by start are gathered in an array, which returns the result of the operation once the promises have been fulfilled.

<a id="react"></a>
## `react`

`react` 可以在并发程序中使用，用来创建代码块，以便在发生某些事件时运行。它[与块一起工作](https://rakudocs.github.io/syntax/react)，同时也用作语句前缀。

`react` can be used in concurrent programs to create blocks of code that run whenever some event occurs. It [works with blocks](https://rakudocs.github.io/syntax/react), and also as a statement prefix.

```Raku
my Channel $KXGA .= new;
for ^100 {
    $KXGA.send( (100000..200000).pick );
}
 
my @sums = ( start react whenever $KXGA -> $number {
    say "In thread ", $*THREAD.id;
    say "→ ", (^$number).sum;
} ) for ^10;
 
start { sleep 10; $KXGA.close(); }
 
await @sums;
```

在这种情况下，`whenever` 前缀是 `react`，这使得从一个通道读取的每一个数字都有一个长和。

In this case `react` prefixes `whenever`, which makes a long sum with every number read from a channel.

<a id="supply"></a>
## `supply`

关键字 `supply` 可以创建[按需 supply](https://rakudocs.github.io/language/concurrency#index-entry-supply_(on-demand))。它与 `emit` 成对工作，它可以在 `supply` 前缀语句中的任何地方使用。

The keyword `supply` creates [on-demand supplies](https://rakudocs.github.io/language/concurrency#index-entry-supply_(on-demand)) that you can tap. It pairs with `emit`, which can be used anywhere from within a `supply` prefixed statement.

```Raku
my &cards = ->  {
    my @cards = 1..10 X~ <♠ ♥ ♦ ♣>;
    emit($_) for @cards.pick(@cards.elems);
}
my $supply = supply cards;
 
$supply.tap( -> $v { say "Drawing: $v" });
$supply.tap( -> $v { say "Drawing: $v" }, done => { say "No more cards" });
# OUTPUT: 
# ...
# Drawing: 1♥ 
# Drawing: 7♥ 
# Drawing: 9♥ 
# No more cards 
```

在本例中，`supply` 充当先前定义的 `cards` 例程的前缀。它很可能被定义为一个块，但是在这种情况下给它取一个名称可能会增加可读性，或者简单地将定义它的责任交给其他模块。

In this example, `supply` acts as prefix of the previously defined `cards` routine. It would very well be defined as a block, but giving it a name in this case might increase legibility or simply give the responsibility of defining it to other module.
