原文：https://docs.raku.org/language/ipc

# Inter-process communication

Programs running other programs and communicating with them

# Running programs

Many programs need to be able to run other programs, and we need to pass information to them and receive their output and exit status. Running a program in Raku is as easy as:

```Raku
run 'git', 'status';
```

This line runs the program named "git" and passes "git" and "status" to its command-line. It will find the program using the `%*ENV<PATH> `setting.

If you would like to run a program by sending a command-line to the shell, there's a tool for that as well. All shell metacharacters are interpreted by the shell, including pipes, redirects, environment variable substitutions and so on.

```Raku
shell 'ls -lR | gzip -9 > ls-lR.gz';
```

Caution should be taken when using `shell` with user input.

# The `Proc` object

Both `run` and `shell` return a [Proc](https://docs.raku.org/type/Proc) object, which can be used to communicate with the process in more detail. Please note that unless you close all output pipes, the program will usually not terminate.

```Raku
my $git = run 'git', 'log', '--oneline', :out;
for $git.out.lines -> $line {
    my ($sha, $subject) = $line.split: ' ', 2;
    say "$subject [$sha]";
}
$git.out.close();
```

If the program fails (exits with a non-zero exit code), it will throw an exception when the returned [Proc](https://docs.raku.org/type/Proc) object is sunk. You can save it into a variable, even anonymous one, to prevent the sinking:

```Raku
$ = run '/bin/false'; # does not sink the Proc and so does not throw
```

You can tell the `Proc` object to capture output as a filehandle by passing the `:out` and `:err` flags. You may also pass input via the `:in` flag.

```Raku
my $echo = run 'echo', 'Hello, world', :out;
my $cat  = run 'cat', '-n', :in($echo.out), :out;
say $cat.out.get;
$cat.out.close();
```

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

# The `Proc::Async` object

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

The small program above uses the "tail" program to print out the contents of the log named `system.log` for 10 seconds and then tells the program to stop with a QUIT signal.

Whereas `Proc` provides access to output using `IO::Handle`s, `Proc::Async` provides access using asynchronous supplies (see [Supply](https://docs.raku.org/type/Supply)).

If you want to run a program and do some work while you wait for the original program to finish, the `start` routine returns a [Promise](https://docs.raku.org/type/Promise), which is kept when the program quits.

Use the `write` method to pass data into the program.
