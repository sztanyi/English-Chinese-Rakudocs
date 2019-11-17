原文：https://docs.raku.org/language/iterating

# 迭代 / Iterating

可用于访问复杂数据结构中的所有项的功能

Functionalities available for visiting all items in a complex data structure

# `Iterator` 和 `Iterable` 角色 / The `Iterator` and `Iterable` roles

Raku 是一种函数式语言，但是函数在处理复杂的数据结构时需要保留一些东西。特别是，它们需要一个可以以相同方式应用于所有数据结构的统一接口。其中一种接口是由 [Iterator](https://docs.raku.org/type/Iterator) 和 [Iterable](https://docs.raku.org/type/Iterable) 角色提供的。

Raku is a functional language, but functions need something to hold on to when working on complex data structures. In particular, they need a uniform interface that can be applied to all data structures in the same way. One of these kind of interfaces is provided by the [Iterator](https://docs.raku.org/type/Iterator) and [Iterable](https://docs.raku.org/type/Iterable) roles.

`Iterable` 角色相对简单。它为 `iterator` 方法提供了一个占位方法，该方法是诸如 `for` 等语句实际使用的方法。`for` 将对它前面的变量调用 `.iterator`，然后对每个项运行一次块。其他方法，如数组分配，将使 `Iterable` 类以相同的方式运行。

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

在此示例中，这是 [`Iterable` 示例的扩展，它显示了 `for` 如何调用 `.iterator`](https://docs.raku.org/type/Iterable)，仅当创建的对象被分配给[位置](https://docs.raku.org/type/Positional)变量 `@longer-chain` 时，才会在相应的上下文中调用“迭代器”方法，该变量是一个 [Array](https://docs.raku.org/type/Array)，并且我们在最后一个示例中对其进行操作。

In this example, which is an extension of the [example in `Iterable` that shows how `for` calls `.iterator`](https://docs.raku.org/type/Iterable), the `iterator` method will be called in the appropriate context only when the created object is assigned to a [Positional](https://docs.raku.org/type/Positional) variable, `@longer-chain`; this variable is an [Array](https://docs.raku.org/type/Array) and we operate on it as such in the last example.

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

We declare a `DNA` class which does the two roles, `Iterator` and `Iterable`; the class will include a string that will be constrained to have a length that is a multiple of 3 and composed only of ACGT.

Let us look at the `pull-one` method. This one is going to be called every time a new iteration occurs, so it must keep the state of the last one. An `$.index` attribute will hold that state across invocations; `pull-one` will check if the end of the chain has been reached and will return the `IterationEnd` constant provided by the role. Implementing this low-level interface, in fact, simplifies the implementation of the `Iterable` interface. Now the iterator will be the object itself, since we can call `pull-one` on it to access every member in turn; `.iterator` will thus return just `self`; this is possible since the object will be, at the same time, `Iterable` and `Iterator`.

This need not always be the case, and in most cases `.iterator` will have to build an iterator type to be returned (that will, for instance, keep track of the iteration state, which we are doing now in the main class), such as we did in the previous example; however, this example shows the minimal code needed to build a class that fulfills the iterator and iterable roles.

# How to iterate: contextualizing and topic variables

`for` and other loops place the item produced in every iteration into the [topic variable `$_`](https://docs.raku.org/language/variables#index-entry-topic_variable), or capture them into the variables that are declared along with the block. These variables can be directly used inside the loop, without needing to declare them, by using the [`^` twigil](https://docs.raku.org/syntax/$CIRCUMFLEX_ACCENT#(Traps_to_avoid)_twigil_^).

Implicit iteration occurs when using the [sequence operator](https://docs.raku.org/language/operators#index-entry-..._operators).

```Raku
say 1,1,1, { $^a²+2*$^b+$^c } … * > 300; # OUTPUT: «(1 1 1 4 7 16 46 127 475)
```

The generating block is being run once while the condition to finish the sequence, in this case the term being bigger than 300, is not met. This has the side effect of running a loop, but also creating a list that is output.

This can be done more systematically through the use of the [`gather/take` blocks](https://docs.raku.org/syntax/gather%20take), which are a different kind of iterating construct that instead of running in sink context, returns an item every iteration. This [Advent Calendar tutorial](https://perl6advent.wordpress.com/2009/12/23/day-23-lazy-fruits-from-the-gather-of-eden/) explains use cases for this kind of loops; in fact, gather is not so much a looping construct, but a statement prefix that collects the items produced by `take` and creates a list out of them.

# `Classic` loops and why we do not like them

Classic `for` loops, with a loop variable being incremented, can be done in Raku through the [`loop` keyword](https://docs.raku.org/language/control#loop). Other [repeat](https://docs.raku.org/language/control#repeat/while,_repeat/until) and [while](https://docs.raku.org/language/control#while,_until) loops are also possible.

However, in general, they are discouraged. Raku is a functional and concurrent language; when coding in Raku, you should look at loops in a functional way: processing, one by one, the items produced by an iterator, that is, feeding an item to a block without any kind of secondary effects. This functional view allows also easy parallelization of the operation via the [`hyper`](https://docs.raku.org/routine/hyper) or [`race`](https://docs.raku.org/routine/race) auto-threading methods.

If you feel more comfortable with your good old loops, the language allows you to use them. However, it is considered more *p6y* to try and use, whenever possible, functional and concurrent iterating constructs.

*Note:* Since version 6.d loops can produce a list of values from the values of last statements.

