原文：https://docs.perl6.org/language/mop

# 元对象协议 / Meta-object protocol (MOP)

内省与 Perl 6 对象系统

Introspection and the Perl 6 object system

Perl 6 构建在一个元对象层上。这意味着有一些*元对象*控制各种面向对象的构造（如类、角色、方法、属性或枚举）的行为。

Perl 6 is built on a meta object layer. That means that there are objects (the *meta objects*) that control how various object-oriented constructs (such as classes, roles, methods, attributes or enums) behave.

当需要一个普通对象的类型时，元对象对用户有实际的好处。例如：

The meta object has a practical benefit to the user when a normal object's type is needed. For example:

```Perl6
my $arr = [1, 2];
sub show-type($arr) {
    my $type = $arr.^name;
    say $type;
}
show-type $arr; # OUTPUT: «Array␤» 
```

为了更深入地理解 `class` 的元对象，这里有一个重复两次的示例：一次在 Perl 6 中作为普通声明，一次通过[元模型](https://docs.perl6.org/type/Metamodel::ClassHOW)表示：

To get a more in-depth understanding of the meta object for a `class`, here is an example repeated twice: once as normal declarations in Perl 6, and once expressed through the [meta model](https://docs.perl6.org/type/Metamodel::ClassHOW):

```Perl6
class A {
    method x() { say 42 }
}
 
A.x();
```

相当于：

corresponds to:

```Perl6
constant A := Metamodel::ClassHOW.new_type( name => 'A' );  # class A { 
A.^add_method('x', my method x(A:) { say 42 });             #   method x() 
A.^compose;                                                 # } 
 
A.x();
```

（除了声明性表单在编译时执行，而后一个形式不执行）。

(except that the declarative form is executed at compile time, and the latter form does not).

对象后面的元对象可以通过 `$obj.HOW` 获得，其中 HOW 代表高阶运作（或者，*这是如何工作的？*）。

The meta object behind an object can be obtained with `$obj.HOW`, where HOW stands for Higher Order Workings (or, *HOW the \*%@$ does this work?*).

这里，'.^' 的调用是对元对象的调用，因此，`A.^compose` 是 `A.HOW.compose(A)` 的快捷方式。调用者也被传递到参数列表中，以便支持原型样式类型系统，其中只有一个元对象（而不是每个类型一个元对象，就像标准 Perl 6 那样）。

Here, the calls with `.^` are calls to the meta object, so `A.^compose` is a shortcut for `A.HOW.compose(A)`. The invocant is passed in the parameter list as well, to make it possible to support prototype-style type systems, where there is just one meta object (and not one meta object per type, as standard Perl 6 does it).

如上面的例子所示，所有面向对象的特性对用户都是可用的，而不仅仅是编译器。事实上，编译器只是使用这些对元对象的调用。

As the example above demonstrates, all object oriented features are available to the user, not just to the compiler. In fact the compiler just uses such calls to meta objects.

# 元方法 / Metamethods

这些是类似于方法调用的自省宏。

These are introspective macros that resemble method calls.

元方法通常以全大写命名，并且它被认为是避免使用全大写名称创建自己的方法的好样式。这将避免与该语言未来版本中可能出现的任何元方法发生冲突。

Metamethods are generally named with ALLCAPS, and it is considered good style to avoid creating your own methods with ALLCAPS names. This will avoid conflicts with any metamethods that may appear in future versions of the language.

## WHAT

类型的类型对象。这是一个可以在不产生错误或警告的情况下重载的伪方法，但将被忽略。

The type object of the type. This is a pseudo-method that can be overloaded without producing error or warning, but will be ignored.

例如 `42.WHAT` 返回 `Int` 类型的对象。

For example `42.WHAT` returns the `Int` type object.

## WHICH

对象的标识值。这可用于散列和身份比较，以及如何实现 `===` 中缀运算符。

The object's identity value. This can be used for hashing and identity comparison, and is how the `===` infix operator is implemented.

## WHO

支持该对象的包。

The package supporting the object.

## WHERE

对象的内存地址。注意，在使用移动/压缩垃圾收集器的实现中，这是不稳定的。使用 `WHICH` 作为稳定的标识指示器。

The memory address of the object. Note that this is not stable in implementations with moving/compacting garbage collectors. Use `WHICH` for a stable identity indicator.

## HOW

返回元类对象，如“高阶运作”。

Returns the metaclass object, as in "Higher Order Workings".

```Perl6
say (%).HOW.^name # OUTPUT: «Perl6::Metamodel::ClassHOW+{<anon>}␤» 
```

在本例中，`HOW` 返回类型为 `Perl6::Metamodel::ClassHOW` 的对象；此类型的对象用于生成类。对 `&` 标记的相同操作将返回 `Perl6::Metamodel::ParametricRoleGroupHOW`。每当使用 `^` 语法访问元方法时，都将调用此对象。实际上，上面的代码相当于 `say (&).HOW.HOW.name(&)`，这更难理解。[Metamodel::ClassHOW](https://docs.perl6.org/type/Metamodel::ClassHOW) 是 Rakudo 实现的一部分，因此请谨慎使用。

`HOW` returns an object of type `Perl6::Metamodel::ClassHOW` in this case; objects of this type are used to build classes. The same operation on the `&` sigil will return `Perl6::Metamodel::ParametricRoleGroupHOW`. You will be calling this object whenever you use the `^` syntax to access meta methods. In fact, the code above is equivalent to `say (&).HOW.HOW.name(&)` which is much more unwieldy. [Metamodel::ClassHOW](https://docs.perl6.org/type/Metamodel::ClassHOW) is part of the Rakudo implementation, so use with caution.

## WHY

附加的 Pod 值。

The attached Pod value.

## DEFINITE

对象具有有效的具体表示形式。这是一种虚假的方法，可以被覆盖而不产生错误或警告，但将被忽视。

The object has a valid concrete representation. This is a pseudo-method that can be overloaded without producing error or warning, but will be ignored.

为实例返回 `True`，为类型对象返回 `False`。

Returns `True` for instances and `False` for type objects.

## VAR

返回隐含的 `Scalar` 对象（如果有）。

Returns the underlying `Scalar` object, if there is one.

`Scalar` 对象的存在表示该对象已“逐项化”，变为单数了。

The presence of a `Scalar` object indicates that the object is "itemized".

```Perl6
.say for (1, 2, 3);           # OUTPUT: «1␤2␤3␤», not itemized 
.say for $(1, 2, 3);          # OUTPUT: «(1 2 3)␤», itemized 
say (1, 2, 3).VAR ~~ Scalar;  # OUTPUT: «False␤» 
say $(1, 2, 3).VAR ~~ Scalar; # OUTPUT: «True␤» 
```

# 元对象系统的结构 / Structure of the meta object system

**注：**本文档主要反映了由[Rakudo Perl 6编译器](https://rakudo.org/)实现的元对象系统，因为 [设计文档](https://design.perl6.org/) 非常详细。

**Note:** this documentation largely reflects the meta object system as implemented by the [Rakudo Perl 6 compiler](https://rakudo.org/), since the [design documents](https://design.perl6.org/) are very light on details.

对于每个类型声明符关键字，例如 `class`、 `role`、 `enum`、 `module`、 `package`、 `grammar` 或 `subset`，在 `Metamodel::` 命名空间中都有一个单独的元类。（Rakudo 在 `Perl6::Metamodel::` 命名空间中实现它们，然后将 `Perl6::Metamodel` 映射到 `Metamodel`）。

For each type declarator keyword, such as `class`, `role`, `enum`, `module`, `package`, `grammar` or `subset`, there is a separate meta class in the `Metamodel::` namespace. (Rakudo implements them in the `Perl6::Metamodel::` namespace, and then maps `Perl6::Metamodel` to `Metamodel`).

这些元类中的许多都具有相同的功能。例如，角色、 grammar 和类都可以包含方法和属性，还可以扮演角色。这个共享功能是在组成适当的元类的角色中实现的。例如 [role Metamodel::RoleContainer](https://docs.perl6.org/type/Metamodel::RoleContainer) 实现了类型可以拥有角色的功能，而 [Metamodel::ClassHOW](https://docs.perl6.org/type/Metamodel::ClassHOW) 是关键字 `class` 后面的元类，它实现了这个角色。

Many of the these meta classes share common functionality. For example roles, grammars and classes can all contain methods and attributes, as well as being able to do roles. This shared functionality is implemented in roles which are composed into the appropriate meta classes. For example [role Metamodel::RoleContainer](https://docs.perl6.org/type/Metamodel::RoleContainer) implements the functionality that a type can hold roles and [Metamodel::ClassHOW](https://docs.perl6.org/type/Metamodel::ClassHOW), which is the meta class behind the `class` keyword, does this role.

大多数元类都有一个 `compose` 方法，在创建或修改完元对象后必须调用该方法。它创建方法缓存、验证事物等等，如果忘记调用它，就会发生奇怪的行为，所以不要：-）。

Most meta classes have a `compose` method that you must call when you're done creating or modifying a meta object. It creates method caches, validates things and so on, and weird behavior ensues if you forget to call it, so don't :-).

## 自举问题 / Bootstrapping concerns

您可能想知道，当 `Metamodel::ClassHOW` 定义为类时，`Metamodel::ClassHOW` 是如何成为类的，或者负责角色处理的角色是如何成为角色的。答案是*魔法*。

You might wonder how `Metamodel::ClassHOW` can be a class, when being a class is defined in terms of `Metamodel::ClassHOW`, or how the roles responsible for role handling can be roles. The answer is *by magic*.

只是开个玩笑。引导是特定于实现的。Rakudo 是通过使用实现它自己的语言的对象系统来实现的，它恰好（几乎）是 Perl 6: NQP 的一个子集，Not Quite Perl。NQP 有一个名为 `knowhow` 的类似类的原始类，用于引导其自己的类和角色实现。`knowhow` 是建立在 NQP 下虚拟机提供的原语之上。

Just kidding. Bootstrapping is implementation specific. Rakudo does it by using the object system of the language in which itself is implemented, which happens to be (nearly) a subset of Perl 6: NQP, Not Quite Perl. NQP has a primitive, class-like kind called `knowhow`, which is used to bootstrap its own classes and roles implementation. `knowhow` is built on primitives that the virtual machine under NQP provides.

Since the object model is bootstrapped in terms of lower-level types, introspection can sometimes return low-level types instead of the ones you expect, like an NQP-level routine instead of a normal [Routine](https://docs.perl6.org/type/Routine) object, or a bootstrap-attribute instead of [Attribute](https://docs.perl6.org/type/Attribute).

## Composition time and static reasoning

In Perl 6, a type is constructed as it is parsed, so in the beginning, it must be mutable. However if all types were always mutable, all reasoning about them would get invalidated at any modification of a type. For example the list of parent types and thus the result of type checking can change during that time.

So to get the best of both worlds, there is a time when a type transitions from mutable to immutable. This is called *composition*, and for syntactically declared types, it happens when the type declaration is fully parsed (so usually when the closing curly brace is parsed).

If you create types through the meta-object system directly, you must call `.^compose` on them before they become fully functional.

Most meta classes also use composition time to calculate some properties like the method resolution order, publish a method cache, and other house-keeping tasks. Meddling with types after they have been composed is sometimes possible, but usually a recipe for disaster. Don't do it.

## Power and responsibility

The meta object protocol offers much power that regular Perl 6 code intentionally limits, such as calling private methods on classes that don't trust you, peeking into private attributes, and other things that usually simply aren't done.

Regular Perl 6 code has many safety checks in place; not so the meta model. It is close to the underlying virtual machine, and violating the contracts with the VM can lead to all sorts of strange behaviors that, in normal code, would obviously be bugs.

So be extra careful and thoughtful when writing meta types.

## Power, convenience and pitfalls

The meta object protocol is designed to be powerful enough to implement the Perl 6 object system. This power occasionally comes at the cost of convenience.

For example, when you write `my $x = 42` and then proceed to call methods on `$x`, most of these methods end up acting on the [integer](https://docs.perl6.org/type/Int) 42, not on the [scalar container](https://docs.perl6.org/type/Scalar) in which it is stored. This is a piece of convenience found in ordinary Perl 6. Many parts of the meta object protocol cannot afford to offer the convenience of automatically ignoring scalar containers, because they are used to implement those scalar containers as well. So if you write `my $t = MyType; ... ; $t.^compose` you are composing the Scalar that the `$`-sigiled variable implies, not `MyType`.

The consequence is that you need to have a rather detailed understanding of the subtleties of Perl 6 in order to avoid pitfalls when working with the MOP, and can't expect the same "do what I mean" convenience that ordinary Perl 6 code offers.