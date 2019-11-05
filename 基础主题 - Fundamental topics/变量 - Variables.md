原文：https://docs.raku.org/language/variables

# 变量 / Variables

Raku 中的变量

Variables in Raku

变量名字以一种叫做标记的特殊字符开头，后面跟着叫 twigil 的特殊字符最后才是[识别符](https://docs.raku.org/language/syntax#Identifiers)，前面两个特殊符号都是可选的。变量是值或者[容器](https://docs.raku.org/language/containers)符号名称。定义变量或者给变量赋值会直接生成容器。

Variable names can start with or without a special character called a *sigil*, followed optionally by a second special character named *twigil* and then an [identifier](https://docs.raku.org/language/syntax#Identifiers). Variables are symbolic names for values or [containers](https://docs.raku.org/language/containers). Variable declarations or assignment of values may create a container on the fly.

# 目录 / Table of Contents

<!-- MarkdownTOC -->

- [标记 / Sigils](#%E6%A0%87%E8%AE%B0--sigils)
    - [单条目与列表赋值 / Item and List Assignment](#%E5%8D%95%E6%9D%A1%E7%9B%AE%E4%B8%8E%E5%88%97%E8%A1%A8%E8%B5%8B%E5%80%BC--item-and-list-assignment)
    - [无标记变量 / Sigilless variables](#%E6%97%A0%E6%A0%87%E8%AE%B0%E5%8F%98%E9%87%8F--sigilless-variables)
- [符号 / Twigils](#%E7%AC%A6%E5%8F%B7--twigils)
    - [`*` 号](#-%E5%8F%B7)
    - [`?` 号](#-%E5%8F%B7-1)
    - [`!` 号](#-%E5%8F%B7-2)
    - [`.` 号](#-%E5%8F%B7-3)
    - [`^` 号](#%5E-%E5%8F%B7)
    - [`:` 号](#-%E5%8F%B7-4)
    - [`=` 号](#-%E5%8F%B7-5)
    - [`~` 号](#%7E-%E5%8F%B7)
- [变量声明符和作用域 / Variable declarators and scope](#%E5%8F%98%E9%87%8F%E5%A3%B0%E6%98%8E%E7%AC%A6%E5%92%8C%E4%BD%9C%E7%94%A8%E5%9F%9F--variable-declarators-and-scope)
    - [`my` 声明符](#my-%E5%A3%B0%E6%98%8E%E7%AC%A6)
    - [`our` 声明符](#our-%E5%A3%B0%E6%98%8E%E7%AC%A6)
    - [使用 my 或者 our 声明一组变量](#%E4%BD%BF%E7%94%A8-my-%E6%88%96%E8%80%85-our-%E5%A3%B0%E6%98%8E%E4%B8%80%E7%BB%84%E5%8F%98%E9%87%8F)
    - [`has` 声明符](#has-%E5%A3%B0%E6%98%8E%E7%AC%A6)
    - [`anon` 声明符](#anon-%E5%A3%B0%E6%98%8E%E7%AC%A6)
    - [`state` 声明符](#state-%E5%A3%B0%E6%98%8E%E7%AC%A6)
        - [`$` 变量](#%24-%E5%8F%98%E9%87%8F)
        - [`@` 变量](#-%E5%8F%98%E9%87%8F)
        - [`%` 变量](#%25-%E5%8F%98%E9%87%8F)
    - [`augment` 声明符](#augment-%E5%A3%B0%E6%98%8E%E7%AC%A6)
    - [`temp` 前缀](#temp-%E5%89%8D%E7%BC%80)
    - [`let` 前缀](#let-%E5%89%8D%E7%BC%80)
- [类型约束及初始化 / Type Constraints and Initialization](#%E7%B1%BB%E5%9E%8B%E7%BA%A6%E6%9D%9F%E5%8F%8A%E5%88%9D%E5%A7%8B%E5%8C%96--type-constraints-and-initialization)
    - [已定义变量的默认指令 / Default Defined Variables Pragma](#%E5%B7%B2%E5%AE%9A%E4%B9%89%E5%8F%98%E9%87%8F%E7%9A%84%E9%BB%98%E8%AE%A4%E6%8C%87%E4%BB%A4--default-defined-variables-pragma)
- [特殊变量 / Special Variables](#%E7%89%B9%E6%AE%8A%E5%8F%98%E9%87%8F--special-variables)
    - [预定义词法变量 / Pre-defined lexical variables](#%E9%A2%84%E5%AE%9A%E4%B9%89%E8%AF%8D%E6%B3%95%E5%8F%98%E9%87%8F--pre-defined-lexical-variables)
        - [`$_` 变量 / The `$_` Variable](#%24_-%E5%8F%98%E9%87%8F--the-%24_-variable)
        - [`$/` 变量 / The `$/` Variable](#%24-%E5%8F%98%E9%87%8F--the-%24-variable)
            - [位置属性 / Positional Attributes](#%E4%BD%8D%E7%BD%AE%E5%B1%9E%E6%80%A7--positional-attributes)
            - [命名属性 / Named Attributes](#%E5%91%BD%E5%90%8D%E5%B1%9E%E6%80%A7--named-attributes)
        - [`$!` 变量 / The `$!` Variable](#%24-%E5%8F%98%E9%87%8F--the-%24-variable-1)
    - [编译时变量 / Compile-time variables](#%E7%BC%96%E8%AF%91%E6%97%B6%E5%8F%98%E9%87%8F--compile-time-variables)
        - [其他编译时变量/ Other compile-time variables](#%E5%85%B6%E4%BB%96%E7%BC%96%E8%AF%91%E6%97%B6%E5%8F%98%E9%87%8F-other-compile-time-variables)
        - [&?ROUTINE](#routine)
        - [&?BLOCK](#block)
        - [$?DISTRIBUTION](#%24distribution)
    - [动态作用域变量 / Dynamic variables](#%E5%8A%A8%E6%80%81%E4%BD%9C%E7%94%A8%E5%9F%9F%E5%8F%98%E9%87%8F--dynamic-variables)
        - [参数相关变量 / Argument related variables](#%E5%8F%82%E6%95%B0%E7%9B%B8%E5%85%B3%E5%8F%98%E9%87%8F--argument-related-variables)
            - [`$*ARGFILES`](#%24argfiles)
            - [`@*ARGS`](#args)
            - [`&*ARGS-TO-CAPTURE`](#args-to-capture)
            - [`&*GENERATE-USAGE`](#generate-usage)
        - [特殊文件句柄： `STDIN`，`STDOUT` 以及 `STDERR` / Special filehandles: `STDIN`, `STDOUT` and `STDERR`](#%E7%89%B9%E6%AE%8A%E6%96%87%E4%BB%B6%E5%8F%A5%E6%9F%84%EF%BC%9A-stdin%EF%BC%8Cstdout-%E4%BB%A5%E5%8F%8A-stderr--special-filehandles-stdin-stdout-and-stderr)
        - [运行时环境 / Runtime environment](#%E8%BF%90%E8%A1%8C%E6%97%B6%E7%8E%AF%E5%A2%83--runtime-environment)
            - [`%*ENV`](#%25env)
            - [`$*REPO`](#%24repo)
            - [`$*INIT-INSTANT`](#%24init-instant)
            - [`$*TZ`](#%24tz)
            - [`$*CWD`](#%24cwd)
            - [`$*KERNEL`](#%24kernel)
            - [`$*DISTRO`](#%24distro)
            - [`$*VM`](#%24vm)
            - [`$*PERL`](#%24perl)
            - [`$*PID`](#%24pid)
            - [`$*PROGRAM-NAME`](#%24program-name)
            - [`$*PROGRAM`](#%24program)
            - [`&*EXIT`](#exit)
            - [`$*EXECUTABLE`](#%24executable)
            - [`$*EXECUTABLE-NAME`](#%24executable-name)
            - [`$*USAGE`](#%24usage)
            - [`$*USER`](#%24user)
            - [`$*GROUP`](#%24group)
            - [`$*HOMEDRIVE`](#%24homedrive)
            - [`$*HOMEPATH`](#%24homepath)
            - [`$*HOME`](#%24home)
            - [`$*SPEC`](#%24spec)
            - [`$*TMPDIR`](#%24tmpdir)
            - [`$*TOLERANCE`](#%24tolerance)
            - [`$*THREAD`](#%24thread)
            - [`$*SCHEDULER`](#%24scheduler)
            - [`$*SAMPLER`](#%24sampler)
- [命名约定 / Naming conventions](#%E5%91%BD%E5%90%8D%E7%BA%A6%E5%AE%9A--naming-conventions)

<!-- /MarkdownTOC -->

<a id="%E6%A0%87%E8%AE%B0--sigils"></a>
# 标记 / Sigils

共有四种标记。标量标记 `$`、位置标记 `@`、关联标记 `%` 和可调用标记 `&`。

There are four sigils. The scalar-sigil `$`, the positional-sigil `@`, the associative-sigil `%` and the callable-sigil `&`.

标记链接了语法，类型系统和[容器](https://docs.raku.org/language/containers)。这些标记为最常见的类型约束提供快捷方式，当声明变量以及为[字符串插值](https://docs.raku.org/language/quoting#Interpolation%3A_qq)充当标记时。[位置标记](https://docs.raku.org/language/containers#Flattening%2C_items_and_containers)和[关联标记](https://docs.raku.org/language/containers#Flattening%2C_items_and_containers)起到了类型约束的作用，使基础类型[下标](https://docs.raku.org/language/subscripts#Custom_types)需要知道分派给哪些方法。可调用标记对函数调用起到了同样的作用。可调用标记还会告诉编译器哪些括号可以省略。位置和关联签名也可以通过默认情况下展平来简化赋值。

Sigils provide a link between syntax, the type system and [containers](https://docs.raku.org/language/containers). They provide a shortcut for the most common type constraints when declaring variables and serve as markers for [string interpolation](https://docs.raku.org/language/quoting#Interpolation%3A_qq). The [positional-sigil](https://docs.raku.org/language/containers#Flattening%2C_items_and_containers) and the [associative-sigil](https://docs.raku.org/language/containers#Flattening%2C_items_and_containers) provide type constraint that enforce a base type [subscripts](https://docs.raku.org/language/subscripts#Custom_types) require to know what methods to dispatch to. The [callable-sigil](https://docs.raku.org/language/containers#Callable_containers) does the same for function calls. The latter also tells the compiler where parentheses for calls can be omitted. The positional and associative-sigil also simplify assignment by flattening by default.

| 标记 | 类型约束                | 默认类型 | 赋值 | 例子                        |
| ---- | ----------------------- | -------- | ---- | --------------------------- |
| $    | Mu (no type constraint) | Any      | item | Int, Str, Array, Hash       |
| @    | Positional              | Array    | list | List, Array, Range, Buf     |
| %    | Associative             | Hash     | list | Hash, Map, Pair             |
| &    | Callable                | Callable | item | Sub, Method, Block, Routine |

Examples:

```Raku
my $square = 9 ** 2;
my @array  = 1, 2, 3;   # Array variable with three elements 
my %hash   = London => 'UK', Berlin => 'Germany';
```

在声明中可以用 `is` 来设置容器类型。

The container type can be set with `is` in a declaration.

```Raku
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

无标记的变量信息见[无标记变量](https://docs.raku.org/language/variables#Sigilless_variables).

For information on variables without sigils, see [sigilless variables](https://docs.raku.org/language/variables#Sigilless_variables).

<a id="%E5%8D%95%E6%9D%A1%E7%9B%AE%E4%B8%8E%E5%88%97%E8%A1%A8%E8%B5%8B%E5%80%BC--item-and-list-assignment"></a>
## 单条目与列表赋值 / Item and List Assignment

有两种类型的变量分配、单条目赋值和列表赋值。两者都用 `=` 作为操作符。左边的语法决定了 `=` 号是用作单条目还是列表赋值。

There are two types of variable assignment, *item assignment* and *list assignment*. Both use the equal sign `=` as operator. The syntax of the left-hand side determines whether an `=` means item or list assignment.

单条目赋值将右边的值放到左边的变量（容器）中。

Item assignment places the value from the right-hand side into the variable (container) on the left.

列表赋值将怎么做的选择权给了左边的变量。

List assignment leaves the choice of what to do to the variable on the left.

例如，[列表](https://docs.raku.org/type/Array)变量（由 `@` 标记的）在列表赋值时首先将自己清空然后接受右边所有的值。

For example, [Array](https://docs.raku.org/type/Array) variables (`@` sigil) empty themselves on list assignment and then put all the values from the right-hand side into themselves.

赋值的类型（单条目或者列表）由当前表达式或声明语句的第一个上下文决定。

The type of assignment (item or list) is decided by the first context seen in the current expression or declarator:

```Raku
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

```Raku
my @array;
@array = my $num = 42, "str";   # item assignment: uses declarator
say @array.perl;                # OUTPUT: «[42, "str"]» (an Array)
say $num.perl;                  # OUTPUT: «42» (a Num)
```

类似地，如果中间的的赋值是表达式，这个表达式用来初始化声明语句，赋值类型由中间表达式的上下文决定：

Similarly, if the internal assignment is an expression that is being used as an initializer for a declarator, the context of the internal expression determines the assignment type:

```Raku
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

```Raku
my ( @array, $num );
@array = $num = 42, "str";    # list assignment
say @array.perl;              # OUTPUT: «[42, "str"]»
say $num.perl;                # OUTPUT: «42»
```

赋值语句被解析为 `@array = (($num = 42), "str")`, 因为单条目赋值比逗号的优先级更高。

The assignment expression is parsed as `@array = (($num = 42), "str")`, because item assignment has tighter precedence than the comma.

更多关于优先级的细节见[操作符](https://docs.raku.org/language/operators)。

See [operators](https://docs.raku.org/language/operators) for more details on precedence.

<a id="%E6%97%A0%E6%A0%87%E8%AE%B0%E5%8F%98%E9%87%8F--sigilless-variables"></a>
## 无标记变量 / Sigilless variables

使用 `\` 作为前缀，可以生成无标记的变量：

Using the `\` prefix, it's possible to create variables that do not have a sigil:

```Raku
my \degrees = pi / 180;
my \θ       = 15 * degrees;
```

注意，无标记变量没有关联的[容器](https://docs.raku.org/language/containers)。这意味着上面例子中的 `degrees` 和 `θ` 实际上表示的是 Num。尝试在定义变量后赋值可以详细说明这一点：

Note that sigilless variable do not have associated [containers](https://docs.raku.org/language/containers). This means `degrees` and `θ`, above, actually directly represent `Num`s. To illustrate, try assigning to one after you've defined it:

```Raku
θ = 3; # Dies with the error "Cannot modify an immutable Num" 
```

无标记变量不会施加上下文，所以他们能被用来按原样传递一些东西：

Sigilless variables do not enforce context, so they can be used to pass something on as-is:

```Raku
sub logged(&f, |args) {
    say('Calling ' ~ &f.name ~ ' with arguments ' ~ args.perl);
    my \result = f(|args);
    #  ^^^^^^^ not enforcing any context here
    say(&f.name ~ ' returned ' ~ result.perl);
    return |result;
}
```

无标记变量也能用作绑定。更多信息见[绑定](https://docs.raku.org/language/containers#Binding) 。

Sigilless variables can also be used for binding. See [Binding](https://docs.raku.org/language/containers#Binding) for more information.

<a id="%E7%AC%A6%E5%8F%B7--twigils"></a>
# 符号 / Twigils

符号影响变量的作用域；但是他们对主标记符是否可以字符串插值无影响。如果变量 `$a` 可以插值， `$^a`, `$*a`, `$=a`, `$?a`, `$.a` 也可以，只取决于 `$`。

Twigils influence the scoping of a variable; however, they have no influence over whether the primary sigil interpolates. That is, if `$a`interpolates, so do `$^a`, `$*a`, `$=a`, `$?a`, `$.a`, etc. It only depends on the `$`.

| 符号 | 作用域                                |
| ---- | ------------------------------------- |
| none | 没有符号，作用域只依赖声明符          |
| *    | 动态作用域                            |
| ?    | 编译时变量                            |
| !    | 属性 (类成员)                         |
| .    | 方法 (非真正意义上的变量)             |
| <    | 正则匹配对象索引 (非真正意义上的变量) |
| ^    | 自声明的正式的位置参数                |
| :    | 自声明的正式的命名参数                |
| =    | Pod 文档变量                          |
| ~    | 分歧器在当前词法点上可见的子语言      |

| Twigil | Scope                                                   |
| ------ | ------------------------------------------------------- |
| none   | Based only on declarator                                |
| *      | Dynamic                                                 |
| !      | Attribute (class member)                                |
| .      | Method (not really a variable)                          |
| :      | Self-declared formal named parameter                    |
| <      | Index into match object (not really a variable)         |
| =      | Pod variables                                           |
| ?      | Compile-time variable                                   |
| ^      | Self-declared formal positional parameter               |
| ~      | The sublanguage seen by the parser at this lexical spot |

<a id="-%E5%8F%B7"></a>
## `*` 号

动态变量使用这个符号，这种变量不在其所在的外部作用域查值，而是在调用者作用域查值的。

This twigil is used for dynamic variables which are looked up through the caller's, not through the outer, scope. Look at the example below.

注意：至今为止，如果你使用 rakudo perl6，下面的代码在 REPL 中无法运行。需要将代码拷贝粘贴至文件，然后运行这个文件。

*Note:* So far, if you use rakudo perl6, the example below cannot run correctly in the REPL. Please test it by copy-pasting it into a file, then run the file.

```Raku
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

第一次运行 `&say-all` 会打印出 “`1, 10, 100`”，没有意外。第二次运行却打印出 “`1, 11, 101`”。这是因为 `$lexical` 不是在调用者作用域里面查值而是在 `&say-all` 被定义时的作用域里查值。那两个动态变量是在调用者作用域里查值，因此值分别为 `11` 和 `101`。第三次运行 `&say-all` 时 `$*dynamic1` 的值不再是 `11`，但 `$*dynamic2` 仍然是 `101`。 这是因为我们在代码块里声明了一个新的 `$*dynamic1` 变量而不是像 `$*dynamic2` 那样给旧变量赋值。

The first time `&say-all` is called, it prints "`1, 10, 100`" just as one would expect. The second time though, it prints "`1, 11, 101`". This is because `$lexical` isn't looked up in the caller's scope but in the scope `&say-all` was defined in. The two dynamic variables are looked up in the caller's scope and therefore have the values `11` and `101`. The third time `&say-all` is called `$*dynamic1` isn't `11`anymore, but `$*dynamic2` is still `101`. This stems from the fact that we declared a new dynamic variable `$*dynamic1` in the block and did not assign to the old variable as we did with `$*dynamic2`.

动态变量与其他变量不同之处在于，引用一个没有声明的动态变量不是一个编译时错误而是一个运行时[错误](https://docs.raku.org/type/Failure)。因此动态变量可以不用声明便使用，只要在使用前检查了是否定义或者在布尔上下文中被用到：

The dynamic variables differ from other variable types in that referring to an undeclared dynamic variable is not a compile time error but a runtime [failure](https://docs.raku.org/type/Failure), so a dynamic variable can be used undeclared as long as it's checked for definedness or used in a boolean context before using it for anything else:

```Raku
sub foo() {
    $*FOO // 'foo';
}
 
say foo; # OUTPUT: «foo»
 
my $*FOO = 'bar';
 
say foo; # OUTPUT: «bar»
```

用 `my` 和 `our` 声明的动态变量分别有词法作用域和包作用域。动态解析以及通过 `our` 引入的借助符号表的解析是两个正交问题。

Dynamic variables can have lexical scope when declared with `my` or package scope when declared with `our`. Dynamic resolution and resolution through symbol tables introduced with `our` are two orthogonal issues.

<a id="-%E5%8F%B7-1"></a>
## `?` 号

编译时变量使用 `?` 号。这个变量就会被编译器知晓，并且在变量编译进去后不能修改。一个常见的例子是：

Compile-time variables may be addressed via the `?` twigil. They are known to the compiler and may not be modified after being compiled in. A popular example for this is:

```Raku
say "$?FILE: $?LINE"; # OUTPUT: "hello.pl: 23" 
                      # if this is the line 23 of a 
                      # file named "hello.pl" 
```

如果想要这些特殊变量的列表，可以参考[编译时变量](https://docs.raku.org/language/variables#Compile-time_variables).

For a list of these special variables, see [compile-time variables](https://docs.raku.org/language/variables#Compile-time_variables).

<a id="-%E5%8F%B7-2"></a>
## `!` 号

属性是存在于类实例中的变量。他们可以在类中通过 `!` 号被直接访问：

[Attributes](https://docs.raku.org/language/objects#Attributes) are variables that exist per instance of a class. They may be directly accessed from within the class via `!`:

```Raku
my class Point {
    has $.x;
    has $.y;
 
    method Str() {
        "($!x, $!y)"
    }
}
```

注意属性是如何通过 `$.x` 和 `$.y` 声明却通过 `$!x` 和 `$!y` 来访问的。这是因为 Raku 中所有的属性都是私有的而且可以在类中通过 `$!attribute-name` 直接访问。Raku 会直接为你生成访问器方法。更多关于对象，类和他们的属性的信息见[面向对象](https://docs.raku.org/language/objects) 。

Note how the attributes are declared as `$.x` and `$.y` but are still accessed via `$!x` and `$!y`. This is because in Raku all attributes are private and can be directly accessed within the class by using `$!attribute-name`. Raku may automatically generate accessor methods for you though. For more details on objects, classes and their attributes see [object orientation](https://docs.raku.org/language/objects).

<a id="-%E5%8F%B7-3"></a>
## `.` 号

`.` 号事实上不是给变量用的，下面代码

The `.` twigil isn't really for variables at all. In fact, something along the lines of

```Raku
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

`.` 号调用了方法的事实意味着下面的操作也是可能的：

The fact that the `.` twigil does a method call implies that the following is also possible:

```Raku
class SaySomething {
    method a() { say "a"; }
    method b() { $.a; }
}
 
SaySomething.b; # OUTPUT: «a»
```

更多关于对象、类和他们的属性的信息见[面向对象](https://docs.raku.org/language/objects) 。

For more details on objects, classes and their attributes and methods see [object orientation](https://docs.raku.org/language/objects).

<a id="%5E-%E5%8F%B7"></a>
## `^` 号

^ 号为代码块或者函数声明正式的位置参数。`$^variable` 形式的变量是占位符变量。他们可以用在裸代码块中来声明代码块的正式参数。因此下面代码中的代码块

The `^` twigil declares a formal positional parameter to blocks or subroutines. Variables of the form `$^variable` are a type of placeholder variable. They may be used in bare blocks to declare formal parameters to that block. So the block in the code

```Raku
my @powers-of-three = 1,3,9…100;
say reduce { $^b - $^a }, 0, |@powers-of-three;
# OUTPUT: «61»
```

有两个正式参数 `$a` 和 `$b`。 注意，尽管 `$^b` 在 `$^a` 之前，`$^a` 人就是代码块中的第一个正式参数。这是因为占位符变量是按 Unicode 顺序排序的。如果你有用 `$^a` 自声明变量，之后你可以用 `$a` 引用它。

has two formal parameters, namely `$a` and `$b`. Note that even though `$^b` appears before `$^a` in the code, `$^a` is still the first formal parameter to that block. This is because the placeholder variables are sorted in Unicode order. If you have self-declared a parameter using `$^a` once, you may refer to it using only `$a` thereafter.

尽管用任意合法的标记符作为占位符变量是可以的，还是建议使用短名或者容易理解的名称，以免给读者带来不必要的惊喜。

Although it is possible to use nearly any valid identifier as a placeholder variable, it is recommended to use short names or ones that can be trivially understood in the correct order, to avoid surprise on behalf of the reader.

普通块和子例程也可以使用占位符变量，但前提是它们没有显式的参数列表。

Normal blocks and subroutines may also make use of placeholder variables but only if they do not have an explicit parameter list.

```Raku
sub say-it    { say $^a; } # valid
sub say-it()  { say $^a; } # invalid
              { say $^a; } # valid
-> $x, $y, $x { say $^a; } # invalid
```

占位符变量不能有类型约束或者变量名称带有单个大写字母。

Placeholder variables cannot have type constraints or a variable name with a single upper-case letter (this is disallowed to enable catching some Perl5-isms).

<a id="-%E5%8F%B7-4"></a>
## `:` 号

`:` 号为块或子例程声明一个正式的命名参数。以这种形式声明的变量也是一种占位符变量。使用这种形式声明的变量也是一种占位符变量。因此，他们与使用 `^` 声明的变量相似（除了它们不是位置的，因此不按照 Unicode 顺序排序）。如：

The `:` twigil declares a formal named parameter to a block or subroutine. Variables declared using this form are a type of placeholder variable too. Therefore the same things that apply to variables declared using the `^` twigil also apply here (with the exception that they are not positional and therefore not ordered using Unicode order, of course). So this:

```Raku
say { $:add ?? $^a + $^b !! $^a - $^b }( 4, 5 ) :!add
# OUTPUT: «-1»
```

更多占位符变量细节见 [^](https://docs.raku.org/routine/$CIRCUMFLEX_ACCENT) 。

See [^](https://docs.raku.org/routine/$CIRCUMFLEX_ACCENT) for more details about placeholder variables.

<a id="-%E5%8F%B7-5"></a>
## `=` 号

= 号用于访问 Pod 变量。当前文件中的每个 Pod 块可以通过 Pod 对象访问，例如 `$=data`、`$=SYNOPSIS` 或 `$=UserBlock`。即变量有着跟 Pod 块相同的名字以及一个 `=` 号。

The `=` twigil is used to access Pod variables. Every Pod block in the current file can be accessed via a Pod object, such as `$=data`, `$=SYNOPSIS` or `$=UserBlock`. That is: a variable with the same name of the desired block and a `=` twigil.

```Raku
  =begin code
  =begin Foo
  ...
  =end Foo
 
  #after that, $=Foo gives you all Foo-Pod-blocks
  =end code
```

你可以通过 `$=pod` 访问包含所有 Pod 结构的 Pod 树作为分层数据结构

You may access the Pod tree which contains all Pod structures as a hierarchical data structure through `$=pod`.

注意所有的 `$=someBlockName` 支持 `Positional` 以及 `Associative` 角色。

Note that all those `$=someBlockName` support the `Positional` and the `Associative` roles.

<a id="%7E-%E5%8F%B7"></a>
## `~` 号

~ 号是用来引用子语言（也叫 slang ）。下面这些变量很有用：

The `~` twigil is for referring to sublanguages (called slangs). The following are useful:

| $~MAIN    | the current main language (e.g. Raku statements) |
| --------- | ------------------------------------------------ |
| $~Quote   | the current root of quoting language             |
| $~Quasi   | the current root of quasiquoting language        |
| $~Regex   | the current root of regex language               |
| $~Trans   | the current root of transliteration language     |
| $~P5Regex | the current root of the Perl 5 regex language    |

你可以在当前的词汇范围内扩充这些语言。

You `augment` these languages in your current lexical scope.

```Raku
use MONKEY-TYPING;
augment slang Regex {  # derive from $~Regex and then modify $~Regex 
    token backslash:std<\Y> { YY };
}
```

<a id="%E5%8F%98%E9%87%8F%E5%A3%B0%E6%98%8E%E7%AC%A6%E5%92%8C%E4%BD%9C%E7%94%A8%E5%9F%9F--variable-declarators-and-scope"></a>
# 变量声明符和作用域 / Variable declarators and scope

大多数时候使用 `my` 关键字创建新变量就足够了：

Most of the time it's enough to create a new variable using the `my` keyword:

```Raku
my $amazing-variable = "World";
say "Hello $amazing-variable!"; # OUTPUT: «Hello World!» 
```

但是，有许多声明符可以改变作用域的一些细节，这超越了[符号](https://docs.raku.org/language/variables#Twigils)所能做的。

However, there are many declarators that change the details of scoping beyond what [Twigils](https://docs.raku.org/language/variables#Twigils) can do.

| 声明符    | 作用                             |
| --------- | -------------------------------- |
| my        | 引入词法作用域变量               |
| our       | 引入包作用域变量                 |
| has       | 引入属性变量                     |
| anon      | 引入构造器私有的变量             |
| state     | 引入词法作用域但是持久保存的变量 |
| augment   | 给现有变量增加定义               |
| supersede | 给现有变量替换定义               |

| Declarator | Effect                                             |
| ---------- | -------------------------------------------------- |
| my         | Introduces lexically scoped names                  |
| our        | Introduces package-scoped names                    |
| has        | Introduces attribute names                         |
| anon       | Introduces names that are private to the construct |
| state      | Introduces lexically scoped but persistent names   |
| augment    | Adds definitions to an existing name               |
| supersede  | Replaces definitions of an existing name           |

还有两个这样的前缀，他们类似于声明符但是作用于已定义变量。

There are also two prefixes that resemble declarators but act on predefined variables:

| Prefix | Effect                                                                                                                                 |
| ------ | -------------------------------------------------------------------------------------------------------------------------------------- |
| temp   | Restores a variable's value at the end of scope / 在作用域结束时恢复变量的值。                                                         |
| let    | Restores a variable's value at the end of scope if the block exits unsuccessfully / 如果代码块退出不成功，在作用域结束时恢复变量的值。 |

<a id="my-%E5%A3%B0%E6%98%8E%E7%AC%A6"></a>
## `my` 声明符

使用 `my` 声明变量赋予了变量词法作用域。这意味着它只存在于当前块中。例如：

Declaring a variable with `my` gives it lexical scope. This means it only exists within the current block. For example:

```Raku
{
    my $foo = "bar";
    say $foo; # OUTPUT: «"bar"»
}
say $foo; # Exception! "Variable '$foo' is not declared"
```

这断代码会报错退出，因为 `$foo` 只有在相同作用域时才是被定义了的。

This dies because `$foo` is only defined as long as we are in the same scope.

另外，词法作用域意味着变量可以在新的作用域内被临时重新定义。

Additionally, lexical scoping means that variables can be temporarily redefined in a new scope:

```Raku
my $location = "outside";
 
sub outer-location {
    # Not redefined: 
    say $location;
}
 
outer-location; # OUTPUT: «outside»
 
sub in-building {
    my $location = "inside";
    say $location;
}
 
in-building;    # OUTPUT: «inside»
 
outer-location; # OUTPUT: «outside»
```

如果一个变量被重新定义，任何引用外部变量的代码依旧引用外部变量。因此这里，`&outer-location` 仍旧打印的是外部的 `$location` 的值：

If a variable has been redefined, any code that referenced the outer variable will continue to reference the outer variable. So here, `&outer-location` still prints the outer `$location`:

```Raku
sub new-location {
    my $location = "nowhere";
    outer-location;
}
 
new-location; # OUTPUT: «outside» 
```

要使 `new-location()` 打印出 `nowhere`，使用 [* 号](https://docs.raku.org/language/variables#The_%2A_Twigil) 使 `$location` 成为一个动态变量。这个符号让编译器在调用者的作用域查找变量符号，而不是查完本地作用域没找到后查外部作用域。

To make `new-location()` print `nowhere`, make `$location` a dynamic variable using [the * twigil](https://docs.raku.org/language/variables#The_%2A_Twigil). This twigil makes the compiler look up the symbol in the calling scope instead of the outer scope after trying the local scope.

`my` 是子例程的默认作用域，因此 `my sub x() {}` 和 `sub x() {}` 是完全一样的。

`my` is the default scope for subroutines, so `my sub x() {}` and `sub x() {}` do exactly the same thing.

<a id="our-%E5%A3%B0%E6%98%8E%E7%AC%A6"></a>
## `our` 声明符

`our` 声明的变量跟 `my` 声明的一样，除了额外给符号表插入了一个别名。

`our` variables work just like `my` variables, except that they also introduce an alias into the symbol table.

```Raku
module M {
    our $Var;
    # $Var available here 
}
 
# Available as $M::Var here. 
```

同时创建多个包作用域的变量只要将变量用括号括起来即可：

In order to create more than one variable with package scope, at the same time, surround the variables with parentheses:

```Raku
our ( $foo, $bar );
```

<a id="%E4%BD%BF%E7%94%A8-my-%E6%88%96%E8%80%85-our-%E5%A3%B0%E6%98%8E%E4%B8%80%E7%BB%84%E5%8F%98%E9%87%8F"></a>
## 使用 my 或者 our 声明一组变量

`my` 和 `our` 声明符都接受一组括起来的变量作为参数来一次声明多个变量。

It is possible to scope more than one variable at a time, but both my and our require variables to be placed into parentheses:

```Raku
my  (@a,  $s,  %h);   # same as my @a; my $s; my %h;
our (@aa, $ss, %hh);  # same as our @aa; our $ss; our %hh; 
```

这可以与解构赋值一起使用。对这样一个列表的任何赋值都将采用左列表的元素个数，并从右列表中为它们分配相应的值。根据变量的类型，任何遗漏的元素都会导致未定义的值。

This can be used in conjunction with destructuring assignment. Any assignment to such a list will take the number of elements provided in the left list and assign corresponding values from the right list to them. Any missing elements are left will result in undefined values according to the type of the variables.

```Raku
my (Str $a, Str $b, Int $c) = <a b>;
say [$a, $b, $c].perl;
# OUTPUT: «["a", "b", Int]»
```

要将列表拆分为单个值，请使用 `($var,)` 创建包含一个元素的列表文字。与变量声明符一起使用时，将单个变量用括号括起来就足够了。

To destructure a list into a single value, create a list literal with one element by using `($var,)`. When used with a variable declarator, providing parentheses around a single variable is sufficient.

```Raku
sub f { 1,2,3 };
my ($a) = f;
say $a.perl;
# OUTPUT: «1» 
```

要跳过列表中的元素，请使用匿名状态变量 `$`。

To skip elements in the list use the anonymous state variable `$`.

```Raku
my ($,$a,$,%h) = ('a', 'b', [1,2,3], {:1th});
say [$a, %h].perl;
# OUTPUT: «["b", {:th(1)}]» 
```

<a id="has-%E5%A3%B0%E6%98%8E%E7%AC%A6"></a>
## `has` 声明符

`has` 声明类实例或者角色的属性以及方法。`has` 暗示了方法，因此 `has method x() {}` 与 `method x() {}` 等价。

`has` scopes attributes to instances of a class or role, and methods to classes or roles. `has` is implied for methods, so `has method x() {}` and `method x() {}` do the same thing.

更多文档和例子，见[面向对象](https://docs.raku.org/language/objects)。

See [object orientation](https://docs.raku.org/language/objects) for more documentation and some examples.

<a id="anon-%E5%A3%B0%E6%98%8E%E7%AC%A6"></a>
## `anon` 声明符

`anon` 声明符可防止在词法作用域，方法表和其他任何地方安放符号。

The `anon` declarator prevents a symbol from getting installed in the lexical scope, the method table and everywhere else.

例如，你可以使用它来声明知道自己名称的子例程，但在它们不会被放置在作用域中：

For example, you can use it to declare subroutines which know their own name, but still aren't installed in a scope:

```Raku
my %operations =
    half   => anon sub half($x) { $x / 2 },
    square => anon sub square($x) { $x * $x },
    ;
say %operations<square>.name;       # square
say %operations<square>(8);         # 64
```

<a id="state-%E5%A3%B0%E6%98%8E%E7%AC%A6"></a>
## `state` 声明符

跟 `my` 类似，`state` 声明词法作用域变量。但是，初始化只会在首次遇到时执行一次。因此，状态变量将在封闭块或例程的多次执行中保持值不被改变。

`state` declares lexically scoped variables, just like `my`. However, initialization happens exactly once the first time the initialization is encountered in the normal flow of execution. Thus, state variables will retain their value across multiple executions of the enclosing block or routine.

因此，子例程

Therefore, the subroutine

```Raku
sub a {
    state @x;
    state $l = 'A';
    @x.push($l++);
};
 
say a for 1..6;
```

会持续增加 `$l` 的值，并在每次调用时将它追加到 `@x`。所以它会输出：

will continue to increment `$l` and append it to `@x` each time it is called. So it will output:

```Raku
[A]
[A B]
[A B C]
[A B C D]
[A B C D E]
[A B C D E F]
```

这适用于包含代码的对象的每个“克隆”，如下例所示：

This works per "clone" of the containing code object, as in this example:

```Raku
({ state $i = 1; $i++.say; } xx 3).map: {$_(), $_()}; # says 1 then 2 thrice 
```

请注意，当多个线程运行同一个块的相同克隆时，这**不是**线程安全的构造。还要记住，方法在每个类中只有一个克隆，而不是在每个对象中。

Note that this is **not** a thread-safe construct when the same clone of the same block is run by multiple threads. Also remember that methods only have one clone per class, not per object.

和 `my` 一样，声明多个 `state` 变量必须放在圆括号中。声明单个变量时，括号可以省略。

As with `my`, declaring multiple `state` variables must be placed in parentheses and for declaring a single variable, parentheses may be omitted.

许多操作符都带有隐式绑定，可能会导致其他地方的操作。

Many operators come with implicit binding which can lead to actions at a distance.

使用 `.clone` 或强制来创建一个可绑定的新容器。

Use `.clone` or coercion to create a new container that can be bound to.

```Raku
my @a;
my @a-cloned;
sub f() {
    state $i;
    $i++;
    @a\      .push: "k$i" => $i;
    @a-cloned.push: "k$i" => $i.clone;
};
 
f for 1..3;
say @a;        # OUTPUT: «[k1 => 3 k2 => 3 k3 => 3]» 
say @a-cloned; # OUTPUT: «[k1 => 1 k2 => 2 k3 => 3]» 
```

状态变量在所有线程中共享。结果可能出乎意料。

State variables are shared between all threads. The result can be unexpected.

```Raku
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
5» 
# OUTPUT: «2
1
3
4
5» 
# 可能有很多其他差不多的输出
# many other more or less odd variations can be produced 
```

<a id="%24-%E5%8F%98%E9%87%8F"></a>
### `$` 变量

除了显式声明的命名状态变量外，`$` 可以用作匿名 `state` 变量而不需要明确的 `state` 声明。

In addition to explicitly declared named state variables, `$` can be used as an anonymous state variable without an explicit `state` declaration.

```Raku
say "1-a 2-b 3-c".subst(:g, /\d/, {<one two three>[$++]});
# OUTPUT: «one-a two-b three-c» 
```

此外，状态变量可以在子程序之外使用。例如，你可以在一行中使用 `$` 来对文件中的行进行编号。

Furthermore, state variables can be used outside of subroutines. You could, for example, use `$` in a one-liner to number the lines in a file.

```Raku
perl6 -ne 'say ++$ ~ " $_"' example.txt
```

在词法范围内对 `$` 的每个引用在效果上相当于一个独立的变量。

Each reference to `$` within a lexical scope is in effect a separate variable.

```Raku
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
4» 
```

如果你需要在一个作用域中多次使用 `$` 的值，它应该被复制到一个新的变量中。

If you need to use the value of $ more than once in a scope, it should be copied to a new variable.

```Raku
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
three» 
```

请注意，隐式 `state` 声明符仅适用于变量本身，而不适用于可能包含初始化程序的表达式。如果初始化代码必须只能被调用一次，则必须使用 `state` 声明器。

Note that the implicit state declarator is only applied to the variable itself, not the expression that may contain an initializer. If the initializer has to be called exactly once, the `state` declarator has to be provided.

```Raku
subset DynInt where $ = ::('Int'); # 每次类型检查，初始化代码都会被调用 / the initializer will be called for each type check 
subset DynInt where state $ = ::('Int'); # 初始化只会被调用一次，这才是合适的缓存 / the initializer is called once, this is a proper cache 
```

<a id="-%E5%8F%98%E9%87%8F"></a>
### `@` 变量

类似于 `$` 变量，还有一个匿名[位置](https://docs.raku.org/type/Positional) `state` 变量 `@` 。

Similar to the `$` variable, there is also a [Positional](https://docs.raku.org/type/Positional) anonymous state variable `@`.

```Raku
sub foo($x) {
    say (@).push($x);
}
 
foo($_) for ^3;
 
# OUTPUT: «[0] 
#          [0 1] 
#          [0 1 2]» 
```

`@` 在这里加括号是为了使其和类成员变量 `@.push` 区分开来。索引访问不需要这种歧义消除，但你需要复制该值以执行任何有用的操作。

The `@` here is parenthesized in order to disambiguate the expression from a class member variable named `@.push`. Indexed access doesn't require this disambiguation but you will need to copy the value in order to do anything useful with it.

```Raku
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

与 `$` 一样，每个 `@` 都会引入一个新的匿名数组到作用域。

As with `$`, each mention of `@` in a scope introduces a new anonymous array.

<a id="%25-%E5%8F%98%E9%87%8F"></a>
### `%` 变量

另外，还有一个[关联](https://docs.raku.org/type/Associative)匿名关联变量 `%`。

In addition, there's an [Associative](https://docs.raku.org/type/Associative) anonymous state variable `%`.

```Raku
sub foo($x) {
    say (%).push($x => $x);
}
 
foo($_) for ^3;
 
# OUTPUT: «{0 => 0} 
#          {0 => 0, 1 => 1} 
#          {0 => 0, 1 => 1, 2 => 2}» 
```

消除歧义的作用在这同样适用。正如你所期望的那样，索引访问也是可以的（通过复制使其生效）。

The same caveat about disambiguation applies. As you may expect, indexed access is also possible (with copying to make it useful).

```Raku
sub foo($x) {
    my $v = %;
    $v{$x} = $x;
    say $v;
}
 
foo($_) for ^3;
 
# OUTPUT: «{0 => 0} 
#          {0 => 0, 1 => 1} 
#          {0 => 0, 1 => 1, 2 => 2}» 
```

与其他匿名状态变量一样，每个 `given` 范围内的 `%` 都将有效地引入一个独立的变量。

As with the other anonymous state variables, each mention of `%` within a given scope will effectively introduce a separate variable.

<a id="augment-%E5%A3%B0%E6%98%8E%E7%AC%A6"></a>
## `augment` 声明符

使用 `augment`，你可以将属性和方法添加到现有的类和语法，只要你先激活 `MONKEY-TYPING` 指令即可。

With `augment`, you can add attributes and methods to existing classes and grammars, provided you activated the `MONKEY-TYPING` pragma first.

由于类通常与 `our` 同作用域，因此是全局的，这样做意味着修改全局状态，这是非常不推荐的。几乎所有的这种情况都有更好的解决方案。

Since classes are usually `our` scoped, and thus global, this means modifying global state, which is strongly discouraged. For almost all situations, there are better solutions.

```Raku
# 不要这样做 / don't do this 
use MONKEY-TYPING;
augment class Int {
    method is-answer { self == 42 }
}
say 42.is-answer;       # OUTPUT: «True» 
```

在这个情况下，更好的解决方案是使用[函数](https://docs.raku.org/language/functions)。

(In this case, the better solution would be to use a [function](https://docs.raku.org/language/functions)).

<a id="temp-%E5%89%8D%E7%BC%80"></a>
## `temp` 前缀

像 `my` 一样，`temp` 会在其范围的末尾恢复变量的旧值。但是 `temp` 不会创建新变量。

Like `my`, `temp` restores the old value of a variable at the end of its scope. However, `temp` does not create a new variable.

```Raku
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
#          </g>» 
```

<a id="let-%E5%89%8D%E7%BC%80"></a>
## `let` 前缀

如果该块以失败退出，则恢复先前的值。成功退出意味着块返回了定义的值或列表。

Restores the previous value if the block exits unsuccessfully. A successful exit means the block returned a defined value or a list.

```Raku
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

在上面的例子中，如果 `Bool.pick` 返回真值，那么答案将保持为 84，因为该块返回一个定义的值（ `say` 返回真）。否则，`die` 语句将导致该块退出失败，并将答案重置为 42。

In the above case, if the `Bool.pick` returns true, the answer will stay as 84 because the block returns a defined value (`say` returns true). Otherwise the `die` statement will cause the block to exit unsuccessfully, resetting the answer to 42.

<a id="%E7%B1%BB%E5%9E%8B%E7%BA%A6%E6%9D%9F%E5%8F%8A%E5%88%9D%E5%A7%8B%E5%8C%96--type-constraints-and-initialization"></a>
# 类型约束及初始化 / Type Constraints and Initialization

变量通过所绑定的[容器](https://docs.raku.org/language/containers)有类型约束，容器在声明符与变量名之间。默认的类型约束是 [Mu](https://docs.raku.org/type/Mu)。也可以使用 [of](https://docs.raku.org/type/Variable#trait_of)特性来设置类型约束。

Variables have a type constraint via the [container](https://docs.raku.org/language/containers) they are bound to, which goes between the declarator and the variable name. The default type constraint is [Mu](https://docs.raku.org/type/Mu). You can also use the trait [of](https://docs.raku.org/type/Variable#trait_of) to set a type constraint.

```Raku
my Int $x = 42;
$x = 'a string';
CATCH { default { put .^name, ': ', .Str } }
# OUTPUT: «X::TypeCheck::Assignment: Type check failed in assignment to $x; expected Int but got Str ("a string")» 
```

如果标量变量有类型约束但是没有设置初始值，会被赋予容器的默认值。

If a scalar variable has a type constraint but no initial value, it's initialized with the type object of the default value of the container it's bound to.

```Raku
my Int $x;
say $x.^name;       # OUTPUT: «Int» 
say $x.defined;     # OUTPUT: «False» 
```

没有显示类型约束的标量变量写作 [Mu](https://docs.raku.org/type/Mu) 但是默认是 [Any](https://docs.raku.org/type/Any)类型对象。

Scalar variables without an explicit type constraint are typed as [Mu](https://docs.raku.org/type/Mu) but default to the [Any](https://docs.raku.org/type/Any) type object.

带 `@` 标记的变量初始化时生成一个空[数组](https://docs.raku.org/type/Array); 带 `%` 标记带变量初始化时生成一个空[哈希](https://docs.raku.org/type/Hash)。

Variables with the `@` sigil are initialized with an empty [Array](https://docs.raku.org/type/Array); variables with the `%` sigil are initialized with an empty [Hash](https://docs.raku.org/type/Hash).

变量默认值可以通过 `is default` 特性来设置，赋值 `Nil` 给变量恢复默认值。

The default value of a variable can be set with the `is default` trait, and re-applied by assigning `Nil` to it:

```Raku
my Real $product is default(1);
say $product;                       # OUTPUT: «1» 
$product *= 5;
say $product;                       # OUTPUT: «5» 
$product = Nil;
say $product;                       # OUTPUT: «1» 
```

<a id="%E5%B7%B2%E5%AE%9A%E4%B9%89%E5%8F%98%E9%87%8F%E7%9A%84%E9%BB%98%E8%AE%A4%E6%8C%87%E4%BB%A4--default-defined-variables-pragma"></a>
## 已定义变量的默认指令 / Default Defined Variables Pragma

强制所有变量适用已定义约束，使用指令 `use variables :D`。指令为词法作用域并且可以使用 `use variables :_` 关闭。

To force all variables to have a definedness constraint, use the pragma `use variables :D`. The pragma is lexically scoped and can be switched off with `use variables :_`.

```Raku
use variables :D;
my Int $i;
# OUTPUT: «===SORRY!=== Error while compiling <tmp>
# Variable definition of type Int:D (implicit :D by pragma) requires an initializer ... 
my Int $i = 1; # that works 
{ use variables :_; my Int $i; } # switch it off in this block 
```

注意赋值 [Nil](https://docs.raku.org/type/Nil) 会使变量恢复默认值。有已定义约束的类型的默认值就是后面跟 `:D` 的类型 (e.g. `Int:D`)。那意味着已定义约束不保证变量的已定义。这个只对变量初始化生效，不适用于[签名](https://docs.raku.org/type/Signature)或者其后的变量赋值。

Note that assigning [Nil](https://docs.raku.org/type/Nil) will revert the variable to its default value. The default value of a defined constraint type is the type appended with `:D` (e.g. `Int:D`). That means a definedness constraint is no guarantee of definedness. This only applies to variable initializers, not to [Signature](https://docs.raku.org/type/Signature)s. or subsequent assignments to a variable.

<a id="%E7%89%B9%E6%AE%8A%E5%8F%98%E9%87%8F--special-variables"></a>
# 特殊变量 / Special Variables

Raku 试图对特殊变量使用可描述的长名。只有三个特殊变量很简短。

Raku attempts to use long, descriptive names for special variables. There are only three special variables that are extra short.

<a id="%E9%A2%84%E5%AE%9A%E4%B9%89%E8%AF%8D%E6%B3%95%E5%8F%98%E9%87%8F--pre-defined-lexical-variables"></a>
## 预定义词法变量 / Pre-defined lexical variables

每个代码块都可以访问到的三个特殊变量：

There are three special variables that are available in every block:

| Variable | Meaning        |
| -------- | -------------- |
| $_       | topic variable |
| $/       | regex match    |
| $!       | exceptions     |

<a id="%24_-%E5%8F%98%E9%87%8F--the-%24_-variable"></a>
### `$_` 变量 / The `$_` Variable

`$_` 是主题变量。代码块没有显示签名时它会作为默认参数，因此类似 `for @array { ... }` 以及 `given $var { ... }` 结构的代码块被调用时会绑定到 `$_`。

`$_` is the topic variable. It's the default parameter for blocks that do not have an explicit signature, so constructs like `for @array { ... }` and `given $var { ... }` bind to `$_` by invoking the block.

```Raku
for <a b c> { say $_ }  # sets $_ to 'a', 'b' and 'c' in turn 
say $_ for <a b c>;     # same, even though it's not a block 
given 'a'   { say $_ }  # sets $_ to 'a' 
say $_ given 'a';       # same, even though it's not a block 
```

`CATCH` 代码块设置 `$_` 为捕获的异常。聪明匹配符 `~~` 将右手边的表达式 `$_` 赋值给左手边的值。

`CATCH` blocks set `$_` to the exception that was caught. The `~~` smart-match operator sets `$_` on the right-hand side expression to the value of the left-hand side.

`$_` 调用方法时可以省去变量名：

Calling a method on `$_` can be shortened by leaving off the variable name:

```Raku
.say;                   # same as $_.say 
```

`m/regex/` 和 `/regex/` 正则匹配以及 `s/regex/subst/` 替换默认对 `$_` 进行操作:

`m/regex/` and `/regex/` regex matches and `s/regex/subst/` substitutions work on `$_`:

```Raku
say "Looking for strings with non-alphabetic characters...";
for <ab:c d$e fgh ij*> {
    .say if m/<-alpha>/;
}
 
# OUTPUT: «Looking for strings with non-alphabetic characters... 
#          ab:c 
#          d$e 
#          ij*» 
```

<a id="%24-%E5%8F%98%E9%87%8F--the-%24-variable"></a>
### `$/` 变量 / The `$/` Variable

`$/` 是匹配变量。它存储了上一次[正则](https://docs.raku.org/language/regexes)匹配的结果，因此通常包含[匹配](https://docs.raku.org/type/Match)类型的对象。

`$/` is the match variable. It stores the result of the last [Regex](https://docs.raku.org/language/regexes) match and so usually contains objects of type [Match](https://docs.raku.org/type/Match).

```Raku
'abc 12' ~~ /\w+/;  # sets $/ to a Match object 
say $/.Str;         # OUTPUT: «abc» 
```

`Grammar.parse` 方法也会将调用者的 `$/` 变量设置为结果中的[匹配](https://docs.raku.org/type/Match)对象。下列代码：

The `Grammar.parse` method also sets the caller's `$/` to the resulting [Match](https://docs.raku.org/type/Match) object. For the following code:

```Raku
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
#             textnode => ｢some text｣» 
```

在 6.c 版本中，你可以使用 `$()` 从 `$/` 中[匹配](https://docs.raku.org/type/Match)得到[ast](https://docs.raku.org/routine/ast)的值, 如果那个值为真的话。也可以从[匹配](https://docs.raku.org/type/Match)对象的字符串形式中获得。

In the 6.c version, you can use `$()` shortcut (no spaces inside the parentheses) to get the [ast](https://docs.raku.org/routine/ast) value from `$/` [Match](https://docs.raku.org/type/Match) if that value is truthy, or the stringification of the [Match](https://docs.raku.org/type/Match) object otherwise.

```Raku
'test' ~~ /.../;
# 6.c language only: 
say $(); # OUTPUT: «tes»; 
$/.make: 'McTesty';
say $(); # OUTPUT: «McTesty»; 
```

<a id="%E4%BD%8D%E7%BD%AE%E5%B1%9E%E6%80%A7--positional-attributes"></a>
#### 位置属性 / Positional Attributes

`$/` 有位置属性，如果[正则]中(https://docs.raku.org/language/regexes)有匹配组的话，就是那些括号组成的匹配组。

`$/` can have positional attributes if the [Regex](https://docs.raku.org/language/regexes) had capture-groups in it, which are just formed with parentheses.

```Raku
'abbbbbcdddddeffg' ~~ / a (b+) c (d+ef+) g /;
say $/[0]; # OUTPUT: «｢bbbbb｣» 
say $/[1]; # OUTPUT: «｢dddddeff｣» 
```

也可以通过快捷变量 `$0`、`$1`、 `$2` 等等表示。

These can also be accessed by the shortcuts `$0`, `$1`, `$2`, etc.

```Raku
'abbbbbcdddddeffg' ~~ / a (b+) c (d+ef+) g /;
say $0; # OUTPUT: «｢bbbbb｣» 
say $1; # OUTPUT: «｢dddddeff｣» 
```

`$/.list` 或者 `@$/`可以用来获取所有的位置属性。在 6.c 中，可以使用 `@()` （括号中无空格）。

To get all of the positional attributes, you can use `$/.list` or `@$/`. In the 6.c language, you can also use the `@()` shortcut (no spaces inside the parentheses).

```Raku
say @$/.join; # OUTPUT: «bbbbbdddddeff»

# 6.c language only:
'abbbbbcdddddeffg' ~~ / a (b+) c (d+ef+) g /;
say @().join; # OUTPUT: «bbbbbdddddeff» 
```

<a id="%E5%91%BD%E5%90%8D%E5%B1%9E%E6%80%A7--named-attributes"></a>
#### 命名属性 / Named Attributes

`$/` 可以有命名属性如果[正则](https://docs.raku.org/language/regexes)中有命名群组捕获或者正则中有调用另外一个正则。

`$/` can have named attributes if the [Regex](https://docs.raku.org/language/regexes) had named capture-groups in it, or if the Regex called out to another Regex.

```Raku
'I.... see?' ~~ / \w+ $<punctuation>=[ <-[\w\s]>+ ] \s* $<final-word> = [ \w+ . ] /;
say $/<punctuation>; # OUTPUT: «｢....｣» 
say $/<final-word>;  # OUTPUT: «｢see?｣» 
```

这些也可以通过 `$` 更快捷地访问。

These can also be accessed by the shortcut `$`.

```Raku
say $<punctuation>; # OUTPUT: «｢....｣» 
say $<final-word>;  # OUTPUT: «｢see?｣» 
```
`$/.hash` 或者 `%$/` 可以用来获取所有的命名属性。在 6.c 中，你也可以使用 `%()`（括号内无空格）。

To get all of the named attributes, you can use `$/.hash` or `%$/`. In the 6.c language, you can also use the `%()` shortcut (no spaces inside the parentheses). 

```Raku
say %$/.join;       # OUTPUT: «"punctuation     ....final-word  see?"

# 6.c language only 
say %().join;       # OUTPUT: «"punctuation     ....final-word  see?"» 
```

<a id="%24-%E5%8F%98%E9%87%8F--the-%24-variable-1"></a>
### `$!` 变量 / The `$!` Variable

`$!` 是错误变量。`try` 代码块或者语句捕获的异常存储在 `$!` 中。如果没有异常被捕获，`$!` 会被设置为 `Any` 类型对象。

`$!` is the error variable. If a `try` block or statement prefix catches an exception, that exception is stored in `$!`. If no exception was caught, `$!` is set to the `Any` type object.

注意 `CATCH` 代码块*不会*设置 `$!`，在代码块中设置 `$_` 来捕获异常。

Note that `CATCH` blocks *do not* set `$!`. Rather they set `$_` inside the block to the caught exception.

<a id="%E7%BC%96%E8%AF%91%E6%97%B6%E5%8F%98%E9%87%8F--compile-time-variables"></a>
## 编译时变量 / Compile-time variables

所有的编译时变量在符号中都带有问号。*编译时*变量无法在运行时被改变，但是它们在内省程序时很有价值。最常见的编译时变量如下：

All compile time variables have a question mark as part of the twigil. Being *compile time* they cannot be changed at run-time, however they are valuable in order to introspect the program. The most common compile time variables are the following:

| $?FILE      | Which file am I in?                                                           | 我在哪一个文件？             |
| ----------- | ----------------------------------------------------------------------------- | ---------------------------- |
| $?LINE      | Which line am I at?                                                           | 我在哪一行？                 |
| ::?CLASS    | Which class am I in?                                                          | 我在哪一个类                 |
| %?LANG      | What is the current set of interwoven languages?                              | 我在哪个交织的语言中 ？      |
| %?RESOURCES | The files associated with the "Distribution" of the current compilation unit. | 当前发行版编译单元相关的文件 |

<a id="%E5%85%B6%E4%BB%96%E7%BC%96%E8%AF%91%E6%97%B6%E5%8F%98%E9%87%8F-other-compile-time-variables"></a>
### 其他编译时变量/ Other compile-time variables

下列编译时变量可以进行更深入的内省：

The following compile time variables allow for a deeper introspection:

| $?PACKAGE      | Which package am I in?                                   | 我在哪个包?                                     |
| -------------- | -------------------------------------------------------- | ----------------------------------------------- |
| $?MODULE       | Which module am I in?                                    | 我在哪个模组?                                   |
| $?CLASS        | Which class am I in? (as variable)                       | 我在哪个类中作为变量？                          |
| $?ROLE         | Which role am I in? (as variable)                        | 我在哪个角色中作为变量？                        |
| $?GRAMMAR      | Which grammar am I in?                                   | 我在哪个语法中?                                 |
| $?TABSTOP      | How many spaces is a tab in a heredoc or virtual margin? | 在 heredoc 或者虚拟边框中 Tab 相当于几个空格 ？ |
| $?NL           | What a vertical newline "\n" means: LF, CR or CRLF       | 换行符的意思是：LF， CR 还是 CRLF               |
| $?DISTRIBUTION | The Distribution of the current compilation unit.        | 当前编译单元的发行版                            |

特别是关于 `$?NL`，见[换行指令](https://docs.raku.org/language/pragmas)

With particular regard to the `$?NL`, see the [newline pragma](https://docs.raku.org/language/pragmas).

这些变量是 Rakudo 特有的，具有所有相应的注意事项：

These variables are Rakudo specific, with all the corresponding caveats:

| $?BITS | Number of bits of the platform the program is being compiled | # 程序被编译时平台的位数。|

<a id="routine"></a>
### &?ROUTINE

程序实际在哪个函数，编译时变量 `&ROUTINE` 为此提供了内省功能。它会返回当前函数的一个 [Sub](https://docs.raku.org/type/Sub) 实例。它支持使用方法 `.name` 或者 `.signature` 以及其他跟 `Sub` 相关的方法来获取调用函数名。

The compile time variable `&?ROUTINE` provides introspection about which routine the program is actually within. It returns an instance of [Sub](https://docs.raku.org/type/Sub) attached to the current routine. It does support the method `.name` to obtain the name of the called routine, as well as `.signature`and others method related to `Sub`:

```Raku
sub awesome-sub { say &?ROUTINE.name }
awesome-sub # OUTPUT: awesome-sub 
```

特殊变量 `&?ROUTINE` 也支持递归：

The special variable `&?ROUTINE` allows also for recursion:

```Raku
my $counter = 10;
sub do-work {
    say 'Calling myself other ' ~ $counter-- ~ ' times';
    &?ROUTINE() if ( $counter > 0 );
}
do-work;
```

<a id="block"></a>
### &?BLOCK

`&?BLOCK` 行为与 `&?ROUTINE` 类似，但是它允许内省单一代码块。其持有一个 [Sub](https://docs.raku.org/type/Sub) 并且允许在相同代码块中迭代。

The special compile variable `&?BLOCK` behaves similarly to `&?ROUTINE` but it allows to introspect a single block of code. It holds a [Sub](https://docs.raku.org/type/Sub)and allows for recursion within the same block:

```Raku
for '.' {
    .Str.say when !.IO.d;
    .IO.dir()».&?BLOCK when .IO.d # lets recurse a little! 
}
```

<a id="%24distribution"></a>
### $?DISTRIBUTION

`$？DISTRIBUTION` 提供对当前编译单元的 [Distribution](https://docs.raku.org/type/distribution) 的访问。这使模块作者可以通过原始相对路径名引用分发中的其他文件，或查看元数据（通过 `.meta` 方法），而无需知道底层文件结构（例如 `Compunit::Repository::Installation` 如何在安装时更改文件布局）。

`$?DISTRIBUTION` provides access to the [Distribution](https://docs.raku.org/type/Distribution) of the current compilation unit. This gives module authors a way to reference other files in the distribution by their original relative path names, or to view the metadata (via the `.meta` method), without needing to know the underlying file structure (such as how `CompUnit::Repository::Installation` changes the file layout on installation).

```Raku
unit module MyFoo;
 
sub module-version {
    say "MyFoo is version:";
    say $?DISTRIBUTION.meta<ver>;
}
 
sub module-source {
    say "MyFoo source code:";
    say $?DISTRIBUTION.content('lib/MyFoo.pm6');
}
```

<a id="%E5%8A%A8%E6%80%81%E4%BD%9C%E7%94%A8%E5%9F%9F%E5%8F%98%E9%87%8F--dynamic-variables"></a>
## 动态作用域变量 / Dynamic variables

所有的动态作用域变量带有 `*` 符号，名字习惯上使用大写。

All dynamically scoped variables have the `*` twigil, and their name is (conventionally) written in uppercase.

<a id="%E5%8F%82%E6%95%B0%E7%9B%B8%E5%85%B3%E5%8F%98%E9%87%8F--argument-related-variables"></a>
### 参数相关变量 / Argument related variables

这些变量与传给脚本的参数有关。

These variables are related to the arguments passed to a script.

<a id="%24argfiles"></a>
#### `$*ARGFILES`

[IO::ArgFiles](https://docs.raku.org/type/IO::ArgFiles) （一个 [IO::CatHandle](https://docs.raku.org/type/IO::CatHandle) 的空子类），如果 `@*ARGS` 中包含文件话，使用 `@*ARGS` 作为源文件，否则用 `$*IN`。 当使用 `$*IN` 时， 它的 `:chomp`、`:encoding` 以及 `:bin` 将会被给到
[IO::ArgFiles](https://docs.raku.org/type/IO::ArgFiles) 对象。

As of the 6.d version, `$*ARGFILES` *inside* [`sub MAIN`](https://docs.raku.org/language/functions#sub_MAIN) is always set to `$*IN`, even when `@*ARGS` is not empty. See [the class documentation](https://docs.raku.org/type/IO::ArgFiles#%24%2AARGFILES) for examples and more context.

<a id="args"></a>
#### `@*ARGS`

`@*ARGS` 包含命令行中的参数。

`@*ARGS` contains the arguments from the command line.

<a id="args-to-capture"></a>
#### `&*ARGS-TO-CAPTURE`

在任意用来分析默认参数的自定义 [`ARGS-TO-CAPTURE`](https://docs.raku.org/language/create-cli#sub_ARGS-TO-CAPTURE) 函数中的动态作用域变量。其与自定义 `ARGS-TO-CAPTURE` 函数一样接受同样的参数。

A dynamic variable available inside any custom [`ARGS-TO-CAPTURE`](https://docs.raku.org/language/create-cli#sub_ARGS-TO-CAPTURE) subroutine that can be used to perform the default argument parsing. Takes the same parameters as are expected of the custom `ARGS-TO-CAPTURE` subroutine.

<a id="generate-usage"></a>
#### `&*GENERATE-USAGE`

在任意用来生成默认使用说明信息的自定义 [`GENERATE-USAGE`](https://docs.raku.org/language/create-cli#sub_GENERATE-USAGE) 函数中的动态作用域变量。其与自定义 `GENERATE-USAGE` 函数一样接受同样的参数。

A dynamic variable available inside any custom [`GENERATE-USAGE`](https://docs.raku.org/language/create-cli#sub_GENERATE-USAGE) subroutine that can be used to perform the default usage message creation. Takes the same parameters as are expected of the custom `GENERATE-USAGE` subroutine.

<a id="%E7%89%B9%E6%AE%8A%E6%96%87%E4%BB%B6%E5%8F%A5%E6%9F%84%EF%BC%9A-stdin%EF%BC%8Cstdout-%E4%BB%A5%E5%8F%8A-stderr--special-filehandles-stdin-stdout-and-stderr"></a>
### 特殊文件句柄： `STDIN`、`STDOUT` 以及 `STDERR` / Special filehandles: `STDIN`, `STDOUT` and `STDERR`

更多关于特殊文件句柄的信息请参考 [Input and Output](https://docs.raku.org/language/io) 以及 [IO::Special](https://docs.raku.org/type/IO::Special) 类。[IO::Handle](https://docs.raku.org/type/IO::Handle) 包含使用 `$*IN` 读取标准输入的几个例子。

For more information about special filehandles please see also the [Input and Output](https://docs.raku.org/language/io) page and the [IO::Special](https://docs.raku.org/type/IO::Special) class. [IO::Handle](https://docs.raku.org/type/IO::Handle)contains several examples of using `$*IN` for reading standard input.

- `$*IN` 标准输入文件句柄, 即 *STDIN*.
- `$*OUT` 标准输出文件句柄, 即 *STDOUT*.
- `$*ERR` 标准错误文件句柄, 即 *STDERR*.

- `$*IN` Standard input filehandle, AKA *STDIN*.
- `$*OUT` Standard output filehandle, AKA *STDOUT*.
- `$*ERR` Standard error filehandle, AKA *STDERR*.

<a id="%E8%BF%90%E8%A1%8C%E6%97%B6%E7%8E%AF%E5%A2%83--runtime-environment"></a>
### 运行时环境 / Runtime environment

这些动态作用域变量包含脚本或者程序环境相关的信息。

These dynamic variables contain information related to the environment the script or program is running in.

<a id="%25env"></a>
#### `%*ENV`

操作系统环境变量。数值由 [allomorphs](https://docs.raku.org/language/glossary#index-entry-Allomorph)提供。

Operating system environment variables. Numeric values are provided as [allomorphs](https://docs.raku.org/language/glossary#index-entry-Allomorph)

<a id="%24repo"></a>
#### `$*REPO`

这个变量有已安装或者装载的模块信息。

This variable holds information about modules installed/loaded.

<a id="%24init-instant"></a>
#### `$*INIT-INSTANT`

`$*INIT-INSTANT` 是一个 [Instant](https://docs.raku.org/type/Instant) 对象，表示程序的启动时间。这个表示的是核心代码启动时的时间，因此它的值可能比你程序中的 `INIT now` 或者 `BEGIN now` 要早几毫秒。

`$*INIT-INSTANT` is an [Instant](https://docs.raku.org/type/Instant) object representing program startup time. In particular, this is when the core code starts up, so the value of `$*INIT-INSTANT` may be a few milliseconds earlier than `INIT now` or even `BEGIN now` executed in your program.

<a id="%24tz"></a>
#### `$*TZ`

`$*TZ` 表示系统本地时区偏移，值为与GMT相差的**秒**数。

`$*TZ` contains the system's local timezone offset, as the number of **seconds** from GMT.

<a id="%24cwd"></a>
#### `$*CWD`

表示当前工作目录。

It contains the `C`urrent `W`orking `D`irectory.

<a id="%24kernel"></a>
#### `$*KERNEL`

`$*KERNEL` 包含一个 [`Kernel` 实例](https://docs.raku.org/type/Kernel)，它调用 `.gist` 方法的输出即为当前生效内核。

`$*KERNEL` contains a [`Kernel` instance](https://docs.raku.org/type/Kernel), the `.gist` of it being the current running kernel.

```Raku
say $*KERNEL; # OUTPUT: «linux (4.4.92.31.default)» 
```

<a id="%24distro"></a>
#### `$*DISTRO`

这个对象（类型为 `Distro`）包含当前操作系统的发行版信息。例如：

This object (of type `Distro`) contains information about the current operating system distribution. For instance:

```Raku
say "Some sort of Windows" if $*DISTRO.is-win;
```

`$*DISTRO.name` 的值依赖操作系统。随着系统的版本和实现而变，因此使用这个前你需要充分确认和测试。这些名字是实现定义的而且不在规格说明里，所以它们随时可能发生变化和改变。

`$*DISTRO.name` takes a set of values that depend on the operating system. These names will vary with version and implementation, so you should double-check and test before using them in your programs; since these names are implementation defined and not in the specification, they could vary and change at any moment.

使用 `say` 显示 `$*DISTRO` 的 gist（返回对象的名字和版本）形式。

The `$*DISTRO` gist is displayed by using `say`:

```Raku
say $*DISTRO; # OUTPUT: «debian (9.stretch)» 
```

这将显示有关操作系统及其使用的版本的其他信息，但实际上，此变量包含的信息对于创建可移植程序很有用，例如路径分隔符：

This shows additional information on the operating system and version it's using, but as a matter of fact, this variable contains information which is useful to create portable programs, such as the path separator:

```Raku
say $*DISTRO.perl;
# OUTPUT: «Distro.new(release => "42.3", is-win => Bool::False, 
#          path-sep => ":", name => "opensuse", 
#          auth => "https://www.opensuse.org/", version => v42.3, 
#          signature => Blob, desc => "2018-12-13T08:50:59.213619+01:00")
» 
```

<a id="%24vm"></a>
#### `$*VM`

此变量包含当前运行代码的虚拟机，以及有关上述虚拟机内部工作的其他信息。

This variable contains the current virtual machine running the code, as well as additional information on the inner workings of aforementioned VM.

```Raku
say $*VM.precomp-ext, " ", $*VM.precomp-target; # OUTPUT: «moarvm mbc» 
```

例如，这两个方法将显示预编译字节码脚本中使用的扩展名和使用的目标。这是在 Moar 虚拟机中的情况，但它也可能随版本和实现而变化。其他的VM，例如 Java，将为它们显示不同的值。`$*VM.config` 包括用于创建虚拟机的所有配置值，例如:

These two methods, for instance, will show the extension used in the precompiled bytecode scripts and the target used. This is what is found in the Moar Virtual Machine, but it could also vary with version and implementation. Other VM, such as Java, will show different values for them. `$*VM.config` includes all configuration values used to create the virtual machine, e.g.

```Raku
say $*VM.config<versionmajor>, ".", $*VM.config<versionminor>;
# OUTPUT: «2018.11» 
```

这是虚拟机的版本，通常与解释器和整个 Raku 环境中使用的版本相同。

which are the version of the virtual machine, generally the same one as the one used in the interpreter and the overall Raku environment.

<a id="%24perl"></a>
#### `$*PERL`

此对象包含有关当前 Raku 语言实现的信息：

This object contains information on the current implementation of the Raku language:

```Raku
say $*PERL.compiler.version; # OUTPUT: «v2018.11.52.g.06156.a.7.ca» 
```

但其 gist 输出包括语言名称，然后是编译器的主要版本：

but its gist includes the name of the language, followed by the major version of the compiler:

```Raku
say $*PERL; # OUTPUT: «Raku (6.d)» 
```

它将字符串化为 `Raku` ：

It stringifies to `Raku`:

```Raku
$*PERL.put; # OUTPUT: «Perl 6» 
```

<a id="%24pid"></a>
#### `$*PID`

包含描述当前进程标识符的整数的对象（依赖于操作系统）。

Object containing an integer describing the current Process IDentifier (operating system dependent).

<a id="%24program-name"></a>
#### `$*PROGRAM-NAME`

它包含当前可执行文件在命令行中输入时的路径，或者如果使用 -e 标志调用 perl，则为 `-e`。

This contains the path to the current executable as it was entered on the command line, or `-e` if perl was invoked with the -e flag.

<a id="%24program"></a>
#### `$*PROGRAM`

包含正在执行的 Raku 程序的位置（以 `IO::Path` 对象的形式）。

Contains the location (in the form of an `IO::Path` object) of the Raku program being executed.

<a id="exit"></a>
#### `&*EXIT`

这是一个[可调用](https://docs.raku.org/type/callable)，其中包含执行 `exit()` 调用时将执行的代码。用于将 Raku 嵌入到另一个语言运行时（如 Perl5 中的 Inline::Perl6）的情况。

This is a [Callable](https://docs.raku.org/type/Callable) that contains the code that will be executed when doing an `exit()` call. Intended to be used in situations where Raku is embedded in another language runtime (such as Inline::Perl6 in Perl 5).

<a id="%24executable"></a>
#### `$*EXECUTABLE`

包含当前正在运行的 Raku 可执行文件的 `IO::Path` 绝对路径。

Contains an `IO::Path` absolute path of the Raku executable that is currently running.

<a id="%24executable-name"></a>
#### `$*EXECUTABLE-NAME`

包含当前运行的 Raku 可执行文件的名称。（例如 raku-p、raku-m）。优先选择 `$*EXECUTABLE`，因为不能保证 Raku 可执行文件在 `PATH` 中。

Contains the name of the Raku executable that is currently running. (e.g. raku-p, raku-m). Favor `$*EXECUTABLE` over this one, since it's not guaranteed that the perl executable is in `PATH`.

<a id="%24usage"></a>
#### `$*USAGE`

这是从 `sub MAIN` 和 `sub USAGE` 内部的 `MAIN` 函数签名生成的默认用法消息。变量为*只读*。

This is the default usage message generated from the signatures of `MAIN` subs available from inside `sub MAIN` and `sub USAGE`. The variable is *read-only*.

<a id="%24user"></a>
#### `$*USER`

包含运行程序的用户信息的一种 `同质异形体` 。如果将其视为字符串则其值为用户名，如果将其视为数字，则其值为用户的数值。

An `Allomorph` with information about the user that is running the program. It will evaluate to the username if treated as a string and the numeric user id if treated as a number.

<a id="%24group"></a>
#### `$*GROUP`

包含运行程序的主组信息的一种 `同质异形体` 。如果将其视为字符串则其值为组名，如果将其视为数字，则其值为组的数值。

An `Allomorph` with the primary group of the user who is running the program. It will evaluate to the groupname only if treated as a string and the numeric group id if treated as a number.

<a id="%24homedrive"></a>
#### `$*HOMEDRIVE`

包含有关在 Windows 上运行程序的用户的“家目录盘”的信息。它在其他操作系统中没有定义。

Contains information about the "home drive" of the user that is running the program on Windows. It's not defined in other operating systems.

<a id="%24homepath"></a>
#### `$*HOMEPATH`

包含有关在 Windows 上运行程序的用户目录路径的信息。它在其他操作系统中没有定义。

Contains information about the path to the user directory that is running the program on Windows. It's not defined in other operating systems.

<a id="%24home"></a>
#### `$*HOME`

包含一个 [IO::Path](https://docs.raku.org/type/IO::Path) 对象，表示运行程序的用户的“家目录”。如果设置，则使用 `%*ENV<HOME>`。

Contains an [IO::Path](https://docs.raku.org/type/IO::Path) object representing the "home directory" of the user that is running the program. Uses `%*ENV<HOME>` if set.

在 Windows 上，使用 `%*ENV<HOMEDRIVE> ~ %*ENV<HOMEPATH>`。如果无法确定家目录，它将是 [Any]（https://docs.raku.org/type/any）。

On Windows, uses `%*ENV<HOMEDRIVE> ~ %*ENV<HOMEPATH>`. If the home directory cannot be determined, it will be [Any](https://docs.raku.org/type/Any).

<a id="%24spec"></a>
#### `$*SPEC`

包含程序所运行平台的适当 [IO::Spec](https://docs.raku.org/type/IO::Spec) 子类。这是操作系统的一个更高级别的类；例如，对于 Linux，它将返回 `Unix`（以 `IO::Spec` 类的形式，用于当前实现）。

Contains the appropriate [IO::Spec](https://docs.raku.org/type/IO::Spec) sub-class for the platform that the program is running on. This is a higher-level class for the operating system; it will return `Unix`, for instance, in the case of Linux (in the form of the `IO::Spec` class used for the current implementation).

<a id="%24tmpdir"></a>
#### `$*TMPDIR`

这是一个 [IO::Path](https://docs.raku.org/type/IO::Path) 对象，表示由 [`.tmpdir IO::Spec::* method`](https://docs.raku.org/routine/tmpdir)确定的“系统临时目录”。

This is an [IO::Path](https://docs.raku.org/type/IO::Path) object representing the "system temporary directory" as determined by [`.tmpdir IO::Spec::* method`](https://docs.raku.org/routine/tmpdir).

<a id="%24tolerance"></a>
#### `$*TOLERANCE`

由 [`=~=`](https://docs.raku.org/routine/=~=) 运算符和依赖它的任何操作使用的变量，以确定两个值是否近似相等。默认为 `1e-15`。

Variable used by the [`=~=`](https://docs.raku.org/routine/=~=) operator, and any operations that depend on it, to decide if two values are approximately equal. Defaults to `1e-15`.

<a id="%24thread"></a>
#### `$*THREAD`

包含表示当前执行线程的 [Thread](https://docs.raku.org/type/thread) 对象。

Contains a [Thread](https://docs.raku.org/type/Thread) object representing the currently executing thread.

<a id="%24scheduler"></a>
#### `$*SCHEDULER`

这是表示当前默认计划程序的 [ThreadPoolScheduler](https://docs.raku.org/type/threadpoolscheduler) 对象。

This is a [ThreadPoolScheduler](https://docs.raku.org/type/ThreadPoolScheduler) object representing the current default scheduler.

默认情况下，在方法 `.hyper`、`.race` 和使用该调度程序的其他线程池类（如 `Promise` 或 `Supply`）上，这最多可施加 64 个线程。但是，这取决于实现，可能会发生更改。要更改线程的最大数目，可以在运行 Raku 之前设置环境变量 `RAKUDO_MAX_THREADS`，或者在使用它们之前创建一个范围复制，并更改默认值：

By default this imposes a maximum of 64 threads on the methods `.hyper`, `.race` and other thread-pool classes that use that scheduler such as `Promise`s or `Supply`s. This is, however, implementation, dependent and might be subject to change. To change the maximum number of threads, you can either set the environment variable `RAKUDO_MAX_THREADS` before running Raku or create a scoped copy with the default changed before using them:

```Raku
my $*SCHEDULER = ThreadPoolScheduler.new( max_threads => 128 );
```

此行为未在规范测试中测试，可能会发生更改。

This behavior is not tested in the spec tests and is subject to change.

<a id="%24sampler"></a>
#### `$*SAMPLER`

当前用于生成系统状态快照的 [Telemetry::Sampler](https://docs.raku.org/type/Telemetry::Sampler)。仅当已加载 [Telemetry]（https://docs.raku.org/type/teletry）时可用。

The current [Telemetry::Sampler](https://docs.raku.org/type/Telemetry::Sampler) used for making snapshots of system state. Only available if [Telemetry](https://docs.raku.org/type/Telemetry) has been loaded.

<a id="%E5%91%BD%E5%90%8D%E7%BA%A6%E5%AE%9A--naming-conventions"></a>
# 命名约定 / Naming conventions

了解我们的命名约定有助于直接理解代码的作用。然而，还没有（也可能永远不会）一份正式的清单；不过，我们列出了一些被广泛采用的约定。

It is helpful to know our naming conventions in order to understand what codes do directly. However, there is not yet (and might never be) an official list of; still, we list several conventions that are widely held.

- 内置库中的函数和方法在找到一个好的单词时，会尝试使用单个单词名。如果一个名称由两个或多个单词组成，则用“-”分隔。
- 符合词被当作一个词来处理，如 `substr`、`subbuf` 和 `deepmap`（就像我们用英语写 "starfish"，而不是 "star fish"）。
- 在特殊时间自动为你调用的函数和方法都是大写的。这包括 `MAIN` 函数、`AT-POS` 和实现容器类型的相关方法，以及 `BUILD` 和 `DESTROY`。
- 类型名采用驼峰法，除了本地类型（小写）。对于例外情况，你可以通过以下方式记住它：它们以更紧凑的方式存储，因此它们的名称看起来也更小。
- 内置的动态作用域变量和编译时变量总是大写的，例如 `$*out`、`$?FILE`。
- 来自 MOP(元对象协议) 和其他内部的方法使用下划线来分隔多个单词，例如 `add_method`。


- Subs and methods from the built-ins library try to have single-word names when a good one could be found. In cases where there are two or more words making up a name, they are separated by a "-".
- Compounds are treated as a single word, thus `substr`, `subbuf`, and `deepmap` (just like we write "starfish", not "star fish" in English).
- Subs and methods that are automatically called for you at special times are written in uppercase. This includes the `MAIN` sub, the `AT-POS` and related methods for implementing container types, along with `BUILD` and `DESTROY`.
- Type names are camel case, except for native types, which are lowercase. For the exception, you can remember it by: they are stored in a more compact way, so they names look smaller too.
- Built-in dynamic variables and compile-time variables are always uppercase, such like `$*OUT`, `$?FILE`.
- Methods from the MOP and other internals use "_" to separate multiple words, such like `add_method`.

