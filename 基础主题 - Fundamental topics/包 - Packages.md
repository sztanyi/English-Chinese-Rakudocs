原文：https://docs.raku.org/language/packages

# 包 - Packages

组织和引用命名空间化了的程序元素

Organizing and referencing namespaced program elements

包是命名程序元素的嵌套命名空间。[模组](https://docs.raku.org/language/module-packages)、类、grammar 等都是包的类型。与目录中的文件一样，如果命名元素是本地的，则通常可以使用它们的短名引用它们，也可以引用包含名称空间的较长名称，只要它们的范围允许，就可以消除歧义。

Packages are nested namespaces of named program elements. [Modules](https://docs.raku.org/language/module-packages), classes, grammars, and others are types of packages. Like files in a directory, you can generally refer to named elements with their short-name if they are local, or with the longer name that includes the namespace to disambiguate as long as their scope allows that.

<!-- MarkdownTOC -->

- [名字 / Names](#%E5%90%8D%E5%AD%97--names)
    - [包限定名 / Package-qualified names](#%E5%8C%85%E9%99%90%E5%AE%9A%E5%90%8D--package-qualified-names)
- [伪包 / Pseudo-packages](#%E4%BC%AA%E5%8C%85--pseudo-packages)
- [查名字 / Looking up names](#%E6%9F%A5%E5%90%8D%E5%AD%97--looking-up-names)
    - [名称插值 / Interpolating into names](#%E5%90%8D%E7%A7%B0%E6%8F%92%E5%80%BC--interpolating-into-names)
    - [直接查找 / Direct lookup](#%E7%9B%B4%E6%8E%A5%E6%9F%A5%E6%89%BE--direct-lookup)
    - [包查找 / Package lookup](#%E5%8C%85%E6%9F%A5%E6%89%BE--package-lookup)
    - [类成员查找 / Class member lookup](#%E7%B1%BB%E6%88%90%E5%91%98%E6%9F%A5%E6%89%BE--class-member-lookup)
- [Globals](#globals)

<!-- /MarkdownTOC -->


<a id="%E5%90%8D%E5%AD%97--names"></a>
# 名字 / Names

包*名*与变量名的合法部分（不包括标记）一样。这包括：

A package *name* is anything that is a legal part of a variable name (not counting the sigil). This includes:

```Raku
class Foo {
    sub zape () { say "zipi" }
    class Bar {
        method baz () { return 'Þor is mighty' }
        our &zape = { "zipi" };
        our $quux = 42;
    }
}

my $foo;                # simple identifiers
say Foo::Bar.baz;       # calling a method; OUTPUT: «Þor is mighty␤»
say Foo::Bar::zape;     # compound identifiers separated by ::; OUTPUT: «zipi␤»
my $bar = 'Bar';
say $Foo::($bar)::quux; # compound identifiers with interpolations; OUTPUT: «42␤»
$42;                    # numeric names
$!;                     # certain punctuation variables
```

`::` 用于分隔嵌套的包名。

`::` is used to separate nested package names.

包实际上没有标识；例如，它们可以只是模组或类名的一部分。它们更类似于命名空间，而不是模组；使用同名的模组*捕获*包的标识(如果存在的话)。

Packages do not really have an identity; they can be simply part of a module or class name, for instance. They are more similar to namespaces than to modules; with a module of the same name *capturing* the identity of a package if it exists.

```Raku
package Foo:ver<0> {};
module Foo:ver<1> {};
say Foo.^ver; # OUTPUT: «1␤»
```

语法允许声明的包使用版本号，但事实上，它被取消了；只有模组和类有一个标识，其中可能包括 `auth` 和 `ver`。

The syntax allows the declared package to use a version, but as a matter of fact, it's dismissed; only modules and classes have an identity that might include `auth` and `ver`.

<a id="%E5%8C%85%E9%99%90%E5%AE%9A%E5%90%8D--package-qualified-names"></a>
## 包限定名 / Package-qualified names

普通的包限定名看起来像这样： `$Foo::Bar::quux`，它将是包 `Foo::Bar` 中的 `$quux` 变量；`Foo::Bar::zape` 将代表在同一包内的 `&zape` 变量。

Ordinary package-qualified names look like this: `$Foo::Bar::quux`, which would be the `$quux` variable in package `Foo::Bar`; `Foo::Bar::zape` would represent the `&zape` variable in the same package.

有时候，用变量名来保持标记更清晰，因此编写此代码的另一种方法是：

Sometimes it's clearer to keep the sigil with the variable name, so an alternate way to write this is:

```Raku
Foo::Bar::<$quux>
```

这不适用于 `Foo«&zape»` 变量，因为在默认情况下，`sub` 有词法范围。该名称是在编译时解析的，因为这个变量名是常量。我们可以访问 `Bar` 中的其余变量（如上例所示），因为类在默认情况下具有包作用域。

This does not work with the `Foo«&zape»` variable, since `sub`s, by default, have lexical scope. The name is resolved at compile time because the variable name is a constant. We can access the rest of the variables in `Bar` (as shown in the example above) since classes, by default, have package scope.

如果 `::` 前面的名称部分为 null，则表示包未指定，必须搜索。通常，这意味着主标记后面的第一个 `::` 是编译时已知的对名称的空指令，不过 `::()` 也可以用来引入插值。此外，在没有其他信号的情况下，`::` 可以作为自己的标记，表示有意使用尚未声明的包名。

If the name part before `::` is null, it means the package is unspecified and must be searched for. Generally this means that an initial `::` following the main sigil is a no-op on names that are known at compile time, though `::()` can also be used to introduce an interpolation. Also, in the absence of another sigil, `::` can serve as its own sigil indicating intentional use of a not-yet-declared package name.

<a id="%E4%BC%AA%E5%8C%85--pseudo-packages"></a>
# 伪包 / Pseudo-packages

下列伪包名称是名称的前面部分的保留字：

The following pseudo-package names are reserved at the front of a name:

| MY        | Symbols in the current lexical scope (aka $?SCOPE)           |
| --------- | ------------------------------------------------------------ |
| OUR       | Symbols in the current package (aka $?PACKAGE)               |
| CORE      | Outermost lexical scope, definition of standard Raku         |
| GLOBAL    | Interpreter-wide package symbols, really UNIT::GLOBAL        |
| PROCESS   | Process-related globals (superglobals). The last place dynamic variable lookup will look. |
| COMPILING | Lexical symbols in the scope being compiled                  |

下列相对名称也被保留，但可以在名称中的任何地方使用：

The following relative names are also reserved but may be used anywhere in a name:

| CALLER  | Dynamic symbols in the immediate caller's lexical scope     |
| ------- | ----------------------------------------------------------- |
| CALLERS | Dynamic symbols in any caller's lexical scope               |
| DYNAMIC | Dynamic symbols in my or any caller's lexical scope         |
| OUTER   | Symbols in the next outer lexical scope                     |
| OUTERS  | Symbols in any outer lexical scope                          |
| LEXICAL | Dynamic symbols in my or any outer's lexical scope          |
| UNIT    | Symbols in the outermost lexical scope of compilation unit  |
| SETTING | Lexical symbols in the unit's DSL (usually CORE)            |
| PARENT  | Symbols in this package's parent package (or lexical scope) |
| CLIENT  | The nearest CALLER that comes from a different package      |

文件的作用域称为 `UNIT`，但在与语言设置相对应的范围之外有一个或多个词法作用域（在其他文化中通常称为前奏）。因此，`SETTING` 范围相当于 `UNIT::OUTERS`。对于标准 Raku 程序，`SETTING` 与 `CORE` 相同，但各种启动选项（例如 `-n` 或 `-p`）可以将你放入特定于域的语言中，在这种情况下，`CORE` 仍然是标准语言的作用域，而 `SETTING` 则表示定义 DSL 的作用域，作为当前文件的设置  。当用作名称中间的搜索词时，`SETTING` 包括它的所有外部作用域，直至 `CORE`。要获取*仅*设置的最外层作用域，请使用 `UNIT::OUTER`。

The file's scope is known as `UNIT`, but there are one or more lexical scopes outside of that corresponding to the linguistic setting (often known as the prelude in other cultures). Hence, the `SETTING` scope is equivalent to `UNIT::OUTERS`. For a standard Raku program `SETTING` is the same as `CORE`, but various startup options (such as `-n` or `-p`) can put you into a domain specific language, in which case `CORE` remains the scope of the standard language, while `SETTING` represents the scope defining the DSL that functions as the setting of the current file. When used as a search term in the middle of a name, `SETTING` includes all its outer scopes up to `CORE`. To get *only* the setting's outermost scope, use `UNIT::OUTER` instead.

<a id="%E6%9F%A5%E5%90%8D%E5%AD%97--looking-up-names"></a>
# 查名字 / Looking up names

<a id="%E5%90%8D%E7%A7%B0%E6%8F%92%E5%80%BC--interpolating-into-names"></a>
## 名称插值 / Interpolating into names

你可以使用 `::($expr)` 将字符串[插值](https://docs.raku.org/language/packages#Interpolating)到包或变量名中，那个位置通常放置包或变量名。字符串允许包含 `::` 的其他实例，这将被解释为包嵌套。你只能插值全名，因为构造以 `::` 开头，或者直接结束，或者在括号外用另一个 `::` 继续。大多数符号引用都是用这个符号来完成的：

You may [interpolate](https://docs.raku.org/language/packages#Interpolating) a string into a package or variable name using `::($expr)` where you'd ordinarily put a package or variable name. The string is allowed to contain additional instances of `::`, which will be interpreted as package nesting. You may only interpolate entire names, since the construct starts with `::`, and either ends immediately or is continued with another `::` outside the parentheses. Most symbolic references are done with this notation:

```Raku
my $foo = "Foo";
my $bar = "Bar";
my $foobar = "Foo::Bar";
$::($bar)              # lexically-scoped $Bar
$::("MY::$bar")        # lexically-scoped $Bar
$::("OUR::$bar")       # package-scoped $Bar
$::("GLOBAL::$bar")    # global $Bar
$::("PROCESS::$bar")   # process $Bar
$::("PARENT::$bar")    # current package's parent's $Bar
$::($foobar)           # $Foo::Bar
@::($foobar)::baz      # @Foo::Bar::baz
@::($foo)::Bar::baz    # @Bar::Bar::baz
@::($foobar)baz        # ILLEGAL at compile time (no operator baz)
@::($foo)::($bar)::baz # @Foo::Bar::baz
```

`::` 开头并不意味着是全局的；在这里，作为插值语法的一部分，它甚至不意味着包。在对 `::()` 组件进行插值之后，对间接名称的查找与原始源代码中的名称完全相同，优先顺序首先是引导伪包名称，然后是词法作用域中的名称(向外搜索范围，以`CORE’结尾)。最后搜索当前包。

An initial `::` doesn't imply global; here as part of the interpolation syntax it doesn't even imply package. After the interpolation of the `::()` component, the indirect name is looked up exactly as if it had been there in the original source code, with priority given first to leading pseudo-package names, then to names in the lexical scope (searching scopes outwards, ending at `CORE`). The current package is searched last.

使用 `MY` 伪包装限制对当前词法作用域的查找，并使用 `OUR` 将作用域限制在当前包范围内。

Use the `MY` pseudopackage to limit the lookup to the current lexical scope, and `OUR` to limit the scopes to the current package scope.

同样，还可以插入类名和方法名：

In the same vein, class and method names can be interpolated too:

```Raku
role with-method {
    method a-method { return 'in-a-method of ' ~ $?CLASS.^name  };
}

class a-class does with-method {
    method another-method { return 'in-another-method' };
}

class b-class does with-method {};

my $what-class = 'a-class';

say ::($what-class).a-method; # OUTPUT: «in-a-method of a-class␤»
$what-class = 'b-class';
say ::($what-class).a-method; # OUTPUT: «in-a-method of b-class␤»

my $what-method = 'a-method';
say a-class."$what-method"(); # OUTPUT: «in-a-method of a-class␤»
$what-method = 'another-method';
say a-class."$what-method"(); # OUTPUT: «in-another-method␤»
```

<a id="%E7%9B%B4%E6%8E%A5%E6%9F%A5%E6%89%BE--direct-lookup"></a>
## 直接查找 / Direct lookup

要在不扫描的程序包的符号表中执行直接查找，请将包名视为哈希：

To do direct lookup in a package's symbol table without scanning, treat the package name as a hash:

```Raku
Foo::Bar::{'&baz'}  # same as &Foo::Bar::baz
PROCESS::<$IN>      # same as $*IN
Foo::<::Bar><::Baz> # same as Foo::Bar::Baz
```

与 `::()` 符号引用不同，它不解析 `::` 的参数，也不从初始点开始名称空间扫描。此外，对于常量下标，保证在编译时解析符号。

Unlike `::()` symbolic references, this does not parse the argument for `::`, nor does it initiate a namespace scan from that initial point. In addition, for constant subscripts, it is guaranteed to resolve the symbol at compile time.

null 伪包与普通名称搜索是相同的搜索列表。也就是说，以下所有内容在含义上都是相同的：

The null pseudo-package is the same search list as an ordinary name search. That is, the following are all identical in meaning:

```Raku
$foo
::{'$foo'}
::<$foo>
```

它们中的每一个都向外扫描词法作用域，然后扫描当前的包作用域（尽管在 "strict" 生效时不允许使用包作用域）。

Each of them scans the lexical scopes outward, and then the current package scope (though the package scope is then disallowed when "strict" is in effect).

<a id="%E5%8C%85%E6%9F%A5%E6%89%BE--package-lookup"></a>
## 包查找 / Package lookup

将包对象本身下标为散列对象，其键为变量名，包括任何标记。包对象可以通过使用 `::` 后缀从类型名称派生出来：

Subscript the package object itself as a hash object, the key of which is the variable name, including any sigil. The package object can be derived from a type name by use of the `::` postfix:

```Raku
MyType::<$foo>
```

<a id="%E7%B1%BB%E6%88%90%E5%91%98%E6%9F%A5%E6%89%BE--class-member-lookup"></a>
## 类成员查找 / Class member lookup

方法-包括自动生成的方法，例如公共属性的访问器-存储在类元对象中，并可以通过 [lookup](https://docs.raku.org/routine/lookup) 方法进行查找。

Methods—including auto-generated methods, such as public attributes' accessors—are stored in the class metaobject and can be looked up through by the [lookup](https://docs.raku.org/routine/lookup) method.

```Raku
Str.^lookup('chars')
```

<a id="globals"></a>
# Globals

解释器全局符号存在于 `GLOBAL` 包中。用户的程序在 `GLOBAL` 包中启动，因此主程序代码中的 "our" 声明默认进入该包。过程范围内的变量存在于 `PROCESS` 包中。大多数预定义的全局符号（如 `$*UID` 和 `$*PID`）实际上都是进程全局符号。

Interpreter globals live in the `GLOBAL` package. The user's program starts in the `GLOBAL` package, so "our" declarations in the mainline code go into that package by default. Process-wide variables live in the `PROCESS` package. Most predefined globals such as `$*UID` and `$*PID` are actually process globals.
