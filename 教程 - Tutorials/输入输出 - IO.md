原文：https://docs.raku.org/language/io

# 输入/输出 - Input/Output

文件相关的操作

File-related operations

在这里，我们简要介绍了与文件相关的输入/输出操作。详细信息可以在 [IO](https://docs.raku.org/type/IO) 角色，以及 [IO::Handle](https://docs.raku.org/type/IO::Handle) 和 [IO::Path](https://docs.raku.org/type/IO::Path) 类型的文档中找到。

Here we present a quick overview of the file-related input/output operations. Details can be found in the documentation for the [IO](https://docs.raku.org/type/IO) role, as well as the [IO::Handle](https://docs.raku.org/type/IO::Handle) and [IO::Path](https://docs.raku.org/type/IO::Path) types.

<!-- MarkdownTOC -->

- [读文件 / Reading from files](#%E8%AF%BB%E6%96%87%E4%BB%B6--reading-from-files)
    - [逐行读取 / Line by line](#%E9%80%90%E8%A1%8C%E8%AF%BB%E5%8F%96--line-by-line)
- [写文件 / Writing to files](#%E5%86%99%E6%96%87%E4%BB%B6--writing-to-files)
- [复制、重命名和删除文件 / Copying, renaming, and removing files](#%E5%A4%8D%E5%88%B6%E3%80%81%E9%87%8D%E5%91%BD%E5%90%8D%E5%92%8C%E5%88%A0%E9%99%A4%E6%96%87%E4%BB%B6--copying-renaming-and-removing-files)
- [检查文件和目录 / Checking files and directories](#%E6%A3%80%E6%9F%A5%E6%96%87%E4%BB%B6%E5%92%8C%E7%9B%AE%E5%BD%95--checking-files-and-directories)
- [获取目录列表 / Getting a directory listing](#%E8%8E%B7%E5%8F%96%E7%9B%AE%E5%BD%95%E5%88%97%E8%A1%A8--getting-a-directory-listing)
- [创建和删除目录 / Creating and removing directories](#%E5%88%9B%E5%BB%BA%E5%92%8C%E5%88%A0%E9%99%A4%E7%9B%AE%E5%BD%95--creating-and-removing-directories)

<!-- /MarkdownTOC -->


<a id="%E8%AF%BB%E6%96%87%E4%BB%B6--reading-from-files"></a>
# 读文件 / Reading from files

读取文件内容的一种方法是使用 `:r` 文件模式选项通过 `open` 函数打开文件，并在代码内容中使用 slurp 方法：

One way to read the contents of a file is to open the file via the `open` function with the `:r` (read) file mode option and slurp in the contents:

```Raku
my $fh = open "testfile", :r;
my $contents = $fh.slurp;
$fh.close;
```

在这里，我们使用 `IO::Handle` 对象上的 `close` 方法显式关闭文件句柄。这是一种非常传统的读取文件内容的方法。然而，也可以更容易和清楚地这样做：

Here we explicitly close the filehandle using the `close` method on the `IO::Handle` object. This is a very traditional way of reading the contents of a file. However, the same can be done more easily and clearly like so:

```Raku
my $contents = "testfile".IO.slurp;
# or in procedural form: 
$contents = slurp "testfile"
```

通过将 `IO` 角色添加到文件名字符串中，我们可以有效地将字符串称为文件对象本身，从而直接全部读取其内容。请注意，`slurp` 负责为你打开和关闭文件。

By adding the `IO` role to the file name string, we are effectively able to refer to the string as the file object itself and thus slurp in its contents directly. Note that the `slurp` takes care of opening and closing the file for you.

<a id="%E9%80%90%E8%A1%8C%E8%AF%BB%E5%8F%96--line-by-line"></a>
## 逐行读取 / Line by line

当然，我们也可以选择逐行读取文件。换行符（即 `$*IN.nl-in`）已经被去除掉了。

Of course, we also have the option to read a file line-by-line. The new line separator (i.e., `$*IN.nl-in`) will be excluded.

```Raku
for 'huge-csv'.IO.lines -> $line {
    # Do something with $line 
}
 
# or if you'll be processing later 
my @lines = 'huge-csv'.IO.lines;
```

<a id="%E5%86%99%E6%96%87%E4%BB%B6--writing-to-files"></a>
# 写文件 / Writing to files

要将数据写入文件，我们同样可以选择调用 `open` 函数的传统方法--这次使用 `:w` 选项--并将数据打印到文件中：

To write data to a file, again we have the choice of the traditional method of calling the `open` function – this time with the `:w` (write) option – and printing the data to the file:

```Raku
my $fh = open "testfile", :w;
$fh.print("data and stuff\n");
$fh.close;
```

等同于使用 `say` 方法，因此不再需要显式换行符：

Or equivalently with `say`, thus the explicit newline is no longer necessary:

```Raku
my $fh = open "testfile", :w;
$fh.say("data and stuff");
$fh.close;
```

我们可以通过使用 `spurt` 以写模式打开文件，将数据写入文件并为我们再次关闭它来简化这一点：

We can simplify this by using `spurt` to open the file in write mode, writing the data to the file and closing it again for us:

```Raku
spurt "testfile", "data and stuff\n";
```

默认情况下，所有（文本）文件都是以 UTF-8 格式写入的，但是，如果有必要，可以通过 `:enc` 选项显式指定编码：

By default all (text) files are written as UTF-8, however if necessary, an explicit encoding can be specified via the `:enc` option:

```Raku
spurt "testfile", "latin1 text: äöüß", enc => "latin1";
```

若要将格式化字符串写入文件，请使用 [IO::Handle](https://docs.raku.org/type/IO::Handle) 的 [printf](https://docs.raku.org/routine/printf) 函数。

To write formatted strings to a file, use the [printf](https://docs.raku.org/routine/printf) function of [IO::Handle](https://docs.raku.org/type/IO::Handle).

```Raku
my $fh = open "testfile", :w;
$fh.printf("formatted data %04d\n", 42);
$fh.close;
```

若要追加写入到文件，请在显式打开文件句柄时指定 `:a` 选项，

To append to a file, specify the `:a` option when opening the filehandle explicitly,

```Raku
my $fh = open "testfile", :a;
$fh.print("more data\n");
$fh.close;
```

等同于使用 `say` 方法，因此不再需要显式换行符：

or equivalently with `say`, thus the explicit newline is no longer necessary,

```Raku
my $fh = open "testfile", :a;
$fh.say("more data");
$fh.close;
```

或者更简单地使用 `spurt` 调用中的 `:append` 选项：

or even simpler with the `:append` option in the call to `spurt`:

```Raku
spurt "testfile", "more data\n", :append;
```

若要显式地将二进制数据写入文件，请使用 `:bin` 选项打开它。然后，输入/输出操作将使用 `Buf` 类型而不是 `Str` 类型进行。

To explicitly write binary data to a file, open it with the `:bin` option. The input/output operations then will take place using the `Buf` type instead of the `Str` type.

<a id="%E5%A4%8D%E5%88%B6%E3%80%81%E9%87%8D%E5%91%BD%E5%90%8D%E5%92%8C%E5%88%A0%E9%99%A4%E6%96%87%E4%BB%B6--copying-renaming-and-removing-files"></a>
# 复制、重命名和删除文件 / Copying, renaming, and removing files

可以使用子例程 `copy`、 `rename`、 `move` 和 `unlink` 来避免低级系统命令。更多细节见 [copy](https://docs.raku.org/routine/copy)、 [rename](https://docs.raku.org/routine/rename)、 [move](https://docs.raku.org/routine/move) 和 [unlink](https://docs.raku.org/routine/unlink)。一些例子:

Routines `copy`, `rename`, `move`, and `unlink` are available to avoid low-level system commands. See details at [copy](https://docs.raku.org/routine/copy), [rename](https://docs.raku.org/routine/rename), [move](https://docs.raku.org/routine/move), and [unlink](https://docs.raku.org/routine/unlink). Some examples:

```Raku
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
 
unlink $filea;
$fileb.IO.unlink;
```

两个 `unlink` 删除它们的参数指定的文件，如果文件存在的话。除非用户没有正确的权限这样做；在这种情况下，它会引发异常。

The two `unlink` sentences remove their argument if it exists, unless the user does not have the correct permissions to do so; in that case, it raises an exception.

<a id="%E6%A3%80%E6%9F%A5%E6%96%87%E4%BB%B6%E5%92%8C%E7%9B%AE%E5%BD%95--checking-files-and-directories"></a>
# 检查文件和目录 / Checking files and directories

使用 `IO::Handle` 对象上的 `e` 方法来测试文件或目录是否存在。

Use the `e` method on an `IO::Handle` object to test whether the file or directory exists.

```Raku
if "nonexistent_file".IO.e {
    say "file exists";
}
else {
    say "file doesn't exist";
}
```

也可以使用冒号对语法来实现相同的目的：

It is also possible to use the colon pair syntax to achieve the same thing:

```Raku
if "path/to/file".IO ~~ :e {
    say 'file exists';
}
my $file = "path/to/file";
if $file.IO ~~ :e {
    say 'file exists';
}
```

类似于文件存在性检查，还可以检查路径是否是目录。例如，假设文件 `testfile` 和目录 `lib` 存在，我们将从存在测试方法 `e` 中获得相同的结果，即两者都存在：

Similarly to the file existence check, one can also check to see if a path is a directory. For instance, assuming that the file `testfile` and the directory `lib` exist, we would obtain from the existence test method `e` the same result, namely that both exist:

```Raku
say "testfile".IO.e;  # OUTPUT: «True␤» 
say "lib".IO.e;       # OUTPUT: «True␤» 
```

但是，由于只有其中一个是目录，目录测试方法 `d` 将给出不同的结果：

However, since only one of them is a directory, the directory test method `d` will give a different result:

```Raku
say "testfile".IO.d;  # OUTPUT: «False␤» 
say "lib".IO.d;       # OUTPUT: «True␤» 
```

当然，如果我们通过方法 `f` 检查路径是否为文件，结果自然是反转的：

Naturally the tables are turned if we check to see if the path is a file via the file test method `f`:

```Raku
say "testfile".IO.f;  # OUTPUT: «True␤» 
say "lib".IO.f;       # OUTPUT: «False␤» 
```

还有其他方法可以用于查询文件或目录，一些有用的方法是：

There are other methods that can be used to query a file or directory, some useful ones are:

```Raku
my $f = "file";
 
say $f.IO.modified; # return time of last file (or directory) change 
say $f.IO.accessed; # return last time file (or directory) was read 
say $f.IO.s;        # return size of file (or directory inode) in bytes 
```

请参见 [IO::Path](https://docs.raku.org/type/IO::Path) 中的更多方法和详细信息。

See more methods and details at [IO::Path](https://docs.raku.org/type/IO::Path).

<a id="%E8%8E%B7%E5%8F%96%E7%9B%AE%E5%BD%95%E5%88%97%E8%A1%A8--getting-a-directory-listing"></a>
# 获取目录列表 / Getting a directory listing

要列出当前目录的内容，请使用 `dir` 功能。它返回一个 [IO::Path](https://docs.raku.org/type/IO::Path) 对象的列表。

To list the contents of the current directory, use the `dir` function. It returns a list of [IO::Path](https://docs.raku.org/type/IO::Path) objects.

```Raku
say dir;          # OUTPUT: «"/path/to/testfile".IO "/path/to/lib".IO␤»
```

要列出给定目录中的文件和目录，只需将路径传递为 `dir` 的参数：

To list the files and directories in a given directory, simply pass a path as an argument to `dir`:

```Raku
say dir "/etc/";  # OUTPUT: «"/etc/ld.so.conf".IO "/etc/shadow".IO ....␤»
```

<a id="%E5%88%9B%E5%BB%BA%E5%92%8C%E5%88%A0%E9%99%A4%E7%9B%AE%E5%BD%95--creating-and-removing-directories"></a>
# 创建和删除目录 / Creating and removing directories

要创建新目录，只需将目录名作为参数传给 `mkdir` 函数：

To create a new directory, simply call the `mkdir` function with the directory name as its argument:

```Raku
mkdir "newdir";
```

函数在成功时返回创建的目录的名称，在失败时返回 `Nil`。因此，标准 Raku 术语的工作方式与预期的一样：

The function returns the name of the created directory on success and `Nil` on failure. Thus the standard Raku idiom works as expected:

```Raku
mkdir "newdir" or die "$!";
```

使用 `rmdir` 删除*空*目录：

Use `rmdir` to remove *empty* directories:

```Raku
rmdir "newdir" or die "$!";
```
