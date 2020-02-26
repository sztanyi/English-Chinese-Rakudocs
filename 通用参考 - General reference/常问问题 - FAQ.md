原文：https://docs.raku.org/language/faq

# 常问问题 / FAQ

关于 Raku 的常问问题

Frequently asked questions about Raku

# 一般问题 / General

## Raku、 Rakudo 和 Perl 6 的区别是什么? / What's the difference between Raku, Rakudo and Perl 6?

正确地说，[Rakudo](https://rakudo.org/) 是 Raku 的一种实现.它是目前正在开发的，但是过去已经有了其他的实现，将来可能还会有其他的实现。Raku 是语言的定义。在谈论当前的解释器时，Rakudo 和 Raku 可以互换使用。“Perl6” 是 2019 年 10 月前用于 “Raku” 的名称。

Properly speaking, [Rakudo](https://rakudo.org/) is an implementation of Raku. It's currently the one that's being developed, but there have been other implementations in the past and there will likely be others in the future. Raku is the definition of the language. When talking about the current interpreter, Rakudo and Raku can be used interchangeably. "Perl 6" is the name that was used for "Raku" before October 2019.

## Raku 是什么时候发布的？ / 发布时间 When was Raku released?

Rakudo 2015.12 实现版本于 2015 年 12 月 25 日发布。

The Rakudo 2015.12 implementation version was released on December 25th 2015.

## 是否有 Raku 版本 6.0.0？ / Is there a Raku version 6.0.0?

没有。第一个稳定的语言规范版本是 v6.c（“Christmas”）。语言规范的未来版本可能有小版本（例如，v6.d.2）或主版本（例如，v6.e）。

No. The first stable language specification version is v6.c ("Christmas"). Future versions of the spec may have point releases (e.g., v6.d.2) or major releases (e.g., v6.e).

运行 `perl6 -v` 将显示编译器实现的语言版本：

Running `perl6 -v` will display the language version your compiler implements:

```Raku
$ perl6 -v
This is Rakudo version 2017.07 built on MoarVM version 2017.07
implementing Raku.c.
```

## v6.d 是在什么时候发布的？ / When was v6.d released?

该 v6.d 规范是在[排灯节 2018](https://en.wikipedia.org/wiki/Diwali)上发布的，这是 2018 年 11 月 6 日至 7 日，在一个方便的时区。在 2018.11 的 Rakudo 编译器版本中默认启用了 6.d。

The v6.d Specification was released on [Diwali 2018](https://en.wikipedia.org/wiki/Diwali), which was November 6–7 2018, in a convenient time zone. 6.d was enabled by default in the Rakudo compiler release of 2018.11.

绝大多数的 6.d 功能已经在 Rakudo 编译器中实现并可用，而不需要任何特殊的杂种，因为它们与 6.c 规范不冲突。如果文件顶部有 `use v6.d` 指令，则自动提供一小组的功能和行为。其余的大约 3100 个新提交的语言规范只是澄清以前未定义的行为。

The vast majority of 6.d features were already implemented and available in the Rakudo compiler without requiring any special pragmas, as they did not conflict with the 6.c specification. A smaller set of features and behaviors is available automatically if you have the `use v6.d` pragma at the top of the file. The rest of about 3100 new commits to the language specification simply clarify previously undefined behavior.

## 作为一个 Raku 用户，我应该安装什么？ / As a Raku user, what should I install?

Mac 用户可以从 <https://rakudo.org/downloads/star> 下载使用在最新的 Rakudo Star DMG 二进制安装器

Mac users can use the latest Rakudo Star DMG binary installer at <https://rakudo.org/downloads/star>

Windows 用户可以使用 Rakudo Star MSI 二进制安装程序.您将需要 Windows Git 和 Strawberry Perl 5 使用 zef 安装库模块。

Windows users can use the Rakudo Star MSI binary installer. You will need Windows Git and Strawberry Perl 5 to use zef to install library modules.

Linux 用户可能想下载 Rakudo Star，并按照在 <https://www.raku.org/downloads/> 的编译说明操作。

Linux users probably want to download Rakudo Star and follow the compilation instructions at <https://www.raku.org/downloads/>.

应该有 Linux 和 Mac 二进制文件可以从供应商和第三方获得，尽管供应商版本可能已经过时。应避免 2015.12 Rakudo 之前发布的版本。

There should be Linux and Mac binaries available from vendors and third parties, although vendor versions may be outdated. Versions before Rakudo release of 2015.12 should be avoided.

官方 Rakudo Star docker镜像在 <https://hub.docker.com/_/rakudo-star/>

There's an official Rakudo Star docker image at <https://hub.docker.com/_/rakudo-star/>

## 作为一个高级用户，我想跟踪 Rakudo 的发展。 / As an advanced user I want to track Rakudo development.

一种选择是克隆[存储库](https://github.com/rakudo/rakudo)并构建它。这将安装正在进行的工作，这是最小的测试，并可能包含严重的错误。如果您有兴趣为 Rakudo Raku 编译器做贡献，您可能会发现 [Z-Script 帮助工具](https://github.com/zoffixznet/z)很有用。

An option is to clone [the repository](https://github.com/rakudo/rakudo) and build it. This will install work in progress which is minimally-tested and may contain severe bugs. If you're interested in contributing to the Rakudo Raku compiler, you may find the [Z-Script helper tool](https://github.com/zoffixznet/z) useful.

若要安装最后一个正式的每月版本，请查看在 <https://raw.githubusercontent.com/rakudo/rakudo/master/VERSION> 的标记或设置[助手命令](https://github.com/zoffixznet/r#table-of-contents)。

To install the last official monthly release, check out the tag visible at <https://raw.githubusercontent.com/rakudo/rakudo/master/VERSION> or set up [a helper command](https://github.com/zoffixznet/r#table-of-contents).

一些用户选择使用 [rakudobrew](https://github.com/tadzik/rakudobrew)，它允许安装多个版本的 rakudo。一定要[阅读它的文档](https://github.com/tadzik/rakudobrew#making-new-scripts-available)。

Some users choose to use [rakudobrew](https://github.com/tadzik/rakudobrew), which allows installation of multiple versions of rakudo. Be sure to [read its documentation](https://github.com/tadzik/rakudobrew#making-new-scripts-available).

在这两种情况下，您可能还需要从[生态系统](https://modules.raku.org/) 中安装 [`zef`](https://modules.raku.org/dist/zef:github) 和 [`p6doc`](https://modules.raku.org/dist/p6doc:github)。

In either case you will probably need to also install [`zef`](https://modules.raku.org/dist/zef:github) and [`p6doc`](https://modules.raku.org/dist/p6doc:github) from the [ecosystem](https://modules.raku.org/).

## 哪里可以找到有关 Raku 的好文档？ / Where can I find good documentation on Raku?

请参阅[官方文献网站](https://docs.raku.org/)（特别是其[“语言”部分](https://docs.raku.org/language)）以及[参考资料页](https://raku.org/resources/)。你也可以参考这个[备忘单]（https://htmlpreview.github.io/?https://github.com/perl6/mu/blob/master/docs/Perl6/Cheatsheet/cheatsheet.html）.

See [the official documentation website](https://docs.raku.org/) (especially its ["Language" section](https://docs.raku.org/language)) as well as the [Resources page](https://raku.org/resources/). You can also consult this [great cheatsheet](https://htmlpreview.github.io/?https://github.com/perl6/mu/blob/master/docs/Perl6/Cheatsheet/cheatsheet.html).

[perl6book.com](https://perl6book.com/) 包含电子书的列表。

[perl6book.com](https://perl6book.com/) contains a list of dead tree and electronic books.

阅读第三方文章时要注意出版日期。在 2015 年 12 月之前发表的任何东西都可能描述了 Raku 的预发布版。

Be mindful of publication dates when reading third-party articles. Anything published before December, 2015 likely describes a pre-release version of Raku.

你总是可以[在我们的帮助聊天中从一个活人那里得到帮助](https://webchat.freenode.net/?channels=#raku)或[搜索聊天日志](https://colabti.org/irclogger/irclogger_log_search/raku)找到以前的对话和讨论。

You can always [get help from a live human in our help chat](https://webchat.freenode.net/?channels=#raku) or [search the chat logs](https://colabti.org/irclogger/irclogger_log_search/raku) to find previous conversations and discussions.

## 我能买些关于 Raku 的书吗 / Can I get some books about Raku?

这里有一些书，按字母顺序排列：

Here are some available books, in alphabetical order:

- [Learning Raku](https://www.learningperl6.com/), by brian d foy
- [Learning to program with Raku: First Steps](https://www.amazon.com/gp/product/B07221XCVL), by JJ Merelo
- [Metagenomics](https://www.gitbook.com/book/kyclark/metagenomics/details), by Ken Youens-Clark
- [Parsing with Perl 6 Regexes and Grammars](https://smile.amazon.com/dp/1484232275/), by Moritz Lenz
- [Perl 6 at a Glance](https://deeptext.media/perl6-at-a-glance/), by Andrew Shitov
- [Perl 6 Fundamentals](https://www.apress.com/us/book/9781484228982), by Moritz Lenz
- [Perl 6 Deep Dive](https://www.packtpub.com/application-development/perl-6-deep-dive), by Andrew Shitov
- [Think Perl 6: How to Think Like a Computer Scientist](https://greenteapress.com/wp/think-perl-6/), by Laurent Rosenfeld.

已出版或正在出版的书籍清单载于 [`raku.org`](https://raku.org/resources/)。

A list of books published or in progress is maintained in [`raku.org`](https://raku.org/resources/).

## Raku 的技术规范是什么？ / What is the Raku specification?

规范中指的是 Raku 的官方测试套件。它被称为 [`roast`](https://github.com/perl6/roast)，并在 GitHub 上托管。任何通过测试的编译器都被认为实现了那个版本的 Raku 规范。

The specification refers to the official test suite for Raku. It's called [`roast`](https://github.com/perl6/roast) and is hosted on github. Any compiler that passes the tests is deemed to implement that version of the Raku specification.

Roast 的 `master` 分支与最新的发展相对应，这还不一定是任何规范的一部分。其他分支对应于特定的版本；例如，“6.c-errata”。

Roast's `master` branch corresponds to the latest development that isn't necessarily part of any specification yet. Other branches correspond to specific versions; for example, "6.c-errata".

因此，`6.c-errata` 是一个已发布的语言版本，除了修复测试中的错误（“errata”）外，我们不会更改，而 master 是未发布的正在进行的工作，可能成为下一个语言版本。它目前的状态不一定是下一个语言版本的行为的规定，因为新的添加将被审查，以纳入版本。

So `6.c-errata` is a released language version we don't change other than to fix errors in tests (the "errata") whereas master is the unreleased work-in-progress that may become the next language version. Its current state is not necessarily prescriptive of the next language version's behavior since new additions will be reviewed for inclusion into the release.

## Is there a glossary of Raku related terms? / 是否有与 Raku 相关的术语表？

有，见 [glossary](https://docs.raku.org/language/glossary)。

Yes, see [glossary](https://docs.raku.org/language/glossary).

## I'm a Perl 5 programmer. Where is a list of differences between Perl 5 and Raku?

There are several *Perl 5 to Raku* guides in the [Language section of the documentation](https://docs.raku.org/language), most notable of which is the [Overview](https://docs.raku.org/language/5to6-nutshell).

## I'm a Ruby programmer looking for quickstart type docs?

See the [rb-nutshell](https://docs.raku.org/language/rb-nutshell) guide.

# Modules

## Is there a CPAN (repository of third party library modules) for Raku?

Yes, it's the same [CPAN](https://cpan.org/) as for Perl 5! The only difference is when using [PAUSE](https://pause.perl.org/) to upload the module, the uploaded modules shows up on [modules.raku.org](https://modules.raku.org/) instead of [MetaCPAN](https://metacpan.org/). The [`App::Mi6` tool](https://modules.raku.org/l/App::Mi6) can simplify the uploading process. The [`zef` module installer](https://github.com/ugexe/zef) automatically check for latest versions of a module on CPAN as well as our [GitHub-based ecosystem](https://github.com/perl6/ecosystem/).

## Is there a perldoc (command line documentation viewer) for Raku?

Yes, it's called `p6doc` and is present in the ecosystem under that name. It comes bundled in with Rakudo Star but needs to be manually installed with `zef` if you are using a Rakudo monthly release.

## Can I use Perl 5 modules from Raku?

Yes, with [Inline::Perl5](https://github.com/niner/Inline-Perl5/), which works well with most Perl 5 modules. It can even run Perl 5 Catalyst and DBI.

## Can I use C and C++ from Raku?

[Nativecall](https://docs.raku.org/language/nativecall) makes this particularly easy.

## Nativecall can't find `libfoo.so` and I only have `libfoo.so.1.2`!

In most Linux systems, shared libraries will be installed in such a way that, for a specific `libfoo`, there will be a `libfoo.so.x.y.z` real file, and then a set of symlinks `libfoo.so` and `libfoo.so.x`. for instance, `ls /usr/local/lib/libxxhash.so*` returns:

```Raku
/usr/local/lib/libxxhash.so -> libxxhash.so.0.6.5
/usr/local/lib/libxxhash.so.0 -> libxxhash.so.0.6.5
/usr/local/lib/libxxhash.so.0.6.5
```

In general, installing a `libfoo-dev` or `libfoo-devel` (depending on the distro) in Linux will install the shared library *and* set up those symlinks for you. But in some cases, you will only have, as in the question, `libfoo.so.1.2`.

In that case, just use the version of `is native` that explicitly sets the ABI/API version, as indicated in [the manual](https://docs.raku.org/language/nativecall#ABI/API_version):

```Raku
sub call-foo() is native('foo',v1.2);
```

## Where have all the traditional UNIX library functions gone?

It's fairly easy to use [NativeCall](https://docs.raku.org/language/nativecall) to access them.

An ecosystem module [POSIX](https://github.com/cspencer/perl6-posix) is also available.

## Does Rakudo have a core standard library?

[Rakudo Star distribution](https://rakudo.raku.org/downloads/) does come with [many useful modules](https://github.com/rakudo/star/tree/master/modules).

Rakudo compiler-only release includes [only a couple of the most basic modules](https://docs.raku.org/language/modules-core).

Many more modules can be found in the [ecosystem](https://modules.raku.org/).

## Is there something like `B::Deparse`/How can I get hold of the AST?

Use `--target=optimize` command line option to view the AST of your program, e.g., `perl6 --target=optimize -e 'say "hi"'`

The target `optimize` gives the AST after the static optimizer does its job, while target `ast` gives the AST before that step. To get the full list of available targets, run `perl6 --stagestats -e ""`

## What is precompilation?

When you load a module for the first time, Rakudo compiles it into bytecode. Then, Rakudo both stores the compiled bytecode on disk and uses it, because that tends to be significantly faster.

## Can I have circular dependencies between modules?

No, you can't have circular dependencies, and you should get a `Circular module loading detected` error if you have them between your modules.

Very likely you can accomplish what you are trying to do using [roles](https://docs.raku.org/language/objects#Roles). Instead of `A.pm6` depending on `B.pm6` and `B.pm6` depending on `A.pm6`, you can have `A-Role.pm6` and `B-Role.pm6` and classes in `A.pm6` and `B.pm6` implementing these roles respectively. Then you can depend on `A-Role.pm6` and `B-Role.pm6` without the need for the circular dependency.

One of the reasons why circular dependencies do not work in Raku is one pass parsing. We have to know what A means when we parse B, and we have to know what B means when we parse A, which is clearly an infinite loop.

Note that Raku has no “1 file = 1 class” limitation, and circular dependencies within a single compilation unit (e.g., file) are possible through stubbing. Therefore another possible solution is to move classes into the same compilation unit.

# Language features

## How can I dump Raku data structures (like Perl 5 Data::Dumper and similar)?

Typical options are to use the [say](https://docs.raku.org/routine/say) routine that uses the [gist](https://docs.raku.org/routine/gist) method which gives the "gist" of the object being dumped. More detailed output can be obtained by calling the [perl](https://docs.raku.org/routine/perl) method (soon to be deprecated in favor of `$obj.raku`, available since the Rakudo 2019.11 release) that typically returns an object's representation in [EVAL](https://docs.raku.org/routine/EVAL)-able code.

If you're using the [rakudo](https://rakudo.org/) implementation, you can use the [rakudo-specific `dd` routine](https://docs.raku.org/programs/01-debugging#Dumper_function_dd) for dumping, whose output is similar to [perl](https://docs.raku.org/routine/perl), but with more information.

Examples:

```Raku
my $foo = %( foo => 'bar' );
say $foo.perl;   # OUTPUT: «${:foo("bar")}␤» 
say $foo;        # OUTPUT: «{foo => bar}␤» 
 
# non-standard routine available in rakudo implementation: 
dd $foo;         # OUTPUT: «Hash $foo = ${:foo("bar")}␤» 
```

There are also [several ecosystem modules](https://modules.raku.org/s/dump) that provide more control over how data structures are dumped, including support for colored output.

## How can I get command line history in the Raku prompt (REPL)?

Install [Linenoise](https://github.com/hoelzro/p6-linenoise/) from the ecosystem.

An alternative for UNIX-like systems is to install `rlwrap`. This can be done on Debian-ish systems by running:

```Raku
sudo apt-get install rlwrap
```

## Why is the Rakudo compiler so apologetic?

If SORRY! is present in the output, the error is a compile time error. Otherwise, it's a runtime error.

Example:

```Raku
sub foo( Int $a, Int $b ) {...}
foo(1)     # ===SORRY!=== Error while compiling ... 
say 1/0;   # Attempt to divide 1 by zero using div 
```

## What is `(Any)`?

[`Any`](https://docs.raku.org/type/Any) is a top level class most objects inherit from. The `Any` type object is [the default value](https://docs.raku.org/type/Attribute#Trait_is_default) on variables and parameters without an explicit type constraint, which means you'll likely see `(Any)` printed when you output a [gist](https://docs.raku.org/routine/gist) of a variable without any value by using, for instance, the [`say` routine](https://docs.raku.org/routine/say):

```Raku
my $foo;
say $foo; # OUTPUT: «(Any)␤» 
 
my Int $baz;
say $baz; # OUTPUT: «(Int)␤» 
 
my $bar = 70;
say $bar; # OUTPUT: «70␤» 
```

To test whether a variable has any defined values, see [DEFINITE](https://docs.raku.org/language/classtut#index-entry-.DEFINITE) and [defined](https://docs.raku.org/routine/defined) routines. Several other constructs exist that test for definiteness, such as [`with`, `orwith`, and `without`](https://docs.raku.org/syntax/with%20orwith%20without) statements, [`//`](https://docs.raku.org/routine/$SOLIDUS$SOLIDUS), [andthen](https://docs.raku.org/routine/andthen), [notandthen](https://docs.raku.org/routine/notandthen), and [orelse](https://docs.raku.org/routine/orelse) operators, as well as [type constraint smileys](https://docs.raku.org/type/Signature#Constraining_defined_and_undefined_values).

## What is `so`?

`so` is a loose precedence operator that coerces to [Bool](https://docs.raku.org/type/Bool).

It has the same semantics as the `?` prefix operator, just like `and` is the low-precedence version of `&&`.

Example:

```Raku
say so 1|2 == 2;    # OUTPUT: «True␤» 
```

In this example, the result of the comparison (which is a [Junction](https://docs.raku.org/type/Junction)), is converted to Bool before being printed.

## What are those `:D` and `:U` things in signatures?

In Raku, classes and other types are objects and pass type checks of their own type.

For example, if you declare a variable

```Raku
my Int $x = 42;
```

then not only can you assign integers (that is, instances of class Int) to it, but the `Int` type object itself:

```Raku
$x = Int
```

If you want to exclude type objects, you can append the `:D` type smiley, which stands for "definite":

```Raku
my Int:D $x = 42;
$x = Int;
 
# dies with: 
# Type check failed in assignment to $x; 
# expected Int:D but got Int 
```

Likewise, `:U` constrains to undefined values, that is, type objects.

To explicitly allow either type objects or instances, you can use `:_`.

## What is the `-->` thing in the signature?

[-->](https://docs.raku.org/type/Signature#Constraining_return_types) is a return constraint, either a type or a definite value.

Example of a type constraint:

```Raku
sub divide-to-int( Int $a, Int $b --> Int ) {
        return ($a / $b).narrow;
}
 
divide-to-int(3, 2)
# Type check failed for return value; expected Int but got Rat 
```

Example of a definite return value:

```Raku
sub discard-random-number( --> 42 ) { rand }
say discard-random-number;
# OUTPUT: «42␤» 
```

In this case, the final value is thrown away because the return value is already specified in the signature.

## How can I extract the values from a Junction?

If you want to extract the values (eigenstates) from a [Junction](https://docs.raku.org/type/Junction), you are probably doing something wrong and should be using a [Set](https://docs.raku.org/type/Set) instead.

Junctions are meant as matchers, not for doing algebra with them.

If you want to do it anyway, you can abuse autothreading for that:

```Raku
sub eigenstates(Mu $j) {
    my @states;
    -> Any $s { @states.push: $s }.($j);
    @states;
}
 
say eigenstates(1|2|3).join(', ');
# prints 1, 2, 3 or a permutation thereof 
```

## If Str is immutable, how does `s///` work? If Int is immutable, how does `$i++` work?

In Raku, values of many basic types are immutable, but the variables holding them are not. The `s///` operator works on a variable, into which it puts a newly created string object. Likewise, `$i++` works on the `$i` variable, not just on the value in it.

Knowing this, you would not try to change a literal string (e.g. like `'hello' ~~ s/h/H/;`), but you might accidentally do something equivalent using `map` as follows.

```Raku
my @foo = <hello world>.map: { s/h/H/ };
 
# dies with 
# Cannot modify an immutable Str (hello) 
 
my @bar = <hello world>».subst-mutate: 'h', 'H';
 
# dies with 
# Cannot resolve caller subst-mutate(Str: Str, Str); 
# the following candidates match the type but require 
# mutable arguments: ... 
```

Instead of modifying the original value in place, use a routine or operator that returns a new value:

```Raku
my @foo = <hello world>.map: { S/h/H/ };  # ['Hello','world'] 
my @bar = <hello world>».subst: 'h', 'H'; # ['Hello','world'] 
```

See the documentation on [containers](https://docs.raku.org/language/containers) for more information.

## What's up with array references and automatic dereferencing? Do I need the `@` sigil?

In Raku, nearly everything is a reference, so talking about taking references doesn't make much sense. Scalar variables can also contain arrays directly:

```Raku
my @a = 1, 2, 3;
say @a;                 # OUTPUT: «[1 2 3]␤» 
say @a.^name;           # OUTPUT: «Array␤» 
 
my $scalar = @a;
say $scalar;            # OUTPUT: «[1 2 3]␤» 
say $scalar.^name;      # OUTPUT: «Array␤» 
```

The big difference is that arrays inside a scalar act as one value in list context, whereas arrays will be happily iterated over.

```Raku
my @a = 1, 2, 3;
my $s = @a;
 
for @a { ... }          # loop body executed 3 times 
for $s { ... }          # loop body executed only once 
 
my @flat = flat @a, @a;
say @flat.elems;            # OUTPUT: «6␤» 
 
my @nested = flat $s, $s;
say @nested.elems;          # OUTPUT: «2␤» 
```

You can force list context with `@( ... )` or by calling the `.list` method on an expression, and item context with `$( ... )` or by calling the `.item` method on an expression.

See the [*Perl 6: Sigils, Variables, and Containers*](https://perl6advent.wordpress.com/2017/12/02/) article to learn more.

## Why sigils? Couldn't you do without them?

There are several reasons:

- they make it easy to interpolate variables into strings
- they form micro-namespaces for different variables and twigils, thus avoiding name clashes
- they allow easy single/plural distinction
- they work like natural languages that use mandatory noun markers, so our brains are built to handle it
- they aren't mandatory, since you can declare sigilless names (if you don't mind the ambiguity)

## "Type Str does not support associative indexing."

You likely tried to mix string interpolation and key characters, like HTML tags:

```Raku
my $foo = "abc";
say "$foo<html-tag>";
```

Raku thinks `$foo` is a Hash and `<html-tag>` is a string literal hash key. Use a closure to help it to understand you.

```Raku
my $foo = "abc";
say "{$foo}<html-tag>";
```

## Does Raku have coroutines? What about `yield`?

Raku has no `yield` statement like Python does, but it does offer similar functionality through lazy lists. There are two popular ways to write routines that return lazy lists:

```Raku
# first method, gather/take 
my @values = gather while have_data() {
    # do some computations 
    take some_data();
    # do more computations 
}
 
# second method, use .map or similar method 
# on a lazy list 
my @squares = (1..*).map(-> \x { x² });
```

## Why can't I initialize private attributes from the new method, and how can I fix this?

The `say` statement in the following code sample

```Raku
class A {
    has $!x;
    method show-x {
        return $!x;
    }
}
say A.new(x => 5).show-x;
```

does not print 5. Private attributes are *private*, which means invisible to the outside world. If the default constructor could initialize them, they would leak into the public API. Thus, in this particular code sample the attribute `$!x` isn't initialized during object construction by the default constructor.

If you still want to initialize private attributes with the default constructor, you can add a `submethod BUILD` to achieve such task:

```Raku
class B {
    has $!x;
    submethod BUILD(:$!x) { }
    method show-x {
        return $!x;
    }
}
say B.new(x => 5).show-x;
```

`BUILD` is called by the default constructor (indirectly, see [Object Construction](https://docs.raku.org/language/objects#Object_construction) for more details) with all the named arguments that the user passes to the constructor. `:$!x` is a named parameter with name `x`, and when called with a named argument of name `x`, its value is bound to the attribute `$!x`.

However, you shouldn't do that. If the attribute is declared as private, then it shouldn't be exposed to the environment outside the class (e.g., during object construction). On the other hand, if the attribute is public, there is no downside to declaring it that way with `$.x` since the external view is read-only by default, and you can still access it internally with `$!x`.

## How and why do `say`, `put` and `print` differ?

The most obvious difference is that `say` and `put` append a newline at the end of the output, and `print` does not.

But there's another difference: `print` and `put` convert their arguments to a string by calling the `Str` method on each item passed to them while `say` uses the `gist` method. The `gist` method, which you can also create for your own classes, is intended to create a `Str` for human interpretation. So it is free to leave out information about the object deemed unimportant to understanding the essence of the object.

Or phrased differently, `$obj.Str` gives a string representation, `$obj.gist` provides a short summary of that object suitable for fast recognition by a human, and `$obj.perl` (`$obj.raku`) gives a Raku-ish representation from which the object could be re-created.

For example, when the `Str` method is invoked on a type object, also known as an "undefined value", the type is stringified to an empty string and a `warn`ing is thrown. On the other hand, the `gist` method returns the name of the type between parentheses (to indicate there's nothing in that value except the type).

```Raku
my Date $x;     # $x now contains the Date type object 
print $x;       # empty string plus warning 
say $x;         # OUTPUT: «(Date)␤» 
```

If you'd like to show a debugging version of an object, it is probably better to use the [rakudo-specific `dd` routine](https://docs.raku.org/programs/01-debugging#Dumper_function_dd). It essentially does a `$obj.perl` (`$obj.raku`) and shows that on STDERR rather than STDOUT, so it won't interfere with any "normal" output of your program.

In short, `say` is optimized for casual human interpretation, `dd` is optimized for casual debugging output and `print` and `put` are more generally suitable for producing output.

`put` is thus a hybrid of `print` and `say`; like `print`, it calls the `Str` method on the object. And like `say`, it adds a newline at the end of the output.

## What's the difference between `token` and `rule` ?

`regex`, `token` and `rule` introduce regexes, but with slightly different semantics.

`token` implies the `:ratchet` or `:r` modifier, which prevents the rule from backtracking.

`rule` implies both the `:ratchet` and `:sigspace` (short `:s`) modifier, which means a rule doesn't backtrace, and it treats whitespace in the text of the regex as `<.ws>` calls (i.e., matches whitespace, which is optional except between two word characters). Whitespace at the start of the regex and at the start of each branch of an alternation is ignored.

`regex` declares a plain regex without any implied modifiers.

## What's the difference between `die` and `fail`?

`die` throws an exception.

`fail` returns a `Failure` object. (If the caller has declared `use fatal;` in the calling lexical scope, `fail` throws an exception instead of returning it.)

A `Failure` is an "unthrown" or "lazy" exception. It's an object that contains the exception, and throws the exception if you try to use the `Failure` as an ordinary object or ignore it in sink context.

A `Failure` returns `False` from a `defined` check, and you can extract the exception with the `exception` method.

## What's the difference between `Pointer` and `OpaquePointer`?

`OpaquePointer` is deprecated and has been replaced with `Pointer`.

## You can have colonpairs in identifiers. What's the justification?

[Identifiers can include colon pairs, which become part of their name](https://docs.raku.org/language/syntax#Identifiers). According to [Larry Wall's answer to the issue](https://github.com/perl6/doc/issues/1753#issuecomment-362875676), *We already had the colon pair mechanism available, so it was a no-brainer to use that to extend any name that needs to be able to quote uniquefying but non-standard characters (or other information with a unique stringification to such characters)*.

## How do most people enter unicode characters?

It depends on the operating system, windowing environment and/or editors. [This page on entering Unicode characters](https://docs.raku.org/language/unicode_entry) specifies how it is done in the most popular operating systems and editors.

# Raku implementation

## What Raku implementations are available?

Currently the best developed is Rakudo (using multiple Virtual Machine backends). Historic implementations include Niecza (.NET) and Pugs (Haskell). Others are listed at [Raku Compilers](https://www.raku.org/compilers/)

## What language is Rakudo written in?

A short answer is that Rakudo is written almost entirely in Raku. A more detailed answer is that Rakudo is written in a mixture of Raku and NQP ("Not Quite Perl"). NQP is a lightweight Raku-like environment for virtual machines; it's designed to be a high-level way to create compilers and libraries for virtual machines (such as MoarVM and JVM) using Raku syntax.

## What language is NQP written in?

NQP is a mixture of (1) NQP code, (2) whatever language the underlying virtual machine is using, (3) some third-party C and Java libraries, and (4) some bootstrapping files created by earlier runs of the build process.

## Is Raku Lisp?

```Raku
(not (not Nil))
```

## Can I compile my script to a standalone executable?

Tools like [`App::InstallerMaker::WiX`](https://modules.raku.org/dist/App::InstallerMaker::WiX) allow you to create an installer that will package the compiler and your script. However, the currently available compilers do not support creating a standalone executable yet.

If you wish to help out, the *Rakudo* compiler on *MoarVM* backend has <https://github.com/MoarVM/MoarVM/issues/875> issue opened as a place to discuss this problem.

# Raku distribution

## When will the next version of Rakudo Star be released?

A Rakudo Star release is typically produced quarterly, with release announcements [posted on rakudo.org](https://rakudo.org/posts).

# Metaquestions and advocacy

## Why was Raku originally called Perl 6?

… As opposed to some other name that didn't imply all the things that the higher number might indicate on other languages.

The short answer is that it was Larry's choice under [Rule 1](https://perldoc.perl.org/5.12.4/perlhack.html#DESCRIPTION).

The community considers Perl 5 and Raku sister languages - they have a lot in common, address many of the same problem spaces, but Raku is not intended to replace Perl 5. In fact, both languages interoperate with each other.

## When will Raku be ready? Is it ready now?

Readiness of programming languages and their compilers is not a binary decision. As the language and the implementations evolve, they grow steadily more usable. Depending on your needs, Raku and its compilers may or may not be ready for you.

That said, version 6.c (Christmas 2015) is the first official release of Raku as a language, along with a validation suite and a compiler that passes it.

## Why should I learn Raku? What's so great about it?

Raku unifies many great ideas that aren't usually found in other programming languages. While several other languages offer some of these features, none of them offer all of them.

- Raku offers procedural, object-oriented AND functional programming methodologies.
- Easy to use consistent syntax, using invariable sigils for data-structures.
- Full grapheme based Unicode support, including Annex #29.
- Clean, more readable regular expressions; taken to the next level of usability, with a lot more functionality. Named regular expressions improve ease of use.
- Junctions allowing easy checking of multiple possibilities; e.g., `$a == 1|3|42` (Is `$a` equal to 1 or 3 or 42?).
- Dynamic variables provide a lexically scoped alternative to global variables.
- Emphasis on composability and lexical scoping to prevent “action at a distance”; e.g., imports are always lexically scoped.
- Easy to understand consistent scoping rules and closures.
- Powerful object orientation, with classes and roles (everything can be seen as an object). Inheritance. Subtyping. Code-reuse.
- Introspection into objects and metaobjects (turtles all the way down).
- MetaObject Protocol allowing for metaprogramming without needing to generate / parse code.
- Subroutine and method signatures for easy unpacking of positional and named parameters.
- Multi dispatch for identically named subroutines/methods with different signatures, based on arity, types and optional additional code.
- Compile time error reporting on unknown subroutines / impossible dispatch.
- Optional gradual type-checking at no additional runtime cost. With optional type annotations.
- Advanced error reporting based on introspection of the compiler/runtime state. This means more useful, more precise error messages.
- Phasers (like `BEGIN` / `END`) allow code to be executed at scope entry / exit, loop first / last / next and many more special contexts.
- High level concurrency model, both for implicit as well as explicit multi-processing, which goes way beyond primitive threads and locks. Raku's concurrency offers a rich set of (composable) tools.
- Multiple-core computers are getting used more and more, and with Raku these can be used thanks to parallelism, both implicit (e.g., with the `>>`. method) and explicit ( `start { code }` ). This is important, because Moore's Law is ending.
- Structured language support is provided to enable programming for asynchronous execution of code.
- Supplies allow code to be executed when something happens (like a timer, or a signal, or a filesystem event).
- `react` / `whenever` / `supply` keywords allows easy construction of interactive, event driven applications.
- Lazy evaluation when possible, eager evaluation when wanted or necessary. This means, for example, lazy lists, and even infinite lazy lists, like the Fibonacci sequence, or all prime numbers.
- Native data types for faster, closer to the metal, processing.
- Interfacing to external libraries in C / C++ is fairly easy with [NativeCall](https://docs.raku.org/language/nativecall).
- Interfacing with Perl 5 (CPAN) / Python modules is fairly easy with [Inline::Perl5](https://modules.raku.org/dist/Inline::Perl5:cpan:NINE) and [Inline::Python](https://modules.raku.org/dist/Inline::Python)
- Can have multiple versions of a module installed and loaded simultaneously.
- System administration simplified due to simpler update/upgrade policies.
- Simple numeric computation without precision loss because of [Rat](https://docs.raku.org/type/Rat)s (rational numbers).
- Extensible grammars for parsing data or code (which Raku uses to parse itself).
- Raku is a very mutable language (define your own functions, operators, traits and data-types, which modify the parser for you).
- Large selection of data-types, plus the possibility to create your own types.
- Multi-dimensional shaped and/or native arrays with proper bounds checking.
- Execute code at any time during parsing of a grammar, or when a certain match occurred.
- Adding a custom operator or adding a trait is as simple as writing a subroutine.
- Automatic generation of hyper-operators on any operator (system or custom added).
- Runs on a variety of back-ends. Currently MoarVM & JVM, JavaScript in development, more may follow.
- Runtime optimization of hot code paths during execution (JIT).
- Runs on small (e.g., Raspberry Pi) and large multi-processor hardware.
- Garbage collection based: no timely destruction, so no ref-counting necessary. Use phasers for timely actions.
- Methods can be mixed into any instantiated object at runtime; e.g., to allow adding out-of-band data.
- Easy command-line interface accessible by `MAIN` subroutine with multiple dispatch and automated usage message generation.
- Fewer lines of code allow for more compact program creation. Huffman-coding of names allows for better readability.
- Lazy lists defined with a simple iterator interface, which any class can supply by minimally supplying a single method.
- Raku's mottos remain the same as they have been for Perl all along: “Perl is different. In a nutshell, Perl is designed to make the easy jobs easy, without making the hard jobs impossible.” and “There Is More Than One Way To Do It”. Now with even more -Ofun added.

## Is Raku fast enough for me?

That depends on what you are doing. Rakudo has been developed with the philosophy of "make it work right then make it work fast." It's fast for some things already but needs work for others. Since Raku provides lots of clues to the JIT that other dynamic languages don't, we think we'll have a lot of headroom for performance improvements.

The following crude benchmarks, with all the usual caveats about such things, show that Raku can be faster than Perl 5 for similar tasks if the big weaponry is included, that is, if Raku features are used to its full extent; at the same time, Perl 5 can be faster if only the bare bones are included. Similar situation can be observed when comparing Raku to other languages.

Try it on your system. You may be pleasantly surprised!

Examples:

```Raku
# Raku version 
use v6.c;
 
class Foo { has $.i is rw };
 
for 1..1_000_000 -> $i {
    my $obj = Foo.new;
    $obj.i = $i;
}
# Perl 5 version 
package Foo;
use Moose;
 
has i => (is => 'rw');
 
__PACKAGE__->meta->make_immutable;
 
for my $i (1..1_000_000) {
    my $obj = Foo->new;
    $obj->i($i);
}
 
1;
 
# Another Perl 5 version that offers bare-bones set of features 
# compared to Moose/Raku's version but those are not needed in this 
# specific, simple program anyway. 
package Foo;
use Mojo::Base -base;
 
has 'i';
 
for my $i (1..1_000_000) {
    my $obj = Foo->new;
    $obj->i($i);
}
 
1;
```

You might want to use this program for comparing performance, too. It works under both languages, as long as `perl -Mbigint` is used for invocation for Perl 5.

```Raku
my ($prev, $current) = (1, 0);
 
for (0..100_000) {
    ($prev, $current) = ($current, $prev + $current);
}
print $current;
```

Generated from [/language/faq](https://github.com/perl6/doc/blob/master/doc/Language/faq.pod6). [Debug: off]

This is a work in progress to document Raku (formerly known as Perl 6), and known to be incomplete.

[Please report any issues](https://github.com/Raku/doc/blob/master/CONTRIBUTING.md#reporting-bugs).Your contribution is appreciated.

This documentation is provided under the terms of the [Artistic License 2.0](https://raw.githubusercontent.com/Raku/doc/master/LICENSE). The Camelia image is [copyright © 2009 by Larry Wall.](https://raw.githubusercontent.com/perl6/mu/master/misc/camelia.txt)
