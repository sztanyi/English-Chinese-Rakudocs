数据结构 / Data structures

Perl 6 如何处理数据结构以及我们可以从中得到什么

How Perl 6 deals with data structures and what we can expect from them

# 标量结构 / Scalar structures

有些类没有任何*内部*结构，要访问其中的某些部分，必须使用特定的方法。数字、字符串和一些其他单体类都包含在这个类中。它们使用的是 `$` 标记，尽管复杂的数据结构也可以使用它。

Some classes do not have any *internal* structure and to access parts of them, specific methods have to be used. Numbers, strings, and some other monolithic classes are included in that class. They use the `$` sigil, although complex data structures can also use it.

```Perl6
my $just-a-number = 7;
my $just-a-string = "8";
```

有一个内部使用的 [Scalar](https://docs.perl6.org/type/Scalar) 类，用来给 `$` 标记的变量赋默认值。

There is a [Scalar](https://docs.perl6.org/type/Scalar) class, which is used internally to assign a default value to variables declared with the `$` sigil.

```Perl6
my $just-a-number = 333;
say $just-a-number.VAR.^name; # OUTPUT: «Scalar␤» 
```

任何复杂数据结构都能使用 [`$`](https://docs.perl6.org/type/Any#index-entry-%2524_%28item_contextualizer%29) 使其*标量化*：

Any complex data structure can be *scalarized* by using the [item contextualizer `$`](https://docs.perl6.org/type/Any#index-entry-%2524_%28item_contextualizer%29):

```Perl6
(1, 2, 3, $(4, 5))[3].VAR.^name.say; # OUTPUT: «Scalar␤» 
```

但是，这意味着它将在它们的上下文中被视为原来的样子。你仍然可以访问其内部结构。

However, this means that it will be treated as such in the context they are. You can still access its internal structure.

```Perl6
(1, 2, 3, $(4, 5))[3][0].say; # OUTPUT: «4␤» 
```

一个有趣的副作用，或者可能是预期的特征，是标量化保留了复杂结构的同一性。

An interesting side effect, or maybe intended feature, is that scalarization conserves identity of complex structures.

```Perl6
for ^2 {
     my @list = (1, 1);
     say @list.WHICH;
} # OUTPUT: «Array|93947995146096␤Array|93947995700032␤» 
```
每次分配 `(1,1)` 时，创建的变量将会是不同的, `===` 对比的结果也显示是不同的变量;如图所示，打印内部指针表示的不同值。然而

Every time `(1, 1)` is assigned, the variable created is going to be different in the sense that `===` will say it is; as it is shown, different values of the internal pointer representation are printed. However

```Perl6
for ^2 {
  my $list = (1, 1);
  say $list.WHICH
} # OUTPUT: «List|94674814008432␤List|94674814008432␤» 
```

在这种情况下，`$list` 正在使用标量标记，因此将成为 `Scalar`。任何具有相同值的标量都将完全相同，如打印指针时所示。

In this case, `$list` is using the Scalar sigil and thus will be a `Scalar`. Any scalar with the same value will be exactly the same, as shown when printing the pointers.

# 复杂数据结构 / Complex data structures

根据你访问其第一级元素的方式，复杂数据结构分为两大类：[位置](https://docs.perl6.org/type/Positional)，或类似列表和[关联](https://docs.perl6.org/type/Associative)或键值对。通常，复杂的数据结构（包括对象）将是两者的组合，其中对象属性被同化为键值对。虽然所有对象都是[Mu](https://docs.perl6.org/type/Mu)的子类，但一般来说复杂对象是 [Any](https://docs.perl6.org/type/Any) 的子类实例 。虽然理论上可以在没有这样做的情况下混合使用`位置`或`关联`，但是大多数适用于复杂数据结构的方法都是在 `Any` 中实现的。

Complex data structures fall in two different broad categories: [Positional](https://docs.perl6.org/type/Positional), or list-like and [Associative](https://docs.perl6.org/type/Associative), or key-value pair like, according to how you access its first-level elements. In general, complex data structures, including objects, will be a combination of both, with object properties assimilated to key-value pairs. While all objects subclass [Mu](https://docs.perl6.org/type/Mu), in general complex objects are instances of subclasses of [Any](https://docs.perl6.org/type/Any). While it is theoretically possible to mix in `Positional` or `Associative` without doing so, most methods applicable to complex data structures are implemented in `Any`.

浏览这些复杂的数据结构是一项挑战，但 Perl 6 提供了一些可用于它们的函数：[`deepmap`](https://docs.perl6.org/routine/deepmap) 和 [`duckmap`] (https://docs.perl6.org/routine/duckmap)。虽然前者将按顺序转到每个元素，并且执行传递的代码块的。

Navigating these complex data structures is a challenge, but Perl 6 provides a couple of functions that can be used on them: [`deepmap`](https://docs.perl6.org/routine/deepmap) and [`duckmap`](https://docs.perl6.org/routine/duckmap). While the former will go to every single element, in order, and do whatever the block passed requires,

```Perl6
say [[1, 2, [3, 4]],[[5, 6, [7, 8]]]].deepmap( *.elems );
# OUTPUT: «[[1 1 [1 1]] [1 1 [1 1]]]␤» 
```

返回 `1` 因为它进入更深层次并将 `elems` 应用于它们，`deepmap` 可以执行更复杂的操作：

which returns `1` because it goes to the deeper level and applies `elems` to them, `deepmap` can perform more complicated operations:

```Perl6
say [[1, 2, [3, 4]], [[5, 6, [7, 8]]]].duckmap:
   -> $array where .elems == 2 { $array.elems };
# OUTPUT: «[[1 2 2] [5 6 2]]␤» 
```

在本例中，它深入到结构中，但如果元素不满足块中的条件（`1，2`），则返回元素本身；如果满足条件，则返回数组的元素数（每个子数组末尾的两个'2`）。

In this case, it dives into the structure, but returns the element itself if it does not meet the condition in the block (`1, 2`), returning the number of elements of the array if it does (the two `2`s at the end of each subarray).

因为 `deepmap` 和 `duckmap` 是 `Any` 的方法，他们也可用于关联数组：

Since `deepmap` and `duckmap` are `Any` methods, they also apply to Associative arrays:

```Perl6
say %( first => [1, 2], second => [3,4] ).deepmap( *.elems );
# OUTPUT: «{first => [1 1], second => [1 1]}␤» 
```

只有在这种情况下，它们才会应用于作为值的每个列表或数组，而不管键。

Only in this case, they will be applied to every list or array that is a value, leaving the keys alone.

`位置`和`关联`数据结构可以互相转换。

`Positional` and `Associative` can be turned into each other.

```Perl6
say %( first => [1, 2], second => [3,4] ).list[0];
# OUTPUT: «second => [3 4]␤» 
```

在这个例子中，2018.05 之后的 Rakudo 版本每次运行都会返回不同的值。哈希会转变为键值对的乱序数组。也可以反着操作，只要只要数组有偶数个元素（奇数个元素会报错）：

However, in this case, and for Rakudo >= 2018.05, it will return a different value every time it runs. A hash will be turned into a list of the key-value pairs, but it is guaranteed to be disordered. You can also do the operation in the opposite direction, as long as the list has an even number of elements (odd number will result in an error):

```Perl6
say <a b c d>.Hash # OUTPUT: «{a => b, c => d}␤» 
```

但是

But

```Perl6
say <a b c d>.Hash.kv # OUTPUT: «(c d a b)␤» 
```

每次运行都是不同的结果，[`kv`](https://docs.perl6.org/type/Pair#method_kv) 将每个 `键值对` 转换为列表。

will obtain a different value every time you run it; [`kv`](https://docs.perl6.org/type/Pair#method_kv) turns every `Pair` into a list.

复杂的数据结构通常也是[可迭代的](https://docs.perl6.org/type/Iterable)。从中生成一个[迭代器](https://docs.perl6.org/routine/iterator)，将允许程序逐个访问结构的第一级：

Complex data structures are also generally [Iterable](https://docs.perl6.org/type/Iterable). Generating an [iterator](https://docs.perl6.org/routine/iterator) out of them will allow the program to visit the first level of the structure, one by one:

```Perl6
.say for 'א'..'ס'; # OUTPUT: «א␤ב␤ג␤ד␤ה␤ו␤ז␤ח␤ט␤י␤ך␤כ␤ל␤ם␤מ␤ן␤נ␤ס␤» 
```

'א'..'ס' 是一个 [Range](https://docs.perl6.org/type/Range) 复杂数据结构，在前面加上 `for`，它将迭代直到列表耗尽。通过重写[迭代器](https://docs.perl6.org/routine/iterator)，可以对复杂的数据结构使用 `for`：

`'א'..'ס'` is a [Range](https://docs.perl6.org/type/Range), a complex data structure, and with `for` in front it will iterate until the list is exhausted. You can use `for`on your complex data structures by overriding the [iterator](https://docs.perl6.org/routine/iterator) method (from role `Iterable`):

```Perl6
class SortedArray is Array {
  method iterator() {
    self.sort.iterator
  }
};
my @thing := SortedArray.new([3,2,1,4]);
.say for @thing; # OUTPUT: «1␤2␤3␤4␤» 
```

`for` 对数组 `@thing` 直接调用 `iterator` 方法使其按顺序返回数组元素。更多关于[迭代](https://docs.perl6.org/language/iterating)。

`for` calls directly the `iterator` method on `@thing` making it return the elements of the array in order. Much more on [iterating on the page devoted to it](https://docs.perl6.org/language/iterating).

# 函数式结构 / Functional structures

Perl 6 是一种函数式语言，因此，函数是第一等的*数据*结构。函数有 [Callable](https://docs.perl6.org/type/Callable) 角色，这是基本角色四件套中的第四个元素。[Callable](https://docs.perl6.org/type/Callable) 与 `&` 标记一起使用，尽管在大多数情况下，为了简单起见省略了它；在 `Callables` 的情况下可以总是省略这标记。

Perl 6 is a functional language and, as such, functions are first-class *data* structures. Functions follow the [Callable](https://docs.perl6.org/type/Callable) role, which is the 4th element in the quartet of fundamental roles. [Callable](https://docs.perl6.org/type/Callable) goes with the `&` sigil, although in most cases it is elided for the sake of simplicity; this sigil elimination is always allowed in the case of `Callables`.

```Perl6
my &a-func= { (^($^þ)).Seq };
say a-func(3), a-func(7); # OUTPUT: «(0 1 2)(0 1 2 3 4 5 6)␤» 
```

[Block](https://docs.perl6.org/type/Block) 是最简单的可调用结构，因为 `Callable` 不能被实例化。在这种情况下，我们实现一个记录事件并可以检索它们的代码：

[Block](https://docs.perl6.org/type/Block)s are the simplest callable structures, since `Callable`s cannot be instantiated. In this case we implement a block that logs events and can retrieve them:

```Perl6
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

`Block` 是有[签名](https://docs.perl6.org/type/Signature)的。在这个例子中，有2个参数。第一个参数是需要记录的事件，第二个参数是获取事件的键。他们将会被独立地使用，意图是展示 [状态变量](https://docs.perl6.org/syntax/state)的用法，该变量从每次调用到下一次调用时都会被保留。此状态变量封装在代码块中，除非使用代码块提供的简单 API，否则无法从外部访问：带第二个参数调用代码块。头两次调用记录了两个事件，示例底部的调用使用第二种调用来检索存储的值。`代码块`可以克隆：

A `Block` has a [Signature](https://docs.perl6.org/type/Signature), in this case two arguments, the first of which is the event that is going to be logged, and the second is the key to retrieve the events. They will be used in an independent way, but its intention is to showcase the use of a [state variable](https://docs.perl6.org/syntax/state) that is kept from every invocation to the next. This state variable is encapsulated within the block, and cannot be accessed from outside except by using the simple API the block provides: calling the block with a second argument. The two first invocations log two events, the third invocation at the bottom of the example use this second type of call to retrieve the stored values. `Block`s can be cloned:

```Perl6
my $clogger = $logger.clone;
$clogger( "Clone stuff" );
$clogger( "More clone stuff" );
say $clogger( Nil, "2018-05-28" );
# OUTPUT: «(Clone stuff More clone stuff)␤» 
```

克隆将重置而非克隆状态变量，我们可以创建改变 API 的*外立面*。例如，无需使用 `Nil` 作为第一个参数来检索特定日期的日志：

And cloning will reset the state variable; instead of cloning, we can create *façades* that change the API. For instance, eliminate the need to use `Nil` as first argument to retrieve the log for a certain date:

```Perl6
my $gets-logs = $logger.assuming( Nil, * );
$logger( %(changing => "Logs") );
say $gets-logs( "2018-05-28" );
# OUTPUT: «({changing => Logs} Stuff More stuff)␤» 
```

[`assuming`](https://docs.perl6.org/type/Block#%28Code%29_method_assuming) 方法包装了一个代码块调用，给我们需要的参数赋一个值（在这种情况下，值是`Nil`），并将参数传递给我们用 `*` 表示的其他参数。
实际上，这对应于自然语言语句“我们正在调用 `$logger` *假设*第一个参数是 `Nil`”。我们可以稍微改变这两个代码块的外观，以澄清它们实际上是在同一个块上运行：

[`assuming`](https://docs.perl6.org/type/Block#%28Code%29_method_assuming) wraps around a block call, giving a value (in this case, `Nil`) to the arguments we need, and passing on the arguments to the other arguments we represent using `*`. In fact, this corresponds to the natural language statement "We are calling `$logger` *assuming* the first argument is `Nil`". We can slightly change the appearance of these two Blocks to clarify they are actually acting on the same block:

```Perl6
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

```Perl6
my @regex-check = ( /<alnum>/, /<alpha>/, /<punct>/ );
say @regex-check.map: "33af" ~~ *;
# OUTPUT: «(｢3｣␤ alnum => ｢3｣ ｢a｣␤ alpha => ｢a｣ Nil)␤» 
```

正则表达式实际上是一种可调用的数据结构：

Regexes are actually a type of callable:

```Perl6
say /regex/.does( Callable ); # OUTPUT: «True␤» 
```

在上面的示例中，我们调用存储在数组中的正则表达式，并将它们应用于字符串文字。

And in the example above we are calling regexes stored in an array, and applying them to a string literal.

可调用数据结构由[函数组合运算符 ∘]组成

Callables are composed by using the [function composition operator ∘](https://docs.perl6.org/language/operators#infix_%25E2%2588%2598):

```Perl6
my $typer = -> $thing { $thing.^name ~ ' → ' ~ $thing };
my $Logger::withtype = $Logger::logs ∘ $typer;
$Logger::withtype( Pair.new( 'left', 'right' ) );
$Logger::withtype( ¾ );
say $Logger::get( "2018-05-28" );
# OUTPUT: «(Pair → left right Rat → 0.75)␤» 
```

我们使用上面定义的 `$Logger::logs` 函数与 `$typer` 组合，获得另外一个函数。这个函数记录一个对象及其类型，这非常有用，例如作为过滤。 `$Logger::withtype` 实际上是一个复杂的数据结构，由两个以串行方式应用的函数组成，但每一个组合的可调用数据结构都可以保持状态，从而创建复杂的变换可调用数据结构，其设计模式是：类似于面向对象领域中的对象组合。在每种特定情况下，你都必须选择最适合你的问题的编程风格。

We are composing `$typer` with the `$Logger::logs` function defined above, obtaining a function that logs an object preceded by its type, which can be useful for filtering, for instance. `$Logger::withtype` is, in fact, a complex data structure composed of two functions which are applied in a serial way, but every one of the callables composed can keep state, thus creating complex transformative callables, in a design pattern that is similar to object composition in the object oriented realm. You will have to choose, in every particular case, what is the programming style which is most suitable for your problem.

# 定义和约束数据结构 / Defining and constraining data structures

Perl 6 有不同的定义数据结构的方法，但也有许多方法来约束它们，这样你就可以为每个问题域创建最合适的数据结构。例如 [`but`](https://docs.perl6.org/routine/but)，将角色或值混合到值或变量中：

Perl 6 has different ways of defining data structures, but also many ways to constrain them so that you can create the most adequate data structure for every problem domain. [`but`](https://docs.perl6.org/routine/but), for example, mixes roles or values into a value or a variable:

```Perl6
my %not-scalar := %(2 => 3) but Associative[Int, Int];
say %not-scalar.^name; # OUTPUT: «Hash+{Associative[Int, Int]}␤» 
say %not-scalar.of;    # OUTPUT: «Associative[Int, Int]␤» 
%not-scalar{3} = 4;
%not-scalar<thing> = 3;
say %not-scalar;       # OUTPUT: «{2 => 3, 3 => 4, thing => 3}␤» 
```

在这种情况下，`but` 混合在 `Associative[Int, Int]` 角色中；请注意，我们使用的是绑定，这样变量的类型就是定义的类型，而不是由 `%` 标记强加的类型；这种混合的角色显示在用大括号括起来的 `name` 中。这到底是什么意思？该角色包含两个方法： `of` 和 `keyof`；通过混合中的角色，将调用新的 `of`（旧的 `of` 将返回 `Mu`，这是哈希的默认值类型）。然而，这就是它所做的一切。它并没有真正改变变量的类型，正如你所看到的，因为我们在接下来的几条语句中使用了任何类型的键和值。

In this case, `but` is mixing in the `Associative[Int, Int]` role; please note that we are using binding so that the type of the variable is the one defined, and not the one imposed by the `%` sigil; this mixed-in role shows in the `name` surrounded by curly braces. What does that really mean? That role includes two methods, `of` and `keyof`; by mixing the role in, the new `of` will be called (the old `of` would return `Mu`, which is the default value type for Hashes). However, that is all it does. It is not really changing the type of the variable, as you can see since we are using any kind of key and values in the next few statements.

但是，我们可以使用这种类型的混合给变量增加新功能：

However, we can provide new functionality to a variable using this type of mixin:

```Perl6
role Lastable {
  method last() {
    self.sort.reverse[0]
  }
}
my %hash-plus := %( 3 => 33, 4 => 44) but Lastable;
say %hash-plus.sort[0]; # OUTPUT: «3 => 33␤» 
say %hash-plus.last;    # OUTPUT: «4 => 44␤» 
```

在 `Lastable` 中，我们使用通用的 `self` 变量来引用这个特定角色所混合的任何对象；在这种情况下，它将包含与之混合的哈希；在另一种情况下，它将包含其他内容（可能以其他方式工作）。此角色将为与之混合的任何变量提供 `last` 方法，为*常规*变量提供新的、可附加的功能。甚至可以[使用 `does` 关键字将角色添加到现有变量中](https://docs.perl6.org/language/objects#Mixins_of_roles)。

In `Lastable` we use the universal `self` variable to refer to whatever object this particular role is mixed in; in this case it will contain the hash it is mixed in with; it will contain something else (and possibly work some other way) in other case. This role will provide the `last` method to any variable it's mixed with, providing new, attachable, functionalities to *regular* variables. Roles can even be [added to existing variables using the `does` keyword](https://docs.perl6.org/language/objects#Mixins_of_roles).

[子集](https://docs.perl6.org/language/typesystem#subset) 也可以用来约束变量可能拥有的值；他们是 Perl 6 [渐进的类型](https://en.wikipedia.org/wiki/Gradual_typing)的尝试；它不是一个全功能的尝试，是因为严格来说子集不是真正的类型，但他们允许运行时类型检查。它为常规类型添加类型检查，因此它创建一个更丰富的类型系统，允许类似于此代码中所示的内容：

[Subsets](https://docs.perl6.org/language/typesystem#subset) can also be used to constrain the possible values a variable might hold; they are Perl 6 attempt at [gradual typing](https://en.wikipedia.org/wiki/Gradual_typing); it is not a full attempt, because subsets are not really types in a strict sense, but they allow runtime type checking. It adds type-checking functionality to regular types, so it helps create a richer type system, allowing things like the one shown in this code:

```Perl6
subset OneOver where (1/$_).Int == 1/$_;
my OneOver $one-fraction = ⅓;
say $one-fraction; # OUTPUT: «0.333333␤» 
```

On the other hand, `my OneOver $ = ⅔;` will cause a type-check error. Subsets can use `Whatever`, that is, `*`, to refer to the argument; but this will be instantiated every time you use it to a different argument, so if we use it twice in the definition we would get an error. In this case we are using the topic single variable, `$_`, to check the instantiation. Subsetting can be done directly, without the need of declaring it, in [signatures](https://docs.perl6.org/language/typesystem#subset).

# 无限数据结构以及惰性 / Infinite structures and laziness

通常认为所有包含在数据结构中的数据都是实际*存在*的。

It might be assumed that all the data contained in a data structure is actually *there*. That is not necessarily the case: in many cases, for efficiency reasons or simply because it is not possible, the elements contained in a data structure only jump into existence when they are actually needed. This computation of items as they are needed is called [reification](https://docs.perl6.org/language/glossary#Reify).

```Perl6
# A list containing infinite number of un-reified Fibonacci numbers: 
my @fibonacci = 1, 1, * + * … ∞;
 
# We reify 10 of them, looking up the first 10 of them with array index: 
say @fibonacci[^10]; # OUTPUT: «(1 1 2 3 5 8 13 21 34 55)␤» 
 
# We reify 5 more: 10 we already reified on previous line, and we need to 
# reify 5 more to get the 15th element at index 14. Even though we need only 
# the 15th element, the original Seq still has to reify all previous elements: 
say @fibonacci[14]; # OUTPUT: «987␤» 
```

Above we were reifying a [Seq](https://docs.perl6.org/type/Seq) we created with the [sequence operator](https://docs.perl6.org/language/operators#index-entry-%25E2%2580%25A6_operators), but other data structures use the concept as well. For example, an un-reified [Range](https://docs.perl6.org/type/Range) is just the two end points. In some languages, calculating the sum of a huge range is a lengthy and memory-consuming process, but Perl 6 calculates it instantly:

```Perl6
say sum 1 .. 9_999_999_999_999; # OUTPUT: «49999999999995000000000000␤» 
```

Why? Because the sum can be calculated *without* reifying the Range; that is, without figuring out all the elements it contains. This is why this feature exists. You can even make your own things reify-on-demand, using [`gather` and `take`](https://docs.perl6.org/syntax/gather%20take):

```Perl6
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

Following the output above, you can see the print statements *inside* the `gather` got executed only when we reified the individual elements while looking up an element. Also note that the elements got reified just once. When we printed the same elements again on the last line of the example, the messages inside `gather` was no longer printed. This is because the construct used already-reified elements from the [Seq](https://docs.perl6.org/type/Seq)'s cache.

Note that above we assigned the `gather` to a [Scalar](https://docs.perl6.org/type/Scalar) container (the `$` sigil), not the [Positional](https://docs.perl6.org/type/Positional) one (the `@` sigil). The reason is that the `@`-sigiled variables are *mostly eager*. What this means is they *reify the stuff assigned to them* right away *most of the time*. The only time they don't do it is when the items are known to be [`is-lazy`](https://docs.perl6.org/routine/is-lazy), like our sequence generated with infinity as the end point. Were we to assign the `gather` to a `@`-variable, the `say` statements inside of it would've been printed right away.

Another way to fully-reify a list, is by calling [`.elems`](https://docs.perl6.org/routine/elems) on it. This is the reason why checking whether a list contains any items is best done by using `.Bool` method (or just using `if @array { … }`), since you don't need to reify *all* the elements to find out if there are `any` of them.

There are times where you *do* want to fully-reify a list before doing something. For example, the [`IO::Handle.lines`](https://docs.perl6.org/type/IO::Handle#method_lines) returns a [Seq](https://docs.perl6.org/type/Seq). The following code contains a bug; keeping reification in mind, try to spot it:

```Perl6
my $fh = "/tmp/bar".IO.open;
my $lines = $fh.lines;
close $fh;
say $lines[0];
```

We open a [filehandle](https://docs.perl6.org/type/IO::Handle), then assign return of [`.lines`](https://docs.perl6.org/type/IO::Handle#method_lines) to a [Scalar](https://docs.perl6.org/type/Scalar) variable, so the returned [Seq](https://docs.perl6.org/type/Seq) does not get reified right away. We then [`close`](https://docs.perl6.org/routine/close) the filehandle, and try to print an element from `$lines`.

The bug in the code is by the time we reify the `$lines` [Seq](https://docs.perl6.org/type/Seq) on the last line, we've *already closed* the filehandle. When the `Seq's` iterator tries to generate the item we've requested, it results in the error about attempting to read from a closed handle. So, to fix the bug we can either assign to a `@`-sigiled variable or call [`.elems`](https://docs.perl6.org/routine/elems) on `$lines` before closing the handle:

```Perl6
my $fh = "/tmp/bar".IO.open;
my @lines = $fh.lines;
close $fh;
say @lines[0]; # no problem! 
```

We can also use any function whose side effect is reification, like `.elems` mentioned above:

```Perl6
my $fh = "/tmp/bar".IO.open;
my $lines = $fh.lines;
say "Read $lines.elems() lines"; # reifying before closing handle 
close $fh;
say $lines[0]; # no problem! 
```

Using [eager](https://docs.perl6.org/routine/eager) will also reify the whole sequence:

```Perl6
my $fh = "/tmp/bar".IO.open;
my $lines = eager $fh.lines; # Uses eager for reification. 
close $fh;
say $lines[0];
```

# Introspection

Languages that allow [introspection](https://en.wikipedia.org/wiki/Type_introspection) like Perl 6 have functionalities attached to the type system that let the developer access container and value metadata. This metadata can be used in a program to carry out different actions depending on their value. As it is obvious from the name, metadata are extracted from a value or container via the metaclass.

```Perl6
my $any-object = "random object";
my $metadata = $any-object.HOW;
say $metadata.^mro;                   # OUTPUT: «((ClassHOW) (Any) (Mu))␤» 
say $metadata.can( $metadata, "uc" ); # OUTPUT: «(uc uc)␤» 
```

With the first `say` we show the class hierarchy of the metamodel class, which in this case is [Metamodel::ClassHOW](https://docs.perl6.org/type/Metamodel::ClassHOW). It inherits directly from `Any`, meaning any method there can be used; it also mixes in several roles which can give you information about the class structure and functions. But one of the methods of that particular class is [`can`](https://docs.perl6.org/type/Metamodel::ClassHOW#method_can), which we can use to look up whether the object can use the `uc` (uppercase) method, which it obviously can. However, it might not be so obvious in some other cases, when roles are mixed in directly into a variable. For instance, in the [case of `%hash-plus` defined above](https://docs.perl6.org/language/structures#Defining_and_constraining_data_structures):

```Perl6
say %hash-plus.^can("last"); # OUTPUT: «(last)␤» 
```

In this case we are using the *syntactic sugar* for `HOW.method`, `^method`, to check if your data structure responds to that method; the output, which shows the name of the methods that match, certifies that we can use it.

See also [this article on class introspection](https://perl6advent.wordpress.com/2015/12/19/day-19-introspection/) on how to access class properties and methods, and use it to generate test data for a class; this [Advent Calendar article describes the meta-object protocol](https://perl6advent.wordpress.com/2010/12/22/day-22-the-meta-object-protocol/) extensively.