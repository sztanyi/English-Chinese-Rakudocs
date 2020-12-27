原文：https://docs.raku.org/language/system

# 系统交互 / System interaction

使用底层操作系统并运行应用程序

Working with the underlying operating system and running applications

<!-- MarkdownTOC -->

- [通过命令行获取参数 / Getting arguments through the command line](#通过命令行获取参数--getting-arguments-through-the-command-line)
- [互动式获取参数 / Getting arguments interactively](#互动式获取参数--getting-arguments-interactively)
- [同步和异步地运行程序 / Running programs synchronously and asynchronously](#同步和异步地运行程序--running-programs-synchronously-and-asynchronously)
- [通过原生 API 执行系统调用 / Making operating system calls through the native API](#通过原生-api-执行系统调用--making-operating-system-calls-through-the-native-api)

<!-- /MarkdownTOC -->

<a id="通过命令行获取参数--getting-arguments-through-the-command-line"></a>
# 通过命令行获取参数 / Getting arguments through the command line

最简单的方法是使用 [`@*ARGS`](https://docs.raku.org/language/variables#%24%2AARGS) 变量从命令行获取参数；这个数组将包含程序名称后面的字符串。[`%*ENV`](https://docs.raku.org/language/variables#Runtime_environment) 将包含环境变量，因此如果你使用：

The simplest way is to use the [`@*ARGS`](https://docs.raku.org/language/variables#%24%2AARGS) variable to obtain arguments from the command line; this array will contain the strings that follow the program name. [`%*ENV`](https://docs.raku.org/language/variables#Runtime_environment) will contain the environment variables, so that if you use:

```Raku
export API_KEY=1967196417966160761fabc1511067
./consume_api.raku
```

你可以通过以下方式在你的程序中使用它们：

You can use them from your program this way:

```Raku
my $api-key = %*ENV<API_KEY> // die "Need the API key";
```

如果以前没有定义环境变量 `API_KEY`，这将报错并退出。

This will fail if the environment variable `API_KEY` has not been defined previously.

如果命令行参数代表文件名，Raku 有更好的方法来处理它们：[`$*ARGFILES`](https://docs.raku.org/language/variables#%24%2AARGFILES) 动态变量。

Raku has a better way to deal with command line arguments if they represent file names: the [`$*ARGFILES`](https://docs.raku.org/language/variables#%24%2AARGFILES) dynamic variable.

```Raku
for $*ARGFILES.lines -> $l {
    say "Long lines in {$*ARGFILES.path}"
        if $l.chars > 72 ;
}
```

例如，你可以以 `argfiles.raku *.raku` 的方式运行这个程序，每次它发现一行超过 72 个字符时，它都会打印一个文件名。`$*ARGFILES` 包含命令行中描述的所有文件的文件句柄，`.lines` 将依次从每个文件中读取一行，每次处理新句柄时都更改 `$*ARGFILES.path` 的值。一般来说，它为处理文件集的脚本提供了一个非常方便的 API。

You can run this program this way `argfiles.p6 *.p6`, for instance, and it will print a file name every time it finds a line longer than 72 characters. `$*ARGFILES` contains filehandles of all files described in the command lines- `.lines` will read in turn one line from every one of them, changing the value of `$*ARGFILES.path` every time a new handle is being processed. In general, it provides a very convenient API for scripts that deal with sets of files.

<a id="互动式获取参数--getting-arguments-interactively"></a>
# 互动式获取参数 / Getting arguments interactively

使用 `prompt` 可以让运行中的程序查询用户的数据：

Use `prompt` to have a running program query the user for data:

```Raku
my UInt $num-iters = prompt "How many iterations to run: ";
```

<a id="同步和异步地运行程序--running-programs-synchronously-and-asynchronously"></a>
# 同步和异步地运行程序 / Running programs synchronously and asynchronously

运行外部程序有两个例程：[`run`](https://docs.raku.org/routine/run) 和 [`shell`](https://docs.raku.org/routine/shell)。两者都存在于 [`IO`](https://docs.raku.org/type/IO) 角色中，因此都包含在混合该角色的所有类中，如 [IO::Path](https://docs.raku.org/type/IO::Path)。两者都返回一个 [Proc](https://docs.raku.org/type/Proc) 对象，但主要区别在于 `run` 会尽量避免系统 shell 而 `shell` 会在系统默认 shell 中运行命令。

There are two routines to run external programs: [`run`](https://docs.raku.org/routine/run) and [`shell`](https://docs.raku.org/routine/shell). Both exist in the [`IO`](https://docs.raku.org/type/IO) role and are thus included in all classes that mix that role in, like [IO::Path](https://docs.raku.org/type/IO::Path). Both return a [Proc](https://docs.raku.org/type/Proc) object, but the main difference is that `run` will try to avoid the system shell, if possible, while `shell` will run the command through the default system shell.

运行所有外部程序的关键类是 [Proc::Async](https://docs.raku.org/type/Proc::Async)，它异步运行进程并允许与正在运行的进程[并发](https://docs.raku.org/language/concurrency#Proc::Async)交互。一般来说，通过这些高级抽象接口与系统交互是一个很好的实践。然而，Raku 提供了通过低级别接口与系统交互的其他方式.

The key class for running all external programs is [Proc::Async](https://docs.raku.org/type/Proc::Async), which runs processes asynchronously and allows [concurrent](https://docs.raku.org/language/concurrency#Proc::Async) interaction with the running processes. In general, it is a good practice to interact with the system through these high-level, abstract interfaces. However, Raku provides with other ways of interacting with the system through a low-level interface.

<a id="通过原生-api-执行系统调用--making-operating-system-calls-through-the-native-api"></a>
# 通过原生 API 执行系统调用 / Making operating system calls through the native API

[`NativeCall`](https://docs.raku.org/language/nativecall) API 可用于与系统库以及任何其他可访问库进行交互。例如，这个[简短教程](https://docs.raku.org/language/nativecall#Short_tutorial_on_calling_a_C_function)解释了如何使用该接口调用系统函数，如 `getaddrinfo`；其他一些函数也可以[通过使用 NativeCall 接口的声明以这种方式访问](https://docs.raku.org/language/5to6-perlfunc#kill)。

The [`NativeCall`](https://docs.raku.org/language/nativecall) API can be used to interact with system libraries, as well as any other accessible library. This [short tutorial](https://docs.raku.org/language/nativecall#Short_tutorial_on_calling_a_C_function) explains, for instance, how to call system functions such as `getaddrinfo` using that interface; some other functions like `kill` can also be [accessed that way, via declaration using the NativeCall interface](https://docs.raku.org/language/5to6-perlfunc#kill).

幸运的是，你不必对所有原生函数都这样做。作为她的 Butterfly 项目的一部分，将 Perl 功能移植到 Raku 作为生态系统的一部分，[Elizabeth Mattijsen](https://github.com/lizmat) 正在将该语言中的许多系统功能移植到诸如 [`P5getprotobyname`](https://github.com/lizmat/P5getprotobyname) 等模组中，其中包括诸如`endprotoent`、`getprotoent`、`getprotobyname`、`getprotobynumber` 和 `setprotoent` 等功能。[搜索并安装 `P5` 模组](https://modules.raku.org/search/?q=p5)，如果你想使用这些已经在 Raku 中的函数的话。

Fortunately, you do not have to do that for all native functions. As part of her Butterfly project porting Perl functions to Raku as part of the ecosystem, [Elizabeth Mattijsen](https://github.com/lizmat) is porting many system functions that were part of that language to modules such as [`P5getprotobyname`](https://github.com/lizmat/P5getprotobyname), which includes functions such as `endprotoent`, `getprotoent`, `getprotobyname`, `getprotobynumber` and `setprotoent`. [Search and install `P5` modules](https://modules.raku.org/search/?q=p5) if you want to use those functions already in Raku.
