原文：https://rakudocs.github.io/language/io

# 输入/输出 / Input/Output

文件相关的操作

File-related operations

这里我们简要介绍了与文件相关的输入/输出操作。有关 [IO](https://rakudocs.github.io/type/IO) 角色以及 [IO::Handle](https://rakudocs.github.io/type/IO::Handle) 和 [IO::Path](https://rakudocs.github.io/type/IO::Path) 类型的详细信息，请参阅文档。

Here we present a quick overview of the file-related input/output operations. Details can be found in the documentation for the [IO](https://rakudocs.github.io/type/IO) role, as well as the [IO::Handle](https://rakudocs.github.io/type/IO::Handle) and [IO::Path](https://rakudocs.github.io/type/IO::Path) types.

<!-- MarkdownTOC -->

- [从文件读 / Reading from files](#%E4%BB%8E%E6%96%87%E4%BB%B6%E8%AF%BB--reading-from-files)
    - [逐行读取 / Line by line](#%E9%80%90%E8%A1%8C%E8%AF%BB%E5%8F%96--line-by-line)
- [写入文件 / Writing to files](#%E5%86%99%E5%85%A5%E6%96%87%E4%BB%B6--writing-to-files)
- [复制和重命名文件 / Copying and renaming files](#%E5%A4%8D%E5%88%B6%E5%92%8C%E9%87%8D%E5%91%BD%E5%90%8D%E6%96%87%E4%BB%B6--copying-and-renaming-files)
- [检查文件和目录 / Checking files and directories](#%E6%A3%80%E6%9F%A5%E6%96%87%E4%BB%B6%E5%92%8C%E7%9B%AE%E5%BD%95--checking-files-and-directories)
- [获取目录列表 / Getting a directory listing](#%E8%8E%B7%E5%8F%96%E7%9B%AE%E5%BD%95%E5%88%97%E8%A1%A8--getting-a-directory-listing)
- [创建和删除目录 / Creating and removing directories](#%E5%88%9B%E5%BB%BA%E5%92%8C%E5%88%A0%E9%99%A4%E7%9B%AE%E5%BD%95--creating-and-removing-directories)

<!-- /MarkdownTOC -->

<a id="%E4%BB%8E%E6%96%87%E4%BB%B6%E8%AF%BB--reading-from-files"></a>
# 从文件读 / Reading from files

读取文件内容的一种方法是通过 `open` 函数打开文件，并使用 `:r` （读取）文件模式选项，用 `slurp` 方法读尽文件内容：

One way to read the contents of a file is to open the file via the `open` function with the `:r` (read) file mode option and slurp in the contents:

```Perl6
my $fh = open "testfile", :r;
my $contents = $fh.slurp;
$fh.close;
```

在这里，我们使用 `IO::Handle` 对象上的 `close` 方法显式关闭文件句柄。这是一种非常传统的读取文件内容的方法。但是，这样做更容易、更清晰：

Here we explicitly close the filehandle using the `close` method on the `IO::Handle` object. This is a very traditional way of reading the contents of a file. However, the same can be done more easily and clearly like so:

```Perl6
my $contents = "testfile".IO.slurp;
# or in procedural form: 
$contents = slurp "testfile"
```

通过将 `IO` 角色添加到文件名字符串中，我们可以有效地将该字符串称为文件对象本身，从而直接在其内容中发出声音。请注意，`slurp` 负责打开和关闭文件。

By adding the `IO` role to the file name string, we are effectively able to refer to the string as the file object itself and thus slurp in its contents directly. Note that the `slurp` takes care of opening and closing the file for you.

<a id="%E9%80%90%E8%A1%8C%E8%AF%BB%E5%8F%96--line-by-line"></a>
## 逐行读取 / Line by line

当然，我们也可以选择逐行读取文件。行分隔符（即，`$*IN.nl-in`）将被排除在外。

Of course, we also have the option to read a file line-by-line. The new line separator (i.e., `$*IN.nl-in`) will be excluded.

```Perl6
for 'huge-csv'.IO.lines -> $line {
    # Do something with $line 
}
 
# or if you'll be processing later 
my @lines = 'huge-csv'.IO.lines;
```

<a id="%E5%86%99%E5%85%A5%E6%96%87%E4%BB%B6--writing-to-files"></a>
# 写入文件 / Writing to files

要将数据写入文件，我们同样可以选择传统方法调用 `open` 函数（这次使用 `:w` （写入）选项）并将数据打印到文件：

To write data to a file, again we have the choice of the traditional method of calling the `open` function – this time with the `:w`(write) option -- and printing the data to the file:

```Perl6
my $fh = open "testfile", :w;
$fh.print("data and stuff\n");
$fh.close;
```

也可以用 `say`，这样就不再需要显式换行：

Or equivalently with `say`, thus the explicit newline is no longer necessary:

```Perl6
my $fh = open "testfile", :w;
$fh.say("data and stuff");
$fh.close;
```

我们可以通过使用 `spurt` 以写模式打开文件、将数据写入文件并再次为我们关闭文件来简化这一过程：

We can simplify this by using `spurt` to open the file in write mode, writing the data to the file and closing it again for us:

```Perl6
spurt "testfile", "data and stuff\n";
```

默认情况下，所有（文本）文件都是以 UTF-8 格式写入的，但是如果需要，可以通过 `:enc` 选项指定显式编码：

By default all (text) files are written as UTF-8, however if necessary, an explicit encoding can be specified via the `:enc` option:

```Perl6
spurt "testfile", "latin1 text: äöüß", enc => "latin1";
```

要将格式化字符串写入文件，请使用 [IO::Handle](https://rakudocs.github.io/type/IO::Handle) 的 [printf](https://rakudocs.github.io/routine/printf) 函数。

To write formatted strings to a file, use the [printf](https://rakudocs.github.io/routine/printf) function of [IO::Handle](https://rakudocs.github.io/type/IO::Handle).

```Perl6
my $fh = open "testfile", :w;
$fh.printf("formatted data %04d\n", 42);
$fh.close;
```

要附加到文件，请在显式打开文件句柄时指定 `:a` 选项，

To append to a file, specify the `:a` option when opening the filehandle explicitly,

```Perl6
my $fh = open "testfile", :a;
$fh.print("more data\n");
$fh.close;
```

也可以用 `say`，这样就不再需要显式换行，

or equivalently with `say`, thus the explicit newline is no longer necessary,

```Perl6
my $fh = open "testfile", :a;
$fh.say("more data");
$fh.close;
```

或者更简单，在调用 `spurt` 时使用 `:append` 选项：

or even simpler with the `:append` option in the call to `spurt`:

```Perl6
spurt "testfile", "more data\n", :append;
```

要显式地将二进制数据写入文件，请使用 `:bin` 选项打开该文件。然后，输入/输出操作将使用 `Buf` 类型而不是 `Str` 类型进行。

To explicitly write binary data to a file, open it with the `:bin` option. The input/output operations then will take place using the `Buf` type instead of the `Str` type.

<a id="%E5%A4%8D%E5%88%B6%E5%92%8C%E9%87%8D%E5%91%BD%E5%90%8D%E6%96%87%E4%BB%B6--copying-and-renaming-files"></a>
# 复制和重命名文件 / Copying and renaming files

例程 `copy`、`rename` 和 `move` 可用于避免低级系统命令。详情请参见[复制](https://rakudocs.github.io/routine/copy)、[重命名](https://rakudocs.github.io/routine/rename)和[移动](https://rakudocs.github.io/routine/move)。一些例子：

Routines `copy`, `rename`, and `move` are available to avoid low-level system commands. See details at [copy](https://rakudocs.github.io/routine/copy), [rename](https://rakudocs.github.io/routine/rename), and [move](https://rakudocs.github.io/routine/move). Some examples:

```Perl6
my $filea = 'foo';
my $fileb = 'foo.bak';
my $filec = '/disk1/foo';
# note 'diskN' is assumed to be a physical storage device 
 
copy $filea, $fileb;              # overwrites $fileb if it exists 
copy $filea, $fileb, :createonly; # fails if $fileb exists 
 
rename $filea, 'new-foo';              # overwrites 'new-foo' if it exists 
rename $filea, 'new-foo', :createonly; # fails if 'new-foo' exists 
 
# use move when a system-level rename may not work 
move $fileb, '/disk2/foo';              # overwrites '/disk2/foo' if it exists 
move $fileb, '/disk2/foo', :createonly; # fails if '/disk2/foo' exists 
```

<a id="%E6%A3%80%E6%9F%A5%E6%96%87%E4%BB%B6%E5%92%8C%E7%9B%AE%E5%BD%95--checking-files-and-directories"></a>
# 检查文件和目录 / Checking files and directories

对 `IO::Handle` 对象使用 `e` 方法来测试文件或目录是否存在。

Use the `e` method on an `IO::Handle` object to test whether the file or directory exists.

```Perl6
if "nonexistent_file".IO.e {
    say "file exists";
}
else {
    say "file doesn't exist";
}
```

也可以使用冒号对语法来实现相同的功能：

It is also possible to use the colon pair syntax to achieve the same thing:

```Perl6
if "path/to/file".IO ~~ :e {
    say 'file exists';
}
my $file = "path/to/file";
if $file.IO ~~ :e {
    say 'file exists';
}
```

与文件存在性检查类似，还可以检查路径是否是目录。例如，假设文件 `testfile` 和目录 `lib` 存在，我们将从存在性测试方法 `e` 中获得相同的结果，即两者都存在：

Similarly to the file existence check, one can also check to see if a path is a directory. For instance, assuming that the file `testfile` and the directory `lib` exist, we would obtain from the existence test method `e` the same result, namely that both exist:

```Perl6
say "testfile".IO.e;  # OUTPUT: «True␤» 
say "lib".IO.e;       # OUTPUT: «True␤» 
```

但是，由于其中只有一个是目录，目录测试方法 `d` 将给出不同的结果：

However, since only one of them is a directory, the directory test method `d` will give a different result:

```Perl6
say "testfile".IO.d;  # OUTPUT: «False␤» 
say "lib".IO.d;       # OUTPUT: «True␤» 
```

当然，如果我们通过文件测试方法 `f` 检查路径是否是一个文件，则会打开表：

Naturally the tables are turned if we check to see if the path is a file via the file test method `f`:

```Perl6
say "testfile".IO.f;  # OUTPUT: «True␤» 
say "lib".IO.f;       # OUTPUT: «False␤» 
```

还有其他方法可用于查询文件或目录，其中一些有用的方法有：

There are other methods that can be used to query a file or directory, some useful ones are:

```Perl6
my $f = "file";
 
say $f.IO.modified; # return time of last file (or directory) change 
say $f.IO.accessed; # return last time file (or directory) was read 
say $f.IO.s;        # return size of file (or directory inode) in bytes 
```

请参阅 [IO::Path](https://rakudocs.github.io/type/IO::Path) 上的更多方法和详细信息。

See more methods and details at [IO::Path](https://rakudocs.github.io/type/IO::Path).

<a id="%E8%8E%B7%E5%8F%96%E7%9B%AE%E5%BD%95%E5%88%97%E8%A1%A8--getting-a-directory-listing"></a>
# 获取目录列表 / Getting a directory listing

要列出当前目录的内容，使用 `dir` 函数。它返回 [IO::Path](https://rakudocs.github.io/type/IO::Path) 对象的列表。

To list the contents of the current directory, use the `dir` function. It returns a list of [IO::Path](https://rakudocs.github.io/type/IO::Path) objects.

```Perl6
say dir;          # OUTPUT: «"/path/to/testfile".IO "/path/to/lib".IO␤» 
```

要列出给定目录中的文件和目录，只需将路径作为参数传递给 `dir`：

To list the files and directories in a given directory, simply pass a path as an argument to `dir`:

```Perl6
say dir "/etc/";  # OUTPUT: «"/etc/ld.so.conf".IO "/etc/shadow".IO ....␤» 
```

<a id="%E5%88%9B%E5%BB%BA%E5%92%8C%E5%88%A0%E9%99%A4%E7%9B%AE%E5%BD%95--creating-and-removing-directories"></a>
# 创建和删除目录 / Creating and removing directories

要创建新目录，只需使用目录名作为参数调用 `mkdir` 函数：

To create a new directory, simply call the `mkdir` function with the directory name as its argument:

```Perl6
mkdir "newdir";
```

函数执行成功时返回所创建目录的名称，失败时返回 `Nil`。因此，标准的 Perl 习语工作正常：

The function returns the name of the created directory on success and `Nil` on failure. Thus the standard Perl idiom works as expected:

```Perl6
mkdir "newdir" or die "$!";
```

使用 `rmdir` 删除 *空* 目录：
Use `rmdir` to remove *empty* directories:

```Perl6
rmdir "newdir" or die "$!";
```