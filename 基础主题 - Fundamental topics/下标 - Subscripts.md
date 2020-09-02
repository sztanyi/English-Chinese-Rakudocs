原文：https://docs.raku.org/language/subscripts

# 下标 / Subscripts

通过索引或键访问数据结构元素

Accessing data structure elements by index or key

通常需要引用集合或数据结构中的特定元素（或元素片段）。借用数学符号，其中向量 *v* 的分量将被称为 *v₁, v₂, v₃*，这个概念在 Raku 中被称为“下标”（或“索引”）。

One often needs to refer to a specific element (or slice of elements) from a collection or data structure. Borrowing from mathematical notation where the components of a vector *v* would be referred to as *v₁, v₂, v₃*, this concept is called "subscripting" (or "indexing") in Raku.

<!-- MarkdownTOC -->

- [基础 / Basics](#基础--basics)
    - [位置下标 / **Positional** subscripting](#位置下标--positional-subscripting)
    - [关联下标 / **Associative** subscripting](#关联下标--associative-subscripting)
    - [应用下标 / Applying subscripts](#应用下标--applying-subscripts)
- [不存在的成员 / Nonexistent elements](#不存在的成员--nonexistent-elements)
- [从末尾 / From the end](#从末尾--from-the-end)
- [切片 / Slices](#切片--slices)
    - [截断切片 / Truncating slices](#截断切片--truncating-slices)
    - [禅切片 / Zen slices](#禅切片--zen-slices)
- [多维 / Multiple dimensions](#多维--multiple-dimensions)
- [修改成员 / Modifying elements](#修改成员--modifying-elements)
- [自动生动化 / Autovivification](#自动生动化--autovivification)
- [绑定 / Binding](#绑定--binding)
- [副词 / Adverbs](#副词--adverbs)
    - [`:exists`](#exists)
    - [`:delete`](#delete)
    - [`:p`](#p)
    - [`:kv`](#kv)
    - [`:k`](#k)
    - [`:v`](#v)
- [自定义类型 / Custom types](#自定义类型--custom-types)
    - [自定义类型例子 / Custom type example](#自定义类型例子--custom-type-example)
    - [实现位置下标的方法 / Methods to implement for positional subscripting](#实现位置下标的方法--methods-to-implement-for-positional-subscripting)
        - [elems 方法 / method elems](#elems-方法--method-elems)
        - [AT-POS 方法 / method AT-POS](#at-pos-方法--method-at-pos)
        - [EXISTS-POS 方法 / method EXISTS-POS](#exists-pos-方法--method-exists-pos)
        - [DELETE-POS 方法 / method DELETE-POS](#delete-pos-方法--method-delete-pos)
        - [ASSIGN-POS 方法 / method ASSIGN-POS](#assign-pos-方法--method-assign-pos)
        - [BIND-POS 方法 / method BIND-POS](#bind-pos-方法--method-bind-pos)
        - [STORE 方法 / method STORE](#store-方法--method-store)
    - [实现关联下标的方法 / Methods to implement for associative subscripting](#实现关联下标的方法--methods-to-implement-for-associative-subscripting)
        - [AT-KEY 方法 / method AT-KEY](#at-key-方法--method-at-key)
        - [EXISTS-KEY 方法 / method EXISTS-KEY](#exists-key-方法--method-exists-key)
        - [DELETE-KEY 方法 / method DELETE-KEY](#delete-key-方法--method-delete-key)
        - [ASSIGN-KEY 方法 / method ASSIGN-KEY](#assign-key-方法--method-assign-key)
        - [BIND-KEY 方法 / method BIND-KEY](#bind-key-方法--method-bind-key)
        - [STORE 方法 / method STORE](#store-方法--method-store-1)

<!-- /MarkdownTOC -->


<a id="基础--basics"></a>
# 基础 / Basics

Raku 提供两个通用下标接口：

Raku provides two universal subscripting interfaces:1 

|      | 成员由什么标识 | 接口名字 | 支持的数据结构                |
| ---- | --------------| ------- | ---------------------------- |
| [ ]  | 零基索引       | 位置的  | Array, List, Buf, Match, ...  |
| { }  | 字符或者对象键 | 关联的   | Hash, Bag, Mix, Match, ...   |


|      | elements are identified by | interface name | supported by                 |
| ---- | -------------------------- | -------------- | ---------------------------- |
| [ ]  | zero-based indices         | Positional     | Array, List, Buf, Match, ... |
| { }  | string or object keys      | Associative    | Hash, Bag, Mix, Match, ...   |

<a id="位置下标--positional-subscripting"></a>
## 位置下标 / **Positional** subscripting

**位置**下标（通过[后环缀运算符 `[ ]`](https://docs.raku.org/language/operators#postcircumfix_[_]) 按位置对有序集合的元素进行寻址。索引 0 引用第一个元素，索引 1 引用第二个元素，依此类推：

**Positional** subscripting(via [`postcircumfix [ ]`](https://docs.raku.org/language/operators#postcircumfix_[_])) addresses elements of an ordered collection by their position. Index 0 refers to the first element, index 1 to the second, and so on:

```Raku
my @chores = "buy groceries", "feed dog", "wash car";
say @chores[0];  # OUTPUT: «buy groceries␤» 
say @chores[1];  # OUTPUT: «feed dog␤» 
say @chores[2];  # OUTPUT: «wash car␤»
```

<a id="关联下标--associative-subscripting"></a>
## 关联下标 / **Associative** subscripting

**关联**下标（通过后环缀运算符 [`{ }`](https://docs.raku.org/language/operators#postcircumfix_{_}) 不需要集合将其元素保持任何特定顺序，而是使用唯一的键来寻址每个值。密钥的性质取决于所讨论的集合：例如，标准的 [Hash](https://docs.raku.org/type/Hash) 使用字符串密钥，而 [Mix](https://docs.raku.org/type/Mix) 允许任意对象作为键，等等：

**Associative** subscripting (via [`postcircumfix { }`](https://docs.raku.org/language/operators#postcircumfix_{_})), does not require the collection to keep its elements in any particular order - instead, it uses a unique key to address each value. The nature of the keys depends on the collection in question: For example a standard [Hash](https://docs.raku.org/type/Hash) uses string keys, whereas a [Mix](https://docs.raku.org/type/Mix) allows arbitrary objects as keys, etc.:

```Raku
my %grade = Zoe => "C", Ben => "B+";
say %grade{"Zoe"};  # OUTPUT: «C␤» 
say %grade{"Ben"};  # OUTPUT: «B+␤» 

my $stats = ( Date.today => 4.18, Date.new(2015,  4,  5) => 17.253 ).Mix;
say $stats{ Date.new(2015, 4, 4) + 1 };  # OUTPUT: «17.253␤»
```

要将单个单词字符串键传递给 `{ }`，还可以使用[以尖括号括起来的引文结构](https://docs.raku.org/language/quoting#Word_quoting:_qw)将它们当作后环缀运算符：

For passing single-word string keys to `{ }`, you can also use the [angle bracketed word quoting constructs](https://docs.raku.org/language/quoting#Word_quoting:_qw) as if they were postcircumfix operators:

```Raku
my %grade = Zoe => "C", Ben => "B+";
say %grade<Zoe>;    # OUTPUT: «C␤» 
say %grade<Ben>;    # OUTPUT: «B+␤»
```

这实际上只是句法糖，在编译时会变成相应的 `{ }` 形式：

This is really just syntactic sugar that gets turned into the corresponding `{ }` form at compile-time:

```Raku
%hash<foo bar>;       # same as %hash{ <foo bar> } 
%hash«foo "$var"»;    # same as %hash{ «foo "$var"» } 
%hash<<foo "$var">>;  # same as %hash{ <<foo "$var">> } 
```

你可能已经注意到，我们使用 `=>` 运算符来避免将 `Zoe` 括起来，但同样的操作符并没有在 `Date.new(2015, 4, 5)` 周围放置不可见的引号，并且我们能够使用 `$stats{ Date.new(2015, 4, 4) + 1 }` 找到相同的元素。这是因为 `=>` 只在单个词周围加上不可见的引号，而词是指标识符/名称。这里的 `=>` 运算符是为了防止我们意外调用函数或使用具有该名称的常量。

You may have noted above that we avoided having to quote `Zoe` by using the `=>` operator, but that same operator did not just put invisible quotes around `Date.new(2015, 4, 5)`, and we were able to find the same element using `$stats{ Date.new(2015, 4, 4) + 1 }`. This is because `=>` only puts invisible quotes around single words, and by "word" we mean an identifier/name. The `=>` operator is there to prevent us from accidentally calling functions or using constants with that name.

哈希下标与 `=>` 的行为不一样。默认的 `Hash` 已经按照新用户期望的方式（使用其他语言经验），以及一般的易用性来实现。在默认的 `Hash` 下，下标键强制转换成字符串，只要这些键产生 `Cool` 对象。可以对集合使用 `.perl` 来确定键是字符串还是对象：

Hash subscripts do not do the same thing as `=>`. The default `Hash` has been made to behave the way new users have come to expect from using other languages, and for general ease of use. On a default `Hash`, subscripts coerce keys into strings, as long as those keys produce something `Cool`. You can use `.perl` on a collection to be sure whether the keys are strings or objects:

```Raku
( 1  => 1 ).perl.say;            # OUTPUT: «1 => 1␤» 
my %h; %h{1}   = 1; say %h.perl; # OUTPUT: «{ "1" => 1 }␤» 
( 1/2 => 1 ).perl.say;           # OUTPUT: «0.5 => 1␤» 
my %h; %h{1/2} = 1; say %h.perl; # OUTPUT: «{ "0.5" => 1 }␤» 
( pi => 1 ).perl.say;            # OUTPUT: «:pi(1)␤» 
my %h; %h{pi}  = 1; say %h.perl; # OUTPUT: «{ "3.14159265358979" => 1 }␤»
```

虽然单个名称周围的不可见引号内置在 `=>` 中，但字符串转换不会内置在大括号中：这是默认 `Hash` 的行为。不是所有类型的散列或集合都这样做：

While the invisible quotes around single names is built into `=>`, string conversion is not built into the curly braces: it is a behavior of the default `Hash`. Not all types of hashes or collections do so:

```Raku
my %h := MixHash.new;
%h{pi} = 1; %h.perl.say;         # OUTPUT: «(3.14159265358979e0=>1).MixHash␤» 
```

（任何 `=>` 转换为字符串的名称也可以用来使用“副词标识”来构建键值对，当通过 `.perl` 查看时，将出现这种方式，这就是为什么我们在上面看到 `:pi(1)` 的原因）。

(Any name that `=>` would convert to a string can also be used to build a pair using "adverbial notation" and will appear that way when viewed through `.perl`, which is why we see `:pi(1)` above.)

<a id="应用下标--applying-subscripts"></a>
## 应用下标 / Applying subscripts

下标可以应用于任何返回可使用下标的对象的表达式，而不仅仅是应用于变量：

Subscripts can be applied to any expression that returns a subscriptable object, not just to variables:

```Raku
say "__Hello__".match(/__(.*)__/)[0];   # OUTPUT: «｢Hello｣␤» 
say "__Hello__".match(/__(.*)__/).[0];  # same, in method notation
```

位置下标和关联下标不是互斥的，例如，[Match](https://docs.raku.org/type/Match) 对象支持两者（两者访问不同的数据集）。此外，为了使列表处理更方便，类 [Any](https://docs.raku.org/type/Any) 为位置下标提供了一个备选实现，它简单地将调用者视为一个元素的列表。（但对于关联下标没有这样的备选实现，因此它们在应用于不支持它们的对象时会抛出运行时错误。）

Positional and associative subscripting are not mutually exclusive - for example, [Match](https://docs.raku.org/type/Match) objects support both (each accessing a different set of data). Also, to make list processing more convenient, class [Any](https://docs.raku.org/type/Any) provides a fallback implementation for positional subscripts which simply treats the invocant as a list of one element. (But there's no such fallback for associative subscripts, so they throw a runtime error when applied to an object that does not implement support for them.)

```Raku
say 42[0];    # OUTPUT: «42␤» 
say 42<foo>;  # ERROR: Type Int does not support associative indexing. 
```

<a id="不存在的成员--nonexistent-elements"></a>
# 不存在的成员 / Nonexistent elements

当一个*不存在*的元素被下标寻址时会发生什么，取决于所集合的类型。标准 [Array](https://docs.raku.org/type/Array) 和 [Hash](https://docs.raku.org/type/Hash) 集合返回其[值类型约束](https://docs.raku.org/routine/of)的类型对象（默认情况下，是 [Any](https://docs.raku.org/type/Any)，除非集合已被 [`is default`](https://docs.raku.org/type/Variable#trait_is_default) 特性声明，在这种情况下，返回值将是程序员声明的：

What happens when a *nonexistent* element is addressed by a subscript is up to the collection type in question. Standard [Array](https://docs.raku.org/type/Array) and [Hash](https://docs.raku.org/type/Hash) collections return the type object of their [value type constraint](https://docs.raku.org/routine/of) (which, by default, is [Any](https://docs.raku.org/type/Any)) unless the collection has been declared with the [`is default`](https://docs.raku.org/type/Variable#trait_is_default) trait in which case the returned value will be whatever the programmer declared it to be:

```Raku
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

```Raku
say (0, 10, 20)[3];           # OUTPUT: «Nil␤» 
say bag(<a a b b b>)<c>;      # OUTPUT: «0␤» 
say array[uint8].new(1, 2)[2] # OUTPUT: «0␤»
```

为了无声地跳过下标操作中不存在的元素，请参阅[截断切片](https://docs.raku.org/language/subscripts#Truncating_slices)和 [:v](https://docs.raku.org/language/subscripts#%3Av) 副词。

To silently skip nonexistent elements in a subscripting operation, see [Truncating slices](https://docs.raku.org/language/subscripts#Truncating_slices) and the [:v](https://docs.raku.org/language/subscripts#%3Av) adverb.

<a id="从末尾--from-the-end"></a>
# 从末尾 / From the end

位置索引是从集合的开始计算出来的，但也有一个符号，用来寻址元素相对于它们的末尾的位置： `*-1` 指的是最后一个元素，`*-2` 指的是倒数第二个元素，等等。

Positional indices are counted from the start of the collection, but there's also a notation for addressing elements by their position relative to the end: `*-1` refers to the last element, `*-2` to the second-to-last element, and so on.

```Raku
my @alphabet = 'A' .. 'Z';
say @alphabet[*-1];  # OUTPUT: «Z␤» 
say @alphabet[*-2];  # OUTPUT: «Y␤» 
say @alphabet[*-3];  # OUTPUT: «X␤»
```

**注意**：星号很重要。如果就像你在许多其他编程语言中所做的那样只传递一个负整数（例如 `@alphabet[-1]`），在 Raku 中会抛出一个错误。

**Note**: The asterisk is important. Passing a bare negative integer (e.g. `@alphabet[-1]`) like you would do in many other programming languages, throws an error in Raku.

这里实际发生的是，像 `*-1` 这样的表达式通过 [Whatever](https://docs.raku.org/type/Whatever) 来声明代码对象。 `[ ]` 下标的反应是将代码对象作为索引，以集合的长度作为参数调用它，并使用结果值作为实际索引。换句话说，`@alphabet[*-1]` 变成了 `@alphabet[@alphabet.elems - 1]`。

What actually happens here, is that an expression like `*-1` declares a code object via [Whatever](https://docs.raku.org/type/Whatever)-currying - and the `[ ]` subscript reacts to being given a code object as an index, by calling it with the length of the collection as argument and using the result value as the actual index. In other words, `@alphabet[*-1]` becomes `@alphabet[@alphabet.elems - 1]`.

这意味着你可以使用取决于集合大小的任意表达式：

This means that you can use arbitrary expressions which depend on the size of the collection:

```Raku
say @array[* div 2];  # select the middlemost element 
say @array[$i % *];   # wrap around a given index ("modular arithmetic") 
say @array[ -> $size { $i % $size } ];  # same as previous 
```

<a id="切片--slices"></a>
# 切片 / Slices

当需要访问一个集合的多个元素时，有一个快捷方式来完成多个单独的子查询操作：只需在下标中指定索引/键的列表，就可以返回一个元素的*列表*，也叫做“切片” — 以相同的顺序。

When multiple elements of a collection need to be accessed, there's a shortcut to doing multiple separate subscripting operations: Simply specify a *list* of indices/keys in the subscript, to get back a *list* of elements - also called a "slice" - in the same order.

对于位置切片，你可以将普通索引与[从末尾](https://docs.raku.org/language/subscripts#From_the_end)索引混合使用：

For positional slices, you can mix normal indices with [from-the-end](https://docs.raku.org/language/subscripts#From_the_end) ones:

```Raku
my @alphabet = 'a' .. 'z';
say @alphabet[15, 4, *-9, 11].perl;  # OUTPUT: «("p", "e", "r", "l")␤»
```

在上面的 `*-number` 结构中，`*` 表示数组的结尾，如上面在[从结尾](https://docs.raku.org/language/subscripts#From_the_end)部分中所述。因此，如果要获取数组的最后 N 个元素，则必须创建包含它的 [Range](https://docs.raku.org/type/Range)。

In the `*-number` construct above, `*` indicates the end of the array as explained above in the [From the end](https://docs.raku.org/language/subscripts#From_the_end) section. So if you want to take the last N elements of the array, you will have to create a [Range](https://docs.raku.org/type/Range) that includes it.

```Raku
(5802..5830).map( {.chr} )[*-10..*-5] # OUTPUT:  «(ᚽ ᚾ ᚿ ᛀ ᛁ ᛂ)␤»
```

使用 `*` 作为范围的最后一个元素将有效地返回集合的最后一个元素。

Using `*` as the last element of the range will, effectively, return the last elements of the collection.

对于关联切片，尖括号形式通常很实用：

For associative slices, the angle brackets form often comes in handy:

```Raku
my %color = kiwi => "green", banana => "yellow", cherry => "red";
say %color{"cherry", "kiwi"};  # OUTPUT: «(red green)␤» 
say %color<cherry kiwi>;       # OUTPUT: «(red green)␤» 
say %color{*};                 # OUTPUT: «(red yellow green)␤»
```

请注意，切片是由传递到（[一维的](https://docs.raku.org/language/subscripts#Multiple_dimensions)）下标的*类型*控制的，而不是它的长度。尤其是*类型*可以是以下任意一种：

Be aware that slices are controlled by the *type* of what is passed to ([one dimension of](https://docs.raku.org/language/subscripts#Multiple_dimensions)) the subscript, not its length. In particular the *type* can be any of the following:

- 一个惰性的 Iterable，在[ ]中被[截断](https://docs.raku.org/language/subscripts#Truncating_slices)
- 因此，无限 Range 将被截断，但有限 Range 将产生一个正常切片
- '*' 将返回整个片（就像所有键/索引都已指定一样）
- 任何其他提供单个元素访问而非切片的对象
- Callable，它返回的任何内容（这可能导致递归）
- empty, 被称为 [Zen slice](https://docs.raku.org/language/subscripts#Zen_slices) 的完全切片
- 不同于上述类型的 Iterable，正常切片

- a lazy Iterable, that [truncates](https://docs.raku.org/language/subscripts#Truncating_slices) in [ ]
- accordingly, an infinite Range will truncate, but a finite one produces a normal slice
- '*' (whatever-star), that returns the full slice (as if all keys/indices were specified)
- any other object, that provides a single-element access rather than a slice
- Callable, whatever is returned by the callable (this can lead to recursion)
- empty, the full slice known as [Zen slice](https://docs.raku.org/language/subscripts#Zen_slices)
- any iterable different from the above ones, normal slice

`*` 和 Zen Slice（空）之间的显著区别是，[Whatever](https://docs.raku.org/type/Whatever) 星号将导致完全[具体化](https://docs.raku.org/language/glossary#index-entry-Reify)或单条目化，而 Zen 切片不会。两个版本都会[去容器化](https://perl6advent.wordpress.com/2017/12/02/perl-6-sigils-variables-and-containers/#decont)。

The notable difference between `*` and Zen slice (empty) is that the [Whatever](https://docs.raku.org/type/Whatever) star will cause full [reification](https://docs.raku.org/language/glossary#index-entry-Reify) or itemization, while Zen slice won't. Both versions also [de-cont](https://perl6advent.wordpress.com/2017/12/02/perl-6-sigils-variables-and-containers/#decont).

因此，即使是单元素列表也会返回一个切片，而裸标量值则不会：

So even a one-element list returns a slice, whereas a bare scalar value doesn't:

```Raku
say @alphabet[2,];        # OUTPUT: «(c)␤» 
say @alphabet[2,].^name;  # OUTPUT: «List␤» 
 
say @alphabet[2];         # OUTPUT: «c␤» 
say @alphabet[2].^name;   # OUTPUT: «Str␤» 
```

（关联下标的尖括号形式之所以有效，是因为[词引用](https://docs.raku.org/language/quoting#Word_quoting:_qw)在单个单词的情况下方便地返回 [Str](https://docs.raku.org/type/Str)，而在多个单词的情况下则返回 [List](https://docs.raku.org/type/List)。）

(The angle bracket form for associative subscripts works out because [word quoting](https://docs.raku.org/language/quoting#Word_quoting:_qw) conveniently returns a [Str](https://docs.raku.org/type/Str) in case of a single word, but a [List](https://docs.raku.org/type/List) in case of multiple words.)

事实上，（[当前维度](https://docs.raku.org/language/subscripts#Multiple_dimensions)）的列表结构下标在切片操作中被保留（但 Iterable 的类型不是 - 结果总是列表）。

In fact, the list structure of ([the current dimension of](https://docs.raku.org/language/subscripts#Multiple_dimensions)) the subscript is preserved across the slice operation (but the kind of Iterable is not – the result is always just lists.)

```Raku
say @alphabet[0, (1..2, (3,))];       # OUTPUT: «(a ((b c) (d)))␤» 
say @alphabet[0, (1..2, [3,])];       # OUTPUT: «(a ((b c) (d)))␤» 
say @alphabet[flat 0, (1..2, (3,))];  # OUTPUT: «(a b c d)␤» 
say flat @alphabet[0, (1..2, (3,))];  # OUTPUT: «(a b c d)␤» 
```

<a id="截断切片--truncating-slices"></a>
## 截断切片 / Truncating slices

引用切片下标中不存在的元素会导致输出 `List` 包含未定义的值（或[其他任何内容](https://docs.raku.org/language/subscripts#Nonexistent_elements)，所讨论的集合选择返回不存在的元素）：

Referring to nonexistent elements in a slice subscript causes the output `List` to contain undefined values (or [whatever else](https://docs.raku.org/language/subscripts#Nonexistent_elements) the collection in question chooses to return for nonexistent elements):

```Raku
my  @letters = <a b c d e f>;
say @letters[3..7];  # OUTPUT: «(d e f (Any) (Any))␤» 
```

乍一看，这种行为似乎不直观，但在希望在当前不存在值的索引处赋值的情况下，这种行为是可取的。

This behavior, while at first glance may seem unintuitive, is desirable in instances when you want to assign a value at an index in which a value does not currently exist.

```Raku
my  @letters;
say @letters; # OUTPUT: «[]␤» 
 
@letters[^10] = 'a'..'z';
say @letters; # OUTPUT: «[a b c d e f g h i j]␤» 
```

如果希望结果切片仅包含现有元素，则可以使用 [:v](https://docs.raku.org/language/subscripts#%3Av) 副词无提示地跳过不存在的元素。

If you want the resulting slice to only include existing elements, you can silently skip the non-existent elements using the [:v](https://docs.raku.org/language/subscripts#%3Av) adverb.

```Raku
my  @letters = <a b c d e f>;
say @letters[3..7]:v;  # OUTPUT: «(d e f)␤» 
```

通过 [lazy](https://docs.raku.org/language/list#Lazy_lists) 下标为集合编制索引时的行为与使用热切的对应项编制索引时的行为不同。当通过惰性下标访问时，结果切片将被截断。

The behavior when indexing a collection via [lazy](https://docs.raku.org/language/list#Lazy_lists) subscripts is different than when indexing with their eager counterparts. When accessing via a lazy subscript, the resulting slice will be truncated.

```Raku
say @letters[lazy 3..7]; # OUTPUT: «(d e f)␤» 
say @letters[     3..*]; # OUTPUT: «(d e f)␤» 
```

这种行为的存在是为了预防大量、可能无限的 `Lists` 的失控生成以及由此产生的内存不足问题。

This behavior exists as a precaution to prevent runaway generation of massive, potentially infinite `Lists` and the out-of-memory issues that occur as a result.

<a id="禅切片--zen-slices"></a>
## 禅切片 / Zen slices

如果将下标运算符放在对象后面而根本不指定任何索引/键，则将返回被下标的对象本身。因为它是空的，但返回所有内容，所以它被称为“禅切片”。

If you put the subscript operator behind an object without specifying any indices/keys at all, it simply returns the subscripted object itself. Since it is empty but returns everything, it is known as a *Zen slice*.

禅切片不同于传递 Whatever 星号（与普通切片一样，无论原始对象的类型如何，它总是返回元素列表）或空列表（返回空切片）：

Zen slicing is different from passing a Whatever-star (which, like a normal slice, always returns a List of elements no matter the type of the original object) or an empty list (which returns an empty slice):

```Raku
my %bag := (orange => 1, apple => 3).Bag;
say %bag<>;    # OUTPUT: «Bag(apple(3), orange)␤» 
say %bag{};    # OUTPUT: «Bag(apple(3), orange)␤» 
say %bag{*};   # OUTPUT: «(1 3)␤» 
say %bag{()};  # OUTPUT: «()␤»
```

禅切片不[具体化](https://docs.raku.org/language/glossary#index-entry-Reify)或[缓存](https://docs.raku.org/routine/cache)，只返回调用者。它通常用于[插值](https://docs.raku.org/language/quoting#Interpolation:_qq)整个数组/散列成字符串或[去容器化](https://docs.raku.org/language/glossary#index-entry-decont)。

Zen slicing does not [reify](https://docs.raku.org/language/glossary#index-entry-Reify) or [cache](https://docs.raku.org/routine/cache) and merely returns the invocant. It is usually used to [interpolate](https://docs.raku.org/language/quoting#Interpolation:_qq) entire arrays / hashes into strings or to [decont](https://docs.raku.org/language/glossary#index-entry-decont).

```Raku
my @words = "cruel", "world";
say "Hello, @words[]!";  # OUTPUT: «Hello, cruel world!␤» 
 
my $list = <a b c>;
.say for $list;   # OUTPUT: «(a b c)␤» 
.say for $list<>; # OUTPUT: «a␤b␤c␤» 
.say for $list[]; # OUTPUT: «a␤b␤c␤»
```

<a id="多维--multiple-dimensions"></a>
# 多维 / Multiple dimensions

下标中的维度用分号分隔，允许混合元素和维度列表。

Dimensions in subscripts are separated by a semicolon, allowing to mix lists of elements and dimensions.

```Raku
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

多维下标与 [Whatever](https://docs.raku.org/type/Whatever) 结合使用时，可用于展平嵌套列表。

Multidimensional subscripts can be used to flatten nested lists when combined with [Whatever](https://docs.raku.org/type/Whatever).

```Raku
my @toomany = [[<a b>], [1, 2]];
say @toomany;
# OUTPUT: «[[a b] [1 2]]␤» 
 
say @toomany[*;*];
# OUTPUT: «(a b 1 2)␤»
```

你可以根据需要使用任意多个*展平分号*；最多会有任意多个嵌套级别展平分号：

You can use as many *flattening semicolons* as you want; there will be, at most, as many nesting levels flattened as the number of semicolons:

```Raku
say [[1,2,[3,4]],[4,5]][*;*];     # OUTPUT: «(1 2 [3 4] 4 5)␤» 
say [[1,2,[3,4]],[4,5]][*;*;*;*]; # OUTPUT: «(1 2 3 4 4 5)␤»
```

在第一个例子中，一个 `Whatever` 小于层数，最深的一个不会被展平；在第二个例子中，所有的数都被展平了，因为它大于层数。

In the first example, with one `Whatever` less than the number of levels, the deepest one will not be flattened; in the second case it is, since it's greater than the number of levels.

你可以使用 [Whatever](https://docs.raku.org/type/Whatever) 在多维下标中选择范围或“行”。

You can use [Whatever](https://docs.raku.org/type/Whatever) to select ranges or "rows" in multidimensional subscripts.

```Raku
my @a = [[1,2], [3,4]];
say @a[*;1]; # 2nd element of each sub list 
# OUTPUT: «(2 4)␤» 
my @a = (<1 c 6>, <2 a 4>, <5 b 3>);
say @a.sort( { $_[1] } ); # sort by 2nd column 
# OUTPUT: «((2 a 4) (5 b 3) (1 c 6))␤»
```

<a id="修改成员--modifying-elements"></a>
# 修改成员 / Modifying elements

<a id="自动生动化--autovivification"></a>
# 自动生动化 / Autovivification

下标参与“自动生动化”，即数组和散列在需要时自动出现的过程，这样你就可以构建嵌套的数据结构，而不必在每个级别预先声明集合类型：

Subscripts participate in "autovivification", i.e. the process by which arrays and hashes automatically spring into existence when needed, so that you can build nested data structures without having to pre-declare the collection type at each level:

```Raku
my $beatles;
 
$beatles{"White Album"}[0] = "Back in the U.S.S.R.";  # autovivification! 
 
say $beatles.perl;  # OUTPUT: «${"White Album" => $["Back in the U.S.S.R."]}␤» 
```

`$beatles` 开始时未定义，但成为一个 [Hash](https://docs.raku.org/type/Hash) 对象，因为它在赋值中被 `{ }` 下标寻址。类似地，`$beatles{"White Album"}` 由于在赋值中用 `[ ]` 下标而成为一个 [Array](https://docs.raku.org/type/Array) 对象。

`$beatles` started out undefined, but became a [Hash](https://docs.raku.org/type/Hash) object because it was subscripted with `{ }` in the assignment. Similarly, `$beatles{"White Album"}` became an [Array](https://docs.raku.org/type/Array) object due to being subscripted with `[ ]` in the assignment.

请注意，下标本身不会导致自动生动化：只有当下标链的结果被*赋值*（或以其他方式发生转变）时，才会发生这种情况。

Note that the subscripting itself does not cause autovivification: It only happens when the result of the subscripting chain is *assigned* to (or otherwise mutated).

<a id="绑定--binding"></a>
# 绑定 / Binding

下标表达式也可以在绑定语句的左侧。如果下标集合的类型支持，则这将使用指定的容器替换在集合的“槽”中自然找到的任何值容器。

A subscripting expression may also be used as the left-hand-side of a binding statement. If supported by the subscripted collection's type, this replaces whatever value container would be naturally found at that "slot" of the collection, with the specified container.

内置的 [Array](https://docs.raku.org/type/Array) 和 [Hash](https://docs.raku.org/type/Hash) 类型支持此功能，以便构建复杂的链数据结构：

The built-in [Array](https://docs.raku.org/type/Array) and [Hash](https://docs.raku.org/type/Hash) types support this in order to allow building complex linked data structures:

```Raku
my @a = 10, 11, 12, 13;
my $x = 1;

@a[2] := $x;  # Bound! (@a[2] and $x refer to the same container now.) 

$x++; @a[2]++;

say @a;  # OUTPUT: «[10 11 3 13]␤» 
say $x;  # OUTPUT: «3␤»
```

当惰性数据结构是较大数据结构的一部分时，这特别有用。

This can be specially useful when lazy data structures are part of a bigger one.

```Raku
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

在这种情况下，散列键绑定到惰性序列。它们是绑定的，这意味着无论计算出什么状态，哈希值和绑定到的序列都会共享，从而加快后续元素的计算速度。

In this case, hash keys are bound to lazily generated sequences. The fact that they are bound means that whatever state has been computed is shared by the hash value and the sequence it's bound to, making computations of subsequent elements faster.

底层机制见[方法 BIND-POS](https://docs.raku.org/language/subscripts#method_BIND-POS) 和 [方法 BIND-KEY](https://docs.raku.org/language/subscripts#method_BIND-KEY)。

See [method BIND-POS](https://docs.raku.org/language/subscripts#method_BIND-POS) and [method BIND-KEY](https://docs.raku.org/language/subscripts#method_BIND-KEY) for the underlying mechanism.

<a id="副词--adverbs"></a>
# 副词 / Adverbs

下标操作的返回值和可能的副作用可以使用副词控制；这些副词在相关的下标[运算符](https://docs.raku.org/language/operators#Method_postfix_precedence)上定义。

The return value and possible side-effect of a subscripting operation can be controlled using adverbs; these are defined on the relevant subscript [operators](https://docs.raku.org/language/operators#Method_postfix_precedence).

注意运算符副词的相对松散的优先级，这可能要求你在复合表达式中添加括号：

Beware of the relatively loose precedence of operator adverbs, which may require you to add parentheses in compound expressions:

```Raku
if $foo || %hash<key>:exists { ... }    # WRONG, tries to adverb the || op 
if $foo || (%hash<key>:exists) { ... }  # correct 
if $foo or %hash<key>:exists { ... }    # also correct 
```

支持的副词有：

The supported adverbs are:

<a id="exists"></a>
## `:exists`

返回请求的元素是否存在，而不是返回元素的实际值。这可用于区分具有未定义值的元素和完全不属于集合的元素：

Returns whether or not the requested element exists, instead of returning the element's actual value. This can be used to distinguish between elements with an undefined value, and elements that aren't part of the collection at all:

```Raku
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

也可以否定以测试是否不存在：

May also be negated to test for non-existence:

```Raku
say %fruit<apple banana>:!exists; # OUTPUT: «(False True)␤» 
```

要检查切片中*所有*元素是否存在，请使用 [all](https://docs.raku.org/routine/all) junction：

To check if *all* elements of a slice exist, use an [all](https://docs.raku.org/routine/all) junction:

```Raku
if all %fruit<apple orange banana>:exists { ... }
```

它可以用于多维数组和散列：

It can be used on multi-dimensional arrays and hashes:

```Raku
my @multi-dim = 1, [2, 3, [4, 5]];
say @multi-dim[1;2;0]:exists;                # OUTPUT: «True␤» 
say @multi-dim[1;2;5]:exists;                # OUTPUT: «False␤» 
 
my %multi-dim = 1 => { foo => { 3 => 42 } };
say %multi-dim{1;'foo';3}:exists;            # OUTPUT: «True␤» 
say %multi-dim{1;'bar';3}:exists;            # OUTPUT: «False␤»
```

`:exists` 可以与 [:delete](https://docs.raku.org/language/subscripts#%3Adelete) 和 [:p](https://docs.raku.org/language/subscripts#%3Ap)/[:kv](https://docs.raku.org/language/subscripts#%3Akv) 副词组合使用，在这种情况下，行为由这些副词决定，除了任何返回的元素*值*被相应的 [Bool](https://docs.raku.org/type/Bool) 替换表示元素是否*存在*。

`:exists` can be combined with the [:delete](https://docs.raku.org/language/subscripts#%3Adelete) and [:p](https://docs.raku.org/language/subscripts#%3Ap)/[:kv](https://docs.raku.org/language/subscripts#%3Akv) adverbs - in which case the behavior is determined by those adverbs, except that any returned element *value* is replaced with the corresponding [Bool](https://docs.raku.org/type/Bool) indicating element *existence*.

底层机制见[方法 EXISTS-POS](https://docs.raku.org/language/subscripts#method_EXISTS-POS) 和 [方法 EXISTS-KEY](https://docs.raku.org/language/subscripts#method_EXISTS-KEY)。

See [method EXISTS-POS](https://docs.raku.org/language/subscripts#method_EXISTS-POS) and [method EXISTS-KEY](https://docs.raku.org/language/subscripts#method_EXISTS-KEY) for the underlying mechanism.

<a id="delete"></a>
## `:delete`

从集合中删除元素，或者，如果集合支持，则在给定索引处创建一个孔（占位），并返回其值。

Delete the element from the collection or, if supported by the collection, creates a hole at the given index, in addition to returning its value.

```Raku
my @tens = 0, 10, 20, 30;
say @tens[3]:delete;     # OUTPUT: «30␤» 
say @tens;               # OUTPUT: «[0 10 20]␤» 
 
my %fruit = apple => 5, orange => 10, banana => 4, peach => 17;
say %fruit<apple>:delete;         # OUTPUT: «5␤» 
say %fruit<peach orange>:delete;  # OUTPUT: «(17 10)␤» 
say %fruit;                       # OUTPUT: «{banana => 4}␤»
```

请注意，赋值 `Nil` 会将给定索引处的容器还原为其默认值。它不会造成孔。可以使用 `:exists` 测试创建的孔，但迭代不会跳过它们，而是生成未定义的值。

Note that assigning `Nil` will revert the container at the given index to its default value. It will not create a hole. The created holes can be tested for with `:exists` but iteration will not skip them and produce undefined values instead.

```Raku
my @a = 1, 2, 3;
@a[1]:delete;
say @a[1]:exists;
# OUTPUT: «False␤» 
.say for @a;
# OUTPUT: «1␤(Any)␤3␤»
```

副词的否定形式实际上并没有删除这个成分。这意味着你可以传递标志以使其成为条件：

With the negated form of the adverb, the element is not actually deleted. This means you can pass a flag to make it conditional:

```Raku
say %fruit<apple> :delete($flag);  # deletes the element only if $flag is 
                                   # true, but always returns the value. 
```

可以与 [:exists](https://docs.raku.org/language/subscripts#%3Aexists) 以及 [:p](https://docs.raku.org/language/subscripts#%3Ap)/[:kv](https://docs.raku.org/language/subscripts#%3Akv)/[:k](https://docs.raku.org/language/subscripts#%3Ak)/[:v](https://docs.raku.org/language/subscripts#%3Av) 副词结合使用 - 在这种情况下返回值将由这些副词决定，但元素同时也将被删除。

Can be combined with the [:exists](https://docs.raku.org/language/subscripts#%3Aexists) and [:p](https://docs.raku.org/language/subscripts#%3Ap)/[:kv](https://docs.raku.org/language/subscripts#%3Akv)/[:k](https://docs.raku.org/language/subscripts#%3Ak)/[:v](https://docs.raku.org/language/subscripts#%3Av) adverbs - in which case the return value will be determined by those adverbs, but the element will at the same time also be deleted.

底层机制见[方法 DELETE-POS](https://docs.raku.org/language/subscripts#method_DELETE-POS) 和[方法 DELETE-KEY](https://docs.raku.org/language/subscripts#method_DELETE-KEY)。

See [method DELETE-POS](https://docs.raku.org/language/subscripts#method_DELETE-POS) and [method DELETE-KEY](https://docs.raku.org/language/subscripts#method_DELETE-KEY) for the underlying mechanism.

<a id="p"></a>
## `:p`

以 [Pair](https://docs.raku.org/type/Pair) 的形式返回索引/键和元素的值，并安静地跳过不存在的元素：

Return both the index/key and the value of the element, in the form of a [Pair](https://docs.raku.org/type/Pair), and silently skip nonexistent elements:

```Raku
my  @tens = 0, 10, 20, 30;
say @tens[1]:p;        # OUTPUT: «1 => 10␤» 
say @tens[0, 4, 2]:p;  # OUTPUT: «(0 => 0 2 => 20)␤» 

my  %month = Jan => 1, Feb => 2, Mar => 3;
say %month<Feb>:p;          # OUTPUT: «Feb => 2␤» 
say %month<Jan Foo Mar>:p;  # OUTPUT: «(Jan => 1 Mar => 3)␤»
```

如果不想跳过不存在的元素，请使用否定形式：

If you *don't* want to skip nonexistent elements, use the negated form:

```Raku
say %month<Jan Foo Mar>:!p;  # OUTPUT: «(Jan => 1 Foo => (Any) Mar => 3)␤» 
```

可以与 [:exists](https://docs.raku.org/language/subscripts#%3Aexists) 和 [:delete](https://docs.raku.org/language/subscripts#%3Adelete) 副词组合使用。

Can be combined with the [:exists](https://docs.raku.org/language/subscripts#%3Aexists) and [:delete](https://docs.raku.org/language/subscripts#%3Adelete) adverbs.

另请参见 [pairs](https://docs.raku.org/routine/pairs) 例程。

See also the [pairs](https://docs.raku.org/routine/pairs) routine.

<a id="kv"></a>
## `:kv`

以 [List](https://docs.raku.org/type/List) 的形式返回索引/键和元素的值，并自动跳过不存在的元素。当在[切片](https://docs.raku.org/language/subscripts#Slices)上使用时，返回值是键和值交错的单一平面列表：

Return both the index/key and the value of the element, in the form of a [List](https://docs.raku.org/type/List), and silently skip nonexistent elements. When used on a [slice](https://docs.raku.org/language/subscripts#Slices), the return value is a single flat list of interleaved keys and values:

```Raku
my  @tens = 0, 10, 20, 30;
say @tens[1]:kv;        # OUTPUT: «(1 10)␤» 
say @tens[0, 4, 2]:kv;  # OUTPUT: «(0 0 2 20)␤» 
 
my  %month = Jan => 1, Feb => 2, Mar => 3;
say %month<Feb>:kv;          # OUTPUT: «(Feb 2)␤» 
say %month<Jan Foo Mar>:kv;  # OUTPUT: «(Jan 1 Mar 3)␤»
```

如果*不*想跳过不存在的元素，请使用否定形式：

If you *don't* want to skip nonexistent elements, use the negated form:

```Raku
say %month<Jan Foo Mar>:!kv;  # OUTPUT: «(Jan 1 Foo (Any) Mar 3)␤» 
```

这个副词通常用于遍历切片：

This adverb is commonly used to iterate over slices:

```Raku
for %month<Feb Mar>:kv -> $month, $i {
    say "$month had {Date.new(2015, $i, 1).days-in-month} days in 2015"
}
```

可以与 [:exists](https://docs.raku.org/language/subscripts#%3Aexists) 和 [:delete](https://docs.raku.org/language/subscripts#%3Adelete) 副词组合使用。

Can be combined with the [:exists](https://docs.raku.org/language/subscripts#%3Aexists) and [:delete](https://docs.raku.org/language/subscripts#%3Adelete) adverbs.

另请参见 [kv](https://docs.raku.org/routine/kv) 例程。

See also the [kv](https://docs.raku.org/routine/kv) routine.

<a id="k"></a>
## `:k`

只返回元素的索引/键，而不是其值，并安静地跳过不存在的元素：

Return only the index/key of the element, rather than its value, and silently skip nonexistent elements:

```Raku
my @tens = 0, 10, 20, 30;
say @tens[1]:k;        # OUTPUT: «1␤» 
say @tens[0, 4, 2]:k;  # OUTPUT: «(0 2)␤» 
 
my %month = Jan => 1, Feb => 2, Mar => 3;
say %month<Feb>:k;          # OUTPUT: «Feb␤» 
say %month<Jan Foo Mar>:k;  # OUTPUT: «(Jan Mar)␤»
```

如果*不*想跳过不存在的元素，请使用否定形式：

If you *don't* want to skip nonexistent elements, use the negated form:

```Raku
say %month<Jan Foo Mar>:!k;  # OUTPUT: «(Jan Foo Mar)␤» 
```

另请参见 [keys](https://docs.raku.org/routine/keys) 例程。

See also the [keys](https://docs.raku.org/routine/keys) routine.

<a id="v"></a>
## `:v`

返回元素的裸值（而不是潜在地返回可变值容器），并安静地跳过不存在的元素：

Return the bare value of the element (rather than potentially returning a mutable value container), and silently skip nonexistent elements:

```Raku
my @tens = 0, 10, 20, 30;
say @tens[1]:v;        # OUTPUT: «10␤» 
say @tens[0, 4, 2]:v;  # OUTPUT: «(0, 20)␤» 
@tens[3] = 31;         # OK 
@tens[3]:v = 31;       # ERROR, Cannot modify an immutable Int (31) 
 
my %month = Jan => 1, Feb => 2, Mar => 3;
say %month<Feb>:v;          # OUTPUT: «2␤» 
say %month<Jan Foo Mar>:v;  # OUTPUT: «(1 3)␤» 
```

如果*不*想跳过不存在的元素，请使用否定形式：

If you *don't* want to skip nonexistent elements, use the negated form:

```Raku
say %month<Jan Foo Mar>:!v;  # OUTPUT: «(1 (Any) 3)␤» 
```

另请参见 [values](https://docs.raku.org/routine/values) 例程。

See also the [values](https://docs.raku.org/routine/values) routine.

<a id="自定义类型--custom-types"></a>
# 自定义类型 / Custom types

本页描述的下标接口并不是 Raku 内置集合类型的专有接口，你可以（而且应该）将它们用于任何希望通过索引或键访问数据的自定义类型。

The subscripting interfaces described on this page are not meant to be exclusive to Raku's built-in collection types - you can (and should) reuse them for any custom type that wants to provide access to data by index or key.

你不必手动重载[后环缀运算符 `[ ]`](https://docs.raku.org/routine/[%20]#postcircumfix_[_]) 和[后环缀运算符 `{ }`](https://docs.raku.org/routine/%7b%20%7d{postcircumfix{}) 运算符并重新实现它们的所有魔力，要实现这一点，你可以依赖于它们的标准实现分派给一组定义良好的底层方法。例如：

You don't have to manually overload the [`postcircumfix [ ]`](https://docs.raku.org/routine/[%20]#postcircumfix_[_]) and [`postcircumfix { }`](https://docs.raku.org/routine/%7B%20%7D#postcircumfix_{_}) operators and re-implement all their magic, to achieve that - instead, you can rely on the fact that their standard implementation dispatches to a well-defined set of low-level methods behind the scenes. For example:

| when you write: | this gets called behind the scenes:            |
| --------------- | ---------------------------------------------- |
| %foo<aa>        | %foo.AT-KEY("aa")                              |
| %foo<aa>:delete | %foo.DELETE-KEY("aa")                          |
| @foo[3, 4, 5]   | @foo.AT-POS(3), @foo.AT-POS(4), @foo.AT-POS(5) |
| @foo[*-1]       | @foo.AT-POS(@foo.elems - 1)                    |

因此，为了使下标正常工作，你只需要实现或委托自定义类型的那些低级方法[下面详细介绍](https://docs.raku.org/language/subscripts#Methods_to_implement_for_positional_subscripting)。

So in order to make subscripting work, you only have to implement or delegate those low-level methods ([detailed below](https://docs.raku.org/language/subscripts#Methods_to_implement_for_positional_subscripting)) for your custom type.

如果这样做了，还应该让你的类型分别组成 [`Positional`](https://docs.raku.org/type/Positional) 或 [`Associative`](https://docs.raku.org/type/Associative) 角色。这本身并没有添加任何功能，但是声明（并且可能是用于检查）类型实现了相应的下标接口。

If you do, you should also let your type compose the [`Positional`](https://docs.raku.org/type/Positional) or [`Associative`](https://docs.raku.org/type/Associative) role, respectively. This doesn't add any functionality per se, but announces (and may be used to check) that the type implements the corresponding subscripting interface.

<a id="自定义类型例子--custom-type-example"></a>
## 自定义类型例子 / Custom type example

设想一个 `HTTP::Header` 类型，尽管它是一个具有特殊行为的自定义类，但可以像散列一样索引：

Imagine a `HTTP::Header` type which, despite being a custom class with special behavior, can be indexed like a hash:

```Raku
my $request = HTTP::Request.new(GET => "perl6.org");
say $request.header.^name;  # OUTPUT: «HTTP::Header␤» 
 
$request.header<Accept> = "text/plain";
$request.header{'Accept-' X~ <Charset Encoding Language>} = <utf-8 gzip en>;
$request.header.push('Accept-Language' => "fr");  # like .push on a Hash 
 
say $request.header<Accept-Language>.perl;  # OUTPUT: «["en", "fr"]␤» 
 
my $rawheader = $request.header.Str;  # stringify according to HTTP spec 
```

实现这个类的一个简单方法是给它一个类型为 [Hash](https://docs.raku.org/type/Hash) 的属性，并将所有与下标和迭代相关的功能委托给该属性（使用自定义类型约束以确保用户不会在其中插入任何非法的内容）：

A simple way to implement this class would be to give it an attribute of type [Hash](https://docs.raku.org/type/Hash), and delegate all subscripting and iterating related functionality to that attribute (using a custom type constraint to make sure users don't insert anything invalid into it):

```Raku
class HTTP::Header does Associative {
    subset StrOrArrayOfStr where Str | ( Array & {.all ~~ Str} );
 
    has %!fields of StrOrArrayOfStr
                 handles <AT-KEY EXISTS-KEY DELETE-KEY push
                          iterator list kv keys values>;
 
    method Str { #`[not shown, for brevity] }
}
```

但是，HTTP 头字段名应该是不区分大小写的（但仍首选骆驼式命名法）。我们可以通过将 `*-KEY` 和 `push` 方法从 `handles` 列表中取出元素，并像这样分别实现它们来实现这种情况：

However, HTTP header field names are supposed to be case-insensitive (and preferred in camel-case). We can accommodate this by taking the `*-KEY` and `push` methods out of the `handles` list, and implementing them separately like this:

```Raku
method AT-KEY     ($key) is rw { %!fields{normalize-key $key}        }
method EXISTS-KEY ($key)       { %!fields{normalize-key $key}:exists }
method DELETE-KEY ($key)       { %!fields{normalize-key $key}:delete }
method push(*@_) { #`[not shown, for brevity] }

sub normalize-key ($key) { $key.subst(/\w+/, *.tc, :g) }
```

注意 `%!fields` 返回一个合适的可读可写容器，我们的 `AT-KEY` 可以简单地传递给它。

Note that subscripting `%!fields` returns an appropriate rw container, which our `AT-KEY` can simply pass on.

但是，我们可能更喜欢对用户输入不那么严格，而是自己清理字段值。在这种情况下，我们可以删除 `%!fields` 上的 `StrOrArrayOfStr` 类型约束，并将我们的 `AT-KEY` 实现替换为一个返回自定义 `Proxy` 容器的实现，该容器负责净化赋值时的值：

However, we may prefer to be less strict about user input and instead take care of sanitizing the field values ourselves. In that case, we can remove the `StrOrArrayOfStr` type constraint on `%!fields`, and replace our `AT-KEY` implementation with one that returns a custom `Proxy` container which takes care of sanitizing values on assignment:

```Raku
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

请注意，将方法声明为 `multi`，并将其限制为 `:D` （已定义的调用者），可以确保未定义的情况被传递到 `Any` 提供的默认实现（涉及自动生动化）。

Note that declaring the method as `multi` and restricting it to `:D` (defined invocants) makes sure that the undefined case is passed through to the default implementation provided by `Any` (which is involved in auto-vivification).

<a id="实现位置下标的方法--methods-to-implement-for-positional-subscripting"></a>
## 实现位置下标的方法 / Methods to implement for positional subscripting

为了使通过[后环缀运算符 `[ ]`](https://docs.raku.org/routine/[%20]#postcircumfix_[_]) 进行的基于索引的下标能够适用于你的自定义类型，你应该至少实现 `elems`、`AT-POS` 和 `EXISTS-POS`-以及下面详细描述的可选的其他类型。

In order to make index-based subscripting via [`postcircumfix [ ]`](https://docs.raku.org/routine/[%20]#postcircumfix_[_]) work for your custom type, you should implement at least `elems`, `AT-POS` and `EXISTS-POS` - and optionally others as detailed below.

<a id="elems-方法--method-elems"></a>
### elems 方法 / method elems

```Raku
multi method elems(::?CLASS:D:)
```

应返回一个数字，指示对象中有多少可下标元素。可以由用户直接调用，也可以由[后环缀运算符 `[ ]`](https://docs.raku.org/routine/[%20]#postcircumfix_[_]) 从末尾索引元素时调用，如 `@foo[*-1]`。

Expected to return a number indicating how many subscriptable elements there are in the object. May be called by users directly, and is also called by [`postcircumfix [ \]`](https://docs.raku.org/routine/[%20]#postcircumfix_[_]) when indexing elements from the end, as in `@foo[*-1]`.

如果未实现，则你的类型将从 `Any` 继承默认实现，该 `Any` 始终为已定义的调用者返回 `1`，这很可能不是你想要的。因此，如果不能根据位置类型知道元素的数量，则添加一个 [fail](https://docs.raku.org/routine/fail) 或者 [die](https://docs.raku.org/routine/die) 实现，以避免安静地做错误的事情。

If not implemented, your type will inherit the default implementation from `Any` that always returns `1` for defined invocants - which is most likely not what you want. So if the number of elements cannot be known for your positional type, add an implementation that [fail](https://docs.raku.org/routine/fail)s or [die](https://docs.raku.org/routine/die)s, to avoid silently doing the wrong thing.

<a id="at-pos-方法--method-at-pos"></a>
### AT-POS 方法 / method AT-POS

```Raku
multi method AT-POS (::?CLASS:D: $index)
```

应返回位于 `$index` 位置的元素。这就是通常所说的[后环缀运算符 `[ ]`](https://docs.raku.org/routine/[%20]#postcircumfix_[_])。

Expected to return the element at position `$index`. This is what [`postcircumfix [ ]`](https://docs.raku.org/routine/[%20]#postcircumfix_[_]) normally calls.

如果你希望元素是可变的（就像它们是内置的 [Array](https://docs.raku.org/type/Array) 类型，那么你必须确保以单条目容器的形式返回，容器在读取时计算为元素值，并在赋值时更新它。（请记住使用 `return-rw` 或 `is rw` 例程特性来实现此功能；请参见[示例](https://docs.raku.org/language/subscripts#Custom_type_example)。）

If you want an element to be mutable (like they are for the built-in [Array](https://docs.raku.org/type/Array) type), you'll have to make sure to return it in the form of an item container that evaluates to the element's value when read, and updates it when assigned to. (Remember to use `return-rw` or the `is rw` routine trait to make that work; see the [example](https://docs.raku.org/language/subscripts#Custom_type_example).)

<a id="exists-pos-方法--method-exists-pos"></a>
### EXISTS-POS 方法 / method EXISTS-POS

```Raku
multi method EXISTS-POS (::?CLASS:D: $index)
```

预期返回一个 Bool，指示在位置 `$index` 是否有一个元素。这就是[后环缀运算符 `[ ]`](https://docs.raku.org/routine/[%20]#postcircumfix_[_]) 在调用如 `@foo[42]:exists` 时调用的内容。

Expected to return a Bool indicating whether or not there is an element at position `$index`. This is what [`postcircumfix [ ]`](https://docs.raku.org/routine/[%20]#postcircumfix_[_]) calls when invoked like `@foo[42]:exists`.

元素的“存在”意味着什么，取决于你的类型。

What "existence" of an element means, is up to your type.

如果你不实现这一点，你的类型将继承 `Any` 中的默认实现，它将返回索引 0 返回 True，并为任何其他索引返回 False - 这可能不是你想要的。因此，如果不能对你的类型进行元素存在性检查，那么添加一个会 [fail](https://docs.raku.org/routine/fail) 或 [die](https://docs.raku.org/routine/die) 的实现，以避免默默地做错误的事情。

If you don't implement this, your type will inherit the default implementation from `Any`, which returns True for 0 and False for any other index - which is probably not what you want. So if checking for element existence cannot be done for your type, add an implementation that [fail](https://docs.raku.org/routine/fail)s or [die](https://docs.raku.org/routine/die)s, to avoid silently doing the wrong thing.

<a id="delete-pos-方法--method-delete-pos"></a>
### DELETE-POS 方法 / method DELETE-POS

```Raku
multi method DELETE-POS (::?CLASS:D: $index)
```

预期将删除位置 `$index` 处的元素，并返回其所具有的值。这就是[后环缀运算符 `[ ]`](https://docs.raku.org/routine/[%20]#postcircumfix_[_]) 在调用如 `@foo[42]:delete` 时调用的内容。

Expected to delete the element at position `$index`, and return the value it had. This is what [`postcircumfix [ ]`](https://docs.raku.org/routine/[%20]#postcircumfix_[_]) calls when invoked like `@foo[42]:delete`.

元素的“删除”意味着什么，取决于你的类型。

What "deleting" an element means, is up to your type.

实现此方法是可选的；如果不实现，尝试从该类型的对象中删除元素的用户将得到适当的错误消息。

Implementing this method is optional; if you don't, users trying to delete elements from an object of this type will get an appropriate error message.

<a id="assign-pos-方法--method-assign-pos"></a>
### ASSIGN-POS 方法 / method ASSIGN-POS

```Raku
multi method ASSIGN-POS (::?CLASS:D: $index, $new)
```

期望将在位置 `$index` 的元素设置为 `$new`。实现这一点完全是可选的；如果不实现，则使用 `self.AT-POS($index) = $new` 替代，如果自己实现它，则应确保它具有相同的效果。

Expected to set the element at position `$index` to the value `$new`. Implementing this is entirely optional; if you don't, `self.AT-POS($index) = $new` is used instead, and if you do, you should make sure it has the same effect.

这意味着在性能优化中选择一个选项，因此 `@numbers[5] = "five"` 这样的简单赋值就可以运行，而不必调用 `AT-POS` （这需要创建和返回一个可能昂贵的容器对象）。

This is meant as an opt-in performance optimization, so that simple assignments like `@numbers[5] = "five"` can operate without having to call `AT-POS` (which would have to create and return a potentially expensive container object).

请注意，实现 `ASSIGN-POS` 并*不能*帮助你将 `AT-POS` 方法变成 `rw`，因为不太重要的赋值/修改（如 `@numbers[5]++`）仍将使用 `AT-POS`。

Note that implementing `ASSIGN-POS` does *not* relieve you from making `AT-POS` an `rw` method though, because less trivial assignments/modifications such as `@numbers[5]++` will still use `AT-POS`.

<a id="bind-pos-方法--method-bind-pos"></a>
### BIND-POS 方法 / method BIND-POS

```Raku
multi method BIND-POS (::?CLASS:D: $index, \new)
```

预期将值或容器 `new` 绑定到位置 `$index` 处的槽上，以替换任何自然在该位置找到的容器。这就是当你写这代码所调用的：

Expected to bind the value or container `new` to the slot at position `$index`, replacing any container that would be naturally found there. This is what is called when you write:

```Raku
my $x = 10;
@numbers[5] := $x;
```

泛型 [Array](https://docs.raku.org/type/Array) 类支持这一点，以允许构建复杂的链数据结构，但是对于更多特定域的类型，它可能没有意义，所以不要觉得必须实现它。如果不这样做，用户在尝试绑定到该类型对象的位置槽时将得到适当的错误消息。

The generic [Array](https://docs.raku.org/type/Array) class supports this in order to allow building complex linked data structures, but for more domain-specific types it may not make sense, so don't feel compelled to implement it. If you don't, users will get an appropriate error message when they try to bind to a positional slot of an object of this type.

<a id="store-方法--method-store"></a>
### STORE 方法 / method STORE

```Raku
method STORE (::?CLASS:D: \values, :$initialize)
```

只有当你希望支持此语法时，才应提供此方法：

This method should only be supplied if you want to support this syntax:

```Raku
my @a is Foo = 1,2,3;
```

它用于绑定你的 `Positional` 角色的实现。

Which is used for binding your implementation of the `Positional` role.

`STORE` 应接受用于（重新）初始化对象的值。当第一次在对象上调用方法时，可选的命名参数将包含一个 `True` 值。它应该会返回调用者。

`STORE` should accept the values to (re-)initialize the object with. The optional named parameter will contain a `True` value when the method is called on the object for the first time. It should return the invocant.

```Raku
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

这段代码考虑了 `$initialize` 的值，只有当我们第一次为使用 `is` 语法声明的变量赋值时， `$initialize` 才会被设置为 `True`。`STORE` 方法应该设置 `self` 变量，并在所有情况下返回它，包括在变量已经初始化时。

This code takes into account the value of `$initialize`, which is set to `True` only if we are assigning a value to a variable declared using the `is` syntax for the first time. The `STORE` method should set the `self` variable and return it in all cases, including when the variable has already been initialized.

<a id="实现关联下标的方法--methods-to-implement-for-associative-subscripting"></a>
## 实现关联下标的方法 / Methods to implement for associative subscripting

为了使基于键的下标通过[后环缀运算符 `{ }`](https://docs.raku.org/routine/%7B%20%7D#postcircumfix_{_}) 为你的自定义类型工作，你应该至少实现 `AT-KEY` 和 `EXISTS-KEY` - 和其他选项，详见下文。

In order to make key-based subscripting via [`postcircumfix { }`](https://docs.raku.org/routine/%7B%20%7D#postcircumfix_{_}) work for your custom type, you should implement at least `AT-KEY` and `EXISTS-KEY` - and optionally others as detailed below.

<a id="at-key-方法--method-at-key"></a>
### AT-KEY 方法 / method AT-KEY

```Raku
multi method AT-KEY (::?CLASS:D: $key)
```

预期将返回与 `$key` 相关的元素。这是[后环缀运算符 `{ }`](https://docs.raku.org/routine/%7B%20%7D#postcircumfix_{_}) 通常的调用方式。

Expected to return the element associated with `$key`. This is what [`postcircumfix { }`](https://docs.raku.org/routine/%7B%20%7D#postcircumfix_{_}) normally calls.

如果你希望一个元素是可变的（就像内置的 [Hash](https://docs.raku.org/type/Hash) 类型)那样），你必须确保以条目容器的形式返回它，该容器在读取时计算元素的值，并在给它赋值时更新它。(请记住使用 `return-rw` 或 `is rw` 常规特征来实现该功能；请参见[示例](https://docs.raku.org/language/subscripts#Custom_type_example)。

If you want an element to be mutable (like they are for the built-in [Hash](https://docs.raku.org/type/Hash) type), you'll have to make sure to return it in the form of an item container that evaluates to the element's value when read, and updates it when assigned to. (Remember to use `return-rw` or the `is rw` routine trait to make that work; see the [example](https://docs.raku.org/language/subscripts#Custom_type_example).)

另一方面，如果你希望你的集合是只读的，请直接返回非容器值。

On the other hand if you want your collection to be read-only, feel free to return non-container values directly.

<a id="exists-key-方法--method-exists-key"></a>
### EXISTS-KEY 方法 / method EXISTS-KEY

```Raku
multi method EXISTS-KEY (::?CLASS:D: $key)
```

预期返回一个 Bool，指示是否存在与 `$key` 相关的元素。这就是[后环缀运算符 `{ }`](https://docs.raku.org/routine/%7B%20%7D#postcircumfix_{_}) 在调用如 `%foo<aa>:exists` 时调用的内容。

Expected to return a Bool indicating whether or not there is an element associated with `$key`. This is what [`postcircumfix { }`](https://docs.raku.org/routine/%7B%20%7D#postcircumfix_{_}) calls when invoked like `%foo<aa>:exists`.

元素的“存在”意味着什么，取决于你的类型。

What "existence" of an element means, is up to your type.

如果不实现这一点，类型将继承 `Any` 的默认实现，`Any` 总是返回 False - 这可能不是你想要的结果。因此，如果不能对你的类型进行元素存在性检查，那么添加一个会 [fail](https://docs.raku.org/routine/fail) 或 [die](https://docs.raku.org/routine/die) 的实现，以避免默默地做错误的事情。

If you don't implement this, your type will inherit the default implementation from `Any`, which always returns False - which is probably not what you want. So if checking for element existence cannot be done for your type, add an implementation that [fail](https://docs.raku.org/routine/fail)s or [die](https://docs.raku.org/routine/die)s, to avoid silently doing the wrong thing.

<a id="delete-key-方法--method-delete-key"></a>
### DELETE-KEY 方法 / method DELETE-KEY

```Raku
multi method DELETE-KEY (::?CLASS:D: $key)
```

预期将删除与 `$key` 相关的元素，并返回其所具有的值。这就是[后环缀运算符 `{ }`](https://docs.raku.org/routine/%7B%20%7D#postcircumfix_{_}) 在调用如 `%foo<aa>:delete` 时调用的内容。

Expected to delete the element associated with `$key`, and return the value it had. This is what [`postcircumfix { }`](https://docs.raku.org/routine/%7B%20%7D#postcircumfix_{_}) calls when invoked like `%foo<aa>:delete`.

一个元素的“删除”意味着什么，取决于你的类型 - 尽管它通常应该导致 `EXISTS-KEY` 方法对那个键的返回值为 `False`。

What "deleting" an element means, is up to your type - though it should usually cause `EXISTS-KEY` to become `False` for that key.

实现此方法是可选的；如果不实现，尝试从该类型的对象中删除元素的用户将得到适当的错误消息。

Implementing this method is optional; if you don't, users trying to delete elements from an object of this type will get an appropriate error message.

<a id="assign-key-方法--method-assign-key"></a>
### ASSIGN-KEY 方法 / method ASSIGN-KEY

```Raku
multi method ASSIGN-KEY (::?CLASS:D: $key, $new)
```

期望将与 `$key` 关联的元素设置为 `$new`。实现这个完全是可选的；如果不实现，则使用 `self.AT-KEY($key) = $new` 替代，如果自己实现它，则应确保它具有相同的效果。

Expected to set the element associated with `$key` to the value `$new`. Implementing this is entirely optional; if you don't, `self.AT-KEY($key) = $new` is used instead, and if you do, you should make sure it has the same effect.

这意味着在性能优化中选择一个选项，因此 `%age<Claire> = 29` 这样的简单赋值就可以运行，而不必调用 `AT-KEY` （这需要创建和返回一个可能昂贵的容器对象）。

This is meant as an opt-in performance optimization, so that simple assignments `%age<Claire> = 29` can operate without having to call `AT-KEY` (which would have to create and return a potentially expensive container object).

请注意，实现 `ASSIGN-POS` 并*不能*帮助你将 `AT-KEY` 方法变成 `rw`，因为较少的琐碎赋值/修改（如 `%age<Claire>++`）仍将使用 `AT-KEY`。

Note that implementing `ASSIGN-KEY` does *not* relieve you from making `AT-KEY` an `rw` method though, because less trivial assignments/modifications such as `%age<Claire>++` will still use `AT-KEY`.

<a id="bind-key-方法--method-bind-key"></a>
### BIND-KEY 方法 / method BIND-KEY

```Raku
multi method BIND-KEY (::?CLASS:D: $key, \new)
```

预期将值或容器 `new` 绑定到与 `$key` 相关的槽上，以替换任何自然在该位置找到的容器。这就是当你写这代码所调用的：

Expected to bind the value or container `new` to the slot associated with `$key`, replacing any container that would be naturally found there. This is what is called when you write:

```Raku
my $x = 10;
%age<Claire> := $x;
```

泛型 [Hash](https://docs.raku.org/type/Hash) 类支持这一点，以允许构建复杂的链数据结构，但对于更多特定于域的类型，它可能没有意义，所以不必感到必须实现它。如果没有实现，则当用户试图绑定到此类型对象的关联插槽时，将获得适当的错误消息。

The generic [Hash](https://docs.raku.org/type/Hash) class supports this in order to allow building complex linked data structures, but for more domain-specific types it may not make sense, so don't feel compelled to implement it. If you don't, users will get an appropriate error message when they try to bind to an associative slot of an object of this type.

<a id="store-方法--method-store-1"></a>
### STORE 方法 / method STORE

```Raku
method STORE (::?CLASS:D: \values, :$initialize)
```

只有当你希望支持以下内容时，才应提供此方法：

This method should only be supplied if you want to support the:

```Raku
my %h is Foo = a => 42, b => 666;
```

绑定你的 `Associative` 角色的实现的语法。

syntax for binding your implementation of the `Associative` role.

应该接受用于（重新）初始化对象的值，该值可以由 `Pair` 组成，也可以由单独的键/值对组成。当第一次在对象上调用方法时，可选的命名参数将包含一个 `True` 值。应该返回调用者。

Should accept the values to (re-)initialize the object with, which either could consist of `Pair`s, or separate key/value pairs. The optional named parameter will contain a `True` value when the method is called on the object for the first time. Should return the invocant.
