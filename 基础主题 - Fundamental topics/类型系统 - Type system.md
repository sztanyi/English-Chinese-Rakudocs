原文：https://docs.perl6.org/language/typesystem

# 类型系统 / Type system

Perl 6 类型系统简介

Introduction to the type system of Perl 6

<!-- MarkdownTOC -->

- [Perl 6 类型的定义 / Definition of a Perl 6 type](#perl-6-%E7%B1%BB%E5%9E%8B%E7%9A%84%E5%AE%9A%E4%B9%89--definition-of-a-perl-6-type)
    - [默认类型 / Default types](#%E9%BB%98%E8%AE%A4%E7%B1%BB%E5%9E%8B--default-types)
    - [类型对象 / Type objects](#%E7%B1%BB%E5%9E%8B%E5%AF%B9%E8%B1%A1--type-objects)
        - [未定义 / Undefinedness](#%E6%9C%AA%E5%AE%9A%E4%B9%89--undefinedness)
        - [强制类型转换 / Coercion](#%E5%BC%BA%E5%88%B6%E7%B1%BB%E5%9E%8B%E8%BD%AC%E6%8D%A2--coercion)
- [类型声明符 / Type declarators](#%E7%B1%BB%E5%9E%8B%E5%A3%B0%E6%98%8E%E7%AC%A6--type-declarators)
    - [`class`](#class)
        - [混合类 / Mixins](#%E6%B7%B7%E5%90%88%E7%B1%BB--mixins)
        - [内省 / Introspection](#%E5%86%85%E7%9C%81--introspection)
            - [元类 / Metaclass](#%E5%85%83%E7%B1%BB--metaclass)
        - [私有属性 / Private attributes](#%E7%A7%81%E6%9C%89%E5%B1%9E%E6%80%A7--private-attributes)
        - [方法 / Methods](#%E6%96%B9%E6%B3%95--methods)
            - [继承与 multi 方法 / Inheritance and multis](#%E7%BB%A7%E6%89%BF%E4%B8%8E-multi-%E6%96%B9%E6%B3%95--inheritance-and-multis)
            - [Only 方法 / Only method](#only-%E6%96%B9%E6%B3%95--only-method)
            - [BUILD 子方法 / submethod BUILD](#build-%E5%AD%90%E6%96%B9%E6%B3%95--submethod-build)
            - [FALLBACK 方法 / Fallback method](#fallback-%E6%96%B9%E6%B3%95--fallback-method)
            - [保留方法名 / Reserved method names](#%E4%BF%9D%E7%95%99%E6%96%B9%E6%B3%95%E5%90%8D--reserved-method-names)
            - [包作用域里的方法 / Methods in package scope](#%E5%8C%85%E4%BD%9C%E7%94%A8%E5%9F%9F%E9%87%8C%E7%9A%84%E6%96%B9%E6%B3%95--methods-in-package-scope)
            - [使用同名变量和方法设置属性 / Setting attributes with namesake variables and methods](#%E4%BD%BF%E7%94%A8%E5%90%8C%E5%90%8D%E5%8F%98%E9%87%8F%E5%92%8C%E6%96%B9%E6%B3%95%E8%AE%BE%E7%BD%AE%E5%B1%9E%E6%80%A7--setting-attributes-with-namesake-variables-and-methods)
        - [`is nodal` 特性 / trait `is nodal`](#is-nodal-%E7%89%B9%E6%80%A7--trait-is-nodal)
        - [`handles` 特性 / trait `handles`](#handles-%E7%89%B9%E6%80%A7--trait-handles)
        - [`is` 特性 / trait `is`](#is-%E7%89%B9%E6%80%A7--trait-is)
        - [`is rw` 特性 / trait `is rw`](#is-rw-%E7%89%B9%E6%80%A7--trait-is-rw)
        - [`is required` 特性 / trait `is required`](#is-required-%E7%89%B9%E6%80%A7--trait-is-required)
        - [`hides` 特性 / trait `hides`](#hides-%E7%89%B9%E6%80%A7--trait-hides)
        - [`trusts` 特性 / trait `trusts`](#trusts-%E7%89%B9%E6%80%A7--trait-trusts)
        - [扩充类 / Augmenting a class](#%E6%89%A9%E5%85%85%E7%B1%BB--augmenting-a-class)
        - [版本控制和作者 / Versioning and authorship](#%E7%89%88%E6%9C%AC%E6%8E%A7%E5%88%B6%E5%92%8C%E4%BD%9C%E8%80%85--versioning-and-authorship)
    - [`role`](#role)
        - [自动双关 / Auto-punning](#%E8%87%AA%E5%8A%A8%E5%8F%8C%E5%85%B3--auto-punning)
        - [`does` 特性 / trait `does`](#does-%E7%89%B9%E6%80%A7--trait-does)
        - [参数化 / Parameterized](#%E5%8F%82%E6%95%B0%E5%8C%96--parameterized)
        - [作为类型约束 / As type constraints](#%E4%BD%9C%E4%B8%BA%E7%B1%BB%E5%9E%8B%E7%BA%A6%E6%9D%9F--as-type-constraints)
        - [版本控制和作者 / Versioning and authorship](#%E7%89%88%E6%9C%AC%E6%8E%A7%E5%88%B6%E5%92%8C%E4%BD%9C%E8%80%85--versioning-and-authorship-1)
    - [`enum`](#enum)
        - [Metaclass](#metaclass)
        - [Methods](#methods)
            - [method enums](#method-enums)
        - [Coercion](#coercion)
    - [`module`](#module)
        - [Versioning and authorship](#versioning-and-authorship)
    - [`package`](#package)
    - [`grammar`](#grammar)
        - [Versioning and authorship](#versioning-and-authorship-1)
    - [`subset`](#subset)

<!-- /MarkdownTOC -->

<a id="perl-6-%E7%B1%BB%E5%9E%8B%E7%9A%84%E5%AE%9A%E4%B9%89--definition-of-a-perl-6-type"></a>
# Perl 6 类型的定义 / Definition of a Perl 6 type

类型通过创建一个类型对象来定义一个新对象，该对象提供一个接口来创建对象的实例或检查值。任何类型的对象都是 [Any](https://docs.perl6.org/type/Any) 或 [Mu](https://docs.perl6.org/type/Mu) 的子类。自省方法是通过继承这些基类和内省后缀 [.^](https://docs.perl6.org/language/operators#postfix_.^) 提供的。以下类型的声明器在编译时或在运行时使用[元对象协议](https://docs.perl6.org/language/mop)将新类型引入当前范围。所有类型名称在其作用域中必须是唯一的。

A type defines a new object by creating a type object that provides an interface to create instances of objects or to check values against. Any type object is a subclass of [Any](https://docs.perl6.org/type/Any) or [Mu](https://docs.perl6.org/type/Mu). Introspection methods are provided via inheritance from those base classes and the introspection postfix [.^](https://docs.perl6.org/language/operators#postfix_.^). A new type is introduced to the current scope by one of the following type declarators at compile time or with the [metaobject protocol](https://docs.perl6.org/language/mop) at runtime. All type names must be unique in their scope.

<a id="%E9%BB%98%E8%AE%A4%E7%B1%BB%E5%9E%8B--default-types"></a>
## 默认类型 / Default types

如果用户没有提供任何类型，Perl 6 假设类型为 `Any`。这包括[容器](https://docs.perl6.org/language/containers)、基类、[参数](https://docs.perl6.org/type/Signature#Type_constraints)和返回类型。

If no type is provided by the user Perl 6 assumes the type to be `Any`. This includes [containers](https://docs.perl6.org/language/containers), base-classes, [parameters](https://docs.perl6.org/type/Signature#Type_constraints) and return types.

```Perl6
my $a = 1;
$a = Nil;
say $a.^name;
# OUTPUT: «Any␤»

class C {};
say C.^parents(:all);
# OUTPUT: «((Any) (Mu))␤»
```

对于容器，默认类型是 `Any`，但默认类型约束是 `Mu`。请注意，绑定取代了容器，而不仅仅是值。在这种情况下，类型约束可能会改变。

For containers the default type is `Any` but the default type constraint is `Mu`. Please note that binding replaces the container, not just the value. The type constraint may change in this case.

<a id="%E7%B1%BB%E5%9E%8B%E5%AF%B9%E8%B1%A1--type-objects"></a>
## 类型对象 / Type objects

要测试对象是否为类型对象，请使用[智能匹配](https://docs.perl6.org/language/operators#index-entry-smartmatch_operator)[类型笑脸符](https://docs.perl6.org/type/Signature#Constraining_defined_and_undefined_values)约束的类型或使用 [`.DEFINITE`](https://docs.perl6.org/language/mop#index-entry-syntax_DEFINITE-DEFINITE) 方法：

To test if an object is a type object, use [smartmatch](https://docs.perl6.org/language/operators#index-entry-smartmatch_operator) against a type constrained with a [type smiley](https://docs.perl6.org/type/Signature#Constraining_defined_and_undefined_values) or [`.DEFINITE`](https://docs.perl6.org/language/mop#index-entry-syntax_DEFINITE-DEFINITE) method:

```Perl6
my $a = Int;
say $a ~~ Mu:U;
# OUTPUT: «True␤»
say not $a.DEFINITE;
# OUTPUT: «True␤»
```

如果调用方是实例，`.DEFINITE` 将返回 `True`。如果它返回 `False`，那么调用方就是类型对象。

`.DEFINITE` will return `True` if the invocant is an instance. If it returns `False`, then the invocant is a type object.

<a id="%E6%9C%AA%E5%AE%9A%E4%B9%89--undefinedness"></a>
### 未定义 / Undefinedness

未定义对象在 Perl 6 中维护类型信息。类型对象用于表示未定义和未定义值的类型。若要提供通用的未定义值，请使用 [Any](https://docs.perl6.org/type/Any)。如果与 `Any`（容器和参数的默认类型）不同，则需要使用 [Mu](https://docs.perl6.org/type/Mu)。

Undefined objects maintain type information in Perl 6. Type objects are used to represent both undefinedness and the type of the undefined value. To provide a general undefined value use [Any](https://docs.perl6.org/type/Any). If differentiation from `Any`, the default type for containers and arguments, is required use [Mu](https://docs.perl6.org/type/Mu).

由 [.CREATE](https://docs.perl6.org/type/Mu#method_CREATE) 创建的对象的实例是按照约定定义的。方法 [.defined](https://docs.perl6.org/type/Mu#routine_defined) 将返回 `Bool::True` 来表示确定性。该规则的例外是 [Nil](https://docs.perl6.org/type/Nil) 和 [Failure](https://docs.perl6.org/type/Failure)。请注意，任何对象都可以重载 `.defined`，因此可以携带额外的信息。此外，Perl 6 明确区分了定义和真值。许多值是定义的，尽管它们为假或空的含义。这些值是 `0`，[Bool::False](https://docs.perl6.org/type/Bool)，[()](https://docs.perl6.org/language/operators#term_(_))（空列表）和 [NaN](https://docs.perl6.org/type/Num#NaN)。

Instances of objects created by [.CREATE](https://docs.perl6.org/type/Mu#method_CREATE) are by convention defined. The method [.defined](https://docs.perl6.org/type/Mu#routine_defined) will return `Bool::True` to indicate definedness. The exceptions to that rule are [Nil](https://docs.perl6.org/type/Nil) and [Failure](https://docs.perl6.org/type/Failure). Please note that any object is able to overload `.defined` and as such can carry additional information. Also, Perl 6 makes a clear distinction between definedness and trueness. Many values are defined even though they carry the meaning of wrongness or emptiness. Such values are `0`, [Bool::False](https://docs.perl6.org/type/Bool), [()](https://docs.perl6.org/language/operators#term_(_)) (empty list) and [NaN](https://docs.perl6.org/type/Num#NaN).

在运行时，值可能会通过[混合](https://docs.perl6.org/language/operators#infix_but)而变得未定义。

Values can become undefined at runtime via [mixin](https://docs.perl6.org/language/operators#infix_but).

```Perl6
my Int $i = 1 but role :: { method defined { False } };
say $i // "undefined";
# OUTPUT: «undefined␤»
```

要测试是否定义，请调用方法 `.defined`、使用 [//](https://docs.perl6.org/language/operators#infix_//)、[with/without](https://docs.perl6.org/language/control#with,_orwith,_without) 和 [签名](https://docs.perl6.org/type/Signature#Constraining_defined_and_undefined_values)。

To test for definedness call `.defined`, use [//](https://docs.perl6.org/language/operators#infix_//), [with/without](https://docs.perl6.org/language/control#with,_orwith,_without) and [signatures](https://docs.perl6.org/type/Signature#Constraining_defined_and_undefined_values).

<a id="%E5%BC%BA%E5%88%B6%E7%B1%BB%E5%9E%8B%E8%BD%AC%E6%8D%A2--coercion"></a>
### 强制类型转换 / Coercion

将一种类型转换为另一种类型是使用与目标类型具有相同名称的强制类型转换方法完成的。这个约定是由 [Signatures](https://docs.perl6.org/type/Signature#Coercion_type) 强制执行的。源类型必须知道如何将自身转换为目标类型。为了允许内置类型将自身转换为用户定义的类型，可以使用 [augment](https://docs.perl6.org/language/variables#The_augment_declarator) 或 [MOP](https://docs.perl6.org/language/mop)。

Turning one type into another is done with coercion methods that have the same name as the target type. This convention is made mandatory by [Signatures](https://docs.perl6.org/type/Signature#Coercion_type). The source type has to know how to turn itself into the target type. To allow built-in types to turn themselves into user defined types use [augment](https://docs.perl6.org/language/variables#The_augment_declarator) or the [MOP](https://docs.perl6.org/language/mop).

```Perl6
class C {
    has $.int;
    method this-is-c { put 'oi' x $!int ~ '‽' }
}

use MONKEY-TYPING;
augment class Int {
    method C { C.new(:int(self))}
}

my $i = 10;
$i.=C;
$i.this-is-c();
# OUTPUT: «oioioioioioioioioioi‽␤»
```

Perl 6 提供了 [Cool](https://docs.perl6.org/type/Cool) 中定义的方法在应用进一步的操作之前转换为目标类型。大多数内置类型都来自 `Cool`，因此可能提供可能不想要的隐式强制类型转换。关注这些方法的无陷阱使用是用户的责任。

Perl 6 provides methods defined in [Cool](https://docs.perl6.org/type/Cool) to convert to a target type before applying further operations. Most built-in types descend from `Cool` and as such may provide implicit coercion that may be undesired. It is the responsibility of the user to care about trap-free usage of those methods.

```Perl6
my $whatever = "123.6";
say $whatever.round;
# OUTPUT: «124␤»
say <a b c d>.starts-with("ab");
# OUTPUT: «False␤»
```

<a id="%E7%B1%BB%E5%9E%8B%E5%A3%B0%E6%98%8E%E7%AC%A6--type-declarators"></a>
# 类型声明符 / Type declarators

类型声明器将新类型引入给定范围。嵌套作用域可以用 `::` 分隔。如果尚未存在此类范围，则会自动创建新 [package](https://docs.perl6.org/language/packages)。

Type declarators introduce a new type into the given scope. Nested scopes can be separated by `::`. New [packages](https://docs.perl6.org/language/packages) are created automatically if no such scope exists already.

```Perl6
class Foo::Bar::C {};
put Foo::Bar::.keys;
# OUTPUT: «C␤»
```

前向声明可以提供一个只包含 `...` 的代码块。如果定义了类型，编译器将在当前作用域的末尾进行检查。

Forward declarations can be provided with a block containing only `...`. The compiler will check at the end of the current scope if the type is defined.

```Perl6
class C {...}
# many lines later
class C { has $.attr }
```

<a id="class"></a>
## `class`

`class` 声明器创建一个编译时构造，该构造被编译成一个类型对象。后者是一个简单的 Perl 6 对象，它提供了通过执行初始化器和子方法来构造实例的方法，以填充类中声明的所有属性和任何父类中的值。可以在属性声明或构造函数中提供初始化器。了解如何运行它们是 [Metamodel::ClassHOW](https://docs.perl6.org/type/Metamodel::ClassHOW) 的责任。这是在 Perl 6 中构建对象的唯一神奇部分，默认的父类型是 `Any`，它继承自 `Mu`。后者提供了默认的构造函数 `.new`（按约定命名）。除此之外，`.new` 没有任何特殊的含义，也没有任何特殊的处理方式。

The `class` declarator creates a compile time construct that is compiled into a type object. The latter is a simple Perl 6 object and provides methods to construct instances by executing initializers and sub methods to fill all attributes declared in a class, and any parent class, with values. Initializers can be provided with the declaration of attributes or in constructors. It's the responsibility of the [Metamodel::ClassHOW](https://docs.perl6.org/type/Metamodel::ClassHOW) to know how to run them. This is the only magic part of building objects in Perl 6. The default parent type is `Any`, which in turn inherits from `Mu`. The latter provides the default constructor `.new` which is named like this by convention. Aside from this, `.new` does not carry any special meaning nor is treated in any special way.

有关如何使用类的更多信息，请参见 [Classes and objects](https://docs.perl6.org/language/classtut) 教程。

For more information how to use classes see the [Classes and objects](https://docs.perl6.org/language/classtut) tutorial.

<a id="%E6%B7%B7%E5%90%88%E7%B1%BB--mixins"></a>
### 混合类 / Mixins

类引入的类型可以在运行时用 [infix:](https://docs.perl6.org/language/operators#infix_but) 进行扩展。原始类型不被修改，而是返回一个新类型对象，并且可以存储在一个容器中，该容器可以根据原始类型或混合的角色成功地检查类型。

The type introduced by `class` can be extended with [infix:](https://docs.perl6.org/language/operators#infix_but) at runtime. The original type is not modified, instead a new type object is returned and can be stored in a container that type checks successful against the original type or the role that is mixed in.

```Perl6
class A {}
role R { method m { say 'oi‽' } }
my R $A = A but R;
my $a1 = $A.new;
$a1.m;
say [$A ~~ R, $a1 ~~ R];
# OUTPUT: «oi‽␤[True True]␤»
```

<a id="%E5%86%85%E7%9C%81--introspection"></a>
### 内省 / Introspection

<a id="%E5%85%83%E7%B1%BB--metaclass"></a>
#### 元类 / Metaclass

若要测试给定类型对象是否为类，请针对 [Metamodel::ClassHOW](https://docs.perl6.org/type/Metamodel::ClassHOW) 测试元对象方法 `.HOW`。

To test if a given type object is a class, test the metaobject method `.HOW` against [Metamodel::ClassHOW](https://docs.perl6.org/type/Metamodel::ClassHOW).

```Perl6
class C {};
say C.HOW ~~ Metamodel::ClassHOW;
# OUTPUT: «True␤»
```

<a id="%E7%A7%81%E6%9C%89%E5%B1%9E%E6%80%A7--private-attributes"></a>
### 私有属性 / Private attributes

私有的[属性](https：/docs.perl6.org/type/properties)的地址是使用任意一标记 `$!`、`@!` 和 `%!`。它们没有自动生成的公共访问器方法。因此，它们不能在定义在其中的类之外被更改。

Private [attribute](https://docs.perl6.org/type/Attribute)s are addressed with any of the twigils `$!`, `@!` and `%!`. They do not have public accessor methods generated automatically. As such they can not be altered from outside the class they are defined in.

```Perl6
class C {
    has $!priv;
    submethod BUILD { $!priv = 42 }
};

say (.name, .package, .has_accessor) for C.new.^attributes;
# OUTPUT: «($!priv (C) False)␤»
```

<a id="%E6%96%B9%E6%B3%95--methods"></a>
### 方法 / Methods

`method` 声明器定义类型为 [Method](https://docs.perl6.org/type/Method) 的对象并将它们绑定到类的作用域中提供的名称。默认情况下，类中的方法是 `has` 作用域。默认情况下，不将 `our` 作用域的方法添加到方法缓存中，因此不能使用访问器 `$.` 调用。用其完全限定的名称和调用者作为第一个参数来调用它们。

The `method` declarator defines objects of type [Method](https://docs.perl6.org/type/Method) and binds them to the provided name in the scope of a class. Methods in a class are `has` scoped by default. Methods that are `our` scoped are not added to the method cache by default and as such can not be called with the accessor sigil `$.`. Call them with their fully qualified name and the invocant as the first argument.

<a id="%E7%BB%A7%E6%89%BF%E4%B8%8E-multi-%E6%96%B9%E6%B3%95--inheritance-and-multis"></a>
#### 继承与 multi 方法 / Inheritance and multis

子类中的正常方法不与父类的 multi 方法竞争。

A normal method in a subclass does not compete with multis of a parent class.

```Perl6
class A {
    multi method m(Int $i){ say 'Int' }
    multi method m(int $i){ say 'int' }
}

class B is A {
    method m(Int $i){ say 'B::Int' }
}

my int $i;
B.new.m($i);
# OUTPUT: «B::Int␤»
```

<a id="only-%E6%96%B9%E6%B3%95--only-method"></a>
#### Only 方法 / Only method

要显式声明一个方法不是 multi 方法，请使用 `only` 方法声明器。

To explicitly state that a method is not a multi method use the `only` method declarator.

```Perl6
class C {
    only method m {};
    multi method m {};
};
# OUTPUT: «X::Comp::AdHoc: Cannot have a multi candidate for 'm' when an only method is also in the package 'C'␤»
```

<a id="build-%E5%AD%90%E6%96%B9%E6%B3%95--submethod-build"></a>
#### BUILD 子方法 / submethod BUILD

[submethod](https://docs.perl6.org/type/Submethod)  `BUILD` 被 [.bless](https://docs.perl6.org/type/Mu#method_bless) 间接调用。它的目的是设置类的私有和公共属性，并接收传递给 `.bless` 的所有名称属性。在 `Mu` 中定义的默认构造函数 [.new](https://docs.perl6.org/type/Mu#method_new) 是调用它的方法。鉴于 `BUILD` 中没有公共访问器方法，您必须使用私有属性表示法。

The [submethod](https://docs.perl6.org/type/Submethod) `BUILD` is (indirectly) called by [.bless](https://docs.perl6.org/type/Mu#method_bless). It is meant to set private and public attributes of a class and receives all names attributes passed into `.bless`. The default constructor [.new](https://docs.perl6.org/type/Mu#method_new) defined in `Mu` is the method that invokes it. Given that public accessor methods are not available in `BUILD`, you must use private attribute notation instead.

```Perl6
class C {
    has $.attr;
    submethod BUILD (:$attr = 42) {
        $!attr = $attr
    };
    multi method new($positional) {
        self.bless(:attr($positional), |%_)
   }
};

C.new.say; C.new('answer').say;
# OUTPUT: «C.new(attr => 42)␤
#          C.new(attr => "answer")␤»
```

<a id="fallback-%E6%96%B9%E6%B3%95--fallback-method"></a>
#### FALLBACK 方法 / Fallback method 

当解析名称的其他方法不产生任何结果时，将调用具有特殊名称 `FALLBACK` 的方法。第一个参数保存名称，以下所有参数都是从原始调用中转发的。支持多方法和[子签名](https://docs.perl6.org/type/Signature#Destructuring_arguments)。

A method with the special name `FALLBACK` will be called when other means to resolve the name produce no result. The first argument holds the name and all following arguments are forwarded from the original call. Multi methods and [sub-signatures](https://docs.perl6.org/type/Signature#Destructuring_arguments) are supported.

```Perl6
class Magic {
    method FALLBACK ($name, |c(Int, Str)) {
        put "$name called with parameters {c.perl}"
    }
};
Magic.new.simsalabim(42, "answer");

# OUTPUT: «simsalabim called with parameters ⌈\(42, "answer")⌋␤»
```

<a id="%E4%BF%9D%E7%95%99%E6%96%B9%E6%B3%95%E5%90%8D--reserved-method-names"></a>
#### 保留方法名 / Reserved method names

一些内置的内省方法实际上是编译器提供的特殊语法，即 `WHAT`、`WHO`、`HOW` 和 `VAR`。用这些名称声明方法将无声地失败。可以动态调用，允许从外部对象调用方法。

Some built-in introspection methods are actually special syntax provided by the compiler, namely `WHAT`, `WHO`, `HOW` and `VAR`. Declaring methods with those names will silently fail. A dynamic call will work, what allows to call methods from foreign objects.

```Perl6
class A {
    method WHAT { "ain't gonna happen" }
};

say A.new.WHAT;    # OUTPUT: «(A)␤»
say A.new."WHAT"() # OUTPUT: «ain't gonna happen␤»
```

<a id="%E5%8C%85%E4%BD%9C%E7%94%A8%E5%9F%9F%E9%87%8C%E7%9A%84%E6%96%B9%E6%B3%95--methods-in-package-scope"></a>
#### 包作用域里的方法 / Methods in package scope

在类的包作用域内，任何 `our` 作用域方法都是可见的。

Any `our` scoped method will be visible in the package scope of a class.

```Perl6
class C {
    our method packaged {};
    method loose {}
};
say C::.keys
# OUTPUT: «(&packaged)␤»
```

<a id="%E4%BD%BF%E7%94%A8%E5%90%8C%E5%90%8D%E5%8F%98%E9%87%8F%E5%92%8C%E6%96%B9%E6%B3%95%E8%AE%BE%E7%BD%AE%E5%B1%9E%E6%80%A7--setting-attributes-with-namesake-variables-and-methods"></a>
#### 使用同名变量和方法设置属性 / Setting attributes with namesake variables and methods

要设置属性时用的变量（或者方法调用）与要设置的属性同名时，除了用 `attr => $attr` 或者 `:attr($attr)` 之外，可以这样简写：

Instead of writing `attr => $attr` or `:attr($attr)`, you can save some typing if the variable (or method call) you're setting the attribute with shares the name with the attribute:

```Perl6
class A { has $.i = 42 };
class B {
    has $.i = "answer";
    method m() { A.new(:$.i) }
    #                  ^^^^  Instead of i => $.i or :i($.i)
};
my $a = B.new.m;
say $a.i; # OUTPUT: «answer␤»
```

`$.i` 方法调用名为 `i` 并且属性名也叫 `i`，因此 Perl 6 允许我们用快捷方式。这同样适用于 `:$var`、`:$!private-attribute`、`:&attr-with-code-in-it` 等等。

Since `$.i` method call is named `i` and the attribute is also named `i`, Perl 6 lets us shortcut. The same applies to `:$var`, `:$!private-attribute`, `:&attr-with-code-in-it`, and so on.

<a id="is-nodal-%E7%89%B9%E6%80%A7--trait-is-nodal"></a>
### `is nodal` 特性 / trait `is nodal`

标记一个 [List](https://docs.perl6.org/type/List) 方法，以指示超级运算符不要下降到内部 [Iterables](https://docs.perl6.org/type/Iterable) 来调用此方法。这种特性通常不是最终用户会使用的特性，除非他们正在子类化或增强核心[List](https://docs.perl6.org/type/List)类型。

Marks a [List](https://docs.perl6.org/type/List) method to indicate to hyperoperator to not descend into inner [Iterables](https://docs.perl6.org/type/Iterable) to call this method. This trait generally isn't something end users would be using, unless they're subclassing or augmenting core [List](https://docs.perl6.org/type/List) type.

为了证明这一区别，请考虑以下例子：第一种方法 (`elems`) 使用 `is nodal` 的方法，第二种方法使用不是节点的方法 (`Int`)。

In order to demonstrate the difference consider the following examples, the first using a method (`elems`) that `is nodal` and the second using a method (`Int`) which is not nodal.

```Perl6
say ((1.0, "2", 3e0), [^4], '5')».elems; # OUTPUT: «(3, 4, 1)␤»
say ((1.0, "2", 3e0), [^4], '5')».Int    # OUTPUT: «((1 2 3) [0 1 2 3] 5)␤»
```

<a id="handles-%E7%89%B9%E6%80%A7--trait-handles"></a>
### `handles` 特性 / trait `handles`

定义为：

Defined as:

```Perl6
multi sub trait_mod:<handles>(Attribute:D $target, $thunk)
```

`handles` 特性应用于类的属性，对提供的方法名的所有调用委托给具有相同属性名称的方法。被属性引用的对象必须初始化。可以为委托调用的对象提供类型约束。

The [trait](https://docs.perl6.org/type/Sub#Traits) `handles` applied to an attribute of a class will delegate all calls to the provided method name to the method with the same name of the attribute. The object referenced by the attribute must be initialized. A type constraint for the object that the call is delegated to can be provided.

```Perl6
class A      { method m(){ 'A::m has been called.' } }
class B is A { method m(){ 'B::m has been called.' } }
class C {
    has A $.delegate handles 'm';
    method new($delegate){ self.bless(delegate => $delegate) }
};
say C.new(B.new).m(); # OUTPUT: «B::m has been called.␤»
```

除了方法名外，还可以作用于 `Pair`（用于重命名）、名字数组、`Pair` 数组、 `Regex` 或者 `Whatever` 。在后一种情况下，类本身及其继承链中的现有方法都将优先。如果需要搜索本地 `FALLBACK`，请使用 `HyperWhatever`。

Instead of a method name, a `Pair` (for renaming), a list of names or `Pair`s, a `Regex` or a `Whatever` can be provided. In the latter case existing methods, both in the class itself and its inheritance chain, will take precedence. If even local `FALLBACK`s should be searched, use a `HyperWhatever`.

```Perl6
class A {
    method m1(){}
    method m2(){}
}

class C {
    has $.delegate handles <m1 m2> = A.new()
}
C.new.m2;

class D {
    has $.delegate handles /m\d/ = A.new()
}
D.new.m1;

class E {
    has $.delegate handles (em1 => 'm1') = A.new()
}
E.new.em1;
```

<a id="is-%E7%89%B9%E6%80%A7--trait-is"></a>
### `is` 特性 / trait `is`

定义为：

Defined as:

```Perl6
multi sub trait_mod:<is>(Mu:U $child, Mu:U $parent)
```

[特性](https://docs.perl6.org/type/Sub#Traits) `is` 接受添加一个类型对象作为定义中的类的父类。要允许多重继承，可以多次应用该特性。将父类添加到类中会将他们的方法导入目标类。如果在多个父类中出现相同的方法名，则第一个添加的父类将获胜。

The [trait](https://docs.perl6.org/type/Sub#Traits) `is` accepts a type object to be added as a parent class of a class in its definition. To allow multiple inheritance the trait can be applied more than once. Adding parents to a class will import their methods into the target class. If the same method name occurs in multiple parents, the first added parent will win.

如果没有 `is` 特性，默认的 [`Any`](https://docs.perl6.org/type/Any) 将会作为父类。这迫使所有 Perl 6 对象都具有相同的基本方法集，以提供一个接口，用于对基本类型进行内省和强制类型转换。

If no `is` trait is provided the default of [`Any`](https://docs.perl6.org/type/Any) will be used as a parent class. This forces all Perl 6 objects to have the same set of basic methods to provide an interface for introspection and coercion to basic types.

```Perl6
class A {
    multi method from-a(){ 'A::from-a' }
}
say A.new.^parents(:all).perl;
# OUTPUT: «(Any, Mu)␤»

class B {
    method from-b(){ 'B::from-b ' }
    multi method from-a(){ 'B::from-A' }
}

class C is A is B {}
say C.new.from-a();
# OUTPUT: «A::from-a␤»
```

<a id="is-rw-%E7%89%B9%E6%80%A7--trait-is-rw"></a>
### `is rw` 特性 / trait `is rw`

定义为：

Defined as:

```Perl6
sub trait_mod:<is>(Mu:U $type, :$rw!)
```

在类上的 `is rw` 特性将对所有公共属性创建可写的访问器方法。

The [trait](https://docs.perl6.org/type/Sub#Traits) `is rw` on a class will create writable accessor methods on all public attributes of that class.

```Perl6
class C is rw {
    has $.a;
};
my $c = C.new.a = 42;
say $c; # OUTPUT: «42␤»
```

<a id="is-required-%E7%89%B9%E6%80%A7--trait-is-required"></a>
### `is required` 特性 / trait `is required`

定义为：

Defined as:

```Perl6
multi sub trait_mod:<is>(Attribute $attr, :$required!)
multi sub trait_mod:<is>(Parameter:D $param, :$required!)
```

标记一个类或者角色的属性必须的。如果在对象构建时属性没有被初始化则抛出 [X::Attribute::Required](https://docs.perl6.org/type/X::Attribute::Required) 异常。

Marks a class or roles attribute as required. If the attribute is not initialized at object construction time throws [X::Attribute::Required](https://docs.perl6.org/type/X::Attribute::Required).

```Perl6
class Correct {
    has $.attr is required;
    submethod BUILD (:$attr) { $!attr = $attr }
}
say Correct.new(attr => 42);
# OUTPUT: «Correct.new(attr => 42)␤»

class C {
    has $.attr is required;
}
C.new;
CATCH { default { say .^name => .Str } }
# OUTPUT: «X::Attribute::Required => The attribute '$!attr' is required, but you did not provide a value for it.␤»
```

你可以提供一个理由作为 `is required` 的参数，说明为什么是必须的。

You can provide a reason why it's required as an argument to `is required`

```Perl6
class Correct {
    has $.attr is required("it's so cool")
};
say Correct.new();
# OUTPUT: «The attribute '$!attr' is required because it's so cool,␤but you did not provide a value for it.␤»
```

<a id="hides-%E7%89%B9%E6%80%A7--trait-hides"></a>
### `hides` 特性 / trait `hides`

`hides` 特性提供继承，而不受[重新调度](https://docs.perl6.org/language/functions#Re-dispatching) 的约束。

The trait `hides` provides inheritance without being subject to [re-dispatching](https://docs.perl6.org/language/functions#Re-dispatching).

```Perl6
class A {
    method m { say 'i am hidden' }
}
class B hides A {
    method m { nextsame }
    method n { self.A::m }
};

B.new.m;
B.new.n;
# OUTPUT: «i am hidden␤»
```

`is hidden` 特性允许类隐藏自己不受[重新调度](https://docs.perl6.org/language/functions#Re-dispatching)的影响。

The trait `is hidden` allows a class to hide itself from [re-dispatching](https://docs.perl6.org/language/functions#Re-dispatching).

```Perl6
class A is hidden {
    method m { say 'i am hidden' }
}
class B is A {
    method m { nextsame }
    method n { self.A::m }
}

B.new.m;
B.new.n;
# OUTPUT: «i am hidden␤»
```

<a id="trusts-%E7%89%B9%E6%80%A7--trait-trusts"></a>
### `trusts` 特性 / trait `trusts`

要允许一个类访问另一个类的私有方法，请使用 `trusts` 这一特性。可能需要可信类的前向声明。

To allow one class to access the private methods of another class use the trait `trusts`. A forward declaration of the trusted class may be required.

```Perl6
class B {...};
class A {
    trusts B;
    has $!foo;
    method !foo { return-rw $!foo }
    method perl { "A.new(foo => $!foo)" }
};
class B {
    has A $.a .= new;
    method change { $!a!A::foo = 42; self }
};
say B.new.change;
# OUTPUT: «B.new(a => A.new(foo => 42))␤»
```

<a id="%E6%89%A9%E5%85%85%E7%B1%BB--augmenting-a-class"></a>
### 扩充类 / Augmenting a class

要在编译时将方法和属性添加到类中，请在类定义片段前面使用 `augment`。编译器将在同一范围的早期要求使用指令 `use MONKEY-TYPING` 或 `use MONKEY`。请注意，这可能会对性能产生影响。

To add methods and attributes to a class at compile time use `augment` in front of a class definition fragment. The compiler will demand the pragmas `use MONKEY-TYPING` or `use MONKEY` early in the same scope. Please note that there may be performance implications, hence the pragmas.

```Perl6
use MONKEY; augment class Str {
    method mark(Any :$set){
        state $mark //= $set; $mark
    }
};
my $s = "42";
$s.mark(set => "answer");
say $s.mark
# OUTPUT: «answer␤»
```

在类片段中所能做的事情几乎没有限制。其中之一是将方法或子例程声明为 multi。使用添加的属性尚未实现。请注意，添加一个仅在其命名参数不同的多个候选项将在已经定义的参数后面添加该候选项，因此它不会被调度程序选中。

There are few limitations of what can be done inside the class fragment. One of them is the redeclaration of a method or sub into a multi. Using added attributes is not yet implemented. Please note that adding a multi candidate that differs only in its named parameters will add that candidate behind the already defined one and as such it won't be picked by the dispatcher.

<a id="%E7%89%88%E6%9C%AC%E6%8E%A7%E5%88%B6%E5%92%8C%E4%BD%9C%E8%80%85--versioning-and-authorship"></a>
### 版本控制和作者 / Versioning and authorship

版本控制和作者可以通过副词 `:ver<>` 和 `:auth<>` 指定。两者都使用一个字符串作为参数，因为 `:ver` 字符串被转换为一个 [Version](https://docs.perl6.org/type/Version) 对象。若要查询类的版本和作者使用 `.^ver` 和 `^.auth`。

Versioning and authorship can be applied via the adverbs `:ver<>` and `:auth<>`. Both take a string as argument, for `:ver` the string is converted to a [Version](https://docs.perl6.org/type/Version) object. To query a class version and author use `.^ver` and `^.auth`.

```Perl6
class C:ver<4.2.3>:auth<me@here.local> {}
say [C.^ver, C.^auth];
# OUTPUT: «[v4.2.3 me@here.local]␤»
```

<a id="role"></a>
## `role`

角色是类片段，它允许定义被类共享的接口。`role` 声明符还引入了一个可用于类型检查的类型对象。角色可以在运行时和编译时混合到类和对象中。`role` 声明符返回创建的类型对象，从而允许定义匿名角色和就地混合。

Roles are class fragments, which allow the definition of interfaces that are shared by classes. The `role` declarator also introduces a type object that can be used for type checks. Roles can be mixed into classes and objects at runtime and compile time. The `role` declarator returns the created type object thus allowing the definition of anonymous roles and in-place mixins.

```Perl6
role Serialize {
    method to-string { self.Str }
    method to-number { self.Num }
}

class A does Serialize {}
class B does Serialize {}

my Serialize @list;
@list.push: A.new;
@list.push: B.new;

say @list».to-string;
# OUTPUT: «[A<57192848> B<57192880>]␤»
```

使用 `...` 作为方法主体的唯一元素来声明方法是抽象的。任何得到这样一个方法的类都必须重载它。如果在编译单元结束前未重载该方法，则将抛出 `X::Comp::AdHoc` 异常。

Use `...` as the only element of a method body to declare a method to be abstract. Any class getting such a method mixed in has to overload it. If the method is not overloaded before the end of the compilation unit `X::Comp::AdHoc` will be thrown.

```Perl6
EVAL 'role R { method overload-this(){...} }; class A does R {}; ';
CATCH { default { say .^name, ' ', .Str } }
# OUTPUT: «X::Comp::AdHoc Method 'overload-this' must be implemented by A because it is required by roles: R.␤»
```

<a id="%E8%87%AA%E5%8A%A8%E5%8F%8C%E5%85%B3--auto-punning"></a>
### 自动双关 / Auto-punning

可以使用角色而不是类来创建对象。由于角色不能存在于运行时，因此创建了一个名称相同的类，该类对角色的类型智能匹配返回真。

A role can be used instead of a class to create objects. Since roles can't exist at runtime, a class of the same name is created that will type check successful against the role.

```Perl6
role R { method m { say 'oi‽' } };
R.new.^mro.say;
# OUTPUT: «((R) (Any) (Mu))␤»
say R.new.^mro[0].HOW.^name;
# OUTPUT: «Perl6::Metamodel::ClassHOW␤»
say R.new ~~ R;
# OUTPUT: «True␤»
```

<a id="does-%E7%89%B9%E6%80%A7--trait-does"></a>
### `does` 特性 / trait `does`

`does` 特性可应用于提供编译时混合的角色和类。若要引用尚未定义的角色，请使用前向声明。具有混合角色的类的类型名称不反映混入，但是类型检查反映。如果方法在多个混合角色中提供，则首先定义的方法优先。可以提供用逗号分隔的角色列表。在这种情况下，冲突将在编译时报告。

The trait `does` can be applied to roles and classes providing compile time mixins. To refer to a role that is not defined yet, use a forward declaration. The type name of the class with mixed in roles does not reflect the mixin, a type check does. If methods are provided in more than one mixed in role, the method that is defined first takes precedence. A list of roles separated by comma can be provided. In this case conflicts will be reported at compile time.

```Perl6
role R2 {...};
role R1 does R2 {};
role R2 {};
class C does R1 {};

say [C ~~ R1, C ~~ R2];
# OUTPUT: «[True True]␤»
```

运行时混入，见 [but](https://docs.perl6.org/language/operators#infix_but) 和 [does](https://docs.perl6.org/language/operators#infix_does)。

For runtime mixins see [but](https://docs.perl6.org/language/operators#infix_but) and [does](https://docs.perl6.org/language/operators#infix_does).

<a id="%E5%8F%82%E6%95%B0%E5%8C%96--parameterized"></a>
### 参数化 / Parameterized

角色的参数可以在角色名称后面 `[]` 之间提供。支持[类型捕获](https://docs.perl6.org/type/Signature#Type_captures)。

Roles can be provided with parameters in-between `[]` behind a roles name. [Type captures](https://docs.perl6.org/type/Signature#Type_captures) are supported.

```Perl6
role R[$d] { has $.a = $d };
class C does R["default"] { };

my $c = C.new;
say $c;
# OUTPUT: «C.new(a => "default")␤»
```

参数可以具有类型约束，`where` 子句不支持类型，但可以通过 `subset` 实现。

Parameters can have type constraints, `where` clauses are not supported for types but can be implemented via `subset`s.

```Perl6
class A {};
class B {};
subset A-or-B where * ~~ A|B;
role R[A-or-B ::T] {};
R[A.new].new;
```

可以提供默认参数。

Default parameters can be provided.

```Perl6
role R[$p = fail("Please provide a parameter to role R")] {};
my $i = 1 does R;
CATCH { default { say .^name, ': ', .Str} }
# OUTPUT: «X::AdHoc: Could not instantiate role 'R':␤Please provide a parameter to role R␤»
```

<a id="%E4%BD%9C%E4%B8%BA%E7%B1%BB%E5%9E%8B%E7%BA%A6%E6%9D%9F--as-type-constraints"></a>
### 作为类型约束 / As type constraints

角色可以用作类型约束，只要需要的是类型。如果一个角色与 `does` 或 `but` 混合，则将其类型对象添加到所述对象的类型对象列表中。如果使用角色代替类(使用自动双关)，则自动生成的类的类型对象(与角色同名)将被添加到继承链中。

Roles can be used as type constraints wherever a type is expected. If a role is mixed in with `does` or `but`, its type-object is added to the type-object list of the object in question. If a role is used instead of a class (using auto-punning), the auto-generated class' type-object, of the same name as the role, is added to the inheritance chain.

```Perl6
role Unitish[$unit = fail('Please provide a SI unit quantifier as a parameter to the role Unitish')] {
    has $.SI-unit-symbol = $unit;
    method gist {
        given self {
            # ...
            when * < 1 { return self * 1000 ~ 'm' ~ $.SI-unit-symbol }
            when * < 1000 { return self ~ $.SI-unit-symbol }
            when * < 1_000_000 { return self / 1_000 ~ 'k' ~ $.SI-unit-symbol }
            # ...
        }
    }
}

role SI-second   does Unitish[<s>] {}
role SI-meter    does Unitish[<m>] {}
role SI-kilogram does Unitish[<g>] {}

sub postfix:<s>(Numeric $num) { ($num) does SI-second }
sub postfix:<m>(Numeric $num) { ($num) does SI-meter }
sub postfix:<g>(Numeric $num) { ($num) does SI-kilogram }
sub postfix:<kg>(Numeric $num){ ($num * 1000) does SI-kilogram }

constant g = 9.806_65;

role SI-Newton does Unitish[<N>] {}

multi sub N(SI-kilogram $kg, SI-meter $m, SI-second $s --> SI-Newton ){ ($kg * ($m / $s²)) does SI-Newton }
multi sub N(SI-kilogram $kg --> SI-Newton)                            { ($kg * g) does SI-Newton }

say [75kg, N(75kg)];
# OUTPUT: «[75kg 735.49875kN]␤»
say [(75kg).^name, N(75kg).^name];
# OUTPUT: «[Int+{SI-kilogram} Rat+{SI-Newton}]␤»
```

<a id="%E7%89%88%E6%9C%AC%E6%8E%A7%E5%88%B6%E5%92%8C%E4%BD%9C%E8%80%85--versioning-and-authorship-1"></a>
### 版本控制和作者 / Versioning and authorship

版本控制和作者可以通过副词 `:ver<>` 和 `:auth<>` 指定。两者都使用一个字符串作为参数，因为 `:ver` 字符串被转换为一个 [Version](https://docs.perl6.org/type/Version) 对象。若要查询类的版本和作者使用 `.^ver` 和 `^.auth`。

Versioning and authorship can be applied via the adverbs `:ver<>` and `:auth<>`. Both take a string as argument, for `:ver` the string is converted to a [Version](https://docs.perl6.org/type/Version) object. To query a role's version and author use `.^ver` and `^.auth`.

```Perl6
role R:ver<4.2.3>:auth<me@here.local> {}
say [R.^ver, R.^auth];
# OUTPUT: «[v4.2.3 me@here.local]␤»
```

<a id="enum"></a>
## `enum`

枚举提供具有关联类型的常量键值对。任何键都是该类型的，并作为符号注入到当前范围中。如果使用符号，则将其视为常量表达式，并将符号替换为枚举键值对的值。任何枚举都从角色 [`Enumeration`](https://docs.perl6.org/type/Enumeration) 继承方法。不支持用于生成键值对的复杂表达式。一般来说，`enum` 是一个元素中混入了 `Enumeration` 角色的 [Map](https://docs.perl6.org/type/Map)；这个角色对于每个元素包括一个索引，它在 map 上创建了一个顺序。

Enumerations provide constant key-value-pairs with an associated type. Any key is of that type and injected as a symbol into the current scope. If the symbol is used, it is treated as a constant expression and the symbol is replaced with the value of the enum-pair. Any Enumeration inherits methods from the role [`Enumeration`](https://docs.perl6.org/type/Enumeration). Complex expressions for generating key-value pairs are not supported. In general, an `enum` is a [Map](https://docs.perl6.org/type/Map) whose elements have the `Enumeration` role mixed in; this role includes, for each element, an index which creates an order on the map.

符号的字符串化，它是在字符串上下文中自动完成的，与其名称完全相等，这也是枚举对的关键。

Stringification of the symbol, which is done automatically in string context and is exactly equal to its name, which is also the key of the enum-pair.

```Perl6
enum Names ( name1 => 1, name2 => 2 );
say name1, ' ', name2; # OUTPUT: «name1 name2␤»
say name1.value, ' ', name2.value; # OUTPUT: «1 2␤»
```

比较符号将使用类型信息和枚举对的值。因为值类型支持 `Num` 和 `Str`。

Comparing symbols will use type information and the value of the enum-pair. As value types `Num` and `Str` are supported.

```Perl6
enum Names ( name1 => 1, name2 => 2 );
sub same(Names $a, Names $b){
   $a eqv $b
}

say same(name1, name1); # OUTPUT: «True␤»
say same(name1, name2); # OUTPUT: «False␤»
my $a = name1;
say $a ~~ Names; # OUTPUT: «True␤»
say $a.^name;    # OUTPUT: «Names␤»
```

所有的键都必须是同类型的。

All keys have to be of the same type.

```Perl6
enum Mass ( mg => 1/1000, g => 1/1, kg => 1000/1 );

say Mass.enums;
# OUTPUT: «Map.new((g => 1, kg => 1000, mg => 0.001))␤»
```

你可以使用任何一种符号：

And you can use any kind of symbol:

```Perl6
enum Suit <♣ ♦ ♥ ♠>;
```

只要您使用完整的语法引用该符号：

As long as you refer to that symbol using the full syntax:

```Perl6
say Suit::<♣>; # OUTPUT: «♣␤»
```

试图不使用上述语法访问 Unicode 枚举键将导致错误：

Attempting to access unicode enum keys without said syntax will result in an error:

```Perl6
say ♣ ; # OUTPUT: «(exit code 1) ===SORRY!===␤Argument to "say" seems to be    malformed…
```

如果没有给定值，`Int` 将被假定为值类型，并从零开始每键递增 1。作为 enum 键类型支持 `Int`、`Num`、`Rat` 和 `Str`。

If no value is given `Int` will be assumed as the values type and incremented by one per key starting at zero. As enum key types `Int`, `Num`, `Rat` and `Str` are supported.

```Perl6
enum Numbers <one two three four>;

say Numbers.enums;
# OUTPUT: «Map.new((four => 3, one => 0, three => 2, two => 1))␤»
```

可以提供不同的起始值。

A different starting value can be provided.

```Perl6
enum Numbers «:one(1) two three four»;

say Numbers.enums;
# OUTPUT: «Map.new((four => 4, one => 1, three => 3, two => 2))␤»
```

你也可以使用 **()** 形式来初始化，但是需要引号括起来没有值的键：

You can also do this with the **()** form of the initializer, but will need to quote keys that do not have a value:

```Perl6
enum Numbers (
  one => 1,
  'two',
  'three',
  'four'
);
```

Enum 也可以是匿名的，唯一的区别是你不能在 `Signature` 中使用它，也不能声明变量。

Enums can also be anonymous, with the only difference with named `enum`s being that you cannot use it in `Signature`s or to declare variables.

```Perl6
my $e = enum <one two three>;
say two;       # OUTPUT: «two␤»
say one.^name; # OUTPUT: «␤»
say $e.^name;  # OUTPUT: «Map␤»
```

There are various methods to get access to the keys and values of the symbols that have been defined. All of them turn the values into `Str`, which may not be desirable. By treating the enum as a package, we can get a list of types for the keys.

```Perl6
enum E(<one two>);
my @keys = E::.values;
say @keys.map: *.enums;
# OUTPUT: «(Map.new((one => 0, two => 1)) Map.new((one => 0, two => 1)))␤»
```

With the use of **()** parentheses, an enum can be defined using any arbitrary dynamically defined list. The list should consist of Pair objects:

For example, in file `config` we have:

```Perl6
a 1 b 2
```

We can create an enum using it with this code:

```Perl6
    enum ConfigValues ('config'.IO.lines.map({ my ($key, $value) = $_.words; $key => $value }));
    say ConfigValues.enums;          # OUTPUT: «Map.new((a => 1, b => 2))␤»
```

Firstly, we read lines from `config` file, split every line using `words` method and return resulting pair for every line, thus creating a List of Pairs.

<a id="metaclass"></a>
### Metaclass

To test if a given type object is an `enum`, test the metaobject method `.HOW` against [Metamodel::EnumHOW](https://docs.perl6.org/type/Metamodel::EnumHOW) or simply test against the `Enumeration` role.

```Perl6
enum E(<a b c>);
say E.HOW ~~ Metamodel::EnumHOW; # OUTPUT: «True␤»
say E ~~ Enumeration;            # OUTPUT: «True␤»
```

<a id="methods"></a>
### Methods

<a id="method-enums"></a>
#### method enums

Defined as:

```Perl6
method enums()
```

Returns the list of enum-pairs.

```Perl6
enum Mass ( mg => 1/1000, g => 1/1, kg => 1000/1 );
say Mass.enums; # OUTPUT: «{g => 1, kg => 1000, mg => 0.001}␤»
```

<a id="coercion"></a>
### Coercion

If you want to coerce the value of an enum element to its proper enum object, use the coercer with the name of the enum:

```Perl6
my enum A (sun => 42, mon => 72);
A(72).pair.say;   # OUTPUT: «mon => 72␤»
A(1000).say; # OUTPUT: «(A)␤»
```

The last example shows what happens if there is no enum-pair that includes that as a value.

<a id="module"></a>
## `module`

Modules are usually one or more source files that expose Perl 6 constructs, such as classes, roles, grammars, subroutines and variables. Modules are usually used for distributing Perl 6 code as libraries which can be used in another Perl 6 program.

For a full explanation see [Modules](https://docs.perl6.org/language/modules).

<a id="versioning-and-authorship"></a>
### Versioning and authorship

Versioning and authorship can be applied via the adverbs `:ver<>` and `:auth<>`. Both take a string as argument, for `:ver` the string is converted to a [Version](https://docs.perl6.org/type/Version) object. To query a modules version and author use `.^ver` and `^.auth`.

```Perl6
module M:ver<4.2.3>:auth<me@here.local> {}
say [M.^ver, M.^auth];
# OUTPUT: «[v4.2.3 me@here.local]␤»
```

<a id="package"></a>
## `package`

Packages are nested namespaces of named program elements. Modules, classes and grammars are all types of package.

For a full explanation see [Packages](https://docs.perl6.org/language/packages).

<a id="grammar"></a>
## `grammar`

Grammars are a specific type of class intended for parsing text. Grammars are composed of rules, tokens and regexes which are actually methods, since grammars are classes.

For a full explanation see [Grammars](https://docs.perl6.org/language/grammars).

<a id="versioning-and-authorship-1"></a>
### Versioning and authorship

Versioning and authorship can be applied via the adverbs `:ver<>` and `:auth<>`. Both take a string as argument, for `:ver` the string is converted to a [Version](https://docs.perl6.org/type/Version) object. To query a grammars version and author use `.^ver` and `^.auth`.

```Perl6
grammar G:ver<4.2.3>:auth<me@here.local> {}
say [G.^ver, G.^auth];
# OUTPUT: «[v4.2.3 me@here.local]␤»
```

<a id="subset"></a>
## `subset`

A `subset` declares a new type that will re-dispatch to its base type. If a [`where`](https://docs.perl6.org/type/Signature#where) clause is supplied any assignment will be checked against the given code object.

```Perl6
subset Positive of Int where * > -1;
my Positive $i = 1;
$i = -42;
CATCH { default { put .^name,': ', .Str } }
# OUTPUT: «X::TypeCheck::Assignment: Type check failed in assignment to $i; expected Positive but got Int (-42)␤»
```

Subsets can be used in signatures, e.g. by typing the output:

```Perl6
subset Foo of List where (Int,Str);
sub a($a, $b, --> Foo) { $a, $b }
# Only a List with the first element being an Int and the second a Str will pass the type check.
a(1, "foo");  # passes
a("foo", 1);  # fails
```

Subsets can be anonymous, allowing inline placements where a subset is required but a name is neither needed nor desirable.

```Perl6
my enum E1 <A B>;
my enum E2 <C D>;
sub g(@a where { .all ~~ subset :: where E1|E2 } ) {
    say @a
}
g([A, C]);
# OUTPUT: «[A C]␤»
```

Subsets can be used to check types dynamically, which can be useful in conjunction with [require](https://docs.perl6.org/language/modules#require).

```Perl6
require ::('YourModule');
subset C where ::('YourModule::C');
```
