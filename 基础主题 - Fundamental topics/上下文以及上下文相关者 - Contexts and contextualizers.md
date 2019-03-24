上下文以及上下文相关者 / Contexts and contextualizers

什么是上下文以及如何深入了解他们。

What are contexts and how to get into them

在许多情况下，需要上下文来解释容器的价值。在 Perl 6 中，我们将使用上下文将容器的值强制转换为某种类型或类，或者决定如何处理它，就像 sink 上下文的情况一样。

A context is needed, in many occasions, to interpret the value of a container. In Perl 6, we will use context to coerce the value of a container into some type or class, or decide what to do with it, as in the case of the sink context.

# Sink

*Sink* 相当于 `void` 上下文，在这种上下文中我们抛出操作的结果或者代码块的返回值。通常，当语句不知道如何处理该值时，将在警告和错误中调用此上下文。

*Sink* is equivalent to `void` context, that is, a context in which we throw (down the sink, as it were) the result of an operation or the return value from a block. In general, this context will be invoked in warnings and errors when a statement does not know what to do with that value.

```Perl6
my $sub = -> $a { return $a² };
$sub; # OUTPUT: «WARNINGS:␤Useless use of $sub in sink context (line 1)␤» 
```

你可以通过使用 [`sink all`](https://docs.perl6.org/routine/sink-all) 方法在[迭代器](https://docs.perl6.org/type/Iterator)上强制 sink 上下文。[proc](https://docs.perl6.org/type/Proc)也可以[通过 `sink` 方法下沉](https://docs.perl6.org/type/Proc#method_sink)，强制它们引发异常而不返回任何内容。

You can force that sink context on [Iterator](https://docs.perl6.org/type/Iterator)s, by using the [`sink-all`](https://docs.perl6.org/routine/sink-all) method. [Proc](https://docs.perl6.org/type/Proc)s can also be [sunk via the `sink` method](https://docs.perl6.org/type/Proc#method_sink), forcing them to raise an exception and not returning anything.

一般来说，如果在 sink 上下文中进行计算，代码块会发出警告；但是，[gather/take 代码块](https://docs.perl6.org/language/control#Flow%2529_gather_take) 会在 sink 上下文中显式计算，并使用 `take` 显式返回值。

In general, blocks will warn if evaluated in sink context; however, [gather/take blocks](https://docs.perl6.org/language/control#Flow%2529_gather_take) are explicitly evaluated in sink context, with values returned explicitly using `take`.

在 sink 上下文中，对象会调用存在的 `sink` 方法：

In sink context, an object will call its `sink` method if present:

```Perl6
sub foo {
    return [<a b c>] does role {
        method sink { say "sink called" }
    }
}
foo
# OUTPUT: sink called 
```

# [Number ](https://docs.perl6.org/language/contexts#___top)

This context, and probably all of them except sink above, are *conversion* or *interpretation* contexts in the sense that they take an untyped or typed variable and duck-type it to whatever is needed to perform the operation. In some cases that will imply a conversion (from [Str](https://docs.perl6.org/type/Str) to [Numeric](https://docs.perl6.org/type/Numeric), for instance); in other cases simply an interpretation ([IntStr](https://docs.perl6.org/type/IntStr) will be interpreted as [Int](https://docs.perl6.org/type/Int) or as [Str](https://docs.perl6.org/type/Str)).

*Number context* is called whenever we need to apply a numerical operation on a variable.

```Perl6
my $not-a-string="1                 ";
my $neither-a-string="3                        ";
say $not-a-string+$neither-a-string; # OUTPUT: «4␤» 
```

In the code above, strings will be interpreted in numeric context as long as there are only a few digits and no other characters. It can have any number of leading or trailing whitespace, however.

Numeric context can be forced by using arithmetic operators such as `+` or `-`. In that context, the [`Numeric`](https://docs.perl6.org/routine/Numeric) method will be called if available and the value returned used as the numeric value of the object.

```Perl6
my $t = True;
my $f = False;
say $t+$f;      # OUTPUT: «1␤» 
say $t.Numeric; # OUTPUT: «1␤» 
say $f.Numeric; # OUTPUT: «0␤» 
my $list= <a b c>;
say True+$list; # OUTPUT: «4␤» 
```

In the case of *listy* things, the numeric value will be in general equivalent to `.elems`; in some cases, like [Thread](https://docs.perl6.org/routine/Numeric#%28Thread%29_method_Numeric) it will return an unique thread identifier.

# [String ](https://docs.perl6.org/language/contexts#___top)

In a *string context*, values can be manipulated as strings. This context is used, for instance, for coercing non-string values so that they can be printed to standard output.

```Perl6
put $very-complicated-and-hairy-object; # OUTPUT: something meaningful 
```

Or when smartmatching to a regular expression:

```Perl6
put 333444777 ~~ /(3+)/; # OUTPUT: «｢333｣␤ 0 => ｢333｣␤» 
```

In general, the [`Str` routine](https://docs.perl6.org/routine/Str) will be called on a variable to contextualize it; since this method is inherited from [Mu](https://docs.perl6.org/type/Mu), it is always present, but it is not always guaranteed to work. In some core classes it will issue a warning.

[`~`](https://docs.perl6.org/routine/~) is the (unary) string contextualizer. As an operator, it concatenates strings, but as a prefix operator it becomes the string context operator.

```Perl6
my @array = [ [1,2,3], [4,5,6]];
say ~@array; # OUTPUT: «1 2 3 4 5 6␤» 
```

This will happen also in a [*reduction*](https://docs.perl6.org/language/operators#Reduction_operators) context, when `[~]` is applied to a list

```Perl6
say [~] [ 3, 5+6i, Set(<a b c>), [1,2,3] ]; # OUTPUT: «35+6ic a b1 2 3␤» 
```

In that sense, empty lists or other containers will stringify to an empty string:

```Perl6
say [~] [] ; # OUTPUT: «␤» 
```

Since [`~` acts also as buffer concatenation operator](https://docs.perl6.org/routine/~#%28Operators%29_infix_~), it will have to check that every element is not empty, since a single empty buffer in string context will behave as a string, thus yielding an error.

```Perl6
say [~] Buf.new(0x3,0x33), Buf.new(0x2,0x22);
# OUTPUT: «Buf:0x<03 33 02 22>␤» 
```

However,

```Perl6
my $non-empty = Buf.new(0x3, 0x33);
my $empty = [];
my $non-empty-also = Buf.new(0x2,0x22);
say [~] $non-empty, $empty, $non-empty-also;
# OUTPUT: «Cannot use a Buf as a string, but you called the Stringy method on it 
```

Since `~` is putting in string context the second element of this list, [`~`](https://docs.perl6.org/routine/~#%28Operators%29_infix_~) is going to be using the second form that applies to strings, thus yielding the shown error. Simply making sure that everything you concatenate is a buffer will avoid this problem.

```Perl6
my $non-empty = Buf.new(0x3, 0x33);
my $empty = Buf.new();
my $non-empty-also = Buf.new(0x2,0x22);
say [~] $non-empty, $empty, $non-empty-also; # OUTPUT: «Buf:0x<03 33 02 22>␤» 
```

In general, a context will coerce a variable to a particular type by calling the contextualizer; in the case of mixins, if the context class is mixed in, it will behave in that way.

```Perl6
my $described-number = 1i but 'Unity in complex plane';
put $described-number; # OUTPUT: «Unity in complex plane␤» 
```

`but` creates a mixin, which endows the complex number with a `Str` method. `put` contextualizes it into a string, that is, it calls `Str`, the string contextualizer, with the result shown above.