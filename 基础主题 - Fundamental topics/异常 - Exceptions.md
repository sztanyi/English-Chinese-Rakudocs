# 异常 / Exceptions

Perl 6 中使用异常

Using exceptions in Perl 6

Exceptions in Perl 6 are objects that hold information about errors. An error can be, for example, the unexpected receiving of data or a network connection no longer available, or a missing file. The information that an exception objects store is, for instance, a human-readable message about the error condition, the backtrace of the raising of the error, and so on.

All built-in exceptions inherit from [Exception](https://docs.perl6.org/type/Exception), which provides some basic behavior, including the storage of a backtrace and an interface for the backtrace printer.

# 临时异常 / *Ad hoc* exceptions

可以通过调用 [die](https://docs.perl6.org/routine/die) 使用临时异常，并对错误进行描述：

Ad hoc exceptions can be used by calling [die](https://docs.perl6.org/routine/die) with a description of the error:

```Perl6
die "oops, something went wrong";
# RESULT: «oops, something went wrong in block <unit> at my-script.p6:1␤» 
```

值得注意的是，`die` 将错误消息打印到标准错误 `$*ERR`。

It is worth noting that `die` prints the error message to the standard error `$*ERR`.

# 类型化异常 / Typed exceptions

类型化异常提供有关存储在异常对象中的错误的详细信息。

Typed exceptions provide more information about the error stored within an exception object.

For example, if while executing `.zombie copy` on an object, a needed path `foo/bar` becomes unavailable, then an [X::IO::DoesNotExist](https://docs.perl6.org/type/X::IO::DoesNotExist) exception can be raised:

```Perl6
die X::IO::DoesNotExist.new(:path("foo/bar"), :trying("zombie copy"))

# RESULT: «Failed to find 'foo/bar' while trying to do '.zombie copy' 
#          in block <unit> at my-script.p6:1» 
```

Note how the object has provided the backtrace with information about what went wrong. A user of the code can now more easily find and correct the problem.

# Catching exceptions

It's possible to handle exceptional circumstances by supplying a `CATCH` block:

```Perl6
die X::IO::DoesNotExist.new(:path("foo/bar"), :trying("zombie copy"));
 
CATCH {
    when X::IO { $*ERR.say: "some kind of IO exception was caught!" }
}
 
# OUTPUT: «some kind of IO exception was caught!» 
```

Here, we are saying that if any exception of type `X::IO` occurs, then the message `some kind of IO exception was caught!` will be sent to *stderr*, which is what `$*ERR.say` does, getting displayed on whatever constitutes the standard error device in that moment, which will probably be the console by default.

A `CATCH` block uses smartmatching similar to how `given/when` smartmatches on options, thus it's possible to catch and handle various categories of exceptions inside a `when` block.

To handle all exceptions, use a `default` statement. This example prints out almost the same information as the normal backtrace printer.

```Perl6
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

Note that the match target is a role. To allow user defined exceptions to match in the same manner, they must implement the given role. Just existing in the same namespace will look alike but won't match in a `CATCH` block.

## Exception handlers and enclosing blocks

After a CATCH has handled the exception, the block enclosing the `CATCH` block is exited.

In other words, even when the exception is handled successfully, the *rest of the code* in the enclosing block will never be executed.

```Perl6
die "something went wrong ...";
 
CATCH {
    # will definitely catch all the exception 
    default { .Str.say; }
}
 
say "This won't be said.";   # but this line will be never reached since 
                             # the enclosing block will be exited immediately 
# OUTPUT: «something went wrong ...␤» 
```

Compare with this:

```Perl6
CATCH {
 
  CATCH {
      default { .Str.say; }
  }
 
  die "something went wrong ...";
 
}
 
say "Hi! I am at the outer block!"; # OUTPUT: «Hi! I am at the outer block!␤» 
```

See [Resuming of exceptions](https://docs.perl6.org/language/exceptions#Resuming_of_exceptions), for how to return control back to where the exception originated.



# `try` blocks

A `try` block is a normal block which implicitly turns on the [`use fatal` pragma](https://docs.perl6.org/language/pragmas#index-entry-fatal-fatal) and includes an implicit `CATCH` block that drops the exception, which means you can use it to contain them. Caught exceptions are stored inside the `$!` variable, which holds a value of type `Exception`.

A normal block like this one will simply fail:

```Perl6
{
    my $x = +"a";
    say $x.^name;
} # OUTPUT: «Failure␤» 
```

However, a `try` block will contain the exception and put it into the `$!` variable:

```
try {
    my $x = +"a";
    say $x.^name;
}
 
if $! { say "Something failed!" } # OUTPUT: «Something failed!␤» 
say $!.^name;                     # OUTPUT: «X::Str::Numeric␤» 
```

Any exception that is thrown in such a block will be caught by a `CATCH` block, either implicit or provided by the user. In the latter case, any unhandled exception will be rethrown. If you choose not to handle the exception, they will be contained by the block.

```
try {
    die "Tough luck";
    say "Not gonna happen";
}
 
try {
    fail "FUBAR";
}
```

In both `try` blocks above, exceptions will be contained within the block, but the `say` statement will not be run. We can handle them, though:

```
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

Which would output:

```
I'm alive!
No, I expect you to DIE Mr. Bond!
I'm immortal.
Just stop already!
  in block <unit> at exception.p6 line 21
```

Since the `CATCH` block is handling just the `X::AdHoc` exception thrown by the `die` statement, but not the `E` exception. In the absence of a `CATCH` block, all exceptions will be contained and dropped, as indicated above. `resume` will resume execution right after the exception has been thrown; in this case, in the `die` statement. Please consult the section on [resuming of exceptions](https://docs.perl6.org/language/exceptions#Resuming_of_exceptions) for more information on this.

A `try`-block is a normal block and as such treats its last statement as the return value of itself. We can therefore use it as a right-hand side.

```
say try { +"99999" } // "oh no"; # OUTPUT: «99999␤» 
say try { +"hello" } // "oh no"; # OUTPUT: «oh no␤» 
```

Try blocks support `else` blocks indirectly by returning the return value of the expression or [Nil](https://docs.perl6.org/type/Nil) if an exception was thrown.

```
with try +"♥" {
    say "this is my number: $_"
} else {
    say "not my number!"
}
# OUTPUT: «not my number!␤» 
```

`try` can also be used with a statement instead of a block, that is, as a [statement prefix](https://docs.perl6.org/language/statement-prefixes#try):

```
say try "some-filename.txt".IO.slurp // "sane default";
# OUTPUT: «sane default␤» 
```

What `try` actually causes is, via the `use fatal` pragma, an immediate throw of the exceptions that happen within its scope, but by doing so the `CATCH` block is invoked from the point where the exception is thrown, which defines its scope.

```
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

# Throwing exceptions

Exceptions can be thrown explicitly with the `.throw` method of an `Exception` object.

This example throws an `AdHoc` exception, catches it and allows the code to continue from the point of the exception by calling the `.resume` method.

```
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

If the `CATCH` block doesn't match the exception thrown, then the exception's payload is passed on to the backtrace printing mechanism.

```
{
    X::AdHoc.new(:payload<foo>).throw;
    "OHAI".say;
    CATCH {  }
}
 
"OBAI".say;
 
# RESULT: «foo 
#          in block <unit> at my-script.p6:1» 
```

This next example doesn't resume from the point of the exception. Instead, it continues after the enclosing block, since the exception is caught, and then control continues after the `CATCH` block.

```
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

`throw` can be viewed as the method form of `die`, just that in this particular case, the sub and method forms of the routine have different names.

# Resuming of exceptions

Exceptions interrupt control flow and divert it away from the statement following the statement that threw it. Any exception handled by the user can be resumed and control flow will continue with the statement following the statement that threw the exception. To do so, call the method `.resume` on the exception object.

```
CATCH { when X::AdHoc { .resume } }         # this is step 2 
 
die "We leave control after this.";         # this is step 1 
 
say "We have continued with control flow."; # this is step 3 
```

Resuming will occur right after the statement that has caused the exception, and in the innermost call frame:

```
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

In this case, `.resume` is getting to the `return` statement that happens right after the `die` statement. Please note that the assignment to `$return` is taking no effect, since the `CATCH` statement is happening *inside* the call to `bad-sub`, which, via the `return` statement, assigns the `not returning` value to it.

# Uncaught exceptions

If an exception is thrown and not caught, it causes the program to exit with a non-zero status code, and typically prints a message to the standard error stream of the program. This message is obtained by calling the `gist` method on the exception object. You can use this to suppress the default behavior of printing a backtrace along with the message:

```
class X::WithoutLineNumber is X::AdHoc {
    multi method gist(X::WithoutLineNumber:D:) {
            $.payload
    }
}
die X::WithoutLineNumber.new(payload => "message")
 
# prints "message\n" to $*ERR and exits, no backtrace 
```

# Control exceptions

Control exceptions are raised when throwing an Exception which does the [X::Control](https://docs.perl6.org/type/X::Control) role (since Rakudo 2019.03). They are usually thrown by certain [keywords](https://docs.perl6.org/language/phasers#CONTROL) and are handled either automatically or by the appropriate [phaser](https://docs.perl6.org/language/phasers#Loop_phasers). Any unhandled control exception is converted to a normal exception.

```
{ return; CATCH { default { $*ERR.say: .^name, ': ', .Str } } }
# OUTPUT: «X::ControlFlow::Return: Attempt to return outside of any Routine␤» 
# was CX::Return 
```