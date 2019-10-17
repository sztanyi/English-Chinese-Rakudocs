原文：https://rakudocs.github.io/language/contexts

# 上下文以及上下文语境化器 / Contexts and contextualizers

什么是上下文以及如何深入了解他们。

What are contexts and how to get into them

在许多情况下，需要上下文来解释容器的价值。在 Raku 中，我们将使用上下文将容器的值强制转换为某种类型或类，或者决定如何处理它，就像 sink 上下文的情况一样。

A context is needed, in many occasions, to interpret the value of a container. In Raku, we will use context to coerce the value of a container into some type or class, or decide what to do with it, as in the case of the sink context.

# 目录 / Table of Contents

<!-- MarkdownTOC -->

- [Sink](#sink)
- [Number](#number)
- [String](#string)

<!-- /MarkdownTOC -->


<a id="sink"></a>
# Sink

*Sink* 相当于 `void` 上下文，在这种上下文中我们抛出操作的结果或者代码块的返回值。通常，当语句不知道如何处理该值时，将在警告和错误中调用此上下文。

*Sink* is equivalent to `void` context, that is, a context in which we throw (down the sink, as it were) the result of an operation or the return value from a block. In general, this context will be invoked in warnings and errors when a statement does not know what to do with that value.

```Raku
my $sub = -> $a { return $a² };
$sub; # OUTPUT: «WARNINGS:␤Useless use of $sub in sink context (line 1)␤» 
```

你可以通过使用 [`sink-all`](https://rakudocs.github.io/routine/sink-all) 方法在[迭代器](https://rakudocs.github.io/type/Iterator)上强制 sink 上下文。[Proc](https://rakudocs.github.io/type/Proc)也可以[通过 `sink` 方法下沉](https://rakudocs.github.io/type/Proc#method_sink)，强制它们引发异常而不返回任何内容。

You can force that sink context on [Iterator](https://rakudocs.github.io/type/Iterator)s, by using the [`sink-all`](https://rakudocs.github.io/routine/sink-all) method. [Proc](https://rakudocs.github.io/type/Proc)s can also be [sunk via the `sink` method](https://rakudocs.github.io/type/Proc#method_sink), forcing them to raise an exception and not returning anything.

一般来说，如果在 sink 上下文中进行计算，代码块会发出警告；但是 [gather/take 代码块](https://rakudocs.github.io/language/control#Flow%2529_gather_take) 会在 sink 上下文中显式计算，并使用 `take` 显式返回值。

In general, blocks will warn if evaluated in sink context; however, [gather/take blocks](https://rakudocs.github.io/language/control#Flow%2529_gather_take) are explicitly evaluated in sink context, with values returned explicitly using `take`.

在 sink 上下文中，对象会调用存在的 `sink` 方法：

In sink context, an object will call its `sink` method if present:

```Raku
sub foo {
    return [<a b c>] does role {
        method sink { say "sink called" }
    }
}
foo
# OUTPUT: sink called 
```

<a id="number"></a>
# Number

这个上下文，可能除了上面的 sink 上下文之外，都是*转换*或*解释*上下文，从这个意义上来说，它们接受一个非类型化或类型化的变量，并将其转换为执行操作所需的任何类型。在某些情况下，这意味着转换（例如，从 [Str](https://rakudocs.github.io/type/Str) 转换至 [Numeric](https://rakudocs.github.io/type/Numeric)）;其他情况下，就只是解释（[IntStr](https://rakudocs.github.io/type/IntStr) 被解释为 [Int](https://rakudocs.github.io/type/Int) 或者 [Str](https://rakudocs.github.io/type/Str)）。

This context, and probably all of them except sink above, are *conversion* or *interpretation* contexts in the sense that they take an untyped or typed variable and duck-type it to whatever is needed to perform the operation. In some cases that will imply a conversion (from [Str](https://rakudocs.github.io/type/Str) to [Numeric](https://rakudocs.github.io/type/Numeric), for instance); in other cases simply an interpretation ([IntStr](https://rakudocs.github.io/type/IntStr) will be interpreted as [Int](https://rakudocs.github.io/type/Int) or as [Str](https://rakudocs.github.io/type/Str)).

每当需要对变量应用数值运算时，都会调用*数字上下文*。

*Number context* is called whenever we need to apply a numerical operation on a variable.

```Raku
my $not-a-string="1                 ";
my $neither-a-string="3                        ";
say $not-a-string+$neither-a-string; # OUTPUT: «4␤» 
```

在上面的代码中，字符串将在数字上下文中解释，只要只有几个数字，没有其他字符。但是，它可以有任意数量的前导空格或尾随空格。

In the code above, strings will be interpreted in numeric context as long as there are only a few digits and no other characters. It can have any number of leading or trailing whitespace, however.

数字上下文可以通过使用诸如 `+` 或 `-` 之类的算术运算符来强制执行。在这种情况下，将调用 [`Numeric`](https://rakudocs.github.io/routine/Numeric)方法（如果有的话），返回的值用作对象的数值。

Numeric context can be forced by using arithmetic operators such as `+` or `-`. In that context, the [`Numeric`](https://rakudocs.github.io/routine/Numeric) method will be called if available and the value returned used as the numeric value of the object.

```Raku
my $t = True;
my $f = False;
say $t+$f;      # OUTPUT: «1␤» 
say $t.Numeric; # OUTPUT: «1␤» 
say $f.Numeric; # OUTPUT: «0␤» 
my $list= <a b c>;
say True+$list; # OUTPUT: «4␤» 
```

对于*列表*，它的数字值一般等同于 `.elems`；在某些情况下，例如[线程](https://rakudocs.github.io/routine/Numeric#%28Thread%29_method_Numeric)，它将返回唯一的线程标识符。

In the case of *listy* things, the numeric value will be in general equivalent to `.elems`; in some cases, like [Thread](https://rakudocs.github.io/routine/Numeric#%28Thread%29_method_Numeric) it will return an unique thread identifier.

<a id="string"></a>
# String

在*字符串上下文*中，值可以作为字符串进行操作。例如，此上下文用于强制非字符串值，以便将其打印到标准输出。

In a *string context*, values can be manipulated as strings. This context is used, for instance, for coercing non-string values so that they can be printed to standard output.

```Raku
put $very-complicated-and-hairy-object; # OUTPUT: something meaningful 
```

或者当智能匹配到正则表达式时：

Or when smartmatching to a regular expression:

```Raku
put 333444777 ~~ /(3+)/; # OUTPUT: «｢333｣␤ 0 => ｢333｣␤» 
```

通常，字符串上下文中的变量会调用 [`Str` 例程](https://rakudocs.github.io/routine/Str)；因为这是从 [Mu](https://rakudocs.github.io/type/Mu) 继承的，它总是存在的，但是并不保证每次都正常工作。在一些核心类中它会发出告警。

In general, the [`Str` routine](https://rakudocs.github.io/routine/Str) will be called on a variable to contextualize it; since this method is inherited from [Mu](https://rakudocs.github.io/type/Mu), it is always present, but it is not always guaranteed to work. In some core classes it will issue a warning.

[`~`](https://rakudocs.github.io/routine/~) 是一元字符串上下文语境化器。作为操作符，它连接字符，但是作为前缀操作符，它成了字符串上下文操作符。

[`~`](https://rakudocs.github.io/routine/~) is the (unary) string contextualizer. As an operator, it concatenates strings, but as a prefix operator it becomes the string context operator.

```Raku
my @array = [ [1,2,3], [4,5,6]];
say ~@array; # OUTPUT: «1 2 3 4 5 6␤» 
```

当将 `[~]` 应用于列表时，也将在 [*reduction*](https://rakudocs.github.io/language/operators#Reduction_operators) 上下文中发生这种情况。

This will happen also in a [*reduction*](https://rakudocs.github.io/language/operators#Reduction_operators) context, when `[~]` is applied to a list

```Raku
say [~] [ 3, 5+6i, Set(<a b c>), [1,2,3] ]; # OUTPUT: «35+6ic a b1 2 3␤» 
```

In that sense, empty lists or other containers will stringify to an empty string:

```Raku
say [~] [] ; # OUTPUT: «␤» 
```

由于 [`~` 也是缓冲区连接运算符](https://rakudocs.github.io/routine/~#%28Operators%29_infix_~)，它必须检查每个元素是否都不是空的，因为字符串上下文中的单个空缓冲区将表现为字符串，从而产生错误。

Since [`~` acts also as buffer concatenation operator](https://rakudocs.github.io/routine/~#%28Operators%29_infix_~), it will have to check that every element is not empty, since a single empty buffer in string context will behave as a string, thus yielding an error.

```Raku
say [~] Buf.new(0x3,0x33), Buf.new(0x2,0x22);
# OUTPUT: «Buf:0x<03 33 02 22>␤» 
```

但是

However,

```Raku
my $non-empty = Buf.new(0x3, 0x33);
my $empty = [];
my $non-empty-also = Buf.new(0x2,0x22);
say [~] $non-empty, $empty, $non-empty-also;
# OUTPUT: «Cannot use a Buf as a string, but you called the Stringy method on it 
```

由于 `~` 将这个列表的第二个元素放入字符串上下文中，因此 [`~`](https://rakudocs.github.io/routine/~#%28Operators%29_infix_~) 将使用应用于字符串的第二种形式，从而产生所示的错误。只要确保连接的所有内容都是缓冲区，就可以避免这个问题。

Since `~` is putting in string context the second element of this list, [`~`](https://rakudocs.github.io/routine/~#%28Operators%29_infix_~) is going to be using the second form that applies to strings, thus yielding the shown error. Simply making sure that everything you concatenate is a buffer will avoid this problem.

```Raku
my $non-empty = Buf.new(0x3, 0x33);
my $empty = Buf.new();
my $non-empty-also = Buf.new(0x2,0x22);
say [~] $non-empty, $empty, $non-empty-also; # OUTPUT: «Buf:0x<03 33 02 22>␤» 
```

一般来说，上下文将通过调用上下文语境化器将变量强制为特定类型；在混合的情况下，如果上下文类是混合的，它将以这种方式工作。

In general, a context will coerce a variable to a particular type by calling the contextualizer; in the case of mixins, if the context class is mixed in, it will behave in that way.

```Raku
my $described-number = 1i but 'Unity in complex plane';
put $described-number; # OUTPUT: «Unity in complex plane␤» 
```

`but` 创建一个混合的情况，它赋予复数一个 `Str` 方法。`put` 使其语境化成一个字符串，也就是说，它调用 `Str` 这个字符串上下文语境化器，结果如上图所示。

`but` creates a mixin, which endows the complex number with a `Str` method. `put` contextualizes it into a string, that is, it calls `Str`, the string contextualizer, with the result shown above.
