原文：https://docs.raku.org/language/iterating

# 迭代 / Iterating

可用于访问复杂数据结构中的所有项的功能

Functionalities available for visiting all items in a complex data structure

<!-- MarkdownTOC -->

- [`Iterator` 和 `Iterable` 角色 / The `Iterator` and `Iterable` roles](#iterator-%E5%92%8C-iterable-%E8%A7%92%E8%89%B2--the-iterator-and-iterable-roles)
- [如何迭代：上下文化和主题变量 / How to iterate: contextualizing and topic variables](#%E5%A6%82%E4%BD%95%E8%BF%AD%E4%BB%A3%EF%BC%9A%E4%B8%8A%E4%B8%8B%E6%96%87%E5%8C%96%E5%92%8C%E4%B8%BB%E9%A2%98%E5%8F%98%E9%87%8F--how-to-iterate-contextualizing-and-topic-variables)
- [“经典循环”以及为什么我们不喜欢它们 / `Classic` loops and why we do not like them](#%E2%80%9C%E7%BB%8F%E5%85%B8%E5%BE%AA%E7%8E%AF%E2%80%9D%E4%BB%A5%E5%8F%8A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%88%91%E4%BB%AC%E4%B8%8D%E5%96%9C%E6%AC%A2%E5%AE%83%E4%BB%AC--classic-loops-and-why-we-do-not-like-them)

<!-- /MarkdownTOC -->

<a id="iterator-%E5%92%8C-iterable-%E8%A7%92%E8%89%B2--the-iterator-and-iterable-roles"></a>
# `Iterator` 和 `Iterable` 角色 / The `Iterator` and `Iterable` roles

Raku 是一种函数式语言，但是函数在处理复杂的数据结构时需要保留一些东西。特别是，它们需要一个可以以相同方式应用于所有数据结构的统一接口。其中一种接口是由 [Iterator](https://docs.raku.org/type/Iterator) 和 [Iterable](https://docs.raku.org/type/Iterable) 角色提供的。

Raku is a functional language, but functions need something to hold on to when working on complex data structures. In particular, they need a uniform interface that can be applied to all data structures in the same way. One of these kind of interfaces is provided by the [Iterator](https://docs.raku.org/type/Iterator) and [Iterable](https://docs.raku.org/type/Iterable) roles.

`Iterable` 角色相对简单。它为 `iterator` 方法提供了一个存根方法，该方法是诸如 `for` 等语句实际使用的方法。`for` 将对它前面的变量调用 `.iterator`，然后对每个项运行一次块。其他方法，如数组分配，将使 `Iterable` 类以相同的方式运行。

The `Iterable` role is relatively simple. It provides a stub for the `iterator` method, which is the one actually used by statements such as `for`. `for` will call `.iterator` on the variable it precedes, and then run a block once for every item. Other methods, such as array assignment, will make the `Iterable` class behave in the same way.

```Raku
class DNA does Iterable {
    has $.chain;
    method new ($chain where {
                       $chain ~~ /^^ <[ACGT]>+ $$ / and
                       $chain.chars %% 3 } ) {
        self.bless( :$chain );
    }
 
    method iterator(DNA:D:){ $.chain.comb.rotor(3).iterator }
};
 
my @longer-chain =  DNA.new('ACGTACGTT');
say @longer-chain.perl;
# OUTPUT: «[("A", "C", "G"), ("T", "A", "C"), ("G", "T", "T")]␤» 
 
say  @longer-chain».join("").join("|"); #OUTPUT: «ACG|TAC|GTT␤» 
```

在此示例中，这是 [`Iterable`](https://docs.raku.org/type/Iterable) 示例的扩展，它显示了 `for` 如何调用，仅当创建的对象被分配给[位置](https://docs.raku.org/type/Positional)变量 `@longer-chain` 时，才会在相应的上下文中调用“迭代器”方法，该变量是一个 [Array](https://docs.raku.org/type/Array)，并且我们在上一个示例中对其进行操作。

In this example, which is an extension of the [example in `Iterable` that shows how `for` calls `.iterator`](https://docs.raku.org/type/Iterable), the `iterator` method will be called in the appropriate context only when the created object is assigned to a [Positional](https://docs.raku.org/type/Positional) variable, `@longer-chain`; this variable is an [Array](https://docs.raku.org/type/Array) and we operate on it as such in the last example.

`Iterator` 角色（可能有点让人费解）比 `Iterable` 要复杂一些。首先，它提供了一个常数 `IterationEnd`。然后，它还提供了一系列的[方法](https://docs.raku.org/type/Iterator#Methods)，如 `.pull-one`，它允许在多个上下文中进行更精细的迭代操作：添加或移除项，或跳过它们以访问其他项。实际上，角色为所有其他方法提供了默认的实现，因此唯一需要定义的方法就是 `pull-one`，角色只提供其中的存根。`Iterable` 提供高级接口循环，而 `Iterator` 提供在循环的每一次迭代中调用的低级函数。让我们用这个角色扩展前面的示例。

The (maybe a bit confusingly named) `Iterator` role is a bit more complex than `Iterable`. First, it provides a constant, `IterationEnd`. Then, it also provides a series of [methods](https://docs.raku.org/type/Iterator#Methods) such as `.pull-one`, which allows for a finer operation of iteration in several contexts: adding or eliminating items, or skipping over them to access other items. In fact, the role provides a default implementation for all the other methods, so the only one that has to be defined is precisely `pull-one`, of which only a stub is provided by the role. While `Iterable` provides the high-level interface loops will be working with, `Iterator` provides the lower-level functions that will be called in every iteration of the loop. Let's extend the previous example with this role.

```Raku
class DNA does Iterable does Iterator {
    has $.chain;
    has Int $!index = 0;
 
    method new ($chain where {
                       $chain ~~ /^^ <[ACGT]>+ $$ / and
                       $chain.chars %% 3 } ) {
        self.bless( :$chain );
    }
 
    method iterator( ){ self }
    method pull-one( --> Mu){
        if $!index < $.chain.chars {
            my $codon = $.chain.comb.rotor(3)[$!index div 3];
            $!index += 3;
            return $codon;
        } else {
            return IterationEnd;
        }
    }
};
 
my $a := DNA.new('GAATCC');
.say for $a; # OUTPUT: «(G A A)␤(T C C)␤» 
```

我们声明一个 `DNA` 类，它执行两个角色，`Iterator` 和 `Iterable`；该类将包含一个字符串，该字符串的长度将被限制为 3 的倍数，并且仅由 ACGT 组成。

We declare a `DNA` class which does the two roles, `Iterator` and `Iterable`; the class will include a string that will be constrained to have a length that is a multiple of 3 and composed only of ACGT.

让我们看看 `pull-one` 的方法。每次发生新的迭代时，都会调用这个值，所以它必须保持最后一个迭代的状态。一个 `$.index` 属性将跨调用保持该状态；`pull-one` 将检查是否已到达链的末尾，并将返回角色提供的 `IterationEnd` 常量。实际上，实现这个低级接口简化了 `Iterable` 接口的实现。现在迭代器将是对象本身，因为我们可以在它上调用 `pull-one` 来依次访问每个成员；`.iterator` 因此只返回 `self`；这是可能的，因为该对象同时是 `Iterable` 和 `Iterator`。

Let us look at the `pull-one` method. This one is going to be called every time a new iteration occurs, so it must keep the state of the last one. An `$.index` attribute will hold that state across invocations; `pull-one` will check if the end of the chain has been reached and will return the `IterationEnd` constant provided by the role. Implementing this low-level interface, in fact, simplifies the implementation of the `Iterable` interface. Now the iterator will be the object itself, since we can call `pull-one` on it to access every member in turn; `.iterator` will thus return just `self`; this is possible since the object will be, at the same time, `Iterable` and `Iterator`.

这不一定总是这样，在大多数情况下，`.iterator` 必须构建要返回的迭代器类型（例如，它将跟踪迭代状态，我们现在在主类中所做的），就像我们在前面的示例中所做的那样；然而，这个示例显示了构建一个类来实现迭代器和可迭代角色所需的最小代码。

This need not always be the case, and in most cases `.iterator` will have to build an iterator type to be returned (that will, for instance, keep track of the iteration state, which we are doing now in the main class), such as we did in the previous example; however, this example shows the minimal code needed to build a class that fulfills the iterator and iterable roles.

<a id="%E5%A6%82%E4%BD%95%E8%BF%AD%E4%BB%A3%EF%BC%9A%E4%B8%8A%E4%B8%8B%E6%96%87%E5%8C%96%E5%92%8C%E4%B8%BB%E9%A2%98%E5%8F%98%E9%87%8F--how-to-iterate-contextualizing-and-topic-variables"></a>
# 如何迭代：上下文化和主题变量 / How to iterate: contextualizing and topic variables

`for` 和其他循环将每次迭代中产生的项放入[主题变量 `$_`](https://docs.raku.org/language/variables#index-entry-topic_variable)，或将它们捕获到与块一起声明的变量中。这些变量可以直接在循环中使用，而不需要声明它们，方法是使用 [`^` twigil](https://docs.raku.org/syntax/$CIRCUMFLEX_ACCENT#(Traps_to_avoid)_twigil_^)。

`for` and other loops place the item produced in every iteration into the [topic variable `$_`](https://docs.raku.org/language/variables#index-entry-topic_variable), or capture them into the variables that are declared along with the block. These variables can be directly used inside the loop, without needing to declare them, by using the [`^` twigil](https://docs.raku.org/syntax/$CIRCUMFLEX_ACCENT#(Traps_to_avoid)_twigil_^).

使用[序列运算符](https://docs.raku.org/language/operators#index-entry-..._operators)时发生隐式迭代

Implicit iteration occurs when using the [sequence operator](https://docs.raku.org/language/operators#index-entry-..._operators).

```Raku
say 1,1,1, { $^a²+2*$^b+$^c } … * > 300; # OUTPUT: «(1 1 1 4 7 16 46 127 475)
```

生成块只运行一次，而不满足完成序列的条件，在这种情况下，条件大于 300。这有运行循环的副作用，但也会创建一个输出列表。

The generating block is being run once while the condition to finish the sequence, in this case the term being bigger than 300, is not met. This has the side effect of running a loop, but also creating a list that is output.

这可以通过使用 [`gather/take` 代码块](https://docs.raku.org/syntax/gather%20take)来更系统地完成，这些代码块是一种不同类型的迭代构造，而不是在 sink 上下文中运行，每次迭代返回一个项目。[Advent Calendar tutorial](https://perl6advent.wordpress.com/2009/12/23/day-23-lazy-fruits-from-the-gather-of-eden/) 解释了这种循环的用例；事实上，gather 不是这样的循环构造，而是一个语句前缀，它收集 `take` 所生成的项，并从它们中创建一个列表。

This can be done more systematically through the use of the [`gather/take` blocks](https://docs.raku.org/syntax/gather%20take), which are a different kind of iterating construct that instead of running in sink context, returns an item every iteration. This [Advent Calendar tutorial](https://perl6advent.wordpress.com/2009/12/23/day-23-lazy-fruits-from-the-gather-of-eden/) explains use cases for this kind of loops; in fact, gather is not so much a looping construct, but a statement prefix that collects the items produced by `take` and creates a list out of them.

<a id="%E2%80%9C%E7%BB%8F%E5%85%B8%E5%BE%AA%E7%8E%AF%E2%80%9D%E4%BB%A5%E5%8F%8A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%88%91%E4%BB%AC%E4%B8%8D%E5%96%9C%E6%AC%A2%E5%AE%83%E4%BB%AC--classic-loops-and-why-we-do-not-like-them"></a>
# “经典循环”以及为什么我们不喜欢它们 / `Classic` loops and why we do not like them

典型的 `for` 循环，循环变量递增，在 Raku 中可以通过 [`loop` 关键字](https://docs.raku.org/language/control#loop)完成。还可以使用其他 [repeat](https://docs.raku.org/language/control#repeat/while,_repeat/until) 和 [while](https://docs.raku.org/language/control#while,_until) 循环。

Classic `for` loops, with a loop variable being incremented, can be done in Raku through the [`loop` keyword](https://docs.raku.org/language/control#loop). Other [repeat](https://docs.raku.org/language/control#repeat/while,_repeat/until) and [while](https://docs.raku.org/language/control#while,_until) loops are also possible.

然而，总的来说，他们是不受欢迎的。Raku 是一种功能和并发语言；在用 Raku 编写代码时，你应该以一种功能的方式查看循环：一个接一个地处理迭代器产生的项，也就是说，将一个项输入一个块，而不产生任何次要效果。此功能视图还允许通过 [`hyper`](https://docs.raku.org/routine/hyper)或 [`race`](https://docs.raku.org/routine/race) 自动线程方法对操作进行简单的并行化。

However, in general, they are discouraged. Raku is a functional and concurrent language; when coding in Raku, you should look at loops in a functional way: processing, one by one, the items produced by an iterator, that is, feeding an item to a block without any kind of secondary effects. This functional view allows also easy parallelization of the operation via the [`hyper`](https://docs.raku.org/routine/hyper) or [`race`](https://docs.raku.org/routine/race) auto-threading methods.

如果你对你的好的旧循环感到更舒服，语言允许你使用它们。但是，只要有可能，尝试并使用函数和并发迭代结构会被认为是更多的 *p6y*。

If you feel more comfortable with your good old loops, the language allows you to use them. However, it is considered more *p6y* to try and use, whenever possible, functional and concurrent iterating constructs.

*注意：*因为 6.d 版本循环可以从最后一个语句的值中生成一个值列表。

*Note:* Since version 6.d loops can produce a list of values from the values of last statements.
