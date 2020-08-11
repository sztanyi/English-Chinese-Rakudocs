原文：https://docs.raku.org/language/structures

# 数据结构 / Data structures

Raku 如何处理数据结构以及我们可以从中得到什么

How Raku deals with data structures and what we can expect from them

# 目录 / Table of Contents

<!-- MarkdownTOC -->

- [标量结构 / Scalar structures](#标量结构--scalar-structures)
- [复杂数据结构 / Complex data structures](#复杂数据结构--complex-data-structures)
- [函数式结构 / Functional structures](#函数式结构--functional-structures)
- [定义和约束数据结构 / Defining and constraining data structures](#定义和约束数据结构--defining-and-constraining-data-structures)
- [无限数据结构以及惰性 / Infinite structures and laziness](#无限数据结构以及惰性--infinite-structures-and-laziness)
- [内省 / Introspection](#内省--introspection)

<!-- /MarkdownTOC -->


<a id="标量结构--scalar-structures"></a>
# 标量结构 / Scalar structures

有些类没有任何*内部*结构，要访问其中的某些部分，必须使用特定的方法。数字、字符串和一些其他单体类都包含在这个类中。它们使用的是 `$` 标记，尽管复杂的数据结构也可以使用它。

Some classes do not have any *internal* structure and to access parts of them, specific methods have to be used. Numbers, strings, and some other monolithic classes are included in that class. They use the `$` sigil, although complex data structures can also use it.

```Raku
my $just-a-number = 7;
my $just-a-string = "8";
```

有一个内部使用的 [Scalar](https://docs.raku.org/type/Scalar) 类，用来给 `$` 标记的变量赋默认值。

There is a [Scalar](https://docs.raku.org/type/Scalar) class, which is used internally to assign a default value to variables declared with the `$` sigil.

```Raku
my $just-a-number = 333;
say $just-a-number.VAR.^name; # OUTPUT: «Scalar␤» 
```

任何复杂数据结构都能使用 [`$`](https://docs.raku.org/type/Any#index-entry-%2524_%28item_contextualizer%29) 使其*标量化*：

Any complex data structure can be *scalarized* by using the [item contextualizer `$`](https://docs.raku.org/type/Any#index-entry-%2524_%28item_contextualizer%29):

```Raku
(1, 2, 3, $(4, 5))[3].VAR.^name.say; # OUTPUT: «Scalar␤» 
```

但是，这意味着它将在它们的上下文中被视为原来的样子。你仍然可以访问其内部结构。

However, this means that it will be treated as such in the context they are. You can still access its internal structure.

```Raku
(1, 2, 3, $(4, 5))[3][0].say; # OUTPUT: «4␤» 
```

一个有趣的副作用，或者可能是预期的特征，是标量化保留了复杂结构的同一性。

An interesting side effect, or maybe intended feature, is that scalarization conserves identity of complex structures.

```Raku
for ^2 {
    my @list = (1, 1);
    say @list.WHICH;
} # OUTPUT: «Array|93947995146096␤Array|93947995700032␤» 
```
每次分配 `(1,1)` 时，创建的变量将会是不同的, `===` 对比的结果也显示是不同的变量;如图所示，打印内部指针表示的不同值。然而

Every time `(1, 1)` is assigned, the variable created is going to be different in the sense that `===` will say it is; as it is shown, different values of the internal pointer representation are printed. However

```Raku
for ^2 {
  my $list = (1, 1);
  say $list.WHICH
} # OUTPUT: «List|94674814008432␤List|94674814008432␤» 
```

在这种情况下，`$list` 正在使用标量标记，因此将成为 `Scalar`。任何具有相同值的标量都将完全相同，如打印指针时所示。

In this case, `$list` is using the Scalar sigil and thus will be a `Scalar`. Any scalar with the same value will be exactly the same, as shown when printing the pointers.

<a id="复杂数据结构--complex-data-structures"></a>
# 复杂数据结构 / Complex data structures

根据你访问其第一级元素的方式，复杂数据结构分为两大类：[Positional](https://docs.raku.org/type/Positional)，或类似列表和 [Associative](https://docs.raku.org/type/Associative) 或键值对。通常，复杂的数据结构（包括对象）将是两者的组合，其中对象属性被同化为键值对。虽然所有对象都是 [Mu](https://docs.raku.org/type/Mu) 的子类，但一般来说复杂对象是 [Any](https://docs.raku.org/type/Any) 的子类实例 。虽然理论上可以在没有这样做的情况下混合使用 `Positional` 或 `Associative`，但是大多数适用于复杂数据结构的方法都是在 `Any` 中实现的。

Complex data structures fall in two different broad categories: [Positional](https://docs.raku.org/type/Positional), or list-like and [Associative](https://docs.raku.org/type/Associative), or key-value pair like, according to how you access its first-level elements. In general, complex data structures, including objects, will be a combination of both, with object properties assimilated to key-value pairs. While all objects subclass [Mu](https://docs.raku.org/type/Mu), in general complex objects are instances of subclasses of [Any](https://docs.raku.org/type/Any). While it is theoretically possible to mix in `Positional` or `Associative` without doing so, most methods applicable to complex data structures are implemented in `Any`.

浏览这些复杂的数据结构是一项挑战，但 Raku 提供了一些可用于它们的函数：[`deepmap`](https://docs.raku.org/routine/deepmap) 和 [`duckmap`](https://docs.raku.org/routine/duckmap)。虽然前者将按顺序转到每个元素，并且执行传递的代码块的。

Navigating these complex data structures is a challenge, but Raku provides a couple of functions that can be used on them: [`deepmap`](https://docs.raku.org/routine/deepmap) and [`duckmap`](https://docs.raku.org/routine/duckmap). While the former will go to every single element, in order, and do whatever the block passed requires,

```Raku
say [[1, 2, [3, 4]],[[5, 6, [7, 8]]]].deepmap( *.elems );
# OUTPUT: «[[1 1 [1 1]] [1 1 [1 1]]]␤» 
```

返回 `1` 因为它进入更深层次并将 `elems` 应用于它们，`deepmap` 可以执行更复杂的操作：

which returns `1` because it goes to the deeper level and applies `elems` to them, `deepmap` can perform more complicated operations:

```Raku
say [[1, 2, [3, 4]], [[5, 6, [7, 8]]]].duckmap:
   -> $array where .elems == 2 { $array.elems };
# OUTPUT: «[[1 2 2] [5 6 2]]␤» 
```

在本例中，它深入到结构中，但如果元素不满足块中的条件（`1，2`），则返回元素本身；如果满足条件，则返回数组的元素数（每个子数组末尾的两个 `2`）。

In this case, it dives into the structure, but returns the element itself if it does not meet the condition in the block (`1, 2`), returning the number of elements of the array if it does (the two `2`s at the end of each subarray).

因为 `deepmap` 和 `duckmap` 是 `Any` 类的方法，他们也可用于关联数组：

Since `deepmap` and `duckmap` are `Any` methods, they also apply to Associative arrays:

```Raku
say %( first => [1, 2], second => [3,4] ).deepmap( *.elems );
# OUTPUT: «{first => [1 1], second => [1 1]}␤» 
```

只有在这种情况下，它们才会应用于作为值的每个列表或数组，而不管键。

Only in this case, they will be applied to every list or array that is a value, leaving the keys alone.

`Positional` 和 `Associative` 数据结构可以互相转换。

`Positional` and `Associative` can be turned into each other.

```Raku
say %( first => [1, 2], second => [3,4] ).list[0];
# OUTPUT: «second => [3 4]␤» 
```

在这个例子中，2018.05 之后的 Rakudo 版本每次运行都会返回不同的值。哈希会转变为键值对的乱序数组。也可以反着操作，只要数组有偶数个元素（奇数个元素会报错）：

However, in this case, and for Rakudo >= 2018.05, it will return a different value every time it runs. A hash will be turned into a list of the key-value pairs, but it is guaranteed to be disordered. You can also do the operation in the opposite direction, as long as the list has an even number of elements (odd number will result in an error):

```Raku
say <a b c d>.Hash # OUTPUT: «{a => b, c => d}␤» 
```

但是

But

```Raku
say <a b c d>.Hash.kv # OUTPUT: «(c d a b)␤» 
```

每次运行都是不同的结果，[`kv`](https://docs.raku.org/type/Pair#method_kv) 将每个 `Pair` 转换为列表。

will obtain a different value every time you run it; [`kv`](https://docs.raku.org/type/Pair#method_kv) turns every `Pair` into a list.

复杂的数据结构通常也是[可迭代的](https://docs.raku.org/type/Iterable)。从中生成一个[迭代器](https://docs.raku.org/routine/iterator)，将允许程序逐个访问结构的第一级：

Complex data structures are also generally [Iterable](https://docs.raku.org/type/Iterable). Generating an [iterator](https://docs.raku.org/routine/iterator) out of them will allow the program to visit the first level of the structure, one by one:

```Raku
.say for 'א'..'ס'; # OUTPUT: «א␤ב␤ג␤ד␤ה␤ו␤ז␤ח␤ט␤י␤ך␤כ␤ל␤ם␤מ␤ן␤נ␤ס␤» 
```

`'א'..'ס'` 是一个 [Range](https://docs.raku.org/type/Range)，一个复杂的数据结构，在前面加上 `for`，它将迭代直到列表耗尽。通过重写[迭代器](https://docs.raku.org/routine/iterator)，可以对复杂的数据结构使用 `for`：

`'א'..'ס'` is a [Range](https://docs.raku.org/type/Range), a complex data structure, and with `for` in front it will iterate until the list is exhausted. You can use `for`on your complex data structures by overriding the [iterator](https://docs.raku.org/routine/iterator) method (from role `Iterable`):

```Raku
class SortedArray is Array {
  method iterator() {
    self.sort.iterator
  }
};
my @thing := SortedArray.new([3,2,1,4]);
.say for @thing; # OUTPUT: «1␤2␤3␤4␤» 
```

`for` 对数组 `@thing` 直接调用 `iterator` 方法使其按顺序返回数组元素。更多关于[迭代](https://docs.raku.org/language/iterating)。

`for` calls directly the `iterator` method on `@thing` making it return the elements of the array in order. Much more on [iterating on the page devoted to it](https://docs.raku.org/language/iterating).

<a id="函数式结构--functional-structures"></a>
# 函数式结构 / Functional structures

Raku 是一种函数式语言，因此，函数是第一等的*数据*结构。函数有 [Callable](https://docs.raku.org/type/Callable) 角色，这是基本角色四件套中的第四个元素。[Callable](https://docs.raku.org/type/Callable) 与 `&` 标记一起使用，尽管在大多数情况下，为了简单起见省略了它；在 `Callables` 的情况下可以总是省略这标记。

Raku is a functional language and, as such, functions are first-class *data* structures.Functions follow the [Callable](https://docs.raku.org/type/Callable) role, which is the 4th element in the quartet of fundamental roles. [Callable](https://docs.raku.org/type/Callable) goes with the `&` sigil, although in most cases it is elided for the sake of simplicity; this sigil elimination is always allowed in the case of `Callables`.

```Raku
my &a-func= { (^($^þ)).Seq };
say a-func(3), a-func(7); # OUTPUT: «(0 1 2)(0 1 2 3 4 5 6)␤» 
```

[Block](https://docs.raku.org/type/Block) 是最简单的可调用结构，因为 `Callable` 不能被实例化。在这种情况下，我们实现一个记录事件并可以检索它们的代码：

[Block](https://docs.raku.org/type/Block)s are the simplest callable structures, since `Callable`s cannot be instantiated. In this case we implement a block that logs events and can retrieve them:

```Raku
my $logger = -> $event, $key = Nil  {
  state %store;
  if ( $event ) {
    %store{ DateTime.new( now ) } = $event;
  } else {
    %store.keys.grep( /$key/ )
  }
}
$logger( "Stuff" );
$logger( "More stuff" );
say $logger( Nil, "2018-05-28" ); # OUTPUT: «(Stuff More stuff)␤» 
```

`Block` 是有 [Signature](https://docs.raku.org/type/Signature)的。在这个例子中，有二个参数。第一个参数是需要记录的事件，第二个参数是获取事件的键。他们将会被独立地使用，意图是展示 [状态变量](https://docs.raku.org/syntax/state)的用法，该变量从每次调用到下一次调用时都会被保留。此状态变量封装在代码块中，除非使用代码块提供的简单 API，否则无法从外部访问：带第二个参数调用代码块。头两次调用记录了两个事件，示例底部的调用使用第二种调用来检索存储的值。`Block` 可以被克隆：

A `Block` has a [Signature](https://docs.raku.org/type/Signature), in this case two arguments, the first of which is the event that is going to be logged, and the second is the key to retrieve the events. They will be used in an independent way, but its intention is to showcase the use of a [state variable](https://docs.raku.org/syntax/state) that is kept from every invocation to the next. This state variable is encapsulated within the block, and cannot be accessed from outside except by using the simple API the block provides: calling the block with a second argument. The two first invocations log two events, the third invocation at the bottom of the example use this second type of call to retrieve the stored values. `Block`s can be cloned:

```Raku
my $clogger = $logger.clone;
$clogger( "Clone stuff" );
$clogger( "More clone stuff" );
say $clogger( Nil, "2018-05-28" );
# OUTPUT: «(Clone stuff More clone stuff)␤» 
```

任何克隆都将重置而非克隆状态变量，我们可以创建改变 API 的*外立面*。例如，无需使用 `Nil` 作为第一个参数来检索特定日期的日志：

And cloning will reset the state variable; instead of cloning, we can create *façades* that change the API. For instance, eliminate the need to use `Nil` as first argument to retrieve the log for a certain date:

```Raku
my $gets-logs = $logger.assuming( Nil, * );
$logger( %(changing => "Logs") );
say $gets-logs( "2018-05-28" );
# OUTPUT: «({changing => Logs} Stuff More stuff)␤» 
```

[`assuming`](https://docs.raku.org/type/Block#%28Code%29_method_assuming) 方法包装了一个代码块调用，给我们需要的参数赋一个值（在这种情况下，值是 `Nil`），并将参数传递给我们用 `*` 表示的其他参数。
实际上，这对应于自然语言语句“我们正在调用 `$logger` *假设*第一个参数是 `Nil`”。我们可以稍微改变这两个代码块的外观，以澄清它们实际上是在同一个块上运行：

[`assuming`](https://docs.raku.org/type/Block#%28Code%29_method_assuming) wraps around a block call, giving a value (in this case, `Nil`) to the arguments we need, and passing on the arguments to the other arguments we represent using `*`. In fact, this corresponds to the natural language statement "We are calling `$logger` *assuming* the first argument is `Nil`". We can slightly change the appearance of these two Blocks to clarify they are actually acting on the same block:

```Raku
my $Logger = $logger.clone;
my $Logger::logs = $Logger.assuming( *, Nil );
my $Logger::get = $Logger.assuming( Nil, * );
$Logger::logs( <an array> );
$Logger::logs( %(key => 42) );
say $Logger::get( "2018-05-28" );
```

尽管 `::` 通常用于调用类方法，但它实际上是变量名称的有效部分。在这种情况下，我们通常使用它们来简单地表明 `$Logger::logs` 和 `$Logger::get` 实际上是在调用 `$Logger`，使用大写使其像类的外观。本教程的重点是，使用函数作为一等公民，以及使用状态变量，允许使用某些有趣的设计模式，例如这一个。

Although `::` is generally used for invocation of class methods, it is actually a valid part of the name of a variable. In this case we use them conventionally to simply indicate `$Logger::logs` and `$Logger::get` are actually calling `$Logger`, which we have capitalized to use a class-like appearance. The point of this tutorial is that using functions as first-class citizens, together with the use of state variables, allows the use of certain interesting design patterns such as this one.

作为这样的第一类数据结构，可以在其他类型的数据可以使用的任何地方使用`可调用`数据结构。

As such first class data structures, callables can be used anywhere another type of data can.

```Raku
my @regex-check = ( /<alnum>/, /<alpha>/, /<punct>/ );
say @regex-check.map: "33af" ~~ *;
# OUTPUT: «(｢3｣␤ alnum => ｢3｣ ｢a｣␤ alpha => ｢a｣ Nil)␤» 
```

正则表达式实际上是一种可调用的数据结构：

Regexes are actually a type of callable:

```Raku
say /regex/.does( Callable ); # OUTPUT: «True␤» 
```

在上面的示例中，我们调用存储在数组中的正则表达式，并将它们应用于字符串文本。

And in the example above we are calling regexes stored in an array, and applying them to a string literal.

可调用数据结构由[函数组合运算符 ∘]组成

Callables are composed by using the [function composition operator ∘](https://docs.raku.org/language/operators#infix_%25E2%2588%2598):

```Raku
my $typer = -> $thing { $thing.^name ~ ' → ' ~ $thing };
my $Logger::withtype = $Logger::logs ∘ $typer;
$Logger::withtype( Pair.new( 'left', 'right' ) );
$Logger::withtype( ¾ );
say $Logger::get( "2018-05-28" );
# OUTPUT: «(Pair → left right Rat → 0.75)␤» 
```

我们将上面定义的 `$Logger::logs` 与 `$typer` 函数组合，获得另外一个函数。这个函数记录一个对象及其类型，这非常有用，例如用来过滤。`$Logger::withtype` 实际上是一个复杂的数据结构，由两个以串行方式应用的函数组成，但每一个组合的可调用数据结构都可以保持状态，从而创建复杂的可变换的可调用数据结构，其设计模式是：类似于面向对象领域中的对象组合。在每种特定情况下，你都必须选择最适合你的问题的编程风格。

We are composing `$typer` with the `$Logger::logs` function defined above, obtaining a function that logs an object preceded by its type, which can be useful for filtering, for instance. `$Logger::withtype` is, in fact, a complex data structure composed of two functions which are applied in a serial way, but every one of the callables composed can keep state, thus creating complex transformative callables, in a design pattern that is similar to object composition in the object oriented realm. You will have to choose, in every particular case, what is the programming style which is most suitable for your problem.

<a id="定义和约束数据结构--defining-and-constraining-data-structures"></a>
# 定义和约束数据结构 / Defining and constraining data structures

Raku 有不同的定义数据结构的方法，但也有许多方法来约束它们，这样你就可以为每个问题域创建最合适的数据结构。例如 [`but`](https://docs.raku.org/routine/but)，将角色或值混合到一个值或一个变量中：

Raku has different ways of defining data structures, but also many ways to constrain them so that you can create the most adequate data structure for every problem domain. [`but`](https://docs.raku.org/routine/but), for example, mixes roles or values into a value or a variable:

```Raku
my %not-scalar := %(2 => 3) but Associative[Int, Int];
say %not-scalar.^name; # OUTPUT: «Hash+{Associative[Int, Int]}␤» 
say %not-scalar.of;    # OUTPUT: «Associative[Int, Int]␤» 
%not-scalar{3} = 4;
%not-scalar<thing> = 3;
say %not-scalar;       # OUTPUT: «{2 => 3, 3 => 4, thing => 3}␤» 
```

在这种情况下，`but` 混合在 `Associative[Int, Int]` 角色中；请注意，我们使用的是绑定，这样定义的就是变量的类型，而不是由 `%` 标记强加的类型；这种混合的角色显示在用大括号括起来的 `name` 中。这到底是什么意思？该角色包含两个方法： `of` 和 `keyof`；通过混进角色，将调用新的 `of`（旧的 `of` 将返回 `Mu`，这是哈希的默认值类型）。然而，这就是它所做的一切。它并没有真正改变变量的类型，正如你所看到的，因为我们在接下来的几条语句中使用了任何类型的键和值。

In this case, `but` is mixing in the `Associative[Int, Int]` role; please note that we are using binding so that the type of the variable is the one defined, and not the one imposed by the `%` sigil; this mixed-in role shows in the `name` surrounded by curly braces. What does that really mean? That role includes two methods, `of` and `keyof`; by mixing the role in, the new `of` will be called (the old `of` would return `Mu`, which is the default value type for Hashes). However, that is all it does. It is not really changing the type of the variable, as you can see since we are using any kind of key and values in the next few statements.

但是，我们可以使用这种类型的混合给变量增加新功能：

However, we can provide new functionality to a variable using this type of mixin:

```Raku
role Lastable {
  method last() {
    self.sort.reverse[0]
  }
}
my %hash-plus := %( 3 => 33, 4 => 44) but Lastable;
say %hash-plus.sort[0]; # OUTPUT: «3 => 33␤» 
say %hash-plus.last;    # OUTPUT: «4 => 44␤» 
```

在 `Lastable` 角色中，我们使用通用的 `self` 变量来引用这个特定角色所混合的任何对象；在这种情况下，它将包含与之混合的哈希；在另一种情况下，它将包含其他内容（可能以其他方式工作）。此角色将为与之混合的任何变量提供 `last` 方法，为*常规*变量提供新的、可附加的功能。甚至可以[使用 `does` 关键字将角色添加到现有变量中](https://docs.raku.org/language/objects#Mixins_of_roles)。

In `Lastable` we use the universal `self` variable to refer to whatever object this particular role is mixed in; in this case it will contain the hash it is mixed in with; it will contain something else (and possibly work some other way) in other case. This role will provide the `last` method to any variable it's mixed with, providing new, attachable, functionalities to *regular* variables. Roles can even be [added to existing variables using the `does` keyword](https://docs.raku.org/language/objects#Mixins_of_roles).

[子集](https://docs.raku.org/language/typesystem#subset) 也可以用来约束变量可能拥有的值；他们是 Raku [渐进的类型](https://en.wikipedia.org/wiki/Gradual_typing)的尝试；它不是一个全功能的尝试，是因为严格来说子集不是真正的类型，但他们允许运行时类型检查。它为常规类型添加类型检查，因此它创建一个更丰富的类型系统，允许类似于此代码中所示的内容：

[Subsets](https://docs.raku.org/language/typesystem#subset) can also be used to constrain the possible values a variable might hold; they are Raku attempt at [gradual typing](https://en.wikipedia.org/wiki/Gradual_typing); it is not a full attempt, because subsets are not really types in a strict sense, but they allow runtime type checking. It adds type-checking functionality to regular types, so it helps create a richer type system, allowing things like the one shown in this code:

```Raku
subset OneOver where (1/$_).Int == 1/$_;
my OneOver $one-fraction = ⅓;
say $one-fraction; # OUTPUT: «0.333333␤» 
```

On the other hand, `my OneOver $ = ⅔;` will cause a type-check error. Subsets can use `Whatever`, that is, `*`, to refer to the argument; but this will be instantiated every time you use it to a different argument, so if we use it twice in the definition we would get an error. In this case we are using the topic single variable, `$_`, to check the instantiation. Subsetting can be done directly, without the need of declaring it, in [signatures](https://docs.raku.org/language/typesystem#subset).

<a id="无限数据结构以及惰性--infinite-structures-and-laziness"></a>
# 无限数据结构以及惰性 / Infinite structures and laziness

通常认为所有包含在数据结构中的数据都是实际*存在*的。这不一定是这样的：在许多情况下，由于效率的原因或仅仅因为不可能，数据结构中包含的元素只有在实际需要时才会出现。按需计算的项目称为 [具体化](https://docs.raku.org/language/glossary#Reify)

It might be assumed that all the data contained in a data structure is actually *there*. That is not necessarily the case: in many cases, for efficiency reasons or simply because it is not possible, the elements contained in a data structure only jump into existence when they are actually needed. This computation of items as they are needed is called [reification](https://docs.raku.org/language/glossary#Reify).

```Raku
# A list containing infinite number of un-reified Fibonacci numbers: 
my @fibonacci = 1, 1, * + * … ∞;
 
# We reify 10 of them, looking up the first 10 of them with array index: 
say @fibonacci[^10]; # OUTPUT: «(1 1 2 3 5 8 13 21 34 55)␤» 
 
# We reify 5 more: 10 we already reified on previous line, and we need to 
# reify 5 more to get the 15th element at index 14. Even though we need only 
# the 15th element, the original Seq still has to reify all previous elements: 
say @fibonacci[14]; # OUTPUT: «987␤» 
```

上面我们正在使用[序列操作符](https://docs.raku.org/language/operators#index-entry-%25E2%2580%25A6_operators)重新定义一个[序列](https://docs.raku.org/type/Seq)，但是其他数据结构也使用这个概念。例如，一个未具体化的[范围 / Range](https://docs.raku.org/type/Range) 只是两个端点。在某些语言中，计算一个巨大范围的和是一个耗时且耗内存的过程，但是 Raku 可以立即算出它：

Above we were reifying a [Seq](https://docs.raku.org/type/Seq) we created with the [sequence operator](https://docs.raku.org/language/operators#index-entry-%25E2%2580%25A6_operators), but other data structures use the concept as well. For example, an un-reified [Range](https://docs.raku.org/type/Range) is just the two end points. In some languages, calculating the sum of a huge range is a lengthy and memory-consuming process, but Raku calculates it instantly:

```Raku
say sum 1 .. 9_999_999_999_999; # OUTPUT: «49999999999995000000000000␤» 
```

为什么？因为求和可以计算而*不需要*重新定义范围；也就是说，不需要计算出它包含的所有元素。这就是这个特性存在的原因。你甚至可以使用 [`gather` 和 `take`](https://docs.raku.org/syntax/gather%20take) 让自己的东西按需具体化：

Why? Because the sum can be calculated *without* reifying the Range; that is, without figuring out all the elements it contains. This is why this feature exists. You can even make your own things reify-on-demand, using [`gather` and `take`](https://docs.raku.org/syntax/gather%20take):

```Raku
my $seq = gather {
    say "About to make 1st element"; take 1;
    say "About to make 2nd element"; take 2;
}
say "Let's reify an element!";
say $seq[0];
say "Let's reify more!";
say $seq[1];
say "Both are reified now!";
say $seq[^2];
 
# OUTPUT: 
# Let's reify an element! 
# About to make 1st element 
# 1 
# Let's reify more! 
# About to make 2nd element 
# 2 
# Both are reified now! 
# (1 2) 
```

在上面的输出之后，你可以看到在 `gather` *里面*的 print 语句只有当我们在查找元素时对单个元素进行了具体化时才会被执行，还要注意，这些元素只被重新定义了一次。当我们在示例的最后一行再次打印相同的元素时，`gather` 中的消息将不再打印。这是因为该构造使用了来自 [Seq](https://docs.raku.org/type/Seq) 缓存的已重新定义的元素。

Following the output above, you can see the print statements *inside* the `gather` got executed only when we reified the individual elements while looking up an element. Also note that the elements got reified just once. When we printed the same elements again on the last line of the example, the messages inside `gather` was no longer printed. This is because the construct used already-reified elements from the [Seq](https://docs.raku.org/type/Seq)'s cache.

请注意，上面我们将 `gather` 赋值给 [标量](https://docs.raku.org/type/Scalar)容器(带 `$` 标记)而非[位置](https://docs.raku.org/type/Positional)容器。这是因为 `@` 标记的变量*大多是贪婪的*。这意味着他们*绝大多数时间*会立刻*具体化赋值给他们的东西*。唯一一次他们不这么做的是当物品被知道是 [`is-lazy`](https://docs.raku.org/routine/is-lazy) 的时候，例如以无穷大为终点的序列。如果我们将 `gather` 分配给一个 `@` 变量，其中的 `say` 语句将立即打印出来。

Note that above we assigned the `gather` to a [Scalar](https://docs.raku.org/type/Scalar) container (the `$` sigil), not the [Positional](https://docs.raku.org/type/Positional) one (the `@` sigil). The reason is that the `@`-sigiled variables are *mostly eager*. What this means is they *reify the stuff assigned to them* right away *most of the time*. The only time they don't do it is when the items are known to be [`is-lazy`](https://docs.raku.org/routine/is-lazy), like our sequence generated with infinity as the end point. Were we to assign the `gather` to a `@`-variable, the `say` statements inside of it would've been printed right away.

另一种完全具体化列表的方法是在列表上调用 [`.elems`](https://docs.raku.org/routine/elems)。这就是为什么检查列表是否包含任何项最好使用 `.Bool` 方法（或者只使用 `if @array { … }`）的原因，因为你不需要具体化*所有*元素以确定其中是否存在某一项。

Another way to fully-reify a list, is by calling [`.elems`](https://docs.raku.org/routine/elems) on it. This is the reason why checking whether a list contains any items is best done by using `.Bool` method (or just using `if @array { … }`), since you don't need to reify *all* the elements to find out if there are `any` of them.

做某事之前有时候你*确实*想完全具体化一个列表。例如，[`IO::Handle.lines`](https://docs.raku.org/type/IO::Handle#method_lines) 返回一个 [Seq](https://docs.raku.org/type/Seq)。下面的代码包含一个 bug；请记住具体化的概念，并尝试找出它：

There are times where you *do* want to fully-reify a list before doing something. For example, the [`IO::Handle.lines`](https://docs.raku.org/type/IO::Handle#method_lines) returns a [Seq](https://docs.raku.org/type/Seq). The following code contains a bug; keeping reification in mind, try to spot it:

```Raku
my $fh = "/tmp/bar".IO.open;
my $lines = $fh.lines;
close $fh;
say $lines[0];
```

我们打开一个[文件句柄](https://docs.raku.org/type/IO::Handle)，然后将 [`.lines`](https://docs.raku.org/type/IO::Handle#method_lines)的返回值赋值给一个[标量](https://docs.raku.org/type/Scalar)变量，这样返回的 [Seq](https://docs.raku.org/type/Seq) 不会马上具体化。然后我们 [`close`](https://docs.raku.org/routine/close) 那个句柄并打印 `$lines` 中的一个元素。

We open a [filehandle](https://docs.raku.org/type/IO::Handle), then assign return of [`.lines`](https://docs.raku.org/type/IO::Handle#method_lines) to a [Scalar](https://docs.raku.org/type/Scalar) variable, so the returned [Seq](https://docs.raku.org/type/Seq) does not get reified right away. We then [`close`](https://docs.raku.org/routine/close) the filehandle, and try to print an element from `$lines`.

代码中的 bug 在最后一行具体化 `$lines` 这个 [Seq](https://docs.raku.org/type/Seq) 时，这时我们*已经关闭*了那个文件句柄。 当 `Seq` 的迭代器设法生成我们请求的项目，它会导致尝试从关闭的句柄读取的错误。修复这个 bug 我们可以将其赋值给 `@` 标记的变量或者在关闭文件句柄前调用 `$lines` 的 [`.elems`](https://docs.raku.org/routine/elems) 方法。

The bug in the code is by the time we reify the `$lines` [Seq](https://docs.raku.org/type/Seq) on the last line, we've *already closed* the filehandle. When the `Seq's` iterator tries to generate the item we've requested, it results in the error about attempting to read from a closed handle. So, to fix the bug we can either assign to a `@`-sigiled variable or call [`.elems`](https://docs.raku.org/routine/elems) on `$lines` before closing the handle:

```Raku
my $fh = "/tmp/bar".IO.open;
my @lines = $fh.lines;
close $fh;
say @lines[0]; # no problem! 
```

我们也可以使用任何副作用是具体化的函数，如上面提到的 `.elems`：

We can also use any function whose side effect is reification, like `.elems` mentioned above:

```Raku
my $fh = "/tmp/bar".IO.open;
my $lines = $fh.lines;
say "Read $lines.elems() lines"; # reifying before closing handle 
close $fh;
say $lines[0]; # no problem! 
```

使用 [eager](https://docs.raku.org/routine/eager) 也可以具体化整个序列：

Using [eager](https://docs.raku.org/routine/eager) will also reify the whole sequence:

```Raku
my $fh = "/tmp/bar".IO.open;
my $lines = eager $fh.lines; # Uses eager for reification. 
close $fh;
say $lines[0];
```

<a id="内省--introspection"></a>
# 内省 / Introspection

像 Raku 这样允许[自省](https://en.wikipedia.org/wiki/Type_introspection)的语言具有附加到类型系统的功能，允许开发人员访问容器和值元数据。此元数据可用于程序中，根据其值执行不同的操作。从名称中可以明显看出，元数据是通过元类从值或容器中提取的。

Languages that allow [introspection](https://en.wikipedia.org/wiki/Type_introspection) like Raku have functionalities attached to the type system that let the developer access container and value metadata. This metadata can be used in a program to carry out different actions depending on their value. As it is obvious from the name, metadata are extracted from a value or container via the metaclass.

```Raku
my $any-object = "random object";
my $metadata = $any-object.HOW;
say $metadata.^mro;                   # OUTPUT: «((ClassHOW) (Any) (Mu))␤» 
say $metadata.can( $metadata, "uc" ); # OUTPUT: «(uc uc)␤» 
```

在第一个 `say` 中，我们显示了元模型类的类层次结构，在本例中是 [Metamodel::ClassHOW](https://docs.raku.org/type/Metamodel::ClassHOW)。它直接从 `Any` 继承，这意味着可以使用任何方法；它还混合了几个角色，可以为你提供有关类结构和函数的信息。但是，这个特定类的方法之一是[`can`](https://docs.raku.org/type/Metamodel::ClassHOW#method_can)，我们可以使用它来查找对象是否可以使用 `uc` （大写）方法，这显然是可以的。然而，在其他一些情况下，当角色直接混合到变量中时，可能就不那么明显了。例如，在[上面定义的 `%hash-plus` 的情况下](https://docs.raku.org/language/structures#Defining_and_constraining_data_structures)：

With the first `say` we show the class hierarchy of the metamodel class, which in this case is [Metamodel::ClassHOW](https://docs.raku.org/type/Metamodel::ClassHOW). It inherits directly from `Any`, meaning any method there can be used; it also mixes in several roles which can give you information about the class structure and functions. But one of the methods of that particular class is [`can`](https://docs.raku.org/type/Metamodel::ClassHOW#method_can), which we can use to look up whether the object can use the `uc` (uppercase) method, which it obviously can. However, it might not be so obvious in some other cases, when roles are mixed in directly into a variable. For instance, in the [case of `%hash-plus` defined above](https://docs.raku.org/language/structures#Defining_and_constraining_data_structures):

```Raku
say %hash-plus.^can("last"); # OUTPUT: «(last)␤» 
```

在这例中，我们使用 `HOW.method` 和 `^method` 的*语法糖*来检查你的数据结构是否响应该方法；显示匹配方法名称的输出说明我们可以使用它。

In this case we are using the *syntactic sugar* for `HOW.method`, `^method`, to check if your data structure responds to that method; the output, which shows the name of the methods that match, certifies that we can use it.

另请参阅[这篇关于类内省的文章](https://perl6advent.wordpress.com/2015/12/19/day-19-introspection/)了解如何访问类属性和方法，并使用它为类生成测试数据；还有这篇[降临节描述元对象协议的文章](https://perl6advent.wordpress.com/2010/12/22/day-22-the-meta-object-protocol/)。

See also [this article on class introspection](https://perl6advent.wordpress.com/2015/12/19/day-19-introspection/) on how to access class properties and methods, and use it to generate test data for a class; this [Advent Calendar article describes the meta-object protocol](https://perl6advent.wordpress.com/2010/12/22/day-22-the-meta-object-protocol/) extensively.