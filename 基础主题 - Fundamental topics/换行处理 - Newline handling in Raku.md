原文：https://docs.raku.org/language/newline

# Raku 中的换行处理 / Newline handling in Raku

不同换行符是如何处理的，以及怎样改变这些处理行为

How the different newline characters are handled, and how to change the behavior

不同的操作系统使用不同的字符或它们的组合来表示到新的一行。每种语言都有自己的规则来处理这个问题。Raku 具有以下特性：

Different operating systems use different characters, or combinations of them, to represent the transition to a new line. Every language has its own set of rules to handle this. Raku has the following ones:

- `\n` 在字符串字面中表示 Unicode 码位 10。
- 通过 say 附加到字符串末尾的默认 [nl-out](https://docs.raku.org/routine/nl-out) 也是 `\n`。
- 在 Windows 上输出时，编码器将默认地在文件、进程或终端（但在 socket 上不会这样做）将 `\n` 转换为 `\r\n`。
- 在输入时，在任何平台上，解码器默认将文件、进程或终端的 `\r\n` 输入格式化为 `\n`（同样，不适用于 socket）。
- 以上两点合在一起意味着你可以期望 - 套接字编程除外 - 永远不会看到程序内部的 `\r\n`（这也是许多其他语言中的工作方式）。
- [`:$translate-nl`](https://docs.raku.org/type/Encoding#method_decoder) 命名参数存在于不同的地方用来控制此转换，例如，在 [`Proc::Async.new`](https://docs.raku.org/type/Proc::Async#method_new) 和 [`Proc::Async.Supply`](https://docs.raku.org/type/Proc::Async#method_Supply) 中。
- [正则](https://docs.raku.org/language/regexes)中的 `\n` 是逻辑上的，可以匹配 `\r\n`。

- `\n` in a string literal means Unicode codepoint 10.
- The default [nl-out](https://docs.raku.org/routine/nl-out) that is appended to a string by say is also `\n`.
- On output, when on Windows, the encoder will by default transform a `\n` into a `\r\n` when it's going to a file, process, or terminal (it won't do this on a socket, however).
- On input, on any platform, the decoder will by default normalize `\r\n` into `\n` for input from a file, process, or terminal (again, not socket).
- These above two points together mean that you can - socket programming aside - expect to never see a `\r\n` inside of your program (this is how things work in numerous other languages too).
- The [`:$translate-nl`](https://docs.raku.org/type/Encoding#method_decoder) named parameter exists in various places to control this transformation, for instance, in [`Proc::Async.new`](https://docs.raku.org/type/Proc::Async#method_new) and [`Proc::Async.Supply`](https://docs.raku.org/type/Proc::Async#method_Supply).
- A `\n` in the [regex](https://docs.raku.org/language/regexes) language is logical, and will match a `\r\n`.

创建句柄时，可以通过设置 `:nl-out` 属性来更改特定句柄的默认行为。

You can change the default behavior for a particular handle by setting the `:nl-out` attribute when you create that handle.

```Raku
my $crlf-out = open(IO::Special.new('<STDOUT>'), :nl-out("\\\n\r"));
$*OUT.say: 1;     #OUTPUT: «1␤» 
$crlf-out.say: 1; #OUTPUT: «1\␤␍»
```

在本例中，我们使用 [IO::Special](https://docs.raku.org/type/IO::Special) 将标准输出复制到一个新句柄，我们将在字符串的末尾附加一个 `\`，后跟一个换行 `␤` 和一个回车 `␍`；我们打印到该句柄的所有内容都将在行末增加这些字符。

In this example, where we are replicating standard output to a new handle by using [IO::Special](https://docs.raku.org/type/IO::Special), we are appending a `\` to the end of the string, followed by a newline `␤`and a carriage return `␍`; everything we print to that handle will get those characters at the end of the line, as shown.

在正则表达式中，[`\n`](https://docs.raku.org/language/regexes#index-entry-regex_%5Cn-regex_%5CN-%5Cn_and_%5CN) 是根据 [Unicode 逻辑换行定义](https://unicode.org/reports/tr18/#Line_Boundaries) 定义的。它将匹配 `.` 和 `\v`，以及任何包含空白的类。

In regular expressions, [`\n`](https://docs.raku.org/language/regexes#index-entry-regex_%5Cn-regex_%5CN-%5Cn_and_%5CN) is defined in terms of the [Unicode definition of logical newline](https://unicode.org/reports/tr18/#Line_Boundaries). It will match `.` and also `\v`, as well as any class that includes whitespace.
