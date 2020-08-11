原文：https://docs.raku.org/language/exceptions

# 异常 / Exceptions

Raku 中使用异常

Using exceptions in Raku

Raku 中的异常是保存错误信息的对象。 例如，错误可以是意外接收数据或网络连接不再可用，也可以是丢失的文件。 例如，异常对象存储的信息可能是关于错误条件的消息、错误的回溯等等。

Exceptions in Raku are objects that hold information about errors. An error can be, for example, the unexpected receiving of data or a network connection no longer available, or a missing file. The information that an exception objects store is, for instance, a human-readable message about the error condition, the backtrace of the raising of the error, and so on.

所有内置异常都继承自 [Exception](https://docs.raku.org/type/Exception)，它提供了一些基本行为，包括存储回溯和回溯打印机的接口。

All built-in exceptions inherit from [Exception](https://docs.raku.org/type/Exception), which provides some basic behavior, including the storage of a backtrace and an interface for the backtrace printer.

<!-- MarkdownTOC -->

- [临时异常 / *Ad hoc* exceptions](#临时异常--ad-hoc-exceptions)
- [类型化异常 / Typed exceptions](#类型化异常--typed-exceptions)
- [捕获异常 / Catching exceptions](#捕获异常--catching-exceptions)
    - [异常处理程序和封闭块 / Exception handlers and enclosing blocks](#异常处理程序和封闭块--exception-handlers-and-enclosing-blocks)
- [`try` 代码块 / `try` blocks](#try-代码块--try-blocks)
- [抛出异常 / Throwing exceptions](#抛出异常--throwing-exceptions)
- [异常恢复 / Resuming of exceptions](#异常恢复--resuming-of-exceptions)
- [未捕获的异常 / Uncaught exceptions](#未捕获的异常--uncaught-exceptions)
- [控制异常 / Control exceptions](#控制异常--control-exceptions)

<!-- /MarkdownTOC -->


<a id="临时异常--ad-hoc-exceptions"></a>
# 临时异常 / *Ad hoc* exceptions

可以通过调用 [die](https://docs.raku.org/routine/die) 使用临时异常，并对错误进行描述：

Ad hoc exceptions can be used by calling [die](https://docs.raku.org/routine/die) with a description of the error:

```Raku
die "oops, something went wrong";
# RESULT: «oops, something went wrong in block <unit> at my-script.p6:1␤» 
```

值得注意的是，`die` 将错误消息打印到标准错误 `$*ERR`。

It is worth noting that `die` prints the error message to the standard error `$*ERR`.

<a id="类型化异常--typed-exceptions"></a>
# 类型化异常 / Typed exceptions

类型化异常提供有关存储在异常对象中的错误的详细信息。

Typed exceptions provide more information about the error stored within an exception object.

例如，如果在一个对象上执行 `.zombie copy` 时，需要的文件 `foo/bar` 将变得不可用，则 [X::IO::DoesNotExist](https://docs.raku.org/type/X::IO::DoesNotExist) 异常会被抛出：

For example, if while executing `.zombie copy` on an object, a needed path `foo/bar` becomes unavailable, then an [X::IO::DoesNotExist](https://docs.raku.org/type/X::IO::DoesNotExist) exception can be raised:

```Raku
die X::IO::DoesNotExist.new(:path("foo/bar"), :trying("zombie copy"))

# RESULT: «Failed to find 'foo/bar' while trying to do '.zombie copy' 
#          in block <unit> at my-script.p6:1» 
```

请注意对象是如何向回溯提供有关出错的信息。代码的用户现在可以更容易地找到和纠正问题。

Note how the object has provided the backtrace with information about what went wrong. A user of the code can now more easily find and correct the problem.

<a id="捕获异常--catching-exceptions"></a>
# 捕获异常 / Catching exceptions

可以通过 `CATCH` 代码块来处理异常：

It's possible to handle exceptional circumstances by supplying a `CATCH` block:

```Raku
die X::IO::DoesNotExist.new(:path("foo/bar"), :trying("zombie copy"));
 
CATCH {
    when X::IO { $*ERR.say: "some kind of IO exception was caught!" }
}
 
# OUTPUT: «some kind of IO exception was caught!» 
```

这里，我们要说的是，如果发生了类型为 `X::IO` 的异常，那么消息 `some kind of IO exception was caught!` 将被发送到*标准错误输出*，这就是 `$*ERR.say` 所做的，在那一刻显示在构成标准错误设备的任何组件上，这很可能是默认的控制台。

Here, we are saying that if any exception of type `X::IO` occurs, then the message `some kind of IO exception was caught!` will be sent to *stderr*, which is what `$*ERR.say` does, getting displayed on whatever constitutes the standard error device in that moment, which will probably be the console by default.

`CATCH` 代码块使用智能匹配的方式类似 `given/when` 用智能匹配处理选项一样，因此可以在 `when` 代码块中抓取和处理各种类别的异常。

A `CATCH` block uses smartmatching similar to how `given/when` smartmatches on options, thus it's possible to catch and handle various categories of exceptions inside a `when` block.

要处理所有异常，使用 `default` 语句。这个例子打印出的信息与普通的回溯打印机几乎相同。

To handle all exceptions, use a `default` statement. This example prints out almost the same information as the normal backtrace printer.

```Raku
CATCH {
     default {
         $*ERR.say: .message;
         for .backtrace.reverse {
             next if .file.starts-with('SETTING::');
             next unless .subname;
             $*ERR.say: "  in block {.subname} at {.file} line {.line}";
         }
     }
}
```

请注意，匹配目标是一个角色。为了允许用户定义的异常以相同的方式匹配，它们必须实现给定的角色。只存在于同一个命名空间中的将看起来相似，但在`CATCH` 代码块中不匹配。

Note that the match target is a role. To allow user defined exceptions to match in the same manner, they must implement the given role. Just existing in the same namespace will look alike but won't match in a `CATCH` block.

<a id="异常处理程序和封闭块--exception-handlers-and-enclosing-blocks"></a>
## 异常处理程序和封闭块 / Exception handlers and enclosing blocks

CATCH 处理完异常后，将退出包含 `CATCH` 代码块的代码块。

After a CATCH has handled the exception, the block enclosing the `CATCH` block is exited.

换句话说，即使成功地处理了异常，也永远不会执行封闭块中的*其余代码*。

In other words, even when the exception is handled successfully, the *rest of the code* in the enclosing block will never be executed.

```Raku
die "something went wrong ...";
 
CATCH {
    # will definitely catch all the exception 
    default { .Str.say; }
}
 
say "This won't be said.";   # but this line will be never reached since 
                             # the enclosing block will be exited immediately 
# OUTPUT: «something went wrong ...␤» 
```

跟这个比较：

Compare with this:

```Raku
CATCH {
 
  CATCH {
      default { .Str.say; }
  }
 
  die "something went wrong ...";
 
}
 
say "Hi! I am at the outer block!"; # OUTPUT: «Hi! I am at the outer block!␤» 
```

怎样把控制权还给异常产生的地方，参考[异常恢复](https://docs.raku.org/language/exceptions#Resuming_of_exceptions)

See [Resuming of exceptions](https://docs.raku.org/language/exceptions#Resuming_of_exceptions), for how to return control back to where the exception originated.

<a id="try-代码块--try-blocks"></a>
# `try` 代码块 / `try` blocks

`try` 代码块是一个普通代码块，它隐式使用 [`use fatal` 指令](https://docs.raku.org/language/pragmas#index-entry-fatal-fatal)，并包含一个用来用于舍弃异常的隐式 `CATCH` 代码块，这意味着你可以使用它来包含异常。捕获的异常存储在 `$!` 变量中，它保存 `Exception` 的值。

A `try` block is a normal block which implicitly turns on the [`use fatal` pragma](https://docs.raku.org/language/pragmas#index-entry-fatal-fatal) and includes an implicit `CATCH` block that drops the exception, which means you can use it to contain them. Caught exceptions are stored inside the `$!` variable, which holds a value of type `Exception`.

像这样的一个普通代码块只会失败：

A normal block like this one will simply fail:

```Raku
{
    my $x = +"a";
    say $x.^name;
} # OUTPUT: «Failure␤» 
```

但是，`try` 代码块将控制异常并将其放入 `$!` 变量中：

However, a `try` block will contain the exception and put it into the `$!` variable:

```Raku
try {
    my $x = +"a";
    say $x.^name;
}
 
if $! { say "Something failed!" } # OUTPUT: «Something failed!␤» 
say $!.^name;                     # OUTPUT: «X::Str::Numeric␤» 
```

在此类块中引发的任何异常都将被 `CATCH` 块捕获，无论是隐式的还是由用户提供的。在后一种情况下，任何未处理的异常都将被重新抛出。如果选择不处理异常，这些异常将被代码块控制。

Any exception that is thrown in such a block will be caught by a `CATCH` block, either implicit or provided by the user. In the latter case, any unhandled exception will be rethrown. If you choose not to handle the exception, they will be contained by the block.

```Raku
try {
    die "Tough luck";
    say "Not gonna happen";
}
 
try {
    fail "FUBAR";
}
```

在上面的两个 `try` 代码块中，异常将被控制在块中，但不会运行 `say` 语句。不过，我们可以处理它们：

In both `try` blocks above, exceptions will be contained within the block, but the `say` statement will not be run. We can handle them, though:

```Raku
class E is Exception { method message() { "Just stop already!" } }
 
try {
    E.new.throw; # this will be local 
 
    say "This won't be said.";
}
 
say "I'm alive!";
 
try {
    CATCH {
        when X::AdHoc { .Str.say; .resume }
    }
 
    die "No, I expect you to DIE Mr. Bond!";
 
    say "I'm immortal.";
 
    E.new.throw;
 
    say "No, you don't!";
}
```

输出：

Which would output:

```Raku
I'm alive!
No, I expect you to DIE Mr. Bond!
I'm immortal.
Just stop already!
  in block <unit> at exception.p6 line 21
```

由于 `CATCH` 代码块只处理由 `die` 语句引发的 `X::AdHoc` 异常，而不是 `E` 异常。在没有 `CATCH` 代码块的情况下，将控制并删除所有异常，如上所示。`resume` 将在引发异常后立即恢复执行；在本例中，在 `die` 语句中。有关此方面的详细信息，请参阅 [恢复异常](https://docs.raku.org/language/exceptions#Resuming_of_exceptions)。

Since the `CATCH` block is handling just the `X::AdHoc` exception thrown by the `die` statement, but not the `E` exception. In the absence of a `CATCH` block, all exceptions will be contained and dropped, as indicated above. `resume` will resume execution right after the exception has been thrown; in this case, in the `die` statement. Please consult the section on [resuming of exceptions](https://docs.raku.org/language/exceptions#Resuming_of_exceptions) for more information on this.

`try` 代码块是一个普通代码块，因此将其最后一条语句视为自身的返回值。因此，我们可以将其与 `//` 操作符配合使用。

A `try`-block is a normal block and as such treats its last statement as the return value of itself. We can therefore use it as a right-hand side.

```Raku
say try { +"99999" } // "oh no"; # OUTPUT: «99999␤» 
say try { +"hello" } // "oh no"; # OUTPUT: «oh no␤» 
```

Try 代码块通过返回表达式的返回值间接支持 `else` 代码块，如果引发异常，则返回 [Nil](https://docs.raku.org/type/Nil)。

Try blocks support `else` blocks indirectly by returning the return value of the expression or [Nil](https://docs.raku.org/type/Nil) if an exception was thrown.

```Raku
with try +"♥" {
    say "this is my number: $_"
} else {
    say "not my number!"
}
# OUTPUT: «not my number!␤» 
```

`try` 还可以与语句而不是代码块一起使用，即作为[语句前缀](https://docs.raku.org/language/statement-prefixes#try)：

`try` can also be used with a statement instead of a block, that is, as a [statement prefix](https://docs.raku.org/language/statement-prefixes#try):

```Raku
say try "some-filename.txt".IO.slurp // "sane default";
# OUTPUT: «sane default␤» 
```

`try` 的实际原因是，通过 `use fatal` 指令，立即抛出在其作用域内发生的异常，但通过这样做，`CATCH` 代码块将从引发异常的点（定义其作用域）被调用。

What `try` actually causes is, via the `use fatal` pragma, an immediate throw of the exceptions that happen within its scope, but by doing so the `CATCH` block is invoked from the point where the exception is thrown, which defines its scope.

```Raku
my $error-code = "333";
sub bad-sub {
    die "Something bad happened";
}
try {
    my $error-code = "111";
    bad-sub;
 
    CATCH {
        default {
            say "Error $error-code ", .^name, ': ',.Str
        }
    }
}
# OUTPUT: «Error 111 X::AdHoc: Something bad happened␤» 
```

<a id="抛出异常--throwing-exceptions"></a>
# 抛出异常 / Throwing exceptions

可以使用 `Exception` 对象的 `.throw` 方法显式抛出异常。

Exceptions can be thrown explicitly with the `.throw` method of an `Exception` object.

此示例引发一个 `AdHoc` 异常，捕获它，并允许代码通过调用 `.resume` 方法从异常点继续。

This example throws an `AdHoc` exception, catches it and allows the code to continue from the point of the exception by calling the `.resume` method.

```Raku
{
    X::AdHoc.new(:payload<foo>).throw;
    "OHAI".say;
    CATCH {
        when X::AdHoc { .resume }
    }
}
 
"OBAI".say;
 
# OUTPUT: «OHAI␤OBAI␤» 
```

如果 `CATCH` 代码块与抛出的异常不匹配，则该异常的有效负载将传递给回溯打印机制。

If the `CATCH` block doesn't match the exception thrown, then the exception's payload is passed on to the backtrace printing mechanism.

```Raku
{
    X::AdHoc.new(:payload<foo>).throw;
    "OHAI".say;
    CATCH {  }
}
 
"OBAI".say;
 
# RESULT: «foo 
#          in block <unit> at my-script.p6:1» 
```

下一个示例不会从异常点恢复。相反，它在封闭代码块之后继续，因为捕获了异常，然后在 `CATCH` 代码块之后继续执行。

This next example doesn't resume from the point of the exception. Instead, it continues after the enclosing block, since the exception is caught, and then control continues after the `CATCH` block.

```Raku
{
    X::AdHoc.new(:payload<foo>).throw;
    "OHAI".say;
    CATCH {
        when X::AdHoc { }
    }
}
 
"OBAI".say;
 
# OUTPUT: «OBAI␤» 
```

`throw` 可以看作是 `die` 的方法形式，在这种特殊情况下，子例程的 sub 和 method 形式有不同的名称。

`throw` can be viewed as the method form of `die`, just that in this particular case, the sub and method forms of the routine have different names.

<a id="异常恢复--resuming-of-exceptions"></a>
# 异常恢复 / Resuming of exceptions

异常中断控制流，并将其从抛出它的语句后面的语句转移开。用户处理的任何异常都可以恢复，控制流将继续执行引发异常的语句后面的语句。为此，请对异常对象调用方法 `.resume`。

Exceptions interrupt control flow and divert it away from the statement following the statement that threw it. Any exception handled by the user can be resumed and control flow will continue with the statement following the statement that threw the exception. To do so, call the method `.resume` on the exception object.

```Raku
CATCH { when X::AdHoc { .resume } }         # this is step 2 
 
die "We leave control after this.";         # this is step 1 
 
say "We have continued with control flow."; # this is step 3 
```

恢复将在引发异常的语句之后以及最内部的调用帧中发生：

Resuming will occur right after the statement that has caused the exception, and in the innermost call frame:

```Raku
sub bad-sub {
    die "Something bad happened";
    return "not returning";
}
 
{
    my $return = bad-sub;
    say "Returned $return";
    CATCH {
        default {
            say "Error ", .^name, ': ',.Str;
            $return = '0';
            .resume;
 
        }
    }
}
# OUTPUT: 
# Error X::AdHoc: Something bad happened 
# Returned not returning 
```

在这种情况下，`.resume` 将进入 `die` 语句之后的 `return` 语句。请注意，对变量 `$return` 的赋值无效，因为 `CATCH` 语句发生在 `bad-sub` 里，而 `bad-sub` 通过 `return` 语句将 `not returning` 字符串赋值给 `$return`。

In this case, `.resume` is getting to the `return` statement that happens right after the `die` statement. Please note that the assignment to `$return` is taking no effect, since the `CATCH` statement is happening *inside* the call to `bad-sub`, which, via the `return` statement, assigns the `not returning` value to it.

<a id="未捕获的异常--uncaught-exceptions"></a>
# 未捕获的异常 / Uncaught exceptions

如果一个异常被抛出并且没有被捕获，它会导致程序以非零状态码退出，并且通常会将一条消息打印到程序的标准错误流。此消息是通过对异常对象调用 `gist` 方法获得的。你可以使用此选项来禁止与消息一起打印回溯的默认行为：

If an exception is thrown and not caught, it causes the program to exit with a non-zero status code, and typically prints a message to the standard error stream of the program. This message is obtained by calling the `gist` method on the exception object. You can use this to suppress the default behavior of printing a backtrace along with the message:

```Raku
class X::WithoutLineNumber is X::AdHoc {
    multi method gist(X::WithoutLineNumber:D:) {
        $.payload
    }
}
die X::WithoutLineNumber.new(payload => "message")

# prints "message\n" to $*ERR and exits, no backtrace 
```

<a id="控制异常--control-exceptions"></a>
# 控制异常 / Control exceptions

有 [X::Control](https://docs.raku.org/type/X::Control) 角色的异常被抛出时（自 Rakudo 2019.03 起），会引发控制异常。它们通常由特定的[关键字](https://docs.raku.org/language/phasers#CONTROL)抛出，并自动或由相应的[相位器](https://docs.raku.org/language/phasers#Loop_phasers)处理。任何未处理的控制异常都将转换为正常异常。

Control exceptions are raised when throwing an Exception which does the [X::Control](https://docs.raku.org/type/X::Control) role (since Rakudo 2019.03). They are usually thrown by certain [keywords](https://docs.raku.org/language/phasers#CONTROL) and are handled either automatically or by the appropriate [phaser](https://docs.raku.org/language/phasers#Loop_phasers). Any unhandled control exception is converted to a normal exception.

```Raku
{ return; CATCH { default { $*ERR.say: .^name, ': ', .Str } } }
# OUTPUT: «X::ControlFlow::Return: Attempt to return outside of any Routine␤» 
# was CX::Return 
```
