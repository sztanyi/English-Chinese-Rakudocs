原文：https://docs.raku.org/type/Signature

# Signature 类 / class Signature

参数列表模式

Parameter list pattern

```Perl6
class Signature { }
```

签名是对代码对象的[参数](https://docs.raku.org/type/parameter)列表的静态描述。也就是说，它描述了要调用代码或函数，需要传递什么和多少参数。

A signature is a static description of the [parameter](https://docs.raku.org/type/Parameter) list of a code object. That is, it describes what and how many arguments you need to pass to the code or function in order to call it.

向签名传递参数将包含在 [Capture](https://docs.raku.org/type/capture) 中的参数*绑定*到签名。

Passing arguments to a signature *binds* the arguments, contained in a [Capture](https://docs.raku.org/type/Capture), to the signature.

# 目录 / Table Of Contents

<!-- MarkdownTOC -->

- [签名字面量 / Signature literals](#%E7%AD%BE%E5%90%8D%E5%AD%97%E9%9D%A2%E9%87%8F--signature-literals)
    - [参数分隔符 / Parameter separators](#%E5%8F%82%E6%95%B0%E5%88%86%E9%9A%94%E7%AC%A6--parameter-separators)
    - [类型约束 / Type constraints](#%E7%B1%BB%E5%9E%8B%E7%BA%A6%E6%9D%9F--type-constraints)
        - [约束可选参数 / Constraining optional arguments](#%E7%BA%A6%E6%9D%9F%E5%8F%AF%E9%80%89%E5%8F%82%E6%95%B0--constraining-optional-arguments)
        - [约束 slurpy 参数 / Constraining slurpy arguments](#%E7%BA%A6%E6%9D%9F-slurpy-%E5%8F%82%E6%95%B0--constraining-slurpy-arguments)
        - [约束命名参数 / Constraining named arguments](#%E7%BA%A6%E6%9D%9F%E5%91%BD%E5%90%8D%E5%8F%82%E6%95%B0--constraining-named-arguments)
        - [约束参数的确定性 / Constraining argument definiteness](#%E7%BA%A6%E6%9D%9F%E5%8F%82%E6%95%B0%E7%9A%84%E7%A1%AE%E5%AE%9A%E6%80%A7--constraining-argument-definiteness)
        - [约束`可调用`签名 / Constraining signatures of `Callable`s](#%E7%BA%A6%E6%9D%9F%E5%8F%AF%E8%B0%83%E7%94%A8%E7%AD%BE%E5%90%8D--constraining-signatures-of-callables)
        - [约束返回值类型 / Constraining return types](#%E7%BA%A6%E6%9D%9F%E8%BF%94%E5%9B%9E%E5%80%BC%E7%B1%BB%E5%9E%8B--constraining-return-types)
            - [`-->`](#--)
            - [`returns`](#returns)
            - [`of`](#of)
            - [前缀（类似 C ）形式 / prefix\(C-like\) form](#%E5%89%8D%E7%BC%80%EF%BC%88%E7%B1%BB%E4%BC%BC-c-%EF%BC%89%E5%BD%A2%E5%BC%8F--prefixc-like-form)
        - [强制转换类型 / Coercion type](#%E5%BC%BA%E5%88%B6%E8%BD%AC%E6%8D%A2%E7%B1%BB%E5%9E%8B--coercion-type)
    - [slurpy（A.K.A。可变）参数 / Slurpy \(A.K.A. variadic\) parameters](#slurpy%EF%BC%88aka%E3%80%82%E5%8F%AF%E5%8F%98%EF%BC%89%E5%8F%82%E6%95%B0--slurpy-aka-variadic-parameters)
    - [slurpy 数组参数的类型 / Types of slurpy array parameters](#slurpy-%E6%95%B0%E7%BB%84%E5%8F%82%E6%95%B0%E7%9A%84%E7%B1%BB%E5%9E%8B--types-of-slurpy-array-parameters)
        - [展平的 slurpy 参数 / Flattened slurpy](#%E5%B1%95%E5%B9%B3%E7%9A%84-slurpy-%E5%8F%82%E6%95%B0--flattened-slurpy)
        - [不展平的 slurpy 参数 / Unflattened slurpy](#%E4%B8%8D%E5%B1%95%E5%B9%B3%E7%9A%84-slurpy-%E5%8F%82%E6%95%B0--unflattened-slurpy)
        - [单一 slurpy 参数规则 / Single argument rule slurpy](#%E5%8D%95%E4%B8%80-slurpy-%E5%8F%82%E6%95%B0%E8%A7%84%E5%88%99--single-argument-rule-slurpy)
    - [类型捕获 / Type captures](#%E7%B1%BB%E5%9E%8B%E6%8D%95%E8%8E%B7--type-captures)
    - [位置与命名参数 / Positional vs. named arguments](#%E4%BD%8D%E7%BD%AE%E4%B8%8E%E5%91%BD%E5%90%8D%E5%8F%82%E6%95%B0--positional-vs-named-arguments)
    - [参数别名 / Argument aliases](#%E5%8F%82%E6%95%B0%E5%88%AB%E5%90%8D--argument-aliases)
    - [可选和强制参数 / Optional and mandatory arguments](#%E5%8F%AF%E9%80%89%E5%92%8C%E5%BC%BA%E5%88%B6%E5%8F%82%E6%95%B0--optional-and-mandatory-arguments)
    - [动态变量 / Dynamic variables](#%E5%8A%A8%E6%80%81%E5%8F%98%E9%87%8F--dynamic-variables)
    - [解构参数 / Destructuring arguments](#%E8%A7%A3%E6%9E%84%E5%8F%82%E6%95%B0--destructuring-arguments)
    - [子签名 / Sub-signatures](#%E5%AD%90%E7%AD%BE%E5%90%8D--sub-signatures)
    - [长名 / Long names](#%E9%95%BF%E5%90%8D--long-names)
    - [捕获参数 / Capture parameters](#%E6%8D%95%E8%8E%B7%E5%8F%82%E6%95%B0--capture-parameters)
    - [参数特征和修饰符 / Parameter traits and modifiers](#%E5%8F%82%E6%95%B0%E7%89%B9%E5%BE%81%E5%92%8C%E4%BF%AE%E9%A5%B0%E7%AC%A6--parameter-traits-and-modifiers)
- [Signature 的方法 / Methods](#signature-%E7%9A%84%E6%96%B9%E6%B3%95--methods)
    - [方法 params / method params](#%E6%96%B9%E6%B3%95-params--method-params)
    - [方法 arity / method arity](#%E6%96%B9%E6%B3%95-arity--method-arity)
    - [方法 count / method count](#%E6%96%B9%E6%B3%95-count--method-count)
    - [方法 returns / method returns](#%E6%96%B9%E6%B3%95-returns--method-returns)
    - [方法 ACCEPTS / method ACCEPTS](#%E6%96%B9%E6%B3%95-accepts--method-accepts)
    - [方法 Capture / method Capture](#%E6%96%B9%E6%B3%95-capture--method-capture)
- [运行时创建签名对象\(6.d, 2019.01及以后\) / Runtime creation of Signature objects \(6.d, 2019.01 and later\)](#%E8%BF%90%E8%A1%8C%E6%97%B6%E5%88%9B%E5%BB%BA%E7%AD%BE%E5%90%8D%E5%AF%B9%E8%B1%A16d-201901%E5%8F%8A%E4%BB%A5%E5%90%8E--runtime-creation-of-signature-objects-6d-201901-and-later)
- [类型图 / Type Graph](#%E7%B1%BB%E5%9E%8B%E5%9B%BE--type-graph)

<!-- /MarkdownTOC -->


<a id="%E7%AD%BE%E5%90%8D%E5%AD%97%E9%9D%A2%E9%87%8F--signature-literals"></a>
# 签名字面量 / Signature literals

签名出现在[函数](https://docs.raku.org/type/Sub)和[方法](https://docs.raku.org/type/Method)名之后的括号里，在代码块中箭头 `->` 或者 `<->` 之后, 作为[变量声明符](https://docs.raku.org/language/variables#Variable_declarators_and_scope)如 [`my`](https://docs.raku.org/syntax/my) 的输入，或者以冒号开头的独立术语。

Signatures appear inside parentheses after [subroutine](https://docs.raku.org/type/Sub) and [method](https://docs.raku.org/type/Method) names, on blocks after a `-> `or `<-> `arrow, as the input to [variable declarators](https://docs.raku.org/language/variables#Variable_declarators_and_scope) like [`my`](https://docs.raku.org/syntax/my), or as a separate term starting with a colon.

```Perl6
sub f($x) { }
#    ^^^^ 函数 f 的签名 / Signature of sub f
my method x() { }
#          ^^ 方法的签名 / Signature of a method
my $s = sub (*@a) { }
#           ^^^^^ 匿名函数的签名 / Signature of an anonymous function
 
for <a b c> -> $x { }
#              ^^  代码块的签名 / Signature of a Block 
 
my ($a, @b) = 5, (6, 7, 8);
#  ^^^^^^^^ 变量声明符的签名 / Signature of a variable declarator 
 
my $sig = :($a, $b);
#          ^^^^^^^^ 独立的签名对象 / Standalone Signature object 
```

签名字面量可用于定义回调或闭包的签名。

Signature literals can be used to define the signature of a callback or a closure.

```Perl6
sub f(&c:(Int)) { }
sub will-work(Int) { }
sub won't-work(Str) { }
f(&will-work);
 
f(&won't-work);
CATCH { default { put .^name, ': ', .Str } };
# OUTPUT: «X::TypeCheck::Binding::Parameter: Constraint type check failed in binding to parameter '&c'␤» 
 
f(-> Int { 'this works too' } );
```

支持针对列表的智能匹配签名。

Smartmatching signatures against a List is supported.

```Perl6
my $sig = :(Int $i, Str $s);
say (10, 'answer') ~~ $sig;
# OUTPUT: «True␤» 
my $sub = sub ( Str $s, Int $i ) { return $s xx $i };
say $sub.signature ~~ :( Str, Int );
# OUTPUT: «True␤» 
given $sig {
    when :(Str, Int) { say 'mismatch' }
    when :($, $)     { say 'match' }
    default          { say 'no match' }
}
# OUTPUT: «match␤» 
```

它匹配第二个 `when` 子句，因为 `:($，$)` 表示带有两个标量，匿名参数的 `签名`，这是 `$sig` 的更通用版本。

It matches the second `when` clause since `:($, $)` represents a `Signature` with two scalar, anonymous, arguments, which is a more general version of `$sig`.

当对哈希进行智能匹配时，假定签名由哈希的键组成。

When smartmatching against a Hash, the signature is assumed to consist of the keys of the Hash.

```Perl6
my %h = left => 1, right => 2;
say %h ~~ :(:$left, :$right);
# OUTPUT: «True␤» 
```

<a id="%E5%8F%82%E6%95%B0%E5%88%86%E9%9A%94%E7%AC%A6--parameter-separators"></a>
## 参数分隔符 / Parameter separators

签名由零或者多个*参数*组成，由逗号分隔。

A signature consists of zero or more *parameters*, separated by commas.

```Perl6
my $sig = :($a, @b, %c);
sub add($a, $b) { $a + $b };
```

有一个例外，第一个参数后面可能跟一个分号而非逗号标记一个方法的调用。调用通常绑定到 [`self`](https://docs.raku.org/routine/self)，是用来调用方法的对象。

As an exception the first parameter may be followed by a colon instead of a comma to mark the invocant of a method. The invocant is the object that was used to call the method, which is usually bound to [`self`](https://docs.raku.org/routine/self). By specifying it in the signature, you can change the variable name it is bound to.

```Perl6
method ($a: @b, %c) {};       # first argument is the invocant 
 
class Foo {
    method whoami($me:) {
        "Well I'm class $me.^name(), of course!"
    }
}
say Foo.whoami; # OUTPUT: «Well I'm class Foo, of course!␤» 
```

<a id="%E7%B1%BB%E5%9E%8B%E7%BA%A6%E6%9D%9F--type-constraints"></a>
## 类型约束 / Type constraints

参数可以选择具有类型约束（默认为 [`Any`](https://docs.raku.org/type/Any)）。这些可用于限制函数输入。

Parameters can optionally have a type constraint (the default is [`Any`](https://docs.raku.org/type/Any)). These can be used to restrict the allowed input to a function.

```Perl6
my $sig = :(Int $a, Str $b);
```

类型约束可以有任意编译时定义的值。

Type constraints can have any compile-time defined value

```Perl6
subset Positive-integer of Int where * > 0;
sub divisors(Positive-integer $n) { $_ if $n %% $_ for 1..$n };
divisors 2.5;
# ERROR «Type check failed in binding to parameter '$n'; 
# expected Positive-integer but got Rat (2.5) $n)» 
divisors -3;
# ERROR: «Constraint type check failed in binding to parameter '$n'; 
# expected Positive-integer but got Int (-3)» 
```

请注意，在上面的代码中，类型约束在两个不同的级别强制执行：第一级检查它是否属于子集所基于的类型，在本例中为 `Int`。如果失败，则产生 `Type check` 错误。清除该过滤器后，将检查定义子集的约束，如果失败则产生 `Constraint type check` 错误。

Please note that in the code above type constraints are enforced at two different levels: the first level checks if it belongs to the type in which the subset is based, in this case `Int`. If it fails, a `Type check` error is produced. Once that filter is cleared, the constraint that defined the subset is checked, producing a `Constraint type check` error if it fails.

使用匿名参数也可以，如果你实际上不需要按名称引用参数，例如区分 [multi](https://docs.raku.org/language/functions#index- entry-declarator_multi-Multi-dispatch) 中的不同签名或检查 [Callable](https://docs.raku.org/type/Callable) 的签名。

Anonymous arguments are fine too, if you don't actually need to refer to a parameter by name, for instance to distinguish between different signatures in a [multi](https://docs.raku.org/language/functions#index-entry-declarator_multi-Multi-dispatch) or to check the signature of a [Callable](https://docs.raku.org/type/Callable).

```Perl6
my $sig = :($, @, %a);          # two anonymous and a "normal" parameter 
$sig = :(Int, Positional);      # just a type is also fine (two parameters) 
sub baz(Str) { "Got passed a Str" }
```

类型约束也可以是[类型捕获](https://docs.raku.org/type/Signature#Type_captures)。

Type constraints may also be [type captures](https://docs.raku.org/type/Signature#Type_captures).

除了那些*名义上*的类型之外，还可以以代码块的形式对参数进行附加约束，这些代码块必须返回真值才能通过类型检查

In addition to those *nominal* types, additional constraints can be placed on parameters in the form of code blocks which must return a true value to pass the type check

```Perl6
sub f(Real $x where { $x > 0 }, Real $y where { $y >= $x }) { }
```

`where` 子句中的代码有一些限制：不支持产生副作用的任何东西（例如打印输出，从迭代器中取值或状态变量增值），如果使用，可能会产生令人惊讶的结果。此外，在某些实现中，对于单个类型检查，`where` 子句的代码可能会运行多次。

The code in `where` clauses has some limitations: anything that produces side-effects (e.g. printing output, pulling from an iterator, or increasing a state variable) is not supported and may produce surprising results if used. Also, the code of the `where` clause may run more than once for a single typecheck in some implementations.

`where` 子句不限于代码块，`where` 子句右边的任何东西都会被参数做[智能匹配](https://docs.raku.org/language/operators#infix_~~)。因此你也可以这样写：

The `where` clause doesn't need to be a code block, anything on the right of the `where`-clause will be used to [smartmatch](https://docs.raku.org/language/operators#infix_~~) the argument against it. So you can also write:

```Perl6
multi factorial(Int $ where 0) { 1 }
multi factorial(Int $x)        { $x * factorial($x - 1) }
```

第一个语句可以简写为

The first of those can be shortened to

```Perl6
multi factorial(0) { 1 }
```

也就是说，你可以对匿名参数直接使用字面值作为一个类型和值的约束。

i.e., you can use a literal directly as a type and value constraint on an anonymous parameter.

**提示:** 注意，当由多个条件时，要使用代码块：

**Tip:** pay attention to not accidentally leave off a block when you, say, have several conditions:

```Perl6
-> $y where   .so && .name    {}( sub one   {} ); # WRONG!! 
-> $y where { .so && .name }  {}( sub two   {} ); # OK! 
-> $y where   .so &  .name.so {}( sub three {} ); # Also good 
```
第一个版本是错误的，运行的话会抛出函数对象强制转化为为字符串的警告。原因是表达式相当于 `($y ~~ ($y.so && $y.name))`; 它会先调用方法 `.so` ，如果执行结果为`真`，则接着调用方法 `.name`，如果执行结果仍为`真`，使用它的值做智能匹配。。。。`(.so && .name)` 的运算结果被智能匹配了，但是我们想要检查 `.so` 和 `.name` 是否都为真值。这就是为什么明确的代码块或者 [Junction](https://docs.raku.org/type/Junction) 是正确的版本。

The first version is wrong and will issue a warning about sub object coerced to string. The reason is the expression is equivalent to `($y ~~ ($y.so && $y.name))`; that is "call `.so`, and if that is `True`, call `.name`; if that is also `True` use its value for smartmatching…". It's the **result** of `(.so && .name)` is will be smartmatched against, but we want to check that both `.so` and `.name` are truthy values. That is why an explicit Block or a [Junction](https://docs.raku.org/type/Junction) is the right version.

所有以前不属于`签名`中的子签名的参数都可以在参数后面的 `where` 子句中被访问。因此，最后一个参数的 `where` 子句可以访问不属于子签名的签名的所有参数。对于子签名，在子签名内放置 `where` 子句。

All previous arguments that are not part of a sub-signature in a `Signature` are accessible in a `where`-clause that follows an argument. Therefore, the `where`-clause of the last argument has access to all arguments of a signature that are not part of a sub-signature. For a sub-signature place the `where`-clause inside the sub-signature.

```Perl6
sub foo($a, $b where * == $a ** 2) { say "$b is a square of $a" }
foo 2, 4; # OUTPUT: «4 is a square of 2␤»» 
# foo 2, 3; 
# OUTPUT: «Constraint type check failed in binding to parameter '$b'…» 
```

<a id="%E7%BA%A6%E6%9D%9F%E5%8F%AF%E9%80%89%E5%8F%82%E6%95%B0--constraining-optional-arguments"></a>
### 约束可选参数 / Constraining optional arguments

[可选参数](https://docs.raku.org/type/Signature#Optional_and_mandatory_arguments)也可以有约束。任何参数的任一 `where` 子句都将会被执行，即使它是可选的并且不由调用者提供。那种情况下你需要防止 `where` 子句中未定义的值。

can have constraints, too. Any `where` clause on any parameter will be executed, even if it's optional and not provided by the caller. In that case you may have to guard against undefined values within the `where` clause.

[Optional arguments](https://docs.raku.org/type/Signature#Optional_and_mandatory_arguments) can have constraints, too. Any `where` clause on any parameter will be executed, even if it's optional and not provided by the caller. In that case you may have to guard against undefined values within the `where` clause.

```Perl6
sub f(Int $a, UInt $i? where { !$i.defined or $i > 5 }) { ... }
```

<a id="%E7%BA%A6%E6%9D%9F-slurpy-%E5%8F%82%E6%95%B0--constraining-slurpy-arguments"></a>
### 约束 slurpy 参数 / Constraining slurpy arguments

[Slurpy 参数](https://docs.raku.org/type/Signature#Slurpy_%28A.K.A._variadic%29_parameters)不能有类型约束。可以使用 `where` 子句和 [Junction](https://docs.raku.org/type/Junction) 来实现该效果。

[Slurpy arguments](https://docs.raku.org/type/Signature#Slurpy_%28A.K.A._variadic%29_parameters) can not have type constraints. A `where`-clause in conjunction with a [Junction](https://docs.raku.org/type/Junction) can be used to that effect.

```Perl6
sub f(*@a where {$_.all ~~ Int}) { say @a };
f(42);
f(<a>);
CATCH { default { say .^name, ' ==> ', .Str }  }
# OUTPUT: «[42]␤Constraint type check failed in binding to parameter '@a' ...» 
```

<a id="%E7%BA%A6%E6%9D%9F%E5%91%BD%E5%90%8D%E5%8F%82%E6%95%B0--constraining-named-arguments"></a>
### 约束命名参数 / Constraining named arguments

对[命名参数](https://docs.raku.org/type/Signature#Positional_vs._named_arguments)的约束适用于[冒号对](https://docs.raku.org/type/Pair)的值部分。

Constraints against [Named arguments](https://docs.raku.org/type/Signature#Positional_vs._named_arguments) apply to the value part of the [colon-pair](https://docs.raku.org/type/Pair).

```Perl6
sub f(Int :$i){};
f :i<forty-two>;
CATCH { default { say .^name, ' ==> ', .Str }  }
# OUTPUT: «X::TypeCheck::Binding::Parameter ==> Type check failed in 
# binding to parameter '$i'; expected Int but got Str ("forty-two")␤» 
```

<a id="%E7%BA%A6%E6%9D%9F%E5%8F%82%E6%95%B0%E7%9A%84%E7%A1%AE%E5%AE%9A%E6%80%A7--constraining-argument-definiteness"></a>
### 约束参数的确定性 / Constraining argument definiteness

通常，类型约束仅检查参数的值是否为正确的类型。至关重要的是，*对象实例*和*类型对象*都将满足如下所示的约束：

Normally, a type constraint only checks whether the value of the parameter is of the correct type. Crucially, both *object instances* and *type objects* will satisfy such a constraint as illustrated below:

```Perl6
say  42.^name;    # OUTPUT: «Int␤» 
say  42 ~~ Int;   # OUTPUT: «True␤» 
say Int ~~ Int;   # OUTPUT: «True␤» 
```

注意 `42` 和 `Int` 是如何满足匹配的。

Note how both `42` and `Int` satisfy the match.

有时我们需要区分这些对象实例（`42`）和类型对象（`Int`）。考虑以下代码：

Sometimes we need to distinguish between these object instances (`42`) and type objects (`Int`). Consider the following code:

```Perl6
sub limit-lines(Str $s, Int $limit) {
    my @lines = $s.lines;
    @lines[0 .. min @lines.elems, $limit].join("\n")
}
say (limit-lines "a \n b \n c \n d \n", 3).perl; # "a \n b \n c \n d " 
say limit-lines Str, 3;
CATCH { default { put .^name, ': ', .Str } };
# OUTPUT: «X::Multi::NoMatch: Cannot resolve caller lines(Str: ); 
# none of these signatures match: 
#     (Str:D $: :$count!, *%_) 
#     (Str:D $: $limit, *%_) 
#     (Str:D $: *%_)» 
say limit-lines "a \n b", Int; # Always returns the max number of lines 
```

在这里，我们其实只想处理字符串实例，而不是类型对象。为此，我们可以使用 `:D` 类型约束。此约束以与调用其 [DEFINITE](https://docs.raku.org/language/mop#DEFINITE) 元方法类似的方式检查传递的值是否为*对象实例*。

Here we really only want to deal with string instances, not type objects. To do this, we can use the `:D` type constraint. This constraint checks that the value passed is an *object instance*, in a similar fashion to calling its [DEFINITE](https://docs.raku.org/language/mop#DEFINITE) (meta)method.

热个身，让我们将 `:D` 应用到我们简陋的 `Int` 示例的右侧：

To warm up, let's apply `:D` to the right-hand side of our humble `Int` example:

```Perl6
say  42 ~~ Int:D;  # OUTPUT: «True␤» 
say Int ~~ Int:D;  # OUTPUT: «False␤» 
```

注意上面只有 `42` 匹配 `Int:D`。

Note how only `42` matches `Int:D` in the above.

回到 `limit-lines`，我们现在可以修改它的签名以便及早收到错误：

Returning to `limit-lines`, we can now amend its signature to catch the error early:

```Perl6
sub limit-lines(Str:D $s, Int $limit) { };
say limit-lines Str, 3;
CATCH { default { put .^name ~ '--' ~ .Str } };
# OUTPUT: «Parameter '$s' of routine 'limit-lines' must be an object instance of type 'Str', 
#          not a type object of type 'Str'.  Did you forget a '.new'?» 
```

这个比之前的编码方式好得多，因为失败的原因更清晰。

This is much better than the way the program failed before, since here the reason for failure is clearer.

也有可能*类型对象*是唯一对例程接受有意义的对象。这可以使用 `:U` 类型约束来完成，该约束检查传递的值是否是类型对象而不是对象实例。这又是我们的 `Int` 例子，不过这次使用 `:U`：

It's also possible that *type objects* are the only ones that make sense for a routine to accept. This can be done with the `:U`type constraint, which checks whether the value passed is a type object rather than an object instance. Here's our `Int`example again, this time with `:U` applied:

```Perl6
say  42 ~~ Int:U;  # OUTPUT: «False␤» 
say Int ~~ Int:U;  # OUTPUT: «True␤» 
```

现在 `42` 匹配失败而 `Int` 匹配成功。

Now `42` fails to match `Int:U` while `Int` succeeds.

这里有一个更实用的例子：

Here's a more practical example:

```Perl6
sub can-turn-into(Str $string, Any:U $type) {
   return so $string.$type;
}
say can-turn-into("3", Int);        # OUTPUT: «True␤» 
say can-turn-into("6.5", Int);      # OUTPUT: «True␤» 
say can-turn-into("6.5", Num);      # OUTPUT: «True␤» 
say can-turn-into("a string", Num); # OUTPUT: «False␤» 
```

使用对象实例作为其第二个参数调用 `can-turn-into` 将按预期产生约束违规：

Calling `can-turn-into` with an object instance as its second parameter will yield a constraint violation as intended:

```Perl6
say can-turn-into("a string", 123);
# OUTPUT: «Parameter '$type' of routine 'can-turn-into' must be a type object 
# of type 'Any', not an object instance of type 'Int'...» 
```

为了明确指出正常行为，即不限制参数是实例还是类型对象，可以使用 `:_`，但这是不必要的。 `:(Num:_ $)` 与 `:(Num $)` 相同。

For explicitly indicating the normal behavior, that is, not constraining whether the argument will be an instance or a type object, `:_` can be used, but this is unnecessary. `:(Num:_ $)` is the same as `:(Num $)`.

回顾一下，这里是这些类型约束的快速说明，也称为*表情符号类型*：

To recap, here is a quick illustration of these type constraints, also known collectively as *type smileys*:

```Perl6
# Checking a type object 
say Int ~~ Any:D;    # OUTPUT: «False␤» 
say Int ~~ Any:U;    # OUTPUT: «True␤» 
say Int ~~ Any:_;    # OUTPUT: «True␤» 
 
# Checking an object instance 
say 42 ~~ Any:D;     # OUTPUT: «True␤» 
say 42 ~~ Any:U;     # OUTPUT: «False␤» 
say 42 ~~ Any:_;     # OUTPUT: «True␤» 
 
# Checking a user-supplied class 
class Foo {};
say Foo ~~ Any:D;    # OUTPUT: «False␤» 
say Foo ~~ Any:U;    # OUTPUT: «True␤» 
say Foo ~~ Any:_;    # OUTPUT: «True␤» 
 
# Checking an instance of a class 
my $f = Foo.new;
say $f  ~~ Any:D;    # OUTPUT: «True␤» 
say $f  ~~ Any:U;    # OUTPUT: «False␤» 
say $f  ~~ Any:_;    # OUTPUT: «True␤» 
```

[类和对象](https://docs.raku.org/language/classtut#Starting_with_class)文档进一步阐述了实例和类型对象的概念，并使用 `.DEFINITE` 方法发现它们。

The [Classes and Objects](https://docs.raku.org/language/classtut#Starting_with_class) document further elaborates on the concepts of instances and type objects and discovering them with the `.DEFINITE` method.

请记住所有参数都有值;即使是可选参数也有默认默认值，他们是显式类型约束的约束类型的类型对象。如果不存在显式类型约束，则默认默认值为方法，子方法和子例程的 [Any](https://docs.raku.org/type/Any) 类型对象，以及 [Mu](https://docs.raku.org/type/Mu) 为块输入对象。这意味着如果使用 `:D` 类型表情符号，则需要提供默认值或使参数成为必需参数。否则，默认默认值为类型对象，这将使定义约束失败。

Keep in mind all parameters have values; even optional ones have default defaults that are the type object of the constrained type for explicit type constraints. If no explicit type constraint exists, the default default is an [Any](https://docs.raku.org/type/Any) type object for methods, submethods, and subroutines, and a [Mu](https://docs.raku.org/type/Mu) type object for blocks. This means that if you use the `:D` type smiley, you'd need to provide a default value or make the parameter required. Otherwise, the default default would be a type object, which would fail the definiteness constraint.

```Perl6
sub divide (Int:D :$a = 2, Int:D :$b!) { say $a/$b }
divide :1a, :2b; # OUTPUT: «0.5␤» 
```

当特定参数（位置或命名）获取不到任何值时，将使用默认值。

The default value will kick in when that particular parameter, either positional or named, gets no value *at all*.

```Perl6
sub f($a = 42){
  my $b is default('answer');
  say $a;
  $b = $a;
  say $b
};
f;     # OUTPUT: «42␤42␤» 
f Nil; # OUTPUT: «Nil␤answer␤» 
```

`$a` 的默认值为 42。没有赋值时，`$a` 将被赋予签名中声明的默认值。但是，在第二种情况下，确实会收到一个值，恰好是 `Nil`。将 `Nil` 分配给任何变量会将其重置为其默认值，该值已被声明为 `'answer'`。这解释了第二次调用 `f` 会发生什么。例程参数和变量处理默认值的方式不同，这部分地通过在每种情况下声明默认值的不同方式来澄清（参数使用 `=`，变量使用 `default` 特性）。

`$a` has 42 as default value. With no value, `$a` will be assigned the default declared in the Signature. However, in the second case, it *does* receive a value, which happens to be `Nil`. Assigning `Nil` to any variable resets it to its default value, which has been declared as `'answer'`. That explains what happens the second time we call `f`. Routine parameters and variables deal differently with default value, which is in part clarified by the different way default values are declared in each case (using `=`for parameters, using the `default` trait for variables).

注意：在 6.c 中，默认 `:U`/`:D` 约束的变量，其默认值是一个带有这种约束的类型对象，它是不可初始化的，因此你不能使用 `.=` 运算符，例如。

Note: in 6.c language, the default default of `:U`/`:D` constrained variables was a type object with such a constraint, which is not initializable, thus you cannot use the `.=` operator, for example.

```Perl6
use v6.c;
my Int:D $x .= new: 42;
# OUTPUT: You cannot create an instance of this type (Int:D) 
# in block <unit> at -e line 1 
```

在 6.d 中，默认默认值是没有类型表情符号约束的​​类型对象：

In the 6.d language, the default default is the type object without the smiley constraint:

```Perl6
use v6.d;
my Int:D $x .= new: 42; # OUTPUT: «42␤» 
```

关于术语的结束语：本节是关于使用类型表情符号 `:D` 和 `:U` 来约束参数的确定性。偶尔*定义*可以用作*定性*的同义词;这可能令人困惑，因为这些术语的含义略有不同。

A closing remark on terminology: this section is about the use of the type smileys `:D` and `:U` to constrain the definiteness of arguments. Occasionally *definedness* is used as a synonym for *definiteness*; this may be confusing, since the terms have subtly different meanings.

如上所述，*明确性*涉及类型对象和对象实例之间的区别。类型对象总是不确定的，而对象实例总是明确的。可以使用 [DEFINITE](https://docs.raku.org/language/mop#DEFINITE)（元）方法验证对象是类型对象还是对象实例。

As explained above, *definiteness* is concerned with the distinction between type objects and object instances. A type object is always indefinite, while an object instance is always definite. Whether an object is a type object/indefinite or an object instance/definite can be verified using the [DEFINITE](https://docs.raku.org/language/mop#DEFINITE) (meta)method.

*确定性*应与*定义性*区分开来，*定义性*与定义和未定义对象之间的区别有关。可以使用 `defined` 方法验证对象是定义的还是未定义的，该方法在类 [Mu](https://docs.raku.org/type/Mu) 中实现。默认情况下，类型对象被视为未定义，而对象实例被视为已定义;即：`.defined` 在类型对象上返回`假值`，否则返回 `真值`。但是这个默认行为可能会被子类覆盖。覆盖默认 `.defined` 行为的子类的示例是 [Failure](https://docs.raku.org/type/Failure)，因此即使实例化的 `Failure` 也可以作为未定义的值：

*Definiteness* should be distinguished from *definedness*, which is concerned with the difference between defined and undefined objects. Whether an object is defined or undefined can be verified using the `defined`-method, which is implemented in class [Mu](https://docs.raku.org/type/Mu). By default a type object is considered undefined, while an object instance is considered defined; that is: `.defined` returns `False` on a type object, and `True` otherwise. But this default behavior may be overridden by subclasses. An example of a subclass that overrides the default `.defined` behavior is [Failure](https://docs.raku.org/type/Failure), so that even an instantiated `Failure` acts as an undefined value:

```Perl6
my $a = Failure;                # Initialize with type object 
my $b = Failure.new("foo");     # Initialize with object instance 
say $a.DEFINITE;                # Output: «False␤» : indefinite type object 
say $b.DEFINITE;                # Output: «True␤»  : definite object instance 
say $a.defined;                 # Output: «False␤» : default response 
say $b.defined;                 # Output: «False␤» : .defined override 
```

<a id="%E7%BA%A6%E6%9D%9F%E5%8F%AF%E8%B0%83%E7%94%A8%E7%AD%BE%E5%90%8D--constraining-signatures-of-callables"></a>
### 约束`可调用`签名 / Constraining signatures of `Callable`s

可以在参数之后紧跟[签名](https://docs.raku.org/type/Signature)（不允许空格）来约束 [Callable](https://docs.raku.org/type/Callable) 参数：

The signature of a [Callable](https://docs.raku.org/type/Callable) parameter can be constrained by specifying a [Signature](https://docs.raku.org/type/Signature) literal right after the parameter (no whitespace allowed):

```Perl6
sub f(&c:(Int, Str))  { say c(10, 'ten') };
sub g(Int $i, Str $s) { $s ~ $i };
f(&g);
# OUTPUT: «ten10␤» 
```

此速记语法仅适用于带有 `&` 标记的参数。对于其他参数，你需要使用长版本：

This shorthand syntax is available only for parameters with the `&` sigil. For others, you need to use the long version:

```Perl6
sub f($c where .signature ~~ :(Int, Str))  { say $c(10, 'ten') }
sub g(Num $i, Str $s) { $s ~ $i }
sub h(Int $i, Str $s) { $s ~ $i }
# f(&g); # Constraint type check failed 
f(&h);   # OUTPUT: «ten10␤» 
```

<a id="%E7%BA%A6%E6%9D%9F%E8%BF%94%E5%9B%9E%E5%80%BC%E7%B1%BB%E5%9E%8B--constraining-return-types"></a>
### 约束返回值类型 / Constraining return types

有多种方式限制一个[例程](https://docs.raku.org/type/Routine)的返回值类型。下面所有的版本都是合法的并且会强制类型检查，当例程成功执行的时候。

There are multiple ways to constrain return types on a [Routine](https://docs.raku.org/type/Routine). All versions below are currently valid and will force a type check on successful execution of a routine.

[`Nil`](https://docs.raku.org/type/Nil) 和 [`Failure`](https://docs.raku.org/type/Failure) 作为返回值类型总是允许的，不受任何类型约束限制。这允许返回 [Failure](https://docs.raku.org/type/Failure) 并在调用链中传递。

[`Nil`](https://docs.raku.org/type/Nil) and [`Failure`](https://docs.raku.org/type/Failure) are always allowed as return types, regardless of any type constraint. This allows [Failure](https://docs.raku.org/type/Failure) to be returned and passed on down the call chain.

```Perl6
sub foo(--> Int) { Nil };
say foo.perl; # OUTPUT: «Nil␤» 
```

不支持类型捕获。

Type captures are not supported.

<a id="--"></a>
#### `-->`

由于以下几个原因，这种形式是首选的：（1）它可以处理常量，而其他形式则不能; （2）为保持一致性，这是本站接受的唯一形式;

This form is preferred for several reasons: (1) it can handle constant values while the others can't; (2) for consistency, it is the only form accepted on this site;

返回类型箭头必须放在参数列表的末尾，在它之前的 `,` 是可选的。

The return type arrow has to be placed at the end of the parameter list, with or without a `,` before it.

```Perl6
sub greeting1(Str $name  --> Str) { say "Hello, $name" } # Valid 
sub greeting2(Str $name, --> Str) { say "Hello, $name" } # Valid 
 
sub favorite-number1(--> 42) {        } # OUTPUT: 42 
sub favorite-number2(--> 42) { return } # OUTPUT: 42 
```

如果类型约束是常量表达式，则将其用作例程的返回值。该例程中的任何返回语句都必须是无争议的。

If the type constraint is a constant expression, it is used as the return value of the routine. Any return statement in that routine has to be argumentless.

```Perl6
sub foo(Str $word --> 123) { say $word; return; }
my $value = foo("hello"); # OUTPUT: hello 
say $value;               # OUTPUT: 123 
# The code below will not compile 
sub foo(Str $word --> 123) { say $word; return $word; }
my $value = foo("hello");
say $value;
```

<a id="returns"></a>
#### `returns`

签名声明后面的关键字 `returns` 与 `-->` 具有相同的功能，但需要注意的是此形式不适用于常量值。您也不能在块中使用它。这就是为什么尖箭头形式总是首选的原因。

The keyword `returns` following a signature declaration has the same function as `-->` with the caveat that this form does not work with constant values. You cannot use it in a block either. That is why the pointy arrow form is always preferred.

```Perl6
sub greeting(Str $name) returns Str { say "Hello, $name" } # Valid 
sub favorite-number returns 42 {        } # This will fail. 
```

<a id="of"></a>
#### `of`

`of` 只是 `returns` 关键字的真实名称。

`of` is just the real name of the `returns` keyword.

```Perl6
sub foo() of Int { 42 }; # Valid 
sub foo() of 42 {  };    # This will fail. 
```

<a id="%E5%89%8D%E7%BC%80%EF%BC%88%E7%B1%BB%E4%BC%BC-c-%EF%BC%89%E5%BD%A2%E5%BC%8F--prefixc-like-form"></a>
#### 前缀（类似 C ）形式 / prefix(C-like) form

这类似于将类型约束放在变量上，例如 `my Type $var = 20;`，除了 `$var` 是例程的定义。

This is similar to placing type constraints on variables like `my Type $var = 20;`, except the `$var` is a definition for a routine.

```Perl6
my Int sub bar { 1 };     # Valid 
my 42 sub bad-answer {};  # This will fail. 
```

<a id="%E5%BC%BA%E5%88%B6%E8%BD%AC%E6%8D%A2%E7%B1%BB%E5%9E%8B--coercion-type"></a>
### 强制转换类型 / Coercion type

要接受一种类型但将其自动强制转换为另一种类型，请使用接受的类型作为目标类型的参数。如果接受的类型是 `Any`，则可以省略。

To accept one type but coerce it automatically to another, use the accepted type as an argument to the target type. If the accepted type is `Any` it can be omitted.

```Perl6
sub f(Int(Str) $want-int, Str() $want-str) {
    say $want-int.^name ~ ' ' ~ $want-str.^name
}
f '10', 10;
# OUTPUT: «Int Str␤» 
 
use MONKEY;
augment class Str { method Date() { Date.new(self) } };
sub foo(Date(Str) $d) { say $d.^name; say $d };
foo "2016-12-01";
# OUTPUT: «Date␤2016-12-01␤» 
```

强制是通过调用具有强制类型名称的方法来执行的，如果存在（例如 `Foo(Bar)` 强制转换，则调用方法 `Foo`）。假定该方法返回正确的类型 - 当前没有对结果进行额外检查。

The coercion is performed by calling the method with the name of the type to coerce to, if it exists (e.g. `Foo(Bar)` coercer, would call method `Foo`). The method is assumed to return the correct type—no additional checks on the result are currently performed.

强制也可以在返回类型上执行：

Coercion can also be performed on return types:

```Perl6
sub square-str (Int $x --> Str(Int)) {
    $x²
}
 
for 2,4, *²  … 256 -> $a {
    say $a, "² is ", square-str( $a ).chars, " figures long";
}
 
# OUTPUT: «2² is 1 figures long␤ 
#          4² is 2 figures long␤ 
#          16² is 3 figures long␤ 
#          256² is 5 figures long␤» 
```

在这个例子中，将返回类型强制转换为 `String` 允许我们直接应用字符串方法，例如字符数。

In this example, coercing the return type to `String` allows us to directly apply string methods, such as the number of characters.

<a id="slurpy%EF%BC%88aka%E3%80%82%E5%8F%AF%E5%8F%98%EF%BC%89%E5%8F%82%E6%95%B0--slurpy-aka-variadic-parameters"></a>
## slurpy（A.K.A。可变）参数 / Slurpy (A.K.A. variadic) parameters

如果函数可以采用不同数量的参数，则该函数是可变参数;也就是说，它的参数元数并不固定。因此，可选，命名和解包参数是可变参数。数组或散列参数可以通过前导星号（*）或两个前导星号（**）或前导加号（+）标记为 *slurpy*。一个 slurpy 参数可以绑定到任意零或更多）。

A function is variadic if it can take a varying number of arguments; that is, its arity is not fixed. Therefore, optional, named, and slurpy parameters are variadic. An array or hash parameter can be marked as *slurpy* by leading asterisk (*) or two leading asterisks (**) or a leading plus (+). A slurpy parameter can bind to an arbitrary number of arguments (zero or more).

这些被称为 “slurpy”，因为它们将任何剩余的参数淹没到一个函数中，就像有人嗦粉一样。

These are called "slurpy" because they slurp up any remaining arguments to a function, like someone slurping up noodles.

```Perl6
$ = :($a, @b);     # 正好两个参数，第二个参数必须是位置的 / exactly two arguments, where the second one must be Positional 
$ = :($a, *@b);    # 至少有一个参数，@b 吃掉多余一个的参数 / at least one argument, @b slurps up any beyond that 
$ = :(*%h);        # no positional arguments, but any number of named arguments 
 
sub one-arg (@)  { }
sub slurpy  (*@) { }
one-arg (5, 6, 7); # ok, same as one-arg((5, 6, 7)) 
slurpy  (5, 6, 7); # ok 
slurpy   5, 6, 7 ; # ok 
# one-arg(5, 6, 7) ; # X::TypeCheck::Argument 
# one-arg  5, 6, 7 ; # X::TypeCheck::Argument 
 
sub named-names (*%named-args) { %named-args.keys };
say named-names :foo(42) :bar<baz>; # OUTPUT: «foo bar␤» 
```

定位和命名的 slurpy 参数可以结合起来;命名参数（即`键值对`）收集在指定的散列中，位置参数收集在数组中：

Positional and named slurpies can be combined; named arguments (i.e., `Pair`s) are collected in the specified hash, positional arguments in the array:

```Perl6
sub combined-slurpy (*@a, *%h) { { array => @a, hash => %h } }
# or: sub combined-slurpy (*%h, *@a) { ... } 
 
say combined-slurpy(one => 1, two => 2);
# OUTPUT: «{array => [], hash => {one => 1, two => 2}}␤» 
say combined-slurpy(one => 1, two => 2, 3, 4);
# OUTPUT: «{array => [3 4], hash => {one => 1, two => 2}}␤» 
say combined-slurpy(one => 1, two => 2, 3, 4, five => 5);
# OUTPUT: «{array => [3 4], hash => {five => 5, one => 1, two => 2}}␤» 
say combined-slurpy(one => 1, two => 2, 3, 4, five => 5, 6);
# OUTPUT: «{array => [3 4 6], hash => {five => 5, one => 1, two => 2}}␤» 
```

请注意，在 slurpy 参数之后不允许使用位置参数：

Note that positional parameters aren't allowed after slurpy parameters:

```Perl6
:(*@args, $last);
# ===SORRY!=== Error while compiling: 
# Cannot put required parameter $last after variadic parameters 
```

通常，一个 slurpy 参数将创建一个[数组](https://docs.raku.org/type/Array)，为每个参数创建一个新的 [标量](https://docs.raku.org/type/Scalar)容器参数，并将每个参数的值分配给这些标量。如果原始参数也有一个中间标量，则在此过程中被绕过，并且在被调用函数内不可用。

Normally a slurpy parameter will create an [Array](https://docs.raku.org/type/Array), create a new [Scalar](https://docs.raku.org/type/Scalar) container for each argument, and assign the value from each argument to those Scalars. If the original argument also had an intermediary Scalar it is bypassed during this process, and is not available inside the called function.

当与某些[特征和修饰符](https://docs.raku.org/type/Signature#Parameter_Traits_and_Modifiers)结合使用时，slurpy 参数具有特殊行为，如[slurpy 数组参数章节](https://docs.raku.org/type/Signature#Types_of_slurpy_array_parameters)所述。

Slurpy parameters have special behaviors when combined with some [traits and modifiers](https://docs.raku.org/type/Signature#Parameter_Traits_and_Modifiers), as described in [the section on slurpy array parameters](https://docs.raku.org/type/Signature#Types_of_slurpy_array_parameters).

<a id="slurpy-%E6%95%B0%E7%BB%84%E5%8F%82%E6%95%B0%E7%9A%84%E7%B1%BB%E5%9E%8B--types-of-slurpy-array-parameters"></a>
## slurpy 数组参数的类型 / Types of slurpy array parameters

slurpy 数组参数有三种变体。

There are three variations to slurpy array parameters.

- 单个星号形式展平传递的参数。
- 双星号形式不会展平传递。
- 加号形式根据单个参数规则展平。

- The single asterisk form flattens passed arguments.
- The double asterisk form does not flatten arguments.
- The plus form flattens according to the single argument rule.

每个部分将在接下来的几节中详细介绍。由于每个之间的差异有点细微差别，因此每个都提供了示例，以说明每个 slurpy 参数约定与其他约定的差异。

Each will be described in detail in the next few sections. As the difference between each is a bit nuanced, examples are provided for each to demonstrate how each slurpy convention varies from the others.

<a id="%E5%B1%95%E5%B9%B3%E7%9A%84-slurpy-%E5%8F%82%E6%95%B0--flattened-slurpy"></a>
### 展平的 slurpy 参数 / Flattened slurpy

用一个星号声明的 slurpy 参数将通过溶解一个或多个裸[可迭代](https://docs.raku.org/type/Iterable)层来展平参数。

Slurpy parameters declared with one asterisk will flatten arguments by dissolving one or more layers of bare [Iterable](https://docs.raku.org/type/Iterable)s.

```Perl6
my @array = <a b c>;
my $list := <d e f>;
sub a(*@a)  { @a.perl.say };
a(@array);                 # OUTPUT: «["a", "b", "c"]» 
a(1, $list, [2, 3]);       # OUTPUT: «[1, "d", "e", "f", 2, 3]» 
a([1, 2]);                 # OUTPUT: «[1, 2]» 
a(1, [1, 2], ([3, 4], 5)); # OUTPUT: «[1, 1, 2, 3, 4, 5]» 
a(($_ for 1, 2, 3));       # OUTPUT: «[1, 2, 3]» 
```

单个星号 slurpy 参数使所有给定的迭代变平，有效地将用逗号创建的任何对象提升到顶层。

A single asterisk slurpy flattens all given iterables, effectively hoisting any object created with commas up to the top level.

<a id="%E4%B8%8D%E5%B1%95%E5%B9%B3%E7%9A%84-slurpy-%E5%8F%82%E6%95%B0--unflattened-slurpy"></a>
### 不展平的 slurpy 参数 / Unflattened slurpy

用两颗星声明的 slurpy 参数不会压缩列表中的任何[可迭代](https://docs.raku.org/type/Iterable)参数，但保持参数或多或少的原样：

Slurpy parameters declared with two stars do not flatten any [Iterable](https://docs.raku.org/type/Iterable) arguments within the list, but keep the arguments more or less as-is:

```Perl6
my @array = <a b c>;
my $list := <d e f>;
sub b(**@b) { @b.perl.say };
b(@array);                 # OUTPUT: «[["a", "b", "c"],]␤» 
b(1, $list, [2, 3]);       # OUTPUT: «[1, ("d", "e", "f"), [2, 3]]␤» 
b([1, 2]);                 # OUTPUT: «[[1, 2],]␤» 
b(1, [1, 2], ([3, 4], 5)); # OUTPUT: «[1, [1, 2], ([3, 4], 5)]␤» 
b(($_ for 1, 2, 3));       # OUTPUT: «[(1, 2, 3),]␤» 
```

双星号 slurpy 参数隐藏嵌套的逗号对象，并在 slurpy 数组中保持原样。

The double asterisk slurpy hides the nested comma objects and leaves them as-is in the slurpy array.

<a id="%E5%8D%95%E4%B8%80-slurpy-%E5%8F%82%E6%95%B0%E8%A7%84%E5%88%99--single-argument-rule-slurpy"></a>
### 单一 slurpy 参数规则 / Single argument rule slurpy

使用 `+` 创建的 slurpy 参数使用*“单个参数规则”*，它决定如何根据上下文处理 slurpy 参数。基本上，如果只传递一个参数并且该参数是[可迭代](https://docs.raku.org/type/Iterable)，则该参数用于填充 slurpy 参数数组。在任何其他情况下，`+@` 的作用类似于 `**@`。

A slurpy parameter created using a plus engages the *"single argument rule"*, which decides how to handle the slurpy argument based upon context. Basically, if only a single argument is passed and that argument is [Iterable](https://docs.raku.org/type/Iterable), that argument is used to fill the slurpy parameter array. In any other case, `+@` works like `**@`.

```Perl6
my @array = <a b c>;
my $list := <d e f>;
sub c(+@b) { @b.perl.say };
c(@array);                 # OUTPUT: «["a", "b", "c"]␤» 
c(1, $list, [2, 3]);       # OUTPUT: «[1, ("d", "e", "f"), [2, 3]]␤» 
c([1, 2]);                 # OUTPUT: «[1, 2]␤» 
c(1, [1, 2], ([3, 4], 5)); # OUTPUT: «[1, [1, 2], ([3, 4], 5)]␤» 
c(($_ for 1, 2, 3));       # OUTPUT: «[1, 2, 3]␤» 
```

有关其他讨论和示例，请参阅[函数的slurpy参数约定](https://docs.raku.org/language/functions#Slurpy_conventions)。

For additional discussion and examples, see [Slurpy Conventions for Functions](https://docs.raku.org/language/functions#Slurpy_conventions).

<a id="%E7%B1%BB%E5%9E%8B%E6%8D%95%E8%8E%B7--type-captures"></a>
## 类型捕获 / Type captures

类型捕获允许将类型约束的规范推迟到调用函数的时间。它们允许在签名和函数体中引用类型。

Type captures allow deferring the specification of a type constraint to the time the function is called. They allow referring to a type both in the signature and the function body.

```Perl6
sub f(::T $p1, T $p2, ::C){
    # $p1 and $p2 are of the same type T, that we don't know yet 
    # C will hold a type we derive from a type object or value 
    my C $closure = $p1 / $p2;
    return sub (T $p1) {
        $closure * $p1;
    }
}
 
# The first parameter is Int and so must be the 2nd. 
# We derive the 3rd type from calling the operator that is used in &f. 
my &s = f(10, 2, Int.new / Int.new);
say s(2); # 10 / 2 * 2 == 10 
```

<a id="%E4%BD%8D%E7%BD%AE%E4%B8%8E%E5%91%BD%E5%90%8D%E5%8F%82%E6%95%B0--positional-vs-named-arguments"></a>
## 位置与命名参数 / Positional vs. named arguments

参数可以是*位置的*或*命名的*。默认情况下，参数是位置的，除了 slurpy 哈希和标有前导冒号 `:` 的参数。后者称为[冒号对](https://docs.raku.org/type/Pair)。检查以下签名及其表示的内容：

An argument can be *positional* or *named*. By default, arguments are positional, except slurpy hash and arguments marked with a leading colon `:`. The latter is called a [colon-pair](https://docs.raku.org/type/Pair). Check the following signatures and what they denote:

```Perl6
$ = :($a);               # a positional argument 
$ = :(:$a);              # a named argument of name 'a' 
$ = :(*@a);              # a slurpy positional argument 
$ = :(*%h);              # a slurpy named argument 
```

在调用者方面，位置参数的传递顺序与声明参数的顺序相同。

On the caller side, positional arguments are passed in the same order as the arguments are declared.

```Perl6
sub pos($x, $y) { "x=$x y=$y" }
pos(4, 5);                          # OUTPUT: «x=4 y=5» 
```

对于命名参数和参数，只有名称用于将参数映射到参数。如果使用胖箭头来构造 [Pair](https://docs.raku.org/type/Pair)，则只有那些具有有效标识符作为键的箭头才会被识别为命名参数。

In the case of named arguments and parameters, only the name is used for mapping arguments to parameters. If a fat arrow is used to construct a [Pair](https://docs.raku.org/type/Pair) only those with valid identifiers as keys are recognized as named arguments.

```Perl6
sub named(:$x, :$y) { "x=$x y=$y" }
named( y => 5, x => 4);             # OUTPUT: «x=4 y=5» 
```

你可以使用与命名参数同名的变量来调用例程;在这种情况下调用者可以使用 `:`，以便将变量的名称理解为参数的键。

You can invoke the routine using a variable with the same name as the named argument; in that case `:` will be used for the invocation so that the name of the variable is understood as the key of the argument.

```Perl6
sub named-shortcut( :$shortcut ) {
    say "Looks like $shortcut"
}
named-shortcut( shortcut => "to here"); # OUTPUT: «Looks like to here␤» 
my $shortcut = "Þor is mighty";
named-shortcut( :$shortcut );           # OUTPUT: «Looks like Þor is mighty␤» 
```

命名参数的名称可与变量的名称不同：

It is possible to have a different name for a named argument than the variable name:

```Perl6
sub named(:official($private)) { "Official business!" if $private }
named :official;
```

<a id="%E5%8F%82%E6%95%B0%E5%88%AB%E5%90%8D--argument-aliases"></a>
## 参数别名 / Argument aliases

[冒号对](https://docs.raku.org/type/Pair)语法可用于为参数提供别名：

The [colon-pair](https://docs.raku.org/type/Pair) syntax can be used to provide aliases for arguments:

```Perl6
sub alias-named(:color(:$colour), :type(:class($kind))) {
    say $colour ~ " " ~ $kind
}
alias-named(color => "red", type => "A");    # both names can be used 
alias-named(colour => "green", type => "B"); # more than two names are ok 
alias-named(color => "white", class => "C"); # every alias is independent 
```

冒号 `:` 的存在将决定我们是否正在创建一个新的命名参数。 `:$colour` 不仅是别名变量的名称，还是一个新的命名参数（在第二次调用中使用）。但是，`$kind` 只是别名变量的名称，不会创建新的命名参数。别名的更多用法可以在 [sub MAIN](https://docs.raku.org/language/functions#sub_MAIN) 中找到。

The presence of the colon `:` will decide whether we are creating a new named argument or not. `:$colour` will not only be the name of the aliased variable, but also a new named argument (used in the second invocation). However, `$kind` will just be the name of the aliased variable, that does not create a new named argument. More uses of aliases can be found in [sub MAIN](https://docs.raku.org/language/functions#sub_MAIN)

具有命名参数的函数可以被动态调用，使用 `|` 解引用 [Pair](https://docs.raku.org/type/Pair) 将其转换为命名参数。

A function with named arguments can be called dynamically, dereferencing a [Pair](https://docs.raku.org/type/Pair) with `|` to turn it into a named argument.

```Perl6
multi f(:$named) { note &?ROUTINE.signature };
multi f(:$also-named) { note &?ROUTINE.signature };
for 'named', 'also-named' -> $n {
    f(|($n => rand))                # OUTPUT: «(:$named)␤(:$also-named)␤» 
}
 
my $pair = :named(1);
f |$pair;                           # OUTPUT: «(:$named)␤» 
```

可以使用同样的方法将 `Hash` 转换为命名参数。

The same can be used to convert a `Hash` into named arguments.

```Perl6
sub f(:$also-named) { note &?ROUTINE.signature };
my %pairs = also-named => 4;
f |%pairs;                              # OUTPUT: «(:$also-named)␤» 
```

包含列表的 `Hash` 转换为命名参数时会出现问题。避免额外的容器层级，将其转化为 [Map](https://docs.raku.org/type/Map)。

A `Hash` that contains a list may prove problematic when slipped into named arguments. To avoid the extra layer of containers coerce to [Map](https://docs.raku.org/type/Map) before slipping.

```Perl6
class C { has $.x; has $.y; has @.z };
my %h = <x y z> Z=> (5, 20, [1,2]);
say C.new(|%h.Map);
# OUTPUT: «C.new(x => 5, y => 20, z => [1, 2])␤» 
```

<a id="%E5%8F%AF%E9%80%89%E5%92%8C%E5%BC%BA%E5%88%B6%E5%8F%82%E6%95%B0--optional-and-mandatory-arguments"></a>
## 可选和强制参数 / Optional and mandatory arguments

默认情况下，位置参数是必需的，并且可以使用默认值或尾随问号使其成为可选参数：

Positional parameters are mandatory by default, and can be made optional with a default value or a trailing question mark:

```Perl6
$ = :(Str $id);         # required parameter 
$ = :($base = 10);      # optional parameter, default value 10 
$ = :(Int $x?);         # optional parameter, default is the Int type object 
```

默认情况下，命名参数是可选的，并且可以使用尾随感叹号强制转为必须参数：

Named parameters are optional by default, and can be made mandatory with a trailing exclamation mark:

```Perl6
$ = :(:%config);        # optional parameter 
$ = :(:$debug = False); # optional parameter, defaults to False 
$ = :(:$name!);         # mandatory 'name' named parameter 
```

默认值可以取决于先前的参数，并且（至少在概念上）为每个调用重新计算

Default values can depend on previous parameters, and are (at least notionally) computed anew for each call

```Perl6
$ = :($goal, $accuracy = $goal / 100);
$ = :(:$excludes = ['.', '..']);        # a new Array for every call 
```

<a id="%E5%8A%A8%E6%80%81%E5%8F%98%E9%87%8F--dynamic-variables"></a>
## 动态变量 / Dynamic variables

签名中允许[动态变量](https://docs.raku.org/language/variables#The_%2A_twigil)，尽管它们不提供特殊行为，因为参数绑定无论如何都会连接两个作用域。

[Dynamic variables](https://docs.raku.org/language/variables#The_%2A_twigil) are allowed in signatures although they don't provide special behavior because argument binding does connect two scopes anyway.


<a id="%E8%A7%A3%E6%9E%84%E5%8F%82%E6%95%B0--destructuring-arguments"></a>
## 解构参数 / Destructuring arguments

参数之后可以是括号中的子签名，它将对给定的参数进行解构。列表解构后就是它的元素：

Parameters can be followed by a sub-signature in parentheses, which will destructure the argument given. The destructuring of a list is just its elements:

```Perl6
sub first(@array ($first, *@rest)) { $first }
```

或者

or

```Perl6
sub first([$f, *@]) { $f }
```

解构后的哈希是它的键值对：

While the destructuring of a hash is its pairs:

```Perl6
sub all-dimensions(% (:length(:$x), :width(:$y), :depth(:$z))) {
    $x andthen $y andthen $z andthen True
}
```

尖点循环也可以解构哈希，允许赋值给变量：

Pointy loops can also destructure hashes, allowing assignment to variables:

```Perl6
my %hhgttu = (:40life, :41universe, :42everything);
for %hhgttu -> (:$key, :$value) {
  say "$key → $value";
}
# OUTPUT: «universe → 41␤life → 40␤everything → 42␤» 
```

通常，对象是基于其属性进行解构。一个常见的习惯用法是在 for 循环中解包 [`Pair`](https://docs.raku.org/type/Pair) 的键和值：

In general, an object is destructured based on its attributes. A common idiom is to unpack a [`Pair`](https://docs.raku.org/type/Pair)'s key and value in a for loop:

```Perl6
for <Peter Paul Merry>.pairs -> (:key($index), :value($guest)) { }
```

但是，将对象解包为其属性只是默认行为。要使对象以不同方式进行解构，请更改其 [`Capture`](https://docs.raku.org/routine/Capture) 方法。

However, this unpacking of objects as their attributes is only the default behavior. To make an object get destructured differently, change its [`Capture`](https://docs.raku.org/routine/Capture) method.

<a id="%E5%AD%90%E7%AD%BE%E5%90%8D--sub-signatures"></a>
## 子签名 / Sub-signatures

要匹配复合参数，请在括号中的参数名称后面使用子签名。

To match against a compound parameter use a sub-signature following the argument name in parentheses.

```Perl6
sub foo(|c(Int, Str)){
   put "called with {c.perl}"
};
foo(42, "answer");
# OUTPUT: «called with \(42, "answer")␤» 
```

<a id="%E9%95%BF%E5%90%8D--long-names"></a>
## 长名 / Long names

要排除某些参数在多次分派中被考虑，请用双分号分隔它们。

To exclude certain parameters from being considered in multiple dispatch, separate them with a double semicolon.

```Perl6
multi sub f(Int $i, Str $s;; :$b) { say "$i, $s, {$b.perl}" };
f(10, 'answer');
# OUTPUT: «10, answer, Any␤» 
```

<a id="%E6%8D%95%E8%8E%B7%E5%8F%82%E6%95%B0--capture-parameters"></a>
## 捕获参数 / Capture parameters

使用竖线 `|` 前缀参数使参数成为 [`Capture`](https://docs.raku.org/type/Capture)，它会消耗完所有剩余的位置和命名参数。

Prefixing a parameter with a vertical bar `|` makes the parameter a [`Capture`](https://docs.raku.org/type/Capture), using up all the remaining positional and named arguments.

这通常用于 `proto` 定义（如 `proto foo (|) {*}`）来表示例程的 [`multi` 定义](https://docs.raku.org/routine/multi)可以有任意[类型约束](https://docs.raku.org/type/Signature#Type_constraints)。有关示例，请参阅 [proto](https://docs.raku.org/language/functions#proto)。

This is often used in `proto` definitions (like `proto foo (|) {*}`) to indicate that the routine's [`multi` definitions](https://docs.raku.org/routine/multi) can have any [type constraints](https://docs.raku.org/type/Signature#Type_constraints). See [proto](https://docs.raku.org/language/functions#proto) for an example.

如果绑定到变量, 参数可以使用 slip 运算符 `|` 作为一个整体转发。

If bound to a variable arguments can be forwarded as a whole using the slip operator `|`.

```Perl6
sub a(Int $i, Str $s) { say $i.^name ~ ' ' ~ $s.^name }
sub b(|c) { say c.^name; a(|c) }
b(42, "answer");
# OUTPUT: «Capture␤Int Str␤» 
```

<a id="%E5%8F%82%E6%95%B0%E7%89%B9%E5%BE%81%E5%92%8C%E4%BF%AE%E9%A5%B0%E7%AC%A6--parameter-traits-and-modifiers"></a>
## 参数特征和修饰符 / Parameter traits and modifiers

默认情况下，参数绑定到其参数并标记为只读。可以通过参数上的特征来改变它。

By default, parameters are bound to their argument and marked as read-only. One can change that with traits on the parameter.

`is copy` 特征可以使复制被参数，并允许在例程中被修改。

The `is copy` trait causes the argument to be copied, and allows it to be modified inside the routine

```Perl6
sub count-up($x is copy) {
    $x = ∞ if $x ~~ Whatever;
    .say for 1..$x;
}
```

`is rw` 特征，代表*可读写*，使参数绑定到变量（或其他可写容器）。分配给参数会更改调用方的变量值。

The `is rw` trait, which stands for *is read-write*, makes the parameter bind to a variable (or other writable container). Assigning to the parameter changes the value of the variable at the caller side.

```Perl6
sub swap($x is rw, $y is rw) {
    ($x, $y) = ($y, $x);
}
```

在 slurpy 参数上，`is rw` 被语言设计者保留供将来使用。

On slurpy parameters, `is rw` is reserved for future use by language designers.

[`is raw` 特征](https://docs.raku.org/type/Parameter#method_raw)会自动应用于使用[反斜杠](https://docs.raku.org/language/variables#Sigilless_variables)声明的参数作为“标记”，也可用于产生`带标记参数`的行为。在 slurpies 的特殊情况下，通常会产生一个充满`标量`的`数组`，如上所述，`is raw` 将导致参数产生一个`列表`。该列表的每个元素将直接绑定为原始参数。

The [`is raw` trait](https://docs.raku.org/type/Parameter#method_raw) is automatically applied to parameters declared with a [backslash](https://docs.raku.org/language/variables#Sigilless_variables) as a "sigil", and may also be used to make normally sigiled parameters behave like these do. In the special case of slurpies, which normally produce an `Array` full of `Scalar`s as described above, `is raw` will instead cause the parameter to produce a `List`. Each element of that list will be bound directly as raw parameter.

要显式请求只读参数，请使用 `is readonly` 特征。请注意，这仅适用于容器。里面的对象很可能有 mutator 方法，而 Perl 6 不会对对象的属性强制不可变。

To explicitly ask for a read-only parameter use the `is readonly` trait. Please note that this applies only to the container. The object inside can very well have mutator methods and Perl 6 will not enforce immutability on the attributes of the object.

特征可以跟随 where 子句：

Traits can be followed by the where clause:

```Perl6
sub ip-expand-ipv6($ip is copy where m:i/^<[a..f\d\:]>**3..39$/) { }
```

<a id="signature-%E7%9A%84%E6%96%B9%E6%B3%95--methods"></a>
# Signature 的方法 / Methods

<a id="%E6%96%B9%E6%B3%95-params--method-params"></a>
## 方法 params / method params

```Perl6
method params(Signature:D: --> Positional)
```

返回组成签名的 [`Parameter`](https://docs.raku.org/type/Parameter) 对象列表。

Returns the list of [`Parameter`](https://docs.raku.org/type/Parameter) objects that make up the signature.

<a id="%E6%96%B9%E6%B3%95-arity--method-arity"></a>
## 方法 arity / method arity

```Perl6
method arity(Signature:D: --> Int:D)
```

返回满足签名所需的*最少*位置参数数。

Returns the *minimal* number of positional arguments required to satisfy the signature.

<a id="%E6%96%B9%E6%B3%95-count--method-count"></a>
## 方法 count / method count

```Perl6
method count(Signature:D: --> Real:D)
```

返回可以绑定到签名的位置参数*最大*个数。如果存在一个不稳定的位置参数，则返回 `Inf`。

Returns the *maximal* number of positional arguments which can be bound to the signature. Returns `Inf` if there is a slurpy positional parameter.

<a id="%E6%96%B9%E6%B3%95-returns--method-returns"></a>
## 方法 returns / method returns

无论签名的返回值约束是什么：

Whatever the Signature's return constraint is:

```Perl6
:($a, $b --> Int).returns # OUTPUT: «(Int)» 
```

<a id="%E6%96%B9%E6%B3%95-accepts--method-accepts"></a>
## 方法 ACCEPTS / method ACCEPTS

```Perl6
multi method ACCEPTS(Signature:D: Signature $topic)
multi method ACCEPTS(Signature:D: Capture $topic)
multi method ACCEPTS(Signature:D: Mu \topic)
```

如果 `$topic` 是一个返回 `True` 的 [Signature](https://docs.raku.org/type/Signature) 时，`$topic` 接受的任何内容也会被调用者接受，否则返回 `False`：

If `$topic` is a [Signature](https://docs.raku.org/type/Signature) returns `True` if anything accepted by `$topic` would also be accepted by the invocant, otherwise returns `False`:

```Perl6
:($a, $b) ~~ :($foo, $bar, $baz?);   # OUTPUT: «True» 
:(Int $n) ~~ :(Str);                 # OUTPUT: «False» 
```

`$topic` 是 [Capture](https://docs.raku.org/type/Capture)，如果它可以绑定到调用者，则返回`True`，即，如果具有调用者的 `Signature` 的函数将可以使用 `$topic` 调用：

The `$topic` is a [Capture](https://docs.raku.org/type/Capture), returns `True` if it can be bound to the invocant, i.e., if a function with invocant's `Signature` would be able to be called with the `$topic`:

```Perl6
\(1, 2, :foo) ~~ :($a, $b, :foo($bar)); # OUTPUT: «True» 
\(1, :bar)    ~~ :($a);                 # OUTPUT: «False» 
```

最后，具有 `Mu \topic` 的候选者将 `topic` 转换为 [Capture](https://docs.raku.org/type/Capture)，并遵循与 [Capture](https://docs.raku.org/type/Capture) `$topic` 相同的语义 ：

Lastly, the candidate with `Mu \topic` converts `topic` to [Capture](https://docs.raku.org/type/Capture) and follows the same semantics as [Capture](https://docs.raku.org/type/Capture) `$topic`:

```Perl6
<a b c d>  ~~ :(Int $a);      # OUTPUT: «False» 
42         ~~ :(Int);         # OUTPUT: «False» (Int.Capture throws) 
set(<a b>) ~~ :(:$a, :$b);    # OUTPUT: «True» 
```

由于 [`where` 子句](https://docs.raku.org/type/Signature#index-entry-where_clause_%28Signature%29)不能内省，因此该方法无法确定是否有两个签名 [ACCEPTS](https://docs.raku.org/type/Signature#method_ACCEPTS) 同样的 `where` 约束的参数。这种比较将返回 `False`。这包括字面量的签名，这些只是 `where`约束的语法糖：

Since [`where` clauses](https://docs.raku.org/type/Signature#index-entry-where_clause_%28Signature%29) are not introspectable, the method cannot determine whether two signatures [ACCEPTS](https://docs.raku.org/type/Signature#method_ACCEPTS) the same sort of `where`-constrained parameters. Such comparisons will return `False`. This includes signatures with literals, which are just sugar for the `where`-constraints:

```Perl6
say :(42) ~~ :($ where 42)    # OUTPUT: «False␤» 
```

<a id="%E6%96%B9%E6%B3%95-capture--method-capture"></a>
## 方法 Capture / method Capture

定义为了：

Defined as:

```Perl6
method Capture()
```

抛出异常 `X::Cannot::Capture`。

Throws `X::Cannot::Capture`.

<a id="%E8%BF%90%E8%A1%8C%E6%97%B6%E5%88%9B%E5%BB%BA%E7%AD%BE%E5%90%8D%E5%AF%B9%E8%B1%A16d-201901%E5%8F%8A%E4%BB%A5%E5%90%8E--runtime-creation-of-signature-objects-6d-201901-and-later"></a>
# 运行时创建签名对象(6.d, 2019.01及以后) / Runtime creation of Signature objects (6.d, 2019.01 and later)

```Perl6
Signature.new(params => (...), returns => Type, arity => 1, count => 1)
```

在某些情况下，特别是在使用元对象协议时，以编程方式创建 `Signature` 对象是有意义的。为此，您可以使用以下命名参数调用 `new` 方法：

In some situations, specifically when working with the MetaObject Protocol, it makes sense to create `Signature` objects programmatically. For this purpose, you can call the `new` method with the following named parameters:

- params

签名的 [Parameter](https://docs.raku.org/type/Parameter) 对象列表。

A list of [Parameter](https://docs.raku.org/type/Parameter) objects for this signature.

- returns

返回值应匹配的任何约束。默认为 `Mu`，这实际上意味着没有返回值约束检查。

Any constraint the return value should match. Defaults to `Mu`, which effectively implies no return value constraint check.

- arity

满足签名的最小位置参数个数。默认为 `params` 参数给的 `Parameter` 对象的个数。

The *minimal* number of positional arguments required to satisfy the signature. Defaults to the number of `Parameter` objects given with the `params` parameter.

- count

可以绑定到签名的*最大*位置参数个数。如果未指定，则默认为 `arity`。如果存在一个 slurpy 位置参数，请指定 `Inf`。

The *maximal* number of positional arguments which can be bound to the signature. Defaults to the `arity` if not specified. Specify `Inf` if there is a slurpy positional parameter.

<a id="%E7%B1%BB%E5%9E%8B%E5%9B%BE--type-graph"></a>
# 类型图 / Type Graph

`Signature` 签名的类型关系。

Type relations for `Signature` Signature.

        Mu
        ^
        |
        |
       Any
        ^
        |
    Signature
