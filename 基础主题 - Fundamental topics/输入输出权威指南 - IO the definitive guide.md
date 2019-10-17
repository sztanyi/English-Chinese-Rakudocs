原文： https://rakudocs.github.io/language/io-guide

# 输入输出权威指南 / Input/Output the definitive guide

正确使用 Raku 输入输出

Correctly use Raku IO

<!-- MarkdownTOC -->

- [基础 / The basics](#%E5%9F%BA%E7%A1%80--the-basics)
- [探索路径 / Navigating paths](#%E6%8E%A2%E7%B4%A2%E8%B7%AF%E5%BE%84--navigating-paths)
    - [什么是 IO::Path / What's an IO::Path anyway?](#%E4%BB%80%E4%B9%88%E6%98%AF-iopath--whats-an-iopath-anyway)
    - [操作文件 / Working with files](#%E6%93%8D%E4%BD%9C%E6%96%87%E4%BB%B6--working-with-files)
        - [写入文件 / Writing into files](#%E5%86%99%E5%85%A5%E6%96%87%E4%BB%B6--writing-into-files)
            - [写入新内容 / Writing new content](#%E5%86%99%E5%85%A5%E6%96%B0%E5%86%85%E5%AE%B9--writing-new-content)
            - [追加内容 / Appending content](#%E8%BF%BD%E5%8A%A0%E5%86%85%E5%AE%B9--appending-content)
        - [从文件读取 / Reading from files](#%E4%BB%8E%E6%96%87%E4%BB%B6%E8%AF%BB%E5%8F%96--reading-from-files)
            - [使用 IO::Path / Using IO::Path](#%E4%BD%BF%E7%94%A8-iopath--using-iopath)
            - [使用 IO::Handle / Using IO::Handle](#%E4%BD%BF%E7%94%A8-iohandle--using-iohandle)
- [错误的做事方式 / The wrong way to do things](#%E9%94%99%E8%AF%AF%E7%9A%84%E5%81%9A%E4%BA%8B%E6%96%B9%E5%BC%8F--the-wrong-way-to-do-things)
    - [不要碰 $*SPEC / Leave $*SPEC alone](#%E4%B8%8D%E8%A6%81%E7%A2%B0-%24spec--leave-%24spec-alone)
    - [字符串化 IO::Path / Stringifying IO::Path](#%E5%AD%97%E7%AC%A6%E4%B8%B2%E5%8C%96-iopath--stringifying-iopath)
    - [注意 $*CWD / Be mindful of $*CWD](#%E6%B3%A8%E6%84%8F-%24cwd--be-mindful-of-%24cwd)
        - [临时化 $*CWD / temp the $*CWD](#%E4%B8%B4%E6%97%B6%E5%8C%96-%24cwd--temp-the-%24cwd)

<!-- /MarkdownTOC -->

<a id="%E5%9F%BA%E7%A1%80--the-basics"></a>
# 基础 / The basics

大多数常见的 IO 工作都是由 [IO::Path](https://rakudocs.github.io/type/IO::Path) 类型完成的。如果你想以某种形式或形状读取或写入文件，这就是你想要的类。它抽象掉了文件句柄（或“文件描述符”）的细节，因此你几乎不必考虑它们。

The vast majority of common IO work is done by the [IO::Path](https://rakudocs.github.io/type/IO::Path) type. If you want to read from or write to a file in some form or shape, this is the class you want. It abstracts away the details of filehandles (or "file descriptors") and so you mostly don't even have to think about them.

在幕后，[IO::Path](https://rakudocs.github.io/type/IO::Path) 与 [IO::Handle](https://rakudocs.github.io/type/IO::Handle) 一起使用；如果你需要比 [IO::Path](https://rakudocs.github.io/type/IO::Path) 更多的控制，可以直接使用 `IO::Handle` 类。在处理其他进程时，例如使用 [Proc](https://rakudocs.github.io/type/Proc) 或 [Proc::Async](https://rakudocs.github.io/type/Proc::Async) 类型，你还将处理 [IO::Handle](https://rakudocs.github.io/type/IO::Handle) 的*子类*： [IO::Pipe](https://rakudocs.github.io/type/IO::Pipe)。

Behind the scenes, [IO::Path](https://rakudocs.github.io/type/IO::Path) works with [IO::Handle](https://rakudocs.github.io/type/IO::Handle); a class which you can use directly if you need a bit more control than what [IO::Path](https://rakudocs.github.io/type/IO::Path) provides. When working with other processes, e.g. via [Proc](https://rakudocs.github.io/type/Proc) or [Proc::Async](https://rakudocs.github.io/type/Proc::Async) types, you'll also be dealing with a *subclass* of [IO::Handle](https://rakudocs.github.io/type/IO::Handle): the [IO::Pipe](https://rakudocs.github.io/type/IO::Pipe).

最后，你有 [IO::CatHandle](https://rakudocs.github.io/type/IO::CatHandle)，以及 [IO::Spec](https://rakudocs.github.io/type/IO::Spec) 及其子类，你很少直接使用它们。这些类为你提供了高级功能，例如将多个文件作为一个句柄进行操作，或者提供低级路径操作。

Lastly, you have the [IO::CatHandle](https://rakudocs.github.io/type/IO::CatHandle), as well as [IO::Spec](https://rakudocs.github.io/type/IO::Spec) and its subclasses, that you'll rarely, if ever, use directly. These classes give you advanced features, such as operating on multiple files as one handle, or low-level path manipulations.

与所有这些类一起，Raku 提供了几个子例程，可以让你间接地使用这些类。如果你喜欢函数式编程风格或 Raku 一行程序，这些都很有用。

Along with all these classes, Raku provides several subroutines that let you indirectly work with these classes. These come in handy if you like functional programming style or in Raku one liners.

虽然 [IO::Socket](https://rakudocs.github.io/type/IO::Socket) 及其子类也与输入和输出有关，但本指南不介绍它们。

While [IO::Socket](https://rakudocs.github.io/type/IO::Socket) and its subclasses also have to do with Input and Output, this guide does not cover them.

<a id="%E6%8E%A2%E7%B4%A2%E8%B7%AF%E5%BE%84--navigating-paths"></a>
# 探索路径 / Navigating paths

<a id="%E4%BB%80%E4%B9%88%E6%98%AF-iopath--whats-an-iopath-anyway"></a>
## 什么是 IO::Path / What's an IO::Path anyway?

要将路径表示为文件或目录，请使用 [IO::Path](https://rakudocs.github.io/type/IO::Path) 类型。获取该类型对象的最简单方法是通过对其调用 [`.IO`](https://rakudocs.github.io/routine/IO) 方法来强制转换 [Str](https://rakudocs.github.io/type/Str) 类型：

To represent paths as either files or directories, use [IO::Path](https://rakudocs.github.io/type/IO::Path) type. The simplest way to obtain an object of that type is to coerce a [Str](https://rakudocs.github.io/type/Str) by calling [`.IO`](https://rakudocs.github.io/routine/IO) method on it:

```Raku
say 'my-file.txt'.IO; # OUTPUT: «"my-file.txt".IO␤» 
```

这里似乎缺少了一些东西，没有涉及到磁盘卷或绝对路径，但这些信息实际上存在于对象中。你可以通过使用 [`.perl`](https://rakudocs.github.io/routine/perl) 方法看到它：

It may seem like something is missing here—there is no volume or absolute path involved—but that information is actually present in the object. You can see it by using [`.perl`](https://rakudocs.github.io/routine/perl) method:

```Raku
say 'my-file.txt'.IO.perl;
# OUTPUT: «IO::Path.new("my-file.txt", :SPEC(IO::Spec::Unix), :CWD("/home/camelia"))␤» 
```

`SPEC` 和 `CWD` 这两个额外的属性指定了路径应该使用的操作系统语义类型以及路径的“当前工作目录”，即，如果路径是相对路径，则它是相对于该目录的。

The two extra attributes—`SPEC` and `CWD`—specify what type of operating system semantics the path should use as well as the "current working directory" for the path, i.e. if it's a relative path, then it's relative to that directory.

这意味着，不管你是如何创建的，[IO::Path](https://rakudocs.github.io/type/IO::Path) 对象技术上总是引用绝对路径。这就是它的 [`.absolute`](https://rakudocs.github.io/routine/absolute) 和 [`.relative`](https://rakudocs.github.io/routine/relative) 方法返回 [Str](https://rakudocs.github.io/type/Str) 对象的原因，它们是正确的路径字符串化方法。

This means that regardless of how you made one, an [IO::Path](https://rakudocs.github.io/type/IO::Path) object technically always refers to an absolute path. This is why its [`.absolute`](https://rakudocs.github.io/routine/absolute) and [`.relative`](https://rakudocs.github.io/routine/relative) methods return [Str](https://rakudocs.github.io/type/Str) objects and they are the correct way to stringify a path.

但是，不要急于将任何东西字符串化。将文件路径作为 [IO::Path](https://rakudocs.github.io/type/IO::Path) 对象传递。所有在文件路径上操作的例程都可以处理它们，因此不需要转换它们。

However, don't be in a rush to stringify anything. Pass paths around as [IO::Path](https://rakudocs.github.io/type/IO::Path) objects. All the routines that operate on paths can handle them, so there's no need to convert them.

<a id="%E6%93%8D%E4%BD%9C%E6%96%87%E4%BB%B6--working-with-files"></a>
## 操作文件 / Working with files

<a id="%E5%86%99%E5%85%A5%E6%96%87%E4%BB%B6--writing-into-files"></a>
### 写入文件 / Writing into files

<a id="%E5%86%99%E5%85%A5%E6%96%B0%E5%86%85%E5%AE%B9--writing-new-content"></a>
#### 写入新内容 / Writing new content

让我们制作一些文件，并从中写入和读取数据！[`spurt`](https://rakudocs.github.io/routine/spurt) 和 [`slurp`](https://rakudocs.github.io/routine/slurp) 例程在一个块中写入和读取数据。除非你正在处理非常大的文件，这些文件很难同时完全存储在内存中，否则这两个例程都是为你准备的。

Let's make some files and write and read data from them! The [`spurt`](https://rakudocs.github.io/routine/spurt) and [`slurp`](https://rakudocs.github.io/routine/slurp) routines write and read the data in one chunk. Unless you're working with very large files that are difficult to store entirely in memory all at the same time, these two routines are for you.

```Raku
"my-file.txt".IO.spurt: "I ♥ Perl!";
```

上面的代码在当前目录中创建一个名为 `my-file.txt` 的文件，然后写入文本 `I ♥ Perl!`。如果 Raku 是你的第一语言，请庆祝你的成就！尝试打开用其他程序创建的文件，以验证用程序编写的内容。如果你已经知道其他语言，你可能会想知道本指南是否遗漏了处理编码或错误条件之类的内容。

The code above creates a file named `my-file.txt` in the current directory and then writes text `I ♥ Perl!` into it. If Raku is your first language, celebrate your accomplishment! Try to open the file you created with some other program to verify what you wrote with your program. If you already know some other language, you may be wondering if this guide missed anything like handling encoding or error conditions.

但是，这就是你所需要的所有代码。默认情况下，字符串将被编码为 `utf-8` 编码，错误通过 [Failure](https://rakudocs.github.io/type/Failure) 机制处理：这些是可以使用常规条件处理的异常。在这种情况下，我们会让所有潜在的 [Failure](https://rakudocs.github.io/type/Failure) 在调用后都被下沉，因此它们包含的任何 [Exceptions](https://rakudocs.github.io/type/Exception) 都将被抛出。

However, that is all the code you need. The string will be encoded in `utf-8` encoding by default and the errors are handled via the [Failure](https://rakudocs.github.io/type/Failure) mechanism: these are exceptions you can handle using regular conditionals. In this case, we're letting all potential [Failures](https://rakudocs.github.io/type/Failure) get sunk after the call and so any [Exceptions](https://rakudocs.github.io/type/Exception) they contain will be thrown.

<a id="%E8%BF%BD%E5%8A%A0%E5%86%85%E5%AE%B9--appending-content"></a>
#### 追加内容 / Appending content

如果你想向上一节中的文件添加更多内容，[`spurt` 文档](https://rakudocs.github.io/routine/spurt)提到了 `:append` 参数。但是，为了更好地控制，让我们为自己准备一个 [IO::Handle](https://rakudocs.github.io/type/IO::Handle) 来处理：

If you wanted to add more content to the file we made in previous section, you could note the [`spurt` documentation](https://rakudocs.github.io/routine/spurt) mentions `:append` argument. However, for finer control, let's get ourselves an [IO::Handle](https://rakudocs.github.io/type/IO::Handle) to work with:

```Raku
my $fh = 'my-file.txt'.IO.open: :a;
$fh.print: "I count: ";
$fh.print: "$_ " for ^10;
$fh.close;
```

[`.open`](https://rakudocs.github.io/routine/open) 方法调用打开我们的 [IO::Path](https://rakudocs.github.io/type/IO::Path) 并返回一个 [IO::Handle](https://rakudocs.github.io/type/IO::Handle)。我们传递了 `:a` 作为参数，以指示我们要以追加模式打开文件进行写入。

The [`.open`](https://rakudocs.github.io/routine/open) method call opens our [IO::Path](https://rakudocs.github.io/type/IO::Path) and returns an [IO::Handle](https://rakudocs.github.io/type/IO::Handle). We passed `:a` as argument, to indicate we want to open the file for writing in append mode.

在接下来的两行代码中，我们在该 [IO::Handle](https://rakudocs.github.io/type/IO::Handle) 方法上使用了常用的 [`.print`](https://rakudocs.github.io/routine/print) 来打印包含 11 个文本碎片的行（`'I count: '` 字符串和 10 个数字）。请注意，再一次，[Failure](https://rakudocs.github.io/type/Failure) 机制负责我们所有的错误检查。如果 [`.open`](https://rakudocs.github.io/routine/open) 失败，它将返回一个 [Failure](https://rakudocs.github.io/type/Failure)，当我们试图调用方法 [`.print`]（https://rakudocs.github.io/routine/print）时，它将抛出这个异常。

In the next two lines of code, we use the usual [`.print`](https://rakudocs.github.io/routine/print) method on that [IO::Handle](https://rakudocs.github.io/type/IO::Handle) to print a line with 11 pieces of text (the `'I count: '` string and 10 numbers). Note that, once again, [Failure](https://rakudocs.github.io/type/Failure) mechanism takes care of all the error checking for us. If the [`.open`](https://rakudocs.github.io/routine/open) fails, it returns a [Failure](https://rakudocs.github.io/type/Failure), which will throw when we attempt to call method [`.print`](https://rakudocs.github.io/routine/print) on it.

最后，我们通过调用 [`.close`](https://rakudocs.github.io/routine/close) 方法来关闭 [IO::Handle](https://rakudocs.github.io/type/IO::Handle)。做这件事非常重要，尤其是在大型程序或处理大量文件的程序中，因为许多系统对一个程序可以同时打开的文件数量有限制。如果不关闭句柄，最终将达到该限制，则 [`.open`](https://rakudocs.github.io/routine/open) 调用将失败。请注意，与其他一些语言不同，Raku 不使用引用计数，因此在离开文件句柄定义的作用域时，文件句柄**不会关闭**。它们只有在被垃圾收集时才会被关闭，如果不关闭句柄，可能会导致程序在打开的句柄有机会被垃圾收集*之前*达到文件句柄数量限制。

Finally, we close the [IO::Handle](https://rakudocs.github.io/type/IO::Handle) by calling the [`.close`](https://rakudocs.github.io/routine/close) method on it. It is *important that you do it*, especially in large programs or ones that deal with a lot of files, as many systems have limits to how many files a program can have open at the same time. If you don't close your handles, eventually you'll reach that limit and the [`.open`](https://rakudocs.github.io/routine/open) call will fail. Note that unlike some other languages, Raku does not use reference counting, so the filehandles **are NOT closed** when the scope they're defined in is left. They will be closed only when they're garbage collected and failing to close the handles may cause your program to reach the file limit *before* the open handles get a chance to get garbage collected.

<a id="%E4%BB%8E%E6%96%87%E4%BB%B6%E8%AF%BB%E5%8F%96--reading-from-files"></a>
### 从文件读取 / Reading from files

<a id="%E4%BD%BF%E7%94%A8-iopath--using-iopath"></a>
#### 使用 IO::Path / Using IO::Path

在前面的部分中，我们已经看到在 Raku 中，将内容写入文件只是一行代码。从他们那里读，同样容易：

We've seen in previous sections that writing stuff to files is a single-line of code in Raku. Reading from them, is similarly easy:

```Raku
say 'my-file.txt'.IO.slurp;        # OUTPUT: «I ♥ Perl!␤» 
say 'my-file.txt'.IO.slurp: :bin;  # OUTPUT: «Buf[uint8]:0x<49 20 e2 99 a5 20 50 65 72 6c 21>␤» 
```

[`.slurp`](https://rakudocs.github.io/routine/slurp) 方法读取文件的全部内容，并将其作为单个 [Str](https://rakudocs.github.io/type/Str) 对象返回，或者作为 [Buf](https://rakudocs.github.io/type/Buf) 对象返回，如果需要返回二进制，则通过指定 `:bin` 命名参数。

The [`.slurp`](https://rakudocs.github.io/routine/slurp) method reads entire contents of the file and returns them as a single [Str](https://rakudocs.github.io/type/Str) object, or as a [Buf](https://rakudocs.github.io/type/Buf) object, if binary mode was requested, by specifying `:bin` named argument.

因为 [slurp](https://rakudocs.github.io/routine/slurp) 将整个文件加载到内存中，所以不适合处理大型文件。

Since [slurping](https://rakudocs.github.io/routine/slurp) loads the entire file into memory, it's not ideal for working with huge files.

[IO::Path](https://rakudocs.github.io/type/IO::Path) 类型提供了另外两种方便的方法： [`.words`](https://rakudocs.github.io/type/IO::Path#method_words) 和 [`.lines`](https://rakudocs.github.io/type/IO::Path#method_lines)，它们可以轻松地将文件分块读取并返回 [Seq](https://rakudocs.github.io/type/Seq) 对象，默认情况下不保留已消耗值的对象。

The [IO::Path](https://rakudocs.github.io/type/IO::Path) type offers two other handy methods: [`.words`](https://rakudocs.github.io/type/IO::Path#method_words) and [`.lines`](https://rakudocs.github.io/type/IO::Path#method_lines) that lazily read the file in smaller chunks and return [Seq](https://rakudocs.github.io/type/Seq) objects that (by default) don't keep already-consumed values around.

下面是一个例子，它在一个提到 Perl 的文本文件中找到行并打印出来。尽管文件本身太大，无法放入可用的 [RAM](https://en.wikipedia.org/wiki/Random-access_memory)，但程序将不会运行任何问题，因为内容是以小块处理的：

Here's an example that finds lines in a text file that mention Perl and prints them out. Despite the file itself being too large to fit into available [RAM](https://en.wikipedia.org/wiki/Random-access_memory), the program will not have any issues running, as the contents are processed in small chunks:

```Raku
.say for '500-PetaByte-File.txt'.IO.lines.grep: *.contains: 'Perl';
```

下面是另一个示例，它从文件中打印前 100 个单词，而不完全加载：

Here's another example that prints the first 100 words from a file, without loading it entirely:

```Raku
.say for '500-PetaByte-File.txt'.IO.words: 100
```

请注意，我们通过将限制参数传递给 [`.words`](https://rakudocs.github.io/type/IO::Path#method_words)，而不是使用[列表索引操作](https://rakudocs.github.io/language/operators#index-entry-array_indexing_operator-array_subscript_operator-array_indexing_operator)。原因是底层仍有一个文件句柄在使用，在你完全消耗掉返回的 [Seq](https://rakudocs.github.io/type/Seq) 之前，该句柄将保持打开状态。如果没有任何内容引用 [Seq](https://rakudocs.github.io/type/Seq)，那么在垃圾收集运行期间，最终会关闭句柄，但是在处理大量文件的大型程序中，最好确保立即关闭所有句柄。因此，你应该始终确保来自 [IO::Path](https://rakudocs.github.io/type/IO::Path) 的 [`.words`](https://rakudocs.github.io/type/IO::Path#method_words) 和 [`.lines`](https://rakudocs.github.io/type/IO::Path#method_lines) 方法是[完全具体化的](https://rakudocs.github.io/language/glossary#index-entry-Reify)；这里的 limit 参数可以帮助你实现这一点。

Note that we did this by passing a limit argument to [`.words`](https://rakudocs.github.io/type/IO::Path#method_words) instead of, say, using [a list indexing operation](https://rakudocs.github.io/language/operators#index-entry-array_indexing_operator-array_subscript_operator-array_indexing_operator). The reason for that is there's still a filehandle in use under the hood, and until you fully consume the returned [Seq](https://rakudocs.github.io/type/Seq), the handle will remain open. If nothing references the [Seq](https://rakudocs.github.io/type/Seq), eventually the handle will get closed, during a garbage collection run, but in large programs that work with a lot of files, it's best to ensure all the handles get closed right away. So, you should always ensure the [Seq](https://rakudocs.github.io/type/Seq) from [IO::Path](https://rakudocs.github.io/type/IO::Path)'s [`.words`](https://rakudocs.github.io/type/IO::Path#method_words) and [`.lines`](https://rakudocs.github.io/type/IO::Path#method_lines) methods is [fully reified](https://rakudocs.github.io/language/glossary#index-entry-Reify); and the limit argument is there to help you with that.

<a id="%E4%BD%BF%E7%94%A8-iohandle--using-iohandle"></a>
#### 使用 IO::Handle / Using IO::Handle

当然，你可以使用 [IO::Handle](https://rakudocs.github.io/type/IO::Handle) 类型从文件中读取，这样你可以更好地控制正在执行的操作：

Of course, you can read from files using the [IO::Handle](https://rakudocs.github.io/type/IO::Handle) type, which gives you a lot finer control over what you're doing:

```Raku
given 'some-file.txt'.IO.open {
    say .readchars: 8;  # OUTPUT: «I ♥ Perl␤» 
    .seek: 1, SeekFromCurrent;
    say .readchars: 15;  # OUTPUT: «I ♥ Programming␤» 
    .close
}
```

[IO::Handle](https://rakudocs.github.io/type/IO::Handle) 为你提供了 [.read](https://rakudocs.github.io/type/IO::Handle#method_read)、 [.readchars](https://rakudocs.github.io/type/IO::Handle#method_readchars)、 [.get](https://rakudocs.github.io/type/IO::Handle#routine_get)、 [.getc](https://rakudocs.github.io/type/IO::Handle#method_getc)、 [.words](https://rakudocs.github.io/type/IO::Handle#routine_words)、 [.lines](https://rakudocs.github.io/type/IO::Handle#routine_lines)、 [.slurp](https://rakudocs.github.io/type/IO::Handle#routine_slurp)、 [.comb](https://rakudocs.github.io/type/IO::Handle#method_comb)、 [.split](https://rakudocs.github.io/type/IO::Handle#method_split)、 以及 [.Supply](https://rakudocs.github.io/type/IO::Handle#method_Supply) 方法从中读取数据。有很多选择，但关键是当你完成后，你需要关闭手柄。

The [IO::Handle](https://rakudocs.github.io/type/IO::Handle) gives you [.read](https://rakudocs.github.io/type/IO::Handle#method_read), [.readchars](https://rakudocs.github.io/type/IO::Handle#method_readchars), [.get](https://rakudocs.github.io/type/IO::Handle#routine_get), [.getc](https://rakudocs.github.io/type/IO::Handle#method_getc), [.words](https://rakudocs.github.io/type/IO::Handle#routine_words), [.lines](https://rakudocs.github.io/type/IO::Handle#routine_lines), [.slurp](https://rakudocs.github.io/type/IO::Handle#routine_slurp), [.comb](https://rakudocs.github.io/type/IO::Handle#method_comb), [.split](https://rakudocs.github.io/type/IO::Handle#method_split), and [.Supply](https://rakudocs.github.io/type/IO::Handle#method_Supply) methods to read data from it. Plenty of options; and the catch is you need to close the handle when you're done with it.

与某些语言不同，当离开句柄定义的作用域时，它不会自动关闭。相反，它将一直保持打开，直到被垃圾收集。为了使句柄关闭更容易，有些方法允许你指定一个 `:close` 参数，你还可以使用 [`will leave` 特征](https://rakudocs.github.io/language/phasers#index-entry-will_trait)，或者由 [`Trait::IO`](https://modules.perl6.org/dist/Trait::IO) 模组提供的 `does auto-close` 特征。

Unlike some languages, the handle won't get automatically closed when the scope it's defined in is left. Instead, it'll remain open until it's garbage collected. To make the closing business easier, some of the methods let you specify a `:close` argument, you can also use the [`will leave` trait](https://rakudocs.github.io/language/phasers#index-entry-will_trait), or the `does auto-close` trait provided by the [`Trait::IO`](https://modules.perl6.org/dist/Trait::IO) module.

<a id="%E9%94%99%E8%AF%AF%E7%9A%84%E5%81%9A%E4%BA%8B%E6%96%B9%E5%BC%8F--the-wrong-way-to-do-things"></a>
# 错误的做事方式 / The wrong way to do things

本节介绍 Perl6 IO *不该*做的事情。

This section describes how NOT to do Raku IO.

<a id="%E4%B8%8D%E8%A6%81%E7%A2%B0-%24spec--leave-%24spec-alone"></a>
## 不要碰 $*SPEC / Leave $*SPEC alone

你可能听说过 [`$*SPEC`](https://rakudocs.github.io/language/variables#Dynamic_variables) 并看到一些代码或书籍展示了它对分割和连接路径片段的用法。它提供的一些例程名称甚至可能看起来与你在其他语言中使用的名称很类似。

You may have heard of [`$*SPEC`](https://rakudocs.github.io/language/variables#Dynamic_variables) and seen some code or books show its usage for splitting and joining path fragments. Some of the routine names it provides may even look familiar to what you've used in other languages.

但是，除非你正在编写自己的 IO 框架，否则几乎不需要直接使用 [`$*SPEC`](https://rakudocs.github.io/language/variables#Dynamic_variables)。[`$*SPEC`](https://rakudocs.github.io/language/variables#Dynamic_variables) 提供了底层的东西，它的使用不仅会使你的代码难以阅读，还可能带来安全问题（如 null 字符）！

However, unless you're writing your own IO framework, you almost never need to use [`$*SPEC`](https://rakudocs.github.io/language/variables#Dynamic_variables) directly. [`$*SPEC`](https://rakudocs.github.io/language/variables#Dynamic_variables) provides low-level stuff and its use will not only make your code tough to read, you'll likely introduce security issues (e.g. null characters)!

[`IO::Path`](https://rakudocs.github.io/type/IO::Path) 类型是 Raku 世界的老黄牛。它满足了所有文件路径操作的需要，并提供了快捷例程，使你可以避免处理文件句柄。使用它而不是 [`$*SPEC`](https://rakudocs.github.io/language/variables#Dynamic_variables)。

The [`IO::Path`](https://rakudocs.github.io/type/IO::Path) type is the workhorse of Raku world. It caters to all the path manipulation needs as well as provides shortcut routines that let you avoid dealing with filehandles. Use that instead of the [`$*SPEC`](https://rakudocs.github.io/language/variables#Dynamic_variables) stuff.

提示：你可以使用 `/` 连接文件路径部件，并将它们馈送给 [`IO::Path`](https://rakudocs.github.io/type/IO::Path) 的例程；不管操作系统如何，它们仍然可以对它们执行正确的操作。

Tip: you can join path parts with `/` and feed them to [`IO::Path`](https://rakudocs.github.io/type/IO::Path)'s routines; they'll still do The Right Thing™ with them, regardless of the operating system.

```Raku
# 错误！！做得太多！ / WRONG!! TOO MUCH WORK! 
my $fh = open $*SPEC.catpath: '', 'foo/bar', $file;
my $data = $fh.slurp;
$fh.close;
# 正确！使用 IO::Path 去做所有的脏活 / RIGHT! Use IO::Path to do all the dirty work 
my $data = 'foo/bar'.IO.add($file).slurp;
```

但是，可以将其用于 [IO::Path](https://rakudocs.github.io/type/IO::Path) 未提供的内容。例如，[`.devnull`方法](https://rakudocs.github.io/routine/devnull)：

However, it's fine to use it for things not otherwise provided by [IO::Path](https://rakudocs.github.io/type/IO::Path). For example, the [`.devnull` method](https://rakudocs.github.io/routine/devnull):

```Raku
{
    temp $*OUT = open :w, $*SPEC.devnull;
    say "In space no one can hear you scream!";
}
say "Hello";
```

<a id="%E5%AD%97%E7%AC%A6%E4%B8%B2%E5%8C%96-iopath--stringifying-iopath"></a>
## 字符串化 IO::Path / Stringifying IO::Path

不要使用 `.Str` 方法来字符串化 [`IO::Path`](https://rakudocs.github.io/type/IO::Path) 对象，除非你只想出于信息目的或其他原因将它们显示在某个地方。`.Str` 方法返回 [`IO::Path`](https://rakudocs.github.io/type/IO::Path) 实例化时用的任何基本路径字符串。它不考虑 [`$.CWD` 属性](https://rakudocs.github.io/type/IO::Path#attribute_CWD)。例如，此代码是破损的：

Don't use the `.Str` method to stringify [`IO::Path`](https://rakudocs.github.io/type/IO::Path) objects, unless you just want to display them somewhere for information purposes or something. The `.Str` method returns whatever basic path string the [`IO::Path`](https://rakudocs.github.io/type/IO::Path) was instantiated with. It doesn't consider the value of the [`$.CWD` attribute](https://rakudocs.github.io/type/IO::Path#attribute_CWD). For example, this code is broken:

```Raku
my $path = 'foo'.IO;
chdir 'bar';
# WRONG!! .Str DOES NOT USE $.CWD! 
run <tar -cvvf archive.tar>, $path.Str;
```

[`chdir`](https://rakudocs.github.io/routine/chdir) 调用更改了当前目录的值，但我们创建的 `$path` 是相对于更改前的目录的。

The [`chdir`](https://rakudocs.github.io/routine/chdir) call changed the value of the current directory, but the `$path` we created is relative to the directory before that change.

但是，[`IO::Path`](https://rakudocs.github.io/type/IO::Path) 对象*的确*知道它与哪个目录相关。我们只需要使用 [`.absolute`](https://rakudocs.github.io/routine/absolute) 或 [`.relative`](https://rakudocs.github.io/routine/relative) 对对象进行字符串化。两个例程都返回一个 [`Str`](https://rakudocs.github.io/type/Str) 对象；它们只在结果是绝对路径还是相对路径上有所不同。因此，我们可以这样修复代码：

However, the [`IO::Path`](https://rakudocs.github.io/type/IO::Path) object *does* know what directory it's relative to. We just need to use [`.absolute`](https://rakudocs.github.io/routine/absolute) or [`.relative`](https://rakudocs.github.io/routine/relative) to stringify the object. Both routines return a [`Str`](https://rakudocs.github.io/type/Str) object; they only differ in whether the result is an absolute or relative path. So, we can fix our code like this:

```Raku
my $path = 'foo'.IO;
chdir 'bar';
# RIGHT!! .absolute does consider the value of $.CWD! 
run <tar -cvvf archive.tar>, $path.absolute;
# Also good: 
run <tar -cvvf archive.tar>, $path.relative;
```

<a id="%E6%B3%A8%E6%84%8F-%24cwd--be-mindful-of-%24cwd"></a>
## 注意 $*CWD / Be mindful of $*CWD

虽然通常不在视图中，但默认情况下，每个 [`IO::Path`](https://rakudocs.github.io/type/IO::Path) 对象使用 [`$*CWD`](https://rakudocs.github.io/language/variables#Dynamic_variables) 的当前值来设置其 [`$.CWD` 属性](https://rakudocs.github.io/type/IO::Path#attribute_CWD)。这意味着有两件事需要注意。

While usually out of view, every [`IO::Path`](https://rakudocs.github.io/type/IO::Path) object, by default, uses the current value of [`$*CWD`](https://rakudocs.github.io/language/variables#Dynamic_variables) to set its [`$.CWD` attribute](https://rakudocs.github.io/type/IO::Path#attribute_CWD). This means there are two things to pay attention to.

<a id="%E4%B8%B4%E6%97%B6%E5%8C%96-%24cwd--temp-the-%24cwd"></a>
### 临时化 $*CWD / temp the $*CWD

此代码是错误的：

This code is a mistake:

```Raku
# WRONG!! 
my $*CWD = "foo".IO;
```

`my $*CWD` 使得 [`$*CWD`](https://rakudocs.github.io/language/variables#Dynamic_variables) 未定义。[`.IO`](https://rakudocs.github.io/routine/IO) 强制转换程序继续执行，并将其创建的文件路径的 [`$.CWD` 属性](https://rakudocs.github.io/type/IO::Path#attribute_CWD) 设置为未定义的 `$*CWD` 的字符串版本；一个空字符串。

The `my $*CWD` made [`$*CWD`](https://rakudocs.github.io/language/variables#Dynamic_variables) undefined. The [`.IO`](https://rakudocs.github.io/routine/IO) coercer then goes ahead and sets the [`$.CWD` attribute](https://rakudocs.github.io/type/IO::Path#attribute_CWD) of the path it's creating to the stringified version of the undefined `$*CWD`; an empty string.

执行此操作的正确方法是使用 [`temp`](https://rakudocs.github.io/routine/temp)，而不是使用 `my`。它将把更改的效果本地化为 [`$*CWD`](https://rakudocs.github.io/language/variables#Dynamic_variables)，就像 `my` 一样，但它不会使其未定义，因此 [`.IO`](https://rakudocs.github.io/routine/IO) 强制转换程序仍将获得正确的旧值：

The correct way to perform this operation is use [`temp`](https://rakudocs.github.io/routine/temp) instead of `my`. It'll localize the effect of changes to [`$*CWD`](https://rakudocs.github.io/language/variables#Dynamic_variables), just like `my` would, but it won't make it undefined, so the [`.IO`](https://rakudocs.github.io/routine/IO) coercer will still get the correct old value:

```Raku
temp $*CWD = "foo".IO;
```

更好的是，如果你想在本地化的 [`$*CWD`](https://rakudocs.github.io/language/variables#Dynamic_variables) 中执行一些代码，请使用 [`indir` 例程](https://rakudocs.github.io/routine/indir)。

Better yet, if you want to perform some code in a localized [`$*CWD`](https://rakudocs.github.io/language/variables#Dynamic_variables), use the [`indir` routine](https://rakudocs.github.io/routine/indir) for that purpose.