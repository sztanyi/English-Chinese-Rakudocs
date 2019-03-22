原文：https://docs.perl6.org/language/classtut

# 类与对象 / Classes and objects

创建和使用 Perl 6 中类的教程

A tutorial about creating and using classes in Perl 6

Perl 6 有一套丰富的定义和使用类的内建语法。

Perl 6 has a rich built-in syntax for defining and using classes.

默认构造器可以为生成的对象设置属性：

A default constructor allows the setting of attributes for the created object:

```Perl6
class Point {
    has Int $.x;
    has Int $.y;
}
 
class Rectangle {
    has Point $.lower;
    has Point $.upper;
 
    method area() returns Int {
        ($!upper.x - $!lower.x) * ( $!upper.y - $!lower.y);
    }
}
 
# Create a new Rectangle from two Points 
my $r = Rectangle.new(lower => Point.new(x => 0, y => 0), upper => Point.new(x => 10, y => 10));
 
say $r.area(); # OUTPUT: «100
» 
```

你也可以提供你自己的构造器和构造实现。下面例子更详细地展示了 Perl 6 中的依赖操作可能的样子。 它展示了客制化的构造器，私有和公有的属性，子方法，方法以及各种签名。代码不多，但是运行结果很有意思也很有用。

You can also provide your own construction and BUILD implementation. The following, more elaborate example shows how a dependency handler might look in Perl 6. It showcases custom constructors, private and public attributes, Submethods, methods, and various aspects of signatures. It's not a lot of code, and yet the result is interesting and useful.

```Perl6
class Task {
    has      &!callback;
    has Task @!dependencies;
    has Bool $.done;
    
    # Normally doesn't need to be written 
    method new(&callback, *@dependencies) {
        return self.bless(:&callback, :@dependencies);
    }
 
    # BUILD is the equivalent of a constructor in other languages 
    submethod BUILD(:&!callback, :@!dependencies) { }
 
    method add-dependency(Task $dependency) {
        push @!dependencies, $dependency;
    }
 
    method perform() {
        unless $!done {
            .perform() for @!dependencies;
            &!callback();
            $!done = True;
        }
    }
}
 
my $eat =
    Task.new({ say 'eating dinner. NOM!' },
        Task.new({ say 'making dinner' },
            Task.new({ say 'buying food' },
                Task.new({ say 'making some money' }),
                Task.new({ say 'going to the store' })
            ),
            Task.new({ say 'cleaning kitchen' })
        )
    );
 
$eat.perform();
```

# 目录 / Table of Contents

<!-- MarkdownTOC -->

