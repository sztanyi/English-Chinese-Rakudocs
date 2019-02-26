原文：https://docs.perl6.org/language/variables

# 变量

Perl 6 中的变量

Variables in Perl 6

变量名字以一种叫做标记的特殊字符开头，后面跟着叫 twigil 的特殊字符最后才是识别符，前面两个特殊符号都是可选的。变量是值以及容器的符号名称。定义变量或者给变量赋值会直接生成容器。

Variable names can start with or without a special character called a *sigil*, followed optionally by a second special character named *twigil* and then an [identifier](https://docs.perl6.org/language/syntax#Identifiers). Variables are symbolic names for values or [containers](https://docs.perl6.org/language/containers). Variable declarations or assignment of values may create a container on the fly.

# [标记（ Sigils ） ](https://docs.perl6.org/language/variables#___top)

共有四种标记。标量标记 `$`，位置标记 `@`，关联标记 `%` 和可调用标记 `&`。

There are four sigils. The scalar-sigil `$`, the positional-sigil `@`, the associative-sigil `%` and the callable-sigil `&`.

标记链接了语法，类型系统和[容器](https://docs.perl6.org/language/containers)。这些标记为最常见的类型约束提供快捷方式，当声明变量以及为[字符串插值](https://docs.perl6.org/language/quoting#Interpolation%3A_qq)充当标记时。[位置标记](https://docs.perl6.org/language/containers#Flattening%2C_items_and_containers)和[关联标记](https://docs.perl6.org/language/containers#Flattening%2C_items_and_containers)起到了类型约束的作用，使基础类型[下标](https://docs.perl6.org/language/subscripts#Custom_types)需要知道分派给哪些方法。可调用标记对函数调用起到了同样的作用。可调用标记还会告诉编译器哪些括号可以省略。位置和关联签名也可以通过默认情况下展平来简化分配。

Sigils provide a link between syntax, the type system and [containers](https://docs.perl6.org/language/containers). They provide a shortcut for the most common type constraints when declaring variables and serve as markers for [string interpolation](https://docs.perl6.org/language/quoting#Interpolation%3A_qq). The [positional-sigil](https://docs.perl6.org/language/containers#Flattening%2C_items_and_containers) and the [associative-sigil](https://docs.perl6.org/language/containers#Flattening%2C_items_and_containers) provide type constraint that enforce a base type [subscripts](https://docs.perl6.org/language/subscripts#Custom_types) require to know what methods to dispatch to. The [callable-sigil](https://docs.perl6.org/language/containers#Callable_containers) does the same for function calls. The latter also tells the compiler where parentheses for calls can be omitted. The positional and associative-sigil also simplify assignment by flattening by default.

| 标记   | 类型约束                    | 默认类型     | 赋值   | 例子                          |
| ---- | ----------------------- | -------- | ---- | --------------------------- |
| $    | Mu (no type constraint) | Any      | item | Int, Str, Array, Hash       |
| @    | Positional              | Array    | list | List, Array, Range, Buf     |
| %    | Associative             | Hash     | list | Hash, Map, Pair             |
| &    | Callable                | Callable | item | Sub, Method, Block, Routine |

Examples:

```Perl6
my $square = 9 ** 2;
my @array  = 1, 2, 3;   # Array variable with three elements 
my %hash   = London => 'UK', Berlin => 'Germany';
```

在声明中可以用 is 来设置容器类型。

The container type can be set with `is` in a declaration.

```Perl6
class FailHash is Hash {
    has Bool $!final = False;
    multi method AT-KEY ( ::?CLASS:D: Str:D \key ){
        fail X::OutOfRange.new(:what("Hash key"), :got(key), :range(self.keys)) if $!final && !self.EXISTS-KEY(key);
        callsame
    }
 
    method finalize() {
        $!final = True
    }
}
 
my %h is FailHash = oranges => "round", bananas => "bendy";
say %h<oranges>;
# OUTPUT: «round» 
%h.finalize;
say %h<cherry>;
CATCH { default { put .^name, ': ', .Str } }
# OUTPUT: «X::OutOfRange: Hash key out of range. Is: cherry, should be in (oranges bananas)» 
```

无标记的变量信息见 [sigilless variables](https://docs.perl6.org/language/variables#Sigilless_variables).

For information on variables without sigils, see [sigilless variables](https://docs.perl6.org/language/variables#Sigilless_variables).

## [单条目和列表赋值 (Item and List Assignment)](https://docs.perl6.org/language/variables#___top)

有两种类型的变量分配，单条目赋值和列表赋值。两者都用等于号作为操作符。等于号左边的语法决定了等于号是用作单条目还是列表赋值。

There are two types of variable assignment, *item assignment* and *list assignment*. Both use the equal sign `=` as operator. The syntax of the left-hand side determines whether an `=` means item or list assignment.

单条目赋值将右边的值放到左边的变量（容器）中。

Item assignment places the value from the right-hand side into the variable (container) on the left.

列表赋值将怎么做的选择权给了左边的变量。

List assignment leaves the choice of what to do to the variable on the left.

例如，[列表](https://docs.perl6.org/type/Array)变量（`@` 标记）在列表赋值时首先将自己清空然后接受右边所有的值。

For example, [Array](https://docs.perl6.org/type/Array) variables (`@` sigil) empty themselves on list assignment and then put all the values from the right-hand side into themselves.

赋值的类型（单条目或者列表）由当前表达式或声明语句的第一个上下文决定。

The type of assignment (item or list) is decided by the first context seen in the current expression or declarator:

```Perl6
my $foo = 5;            # item assignment 
say $foo.perl;          # OUTPUT: «5» 
 
my @bar = 7, 9;         # list assignment 
say @bar.^name;         # OUTPUT: «Array» 
say @bar.perl;          # OUTPUT: «[7, 9]» 
 
(my $baz) = 11, 13;     # list assignment 
say $baz.^name;         # OUTPUT: «List» 
say $baz.perl;          # OUTPUT: «$(11, 13)» 
```

列表赋值中的赋值行为依赖于包含它的表达式或者声明语句。

Thus, the behavior of an assignment contained within a list assignment depends on the expression or declarator that contains it.

例如，如果中间的赋值是声明语句，这时为单条目赋值，它比逗号和列表赋值有更高的优先级：

For instance, if the internal assignment is a declarator, item assignment is used, which has tighter precedence than both the comma and the list assignment:

```Perl6
my @array;
@array = my $num = 42, "str";   # item assignment: uses declarator 
say @array.perl;                # OUTPUT: «[42, "str"]» (an Array) 
say $num.perl;                  # OUTPUT: «42» (a Num) 
```

类似地，如果中间的的赋值是表达式，这个表达式用来初始化声明语句，赋值类型由中间表达式的上下文决定：

Similarly, if the internal assignment is an expression that is being used as an initializer for a declarator, the context of the internal expression determines the assignment type:

```Perl6
my $num;
my @array = $num = 42, "str";    # item assignment: uses expression 
say @array.perl;                 # OUTPUT: «[42, "str"]» (an Array) 
say $num.perl;                   # OUTPUT: «42» (a Num) 
 
my ( @foo, $bar );
@foo = ($bar) = 42, "str";       # list assignment: uses parentheses 
say @foo.perl;                   # OUTPUT: «[(42, "str"),]» (an Array) 
say $bar.perl;                   # OUTPUT: «$(42, "str")» (a List)# 
```

但是，如果中间的赋值既不是一个声明语句也不是一个表达式，而是更大的表达式中的一部分， 那个更大的表达式的上下文决定了赋值类型：

However, if the internal assignment is neither a declarator nor an expression, but is part of a larger expression, the context of the larger expression determines the assignment type:

```Perl6
my ( @array, $num );
@array = $num = 42, "str";    # list assignment 
say @array.perl;              # OUTPUT: «[42, "str"]» 
say $num.perl;                # OUTPUT: «42» 
```

赋值语句被解析为 `@array = (($num = 42), "str")`, 因为单条目赋值比逗号的优先级更高。

The assignment expression is parsed as `@array = (($num = 42), "str")`, because item assignment has tighter precedence than the comma.

更多关于优先级的细节见 [操作符](https://docs.perl6.org/language/operators) 。

See [operators](https://docs.perl6.org/language/operators) for more details on precedence.

## [无符号变量 (Sigilless variables) ](https://docs.perl6.org/language/variables#___top)

使用 \ 作为前缀，可以生成无标记的变量：

Using the `\` prefix, it's possible to create variables that do not have a sigil:

```Perl6
my \degrees = pi / 180;
my \θ       = 15 * degrees;
```

注意，无标记变量没有关联的[容器](https://docs.perl6.org/language/containers)。这意味着上面例子中的 `degrees` 和  `θ` 实际上表示的是 Num。尝试在定义变量后赋值可以详细说明这一点：

Note that sigilless variable do not have associated [containers](https://docs.perl6.org/language/containers). This means `degrees` and `θ`, above, actually directly represent `Num`s. To illustrate, try assigning to one after you've defined it:

```Perl6
θ = 3; # Dies with the error "Cannot modify an immutable Num" 
```

无标记变量不会施加上下文，所以他们能被用来按原样传递一些东西：

Sigilless variables do not enforce context, so they can be used to pass something on as-is:

```Perl6
sub logged(&f, |args) {
    say('Calling ' ~ &f.name ~ ' with arguments ' ~ args.perl);
    my \result = f(|args);
    #  ^^^^^^^ not enforcing any context here 
    say(&f.name ~ ' returned ' ~ result.perl);
    return |result;
}
```

无标记变量也能用作绑定。更多信息见 [绑定](https://docs.perl6.org/language/containers#Binding) 。

Sigilless variables can also be used for binding. See [Binding](https://docs.perl6.org/language/containers#Binding) for more information.

# [符号 (Twigils)](https://docs.perl6.org/language/variables#___top)

符号影响变量的作用域；但是他们对主标记符是否插值无影响。如果变量 `$a` 内插了， `$^a`, `$*a`, `$=a`, `$?a`, `$.a` 也可以，只取决于 `$`。

Twigils influence the scoping of a variable; however, they have no influence over whether the primary sigil interpolates. That is, if `$a`interpolates, so do `$^a`, `$*a`, `$=a`, `$?a`, `$.a`, etc. It only depends on the `$`.

| 符号   | 作用域                                    |
| ------ | ---------------------------------------- |
| none   | 作用域只依赖声明符                         |
| *      | 动态作用域                                |
| ?      | 编译时变量                                |
| !      | 属性 (类成员)                             |
| .      | 方法 (非真正意义上的变量)                  |
| <      | 正则匹配对象索引 (非真正意义上的变量)       |
| ^      | 自声明的正式的位置参数                     |
| :      | 自声明的正式的命名参数                     |
| =      | Pod 文档变量                              |
| ~      | 分歧器在当前词法点上可见的子语言            |

| Twigil | Scope                                    |
| ------ | ---------------------------------------- |
| none   | Based only on declarator                 |
| *      | Dynamic                                  |
| !      | Attribute (class member)                 |
| .      | Method (not really a variable)           |
| :      | Self-declared formal named parameter     |
| <      | Index into match object (not really a variable) |
| =      | Pod variables                            |
| ?      | Compile-time variable                    |
| ^      | Self-declared formal positional parameter |
| ~      | The sublanguage seen by the parser at this lexical spot |

## [`*` 号 ](https://docs.perl6.org/language/variables#___top)

动态变量使用这个符号，这种变量不在其所在的外部作用域查值，而是在调用者作用域查值的。

This twigil is used for dynamic variables which are looked up through the caller's, not through the outer, scope. Look at the example below.

注意：至今为止，如果你使用 rakudo perl6，下面的代码在 REPL 中无法运行。需要将代码拷贝粘贴至文件，然后运行这个文件。

*Note:* So far, if you use rakudo perl6, the example below cannot run correctly in the REPL. Please test it by copy-pasting it into a file, then run the file.

```Perl6
my $lexical   = 1;
my $*dynamic1 = 10;
my $*dynamic2 = 100;
 
sub say-all() {
    say "$lexical, $*dynamic1, $*dynamic2";
}
 
say-all();    # OUTPUT: 1, 10, 100 
 
{
    my $lexical   = 2;
    my $*dynamic1 = 11;
    $*dynamic2    = 101;
 
    say-all(); # OUTPUT: 1, 11, 101 
}
 
say-all();  # OUTPUT: 1, 10, 101 
```

第一次运行 `&say-all` 会打印出 “1， 10， 100”，没有意外。第二次运行却打印出 “1，11，101”。这是因为 `$lexical` 不是在调用者作用域查值而是在 `&say-all` 被定义时的作用域里查值。那两个动态变量是在调用者作用域里查值，因此值分别为 `11` 和 `101`。第三次运行 `&say-all` 时 `$*dynamic1` 的值不再是 `11`，但 `$*dynamic2` 仍然是 `101`。 这是因为我们在代码块声明了一个新的 `$*dynamic1` 变量而不是像 `$*dynamic2` 那样给旧变量赋值。

The first time `&say-all` is called, it prints "`1, 10, 100`" just as one would expect. The second time though, it prints "`1, 11, 101`". This is because `$lexical` isn't looked up in the caller's scope but in the scope `&say-all` was defined in. The two dynamic variables are looked up in the caller's scope and therefore have the values `11` and `101`. The third time `&say-all` is called `$*dynamic1` isn't `11`anymore, but `$*dynamic2` is still `101`. This stems from the fact that we declared a new dynamic variable `$*dynamic1` in the block and did not assign to the old variable as we did with `$*dynamic2`.

动态变量与其他变量不同之处在于，引用一个没有声明的动态变量不是一个编译时错误而是一个运行时错误。因此动态变量可以不用声明便使用，只要在使用前检查了是否定义或者在布尔上下文被用到：

The dynamic variables differ from other variable types in that referring to an undeclared dynamic variable is not a compile time error but a runtime [failure](https://docs.perl6.org/type/Failure), so a dynamic variable can be used undeclared as long as it's checked for definedness or used in a boolean context before using it for anything else:

```Perl6
sub foo() {
    $*FOO // 'foo';
}
 
say foo; # OUTPUT: «foo
» 
 
my $*FOO = 'bar';
 
say foo; # OUTPUT: «bar
» 
```

用 `my` 和 `our` 声明的动态变量分别有词法作用域和包作用域。动态解析以及通过 `our` 引入的借助符号表的解析是两个正交问题。

## [`?` 号](https://docs.perl6.org/language/variables#___top)

编译时变量使用 `?` 号。编译器知道他们并且编译时不能修改。一个常见的例子是：

Compile-time variables may be addressed via the `?` twigil. They are known to the compiler and may not be modified after being compiled in. A popular example for this is:

```Perl6
say "$?FILE: $?LINE"; # OUTPUT: "hello.pl: 23" 
                      # if this is the line 23 of a 
                      # file named "hello.pl" 
```

For a list of these special variables, see [compile-time variables](https://docs.perl6.org/language/variables#Compile-time_variables).

## [`!` 号](https://docs.perl6.org/language/variables#___top)

属性是存在于类实例中的变量。他们可以在类中通过 `!` 号被直接访问：

[Attributes](https://docs.perl6.org/language/objects#Attributes) are variables that exist per instance of a class. They may be directly accessed from within the class via `!`:

```Perl6
my class Point {
    has $.x;
    has $.y;
 
    method Str() {
        "($!x, $!y)"
    }
}
```

注意属性是如何通过 `$.x` 和 `$xy` 声明却通过 `$!x` 和 `$!y` 来访问的。这是因为 Perl 6 中所有的属性都是私有的而且可以在类中通过 `$!attribute-name` 直接访问。Perl 6 会直接为你生成访问器方法。更多关于对象，类和他们的属性的信息见 [object orientation](https://docs.perl6.org/language/objects) 。

Note how the attributes are declared as `$.x` and `$.y` but are still accessed via `$!x` and `$!y`. This is because in Perl 6 all attributes are private and can be directly accessed within the class by using `$!attribute-name`. Perl 6 may automatically generate accessor methods for you though. For more details on objects, classes and their attributes see [object orientation](https://docs.perl6.org/language/objects).

## [`.` 号](https://docs.perl6.org/language/variables#___top)

`.` 号不是给变量用的，事实上，下面代码

The `.` twigil isn't really for variables at all. In fact, something along the lines of

```Perl6
my class Point {
    has $.x;
    has $.y;
 
    method Str() {
        "($.x, $.y)" # note that we use the . instead of ! this time 
    }
}
```

对 `self` 调用了方法 `x` 和 `y` ，这些是自动为你生成的，因为你使用 `.` 声明属性。但是子类可能覆盖这些方法，如果你不想看到这种情况发生，使用 `$!x` 和 `$!y` 。

just calls the methods `x` and `y` on `self`, which are automatically generated for you because you used the `.` twigil when the attributes were declared. Note, however, that subclasses may override those methods. If you don't want this to happen, use `$!x` and `$!y` instead.

`.` 号调用了方法的事实以为下面的操作也是可能的：

The fact that the `.` twigil does a method call implies that the following is also possible:

```Perl6
class SaySomething {
    method a() { say "a"; }
    method b() { $.a; }
}
 
SaySomething.b; # OUTPUT: «a
» 
```

更多关于对象，类和他们的属性的信息见 [object orientation](https://docs.perl6.org/language/objects) 。

For more details on objects, classes and their attributes and methods see [object orientation](https://docs.perl6.org/language/objects).

## [`^` 号 ](https://docs.perl6.org/language/variables#___top)

^ 号为代码块或者函数声明正式的位置参数。`$^variable` 形式的变量是占位符变量。他们可以用在裸代码块中来声明代码块的正式参数。因此下面代码中的代码块

The `^` twigil declares a formal positional parameter to blocks or subroutines. Variables of the form `$^variable` are a type of placeholder variable. They may be used in bare blocks to declare formal parameters to that block. So the block in the code

```Perl6
my @powers-of-three = 1,3,9…100;
say reduce { $^b - $^a }, 0, |@powers-of-three;
# OUTPUT: «61
» 
```

有两个正式参数 `$a` 和 `$b`。 注意，尽管 `$^b` 在 `$^a` 之前，`$^a` 人就是代码块中的第一个正式参数。这是因为占位符变量是按 Unicode 顺序排序的。如果你有用 `$^a` 自声明变量，之后你可以用 `$a` 引用它。

has two formal parameters, namely `$a` and `$b`. Note that even though `$^b` appears before `$^a` in the code, `$^a` is still the first formal parameter to that block. This is because the placeholder variables are sorted in Unicode order. If you have self-declared a parameter using `$^a` once, you may refer to it using only `$a` thereafter.

尽管用任意合法的标记符作为占位符变量是可以的，还是建议使用短名或者按照正常顺序轻松理解的名称，以免给读者带来不必要的惊喜。

Although it is possible to use nearly any valid identifier as a placeholder variable, it is recommended to use short names or ones that can be trivially understood in the correct order, to avoid surprise on behalf of the reader.

普通块和子例程也可以使用占位符变量，但前提是它们没有明确的参数列表。

Normal blocks and subroutines may also make use of placeholder variables but only if they do not have an explicit parameter list.

```
sub say-it    { say $^a; } # valid 
sub say-it()  { say $^a; } # invalid 
              { say $^a; } # valid 
-> $x, $y, $x { say $^a; } # invalid 
```

占位符变量不能有类型约束或者变量名称带有单个大写字母（这个不被允许，以免 Perl5 氛围太明显）。

Placeholder variables cannot have type constraints or a variable name with a single upper-case letter (this is disallowed to enable catching some Perl5-isms).

## [`:` 号 ](https://docs.perl6.org/language/variables#___top)

`:` 号为块或子例程声明一个正式的命名参数。以这种形式声明的变量也是一种占位符变量。

使用此表单声明的变量也是一种占位符变量。因此，与应用于使用^ twigil声明的变量相同的东西也适用于此（除了它们不是位置的，因此不用Unicode顺序排序）。如：

The `:` twigil declares a formal named parameter to a block or subroutine. Variables declared using this form are a type of placeholder variable too. Therefore the same things that apply to variables declared using the `^` twigil also apply here (with the exception that they are not positional and therefore not ordered using Unicode order, of course). So this:

```Perl6
say { $:add ?? $^a + $^b !! $^a - $^b }( 4, 5 ) :!add
# OUTPUT: «-1
» 
```

更多占位符变量细节见 [^](https://docs.perl6.org/routine/$CIRCUMFLEX_ACCENT) 。

See [^](https://docs.perl6.org/routine/$CIRCUMFLEX_ACCENT) for more details about placeholder variables.

## [`=` 号 ](https://docs.perl6.org/language/variables#___top)

= 号用于访问 Pod 变量。当前文件中的每个 Pod 块可以通过 Pod 对象访问，例如 `$=data`，`$=SYNOPSIS` 或 `=UserBlock`。即：变量有着跟 Pod 块相同的名字以及一个 `=` 号。

即：所需块和a = twigil具有相同名称的变量。

The `=` twigil is used to access Pod variables. Every Pod block in the current file can be accessed via a Pod object, such as `$=data`, `$=SYNOPSIS` or `=UserBlock`. That is: a variable with the same name of the desired block and a `=` twigil.

```Perl6
  =begin code
  =begin Foo
  ...
  =end Foo
 
  #after that, $=Foo gives you all Foo-Pod-blocks
  =end code
```

您可以通过 `$=pod` 访问包含所有 Pod 结构的 Pod 树作为分层数据结构

You may access the Pod tree which contains all Pod structures as a hierarchical data structure through `$=pod`.

注意所有的 `$=someBlockName` 支持位置以及关联角色。

Note that all those `$=someBlockName` support the `Positional` and the `Associative` roles.

## [`~` 号 ](https://docs.perl6.org/language/variables#___top)

~ 号是用来引用子语言（也叫 slangs ）。以下是有用的：

The `~` twigil is for referring to sublanguages (called slangs). The following are useful:

| $~MAIN    | the current main language (e.g. Perl statements) |
| --------- | ---------------------------------------- |
| $~Quote   | the current root of quoting language     |
| $~Quasi   | the current root of quasiquoting language |
| $~Regex   | the current root of regex language       |
| $~Trans   | the current root of transliteration language |
| $~P5Regex | the current root of the Perl 5 regex language |

你可以在当前的词汇范围内扩充这些语言。

You `augment` these languages in your current lexical scope.

```Perl6
use MONKEY-TYPING;
augment slang Regex {  # derive from $~Regex and then modify $~Regex 
    token backslash:std<\Y> { YY };
}
```

# [变量声明符和作用域](https://docs.perl6.org/language/variables#___top)

大多数时候使用 `my` 关键字创建新变量就足够了：

Most of the time it's enough to create a new variable using the `my` keyword:

```Perl6
my $amazing-variable = "World";
say "Hello $amazing-variable!"; # OUTPUT: «Hello World!
» 
```

但是，有许多声明符可以改变作用域的一些细节，这超越了符号所能做的。

However, there are many declarators that change the details of scoping beyond what [Twigils](https://docs.perl6.org/language/variables#Twigils) can do.

| Declarator | Effect                                   |
| ---------- | ---------------------------------------- |
| my         | Introduces lexically scoped names        |
| our        | Introduces package-scoped names          |
| has        | Introduces attribute names               |
| anon       | Introduces names that are private to the construct |
| state      | Introduces lexically scoped but persistent names |
| augment    | Adds definitions to an existing name     |
| supersede  | Replaces definitions of an existing name |

还有两个类似于声明符的前缀对预定义的变量起作用。

There are also two prefixes that resemble declarators but act on predefined variables:

| Prefix | Effect                                   |
| ------ | ---------------------------------------- |
| temp   | Restores a variable's value at the end of scope / 在作用域结束时恢复变量的值。 |
| let    | Restores a variable's value at the end of scope if the block exits unsuccessfully / 如果代码块退出不成功，在作用域结束时恢复变量的值。 |

## [`my` 声明符](https://docs.perl6.org/language/variables#___top)

使用 `my` 声明变量赋予了变量词法作用域。这意味着它只存在于当前块中。例如：

Declaring a variable with `my` gives it lexical scope. This means it only exists within the current block. For example:

```Perl6
{
    my $foo = "bar";
    say $foo; # OUTPUT: «"bar"
» 
}
say $foo; # Exception! "Variable '$foo' is not declared" 
```

这断代码会报错退出，因为 `$foo` 只有在相同作用域时才是被定义了的。

This dies because `$foo` is only defined as long as we are in the same scope.

另外，词法作用域意味着变量可以在新的作用域内被临时重新定义。

Additionally, lexical scoping means that variables can be temporarily redefined in a new scope:

```Perl6
my $location = "outside";
 
sub outer-location {
    # Not redefined: 
    say $location;
}
 
outer-location; # OUTPUT: «outside
» 
 
sub in-building {
    my $location = "inside";
    say $location;
}
 
in-building;    # OUTPUT: «inside
» 
 
outer-location; # OUTPUT: «outside
» 
```

如果一个变量被重新定义，任何引用外部变量的代码依旧引用外部变量。因此这里，`&outer-location` 仍旧打印的是外部的 `$location` 的值：

If a variable has been redefined, any code that referenced the outer variable will continue to reference the outer variable. So here, `&outer-location` still prints the outer `$location`:

```Perl6
sub new-location {
    my $location = "nowhere";
    outer-location;
}
 
new-location; # OUTPUT: «outside
» 
```

要使 `new-location()` 打印出 `nowhere`，使用 [* 号](https://docs.perl6.org/language/variables#The_%2A_Twigil) 使 `$location` 成为一个动态变量。这个符号让编译器在调用者的作用域查找变量符号，而不是查完本地作用域后查外部作用域。

To make `new-location()` print `nowhere`, make `$location` a dynamic variable using [the * twigil](https://docs.perl6.org/language/variables#The_%2A_Twigil). This twigil makes the compiler look up the symbol in the calling scope instead of the outer scope after trying the local scope.

`my` 是子例程的默认作用域，因此 `my sub x() {}` 和 `sub x() {}` 是完全一样的。

`my` is the default scope for subroutines, so `my sub x() {}` and `sub x() {}` do exactly the same thing.

## [`our` 声明符](https://docs.perl6.org/language/variables#___top)

`our` 声明的变量像 `my` 声明的变量一样工作，除了额外给符号表插入了一个别名。

`our` variables work just like `my` variables, except that they also introduce an alias into the symbol table.

```Perl6
module M {
    our $Var;
    # $Var available here 
}
 
# Available as $M::Var here. 
```

## [声明一组变量](https://docs.perl6.org/language/variables#___top)

`my` 和 `our` 声明符接受一组括起来的变量作为参数来一次声明多个变量。

The declarators `my` and `our` take a list of variables in parentheses as argument to declare more than one variable at a time.

```Perl6
my (@a, $s, %h);
```

这可以与解构赋值一起使用。对这样一个列表的任何赋值都将采用左列表中提供的元素数量，并从右列表中为它们分配相应的值。根据变量的类型，任何遗漏的元素都会导致未定义的值。

This can be used in conjunction with [destructuring assignment](undefined). Any assignment to such a list will take the number of elements provided in the left list and assign corresponding values from the right list to them. Any missing elements are left will result in undefined values according to the type of the variables.

```Perl6
my (Str $a, Str $b, Int $c) = <a b>;
say [$a, $b, $c].perl;
# OUTPUT: «["a", "b", Int]
» 
```

要将列表拆分为单个值，请使用 `($var,)` 创建包含一个元素的列表文字。与变量声明符一起使用时，将单个变量用括号括起来就足够了。

To destructure a list into a single value, create a list literal with one element by using `($var,)`. When used with a variable declarator, providing parentheses around a single variable is sufficient.

```Perl6
sub f { 1,2,3 };
my ($a) = f;
say $a.perl;
# OUTPUT: «1
» 
```

要跳过列表中的元素，请使用匿名状态变量 `$`。

To skip elements in the list use the anonymous state variable `$`.

```Perl6
my ($,$a,$,%h) = ('a', 'b', [1,2,3], {:1th});
say [$a, %h].perl;
# OUTPUT: «["b", {:th(1)}]
» 
```

## [`has` 声明符](https://docs.perl6.org/language/variables#___top)

`has` 将属性作用于类实例或者角色，以及类或角色的方法。`has` 暗示了方法，因此 `has method x() {}` 与 `mehod x() {}` 等价。

`has` scopes attributes to instances of a class or role, and methods to classes or roles. `has` is implied for methods, so `has method x() {}` and `method x() {}` do the same thing.

See [object orientation](https://docs.perl6.org/language/objects) for more documentation and some examples.

## [`anon` 声明符](https://docs.perl6.org/language/variables#___top)

`anon` 声明符可防止在词法作用域，方法表和其他任何地方安装符号。

The `anon` declarator prevents a symbol from getting installed in the lexical scope, the method table and everywhere else.

例如，你可以使用它来声明知道其自己名称的子例程，但仍未安装在作用域中：

For example, you can use it to declare subroutines which know their own name, but still aren't installed in a scope:

```Perl6
my %operations =
    half   => anon sub half($x) { $x / 2 },
    square => anon sub square($x) { $x * $x },
    ;
say %operations<square>.name;       # square 
say %operations<square>(8);         # 64 
```

## [`state` 声明符](https://docs.perl6.org/language/variables#___top)

跟 `my` 类似，`state` 声明词法作用域变量。但是，初始化在正常执行流程中首次遇到初始化时发生。因此，state 变量将在封闭块或例程的多次执行中保持其值。

`state` declares lexically scoped variables, just like `my`. However, initialization happens exactly once the first time the initialization is encountered in the normal flow of execution. Thus, state variables will retain their value across multiple executions of the enclosing block or routine.

因此，子例程

Therefore, the subroutine

```Perl6
sub a {
    state @x;
    state $l = 'A';
    @x.push($l++);
};
 
say a for 1..6;
```

会持续增加 `$l` 的值，并在每次调用时将它追加到 `@x`。所以它会输出：

will continue to increment `$l` and append it to `@x` each time it is called. So it will output:

```Perl6
[A]
[A B]
[A B C]
[A B C D]
[A B C D E]
[A B C D E F]
 
```

这适用于包含代码对象的每个“克隆”，如下例所示：

This works per "clone" of the containing code object, as in this example:

```Perl6
({ state $i = 1; $i++.say; } xx 3).map: {$_(), $_()}; # says 1 then 2 thrice 
```

请注意，当多个线程运行同一个块的相同克隆时，这不是线程安全的构造。还要记住，方法在每个类中只有一个克隆，而不是在每个对象中。

Note that this is **not** a thread-safe construct when the same clone of the same block is run by multiple threads. Also remember that methods only have one clone per class, not per object.

和 `my` 一样，声明多个 `state` 变量必须放在圆括号中。声明单个变量时，括号可以省略。

As with `my`, declaring multiple `state` variables must be placed in parentheses and for declaring a single variable, parentheses may be omitted.

许多操作符都带有隐式绑定，可能会导致其他地方的操作。

Many operators come with implicit binding which can lead to actions at a distance.

使用 `.clone` 或强制来创建一个可绑定的新容器。

Use `.clone` or coercion to create a new container that can be bound to.

```Perl6
my @a;
my @a-cloned;
sub f() {
    state $i;
    $i++;
    @a\      .push: "k$i" => $i;
    @a-cloned.push: "k$i" => $i.clone;
};
 
f for 1..3;
say @a;        # OUTPUT: «[k1 => 3 k2 => 3 k3 => 3]
» 
say @a-cloned; # OUTPUT: «[k1 => 1 k2 => 2 k3 => 3]
» 
```

State variables are shared between all threads. The result can be unexpected.

```Perl6
sub code(){ state $i = 0; say ++$i; $i };
await
    start { loop { last if code() >= 5 } },
    start { loop { last if code() >= 5 } };
 
# OUTPUT: «1
2
3
4
4
3
5
» 
# OUTPUT: «2
1
3
4
5
» 
# many other more or less odd variations can be produced 
```

### [$ 变量 ](https://docs.perl6.org/language/variables#___top)

除了显式声明的命名状态变量外，`$` 可以用作匿名 `state` 变量而不需要明确的 `state` 声明。

In addition to explicitly declared named state variables, `$` can be used as an anonymous state variable without an explicit `state` declaration.

```Perl6
say "1-a 2-b 3-c".subst(:g, /\d/, {<one two three>[$++]});
# OUTPUT: «one-a two-b three-c
» 
```

此外，状态变量可以在子程序之外使用。例如，你可以在一行中使用 `$` 来对文件中的行进行编号。

Furthermore, state variables can be used outside of subroutines. You could, for example, use `$` in a one-liner to number the lines in a file.

```Perl6
perl6 -ne 'say ++$ ~ " $_"' example.txt
```

在词法范围内对 `$` 的每个引用实际上是一个单独的变量。

Each reference to `$` within a lexical scope is in effect a separate variable.

```Perl6
perl6 -e '{ say ++$; say $++  } for ^5'
# OUTPUT: «1
0
2
1
3
2
4
3
5
4
» 
```

如果你需要在一个作用域中多次使用 `$` 的值，它应该被复制到一个新的变量中。

If you need to use the value of $ more than once in a scope, it should be copied to a new variable.

```Perl6
sub foo() {
    given ++$ {
        when 1 {
            say "one";
        }
        when 2 {
            say "two";
        }
        when 3 {
            say "three";
        }
        default {
            say "many";
        }
    }
}
 
foo() for ^3;
# OUTPUT: «one
two
three
» 
```

请注意，隐式 `state` 声明器仅适用于变量本身，而不适用于可能包含初始化程序的表达式。如果初始化器只能被调用一次，则必须提供 `state` 声明器。

Note that the implicit state declarator is only applied to the variable itself, not the expression that may contain an initializer. If the initializer has to be called exactly once, the `state` declarator has to be provided.

```Perl6
subset DynInt where $ = ::('Int'); # the initializer will be called for each type check 
subset DynInt where state $ = ::('Int'); # the initializer is called once, this is a proper cache 
```

### [`@` 变量](https://docs.perl6.org/language/variables#___top)

类似于 `$` 变量，还有一个位置匿名 `state` 变量 `@` 。

Similar to the `$` variable, there is also a [Positional](https://docs.perl6.org/type/Positional) anonymous state variable `@`.

```Perl6
sub foo($x) {
    say (@).push($x);
}
 
foo($_) for ^3;
 
# OUTPUT: «[0] 
#          [0 1] 
#          [0 1 2]
» 
```

`@` 在这里加括号是为了从名为 `@.push` 的类成员变量中消除表达式的歧义。索引访问不需要这种歧义消除，但你需要复制该值以执行任何有用的操作。

The `@` here is parenthesized in order to disambiguate the expression from a class member variable named `@.push`. Indexed access doesn't require this disambiguation but you will need to copy the value in order to do anything useful with it.

```Perl6
sub foo($x) {
    my $v = @;
    $v[$x] = $x;
    say $v;
}
 
foo($_) for ^3;
 
# OUTPUT: «[0] 
#          [0 1] 
#          [0 1 2]
» 
```

与 `$` 一样，范围中的每个 `@` 都会引入一个新的匿名数组。

As with `$`, each mention of `@` in a scope introduces a new anonymous array.

### [`%` 变量](https://docs.perl6.org/language/variables#___top)

另外，还有一个关联匿名状态变量 `％`。

In addition, there's an [Associative](https://docs.perl6.org/type/Associative) anonymous state variable `%`.

```Perl6
sub foo($x) {
    say (%).push($x => $x);
}
 
foo($_) for ^3;
 
# OUTPUT: «{0 => 0} 
#          {0 => 0, 1 => 1} 
#          {0 => 0, 1 => 1, 2 => 2}
» 
```

关于消歧的警告同样适用。正如你所期望的那样，索引访问也是可能的（通过复制使其有用）。

The same caveat about disambiguation applies. As you may expect, indexed access is also possible (with copying to make it useful).

```Perl6
sub foo($x) {
    my $v = %;
    $v{$x} = $x;
    say $v;
}
 
foo($_) for ^3;
 
# OUTPUT: «{0 => 0} 
#          {0 => 0, 1 => 1} 
#          {0 => 0, 1 => 1, 2 => 2}
» 
```

与其他匿名状态变量一样，每个`given` 范围内的 `％` 都将有效地引入一个单独的变量。

As with the other anonymous state variables, each mention of `%` within a given scope will effectively introduce a separate variable.

## [`augment` 声明符](https://docs.perl6.org/language/variables#___top)

通过  `augment`，你可以将属性和方法添加到现有的类和语法，只要您先激活 `MONKEY-TYPING` 指令即可。

With `augment`, you can add attributes and methods to existing classes and grammars, provided you activated the `MONKEY-TYPING`pragma first.

由于类通常是 `our` 作用域，因此是全局的，这意味着修改全局状态，这是强烈不鼓励的。几乎所有的情况都有更好的解决方案。

Since classes are usually `our` scoped, and thus global, this means modifying global state, which is strongly discouraged. For almost all situations, there are better solutions.

```Perl6
# don't do this 
use MONKEY-TYPING;
augment class Int {
    method is-answer { self == 42 }
}
say 42.is-answer;       # OUTPUT: «True
» 
```

（在这个情况下，更好的解决方案是使用 [function](https://docs.perl6.org/language/functions)）。

(In this case, the better solution would be to use a [function](https://docs.perl6.org/language/functions)).

## [`temp` 前缀](https://docs.perl6.org/language/variables#___top)

像 `my` 一样，`temp` 会在其范围的末尾恢复变量的旧值。但是，`temp` 不会创建新变量。

Like `my`, `temp` restores the old value of a variable at the end of its scope. However, `temp` does not create a new variable.

```Perl6
my $in = 0; # temp will "entangle" the global variable with the call stack 
            # that keeps the calls at the bottom in order. 
sub f(*@c) {
    (temp $in)++;
     "<f>\n"
     ~ @c».indent($in).join("\n")
     ~ (+@c ?? "\n" !! "")
     ~ '</f>'
};
sub g(*@c) {
    (temp $in)++;
    "<g>\n"
    ~ @c».indent($in).join("\n")
    ~ (+@c ?? "\n" !! "")
    ~ "</g>"
};
print g(g(f(g()), g(), f()));
 
# OUTPUT: «<g> 
#           <g> 
#            <f> 
#             <g> 
#             </g> 
#            </f> 
#            <g> 
#            </g> 
#            <f> 
#            </f> 
#           </g> 
#          </g>
» 
```

## [`let` 前缀](https://docs.perl6.org/language/variables#___top)

如果该块以失败退出，则恢复先前的值。成功退出意味着块返回了定义的值或列表。

Restores the previous value if the block exits unsuccessfully. A successful exit means the block returned a defined value or a list.

```Perl6
my $answer = 42;
 
{
    let $answer = 84;
    die if not Bool.pick;
    CATCH {
        default { say "it's been reset :(" }
    }
    say "we made it 84 sticks!";
}
 
say $answer;
```

在上面的例子中，如果 `Bool.pick` 返回真值，那么答案将保持为 84，因为该块返回一个定义的值（ `say` 返回真）。否则，`die` 语句将导致该块退出失败，并将答案重置为42。

In the above case, if the `Bool.pick` returns true, the answer will stay as 84 because the block returns a defined value (`say` returns true). Otherwise the `die` statement will cause the block to exit unsuccessfully, resetting the answer to 42.

# [Type Constraints and Initialization](https://docs.perl6.org/language/variables#___top)

Variables have a type constraint via the [container](https://docs.perl6.org/language/containers) they are bound to, which goes between the declarator and the variable name. The default type constraint is [Mu](https://docs.perl6.org/type/Mu). You can also use the trait [of](https://docs.perl6.org/type/Variable#trait_of) to set a type constraint.

```
my Int $x = 42;
$x = 'a string';
CATCH { default { put .^name, ': ', .Str } }
# OUTPUT: «X::TypeCheck::Assignment: Type check failed in assignment to $x; expected Int but got Str ("a string")
» 
```

If a scalar variable has a type constraint but no initial value, it's initialized with the type object of the default value of the container it's bound to.

```
my Int $x;
say $x.^name;       # OUTPUT: «Int
» 
say $x.defined;     # OUTPUT: «False
» 
```

Scalar variables without an explicit type constraint are typed as [Mu](https://docs.perl6.org/type/Mu) but default to the [Any](https://docs.perl6.org/type/Any) type object.

Variables with the `@` sigil are initialized with an empty [Array](https://docs.perl6.org/type/Array); variables with the `%` sigil are initialized with an empty [Hash](https://docs.perl6.org/type/Hash).

The default value of a variable can be set with the `is default` trait, and re-applied by assigning `Nil` to it:

```
my Real $product is default(1);
say $product;                       # OUTPUT: «1
» 
$product *= 5;
say $product;                       # OUTPUT: «5
» 
$product = Nil;
say $product;                       # OUTPUT: «1
» 
```

## [Default Defined Variables Pragma](https://docs.perl6.org/language/variables#___top)

To force all variables to have a definedness constraint, use the pragma `use variables :D`. The pragma is lexically scoped and can be switched off with `use variables :_`.

```
use variables :D;
my Int $i;
# OUTPUT: «===SORRY!=== Error while compiling <tmp>
Variable definition of type Int:D (implicit :D by pragma) requires an initializer ... 
my Int $i = 1; # that works 
{ use variables :_; my Int $i; } # switch it off in this block 
```

Note that assigning [Nil](https://docs.perl6.org/type/Nil) will revert the variable to its default value. The default value of a defined constraint type is the type appended with `:D` (e.g. `Int:D`). That means a definedness constraint is no guarantee of definedness. This only applies to variable initializers, not to [Signature](https://docs.perl6.org/type/Signature)s. or subsequent assignments to a variable.

# [Special Variables](https://docs.perl6.org/language/variables#___top)

Perl 6 attempts to use long, descriptive names for special variables. There are only three special variables that are extra short.

## [Pre-defined lexical variables](https://docs.perl6.org/language/variables#___top)

There are three special variables that are available in every block:

| Variable | Meaning        |
| -------- | -------------- |
| $_       | topic variable |
| $/       | regex match    |
| $!       | exceptions     |

### [The `$_` Variable](https://docs.perl6.org/language/variables#___top)

`$_` is the topic variable. It's the default parameter for blocks that do not have an explicit signature, so constructs like `for @array { ... }` and `given $var { ... }` bind to `$_` by invoking the block.

```
for <a b c> { say $_ }  # sets $_ to 'a', 'b' and 'c' in turn 
say $_ for <a b c>;     # same, even though it's not a block 
given 'a'   { say $_ }  # sets $_ to 'a' 
say $_ given 'a';       # same, even though it's not a block 
```

`CATCH` blocks set `$_` to the exception that was caught. The `~~` smart-match operator sets `$_` on the right-hand side expression to the value of the left-hand side.

Calling a method on `$_` can be shortened by leaving off the variable name:

```
.say;                   # same as $_.say 
```

`m/regex/` and `/regex/` regex matches and `s/regex/subst/` substitutions work on `$_`:

```
say "Looking for strings with non-alphabetic characters...";
for <ab:c d$e fgh ij*> {
    .say if m/<-alpha>/;
}
 
# OUTPUT: «Looking for strings with non-alphabetic characters... 
#          ab:c 
#          d$e 
#          ij*
» 
```

### [The `$/` Variable](https://docs.perl6.org/language/variables#___top)

`$/` is the match variable. It stores the result of the last [Regex](https://docs.perl6.org/language/regexes) match and so usually contains objects of type [Match](https://docs.perl6.org/type/Match).

```
'abc 12' ~~ /\w+/;  # sets $/ to a Match object 
say $/.Str;         # OUTPUT: «abc
» 
```

The `Grammar.parse` method also sets the caller's `$/` to the resulting [Match](https://docs.perl6.org/type/Match) object. For the following code:

```
use XML::Grammar; # zef install XML 
XML::Grammar.parse("<p>some text</p>");
say $/;
 
# OUTPUT: «｢<p>some text</p>｣ 
#           root => ｢<p>some text</p>｣ 
#            name => ｢p｣ 
#            child => ｢some text｣ 
#             text => ｢some text｣ 
#             textnode => ｢some text｣ 
#           element => ｢<p>some text</p>｣ 
#            name => ｢p｣ 
#            child => ｢some text｣ 
#             text => ｢some text｣ 
#             textnode => ｢some text｣
» 
```

#### [Positional Attributes](undefined)

`$/` can have positional attributes if the [Regex](https://docs.perl6.org/language/regexes) had capture-groups in it, which are just formed with parentheses.

```
'abbbbbcdddddeffg' ~~ / a (b+) c (d+ef+) g /;
say $/[0]; # OUTPUT: «｢bbbbb｣
» 
say $/[1]; # OUTPUT: «｢dddddeff｣
» 
```

These can also be accessed by the shortcuts `$0`, `$1`, `$2`, etc.

```
say $0; # OUTPUT: «｢bbbbb｣
» 
say $1; # OUTPUT: «｢dddddeff｣
» 
```

To get all of the positional attributes, any of `$/.list`, `@$/`, or `@()` can be used.

```
say @().join; # OUTPUT: «bbbbbdddddeff
» 
```

#### [Named Attributes](undefined)

`$/` can have named attributes if the [Regex](https://docs.perl6.org/language/regexes) had named capture-groups in it, or if the Regex called out to another Regex.

```
'I.... see?' ~~ / \w+ $<punctuation>=[ <-[\w\s]>+ ] \s* $<final-word> = [ \w+ . ] /;
say $/<punctuation>; # OUTPUT: «｢....｣
» 
say $/<final-word>;  # OUTPUT: «｢see?｣
» 
```

These can also be accessed by the shortcut `$`.

```
say $<punctuation>; # OUTPUT: «｢....｣
» 
say $<final-word>;  # OUTPUT: «｢see?｣
» 
```

To get all of the named attributes, any of `$/.hash`, `%$/`, or `%()` can be used.

```
say %().join;       # OUTPUT: «"punctuation     ....final-word  see?"
» 
```

### [The `$!` Variable](https://docs.perl6.org/language/variables#___top)

`$!` is the error variable. If a `try` block or statement prefix catches an exception, that exception is stored in `$!`. If no exception was caught, `$!` is set to the `Any` type object.

Note that `CATCH` blocks *do not* set `$!`. Rather they set `$_` inside the block to the caught exception.

## [Compile-time variables](https://docs.perl6.org/language/variables#___top)

All compile time variables have a question mark as part of the twigil. Being *compile time* they cannot be changed at run-time, however they are valuable in order to introspect the program. The most common compile time variables are the following:

| $?FILE      | Which file am I in?                      |
| ----------- | ---------------------------------------- |
| $?LINE      | Which line am I at?                      |
| ::?CLASS    | Which class am I in?                     |
| %?LANG      | What is the current set of interwoven languages? |
| %?RESOURCES | The files associated with the "Distribution" of the current compilation unit. |

### [Other compile-time variables:](https://docs.perl6.org/language/variables#___top)

The following compile time variables allow for a deeper introspection:

| $?PACKAGE | Which package am I in?                   |
| --------- | ---------------------------------------- |
| $?MODULE  | Which module am I in?                    |
| $?CLASS   | Which class am I in? (as variable)       |
| $?ROLE    | Which role am I in? (as variable)        |
| $?GRAMMAR | Which grammar am I in?                   |
| $?TABSTOP | How many spaces is a tab in a heredoc or virtual margin? |
| $?NL      | What a vertical newline "\n" means: LF, CR or CRLF |
| $?ENC     | Default encoding of various IO methods, e.g., Str.encode, Buf.decode |

With particular regard to the `$?NL`, see the [newline pragma](https://docs.perl6.org/language/pragmas).

### [&?ROUTINE](undefined)

The compile time variable `&?ROUTINE` provides introspection about which routine the program is actually within. It returns an instance of [Sub](https://docs.perl6.org/type/Sub) attached to the current routine. It does support the method `.name` to obtain the name of the called routine, as well as `.signature`and others method related to `Sub`:

```
sub awesome-sub { say &?ROUTINE.name }
awesome-sub # OUTPUT: awesome-sub 
```

The special variable `&?ROUTINE` allows also for recursion:

```
my $counter = 10;
sub do-work {
    say 'Calling myself other ' ~ $counter-- ~ ' times';
    &?ROUTINE() if ( $counter > 0 );
}
do-work;
```

### [&?BLOCK](undefined)

The special compile variable `?&BLOCK` behaves similarly to `?&ROUTINE` but it allows to introspect a single block of code. It holds a [Sub](https://docs.perl6.org/type/Sub)and allows for recursion within the same block:

```
for '.' {
    .Str.say when !.IO.d;
    .IO.dir()».&?BLOCK when .IO.d # lets recurse a little! 
}
```

## [Dynamic variables](https://docs.perl6.org/language/variables#___top)

| $*ARGFILES        | An L<IO::ArgFiles> (an empty subclass of L<IO::CatHandle>) that uses C<@*ARGS> as source files, if it contains any files, or C<$*IN> otherwise. When C<$*IN> is used, its C<:nl-in>, C<:chomp>, C<:encoding>, and C<:bin> will be set on the L<IO::ArgFiles> object. |
| ----------------- | ---------------------------------------- |
| @*ARGS            | Arguments from the command line.         |
| $*IN              | Standard input filehandle, AKA stdin     |
| $*OUT             | Standard output filehandle, AKA stdout   |
| $*ERR             | Standard error filehandle, AKA stderr    |
| %*ENV             | Environment variables                    |
| $*REPO            | A variable holding information about modules installed/loaded |
| $*INIT-INSTANT    | An Instant object representing program startup time. In particular, this is when the core code starts up, so the value of $*INIT-INSTANT may be a few milliseconds earlier than C<INIT now> or even C<BEGIN now> executed in your program. |
| $*TZ              | The system's local timezone offset, as the number of B<seconds> from GMT |
| $*CWD             | The Current Working Directory.           |
| $*KERNEL          | Which kernel am I running under?         |
| $*DISTRO          | Which OS distribution am I running under? (e.g. C<say "Some sort of Windows" if $*DISTRO.is-win>) |
| $*VM              | Which virtual machine am I running under? |
| $*PERL            | Which Perl am I running under?           |
| $*PID             | Process ID of the current process.       |
| $*PROGRAM-NAME    | Path to the current executable as it was entered on the command line, or C<-e> if perl was invoked with the -e flag. |
| $*PROGRAM         | Location (in the form of an C<IO::Path> object) of the Perl program being executed. |
| &*EXIT            | Code that will be executed when doing an exit(). Intended to be used in situations where Perl 6 is embedded in another language runtime (such as Inline::Perl6 in Perl 5) |
| $*EXECUTABLE      | Absolute path of the perl executable that is currently running. |
| $*EXECUTABLE-NAME | The name of the perl executable that is currently running. (e.g. perl6-p, perl6-m, Niecza.exe) Favor $*EXECUTABLE because it's not guaranteed that the perl executable is in PATH. |
| $*USAGE           | Read-only. The default usage message generated from the signatures of MAIN subs available from inside sub MAIN and sub USAGE |
| $*USER            | The user that is running the program. It's an object that evaluates to "username (uid)". It will evaluate to the username only if treated as a string and the numeric user id if treated as a number. |
| $*GROUP           | The primary group of the user who is running the program. It's an object that evaluates to "groupname (gid)". It will evaluate to the groupname only if treated as a string and the numeric group id if treated as a number. |
| $*HOME            | An L<IO::Path> object representing the "home directory" of the user that is running the program. Uses C«%*ENV<HOME>» if set. On Windows, uses C«%*ENV<HOMEDRIVE> ~ %*ENV<HOMEPATH>». If the home directory cannot be determined, it will be L<Any> |
| $*SPEC            | The appropriate L<IO::Spec> sub-class for the platform that the program is running on. |
| $*TMPDIR          | An L<IO::Path> object representing the "system temporary directory" as determined by L«C<.tmpdir IO::Spec::* method\|/routine/tmpdir>» |
| $*TOLERANCE       | Used by the C<=~=> operator, and any operations that depend on it, to decide if two values are approximately equal. Defaults to 1e-15. |
| $*THREAD          | A L<Thread> object representing the currently executing thread. |
| $*SCHEDULER       | A L<ThreadPoolScheduler> object representing the current default scheduler. (see note below) |
| $*SAMPLER         | The current L<Telemetry::Sampler> used for making snapshots of system state. Only available if L<Telemetry> has been loaded. |

Note on usage of $*SCHEDULER:

For the current Rakudo, by default this imposes a maximum of 16 threads on the methods `.hyper` and `.race`. To change the maximum number of threads, either set the environment variable RAKUDO_MAX_THREADS before running perl6 or create a scoped copy with the default changed before using `.hyper` or `.race`:

```
my $*SCHEDULER = ThreadPoolScheduler.new( max_threads => 64 );
```

This behavior is not tested in the spec tests and is subject to change.

# [Naming Conventions](https://docs.perl6.org/language/variables#___top)

It is helpful to know our naming conventions in order to understand what codes do directly. However, there is not yet a conventions list covering anywhere. Still we list several conventions that are widely held.

- Subs and methods from the built-ins library try to have single-word names when a good one could be found. In cases where there are two or more words making up a name, they are separated by a "-".
- Compounds are treated as a single word, thus `substr`, `subbuf`, and `deepmap` (just like we write "starfish", not "star fish" in English).
- Subs and methods that are automatically called for you at special times are written in uppercase. This includes the `MAIN` sub, the `AT-POS` and related methods for implementing container types, along with `BUILD` and `DESTROY`.
- Type names are camel case, except for native types, which are lowercase. For the exception, you can remember it by: they are stored in a more compact way, so they names look smaller too.
- Built-in dynamic variables and compile-time variables are always uppercase, such like `$*OUT`, `$?FILE`.
- Methods from the MOP and other internals use "_" to separate multiple words, such like `add_method`.

