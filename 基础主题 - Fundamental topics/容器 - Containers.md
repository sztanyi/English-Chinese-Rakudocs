# 容器 Containers

Perl 6 容器的底层解释

A low-level explanation of Perl 6 containers

本节解释处理变量和容器元素所涉及的间接级别。介绍了 Perl6 中使用的容器的不同类型，以及适用于这些容器的操作，如分配、绑定和展平。最后讨论了更高级的主题，如自引用数据、类型约束和自定义容器。

This section explains the levels of indirection involved in dealing with variables and container elements. The difference types of containers used in Perl 6 are explained and the actions applicable to them like assigning, binding and flattening. More advanced topics like self-referential data, type constraints and custom containers are discussed at the end.

# [变量是什么（What is a variable?）](https://docs.perl6.org/language/containers#___top)

有些人喜欢说“一切都是一个对象”，但实际上在 Perl6 中，变量不是用户公开的对象。

Some people like to say "everything is an object", but in fact a variable is not a user-exposed object in Perl 6.

当编译器遇到类似 `my $x` 的变量声明时，它会将其注册到一些内部符号表中。此内部符号表用于检测未声明的变量，并将变量的代码生成与正确的范围相关联。

When the compiler encounters a variable declaration like `my $x`, it registers it in some internal symbol table. This internal symbol table is used to detect undeclared variables and to tie the code generation for the variable to the correct scope.

在运行时，变量在*词法板*（或简称 *lexpad*）中显示为条目。这是一个按作用域的数据结构，它为每个变量存储一个指针。

At runtime, a variable appears as an entry in a *lexical pad*, or *lexpad* for short. This is a per-scope data structure that stores a pointer for each variable.

在 `my $x` 的情况下，变量 `$x` 的词法板条目是指向 `Scalar` 类型的对象的指针，通常称为*容器*。

In the case of `my $x`, the lexpad entry for the variable `$x` is a pointer to an object of type `Scalar`, usually just called *the container*.

# [标量容器 （Scalar containers）](https://docs.perl6.org/language/containers#___top)

