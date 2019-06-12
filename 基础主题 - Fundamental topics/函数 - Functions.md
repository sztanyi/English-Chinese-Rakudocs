# 函数 / Functions

Perl 6 中的函数和函数式编程

Functions and functional programming in Perl 6

例程是 Perl 6 重用代码的方法之一。它们有几种形式，最显著的是 [方法](https://docs.perl6.org/type/Method)，它们属于类和角色，与一个对象相关联；以及函数（也称为*子例程*或 [sub](https://docs.perl6.org/type/Sub)，可以独立于对象调用。

Routines are one of the means Perl 6 has to reuse code. They come in several forms, most notably [methods](https://docs.perl6.org/type/Method), which belong in classes and roles and are associated with an object; and functions (also called *subroutines* or [sub](https://docs.perl6.org/type/Sub)s, for short), which can be called independently of objects.

子例程默认为词法（`my`）作用域，对它们的调用通常在编译时解决。

Subroutines default to lexical (`my`) scoping, and calls to them are generally resolved at compile time.

子例程可以有一个[签名](https://docs.perl6.org/type/Signature)，也称为*参数列表*，它指定签名期望的参数（如果有）。它可以指定参数的数量和类型，以及返回值。

Subroutines can have a [signature](https://docs.perl6.org/type/Signature), also called *parameter list*, which specifies which, if any, arguments the signature expects. It can specify (or leave open) both the number and types of arguments, and the return value.

子例程的自省通过 [`Routine`](https://docs.perl6.org/type/Routine) 提供。

Introspection on subroutines is provided via [`Routine`](https://docs.perl6.org/type/Routine).

# 定义/创建/使用函数 / Defining/Creating/Using functions

## 子例程 Subroutines

创建子例程的基本方法是使用 `sub` 声明符，后跟可选的[标识符](https://docs.perl6.org/language/syntax#Identifiers)：

The basic way to create a subroutine is to use the `sub` declarator followed by an optional [identifier](https://docs.perl6.org/language/syntax#Identifiers):

```Perl6
sub my-func { say "Look ma, no args!" }
my-func;
```

sub 声明符返回可以存储在任何容器中的 [sub](https://docs.perl6.org/type/Sub) 类型的值：

The sub declarator returns a value of type [Sub](https://docs.perl6.org/type/Sub) that can be stored in any container:

```Perl6
my &c = sub { say "Look ma, no name!" }
c;     # OUTPUT: «Look ma, no name!␤» 
 
my Any:D $f = sub { say 'Still nameless...' }
$f();  # OUTPUT: «Still nameless...␤» 
 
my Code \a = sub { say ‚raw containers don't implement postcircumfix:<( )>‘ };
a.();  # OUTPUT: «raw containers don't implement postcircumfix:<( )>␤» 
```

声明符 `sub` 会在编译时当前范围内声明一个新名字。因此，任何间接命名都会在在编译时解决：

The declarator `sub` will declare a new name in the current scope at compile time. As such any indirection has to be resolved at compile time:

```Perl6
constant aname = 'foo';
sub ::(aname) { say 'oi‽' };
foo;
```

一旦将宏添加到 Perl 6 中，这将变得更加有用。

This will become more useful once macros are added to Perl 6.

要让子例程接受参数，在子例程的名称和其主体之间插入一个[签名](https://docs.perl6.org/type/Signature)，在括号中：

To have the subroutine take arguments, a [signature](https://docs.perl6.org/type/Signature) goes between the subroutine's name and its body, in parentheses:

```Perl6
sub exclaim ($phrase) {
    say $phrase ~ "!!!!"
}
exclaim "Howdy, World";
```

默认情况下，子例程为[词法作用域](https://docs.perl6.org/syntax/my)。也就是说，`sub foo {...}` 与 `my sub foo {...}` 相同，仅在当前范围内定义。

By default, subroutines are [lexically scoped](https://docs.perl6.org/syntax/my). That is, `sub foo {...}` is the same as `my sub foo {...}` and is only defined within the current scope.

```Perl6
sub escape($str) {
    # Puts a slash before non-alphanumeric characters 
    S:g[<-alpha -digit>] = "\\$/" given $str
}
 
say escape 'foo#bar?'; # OUTPUT: «foo\#bar\?␤» 
 
{
    sub escape($str) {
        # Writes each non-alphanumeric character in its hexadecimal escape 
        S:g[<-alpha -digit>] = "\\x[{ $/.ord.base(16) }]" given $str
    }
 
    say escape 'foo#bar?' # OUTPUT: «foo\x[23]bar\x[3F]␤» 
}
 
# Back to original escape function 
say escape 'foo#bar?'; # OUTPUT: «foo\#bar\?␤» 
```

子程序不必命名。如果未命名，则称为*匿名*子例程。

Subroutines don't have to be named. If unnamed, they're called *anonymous* subroutines.

```Perl6
say sub ($a, $b) { $a ** 2 + $b ** 2 }(3, 4) # OUTPUT: «25␤» 
```

但在这种情况下，通常需要使用更简洁的 [block](https://docs.perl6.org/type/Block) 语法。子例程和块可以就地调用，如上面的示例所示。

But in this case, it's often desirable to use the more succinct [block](https://docs.perl6.org/type/Block) syntax. Subroutines and blocks can be called in place, as in the example above.

```Perl6
say -> $a, $b { $a ** 2 + $b ** 2 }(3, 4)    # OUTPUT: «25␤» 
```

甚至

Or even

```Perl6
say { $^a ** 2 + $^b ** 2 }(3, 4)            # OUTPUT: «25␤» 
```

## 代码块和拉姆达 / Blocks and lambdas

每当你看到类似于 `{ $_ + 42 }`、 `-> $a, $b { $a ** $b }`，或 `{ $^text.indent($:spaces) }`，那就是 [Block](https://docs.perl6.org/type/Block) 语法。它在 `if`、 `for`、`while` 等后面使用。

Whenever you see something like `{ $_ + 42 }`, `-> $a, $b { $a ** $b }`, or `{ $^text.indent($:spaces) }`, that's [Block](https://docs.perl6.org/type/Block) syntax. It's used after every `if`, `for`, `while`, etc.

```Perl6
for 1, 2, 3, 4 -> $a, $b {
    say $a ~ $b;
}
# OUTPUT: «12␤34␤» 
```

它们也可以作为匿名代码块单独使用。

They can also be used on their own as anonymous blocks of code.

```Perl6
say { $^a ** 2 + $^b ** 2}(3, 4) # OUTPUT: «25␤» 
```

有关块语法的详细信息，请参阅 [Block](https://docs.perl6.org/type/Block) 类型的文档。

For block syntax details, see the documentation for the [Block](https://docs.perl6.org/type/Block) type.

## 签名 / Signatures

函数接受的参数在其*签名*中描述。

The parameters that a function accepts are described in its *signature*.

```Perl6
sub format(Str $s) { ... }
-> $a, $b { ... }
```

有关签名的语法和使用的详细信息，请参见 [关于'signature'类的文档](https://docs.perl6.org/type/Signature)。

Details about the syntax and use of signatures can be found in the [documentation on the `Signature` class](https://docs.perl6.org/type/Signature).

### 自动签名 / Automatic signatures

如果没有提供签名，但函数体中使用了两个自动变量 `@_` 或 `%_` ，则将生成带有 `*@_` 或 `*%_` 的签名。两个自动变量可以同时使用。

If no signature is provided but either of the two automatic variables `@_` or `%_` are used in the function body, a signature with `*@_` or `*%_` will be generated. Both automatic variables can be used at the same time.

```Perl6
sub s { say @_, %_ };
say &s.signature # OUTPUT: «(*@_, *%_)␤» 
```

## 参数 / Arguments 

参数以逗号分隔的列表形式提供。要消除嵌套调用的歧义，请使用括号：

Arguments are supplied as a comma separated list. To disambiguate nested calls, use parentheses:

```Perl6
sub f(&c){ c() * 2 }; # call the function reference c with empty parameter list 
sub g($p){ $p - 2 };
say(g(42), 45);       # pass only 42 to g() 
```

调用函数时，位置参数的提供顺序应与函数的签名相同。命名参数可以按任意顺序提供，但将命名参数放在位置参数之后被认为是一种很好的形式。在函数调用的参数列表中，支持某些特殊语法：

When calling a function, positional arguments should be supplied in the same order as the function's signature. Named arguments may be supplied in any order, but it's considered good form to place named arguments after positional arguments. Inside the argument list of a function call, some special syntax is supported:

```Perl6
sub f(|c){};
f :named(35);     # A named argument (in "adverb" form) 
f named => 35;    # Also a named argument 
f :35named;       # A named argument using abbreviated adverb form 
f 'named' => 35;  # Not a named argument, a Pair in a positional argument 
my \c = <a b c>.Capture;
f |c;             # Merge the contents of Capture $c as if they were supplied 
```

传递给函数的参数在概念上首先收集在 `Capture` 容器中。有关这些容器的语法和使用的详细信息，请参见[关于 `Capture` 类的文档](https://docs.perl6.org/type/Capture)。

Arguments passed to a function are conceptually first collected in a `Capture` container. Details about the syntax and use of these containers can be found in the [documentation on the `Capture` class](https://docs.perl6.org/type/Capture).

使用命名参数时，请注意，普通列表“对链接”允许跳过命名参数之间的逗号。

When using named arguments, note that normal List "pair-chaining" allows one to skip commas between named arguments.

```Perl6
sub f(|c){};
f :dest</tmp/foo> :src</tmp/bar> :lines(512);
f :32x :50y :110z;   # This flavor of "adverb" works, too 
f :a:b:c;            # The spaces are also optional. 
```

## 返回值 / Return values

任何 `Block` 或 `Routine` 都会将其最后一个表达式的值作为返回值提供给调用方。如果调用了 [return](https://docs.perl6.org/language/control#return) 或 [return-rw](https://docs.perl6.org/language/control#return-rw) ，则其参数（如果有）将成为返回值。默认返回值为 [Nil](https://docs.perl6.org/type/Nil)。

Any `Block` or `Routine` will provide the value of its last expression as a return value to the caller. If either [return](https://docs.perl6.org/language/control#return) or [return-rw](https://docs.perl6.org/language/control#return-rw) is called, then its parameter, if any, will become the return value. The default return value is [Nil](https://docs.perl6.org/type/Nil).

```Perl6
sub a { 42 };
sub b { say a };
sub c { };
b;     # OUTPUT: «42␤» 
say c; # OUTPUT: «Nil␤» 
```

多个返回值作为一个列表或通过创建一个 [Capture](https://docs.perl6.org/type/Capture)返回。析构函数可用于解开多个返回值。

Multiple return values are returned as a list or by creating a [Capture](https://docs.perl6.org/type/Capture). Destructuring can be used to untangle multiple return values.

```Perl6
sub a { 42, 'answer' };
put a.perl;
# OUTPUT: «(42, "answer")␤» 
 
my ($n, $s) = a;
put [$s, $n];
# OUTPUT: «answer 42␤» 
 
sub b { <a b c>.Capture };
put b.perl;
# OUTPUT: «\("a", "b", "c")␤» 
```

## 返回类型约束 / Return type constraints

Perl 6 有许多方法可以指定函数的返回类型：

Perl 6 has many ways to specify a function's return type:

```Perl6
sub foo(--> Int)      {}; say &foo.returns; # OUTPUT: «(Int)␤» 
sub foo() returns Int {}; say &foo.returns; # OUTPUT: «(Int)␤» 
sub foo() of Int      {}; say &foo.returns; # OUTPUT: «(Int)␤» 
my Int sub foo()      {}; say &foo.returns; # OUTPUT: «(Int)␤» 
```

尝试返回其他类型的值将导致编译错误。

Attempting to return values of another type will cause a compilation error.

```Perl6
sub foo() returns Int { "a"; }; foo; # Type check fails 
```

`returns` 和 `of` 是等效的，它们都只接受一个类型，因为它们声明了 [Callable](https://docs.perl6.org/type/Callable)的特性。最后一个声明实际上是一个类型声明，它显然只能接受一个类型。`-->`，但是，可以采用未定义或定义了的值。

`returns` and `of` are equivalent, and both take only a Type since they are declaring a trait of the [Callable](https://docs.perl6.org/type/Callable). The last declaration is, in fact, a type declaration, which obviously can take only a type. `-->`, however, can take either undefined or definite values.

请注意，`Nil` 和 `Failure` 不受返回类型约束，并且可以从任何例程返回，无论其约束如何：

Note that `Nil` and `Failure` are exempt from return type constraints and can be returned from any routine, regardless of its constraint:

```Perl6
sub foo() returns Int { fail   }; foo; # Failure returned 
sub bar() returns Int { return }; bar; # Nil returned 
```

## 多分派 / Multi-dispatch

Perl 6 允许使用相同的名称但不同的签名编写多个例程。当以名称调用例程时，运行时环境将确定正确的*候选*并调用它。

Perl 6 allows for writing several routines with the same name but different signatures. When the routine is called by name, the runtime environment determines the proper *candidate* and invokes it.

每个候选项都用 `multi` 关键字声明。根据参数的编号（[arity](https://docs.perl6.org/type/Routine#%28Code%29_method_arity)）、类型和名称进行调度。请考虑以下示例：

Each candidate is declared with the `multi` keyword. Dispatch happens depending on the number ([arity](https://docs.perl6.org/type/Routine#%28Code%29_method_arity)), type and name of arguments. Consider the following example:

```Perl6
# version 1 
multi happy-birthday( $name ) {
    say "Happy Birthday $name !";
}
 
# version 2 
multi happy-birthday( $name, $age ) {
    say "Happy {$age}th Birthday $name !";
}
 
# version 3 
multi happy-birthday( :$name, :$age, :$title  = 'Mr' ) {
    say "Happy {$age}th Birthday $title $name !";
}
 
 
# calls version 1 (arity) 
happy-birthday 'Larry';                        # OUTPUT: «Happy Birthday Larry !␤» 
# calls version 2 (arity) 
happy-birthday 'Luca', 40;                     # OUTPUT: «Happy 40th Birthday Luca !␤» 
# calls version 3 
# (named arguments win against arity) 
happy-birthday( age => '50', name => 'John' ); # OUTPUT: «Happy 50th Birthday Mr John !␤» 
# calls version 2 (arity) 
happy-birthday( 'Jack', 25 );                  # OUTPUT: «Happy 25th Birthday Jack !␤» 
 
```

`happy-birthday` 子例程的前两个版本仅在 arity（参数个数）上有所不同，而第三个版本使用命名参数，并且仅在使用命名参数时被选中，即使 arity 与另一个 `multi` 候选版本相同。

The first two versions of the `happy-birthday` sub differs only in the arity (number of arguments), while the third version uses named arguments and is chosen only when named arguments are used, even if the arity is the same of another `multi`candidate.

当两个子例程具有相同的 arity 时，参数的类型驱动调度；当存在命名参数时，即使它们的类型与另一个候选类型相同，它们也驱动调度：

When two sub have the same arity, the type of the arguments drive the dispatch; when there are named arguments they drive the dispatch even when their type is the same as another candidate:

```Perl6
multi happy-birthday( Str $name, Int $age ) {
    say "Happy {$age}th Birthday $name !";
}
 
multi happy-birthday( Str $name, Str $title ) {
    say "Happy Birthday $title $name !";
}
 
multi happy-birthday( Str :$name, Int :$age ) {
    say "Happy Birthday $name, you turned $age !";
}
 
happy-birthday 'Luca', 40;                 # OUTPUT: «Happy 40th Birthday Luca !␤» 
happy-birthday 'Luca', 'Mr';               # OUTPUT: «Happy Birthday Mr Luca !␤» 
happy-birthday age => 40, name => 'Luca';  # OUTPUT: «Happy Birthday Luca, you turned 40 !␤» 
 
```

命名参数参与调度，即使调用中没有提供这些参数。因此，将优先考虑具有命名参数的多候选项。

Named parameters participate in the dispatch even if they are not provided in the call. Therefore a multi candidate with named parameters will be given precedence.

有关类型约束的详细信息，请参阅[签名](https://docs.perl6.org/type/Signature#Type_constraints)类的文档。

For more information about type constraints see the documentation for the [Signature](https://docs.perl6.org/type/Signature#Type_constraints) class.

```Perl6
multi as-json(Bool $d) { $d ?? 'true' !! 'false'; }
multi as-json(Real $d) { ~$d }
multi as-json(@d)      { sprintf '[%s]', @d.map(&as-json).join(', ') }
 
say as-json( True );                        # OUTPUT: «true␤» 
say as-json( 10.3 );                        # OUTPUT: «10.3␤» 
say as-json( [ True, 10.3, False, 24 ] );   # OUTPUT: «[true, 10.3, false, 24]␤» 
```

`multi` 不带任何特定子例程类型都缺省为 `sub`，但是你也可以对方法使用它。候选都是对象的 multi 方法：

`multi` without any specific routine type always defaults to a `sub`, but you can use it on methods as well. The candidates are all the multi methods of the object:

```Perl6
class Congrats {
    multi method congratulate($reason, $name) {
        say "Hooray for your $reason, $name";
    }
}
 
role BirthdayCongrats {
    multi method congratulate('birthday', $name) {
        say "Happy birthday, $name";
    }
    multi method congratulate('birthday', $name, $age) {
        say "Happy {$age}th birthday, $name";
    }
}
 
my $congrats = Congrats.new does BirthdayCongrats;
 
$congrats.congratulate('promotion','Cindy'); # OUTPUT: «Hooray for your promotion, Cindy␤» 
$congrats.congratulate('birthday','Bob');    # OUTPUT: «Happy birthday, Bob␤» 
```

与 `sub` 不同，如果将命名参数与多个方法一起使用，则参数必须是必需的参数才能按预期工作。

Unlike `sub`, if you use named parameters with multi methods, the parameters must be required parameters to behave as expected.

请注意，non-multi 子例程或运算符将在任何父范围或子范围中隐藏同名的多个候选项。对于导入的非多候选人也是如此。

Please note that a non-multi sub or operator will hide multi candidates of the same name in any parent scope or child scope. The same is true for imported non-multi candidates.

### proto

`proto` 是一种正式声明 `multi` 候选人之间共性的方法。它充当一个包装器，可以验证但不能修改参数。考虑这个基本示例：

`proto` is a way to formally declare commonalities between `multi` candidates. It acts as a wrapper that can validate but not modify arguments. Consider this basic example:

```Perl6
proto congratulate(Str $reason, Str $name, |) {*}
multi congratulate($reason, $name) {
   say "Hooray for your $reason, $name";
}
multi congratulate($reason, $name, Int $rank) {
   say "Hooray for your $reason, $name -- got rank $rank!";
}
 
congratulate('being a cool number', 'Fred');     # OK 
congratulate('being a cool number', 'Fred', 42); # OK 
congratulate('being a cool number', 42);         # Proto match error 
```

proto 坚持所有的 `multi congratulate` 子例程都符合两个字符串的基本签名，还可以选择后面跟着其他参数。`|` 是一个未命名的 `Capture` 参数，允许 `multi` 接受其他参数。前两个调用成功，但第三个调用（在编译时）失败，因为 `42` 与 `Str` 不匹配。

The proto insists that all `multi congratulate` subs conform to the basic signature of two strings, optionally followed by further parameters. The `|` is an un-named `Capture` parameter, and allows a `multi` to take additional arguments. The first two calls succeed, but the third fails (at compile time) because `42` doesn't match `Str`.

```Perl6
say &congratulate.signature # OUTPUT: «(Str $reason, Str $name, | is raw)␤» 
```

您可以给 `proto` 一个函数体，并将 `{*}` 放在要完成分派的位置。

You can give the `proto` a function body, and place the `{*}` where you want the dispatch to be done.

```Perl6
# attempts to notify someone -- False if unsuccessful 
proto notify(Str $user,Str $msg) {
   my \hour = DateTime.now.hour;
   if hour > 8 or hour < 22 {
      return {*};
   } else {
      # we can't notify someone when they might be sleeping 
      return False;
   }
}
```

`{*}` 总是使用调用参数向候选人发送消息。参数默认值和类型强制将起作用，但不会传递。

`{*}` always dispatches to candidates with the parameters it's called with. Parameter defaults and type coercions will work but are not passed on.

```Perl6
proto mistake-proto(Str() $str, Int $number = 42) {*}
multi mistake-proto($str, $number) { say $str.^name }
mistake-proto(7, 42);  # OUTPUT: «Int␤» -- not passed on 
mistake-proto('test'); # fails -- not passed on 
```

## only

在 `sub` 或 `method` 前面的 `only` 关键字指示它将是唯一驻留给定命名空间的具有该名称的函数。

The `only` keyword preceding `sub` or `method` indicates that it will be the only function with that name that inhabits a given namespace.

```Perl6
only sub you () {"Can make all the world seem right"};
```

这将在同一命名空间中生成其他声明，例如

This will make other declarations in the same namespace, such as

```Perl6
sub you ( $can ) { "Make the darkness bright" }
```

失败并出现类型为 `X::Redeclaration` 的异常。`only` 是所有 sub 的默认值；在上面的情况下，不将第一个子例程声明为 `only` 将产生完全相同的错误；但是，没有什么可以阻止未来的开发人员声明 proto 并在名称前面加上 `multi`。在例程之前使用 `only` 是一个[防御编程](https://en.wikipedia.org/wiki/Defensive_programming)功能，它声明将来不在同一命名空间中声明具有相同名称的例程。

fail with an exception of type `X::Redeclaration`. `only` is the default value for all subs; in the case above, not declaring the first subroutine as `only` will yield exactly the same error; however, nothing prevents future developers from declaring a proto and preceding the names with `multi`. Using `only` before a routine is a [defensive programming](https://en.wikipedia.org/wiki/Defensive_programming) feature that declares the intention of not having routines with the same name declared in the same namespace in the future.

```Perl6
(exit code 1)
===SORRY!=== Error while compiling /tmp/only-redeclaration.p6
Redeclaration of routine 'you' (did you mean to declare a multi-sub?)
at /tmp/only-redeclaration.p6:3
------> <BOL>⏏<EOL>
```

匿名子例程不能声明为 `only`。`only sub {}` 会抛出类型为 `X::Anon::Multi` 的错误。

Anonymous sub cannot be declared `only`. `only sub {}'` will throw an error of type, surprisingly, `X::Anon::Multi`.

# 习惯用法 / Conventions and idioms

虽然上面描述的调度系统提供了很大的灵活性，但是大多数内部函数和许多模块中的函数都会遵循一些约定。

While the dispatch system described above provides a lot of flexibility, there are some conventions that most internal functions, and those in many modules, will follow.

## 解构约定 / Slurpy conventions

也许这些约定中最重要的一个就是处理 slurpy 列表参数的方式。大多数情况下，函数不会自动压扁 slurpy 列表。罕见的例外是那些在列表的列表上没有合理行为的函数（例如，[chrs](https://docs.perl6.org/routine/chrs)），或者与已建立的习惯用法（例如，[pop](https://docs.perl6.org/routine/pop) 作为 [push](https://docs.perl6.org/routine/push) 的逆函数 ）。

Perhaps the most important one of these conventions is the way slurpy list arguments are handled. Most of the time, functions will not automatically flatten slurpy lists. The rare exceptions are those functions that don't have a reasonable behavior on lists of lists (e.g., [chrs](https://docs.perl6.org/routine/chrs)) or where there is a conflict with an established idiom (e.g., [pop](https://docs.perl6.org/routine/pop) being the inverse of [push](https://docs.perl6.org/routine/push)).

如果您希望匹配这种外观和感觉，任何 [Iterable](https://docs.perl6.org/type/Iterable) 参数都必须使用 `**@` 逐元素分解，这有两个细微差别：

If you wish to match this look and feel, any [Iterable](https://docs.perl6.org/type/Iterable) argument must be broken out element-by-element using a `**@` slurpy, with two nuances:


- 对[标量容器](https://docs.perl6.org/language/containers#Scalar_containers)中的 [Iterable](https://docs.perl6.org/type/Iterable) 不生效。
- 使用一个 [`,`](https://docs.perl6.org/routine/,) 创建的 [List](https://docs.perl6.org/type/List)，在最上层只会被当做一个 [Iterable](https://docs.perl6.org/type/Iterable)。

- An [Iterable](https://docs.perl6.org/type/Iterable) inside a [Scalar container](https://docs.perl6.org/language/containers#Scalar_containers) doesn't count.
- [List](https://docs.perl6.org/type/List)s created with a [`,`](https://docs.perl6.org/routine/,) at the top level only count as one [Iterable](https://docs.perl6.org/type/Iterable).

这可以通过使用 `+` 或者 `+@` 而不是 `**` 来实现：

This can be achieved by using a slurpy with a `+` or `+@` instead of `**`:

```Perl6
sub grab(+@a) { "grab $_".say for @a }
```

这是非常接近以下内容的简写：

which is shorthand for something very close to:

```Perl6
multi sub grab(**@a) { "grab $_".say for @a }
multi sub grab(\a) {
    a ~~ Iterable and a.VAR !~~ Scalar ?? nextwith(|a) !! nextwith(a,)
}
```

这会导致下列被称为*“单参数规则”*的行为，在调用 slurpy 函数时需要了解这些行为至关重要：

This results in the following behavior, which is known as the *"single argument rule"* and is important to understand when invoking slurpy functions:

```Perl6
grab(1, 2);      # OUTPUT: «grab 1␤grab 2␤» 
grab((1, 2));    # OUTPUT: «grab 1␤grab 2␤» 
grab($(1, 2));   # OUTPUT: «grab 1 2␤» 
grab((1, 2), 3); # OUTPUT: «grab 1 2␤grab 3␤» 
```

这也使得用户请求的扁平化无论有一个子列表还是多个子列表都感觉一致：

This also makes user-requested flattening feel consistent whether there is one sublist, or many:

```Perl6
grab(flat (1, 2), (3, 4));   # OUTPUT: «grab 1␤grab 2␤grab 3␤grab 4␤» 
grab(flat $(1, 2), $(3, 4)); # OUTPUT: «grab 1 2␤grab 3 4␤» 
grab(flat (1, 2));           # OUTPUT: «grab 1␤grab 2␤» 
grab(flat $(1, 2));          # OUTPUT: «grab 1␤grab 2␤» 
```

值得注意的是，在这些情况下混合绑定和无符号变量需要一些技巧，因为在绑定期间没有使用[标量](https://docs.perl6.org/type/Scalar)媒介。

It's worth noting that mixing binding and sigilless variables in these cases requires a bit of finesse, because there is no [Scalar](https://docs.perl6.org/type/Scalar)intermediary used during binding.

```Perl6
my $a = (1, 2);  # Normal assignment, equivalent to $(1, 2) 
grab($a);        # OUTPUT: «grab 1 2␤» 
my $b := (1, 2); # Binding, $b links directly to a bare (1, 2) 
grab($b);        # OUTPUT: «grab 1␤grab 2␤» 
my \c = (1, 2);  # Sigilless variables always bind, even with '=' 
grab(c);         # OUTPUT: «grab 1␤grab 2␤» 
```

# 函数是第一等对象 / Functions are first-class objects

函数和其他代码对象可以作为值传递，就像其他任何对象一样。

Functions and other code objects can be passed around as values, just like any other object.

有几种方法可以获取代码对象。可以在声明点将其赋给变量：

There are several ways to get hold of a code object. You can assign it to a variable at the point of declaration:

```Perl6
my $square = sub (Numeric $x) { $x * $x }
# and then use it: 
say $square(6);    # OUTPUT: «36␤» 
```

或者，可以使用前面的 `&` 来引用现有的命名函数。

Or you can reference an existing named function by using the `&`-sigil in front of it.

```Perl6
sub square($x) { $x * $x };
 
# get hold of a reference to the function: 
my $func = &square
```

这对于*高阶函数*非常有用，也就是说，将其他函数作为输入的函数。一个简单的例子是 [map](https://docs.perl6.org/type/List#routine_map)，它将一个函数应用于每个输入元素：

This is very useful for *higher order functions*, that is, functions that take other functions as input. A simple one is [map](https://docs.perl6.org/type/List#routine_map), which applies a function to each input element:

```Perl6
sub square($x) { $x * $x };
my @squared = map &square,  1..5;
say join ', ', @squared;        # OUTPUT: «1, 4, 9, 16, 25␤» 
```

## 中缀形式 / Infix form

要使用 2 个参数（如中缀运算符）调用子例程，使用由 `[` 和 `]` 包围的子例程引用。

To call a subroutine with 2 arguments like an infix operator, use a subroutine reference surrounded by `[` and `]`.

```Perl6
sub plus { $^a + $^b };
say 21 [&plus] 21;
# OUTPUT: «42␤» 
```

## 闭包 / Closures

Perl 6 中的所有代码对象都是*闭包*，这意味着它们可以从外部范围引用词汇变量。

All code objects in Perl 6 are *closures*, which means they can reference lexical variables from an outer scope.

```Perl6
sub generate-sub($x) {
    my $y = 2 * $x;
    return sub { say $y };
    #      ^^^^^^^^^^^^^^  inner sub, uses $y 
}
my $generated = generate-sub(21);
$generated(); # OUTPUT: «42␤» 
```

这里，`$y` 是 `generate-sub` 中的词法变量，返回的内部子例程使用了它。在调用内部函数时， `generate-sub` 已退出。但是内部函数仍然可以使用 `$y`，因为它*关闭*了变量。

Here, `$y` is a lexical variable inside `generate-sub`, and the inner subroutine that is returned uses it. By the time that inner sub is called, `generate-sub` has already exited. Yet the inner sub can still use `$y`, because it *closed* over the variable.

另一个闭包示例是使用 [map](https://docs.perl6.org/type/List#routine_map) 将数字列表相乘：

Another closure example is the use of [map](https://docs.perl6.org/type/List#routine_map) to multiply a list of numbers:

```Perl6
my $multiply-by = 5;
say join ', ', map { $_ * $multiply-by }, 1..5;     # OUTPUT: «5, 10, 15, 20, 25␤» 
```

在这里，传递给 `map` 的块引用了外部作用域中的变量 `$multiply-by`，从而使块成为一个闭包。

Here, the block passed to `map` references the variable `$multiply-by` from the outer scope, making the block a closure.

没有闭包的语言很难提供像 `map` 这样易于使用且功能强大的高阶函数。

Languages without closures cannot easily provide higher-order functions that are as easy to use and powerful as `map`.

## 例程 / Routines

例程是符合 [类型 `Routine`](https://docs.perl6.org/type/Routine) 的代码对象，最显著的是 [`Sub`](https://docs.perl6.org/type/Sub)、[`Method`](https://docs.perl6.org/type/Method)、[`Regex`](https://docs.perl6.org/type/Regex) 和 [`Submethod`](https://docs.perl6.org/type/Submethod)。

Routines are code objects that conform to [type `Routine`](https://docs.perl6.org/type/Routine), most notably [`Sub`](https://docs.perl6.org/type/Sub), [`Method`](https://docs.perl6.org/type/Method), [`Regex`](https://docs.perl6.org/type/Regex) and [`Submethod`](https://docs.perl6.org/type/Submethod).

除了 [`Block`](https://docs.perl6.org/type/Block) 提供的功能外，它们还具有额外的功能：它们可以作为 [multis](https://docs.perl6.org/language/functions#Multi-dispatch) 提供，你可以 [wrap](https://docs.perl6.org/type/Routine#method_wrap) 他们，并使用 `return` 提前退出：

They carry extra functionality in addition to what a [`Block`](https://docs.perl6.org/type/Block) supplies: they can come as [multis](https://docs.perl6.org/language/functions#Multi-dispatch), you can [wrap](https://docs.perl6.org/type/Routine#method_wrap) them, and exit early with `return`:

```Perl6
my $keywords = set <if for unless while>;
 
sub has-keyword(*@words) {
    for @words -> $word {
        return True if $word (elem) $keywords;
    }
    False;
}
 
say has-keyword 'not', 'one', 'here';       # OUTPUT: «False␤» 
say has-keyword 'but', 'here', 'for';       # OUTPUT: «True␤» 
```

Here, `return` doesn't just leave the block inside which it was called, but the whole routine. In general, blocks are transparent to `return`, they attach to the outermost routine.

Routines can be inlined and as such provide an obstacle for wrapping. Use the pragma `use soft;` to prevent inlining to allow wrapping at runtime.

```Perl6
sub testee(Int $i, Str $s){
    rand.Rat * $i ~ $s;
}
 
sub wrap-to-debug(&c){
    say "wrapping {&c.name} with arguments {&c.signature.perl}";
    &c.wrap: sub (|args){
        note "calling {&c.name} with {args.gist}";
        my \ret-val := callwith(|args);
        note "returned from {&c.name} with return value {ret-val.perl}";
        ret-val
    }
}
 
my $testee-handler = wrap-to-debug(&testee);
# OUTPUT: «wrapping testee with arguments :(Int $i, Str $s)» 
 
say testee(10, "ten");
# OUTPUT: «calling testee with \(10, "ten")␤returned from testee with return value "6.151190ten"␤6.151190ten» 
&testee.unwrap($testee-handler);
say testee(10, "ten");
# OUTPUT: «6.151190ten␤» 
```

# Defining operators

Operators are just subroutines with funny names. The funny names are composed of the category name (`infix`, `prefix`, `postfix`, `circumfix`, `postcircumfix`), followed by a colon, and a list of the operator name or names (two components in the case of circumfix and postcircumfix).

This works both for adding multi candidates to existing operators and for defining new ones. In the latter case, the definition of the new subroutine automatically installs the new operator into the grammar, but only in the current lexical scope. Importing an operator via `use` or `import` also makes it available.

```Perl6
# adding a multi candidate to an existing operator: 
multi infix:<+>(Int $x, "same") { 2 * $x };
say 21 + "same";            # OUTPUT: «42␤» 
 
# defining a new operator 
sub postfix:<!>(Int $x where { $x >= 0 }) { [*] 1..$x };
say 6!;                     # OUTPUT: «720␤» 
```

The operator declaration becomes available as soon as possible, so you can recurse into a just-defined operator:

```
sub postfix:<!>(Int $x where { $x >= 0 }) {
    $x == 0 ?? 1 !! $x * ($x - 1)!
}
say 6!;                     # OUTPUT: «720␤» 
```

Circumfix and postcircumfix operators are made of two delimiters, one opening and one closing.

```
sub circumfix:<START END>(*@elems) {
    "start", @elems, "end"
}
 
say START 'a', 'b', 'c' END;        # OUTPUT: «(start [a b c] end)␤» 
```

Postcircumfixes also receive the term after which they are parsed as an argument:

```
sub postcircumfix:<!! !!>($left, $inside) {
    "$left -> ( $inside )"
}
say 42!! 1 !!;      # OUTPUT: «42 -> ( 1 )␤» 
```

Blocks can be assigned directly to operator names. Use a variable declarator and prefix the operator name with a `&`-sigil.

```
my &infix:<ieq> = -> |l { [eq] l>>.fc };
say "abc" ieq "Abc";
# OUTPUT: «True␤» 
```



## Precedence

Operator precedence in Perl 6 is specified relatively to existing operators. The traits `is tighter`, `is equiv` and `is looser` can be provided with an operator to indicate how the precedence of the new operators is related to other, existing ones. More than one trait can be applied.

For example, `infix:<*>` has a tighter precedence than `infix:<+>`, and squeezing one in between works like this:

```
sub infix:<!!>($a, $b) is tighter(&infix:<+>) {
    2 * ($a + $b)
}
 
say 1 + 2 * 3 !! 4;     # OUTPUT: «21␤» 
```

Here, the `1 + 2 * 3 !! 4` is parsed as `1 + ((2 * 3) !! 4)`, because the precedence of the new `!!` operator is between that of `+`and `*`.

The same effect could have been achieved with:

```
sub infix:<!!>($a, $b) is looser(&infix:<*>) { ... }
```

To put a new operator on the same precedence level as an existing operator, use `is equiv(&other-operator)` instead.

## Associativity

When the same operator appears several times in a row, there are multiple possible interpretations. For example:

```
1 + 2 + 3
```

could be parsed as

```
(1 + 2) + 3         # left associative 
```

or as

```
1 + (2 + 3)         # right associative 
```

For addition of real numbers, the distinction is somewhat moot, because `+` is [mathematically associative](https://en.wikipedia.org/wiki/Associative_property).

But for other operators it matters a great deal. For example, for the exponentiation/power operator, `infix:<**> `:

```
say 2 ** (2 ** 3);      # OUTPUT: «256␤» 
say (2 ** 2) ** 3;      # OUTPUT: «64␤» 
```

Perl 6 has the following possible associativity configurations:

| A    | Assoc | Meaning of $a ! $b ! $c |
| ---- | ----- | ----------------------- |
| L    | left  | ($a ! $b) ! $c          |
| R    | right | $a ! ($b ! $c)          |
| N    | non   | ILLEGAL                 |
| C    | chain | ($a ! $b) and ($b ! $c) |
| X    | list  | infix:<!>($a; $b; $c)   |

You can specify the associativity of an operator with the `is assoc` trait, where `left` is the default associativity.

```
sub infix:<§>(*@a) is assoc<list> {
    '(' ~ @a.join('|') ~ ')';
}
 
say 1 § 2 § 3;      # OUTPUT: «(1|2|3)␤» 
```

# Traits

*Traits* are subroutines that run at compile time and modify the behavior of a type, variable, routine, attribute, or other language object.

Examples of traits are:

```
class ChildClass is ParentClass { ... }
#                ^^ trait, with argument ParentClass 
has $.attrib is rw;
#            ^^^^^  trait with name 'rw' 
class SomeClass does AnotherRole { ... }
#               ^^^^ trait 
has $!another-attribute handles <close>;
#                       ^^^^^^^ trait 
```

... and also `is tighter`, `is looser`, `is equiv` and `is assoc` from the previous section.

Traits are subs declared in the form `trait_mod<VERB> `, where `VERB` stands for the name like `is`, `does` or `handles`. It receives the modified thing as argument, and the name as a named argument. See [Sub](https://docs.perl6.org/type/Sub#Traits) for details.

```
multi sub trait_mod:<is>(Routine $r, :$doubles!) {
    $r.wrap({
        2 * callsame;
    });
}
 
sub square($x) is doubles {
    $x * $x;
}
 
say square 3;       # OUTPUT: «18␤» 
```

See [type Routine](https://docs.perl6.org/type/Routine) for the documentation of built-in routine traits.

# Re-dispatching

There are cases in which a routine might want to call the next method from a chain. This chain could be a list of parent classes in a class hierarchy, or it could be less specific multi candidates from a multi dispatch, or it could be the inner routine from a `wrap`.

Fortunately, we have a series of re-dispatching tools that help us to make it easy.

## sub callsame



`callsame` calls the next matching candidate with the same arguments that were used for the current candidate and returns that candidate's return value.

```
proto a(|) {*}
 
multi a(Any $x) {
    say "Any $x";
    return 5;
}
 
multi a(Int $x) {
    say "Int $x";
    my $res = callsame;
    say "Back in Int with $res";
}
 
a 1;        # OUTPUT: «Int 1␤Any 1␤Back in Int with 5␤» 
```

## sub callwith



`callwith` calls the next candidate matching the original signature, that is, the next function that could possibly be used with the arguments provided by users and returns that candidate's return value.

```
proto a(|) {*}
 
multi a(Any $x) {
    say "Any $x";
    return 5;
}
multi a(Int $x) {
    say "Int $x";
    my $res = callwith($x + 1);
    say "Back in Int with $res";
}
 
a 1;        # OUTPUT: «Int 1␤Any 2␤Back in Int with 5␤» 
```

Here, `a 1` calls the most specific `Int` candidate first, and `callwith` re-dispatches to the less specific `Any` candidate. Note that although our parameter `$x + 1` is an `Int`, still we call the next candidate in the chain.

In this case, for example:

```
proto how-many(|) {*}
 
multi how-many( Associative $a ) {
    say "Associative $a ";
    my $calling = callwith( 1 => $a );
    return $calling;
}
 
multi how-many( Pair $a ) {
    say "Pair $a ";
    return "There is $a "
 
}
 
multi how-many( Hash $a ) {
    say "Hash $a";
    return "Hashing $a";
}
 
my $little-piggy = little => 'piggy';
say $little-piggy.^name;        # OUTPUT: «Pair␤» 
say &how-many.cando( \( $little-piggy ));
# OUTPUT: «(sub how-many (Pair $a) { #`(Sub|68970512) ... } sub how-many (Associative $a) { #`(Sub|68970664) ... })␤» 
say how-many( $little-piggy  ); # OUTPUT: «Pair little     piggy␤There is little piggy␤» 
```

the only candidates that take the `Pair` argument supplied by the user are the two functions defined first. Although a `Pair` can be easily coerced to a `Hash`, here is how signatures match:

```
say :( Pair ) ~~ :( Associative ); # OUTPUT: «True␤» 
say :( Pair ) ~~ :( Hash );        # OUTPUT: «False␤» 
```

The arguments provided by us are a `Pair`. It does not match a `Hash`, so the corresponding function is thus not included in the list of candidates, as can be seen by the output of `&how-many.cando( \( $little-piggy ));`.

## sub nextsame



`nextsame` calls the next matching candidate with the same arguments that were used for the current candidate and **never**returns.

```
proto a(|) {*}
 
multi a(Any $x) {
    say "Any $x";
    return 5;
}
multi a(Int $x) {
    say "Int $x";
    nextsame;
    say "never executed because nextsame doesn't return";
}
 
a 1;        # OUTPUT: «Int 1␤Any 1␤» 
```

## sub nextwith



`nextwith` calls the next matching candidate with arguments provided by users and **never** returns.

```
proto a(|) {*}
 
multi a(Any $x) {
    say "Any $x";
    return 5;
}
multi a(Int $x) {
    say "Int $x";
    nextwith($x + 1);
    say "never executed because nextsame doesn't return";
}
 
a 1;        # OUTPUT: «Int 1␤Any 2␤» 
```

## sub samewith



`samewith` calls current candidate again with arguments provided by users and returns return value of the new instance of current candidate.

```
proto a(|) {*}
 
multi a(Int $x) {
  return 1 unless $x > 1;
  return $x * samewith($x-1);
}
 
say (a 10); # OUTPUT: «36288002␤» 
```



## sub nextcallee

Redispatch may be required to call a block that is not the current scope what provides `nextsame` and friends with the problem to referring to the wrong scope. Use `nextcallee` to capture the right candidate and call it at the desired time.

```
proto pick-winner(|) {*}
 
multi pick-winner (Int \s) {
    my &nextone = nextcallee;
    Promise.in(π²).then: { nextone s }
}
multi pick-winner { say "Woot! $^w won" }
 
with pick-winner ^5 .pick -> \result {
    say "And the winner is...";
    await result;
}
 
# OUTPUT: 
# And the winner is... 
# Woot! 3 won 
```

The Int candidate takes the `nextcallee` and then fires up a Promise to be executed in parallel, after some timeout, and then returns. We can't use `nextsame` here, because it'd be trying to `nextsame` the Promise's block instead of our original routine.



## Wrapped routines

Besides those are mentioned above, re-dispatch is helpful in more situations. One is for dispatching to wrapped routines:

```
# enable wrapping: 
use soft;
 
# function to be wrapped: 
sub square-root($x) { $x.sqrt }
 
&square-root.wrap(sub ($num) {
   nextsame if $num >= 0;
   1i * callwith(abs($num));
});
 
say square-root(4);     # OUTPUT: «2␤» 
say square-root(-4);    # OUTPUT: «0+2i␤» 
```

## Routines of parent class

Another use case is to re-dispatch to methods from parent classes.

```
say Version.new('1.0.2') # OUTPUT: v1.0.2 
class LoggedVersion is Version {
    method new(|c) {
        note "New version object created with arguments " ~ c.perl;
        nextsame;
    }
}
 
say LoggedVersion.new('1.0.2');
 
# OUTPUT: 
# New version object created with arguments \("1.0.2") 
# v1.0.2 
```

# Coercion types

Coercion types force a specific type for routine arguments while allowing the routine itself to accept a wider input. When invoked, the arguments are narrowed automatically to the stricter type, and therefore within the routine the arguments have always the desired type.

In the case the arguments cannot be converted to the stricter type, a *Type Check* error is thrown.

```
sub double(Int(Cool) $x) {
    2 * $x
}
 
say double '21';# OUTPUT: «42␤» 
say double  21; # OUTPUT: «42␤» 
say double Any; # Type check failed in binding $x; expected 'Cool' but got 'Any' 
```

In the above example, the [Int](https://docs.perl6.org/type/Int) is the target type to which the argument `$x` will be coerced, and [Cool](https://docs.perl6.org/type/Cool) is the type that the routine accepts as wider input.

If the accepted wider input type is [Any](https://docs.perl6.org/type/Any), it is possible to abbreviate the coercion `Int(Any)` omitting the `Any` type, thus resulting in `Int()`.

The coercion works by looking for a method with the same name as the target type: if such method is found on the argument, it is invoked to convert the latter to the expected narrow type. From the above, it is clear that it is possible to provide coercion among user types just providing the required methods:

```
class Bar {
   has $.msg;
}
 
class Foo {
   has $.msg = "I'm a foo!";
 
   # allows coercion from Foo to Bar 
   method Bar {
       Bar.new(:msg($.msg ~ ' But I am now Bar.'));
   }
}
 
# wants a Bar, but accepts Any 
sub print-bar(Bar() $bar) {
   say $bar.^name; # OUTPUT: «Bar␤» 
   say $bar.msg;   # OUTPUT: «I'm a foo! But I am now Bar.␤» 
}
 
print-bar Foo.new;
```

In the above code, once a `Foo` instance is passed as argument to `print-bar`, the `Foo.Bar` method is called and the result is placed into `$bar`.

Coercion types are supposed to work wherever types work, but Rakudo currently (2018.05) only implements them in signatures, for both parameters and return types.

Coercion also works with return types:

```
sub are-equal (Int $x, Int $y --> Bool(Int) ) { $x - $y };
 
for (2,4) X (1,2) -> ($a,$b) {
    say "Are $a and $b equal? ", are-equal($a, $b);
} #  OUTPUT: «Are 2 and 1 equal? True␤Are 2 and 2 equal? False␤Are 4 and 1 equal? True␤Are 4 and 2 equal? True␤» 
```

In this case, we are coercing an `Int` to a `Bool`, which is then printed (put into a string context) in the `for` loop that calls the function.

# sub MAIN

Declaring a `sub MAIN` is not compulsory in Perl 6 scripts, but you can provide one to create a [command line interface](https://docs.perl6.org/language/create-cli) for your script.