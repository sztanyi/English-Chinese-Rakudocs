原文：https://rakudocs.github.io/language/list

# 列表、序列和数组 - Lists, sequences, and arrays

位置数据构造

Positional data constructs

自从计算机出现之前，列表就一直是计算的核心部分，在这期间，许多魔鬼都在他们的细节中占有一席之地。它们实际上是 Raku 中最难设计的部分之一，但是通过持久性和耐心，Raku 已经有了一个优雅的系统来处理它们。

Lists have been a central part of computing since before there were computers, during which time many devils have taken up residence in their details. They were actually one of the hardest parts of Raku to design, but through persistence and patience, Raku has arrived with an elegant system for handling them.

<!-- MarkdownTOC -->

- [列表字面量 / Literal lists](#%E5%88%97%E8%A1%A8%E5%AD%97%E9%9D%A2%E9%87%8F--literal-lists)
- [@ 符号 / The @ sigil](#-%E7%AC%A6%E5%8F%B7--the--sigil)
- [重置列表容器 / Reset a list container](#%E9%87%8D%E7%BD%AE%E5%88%97%E8%A1%A8%E5%AE%B9%E5%99%A8--reset-a-list-container)
- [迭代 / Iteration](#%E8%BF%AD%E4%BB%A3--iteration)
    - [单参数规则 / Single Argument Rule](#%E5%8D%95%E5%8F%82%E6%95%B0%E8%A7%84%E5%88%99--single-argument-rule)
- [成员测试 / Testing for elements](#%E6%88%90%E5%91%98%E6%B5%8B%E8%AF%95--testing-for-elements)
    - [序列 / Sequences](#%E5%BA%8F%E5%88%97--sequences)
    - [使用 `.iterator` / Using `.iterator`](#%E4%BD%BF%E7%94%A8-iterator--using-iterator)
    - [Slips](#slips)
- [惰性列表 / Lazy lists](#%E6%83%B0%E6%80%A7%E5%88%97%E8%A1%A8--lazy-lists)
- [不变性 / Immutability](#%E4%B8%8D%E5%8F%98%E6%80%A7--immutability)
- [列表上下文 / List contexts](#%E5%88%97%E8%A1%A8%E4%B8%8A%E4%B8%8B%E6%96%87--list-contexts)
    - [列表分配上下文 / List assignment context](#%E5%88%97%E8%A1%A8%E5%88%86%E9%85%8D%E4%B8%8A%E4%B8%8B%E6%96%87--list-assignment-context)
    - [扁平化“上下文” / Flattening "context"](#%E6%89%81%E5%B9%B3%E5%8C%96%E2%80%9C%E4%B8%8A%E4%B8%8B%E6%96%87%E2%80%9D--flattening-context)
    - [参数列表（Capture）上下文 / Argument list \(Capture\) context](#%E5%8F%82%E6%95%B0%E5%88%97%E8%A1%A8%EF%BC%88capture%EF%BC%89%E4%B8%8A%E4%B8%8B%E6%96%87--argument-list-capture-context)
    - [切片索引上下文 / Slice indexing context](#%E5%88%87%E7%89%87%E7%B4%A2%E5%BC%95%E4%B8%8A%E4%B8%8B%E6%96%87--slice-indexing-context)
    - [范围为切片 / Range as slice](#%E8%8C%83%E5%9B%B4%E4%B8%BA%E5%88%87%E7%89%87--range-as-slice)
    - [数组构造器上下文 / Array constructor context](#%E6%95%B0%E7%BB%84%E6%9E%84%E9%80%A0%E5%99%A8%E4%B8%8A%E4%B8%8B%E6%96%87--array-constructor-context)
- [数组 / Arrays](#%E6%95%B0%E7%BB%84--arrays)
    - [录入 / Typing](#%E5%BD%95%E5%85%A5--typing)
    - [定长数组 / Fixed size arrays](#%E5%AE%9A%E9%95%BF%E6%95%B0%E7%BB%84--fixed-size-arrays)
    - [条目化 / Itemization](#%E6%9D%A1%E7%9B%AE%E5%8C%96--itemization)
    - [字面量数组 / Literal arrays](#%E5%AD%97%E9%9D%A2%E9%87%8F%E6%95%B0%E7%BB%84--literal-arrays)
    - [可变性 / Mutability](#%E5%8F%AF%E5%8F%98%E6%80%A7--mutability)
        - [赋值 / Assigning](#%E8%B5%8B%E5%80%BC--assigning)
        - [绑定 / Binding](#%E7%BB%91%E5%AE%9A--binding)

<!-- /MarkdownTOC -->


<a id="%E5%88%97%E8%A1%A8%E5%AD%97%E9%9D%A2%E9%87%8F--literal-lists"></a>
# 列表字面量 / Literal lists

字面量 [`List`](https://rakudocs.github.io/type/List) 由逗号和分号**而不是**括号创建：

Literal [`List`s](https://rakudocs.github.io/type/List) are created with commas and semicolons, **not** with parentheses, so:

```Raku
1, 2;                # This is two-element list 
our $list = (1, 2);  # This is also a List, in parentheses 
$list = (1; 2);      # same List (see below) 
$list = (1);         # This is not a List, just a 1 in parentheses 
$list = (1,);        # This is a one-element List 
```

有一个例外，空列表仅用一对括号创建：

There is one exception, empty lists are created with just a pair of parentheses:

```Raku
();          # This is an empty List 
(,);         # This is a syntax error 
```

请注意，只要列表的开头和结尾都是清晰的，挂起逗号是可以的，因此你可以放心使用它们进行代码编辑。

Note that hanging commas are just fine as long as the beginning and end of a list are clear, so feel free to use them for easy code editing.

括号可以用来标记一个列表的开始和结束，所以：

Parentheses can be used to mark the beginning and end of a `List`, so:

```Raku
(1, 2), (1, 2); # This is a list of two lists. 
```


也可以通过组合逗号和分号来创建列表的列表。这也被称为多维语法，因为它最常用于索引多维数组。

`List`s of `List`s can also be created by combining comma and semicolon. This is also called multi-dimensional syntax, because it is most often used to index multidimensional arrays.

```Raku
say so (1,2; 3,4) eqv ((1,2), (3,4));
# OUTPUT: «True␤» 
say so (1,2; 3,4;) eqv ((1,2), (3,4));
# OUTPUT: «True␤» 
say so ("foo";) eqv ("foo") eqv (("foo")); # not a list 
# OUTPUT: «True␤» 
```

与逗号不同，挂起的分号不会在文本中创建多维列表。但是，请注意，此行为在大多数参数列表中都会发生变化，具体的行为取决于函数…但通常是：

Unlike a comma, a hanging semicolon does not create a multidimensional list in a literal. However, be aware that this behavior changes in most argument lists, where the exact behavior depends on the function... But will usually be:

```Raku
say('foo';);   # a list with one element and the empty list 
# OUTPUT: «(foo)()␤» 
say(('foo';)); # no list, just the string "foo" 
# OUTPUT: «foo␤» 
```

因为分号同时用作[语句终止符](https://rakudocs.github.io/language/control#statements)，所以在顶级使用时，它将结束字面量列表，而不是创建语句列表。如果要在括号内创建语句列表，请在括号前使用符号：

Because the semicolon doubles as a [statement terminator](https://rakudocs.github.io/language/control#statements) it will end a literal list when used at the top level, instead creating a statement list. If you want to create a statement list inside parenthesis, use a sigil before the parenthesis:

```Raku
say so (42) eqv $(my $a = 42; $a;);
# OUTPUT: «True␤» 
say so (42,42) eqv (my $a = 42; $a;);
# OUTPUT: «True␤» 
```

可以使用下标将单个元素从列表中拉出。列表的第一个元素位于索引号零处：

Individual elements can be pulled out of a list using a subscript. The first element of a list is at index number zero:

```Raku
say (1, 2)[0];  # says 1 
say (1, 2)[1];  # says 2 
say (1, 2)[2];  # says Nil 
say (1, 2)[-1]; # Error 
say ((<a b>,<c d>),(<e f>,<g h>))[1;0;1]; # says "f" 
```

<a id="-%E7%AC%A6%E5%8F%B7--the--sigil"></a>
# @ 符号 / The @ sigil

Raku 中名带有 `@` 符号的变量应该包含某种类似列表的对象。当然，其他变量也可能包含这些对象，但是 `@` 符号变量总是包含这些对象。

Variables in Raku whose names bear the `@` sigil are expected to contain some sort of list-like object. Of course, other variables may also contain these objects, but `@`-sigiled variables always do, and are expected to act the part.

默认情况下，当将 `List` 分配给一个 `@` 符号变量时，将创建一个 `Array`。这些内容如下所述。如果你希望使用 `@` 符号变量直接引用 `List` 对象，则可以使用 `:=` 绑定。

By default, when you assign a `List` to an `@`-sigiled variable, you create an `Array`. Those are described below. If instead you want to refer directly to a `List` object using an `@`-sigiled variable, you can use binding with `:=` instead.

```Raku
my @a := 1, 2, 3;
```

`@` 符号的变量表现得像列表的方法是支持 [位置下标](https://rakudocs.github.io/language/subscripts)。 任何绑定 `@` 符号的值必须支持 [Positional](https://rakudocs.github.io/type/Positional) 角色，这意味着下面的语句注定失败：

One of the ways `@`-sigiled variables act like lists is by always supporting [positional subscripting](https://rakudocs.github.io/language/subscripts). Anything bound to a `@`-sigiled value must support the [Positional](https://rakudocs.github.io/type/Positional) role which guarantees that this is going to fail:

```Raku
my @a := 1; # Type check failed in binding; expected Positional but got Int 
```

<a id="%E9%87%8D%E7%BD%AE%E5%88%97%E8%A1%A8%E5%AE%B9%E5%99%A8--reset-a-list-container"></a>
# 重置列表容器 / Reset a list container

从位置容器中删除所有元素可以赋值 [`Empty`](https://rakudocs.github.io/type/Slip#Empty)、空列表 `()` 或者 空列表的 `Slip` 形式给容器。

To remove all elements from a Positional container assign [`Empty`](https://rakudocs.github.io/type/Slip#Empty), the empty list `()` or a `Slip` of the empty list to the container.

```Raku
my @a = 1, 2, 3;
@a = ();
@a = Empty;
@a = |();
```

<a id="%E8%BF%AD%E4%BB%A3--iteration"></a>
# 迭代 / Iteration

可以迭代所有列表，这意味着按顺序从列表中取出每个元素，并在最后一个元素之后停止：

All lists may be iterated, which means taking each element from the list in order and stopping after the last element:

```Raku
for 1, 2, 3 { .say }  # OUTPUT: «1␤2␤3␤» 
```

<a id="%E5%8D%95%E5%8F%82%E6%95%B0%E8%A7%84%E5%88%99--single-argument-rule"></a>
## 单参数规则 / Single Argument Rule

传递给迭代器（如 `for` ）的参数集被视为单个参数，而不是多个参数；即 `some-iterator( a, b, c, ...)` 将始终被视为 `some-iterator( list-or-array(a, b, c))`，而不是 `(some-iterator(a))(b)...`，即迭代应用迭代器到第一个参数，然后是下一个参数的结果，依此类推。在这个例子中

It is the rule by which the set of parameters passed to an iterator such as `for` is treated as a single argument, instead of several arguments; that is `some-iterator( a, b, c, ...)` will always be treated as `some-iterator( list-or-array(a, b, c))` and never as `(some-iterator(a))(b)...`, that is, iterative application of the iterator to the first argument, then the result to the next argument, and so on. In this example

```Raku
my @list = [ (1, 2, 3),
             (1, 2, ),
             [<a b c>, <d e f>],
             [[1]] ];
 
for @list -> @element {
  say "{@element} → {@element.^name}";
    for @element -> $sub-element {
      say $sub-element;
    }
}
# OUTPUT 
#1 2 3 → List 
#1 
#2 
#3 
#1 2 → List 
#1 
#2 
#a b c d e f → Array 
#(a b c) 
#(d e f) 
#1 → Array 
#1 
```

由于 `for` 接收的是单个参数，因此它将被视为要循环访问的元素列表。经验法则是[如果有逗号，它前面的任何东西都是一个元素](https://perl6advent.wordpress.com/2015/12/14/day-15-2015-the-year-of-the-great-list-refactor/)并且这样创建的列表就变成了*单个元素*。这是在两个数组之间用逗号分隔的情况下发生的，逗号是我们正在迭代的 `Array` 中的第三个数组。一般来说，引用上述文章，单参数规则 *... 使行为如程序员所期望的那样。

Since what `for` receives is a single argument, it will be treated as a list of elements to iterate over. The rule of thumb is that [if there's a comma, anything preceding it is an element](https://perl6advent.wordpress.com/2015/12/14/day-15-2015-the-year-of-the-great-list-refactor/) and the list thus created becomes the *single element*. That happens in the case of the two arrays separated by a comma which are the third in the `Array` we are iterating. In general, quoting the article linked above, the single argument rule *... makes for behavior as the programmer would expect*.

<a id="%E6%88%90%E5%91%98%E6%B5%8B%E8%AF%95--testing-for-elements"></a>
# 成员测试 / Testing for elements

要测试是否为列表或者数组的成员，可以使用 ["是否成员"](https://rakudocs.github.io/language/setbagmix#infix_%28elem%29) [`Set`](https://rakudocs.github.io/type/Set) 操作符

To test for elements in a `List` or `Array`, you can use the ["is element of"](https://rakudocs.github.io/language/setbagmix#infix_%28elem%29) [`Set`](https://rakudocs.github.io/type/Set) operator.

```Raku
my @a = <foo bar buzz>;
say 'bar' (elem) @a;    # OUTPUT: «True␤» 
say 'bar' ∈ @a;         # same, using unicode version of operator 
```

这相当于：

This is the equivalent of:

```Raku
'bar' (elem) @a.Set;    # convert the array to a Set first 
```

但是，如果可能的话，它实际上不会进行转换。

except that, if possible, it won't actually do the conversion.

它基本上使用 [===](https://rakudocs.github.io/routine/===) 运算符将值与数组中的每个元素进行比较。如果你想使用另一种方法来比较值，你应该使用 [first](https://rakudocs.github.io/routine/first#%28List%29_routine_first)。

It basically compares the value with each element in the array using the [===](https://rakudocs.github.io/routine/===) infix operator. If you want to use another way to compare values, you probably should use [first](https://rakudocs.github.io/routine/first#%28List%29_routine_first).

<a id="%E5%BA%8F%E5%88%97--sequences"></a>
## 序列 / Sequences

并不是所有的列表都充满了元素。有些只创建所需的元素。这些被称为序列，其类型为 [Seq](https://rakudocs.github.io/type/Seq)。当它发生时，循环返回 `Seq`。

Not all lists are born full of elements. Some only create as many elements as they are asked for. These are called sequences, which are of type [Seq](https://rakudocs.github.io/type/Seq). As it so happens, loops return `Seq`s.

```Raku
(loop { 42.say })[2]  # OUTPUT: «42␤42␤42␤» 
```

所以，在 Raku 中拥有无限的列表是很好的，只要你从不要求它们提供所有元素。在某些情况下，你可能希望避免询问它们的长度——如果 Raku 知道序列是无限的，它将尝试返回 `Inf`，但它不能总是知道。

So, it is fine to have infinite lists in Raku, just so long as you never ask them for all their elements. In some cases, you may want to avoid asking them how long they are too – Raku will try to return `Inf` if it knows a sequence is infinite, but it cannot always know.

这些列表可以使用 [...](https://rakudocs.github.io/language/operators#infix_...) 运算符构建，该运算符使用各种生成表达式构建惰性列表。

These lists can be built using the [...](https://rakudocs.github.io/language/operators#infix_...) operator, which builds lazy lists using a variety of generating expressions.

尽管 `Seq` 类提供了一些位置订阅，但它不提供 `Positional` 的完整接口，因此 `@` 变量可能**未**绑定到`Seq`，尝试这样做会产生错误。

Although the `Seq` class does provide some positional subscripting, it does not provide the full interface of `Positional`, so an `@`-sigiled variable may **not** be bound to a `Seq`, and trying to do so will yield an error.

```Raku
my @s := <a b c>.Seq; CATCH { default { say .^name, ' ', .Str } }
# OUTPUT «X::TypeCheck::Binding Type check failed in binding; expected Positional but got Seq ($(("a", "b","c").Seq))␤» 
```

这是因为 `Seq` 在使用后不保留值。如果你有一个非常长的序列，这是很有用的行为，因为你可能希望在使用它们之后丢弃值，这样你的程序就不会填满内存。例如，处理一百万行的文件时：

This is because the `Seq` does not keep values around after you have used them. This is useful behavior if you have a very long sequence, as you may want to throw values away after using them, so that your program does not fill up memory. For example, when processing a file of a million lines:

```Raku
for 'filename'.IO.lines -> $line {
    do-something-with($line);
}
```

你可以确信，文件的全部内容不会留在记忆中，除非你明确地在某个地方保存这些内容。

You can be confident that the entire content of the file will not stay around in memory, unless you are explicitly storing the lines somewhere.

另一方面，在某些情况下，你可能希望保留旧值。可以将 `Seq` 隐藏在 `List` 中，它仍然是懒惰的，但会记住旧值。这是通过调用 `.list` 方法完成的。由于这个 `.list` 完全支持 `Positional`，可以将它直接绑定到一个 `@` 变量。

On the other hand, you may want to keep old values around in some cases. It is possible to hide a `Seq` inside a `List`, which will still be lazy, but will remember old values. This is done by calling the `.list` method. Since this `List` fully supports `Positional`, you may bind it directly to an `@`-sigiled variable.

```Raku
my @s := (loop { 42.say }).list;
@s[2]; # says 42 three times 
@s[1]; # does not say anything 
@s[4]; # says 42 two more times 
```

还可以使用 `.cache` 方法而不是 `.list`，这取决于你希望如何处理引用。有关详细信息，请参阅 [`Seq` 页面](https://rakudocs.github.io/type/Seq)。

You may also use the `.cache` method instead of `.list`, depending on how you want the references handled. See the [page on `Seq`](https://rakudocs.github.io/type/Seq) for details.

<a id="%E4%BD%BF%E7%94%A8-iterator--using-iterator"></a>
## 使用 `.iterator` / Using `.iterator`

所有列表都混合在[迭代器](https://rakudocs.github.io/type/Iterator)角色中，因此它们可以使用 `.iterator` 方法对列表进行更好的控制。我们可以这样使用它，例如：

All lists mix in the [Iterator](https://rakudocs.github.io/type/Iterator) role, and as such have an `.iterator` method they can use for a finer control over a list. We can use it like this, for instance:

```Raku
my @multiples-of-five = 0,5,10 … 500;
my $odd-iterator = @multiples-of-five.iterator;
my $odd;
repeat {
    $odd-iterator.skip-one;
    $odd = $odd-iterator.pull-one;
    say "→ $odd";
} until $odd.Str eq IterationEnd.Str;
```

我们没有像在 `for` 循环中那样隐式地使用迭代器，而是将它显式地分配给 `$odd-iterator` 变量，以便只处理序列的奇数元素。这样，我们可以使用 `.skip-one` 跳过偶数元素。我们必须明确测试终止，这是在 `until` 表达式中进行的。当没有剩余的东西可以迭代时，`$odd` 将具有值 `IterationEnd`。请查看[迭代器文档](https://rakudocs.github.io/type/Iterator)，了解可用的方法和函数。

Instead of using the iterator implicitly as we do in `for` loops, we explicitly assign it to the `$odd-iterator` variable to work over the odd elements of the sequence only. That way, we can skip even elements using `.skip-one`. We do have to test explicitly for termination, which we do in the `until` expression. When there's nothing left to iterate, `$odd` will have the value `IterationEnd`. Please check the [documentation on `Iterator`s](https://rakudocs.github.io/type/Iterator) for the methods and functions that are available.

<a id="slips"></a>
## Slips

有时，你希望将列表的元素插入到另一个列表中。这可以通过一种特殊类型的列表来实现，称为 [Slip](https://rakudocs.github.io/type/Slip)。

Sometimes you want to insert the elements of a list into another list. This can be done with a special type of list called a [Slip](https://rakudocs.github.io/type/Slip).

```Raku
say (1, (2, 3), 4) eqv (1, 2, 3, 4);         # OUTPUT: «False␤» 
say (1, Slip.new(2, 3), 4) eqv (1, 2, 3, 4); # OUTPUT: «True␤» 
say (1, slip(2, 3), 4) eqv (1, 2, 3, 4);     # OUTPUT: «True␤» 
```

另一种制作 `Slip` 的方法是使用 `|` 前缀操作符。请注意，这比逗号的优先级更高，因此它只影响单个值，但与上述选项不同，它将打散[标量](https://rakudocs.github.io/type/Scalar)。

Another way to make a `Slip` is with the `|` prefix operator. Note that this has a tighter precedence than the comma, so it only affects a single value, but unlike the above options, it will break [Scalars](https://rakudocs.github.io/type/Scalar).

```Raku
say (1, |(2, 3), 4) eqv (1, 2, 3, 4);        # OUTPUT: «True␤» 
say (1, |$(2, 3), 4) eqv (1, 2, 3, 4);       # OUTPUT: «True␤» 
say (1, slip($(2, 3)), 4) eqv (1, 2, 3, 4);  # OUTPUT: «False␤» 
```

<a id="%E6%83%B0%E6%80%A7%E5%88%97%E8%A1%A8--lazy-lists"></a>
# 惰性列表 / Lazy lists

`List`、`Seq`、`Array` 和任何其他实现 [Iterator](https://rakudocs.github.io/type/Iterator) 角色的类都是惰性的，这意味着它们的值是按需计算的，并存储以备以后使用。创建懒惰对象的方法之一是使用 [gather/take](https://rakudocs.github.io/language/control#gather%2Ftake) 或[序列运算符](https://rakudocs.github.io/language/operators#infix_...)。你还可以编写一个实现角色[迭代器](https://rakudocs.github.io/type/Iterator)的类，并在调用 [is-lazy](https://rakudocs.github.io/routine/is-lazy) 时返回 `True`。请注意，某些方法（如 `elems`）不能在惰性列表中调用，并将导致引发 [Exception](https://rakudocs.github.io/type/Exception)。

`List`s, `Seq`s, `Array`s and any other class that implements the [Iterator](https://rakudocs.github.io/type/Iterator) role can be lazy, which means that their values are computed on demand and stored for later use. One of the ways to create a lazy object is to use [gather/take](https://rakudocs.github.io/language/control#gather%2Ftake) or the [sequence operator](https://rakudocs.github.io/language/operators#infix_...). You can also write a class that implements the role [Iterator](https://rakudocs.github.io/type/Iterator) and returns `True` on a call to [is-lazy](https://rakudocs.github.io/routine/is-lazy). Please note that some methods like `elems` cannot be called on a lazy List and will result in a thrown [Exception](https://rakudocs.github.io/type/Exception).

```Raku
# This array is lazy and its elements will not be available 
# until explicitly requested. 
 
my @lazy-array = lazy 1, 11, 121 ... 10**100;
say @lazy-array.is-lazy;     # OUTPUT: «True␤» 
say @lazy-array[];           # OUTPUT: «[...]␤» 
 
# Once all elements have been retrieved, the list 
# is no longer considered lazy. 
 
my @no-longer-lazy = eager @lazy-array;  # Forcing eager evaluation 
say @no-longer-lazy.is-lazy;             # OUTPUT: «False␤» 
say @no-longer-lazy[];
# OUTPUT: (sequence starting with «[1 11 121» ending with a 300 digit number) 
```

在上面的示例中，`@lazy-array` 是一个数组，通过构造，它被设置为惰性。对其调用 `is-lazy` 实际上调用了角色 `Iterator` 混合的方法，因为它源自一个懒惰列表，所以它本身就是懒惰的。

In the example above, `@lazy-array` is an `Array` which, through construction, is made `lazy`. Calling `is-lazy` on it actually calls the method mixed in by the role `Iterator`, which, since it originates in a lazy list, is itself lazy.

对于惰性序列，一个常见的用例是处理无限的数字序列，这些序列的值还没有计算出来，也不能全部计算出来。列表中的特定值仅在需要时计算。

A common use case for lazy `Seq`s is the processing of infinite sequences of numbers, whose values have not been computed yet and cannot be computed in their entirety. Specific values in the List will only be computed when they are needed.

```Raku
my  $l := 1, 2, 4, 8 ... Inf;
say $l[0..16];
#OUTPUT: «(1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536)␤» 
```

你可以很容易地将惰性对象赋值给其他对象并且保留他们的惰性：

You can easily assign lazy objects to other objects, conserving their laziness:

```Raku
my  $l := 1, 2, 4, 8 ... Inf; # This is a lazy Seq. 
my  @lazy-array = $l;
say @lazy-array[10..15]; # OUTPUT: «(1024 2048 4096 8192 16384 32768)␤» 
say @lazy-array.is-lazy; # OUTPUT: «True␤» 
```

<a id="%E4%B8%8D%E5%8F%98%E6%80%A7--immutability"></a>
# 不变性 / Immutability

到目前为止我们讨论过的列表（`List`、`Seq`和 `Slip`）都是不可变的。这意味着你不能从中删除元素，也不能重新绑定现有元素：

The lists we have talked about so far (`List`, `Seq` and `Slip`) are all immutable. This means you cannot remove elements from them, or re-bind existing elements:

```Raku
(1, 2, 3)[0]:delete; # Error Can not remove elements from a List 
(1, 2, 3)[0] := 0;   # Error Cannot use bind operator with this left-hand side 
(1, 2, 3)[0] = 0;    # Error Cannot modify an immutable Int 
```

但是，如果任何元素被包装在一个 [`Scalar`](https://rakudocs.github.io/type/Scalar) 中，仍然可以更改 `Scalar` 指向的值：

However, if any of the elements is wrapped in a [`Scalar`](https://rakudocs.github.io/type/Scalar) you can still change the value which that `Scalar` points to:

```Raku
my $a = 2;
(1, $a, 3)[1] = 42;
$a.say;            # OUTPUT: «42␤» 
```

也就是说，只有列表结构本身——有多少个元素以及每个元素的标识——是不可变的。不变性不会通过元素的身份传染。

that is, it is only the list structure itself – how many elements there are and each element's identity – that is immutable. The immutability is not contagious past the identity of the element.

<a id="%E5%88%97%E8%A1%A8%E4%B8%8A%E4%B8%8B%E6%96%87--list-contexts"></a>
# 列表上下文 / List contexts

到目前为止，我们主要是在中性环境下处理列表。列表实际上在语法级别上对上下文非常敏感。

So far we have mostly dealt with lists in neutral contexts. Lists are actually very context sensitive on a syntactical level.

<a id="%E5%88%97%E8%A1%A8%E5%88%86%E9%85%8D%E4%B8%8A%E4%B8%8B%E6%96%87--list-assignment-context"></a>
## 列表分配上下文 / List assignment context

当一个列表（或者将要转换成列表的东西）出现在赋值的右侧，变成一个 `@` 变量时，它会被“急切地”评估。例如，这意味着 `Seq` 将被迭代，直到不能再生成任何元素。这是你不希望放置无限列表的地方之一，以免程序挂起，最终耗尽内存：

When a list (or something that is going to be converted into a list) appears on the right-hand side of an assignment into a `@`-sigiled variable, it is "eagerly" evaluated. This means that a `Seq` will be iterated until it can produce no more elements, for instance. This is one of the places you do not want to put an infinite list, lest your program hang and, eventually, run out of memory:

```Raku
my @divisors = (gather {
    for <2 3 5 7> {
        take $_ if 70 %% $_;
    }
});
say @divisors; # OUTPUT: «[2 5 7]␤» 
```

[`gather` 语句](https://rakudocs.github.io/language/control#index-entry-lazy_list_gather)创建一个惰性列表，当赋值给 `@divisors` 变量时会被急切地评估。

The [`gather` statement](https://rakudocs.github.io/language/control#index-entry-lazy_list_gather) creates a lazy list, which is eagerly evaluated when assigned to `@divisors`.

<a id="%E6%89%81%E5%B9%B3%E5%8C%96%E2%80%9C%E4%B8%8A%E4%B8%8B%E6%96%87%E2%80%9D--flattening-context"></a>
## 扁平化“上下文” / Flattening "context"

当你有一个包含子列表的列表，但你只需要一个简单列表时，可以将该列表展平以生成一个值序列，就像删除了所有括号一样。不管括号嵌套多少层，这都有效。

When you have a list that contains sub-lists, but you only want one flat list, you may flatten the list to produce a sequence of values as if all parentheses were removed. This works no matter how many levels deep the parentheses are nested.

```Raku
say (1, (2, (3, 4)), 5).flat eqv (1, 2, 3, 4, 5) # OUTPUT: «True␤» 
```

这并不是一个真正的语法“上下文”，而是一个迭代过程，但它具有上下文的外观。

This is not really a syntactical "context" as much as it is a process of iteration, but it has the appearance of a context.

请注意，列表周围的 [`Scalar`](https://rakudocs.github.io/type/Scalar) 将使其不受扁平化的影响：

Note that [`Scalar`s](https://rakudocs.github.io/type/Scalar) around a list will make it immune to flattening:

```Raku
for (1, (2, $(3, 4)), 5).flat { .say } # OUTPUT: «1␤2␤(3 4)␤5␤» 
```

…但是一个带 `@` 标记的变量会溢出它的元素。

...but an `@`-sigiled variable will spill its elements.

```Raku
my @l := 2, (3, 4);
for (1, @l, 5).flat { .say };      # OUTPUT: «1␤2␤3␤4␤5␤» 
my @a = 2, (3, 4);                 # Arrays are special, see below 
for (1, @a, 5).flat { .say };      # OUTPUT: «1␤2␤(3 4)␤5␤» 
```

<a id="%E5%8F%82%E6%95%B0%E5%88%97%E8%A1%A8%EF%BC%88capture%EF%BC%89%E4%B8%8A%E4%B8%8B%E6%96%87--argument-list-capture-context"></a>
## 参数列表（Capture）上下文 / Argument list (Capture) context

当列表显示为函数或方法调用的参数时，将使用特殊的语法规则：列表将立即转换为 `Capture` 对象。`Capture` 本身有一个列表（`.list`）和一个哈希（`.hash`）。任何键未被引用或未加括号的 `Pair` 文本都不会进入 `.list`。相反，它们被认为是命名参数并被压缩到 `.hash`。有关此处理的详细信息，请参阅 [`Capture`页面](https://rakudocs.github.io/type/Capture)。

When a list appears as arguments to a function or method call, special syntax rules are at play: the list is immediately converted into a `Capture`. A `Capture` itself has a List (`.list`) and a Hash (`.hash`). Any `Pair` literals whose keys are not quoted, or which are not parenthesized, never make it into `.list`. Instead, they are considered to be named arguments and squashed into `.hash`. See the [page on `Capture`](https://rakudocs.github.io/type/Capture) for the details of this processing.

考虑以下方法从 `List` 创建新的 `Array`。这些方法将 `List` 放在参数列表上下文中，因此 `Array` 只包含 `1` 和 `2`，而不包含 `Pair` `:c(3)`，它会被忽略。

Consider the following ways to make a new `Array` from a `List`. These ways place the `List` in an argument list context and because of that, the `Array` only contains `1` and `2` but not the `Pair` `:c(3)`, which is ignored.

```Raku
Array.new(1, 2, :c(3));
Array.new: 1, 2, :c(3);
new Array: 1, 2, :c(3);
```

相反，这些方法不会将 `List` 放在参数列表上下文中，因此所有元素，甚至 `Pair` `:c(3)`，都放在 `Array` 中。

In contrast, these ways do not place the `List` in argument list context, so all the elements, even the `Pair` `:c(3)`, are placed in the `Array`.

```Raku
Array.new((1, 2, :c(3)));
(1, 2, :c(3)).Array;
my @a = 1, 2, :c(3); Array.new(@a);
my @a = 1, 2, :c(3); Array.new: @a;
my @a = 1, 2, :c(3); new Array: @a;
```

在参数列表上下文中，应用于有 `Positional` 角色的对象的 `|` 前缀运算符始终将列表元素作为位置参数展平给 `Capture` 对象，而应用于有 `Associative` 角色的对象的 `|` 前缀运算符会将键值对作为命名参数给 `Capture` 对象：

In argument list context the `|` prefix operator applied to a `Positional` will always slip list elements as positional arguments to the Capture, while a `|` prefix operator applied to an `Associative` will slip pairs in as named parameters:

```Raku
my @a := 2, "c" => 3;
Array.new(1, |@a, 4);    # Array contains 1, 2, :c(3), 4 
my %a = "c" => 3;
Array.new(1, |%a, 4);    # Array contains 1, 4 
```

<a id="%E5%88%87%E7%89%87%E7%B4%A2%E5%BC%95%E4%B8%8A%E4%B8%8B%E6%96%87--slice-indexing-context"></a>
## 切片索引上下文 / Slice indexing context

从[切片下标](https://rakudocs.github.io/language/subscripts#Slices)中的 `List` 来看，它的特别之处就是没有什么特别的：因为切片的 [adverbs](https://rakudocs.github.io/language/subscripts#Adverbs) 附加在 `]` 之后，切片的内部**不是**一个参数列表，不会有键值对形式的特殊处理。

From the perspective of the `List` inside a [slice subscript](https://rakudocs.github.io/language/subscripts#Slices), is only remarkable in that it is unremarkable: because [adverbs](https://rakudocs.github.io/language/subscripts#Adverbs) to a slice are attached after the `]`, the inside of a slice is **not** an argument list, and no special processing of pair forms happens.

大多数 `Positional` 类型都会对切片索引的每个元素强制使用整数，因此在切片索引中出现的键值对将生成错误：

Most `Positional` types will enforce an integer coercion on each element of a slice index, so pairs appearing there will generate an error, anyway:

```Raku
(1, 2, 3)[1, 2, :c(3)] # OUTPUT: «Method 'Int' not found for invocant of class 'Pair'␤» 
```

…但是，这完全取决于类型——如果它定义了键值对的顺序，那么它可以将 `:c(3)` 视为有效索引。

...however this is entirely up to the type – if it defines an order for pairs, it could consider `:c(3)` a valid index.

切片内的索引通常不会自动展平，但子列表也不会强制为 `Int`。相反，列表结构保持不变，导致嵌套的切片操作复制结果中的结构：

Indices inside a slice are usually not automatically flattened, but neither are sublists usually coerced to `Int`. Instead, the list structure is kept intact, causing a nested slice operation that replicates the structure in the result:

```Raku
say ("a", "b", "c")[(1, 2), (0, 1)] eqv (("b", "c"), ("a", "b")) # OUTPUT: «True␤» 
```

切片也可以使用*半列表*跨多个维度进行，半列表是用分号分隔的切片列表：

Slices can be taken also across several dimensions using *semilists*, which are lists of slices separated by semicolons:

```Raku
my @sliceable = [[ ^10 ], ['a'..'h'], ['Ⅰ'..'Ⅺ']];
say @sliceable[ ^3; 4..6 ]; #OUTPUT: «(4 5 6 e f g Ⅴ Ⅵ Ⅶ)␤» 
```

它是从三个第一维度 (`^3`) 中选择第 4 到第 6 个元素。

which is selecting the 4 to 6th element from the three first dimensions (`^3`).

<a id="%E8%8C%83%E5%9B%B4%E4%B8%BA%E5%88%87%E7%89%87--range-as-slice"></a>
## 范围为切片 / Range as slice

[`Range`](https://rakudocs.github.io/type/Range) 是上下边界的容器，可以只有上边界或者只有下边界。生成带有 `Range` 的切片将包含边界之间的任何索引，但无限范围将 [截断](https://rakudocs.github.io/language/subscripts#Truncating_slices)不存在的元素。具有排除上边界的无限范围仍然是无限的，并且将到达所有元素。

A [`Range`](https://rakudocs.github.io/type/Range) is a container for a lower and an upper boundary, either of which may be excluded. Generating a slice with a `Range` will include any index between the bounds, though an infinite Range will [truncate](https://rakudocs.github.io/language/subscripts#Truncating_slices) non-existent elements. An infinite range with excluded upper boundary (e.g. `0..^Inf`) is still infinite and will reach all elements.

```Raku
my @a = 1..5;
say @a[0..2];     # OUTPUT: «(1 2 3)␤» 
say @a[0..^2];    # OUTPUT: «(1 2)␤» 
say @a[0..*];     # OUTPUT: «(1 2 3 4 5)␤» 
say @a[0..^*];    # OUTPUT: «(1 2 3 4 5)␤» 
say @a[0..Inf-1]; # OUTPUT: «(1 2 3 4 5)␤» 
```

请注意，当上边界是 WhateverCode 而不是 Whatever 时，范围不是无限的，而是一个生成 Range 的可调用函数。这是 [..](https://rakudocs.github.io/type/Range) 运算符的正常行为。下标运算符 [[\]](https://rakudocs.github.io/language/subscripts#Slices) 评估 WhateverCode 时将
列表的 `.elems` 作为参数，并使用结果范围进行切片：

Note that when the upper boundary is a WhateverCode instead of just a Whatever, the range is not infinite but becomes a Callable producing Ranges. This is normal behavior of the [..](https://rakudocs.github.io/type/Range) operator. The subscript operator [[\]](https://rakudocs.github.io/language/subscripts#Slices) evaluates the WhateverCode providing the list's `.elems` as an argument and uses the resulting range to slice:

```Raku
    say @a[0..*-1];   # OUTPUT: «(1 2 3 4 5)␤» 
    say @a[0..^*-1];  # OUTPUT: «(1 2 3 4)␤» 
    # Produces 0..^2.5 as the slice range 
    say @a[0..^*/2];  # OUTPUT: «(1 2 3)␤» 
```

请注意，`0..^*` 和 `0..^*+0` 在下标中的行为一致，尽管其中一个是无限范围，另一个是生成范围的 WhateverCode，但 `0..*+0` 将为你提供额外的尾随 `Nil`，因为与无限范围 `0..*` 不同，它不会截断。

Notice that `0..^*` and `0..^*+0` behave consistently in subscripts despite one being an infinite range and the other a WhateverCode producing ranges, but `0..*+0` will give you an additional trailing `Nil` because, unlike the infinite range `0..*`, it does not truncate.

<a id="%E6%95%B0%E7%BB%84%E6%9E%84%E9%80%A0%E5%99%A8%E4%B8%8A%E4%B8%8B%E6%96%87--array-constructor-context"></a>
## 数组构造器上下文 / Array constructor context

在数组字面量中，初始化值的列表不在 capture 上下文中，只是一个普通的列表。然而，它被急切地求值，就像在赋值中一样。

Inside an Array Literal, the list of initialization values is not in capture context and is just a normal list. It is, however, eagerly evaluated just as in assignment.

```Raku
say so [ 1, 2, :c(3) ] eqv Array.new((1, 2, :c(3))); # OUTPUT: «True␤» 
[while $++ < 2 { 42.say; 43 }].map: *.say;           # OUTPUT: «42␤42␤43␤43␤» 
(while $++ < 2 { 42.say; 43 }).map: *.say;           # OUTPUT: «42␤43␤42␤43␤» 
```

这给我们带来了数组…

Which brings us to Arrays...

<a id="%E6%95%B0%E7%BB%84--arrays"></a>
# 数组 / Arrays

数组与列表的区别主要有三种：它们的元素可以被类型化，它们自动条目化它们的元素，并且它们是可变的。否则，它们是列表。

Arrays differ from lists in three major ways: Their elements may be typed, they automatically itemize their elements, and they are mutable. Otherwise they are Lists and are accepted wherever lists are.

```Raku
say Array ~~ List     # OUTPUT: «True␤» 
```

第四个更微妙的不同之处在于，当使用数组时，有时很难保持懒惰或使用无限序列。

A fourth, more subtle, way they differ is that when working with Arrays, it can sometimes be harder to maintain laziness or work with infinite sequences.

<a id="%E5%BD%95%E5%85%A5--typing"></a>
## 录入 / Typing

数组可以有类型，这样在赋值时会执行类型检查。只允许分配 `Int` 值的数组的类型为 `Array[Int]`，可以使用 `Array[Int].new` 创建一个数组。如果你只打算为此目的使用 `@` 变量，则可以通过在声明元素时指定元素类型来更改其类型：

Arrays may be typed such that their slots perform a typecheck whenever they are assigned to. An Array that only allows `Int` values to be assigned is of type `Array[Int]` and one can create one with `Array[Int].new`. If you intend to use an `@`-sigiled variable only for this purpose, you may change its type by specifying the type of the elements when declaring it:

```Raku
my Int @a = 1, 2, 3;              # An Array that contains only Ints 
# the same as 
my @a of Int = 1, 2, 3;           # An Array of Ints 
my @b := Array[Int].new(1, 2, 3); # Same thing, but the variable is not typed 
my @b := Array[Int](1, 2, 3);     # Rakudo shortcut for the same code 
say @b eqv @a;                    # says True. 
my @c = 1, 2, 3;                  # An Array that can contain anything 
say @b eqv @c;                    # says False because types do not match 
say @c eqv (1, 2, 3);             # says False because one is a List 
say @b eq @c;                     # says True, because eq only checks values 
say @b eq (1, 2, 3);              # says True, because eq only checks values 
 
@a[0] = 42;                       # fine 
@a[0] = "foo";                    # error: Type check failed in assignment 
```

在上例中我们我们绑定一个有类型的数组对象到无类型的 `@` 变量。反过来是不行的，你不可以绑定一个错误类型的数组到一个带类型的 `@` 变量：

In the above example we bound a typed Array object to a `@`-sigil variable for which no type had been specified. The other way around does not work – you may not bind an Array that has the wrong type to a typed `@`-sigiled variable:

```Raku
my @a := Array[Int].new(1, 2, 3);     # fine 
@a := Array[Str].new("a", "b");       # fine, can be re-bound 
my Int @b := Array[Int].new(1, 2, 3); # fine 
@b := Array.new(1, 2, 3);             # error: Type check failed in binding 
```

使用类型化数组时，必须记住它们名义上是类型化的。这意味着数组的声明类型才是重要的。以下子例程声明：

When working with typed arrays, it is important to remember that they are nominally typed. This means the declared type of an array is what matters. Given the following sub declaration:

```Raku
sub mean(Int @a) {
    @a.sum / @a.elems
}
```

传递 Array[Int] 参数没问题：

Calls that pass an Array[Int] will be successful:

```Raku
my Int @b = 1, 3, 5;
say mean(@b);                       # @b is Array[Int] 
say mean(Array[Int].new(1, 3, 5));  # Anonymous Array[Int] 
say mean(my Int @ = 1, 3, 5);       # Another anonymous Array[Int] 
```

但是，由于传递一个非类型化数组，以下调用都将失败，即使该数组恰好在传递点包含 Int 值：

However, the following calls will all fail, due to passing an untyped array, even if the array just happens to contain Int values at the point it is passed:

```Raku
my @c = 1, 3, 5;
say mean(@c);                       # Fails, passing untyped Array 
say mean([1, 3, 5]);                # Same 
say mean(Array.new(1, 3, 5));       # Same again 
```

请注意，在任何给定的编译器中，可能会有一些奇特的方法来绕过数组上的类型检查，因此在处理不受信任的输入时，最好在重要的地方执行额外的类型检查：

Note that in any given compiler, there may be fancy, under-the-hood, ways to bypass the type check on arrays, so when handling untrusted input, it can be good practice to perform additional type checks, where it matters:

```Raku
for @a -> Int $i { $_++.say };
```

但是，只要你坚持在代码的可信区域内执行正常的赋值操作，这就不会是问题，并且如果在编译时无法捕获类型检查错误，则在赋值给数组的过程中，类型检查错误将立即发生。Raku 中提供的用于列表操作的核心函数都不应该产生一个不稳定的有类型的数组。

However, as long as you stick to normal assignment operations inside a trusted area of code, this will not be a problem, and typecheck errors will happen promptly during assignment to the array, if they cannot be caught at compile time. None of the core functions provided in Raku for operating on lists should ever produce a wonky typed Array.

不存在的元素（索引时）或已分配 `Nil` 的元素将采用默认值。此默认值可以使用 `is default` 特性按变量进行调整。请注意，无类型的 `@` 变量的元素类型为 `Mu`，但其默认值是未定义的 `Any`：

Nonexistent elements (when indexed), or elements to which `Nil` has been assigned, will assume a default value. This default may be adjusted on a variable-by-variable basis with the `is default` trait. Note that an untyped `@`-sigiled variable has an element type of `Mu`, however its default value is an undefined `Any`:

```Raku
my @a;
@a.of.perl.say;                 # OUTPUT: «Mu␤» 
@a.default.perl.say;            # OUTPUT: «Any␤» 
@a[0].say;                      # OUTPUT: «(Any)␤» 
my Numeric @n is default(Real);
@n.of.perl.say;                 # OUTPUT: «Numeric␤» 
@n.default.perl.say;            # OUTPUT: «Real␤» 
@n[0].say;                      # OUTPUT: «(Real)␤» 
```

<a id="%E5%AE%9A%E9%95%BF%E6%95%B0%E7%BB%84--fixed-size-arrays"></a>
## 定长数组 / Fixed size arrays

要限制 `Array` 的维度，请在数组容器名称后的方括号中提供由 `,` 或 `;` 分隔的维度，以防有多个维度；这些维度也被称为 *shaped* 数组。此类数组的值将默认为 `Any`。运行时可以通过 `shape` 方法访问形状。

To limit the dimensions of an `Array`, provide the dimensions separated by `,` or `;` in square brackets after the name of the array container in case there is more than one dimension; these are called *shaped* arrays too. The values of such a kind of `Array` will default to `Any`. The shape can be accessed at runtime via the `shape` method.

```Raku
my @a[2,2];
say @a.perl;
# OUTPUT: «Array.new(:shape(2, 2), [Any, Any], [Any, Any])␤» 
say @a.shape;         # OUTPUT: «(2 2)␤» 
my @just-three[3] = <alpha beta kappa>;
say @just-three.perl;
# OUTPUT: «Array.new(:shape(3,), ["alpha", "beta", "kappa"])␤» 
```

Shape 将控制可按维度分配的元素数量：

Shape will control the amount of elements that can be assigned by dimension:

```Raku
my @just-two[2] = <alpha beta kappa>;
# Will throw exception: «Index 2 for dimension 1 out of range (must be 0..1)» 
```

赋值给固定大小的数组将把列表的列表提升为数组的数组（使其在进程中变为可改变）。

Assignment to a fixed size `Array` will promote a List of Lists to an Array of Arrays (making then mutable in the process).

```Raku
my @a[2;2] = (1,2; 3,4);
say @a.Array; # OUTPUT: «[1 2 3 4]␤» 
@a[1;1] = 42;
say @a.perl;
# OUTPUT: «Array.new(:shape(2, 2), [1, 2], [3, 42])␤» 
```

如第三条语句所示，你也可以直接赋值给 shape 数组中的元素。**注**：第二条声明仅适用于 2018.09 的版本。

As the third statement shows, you can assign directly to an element in a shaped array too. **Note**: the second statement works only from version 2018.09.

<a id="%E6%9D%A1%E7%9B%AE%E5%8C%96--itemization"></a>
## 条目化 / Itemization

对于大多数情况，`Array` 由多个槽组成，每个槽都包含正确类型的标量。每个这样的标量依次包含该类型的值。 Raku 将自动检查值的类型，并在初始化、分配或构造数组时创建包含这些值的标量。

For most uses, `Array`s consist of a number of slots each containing a `Scalar` of the correct type. Every such `Scalar`, in turn, contains a value of that type. Raku will automatically type-check values and create Scalars to contain them when Arrays are initialized, assigned to, or constructed.

这实际上是深刻理解 Raku 列表处理最难的部分之一。

This is actually one of the trickiest parts of Raku list handling to get a firm understanding of.

首先，请注意，因为假定数组中的条目化，所以它本质上意味着如果你不亲自将它们放在数组中，那么将把 `$(…)` 放在分配给数组的所有内容周围。另一方面，Array.perl 不将 `$` 放在显式显示变量中，与 List.perl 不同：

First, be aware that because itemization in Arrays is assumed, it essentially means that `$(…)`s are being put around everything that you assign to an array, if you do not put them there yourself. On the other side, Array.perl does not put `$` to explicitly show scalars, unlike List.perl:

```Raku
((1, 2), $(3, 4)).perl.say; # says "((1, 2), $(3, 4))" 
[(1, 2), $(3, 4)].perl.say; # says "[(1, 2), (3, 4)]" 
                            # ...but actually means: "[$(1, 2), $(3, 4)]" 
```

结果发现，所有这些额外的美元符号和圆括号对用户来说都是一种伤害，而不是一种好处。基本上，当你看到一个方括号时，记住看不见的美元符号。

It was decided all those extra dollar signs and parentheses were more of an eye sore than a benefit to the user. Basically, when you see a square bracket, remember the invisible dollar signs.

第二，记住这些看不见的美元符号也可以防止展平，所以你不能通过对 `flat` 或 `.flat` 的正常调用真正展平数组中的元素。

Second, remember that these invisible dollar signs also protect against flattening, so you cannot really flatten the elements inside of an Array with a normal call to `flat` or `.flat`.

```Raku
((1, 2), $(3, 4)).flat.perl.say; # OUTPUT: «(1, 2, $(3, 4)).Seq␤» 
[(1, 2), $(3, 4)].flat.perl.say; # OUTPUT: «($(1, 2), $(3, 4)).Seq␤» 
```

因为方括号不能保护自己不被展平，所以仍然可以使用 `flat` 将数组中的元素溢出到周围的列表中。

Since the square brackets do not themselves protect against flattening, you can still spill the elements out of an Array into a surrounding list using `flat`.

```Raku
(0, [(1, 2), $(3, 4)], 5).flat.perl.say; # OUTPUT: «(0, $(1, 2), $(3, 4), 5).Seq␤» 
```

…然而，元素本身是一体的。

...the elements themselves, however, stay in one piece.

如果有深度嵌套的数组需要展平的数据，这会使用户对你提供的数据感到厌烦。目前，他们必须手动对结构进行深度映射，以取消嵌套：

This can irk users of data you provide if you have deeply nested Arrays where they want flat data. Currently they have to deeply map the structure by hand to undo the nesting:

```Raku
say gather [0, [(1, 2), [3, 4]], $(5, 6)].deepmap: *.take; # OUTPUT: «(1 2 3 4 5 6)␤» 
```

……Raku 的未来版本可能会找到一种更简单的方法。但是，当非逐项列表足够时，不从函数返回数组或条目化列表是应该考虑的对用户的一种礼貌：

... Future versions of Raku might find a way to make this easier. However, not returning Arrays or itemized lists from functions, when non-itemized lists are sufficient, is something that one should consider as a courtesy to their users:

- 使用 `Slip`如果要始终与周围的列表合并。
- 使用非条目化列表当你想让用户更容易展平时。
- 使用条目化数组保护用户不想展平的数据。
- 使用 `Array` 作为条目化列表的非条目化列表，如果恰当的话。
- 使用 `Array` 如果用户想要在不首先拷贝它的情况下转换结果。

- Use `Slip`s when you want to always merge with surrounding lists.
- Use non-itemized lists when you want to make it easy for the user to flatten.
- Use itemized lists to protect things the user probably will not want flattened.
- Use `Arrays` as non-itemized lists of itemized lists, if appropriate.
- Use `Array`s if the user is going to want to mutate the result without copying it first.

数组的所有元素都被条目化（在标量容器中）这一事实，与其说是一个普遍强制的规则，不如说是一个君子协定，而且在类型化数组中进行类型检查的执行情况也不太好。请参阅下面有关绑定到数组插槽的部分。

The fact that all elements of an array are itemized (in `Scalar` containers) is more a gentleman's agreement than a universally enforced rule, and it is less well enforced that typechecks in typed arrays. See the section below on binding to Array slots.

<a id="%E5%AD%97%E9%9D%A2%E9%87%8F%E6%95%B0%E7%BB%84--literal-arrays"></a>
## 字面量数组 / Literal arrays

字面量 `Array` 是用方括号内的 `List` 构造的。`List` 被急切地迭代（如果可能的话，在编译时），其中的值被执行类型检查并条目化。方括号本身在扁平化时会将元素溢出到周围的列表中，但元素本身不会由于逐项化而溢出。

Literal `Array`s are constructed with a `List` inside square brackets. The `List` is eagerly iterated (at compile time if possible) and values in it are each type-checked and itemized. The square brackets themselves will spill elements into surrounding lists when flattened, but the elements themselves will not spill due to the itemization.

<a id="%E5%8F%AF%E5%8F%98%E6%80%A7--mutability"></a>
## 可变性 / Mutability

与列表不同，`Array` 是可变的。元素可以删除、添加或更改。

Unlike lists, `Array`s are mutable. Elements may deleted, added, or changed.

```Raku
my @a = "a", "b", "c";
@a.say;                  # OUTPUT: «[a b c]␤» 
@a.pop.say;              # OUTPUT: «c␤» 
@a.say;                  # OUTPUT: «[a b]␤» 
@a.push("d");
@a.say;                  # OUTPUT: «[a b d]␤» 
@a[1, 3] = "c", "c";
@a.say;                  # OUTPUT: «[a c d c]␤» 
```

<a id="%E8%B5%8B%E5%80%BC--assigning"></a>
### 赋值 / Assigning

将列表赋给 `Array` 是非惰性的。列表将被全部估值，不应是无限的，否则程序可能挂起。同样，对 `Array` 的一个切片的赋值也是非惰性的，但只能达到所请求的有限元素数：

Assignment of a list to an `Array` is eager. The list will be entirely evaluated, and should not be infinite or the program may hang. Assignment to a slice of an `Array` is, likewise, eager, but only up to the requested number of elements, which may be finite:

```Raku
my @a;
@a[0, 1, 2] = (loop { 42 });
@a.say;                     # OUTPUT: «[42 42 42]␤» 
```

在赋值时，将对每个值进行类型检查，以确保它是 `Array` 的允许类型。任何 `Scalar` 都将从每个值中删除，并在其周围包裹一个新的 `Scalar`。

During assignment, each value will be typechecked to ensure it is a permitted type for the `Array`. Any `Scalar` will be stripped from each value and a new `Scalar` will be wrapped around it.

<a id="%E7%BB%91%E5%AE%9A--binding"></a>
### 绑定 / Binding

单个数组元素的绑定方式可能与 `$` 变量的绑定方式相同：

Individual Array slots may be bound the same way `$`-sigiled variables are:

```Raku
my $b = "foo";
my @a = 1, 2, 3;
@a[2] := $b;
@a.say;          # OUTPUT: «[1 2 "foo"]␤» 
$b = "bar";
@a.say;          # OUTPUT: «[1 2 "bar"]␤» 
```

……但强烈建议不要将 `Array` 槽直接绑定到值。如果你这样做了，就可以期待内置功能带来的惊喜。唯一可以这样做的时间是，如果需要知道值和`Scalar` 包装值之间的差异的可变容器，或者对于非常大的 `Array`，不能使用原生类型数组。这样的东西不应该传给毫无戒心的用户。

... But binding `Array` slots directly to values is strongly discouraged. If you do, expect surprises with built-in functions. The only time this would be done is if a mutable container that knows the difference between values and `Scalar`-wrapped values is needed, or for very large `Array`s where a native-typed array cannot be used. Such a creature should never be passed back to unsuspecting users.