原文：https://docs.raku.org/language/containers

# 容器 / Containers

Raku 容器的底层解释

A low-level explanation of Raku containers

本节将解释与变量和容器元素打交道所涉及的间接级别。介绍 Raku 中使用的容器的不同类型，以及适用于这些容器的操作，如赋值、绑定和展平。最后讨论了更高级的主题，如自引用数据、类型约束和自定义容器。

This section explains the levels of indirection involved in dealing with variables and container elements. The difference types of containers used in Raku are explained and the actions applicable to them like assigning, binding and flattening. More advanced topics like self-referential data, type constraints and custom containers are discussed at the end.

# 目录 / Table of Contents

<!-- MarkdownTOC -->

- [变量是什么？ / What is a variable?](#变量是什么？--what-is-a-variable)
- [标量容器 / Scalar containers](#标量容器--scalar-containers)
- [可调用容器 / Callable containers](#可调用容器--callable-containers)
- [绑定 / Binding](#绑定--binding)
- [标量容器和列表 / Scalar containers and listy things](#标量容器和列表--scalar-containers-and-listy-things)
- [赋值及绑定至数组变量 / Assigning and binding to array variables](#赋值及绑定至数组变量--assigning-and-binding-to-array-variables)
- [绑定至数组元素 / Binding to array elements](#绑定至数组元素--binding-to-array-elements)
- [展开、物品和容器 / Flattening, items and containers](#展开、物品和容器--flattening-items-and-containers)
- [自引用数据 / Self-referential data](#自引用数据--self-referential-data)
- [类型约束 / Type constraints](#类型约束--type-constraints)
	- [`已定义`约束 / Definedness constraints](#已定义约束--definedness-constraints)
- [自定义容器 / Custom containers](#自定义容器--custom-containers)

<!-- /MarkdownTOC -->

<a id="变量是什么？--what-is-a-variable"></a>
# 变量是什么？ / What is a variable?

有些人喜欢说“一切都是一个对象”，但实际上在 Raku 中，变量不是暴露给用户的对象。

Some people like to say "everything is an object", but in fact a variable is not a user-exposed object in Raku.

当编译器遇到类似 `my $x` 的变量声明时，它会将其注册到一些内部符号表中。此内部符号表用于检测未声明的变量，并将变量的代码生成与正确的作用域相关联。

When the compiler encounters a variable declaration like `my $x`, it registers it in some internal symbol table. This internal symbol table is used to detect undeclared variables and to tie the code generation for the variable to the correct scope.

在运行时，变量在*词法板*（或简称 *lexpad*）中显示为一个条目。这是一个按作用域的数据结构，它为每个变量存储一个指针。

At runtime, a variable appears as an entry in a *lexical pad*, or *lexpad* for short. This is a per-scope data structure that stores a pointer for each variable.

`my $x` 中，变量 `$x` 的词法板条目是一个指向 `Scalar` 类型的对象的指针，通常称为*容器*。

In the case of `my $x`, the lexpad entry for the variable `$x` is a pointer to an object of type `Scalar`, usually just called *the container*.

<a id="标量容器--scalar-containers"></a>
# 标量容器 / Scalar containers

尽管在 Raku 中，[`Scalar`](https://docs.raku.org/type/scalar) 类型的对象随处可见，但你很少见它们直接作为对象，因为大多数操作是*去容器化*的，这意味着它们作用于 `scalar` 容器的内容，而不是容器本身。

Although objects of type [`Scalar`](https://docs.raku.org/type/Scalar) are everywhere in Raku, you rarely see them directly as objects, because most operations *decontainerize*, which means they act on the `Scalar` container's contents instead of the container itself.

在代码中

In code like

```Raku
my $x = 42;
say $x;
```

赋值语句 `$x = 42` 将指向 `Int` 对象 42 的指针存储在标量容器中，其中 `$x` 的词法板条目指向该标量容器。

the assignment `$x = 42` stores a pointer to the `Int` object 42 in the scalar container to which the lexpad entry for `$x` points.

赋值运算符要求左侧的容器存储其右侧的值。这究竟意味着什么取决于容器类型。对于 `Scalar`，它的意思是“用新值替换先前存储的值”。

The assignment operator asks the container on the left to store the value on its right. What exactly that means is up to the container type. For `Scalar` it means "replace the previously stored value with the new one".

注意，子程序签名允许传递容器：

Note that subroutine signatures allow passing around of containers:

```Raku
sub f($a is rw) {
    $a = 23;
}
my $x = 42;
f($x);
say $x;         # OUTPUT: «23
» 
```

在子例程中，`$a` 的词法板条目与子例程外部 `$x` 指向同一容器。这就是为什么赋值给 `$a` 也会修改 `$x` 的内容。

Inside the subroutine, the lexpad entry for `$a` points to the same container that `$x` points to outside the subroutine. Which is why assignment to `$a` also modifies the contents of `$x`.

同样，如果例程标记为 `is rw`，则可以返回容器：

Likewise a routine can return a container if it is marked as `is rw`:

```Raku
my $x = 23;
sub f() is rw { $x };
f() = 42;
say $x;         # OUTPUT: «42
» 
```

对于显式返回，必须使用 `return-rw` 而不是 `return`。

For explicit returns, `return-rw` instead of `return` must be used.

返回容器就是 `rw` 属性访问器的工作方式。所以

Returning a container is how `is rw` attribute accessors work. So

```Raku
class A {
    has $.attr is rw;
}
```

等同于

is equivalent to

```Raku
class A {
    has $!attr;
    method attr() is rw { $!attr }
}
```

标量容器对于类型检查和大多数只读访问都是透明的。`.VAR` 使得它们可见：

Scalar containers are transparent to type checks and most kinds of read-only accesses. A `.VAR` makes them visible:

```Raku
my $x = 42;
say $x.^name;       # OUTPUT: «Int
» 
say $x.VAR.^name;   # OUTPUT: «Scalar
» 
```

参数上的 `is rw` 要求可写的标量容器：

And `is rw` on a parameter requires the presence of a writable Scalar container:

```Raku
sub f($x is rw) { say $x };
f 42;
CATCH { default { say .^name, ': ', .Str } };
# OUTPUT: «X::Parameter::RW: Parameter '$x' expected a writable container, but got Int value
» 
```

<a id="可调用容器--callable-containers"></a>
# 可调用容器 / Callable containers

在存储在容器中的对象的 [Routine](https://docs.raku.org/type/routine) 调用语法和 [CALL-ME](https://docs.raku.org/type/callable method_call-me) 方法的实际调用之间，可调用容器提供了一个桥梁。声明容器时需要 `&` 标记并且在执行 `Callable` 时标记必须省略。默认类型约束为 [Callable](https://docs.raku.org/type/callable)。

Callable containers provide a bridge between the syntax of a [Routine](https://docs.raku.org/type/Routine) call and the actual call of the method [CALL-ME](https://docs.raku.org/type/Callable#method_CALL-ME) of the object that is stored in the container. The sigil `&` is required when declaring the container and has to be omitted when executing the `Callable`. The default type constraint is [Callable](https://docs.raku.org/type/Callable).

```Raku
my &callable = -> $ν { say "$ν is", $ν ~~ Int??" whole"!!" not whole" }
callable( ⅓ );
callable( 3 );
```

引用存储在容器中的值时必须带标记。这反过来又允许将  `Routine` 用作[参数](https://docs.raku.org/type/Signature#Constraining_signature_s_of_Callables)调用。

The sigil has to be provided when referring to the value stored in the container. This in turn allows `Routine`s to be used as [arguments](https://docs.raku.org/type/Signature#Constraining_signatures_of_Callables) to calls.

```Raku
sub f() {}
my &g = sub {}
sub caller(&c1, &c2){ c1, c2 }
caller(&f, &g);
```

<a id="绑定--binding"></a>
# 绑定 / Binding

除了赋值之外，Raku 还支持*绑定*，使用 `：=` 运算符。将值或容器绑定到变量时，将修改变量的词法板条目（而不仅仅是它指向的容器）。如果你写:

Next to assignment, Raku also supports *binding* with the `:=` operator. When binding a value or a container to a variable, the lexpad entry of the variable is modified (and not just the container it points to). If you write

```Raku
my $x := 42;
```

那么 `$x` 的词法板条目指向 `Int` 42。意味着你无法再给它赋值。

then the lexpad entry for `$x` directly points to the `Int` 42. Which means that you cannot assign to it anymore:

```Raku
my $x := 42;
$x = 23;
CATCH { default { say .^name, ': ', .Str } };
# OUTPUT: «X::AdHoc: Cannot assign to an immutable value
» 
```

也可以绑定到其他变量：

You can also bind variables to other variables:

```Raku
my $a = 0;
my $b = 0;
$a := $b;
$b = 42;
say $a;         # OUTPUT: «42
» 
```

在第一绑定后，`$a` 和 `$b` 的词法板条目指向相同的标量容器，因此给一个变量赋值也会改变另一个变量的内容。

Here, after the initial binding, the lexpad entries for `$a` and `$b` both point to the same scalar container, so assigning to one variable also changes the contents of the other.

这种情形你之前也见到过：标记为 `is rw` 的签名参数正是如此。

You've seen this situation before: it is exactly what happened with the signature parameter marked as `is rw`.

无符号变量以及 `is raw` 特性的参数始终绑定（无论使用 `=` 还是 `:=`）:

Sigilless variables and parameters with the trait `is raw` always bind (whether `=` or `:=` is used):

```Raku
my $a = 42;
my \b = $a;
b++;
say $a;         # OUTPUT: «43
» 
 
sub f($c is raw) { $c++ }
f($a);
say $a;         # OUTPUT: «44
» 
```

<a id="标量容器和列表--scalar-containers-and-listy-things"></a>
# 标量容器和列表 / Scalar containers and listy things

Raku 中有许多语义稍有不同的位置容器类型。最基本的是 [List](https://docs.raku.org/type/list)；它是由逗号操作符创建的。

There are a number of positional container types with slightly different semantics in Raku. The most basic one is [List](https://docs.raku.org/type/List); it is created by the comma operator.

```Raku
say (1, 2, 3).^name;    # OUTPUT: «List
» 
```

列表是不可变的，这意味着你不能更改列表中的元素数。但是，如果其中一个元素恰好是一个标量容器的话，你仍然可以给它赋值：

A list is immutable, which means you cannot change the number of elements in a list. But if one of the elements happens to be a scalar container, you can still assign to it:

```Raku
my $x = 42;
($x, 1, 2)[0] = 23;
say $x;                 # OUTPUT: «23
» 
($x, 1, 2)[1] = 23;     # Cannot modify an immutable value 
CATCH { default { say .^name, ': ', .Str } };
# OUTPUT: «X::Assignment::RO: Cannot modify an immutable Int
» 
```

因此列表不关心它的元素时值还是容器，它们只存储和检索给它们的任何东西。

So the list doesn't care about whether its elements are values or containers, they just store and retrieve whatever was given to them.

列表也可以是惰性的；在这种情况下，末尾的元素是根据需要从迭代器生成的。

Lists can also be lazy; in that case, elements at the end are generated on demand from an iterator.

`Array` 类似列表，除了它强制其所有元素都是容器，这意味着你可以始终给其中的元素赋值：

An `Array` is just like a list, except that it forces all its elements to be containers, which means that you can always assign to elements:

```Raku
my @a = 1, 2, 3;
@a[0] = 42;
say @a;         # OUTPUT: «[42 2 3]
» 
```

`@a` 实际上存储了三个标量变量。`@a[0]` 返回其中的一个，赋值运算符将容器内的值替换成新的值 `42`。

`@a` actually stores three scalar containers. `@a[0]` returns one of them, and the assignment operator replaces the integer value stored in that container with the new one, `42`.

<a id="赋值及绑定至数组变量--assigning-and-binding-to-array-variables"></a>
# 赋值及绑定至数组变量 / Assigning and binding to array variables

给标量以及数组变量赋值都做的同一件事情：舍弃旧值并输入新值。

Assignment to a scalar variable and to an array variable both do the same thing: discard the old value(s), and enter some new value(s).

尽管如此，很容易观察到它们有多不同：

Nevertheless, it's easy to observe how different they are:

```Raku
my $x = 42; say $x.^name;   # OUTPUT: «Int
» 
my @a = 42; say @a.^name;   # OUTPUT: «Array
» 
```

这是因为 `Scalar` 容器类型很好地隐藏了自己，但是 `Array` 不这样做。另外，对数组变量的赋值是强制的，因此可以将非数组值赋给数组变量。

This is because the `Scalar` container type hides itself well, but `Array` makes no such effort. Also assignment to an array variable is coercive, so you can assign a non-array value to an array variable.

要将非 `Array` 放入一个数组变量中，使用绑定：

To place a non-`Array` into an array variable, binding works:

```Raku
my @a := (1, 2, 3);
say @a.^name;               # OUTPUT: «List
» 
```

<a id="绑定至数组元素--binding-to-array-elements"></a>
# 绑定至数组元素 / Binding to array elements

作为一个奇怪的侧注，Raku 支持绑定到数组元素：

As a curious side note, Raku supports binding to array elements:

```Raku
my @a = (1, 2, 3);
@a[0] := my $x;
$x = 42;
say @a;                     # OUTPUT: «[42 2 3]
» 
```

如果你已经阅读并理解了前面的解释，现在是时候思考一下这是如何工作的了。绑定到变量需要那个变量的一个词法板条目，虽然数组确有一个词法板条目，但是数组里的元素没有词法板条目，因为你不能在运行时扩展词法板。

If you've read and understood the previous explanations, it is now time to wonder how this can possibly work. After all, binding to a variable requires a lexpad entry for that variable, and while there is one for an array, there aren't lexpad entries for each array element, because you cannot expand the lexpad at runtime.

答案是，绑定到数组元素是在语法级别识别的，对数组调用一个叫做 `BIND-KEY` 的特殊方法，而不是为寻常的绑定操作发射代码。此方法处理与数组元素的绑定。

The answer is that binding to array elements is recognized at the syntax level and instead of emitting code for a normal binding operation, a special method (called `BIND-KEY`) is called on the array. This method handles binding to array elements.

请注意，尽管支持，但通常应避免将非容器化的内容直接绑定到数组元素中。这样做可能会在稍后使用数组时产生反直观的结果。

Note that, while supported, one should generally avoid directly binding uncontainerized things into array elements. Doing so may produce counter-intuitive results when the array is used later.

```Raku
my @a = (1, 2, 3);
@a[0] := 42;         # This is not recommended, use assignment instead. 
my $b := 42;
@a[1] := $b;         # Nor is this. 
@a[2] = $b;          # ...but this is fine. 
@a[1, 2] := 1, 2;    # runtime error: X::Bind::Slice 
CATCH { default { say .^name, ': ', .Str } };
# OUTPUT: «X::Bind::Slice: Cannot bind to Array slice
» 
```

混合列表和数组的操作通常可以防止意外发生这种情况。

Operations that mix Lists and Arrays generally protect against such a thing happening accidentally.

<a id="展开、物品和容器--flattening-items-and-containers"></a>
# 展开、物品和容器 / Flattening, items and containers

`%` 和 `@` 标记在 Raku 中通常代表迭代结构有多个值，而 `$` 标记只表示一个值。

The `%` and `@` sigils in Raku generally indicate multiple values to an iteration construct, whereas the `$` sigil indicates only one value.

```Raku
my @a = 1, 2, 3;
for @a { };         # 3 iterations 
my $a = (1, 2, 3);
for $a { };         # 1 iteration 
```

`@` 标记的变量在列表上下文中不展开。

`@`-sigiled variables do not flatten in list context:

```Raku
my @a = 1, 2, 3;
my @b = @a, 4, 5;
say @b.elems;               # OUTPUT: «3
» 
```

有一些操作可以展开不在标量容器中的子列表：解包参数（`*@a`）和显式调用 `flat`:

There are operations that flatten out sublists that are not inside a scalar container: slurpy parameters (`*@a`) and explicit calls to `flat`:

```Raku
my @a = 1, 2, 3;
say (flat @a, 4, 5).elems;  # OUTPUT: «5
» 
 
sub f(*@x) { @x.elems };
say f @a, 4, 5;             # OUTPUT: «5
» 
```

你也可以使用 `|` 生成一个 [Slip](https://docs.raku.org/type/Slip)，将一个列表引入另一个。

You can also use `|` to create a [Slip](https://docs.raku.org/type/Slip), introducing a list into the other.

```Raku
my @l := 1, 2, (3, 4, (5, 6)), [7, 8, (9, 10)];
say (|@l, 11, 12);    # OUTPUT: «(1 2 (3 4 (5 6)) [7 8 (9 10)] 11 12)
» 
say (flat @l, 11, 12) # OUTPUT: «(1 2 3 4 5 6 7 8 (9 10) 11 12)
» 
```

在第一种情况下，`@l` 的每个元素都会*滑入*结果列表作为相应的元素。`flat` 函数*扁平化*包括所包含数组元素的所有元素，除了 `(9 10)`。
`flat` 函数*展开*所有元素，包括包含数组的元素，除了 `(9 10)`。

In the first case, every element of `@l` is *slipped* as the corresponding elements of the resulting list. `flat`, in the other hand, *flattens* all elements including the elements of the included array, except for `(9 10)`.

如上所述，标量容器阻止展开

As hinted above, scalar containers prevent that flattening:

```Raku
sub f(*@x) { @x.elems };
my @a = 1, 2, 3;
say f $@a, 4, 5;            # OUTPUT: «3
» 
```

`@` 字符也可以用做前缀来强制参数转为列表，从而移除标量容器。

The `@` character can also be used as a prefix to coerce the argument to a list, thus removing a scalar container:

```Raku
my $x = (1, 2, 3);
.say for @$x;               # 3 iterations 
```

但是*去容器化*操作符 `<>` 更适合用来对非列表的条目去容器化。

However, the *decont* operator `<>` is more appropriate to decontainerize items that aren't lists:

```Raku
my $x = ^Inf .grep: *.is-prime;
say "$_ is prime" for @$x;  # WRONG! List keeps values, thus leaking memory 
say "$_ is prime" for $x<>; # RIGHT. Simply decontainerize the Seq 
 
my $y := ^Inf .grep: *.is-prime; # Even better; no Scalars involved at all 
```

方法通常不关心他们的调用者是否在标量里。

Methods generally don't care whether their invocant is in a scalar, so

```Raku
my $x = (1, 2, 3);
$x.map(*.say);              # 3 iterations 
```

映射三个元素的列表，而不是一个。

maps over a list of three elements, not of one.

<a id="自引用数据--self-referential-data"></a>
# 自引用数据 / Self-referential data

容器类型，包括 `Array` 和 `Hash`，允许你创建自引用结构。

Containers types, including `Array` and `Hash`, allow you to create self-referential structures.

```Raku
my @a;
@a[0] = @a;
put @a.perl;
# OUTPUT: «((my @Array_75093712) = [@Array_75093712,])
» 
```

尽管 Raku 不会阻止你创建和使用自引用数据，但是这样做可能会导致你陷入一个试图转储数据的循环中。万不得已，你可以使用 Promises 来[处理](https://docs.raku.org/type/promise-method-in)超时。

Although Raku does not prevent you from creating and using self-referential data, by doing so you may end up in a loop trying to dump the data. As a last resort, you can use Promises to [handle](https://docs.raku.org/type/Promise#method_in) timeouts.

<a id="类型约束--type-constraints"></a>
# 类型约束 / Type constraints

任何容器都有[类型对象](https://docs.raku.org/language/typesystem#Type_objects)或者[子集](https://docs.raku.org/language/typesystem#subset)形式的类型约束。两者都可以放在声明符合变量名中间或者在特性 [of] (https://docs.raku.org/type/Variable#trait_is_dynamic) 之后。约束是变量而非容器的属性。

Any container can have a type constraint in the form of a [type object](https://docs.raku.org/language/typesystem#Type_objects) or a [subset](https://docs.raku.org/language/typesystem#subset). Both can be placed between a declarator and the variable name or after the trait [of](https://docs.raku.org/type/Variable#trait_is_dynamic). The constraint is a property of the variable, not the container.

```Raku
subset Three-letter of Str where .chars == 3;
my Three-letter $acronym = "ÞFL";
```

这个例子中，类型约束是子集 `Three-letter`，

In this case, the type constraint is the (compile-type defined) subset `Three-letter`.

变量中可能没有容器，但是仍然具有再绑定的能力以及对再绑定进行类型检查。因为在那种情况中绑定运算符 [:=](https://docs.raku.org/language/operators#infix_%3A%3D) 执行了类型检查：

Variables may have no container in them, yet still offer the ability to re-bind and typecheck that rebind. The reason for that is in such cases the binding operator [:=](https://docs.raku.org/language/operators#infix_%3A%3D) performs the typecheck:

```Raku
my Int \z = 42;
z := 100; # OK 
z := "x"; # Typecheck failure 
```

当绑定至 [Hash] 键时，情况又有所不同，因为绑定是被一个方法调用处理的（尽管语法仍旧不变，使用 `:=` 操作符）。

The same isn't the case when, say, binding to a [Hash](https://docs.raku.org/type/Hash) key, as the binding is then handled by a method call (even though the syntax remains the same, using `:=` operator).

`Scalar` 容器的默认类型约束是 [Mu](https://docs.raku.org/type/Mu)。容器的类型约束反省是由 `.VAR.of` 方法提供的，对于 `@` 和 `％` 标记的变量给出了值的约束：

The default type constraint of a `Scalar` container is [Mu](https://docs.raku.org/type/Mu). Introspection of type constraints on containers is provided by `.VAR.of` method, which for `@` and `%` sigiled variables gives the constraint for values:

```Raku
my Str $x;
say $x.VAR.of;  # OUTPUT: «(Str)
» 
my Num @a;
say @a.VAR.of;  # OUTPUT: «(Num)
» 
my Int %h;
say %h.VAR.of;  # OUTPUT: «(Int)
» 
```

<a id="已定义约束--definedness-constraints"></a>
## `已定义`约束 / Definedness constraints

容器还可以强制变量是已定义的。在声明中加一个类型表情符号：

A container can also enforce a variable to be defined. Put a smiley in the declaration:

```Raku
my Int:D $def = 3;
say $def;   # OUTPUT: «3
» 
$def = Int; # Typecheck failure 
```

你还需要初始化声明中的变量，毕竟它不能是未定义的。

You'll also need to initialize the variable in the declaration, it can't be left undefined after all.

也可以使用[默认已定义变量的指令](https://docs.raku.org/language/variables#Default_defined_variables_pragma)在作用域中声明的所有变量中强制实施此约束。来自其他语言的人会想看看，可能他们的变量总是定义的。

It's also possible to have this constraint enforced in all variables declared in a scope with the [default defined variables pragma](https://docs.raku.org/language/variables#Default_defined_variables_pragma). People coming from other languages where variables are always defined will want to have a look.

<a id="自定义容器--custom-containers"></a>
# 自定义容器 / Custom containers

为了提供自定义容器，Raku 提供了 `Proxy` 类。它接受两个方法，从容器中提取值或存储到容器时调用。类型检查不是由容器本身完成的并且其他限制如只读可能会被打破。因此，返回值的类型必须与它绑定到的变量的类型相同。我们可以使用类型捕获来处理 Raku 中的类型。

To provide custom containers Raku provides the class `Proxy`. It takes two methods that are called when values are stored or fetched from the container. Type checks are not done by the container itself and other restrictions like readonlyness can be broken. The returned value must therefore be of the same type as the type of the variable it is bound to. We can use type captures to work with types in Raku.

```Raku
sub lucky(::T $type) {
    my T $c-value; # closure variable 
    return Proxy.new(
        FETCH => method () { $c-value },
        STORE => method (T $new-value) {
            X::OutOfRange.new(what => 'number', got => '13', range => '-∞..12, 14..∞').throw
                if $new-value == 13;
            $c-value = $new-value;
        }
    );
}
 
my Int $a := lucky(Int);
say $a = 12;    # OUTPUT: «12
» 
say $a = 'FOO'; # X::TypeCheck::Binding 
say $a = 13;    # X::OutOfRange 
CATCH { default { say .^name, ': ', .Str } };
```