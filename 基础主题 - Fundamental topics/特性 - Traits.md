# 特性 / Traits

简化了行为的编译时规范

Compile-time specification of behavior made easy

在 Raku 中，*特性*是附加到修改其默认行为、功能或表示的对象和类的编译器钩子。作为这样的编译器钩子，它们是在编译时定义的，尽管它们可以在运行时使用。

In Raku, *traits* are compiler hooks attached to objects and classes that modify their default behavior, functionality or representation. As such compiler hooks, they are defined in compile time, although they can be used in runtime.

通过使用 `trait_mod` 关键字，一些特征已经被定义为语言或 Rakudo 编译器的一部分。下面列出并解释它们。

Several traits are already defined as part of the language or the Rakudo compiler by using the `trait_mod` keyword. They are listed, and explained, next.

<!-- MarkdownTOC -->

- [The `is` trait / `is` 特性](#the-is-trait--is-特性)
	- [`is` applied to classes. / `is` 应用与类](#is-applied-to-classes--is-应用与类)
	- [`is repr` and native representations. / `is repr` 与原生表示](#is-repr-and-native-representations--is-repr-与原生表示)
	- [`is` on routines / 例程上的 `is`](#is-on-routines--例程上的-is)

<!-- /MarkdownTOC -->

<a id="the-is-trait--is-特性"></a>
# The `is` trait / `is` 特性

其定义为

Defined as

```Raku
proto sub trait_mod:<is>(Mu $, |) {*}
```

`is` 适用于任何类型的标量对象，并且可以接受任意数量的命名参数或位置参数。它是最常用的特性，根据第一个参数的类型有以下几种形式。

`is` applies to any kind of scalar object, and can take any number of named or positional arguments. It is the most commonly used trait, and takes the following forms, depending on the type of the first argument.

<a id="is-applied-to-classes--is-应用与类"></a>
## `is` applied to classes. / `is` 应用与类

最常见的形式，包括两个类，一个正在定义，另一个已经存在，[定义父母身份](https://docs.raku.org/syntax/is). `A is B` 中，如果两者都是类，则将 A 定义为 B 的子类。

The most common form, involving two classes, one that is being defined and the other existing, [defines parenthood](https://docs.raku.org/syntax/is). `A is B`, if both are classes, defines A as a subclass of B.

[`is DEPRECATED`](https://docs.raku.org/type/Attribute#trait_is_DEPRECATED) 可以应用于类、属性或例程，将它们标记为已弃用并发出消息。

[`is DEPRECATED`](https://docs.raku.org/type/Attribute#trait_is_DEPRECATED) can be applied to classes, Attributes or Routines, marks them as deprecated and issues a message, if provided.

`is` 的几个实例直接转换为它们所引用的类的属性：`rw`、`nativesize`、`ctype`、`unsigned`、`hidden` 和 `array_type`。

Several instances of `is` are translated directly into attributes for the class they refer to: `rw`, `nativesize`, `ctype`, `unsigned`, `hidden`, `array_type`.

不可实例化的表示特性与其说是与表示相关，不如说是与特定类的操作相关；它有效地阻止了以任何可能的方式创建类的实例。

The Uninstantiable representation trait is not so much related to the representation as related to what can be done with a specific class; it effectively prevents the creation of instances of the class in any possible way.

```Raku
constant @IMM = <Innie Minnie Moe>;

class don't-instantiate is repr('Uninstantiable') {
    my $.counter;

    method imm () {
        return @IMM[ $.counter++ mod @IMM.elems ];
    }
}
say don't-instantiate.imm for ^10;
```

不可实例化的类仍然可以通过它们的类变量和方法来使用，如上所述。但是，尝试以这种方式实例化它们：`my $do-instantiate = don't-instantiate.new;` 将产生错误`不能创建此类型的实例（别实例化）`。

Uninstantiable classes can still be used via their class variables and methods, as above. However, trying to instantiate them this way: `my $do-instantiate = don't-instantiate.new;` will yield the error `You cannot create an instance of this type (don't-instantiate)`.

<a id="is-repr-and-native-representations--is-repr-与原生表示"></a>
## `is repr` and native representations. / `is repr` 与原生表示

由于 `is` 特征通常指的是应用于它们的类或对象的性质，因此它们在[原生调用](https://docs.raku.org/language/nativecall)中被广泛用来[详细说明](https://docs.raku.org/language/nativecall#Specifying_the_native_representation)通过 `is repr` 后缀指定的将要处理的数据结构。同时，`is native` 用于实际通过原生函数实现的例程。以下是可以使用的表示法：

Since the `is` trait refers, in general, to the nature of the class or object they are applied to, they are used extensively in [native calls](https://docs.raku.org/language/nativecall) to [specify the representation](https://docs.raku.org/language/nativecall#Specifying_the_native_representation) of the data structures that are going to be handled by the native functions via the `is repr` suffix; at the same time, `is native` is used for the routines that are actually implemented via native functions. These are the representations that can be used:

- CStruct 对应于 C 语言中的 `struct`。它是一种复合数据结构，包括不同的、异构的低级别数据结构；请参见[这个例子](https://docs.raku.org/language/nativecall#Structs)和进一步的解释。
- 同样，CPPStruct 对应于 C++ 中的 `struct`。不过，这是 Rakudo 目前所特有的。
- CPointer 是这些语言中任何一种的指针。它是一个动态的数据结构，必须在使用前实例化，能[被用于](https://docs.raku.org/language/nativecall#Basic_use_of_pointers)方法也是原生方法的类。
- CUnion 将使用与 C 中的 `union` 相同的表示；参见[这个例子](https://docs.raku.org/language/nativecall#CUnions)。

- CStruct corresponds to a `struct` in the C language. It is a composite data structure which includes different and heterogeneous lower-level data structures; see [this](https://docs.raku.org/language/nativecall#Structs) for examples and further explanations.
- CPPStruct, similarly, correspond to a `struct` in C++. However, this is Rakudo specific for the time being.
- CPointer is a pointer in any of these languages. It is a dynamic data structure that must be instantiated before being used, can be [used](https://docs.raku.org/language/nativecall#Basic_use_of_pointers) for classes whose methods are also native.
- CUnion is going to use the same representation as an `union` in C; see [this](https://docs.raku.org/language/nativecall#CUnions) for an example.

另一方面，P6opaque 是 Raku 中所有对象的默认表示。

On the other hand, P6opaque is the default representation used for all objects in Raku.

```Raku
class Thar {};
say Thar.REPR;    #OUTPUT: «P6opaque␤»
```

默认情况下对每个对象和类都使用[元对象协议](https://docs.raku.org/language/mop)，除非另外指定；因此，除非你能有效地使用该接口，否则通常不需要使用它。

The [metaobject protocol](https://docs.raku.org/language/mop) uses it by default for every object and class unless specified otherwise; for that reason, it is in general not necessary unless you are effectively working with that interface.

<a id="is-on-routines--例程上的-is"></a>
## `is` on routines / 例程上的 `is`

`is` 特征可用于方法和例程的定义以建立[优先级](https://docs.raku.org/language/functions#Precedence)和[关联性](https://docs.raku.org/language/functions#Associativity)。 它们作为[使用 `trait_mod` 特性定义的子例程](https://docs.raku.org/type/Sub#Traits)以要添加的特征的类型和名称作为参数。在子例程的情况下，特性是一种跨越类和角色层次结构添加功能的方法，甚至可以用来向独立定义的例程添加行为。

The `is` trait can be used on the definition of methods and routines to establish [precedence](https://docs.raku.org/language/functions#Precedence) and [associativity](https://docs.raku.org/language/functions#Associativity). They act as a [sub defined using `trait_mod`](https://docs.raku.org/type/Sub#Traits) which take as argument the types and names of the traits that are going to be added. In the case of subroutines, traits would be a way of adding functionality which cuts across class and role hierarchies, or can even be used to add behaviors to independently defined routines.