- [从类开始 / Starting with class](#%E4%BB%8E%E7%B1%BB%E5%BC%80%E5%A7%8B--starting-with-class)
- [状态 / State](#%E7%8A%B6%E6%80%81--state)
- [静态字段？ / Static fields?](#%E9%9D%99%E6%80%81%E5%AD%97%E6%AE%B5%EF%BC%9F--static-fields)
- [方法 / Methods](#%E6%96%B9%E6%B3%95--methods)
    - [私有方法 / Private Methods](#%E7%A7%81%E6%9C%89%E6%96%B9%E6%B3%95--private-methods)
- [构造器 / Constructors](#%E6%9E%84%E9%80%A0%E5%99%A8--constructors)
- [类的使用 / Consuming our class](#%E7%B1%BB%E7%9A%84%E4%BD%BF%E7%94%A8--consuming-our-class)
- [继承 / Inheritance](#%E7%BB%A7%E6%89%BF--inheritance)
    - [覆盖继承的方法 / Overriding inherited methods](#%E8%A6%86%E7%9B%96%E7%BB%A7%E6%89%BF%E7%9A%84%E6%96%B9%E6%B3%95--overriding-inherited-methods)
    - [多重继承 / Multiple inheritance](#%E5%A4%9A%E9%87%8D%E7%BB%A7%E6%89%BF--multiple-inheritance)
    - [`also` 声明符 / The `also` declarator](#also-%E5%A3%B0%E6%98%8E%E7%AC%A6--the-also-declarator)
- [内省 / Introspection](#%E5%86%85%E7%9C%81--introspection)

<!-- /MarkdownTOC -->

<a id="%E4%BB%8E%E7%B1%BB%E5%BC%80%E5%A7%8B--starting-with-class"></a>
# 从类开始 / Starting with class

Perl 6 和许多其他语言类似，使用 `class` 关键字来定义一个类。其后的代码块就是用户自己的代码，就像其他代码块一样，但是类通常含有状态以及行为声明。例子中的代码包含通过 `has` 关键字声明的属性（状态）以及通过 `method` 关键字声明的行为。

Perl 6, like many other languages, uses the `class` keyword to define a class. The block that follows may contain arbitrary code, just as with any other block, but classes commonly contain state and behavior declarations. The example code includes attributes (state), introduced through the `has` keyword, and behaviors, introduced through the `method` keyword.

声明一个类默认给当前的包创建了一个新的类型对象（就像通过 `our` 声明的变量）。这个类型对象是类的一个“空实例”。例如，`Int` 和 `Str` 类型指代 Perl 6 中内建类的类型对象。上面的例子使用类名 `Task` 以供其他代码以后来代指它，例如调用 `new` 方法来创建类实例。

Declaring a class creates a new *type object* which, by default, is installed into the current package (just like a variable declared with `our`scope). This type object is an "empty instance" of the class. For example, types such as `Int` and `Str` refer to the type object of one of the Perl 6 built-in classes. The example above uses the class name `Task` so that other code can refer to it later, such as to create class instances by calling the `new` method.

你可以使用 `.DEFINITE` 方法来弄清楚你拥有的是实例还是类型对象：

You can use `.DEFINITE` method to find out if what you have is an instance or a type object:

```Perl6
say Int.DEFINITE; # OUTPUT: «False
» (type object) 
say 426.DEFINITE; # OUTPUT: «True
»  (instance) 
 
class Foo {};
say Foo.DEFINITE;     # OUTPUT: «False
» (type object) 
say Foo.new.DEFINITE; # OUTPUT: «True
»  (instance) 
```

你也可以使用类型笑容符号来指定只接受实例或者类型对象：

You can also use type smileys to only accept instances or type objects:

```Perl6
multi foo (Int:U) { "It's a type object!" }
multi foo (Int:D) { "It's an instance!"   }
say foo Int; # OUTPUT: «It's a type object!
» 
say foo 42;  # OUTPUT: «It's an instance!
» 
```

<a id="%E7%8A%B6%E6%80%81--state"></a>
# 状态 / State

Task 类中前三行都是用来声明属性的（在其他语言中叫*字段*或者*实例存储*）。就像用 `my` 声明的变量不可以在它被声明的作用域之外访问一样，属性也不可以在类之外被访问。这种封装特性是面向对象设计的重要原则。

The first three lines inside the class block all declare attributes (called *fields* or *instance storage* in other languages). Just as a `my`variable cannot be accessed from outside its declared scope, attributes are not accessible outside of the class. This *encapsulation* is one of the key principles of object oriented design.

第一个声明语句定义了一个回调的实例存储 - 为执行对象代表的任务而调用的一小段代码:

The first declaration specifies instance storage for a callback – a bit of code to invoke in order to perform the task that an object represents:

```Perl6
has &!callback;
```

`&` 标记表示这个属性是可被调用的。`!` 字符是叫做符号或者次要标记。符号是变量名字的一部分。在这个例子中，`!` 号强调了这是类的私有属性。

The `&` sigil indicates that this attribute represents something invocable. The `!` character is a *twigil*, or secondary sigil. A twigil forms part of the name of the variable. In this case, the `!` twigil emphasizes that this attribute is private to the class.

第二个声明语句也使用了私有符号：

The second declaration also uses the private twigil:

```Perl6
has Task @!dependencies;
```

但是，这个属性代表的是一组物件，所以需要 `@` 标记。每个物件代表了当前任务完成之前必须要完成的任务。另外，这个属性的类型声明也说明数组只能持有 `Task` 类或其子类。

However, this attribute represents an array of items, so it requires the `@` sigil. These items each specify a task that must be completed before the present one can complete. Furthermore, the type declaration on this attribute indicates that the array may only hold instances of the `Task` class (or some subclass of it).

第三个属性代表任务完成的状态。

The third attribute represents the state of completion of a task:

```Perl6
has Bool $.done;
```

这个标量属性（以 `$` 标记）是 `Bool` 类型。这里使用了 `.` 而非 `!` 。这样，Perl 6 强制封装属性的同时，也避免了你写访问器方法。用 `.` 替换 `!` 时声明了属性 `$!done` 以及访问器方法 `done` 。就像你写了下面代码一样：

This scalar attribute (with the `$` sigil) has a type of `Bool`. Instead of the `!` twigil, the `.` twigil is used. While Perl 6 does enforce encapsulation on attributes, it also saves you from writing accessor methods. Replacing the `!` with a `.` both declares the attribute `$!done` and an accessor method named `done`. It's as if you had written:

```Perl6
has Bool $!done;
method done() { return $!done }
```

注意这不像声明了一个公共属性，像某些语言允许的那样的；你真实地获得了一个私有属性和一个方法，而不用去手写那个方法。你也可以编写自己的访问器方法，如果将来你需要做一些比仅仅返回值更复杂的事情。

Note that this is not like declaring a public attribute, as some languages allow; you really get *both* a private attribute and a method, without having to write the method by hand. You are free instead to write your own accessor method, if at some future point you need to do something more complex than return the value.

注意使用 `.` 会创建对属性有只读权限的方法。如果这个对象的用户想能够重置任务的完成状态（也许想重新执行一遍），可以通过改变属性声明：

Note that using the `.` twigil has created a method that will provide read-only access to the attribute. If instead the users of this object should be able to reset a task's completion state (perhaps to perform it again), you can change the attribute declaration:

```Perl6
has Bool $.done is rw;
```

`is rw` 特性使生成的访问器方法返回可以修改属性值的代码。

The `is rw` trait causes the generated accessor method to return something external code can modify to change the value of the attribute.

你也可以提供默认值给属性（对那些没有访问器的也适用）：

You can also supply default values to attributes (which works equally for those with and without accessors):

```Perl6
has Bool $.done = False;
```

赋值发生在对象构建时。等号右边的求值发生在那段时间，甚至可以引用之前的属性：

The assignment is carried out at object build time. The right-hand side is evaluated at that time, and can even reference earlier attributes:

```Perl6
has Task @!dependencies;
has $.ready = not @!dependencies;
```

<a id="%E9%9D%99%E6%80%81%E5%AD%97%E6%AE%B5%EF%BC%9F--static-fields"></a>
# 静态字段？ / Static fields?

Perl 6 没有 **static** 关键字。然而，任何类都可以声明模组可以声明的任何东西，创建一个有限作用域的变量听起来是个好点子。

Perl 6 has no **static** keyword. Nevertheless, any class may declare anything that a module can, so making a scoped variable sounds like good idea.

```Perl6
class Singleton {
    my Singleton $instance;
    method new {!!!}
    submethod instance {
        $instance = Singleton.bless unless $instance;
        $instance;
    }
}
 
```

通过 [my](https://docs.perl6.org/syntax/my) 或者 [our](https://docs.perl6.org/syntax/our) 定义的类属性也可能在声明时被初始化，但是我们要在这实现单例模式，对象必须在第一次使用时被创建。不可能 100% 预见什么属性初始化的时刻，因为它可以发生在编译时，运行时或者同时，尤其使用 [use](https://docs.perl6.org/syntax/use) 关键字时。

Class attributes defined by [my](https://docs.perl6.org/syntax/my) or [our](https://docs.perl6.org/syntax/our) may also be initialized when being declared, however we are implementing the Singleton pattern here and the object must be created during its first use. It is not 100% possible to predict the moment when attribute initialization will be executed, because it can take place during compilation, runtime or both, especially when importing the class using the [use](https://docs.perl6.org/syntax/use) keyword.

```Perl6
class HaveStaticAttr {
      my Foo $.foo = some_complicated_subroutine;
}
```

类属性也可以通过第二个符号来声明，与声明对象属性类似的方式。如果属性是公有的话它会生成只读访问器。

Class attributes may also be declared with a secondary sigil – in a similar manner to object attributes – that will generate read-only accessors if the attribute is to be public.

<a id="%E6%96%B9%E6%B3%95--methods"></a>
# 方法 / Methods

属性给赋予对象状态，方法赋予对象行为。让我们暂时忽略 `new` 这个特殊方法。考虑第二个方法 `add-dependency` ，它给任务的依赖列表增加了新任务。

While attributes give objects state, methods give objects behaviors. Let's ignore the `new` method temporarily; it's a special type of method. Consider the second method, `add-dependency`, which adds a new task to a task's dependency list.

```Perl6
method add-dependency(Task $dependency) {
    push @!dependencies, $dependency;
}
```

从许多方面看，这个看起来很像一个`函数`定义。但是，它们之间有两个重要的区别。首先，声明例程为方法使其加入当前类的方法列表。这样一来 `Task`  类的任何实例都可以使用方法调用符 `.` 来调用这个方法。其次，方法会将其调用者放置到特殊变量 `self`。

In many ways, this looks a lot like a `sub` declaration. However, there are two important differences. First, declaring this routine as a method adds it to the list of methods for the current class. Thus any instance of the `Task` class can call this method with the `.` method call operator. Second, a method places its invocant into the special variable `self`.

方法本身接受传递的参数（必须是 `Task` 类的一个实例），并将其`推送`到调用方的 `@！dependencies` 属性。

The method itself takes the passed parameter – which must be an instance of the `Task` class – and `push`es it onto the invocant's `@!dependencies` attribute.

`perform` 方法包含依赖关系处理程序的主要逻辑：

The `perform` method contains the main logic of the dependency handler:

```Perl6
method perform() {
    unless $!done {
        .perform() for @!dependencies;
        &!callback();
        $!done = True;
    }
}
```

它不需要参数，而是使用对象的属性。首先，通过检查 `$!done` 来确定任务是否已经完成。如果是这样，那就没什么可做的了。

It takes no parameters, working instead with the object's attributes. First, it checks if the task has already completed by checking the `$!done` attribute. If so, there's nothing to do.

否则，该方法将执行任务的所有依赖项，使用 `for` 构造迭代 `@!dependencies` 中的所有属性。此迭代将每个项（每个项都是一个 `Task` 对象）放入主题变量 `$_`。使用 `.` 方法调用运算符而不指定显式调用者会将当前主题当作调用者。因此，迭代构造对当前调用者的 `@!dependencies` 属性中的每个 `Task` 对象调用 `.perform()` 方法。

Otherwise, the method performs all of the task's dependencies, using the `for` construct to iterate over all of the items in the `@!dependencies` attribute. This iteration places each item – each a `Task` object – into the topic variable, `$_`. Using the `.` method call operator without specifying an explicit invocant uses the current topic as the invocant. Thus the iteration construct calls the `.perform()`method on every `Task` object in the `@!dependencies` attribute of the current invocant.

所有的依赖项完成后，会执行当前 `Task` 的任务，通过执行调用 `&!callback` 属性，这就是括号的目的。最后，方法设置 `$!done` 属性为`真`，后续这个对象的 `perform` 方法调用不会重复这个任务（例如，如果这个 `Task` 是另一个 `Task`的依赖）。

After all of the dependencies have completed, it's time to perform the current `Task`'s task by invoking the `&!callback` attribute directly; this is the purpose of the parentheses. Finally, the method sets the `$!done` attribute to `True`, so that subsequent invocations of `perform`on this object (if this `Task` is a dependency of another `Task`, for example) will not repeat the task.

<a id="%E7%A7%81%E6%9C%89%E6%96%B9%E6%B3%95--private-methods"></a>
## 私有方法 / Private Methods

和属性一样，方法也可以是私有的。私有方法用带前缀的感叹号声明。使用 `self!` 跟方法名调用私有方法。要调用另一个类的私有方法，调用类必须受被调用类的信任。信任关系是用 `trusts` 声明的，并且要信任的类必须已经声明。调用另一个类的私有方法需要该类的实例和该方法的完全限定名。信任还允许访问私有属性。

Just like attributes, methods can also be private. Private methods are declared with a prefixed exclamation mark. They are called with `self!` followed by the method's name. To call a private method of another class the calling class has to be trusted by the called class. A trust relationship is declared with `trusts` and the class to be trusted must already be declared. Calling a private method of another class requires an instance of that class and the fully qualified name of the method. Trust also allows access to private attributes.

```Perl6
class B {...}
 
class C {
    trusts B;
    has $!hidden = 'invisible';
    method !not-yours () { say 'hidden' }
    method yours-to-use () {
        say $!hidden;
        self!not-yours();
    }
}
 
class B {
    method i-am-trusted () {
        my C $c.=new;
        $c!C::not-yours();
    }
}
 
C.new.yours-to-use(); # the context of this call is GLOBAL, and not trusted by C 
B.new.i-am-trusted();
```

信任关系不受继承的约束。要信任全局命名空间，可以使用伪包 `GLOBAL`。

Trust relationships are not subject to inheritance. To trust the global namespace, the pseudo package `GLOBAL` can be used.

<a id="%E6%9E%84%E9%80%A0%E5%99%A8--constructors"></a>
# 构造器 / Constructors

Perl 6 在构造器领域比许多语言更自由。构造器是返回类实例的任何东西。此外，构造器是普通的方法。你从基类 `Mu` 继承了名为 `new` 的默认构造器，但是你可以自由地重写 `new`，如本例所示：

Perl 6 is rather more liberal than many languages in the area of constructors. A constructor is anything that returns an instance of the class. Furthermore, constructors are ordinary methods. You inherit a default constructor named `new` from the base class `Mu`, but you are free to override `new`, as this example does:

```Perl6
method new(&callback, *@dependencies) {
    return self.bless(:&callback, :@dependencies);
}
```

Perl 6 中的构造器和 C 语言与 Java 语言中的构造器之间的最大区别在于，Perl 6 构造器自己创建对象本身，而不是在魔法般已创建的对象上建立状态。最简单的方法是调用 [bless](https://docs.perl6.org/routine/bless) 方法，这个方法也继承自 [Mu]（https://docs.perl6.org/type/mu）。`bless` 方法需要一组命名参数来为每个属性提供初始值。

The biggest difference between constructors in Perl 6 and constructors in languages such as C# and Java is that rather than setting up state on a somehow already magically created object, Perl 6 constructors create the object themselves. The easiest way to do this is by calling the [bless](https://docs.perl6.org/routine/bless) method, also inherited from [Mu](https://docs.perl6.org/type/Mu). The `bless` method expects a set of named parameters to provide the initial values for each attribute.

示例的构造器将位置参数转换为命名参数，这样类就可以为其用户提供一个好的构造器。第一个参数是回调（将执行任务的对象）。其余参数依赖于 `Task` 实例。构造器将这些捕获到 `@dependencies` 吞噬数组中，并将它们作为命名参数传递给 `bless`（注意 `:&callback` 使用变量名减去标记作为参数名）。

The example's constructor turns positional arguments into named arguments, so that the class can provide a nice constructor for its users. The first parameter is the callback (the thing which will execute the task). The rest of the parameters are dependent `Task`instances. The constructor captures these into the `@dependencies` slurpy array and passes them as named parameters to `bless` (note that `:&callback` uses the name of the variable – minus the sigil – as the name of the parameter).

私有属性确实是私有的。这意味着 `bless` 不允许将事物直接绑定到 `&!callback` 和 `@!dependencies`。为了做到这一点，我们重写了 `BUILD` 子方法，这个方法被 `bless` 在全新的对象上调用：

Private attributes really are private. This means that `bless` is not allowed to bind things to `&!callback` and `@!dependencies` directly. To do this, we override the `BUILD` submethod, which is called on the brand new object by `bless`:

```Perl6
submethod BUILD(:&!callback, :@!dependencies) { }
```

因为 `BUILD` 在新创建的 `Task` 对象上下文中运行，可以操作这些私有属性。这里的技巧是私有属性（`&!callback` 和 `@!dependencies`）被用作 `BUILD` 参数的绑定目标。没有初始化样板代码！更多信息见[对象](https://docs.perl6.org/language/objects#Object_Construction)。

Since `BUILD` runs in the context of the newly created `Task` object, it is allowed to manipulate those private attributes. The trick here is that the private attributes (`&!callback` and `@!dependencies`) are being used as the bind targets for `BUILD`'s parameters. Zero-boilerplate initialization! See [objects](https://docs.perl6.org/language/objects#Object_Construction) for more information.

`BUILD` 方法负责初始化所有属性，也必须处理默认值：

The `BUILD` method is responsible for initializing all attributes and must also handle default values:

```Perl6
has &!callback;
has @!dependencies;
has Bool ($.done, $.ready);
submethod BUILD(
        :&!callback,
        :@!dependencies,
        :$!done = False,
        :$!ready = not @!dependencies
    ) { }
```

更多影响对象构建的选项以及属性初始化，参考 [对象构建](https://docs.perl6.org/language/objects#Object_Construction) 。

See [Object Construction](https://docs.perl6.org/language/objects#Object_Construction) for more options to influence object construction and attribute initialization.

<a id="%E7%B1%BB%E7%9A%84%E4%BD%BF%E7%94%A8--consuming-our-class"></a>
# 类的使用 / Consuming our class

类创建后，你才可以创建类实例。声明任务以及他们的依赖的一个简单方法是声明一个自定义构造器。创建一个没有依赖的简单任务：
After creating a class, you can create instances of the class. Declaring a custom constructor provides a simple way of declaring tasks along with their dependencies. To create a single task with no dependencies, write:

```Perl6
my $eat = Task.new({ say 'eating dinner. NOM!' });
```

之前的章节解释了声明 `Task` 类会在命名空间生成一个类型对象。这个类型对象是这个类的一种“空实例”，确切地说是一个没有状态的实例。你可以调用那个实例的方法，只要这些方法不访问任何的状态。 `new` 就是这样的例子，它创建了一个新对象而不是修改或者访问现存的对象。

An earlier section explained that declaring the class `Task` installed a type object in the namespace. This type object is a kind of "empty instance" of the class, specifically an instance without any state. You can call methods on that instance, as long as they do not try to access any state; `new` is an example, as it creates a new object rather than modifying or accessing an existing object.

不幸的是，晚餐不会魔法般冒出来。它有依赖的任务：

Unfortunately, dinner never magically happens. It has dependent tasks:

```Perl6
my $eat =
    Task.new({ say 'eating dinner. NOM!' },
        Task.new({ say 'making dinner' },
            Task.new({ say 'buying food' },
                Task.new({ say 'making some money' }),
                Task.new({ say 'going to the store' })
            ),
            Task.new({ say 'cleaning kitchen' })
        )
    );
```

注意自定义构造器和合理地使用空格怎样使任务依赖更清晰。

Notice how the custom constructor and sensible use of whitespace makes task dependencies clear.

最后，`perform` 方法迭代地对各种各样的其他依赖依次调用 `perform` 方法，输出：

Finally, the `perform` method call recursively calls the `perform` method on the various other dependencies in order, giving the output:

```Perl6
making some money
going to the store
buying food
cleaning kitchen
making dinner
eating dinner. NOM!
```

<a id="%E7%BB%A7%E6%89%BF--inheritance"></a>
# 继承 / Inheritance

面向对象编程采用继承作为代码重用的一种机制。Perl 6 支持一个类从一个或者多个类继承。当一个类从另一个类继承时，它通知方法分派器沿着继承链查找要分派的方法。这既适用于通过 method 关键字定义的标准方法，也适用于通过其他方法（如属性访问器）生成的方法。

Object Oriented Programming provides the concept of inheritance as one of the mechanisms for code reuse. Perl 6 supports the ability for one class to inherit from one or more classes. When a class inherits from another class it informs the method dispatcher to follow the inheritance chain to look for a method to dispatch. This happens both for standard methods defined via the method keyword and for methods generated through other means, such as attribute accessors.

```Perl6
class Employee {
    has $.salary;
 
    method pay() {
        say "Here is \$$.salary";
    }
}
 
class Programmer is Employee {
    has @.known_languages is rw;
    has $.favorite_editor;
 
    method code_to_solve( $problem ) {
        say "Solving $problem using $.favorite_editor in "
        ~ $.known_languages[0] ~ '.';
    }
}
```

现在，Programmer 类型的任何对象都可以使用 Employee 类中定义的方法和访问器，就好像它们来自Programmer类一样。

Now, any object of type Programmer can make use of the methods and accessors defined in the Employee class as though they were from the Programmer class.

```Perl6
my $programmer = Programmer.new(
    salary => 100_000,
    known_languages => <Perl5 Perl6 Erlang C++>,
    favorite_editor => 'vim'
);
 
$programmer.code_to_solve('halting problem');
$programmer.pay();
```

<a id="%E8%A6%86%E7%9B%96%E7%BB%A7%E6%89%BF%E7%9A%84%E6%96%B9%E6%B3%95--overriding-inherited-methods"></a>
## 覆盖继承的方法 / Overriding inherited methods

当然，类可以通过定义自己的类来覆盖父类定义的方法和属性。下面的例子演示了 `Baker` 类覆盖了 `Cook` 的 `cook` 方法。

Of course, classes can override methods and attributes defined by parent classes by defining their own. The example below demonstrates the `Baker` class overriding the `Cook`'s `cook` method.

```Perl6
class Cook is Employee {
    has @.utensils  is rw;
    has @.cookbooks is rw;
 
    method cook( $food ) {
        say "Cooking $food";
    }
 
    method clean_utensils {
        say "Cleaning $_" for @.utensils;
    }
}
 
class Baker is Cook {
    method cook( $confection ) {
        say "Baking a tasty $confection";
    }
}
 
my $cook = Cook.new(
    utensils => <spoon ladle knife pan>,
    cookbooks => 'The Joy of Cooking',
    salary => 40000);
 
$cook.cook( 'pizza' );       # OUTPUT: «Cooking pizza
» 
say $cook.utensils.perl;     # OUTPUT: «["spoon", "ladle", "knife", "pan"]
» 
say $cook.cookbooks.perl;    # OUTPUT: «["The Joy of Cooking"]
» 
say $cook.salary;            # OUTPUT: «40000
» 
 
my $baker = Baker.new(
    utensils => 'self cleaning oven',
    cookbooks => "The Baker's Apprentice",
    salary => 50000);
 
$baker.cook('brioche');      # OUTPUT: «Baking a tasty brioche
» 
say $baker.utensils.perl;    # OUTPUT: «["self cleaning oven"]
» 
say $baker.cookbooks.perl;   # OUTPUT: «["The Baker's Apprentice"]
» 
say $baker.salary;           # OUTPUT: «50000
» 
```

因为调度程序在它移动到父类之前会在 `Baker` 上看到 `cook` 方法，所以将调用 `Baker` 的 `cook` 方法。

Because the dispatcher will see the `cook` method on `Baker` before it moves up to the parent class the `Baker`'s `cook` method will be called.

要访问继承链中的方法，请使用 [re-dispatch](https://docs.perl6.org/language/functions#Re-dispatching) 或 [MOP](https://docs.perl6.org/type/Metamodel::ClassHOW#method_can)。

To access methods in the inheritance chain use [re-dispatch](https://docs.perl6.org/language/functions#Re-dispatching) or the [MOP](https://docs.perl6.org/type/Metamodel::ClassHOW#method_can).

<a id="%E5%A4%9A%E9%87%8D%E7%BB%A7%E6%89%BF--multiple-inheritance"></a>
## 多重继承 / Multiple inheritance

如前所述，类可以从多个类继承。当一个类从多个类继承时，调度程序知道在查找要搜索的方法时查看这两个类。 Perl 6 使用 [C3 算法](https://en.wikipedia.org/wiki/C3_linearization)来线性化多个继承层次结构，这比深度优先搜索更好地处理多重继承。

As mentioned before, a class can inherit from multiple classes. When a class inherits from multiple classes the dispatcher knows to look at both classes when looking up a method to search for. Perl 6 uses the [C3 algorithm](https://en.wikipedia.org/wiki/C3_linearization) to linearize multiple inheritance hierarchies, which is better than depth-first search for handling multiple inheritance.

```Perl6
class GeekCook is Programmer is Cook {
    method new( *%params ) {
        push( %params<cookbooks>, "Cooking for Geeks" );
        return self.bless(|%params);
    }
}
 
my $geek = GeekCook.new(
    books           => 'Learning Perl 6',
    utensils        => ('stainless steel pot', 'knife', 'calibrated oven'),
    favorite_editor => 'MacVim',
    known_languages => <Perl6>
);
 
$geek.cook('pizza');
$geek.code_to_solve('P =? NP');
```

现在可以从 GeekCook 类获得可用于 Programmer 和 Cook 类的所有方法。

Now all the methods made available to the Programmer and the Cook classes are available from the GeekCook class.

虽然多重继承是一个有用的概念，但需要了解并偶尔使用，但重要的是要了解有更多有用的 OOP 概念。在进行多重继承时，最好考虑使用角色是否更好地实现设计，角色通常更安全，因为它们迫使类作者明确解决冲突的方法名称。有关角色的更多信息，请参阅[角色](https://docs.perl6.org/language/objects#Roles)。

While multiple inheritance is a useful concept to know and occasionally use, it is important to understand that there are more useful OOP concepts. When reaching for multiple inheritance it is good practice to consider whether the design wouldn't be better realized by using roles, which are generally safer because they force the class author to explicitly resolve conflicting method names. For more information on roles see [Roles](https://docs.perl6.org/language/objects#Roles).

<a id="also-%E5%A3%B0%E6%98%8E%E7%AC%A6--the-also-declarator"></a>
## `also` 声明符 / The `also` declarator

要继承的类可以在类声明体中列出，方法是将 `is` 特性加上 `also`。这也适用于角色构成特性 `does`。

Classes to be inherited from can be listed in the class declaration body by prefixing the `is` trait with `also`. This also works for the role composition trait `does`.

```Perl6
class GeekCook {
    also is Programmer;
    also is Cook;
    # ... 
}
 
role A {};
role B {};
class C { also does A; also does B }
```

<a id="%E5%86%85%E7%9C%81--introspection"></a>
# 内省 / Introspection

内省是在程序中收集有关某些对象的信息的过程，而不是通过读取源代码，而是通过查询对象（或是一个控制对象）来查找某些属性，例如其类型。

Introspection is the process of gathering information about some objects in your program, not by reading the source code, but by querying the object (or a controlling object) for some properties, such as its type.

给定一个对象 `$o` 和前面几节中的类定义，我们可以问几个问题：

Given an object `$o` and the class definitions from the previous sections, we can ask it a few questions:

```Perl6
if $o ~~ Employee { say "It's an employee" };
if $o ~~ GeekCook { say "It's a geeky cook" };
say $o.WHAT;
say $o.perl;
say $o.^methods(:local)».name.join(', ');
say $o.^name;
```

输出可能如下所示：

The output can look like this:

```Perl6
It's an employee
(Programmer)
Programmer.new(known_languages => ["Perl", "Python", "Pascal"],
        favorite_editor => "gvim", salary => "too small")
code_to_solve, known_languages, favorite_editor
Programmer
```

前两个测试每个智能匹配一个类名。如果对象属于该类或继承类，则返回真值。因此，所讨论的对象是 `Employee` 类或者继承自它的类，而不是 `GeekCook`。

The first two tests each smart-match against a class name. If the object is of that class, or of an inheriting class, it returns true. So the object in question is of class `Employee` or one that inherits from it, but not `GeekCook`.

`.WHAT` 方法返回与对象 `$o` 关联的类型对象，它告诉我们 `$o` 的确切类型：在本例中为 `Programmer`。

The `.WHAT` method returns the type object associated with the object `$o`, which tells us the exact type of `$o`: in this case `Programmer`.

`$o.perl` 返回一个可以作为 Perl 代码执行的字符串，并重现原始对象 `$o`。虽然这在对所有情况不会都完美生效，但它对于调试简单对象非常有用。 [[\]](https://docs.perl6.org/language/classtut#fn-1) `$o.^methods(:local)` 生成对 `$o` 调用的 [Method](https://docs.perl6.org/type/Method) 列表。`:local` 命名参数将返回的方法限制为 `Programmer` 类中定义的方法，并排除继承的方法。

`$o.perl` returns a string that can be executed as Perl code, and reproduces the original object `$o`. While this does not work perfectly in all cases, it is very useful for debugging simple objects. [[\]](https://docs.perl6.org/language/classtut#fn-1) `$o.^methods(:local)` produces a list of [Method](https://docs.perl6.org/type/Method)s that can be called on `$o`. The `:local` named argument limits the returned methods to those defined in the `Programmer` class and excludes the inherited methods.

使用 `.^` 而不是单个点调用方法的语法意味着它实际上是对其*元类*的一个方法调用，它是一个管理 `Programmer` 类的属性的类 - 或任何其他类你感兴趣的类。这个元类也可以实现其他内省方式：

The syntax of calling a method with `.^` instead of a single dot means that it is actually a method call on its *meta class*, which is a class managing the properties of the `Programmer` class – or any other class you are interested in. This meta class enables other ways of introspection too:

```Perl6
say $o.^attributes.join(', ');
say $o.^parents.map({ $_.^name }).join(', ');
```

最后 `$o.^name` 在元对象上调用 `name` 方法，不出所料地返回类名。

Finally `$o.^name` calls the `name` method on the meta object, which unsurprisingly returns the class name.

内省对于调试和学习语言和新库非常有用。当一个函数或方法返回一个你不知道的对象时，用 `.WHAT` 找到它的类型，用 `.perl` 查看它的构造方法，依此类推，你会很清楚它是什么返回值是。使用 `.^methods` 你可以了解如何使用该类。

Introspection is very useful for debugging and for learning the language and new libraries. When a function or method returns an object you don't know about, finding its type with `.WHAT`, seeing a construction recipe for it with `.perl`, and so on, you'll get a good idea of what its return value is. With `.^methods` you can learn what you can do with the class.

但是还有其他应用程序：将对象序列化为一堆字节的例程需要知道该对象的属性，它可以通过内省找到。

But there are other applications too: a routine that serializes objects to a bunch of bytes needs to know the attributes of that object, which it can find out via introspection.

