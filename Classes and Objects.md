原文：https://docs.perl6.org/language/classtut
译者：stanley_tam@163.com

# 类与对象
# Classes and objects

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

# [类](https://docs.perl6.org/language/classtut#___top)

Perl 6 和许多其他语言类似，使用 `class` 关键字来定义一个类。紧随其后的代码块可能包含任意代码，跟其他代码块一样，但是类通常含有状态以及行为声明。例子中的代码包含通过 `has` 关键字声明的属性（状态）以及通过 `method` 关键字声明的行为。

Perl 6, like many other languages, uses the `class` keyword to define a class. The block that follows may contain arbitrary code, just as with any other block, but classes commonly contain state and behavior declarations. The example code includes attributes (state), introduced through the `has` keyword, and behaviors, introduced through the `method` keyword.

声明一个类默认给当前的包创建了一个新的类型对象（就像通过 `our` 声明的变量）。这个类型对象是类的一个“空实例”。例如，`Int` 和 `Str` 类型指代 Perl 6 中内建类的类型对象。上面的例子使用类名 `Task` 以供其他代码以后来代指它，例如调用 `new` 方法来创建类实例。

你可以使用 `.DEFINITE` 方法来区别实例和类型对象：

Declaring a class creates a new *type object* which, by default, is installed into the current package (just like a variable declared with `our`scope). This type object is an "empty instance" of the class. For example, types such as `Int` and `Str` refer to the type object of one of the Perl 6 built-in classes. The example above uses the class name `Task` so that other code can refer to it later, such as to create class instances by calling the `new` method.

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

你也可以使用类型笑容符来指定只接受实例或者类型对象：

You can also use type smileys to only accept instances or type objects:

```Perl6
multi foo (Int:U) { "It's a type object!" }
multi foo (Int:D) { "It's an instance!"   }
say foo Int; # OUTPUT: «It's a type object!
» 
say foo 42;  # OUTPUT: «It's an instance!
» 
```

# [状态](https://docs.perl6.org/language/classtut#___top)

Task 类中前三行代码都是用来声明属性的（在其他语言中叫 *fields* 或者实例存储）。就像用 `my` 声明的变量不可以在它被声明的作用域之外访问一样，属性也不可以在类之外被访问。这种封装特性是面向对象设计的重要原则。

The first three lines inside the class block all declare attributes (called *fields* or *instance storage* in other languages). Just as a `my`variable cannot be accessed from outside its declared scope, attributes are not accessible outside of the class. This *encapsulation* is one of the key principles of object oriented design.

第一个声明语句定义了回调的实例存储 - 为执行对象代表的任务而调用的一些代码。

The first declaration specifies instance storage for a callback – a bit of code to invoke in order to perform the task that an object represents:

```Perl6
has &!callback;
```

`&` 标记表示这个属性是可被调用的。`!`  字符是叫做符号或者次要标记。符号是变量名字的一部分。在这个例子中，`!` 号强调了这是类的私有属性。

The `&` sigil indicates that this attribute represents something invocable. The `!` character is a *twigil*, or secondary sigil. A twigil forms part of the name of the variable. In this case, the `!` twigil emphasizes that this attribute is private to the class.

第二个声明语句也使用了私有符号：

The second declaration also uses the private twigil:

```Perl6
has Task @!dependencies;
```

但是，这个属性代表的是一组物件，所以需要 `@` 标记。每个物件代表了当前任务完成之前必须要完成的任务。另外，这个属性的类型声明也说明数组只能持有 `Task` 类或其子例的实例。

However, this attribute represents an array of items, so it requires the `@` sigil. These items each specify a task that must be completed before the present one can complete. Furthermore, the type declaration on this attribute indicates that the array may only hold instances of the `Task` class (or some subclass of it).

第三个属性代表任务完成的状态。

The third attribute represents the state of completion of a task:

```Perl6
has Bool $.done;
```

这个标量属性（以 `$` 标记）是 `Bool` 类型。`.` 号而非 `!` 号被使用了。Perl 6 强制封装属性的同时，也避免了你写访问器方法。用 `.` 替换 `!` 时声明了属性 `$!done` 以及访问器方法 `done` 。就像你写了：

This scalar attribute (with the `$` sigil) has a type of `Bool`. Instead of the `!` twigil, the `.` twigil is used. While Perl 6 does enforce encapsulation on attributes, it also saves you from writing accessor methods. Replacing the `!` with a `.` both declares the attribute `$!done` and an accessor method named `done`. It's as if you had written:

```Perl6
has Bool $!done;
method done() { return $!done }
```

