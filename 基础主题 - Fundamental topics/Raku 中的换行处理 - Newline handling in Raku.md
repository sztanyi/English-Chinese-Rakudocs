原文：https://rakudocs.github.io/language/newline

# Raku 中的换行处理 / Newline handling in Raku

如何处理不同的换行符，以及如何更改行为

How the different newline characters are handled, and how to change the behavior

不同的操作系统使用不同的字符或它们的组合来表示到新行的转换。每种语言都有自己的规则来处理这个问题。Raku 具有以下特性：

Different operating systems use different characters, or combinations of them, to represent the transition to a new line. Every language has its own set of rules to handle this. Raku has the following ones:

- `\n` 在字符串文字中表示 Unicode 码位 10。
- 通过 say 附加到字符串的默认 [nl-out](https://rakudocs.github.io/routine/nl-out) 也是 `\n`。
- 在输出时，在 Windows 上，编码器将默认地在文件、进程或终端（但在套接字上不会这样做）将 `\n` 转换为 `\r\n'。
- 在输入端，在任何平台上，解码器默认将文件、进程或终端的 `\r\n` 输入规范化为 `\n`（同样，不适用于 socket）。
- 以上两点合在一起意味着您可以-将编程套接字放在一边-期望永远不会看到程序内部的 `\r\n`（这也是许多其他语言中的工作方式）。
- [`:$translate-nl`](https://rakudocs.github.io/type/Encoding#method_decoder) 命名参数存在于不同的地方，用于控制此转换，例如，在 [`Proc::Async.new`](https://rakudocs.github.io/type/Proc::Async#method_new) 和 [`Proc::Async.Supply`](https://rakudocs.github.io/type/Proc::Async#method_Supply) 中。
- [regex](https://rakudocs.github.io/language/regexes) 语言中的 `\n` 是逻辑上的，将与 `\r\n` 匹配。

- `\n` in a string literal means Unicode codepoint 10.
- The default [nl-out](https://rakudocs.github.io/routine/nl-out) that is appended to a string by say is also `\n`.
- On output, when on Windows, the encoder will by default transform a `\n` into a `\r\n` when it's going to a file, process, or terminal (it won't do this on a socket, however).
- On input, on any platform, the decoder will by default normalize `\r\n` into `\n` for input from a file, process, or terminal (again, not socket).
- These above two points together mean that you can - socket programming aside - expect to never see a `\r\n` inside of your program (this is how things work in numerous other languages too).
- The [`:$translate-nl`](https://rakudocs.github.io/type/Encoding#method_decoder) named parameter exists in various places to control this transformation, for instance, in [`Proc::Async.new`](https://rakudocs.github.io/type/Proc::Async#method_new) and [`Proc::Async.Supply`](https://rakudocs.github.io/type/Proc::Async#method_Supply).
- A `\n` in the [regex](https://rakudocs.github.io/language/regexes) language is logical, and will match a `\r\n`.

创建句柄时，可以通过设置 `:nl-out` 属性来更改特定句柄的默认行为。

You can change the default behavior for a particular handle by setting the `:nl-out` attribute when you create that handle.

```Raku
my $crlf-out = open(IO::Special.new('<STDOUT>'), :nl-out("\\\n\r"));
$*OUT.say: 1;     #OUTPUT: «1␤» 
$crlf-out.say: 1; #OUTPUT: «1\␤␍»
```

在本例中，我们使用 [IO::Special](https://rakudocs.github.io/type/IO::Special) 将标准输出复制到一个新句柄，我们将在字符串的末尾附加一个 `\'，后跟一个换行 `␤` 和一个回车 `␍`；我们打印到该句柄的所有内容都将得到这些字符如图所示，行尾的字符数。

In this example, where we are replicating standard output to a new handle by using [IO::Special](https://rakudocs.github.io/type/IO::Special), we are appending a `\` to the end of the string, followed by a newline `␤`and a carriage return `␍`; everything we print to that handle will get those characters at the end of the line, as shown.

在正则表达式中，[`\n`](https://rakudocs.github.io/language/regexes#index-entry-regex_%5Cn-regex_%5CN-%5Cn_and_%5CN) 是根据 [Unicode 逻辑换行定义](https://unicode.org/reports/tr18/#Line_Boundaries) 定义的。它将匹配 `.` 和 `\v`，以及任何包含空白的类。

In regular expressions, [`\n`](https://rakudocs.github.io/language/regexes#index-entry-regex_%5Cn-regex_%5CN-%5Cn_and_%5CN) is defined in terms of the [Unicode definition of logical newline](https://unicode.org/reports/tr18/#Line_Boundaries). It will match `.` and also `\v`, as well as any class that includes whitespace.