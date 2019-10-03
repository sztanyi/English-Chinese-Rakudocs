# 下标 / Subscripts

通过索引或键访问数据结构元素

Accessing data structure elements by index or key

通常需要引用集合或数据结构中的特定元素（或元素片段）。借用数学符号，其中向量 *v* 的分量将被称为 *v₁, v₂, v₃*，这个概念在 Perl 6 中被称为“下标”（或“索引”）。

One often needs to refer to a specific element (or slice of elements) from a collection or data structure. Borrowing from mathematical notation where the components of a vector *v* would be referred to as *v₁, v₂, v₃*, this concept is called "subscripting" (or "indexing") in Perl 6.

<!-- MarkdownTOC -->

- [基础 / Basics](#%E5%9F%BA%E7%A1%80--basics)
    - [位置下标 / **Positional** subscripting](#%E4%BD%8D%E7%BD%AE%E4%B8%8B%E6%A0%87--positional-subscripting)
    - [关联下标 / **Associative** subscripting](#%E5%85%B3%E8%81%94%E4%B8%8B%E6%A0%87--associative-subscripting)
    - [应用下标 / Applying subscripts](#%E5%BA%94%E7%94%A8%E4%B8%8B%E6%A0%87--applying-subscripts)
- [不存在的成员 / Nonexistent elements](#%E4%B8%8D%E5%AD%98%E5%9C%A8%E7%9A%84%E6%88%90%E5%91%98--nonexistent-elements)
- [从末尾 / From the end](#%E4%BB%8E%E6%9C%AB%E5%B0%BE--from-the-end)
- [切片 / Slices](#%E5%88%87%E7%89%87--slices)
    - [Truncating slices](#truncating-slices)
    - [Zen slices](#zen-slices)
- [Multiple dimensions](#multiple-dimensions)
- [Modifying elements](#modifying-elements)
- [Autovivification](#autovivification)
- [Binding](#binding)
- [Adverbs](#adverbs)
    - [`:exists`](#exists)
    - [`:delete`](#delete)
    - [`:p`](#p)
    - [`:kv`](#kv)
    - [`:k`](#k)
    - [`:v`](#v)
- [Custom types](#custom-types)
    - [Custom type example](#custom-type-example)
    - [Methods to implement for positional subscripting](#methods-to-implement-for-positional-subscripting)
        - [method elems](#method-elems)
        - [method AT-POS](#method-at-pos)
        - [method EXISTS-POS](#method-exists-pos)
        - [method DELETE-POS](#method-delete-pos)
        - [method ASSIGN-POS](#method-assign-pos)
        - [method BIND-POS](#method-bind-pos)
        - [method STORE](#method-store)
    - [Methods to implement for associative subscripting](#methods-to-implement-for-associative-subscripting)
        - [method AT-KEY](#method-at-key)
        - [method EXISTS-KEY](#method-exists-key)
        - [method DELETE-KEY](#method-delete-key)
        - [method ASSIGN-KEY](#method-assign-key)
        - [method BIND-KEY](#method-bind-key)
        - [method STORE](#method-store-1)

<!-- /MarkdownTOC -->


<a id="%E5%9F%BA%E7%A1%80--basics"></a>
# 基础 / Basics

Perl 6 提供两个通用下标接口：

Perl 6 provides two universal subscripting interfaces:1 

|      | 成员由什么标识 | 接口名字 | 支持的数据结构                |
| ---- | --------------| ------- | ---------------------------- |
| [ ]  | 零基索引       | 位置的  | Array, List, Buf, Match, ...  |
| { }  | 字符或者对象键 | 关联的   | Hash, Bag, Mix, Match, ...   |


|      | elements are identified by | interface name | supported by                 |
| ---- | -------------------------- | -------------- | ---------------------------- |
| [ ]  | zero-based indices         | Positional     | Array, List, Buf, Match, ... |
| { }  | string or object keys      | Associative    | Hash, Bag, Mix, Match, ...   |

<a id="%E4%BD%8D%E7%BD%AE%E4%B8%8B%E6%A0%87--positional-subscripting"></a>
## 位置下标 / **Positional** subscripting

**位置**下标（通过[后环缀运算符 `[ ]`](https://docs.perl6.org/language/operators#postcircumfix_[_]) 按位置对有序集合的元素进行寻址。索引 0 引用第一个元素，索引 1 引用第二个元素，依此类推：

**Positional** subscripting(via [`postcircumfix [ ]`](https://docs.perl6.org/language/operators#postcircumfix_[_])) addresses elements of an ordered collection by their position. Index 0 refers to the first element, index 1 to the second, and so on:

```Perl6
my @chores = "buy groceries", "feed dog", "wash car";
say @chores[0];  # OUTPUT: «buy groceries␤» 
say @chores[1];  # OUTPUT: «feed dog␤» 
say @chores[2];  # OUTPUT: «wash car␤»
```

<a id="%E5%85%B3%E8%81%94%E4%B8%8B%E6%A0%87--associative-subscripting"></a>
## 关联下标 / **Associative** subscripting

**关联**下标（通过后环缀运算符 [`{ }`](https://docs.perl6.org/language/operators#postcircumfix_{_}) 不需要集合将其元素保持任何特定顺序，而是使用唯一的键来寻址每个值。密钥的性质取决于所讨论的集合：例如，标准的 [Hash](https://docs.perl6.org/type/Hash) 使用字符串密钥，而 [Mix](https://docs.perl6.org/type/Mix) 允许任意对象作为键，等等：

**Associative** subscripting (via [`postcircumfix { }`](https://docs.perl6.org/language/operators#postcircumfix_{_})), does not require the collection to keep its elements in any particular order - instead, it uses a unique key to address each value. The nature of the keys depends on the collection in question: For example a standard [Hash](https://docs.perl6.org/type/Hash) uses string keys, whereas a [Mix](https://docs.perl6.org/type/Mix) allows arbitrary objects as keys, etc.:

```Perl6
my %grade = Zoe => "C", Ben => "B+";
say %grade{"Zoe"};  # OUTPUT: «C␤» 
say %grade{"Ben"};  # OUTPUT: «B+␤» 
 
my $stats = ( Date.today => 4.18, Date.new(2015,  4,  5) => 17.253 ).Mix;
say $stats{ Date.new(2015, 4, 4) + 1 };  # OUTPUT: «17.253␤»
```

要将单个单词字符串键传递给 `{ }`，还可以使用[以尖括号括起来的词的结构](https://docs.perl6.org/language/quoting#Word_quoting:_qw)将它们当作后循环修复运算符：

For passing single-word string keys to `{ }`, you can also use the [angle bracketed word quoting constructs](https://docs.perl6.org/language/quoting#Word_quoting:_qw) as if they were postcircumfix operators:

```Perl6
my %grade = Zoe => "C", Ben => "B+";
say %grade<Zoe>;    # OUTPUT: «C␤» 
say %grade<Ben>;    # OUTPUT: «B+␤»
```

这实际上只是句法糖，编译时会变成相应的 `{ }` 形式：

This is really just syntactic sugar that gets turned into the corresponding `{ }` form at compile-time:

```Perl6
%hash<foo bar>;       # same as %hash{ <foo bar> } 
%hash«foo "$var"»;    # same as %hash{ «foo "$var"» } 
%hash<<foo "$var">>;  # same as %hash{ <<foo "$var">> } 
```

你可能已经注意到，我们使用 `=>` 运算符来避免将 `Zoe` 括起来，但同样的操作符并没有在 `Date.new(2015, 4, 5)` 周围放置不可见的引号，并且我们能够使用 `$stats{ Date.new(2015, 4, 4) + 1 }` 找到相同的元素。这是因为 `=>` 只在单个词周围加上不可见的引号，而词是指标识符/名称。这里的 `=>` 运算符是为了防止我们意外调用函数或使用具有该名称的常量。

You may have noted above that we avoided having to quote `Zoe` by using the `=>` operator, but that same operator did not just put invisible quotes around `Date.new(2015, 4, 5)`, and we were able to find the same element using `$stats{ Date.new(2015, 4, 4) + 1 }`. This is because `=>` only puts invisible quotes around single words, and by "word" we mean an identifier/name. The `=>` operator is there to prevent us from accidentally calling functions or using constants with that name.

哈希下标与 `=>` 的行为不一样。默认的 `Hash` 已经按照新用户期望的方式（使用其他语言经验），以及一般的易用性来实现。在默认的 `Hash` 下，下标键强制转换成字符串，只要这些键产生 `Cool` 对象。可以对集合使用 `.perl` 来确定键是字符串还是对象：

Hash subscripts do not do the same thing as `=>`. The default `Hash` has been made to behave the way new users have come to expect from using other languages, and for general ease of use. On a default `Hash`, subscripts coerce keys into strings, as long as those keys produce something `Cool`. You can use `.perl` on a collection to be sure whether the keys are strings or objects:

```Perl6
( 1  => 1 ).perl.say;            # OUTPUT: «1 => 1␤» 
my %h; %h{1}   = 1; say %h.perl; # OUTPUT: «{ "1" => 1 }␤» 
( 1/2 => 1 ).perl.say;           # OUTPUT: «0.5 => 1␤» 
my %h; %h{1/2} = 1; say %h.perl; # OUTPUT: «{ "0.5" => 1 }␤» 
( pi => 1 ).perl.say;            # OUTPUT: «:pi(1)␤» 
my %h; %h{pi}  = 1; say %h.perl; # OUTPUT: «{ "3.14159265358979" => 1 }␤»
```

虽然单个名称周围的不可见引号内置在 `=>` 中，但字符串转换不会内置在大括号中：这是默认 `Hash` 的行为。不是所有类型的散列或集合都这样做：

While the invisible quotes around single names is built into `=>`, string conversion is not built into the curly braces: it is a behavior of the default `Hash`. Not all types of hashes or collections do so:

```Perl6
my %h := MixHash.new;
%h{pi} = 1; %h.perl.say;         # OUTPUT: «(3.14159265358979e0=>1).MixHash␤» 
```

（任何 `=>` 转换为字符串的名称也可以用来使用“副词标识”来构建键值对，当通过 `.perl` 查看时，将出现这种方式，这就是为什么我们在上面看到 `:pi(1)`）的原因）。

(Any name that `=>` would convert to a string can also be used to build a pair using "adverbial notation" and will appear that way when viewed through `.perl`, which is why we see `:pi(1)` above.)

<a id="%E5%BA%94%E7%94%A8%E4%B8%8B%E6%A0%87--applying-subscripts"></a>
## 应用下标 / Applying subscripts

下标可以应用于任何返回可使用下标的对象的表达式，而不仅仅是应用于变量：

Subscripts can be applied to any expression that returns a subscriptable object, not just to variables:

```Perl6
say "__Hello__".match(/__(.*)__/)[0];   # OUTPUT: «｢Hello｣␤» 
say "__Hello__".match(/__(.*)__/).[0];  # same, in method notation
```

位置下标和关联下标不是互斥的，例如，[Match](https://docs.perl6.org/type/Match) 对象支持两者（两者访问不同的数据集）。此外，为了使列表处理更方便，类 [Any](https://docs.perl6.org/type/Any) 为位置下标提供了一个备选实现，它简单地将调用器视为一个元素的列表。（但对于关联下标没有这样的备选实现，因此它们在应用于不支持它们的对象时会抛出运行时错误。）

Positional and associative subscripting are not mutually exclusive - for example, [Match](https://docs.perl6.org/type/Match) objects support both (each accessing a different set of data). Also, to make list processing more convenient, class [Any](https://docs.perl6.org/type/Any) provides a fallback implementation for positional subscripts which simply treats the invocant as a list of one element. (But there's no such fallback for associative subscripts, so they throw a runtime error when applied to an object that does not implement support for them.)

```Perl6
say 42[0];    # OUTPUT: «42␤» 
say 42<foo>;  # ERROR: Type Int does not support associative indexing. 
```

<a id="%E4%B8%8D%E5%AD%98%E5%9C%A8%E7%9A%84%E6%88%90%E5%91%98--nonexistent-elements"></a>
# 不存在的成员 / Nonexistent elements

当一个*不存在*的元素被下标寻址时会发生什么，取决于所集合的类型。标准 [Array](https://docs.perl6.org/type/Array) 和 [Hash](https://docs.perl6.org/type/Hash) 集合返回其[值类型约束](https://docs.perl6.org/routine/of)的类型对象（默认情况下，是 [Any](https://docs.perl6.org/type/Any)，除非集合已被 [`is default`](https://docs.perl6.org/type/Variable#trait_is_default) 特性声明，在这种情况下，返回值将是程序员声明的：

What happens when a *nonexistent* element is addressed by a subscript is up to the collection type in question. Standard [Array](https://docs.perl6.org/type/Array) and [Hash](https://docs.perl6.org/type/Hash) collections return the type object of their [value type constraint](https://docs.perl6.org/routine/of) (which, by default, is [Any](https://docs.perl6.org/type/Any)) unless the collection has been declared with the [`is default`](https://docs.perl6.org/type/Variable#trait_is_default) trait in which case the returned value will be whatever the programmer declared it to be:

```Perl6
# no default values specified 
my @array1;     say @array1[10];                   # OUTPUT: «(Any)␤» 
my Int @array2; say @array2[10];                   # OUTPUT: «(Int)␤» 
 
my %hash1;      say %hash1<foo>;                   # OUTPUT: «(Any)␤» 
my Int %hash2;  say %hash2<foo>;                   # OUTPUT: «(Int)␤» 
 
# default values specified 
my @array3 is default('--');     say @array3[10];  # OUTPUT: «--␤» 
my Int @array4 is default(17);   say @array4[10];  # OUTPUT: «17␤» 
 
my %hash3 is default('Empty');   say %hash3<foo>;  # OUTPUT: «Empty␤» 
my Int %hash4 is default(4711);  say %hash4<foo>;  # OUTPUT: «4711␤»
```

但是，其他类型的集合可能会对不存在元素的下标寻址作出不同的反应：

However, other types of collections may react differently to subscripts that address nonexistent elements:

```Perl6
say (0, 10, 20)[3];           # OUTPUT: «Nil␤» 
say bag(<a a b b b>)<c>;      # OUTPUT: «0␤» 
say array[uint8].new(1, 2)[2] # OUTPUT: «0␤»
```

为了悄悄地跳过下标操作中不存在的元素，请参阅[截断切片](https://docs.perl6.org/language/subscripts#Truncating_slices)和 [:v](https://docs.perl6.org/language/subscripts#%3Av) 副词。

To silently skip nonexistent elements in a subscripting operation, see [Truncating slices](https://docs.perl6.org/language/subscripts#Truncating_slices) and the [:v](https://docs.perl6.org/language/subscripts#%3Av) adverb.

<a id="%E4%BB%8E%E6%9C%AB%E5%B0%BE--from-the-end"></a>
# 从末尾 / From the end

位置索引是从集合的开始计算出来的，但也有一个符号，用来寻址元素相对于它们的末尾的位置： `*-1` 指的是最后一个元素，`*-2` 指的是倒数第二个元素，等等。

Positional indices are counted from the start of the collection, but there's also a notation for addressing elements by their position relative to the end: `*-1` refers to the last element, `*-2` to the second-to-last element, and so on.

```Perl6
my @alphabet = 'A' .. 'Z';
say @alphabet[*-1];  # OUTPUT: «Z␤» 
say @alphabet[*-2];  # OUTPUT: «Y␤» 
say @alphabet[*-3];  # OUTPUT: «X␤»
```

**注意**：星号很重要。传递一个负整数（例如 `@alphabet[-1]`），就像你在许多其他编程语言中所做的那样，在 Perl 6 中抛出一个错误。

**Note**: The asterisk is important. Passing a bare negative integer (e.g. `@alphabet[-1]`) like you would do in many other programming languages, throws an error in Perl 6.

这里实际发生的是，像 `*-1` 这样的表达式通过 [Whatever](https://docs.perl6.org/type/Whatever) 来声明代码对象。 `[ ]` 下标的反应是将代码对象作为索引，以集合的长度作为参数调用它，并使用结果值作为实际索引。换句话说，`@alphabet[*-1]` 变成了 `@alphabet[@alphabet.elems - 1]`。

What actually happens here, is that an expression like `*-1` declares a code object via [Whatever](https://docs.perl6.org/type/Whatever)-currying - and the `[ ]` subscript reacts to being given a code object as an index, by calling it with the length of the collection as argument and using the result value as the actual index. In other words, `@alphabet[*-1]` becomes `@alphabet[@alphabet.elems - 1]`.

这意味着你可以使用取决于集合大小的任意表达式：

This means that you can use arbitrary expressions which depend on the size of the collection:

```Perl6
say @array[* div 2];  # select the middlemost element 
say @array[$i % *];   # wrap around a given index ("modular arithmetic") 
say @array[ -> $size { $i % $size } ];  # same as previous 
```

<a id="%E5%88%87%E7%89%87--slices"></a>
# 切片 / Slices

当需要访问一个集合的多个元素时，有一个快捷方式来完成多个单独的子查询操作：只需在下标中指定索引/键的列表，就可以返回一个元素的*列表*，也叫做“切片”——以相同的顺序。

When multiple elements of a collection need to be accessed, there's a shortcut to doing multiple separate subscripting operations: Simply specify a *list* of indices/keys in the subscript, to get back a *list* of elements - also called a "slice" - in the same order.

对于位置切片，你可以将普通索引与[从末尾](https://docs.perl6.org/language/subscripts#From_the_end)索引混合使用：

For positional slices, you can mix normal indices with [from-the-end](https://docs.perl6.org/language/subscripts#From_the_end) ones:

```Perl6
my @alphabet = 'a' .. 'z';
say @alphabet[15, 4, *-9, 11].perl;  # OUTPUT: «("p", "e", "r", "l")␤»
```

在上面的 `*-number` 结构中，`*` 表示数组的结尾，如上面在 [从结尾](https://docs.perl6.org/language/subscripts#From_the_end)部分中所述。因此，如果要获取数组的最后 N 个元素，则必须创建包含它的 [Range](https://docs.perl6.org/type/Range)。

In the `*-number` construct above, `*` indicates the end of the array as explained above in the [From the end](https://docs.perl6.org/language/subscripts#From_the_end) section. So if you want to take the last N elements of the array, you will have to create a [Range](https://docs.perl6.org/type/Range) that includes it.

```Perl6
(5802..5830).map( {.chr} )[*-10..*-5] # OUTPUT:  «(ᚽ ᚾ ᚿ ᛀ ᛁ ᛂ)␤»
```

使用 `*` 作为范围的最后一个元素将有效地返回集合的最后一个元素。

Using `*` as the last element of the range will, effectively, return the last elements of the collection.

对于关联切片，角度括号形式通常很实用：

For associative slices, the angle brackets form often comes in handy:

```Perl6
my %color = kiwi => "green", banana => "yellow", cherry => "red";
say %color{"cherry", "kiwi"};  # OUTPUT: «(red green)␤» 
say %color<cherry kiwi>;       # OUTPUT: «(red green)␤» 
say %color{*};                 # OUTPUT: «(red yellow green)␤»
```

请注意，切片是由传递到（[一维的](https://docs.perl6.org/language/subscripts#Multiple_dimensions)）下标的*类型*控制的，而不是它的长度。尤其是*类型*可以是以下任意一种：

Be aware that slices are controlled by the *type* of what is passed to ([one dimension of](https://docs.perl6.org/language/subscripts#Multiple_dimensions)) the subscript, not its length. In particular the *type* can be any of the following:

- 一个惰性的 Iterable，在[ ]中被[截断](https://docs.perl6.org/language/subscripts#Truncating_slices)
- 因此，无限 Range 将被截断，但有限 Range 将产生一个正常切片
- '*' 将返回整个片（就像所有键/索引都已指定一样）
- 任何其他提供单个元素访问而非切片的对象
- Callable，它返回的任何内容（这可能导致递归）
- empty, 被称为 [Zen slice](https://docs.perl6.org/language/subscripts#Zen_slices) 的完全切片
- 不同于上述类型的 Iterable，正常切片

- a lazy Iterable, that [truncates](https://docs.perl6.org/language/subscripts#Truncating_slices) in [ ]
- accordingly, an infinite Range will truncate, but a finite one produces a normal slice
- '*' (whatever-star), that returns the full slice (as if all keys/indices were specified)
- any other object, that provides a single-element access rather than a slice
- Callable, whatever is returned by the callable (this can lead to recursion)
- empty, the full slice known as [Zen slice](https://docs.perl6.org/language/subscripts#Zen_slices)
- any iterable different from the above ones, normal slice

`*` 和 Zen Slice（空）之间的显著区别是，[Whatever](https://docs.perl6.org/type/Whatever) 星号将导致完全[具体化](https://docs.perl6.org/language/glossary#index-entry-Reify)或单条目化，而 Zen 切片不会。两个版本也 [de-cont](https://perl6advent.wordpress.com/2017/12/02/perl-6-sigils-variables-and-containers/#decont)。

The notable difference between `*` and Zen slice (empty) is that the [Whatever](https://docs.perl6.org/type/Whatever) star will cause full [reification](https://docs.perl6.org/language/glossary#index-entry-Reify) or itemization, while Zen slice won't. Both versions also [de-cont](https://perl6advent.wordpress.com/2017/12/02/perl-6-sigils-variables-and-containers/#decont).

因此，即使是单元素列表也会返回一个切片，而裸标量值则不会：

So even a one-element list returns a slice, whereas a bare scalar value doesn't:

```Perl6
say @alphabet[2,];        # OUTPUT: «(c)␤» 
say @alphabet[2,].^name;  # OUTPUT: «List␤» 
 
say @alphabet[2];         # OUTPUT: «c␤» 
say @alphabet[2].^name;   # OUTPUT: «Str␤» 
```

(The angle bracket form for associative subscripts works out because [word quoting](https://docs.perl6.org/language/quoting#Word_quoting:_qw) conveniently returns a [Str](https://docs.perl6.org/type/Str) in case of a single word, but a [List](https://docs.perl6.org/type/List) in case of multiple words.)

In fact, the list structure of ([the current dimension of](https://docs.perl6.org/language/subscripts#Multiple_dimensions)) the subscript is preserved across the slice operation (but the kind of Iterable is not – the result is always just lists.)

```Perl6
say @alphabet[0, (1..2, (3,))];       # OUTPUT: «(a ((b c) (d)))␤» 
say @alphabet[0, (1..2, [3,])];       # OUTPUT: «(a ((b c) (d)))␤» 
say @alphabet[flat 0, (1..2, (3,))];  # OUTPUT: «(a b c d)␤» 
say flat @alphabet[0, (1..2, (3,))];  # OUTPUT: «(a b c d)␤» 
```

<a id="truncating-slices"></a>
## Truncating slices

Referring to nonexistent elements in a slice subscript causes the output `List` to contain undefined values (or [whatever else](https://docs.perl6.org/language/subscripts#Nonexistent_elements) the collection in question chooses to return for nonexistent elements):

```Perl6
my  @letters = <a b c d e f>;
say @letters[3..7];  # OUTPUT: «(d e f (Any) (Any))␤» 
```

This behavior, while at first glance may seem unintuitive, is desirable in instances when you want to assign a value at an index in which a value does not currently exist.

```Perl6
my  @letters;
say @letters; # OUTPUT: «[]␤» 
 
@letters[^10] = 'a'..'z';
say @letters; # OUTPUT: «[a b c d e f g h i j]␤» 
```

If you want the resulting slice to only include existing elements, you can silently skip the non-existent elements using the [:v](https://docs.perl6.org/language/subscripts#%3Av) adverb.

```Perl6
my  @letters = <a b c d e f>;
say @letters[3..7]:v;  # OUTPUT: «(d e f)␤» 
```

The behavior when indexing a collection via [lazy](https://docs.perl6.org/language/list#Lazy_lists) subscripts is different than when indexing with their eager counterparts. When accessing via a lazy subscript, the resulting slice will be truncated.

```Perl6
say @letters[lazy 3..7]; # OUTPUT: «(d e f)␤» 
say @letters[     3..*]; # OUTPUT: «(d e f)␤» 
```

This behavior exists as a precaution to prevent runaway generation of massive, potentially infinite `Lists` and the out-of-memory issues that occur as a result.

<a id="zen-slices"></a>
## Zen slices

If you put the subscript operator behind an object without specifying any indices/keys at all, it simply returns the subscripted object itself. Since it is empty but returns everything, it is known as a *Zen slice*.

Zen slicing is different from passing a Whatever-star (which, like a normal slice, always returns a List of elements no matter the type of the original object) or an empty list (which returns an empty slice):

```Perl6
my %bag := (orange => 1, apple => 3).Bag;
say %bag<>;    # OUTPUT: «Bag(apple(3), orange)␤» 
say %bag{};    # OUTPUT: «Bag(apple(3), orange)␤» 
say %bag{*};   # OUTPUT: «(1 3)␤» 
say %bag{()};  # OUTPUT: «()␤»
```

Zen slicing does not [reify](https://docs.perl6.org/language/glossary#index-entry-Reify) or [cache](https://docs.perl6.org/routine/cache) and merely returns the invocant. It is usually used to [interpolate](https://docs.perl6.org/language/quoting#Interpolation:_qq) entire arrays / hashes into strings or to [decont](https://docs.perl6.org/language/glossary#index-entry-decont).

```Perl6
my @words = "cruel", "world";
say "Hello, @words[]!";  # OUTPUT: «Hello, cruel world!␤» 
 
my $list = <a b c>;
.say for $list;   # OUTPUT: «(a b c)␤» 
.say for $list<>; # OUTPUT: «a␤b␤c␤» 
.say for $list[]; # OUTPUT: «a␤b␤c␤»
```

<a id="multiple-dimensions"></a>
# Multiple dimensions

Dimensions in subscripts are separated by a semicolon, allowing to mix lists of elements and dimensions.

```Perl6
my @twodim = (<a b c>, (1, 2, 3));
say @twodim;
# OUTPUT: «[(a b c) (1 2 3)]␤» 
 
say @twodim[0,1;1]; # 2nd element of both lists 
# OUTPUT: «(b 2)␤» 
 
my %pantheon = %('Baldr' => 'consort' => 'Nanna' ,
                 'Bragi' => 'consort' => 'Iðunn' ,
                 'Nótt'  => 'consort' => 'Dellingr' );
say %pantheon{'Bragi','Nótt';'consort'}; # 'consort' value for both keys 
# OUTPUT: «(Iðunn Dellingr)␤»
```

Multidimensional subscripts can be used to flatten nested lists when combined with [Whatever](https://docs.perl6.org/type/Whatever).

```Perl6
my @toomany = [[<a b>], [1, 2]];
say @toomany;
# OUTPUT: «[[a b] [1 2]]␤» 
 
say @toomany[*;*];
# OUTPUT: «(a b 1 2)␤»
```

You can use as many *flattening semicolons* as you want; there will be, at most, as many nesting levels flattened as the number of semicolons:

```Perl6
say [[1,2,[3,4]],[4,5]][*;*];     # OUTPUT: «(1 2 [3 4] 4 5)␤» 
say [[1,2,[3,4]],[4,5]][*;*;*;*]; # OUTPUT: «(1 2 3 4 4 5)␤»
```

In the first example, with one `Whatever` less than the number of levels, the deepest one will not be flattened; in the second case it is, since it's greater than the number of levels.

You can use [Whatever](https://docs.perl6.org/type/Whatever) to select ranges or "rows" in multidimensional subscripts.

```Perl6
my @a = [[1,2], [3,4]];
say @a[*;1]; # 2nd element of each sub list 
# OUTPUT: «(2 4)␤» 
my @a = (<1 c 6>, <2 a 4>, <5 b 3>);
say @a.sort( { $_[1] } ); # sort by 2nd column 
# OUTPUT: «((2 a 4) (5 b 3) (1 c 6))␤»
```

<a id="modifying-elements"></a>
# Modifying elements

<a id="autovivification"></a>
# Autovivification

Subscripts participate in "autovivification", i.e. the process by which arrays and hashes automatically spring into existence when needed, so that you can build nested data structures without having to pre-declare the collection type at each level:

```Perl6
my $beatles;
 
$beatles{"White Album"}[0] = "Back in the U.S.S.R.";  # autovivification! 
 
say $beatles.perl;  # OUTPUT: «${"White Album" => $["Back in the U.S.S.R."]}␤» 
```

`$beatles` started out undefined, but became a [Hash](https://docs.perl6.org/type/Hash) object because it was subscripted with `{ }` in the assignment. Similarly, `$beatles{"White Album"}` became an [Array](https://docs.perl6.org/type/Array) object due to being subscripted with `[ ]` in the assignment.

Note that the subscripting itself does not cause autovivification: It only happens when the result of the subscripting chain is *assigned* to (or otherwise mutated).

<a id="binding"></a>
# Binding

A subscripting expression may also be used as the left-hand-side of a binding statement. If supported by the subscripted collection's type, this replaces whatever value container would be naturally found at that "slot" of the collection, with the specified container.

The built-in [Array](https://docs.perl6.org/type/Array) and [Hash](https://docs.perl6.org/type/Hash) types support this in order to allow building complex linked data structures:

```Perl6
my @a = 10, 11, 12, 13;
my $x = 1;
 
@a[2] := $x;  # Bound! (@a[2] and $x refer to the same container now.) 
 
$x++; @a[2]++;
 
say @a;  # OUTPUT: «[10 11 3 13]␤» 
say $x;  # OUTPUT: «3␤»
```

This can be specially useful when lazy data structures are part of a bigger one.

```Perl6
my @fib = 1,1, * + * … ∞;
my @lucas = 1,3, * + * … ∞;
my %sequences;
%sequences<f> := @fib;
%sequences<l> := @lucas;
for %sequences.keys -> $s {
    for ^10 -> $n {
        say %sequences{$s}[100+$n*10]/%sequences{$s}[101+$n*10];
    }
}
# OUTPUT: 0.6180339887498949 times 20. 
```

In this case, hash keys are bound to lazily generated sequences. The fact that they are bound means that whatever state has been computed is shared by the hash value and the sequence it's bound to, making computations of subsequent elements faster.

See [method BIND-POS](https://docs.perl6.org/language/subscripts#method_BIND-POS) and [method BIND-KEY](https://docs.perl6.org/language/subscripts#method_BIND-KEY) for the underlying mechanism.

<a id="adverbs"></a>
# Adverbs

The return value and possible side-effect of a subscripting operation can be controlled using adverbs; these are defined on the relevant subscript [operators](https://docs.perl6.org/language/operators#Method_postfix_precedence).

Beware of the relatively loose precedence of operator adverbs, which may require you to add parentheses in compound expressions:

```Perl6
if $foo || %hash<key>:exists { ... }    # WRONG, tries to adverb the || op 
if $foo || (%hash<key>:exists) { ... }  # correct 
if $foo or %hash<key>:exists { ... }    # also correct 
```

The supported adverbs are:

<a id="exists"></a>
## `:exists`

Returns whether or not the requested element exists, instead of returning the element's actual value. This can be used to distinguish between elements with an undefined value, and elements that aren't part of the collection at all:

```Perl6
my @foo = Any, 10;
say @foo[0].defined;    # OUTPUT: «False␤» 
say @foo[0]:exists;     # OUTPUT: «True␤» 
say @foo[2]:exists;     # OUTPUT: «False␤» 
say @foo[0, 2]:exists;  # OUTPUT: «(True False)␤» 
 
my %fruit = apple => Any, orange => 10;
say %fruit<apple>.defined;       # OUTPUT: «False␤» 
say %fruit<apple>:exists;        # OUTPUT: «True␤» 
say %fruit<banana>:exists;       # OUTPUT: «False␤» 
say %fruit<apple banana>:exists; # OUTPUT: «(True False)␤»
```

May also be negated to test for non-existence:

```Perl6
say %fruit<apple banana>:!exists; # OUTPUT: «(False True)␤» 
```

To check if *all* elements of a slice exist, use an [all](https://docs.perl6.org/routine/all) junction:

```Perl6
if all %fruit<apple orange banana>:exists { ... }
```

It can be used on multi-dimensional arrays and hashes:

```Perl6
my @multi-dim = 1, [2, 3, [4, 5]];
say @multi-dim[1;2;0]:exists;                # OUTPUT: «True␤» 
say @multi-dim[1;2;5]:exists;                # OUTPUT: «False␤» 
 
my %multi-dim = 1 => { foo => { 3 => 42 } };
say %multi-dim{1;'foo';3}:exists;            # OUTPUT: «True␤» 
say %multi-dim{1;'bar';3}:exists;            # OUTPUT: «False␤»
```

`:exists` can be combined with the [:delete](https://docs.perl6.org/language/subscripts#%3Adelete) and [:p](https://docs.perl6.org/language/subscripts#%3Ap)/[:kv](https://docs.perl6.org/language/subscripts#%3Akv) adverbs - in which case the behavior is determined by those adverbs, except that any returned element *value* is replaced with the corresponding [Bool](https://docs.perl6.org/type/Bool) indicating element *existence*.

See [method EXISTS-POS](https://docs.perl6.org/language/subscripts#method_EXISTS-POS) and [method EXISTS-KEY](https://docs.perl6.org/language/subscripts#method_EXISTS-KEY) for the underlying mechanism.

<a id="delete"></a>
## `:delete`

Delete the element from the collection or, if supported by the collection, creates a hole at the given index, in addition to returning its value.

```Perl6
my @tens = 0, 10, 20, 30;
say @tens[3]:delete;     # OUTPUT: «30␤» 
say @tens;               # OUTPUT: «[0 10 20]␤» 
 
my %fruit = apple => 5, orange => 10, banana => 4, peach => 17;
say %fruit<apple>:delete;         # OUTPUT: «5␤» 
say %fruit<peach orange>:delete;  # OUTPUT: «(17 10)␤» 
say %fruit;                       # OUTPUT: «{banana => 4}␤»
```

Note that assigning `Nil` will revert the container at the given index to its default value. It will not create a hole. The created holes can be tested for with `:exists` but iteration will not skip them and produce undefined values instead.

```Perl6
my @a = 1, 2, 3;
@a[1]:delete;
say @a[1]:exists;
# OUTPUT: «False␤» 
.say for @a;
# OUTPUT: «1␤(Any)␤3␤»
```

With the negated form of the adverb, the element is not actually deleted. This means you can pass a flag to make it conditional:

```Perl6
say %fruit<apple> :delete($flag);  # deletes the element only if $flag is 
                                   # true, but always returns the value. 
```

Can be combined with the [:exists](https://docs.perl6.org/language/subscripts#%3Aexists) and [:p](https://docs.perl6.org/language/subscripts#%3Ap)/[:kv](https://docs.perl6.org/language/subscripts#%3Akv)/[:k](https://docs.perl6.org/language/subscripts#%3Ak)/[:v](https://docs.perl6.org/language/subscripts#%3Av) adverbs - in which case the return value will be determined by those adverbs, but the element will at the same time also be deleted.

See [method DELETE-POS](https://docs.perl6.org/language/subscripts#method_DELETE-POS) and [method DELETE-KEY](https://docs.perl6.org/language/subscripts#method_DELETE-KEY) for the underlying mechanism.

<a id="p"></a>
## `:p`

Return both the index/key and the value of the element, in the form of a [Pair](https://docs.perl6.org/type/Pair), and silently skip nonexistent elements:

```Perl6
my  @tens = 0, 10, 20, 30;
say @tens[1]:p;        # OUTPUT: «1 => 10␤» 
say @tens[0, 4, 2]:p;  # OUTPUT: «(0 => 0 2 => 20)␤» 
 
my  %month = Jan => 1, Feb => 2, Mar => 3;
say %month<Feb>:p;          # OUTPUT: «Feb => 2␤» 
say %month<Jan Foo Mar>:p;  # OUTPUT: «(Jan => 1 Mar => 3)␤»
```

If you *don't* want to skip nonexistent elements, use the negated form:

```Perl6
say %month<Jan Foo Mar>:!p;  # OUTPUT: «(Jan => 1 Foo => (Any) Mar => 3)␤» 
```

Can be combined with the [:exists](https://docs.perl6.org/language/subscripts#%3Aexists) and [:delete](https://docs.perl6.org/language/subscripts#%3Adelete) adverbs.

See also the [pairs](https://docs.perl6.org/routine/pairs) routine.

<a id="kv"></a>
## `:kv`

Return both the index/key and the value of the element, in the form of a [List](https://docs.perl6.org/type/List), and silently skip nonexistent elements. When used on a [slice](https://docs.perl6.org/language/subscripts#Slices), the return value is a single flat list of interleaved keys and values:

```Perl6
my  @tens = 0, 10, 20, 30;
say @tens[1]:kv;        # OUTPUT: «(1 10)␤» 
say @tens[0, 4, 2]:kv;  # OUTPUT: «(0 0 2 20)␤» 
 
my  %month = Jan => 1, Feb => 2, Mar => 3;
say %month<Feb>:kv;          # OUTPUT: «(Feb 2)␤» 
say %month<Jan Foo Mar>:kv;  # OUTPUT: «(Jan 1 Mar 3)␤»
```

If you *don't* want to skip nonexistent elements, use the negated form:

```Perl6
say %month<Jan Foo Mar>:!kv;  # OUTPUT: «(Jan 1 Foo (Any) Mar 3)␤» 
```

This adverb is commonly used to iterate over slices:

```Perl6
for %month<Feb Mar>:kv -> $month, $i {
    say "$month had {Date.new(2015, $i, 1).days-in-month} days in 2015"
}
```

Can be combined with the [:exists](https://docs.perl6.org/language/subscripts#%3Aexists) and [:delete](https://docs.perl6.org/language/subscripts#%3Adelete) adverbs.

See also the [kv](https://docs.perl6.org/routine/kv) routine.

<a id="k"></a>
## `:k`

Return only the index/key of the element, rather than its value, and silently skip nonexistent elements:

```Perl6
my @tens = 0, 10, 20, 30;
say @tens[1]:k;        # OUTPUT: «1␤» 
say @tens[0, 4, 2]:k;  # OUTPUT: «(0 2)␤» 
 
my %month = Jan => 1, Feb => 2, Mar => 3;
say %month<Feb>:k;          # OUTPUT: «Feb␤» 
say %month<Jan Foo Mar>:k;  # OUTPUT: «(Jan Mar)␤»
```

If you *don't* want to skip nonexistent elements, use the negated form:

```Perl6
say %month<Jan Foo Mar>:!k;  # OUTPUT: «(Jan Foo Mar)␤» 
```

See also the [keys](https://docs.perl6.org/routine/keys) routine.

<a id="v"></a>
## `:v`

Return the bare value of the element (rather than potentially returning a mutable value container), and silently skip nonexistent elements:

```Perl6
my @tens = 0, 10, 20, 30;
say @tens[1]:v;        # OUTPUT: «10␤» 
say @tens[0, 4, 2]:v;  # OUTPUT: «(0, 20)␤» 
@tens[3] = 31;         # OK 
@tens[3]:v = 31;       # ERROR, Cannot modify an immutable Int (31) 
 
my %month = Jan => 1, Feb => 2, Mar => 3;
say %month<Feb>:v;          # OUTPUT: «2␤» 
say %month<Jan Foo Mar>:v;  # OUTPUT: «(1 3)␤» 
```

If you *don't* want to skip nonexistent elements, use the negated form:

```Perl6
say %month<Jan Foo Mar>:!v;  # OUTPUT: «(1 (Any) 3)␤» 
```

See also the [values](https://docs.perl6.org/routine/values) routine.

<a id="custom-types"></a>
# Custom types

The subscripting interfaces described on this page are not meant to be exclusive to Perl 6's built-in collection types - you can (and should) reuse them for any custom type that wants to provide access to data by index or key.

You don't have to manually overload the [`postcircumfix [ \]`](https://docs.perl6.org/routine/[%20]#postcircumfix_[_]) and [`postcircumfix { }`](https://docs.perl6.org/routine/%7B%20%7D#postcircumfix_{_}) operators and re-implement all their magic, to achieve that - instead, you can rely on the fact that their standard implementation dispatches to a well-defined set of low-level methods behind the scenes. For example:

| when you write: | this gets called behind the scenes:            |
| --------------- | ---------------------------------------------- |
| %foo<aa>        | %foo.AT-KEY("aa")                              |
| %foo<aa>:delete | %foo.DELETE-KEY("aa")                          |
| @foo[3, 4, 5]   | @foo.AT-POS(3), @foo.AT-POS(4), @foo.AT-POS(5) |
| @foo[*-1]       | @foo.AT-POS(@foo.elems - 1)                    |

So in order to make subscripting work, you only have to implement or delegate those low-level methods ([detailed below](https://docs.perl6.org/language/subscripts#Methods_to_implement_for_positional_subscripting)) for your custom type.

If you do, you should also let your type compose the [`Positional`](https://docs.perl6.org/type/Positional) or [`Associative`](https://docs.perl6.org/type/Associative) role, respectively. This doesn't add any functionality per se, but announces (and may be used to check) that the type implements the corresponding subscripting interface.

<a id="custom-type-example"></a>
## Custom type example

Imagine a `HTTP::Header` type which, despite being a custom class with special behavior, can be indexed like a hash:

```Perl6
my $request = HTTP::Request.new(GET => "perl6.org");
say $request.header.^name;  # OUTPUT: «HTTP::Header␤» 
 
$request.header<Accept> = "text/plain";
$request.header{'Accept-' X~ <Charset Encoding Language>} = <utf-8 gzip en>;
$request.header.push('Accept-Language' => "fr");  # like .push on a Hash 
 
say $request.header<Accept-Language>.perl;  # OUTPUT: «["en", "fr"]␤» 
 
my $rawheader = $request.header.Str;  # stringify according to HTTP spec 
```

A simple way to implement this class would be to give it an attribute of type [Hash](https://docs.perl6.org/type/Hash), and delegate all subscripting and iterating related functionality to that attribute (using a custom type constraint to make sure users don't insert anything invalid into it):

```Perl6
class HTTP::Header does Associative {
    subset StrOrArrayOfStr where Str | ( Array & {.all ~~ Str} );
 
    has %!fields of StrOrArrayOfStr
                 handles <AT-KEY EXISTS-KEY DELETE-KEY push
                          iterator list kv keys values>;
 
    method Str { #`[not shown, for brevity] }
}
```

However, HTTP header field names are supposed to be case-insensitive (and preferred in camel-case). We can accommodate this by taking the `*-KEY` and `push` methods out of the `handles` list, and implementing them separately like this:

```Perl6
method AT-KEY     ($key) is rw { %!fields{normalize-key $key}        }
method EXISTS-KEY ($key)       { %!fields{normalize-key $key}:exists }
method DELETE-KEY ($key)       { %!fields{normalize-key $key}:delete }
method push(*@_) { #`[not shown, for brevity] }
 
sub normalize-key ($key) { $key.subst(/\w+/, *.tc, :g) }
```

Note that subscripting `%!fields` returns an appropriate rw container, which our `AT-KEY` can simply pass on.

However, we may prefer to be less strict about user input and instead take care of sanitizing the field values ourselves. In that case, we can remove the `StrOrArrayOfStr` type constraint on `%!fields`, and replace our `AT-KEY` implementation with one that returns a custom `Proxy` container which takes care of sanitizing values on assignment:

```Perl6
multi method AT-KEY (::?CLASS:D: $key) is rw {
    my $element := %!fields{normalize-key $key};
 
    Proxy.new(
        FETCH => method () { $element },
 
        STORE => method ($value) {
            $element = do given $value».split(/',' \s+/).flat {
                when 1  { .[0] }    # a single value is stored as a string 
                default { .Array }  # multiple values are stored as an array 
            }
        }
    );
}
```

Note that declaring the method as `multi` and restricting it to `:D` (defined invocants) makes sure that the undefined case is passed through to the default implementation provided by `Any` (which is involved in auto-vivification).

<a id="methods-to-implement-for-positional-subscripting"></a>
## Methods to implement for positional subscripting

In order to make index-based subscripting via [`postcircumfix [ \]`](https://docs.perl6.org/routine/[%20]#postcircumfix_[_]) work for your custom type, you should implement at least `elems`, `AT-POS` and `EXISTS-POS` - and optionally others as detailed below.

<a id="method-elems"></a>
### method elems

```Perl6
multi method elems(::?CLASS:D:)
```

Expected to return a number indicating how many subscriptable elements there are in the object. May be called by users directly, and is also called by [`postcircumfix [ \]`](https://docs.perl6.org/routine/[%20]#postcircumfix_[_]) when indexing elements from the end, as in `@foo[*-1]`.

If not implemented, your type will inherit the default implementation from `Any` that always returns `1` for defined invocants - which is most likely not what you want. So if the number of elements cannot be known for your positional type, add an implementation that [fail](https://docs.perl6.org/routine/fail)s or [die](https://docs.perl6.org/routine/die)s, to avoid silently doing the wrong thing.

<a id="method-at-pos"></a>
### method AT-POS

```Perl6
multi method AT-POS (::?CLASS:D: $index)
```

Expected to return the element at position `$index`. This is what [`postcircumfix [ \]`](https://docs.perl6.org/routine/[%20]#postcircumfix_[_]) normally calls.

If you want an element to be mutable (like they are for the built-in [Array](https://docs.perl6.org/type/Array) type), you'll have to make sure to return it in the form of an item container that evaluates to the element's value when read, and updates it when assigned to. (Remember to use `return-rw` or the `is rw` routine trait to make that work; see the [example](https://docs.perl6.org/language/subscripts#Custom_type_example).)

<a id="method-exists-pos"></a>
### method EXISTS-POS

```Perl6
multi method EXISTS-POS (::?CLASS:D: $index)
```

Expected to return a Bool indicating whether or not there is an element at position `$index`. This is what [`postcircumfix [ \]`](https://docs.perl6.org/routine/[%20]#postcircumfix_[_]) calls when invoked like `@foo[42]:exists`.

What "existence" of an element means, is up to your type.

If you don't implement this, your type will inherit the default implementation from `Any`, which returns True for 0 and False for any other index - which is probably not what you want. So if checking for element existence cannot be done for your type, add an implementation that [fail](https://docs.perl6.org/routine/fail)s or [die](https://docs.perl6.org/routine/die)s, to avoid silently doing the wrong thing.

<a id="method-delete-pos"></a>
### method DELETE-POS

```Perl6
multi method DELETE-POS (::?CLASS:D: $index)
```

Expected to delete the element at position `$index`, and return the value it had. This is what [`postcircumfix [ \]`](https://docs.perl6.org/routine/[%20]#postcircumfix_[_]) calls when invoked like `@foo[42]:delete`.

What "deleting" an element means, is up to your type.

Implementing this method is optional; if you don't, users trying to delete elements from an object of this type will get an appropriate error message.

<a id="method-assign-pos"></a>
### method ASSIGN-POS

```Perl6
multi method ASSIGN-POS (::?CLASS:D: $index, $new)
```

Expected to set the element at position `$index` to the value `$new`. Implementing this is entirely optional; if you don't, `self.AT-POS($index) = $new` is used instead, and if you do, you should make sure it has the same effect.

This is meant as an opt-in performance optimization, so that simple assignments like `@numbers[5] = "five"` can operate without having to call `AT-POS` (which would have to create and return a potentially expensive container object).

Note that implementing `ASSIGN-POS` does *not* relieve you from making `AT-POS` an `rw` method though, because less trivial assignments/modifications such as `@numbers[5]++` will still use `AT-POS`.

<a id="method-bind-pos"></a>
### method BIND-POS

```Perl6
multi method BIND-POS (::?CLASS:D: $index, \new)
```

Expected to bind the value or container `new` to the slot at position `$index`, replacing any container that would be naturally found there. This is what is called when you write:

```Perl6
my $x = 10;
@numbers[5] := $x;
```

The generic [Array](https://docs.perl6.org/type/Array) class supports this in order to allow building complex linked data structures, but for more domain-specific types it may not make sense, so don't feel compelled to implement it. If you don't, users will get an appropriate error message when they try to bind to a positional slot of an object of this type.

<a id="method-store"></a>
### method STORE

```Perl6
method STORE (::?CLASS:D: \values, :$initialize)
```

This method should only be supplied if you want to support this syntax:

```Perl6
my @a is Foo = 1,2,3;
```

Which is used for binding your implementation of the `Positional` role.

`STORE` should accept the values to (re-)initialize the object with. The optional named parameter will contain a `True` value when the method is called on the object for the first time. It should return the invocant.

```Perl6
class DNA {
    has $.chain is rw;
 
    method STORE ($chain where {
                         $chain ~~ /^^ <[ACGT]>+ $$ / and
                         $chain.chars %% 3
                     }, :$initialize --> DNA) {
        if $initialize {
            self= DNA.new( chain => $chain )
        } else {
            self.chain = $chain;
            self
        }
    }
 
    method Str(::?CLASS:D:) { return $.chain.comb.rotor(3) }
};
 
my @string is DNA = 'GAATCC';
say @string.Str;    # OUTPUT: «((G A A) (T C C))␤» 
@string = 'ACGTCG';
say @string.Str;    # OUTPUT: «((A C G) (T C G))␤» 
```

This code takes into account the value of `$initialize`, which is set to `True` only if we are assigning a value to a variable declared using the `is` syntax for the first time. The `STORE` method should set the `self` variable and return it in all cases, including when the variable has already been initialized.

<a id="methods-to-implement-for-associative-subscripting"></a>
## Methods to implement for associative subscripting

In order to make key-based subscripting via [`postcircumfix { }`](https://docs.perl6.org/routine/%7B%20%7D#postcircumfix_{_}) work for your custom type, you should implement at least `AT-KEY` and `EXISTS-KEY` - and optionally others as detailed below.

<a id="method-at-key"></a>
### method AT-KEY

```Perl6
multi method AT-KEY (::?CLASS:D: $key)
```

Expected to return the element associated with `$key`. This is what [`postcircumfix { }`](https://docs.perl6.org/routine/%7B%20%7D#postcircumfix_{_}) normally calls.

If you want an element to be mutable (like they are for the built-in [Hash](https://docs.perl6.org/type/Hash) type), you'll have to make sure to return it in the form of an item container that evaluates to the element's value when read, and updates it when assigned to. (Remember to use `return-rw` or the `is rw` routine trait to make that work; see the [example](https://docs.perl6.org/language/subscripts#Custom_type_example).)

On the other hand if you want your collection to be read-only, feel free to return non-container values directly.

<a id="method-exists-key"></a>
### method EXISTS-KEY

```Perl6
multi method EXISTS-KEY (::?CLASS:D: $key)
```

Expected to return a Bool indicating whether or not there is an element associated with `$key`. This is what [`postcircumfix { }`](https://docs.perl6.org/routine/%7B%20%7D#postcircumfix_{_}) calls when invoked like `%foo<aa>:exists`.

What "existence" of an element means, is up to your type.

If you don't implement this, your type will inherit the default implementation from `Any`, which always returns False - which is probably not what you want. So if checking for element existence cannot be done for your type, add an implementation that [fail](https://docs.perl6.org/routine/fail)s or [die](https://docs.perl6.org/routine/die)s, to avoid silently doing the wrong thing.

<a id="method-delete-key"></a>
### method DELETE-KEY

```Perl6
multi method DELETE-KEY (::?CLASS:D: $key)
```

Expected to delete the element associated with `$key`, and return the value it had. This is what [`postcircumfix { }`](https://docs.perl6.org/routine/%7B%20%7D#postcircumfix_{_}) calls when invoked like `%foo<aa>:delete`.

What "deleting" an element means, is up to your type - though it should usually cause `EXISTS-KEY` to become `False` for that key.

Implementing this method is optional; if you don't, users trying to delete elements from an object of this type will get an appropriate error message.

<a id="method-assign-key"></a>
### method ASSIGN-KEY

```Perl6
multi method ASSIGN-KEY (::?CLASS:D: $key, $new)
```

Expected to set the element associated with `$key` to the value `$new`. Implementing this is entirely optional; if you don't, `self.AT-KEY($key) = $new` is used instead, and if you do, you should make sure it has the same effect.

This is meant as an opt-in performance optimization, so that simple assignments `%age<Claire> = 29` can operate without having to call `AT-KEY` (which would have to create and return a potentially expensive container object).

Note that implementing `ASSIGN-KEY` does *not* relieve you from making `AT-KEY` an `rw` method though, because less trivial assignments/modifications such as `%age<Claire>++` will still use `AT-KEY`.

<a id="method-bind-key"></a>
### method BIND-KEY

```Perl6
multi method BIND-KEY (::?CLASS:D: $key, \new)
```

Expected to bind the value or container `new` to the slot associated with `$key`, replacing any container that would be naturally found there. This is what is called when you write:

```Perl6
my $x = 10;
%age<Claire> := $x;
```

The generic [Hash](https://docs.perl6.org/type/Hash) class supports this in order to allow building complex linked data structures, but for more domain-specific types it may not make sense, so don't feel compelled to implement it. If you don't, users will get an appropriate error message when they try to bind to an associative slot of an object of this type.

<a id="method-store-1"></a>
### method STORE

```Perl6
method STORE (::?CLASS:D: \values, :$initialize)
```

This method should only be supplied if you want to support the:

```Perl6
my %h is Foo = a => 42, b => 666;
```

syntax for binding your implementation of the `Associative` role.

Should accept the values to (re-)initialize the object with, which either could consist of `Pair`s, or separate key/value pairs. The optional named parameter will contain a `True` value when the method is called on the object for the first time. Should return the invocant.