注意这不像声明了一个某些语言允许的那样的公共属性；你真实地获得了一个私有属性和一个方法，而不用去手写那个方法。你也可以编写自己的访问器方法，如果将来你需要做一些比仅仅返回值更复杂的事情。

Note that this is not like declaring a public attribute, as some languages allow; you really get *both* a private attribute and a method, without having to write the method by hand. You are free instead to write your own accessor method, if at some future point you need to do something more complex than return the value.

注意使用 `.` 号会创建对属性有只读权限的方法。如果这个对象的用户想能够重置任务的完成状态（也许想重新执行一遍），可以通过改变属性声明：

Note that using the `.` twigil has created a method that will provide read-only access to the attribute. If instead the users of this object should be able to reset a task's completion state (perhaps to perform it again), you can change the attribute declaration:

```Perl6
has Bool $.done is rw;
```

`is rw` 特性致使生成的访问器方法返回可以修改属性值的外部代码。

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

# [Static fields?](https://docs.perl6.org/language/classtut#___top)

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

# [Methods](https://docs.perl6.org/language/classtut#___top)

属性给赋予对象状态，方法赋予对象行为。让我们暂时忽略 `new` 这个特殊方法。考虑第二个方法 `add-dependency` ，它给任务的依赖列表增加了新任务。

While attributes give objects state, methods give objects behaviors. Let's ignore the `new` method temporarily; it's a special type of method. Consider the second method, `add-dependency`, which adds a new task to a task's dependency list.

```Perl6
method add-dependency(Task $dependency) {
    push @!dependencies, $dependency;
}
```

从许多方面看，这个看起来很像 `sub` 定义。但是，它们之间有两个重要的区别。首先，声明这个函数是

In many ways, this looks a lot like a `sub` declaration. However, there are two important differences. First, declaring this routine as a method adds it to the list of methods for the current class. Thus any instance of the `Task` class can call this method with the `.` method call operator. Second, a method places its invocant into the special variable `self`.

The method itself takes the passed parameter – which must be an instance of the `Task` class – and `push`es it onto the invocant's `@!dependencies` attribute.

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

It takes no parameters, working instead with the object's attributes. First, it checks if the task has already completed by checking the `$!done` attribute. If so, there's nothing to do.

Otherwise, the method performs all of the task's dependencies, using the `for` construct to iterate over all of the items in the `@!dependencies` attribute. This iteration places each item – each a `Task` object – into the topic variable, `$_`. Using the `.` method call operator without specifying an explicit invocant uses the current topic as the invocant. Thus the iteration construct calls the `.perform()`method on every `Task` object in the `@!dependencies` attribute of the current invocant.

After all of the dependencies have completed, it's time to perform the current `Task`'s task by invoking the `&!callback` attribute directly; this is the purpose of the parentheses. Finally, the method sets the `$!done` attribute to `True`, so that subsequent invocations of `perform`on this object (if this `Task` is a dependency of another `Task`, for example) will not repeat the task.

## [Private Methods](https://docs.perl6.org/language/classtut#___top)

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

Trust relationships are not subject to inheritance. To trust the global namespace, the pseudo package `GLOBAL` can be used.

# [Constructors](https://docs.perl6.org/language/classtut#___top)

Perl 6 is rather more liberal than many languages in the area of constructors. A constructor is anything that returns an instance of the class. Furthermore, constructors are ordinary methods. You inherit a default constructor named `new` from the base class `Mu`, but you are free to override `new`, as this example does:

```Perl6
method new(&callback, *@dependencies) {
    return self.bless(:&callback, :@dependencies);
}
```

The biggest difference between constructors in Perl 6 and constructors in languages such as C# and Java is that rather than setting up state on a somehow already magically created object, Perl 6 constructors create the object themselves. The easiest way to do this is by calling the [bless](https://docs.perl6.org/routine/bless) method, also inherited from [Mu](https://docs.perl6.org/type/Mu). The `bless` method expects a set of named parameters to provide the initial values for each attribute.

The example's constructor turns positional arguments into named arguments, so that the class can provide a nice constructor for its users. The first parameter is the callback (the thing which will execute the task). The rest of the parameters are dependent `Task`instances. The constructor captures these into the `@dependencies` slurpy array and passes them as named parameters to `bless` (note that `:&callback` uses the name of the variable – minus the sigil – as the name of the parameter).

Private attributes really are private. This means that `bless` is not allowed to bind things to `&!callback` and `@!dependencies` directly. To do this, we override the `BUILD` submethod, which is called on the brand new object by `bless`:

```Perl6
submethod BUILD(:&!callback, :@!dependencies) { }
```