尽管在 Perl6 中，[`Scalar`] 类型的对象(https://docs.perl6.org/type/scalar)随处可见，但你很少见它们直接作为对象，因为大多数操作时*反容器化*的，这意味着它们作用于 `scalar` 容器的内容，而不是容器本身。

Although objects of type [`Scalar`](https://docs.perl6.org/type/Scalar) are everywhere in Perl 6, you rarely see them directly as objects, because most operations *decontainerize*, which means they act on the `Scalar` container's contents instead of the container itself.

在代码中

In code like

```Perl6
my $x = 42;
say $x;
```

赋值语句 `$x = 42` 将指向 `Int` 对象 42 的指针存储在标量容器中，其中 `$x` 的词法板条目指向该标量容器。

the assignment `$x = 42` stores a pointer to the `Int` object 42 in the scalar container to which the lexpad entry for `$x` points.

赋值运算符要求左侧的容器存储其右侧的值。这究竟意味着什么取决于容器类型。对于 `Scalar`，它的意思是“用新值替换先前存储的值”。

The assignment operator asks the container on the left to store the value on its right. What exactly that means is up to the container type. For `Scalar` it means "replace the previously stored value with the new one".

注意，子程序签名允许传递容器：

Note that subroutine signatures allow passing around of containers:

```Perl6
sub f($a is rw) {
    $a = 23;
}
my $x = 42;
f($x);
say $x;         # OUTPUT: «23␤» 
```

在子例程中，`$a` 的词法板条目指向与 `$x` 指向子例程外部的相同容器。这就是为什么赋值给 `$a` 也会修改 `$x` 的内容。

Inside the subroutine, the lexpad entry for `$a` points to the same container that `$x` points to outside the subroutine. Which is why assignment to `$a` also modifies the contents of `$x`.

同样，如果标记为 `is rw`，则例程可以返回容器：

Likewise a routine can return a container if it is marked as `is rw`:

```Perl6
my $x = 23;
sub f() is rw { $x };
f() = 42;
say $x;         # OUTPUT: «42␤» 
```

对于显式返回，必须使用  `return-rw` 而不是 `return`。

For explicit returns, `return-rw` instead of `return` must be used.

返回容器是 `rw` 属性访问器的工作方式。所以

Returning a container is how `is rw` attribute accessors work. So

```Perl6
class A {
    has $.attr is rw;
}
```

等同于

is equivalent to

```Perl6
class A {
    has $!attr;
    method attr() is rw { $!attr }
}
```

标量容器对于类型检查和大多数只读访问都是透明的。`.var` 使它们可见：

Scalar containers are transparent to type checks and most kinds of read-only accesses. A `.VAR` makes them visible:

```Perl6
my $x = 42;
say $x.^name;       # OUTPUT: «Int␤» 
say $x.VAR.^name;   # OUTPUT: «Scalar␤» 
```

参数上的 `is rw` 要求可写的标量容器：

And `is rw` on a parameter requires the presence of a writable Scalar container:

```Perl6
sub f($x is rw) { say $x };
f 42;
CATCH { default { say .^name, ': ', .Str } };
# OUTPUT: «X::Parameter::RW: Parameter '$x' expected a writable container, but got Int value␤» 
```

# [可调用容器（Callable containers）](https://docs.perl6.org/language/containers#___top)

可调用容器在存储在容器中的对象的 [Routine](https://docs.perl6.org/type/routine) 调用的语法和方法 [CALL-ME](https://docs.perl6.org/type/callable method_call-me) 的实际调用之间提供了一个桥梁。声明容器时需要 `&` 标记并且在执行 `Callable` 时必须省略。默认类型约束为 [Callable](https://docs.perl6.org/type/callable)。

Callable containers provide a bridge between the syntax of a [Routine](https://docs.perl6.org/type/Routine) call and the actual call of the method [CALL-ME](https://docs.perl6.org/type/Callable#method_CALL-ME) of the object that is stored in the container. The sigil `&` is required when declaring the container and has to be omitted when executing the `Callable`. The default type constraint is [Callable](https://docs.perl6.org/type/Callable).

```Perl6
my &callable = -> $ν { say "$ν is", $ν ~~ Int??" whole"!!" not whole" }
callable( ⅓ );
callable( 3 );
```

引用存储在容器中的值时必须带标记。这反过来又允许将  `Routine` 用作[参数](https://docs.perl6.org/type/Signature#Constraining_signature_s_of_Callables)调用。

The sigil has to be provided when referring to the value stored in the container. This in turn allows `Routine`s to be used as [arguments](https://docs.perl6.org/type/Signature#Constraining_signatures_of_Callables) to calls.

```Perl6
sub f() {}
my &g = sub {}
sub caller(&c1, &c2){ c1, c2 }
caller(&f, &g);
```

# [绑定（Binding）](https://docs.perl6.org/language/containers#___top)

除了赋值之外，Perl6 还支持带 `：=` 运算符的*绑定*。将值或容器绑定到变量时，将修改变量的词法板条目（而不仅仅是它指向的容器）。如果你写:

Next to assignment, Perl 6 also supports *binding* with the `:=` operator. When binding a value or a container to a variable, the lexpad entry of the variable is modified (and not just the container it points to). If you write

```Perl6
my $x := 42;
```
那么 `$x` 的词法板条目指向 `Int` 42。意味着你无法再给它赋值。
then the lexpad entry for `$x` directly points to the `Int` 42. Which means that you cannot assign to it anymore:

```Perl6
my $x := 42;
$x = 23;
CATCH { default { say .^name, ': ', .Str } };
# OUTPUT: «X::AdHoc: Cannot assign to an immutable value␤» 
```

也可以绑定到其他变量：

You can also bind variables to other variables:

```Perl6
my $a = 0;
my $b = 0;
$a := $b;
$b = 42;
say $a;         # OUTPUT: «42␤» 
```

在绑定后，`$a` 和 `$b` 的词法板条目指向相同的标量容器，因此给一个变量赋值也会改变另一个变量的内容。

Here, after the initial binding, the lexpad entries for `$a` and `$b` both point to the same scalar container, so assigning to one variable also changes the contents of the other.

这种情形你之前也见到过：标记为 `is rw` 的签名参数正是如此。

You've seen this situation before: it is exactly what happened with the signature parameter marked as `is rw`.

无符号变量以及带 `is raw` 特性的参数始终绑定（无论使用 `=` 还是 `:=`）:

Sigilless variables and parameters with the trait `is raw` always bind (whether `=` or `:=` is used):

```Perl6
my $a = 42;
my \b = $a;
b++;
say $a;         # OUTPUT: «43␤» 
 
sub f($c is raw) { $c++ }
f($a);
say $a;         # OUTPUT: «44␤» 
```

# [标量容器和列表（Scalar containers and listy things）](https://docs.perl6.org/language/containers#___top)

Perl6 中有许多语义稍有不同的位置容器类型。最基本的是 [List](https://docs.perl6.org/type/list)；它是由逗号操作符创建的。

There are a number of positional container types with slightly different semantics in Perl 6. The most basic one is [List](https://docs.perl6.org/type/List); it is created by the comma operator.

```Perl6
say (1, 2, 3).^name;    # OUTPUT: «List␤» 
```

列表是不可变的，这意味着您不能更改列表中的元素数。但是，如果其中一个元素恰好是一个标量容器，你仍然可以给它赋值：

A list is immutable, which means you cannot change the number of elements in a list. But if one of the elements happens to be a scalar container, you can still assign to it:

```Perl6
my $x = 42;
($x, 1, 2)[0] = 23;
say $x;                 # OUTPUT: «23␤» 
($x, 1, 2)[1] = 23;     # Cannot modify an immutable value 
CATCH { default { say .^name, ': ', .Str } };
# OUTPUT: «X::Assignment::RO: Cannot modify an immutable Int␤» 
```

因此列表不关心它的元素时值还是容器，它们只存储和检索给它们的任何东西。

So the list doesn't care about whether its elements are values or containers, they just store and retrieve whatever was given to them.

列表也可以是惰性的；在这种情况下，末尾的元素是根据需要从迭代器生成的。

Lists can also be lazy; in that case, elements at the end are generated on demand from an iterator.

`数组` 类似列表，除了它强制其所有元素都时容器，着意味着你可以始终给其中的元素赋值：

An `Array` is just like a list, except that it forces all its elements to be containers, which means that you can always assign to elements:

```Perl6
my @a = 1, 2, 3;
@a[0] = 42;
say @a;         # OUTPUT: «[42 2 3]␤» 
```

`@a` 实际上存储了三个标量变量。`@a[0]` 返回其中的一个，赋值符号将容器内的值替换成新的 `42`。

`@a` actually stores three scalar containers. `@a[0]` returns one of them, and the assignment operator replaces the integer value stored in that container with the new one, `42`.

# [赋值以及绑定至数组变量（Assigning and binding to array variables）](https://docs.perl6.org/language/containers#___top)

给标量以及数组变量赋值都做的同一件事情：舍弃旧值并输入新值。

Assignment to a scalar variable and to an array variable both do the same thing: discard the old value(s), and enter some new value(s).

尽管如此，很容易观察到它们有多不同：

Nevertheless, it's easy to observe how different they are:

```Perl6
my $x = 42; say $x.^name;   # OUTPUT: «Int␤» 
my @a = 42; say @a.^name;   # OUTPUT: «Array␤» 
```

This is because the `Scalar` container type hides itself well, but `Array` makes no such effort. Also assignment to an array variable is coercive, so you can assign a non-array value to an array variable.

To place a non-`Array` into an array variable, binding works:

```Perl6
my @a := (1, 2, 3);
say @a.^name;               # OUTPUT: «List␤» 
```

# [Binding to array elements](https://docs.perl6.org/language/containers#___top)

As a curious side note, Perl 6 supports binding to array elements:

```
my @a = (1, 2, 3);
@a[0] := my $x;
$x = 42;
say @a;                     # OUTPUT: «[42 2 3]␤» 
```

If you've read and understood the previous explanations, it is now time to wonder how this can possibly work. After all, binding to a variable requires a lexpad entry for that variable, and while there is one for an array, there aren't lexpad entries for each array element, because you cannot expand the lexpad at runtime.

The answer is that binding to array elements is recognized at the syntax level and instead of emitting code for a normal binding operation, a special method (called `BIND-KEY`) is called on the array. This method handles binding to array elements.

Note that, while supported, one should generally avoid directly binding uncontainerized things into array elements. Doing so may produce counter-intuitive results when the array is used later.

```
my @a = (1, 2, 3);
@a[0] := 42;         # This is not recommended, use assignment instead. 
my $b := 42;
@a[1] := $b;         # Nor is this. 
@a[2] = $b;          # ...but this is fine. 
@a[1, 2] := 1, 2;    # runtime error: X::Bind::Slice 
CATCH { default { say .^name, ': ', .Str } };
# OUTPUT: «X::Bind::Slice: Cannot bind to Array slice␤» 
```

Operations that mix Lists and Arrays generally protect against such a thing happening accidentally.

# [Flattening, items and containers](https://docs.perl6.org/language/containers#___top)

The `%` and `@` sigils in Perl 6 generally indicate multiple values to an iteration construct, whereas the `$` sigil indicates only one value.

```
my @a = 1, 2, 3;
for @a { };         # 3 iterations 
my $a = (1, 2, 3);
for $a { };         # 1 iteration 
```

`@`-sigiled variables do not flatten in list context:

```
my @a = 1, 2, 3;
my @b = @a, 4, 5;
say @b.elems;               # OUTPUT: «3␤» 
```

There are operations that flatten out sublists that are not inside a scalar container: slurpy parameters (`*@a`) and explicit calls to `flat`:

```
my @a = 1, 2, 3;
say (flat @a, 4, 5).elems;  # OUTPUT: «5␤» 
 
sub f(*@x) { @x.elems };
say f @a, 4, 5;             # OUTPUT: «5␤» 
```

You can also use `|` to create a [Slip](https://docs.perl6.org/type/Slip), introducing a list into the other.

```
my @l := 1, 2, (3, 4, (5, 6)), [7, 8, (9, 10)];
say (|@l, 11, 12);    # OUTPUT: «(1 2 (3 4 (5 6)) [7 8 (9 10)] 11 12)␤» 
say (flat @l, 11, 12) # OUTPUT: «(1 2 3 4 5 6 7 8 (9 10) 11 12)␤» 
```

In the first case, every element of `@l` is *slipped* as the corresponding elements of the resulting list. `flat`, in the other hand, *flattens* all elements including the elements of the included array, except for `(9 10)`.

As hinted above, scalar containers prevent that flattening:

```
sub f(*@x) { @x.elems };
my @a = 1, 2, 3;
say f $@a, 4, 5;            # OUTPUT: «3␤» 
```

The `@` character can also be used as a prefix to coerce the argument to a list, thus removing a scalar container:

```
my $x = (1, 2, 3);
.say for @$x;               # 3 iterations 
```

However, the *decont* operator `<>` is more appropriate to decontainerize items that aren't lists:

```
my $x = ^Inf .grep: *.is-prime;
say "$_ is prime" for @$x;  # WRONG! List keeps values, thus leaking memory 
say "$_ is prime" for $x<>; # RIGHT. Simply decontainerize the Seq 
 
my $y := ^Inf .grep: *.is-prime; # Even better; no Scalars involved at all 
```

Methods generally don't care whether their invocant is in a scalar, so

```
my $x = (1, 2, 3);
$x.map(*.say);              # 3 iterations 
```

maps over a list of three elements, not of one.

# [Self-referential data](https://docs.perl6.org/language/containers#___top)

Containers types, including `Array` and `Hash`, allow you to create self-referential structures.

```
my @a;
@a[0] = @a;
put @a.perl;
# OUTPUT: «((my @Array_75093712) = [@Array_75093712,])␤» 
```

Although Perl 6 does not prevent you from creating and using self-referential data, by doing so you may end up in a loop trying to dump the data. As a last resort, you can use Promises to [handle](https://docs.perl6.org/type/Promise#method_in) timeouts.

# [Type constraints](https://docs.perl6.org/language/containers#___top)

Any container can have a type constraint in the form of a [type object](https://docs.perl6.org/language/typesystem#Type_objects) or a [subset](https://docs.perl6.org/language/typesystem#subset). Both can be placed between a declarator and the variable name or after the trait [of](https://docs.perl6.org/type/Variable#trait_is_dynamic). The constraint is a property of the variable, not the container.

```
subset Three-letter of Str where .chars == 3;
my Three-letter $acronym = "ÞFL";
```

In this case, the type constraint is the (compile-type defined) subset `Three-letter`.

Variables may have no container in them, yet still offer the ability to re-bind and typecheck that rebind. The reason for that is in such cases the binding operator [:=](https://docs.perl6.org/language/operators#infix_%3A%3D) performs the typecheck:

```
my Int \z = 42;
z := 100; # OK 
z := "x"; # Typecheck failure 
```

The same isn't the case when, say, binding to a [Hash](https://docs.perl6.org/type/Hash) key, as the binding is then handled by a method call (even though the syntax remains the same, using `:=` operator).

The default type constraint of a `Scalar` container is [Mu](https://docs.perl6.org/type/Mu). Introspection of type constraints on containers is provided by `.VAR.of` method, which for `@` and `%` sigiled variables gives the constraint for values:

```
my Str $x;
say $x.VAR.of;  # OUTPUT: «(Str)␤» 
my Num @a;
say @a.VAR.of;  # OUTPUT: «(Num)␤» 
my Int %h;
say %h.VAR.of;  # OUTPUT: «(Int)␤» 
```

## [Definedness constraints](https://docs.perl6.org/language/containers#___top)

A container can also enforce a variable to be defined. Put a smiley in the declaration:

```
my Int:D $def = 3;
say $def;   # OUTPUT: «3␤» 
$def = Int; # Typecheck failure 
```

You'll also need to initialize the variable in the declaration, it can't be left undefined after all.

It's also possible to have this constraint enforced in all variables declared in a scope with the [default defined variables pragma](https://docs.perl6.org/language/variables#Default_defined_variables_pragma). People coming from other languages where variables are always defined will want to have a look.

# [Custom containers](https://docs.perl6.org/language/containers#___top)

To provide custom containers Perl 6 provides the class `Proxy`. It takes two methods that are called when values are stored or fetched from the container. Type checks are not done by the container itself and other restrictions like readonlyness can be broken. The returned value must therefore be of the same type as the type of the variable it is bound to. We can use type captures to work with types in Perl 6.

```
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
say $a = 12;    # OUTPUT: «12␤» 
say $a = 'FOO'; # X::TypeCheck::Binding 
say $a = 13;    # X::OutOfRange 
CATCH { default { say .^name, ': ', .Str } };
```