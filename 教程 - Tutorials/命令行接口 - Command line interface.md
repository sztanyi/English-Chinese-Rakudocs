原文：https://docs.raku.org/language/create-cli

# 命令行接口 / Command line interface

在 Raku 创建自己的命令行接口

Creating your own CLI in Raku

<!-- MarkdownTOC -->

- [命令行接口 - 概述 / Command line interface - an overview](#命令行接口---概述--command-line-interface---an-overview)
  - [将命令行参数解析为 Capture / Parsing the command line parameters into a capture](#将命令行参数解析为-capture--parsing-the-command-line-parameters-into-a-capture)
  - [使用该 Capture 调用提供的 `MAIN` 子例程 / Calling a provided `MAIN` subroutine using that capture](#使用该-capture-调用提供的-main-子例程--calling-a-provided-main-subroutine-using-that-capture)
  - [如果调用 `MAIN` 失败，则创建/显示使用信息 - Creating / showing usage information if calling `MAIN` failed](#如果调用-main-失败，则创建显示使用信息---creating--showing-usage-information-if-calling-main-failed)
- [MAIN 子例程 / sub MAIN](#main-子例程--sub-main)
  - [%*SUB-MAIN-OPTS](#sub-main-opts)
    - [named-anywhere](#named-anywhere)
  - [is hidden-from-USAGE](#is-hidden-from-usage)
- [`MAIN` 的单元范围定义 / Unit-scoped definition of `MAIN`](#main-的单元范围定义--unit-scoped-definition-of-main)
  - [USAGE 子例程 / sub USAGE](#usage-子例程--sub-usage)
- [拦截 CLI 参数解析（2018.10，v6.d 及以后版本） / Intercepting CLI argument parsing \(2018.10, v6.d and later\)](#拦截-cli-参数解析（201810，v6d-及以后版本）--intercepting-cli-argument-parsing-201810-v6d-and-later)
  - [ARGS-TO-CAPTURE 子例程 / sub ARGS-TO-CAPTURE](#args-to-capture-子例程--sub-args-to-capture)
- [拦截使用信息的生成（2018.10，v6.d 及以后版本） / Intercepting usage message generation \(2018.10, v6.d and later\)](#拦截使用信息的生成（201810，v6d-及以后版本）--intercepting-usage-message-generation-201810-v6d-and-later)
  - [RUN-MAIN 子例程 / sub RUN-MAIN](#run-main-子例程--sub-run-main)
  - [GENERATE-USAGE 子例程 / sub GENERATE-USAGE](#generate-usage-子例程--sub-generate-usage)
- [拦截 MAIN 调用（在 2018.10，V6.e 之前） / Intercepting MAIN calling \(before 2018.10, v6.e\)](#拦截-main-调用（在-201810，v6e-之前）--intercepting-main-calling-before-201810-v6e)

<!-- /MarkdownTOC -->


<a id="命令行接口---概述--command-line-interface---an-overview"></a>
# 命令行接口 - 概述 / Command line interface - an overview

Raku 脚本的默认命令行接口由三部分组成：

The default command line interface of Raku scripts consists of three parts:

<a id="将命令行参数解析为-capture--parsing-the-command-line-parameters-into-a-capture"></a>
## 将命令行参数解析为 Capture / Parsing the command line parameters into a capture

它查看 [@*ARGS](https://docs.raku.org/language/variables#index-entry-@*ARGS) 中的值，根据某些策略解释这些值，并创建一个 [Capture](https://docs.raku.org/type/Capture) 对象。开发人员可以提供另一种解析方法，或者使用模块安装。

This looks at the values in [@*ARGS](https://docs.raku.org/language/variables#index-entry-@*ARGS), interprets these according to some policy, and creates a [Capture](https://docs.raku.org/type/Capture) object out of that. An alternative way of parsing may be provided by the developer or installed using a module.

<a id="使用该-capture-调用提供的-main-子例程--calling-a-provided-main-subroutine-using-that-capture"></a>
## 使用该 Capture 调用提供的 `MAIN` 子例程 / Calling a provided `MAIN` subroutine using that capture

标准[多分派](https://docs.raku.org/language/functions#index-entry-declarator_multi-Multi-dispatch)用于使用生成的 `Capture `对象调用 `MAN` 子例程。这意味着你的 `MAIN` 子例程可能是一个 `multi sub`，每个候选子例程都负责处理给定的命令行参数的某些部分。

Standard [multi dispatch](https://docs.raku.org/language/functions#index-entry-declarator_multi-Multi-dispatch) is used to call the `MAIN` subroutine with the generated `Capture` object. This means that your `MAIN` subroutine may be a `multi sub`, each candidate of which is responsible for some part of processing the given command line arguments.

<a id="如果调用-main-失败，则创建显示使用信息---creating--showing-usage-information-if-calling-main-failed"></a>
## 如果调用 `MAIN` 失败，则创建/显示使用信息 - Creating / showing usage information if calling `MAIN` failed

如果多分派失败，那么脚本的用户应该尽可能地被告知失败的原因。默认情况下，这是通过检查每个 `MAIN` 候选子例程以及任何相关的 Pod 信息的签名来完成的。然后将结果显示在 STDERR 上（如果指定了 `--help`，则显示在 STDOUT 上）。开发人员可以提供生成使用信息的替代方法，或者使用模块安装。

If multi dispatch failed, then the user of the script should be informed as well as possible as to why it failed. By default, this is done by inspecting the signature of each `MAIN` candidate sub, and any associated Pod information. The result is then shown to the user on STDERR (or on STDOUT if `--help` was specified). An alternative way of generating the usage information may be provided by the developer or installed using a module.

<a id="main-子例程--sub-main"></a>
# MAIN 子例程 / sub MAIN

在运行所有相关的输入阶段（`BEGIN`、`CHECK`、`INT`、`PRE`、`ENTER`）并执行脚本的 [mainline](https://docs.raku.org/language/glossary#index-entry-Mainline) 之后，具有特殊名称的子程序 `MAIN` 将被执行。如果没有 `MAIN` 子例程，则不会出现错误：然后，你的脚本将只需在脚本的 mainline 中执行参数解析等工作。

The sub with the special name `MAIN` will be executed after all relevant entry phasers (`BEGIN`, `CHECK`, `INIT`, `PRE`, `ENTER`) have been run and the [mainline](https://docs.raku.org/language/glossary#index-entry-Mainline) of the script has been executed. No error will occur if there is no `MAIN` sub: your script will then just have to do the work, such as argument parsing, in the mainline of the script.

来自 `MAIN` 子例程的任何正常退出将导致退出代码为 `0`，表示成功。`MAIN` 子例程的任何返回值将被忽略。如果抛出 `MAIN` 子例程中未处理的异常，则退出代码将为 `1`。如果调度到 `MAIN` 失败，将在 STDERR 上显示使用消息，退出代码将为 `2`。

Any normal exit from the `MAIN` sub will result in an exit code of `0`, indicating success. Any return value of the `MAIN` sub will be ignored. If an exception is thrown that is not handled inside the `MAIN` sub, then the exit code will be `1`. If the dispatch to `MAIN` failed, a usage message will be displayed on STDERR and the exit code will be `2`.

命令行参数存在于 `@*ARGS` 动态变量中，并且在调用 `MAIN` 单元之前，可以在脚本的主线中进行更改。

The command line parameters are present in the `@*ARGS` dynamic variable and may be altered in the mainline of the script before the `MAIN` unit is called.

`MAIN` 子例程的签名决定哪个候选实际上将使用标准[多分派](https://docs.raku.org/language/glossary#index-entry-Multi-Dispatch)语义来调用。

The signature of (the candidates of the multi) sub `MAIN` determines which candidate will actually be called using the standard [multi dispatch](https://docs.raku.org/language/glossary#index-entry-Multi-Dispatch) semantics.

一个简单的例子：

A simple example:

```Raku
# inside file 'hello.p6' 
sub MAIN($name) {
    say "Hello $name, how are you?"
}
```

如果在没有任何参数情况下调用该脚本，可以获得以下使用消息：

If you call that script without any parameters, you get the following usage message:

```Raku
$ perl6 hello.p6
Usage:
  hello.p6 <name>
```

但是，如果为参数提供默认值，那么在指定名称或不指定名称的情况下运行脚本将始终有效：

However, if you give a default value for the parameter, running the script either with or without specifying a name will always work:

```Raku
# inside file 'hello.p6' 
sub MAIN($name = 'bashful') {
    say "Hello $name, how are you?"
}
$ perl6 hello.p6
Hello bashful, how are you?
$ perl6 hello.p6 Liz
Hello Liz, how are you?
```

另一种方法是使 `sub MAIN` 成为 `multi sub`：

Another way to do this is to make `sub MAIN` a `multi sub`:

```Raku
# inside file 'hello.p6' 
multi sub MAIN()      { say "Hello bashful, how are you?" }
multi sub MAIN($name) { say "Hello $name, how are you?"   }
```

它将给出与上面的例子相同的输出。你是否应该使用任何一种方法来达到预期的目标完全取决于你。

Which would give the same output as the examples above. Whether you should use either method to achieve the desired goal is entirely up to you.

一个使用单个位置和多个命名参数的更复杂的示例：

A more complicated example using a single positional and multiple named parameters:

```Raku
# inside "frobnicate.p6" 
sub MAIN(
  Str   $file where *.IO.f = 'file.dat',
  Int  :$length = 24,
  Bool :$verbose
) {
    say $length if $length.defined;
    say $file   if $file.defined;
    say 'Verbosity ', ($verbose ?? 'on' !! 'off');
}
```

参数为 `file.dat`，并且文件存在时：

With `file.dat` present, this will work this way:

```Raku
$ perl6 frobnicate.p6 file.dat
24
file.dat
Verbosity off
```

或者添加 `--verbose` 参数：

Or this way with `--verbose`:

```Raku
$ perl6 frobnicate.p6 --verbose file.dat
24
file.dat
Verbosity on
```

如果文件 `file.dat` 不存在，或者你已经指定了不存在的另一个文件名，你将获得从 `MAIN` 子例程的内省机制创建的标准使用帮助消息：

If the file `file.dat` is not present, or you've specified another filename that doesn't exist, you would get the standard usage message created from introspection of the `MAIN` sub:

```Raku
$ perl6 frobnicate.p6 doesntexist.dat
Usage:
  frobnicate.p6 [--length=<Int>] [--verbose] [<file>]
```

尽管你不必在代码中做任何事情来执行此操作，但它可能被视为有点过于精练。但是，通过提供使用 pod 功能的提示，很容易使使用消息变得更好：

Although you don't have to do anything in your code to do this, it may still be regarded as a bit terse. But there's an easy way to make that usage message better by providing hints using pod features:

```Raku
# inside "frobnicate.p6" 
sub MAIN(
  Str   $file where *.IO.f = 'file.dat',  #= an existing file to frobnicate 
  Int  :$length = 24,                     #= length needed for frobnication 
  Bool :$verbose,                         #= required verbosity 
) {
    say $length if $length.defined;
    say $file   if $file.defined;
    say 'Verbosity ', ($verbose ?? 'on' !! 'off');
}
```

这将改进这样的使用消息：

Which would improve the usage message like this:

```Raku
$ perl6 frobnicate.p6 doesntexist.dat
Usage:
  frobnicate.p6 [--length=<Int>] [--verbose] [<file>]
 
    [<file>]          an existing file to frobnicate
    --length=<Int>    length needed for frobnication
    --verbose         required verbosity
```

与任何其他子例程一样，`MAIN` 可以为其命名参数定义[别名](https://docs.raku.org/type/Signature#index-entry-argument_aliases)。

As any other subroutine, `MAIN` can define [aliases](https://docs.raku.org/type/Signature#index-entry-argument_aliases) for its named parameters.

```Raku
sub MAIN(
  Str   $file where *.IO.f = 'file.dat',  #= an existing file to frobnicate 
  Int  :size(:$length) = 24,              #= length/size needed for frobnication 
  Bool :$verbose,                         #= required verbosity 
) {
    say $length if $length.defined;
    say $file   if $file.defined;
    say 'Verbosity ', ($verbose ?? 'on' !! 'off');
}
```

在这种情况下，这些别名也将被列为 `--help` 的替代品：

In which case, these aliases will also be listed as alternatives with `--help`:

```Raku
Usage:
  frobnicate.p6 [--size|--length=<Int>] [--verbose] [<file>]
 
    [<file>]                 an existing file to frobnicate
    --size|--length=<Int>    length needed for frobnication
    --verbose                required verbosity
```

<a id="sub-main-opts"></a>
## %*SUB-MAIN-OPTS

通过在 `%*SUB-MAIN-OPTS` 哈希中设置选项，在将参数传递到 `sub MAIN {}` 之前，可以更改参数的处理方式。由于动态变量的性质，需要设置 `%*SUB-MAIN-OPTS` 哈希，并用适当的设置填充它。例如：

It's possible to alter how arguments are processed before they're passed to `sub MAIN {}` by setting options in the `%*SUB-MAIN-OPTS` hash. Due to the nature of dynamic variables, it is required to set up the `%*SUB-MAIN-OPTS` hash and fill it with the appropriate settings. For instance:

```Raku
my %*SUB-MAIN-OPTS =
  :named-anywhere,    # allow named variables at any location 
  # other possible future options / custom options 
;
sub MAIN ($a, $b, :$c, :$d) {
    say "Accepted!"
}
```

可选的选项是：

Available options are:

<a id="named-anywhere"></a>
### named-anywhere

默认情况下，传递给程序的命名参数（即 `MAIN`）不能出现在任何位置参数之后。但是，如果 `%*SUB-MAIN-OPTS<named-anywhere>` 设置为真值，则可以在任何地方指定命名参数，甚至在位置参数之后也可以。例如，可以使用以下方法调用上述程序：

By default, named arguments passed to the program (i.e., `MAIN`) cannot appear after any positional argument. However, if `%*SUB-MAIN-OPTS<named-anywhere>` is set to a true value, named arguments can be specified anywhere, even after positional parameter. For example, the above program can be called with:

```Raku
$ perl6 example.p6 1 --c=2 3 --d=4
```

<a id="is-hidden-from-usage"></a>
## is hidden-from-USAGE

有时你要排除在任何自动生成的使用消息中显示的 `MAIN` 候选项。这可以通过将 `hidden-from-USAGE` 特性添加到不想显示的 `MAIN` 候选项的规格来实现。在较早的示例中展开：

Sometimes you want to exclude a `MAIN` candidate from being shown in any automatically generated usage message. This can be achieved by adding a `hidden-from-USAGE` trait to the specification of the `MAIN` candidate you do not want to show. Expanding on an earlier example:

```Raku
# inside file 'hello.p6' 
multi sub MAIN() is hidden-from-USAGE {
    say "Hello bashful, how are you?"
}
multi sub MAIN($name) {  #= the name by which you would like to be called 
    say "Hello $name, how are you?"
}
```

因此，如果你只使用命名变量调用此脚本，你将获得以下用法：

So, if you would call this script with just a named variable, you would get the following usage:

```Raku
$ perl6 hello.p6 --verbose
Usage:
  hello.p6 <name> -- the name by which you would like to be called
```

如果在第一个候选人上没有 `hidden-from-USAGE` 的特性，结果就会是这样：

Without the `hidden-from-USAGE` trait on the first candidate, it would have looked like this:

```Raku
$ perl6 hello.p6 --verbose
Usage:
  hello.p6
  hello.p6 <name> -- the name by which you would like to be called
```

这虽然技术上是正确的，但也不是很好。

Which, although technically correct, doesn't read as well.

<a id="main-的单元范围定义--unit-scoped-definition-of-main"></a>
# `MAIN` 的单元范围定义 / Unit-scoped definition of `MAIN`

如果整个程序主体驻留在 `MAIN` 中，则可以使用下面的 `unit` 声明器（修改较早的示例）：

If the entire program body resides within `MAIN`, you can use the `unit` declarator as follows (adapting an earlier example):

```Raku
unit sub MAIN(
  Str   $file where *.IO.f = 'file.dat',
  Int  :$length = 24,
  Bool :$verbose,
);  # <- note semicolon here 
 
say $length if $length.defined;
say $file   if $file.defined;
say 'Verbosity ', ($verbose ?? 'on' !! 'off');
# rest of script is part of MAIN 
```

请注意，只有仅使用单个 `sub MAIN`才能获得此选项。

Note that this is only appropriate if you can get by with just a single (only) `sub MAIN`.

<a id="usage-子例程--sub-usage"></a>
## USAGE 子例程 / sub USAGE

如果没有为给定的命令行参数找到 `MAIN` 的多个候选项，则调用子例程 `USAGE`。如果没有找到这样的方法，编译器将输出默认的使用消息。

If no multi candidate of `MAIN` is found for the given command line parameters, the sub `USAGE` is called. If no such method is found, the compiler will output a default usage message.

```Raku
#|(is it the answer) 
multi MAIN(Int $i) { say $i == 42 ?? 'answer' !! 'dunno' }
#|(divide two numbers) 
multi MAIN($a, $b){ say $a/$b }
 
sub USAGE() {
    print Q:c:to/EOH/; 
    Usage: {$*PROGRAM-NAME} [number]
 
    Prints the answer or 'dunno'.
EOH
}
```

默认使用帮助消息可通过只读变量 `$*USAGE` 在 `sub USAGE` 中使用。它将基于可用的 `sub MAIN` 候选函数和它们的参数来生成。如前面所示，你可以使用 `#|(...)` Pod 代码块来为每个候选指定一个附加的扩展说明，以设置  [`WHY`](https://docs.raku.org/routine/WHY)。

The default usage message is available inside `sub USAGE` via the read-only `$*USAGE` variable. It will be generated based on available `sub MAIN` candidates and their parameters. As shown before, you can specify an additional extended description for each candidate using a `#|(...)` Pod block to set [`WHY`](https://docs.raku.org/routine/WHY).

<a id="拦截-cli-参数解析（201810，v6d-及以后版本）--intercepting-cli-argument-parsing-201810-v6d-and-later"></a>
# 拦截 CLI 参数解析（2018.10，v6.d 及以后版本） / Intercepting CLI argument parsing (2018.10, v6.d and later)

通过为你自己提供 `ARGS-TO-CAPTURE` 子例程，或从生态系统中可用的 [Getopt](https://modules.perl6.org/search/?q=getopt) 模块中的任何一个导入一个子例程，你可以替换或增加参数解析的默认方式。

You can replace or augment the default way of argument parsing by supplying a `ARGS-TO-CAPTURE` subroutine yourself, or by importing one from any of the [Getopt](https://modules.perl6.org/search/?q=getopt) modules available in the ecosystem.

<a id="args-to-capture-子例程--sub-args-to-capture"></a>
## ARGS-TO-CAPTURE 子例程 / sub ARGS-TO-CAPTURE

`ARGS-TO-CAPTURE` 子例程应该接受两个参数：一个表示要执行的 `MAIN` 单元的 [Callable](https://docs.raku.org/type/Callable)（以便在必要时可以自省）和一个带有命令行参数的数组。它应该返回一个 [Capture](https://docs.raku.org/type/Capture) 对象，它将用于分派 `MAIN` 单元。下面是一个**非常**人为的示例，它将根据输入的某个关键字（在测试脚本的命令行接口时非常方便）创建一个 `Capture`：

The `ARGS-TO-CAPTURE` subroutine should accept two parameters: a [Callable](https://docs.raku.org/type/Callable) representing the `MAIN` unit to be executed (so it can be introspected if necessary) and an array with the arguments from the command line. It should return a [Capture](https://docs.raku.org/type/Capture) object that will be used to dispatch the `MAIN` unit. The following is a **very** contrived example that will create a `Capture` depending on some keyword that was entered (which can be handy during testing of a command line interface of a script):

```Raku
sub ARGS-TO-CAPTURE(&main, @args --> Capture) {
    # if we only specified "frobnicate" as an argument 
    @args == 1 && @args[0] eq 'frobnicate'
      # then dispatch as MAIN("foo","bar",verbose => 2) 
      ?? Capture.new( list => <foo bar>, hash => { verbose => 2 } )
      # otherwise, use default processing of args 
      !! &*ARGS-TO-CAPTURE(&main, @args)
}
```

请注意，动态变量 [`&*ARGS-TO-CAPTURE`](https://docs.raku.org/language/variables#&*ARGS-TO-CAPTURE) 可以执行默认的命令行参数到 `Capture` 处理，因此如果不愿意，你就不必重新发明轮子。

Note that the dynamic variable [`&*ARGS-TO-CAPTURE`](https://docs.raku.org/language/variables#&*ARGS-TO-CAPTURE) is available to perform the default command line arguments to `Capture` processing so you don't have to reinvent the whole wheel if you don't want to.

<a id="拦截使用信息的生成（201810，v6d-及以后版本）--intercepting-usage-message-generation-201810-v6d-and-later"></a>
# 拦截使用信息的生成（2018.10，v6.d 及以后版本） / Intercepting usage message generation (2018.10, v6.d and later)

你可以通过自己提供一个 `GENERATE-USAGE` 子例程，或者从生态系统中可用的任何 [Getopt](https://modules.perl6.org/search/?q=getopt) 模块中导入一个，来替换或增强默认的使用消息生成方式（在向 MAIN 发送失败之后）。

You can replace or augment the default way of usage message generation (after a failed dispatch to MAIN) by supplying a `GENERATE-USAGE` subroutine yourself, or by importing one from any of the [Getopt](https://modules.perl6.org/search/?q=getopt) modules available in the ecosystem.

<a id="run-main-子例程--sub-run-main"></a>
## RUN-MAIN 子例程 / sub RUN-MAIN

定义为：

Defined as:

```Raku
sub RUN-MAIN(&main, $mainline, :$in-as-argsfiles)
```

这个例程允许完全控制 `MAIN` 的处理。它得到一个 `Callable`，即应该执行的 `MAIN`、mainline 执行的返回值和附加的命名变量：`:in-as-argsfiles`，如果 STDIN 应该被视为 `$*ARGFILES`，它将是 `True`。

This routine allows complete control over the handling of `MAIN`. It gets a `Callable` that is the `MAIN` that should be executed, the return value of the mainline execution and additional named variables: `:in-as-argsfiles` which will be `True` if STDIN should be treated as `$*ARGFILES`.

如果未提供 `RUN-MAIN`，则将运行一个默认程序，查找旧接口的子例程，如 `MAIN_HELPER` 和 `USAGE`。如果找到，它将在"旧的"语义之后执行。

If `RUN-MAIN` is not provided, a default one will be run that looks for subroutines of the old interface, such as `MAIN_HELPER` and `USAGE`. If found, it will execute following the "old" semantics.

```Raku
class Hero {
    has @!inventory;
    has Str $.name;
    submethod BUILD( :$name, :@inventory ) {
        $!name = $name;
        @!inventory = @inventory
    }
}

sub new-main($name, *@stuff ) {
    Hero.new(:name($name), :inventory(@stuff) ).perl.say
}

RUN-MAIN( &new-main, Nil );
```

这将打印生成对象的名称（第一个参数）。

This will print the name (first argument) of the generated object.

<a id="generate-usage-子例程--sub-generate-usage"></a>
## GENERATE-USAGE 子例程 / sub GENERATE-USAGE

`GENERATE-USAGE` 子例程应该接受一个 `Callable`，表示由于调度失败而未被执行的 `MAIN` 子程序。这可以用于内省。所有其他参数都是设置为发送到 `MAIN` 的参数。它应该返回你想要显示给用户的使用信息的字符串。一个只需重新创建由处理参数创建的 `Capture` 的示例：

The `GENERATE-USAGE` subroutine should accept a `Callable` representing the `MAIN` subroutine that didn't get executed because the dispatch failed. This can be used for introspection. All the other parameters are the parameters that were set up to be sent to `MAIN`. It should return the string of the usage information you want to be shown to the user. An example that will just recreate the `Capture` that was created from processing the arguments:

```Raku
sub GENERATE-USAGE(&main, |capture) {
    capture<foo>:exists
      ?? "You're not allowed to specify a --foo"
      !! &*GENERATE-USAGE(&main, |capture)
}
```

你还可以使用多个子程序来创建相同的效果：

You can also use multi subroutines to create the same effect:

```Raku
multi sub GENERATE-USAGE(&main, :$foo!) {
    "You're not allowed to specify a --foo"
}
multi sub GENERATE-USAGE(&main, |capture) {
    &*GENERATE-USAGE(&main, |capture)
}
```

请注意，动态变量 [`&*ARGS-TO-CAPTURE`](https://docs.raku.org/language/variables#&*ARGS-TO-CAPTURE) 可以执行默认的命令行参数到 `Capture` 处理，因此如果不愿意，你就不必重新发明轮子。

Note that the dynamic variable [`&*GENERATE-USAGE`](https://docs.raku.org/language/variables#&*GENERATE-USAGE) is available to perform the default usage message generation so you don't have to reinvent the whole wheel if you don't want to.

<a id="拦截-main-调用（在-201810，v6e-之前）--intercepting-main-calling-before-201810-v6e"></a>
# 拦截 MAIN 调用（在 2018.10，V6.e 之前） / Intercepting MAIN calling (before 2018.10, v6.e)

一个较旧的接口使用户能够完全拦截对 `MAIN` 的调用。这取决于是否存在一个 `MAIN_HELPER` 子例程，如果在程序的主线中找到 `MAIN` 子例程，该子例程将被调用。

An older interface enabled one to intercept the calling to `MAIN` completely. This depended on the existence of a `MAIN_HELPER` subroutine that would be called if a `MAIN` subroutine was found in the mainline of a program.

这个接口从未被记录过。然而，任何使用这个无文档接口的程序都将继续工作到 `v6.e` 为止。从 v6.d 开始，使用无文档的 API 将导致一条 `DEPRECATED` 消息。

This interface was never documented. However, any programs using this undocumented interface will continue to function until `v6.e`. From v6.d onward, the use of the undocumented API will cause a `DEPRECATED` message.

生态系统模块可以提供新的和旧的接口，以与旧版本的 Raku 兼容：如果新的 Raku 识别了新的（有文档记录的）接口，则它将使用该接口。如果没有可用的新接口子例程，但旧的 `MAIN_HELPER` 接口是，则它将使用旧接口。

Ecosystem modules can provide both the new and the old interface for compatibility with older versions of Raku: if a newer Raku recognizes the new (documented) interface, it will use that. If there is no new interface subroutine available, but the old `MAIN_HELPER` interface is, then it will use the old interface.

如果模块开发者决定只提供 `v6.d` 或更高的模块，则可以从模块中删除旧接口的支持。

If a module developer decides to only offer a module for `v6.d` or higher, then the support for the old interface can be removed from the module.