Since `BUILD` runs in the context of the newly created `Task` object, it is allowed to manipulate those private attributes. The trick here is that the private attributes (`&!callback` and `@!dependencies`) are being used as the bind targets for `BUILD`'s parameters. Zero-boilerplate initialization! See [objects](https://docs.perl6.org/language/objects#Object_Construction) for more information.

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

See [Object Construction](https://docs.perl6.org/language/objects#Object_Construction) for more options to influence object construction and attribute initialization.

# [Consuming our class](https://docs.perl6.org/language/classtut#___top)

After creating a class, you can create instances of the class. Declaring a custom constructor provides a simple way of declaring tasks along with their dependencies. To create a single task with no dependencies, write:

```Perl6
my $eat = Task.new({ say 'eating dinner. NOM!' });
```

An earlier section explained that declaring the class `Task` installed a type object in the namespace. This type object is a kind of "empty instance" of the class, specifically an instance without any state. You can call methods on that instance, as long as they do not try to access any state; `new` is an example, as it creates a new object rather than modifying or accessing an existing object.

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

Notice how the custom constructor and sensible use of whitespace makes task dependencies clear.

Finally, the `perform` method call recursively calls the `perform` method on the various other dependencies in order, giving the output:

```Perl6
making some money
going to the store
buying food
cleaning kitchen
making dinner
eating dinner. NOM!
```

# [Inheritance](https://docs.perl6.org/language/classtut#___top)

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

## [Overriding inherited methods](https://docs.perl6.org/language/classtut#___top)

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

Because the dispatcher will see the `cook` method on `Baker` before it moves up to the parent class the `Baker`'s `cook` method will be called.

To access methods in the inheritance chain use [re-dispatch](https://docs.perl6.org/language/functions#Re-dispatching) or the [MOP](https://docs.perl6.org/type/Metamodel::ClassHOW#method_can).

## [Multiple inheritance](https://docs.perl6.org/language/classtut#___top)

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

Now all the methods made available to the Programmer and the Cook classes are available from the GeekCook class.

While multiple inheritance is a useful concept to know and occasionally use, it is important to understand that there are more useful OOP concepts. When reaching for multiple inheritance it is good practice to consider whether the design wouldn't be better realized by using roles, which are generally safer because they force the class author to explicitly resolve conflicting method names. For more information on roles see [Roles](https://docs.perl6.org/language/objects#Roles).

## [The ](https://docs.perl6.org/language/classtut#___top)[`also`](undefined) declarator

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

# [Introspection](https://docs.perl6.org/language/classtut#___top)

Introspection is the process of gathering information about some objects in your program, not by reading the source code, but by querying the object (or a controlling object) for some properties, such as its type.

Given an object `$o` and the class definitions from the previous sections, we can ask it a few questions:

```Perl6
if $o ~~ Employee { say "It's an employee" };
if $o ~~ GeekCook { say "It's a geeky cook" };
say $o.WHAT;
say $o.perl;
say $o.^methods(:local)».name.join(', ');
say $o.^name;
```

The output can look like this:

```Perl6
It's an employee
(Programmer)
Programmer.new(known_languages => ["Perl", "Python", "Pascal"],
        favorite_editor => "gvim", salary => "too small")
code_to_solve, known_languages, favorite_editor
Programmer
```

The first two tests each smart-match against a class name. If the object is of that class, or of an inheriting class, it returns true. So the object in question is of class `Employee` or one that inherits from it, but not `GeekCook`.

The `.WHAT` method returns the type object associated with the object `$o`, which tells us the exact type of `$o`: in this case `Programmer`.

`$o.perl` returns a string that can be executed as Perl code, and reproduces the original object `$o`. While this does not work perfectly in all cases, it is very useful for debugging simple objects. [[\]](https://docs.perl6.org/language/classtut#fn-1) `$o.^methods(:local)` produces a list of [Method](https://docs.perl6.org/type/Method)s that can be called on `$o`. The `:local` named argument limits the returned methods to those defined in the `Programmer` class and excludes the inherited methods.

The syntax of calling a method with `.^` instead of a single dot means that it is actually a method call on its *meta class*, which is a class managing the properties of the `Programmer` class – or any other class you are interested in. This meta class enables other ways of introspection too:

```Perl6
say $o.^attributes.join(', ');
say $o.^parents.map({ $_.^name }).join(', ');
```

Finally `$o.^name` calls the `name` method on the meta object, which unsurprisingly returns the class name.

Introspection is very useful for debugging and for learning the language and new libraries. When a function or method returns an object you don't know about, finding its type with `.WHAT`, seeing a construction recipe for it with `.perl`, and so on, you'll get a good idea of what its return value is. With `.^methods` you can learn what you can do with the class.

But there are other applications too: a routine that serializes objects to a bunch of bytes needs to know the attributes of that object, which it can find out via introspection.

