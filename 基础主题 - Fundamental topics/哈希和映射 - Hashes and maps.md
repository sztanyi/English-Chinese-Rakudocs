原文：https://docs.raku.org/language/hashmap

# 哈希和映射 / Hashes and maps

使用关联数组/字典/哈希

Working with associative arrays/dictionaries/hashes

<!-- MarkdownTOC -->

- [关联角色和关联类 / The associative role and associative classes](#%E5%85%B3%E8%81%94%E8%A7%92%E8%89%B2%E5%92%8C%E5%85%B3%E8%81%94%E7%B1%BB--the-associative-role-and-associative-classes)
- [可变哈希和不变映射 / Mutable hashes and immutable maps](#%E5%8F%AF%E5%8F%98%E5%93%88%E5%B8%8C%E5%92%8C%E4%B8%8D%E5%8F%98%E6%98%A0%E5%B0%84--mutable-hashes-and-immutable-maps)
- [哈希赋值 / Hash assignment](#%E5%93%88%E5%B8%8C%E8%B5%8B%E5%80%BC--hash-assignment)
    - [哈希切片 / Hash slices](#%E5%93%88%E5%B8%8C%E5%88%87%E7%89%87--hash-slices)
    - [非字符串键（对象哈希） / Non-string keys \(object hash\)](#%E9%9D%9E%E5%AD%97%E7%AC%A6%E4%B8%B2%E9%94%AE%EF%BC%88%E5%AF%B9%E8%B1%A1%E5%93%88%E5%B8%8C%EF%BC%89--non-string-keys-object-hash)
    - [约束值类型 / Constraint value types](#%E7%BA%A6%E6%9D%9F%E5%80%BC%E7%B1%BB%E5%9E%8B--constraint-value-types)
- [在哈希键和值上遍历 / Looping over hash keys and values](#%E5%9C%A8%E5%93%88%E5%B8%8C%E9%94%AE%E5%92%8C%E5%80%BC%E4%B8%8A%E9%81%8D%E5%8E%86--looping-over-hash-keys-and-values)
    - [就地编辑值 / In place editing of values](#%E5%B0%B1%E5%9C%B0%E7%BC%96%E8%BE%91%E5%80%BC--in-place-editing-of-values)

<!-- /MarkdownTOC -->


<a id="%E5%85%B3%E8%81%94%E8%A7%92%E8%89%B2%E5%92%8C%E5%85%B3%E8%81%94%E7%B1%BB--the-associative-role-and-associative-classes"></a>
# 关联角色和关联类 / The associative role and associative classes

[Associative](https://docs.raku.org/type/Associative) 角色是哈希和映射以及其他类（如 [MixHash](https://docs.raku.org/type/MixHash)）的基础。它定义了将在关联类中使用的两种类型；默认情况下，你可以使用任何类型（只要是 [Any](https://docs.raku.org/type/Any) 的子类都可以）[作为键](https://docs.raku.org/language/hashmap#Non-string_keys_%28object_hash%29)（尽管它的键将会被强制转为字符串）和任何对象作为值。可以使用 `of` 和 `keyof` 方法访问这些类型。

The [Associative](https://docs.raku.org/type/Associative) role underlies hashes and maps, as well as other classes such as [MixHash](https://docs.raku.org/type/MixHash). It defines the two types that will be used in associative classes; by default, you can use anything (literally, since any class that subclasses [Any](https://docs.raku.org/type/Any) can be used) [as a key](https://docs.raku.org/language/hashmap#Non-string_keys_%28object_hash%29), although it will be coerced to a string, and any object as value. You can access these types using the `of` and `keyof` methods.

默认情况下，使用 `%` 标记声明的任何对象都将获得 Associative 角色，并且在默认情况下行为类似于哈希，但此角色将仅提供上述两种方法以及默认哈希行为。

By default, any object declared with the `%` sigil will get the Associative role, and will by default behave like a hash, but this role will only provide the two methods above, as well as the default Hash behavior.

```Raku
say (%).^name ; # OUTPUT: «Hash␤»
```

相反，如果没有 `Associative` 角色，则不能使用 `%` 标记，但由于此角色没有任何关联属性，因此必须重新定义[哈希下标运算符](https://docs.raku.org/language/operators#postcircumfix_%7B_%7D)的行为。要做到这一点，你需要覆盖以下几个功能：

Inversely, you cannot use the `%` sigil if the `Associative` role is not mixed in, but since this role does not have any associated properties, you will have to redefine the behavior of the [hash subscript operator](https://docs.raku.org/language/operators#postcircumfix_%7B_%7D). In order to do that, there are several functions you will have to override:

```Raku
class Logger does Associative[Cool,DateTime] {
    has %.store;
 
    method log( Cool $event ) {
        %.store{ DateTime.new( now ) } = $event;
    }
 
    multi method AT-KEY ( ::?CLASS:D: $key) {
        my @keys = %.store.keys.grep( /$key/ );
        %.store{ @keys };
    }
 
    multi method EXISTS-KEY (::?CLASS:D: $key) {
        %.store.keys.grep( /$key/ )??True!!False;
    }
 
    multi method DELETE-KEY (::?CLASS:D: $key) {
        X::Assignment::RO.new.throw;
    }
 
    multi method ASSIGN-KEY (::?CLASS:D: $key, $new) {
        X::Assignment::RO.new.throw;
    }
 
    multi method BIND-KEY (::?CLASS:D: $key, \new){
        X::Assignment::RO.new.throw;
    }
}
say Logger.of;                   # OUTPUT: «(Cool)» 
my %logger := Logger.new;
say %logger.of;                  # OUTPUT: «(Cool)» 
 
%logger.log( "Stuff" );
%logger.log( "More stuff");
 
say %logger<2018-05-26>;         # OUTPUT: «(More stuff Stuff)» 
say %logger<2018-04-22>:exists;  # OUTPUT: «False» 
```

在本例中，我们定义了一个具有关联语义的记录器，它将能够使用日期（或其中的一部分）作为键。由于我们将 `Associative` 参数化为这些特定类，`of` 将返回我们使用的值类型，在本例中为 `Cool`（我们只能记录列表或字符串）。混合 `Associative` 角色使其有权使用 `%` 标记；由于 `%` 标记变量默认为 `Hash` 类型，因此在定义中需要绑定。

In this case, we are defining a logger with Associative semantics that will be able to use dates (or a part of them) as keys. Since we are parameterizing `Associative` to those particular classes, `of` will return the value type we have used, `Cool` in this case (we can log lists or strings only). Mixing the `Associative` role gives it the right to use the `%` sigil; binding is needed in the definition since `%`-sigiled variables get by default the `Hash` type.

此日志将只追加，这就是为什么我们要转义关联数组隐喻，使用 `log` 方法向日志中添加新事件的原因。但是，一旦添加了它们，我们就可以按日期检索它们，或者检查它们是否存在。首先，我们必须重写 `AT-KEY` multi 方法，其后是 `EXIST-KEY` 方法。在最后两个语句中，我们演示了下标操作如何调用 `AT-KEY`，而 `:exists` 副词如何调用 `EXISTS-KEY`。

This log is going to be append-only, which is why we escape the associative array metaphor to use a `log` method to add new events to the log. Once they have been added, however, we can retrieve them by date or check if they exist. For the first we have to override the `AT-KEY` multi method, for the latter `EXIST-KEY`. In the last two statements, we show how the subscript operation invokes `AT-KEY`, while the `:exists` adverb invokes `EXISTS-KEY`.

我们重写了 `DELETE-KEY`、`ASSIGN-KEY` 和 `BIND-KEY`，但只引发了一个异常。尝试将值分配、删除或绑定到键将导致引发 `Cannot modify an immutable Str (value)` 异常。

We override `DELETE-KEY`, `ASSIGN-KEY` and `BIND-KEY`, but only to throw an exception. Attempting to assign, delete, or bind a value to a key will result in a `Cannot modify an immutable Str (value)` exception thrown.

将类关联起来提供了一种非常方便的方法，可以使用哈希来使用它们；可以在 [Cro](https://cro.services/docs/reference/cro-http-client#Setting_the_request_body) 中看到一个示例，它广泛地使用它来方便使用哈希来定义结构化的请求并表达其回应。

Making classes associative provides a very convenient way of using and working with them using hashes; an example can be seen in [Cro](https://cro.services/docs/reference/cro-http-client#Setting_the_request_body), which uses it extensively for the convenience of using hashes to define structured requests and express its response.

<a id="%E5%8F%AF%E5%8F%98%E5%93%88%E5%B8%8C%E5%92%8C%E4%B8%8D%E5%8F%98%E6%98%A0%E5%B0%84--mutable-hashes-and-immutable-maps"></a>
# 可变哈希和不变映射 / Mutable hashes and immutable maps

`Hash` 是从键到值的可变映射（在其他编程语言中称为*字典*、*哈希表*或*映射*）。这些值都是标量容器，这意味着你可以给它们赋值。[Map](https://docs.raku.org/type/Map) 是不可变的。一旦一个键与一个值配对，就不能更改此配对。

A `Hash` is a mutable mapping from keys to values (called *dictionary*, *hash table* or *map* in other programming languages). The values are all scalar containers, which means you can assign to them. [Map](https://docs.raku.org/type/Map)s are, on the other hand, immutable. Once a key has been paired with a value, this pairing cannot be changed.

映射和散列通常存储在带有 `%` 标记的变量中，用于表示它们是关联的。

Maps and hashes are usually stored in variables with the percent `%` sigil, which is used to indicate they are Associative.

哈希和映射元素由键通过 `{ }` 后环缀运算符访问：

Hash and map elements are accessed by key via the `{ }` postcircumfix operator:

```Raku
say %*ENV{'HOME', 'PATH'}.perl;
# OUTPUT: «("/home/camelia", "/usr/bin:/sbin:/bin")␤»
```

一般的[下标](https://docs.raku.org/language/subscripts)规则应用于为文本字符串列表提供快捷方式，可以使用字符串插值。

The general [Subscript](https://docs.raku.org/language/subscripts) rules apply providing shortcuts for lists of literal strings, with and without interpolation.

```Raku
my %h = oranges => 'round', bananas => 'bendy';
say %h<oranges bananas>;
# OUTPUT: «(round bendy)␤» 
 
my $fruit = 'bananas';
say %h«oranges "$fruit"»;
# OUTPUT: «(round bendy)␤»
```

你可以通过分配给未使用的键来添加新的对：

You can add new pairs simply by assigning to an unused key:

```Raku
my %h;
%h{'new key'} = 'new value';
```

<a id="%E5%93%88%E5%B8%8C%E8%B5%8B%E5%80%BC--hash-assignment"></a>
# 哈希赋值 / Hash assignment

将元素列表赋给散列变量首先清空该变量，然后迭代右侧的元素。如果一个元素是一个 [Pair](https://docs.raku.org/type/Pair)，那么它的键将作为一个新的哈希键，其值将作为该键的新哈希值。否则，该值被强制转换为 [Str](https://docs.raku.org/type/Str)并用作哈希键，而列表的下一个元素则作为相应的值。

Assigning a list of elements to a hash variable first empties the variable, and then iterates the elements of the right-hand side. If an element is a [Pair](https://docs.raku.org/type/Pair), its key is taken as a new hash key, and its value as the new hash value for that key. Otherwise the value is coerced to [Str](https://docs.raku.org/type/Str) and used as a hash key, while the next element of the list is taken as the corresponding value.

```Raku
my %h = 'a', 'b', c => 'd', 'e', 'f';
```

相当于

Same as

```Raku
my %h = a => 'b', c => 'd', e => 'f';
```

或者

or

```Raku
my %h = <a b c d e f>;
```

或者更甚

or even

```Raku
my %h = %( a => 'b', c => 'd', e => 'f' );
```

或者

or

```Raku
my %h = [ a => 'b', c => 'd', e => 'f' ]; # This format is NOT recommended. 
                                          # It cannot be a constant and there 
                                          # will be problems with nested hashes
```

或者

or

```Raku
my $h = { a => 'b', c => 'd', e => 'f'};
```

请注意，大括号仅在我们没有将其分配给 `%` 标记的变量的情况下使用；如果我们将其用于 `%` 标记的变量，我们将得到一个 `Potential difficulties:␤ Useless use of hash composer on right side of hash assignment; did you mean := instead?` 的错误。但是，正如此错误所指示的，只要使用绑定，就可以使用大括号：

Please note that curly braces are used only in the case that we are not assigning it to a `%`-sigiled variable; in case we use it for a `%`-sigiled variable we will get an `Potential difficulties:␤ Useless use of hash composer on right side of hash assignment; did you mean := instead?` error. As this error indicates, however, we can use curly braces as long as we use also binding:

```Raku
my %h := { a => 'b', c => 'd', e => 'f'};
say %h; # OUTPUT: «{a => b, c => d, e => f}␤»
```

嵌套哈希也可以使用相同的语法定义：

Nested hashes can also be defined using the same syntax:

```Raku
my %h =  e => f => 'g';
say %h<e><f>; # OUTPUT: «g␤»
```

但是，你在这里定义的是一个指向 [Pair](https://docs.raku.org/type/Pair) 的键，如果这是你想要的，并且你的嵌套哈希只有一个键，那么就可以了。但是 `%h<e>` 指向一个 `Pair` 时，将产生以下后果：

However, what you are defining here is a key pointing to a [Pair](https://docs.raku.org/type/Pair), which is fine if that is what you want and your nested hash has a single key. But `%h<e>` will point to a `Pair` which will have these consequences:

```Raku
my %h =  e => f => 'g';
%h<e><q> = 'k';
# OUTPUT: «Pair␤Cannot modify an immutable Str (Nil)␤  in block <unit>» 
```

但是，这将有效地定义嵌套哈希：

This, however, will effectively define a nested hash:

```Raku
my %h =  e => { f => 'g' };
say %h<e>.^name;  # OUTPUT: «Hash␤» 
say %h<e><f>;     # OUTPUT: «g␤»
```

如果在需要值的地方遇到 [Pair](https://docs.raku.org/type/Pair)，则将其用作哈希值：

If a [Pair](https://docs.raku.org/type/Pair) is encountered where a value is expected, it is used as a hash value:

```Raku
my %h = 'a', 'b' => 'c';
say %h<a>.^name;            # OUTPUT: «Pair␤» 
say %h<a>.key;              # OUTPUT: «b␤»
```

如果同一个键出现多次，则与最后出现的键关联的值将存储在哈希中：

If the same key appears more than once, the value associated with its last occurrence is stored in the hash:

```Raku
my %h = a => 1, a => 2;
say %h<a>;                  # OUTPUT: «2␤»
```

若要将哈希分配给不具有 `%` 符号的变量，可以使用 `%()` 哈希构造函数：

To assign a hash to a variable which does not have the `%` sigil, you may use the `%()` hash constructor:

```Raku
my $h = %( a => 1, b => 2 );
say $h.^name;               # OUTPUT: «Hash␤» 
say $h<a>;                  # OUTPUT: «1␤»
```

如果一个或多个值引用主题变量 `$_`，则分配的右侧将被解释为 [Block](https://docs.raku.org/type/Block)，而不是哈希：

If one or more values reference the topic variable, `$_`, the right-hand side of the assignment will be interpreted as a [Block](https://docs.raku.org/type/Block), not a Hash:

```Raku
my @people = [
    %( id => "1A", firstName => "Andy", lastName => "Adams" ),
    %( id => "2B", firstName => "Beth", lastName => "Burke" ),
    # ... 
];
 
sub lookup-user (Hash $h) { #`(Do something...) $h }
 
my @names = map {
    # 这会创建一个哈希 / While this creates a hash: 
    my  $query = { name => "$person<firstName> $person<lastName>" };
    say $query.^name;      # OUTPUT: «Hash␤» 
 
    # 这样做会创建一个代码块，因为多个 $_ 被使用 / Doing this will create a Block. Oh no! 
    my  $query2 = { name => "$_<firstName> $_<lastName>" };
    say $query2.^name;       # OUTPUT: «Block␤» 
    say $query2<name>;       # fails 
 
    CATCH { default { put .^name, ': ', .Str } };
    # OUTPUT: «X::AdHoc: Type Block does not support associative indexing.␤» 
    lookup-user($query);
    # Type check failed in binding $h; expected Hash but got Block 
}, @people;
```

如果使用了 `%()` 哈希构造函数，就可以避免这种情况。仅使用大括号创建块。

This would have been avoided if you had used the `%()` hash constructor. Only use curly braces for creating Blocks.

<a id="%E5%93%88%E5%B8%8C%E5%88%87%E7%89%87--hash-slices"></a>
## 哈希切片 / Hash slices

可以使用一个切片同时指定多个键。

You can assign to multiple keys at the same time with a slice.

```Raku
my %h; %h<a b c> = 2 xx *; %h.perl.say;  # OUTPUT: «{:a(2), :b(2), :c(2)}␤» 
my %h; %h<a b c> = ^3;     %h.perl.say;  # OUTPUT: «{:a(0), :b(1), :c(2)}␤»
```

<a id="%E9%9D%9E%E5%AD%97%E7%AC%A6%E4%B8%B2%E9%94%AE%EF%BC%88%E5%AF%B9%E8%B1%A1%E5%93%88%E5%B8%8C%EF%BC%89--non-string-keys-object-hash"></a>
## 非字符串键（对象哈希） / Non-string keys (object hash)

默认情况下，`{ }` 中的键被强制转换为字符串。要用非字符串键组成哈希，请使用冒号前缀：

By default keys in `{ }` are forced to strings. To compose a hash with non-string keys, use a colon prefix:

```Raku
my $when = :{ (now) => "Instant", (DateTime.now) => "DateTime" };
```

注意，当对象作为键时，你通常不能使用 `<...>` 构造进行键查找，因为它只创建字符串和 [allomorphs](https://docs.raku.org/language/glossary#index-entry-Allomorph)。使用 `{...}` 代替：

Note that with objects as keys, you often cannot use the `<...>` construct for key lookup, as it creates only strings and [allomorphs](https://docs.raku.org/language/glossary#index-entry-Allomorph). Use the `{...}` instead:

```Raku
:{  0  => 42 }<0>.say;   # Int    as key, IntStr in lookup; OUTPUT: «(Any)␤» 
:{  0  => 42 }{0}.say;   # Int    as key, Int    in lookup; OUTPUT: «42␤» 
:{ '0' => 42 }<0>.say;   # Str    as key, IntStr in lookup; OUTPUT: «(Any)␤» 
:{ '0' => 42 }{'0'}.say; # Str    as key, Str    in lookup; OUTPUT: «42␤» 
:{ <0> => 42 }<0>.say;   # IntStr as key, IntStr in lookup; OUTPUT: «42␤»
```

*小心*：Rakudo 的实现目前错误地将[相同的规则](https://docs.raku.org/routine/%7B%20%7D#%28Operators%29_term_%7B_%7D) 应用于 `:{ }` 和它在 `{ }` 中的应用一样，并且可以在某些情况下构造 [Block](https://docs.raku.org/type/Block)。为了避免这种情况，可以直接实例化参数化哈希。还支持 `%` 标记变量的参数化：

*Note*: Rakudo implementation currently erroneously applies [the same rules](https://docs.raku.org/routine/%7B%20%7D#%28Operators%29_term_%7B_%7D) for `:{ }` as it does for `{ }` and can construct a [Block](https://docs.raku.org/type/Block) in certain circumstances. To avoid that, you can instantiate a parameterized Hash directly. Parameterization of `%`-sigiled variables is also supported:

```Raku
my Num %foo1      = "0" => 0e0; # Str keys and Num values 
my     %foo2{Int} =  0  => "x"; # Int keys and Any values 
my Num %foo3{Int} =  0  => 0e0; # Int keys and Num values 
Hash[Num,Int].new: 0, 0e0;      # Int keys and Num values
```

现在，如果你想定义一个使用对象作为键的散列，而且对象不会被强制类型转换，那么对象散列就是你需要的。

Now if you want to define a hash to preserve the objects you are using as keys *as the **exact** objects you are providing to the hash to use as keys*, then object hashes are what you are looking for.

```Raku
my %intervals{Instant};
my $first-instant = now;
%intervals{ $first-instant } = "Our first milestone.";
sleep 1;
my $second-instant = now;
%intervals{ $second-instant } = "Logging this Instant for spurious raisins.";
for %intervals.sort -> (:$key, :$value) {
    state $last-instant //= $key;
    say "We noted '$value' at $key, with an interval of {$key - $last-instant}";
    $last-instant = $key;
}
```

此示例使用只接受类型为 [Instant](https://docs.raku.org/type/Instant) 的键的对象哈希来实现基本的、但类型安全的日志记录机制。我们使用一个命名的 [state](https://docs.raku.org/language/variables#The_state_declarator) 变量来跟踪前面的 `Instant`，以便提供一个间隔。

This example uses an object hash that only accepts keys of type [Instant](https://docs.raku.org/type/Instant) to implement a rudimentary, yet type-safe, logging mechanism. We utilize a named [state](https://docs.raku.org/language/variables#The_state_declarator) variable for keeping track of the previous `Instant` so that we can provide an interval.

对象散列的全部要点是将键作为对象保存在它们自身中。当前对象散列使用对象的 [WHICH](https://docs.raku.org/routine/WHICH) 方法，该方法为每个可变对象返回唯一标识符。这是对象标识操作符（[===](https://docs.raku.org/routine/===)）的基础。这里的顺序和容器真的很重要，因为 `.keys` 的顺序未定义，并且一个匿名列表与另一个列表使用 [===](https://docs.raku.org/routine/===) 比较时不会有相等的时候。

The whole point of object hashes is to keep keys as objects-in-themselves. Currently object hashes utilize the [WHICH](https://docs.raku.org/routine/WHICH) method of an object, which returns a unique identifier for every mutable object. This is the keystone upon which the object identity operator ([===](https://docs.raku.org/routine/===)) rests. Order and containers really matter here as the order of `.keys` is undefined and one anonymous list is never [===](https://docs.raku.org/routine/===) to another.

```Raku
my %intervals{Instant};
my $first-instant = now;
%intervals{ $first-instant } = "Our first milestone.";
sleep 1;
my $second-instant = now;
%intervals{ $second-instant } = "Logging this Instant for spurious raisins.";
say ($first-instant, $second-instant) ~~ %intervals.keys;       # OUTPUT: «False␤» 
say ($first-instant, $second-instant) ~~ %intervals.keys.sort;  # OUTPUT: «False␤» 
say ($first-instant, $second-instant) === %intervals.keys.sort; # OUTPUT: «False␤» 
say $first-instant === %intervals.keys.sort[0];                 # OUTPUT: «True␤» 
```

由于 `Instant` 定义了自己的比较方法，因此在我们的示例中，根据 [cmp](https://docs.raku.org/routine/cmp) 进行的排序将始终提供最早的即时对象作为它返回的 [List](https://docs.raku.org/type/List) 中的第一个元素。

Since `Instant` defines its own comparison methods, in our example a sort according to [cmp](https://docs.raku.org/routine/cmp) will always provide the earliest instant object as the first element in the [List](https://docs.raku.org/type/List) it returns.

如果你想接受哈希中的任何对象，可以使用 [Any](https://docs.raku.org/type/Any)！

If you would like to accept any object whatsoever in your hash, you can use [Any](https://docs.raku.org/type/Any)!

```Raku
my %h{Any};
%h{(now)} = "This is an Instant";
%h{(DateTime.now)} = "This is a DateTime, which is not an Instant";
%h{"completely different"} = "Monty Python references are neither DateTimes nor Instants";
```

有一种使用绑定的更简洁的语法。

There is a more concise syntax which uses binding.

```Raku
my %h := :{ (now) => "Instant", (DateTime.now) => "DateTime" };
```

绑定是必要的，因为对象散列是关于非常实在的、特定的对象的，这是绑定非常擅长跟踪的东西，但是关于哪个分配本身并不太重要。

The binding is necessary because an object hash is about very solid, specific objects, which is something that binding is great at keeping track of but about which assignment doesn't concern itself much.

自从 6.d 发布以来，[`Junction`s](https://docs.raku.org/type/Junction) 也可以用作哈希键。结果也将是与键同一类型的 `Junction`。

Since 6.d was released, [`Junction`s](https://docs.raku.org/type/Junction) can also be used as hash keys. The result will also be a `Junction` of the same type used as key.

```Raku
my %hash = %( a => 1, b => 2, c=> 3);
say %hash{"a"|"c"};   # OUTPUT: «any(1, 3)␤» 
say %hash{"b"^"c"};   # OUTPUT: «one(2, 3)␤» 
say %hash{"a" & "c"}; # OUTPUT: «all(1, 3)␤»
```

如果使用任何类型的 Junction 来定义键，它将具有将 `Junction` 的元素定义为单独键的相同效果：

If a Junction of any kind is used to define a key, it will have the same effect of defining elements of the `Junction` as separate keys:

```Raku
my %hash = %( "a"|"b" => 1, c => 2 );
say %hash{"b"|"c"};       # OUTPUT: «any(1, 2)␤» 
```

<a id="%E7%BA%A6%E6%9D%9F%E5%80%BC%E7%B1%BB%E5%9E%8B--constraint-value-types"></a>
## 约束值类型 / Constraint value types

在声明符和名称之间放置一个类型对象，以约束 `Hash` 的所有值的类型。

Place a type object in-between the declarator and the name to constrain the type of all values of a `Hash`.

```Raku
my Int %h;
put %h<Goku>   = 900;
 
try {
    %h<Vegeta> = "string";
    CATCH { when X::TypeCheck::Binding { .message.put } }
}
 
# OUTPUT: 
# 9001 
# Type check failed in assignment to %h; expected Int but got Str ("string")
```

你可以通过更易读的语法来实现这一点。

You can do the same by a more readable syntax.

```Raku
my %h of Int; # the same as my Int %h
```

如果要约束 `Hash` 的所有键的类型，请在变量名后面添加 `{Type}`。

If you want to constraint the type of all keys of a `Hash`, add `{Type}` following the name of variable.

```Raku
my %h{Int};
```

甚至把这两个约束放在一起。

Even put these two constraints together.

```Raku
my %h{Int} of Int;
put %h{21} = 42;
 
try {
    %h{0} = "String";
    CATCH { when X::TypeCheck::Binding { .message.put } }
}
 
try {
    %h<string> = 42;
    CATCH { when X::TypeCheck::Binding { .message.put } }
}
 
try {
    %h<string> = "String";
    CATCH { when X::TypeCheck::Binding { .message.put } }
}
 
# OUTPUT: 
# 42 
# Type check failed in binding to parameter 'assignval'; expected Int but got Str ("String") 
# Type check failed in binding to parameter 'key'; expected Int but got Str ("string") 
# Type check failed in binding to parameter 'key'; expected Int but got Str ("string")
```

<a id="%E5%9C%A8%E5%93%88%E5%B8%8C%E9%94%AE%E5%92%8C%E5%80%BC%E4%B8%8A%E9%81%8D%E5%8E%86--looping-over-hash-keys-and-values"></a>
# 在哈希键和值上遍历 / Looping over hash keys and values

处理哈希中元素的一个常见习惯用法是循环键和值，例如，

A common idiom for processing the elements in a hash is to loop over the keys and values, for instance,

```Raku
my %vowels = 'a' => 1, 'e' => 2, 'i' => 3, 'o' => 4, 'u' => 5;
for %vowels.kv -> $vowel, $index {
  "$vowel: $index".say;
}
```

给出与此类似的输出：

gives output similar to this:

```Raku
a: 1
e: 2
o: 4
u: 5
i: 3
```

其中，我们使用 `kv` 方法从散列中提取键及其各自的值，以便将这些值传递到循环中。

where we have used the `kv` method to extract the keys and their respective values from the hash, so that we can pass these values into the loop.

请注意，不能依赖键和值的打印顺序；对于同一程序的不同运行，哈希的元素并不总是以相同的方式存储在内存中。实际上，自 2018.05 版以来，每次调用的顺序都是不同的。有时人们希望处理排序后的元素，例如哈希的键。如果你想按字母顺序打印元音的列表，那么你可以写

Note that the order of the keys and values printed cannot be relied upon; the elements of a hash are not always stored the same way in memory for different runs of the same program. In fact, since version 2018.05, the order is guaranteed to be different in every invocation. Sometimes one wishes to process the elements sorted on, e.g., the keys of the hash. If one wishes to print the list of vowels in alphabetical order then one would write

```Raku
my %vowels = 'a' => 1, 'e' => 2, 'i' => 3, 'o' => 4, 'u' => 5;
for %vowels.sort(*.key)>>.kv -> ($vowel, $index) {
  "$vowel: $index".say;
}
```

这会打印出

which prints

```Raku
a: 1
e: 2
i: 3
o: 4
u: 5
```

按字母顺序排列。为了达到这个结果，我们按键对元音散列进行排序（`%vowels.sort(*.key)`），然后通过一元超级运算符 `>>` 向每个元素应用 `.kv` 方法来请求其键和值，从而生成键/值列表的[列表](https://docs.raku.org/type/List)。要提取键/值，需要将变量括在括号中。

in alphabetical order as desired. To achieve this result, we sorted the hash of vowels by key (`%vowels.sort(*.key)`) which we then ask for its keys and values by applying the `.kv` method to each element via the unary `>>` hyperoperator resulting in a [List](https://docs.raku.org/type/List) of key/value lists. To extract the key/value the variables thus need to be wrapped in parentheses.

An alternative solution is to flatten the resulting list. Then the key/value pairs can be accessed in the same way as with plain `.kv`:

```Raku
my %vowels = 'a' => 1, 'e' => 2, 'i' => 3, 'o' => 4, 'u' => 5;
for %vowels.sort(*.key)>>.kv.flat -> $vowel, $index {
  "$vowel: $index".say;
}
```

你还可以使用 [destructuring](https://docs.raku.org/type/Signature#Destructuring_arguments) 遍历 `Hash`。

You can also loop over a `Hash` using [destructuring](https://docs.raku.org/type/Signature#Destructuring_arguments).

<a id="%E5%B0%B1%E5%9C%B0%E7%BC%96%E8%BE%91%E5%80%BC--in-place-editing-of-values"></a>
## 就地编辑值 / In place editing of values

有时你可能希望在对哈希值进行迭代时修改这些值。

There may be times when you would like to modify the values of a hash while iterating over them.

```Raku
my %answers = illuminatus => 23, hitchhikers => 42;
# OUTPUT: «hitchhikers => 42, illuminatus => 23» 
for %answers.values -> $v { $v += 10 }; # Fails 
CATCH { default { put .^name, ': ', .Str } };
# OUTPUT: «X::AdHoc: Cannot assign to a readonly variable or a value␤»
```

这通常是通过如下发送键和值来完成的。

This is traditionally accomplished by sending both the key and the value as follows.

```Raku
my %answers = illuminatus => 23, hitchhikers => 42;
for %answers.kv -> $k,$v { %answers{$k} = $v + 10 };
```

但是，可以利用代码块的签名来指定要对值进行读写访问。

However, it is possible to leverage the signature of the block in order to specify that you would like read-write access to the values.

```Raku
my %answers = illuminatus => 23, hitchhikers => 42;
for %answers.values -> $v is rw { $v += 10 };
```

即使在对象散列的情况下，也不可能直接就地编辑散列键；但是，可以删除一个键并添加一个新的键/值对以获得相同的结果。例如，给定此哈希值：

It is not possible directly to do in-place editing of hash keys, even in the case of object hashes; however, a key can be deleted and a new key/value pair added to achieve the same results. For example, given this hash:

```Raku
my %h = a => 1, b => 2;
for %h.keys.sort -> $k {
    # use sort to ease output comparisons 
    print "$k => {%h{$k}}; ";
}
say ''; # OUTPUT: «a => 1; b => 2;»␤ 
```

用 'bb' 替换键 'b'，但保留 'b' 值作为新键的值：

replace key 'b' with 'bb' but retain 'b's value as the new key's value:

```Raku
for %h.keys -> $k {
    if $k eq 'b' {
        my $v = %h{$k};
        %h{$k}:delete;
        %h<bb> = $v;
    }
}
for %h.keys.sort -> $k {
    print "$k => {%h{$k}}; ";
}
say ''; # OUTPUT: «a => 1; bb => 2;»␤ 
```
