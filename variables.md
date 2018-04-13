# 变量

Perl 6 中的变量

Variables in Perl 6

变量名字可以（也可以不）以一种叫做标记（ sigil ）的特殊字符开头，后面跟着（可选）叫 twigil 的第二个特殊字符以及识别符（ [identifier](https://docs.perl6.org/language/syntax#Identifiers) ）。变量是值以及容器（  [containers](https://docs.perl6.org/language/containers) ）的符号名称。定义变量或者给变量赋值会直接生成容器。

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
# OUTPUT: «round␤» 
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
say $foo.perl;          # OUTPUT: «5␤» 
 
my @bar = 7, 9;         # list assignment 
say @bar.^name;         # OUTPUT: «Array␤» 
say @bar.perl;          # OUTPUT: «[7, 9]␤» 
 
(my $baz) = 11, 13;     # list assignment 
say $baz.^name;         # OUTPUT: «List␤» 
say $baz.perl;          # OUTPUT: «$(11, 13)␤» 
```

列表赋值中的赋值行为依赖于包含它的表达式或者声明语句。

Thus, the behavior of an assignment contained within a list assignment depends on the expression or declarator that contains it.

例如，如果中间的赋值是声明语句，这时为单条目赋值，它比逗号和列表赋值有更高的优先级：

For instance, if the internal assignment is a declarator, item assignment is used, which has tighter precedence than both the comma and the list assignment:

```Perl6
my @array;
@array = my $num = 42, "str";   # item assignment: uses declarator 
say @array.perl;                # OUTPUT: «[42, "str"]␤» (an Array) 
say $num.perl;                  # OUTPUT: «42␤» (a Num) 
```

类似地，如果中间的的赋值是表达式，这个表达式用来初始化声明语句，赋值类型由中间表达式的上下文决定：

Similarly, if the internal assignment is an expression that is being used as an initializer for a declarator, the context of the internal expression determines the assignment type:

```Perl6
my $num;
my @array = $num = 42, "str";    # item assignment: uses expression 
say @array.perl;                 # OUTPUT: «[42, "str"]␤» (an Array) 
say $num.perl;                   # OUTPUT: «42␤» (a Num) 
 
my ( @foo, $bar );
@foo = ($bar) = 42, "str";       # list assignment: uses parentheses 
say @foo.perl;                   # OUTPUT: «[(42, "str"),]␤» (an Array) 
say $bar.perl;                   # OUTPUT: «$(42, "str")␤» (a List)# 
```

但是，如果中间的赋值既不是一个声明语句也不是一个表达式，而是更大的表达式中的一部分， 那个更大的表达式的上下文决定了赋值类型：

However, if the internal assignment is neither a declarator nor an expression, but is part of a larger expression, the context of the larger expression determines the assignment type:

```
my ( @array, $num );
@array = $num = 42, "str";    # list assignment 
say @array.perl;              # OUTPUT: «[42, "str"]␤» 
say $num.perl;                # OUTPUT: «42␤» 
```

赋值语句被解析为 `@array = (($num = 42), "str")`, 因为单条目赋值比逗号的优先级更高。

The assignment expression is parsed as `@array = (($num = 42), "str")`, because item assignment has tighter precedence than the comma.

更多关于优先级的细节见 [operators](https://docs.perl6.org/language/operators) 。

See [operators](https://docs.perl6.org/language/operators) for more details on precedence.

## [Sigilless variables ](https://docs.perl6.org/language/variables#___top)

使用 \ 作为前缀，可以生成没有标记的变量：

Using the `\` prefix, it's possible to create variables that do not have a sigil:

```
my \degrees = pi / 180;
my \θ       = 15 * degrees;
```

注意，无标记变量没有关联容器。上面例子中的degrees 和  `θ` 实际上表示的是 Num。尝试在定义变量后赋值可以详细说明这一点：

Note that sigilless variable do not have associated [containers](https://docs.perl6.org/language/containers). This means `degrees` and `θ`, above, actually directly represent `Num`s. To illustrate, try assigning to one after you've defined it:

```
θ = 3; # Dies with the error "Cannot modify an immutable Num" 
```

无标记变量不会施加上下文，所以他们能被用来按原样传递一些东西：

Sigilless variables do not enforce context, so they can be used to pass something on as-is:

```
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

## [The `*` Twigil ](https://docs.perl6.org/language/variables#___top)

This twigil is used for dynamic variables which are looked up through the caller's, not through the outer, scope. Look at the example below.

*Note:* So far, if you use rakudo perl6, the example below cannot run correctly in the REPL. Please test it by copy-pasting it into a file, then run the file.

```
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

The first time `&say-all` is called, it prints "`1, 10, 100`" just as one would expect. The second time though, it prints "`1, 11, 101`". This is because `$lexical` isn't looked up in the caller's scope but in the scope `&say-all` was defined in. The two dynamic variables are looked up in the caller's scope and therefore have the values `11` and `101`. The third time `&say-all` is called `$*dynamic1` isn't `11`anymore, but `$*dynamic2` is still `101`. This stems from the fact that we declared a new dynamic variable `$*dynamic1` in the block and did not assign to the old variable as we did with `$*dynamic2`.

The dynamic variables differ from other variable types in that referring to an undeclared dynamic variable is not a compile time error but a runtime [failure](https://docs.perl6.org/type/Failure), so a dynamic variable can be used undeclared as long as it's checked for definedness or used in a boolean context before using it for anything else:

```
sub foo() {
    $*FOO // 'foo';
}
 
say foo; # OUTPUT: «foo␤» 
 
my $*FOO = 'bar';
 
say foo; # OUTPUT: «bar␤» 
```

Dynamic variables can have lexical scope when declared with `my` or package scope when declared with `our`. Dynamic resolution and resolution through symbol tables introduced with `our` are two orthogonal issues.

## [The `?` Twigil ](https://docs.perl6.org/language/variables#___top)

Compile-time variables may be addressed via the `?` twigil. They are known to the compiler and may not be modified after being compiled in. A popular example for this is:

```
say "$?FILE: $?LINE"; # OUTPUT: "hello.pl: 23" 
                      # if this is the line 23 of a 
                      # file named "hello.pl" 
```

For a list of these special variables, see [compile-time variables](https://docs.perl6.org/language/variables#Compile-time_variables).

## [The `!` Twigil ](https://docs.perl6.org/language/variables#___top)

[Attributes](https://docs.perl6.org/language/objects#Attributes) are variables that exist per instance of a class. They may be directly accessed from within the class via `!`:

```
my class Point {
    has $.x;
    has $.y;
 
    method Str() {
        "($!x, $!y)"
    }
}
```

Note how the attributes are declared as `$.x` and `$.y` but are still accessed via `$!x` and `$!y`. This is because in Perl 6 all attributes are private and can be directly accessed within the class by using `$!attribute-name`. Perl 6 may automatically generate accessor methods for you though. For more details on objects, classes and their attributes see [object orientation](https://docs.perl6.org/language/objects).

## [The `.` Twigil ](https://docs.perl6.org/language/variables#___top)

The `.` twigil isn't really for variables at all. In fact, something along the lines of

```
my class Point {
    has $.x;
    has $.y;
 
    method Str() {
        "($.x, $.y)" # note that we use the . instead of ! this time 
    }
}
```

just calls the methods `x` and `y` on `self`, which are automatically generated for you because you used the `.` twigil when the attributes were declared. Note, however, that subclasses may override those methods. If you don't want this to happen, use `$!x` and `$!y` instead.

The fact that the `.` twigil does a method call implies that the following is also possible:

```
class SaySomething {
    method a() { say "a"; }
    method b() { $.a; }
}
 
SaySomething.b; # OUTPUT: «a␤» 
```

For more details on objects, classes and their attributes and methods see [object orientation](https://docs.perl6.org/language/objects).

## [The `^` Twigil ](https://docs.perl6.org/language/variables#___top)

The `^` twigil declares a formal positional parameter to blocks or subroutines. Variables of the form `$^variable` are a type of placeholder variable. They may be used in bare blocks to declare formal parameters to that block. So the block in the code

```
my @powers-of-three = 1,3,9…100;
say reduce { $^b - $^a }, 0, |@powers-of-three;
# OUTPUT: «61␤» 
```

has two formal parameters, namely `$a` and `$b`. Note that even though `$^b` appears before `$^a` in the code, `$^a` is still the first formal parameter to that block. This is because the placeholder variables are sorted in Unicode order. If you have self-declared a parameter using `$^a` once, you may refer to it using only `$a` thereafter.

Although it is possible to use nearly any valid identifier as a placeholder variable, it is recommended to use short names or ones that can be trivially understood in the correct order, to avoid surprise on behalf of the reader.

Normal blocks and subroutines may also make use of placeholder variables but only if they do not have an explicit parameter list.

```
sub say-it    { say $^a; } # valid 
sub say-it()  { say $^a; } # invalid 
              { say $^a; } # valid 
-> $x, $y, $x { say $^a; } # invalid 
```

Placeholder variables cannot have type constraints or a variable name with a single upper-case letter (this is disallowed to enable catching some Perl5-isms).

## [The `:` Twigil ](https://docs.perl6.org/language/variables#___top)

The `:` twigil declares a formal named parameter to a block or subroutine. Variables declared using this form are a type of placeholder variable too. Therefore the same things that apply to variables declared using the `^` twigil also apply here (with the exception that they are not positional and therefore not ordered using Unicode order, of course). So this:

```
say { $:add ?? $^a + $^b !! $^a - $^b }( 4, 5 ) :!add
# OUTPUT: «-1␤» 
```

See [^](https://docs.perl6.org/routine/$CIRCUMFLEX_ACCENT) for more details about placeholder variables.

## [The `=` Twigil ](https://docs.perl6.org/language/variables#___top)

The `=` twigil is used to access Pod variables. Every Pod block in the current file can be accessed via a Pod object, such as `$=data`, `$=SYNOPSIS` or `=UserBlock`. That is: a variable with the same name of the desired block and a `=` twigil.

```
  =begin code
  =begin Foo
  ...
  =end Foo
 
  #after that, $=Foo gives you all Foo-Pod-blocks
  =end code
```

You may access the Pod tree which contains all Pod structures as a hierarchical data structure through `$=pod`.

Note that all those `$=someBlockName` support the `Positional` and the `Associative` roles.

## [The `~` Twigil ](https://docs.perl6.org/language/variables#___top)

The `~` twigil is for referring to sublanguages (called slangs). The following are useful:

| $~MAIN    | the current main language (e.g. Perl statements) |
| --------- | ---------------------------------------- |
| $~Quote   | the current root of quoting language     |
| $~Quasi   | the current root of quasiquoting language |
| $~Regex   | the current root of regex language       |
| $~Trans   | the current root of transliteration language |
| $~P5Regex | the current root of the Perl 5 regex language |

You `augment` these languages in your current lexical scope.

```
use MONKEY-TYPING;
augment slang Regex {  # derive from $~Regex and then modify $~Regex 
    token backslash:std<\Y> { YY };
}
```

# [Variable Declarators and Scope](https://docs.perl6.org/language/variables#___top)

Most of the time it's enough to create a new variable using the `my` keyword:

```
my $amazing-variable = "World";
say "Hello $amazing-variable!"; # OUTPUT: «Hello World!␤» 
```

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

There are also two prefixes that resemble declarators but act on predefined variables:

| Prefix | Effect                                   |
| ------ | ---------------------------------------- |
| temp   | Restores a variable's value at the end of scope |
| let    | Restores a variable's value at the end of scope if the block exits unsuccessfully |

## [The `my` Declarator](https://docs.perl6.org/language/variables#___top)

Declaring a variable with `my` gives it lexical scope. This means it only exists within the current block. For example:

```
{
    my $foo = "bar";
    say $foo; # OUTPUT: «"bar"␤» 
}
say $foo; # Exception! "Variable '$foo' is not declared" 
```

This dies because `$foo` is only defined as long as we are in the same scope.

Additionally, lexical scoping means that variables can be temporarily redefined in a new scope:

```
my $location = "outside";
 
sub outer-location {
    # Not redefined: 
    say $location;
}
 
outer-location; # OUTPUT: «outside␤» 
 
sub in-building {
    my $location = "inside";
    say $location;
}
 
in-building;    # OUTPUT: «inside␤» 
 
outer-location; # OUTPUT: «outside␤» 
```

If a variable has been redefined, any code that referenced the outer variable will continue to reference the outer variable. So here, `&outer-location` still prints the outer `$location`:

```
sub new-location {
    my $location = "nowhere";
    outer-location;
}
 
new-location; # OUTPUT: «outside␤» 
```

To make `new-location()` print `nowhere`, make `$location` a dynamic variable using [the * twigil](https://docs.perl6.org/language/variables#The_%2A_Twigil). This twigil makes the compiler look up the symbol in the calling scope instead of the outer scope after trying the local scope.

`my` is the default scope for subroutines, so `my sub x() {}` and `sub x() {}` do exactly the same thing.

## [The `our` Declarator](https://docs.perl6.org/language/variables#___top)

`our` variables work just like `my` variables, except that they also introduce an alias into the symbol table.

```
module M {
    our $Var;
    # $Var available here 
}
 
# Available as $M::Var here. 
```

## [Declaring a list of variables](https://docs.perl6.org/language/variables#___top)

The declarators `my` and `our` take a list of variables in parentheses as argument to declare more than one variable at a time.

```
my (@a, $s, %h);
```

This can be used in conjunction with [destructuring assignment](undefined). Any assignment to such a list will take the number of elements provided in the left list and assign corresponding values from the right list to them. Any missing elements are left will result in undefined values according to the type of the variables.

```
my (Str $a, Str $b, Int $c) = <a b>;
say [$a, $b, $c].perl;
# OUTPUT: «["a", "b", Int]␤» 
```

To destructure a list into a single value, create a list literal with one element by using `($var,)`. When used with a variable declarator, providing parentheses around a single variable is sufficient.

```
sub f { 1,2,3 };
my ($a) = f;
say $a.perl;
# OUTPUT: «1␤» 
```

To skip elements in the list use the anonymous state variable `$`.

```
my ($,$a,$,%h) = ('a', 'b', [1,2,3], {:1th});
say [$a, %h].perl;
# OUTPUT: «["b", {:th(1)}]␤» 
```

## [The `has` Declarator](https://docs.perl6.org/language/variables#___top)

`has` scopes attributes to instances of a class or role, and methods to classes or roles. `has` is implied for methods, so `has method x() {}` and `method x() {}` do the same thing.

See [object orientation](https://docs.perl6.org/language/objects) for more documentation and some examples.

## [The `anon` Declarator](https://docs.perl6.org/language/variables#___top)

The `anon` declarator prevents a symbol from getting installed in the lexical scope, the method table and everywhere else.

For example, you can use it to declare subroutines which know their own name, but still aren't installed in a scope:

```
my %operations =
    half   => anon sub half($x) { $x / 2 },
    square => anon sub square($x) { $x * $x },
    ;
say %operations<square>.name;       # square 
say %operations<square>(8);         # 64 
```

## [The `state` Declarator](https://docs.perl6.org/language/variables#___top)

`state` declares lexically scoped variables, just like `my`. However, initialization happens exactly once the first time the initialization is encountered in the normal flow of execution. Thus, state variables will retain their value across multiple executions of the enclosing block or routine.

Therefore, the subroutine

```
sub a {
    state @x;
    state $l = 'A';
    @x.push($l++);
};
 
say a for 1..6;
```

will continue to increment `$l` and append it to `@x` each time it is called. So it will output:

```
[A]
[A B]
[A B C]
[A B C D]
[A B C D E]
[A B C D E F]
 
```

This works per "clone" of the containing code object, as in this example:

```
({ state $i = 1; $i++.say; } xx 3).map: {$_(), $_()}; # says 1 then 2 thrice 
```

Note that this is **not** a thread-safe construct when the same clone of the same block is run by multiple threads. Also remember that methods only have one clone per class, not per object.

As with `my`, declaring multiple `state` variables must be placed in parentheses and for declaring a single variable, parentheses may be omitted.

Many operators come with implicit binding which can lead to actions at a distance.

Use `.clone` or coercion to create a new container that can be bound to.

```
my @a;
my @a-cloned;
sub f() {
    state $i;
    $i++;
    @a\      .push: "k$i" => $i;
    @a-cloned.push: "k$i" => $i.clone;
};
 
f for 1..3;
say @a;        # OUTPUT: «[k1 => 3 k2 => 3 k3 => 3]␤» 
say @a-cloned; # OUTPUT: «[k1 => 1 k2 => 2 k3 => 3]␤» 
```

State variables are shared between all threads. The result can be unexpected.

```
sub code(){ state $i = 0; say ++$i; $i };
await
    start { loop { last if code() >= 5 } },
    start { loop { last if code() >= 5 } };
 
# OUTPUT: «1␤2␤3␤4␤4␤3␤5␤» 
# OUTPUT: «2␤1␤3␤4␤5␤» 
# many other more or less odd variations can be produced 
```

### [The `$` Variable ](https://docs.perl6.org/language/variables#___top)

In addition to explicitly declared named state variables, `$` can be used as an anonymous state variable without an explicit `state`declaration.

```
say "1-a 2-b 3-c".subst(:g, /\d/, {<one two three>[$++]});
# OUTPUT: «one-a two-b three-c␤» 
```

Furthermore, state variables can be used outside of subroutines. You could, for example, use `$` in a one-liner to number the lines in a file.

```
perl6 -ne 'say ++$ ~ " $_"' example.txt
```

Each reference to `$` within a lexical scope is in effect a separate variable.

```
perl6 -e '{ say ++$; say $++  } for ^5'
# OUTPUT: «1␤0␤2␤1␤3␤2␤4␤3␤5␤4␤» 
```

If you need to use the value of $ more than once in a scope, it should be copied to a new variable.

```
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
# OUTPUT: «one␤two␤three␤» 
```

Note that the implicit state declarator is only applied to the variable itself, not the expression that may contain an initializer. If the initializer has to be called exactly once, the `state` declarator has to be provided.

```
subset DynInt where $ = ::('Int'); # the initializer will be called for each type check 
subset DynInt where state $ = ::('Int'); # the initializer is called once, this is a proper cache 
```

### [The `@` Variable](https://docs.perl6.org/language/variables#___top)

Similar to the `$` variable, there is also a [Positional](https://docs.perl6.org/type/Positional) anonymous state variable `@`.

```
sub foo($x) {
    say (@).push($x);
}
 
foo($_) for ^3;
 
# OUTPUT: «[0] 
#          [0 1] 
#          [0 1 2]␤» 
```

The `@` here is parenthesized in order to disambiguate the expression from a class member variable named `@.push`. Indexed access doesn't require this disambiguation but you will need to copy the value in order to do anything useful with it.

```
sub foo($x) {
    my $v = @;
    $v[$x] = $x;
    say $v;
}
 
foo($_) for ^3;
 
# OUTPUT: «[0] 
#          [0 1] 
#          [0 1 2]␤» 
```

As with `$`, each mention of `@` in a scope introduces a new anonymous array.

### [The `%` Variable](https://docs.perl6.org/language/variables#___top)

In addition, there's an [Associative](https://docs.perl6.org/type/Associative) anonymous state variable `%`.

```
sub foo($x) {
    say (%).push($x => $x);
}
 
foo($_) for ^3;
 
# OUTPUT: «{0 => 0} 
#          {0 => 0, 1 => 1} 
#          {0 => 0, 1 => 1, 2 => 2}␤» 
```

The same caveat about disambiguation applies. As you may expect, indexed access is also possible (with copying to make it useful).

```
sub foo($x) {
    my $v = %;
    $v{$x} = $x;
    say $v;
}
 
foo($_) for ^3;
 
# OUTPUT: «{0 => 0} 
#          {0 => 0, 1 => 1} 
#          {0 => 0, 1 => 1, 2 => 2}␤» 
```

As with the other anonymous state variables, each mention of `%` within a given scope will effectively introduce a separate variable.

## [The `augment` Declarator](https://docs.perl6.org/language/variables#___top)

With `augment`, you can add attributes and methods to existing classes and grammars, provided you activated the `MONKEY-TYPING`pragma first.

Since classes are usually `our` scoped, and thus global, this means modifying global state, which is strongly discouraged. For almost all situations, there are better solutions.

```
# don't do this 
use MONKEY-TYPING;
augment class Int {
    method is-answer { self == 42 }
}
say 42.is-answer;       # OUTPUT: «True␤» 
```

(In this case, the better solution would be to use a [function](https://docs.perl6.org/language/functions)).

## [The `temp` Prefix](https://docs.perl6.org/language/variables#___top)

Like `my`, `temp` restores the old value of a variable at the end of its scope. However, `temp` does not create a new variable.

```
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
#          </g>␤» 
```

## [The `let` Prefix](https://docs.perl6.org/language/variables#___top)

Restores the previous value if the block exits unsuccessfully. A successful exit means the block returned a defined value or a list.

```
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

In the above case, if the `Bool.pick` returns true, the answer will stay as 84 because the block returns a defined value (`say` returns true). Otherwise the `die` statement will cause the block to exit unsuccessfully, resetting the answer to 42.

# [Type Constraints and Initialization](https://docs.perl6.org/language/variables#___top)

Variables have a type constraint via the [container](https://docs.perl6.org/language/containers) they are bound to, which goes between the declarator and the variable name. The default type constraint is [Mu](https://docs.perl6.org/type/Mu). You can also use the trait [of](https://docs.perl6.org/type/Variable#trait_of) to set a type constraint.

```
my Int $x = 42;
$x = 'a string';
CATCH { default { put .^name, ': ', .Str } }
# OUTPUT: «X::TypeCheck::Assignment: Type check failed in assignment to $x; expected Int but got Str ("a string")␤» 
```

If a scalar variable has a type constraint but no initial value, it's initialized with the type object of the default value of the container it's bound to.

```
my Int $x;
say $x.^name;       # OUTPUT: «Int␤» 
say $x.defined;     # OUTPUT: «False␤» 
```

Scalar variables without an explicit type constraint are typed as [Mu](https://docs.perl6.org/type/Mu) but default to the [Any](https://docs.perl6.org/type/Any) type object.

Variables with the `@` sigil are initialized with an empty [Array](https://docs.perl6.org/type/Array); variables with the `%` sigil are initialized with an empty [Hash](https://docs.perl6.org/type/Hash).

The default value of a variable can be set with the `is default` trait, and re-applied by assigning `Nil` to it:

```
my Real $product is default(1);
say $product;                       # OUTPUT: «1␤» 
$product *= 5;
say $product;                       # OUTPUT: «5␤» 
$product = Nil;
say $product;                       # OUTPUT: «1␤» 
```

## [Default Defined Variables Pragma](https://docs.perl6.org/language/variables#___top)

To force all variables to have a definedness constraint, use the pragma `use variables :D`. The pragma is lexically scoped and can be switched off with `use variables :_`.

```
use variables :D;
my Int $i;
# OUTPUT: «===SORRY!=== Error while compiling <tmp>␤Variable definition of type Int:D (implicit :D by pragma) requires an initializer ... 
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
#          ij*␤» 
```

### [The `$/` Variable](https://docs.perl6.org/language/variables#___top)

`$/` is the match variable. It stores the result of the last [Regex](https://docs.perl6.org/language/regexes) match and so usually contains objects of type [Match](https://docs.perl6.org/type/Match).

```
'abc 12' ~~ /\w+/;  # sets $/ to a Match object 
say $/.Str;         # OUTPUT: «abc␤» 
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
#             textnode => ｢some text｣␤» 
```

#### [Positional Attributes](undefined)

`$/` can have positional attributes if the [Regex](https://docs.perl6.org/language/regexes) had capture-groups in it, which are just formed with parentheses.

```
'abbbbbcdddddeffg' ~~ / a (b+) c (d+ef+) g /;
say $/[0]; # OUTPUT: «｢bbbbb｣␤» 
say $/[1]; # OUTPUT: «｢dddddeff｣␤» 
```

These can also be accessed by the shortcuts `$0`, `$1`, `$2`, etc.

```
say $0; # OUTPUT: «｢bbbbb｣␤» 
say $1; # OUTPUT: «｢dddddeff｣␤» 
```

To get all of the positional attributes, any of `$/.list`, `@$/`, or `@()` can be used.

```
say @().join; # OUTPUT: «bbbbbdddddeff␤» 
```

#### [Named Attributes](undefined)

`$/` can have named attributes if the [Regex](https://docs.perl6.org/language/regexes) had named capture-groups in it, or if the Regex called out to another Regex.

```
'I.... see?' ~~ / \w+ $<punctuation>=[ <-[\w\s]>+ ] \s* $<final-word> = [ \w+ . ] /;
say $/<punctuation>; # OUTPUT: «｢....｣␤» 
say $/<final-word>;  # OUTPUT: «｢see?｣␤» 
```

These can also be accessed by the shortcut `$`.

```
say $<punctuation>; # OUTPUT: «｢....｣␤» 
say $<final-word>;  # OUTPUT: «｢see?｣␤» 
```

To get all of the named attributes, any of `$/.hash`, `%$/`, or `%()` can be used.

```
say %().join;       # OUTPUT: «"punctuation     ....final-word  see?"␤» 
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