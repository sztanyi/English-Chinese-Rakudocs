原文：https://docs.raku.org/language/ipc

# 进程间通信 / Inter-process communication

运行其他程序并与其通信的程序

Programs running other programs and communicating with them

<!-- MarkdownTOC -->

- [运行程序 / Running programs](#%E8%BF%90%E8%A1%8C%E7%A8%8B%E5%BA%8F--running-programs)
- [`Proc` 对象 / The `Proc` object](#proc-%E5%AF%B9%E8%B1%A1--the-proc-object)
- [`Proc::Async` 对象 / The `Proc::Async` object](#procasync-%E5%AF%B9%E8%B1%A1--the-procasync-object)

<!-- /MarkdownTOC -->

<a id="%E8%BF%90%E8%A1%8C%E7%A8%8B%E5%BA%8F--running-programs"></a>
# 运行程序 / Running programs

许多程序需要能够运行其他程序，并且我们需要将信息传递给它们并接收它们的输出和退出状态。在 Raku 运行一个程序非常简单：

Many programs need to be able to run other programs, and we need to pass information to them and receive their output and exit status. Running a program in Raku is as easy as:

```Raku
run 'git', 'status';
```

这一行运行名为 “git” 的程序，并将 “git” 和 “status” 传递到其命令行。它将使用 `%*ENV<PATH>` 路径查找程序。

This line runs the program named "git" and passes "git" and "status" to its command-line. It will find the program using the `%*ENV<PATH>` setting.

如果你想通过向 shell 发送命令行来运行程序，那么也有一个工具可以实现这一点。所有 shell 元字符都由 shell 解释，包括管道、重定向、环境变量替换等。

If you would like to run a program by sending a command-line to the shell, there's a tool for that as well. All shell metacharacters are interpreted by the shell, including pipes, redirects, environment variable substitutions and so on.

```Raku
shell 'ls -lR | gzip -9 > ls-lR.gz';
```

对用户输入使用 `shell` 时应小心。

Caution should be taken when using `shell` with user input.

<a id="proc-%E5%AF%B9%E8%B1%A1--the-proc-object"></a>
# `Proc` 对象 / The `Proc` object

`run` 和 `shell` 都返回一个 [Proc](https://docs.raku.org/type/Proc) 对象，该对象可用于与进程进行更详细的通信。请注意，除非关闭所有输出管道，否则程序通常不会终止。

Both `run` and `shell` return a [Proc](https://docs.raku.org/type/Proc) object, which can be used to communicate with the process in more detail. Please note that unless you close all output pipes, the program will usually not terminate.

```Raku
my $git = run 'git', 'log', '--oneline', :out;
for $git.out.lines -> $line {
    my ($sha, $subject) = $line.split: ' ', 2;
    say "$subject [$sha]";
}
$git.out.close();
```

如果程序失败（以非零退出代码退出），当返回的 [Proc](https://docs.raku.org/type/Proc) 对象在 sink 上下文（返回值）时，它将抛出异常。你可以将其保存到变量，甚至是匿名变量，以防止 sink 上下文：

If the program fails (exits with a non-zero exit code), it will throw an exception when the returned [Proc](https://docs.raku.org/type/Proc) object is sunk. You can save it into a variable, even anonymous one, to prevent the sinking:

```Raku
$ = run '/bin/false'; # does not sink the Proc and so does not throw
```

通过传递 `:out` 和 `:err` 标志，可以告诉 `Proc` 对象将输出捕获为文件句柄。你还可以通过 `:in` 标志传递输入。

You can tell the `Proc` object to capture output as a filehandle by passing the `:out` and `:err` flags. You may also pass input via the `:in` flag.

```Raku
my $echo = run 'echo', 'Hello, world', :out;
my $cat  = run 'cat', '-n', :in($echo.out), :out;
say $cat.out.get;
$cat.out.close();
```

你还可以使用 `Proc` 捕获 PID，向应用程序发送信号，并检查退出代码。

You may also use `Proc` to capture the PID, send signals to the application, and check the exitcode.

```Raku
my $crontab = run 'crontab', '-l';
if $crontab.exitcode == 0 {
    say 'crontab -l ran ok';
}
else {
    say 'something went wrong';
}
```

<a id="procasync-%E5%AF%B9%E8%B1%A1--the-procasync-object"></a>
# `Proc::Async` 对象 / The `Proc::Async` object

当你需要更多地控制与另一个进程之间的通信时，你将需要使用 [Proc::Async](https://docs.raku.org/type/Proc::Async)。这个类支持与程序的异步通信，以及向程序发送信号的能力。

When you need more control over the communication with and from another process, you will want to make use of [Proc::Async](https://docs.raku.org/type/Proc::Async). This class provides support for asynchronous communication with a program, as well as the ability to send signals to that program.

```Raku
# Get ready to run the program 
my $log = Proc::Async.new('tail', '-f',  '/var/log/system.log');
$log.stdout.tap(-> $buf { print $buf });
$log.stderr.tap(-> $buf { $*ERR.print($buf) });
 
# Start the program 
my $done = $log.start;
sleep 10;
 
# Tell the program to stop 
$log.kill('QUIT');
 
# Wait for the program to finish 
await $done;
```

上面的小程序使用 “tail” 程序打印名为 `system.log` 的日志内容 10 秒，然后用 QUIT 信号告诉程序停止。

The small program above uses the "tail" program to print out the contents of the log named `system.log` for 10 seconds and then tells the program to stop with a QUIT signal.

`Proc` 使用 `IO::Handle` 提供对输出的访问，`Proc::Async` 使用异步 supply 访问（请参见 [Supply](https://docs.raku.org/type/Supply)）。

Whereas `Proc` provides access to output using `IO::Handle`s, `Proc::Async` provides access using asynchronous supplies (see [Supply](https://docs.raku.org/type/Supply)).

如果希望在等待原始程序完成时运行某个程序并执行某些工作，则 `start` 例程将返回一个 [Promise](https://docs.raku.org/type/Promise)，在程序退出时会保留该程序。

If you want to run a program and do some work while you wait for the original program to finish, the `start` routine returns a [Promise](https://docs.raku.org/type/Promise), which is kept when the program quits.

使用 `write` 方法将数据传递到程序中。

Use the `write` method to pass data into the program.
