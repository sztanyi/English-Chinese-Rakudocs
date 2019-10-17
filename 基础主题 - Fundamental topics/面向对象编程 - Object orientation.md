原文：https://rakudocs.github.io/language/objects

# 面向对象（物件） / Object orientation

Raku 中的面向对象

Object orientation in Raku

Raku 为[面向对象的编程（OOP）](https://en.wikipedia.org/wiki/Object-oriented_programming)提供了强有力的支持。尽管 Raku 允许程序员多范例编程，但面向对象的编程是该语言的核心。

Raku provides strong support for [Object Oriented Programming (OOP)](https://en.wikipedia.org/wiki/Object-oriented_programming). Although Raku allows programmers to program in multiple paradigms, Object Oriented Programming is at the heart of the language.

Raku 有很多预定义的类型，可以分为两类：常规类型和[*原生*类型](https://rakudocs.github.io/language/nativetypes)。你可以存储在变量中的所有内容都是*原生值*或*对象*。它包括文字、类型（类型对象）、代码和容器。

Raku comes with a wealth of predefined types, which can be classified in two categories: regular and [*native* types](https://rakudocs.github.io/language/nativetypes). Everything that you can store in a variable is either a *native value* or an *object*. That includes literals, types (type objects), code and containers.

原生类型用于低级类型（如 `uint64`）。即使*原生*类型不具有与对象相同的功能，如果在它们上调用方法，它们也会自动*装箱*到普通对象中。

Native types are used for low-level types (like `uint64`). Even if *native* types do not have the same capabilities as objects, if you call methods on them, they are automatically *boxed* into normal objects.

所有不是*原生*值的东西都是*对象*。对象确实允许[继承](https://en.wikipedia.org/wiki/Object-oriented_programming#Inheritance_and_behavioral_subtyping)和[封装](https://en.wikipedia.org/wiki/Object-oriented_programming#Encapsulation)。

Everything that is not a *native* value is an *object*. Objects do allow for both [inheritance](https://en.wikipedia.org/wiki/Object-oriented_programming#Inheritance_and_behavioral_subtyping) and [encapsulation](https://en.wikipedia.org/wiki/Object-oriented_programming#Encapsulation).

<!-- MarkdownTOC -->

- [使用对象 / Using objects](#%E4%BD%BF%E7%94%A8%E5%AF%B9%E8%B1%A1--using-objects)
    - [类型对象 / Type objects](#%E7%B1%BB%E5%9E%8B%E5%AF%B9%E8%B1%A1--type-objects)
- [类 / Classes](#%E7%B1%BB--classes)
    - [属性 / Attributes](#%E5%B1%9E%E6%80%A7--attributes)
    - [方法 / Methods](#%E6%96%B9%E6%B3%95--methods)
    - [类和实例方法 / Class and instance methods](#%E7%B1%BB%E5%92%8C%E5%AE%9E%E4%BE%8B%E6%96%B9%E6%B3%95--class-and-instance-methods)
    - [`self`](#self)
    - [私有方法 / Private methods](#%E7%A7%81%E6%9C%89%E6%96%B9%E6%B3%95--private-methods)
    - [子方法 / Submethods](#%E5%AD%90%E6%96%B9%E6%B3%95--submethods)
    - [继承 / Inheritance](#%E7%BB%A7%E6%89%BF--inheritance)
    - [对象构造器 / Object construction](#%E5%AF%B9%E8%B1%A1%E6%9E%84%E9%80%A0%E5%99%A8--object-construction)
    - [对象克隆 / Object cloning](#%E5%AF%B9%E8%B1%A1%E5%85%8B%E9%9A%86--object-cloning)
- [角色 / Roles](#%E8%A7%92%E8%89%B2--roles)
    - [应用角色 / Applying roles](#%E5%BA%94%E7%94%A8%E8%A7%92%E8%89%B2--applying-roles)
    - [占位 / Stubs](#%E5%8D%A0%E4%BD%8D--stubs)
    - [继承 / Inheritance](#%E7%BB%A7%E6%89%BF--inheritance-1)
    - [顺序排行 / Pecking order](#%E9%A1%BA%E5%BA%8F%E6%8E%92%E8%A1%8C--pecking-order)
    - [自动角色双关 / Automatic role punning](#%E8%87%AA%E5%8A%A8%E8%A7%92%E8%89%B2%E5%8F%8C%E5%85%B3--automatic-role-punning)
    - [参数化角色 / Parameterized roles](#%E5%8F%82%E6%95%B0%E5%8C%96%E8%A7%92%E8%89%B2--parameterized-roles)
    - [混合角色 / Mixins of roles](#%E6%B7%B7%E5%90%88%E8%A7%92%E8%89%B2--mixins-of-roles)
- [元对象编程与自省 / Metaobject programming and introspection](#%E5%85%83%E5%AF%B9%E8%B1%A1%E7%BC%96%E7%A8%8B%E4%B8%8E%E8%87%AA%E7%9C%81--metaobject-programming-and-introspection)

<!-- /MarkdownTOC -->


<a id="%E4%BD%BF%E7%94%A8%E5%AF%B9%E8%B1%A1--using-objects"></a>
# 使用对象 / Using objects

若要调用对象上的方法，请添加一个点，后面跟着方法名称：

To call a method on an object, add a dot, followed by the method name:

```Raku
say "abc".uc;
# OUTPUT: «ABC␤» 
```

这就调用了 `"abc"` 上的 `uc` 方法，它是一个类型为 `Str` 的对象。若要向方法提供参数，请在方法后面的括号内添加参数。

This calls the `uc` method on `"abc"`, which is an object of type `Str`. To supply arguments to the method, add arguments inside parentheses after the method.

```Raku
my $formatted-text = "Fourscore and seven years ago...".indent(8);
say $formatted-text;
# OUTPUT: «        Fourscore and seven years ago...␤» 
```

`$formatted-text` 现在包含上面的文本，但缩进了 8 个空格。

`$formatted-text` now contains the above text, but indented 8 spaces.

多个参数用逗号分隔：

Multiple arguments are separated by commas:

```Raku
my @words = "Abe", "Lincoln";
@words.push("said", $formatted-text.comb(/\w+/));
say @words;
# OUTPUT: «[Abe Lincoln said (Fourscore and seven years ago)]␤» 
```

同样，可以通过在方法后面放置冒号并用逗号分隔参数列表来指定多个参数：

Similarly, multiple arguments can be specified by placing a colon after the method and separating the argument list with a comma:

```Raku
say @words.join('--').subst: 'years', 'DAYS';
# OUTPUT: «Abe--Lincoln--said--Fourscore and seven DAYS ago␤» 
```

如果你想不使用括号传递参数，则必须在方法后面放置一个 `:`，没有冒号或括号的方法调用是一个没有参数列表的方法调用：

Since you have to put a `:` after the method if you want to pass arguments without parentheses, a method call without a colon or parentheses is unambiguously a method call without an argument list:

```Raku
say 4.log:   ; # OUTPUT: «1.38629436111989␤» ( natural logarithm of 4 ) 
say 4.log: +2; # OUTPUT: «2␤» ( base-2 logarithm of 4 ) 
say 4.log  +2; # OUTPUT: «3.38629436111989␤» ( natural logarithm of 4, plus 2 )
```

许多看起来不像方法调用的操作(例如，智能匹配或将对象插入到字符串中)可能会导致隐性方法调用。

Many operations that don't look like method calls (for example, smartmatching or interpolating an object into a string) might result in method calls under the hood.

方法可以返回可变容器，在这种情况下，可以给方法调用的返回值赋值。这就是如何使用对象的可读写属性：

Methods can return mutable containers, in which case you can assign to the return value of a method call. This is how read-writable attributes to objects are used:

```Raku
$*IN.nl-in = "\r\n";
```

在这里，我们在 `$*IN` 对象上调用方法 `nl-in`，不带参数，并将其赋值为用 [`=`](https://rakudocs.github.io/routine/=) 返回的容器。

Here, we call method `nl-in` on the `$*IN` object, without arguments, and assign to the container it returned with the [`=`](https://rakudocs.github.io/routine/=) operator.

所有对象都支持类 [Mu](https://rakudocs.github.io/type/Mu) 中的方法。所有对象都是从 `Mu` 派生出来的。

All objects support methods from class [Mu](https://rakudocs.github.io/type/Mu), which is the type hierarchy root. All objects derive from `Mu`.

<a id="%E7%B1%BB%E5%9E%8B%E5%AF%B9%E8%B1%A1--type-objects"></a>
## 类型对象 / Type objects

类型本身就是对象，你可以通过直接输入它的名称来获得*类型对象*：

Types themselves are objects and you can get the *type object* by writing its name:

```Raku
my $int-type-obj = Int;
```

你可以通过调用 `WHAT` 方法来获得任何东西的类型对象，该方法实际上是一个方法形式的宏：

You can request the type object of anything by calling the `WHAT` method, which is actually a macro in method form:

```Raku
my $int-type-obj = 1.WHAT;
```

类型对象（不包括 [Mu](https://rakudocs.github.io/type/Mu)）可用 [`===`](https://rakudocs.github.io/routine/===) 运算符比较标识：

Type objects (other than [Mu](https://rakudocs.github.io/type/Mu)) can be compared for equality with the [`===`](https://rakudocs.github.io/routine/===) identity operator:

```Raku
sub f(Int $x) {
    if $x.WHAT === Int {
        say 'you passed an Int';
    }
    else {
        say 'you passed a subtype of Int';
    }
}
```

尽管在大多数情况下，[`.isa`](https://rakudocs.github.io/routine/isa) 方法已经足够：

Although, in most cases, the [`.isa`](https://rakudocs.github.io/routine/isa) method will suffice:

```Raku
sub f($x) {
    if $x.isa(Int) {
        ...
    }
    ...
}
```

子类型检查可以使用[智能匹配](https://rakudocs.github.io/language/operators#infix_~~)完成：

Subtype checking is done by [smartmatching](https://rakudocs.github.io/language/operators#infix_~~):

```Raku
if $type ~~ Real {
    say '$type contains Real or a subtype thereof';
}
```

<a id="%E7%B1%BB--classes"></a>
# 类 / Classes

类使用 `class` 关键字声明，通常后面跟着名称。

Classes are declared using the `class` keyword, typically followed by a name.

```Raku
class Journey { }
```

此声明将导致在当前包和当前词法作用域中创建一个类型对象，名为 `Journey`。你还可以在词法作用域上声明类：

This declaration results in a type object being created and installed in the current package and current lexical scope under the name `Journey`. You can also declare classes lexically:

```Raku
my class Journey { }
```

这限制了它们对当前词法作用域的可见性，如果类是嵌套在模块或其他类中的实现详细信息，则这将非常有用。

This restricts their visibility to the current lexical scope, which can be useful if the class is an implementation detail nested inside a module or another class.

<a id="%E5%B1%9E%E6%80%A7--attributes"></a>
## 属性 / Attributes 

属性是存在类实例中的变量；当实例化时，变量与其值之间的关联称为属性。它们是存储对象状态的地方。在 Raku 中，所有属性都是*私有*，这意味着它们只能由类实例本身直接访问。它们通常使用 `has` 声明符和 `!` 符号声明。

Attributes are variables that exist per instance of a class; when instantiated to a value, the association between the variable and its value is called a property. They are where the state of an object is stored. In Raku, all attributes are *private*, which means they can be accessed directly only by the class instance itself. They are typically declared using the `has` declarator and the `!` twigil.

```Raku
class Journey {
    has $!origin;
    has $!destination;
    has @!travelers;
    has $!notes;
}
```

虽然不存在公共(甚至是受保护的)属性，但有一种方法可以自动生成访问器方法：将 `!` 替换为 `.`（`.` 应该会使你想到方法调用）。

While there is no such thing as a public (or even protected) attribute, there is a way to have accessor methods generated automatically: replace the `!` twigil with the `.` twigil (the `.` should remind you of a method call).

```Raku
class Journey {
    has $.origin;
    has $.destination;
    has @!travelers;
    has $.notes;
}
```

默认提供只读访问器。为了允许对属性进行更改，添加 [is rw](https://rakudocs.github.io/routine/is%20rw) 特性：

This defaults to providing a read-only accessor. In order to allow changes to the attribute, add the [is rw](https://rakudocs.github.io/routine/is%20rw) trait:

```Raku
class Journey {
    has $.origin;
    has $.destination;
    has @!travelers;
    has $.notes is rw;
}
```

现在，在创建了 `Journey` 对象之后，它的 `.origin`、`.destination` 和 `.notes` 都可以从类之外访问，但只有 `.notes` 能被修改。

Now, after a `Journey` object is created, its `.origin`, `.destination`, and `.notes` will all be accessible from outside the class, but only `.notes` can be modified.

如果一个对象实例化时没有指定特定的属性，例如 origin 或 destination，我们可能无法得到想要的结果。为了防止出现这种情况，请提供默认值，或通过使用 [is required](https://rakudocs.github.io/routine/is%20required) 特性标记属性，确保在创建对象时设置属性。

If an object is instantiated without certain attributes, such as origin or destination, we may not get the desired result. To prevent this, provide default values or make sure that an attribute is set on object creation by marking an attribute with an [is required](https://rakudocs.github.io/routine/is%20required) trait.

```Raku
class Journey {
    # error if origin is not provided 
    has $.origin is required;
    # set the destination to Orlando as default (unless that is the origin!) 
    has $.destination = self.origin eq 'Orlando' ?? 'Kampala' !! 'Orlando';
    has @!travelers;
    has $.notes is rw;
}
```

因为类继承了 `Mu` 的默认构造函数，并且我们请求为我们生成一些访问器方法，所以我们的类已经有点功能了。

Since classes inherit a default constructor from `Mu` and we have requested that some accessor methods are generated for us, our class is already somewhat functional.

```Raku
# Create a new instance of the class. 
my $vacation = Journey.new(
    origin      => 'Sweden',
    destination => 'Switzerland',
    notes       => 'Pack hiking gear!'
);
 
# Use an accessor; this outputs Sweden. 
say $vacation.origin;
 
# Use an rw accessor to change the value. 
$vacation.notes = 'Pack hiking gear and sunglasses!';
```

注意，尽管默认构造函数可以初始化只读属性，但它将只设置具有访问器方法的属性。也就是说，即使你向默认构造函数传递 `travelers => ["Alex", "Betty"]`，属性 `@!travelers` 也不会初始化。

Note that, although the default constructor can initialize read-only attributes, it will only set attributes that have an accessor method. That is, even if you pass `travelers => ["Alex", "Betty"]` to the default constructor, the attribute `@!travelers` is not initialized.

<a id="%E6%96%B9%E6%B3%95--methods"></a>
## 方法 / Methods

方法在类中使用 `method` 关键字声明。

Methods are declared with the `method` keyword inside a class body.

```Raku
class Journey {
    has $.origin;
    has $.destination;
    has @!travelers;
    has $.notes is rw;
 
    method add-traveler($name) {
        if $name ne any(@!travelers) {
            push @!travelers, $name;
        }
        else {
            warn "$name is already going on the journey!";
        }
    }
 
    method describe() {
        "From $!origin to $!destination"
    }
}
```

方法可以有签名，就像子例程一样。属性可以在方法中使用，任何时候都可以与 `!` 号一起使用，即使它们是用 `.` 号声明的。这是因为 `.` 号声明了一个 `!` 号的属性，并生成了一个访问器方法。

A method can have a signature, just like a subroutine. Attributes can be used in methods and can always be used with the `!` twigil, even if they are declared with the `.` twigil. This is because the `.` twigil declares a `!` twigil and generates an accessor method.

从上面的代码来看，在方法 `describe` 中使用 `$!origin` 和 `$.origin` 之间有一个微妙但重要的区别。`$!origin` 是对该属性的一种廉价而明显的查找。`$.origin` 是一个方法调用，因此可以在子类中重写。如果要允许重写，请只使用 `$.origin`。

Looking at the code above, there is a subtle but important difference between using `$!origin` and `$.origin` in the method `describe`. `$!origin` is an inexpensive and obvious lookup of the attribute. `$.origin` is a method call and thus may be overridden in a subclass. Only use `$.origin` if you want to allow overriding.

与子例程不同，额外的命名参数不会产生编译时间或运行时错误。这允许通过 [Re-dispatching](https://rakudocs.github.io/language/functions#Re-dispatching) 链式调用方法。

Unlike subroutines, additional named arguments will not produce compile time or runtime errors. That allows chaining of methods via [Re-dispatching](https://rakudocs.github.io/language/functions#Re-dispatching).

你可以编写自己的访问器来覆盖自动生成的访问器。

You may write your own accessors to override any or all of the autogenerated ones.

```Raku
my $ⲧ = " " xx 4; # A tab-like thing 
class Journey {
    has $.origin;
    has $.destination;
    has @.travelers;
    has Str $.notes is rw;
 
    multi method notes() { "$!notes\n" };
    multi method notes( Str $note ) { $!notes ~= "$note\n$ⲧ" };
 
    method Str { "⤷ $!origin\n$ⲧ" ~ self.notes() ~ "$!destination ⤶\n" };
}
 
my $trip = Journey.new( :origin<Here>, :destination<There>,
                        travelers => <þor Freya> );
 
$trip.notes("First steps");
notes $trip: "Almost there";
print $trip;
 
# OUTPUT: 
#⤷ Here 
#       First steps 
#       Almost there 
# 
#There ⤶ 
```

multi 方法 `notes` 覆盖 `$.notes` 中隐含的自动生成的方法，用不同的签名区分读写。

The declared multi method `notes` overrides the auto-generated methods implicit in the declaration of `$.notes`, using a different signature for reading and writing.

请注意，在 `notes $trip: "Almost there"` 中，我们使用的是间接调用语法，它首先是方法名，然后是对象，然后用冒号分隔参数：`method invocant: arguments`。我们可以在感觉比经典句点更自然的时候使用这个语法，并加上括号。它的工作方式完全相同。

Please note that in `notes $trip: "Almost there"` we are using indirect invocant syntax, which puts first the method name, then the object, and then, separated by a colon, the arguments: `method invocant: arguments`. We can use this syntax whenever it feels more natural than the classical period-and-parentheses one. It works exactly in the same way.

方法名称可以在运行时使用 `.""` 操作符解析。

Method names can be resolved at runtime with the `.""` operator.

```Raku
class A { has $.b };
my $name = 'b';
A.new."$name"().say;
# OUTPUT: «(Any)␤» 
```

用于更新 `$.notes` 的语法在本节中与前面的 [Attributes](https://rakudocs.github.io/language/objects#Attributes) 部分相关。作为赋值的替代：

The syntax used to update `$.notes` changed in this section with respect to the previous [Attributes](https://rakudocs.github.io/language/objects#Attributes) section. Instead of an assignment:

```Raku
$vacation.notes = 'Pack hiking gear and sunglasses!';
```

我们现在执行一个方法调用：

we now do a method call:

```Raku
$trip.notes("First steps");
```

覆盖默认的自动生成访问器意味着，不可以对返回值赋值可变容器。方法调用是将计算和逻辑添加到属性更新中的首选方法。许多现代语言可以通过使用 “setter” 方法重载赋值来更新属性。虽然 Raku 可以通过一个 [`Proxy`](https://github.com/perl6/roast/blob/master/S12-attributes/mutators.t) 对象重载赋值操作符，但重载赋值设置复杂逻辑属性是不可取的，因为[较弱的面向对象设计](https://6guts.wordpress.com/2016/11/25/perl-6-is-biased-towards-mutators-being-really-simple-thats-a-good-thing/)。

Overriding the default auto-generated accessor means it is no longer available to provide a mutable container on return for an assignment. A method call is the preferred approach to adding computation and logic to the update of an attribute. Many modern languages can update an attribute by overloading assignment with a “setter” method. While Raku can overload the assignment operator for this purpose with a [`Proxy`](https://github.com/perl6/roast/blob/master/S12-attributes/mutators.t) object, overloading assignment to set attributes with complex logic is currently discouraged as [weaker object oriented design](https://6guts.wordpress.com/2016/11/25/perl-6-is-biased-towards-mutators-being-really-simple-thats-a-good-thing/).

<a id="%E7%B1%BB%E5%92%8C%E5%AE%9E%E4%BE%8B%E6%96%B9%E6%B3%95--class-and-instance-methods"></a>
## 类和实例方法 / Class and instance methods

方法的签名可以有一个*显式调用者*作为它的第一个参数，后面跟一个冒号，这允许方法使用调用方法的对象。

A method's signature can have an *explicit invocant* as its first parameter followed by a colon, which allows for the method to refer to the object it was called on.

```Raku
class Foo {
    method greet($me: $person) {
        say "Hi, I am $me.^name(), nice to meet you, $person";
    }
}
Foo.new.greet("Bob");    # OUTPUT: «Hi, I am Foo, nice to meet you, Bob␤» 
```

在方法签名中提供一个调用方，还允许通过使用[类型约束](https://rakudocs.github.io/type/Signature#Type_constraints)将方法定义为类方法或对象方法。`::?CLASS` 变量可用于在编译时提供类名，并与 `:U`（用于类方法）或 `:D`（用于实例方法）组合使用。

Providing an invocant in the method signature also allows for defining the method as either as a class method, or as an object method, through the use of [type constraints](https://rakudocs.github.io/type/Signature#Type_constraints). The `::?CLASS` variable can be used to provide the class name at compile time, combined with either `:U` (for class methods) or `:D` (for instance methods).

```Raku
class Pizza {
    has $!radius = 42;
    has @.ingredients;
 
    # class method: construct from a list of ingredients 
    method from-ingredients(::?CLASS:U $pizza: @ingredients) {
        $pizza.new( ingredients => @ingredients );
    }
 
    # instance method 
    method get-radius(::?CLASS:D:) { $!radius }
}
my $p = Pizza.from-ingredients: <cheese pepperoni vegetables>;
say $p.ingredients;     # OUTPUT: «[cheese pepperoni vegetables]␤» 
say $p.get-radius;      # OUTPUT: «42␤» 
say Pizza.get-radius;   # This will fail. 
CATCH { default { put .^name ~ ":\n" ~ .Str } };
# OUTPUT: «X::Parameter::InvalidConcreteness:␤ 
#          Invocant of method 'get-radius' must be 
#          an object instance of type 'Pizza', 
#          not a type object of type 'Pizza'. 
#          Did you forget a '.new'?» 
```

一个方法既可以是类方法，也可以是对象方法，方法可以使用 [multi](https://rakudocs.github.io/syntax/multi) 声明符：

A method can be both a class and object method by using the [multi](https://rakudocs.github.io/syntax/multi) declarator:

```Raku
class C {
    multi method f(::?CLASS:U:) { say "class method"  }
    multi method f(::?CLASS:D:) { say "object method" }
}
C.f;       # OUTPUT: «class method␤» 
C.new.f;   # OUTPUT: «object method␤» 
```

<a id="self"></a>
## `self`

在方法中，`self` 一词是可用的，并绑定到调用者对象。`self` 可用于调用调用者的深层次方法，包括构造函数：

Inside a method, the term `self` is available and bound to the invocant object. `self` can be used to call further methods on the invocant, including constructors:

```Raku
class Box {
  has $.data;
 
  method make-new-box-from() {
      self.new: data => $!data;
  }
}
```

`self` 也可以在类或实例方法中使用，但要小心尝试从一种方法中调用另一种方法：

`self` can be used in class or instance methods as well, though beware of trying to invoke one type of method from the other:

```Raku
class C {
    method g()            { 42     }
    method f(::?CLASS:U:) { self.g }
    method d(::?CLASS:D:) { self.f }
}
C.f;        # OUTPUT: «42␤» 
C.new.d;    # This will fail. 
CATCH { default { put .^name ~ ":\n" ~ .Str } };
# OUTPUT: «X::Parameter::InvalidConcreteness:␤ 
#          Invocant of method 'f' must be a type object of type 'C', 
#          not an object instance of type 'C'.  Did you forget a 'multi'?» 
```

`self` 也可以与属性一起使用，只要它们有访问器。`self.a` 将调用属性的访问器，该属性声明为 `has $.a`。但是，`self.a` 和 `$.a` 之间有区别，因为后者将逐项列出；`$.a` 将等同于 `self.a.item` 或 `$(self.a)`。

`self` can also be used with attributes, as long as they have an accessor. `self.a` will call the accessor for an attribute declared as `has $.a`. However, there is a difference between `self.a` and `$.a`, since the latter will itemize; `$.a` will be equivalent to `self.a.item` or `$(self.a)`.

```Raku
class A {
    has $.x = (1, 2, 3);
    method b() { .say for self.x; .say for $.x }
};
A.new.b; # OUTPUT: «1␤2␤3␤(1 2 3)␤» 
```

方法参数的冒号语法仅支持使用 `self` 的方法调用，而不是快捷方式。

The colon-syntax for method arguments is only supported for method calls using `self`, not the shortcut.

请注意，如果 [Mu](https://rakudocs.github.io/type/Mu) 的相关方法 `bless`、`CREATE` 没有重载，`self` 将指向这些方法中的类型对象。

Note that if the relevant methods `bless`, `CREATE` of [Mu](https://rakudocs.github.io/type/Mu) are not overloaded, `self` will point to the type object in those methods.

另一方面，在初始化的不同阶段调用了 `BUILD` 和 `TWEAK` 等子方法。子类中同名的子方法尚未运行，因此不应依赖这些方法中潜在的虚拟方法调用。

On the other hand, the submethods `BUILD` and `TWEAK` are called on instances, in different stages of initialization. Submethods of the same name from subclasses have not yet run, so you should not rely on potentially virtual method calls inside these methods.

<a id="%E7%A7%81%E6%9C%89%E6%96%B9%E6%B3%95--private-methods"></a>
## 私有方法 / Private methods

在定义类之外的任何地方都不能调用带有 `!` 的方法；这些方法是私有的，因为它们在声明它们的类之外是不可见的。使用感叹号而不是点调用私有方法：

Methods with an exclamation mark `!` before the method name are not callable from anywhere outside the defining class; such methods are private in the sense that they are not visible from outside the class that declares them. Private methods are invoked with an exclamation mark instead of a dot:

```Raku
class FunMath {
    has $.value is required;
    method !do-subtraction( $num ) {
        if $num ~~ Str {
            return $!value + (-1 * $num.chars);
        }
        return $!value + (-1 * $num);
    }
    method minus( $minuend: $subtrahend ) {
        # invoking the private method on the explicit invocant 
        $minuend!do-subtraction($subtrahend);
    }
}
my $five = FunMath.new(value => 5);
say $five.minus(6);         # OUTPUT: «-1␤» 
 
say $five.do-subtraction(6);
CATCH { default { put .^name ~ ":\n" ~ .Str } }
# OUTPUT: «X::Method::NotFound: 
# No such method 'do-subtraction' for invocant of type 
# 'FunMath'. Did you mean '!do-subtraction'?␤» 
```

私有方法不能由子类继承的。

Private methods are not inherited by subclasses.

<a id="%E5%AD%90%E6%96%B9%E6%B3%95--submethods"></a>
## 子方法 / Submethods

子方法是不可由子类继承的公共方法。这个名称源于这样一个事实，即它们在语义上与子例程相似。

Submethods are public methods that will not be inherited by subclasses. The name stems from the fact that they are semantically similar to subroutines.

子方法对于对象构造和销毁任务非常有用，对于特定类型的任务也很有用，因此子类型肯定必须重写它们。

Submethods are useful for object construction and destruction tasks, as well as for tasks that are so specific to a certain type that subtypes would certainly have to override them.

例如，[默认方法 new](https://rakudocs.github.io/type/Mu#method_new) 对[继承](https://rakudocs.github.io/language/objects#Inheritance)链中的每个类调用子方法 `BUILD`：

For example, the [default method new](https://rakudocs.github.io/type/Mu#method_new) calls submethod `BUILD` on each class in an [inheritance](https://rakudocs.github.io/language/objects#Inheritance) chain:

```Raku
class Point2D {
    has $.x;
    has $.y;
 
    submethod BUILD(:$!x, :$!y) {
        say "Initializing Point2D";
    }
}
 
class InvertiblePoint2D is Point2D {
    submethod BUILD() {
        say "Initializing InvertiblePoint2D";
    }
    method invert {
        self.new(x => - $.x, y => - $.y);
    }
}
 
say InvertiblePoint2D.new(x => 1, y => 2);
# OUTPUT: «Initializing Point2D␤» 
# OUTPUT: «Initializing InvertiblePoint2D␤» 
# OUTPUT: «InvertiblePoint2D.new(x => 1, y => 2)␤» 
```

还请参见：[对象构造](https://rakudocs.github.io/language/objects#Object_construction)。

See also: [Object construction](https://rakudocs.github.io/language/objects#Object_construction).

<a id="%E7%BB%A7%E6%89%BF--inheritance"></a>
## 继承 / Inheritance

类可以有*父类*。

Classes can have *parent classes*.

```Raku
class Child is Parent1 is Parent2 { }
```

如果在子类上调用方法，而子类不提供该方法，则将调用父类中某个父类中的该名称的方法(如果该方法存在)。查询父类的顺序称为*方法解析顺序*(MRO)。Raku 使用 [C3 方法解析顺序](https://en.wikipedia.org/wiki/C3_linearization)。你可以通过调用其元类来请求某个类型的 MRO：

If a method is called on the child class, and the child class does not provide that method, the method of that name in one of the parent classes is invoked instead, if it exists. The order in which parent classes are consulted is called the *method resolution order* (MRO). Raku uses the [C3 method resolution order](https://en.wikipedia.org/wiki/C3_linearization). You can ask a type for its MRO through a call to its metaclass:

```Raku
say List.^mro;      # ((List) (Cool) (Any) (Mu)) 
```

如果类没有指定父类，则 [Any](https://rakudocs.github.io/type/Any) 默认为父类。所有类直接或间接地派生自 [Mu](https://rakudocs.github.io/type/Mu)，它是类型层次结构的根。

If a class does not specify a parent class, [Any](https://rakudocs.github.io/type/Any) is assumed by default. All classes directly or indirectly derive from [Mu](https://rakudocs.github.io/type/Mu), the root of the type hierarchy.

对公共方法的所有调用都是“虚拟的”，与 C++ 很像。这意味着对象的实际类型决定要调用的方法，而不是声明的类型：

All calls to public methods are "virtual" in the C++ sense, which means that the actual type of an object determines which method to call, not the declared type:

```Raku
class Parent {
    method frob {
        say "the parent class frobs"
    }
}
 
class Child is Parent {
    method frob {
        say "the child's somewhat more fancy frob is called"
    }
}
 
my Parent $test;
$test = Child.new;
$test.frob;          # calls the frob method of Child rather than Parent 
# OUTPUT: «the child's somewhat more fancy frob is called␤» 
```

<a id="%E5%AF%B9%E8%B1%A1%E6%9E%84%E9%80%A0%E5%99%A8--object-construction"></a>
## 对象构造器 / Object construction

对象通常是通过方法调用来创建的，无论是在类型对象上还是在同一类型的另一个对象上。

Objects are generally created through method calls, either on the type object or on another object of the same type.

类 [Mu](https://rakudocs.github.io/type/Mu) 提供了一个名为 [new](https://rakudocs.github.io/routine/new) 的构造方法，它采用命名[参数](https://rakudocs.github.io/language/functions#Arguments)的方式并使用它们初始化公共属性。

Class [Mu](https://rakudocs.github.io/type/Mu) provides a constructor method called [new](https://rakudocs.github.io/routine/new), which takes named [arguments](https://rakudocs.github.io/language/functions#Arguments) and uses them to initialize public attributes.

```Raku
class Point {
    has $.x;
    has $.y;
}
my $p = Point.new( x => 5, y => 2);
#             ^^^ inherited from class Mu 
say "x: ", $p.x;
say "y: ", $p.y;
# OUTPUT: «x: 5␤» 
# OUTPUT: «y: 2␤» 
```

`Mu.new` 对自己的调用者调用方法 [bless](https://rakudocs.github.io/routine/bless)，将所有的命名[参数](https://rakudocs.github.io/language/functions#Arguments)传递给这个方法。`bless` 创建新对象，然后以反向方法解析顺序遍历所有子类(即从 [Mu](https://rakudocs.github.io/type/Mu) 到大多数派生类)，并在每个类中检查是否存在一个名为 `BUILD` 的方法。如果存在该方法，则使用 `new` 方法中的所有命名参数调用该方法。如果没有，则从同名命名参数初始化该类的公共属性。在这两种情况下，如果 `BUILD` 或默认机制都没有初始化属性，则应用默认值。这意味着 `BUILD` 可以更改一个属性，但它不能访问声明为其默认值的属性的内容；这些内容只有在 `TWEAK`（见下文）期间才可用，可以“查看”类声明中初始化的属性的内容。

`Mu.new` calls method [bless](https://rakudocs.github.io/routine/bless) on its invocant, passing all the named [arguments](https://rakudocs.github.io/language/functions#Arguments). `bless` creates the new object, and then walks all subclasses in reverse method resolution order (i.e. from [Mu](https://rakudocs.github.io/type/Mu) to most derived classes) and in each class checks for the existence of a method named `BUILD`. If the method exists, the method is called with all the named arguments from the `new` method. If not, the public attributes from this class are initialized from named arguments of the same name. In either case, if neither `BUILD` nor the default mechanism has initialized the attribute, default values are applied. This means that `BUILD` may change an attribute, but it does not have access to the contents of the attribute declared as its default; these are available only during `TWEAK` (see below), which can 'see' the contents of an attribute initialized in the declaration of the class.

在调用 `BUILD` 方法之后，如果存在命名为 `TWEAK` 的方法，则再次调用它们，并使用传递给 `new` 的所有命名参数。参见下面使用它的示例。

After the `BUILD` methods have been called, methods named `TWEAK` are called, if they exist, again with all the named arguments that were passed to `new`. See an example of its use below.

由于 `BUILD` 和 `TWEAK` 子方法的默认行为，从 `Mu` 派生的构造函数 `new` 的命名参数可以直接对应任何类的公共属性(按方法解析顺序排列)，也可以与任何 `BUILD` 或 `TWEAK` 子方法的任何命名参数相对应。

Due to the default behavior of `BUILD` and `TWEAK` submethods, named arguments to the constructor `new` derived from `Mu` can correspond directly to public attributes of any of the classes in the method resolution order, or to any named parameter of any `BUILD` or `TWEAK` submethod.

该对象构造方案对自定义构造函数具有一定的影响。首先，自定义的 `BUILD` 方法应该始终是子方法，否则它们会中断子类中的属性初始化。第二，可以使用 `BUILD` 子方法在对象构造时运行自定义代码。它们还可用于为属性初始化创建别名：

This object construction scheme has several implications for customized constructors. First, custom `BUILD` methods should always be submethods, otherwise they break attribute initialization in subclasses. Second, `BUILD` submethods can be used to run custom code at object construction time. They can also be used for creating aliases for attribute initialization:

```Raku
class EncodedBuffer {
    has $.enc;
    has $.data;
 
    submethod BUILD(:encoding(:$enc), :$data) {
        $!enc  :=  $enc;
        $!data := $data;
    }
}
my $b1 = EncodedBuffer.new( encoding => 'UTF-8', data => [64, 65] );
my $b2 = EncodedBuffer.new( enc      => 'UTF-8', data => [64, 65] );
#  both enc and encoding are allowed now 
```

由于将实参传递给例程会将实参绑定到形参，因此如果将属性用作参数，则不需要单独的绑定步骤。因此，上面的例子也可以写成：

Since passing arguments to a routine binds the arguments to the parameters, a separate binding step is unnecessary if the attribute is used as a parameter. Hence the example above could also have been written as:

```Raku11 
submethod BUILD(:encoding(:$!enc), :$!data) {
    # nothing to do here anymore, the signature binding 
    # does all the work for us. 
}
```

但是，当属性可能有特殊的类型要求时，使用这种属性的自动绑定时要小心，例如必须是正整数的 `:$!id`。请记住，除非专门处理此属性，否则将分配默认值，默认值为 `Any`，这将导致类型错误。

However, be careful when using this auto-binding of attributes when the attribute may have special type requirements, such as an `:$!id` that must be a positive integer. Remember, default values will be assigned unless you specifically take care of this attribute, and that default value will be `Any`, which would cause a type error.

第三个含义是，如果你想要一个接受位置参数的构造函数，那么你必须编写自己的 `new` 方法：

The third implication is that if you want a constructor that accepts positional arguments, you must write your own `new` method:

```Raku
class Point {
    has $.x;
    has $.y;
    method new($x, $y) {
        self.bless(:$x, :$y);
    }
}
```

然而，这被认为是糟糕的实践，因为它使子类对象的正确初始化变得更加困难。

However this is considered poor practice, because it makes correct initialization of objects from subclasses harder.

另一件要注意的是，在 Raku 中，`new` 这个名字并不特殊。它只是一个常见的约定，在[大多数 Raku 类](https://rakudocs.github.io/routine/new)中都是完全遵循的。你可以从任何方法中调用 `bless` ，也可以使用 `CREATE` 来摆弄低层次的工作。

Another thing to note is that the name `new` is not special in Raku. It is merely a common convention, one that is followed quite thoroughly in [most Raku classes](https://rakudocs.github.io/routine/new). You can call `bless` from any method at all, or use `CREATE` to fiddle around with low-level workings.

`TWEAK` 子方法允许你在对象构造之后检查事物或修改属性：

The `TWEAK` submethod allows you to check things or modify attributes after object construction:

```Raku
class RectangleWithCachedArea {
    has ($.x1, $.x2, $.y1, $.y2);
    has $.area;
    submethod TWEAK() {
        $!area = abs( ($!x2 - $!x1) * ( $!y2 - $!y1) );
    }
}
 
say RectangleWithCachedArea.new( x2 => 5, x1 => 1, y2 => 1, y1 => 0).area;
# OUTPUT: «4␤» 
```

<a id="%E5%AF%B9%E8%B1%A1%E5%85%8B%E9%9A%86--object-cloning"></a>
## 对象克隆 / Object cloning

克隆是使用 [clone](https://rakudocs.github.io/routine/clone) 方法完成的，所有对象都有这个方法，它会浅层克隆公共属性和私有属性。*公共*属性的新值可以作为命名参数提供。

The cloning is done using the [clone](https://rakudocs.github.io/routine/clone) method available on all objects, which shallow-clones both public and private attributes. New values for *public* attributes can be supplied as named arguments.

```Raku
class Foo {
    has $.foo = 42;
    has $.bar = 100;
}
 
my $o1 = Foo.new;
my $o2 = $o1.clone: :bar(5000);
say $o1; # Foo.new(foo => 42, bar => 100) 
say $o2; # Foo.new(foo => 42, bar => 5000) 
```

有关如何克隆非标量属性的详细信息，以及实现你自己的自定义克隆方法的示例，请参阅 [clone](https://rakudocs.github.io/routine/clone) 文档。

See document for [clone](https://rakudocs.github.io/routine/clone) for details on how non-scalar attributes get cloned, as well as examples of implementing your own custom clone methods.

<a id="%E8%A7%92%E8%89%B2--roles"></a>
# 角色 / Roles

角色是属性和方法的集合；但是，与类不同的是，角色只用于描述对象行为的一部分；这就是为什么通常将角色*混合*在类和对象中。通常，类用于管理对象，角色用于管理对象中的行为和代码重用。

Roles are a collection of attributes and methods; however, unlike classes, roles are meant for describing only parts of an object's behavior; this is why, in general, roles are intended to be *mixed in* classes and objects. In general, classes are meant for managing objects and roles are meant for managing behavior and code reuse within objects.

角色使用关键字 `role` 后接角色名称声明。角色在使用混合角色的名称之前的 `does` 关键字时是混合的。

Roles use the keyword `role` preceding the name of the role that is declared. Roles are mixed in using the `does` keyword preceding the name of the role that is mixed in.

```Raku
constant t = " " xx 4; #Just a ⲧab 
role Notable {
    has Str $.notes is rw;
 
    multi method notes() { "$!notes\n" };
    multi method notes( Str $note ) { $!notes ~= "$note\n" ~ t };
 
}
 
class Journey does Notable {
    has $.origin;
    has $.destination;
    has @.travelers;
 
    method Str { "⤷ $!origin\n" ~ t ~ self.notes() ~ "$!destination ⤶\n" };
}
 
my $trip = Journey.new( :origin<Here>, :destination<There>,
                        travelers => <þor Freya> );
 
$trip.notes("First steps");
notes $trip: "Almost there";
print $trip;
# OUTPUT: 
#⤷ Here 
#       First steps 
#       Almost there 
# 
#There ⤶ 
```

一旦编译器解析了角色声明的结束大括号，角色就是不可变的。

Roles are immutable as soon as the compiler parses the closing curly brace of the role declaration.

<a id="%E5%BA%94%E7%94%A8%E8%A7%92%E8%89%B2--applying-roles"></a>
## 应用角色 / Applying roles

角色应用与类继承有很大不同。当角色应用于类时，该角色的方法将复制到类中。如果对同一个类应用了多个角色，冲突（例如属性或同名的 non-multi 方法）会导致编译时错误，可以通过在类中提供同名的方法来解决。

Role application differs significantly from class inheritance. When a role is applied to a class, the methods of that role are copied into the class. If multiple roles are applied to the same class, conflicts (e.g. attributes or non-multi methods of the same name) cause a compile-time error, which can be solved by providing a method of the same name in the class.

这比多继承安全得多，因为在继承中编译器不检测冲突，而是解析到在方法解析顺序中更早出现的超类中的方法，这可能不是程序员所希望的。

This is much safer than multiple inheritance, where conflicts are never detected by the compiler, but are instead resolved to the superclass that appears earlier in the method resolution order, which might not be what the programmer wanted.

例如，如果你发现了一种有效的驾驶牛的方法，并且试图将其作为一种新的流行交通方式进行销售，那么你可能会有一个类别 `Bull`（对于所有的牛），对于你可以驾驶的东西，你可能会有一个 `Automobile` 类。

For example, if you've discovered an efficient method to ride cows, and are trying to market it as a new form of popular transportation, you might have a class `Bull`, for all the bulls you keep around the house, and a class `Automobile`, for things that you can drive.

```Raku
class Bull {
    has Bool $.castrated = False;
    method steer {
        # Turn your bull into a steer 
        $!castrated = True;
        return self;
    }
}
class Automobile {
    has $.direction;
    method steer($!direction) { }
}
class Taurus is Bull is Automobile { }
 
my $t = Taurus.new;
say $t.steer;
# OUTPUT: «Taurus.new(castrated => Bool::True, direction => Any)␤» 
```

通过这种设置，你的可怜的客户将发现自己无法改变他们的 Taurus，你将无法制造更多的你的产品！在这种情况下，最好使用角色：

With this setup, your poor customers will find themselves unable to turn their Taurus and you won't be able to make more of your product! In this case, it may have been better to use roles:

```Raku
role Bull-Like {
    has Bool $.castrated = False;
    method steer {
        # Turn your bull into a steer 
        $!castrated = True;
        return self;
    }
}
role Steerable {
    has Real $.direction;
    method steer(Real $d = 0) {
        $!direction += $d;
    }
}
class Taurus does Bull-Like does Steerable { }
```

这段代码会终止并报编译时错误：

This code will die with something like:

```Raku
===SORRY!===
Method 'steer' must be resolved by class Taurus because it exists in
multiple roles (Steerable, Bull-Like)
```

这种检查能让你省去很多麻烦：

This check will save you a lot of headaches:

```Raku
class Taurus does Bull-Like does Steerable {
    method steer($direction?) {
        self.Steerable::steer($direction)
    }
}
```

当一个角色被应用到第二个角色时，实际的应用会被延迟，直到第二个角色被应用到一个类，此时这两个角色都被应用到这个类。因此

When a role is applied to a second role, the actual application is delayed until the second role is applied to a class, at which point both roles are applied to the class. Thus

```Raku
role R1 {
    # methods here 
}
role R2 does R1 {
    # methods here 
}
class C does R2 { }
```

生成与 `C` 相同的类

produces the same class `C` as

```Raku
role R1 {
    # methods here 
}
role R2 {
    # methods here 
}
class C does R1 does R2 { }
```

<a id="%E5%8D%A0%E4%BD%8D--stubs"></a>
## 占位 / Stubs

当角色包含[占位](https://rakudocs.github.io/routine/...)方法时，必须在角色应用于类时提供同名方法的非占位版本。这允许你创建充当抽象接口的角色。

When a role contains a [stubbed](https://rakudocs.github.io/routine/...) method, a non-stubbed version of a method of the same name must be supplied at the time the role is applied to a class. This allows you to create roles that act as abstract interfaces.

```Raku
role AbstractSerializable {
    method serialize() { ... }        # literal ... here marks the 
                                      # method as a stub 
}
 
# the following is a compile time error, for example 
#        Method 'serialize' must be implemented by Point because 
#        it's required by a role 
 
class APoint does AbstractSerializable {
    has $.x;
    has $.y;
}
 
# this works: 
class SPoint does AbstractSerializable {
    has $.x;
    has $.y;
    method serialize() { "p($.x, $.y)" }
}
```

占位方法的实现也可以由另一个角色提供。

The implementation of the stubbed method may also be provided by another role.

<a id="%E7%BB%A7%E6%89%BF--inheritance-1"></a>
## 继承 / Inheritance

角色不能从类继承，但它们可能*承载*类，从而导致执行该角色的任何类从所承载的类继承。所以如果你写：

Roles cannot inherit from classes, but they may *carry* classes, causing any class which does that role to inherit from the carried classes. So if you write:

```Raku
role A is Exception { }
class X::Ouch does A { }
X::Ouch.^parents.say # OUTPUT: «((Exception))␤» 
```

然后 `X::Ouch` 将直接继承异常，正如我们在上面通过列出它的父类所看到的那样。

then `X::Ouch` will inherit directly from Exception, as we can see above by listing its parents.

由于它们没有使用可以正确称为继承的内容，所以角色不是类层次结构的一部分。角色列在 `.^roles` 元方法中，该方法使用 `transitive` 作为标志，用于包含所有级别或仅仅包含第一个级别。尽管如此，类或实例仍然可以使用智能匹配或类型约束进行测试，以查看它是否实施了角色。

As they do not use what can properly be called inheritance, roles are not part of the class hierarchy. Roles are listed with the `.^roles` metamethod instead, which uses `transitive` as flag for including all levels or just the first one. Despite this, a class or instance may still be tested with smartmatches or type constraints to see if it does a role.

```Raku
role F { }
class G does F { }
G.^roles.say;                    # OUTPUT: «((F))␤» 
role Ur {}
role Ar does Ur {}
class Whim does Ar {}; Whim.^roles(:!transitive).say;   # OUTPUT: «((Ar))␤» 
say G ~~ F;                      # OUTPUT: «True␤» 
multi a (F $a) { "F".say }
multi a ($a)   { "not F".say }
a(G);                            # OUTPUT: «F␤» 
```

<a id="%E9%A1%BA%E5%BA%8F%E6%8E%92%E8%A1%8C--pecking-order"></a>
## 顺序排行 / Pecking order

在类中直接定义的方法总是覆盖来自应用角色或继承类的定义。如果不存在此类定义，则来自角色的方法将覆盖从类继承的方法。这既发生在所述类由角色引入时，也发生在所述类直接继承时。

A method defined directly in a class will always override definitions from applied roles or from inherited classes. If no such definition exists, methods from roles override methods inherited from classes. This happens both when said class was brought in by a role, and also when said class was inherited directly.

```Raku
role M {
  method f { say "I am in role M" }
}
 
class A {
  method f { say "I am in class A" }
}
 
class B is A does M {
  method f { say "I am in class B" }
}
 
class C is A does M { }
 
B.new.f; # OUTPUT «I am in class B␤» 
C.new.f; # OUTPUT «I am in role M␤» 
```

注意，multi 方法的每个候选方法都是它自己的方法。在这种情况下，上述情况只适用于两个这样的候选方法有相同的签名。否则，就不存在冲突，而候选人只是被添加到 multi 方法中。

Note that each candidate for a multi-method is its own method. In this case, the above only applies if two such candidates have the same signature. Otherwise, there is no conflict, and the candidate is just added to the multi-method.

<a id="%E8%87%AA%E5%8A%A8%E8%A7%92%E8%89%B2%E5%8F%8C%E5%85%B3--automatic-role-punning"></a>
## 自动角色双关 / Automatic role punning

任何直接实例化角色或将其用作类型对象的尝试都会自动创建与角色同名的类，从而可以透明地使用角色，就像使用类一样。

Any attempt to directly instantiate a role or use it as a type object will automatically create a class with the same name as the role, making it possible to transparently use a role as if it were a class.

```Raku
role Point {
    has $.x;
    has $.y;
    method abs { sqrt($.x * $.x + $.y * $.y) }
    method dimensions { 2 }
}
say Point.new(x => 6, y => 8).abs; # OUTPUT «10␤» 
say Point.dimensions;              # OUTPUT «2␤» 
```

我们将自动创建类称为*双关语*，生成的类是一个*双关*。

We call this automatic creation of classes *punning*, and the generated class a *pun*.

然而，双关语不是由大多数[元编程](https://rakudocs.github.io/language/mop)构造引起的，因为这些结构有时用于直接处理角色。

Punning is not caused by most [metaprogramming](https://rakudocs.github.io/language/mop) constructs, however, as those are sometimes used to work directly with roles.

<a id="%E5%8F%82%E6%95%B0%E5%8C%96%E8%A7%92%E8%89%B2--parameterized-roles"></a>
## 参数化角色 / Parameterized roles

角色可以参数化，方法是在方括号中给角色签名：

Roles can be parameterized, by giving them a signature in square brackets:

```Raku
role BinaryTree[::Type] {
    has BinaryTree[Type] $.left;
    has BinaryTree[Type] $.right;
    has Type $.node;
 
    method visit-preorder(&cb) {
        cb $.node;
        for $.left, $.right -> $branch {
            $branch.visit-preorder(&cb) if defined $branch;
        }
    }
    method visit-postorder(&cb) {
        for $.left, $.right -> $branch {
            $branch.visit-postorder(&cb) if defined $branch;
        }
        cb $.node;
    }
    method new-from-list(::?CLASS:U: *@el) {
        my $middle-index = @el.elems div 2;
        my @left         = @el[0 .. $middle-index - 1];
        my $middle       = @el[$middle-index];
        my @right        = @el[$middle-index + 1 .. *];
        self.new(
            node    => $middle,
            left    => @left  ?? self.new-from-list(@left)  !! self,
            right   => @right ?? self.new-from-list(@right) !! self,
        );
    }
}
 
my $t = BinaryTree[Int].new-from-list(4, 5, 6);
$t.visit-preorder(&say);    # OUTPUT: «5␤4␤6␤» 
$t.visit-postorder(&say);   # OUTPUT: «4␤6␤5␤» 
```

在这里，签名只包含类型捕获，但是任何签名都可以：

Here the signature consists only of a type capture, but any signature will do:

```Raku
enum Severity <debug info warn error critical>;
 
role Logging[$filehandle = $*ERR] {
    method log(Severity $sev, $message) {
        $filehandle.print("[{uc $sev}] $message\n");
    }
}
 
Logging[$*OUT].log(debug, 'here we go'); # OUTPUT: «[DEBUG] here we go␤» 
```

你可以有同名但不同签名的多个角色；通常的多分派规则适用于选择多个候选者。

You can have multiple roles of the same name, but with different signatures; the normal rules of multi dispatch apply for choosing multi candidates.

<a id="%E6%B7%B7%E5%90%88%E8%A7%92%E8%89%B2--mixins-of-roles"></a>
## 混合角色 / Mixins of roles

角色可以混合到对象中。角色的给定属性和方法将被添加到对象已经拥有的方法和属性中。多个混合器和匿名角色是支持的。

Roles can be mixed into objects. A role's given attributes and methods will be added to the methods and attributes the object already has. Multiple mixins and anonymous roles are supported.

```Raku
role R { method Str() {'hidden!'} };
my $i = 2 but R;
sub f(\bound){ put bound };
f($i); # OUTPUT: «hidden!␤» 
my @positional := <a b> but R;
say @positional.^name; # OUTPUT: «List+{R}␤» 
```

注意，对象使角色混入，而不是对象的类或容器。因此，@ 标记的容器将需要绑定才能使角色保持不变，如示例中所示的 `@positional`。一些操作符将返回一个新的值，这将有效地从结果中剥离混合。这就是为什么在声明变量时使用 `does` 混入角色的可能会更加清楚：

Note that the object got the role mixed in, not the object's class or the container. Thus, @-sigiled containers will require binding to make the role stick as is shown in the example with `@positional`. Some operators will return a new value, which effectively strips the mixin from the result. That is why it might be more clear to mix in the role in the declaration of the variable using `does`:

```Raku
role R {};
my @positional does R = <a b>;
say @positional.^name; # OUTPUT: «Array+{R}␤» 
```

运算符 `infix:<but>` 比列表构造函数窄。提供要混合的角色列表时，始终使用括号。

The operator `infix:<but>` is narrower than the list constructor. When providing a list of roles to mix in, always use parentheses.

```Raku
role R1 { method m {} }
role R2 { method n {} }
my $a = 1 but R1,R2; # R2 is in sink context, issues a WARNING 
say $a.^name;
# OUTPUT: «Int+{R1}␤» 
my $all-roles = 1 but (R1,R2);
say $all-roles.^name; # OUTPUT: «Int+{R1,R2}␤» 
```

角色混入可以在对象生命周期的任意时刻使用。

Mixins can be used at any point in your object's life.

```Raku
# A counter for Table of Contents 
role TOC-Counter {
    has Int @!counters is default(0);
    method Str() { @!counters.join: '.' }
    method inc($level) {
        @!counters[$level - 1]++;
        @!counters.splice($level);
        self
    }
}
 
my Num $toc-counter = NaN;     # don't do math with Not A Number 
say $toc-counter;              # OUTPUT: «NaN␤» 
$toc-counter does TOC-Counter; # now we mix the role in 
$toc-counter.inc(1).inc(2).inc(2).inc(1).inc(2).inc(2).inc(3).inc(3);
put $toc-counter / 1;          # OUTPUT: «NaN␤» (because that's numerical context) 
put $toc-counter;              # OUTPUT: «2.2.2␤» (put will call TOC-Counter::Str) 
```

角色可以是匿名的。

Roles can be anonymous.

```Raku
my %seen of Int is default(0 but role :: { method Str() {'NULL'} });
say %seen<not-there>;          # OUTPUT: «NULL␤» 
say %seen<not-there>.defined;  # OUTPUT: «True␤» (0 may be False but is well defined) 
say Int.new(%seen<not-there>); # OUTPUT: «0␤» 
```

<a id="%E5%85%83%E5%AF%B9%E8%B1%A1%E7%BC%96%E7%A8%8B%E4%B8%8E%E8%87%AA%E7%9C%81--metaobject-programming-and-introspection"></a>
# 元对象编程与自省 / Metaobject programming and introspection

Raku 有一个元对象系统，这意味着对象、类、角色、语法、枚举等的行为本身由其他对象控制；这些对象被称为*元对象*。元对象和普通对象一样，是类的实例，在本例中我们称之为*元类*。

Raku has a metaobject system, which means that the behavior of objects, classes, roles, grammars, enums, etc. are themselves controlled by other objects; those objects are called *metaobjects*. Metaobjects are, like ordinary objects, instances of classes, in this case we call them *metaclasses*.

对于每个对象或类，你可以通过调用它的 `.HOW` 来获取元对象。注意，虽然这看起来像一个方法调用，但它的工作机制更像一个宏。

For each object or class you can get the metaobject by calling `.HOW` on it. Note that although this looks like a method call, it works more like a macro.

那么，你能用这个元对象做什么呢？首先，你可以通过比较两个对象是否具有相同的元类来检查它们是否具有相同的元类：

So, what can you do with the metaobject? For one you can check if two objects have the same metaclass by comparing them for equality:

```Raku
say 1.HOW ===   2.HOW;      # OUTPUT: «True␤» 
say 1.HOW === Int.HOW;      # OUTPUT: «True␤» 
say 1.HOW === Num.HOW;      # OUTPUT: «False␤» 
```

Raku 使用 *HOW*（Higher Order Workings）一词来指代元对象系统。因此，毫不奇怪，在 Rakudo 中，控制类行为的元类的类名称为 `Perl6::Metamodel::ClassHOW`。对于每个类，都有一个 `Perl6::Metamodel::ClassHOW` 实例。

Raku uses the word *HOW* (Higher Order Workings) to refer to the metaobject system. Thus it should be no surprise that in Rakudo, the class name of the metaclass that controls class behavior is called `Perl6::Metamodel::ClassHOW`. For each class there is one instance of `Perl6::Metamodel::ClassHOW`.

当然，元模型为你做了更多的事情。例如，它允许你内省对象和类。元对象方法的调用约定是调用元对象上的方法，并将感兴趣的对象作为对象的第一个参数传递给对象。因此，要获取对象的类的名称，可以写成：

But of course the metamodel does much more for you. For example, it allows you to introspect objects and classes. The calling convention for methods on metaobjects is to call the method on the metaobject and pass in the object of interest as first argument to the object. So to get the name of the class of an object, you could write:

```Raku
my $object = 1;
my $metaobject = 1.HOW;
say $metaobject.name($object);      # OUTPUT: «Int␤» 
 
# or shorter: 
say 1.HOW.name(1);                  # OUTPUT: «Int␤» 
```

(其动机是 Raku 还希望允许一个更基于原型的对象系统，而不必为每种类型创建一个新的元对象)。

(The motivation is that Raku also wants to allow a more prototype-based object system, where it's not necessary to create a new metaobject for every type).

有一个快捷方式可以避免两次使用同一个对象：

There's a shortcut to keep from using the same object twice:

```Raku
say 1.^name;                        # OUTPUT: «Int␤» 
# same as 
say 1.HOW.name(1);                  # OUTPUT: «Int␤» 
```

见 [Metamodel::ClassHOW](https://rakudocs.github.io/type/Metamodel::ClassHOW) 关于 `class` 的元类的文档以及[元对象协议的一般文档](https://rakudocs.github.io/language/mop)。

See [Metamodel::ClassHOW](https://rakudocs.github.io/type/Metamodel::ClassHOW) for documentation on the metaclass of `class` and also the [general documentation on the metaobject protocol](https://rakudocs.github.io/language/mop).
