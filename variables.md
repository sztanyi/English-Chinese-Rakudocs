原文：https://docs.perl6.org/language/variables

译者：stanley_tam@163.com

# 变量

Perl 6 中的变量

Variables in Perl 6

变量名字以一种叫做标记的特殊字符开头，后面跟着叫 twigil 的特殊字符最后才是识别符，前面两个特殊符号都是可选的。变量是值以及容器的符号名称。定义变量或者给变量赋值会直接生成容器。

Variable names can start with or without a special character called a *sigil*, followed optionally by a second special character named *twigil* and then an [identifier](https://docs.perl6.org/language/syntax#Identifiers). Variables are symbolic names for values or [containers](https://docs.perl6.org/language/containers). Variable declarations or assignment of values may create a container on the fly.

# [标记（ Sigils ） ](https://docs.perl6.org/language/variables#___top)

共有四种标记。标量标记 \$，位置标记 @，关联标记 % 和可调用标记 &。

There are four sigils. The scalar-sigil `$`, the positional-sigil `@`, the associative-sigil `%` and the callable-sigil `&`.

标记链接了语法，类型系统和容器。当声明变量以及为字符串插值充当标记时，他们为最常见的类型约束提供快捷方式。位置标记和关联标记提供了类型约束，使基础类型下标需要知道分派给哪些方法。可调用标记对函数调用起到了同样的作用。可调用标记还会告诉编译器哪些括号可以省略。位置和关联签名也可以通过默认情况下展平来简化分配。

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

The container type can be set with `is` in a declaration.

在声明中可以用 is 来设置容器类型。

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
# OUTPUT: «round
» 
%h.finalize;
say %h<cherry>;
CATCH { default { put .^name, ': ', .Str } }
# OUTPUT: «X::OutOfRange: Hash key out of range. Is: cherry, should be in (oranges bananas)» 
```

无标记的变量信息见 [sigilless variables](https://docs.perl6.org/language/variables#Sigilless_variables).

For information on variables without sigils, see [sigilless variables](https://docs.perl6.org/language/variables#Sigilless_variables).

## [Item and List Assignment](https://docs.perl6.org/language/variables#___top)

有两种类型的变量分配，单条目赋值和列表赋值。两者都用等于号作为操作符。等于号左边的语法决定了等于号是用作单条目还是列表赋值。

There are two types of variable assignment, *item assignment* and *list assignment*. Both use the equal sign `=` as operator. The syntax of the left-hand side determines whether an `=` means item or list assignment.

单条目赋值将右边的值放到左边的变量（容器）中。

Item assignment places the value from the right-hand side into the variable (container) on the left.

列表赋值将怎么做的选择权给了左边的变量。

List assignment leaves the choice of what to do to the variable on the left.

例如，列表变量（@ 标记）首先将自己的值清空然后接受右边所有的值。

For example, [Array](https://docs.perl6.org/type/Array) variables (`@` sigil) empty themselves on list assignment and then put all the values from the right-hand side into themselves.

赋值的类型（单条目或者列表）由当前表达式或声明语句的第一个上下文决定。

The type of assignment (item or list) is decided by the first context seen in the current expression or declarator:

```Perl6
my $foo = 5;            # item assignment 
say $foo.perl;          # OUTPUT: «5
» 
 
my @bar = 7, 9;         # list assignment 
say @bar.^name;         # OUTPUT: «Array
» 
say @bar.perl;          # OUTPUT: «[7, 9]
» 
 
(my $baz) = 11, 13;     # list assignment 
say $baz.^name;         # OUTPUT: «List
» 
say $baz.perl;          # OUTPUT: «$(11, 13)
» 
```

列表赋值中的赋值行为依赖于包含它的表达式或者声明语句。

Thus, the behavior of an assignment contained within a list assignment depends on the expression or declarator that contains it.

例如，如果中间的赋值是声明语句，这时为单条目赋值，它比逗号和列表赋值有更高的优先级：

For instance, if the internal assignment is a declarator, item assignment is used, which has tighter precedence than both the comma and the list assignment:

```Perl6
my @array;
@array = my $num = 42, "str";   # item assignment: uses declarator 
say @array.perl;                # OUTPUT: «[42, "str"]
» (an Array) 
say $num.perl;                  # OUTPUT: «42
» (a Num) 
```

类似地，如果中间的的赋值是表达式，这个表达式用来初始化声明语句，赋值类型由中间表达式的上下文决定：

Similarly, if the internal assignment is an expression that is being used as an initializer for a declarator, the context of the internal expression determines the assignment type:

```Perl6
my $num;
my @array = $num = 42, "str";    # item assignment: uses expression 
say @array.perl;                 # OUTPUT: «[42, "str"]
» (an Array) 
say $num.perl;                   # OUTPUT: «42
» (a Num) 
 
my ( @foo, $bar );
@foo = ($bar) = 42, "str";       # list assignment: uses parentheses 
say @foo.perl;                   # OUTPUT: «[(42, "str"),]
» (an Array) 
say $bar.perl;                   # OUTPUT: «$(42, "str")
» (a List)# 
```

但是，如果中间的赋值既不是一个声明语句也不是一个表达式，而是更大的表达式中的一部分， 那个更大的表达式的上下文决定了赋值类型：

However, if the internal assignment is neither a declarator nor an expression, but is part of a larger expression, the context of the larger expression determines the assignment type:

```Perl6
my ( @array, $num );
@array = $num = 42, "str";    # list assignment 
say @array.perl;              # OUTPUT: «[42, "str"]
» 
say $num.perl;                # OUTPUT: «42
» 
```

赋值语句被解析为 `@array = (($num = 42), "str")`, 因为单条目赋值比逗号的优先级更高。

The assignment expression is parsed as `@array = (($num = 42), "str")`, because item assignment has tighter precedence than the comma.

更多关于优先级的细节见 [operators](https://docs.perl6.org/language/operators) 。

See [operators](https://docs.perl6.org/language/operators) for more details on precedence.

## [无符号变量(Sigilless variables) ](https://docs.perl6.org/language/variables#___top)

使用 \ 作为前缀，可以生成无标记的变量：

Using the `\` prefix, it's possible to create variables that do not have a sigil:

```Perl6
my \degrees = pi / 180;
my \θ       = 15 * degrees;
```

注意，无标记变量没有关联容器。这意味着上面例子中的degrees 和  `θ` 实际上表示的是 Num。尝试在定义变量后赋值可以详细说明这一点：

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

无标记变量也能用作绑定。更多信息见 [Binding](https://docs.perl6.org/language/containers#Binding) 。

Sigilless variables can also be used for binding. See [Binding](https://docs.perl6.org/language/containers#Binding) for more information.

# [符号（Twigils） ](https://docs.perl6.org/language/variables#___top)

符号影响变量的作用域；但是他们对主标记符是否插值无影响。如果变量 `$a` 内插了， `$^a`, `$*a`, `$=a`, `$?a`, `$.a` 也可以，只取决于 `$`。

Twigils influence the scoping of a variable; however, they have no influence over whether the primary sigil interpolates. That is, if `$a`interpolates, so do `$^a`, `$*a`, `$=a`, `$?a`, `$.a`, etc. It only depends on the `$`.

| Twigil | Scope                                    |
| ------ | ---------------------------------------- |
| !      | Attribute (class member)                 |
| *      | Dynamic                                  |
| .      | Method (not really a variable)           |
| :      | Self-declared formal named parameter     |
| <      | Index into match object (not really a variable) |
| =      | Pod variables                            |
| ?      | Compile-time variable                    |
| ^      | Self-declared formal positional parameter |
| none   | Based only on declarator                 |
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