# 输入输出权威指南 / Input/Output the definitive guide

正确使用 Perl 6 输入输出

Correctly use Perl 6 IO

# 基础 - The basics

The vast majority of common IO work is done by the [IO::Path](https://docs.perl6.org/type/IO::Path) type. If you want to read from or write to a file in some form or shape, this is the class you want. It abstracts away the details of filehandles (or "file descriptors") and so you mostly don't even have to think about them.

Behind the scenes, [IO::Path](https://docs.perl6.org/type/IO::Path) works with [IO::Handle](https://docs.perl6.org/type/IO::Handle); a class which you can use directly if you need a bit more control than what [IO::Path](https://docs.perl6.org/type/IO::Path) provides. When working with other processes, e.g. via [Proc](https://docs.perl6.org/type/Proc) or [Proc::Async](https://docs.perl6.org/type/Proc::Async) types, you'll also be dealing with a *subclass* of [IO::Handle](https://docs.perl6.org/type/IO::Handle): the [IO::Pipe](https://docs.perl6.org/type/IO::Pipe).

Lastly, you have the [IO::CatHandle](https://docs.perl6.org/type/IO::CatHandle), as well as [IO::Spec](https://docs.perl6.org/type/IO::Spec) and its subclasses, that you'll rarely, if ever, use directly. These classes give you advanced features, such as operating on multiple files as one handle, or low-level path manipulations.

Along with all these classes, Perl 6 provides several subroutines that let you indirectly work with these classes. These come in handy if you like functional programming style or in Perl 6 one liners.

While [IO::Socket](https://docs.perl6.org/type/IO::Socket) and its subclasses also have to do with Input and Output, this guide does not cover them.

# Navigating paths

## What's an IO::Path anyway?

To represent paths as either files or directories, use [IO::Path](https://docs.perl6.org/type/IO::Path) type. The simplest way to obtain an object of that type is to coerce a [Str](https://docs.perl6.org/type/Str) by calling [`.IO`](https://docs.perl6.org/routine/IO) method on it:

```
say 'my-file.txt'.IO; # OUTPUT: «"my-file.txt".IO␤» 
```

It may seem like something is missing here—there is no volume or absolute path involved—but that information is actually present in the object. You can see it by using [`.perl`](https://docs.perl6.org/routine/perl) method:

```
say 'my-file.txt'.IO.perl;
# OUTPUT: «IO::Path.new("my-file.txt", :SPEC(IO::Spec::Unix), :CWD("/home/camelia"))␤» 
```

The two extra attributes—`SPEC` and `CWD`—specify what type of operating system semantics the path should use as well as the "current working directory" for the path, i.e. if it's a relative path, then it's relative to that directory.

This means that regardless of how you made one, an [IO::Path](https://docs.perl6.org/type/IO::Path) object technically always refers to an absolute path. This is why its [`.absolute`](https://docs.perl6.org/routine/absolute) and [`.relative`](https://docs.perl6.org/routine/relative) methods return [Str](https://docs.perl6.org/type/Str) objects and they are the correct way to stringify a path.

However, don't be in a rush to stringify anything. Pass paths around as [IO::Path](https://docs.perl6.org/type/IO::Path) objects. All the routines that operate on paths can handle them, so there's no need to convert them.

## Working with files

### Writing into files

#### Writing new content

Let's make some files and write and read data from them! The [`spurt`](https://docs.perl6.org/routine/spurt) and [`slurp`](https://docs.perl6.org/routine/slurp) routines write and read the data in one chunk. Unless you're working with very large files that are difficult to store entirely in memory all at the same time, these two routines are for you.

```
"my-file.txt".IO.spurt: "I ♥ Perl!";
```

The code above creates a file named `my-file.txt` in the current directory and then writes text `I ♥ Perl!` into it. If Perl 6 is your first language, celebrate your accomplishment! Try to open the file you created with some other program to verify what you wrote with your program. If you already know some other language, you may be wondering if this guide missed anything like handling encoding or error conditions.

However, that is all the code you need. The string will be encoded in `utf-8` encoding by default and the errors are handled via the [Failure](https://docs.perl6.org/type/Failure) mechanism: these are exceptions you can handle using regular conditionals. In this case, we're letting all potential [Failures](https://docs.perl6.org/type/Failure) get sunk after the call and so any [Exceptions](https://docs.perl6.org/type/Exception) they contain will be thrown.

#### Appending content

If you wanted to add more content to the file we made in previous section, you could note the [`spurt` documentation](https://docs.perl6.org/routine/spurt)mentions `:append` argument. However, for finer control, let's get ourselves an [IO::Handle](https://docs.perl6.org/type/IO::Handle) to work with:

```
my $fh = 'my-file.txt'.IO.open: :a;
$fh.print: "I count: ";
$fh.print: "$_ " for ^10;
$fh.close;
```

The [`.open`](https://docs.perl6.org/routine/open) method call opens our [IO::Path](https://docs.perl6.org/type/IO::Path) and returns an [IO::Handle](https://docs.perl6.org/type/IO::Handle). We passed `:a` as argument, to indicate we want to open the file for writing in append mode.

In the next two lines of code, we use the usual [`.print`](https://docs.perl6.org/routine/print) method on that [IO::Handle](https://docs.perl6.org/type/IO::Handle) to print a line with 11 pieces of text (the `'I count: '` string and 10 numbers). Note that, once again, [Failure](https://docs.perl6.org/type/Failure) mechanism takes care of all the error checking for us. If the [`.open`](https://docs.perl6.org/routine/open) fails, it returns a [Failure](https://docs.perl6.org/type/Failure), which will throw when we attempt to call method [`.print`](https://docs.perl6.org/routine/print) on it.

Finally, we close the [IO::Handle](https://docs.perl6.org/type/IO::Handle) by calling the [`.close`](https://docs.perl6.org/routine/close) method on it. It is *important that you do it*, especially in large programs or ones that deal with a lot of files, as many systems have limits to how many files a program can have open at the same time. If you don't close your handles, eventually you'll reach that limit and the [`.open`](https://docs.perl6.org/routine/open) call will fail. Note that unlike some other languages, Perl 6 does not use reference counting, so the filehandles **are NOT closed** when the scope they're defined in is left. They will be closed only when they're garbage collected and failing to close the handles may cause your program to reach the file limit *before* the open handles get a chance to get garbage collected.

### Reading from files

#### Using IO::Path

We've seen in previous sections that writing stuff to files is a single-line of code in Perl 6. Reading from them, is similarly easy:

```
say 'my-file.txt'.IO.slurp;        # OUTPUT: «I ♥ Perl!␤» 
say 'my-file.txt'.IO.slurp: :bin;  # OUTPUT: «Buf[uint8]:0x<49 20 e2 99 a5 20 50 65 72 6c 21>␤» 
```

The [`.slurp`](https://docs.perl6.org/routine/slurp) method reads entire contents of the file and returns them as a single [Str](https://docs.perl6.org/type/Str) object, or as a [Buf](https://docs.perl6.org/type/Buf) object, if binary mode was requested, by specifying `:bin` named argument.

Since [slurping](https://docs.perl6.org/routine/slurp) loads the entire file into memory, it's not ideal for working with huge files.

The [IO::Path](https://docs.perl6.org/type/IO::Path) type offers two other handy methods: [`.words`](https://docs.perl6.org/type/IO::Path#method_words) and [`.lines`](https://docs.perl6.org/type/IO::Path#method_lines) that lazily read the file in smaller chunks and return [Seq](https://docs.perl6.org/type/Seq)objects that (by default) don't keep already-consumed values around.

Here's an example that finds lines in a text file that mention Perl and prints them out. Despite the file itself being too large to fit into available [RAM](https://en.wikipedia.org/wiki/Random-access_memory), the program will not have any issues running, as the contents are processed in small chunks:

```
.say for '500-PetaByte-File.txt'.IO.lines.grep: *.contains: 'Perl';
```

Here's another example that prints the first 100 words from a file, without loading it entirely:

```
.say for '500-PetaByte-File.txt'.IO.words: 100
```

Note that we did this by passing a limit argument to [`.words`](https://docs.perl6.org/type/IO::Path#method_words) instead of, say, using [a list indexing operation](https://docs.perl6.org/language/operators#index-entry-array_indexing_operator-array_subscript_operator-array_indexing_operator). The reason for that is there's still a filehandle in use under the hood, and until you fully consume the returned [Seq](https://docs.perl6.org/type/Seq), the handle will remain open. If nothing references the [Seq](https://docs.perl6.org/type/Seq), eventually the handle will get closed, during a garbage collection run, but in large programs that work with a lot of files, it's best to ensure all the handles get closed right away. So, you should always ensure the [Seq](https://docs.perl6.org/type/Seq) from [IO::Path](https://docs.perl6.org/type/IO::Path)'s [`.words`](https://docs.perl6.org/type/IO::Path#method_words) and [`.lines`](https://docs.perl6.org/type/IO::Path#method_lines) methods is [fully reified](https://docs.perl6.org/language/glossary#index-entry-Reify); and the limit argument is there to help you with that.

#### Using IO::Handle

Of course, you can read from files using the [IO::Handle](https://docs.perl6.org/type/IO::Handle) type, which gives you a lot finer control over what you're doing:

```
given 'some-file.txt'.IO.open {
    say .readchars: 8;  # OUTPUT: «I ♥ Perl␤» 
    .seek: 1, SeekFromCurrent;
    say .readchars: 15;  # OUTPUT: «I ♥ Programming␤» 
    .close
}
```

The [IO::Handle](https://docs.perl6.org/type/IO::Handle) gives you [.read](https://docs.perl6.org/type/IO::Handle#method_read), [.readchars](https://docs.perl6.org/type/IO::Handle#method_readchars), [.get](https://docs.perl6.org/type/IO::Handle#routine_get), [.getc](https://docs.perl6.org/type/IO::Handle#method_getc), [.words](https://docs.perl6.org/type/IO::Handle#routine_words), [.lines](https://docs.perl6.org/type/IO::Handle#routine_lines), [.slurp](https://docs.perl6.org/type/IO::Handle#routine_slurp), [.comb](https://docs.perl6.org/type/IO::Handle#method_comb), [.split](https://docs.perl6.org/type/IO::Handle#method_split), and [.Supply](https://docs.perl6.org/type/IO::Handle#method_Supply) methods to read data from it. Plenty of options; and the catch is you need to close the handle when you're done with it.

Unlike some languages, the handle won't get automatically closed when the scope it's defined in is left. Instead, it'll remain open until it's garbage collected. To make the closing business easier, some of the methods let you specify a `:close`argument, you can also use the [`will leave` trait](https://docs.perl6.org/language/phasers#index-entry-will_trait), or the `does auto-close` trait provided by the [`Trait::IO`](https://modules.perl6.org/dist/Trait::IO) module.

# The wrong way to do things

This section describes how NOT to do Perl 6 IO.

## Leave $*SPEC alone

You may have heard of [`$*SPEC`](https://docs.perl6.org/language/variables#Dynamic_variables) and seen some code or books show its usage for splitting and joining path fragments. Some of the routine names it provides may even look familiar to what you've used in other languages.

However, unless you're writing your own IO framework, you almost never need to use [`$*SPEC`](https://docs.perl6.org/language/variables#Dynamic_variables) directly. [`$*SPEC`](https://docs.perl6.org/language/variables#Dynamic_variables) provides low-level stuff and its use will not only make your code tough to read, you'll likely introduce security issues (e.g. null characters)!

The [`IO::Path`](https://docs.perl6.org/type/IO::Path) type is the workhorse of Perl 6 world. It caters to all the path manipulation needs as well as provides shortcut routines that let you avoid dealing with filehandles. Use that instead of the [`$*SPEC`](https://docs.perl6.org/language/variables#Dynamic_variables) stuff.

Tip: you can join path parts with `/` and feed them to [`IO::Path`](https://docs.perl6.org/type/IO::Path)'s routines; they'll still do The Right Thing™ with them, regardless of the operating system.

```
# WRONG!! TOO MUCH WORK! 
my $fh = open $*SPEC.catpath: '', 'foo/bar', $file;
my $data = $fh.slurp;
$fh.close;
# RIGHT! Use IO::Path to do all the dirty work 
my $data = 'foo/bar'.IO.add($file).slurp;
```

However, it's fine to use it for things not otherwise provided by [IO::Path](https://docs.perl6.org/type/IO::Path). For example, the [`.devnull` method](https://docs.perl6.org/routine/devnull):

```
{
    temp $*OUT = open :w, $*SPEC.devnull;
    say "In space no one can hear you scream!";
}
say "Hello";
```

## Stringifying IO::Path

Don't use the `.Str` method to stringify [`IO::Path`](https://docs.perl6.org/type/IO::Path) objects, unless you just want to display them somewhere for information purposes or something. The `.Str` method returns whatever basic path string the [`IO::Path`](https://docs.perl6.org/type/IO::Path) was instantiated with. It doesn't consider the value of the [`$.CWD` attribute](https://docs.perl6.org/type/IO::Path#attribute_CWD). For example, this code is broken:

```
my $path = 'foo'.IO;
chdir 'bar';
# WRONG!! .Str DOES NOT USE $.CWD! 
run <tar -cvvf archive.tar>, $path.Str;
```

The [`chdir`](https://docs.perl6.org/routine/chdir) call changed the value of the current directory, but the `$path` we created is relative to the directory before that change.

However, the [`IO::Path`](https://docs.perl6.org/type/IO::Path) object *does* know what directory it's relative to. We just need to use [`.absolute`](https://docs.perl6.org/routine/absolute) or [`.relative`](https://docs.perl6.org/routine/relative) to stringify the object. Both routines return a [`Str`](https://docs.perl6.org/type/Str) object; they only differ in whether the result is an absolute or relative path. So, we can fix our code like this:

```
my $path = 'foo'.IO;
chdir 'bar';
# RIGHT!! .absolute does consider the value of $.CWD! 
run <tar -cvvf archive.tar>, $path.absolute;
# Also good: 
run <tar -cvvf archive.tar>, $path.relative;
```

## Be mindful of $*CWD

While usually out of view, every [`IO::Path`](https://docs.perl6.org/type/IO::Path) object, by default, uses the current value of [`$*CWD`](https://docs.perl6.org/language/variables#Dynamic_variables) to set its [`$.CWD` attribute](https://docs.perl6.org/type/IO::Path#attribute_CWD). This means there are two things to pay attention to.

### temp the $*CWD

This code is a mistake:

```
# WRONG!! 
my $*CWD = "foo".IO;
```

The `my $*CWD` made [`$*CWD`](https://docs.perl6.org/language/variables#Dynamic_variables) undefined. The [`.IO`](https://docs.perl6.org/routine/IO) coercer then goes ahead and sets the [`$.CWD` attribute](https://docs.perl6.org/type/IO::Path#attribute_CWD) of the path it's creating to the stringified version of the undefined `$*CWD`; an empty string.

The correct way to perform this operation is use [`temp`](https://docs.perl6.org/routine/temp) instead of `my`. It'll localize the effect of changes to [`$*CWD`](https://docs.perl6.org/language/variables#Dynamic_variables), just like `my`would, but it won't make it undefined, so the [`.IO`](https://docs.perl6.org/routine/IO) coercer will still get the correct old value:

```
temp $*CWD = "foo".IO;
```

Better yet, if you want to perform some code in a localized [`$*CWD`](https://docs.perl6.org/language/variables#Dynamic_variables), use the [`indir` routine](https://docs.perl6.org/routine/indir) for that purpose.