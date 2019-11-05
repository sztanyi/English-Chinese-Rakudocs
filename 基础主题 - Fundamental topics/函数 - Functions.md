原文：https://docs.raku.org/language/functions

# 函数 / Functions

Raku 中的函数和函数式编程

Functions and functional programming in Raku

例程是 Raku 重用代码的方法之一。它们有几种形式，最显著的是 [方法](https://docs.raku.org/type/Method)，它们属于类和角色，与一个对象相关联；以及函数（也称为*子例程*或 [sub](https://docs.raku.org/type/Sub)），可以独立于对象调用。

Routines are one of the means Raku has to reuse code. They come in several forms, most notably [methods](https://docs.raku.org/type/Method), which belong in classes and roles and are associated with an object; and functions (also called *subroutines* or [sub](https://docs.raku.org/type/Sub)s, for short), which can be called independently of objects.

子例程默认为词法（`my`）作用域，对它们的调用通常在编译时解决。

Subroutines default to lexical (`my`) scoping, and calls to them are generally resolved at compile time.

子例程可以有一个[签名](https://docs.raku.org/type/Signature)，也称为*参数列表*，它指定签名期望的参数（如果有）。它可以指定参数的数量和类型，以及返回值。

Subroutines can have a [signature](https://docs.raku.org/type/Signature), also called *parameter list*, which specifies which, if any, arguments the signature expects. It can specify (or leave open) both the number and types of arguments, and the return value.

子例程的自省通过 [`Routine`](https://docs.raku.org/type/Routine) 提供。

Introspection on subroutines is provided via [`Routine`](https://docs.raku.org/type/Routine).

<!-- MarkdownTOC -->

- [定义/创建/使用函数 - Defining/Creating/Using functions](#%E5%AE%9A%E4%B9%89%E5%88%9B%E5%BB%BA%E4%BD%BF%E7%94%A8%E5%87%BD%E6%95%B0---definingcreatingusing-functions)
  - [子例程 Subroutines](#%E5%AD%90%E4%BE%8B%E7%A8%8B-subroutines)
  - [代码块和拉姆达 / Blocks and lambdas](#%E4%BB%A3%E7%A0%81%E5%9D%97%E5%92%8C%E6%8B%89%E5%A7%86%E8%BE%BE--blocks-and-lambdas)
  - [签名 / Signatures](#%E7%AD%BE%E5%90%8D--signatures)
    - [自动签名 / Automatic signatures](#%E8%87%AA%E5%8A%A8%E7%AD%BE%E5%90%8D--automatic-signatures)
  - [参数 / Arguments](#%E5%8F%82%E6%95%B0--arguments)
  - [返回值 / Return values](#%E8%BF%94%E5%9B%9E%E5%80%BC--return-values)
  - [返回类型约束 / Return type constraints](#%E8%BF%94%E5%9B%9E%E7%B1%BB%E5%9E%8B%E7%BA%A6%E6%9D%9F--return-type-constraints)
  - [多分派 / Multi-dispatch](#%E5%A4%9A%E5%88%86%E6%B4%BE--multi-dispatch)
    - [proto](#proto)
  - [only](#only)
- [习惯用法和习语 / Conventions and idioms](#%E4%B9%A0%E6%83%AF%E7%94%A8%E6%B3%95%E5%92%8C%E4%B9%A0%E8%AF%AD--conventions-and-idioms)
  - [Slurpy 约定 / Slurpy conventions](#slurpy-%E7%BA%A6%E5%AE%9A--slurpy-conventions)
- [函数是第一等对象 / Functions are first-class objects](#%E5%87%BD%E6%95%B0%E6%98%AF%E7%AC%AC%E4%B8%80%E7%AD%89%E5%AF%B9%E8%B1%A1--functions-are-first-class-objects)
  - [中缀形式 / Infix form](#%E4%B8%AD%E7%BC%80%E5%BD%A2%E5%BC%8F--infix-form)
  - [闭包 / Closures](#%E9%97%AD%E5%8C%85--closures)
  - [例程 / Routines](#%E4%BE%8B%E7%A8%8B--routines)
- [定义运算符 / Defining operators](#%E5%AE%9A%E4%B9%89%E8%BF%90%E7%AE%97%E7%AC%A6--defining-operators)
  - [优先级 / Precedence](#%E4%BC%98%E5%85%88%E7%BA%A7--precedence)
  - [结合性 / Associativity](#%E7%BB%93%E5%90%88%E6%80%A7--associativity)
- [特征 / Traits](#%E7%89%B9%E5%BE%81--traits)
- [重新分派 / Re-dispatching](#%E9%87%8D%E6%96%B0%E5%88%86%E6%B4%BE--re-dispatching)
  - [callsame 函数 / sub callsame](#callsame-%E5%87%BD%E6%95%B0--sub-callsame)
  - [callwith 函数 / sub callwith](#callwith-%E5%87%BD%E6%95%B0--sub-callwith)
  - [nextsame 函数 / sub nextsame](#nextsame-%E5%87%BD%E6%95%B0--sub-nextsame)
  - [nextwith 函数 / sub nextwith](#nextwith-%E5%87%BD%E6%95%B0--sub-nextwith)
  - [samewith 函数 / sub samewith](#samewith-%E5%87%BD%E6%95%B0--sub-samewith)
  - [nextcallee 函数 / sub nextcallee](#nextcallee-%E5%87%BD%E6%95%B0--sub-nextcallee)
  - [包装的例程 / Wrapped routines](#%E5%8C%85%E8%A3%85%E7%9A%84%E4%BE%8B%E7%A8%8B--wrapped-routines)
  - [父类例程 / Routines of parent class](#%E7%88%B6%E7%B1%BB%E4%BE%8B%E7%A8%8B--routines-of-parent-class)
- [强制类型转换的类型 / Coercion types](#%E5%BC%BA%E5%88%B6%E7%B1%BB%E5%9E%8B%E8%BD%AC%E6%8D%A2%E7%9A%84%E7%B1%BB%E5%9E%8B--coercion-types)
- [Main 函数 / sub MAIN](#main-%E5%87%BD%E6%95%B0--sub-main)

<!-- /MarkdownTOC -->


<a id="%E5%AE%9A%E4%B9%89%E5%88%9B%E5%BB%BA%E4%BD%BF%E7%94%A8%E5%87%BD%E6%95%B0---definingcreatingusing-functions"></a>
# 定义/创建/使用函数 - Defining/Creating/Using functions

<a id="%E5%AD%90%E4%BE%8B%E7%A8%8B-subroutines"></a>
## 子例程 Subroutines

创建子例程的基本方法是使用 `sub` 声明符，后跟可选的[标识符](https://docs.raku.org/language/syntax#Identifiers)：

The basic way to create a subroutine is to use the `sub` declarator followed by an optional [identifier](https://docs.raku.org/language/syntax#Identifiers):

```Raku
sub my-func { say "Look ma, no args!" }
my-func;
```

sub 声明符返回可以存储在任何容器中的 [sub](https://docs.raku.org/type/Sub) 类型的值：

The sub declarator returns a value of type [Sub](https://docs.raku.org/type/Sub) that can be stored in any container:

```Raku
my &c = sub { say "Look ma, no name!" }
c;     # OUTPUT: «Look ma, no name!␤» 
 
my Any:D $f = sub { say 'Still nameless...' }
$f();  # OUTPUT: «Still nameless...␤» 
 
my Code \a = sub { say ‚raw containers don't implement postcircumfix:<( )>‘ };
a.();  # OUTPUT: «raw containers don't implement postcircumfix:<( )>␤» 
```

声明符 `sub` 会在编译时当前作用域内声明一个新名字。因此，任何间接声明都会在在编译时解析完：

The declarator `sub` will declare a new name in the current scope at compile time. As such any indirection has to be resolved at compile time:

```Raku
constant aname = 'foo';
sub ::(aname) { say 'oi‽' };
foo;
```

一旦将宏添加到 Raku 中，这将变得更加有用。

This will become more useful once macros are added to Raku.

要让子例程接受参数，在子例程的名称和其主体之间插入一个[签名](https://docs.raku.org/type/Signature)，在括号中：

To have the subroutine take arguments, a [signature](https://docs.raku.org/type/Signature) goes between the subroutine's name and its body, in parentheses:

```Raku
sub exclaim ($phrase) {
    say $phrase ~ "!!!!"
}
exclaim "Howdy, World";
```

默认情况下，子例程为[词法作用域](https://docs.raku.org/syntax/my)。也就是说，`sub foo {...}` 与 `my sub foo {...}` 相同，仅在当前作用域内定义。

By default, subroutines are [lexically scoped](https://docs.raku.org/syntax/my). That is, `sub foo {...}` is the same as `my sub foo {...}` and is only defined within the current scope.

```Raku
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

```Raku
say sub ($a, $b) { $a ** 2 + $b ** 2 }(3, 4) # OUTPUT: «25␤» 
```

但在这种情况下，通常需要使用更简洁的 [block](https://docs.raku.org/type/Block) 语法。子例程和块可以就地调用，如上面的示例所示。

But in this case, it's often desirable to use the more succinct [block](https://docs.raku.org/type/Block) syntax. Subroutines and blocks can be called in place, as in the example above.

```Raku
say -> $a, $b { $a ** 2 + $b ** 2 }(3, 4)    # OUTPUT: «25␤» 
```

甚至

Or even

```Raku
say { $^a ** 2 + $^b ** 2 }(3, 4)            # OUTPUT: «25␤» 
```

<a id="%E4%BB%A3%E7%A0%81%E5%9D%97%E5%92%8C%E6%8B%89%E5%A7%86%E8%BE%BE--blocks-and-lambdas"></a>
## 代码块和拉姆达 / Blocks and lambdas

每当你看到类似于 `{ $_ + 42 }`、 `-> $a, $b { $a ** $b }`，或 `{ $^text.indent($:spaces) }`，那就是 [Block](https://docs.raku.org/type/Block) 语法。它在 `if`、 `for` 和 `while` 等后面使用。

Whenever you see something like `{ $_ + 42 }`, `-> $a, $b { $a ** $b }`, or `{ $^text.indent($:spaces) }`, that's [Block](https://docs.raku.org/type/Block) syntax. It's used after every `if`, `for`, `while`, etc.

```Raku
for 1, 2, 3, 4 -> $a, $b {
    say $a ~ $b;
}
# OUTPUT: «12␤34␤» 
```

它们也可以作为匿名代码块单独使用。

They can also be used on their own as anonymous blocks of code.

```Raku
say { $^a ** 2 + $^b ** 2}(3, 4) # OUTPUT: «25␤» 
```

有关块语法的详细信息，请参阅 [Block](https://docs.raku.org/type/Block) 类型的文档。

For block syntax details, see the documentation for the [Block](https://docs.raku.org/type/Block) type.

<a id="%E7%AD%BE%E5%90%8D--signatures"></a>
## 签名 / Signatures

函数接受的参数在其*签名*中描述。

The parameters that a function accepts are described in its *signature*.

```Raku
sub format(Str $s) { ... }
-> $a, $b { ... }
```

有关签名的语法和使用的详细信息，请参见 [关于'signature'类的文档](https://docs.raku.org/type/Signature)。

Details about the syntax and use of signatures can be found in the [documentation on the `Signature` class](https://docs.raku.org/type/Signature).

<a id="%E8%87%AA%E5%8A%A8%E7%AD%BE%E5%90%8D--automatic-signatures"></a>
### 自动签名 / Automatic signatures

如果没有提供签名，但函数体中使用了两个自动变量 `@_` 或 `%_` ，则将生成带有 `*@_` 或 `*%_` 的签名。两个自动变量可以同时使用。

If no signature is provided but either of the two automatic variables `@_` or `%_` are used in the function body, a signature with `*@_` or `*%_` will be generated. Both automatic variables can be used at the same time.

```Raku
sub s { say @_, %_ };
say &s.signature # OUTPUT: «(*@_, *%_)␤» 
```

<a id="%E5%8F%82%E6%95%B0--arguments"></a>
## 参数 / Arguments

参数以逗号分隔的列表形式提供。要消除嵌套调用的歧义，请使用括号：

Arguments are supplied as a comma separated list. To disambiguate nested calls, use parentheses:

```Raku
sub f(&c){ c() * 2 }; # call the function reference c with empty parameter list 
sub g($p){ $p - 2 };
say(g(42), 45);       # pass only 42 to g() 
```

调用函数时，位置参数的提供顺序应与函数的签名相同。命名参数可以按任意顺序提供，但将命名参数放在位置参数之后被认为是一种很好的形式。在函数调用的参数列表中，支持某些特殊语法：

When calling a function, positional arguments should be supplied in the same order as the function's signature. Named arguments may be supplied in any order, but it's considered good form to place named arguments after positional arguments. Inside the argument list of a function call, some special syntax is supported:

```Raku
sub f(|c){};
f :named(35);     # A named argument (in "adverb" form)
f named => 35;    # Also a named argument
f :35named;       # A named argument using abbreviated adverb form
f 'named' => 35;  # Not a named argument, a Pair in a positional argument
my \c = <a b c>.Capture;
f |c;             # Merge the contents of Capture $c as if they were supplied
```

传递给函数的参数在概念上首先收集在 `Capture` 容器中。有关这些容器的语法和使用的详细信息，请参见[关于 `Capture` 类的文档](https://docs.raku.org/type/Capture)。

Arguments passed to a function are conceptually first collected in a `Capture` container. Details about the syntax and use of these containers can be found in the [documentation on the `Capture` class](https://docs.raku.org/type/Capture).

使用命名参数时，请注意，普通列表“对链接”允许跳过命名参数之间的逗号。

When using named arguments, note that normal List "pair-chaining" allows one to skip commas between named arguments.

```Raku
sub f(|c){};
f :dest</tmp/foo> :src</tmp/bar> :lines(512);
f :32x :50y :110z;   # This flavor of "adverb" works, too 
f :a:b:c;            # The spaces are also optional. 
```

<a id="%E8%BF%94%E5%9B%9E%E5%80%BC--return-values"></a>
## 返回值 / Return values

任何 `Block` 或 `Routine` 都会将其最后一个表达式的值作为返回值提供给调用方。如果调用了 [return](https://docs.raku.org/language/control#return) 或 [return-rw](https://docs.raku.org/language/control#return-rw) ，则其参数（如果有）将成为返回值。默认返回值为 [Nil](https://docs.raku.org/type/Nil)。

Any `Block` or `Routine` will provide the value of its last expression as a return value to the caller. If either [return](https://docs.raku.org/language/control#return) or [return-rw](https://docs.raku.org/language/control#return-rw) is called, then its parameter, if any, will become the return value. The default return value is [Nil](https://docs.raku.org/type/Nil).

```Raku
sub a { 42 };
sub b { say a };
sub c { };
b;     # OUTPUT: «42␤»
say c; # OUTPUT: «Nil␤»
```

多个返回值作为一个列表或通过创建一个 [Capture](https://docs.raku.org/type/Capture) 返回。析构函数可用于解开多个返回值。

Multiple return values are returned as a list or by creating a [Capture](https://docs.raku.org/type/Capture). Destructuring can be used to untangle multiple return values.

```Raku
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

<a id="%E8%BF%94%E5%9B%9E%E7%B1%BB%E5%9E%8B%E7%BA%A6%E6%9D%9F--return-type-constraints"></a>
## 返回类型约束 / Return type constraints

Raku 有许多方法可以指定函数的返回类型：

Raku has many ways to specify a function's return type:

```Raku
sub foo(--> Int)      {}; say &foo.returns; # OUTPUT: «(Int)␤» 
sub foo() returns Int {}; say &foo.returns; # OUTPUT: «(Int)␤» 
sub foo() of Int      {}; say &foo.returns; # OUTPUT: «(Int)␤» 
my Int sub foo()      {}; say &foo.returns; # OUTPUT: «(Int)␤» 
```

尝试返回其他类型的值将导致编译错误。

Attempting to return values of another type will cause a compilation error.

```Raku
sub foo() returns Int { "a"; }; foo; # Type check fails 
```

`returns` 和 `of` 是等效的，它们都只接受一个类型，因为它们声明了 [Callable](https://docs.raku.org/type/Callable)的特性。最后一个声明实际上是一个类型声明，它显然只能接受一个类型。但是 `-->` 可以采用未定义或定义了的值。

`returns` and `of` are equivalent, and both take only a Type since they are declaring a trait of the [Callable](https://docs.raku.org/type/Callable). The last declaration is, in fact, a type declaration, which obviously can take only a type. `-->`, however, can take either undefined or definite values.

请注意，`Nil` 和 `Failure` 不受返回类型约束，并且可以从任何例程返回，无论其约束如何：

Note that `Nil` and `Failure` are exempt from return type constraints and can be returned from any routine, regardless of its constraint:

```Raku
sub foo() returns Int { fail   }; foo; # Failure returned 
sub bar() returns Int { return }; bar; # Nil returned 
```

<a id="%E5%A4%9A%E5%88%86%E6%B4%BE--multi-dispatch"></a>
## 多分派 / Multi-dispatch

Raku 允许使用相同的名称但不同的签名编写多个例程。当以名称调用例程时，运行时环境将确定正确的*候选例程*并调用它。

Raku allows for writing several routines with the same name but different signatures. When the routine is called by name, the runtime environment determines the proper *candidate* and invokes it.

每个候选项都用 `multi` 关键字声明。根据参数的编号（[arity](https://docs.raku.org/type/Routine#%28Code%29_method_arity)）、类型和名称进行调度。请考虑以下示例：

Each candidate is declared with the `multi` keyword. Dispatch happens depending on the number ([arity](https://docs.raku.org/type/Routine#%28Code%29_method_arity)), type and name of arguments. Consider the following example:

```Raku
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

`happy-birthday` 子例程的前两个版本仅在参数个数上有所不同，而第三个版本使用命名参数，并且仅在使用命名参数时被选中，即使参数个数与另一个 `multi` 候选版本相同。

The first two versions of the `happy-birthday` sub differs only in the arity (number of arguments), while the third version uses named arguments and is chosen only when named arguments are used, even if the arity is the same of another `multi`candidate.

当两个子例程具有相同的参数个数时，则由参数的类型驱动调度；当存在命名参数时，即使它们的类型与另一个候选类型相同，它们也驱动调度：

When two sub have the same arity, the type of the arguments drive the dispatch; when there are named arguments they drive the dispatch even when their type is the same as another candidate:

```Raku
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

有关类型约束的详细信息，请参阅[签名](https://docs.raku.org/type/Signature#Type_constraints)类的文档。

For more information about type constraints see the documentation for the [Signature](https://docs.raku.org/type/Signature#Type_constraints) class.

```Raku
multi as-json(Bool $d) { $d ?? 'true' !! 'false'; }
multi as-json(Real $d) { ~$d }
multi as-json(@d)      { sprintf '[%s]', @d.map(&as-json).join(', ') }
 
say as-json( True );                        # OUTPUT: «true␤» 
say as-json( 10.3 );                        # OUTPUT: «10.3␤» 
say as-json( [ True, 10.3, False, 24 ] );   # OUTPUT: «[true, 10.3, false, 24]␤» 
```

`multi` 不带任何特定子例程类型都缺省为 `sub`，但是你也可以对方法使用它。候选都是对象的 multi 方法：

`multi` without any specific routine type always defaults to a `sub`, but you can use it on methods as well. The candidates are all the multi methods of the object:

```Raku
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

<a id="proto"></a>
### proto

`proto` 是一种正式声明 `multi` 候选人之间共性的方法。它充当一个包装器，可以验证但不能修改参数。考虑这个基本示例：

`proto` is a way to formally declare commonalities between `multi` candidates. It acts as a wrapper that can validate but not modify arguments. Consider this basic example:

```Raku
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

```Raku
say &congratulate.signature # OUTPUT: «(Str $reason, Str $name, | is raw)␤» 
```

你可以给 `proto` 一个函数体，并将 `{*}` 放在要完成分派的位置。

You can give the `proto` a function body, and place the `{*}` where you want the dispatch to be done.

```Raku
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

```Raku
proto mistake-proto(Str() $str, Int $number = 42) {*}
multi mistake-proto($str, $number) { say $str.^name }
mistake-proto(7, 42);  # OUTPUT: «Int␤» -- not passed on 
mistake-proto('test'); # fails -- not passed on 
```

<a id="only"></a>
## only

在 `sub` 或 `method` 前面的 `only` 关键字指示它将是唯一驻留给定命名空间的具有该名称的函数。

The `only` keyword preceding `sub` or `method` indicates that it will be the only function with that name that inhabits a given namespace.

```Raku
only sub you () {"Can make all the world seem right"};
```

这将在同一命名空间中生成其他声明，例如

This will make other declarations in the same namespace, such as

```Raku
sub you ( $can ) { "Make the darkness bright" }
```

失败并出现类型为 `X::Redeclaration` 的异常。`only` 是所有 sub 的默认值；在上面的情况下，不将第一个子例程声明为 `only` 将产生完全相同的错误；但是，没有什么可以阻止未来的开发人员声明 proto 并在名称前面加上 `multi`。在例程之前使用 `only` 是一个[防御编程](https://en.wikipedia.org/wiki/Defensive_programming)特点，它声明将来不在同一命名空间中声明具有相同名称的例程。

fail with an exception of type `X::Redeclaration`. `only` is the default value for all subs; in the case above, not declaring the first subroutine as `only` will yield exactly the same error; however, nothing prevents future developers from declaring a proto and preceding the names with `multi`. Using `only` before a routine is a [defensive programming](https://en.wikipedia.org/wiki/Defensive_programming) feature that declares the intention of not having routines with the same name declared in the same namespace in the future.

```Raku
(exit code 1)
===SORRY!=== Error while compiling /tmp/only-redeclaration.p6
Redeclaration of routine 'you' (did you mean to declare a multi-sub?)
at /tmp/only-redeclaration.p6:3
------> <BOL>⏏<EOL>
```

匿名子例程不能声明为 `only`。`only sub {}` 会抛出类型为 `X::Anon::Multi` 的错误。

Anonymous sub cannot be declared `only`. `only sub {}'` will throw an error of type, surprisingly, `X::Anon::Multi`.

<a id="%E4%B9%A0%E6%83%AF%E7%94%A8%E6%B3%95%E5%92%8C%E4%B9%A0%E8%AF%AD--conventions-and-idioms"></a>
# 习惯用法和习语 / Conventions and idioms

虽然上面描述的调度系统提供了很大的灵活性，但是大多数内部函数和许多模块中的函数都会遵循一些约定。

While the dispatch system described above provides a lot of flexibility, there are some conventions that most internal functions, and those in many modules, will follow.

<a id="slurpy-%E7%BA%A6%E5%AE%9A--slurpy-conventions"></a>
## Slurpy 约定 / Slurpy conventions

也许这些约定中最重要的一个就是处理 slurpy 列表参数的方式。大多数情况下，函数不会自动压扁 slurpy 列表。罕见的例外是那些在列表的列表上没有合理行为的函数（例如，[chrs](https://docs.raku.org/routine/chrs)），或者与已建立的习惯用法（例如，[pop](https://docs.raku.org/routine/pop) 作为 [push](https://docs.raku.org/routine/push) 的逆函数 ）。

Perhaps the most important one of these conventions is the way slurpy list arguments are handled. Most of the time, functions will not automatically flatten slurpy lists. The rare exceptions are those functions that don't have a reasonable behavior on lists of lists (e.g., [chrs](https://docs.raku.org/routine/chrs)) or where there is a conflict with an established idiom (e.g., [pop](https://docs.raku.org/routine/pop) being the inverse of [push](https://docs.raku.org/routine/push)).

如果你希望匹配这种外观和感觉，任何 [Iterable](https://docs.raku.org/type/Iterable) 参数都必须使用 `**@` 逐元素分解，这有两个细微差别：

If you wish to match this look and feel, any [Iterable](https://docs.raku.org/type/Iterable) argument must be broken out element-by-element using a `**@` slurpy, with two nuances:

- 对[标量容器](https://docs.raku.org/language/containers#Scalar_containers)中的 [Iterable](https://docs.raku.org/type/Iterable) 不生效。
- 使用一个 [`,`](https://docs.raku.org/routine/,) 创建的 [List](https://docs.raku.org/type/List)，在最上层只会被当做一个 [Iterable](https://docs.raku.org/type/Iterable)。

- An [Iterable](https://docs.raku.org/type/Iterable) inside a [Scalar container](https://docs.raku.org/language/containers#Scalar_containers) doesn't count.
- [List](https://docs.raku.org/type/List)s created with a [`,`](https://docs.raku.org/routine/,) at the top level only count as one [Iterable](https://docs.raku.org/type/Iterable).

这可以通过使用 `+` 或者 `+@` 而不是 `**` 来实现：

This can be achieved by using a slurpy with a `+` or `+@` instead of `**`:

```Raku
sub grab(+@a) { "grab $_".say for @a }
```

这是非常接近以下内容的简写：

which is shorthand for something very close to:

```Raku
multi sub grab(**@a) { "grab $_".say for @a }
multi sub grab(\a) {
    a ~~ Iterable and a.VAR !~~ Scalar ?? nextwith(|a) !! nextwith(a,)
}
```

这会导致下列被称为*单参数规则*的行为，在调用 slurpy 函数时需要了解这些行为至关重要：

This results in the following behavior, which is known as the *"single argument rule"* and is important to understand when invoking slurpy functions:

```Raku
grab(1, 2);      # OUTPUT: «grab 1␤grab 2␤» 
grab((1, 2));    # OUTPUT: «grab 1␤grab 2␤» 
grab($(1, 2));   # OUTPUT: «grab 1 2␤» 
grab((1, 2), 3); # OUTPUT: «grab 1 2␤grab 3␤» 
```

这也使得用户请求的扁平化无论有一个子列表还是多个子列表都感觉一致：

This also makes user-requested flattening feel consistent whether there is one sublist, or many:

```Raku
grab(flat (1, 2), (3, 4));   # OUTPUT: «grab 1␤grab 2␤grab 3␤grab 4␤» 
grab(flat $(1, 2), $(3, 4)); # OUTPUT: «grab 1 2␤grab 3 4␤» 
grab(flat (1, 2));           # OUTPUT: «grab 1␤grab 2␤» 
grab(flat $(1, 2));          # OUTPUT: «grab 1␤grab 2␤» 
```

值得注意的是，在这些情况下混合绑定和无符号变量需要一些技巧，因为在绑定期间没有使用[标量](https://docs.raku.org/type/Scalar)媒介。

It's worth noting that mixing binding and sigilless variables in these cases requires a bit of finesse, because there is no [Scalar](https://docs.raku.org/type/Scalar)intermediary used during binding.

```Raku
my $a = (1, 2);  # Normal assignment, equivalent to $(1, 2) 
grab($a);        # OUTPUT: «grab 1 2␤» 
my $b := (1, 2); # Binding, $b links directly to a bare (1, 2) 
grab($b);        # OUTPUT: «grab 1␤grab 2␤» 
my \c = (1, 2);  # Sigilless variables always bind, even with '=' 
grab(c);         # OUTPUT: «grab 1␤grab 2␤» 
```

<a id="%E5%87%BD%E6%95%B0%E6%98%AF%E7%AC%AC%E4%B8%80%E7%AD%89%E5%AF%B9%E8%B1%A1--functions-are-first-class-objects"></a>
# 函数是第一等对象 / Functions are first-class objects

函数和其他代码对象可以作为值传递，就像其他任何对象一样。

Functions and other code objects can be passed around as values, just like any other object.

有几种方法可以获取代码对象。可以在声明点将其赋给变量：

There are several ways to get hold of a code object. You can assign it to a variable at the point of declaration:

```Raku
my $square = sub (Numeric $x) { $x * $x }
# and then use it: 
say $square(6);    # OUTPUT: «36␤» 
```

或者，可以使用在函数名前面使用 `&` 来引用现有的命名函数。

Or you can reference an existing named function by using the `&`-sigil in front of it.

```Raku
sub square($x) { $x * $x };
 
# get hold of a reference to the function: 
my $func = &square
```

这对于*高阶函数*非常有用，也就是说，将其他函数作为输入的函数。一个简单的例子是 [map](https://docs.raku.org/type/List#routine_map)，它将一个函数应用于每个输入元素：

This is very useful for *higher order functions*, that is, functions that take other functions as input. A simple one is [map](https://docs.raku.org/type/List#routine_map), which applies a function to each input element:

```Raku
sub square($x) { $x * $x };
my @squared = map &square,  1..5;
say join ', ', @squared;        # OUTPUT: «1, 4, 9, 16, 25␤» 
```

<a id="%E4%B8%AD%E7%BC%80%E5%BD%A2%E5%BC%8F--infix-form"></a>
## 中缀形式 / Infix form

要使用 2 个参数（如中缀运算符）调用子例程，使用由 `[` 和 `]` 包围的子例程引用。

To call a subroutine with 2 arguments like an infix operator, use a subroutine reference surrounded by `[` and `]`.

```Raku
sub plus { $^a + $^b };
say 21 [&plus] 21;
# OUTPUT: «42␤» 
```

<a id="%E9%97%AD%E5%8C%85--closures"></a>
## 闭包 / Closures

Raku 中的所有代码对象都是*闭包*，这意味着它们可以从外部范围引用词法变量。

All code objects in Raku are *closures*, which means they can reference lexical variables from an outer scope.

```Raku
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

另一个闭包示例是使用 [map](https://docs.raku.org/type/List#routine_map) 将数字列表相乘：

Another closure example is the use of [map](https://docs.raku.org/type/List#routine_map) to multiply a list of numbers:

```Raku
my $multiply-by = 5;
say join ', ', map { $_ * $multiply-by }, 1..5;     # OUTPUT: «5, 10, 15, 20, 25␤» 
```

在这里，传递给 `map` 的代码块引用了外部作用域中的变量 `$multiply-by`，从而使块成为一个闭包。

Here, the block passed to `map` references the variable `$multiply-by` from the outer scope, making the block a closure.

没有闭包的语言很难提供像 `map` 这样易于使用且功能强大的高阶函数。

Languages without closures cannot easily provide higher-order functions that are as easy to use and powerful as `map`.

<a id="%E4%BE%8B%E7%A8%8B--routines"></a>
## 例程 / Routines

例程是符合 [类型 `Routine`](https://docs.raku.org/type/Routine) 的代码对象，最显著的是 [`Sub`](https://docs.raku.org/type/Sub)、[`Method`](https://docs.raku.org/type/Method)、[`Regex`](https://docs.raku.org/type/Regex) 和 [`Submethod`](https://docs.raku.org/type/Submethod)。

Routines are code objects that conform to [type `Routine`](https://docs.raku.org/type/Routine), most notably [`Sub`](https://docs.raku.org/type/Sub), [`Method`](https://docs.raku.org/type/Method), [`Regex`](https://docs.raku.org/type/Regex) and [`Submethod`](https://docs.raku.org/type/Submethod).

除了 [`Block`](https://docs.raku.org/type/Block) 提供的功能外，它们还具有额外的功能：它们可以作为 [多分派](https://docs.raku.org/language/functions#Multi-dispatch)函数，你可以[包装](https://docs.raku.org/type/Routine#method_wrap)他们，并使用 `return` 提前退出：

They carry extra functionality in addition to what a [`Block`](https://docs.raku.org/type/Block) supplies: they can come as [multis](https://docs.raku.org/language/functions#Multi-dispatch), you can [wrap](https://docs.raku.org/type/Routine#method_wrap) them, and exit early with `return`:

```Raku
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

在这里，`return` 不仅仅是离开调用它的代码块，而是整个例程。通常，代码块对 `return` 是透明的，它们附加到最外层的例程。

Here, `return` doesn't just leave the block inside which it was called, but the whole routine. In general, blocks are transparent to `return`, they attach to the outermost routine.

例程可以是内联的，因此为包装提供了障碍。使用指令 `use soft;` 防止内联在运行时允许包装。

Routines can be inlined and as such provide an obstacle for wrapping. Use the pragma `use soft;` to prevent inlining to allow wrapping at runtime.

```Raku
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

<a id="%E5%AE%9A%E4%B9%89%E8%BF%90%E7%AE%97%E7%AC%A6--defining-operators"></a>
# 定义运算符 / Defining operators

运算符只是具有有趣名称的子例程。有趣的名称由类别名称（`infix`、`prefix`、`postfix`、`circufix`、`postcircumfix`）和其后的冒号以及一个或多个运算符名称列表（ circufix 和 postcircumfix 有两个组件）组成。

Operators are just subroutines with funny names. The funny names are composed of the category name (`infix`, `prefix`, `postfix`, `circumfix`, `postcircumfix`), followed by a colon, and a list of the operator name or names (two components in the case of circumfix and postcircumfix).

这既适用于向现有运算符添加多个候选对象，也适用于定义新运算符。在后一种情况下，新子程序的定义会自动将新的运算符安装到语法中，但仅在当前词汇范围内。通过 `use` 或 `import` 导入运算符也使其可用。

This works both for adding multi candidates to existing operators and for defining new ones. In the latter case, the definition of the new subroutine automatically installs the new operator into the grammar, but only in the current lexical scope. Importing an operator via `use` or `import` also makes it available.

```Raku
# adding a multi candidate to an existing operator: 
multi infix:<+>(Int $x, "same") { 2 * $x };
say 21 + "same";            # OUTPUT: «42␤» 
 
# defining a new operator 
sub postfix:<!>(Int $x where { $x >= 0 }) { [*] 1..$x };
say 6!;                     # OUTPUT: «720␤» 
```

运算符声明将尽快可用，因此可以递归到刚刚定义的运算符：

The operator declaration becomes available as soon as possible, so you can recurse into a just-defined operator:

```Raku
sub postfix:<!>(Int $x where { $x >= 0 }) {
    $x == 0 ?? 1 !! $x * ($x - 1)!
}
say 6!;                     # OUTPUT: «720␤» 
```

Circumfix 和 postcircumfix 运算符有两个分隔符组成，一个标记开始一个标记结尾。

Circumfix and postcircumfix operators are made of two delimiters, one opening and one closing.

```Raku
sub circumfix:<START END>(*@elems) {
    "start", @elems, "end"
}
 
say START 'a', 'b', 'c' END;        # OUTPUT: «(start [a b c] end)␤» 
```

Postcircumfix 还接收到一个术语，在该术语之后，它们将被解析为一个参数：

Postcircumfixes also receive the term after which they are parsed as an argument:

```Raku
sub postcircumfix:<!! !!>($left, $inside) {
    "$left -> ( $inside )"
}
say 42!! 1 !!;      # OUTPUT: «42 -> ( 1 )␤» 
```

代码块可以直接赋值给运算符名称。使用变量声明符并在运算符名称前面加上 `&` 标记。

Blocks can be assigned directly to operator names. Use a variable declarator and prefix the operator name with a `&`-sigil.

```Raku
my &infix:<ieq> = -> |l { [eq] l>>.fc };
say "abc" ieq "Abc";
# OUTPUT: «True␤» 
```

<a id="%E4%BC%98%E5%85%88%E7%BA%A7--precedence"></a>
## 优先级 / Precedence

Raku 中的运算符优先级是相对于现有运算符指定的。特征 `is tighter`、`is equiv` 和 `is looser`，可以提供一个运算符来指示新运算符的优先级如何与其他现有运算符相关。可以应用多个特性。

Operator precedence in Raku is specified relatively to existing operators. The traits `is tighter`, `is equiv` and `is looser` can be provided with an operator to indicate how the precedence of the new operators is related to other, existing ones. More than one trait can be applied.

例如，`infix:<*>` 比 `infix:<+>` 具有更严格的优先级，在两者之间插入一个优先级可以这样：

For example, `infix:<*>` has a tighter precedence than `infix:<+>`, and squeezing one in between works like this:

```Raku
sub infix:<!!>($a, $b) is tighter(&infix:<+>) {
    2 * ($a + $b)
}
 
say 1 + 2 * 3 !! 4;     # OUTPUT: «21␤» 
```

在这，`1 + 2 * 3 !! 4` 等于 `1 + ((2 * 3) !! 4)`，因为新运算符 `!!` 的优先级在 `+` 与 `*` 之间。

Here, the `1 + 2 * 3 !! 4` is parsed as `1 + ((2 * 3) !! 4)`, because the precedence of the new `!!` operator is between that of `+` and `*`.

同样的效果也可以通过以下方式实现：

The same effect could have been achieved with:

```Raku
sub infix:<!!>($a, $b) is looser(&infix:<*>) { ... }
```

若要将新运算符置于与现有运算符相同的优先级，请改用 `is equiv(&other-operator)`。

To put a new operator on the same precedence level as an existing operator, use `is equiv(&other-operator)` instead.

<a id="%E7%BB%93%E5%90%88%E6%80%A7--associativity"></a>
## 结合性 / Associativity

当同一个运算符在一行中出现多次时，可能会有多种解释。例如：

When the same operator appears several times in a row, there are multiple possible interpretations. For example:

```Raku
1 + 2 + 3
```

可以解析为

could be parsed as

```Raku
(1 + 2) + 3         # left associative 
```

或者

or as

```Raku
1 + (2 + 3)         # right associative 
```

对于实数的加法，这种区别有些无意义，因为 `+ `是 [数学上的关联性](https://en.wikipedia.org/wiki/Associative_property)。

For addition of real numbers, the distinction is somewhat moot, because `+` is [mathematically associative](https://en.wikipedia.org/wiki/Associative_property).

但对于其他运算符来说，这是非常重要的。例如，对于幂运算符，`infix:<**>`:

But for other operators it matters a great deal. For example, for the exponentiation/power operator, `infix:<**> `:

```Raku
say 2 ** (2 ** 3);      # OUTPUT: «256␤» 
say (2 ** 2) ** 3;      # OUTPUT: «64␤» 
```

Raku 具有以下可能的结合性：

Raku has the following possible associativity configurations:

| A    | Assoc | Meaning of $a ! $b ! $c |
| ---- | ----- | ----------------------- |
| L    | left  | ($a ! $b) ! $c          |
| R    | right | $a ! ($b ! $c)          |
| N    | non   | ILLEGAL                 |
| C    | chain | ($a ! $b) and ($b ! $c) |
| X    | list  | infix:<!>($a; $b; $c)   |

可以使用 `is assoc` 特性指定运算符的结合性，左结合是默认结合性。

You can specify the associativity of an operator with the `is assoc` trait, where `left` is the default associativity.

```Raku
sub infix:<§>(*@a) is assoc<list> {
    '(' ~ @a.join('|') ~ ')';
}
 
say 1 § 2 § 3;      # OUTPUT: «(1|2|3)␤» 
```

<a id="%E7%89%B9%E5%BE%81--traits"></a>
# 特征 / Traits

*Traits* 是在编译时运行并修改类型、变量、例程、属性或其他语言对象行为的子例程。

*Traits* are subroutines that run at compile time and modify the behavior of a type, variable, routine, attribute, or other language object.

特征的例子有：

Examples of traits are:

```Raku
class ChildClass is ParentClass { ... }
#                ^^ trait, with argument ParentClass 
has $.attrib is rw;
#            ^^^^^  trait with name 'rw' 
class SomeClass does AnotherRole { ... }
#               ^^^^ trait 
has $!another-attribute handles <close>;
#                       ^^^^^^^ trait 
```

另外，前一节的 `is tighter`、`is looser`、`is equiv` 和 `is assoc` 也是特征。

... and also `is tighter`, `is looser`, `is equiv` and `is assoc` from the previous section.

Traits 是以 `trait_mod<VERB>` 的形式声明的子例程，其中 `VERB` 表示像 `is`、`does` 或 `handles` 的动词。它接收修改后的对象作为参数，接收名称作为命名参数。有关详细信息，请参阅 [Sub](https://docs.raku.org/type/Sub#Traits)。

Traits are subs declared in the form `trait_mod<VERB>`, where `VERB` stands for the name like `is`, `does` or `handles`. It receives the modified thing as argument, and the name as a named argument. See [Sub](https://docs.raku.org/type/Sub#Traits) for details.

```Raku
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

内置的函数特征见文档[类型 Routine](https://docs.raku.org/type/Routine)。

See [type Routine](https://docs.raku.org/type/Routine) for the documentation of built-in routine traits.

<a id="%E9%87%8D%E6%96%B0%E5%88%86%E6%B4%BE--re-dispatching"></a>
# 重新分派 / Re-dispatching

在某些情况下，例程可能希望从链调用下一个方法。这个链可以是类层次结构中父类的列表，也可以是来自多个分派的不太具体的多个候选，或者是来自 `wrap` 的内部例程。

There are cases in which a routine might want to call the next method from a chain. This chain could be a list of parent classes in a class hierarchy, or it could be less specific multi candidates from a multi dispatch, or it could be the inner routine from a `wrap`.

幸运的是，我们有一系列的重新分派工具，帮助我们简化工作。

Fortunately, we have a series of re-dispatching tools that help us to make it easy.

<a id="callsame-%E5%87%BD%E6%95%B0--sub-callsame"></a>
## callsame 函数 / sub callsame

`callsame` 使用当前候选的相同参数调用下一个匹配的候选，并返回该候选的返回值。

`callsame` calls the next matching candidate with the same arguments that were used for the current candidate and returns that candidate's return value.

```Raku
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

<a id="callwith-%E5%87%BD%E6%95%B0--sub-callwith"></a>
## callwith 函数 / sub callwith

`callWith` 调用与原始签名匹配的下一个候选函数，也就是可能与用户提供的参数一起使用的下一个函数，并返回该候选函数的返回值。

`callwith` calls the next candidate matching the original signature, that is, the next function that could possibly be used with the arguments provided by users and returns that candidate's return value.

```Raku
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

这里，`a 1` 首先调用最具体的接收 `Int` 参数的候选参数，`callwith` 重新分派到不太具体的接受 `Any` 类型参数的函数候选。注意尽管我们的参数 `$x + 1` 是一个 `Int`，我们

Here, `a 1` calls the most specific `Int` candidate first, and `callwith` re-dispatches to the less specific `Any` candidate. Note that although our parameter `$x + 1` is an `Int`, still we call the next candidate in the chain.

在这个案例中，例如：

In this case, for example:

```Raku
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

唯一候选函数接受用户提供的 `Pair` 参数是先定义的那两个函数。尽管 `Pair` 可以很容易强制转成为 `Hash`，以下是签名的匹配方式：

the only candidates that take the `Pair` argument supplied by the user are the two functions defined first. Although a `Pair` can be easily coerced to a `Hash`, here is how signatures match:

```Raku
say :( Pair ) ~~ :( Associative ); # OUTPUT: «True␤» 
say :( Pair ) ~~ :( Hash );        # OUTPUT: «False␤» 
```

我们提供的参数是一个 `Pair`。它与 `Hash` 不匹配，因此相应的函数不包含在候选列表中，这可以通过 `&how-many.cando( \( $little-piggy ));` 的输出看到。

The arguments provided by us are a `Pair`. It does not match a `Hash`, so the corresponding function is thus not included in the list of candidates, as can be seen by the output of `&how-many.cando( \( $little-piggy ));`.

<a id="nextsame-%E5%87%BD%E6%95%B0--sub-nextsame"></a>
## nextsame 函数 / sub nextsame

`nextsame` 使用与当前候选函数相同的参数调用下一个匹配的候选函数，并且**不**返回原函数继续执行。

`nextsame` calls the next matching candidate with the same arguments that were used for the current candidate and **never** returns.

```Raku
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

<a id="nextwith-%E5%87%BD%E6%95%B0--sub-nextwith"></a>
## nextwith 函数 / sub nextwith

`nextwith` 使用用户提供的参数调用下一个匹配的候选函数，并且**不**返回原函数继续执行。

`nextwith` calls the next matching candidate with arguments provided by users and **never** returns.

```Raku
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

<a id="samewith-%E5%87%BD%E6%95%B0--sub-samewith"></a>
## samewith 函数 / sub samewith

`samewith` 使用用户提供的参数再次调用当前候选，并返回当前候选的新实例的返回值。

`samewith` calls current candidate again with arguments provided by users and returns return value of the new instance of current candidate.

```Raku
proto a(|) {*}

multi a(Int $x) {
  return 1 unless $x > 1;
  return $x * samewith($x-1);
}

say (a 10); # OUTPUT: «36288002␤»
```

<a id="nextcallee-%E5%87%BD%E6%95%B0--sub-nextcallee"></a>
## nextcallee 函数 / sub nextcallee

可能需要重新分配来调用一个不是当前作用域代码块，它提供了 `nextsame` 与其朋友们在引用错误作用域时遇到的问题。使用 `nextcallee` 捕获正确的候选对象并调用它。

Redispatch may be required to call a block that is not the current scope what provides `nextsame` and friends with the problem to referring to the wrong scope. Use `nextcallee` to capture the right candidate and call it at the desired time.

```Raku
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

Int 参数的候选函数调用 `nextcallee`，然后在超时后触发一个并行执行的 Promise，然后返回。我们不能在这里使用 `nextsame`，因为它会试图 `nextsame` 那个有 Promise 的代码块，而不是我们原来的子例程。

The Int candidate takes the `nextcallee` and then fires up a Promise to be executed in parallel, after some timeout, and then returns. We can't use `nextsame` here, because it'd be trying to `nextsame` the Promise's block instead of our original routine.

<a id="%E5%8C%85%E8%A3%85%E7%9A%84%E4%BE%8B%E7%A8%8B--wrapped-routines"></a>
## 包装的例程 / Wrapped routines

除上述情况外，在更多情况下，重新调度也很有帮助。分派到被包装的例程：

Besides those are mentioned above, re-dispatch is helpful in more situations. One is for dispatching to wrapped routines:

```Raku
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

<a id="%E7%88%B6%E7%B1%BB%E4%BE%8B%E7%A8%8B--routines-of-parent-class"></a>
## 父类例程 / Routines of parent class

另一个用例是从父类重新分派到方法。

Another use case is to re-dispatch to methods from parent classes.

```Raku
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

<a id="%E5%BC%BA%E5%88%B6%E7%B1%BB%E5%9E%8B%E8%BD%AC%E6%8D%A2%E7%9A%84%E7%B1%BB%E5%9E%8B--coercion-types"></a>
# 强制类型转换的类型 / Coercion types

强制类型转换类型强制例程参数为特定类型，同时允许例程本身接受更广泛的输入。调用时，参数会自动缩小到更严格的类型，因此在例程中，参数始终具有所需的类型。

Coercion types force a specific type for routine arguments while allowing the routine itself to accept a wider input. When invoked, the arguments are narrowed automatically to the stricter type, and therefore within the routine the arguments have always the desired type.

如果无法将参数转换为更严格的类型，则会引发*类型检查*错误。

In the case the arguments cannot be converted to the stricter type, a *Type Check* error is thrown.

```Raku
sub double(Int(Cool) $x) {
    2 * $x
}

say double '21';# OUTPUT: «42␤» 
say double  21; # OUTPUT: «42␤» 
say double Any; # Type check failed in binding $x; expected 'Cool' but got 'Any' 
```

在上例中 [Int](https://docs.raku.org/type/Int) 是参数 `$x` 会强制转换的目标类型，[Cool](https://docs.raku.org/type/Cool) 是例程接受的更广泛的类型。

In the above example, the [Int](https://docs.raku.org/type/Int) is the target type to which the argument `$x` will be coerced, and [Cool](https://docs.raku.org/type/Cool) is the type that the routine accepts as wider input.

如果接受的更广泛的输入类型是 [Any](https://docs.raku.org/type/Any)，可以省略 `Any` 类型，缩写 `Int(Any)` 为 `Int()`。

If the accepted wider input type is [Any](https://docs.raku.org/type/Any), it is possible to abbreviate the coercion `Int(Any)` omitting the `Any` type, thus resulting in `Int()`.

强制类型转换通过查找与目标类型同名的方法来工作：如果在参数上找到此类方法，则调用该方法将后者转换为预期的窄类型。从上面可以清楚地看出，仅提供所需方法就可以在用户类型之间提供强制类型转换：

The coercion works by looking for a method with the same name as the target type: if such method is found on the argument, it is invoked to convert the latter to the expected narrow type. From the above, it is clear that it is possible to provide coercion among user types just providing the required methods:

```Raku
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

在上面的代码中，一旦将 `Foo` 实例作为参数传递给 `print-bar` 函数，就会调用 `Foo.Bar` 方法，并将结果放入 `$bar`。

In the above code, once a `Foo` instance is passed as argument to `print-bar`, the `Foo.Bar` method is called and the result is placed into `$bar`.

强制类型转换应该在类型工作的任何地方都可以工作，但 Rakudo 目前（2018.05）只在签名中实现它们，用于参数和返回类型。

Coercion types are supposed to work wherever types work, but Rakudo currently (2018.05) only implements them in signatures, for both parameters and return types.

强制类型转换也适用于返回类型：

Coercion also works with return types:

```Raku
sub are-equal (Int $x, Int $y --> Bool(Int) ) { $x - $y };
 
for (2,4) X (1,2) -> ($a,$b) {
    say "Are $a and $b equal? ", are-equal($a, $b);
} #  OUTPUT: «Are 2 and 1 equal? True␤Are 2 and 2 equal? False␤Are 4 and 1 equal? True␤Are 4 and 2 equal? True␤» 
```

在这种情况下，我们将 `Int` 强制转换为 `Bool`，然后在调用函数的 `for` 循环中打印（放入字符串上下文中）。

In this case, we are coercing an `Int` to a `Bool`, which is then printed (put into a string context) in the `for` loop that calls the function.

<a id="main-%E5%87%BD%E6%95%B0--sub-main"></a>
# Main 函数 / sub MAIN

在 Raku 脚本中声明 `sub MAIN` 不是强制的，但是你可以提供一个[命令行接口](https://docs.raku.org/language/create-cli)来为你的脚本创建一个。

Declaring a `sub MAIN` is not compulsory in Raku scripts, but you can provide one to create a [command line interface](https://docs.raku.org/language/create-cli) for your script.