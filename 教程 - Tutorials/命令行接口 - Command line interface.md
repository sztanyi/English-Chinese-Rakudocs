原文：https://docs.raku.org/language/create-cli

# 命令行接口 / Command line interface

在 Raku 创建自己的命令行接口

Creating your own CLI in Raku

# 命令行接口 - 概述 / Command line interface - an overview

Raku 脚本的默认命令行接口由三部分组成：

The default command line interface of Raku scripts consists of three parts:

## 将命令行参数解析为 Capture / Parsing the command line parameters into a capture

它查看 [@*ARGS](https://docs.raku.org/language/variables#index-entry-@*ARGS) 中的值，根据某些策略解释这些值，并创建一个 [Capture](https://docs.raku.org/type/Capture) 对象。开发人员可以提供另一种解析方法，或者使用模块安装。

This looks at the values in [@*ARGS](https://docs.raku.org/language/variables#index-entry-@*ARGS), interprets these according to some policy, and creates a [Capture](https://docs.raku.org/type/Capture) object out of that. An alternative way of parsing may be provided by the developer or installed using a module.

## Calling a provided `MAIN` subroutine using that capture

Standard [multi dispatch](https://docs.raku.org/language/functions#index-entry-declarator_multi-Multi-dispatch) is used to call the `MAIN` subroutine with the generated `Capture` object. This means that your `MAIN` subroutine may be a `multi sub`, each candidate of which is responsible for some part of processing the given command line arguments.

## Creating / showing usage information if calling `MAIN` failed

If multi dispatch failed, then the user of the script should be informed as well as possible as to why it failed. By default, this is done by inspecting the signature of each `MAIN` candidate sub, and any associated Pod information. The result is then shown to the user on STDERR (or on STDOUT if `--help` was specified). An alternative way of generating the usage information may be provided by the developer or installed using a module.

# sub MAIN

The sub with the special name `MAIN` will be executed after all relevant entry phasers (`BEGIN`, `CHECK`, `INIT`, `PRE`, `ENTER`) have been run and the [mainline](https://docs.raku.org/language/glossary#index-entry-Mainline) of the script has been executed. No error will occur if there is no `MAIN` sub: your script will then just have to do the work, such as argument parsing, in the mainline of the script.

Any normal exit from the `MAIN` sub will result in an exit code of `0`, indicating success. Any return value of the `MAIN` sub will be ignored. If an exception is thrown that is not handled inside the `MAIN` sub, then the exit code will be `1`. If the dispatch to `MAIN` failed, a usage message will be displayed on STDERR and the exit code will be `2`.

The command line parameters are present in the `@*ARGS` dynamic variable and may be altered in the mainline of the script before the `MAIN` unit is called.

The signature of (the candidates of the multi) sub `MAIN` determines which candidate will actually be called using the standard [multi dispatch](https://docs.raku.org/language/glossary#index-entry-Multi-Dispatch) semantics.

A simple example:

```Raku
# inside file 'hello.p6' 
sub MAIN($name) {
    say "Hello $name, how are you?"
}
```

If you call that script without any parameters, you get the following usage message:

```Raku
$ perl6 hello.p6
Usage:
  hello.p6 <name>
```

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

Another way to do this is to make `sub MAIN` a `multi sub`:

```Raku
# inside file 'hello.p6' 
multi sub MAIN()      { say "Hello bashful, how are you?" }
multi sub MAIN($name) { say "Hello $name, how are you?"   }
```

Which would give the same output as the examples above. Whether you should use either method to achieve the desired goal is entirely up to you.

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

With `file.dat` present, this will work this way:

```Raku
$ perl6 frobnicate.p6
24
file.dat
Verbosity off
```

Or this way with `--verbose`:

```Raku
$ perl6 frobnicate.p6 --verbose
24
file.dat
Verbosity on
```

If the file `file.dat` is not present, or you've specified another filename that doesn't exist, you would get the standard usage message created from introspection of the `MAIN` sub:

```Raku
$ perl6 frobnicate.p6 doesntexist.dat
Usage:
  frobnicate.p6 [--length=<Int>] [--verbose] [<file>]
```

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

Which would improve the usage message like this:

```Raku
$ perl6 frobnicate.p6 doesntexist.dat
Usage:
  frobnicate.p6 [--length=<Int>] [--verbose] [<file>]
 
    [<file>]          an existing file to frobnicate
    --length=<Int>    length needed for frobnication
    --verbose         required verbosity
```

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

In which case, these aliases will also be listed as alternatives with `--help`:

```Raku
Usage:
  frobnicate.p6 [--size|--length=<Int>] [--verbose] [<file>]
 
    [<file>]                 an existing file to frobnicate
    --size|--length=<Int>    length needed for frobnication
    --verbose                required verbosity
```

## %*SUB-MAIN-OPTS

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

Available options are:

### named-anywhere

By default, named arguments passed to the program (i.e., `MAIN`) cannot appear after any positional argument. However, if `%*SUB-MAIN-OPTS<named-anywhere>` is set to a true value, named arguments can be specified anywhere, even after positional parameter. For example, the above program can be called with:

```Raku
$ perl6 example.p6 1 --c=2 3 --d=4
```

## is hidden-from-USAGE

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

So, if you would call this script with just a named variable, you would get the following usage:

```Raku
$ perl6 hello.p6 --verbose
Usage:
  hello.p6 <name> -- the name by which you would like to be called
```

Without the `hidden-from-USAGE` trait on the first candidate, it would have looked like this:

```Raku
$ perl6 hello.p6 --verbose
Usage:
  hello.p6
  hello.p6 <name> -- the name by which you would like to be called
```

Which, although technically correct, doesn't read as well.

# Unit-scoped definition of `MAIN`

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

Note that this is only appropriate if you can get by with just a single (only) `sub MAIN`.

## sub USAGE

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

The default usage message is available inside `sub USAGE` via the read-only `$*USAGE` variable. It will be generated based on available `sub MAIN` candidates and their parameters. As shown before, you can specify an additional extended description for each candidate using a `#|(...)` Pod block to set [`WHY`](https://docs.raku.org/routine/WHY).

# Intercepting CLI argument parsing (2018.10, v6.d and later)

You can replace or augment the default way of argument parsing by supplying a `ARGS-TO-CAPTURE` subroutine yourself, or by importing one from any of the [Getopt](https://modules.perl6.org/search/?q=getopt) modules available in the ecosystem.

## sub ARGS-TO-CAPTURE

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

Note that the dynamic variable [`&*ARGS-TO-CAPTURE`](https://docs.raku.org/language/variables#&*ARGS-TO-CAPTURE) is available to perform the default command line arguments to `Capture` processing so you don't have to reinvent the whole wheel if you don't want to.

# Intercepting usage message generation (2018.10, v6.d and later)

You can replace or augment the default way of usage message generation (after a failed dispatch to MAIN) by supplying a `GENERATE-USAGE` subroutine yourself, or by importing one from any of the [Getopt](https://modules.perl6.org/search/?q=getopt) modules available in the ecosystem.

## sub RUN-MAIN

Defined as:

```Raku
sub RUN-MAIN(&main, $mainline, :$in-as-argsfiles)
```

This routine allows complete control over the handling of `MAIN`. It gets a `Callable` that is the `MAIN` that should be executed, the return value of the mainline execution and additional named variables: `:in-as-argsfiles` which will be `True` if STDIN should be treated as `$*ARGFILES`.

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

This will print the name (first argument) of the generated object.

## sub GENERATE-USAGE

The `GENERATE-USAGE` subroutine should accept a `Callable` representing the `MAIN` subroutine that didn't get executed because the dispatch failed. This can be used for introspection. All the other parameters are the parameters that were set up to be sent to `MAIN`. It should return the string of the usage information you want to be shown to the user. An example that will just recreate the `Capture` that was created from processing the arguments:

```Raku
sub GENERATE-USAGE(&main, |capture) {
    capture<foo>:exists
      ?? "You're not allowed to specify a --foo"
      !! &*GENERATE-USAGE(&main, |capture)
}
```

You can also use multi subroutines to create the same effect:

```Raku
multi sub GENERATE-USAGE(&main, :$foo!) {
    "You're not allowed to specify a --foo"
}
multi sub GENERATE-USAGE(&main, |capture) {
    &*GENERATE-USAGE(&main, |capture)
}
```

Note that the dynamic variable [`&*GENERATE-USAGE`](https://docs.raku.org/language/variables#&*GENERATE-USAGE) is available to perform the default usage message generation so you don't have to reinvent the whole wheel if you don't want to.

# Intercepting MAIN calling (before 2018.10, v6.e)

An older interface enabled one to intercept the calling to `MAIN` completely. This depended on the existence of a `MAIN_HELPER` subroutine that would be called if a `MAIN` subroutine was found in the mainline of a program.

This interface was never documented. However, any programs using this undocumented interface will continue to function until `v6.e`. From v6.d onward, the use of the undocumented API will cause a `DEPRECATED` message.

Ecosystem modules can provide both the new and the old interface for compatibility with older versions of Raku: if a newer Raku recognizes the new (documented) interface, it will use that. If there is no new interface subroutine available, but the old `MAIN_HELPER` interface is, then it will use the old interface.

If a module developer decides to only offer a module for `v6.d` or higher, then the support for the old interface can be removed from the module.
