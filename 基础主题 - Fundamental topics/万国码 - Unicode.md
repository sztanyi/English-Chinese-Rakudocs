原文：https://docs.raku.org/language/unicode

# 万国码 / Unicode

Raku 中的 Unicode 支持

Unicode support in Raku

Raku 高度支持 Unicode。本文档旨在对不属于例程和方法的文档中的 Unicode 特性进行概述和描述。

Raku has a high level of support of Unicode. This document aims to be both an overview as well as description of Unicode features which don't belong in the documentation for routines and methods.

有关 MoarVM 内部字符串表示的概述，请参阅 [MoarVM 字符串文档](https://github.com/MoarVM/MoarVM/blob/master/docs/strings.asciidoc)。

For an overview on MoarVM's internal representation of strings, see the [MoarVM string documentation](https://github.com/MoarVM/MoarVM/blob/master/docs/strings.asciidoc).

<!-- MarkdownTOC -->

- [文件句柄和 I/O Filehandles and I/O](#文件句柄和-io-filehandles-and-io)
	- [规范化 / Normalization](#规范化--normalization)
	- [UTF8-C8](#utf8-c8)
- [输入 Unicode 码点和码点序列 / Entering unicode codepoints and codepoint sequences](#输入-unicode-码点和码点序列--entering-unicode-codepoints-and-codepoint-sequences)
	- [名称别名 / Name aliases](#名称别名--name-aliases)
	- [命名序列 / Named sequences](#命名序列--named-sequences)
		- [表情序列 / Emoji sequences](#表情序列--emoji-sequences)

<!-- /MarkdownTOC -->

<a id="文件句柄和-io-filehandles-and-io"></a>
# 文件句柄和 I/O Filehandles and I/O

<a id="规范化--normalization"></a>
## 规范化 / Normalization

Raku 默认情况下对所有输入和输出应用规范化，但文件名除外，这些文件名被读和写为 [`UTF8-C8`](https://docs.raku.org/language/unicode#UTF8-C8)；字素作为用户可见的字符形式的图形符号将使用规范化表示形式。例如，可以用两种方式表示字形素 `á`，要么使用一个码点：

Raku applies normalization by default to all input and output except for file names, which are read and written as [`UTF8-C8`](https://docs.raku.org/language/unicode#UTF8-C8); graphemes, which are user-visible forms of the characters, will use a normalized representation. For example, the grapheme `á` can be represented in two ways, either using one codepoint:

```Raku
á (U+E1 "LATIN SMALL LETTER A WITH ACUTE")
```

或二个码点：

Or two codepoints:

```Raku
a +  ́ (U+61 "LATIN SMALL LETTER A" + U+301 "COMBINING ACUTE ACCENT")
```

Raku 将这两个输入转换为一个码点，这是为规范化形式 C（*NFC*）指定的。在大多数情况下，这是有用的，这意味着两个等价的输入都是相同的。Unicode 有一个规范等价的概念，它允许我们确定字符串的规范形式，允许我们正确地比较和操作字符串，而不必担心文本会丢失这些属性。默认情况下，你从 Raku 处理或输出的任何文本都将以“规范”形式出现，即使在对字符串进行修改或连接时也是如此（有关如何避免这种情况，请参阅下面的内容）。有关规范形式 C 和规范等价的更详细信息，请参见 Unicode 基金会关于[规范化和规范等价](https://unicode.org/reports/tr15/#Canon_Compat_Equivalence)的页面。

Raku will turn both these inputs into one codepoint, as is specified for Normalization Form C (**NFC**). In most cases this is useful and means that two inputs that are equivalent are both treated the same. Unicode has a concept of canonical equivalence which allows us to determine the canonical form of a string, allowing us to properly compare strings and manipulate them, without having to worry about the text losing these properties. By default, any text you process or output from Raku will be in this “canonical” form, even when making modifications or concatenations to the string (see below for how to avoid this). For more detailed information about Normalization Form C and canonical equivalence, see the Unicode Foundation's page on [Normalization and Canonical Equivalence](https://unicode.org/reports/tr15/#Canon_Compat_Equivalence).

有一种情况是，我们不默认这样做，那就是文件的名称。这是因为文件的名称必须与写入磁盘的字节完全相同。

One case where we don't default to this, is for the names of files. This is because the names of files must be accessed exactly as the bytes are written on the disk.

为了避免规范化，你可以使用名为 [UTF8-C8](https://docs.raku.org/language/unicode#UTF8-C8) 的特殊编码格式。将这种编码与任何文件句柄一起使用，将允许你读取磁盘上的确切字节，而无需规范化。如果你用 UTF8 打印出来，它们在打印出来时可能看起来很滑稽。如果你将它打印到输出编码为 UTF8-C8 的句柄上，那么它将按照你通常所期望的那样呈现，并且是字节精确复制的字节。关于 MoarVM 的 [UTF8-C8](https://docs.raku.org/language/unicode#UTF8-C8) 的更多技术细节如下所述。

To avoid normalization you can use a special encoding format called [UTF8-C8](https://docs.raku.org/language/unicode#UTF8-C8). Using this encoding with any filehandle will allow you to read the exact bytes as they are on disk, without normalization. They may look funny when printed out, if you print it out using a UTF8 handle. If you print it out to a handle where the output encoding is UTF8-C8, then it will render as you would normally expect, and be a byte for byte exact copy. More technical details on [UTF8-C8](https://docs.raku.org/language/unicode#UTF8-C8) on MoarVM are described below.

<a id="utf8-c8"></a>
## UTF8-C8

UTF-8 Clean-8 是一个编码器/解码器，主要对 UTF-8 工作。但是，当遇到一个字节序列时，它将使用 [NFG 合成](https://docs.raku.org/language/glossary#NFG)来跟踪所涉及的原始字节。这意味着编码返回到 UTF-8 Clean-8 将能够重新创建字节，因为他们原来存在。合成体包含 4 个码点：

UTF-8 Clean-8 is an encoder/decoder that primarily works as the UTF-8 one. However, upon encountering a byte sequence that will either not decode as valid UTF-8, or that would not round-trip due to normalization, it will use [NFG synthetics](https://docs.raku.org/language/glossary#NFG) to keep track of the original bytes involved. This means that encoding back to UTF-8 Clean-8 will be able to recreate the bytes as they originally existed. The synthetics contain 4 codepoints:

- 码点 0x10FFFD（它是一个专用码点）
- 码点 'x'
- 不可解码字节的上 4 位作为十六进制字符 （0..9A..F）
- 不可解码字节的下 4 位作为十六进制字符 （0..9A..F）

- The codepoint 0x10FFFD (which is a private use codepoint)
- The codepoint 'x'
- The upper 4 bits of the non-decodable byte as a hex char (0..9A..F)
- The lower 4 bits as the non-decodable byte as a hex char (0..9A..F)

在正常的 UTF-8 编码下，这意味着无法表示的字符将以 `?xFF` 这样的形式出现。

Under normal UTF-8 encoding, this means the unrepresentable characters will come out as something like `?xFF`.

在 MoarVM 接收来自环境、命令行参数和文件系统查询的字符串的地方使用 UTF-8 Clean-8，例如在解码缓冲区时：

UTF-8 Clean-8 is used in places where MoarVM receives strings from the environment, command line arguments, and filesystem queries, for instance when decoding buffers:

```Raku
say Buf.new(ord('A'), 0xFE, ord('Z')).decode('utf8-c8');
#  OUTPUT: «A􏿽xFEZ␤»
```

你可以看到 UTF8-C8 使用的两个初始代码点是如何出现在这里的，就在 “FE” 之前。你可以使用这种类型的编码来读取具有未知编码的文件：

You can see how the two initial codepoints used by UTF8-C8 show up here, right before the "FE". You can use this type of encoding to read files with unknown encoding:

```Raku
my $test-file = "/tmp/test";
given open($test-file, :w, :bin) {
  .write: Buf.new(ord('A'), 0xFA, ord('B'), 0xFB, 0xFC, ord('C'), 0xFD);
  .close;
}
 
say slurp($test-file, enc => 'utf8-c8');
# OUTPUT: «(65 250 66 251 252 67 253)»
```

使用这种类型的编码读取并将它们编码回 UTF8-C8 将返回原始字节；这在默认的 UTF-8 编码中是不可能的。

Reading with this type of encoding and encoding them back to UTF8-C8 will give you back the original bytes; this would not have been possible with the default UTF-8 encoding.

请注意，到目前为止，在 Rakudo 的 JVM 实现中不支持这种编码。

Please note that this encoding so far is not supported in the JVM implementation of Rakudo.

<a id="输入-unicode-码点和码点序列--entering-unicode-codepoints-and-codepoint-sequences"></a>
# 输入 Unicode 码点和码点序列 / Entering unicode codepoints and codepoint sequences

你可以按数字(十进制和十六进制)输入 Unicode 码点。例如，名为 "latin capital letter ae with macron" 的字符有十进制码点 482 和十六进制码点 0x1E2：

You can enter Unicode codepoints by number (decimal as well as hexadecimal). For example, the character named "latin capital letter ae with macron" has decimal codepoint 482 and hexadecimal codepoint 0x1E2:

```Raku
say "\c[482]"; # OUTPUT: «Ǣ␤» 
say "\x1E2";   # OUTPUT: «Ǣ␤»
```

你还可以按名称访问 Unicode 码点：Raku 支持所有 Unicode 名称。

You can also access Unicode codepoints by name: Raku supports all Unicode names.

```Raku
say "\c[PENGUIN]"; # OUTPUT: «🐧␤» 
say "\c[BELL]";    # OUTPUT: «🔔␤» (U+1F514 BELL)
```

所有 Unicode 代码点名称/命名的 seq/moji 序列现在都是不区分大小写的：[从 Rakudo 2017.02 开始]

All Unicode codepoint names/named seq/emoji sequences are now case-insensitive: [Starting in Rakudo 2017.02]

```Raku
say "\c[latin capital letter ae with macron]"; # OUTPUT: «Ǣ␤» 
say "\c[latin capital letter E]";              # OUTPUT: «E␤» (U+0045)
```

可以通过使用带有 `\c[]` 的逗号分隔列表来指定多个字符。还可以组合数字样式和命名样式：

You can specify multiple characters by using a comma separated list with `\c[]`. You can combine numeric and named styles as well:

```Raku
say "\c[482,PENGUIN]"; # OUTPUT: «Ǣ🐧␤»
```

除了在字符串插值中使用 `\c[]` 之外，还可以使用 [uniparse](https://docs.raku.org/routine/uniparse)：

In addition to using `\c[]` inside interpolated strings, you can also use the [uniparse](https://docs.raku.org/routine/uniparse):

```Raku
say "DIGIT ONE".uniparse;  # OUTPUT: «1␤» 
say uniparse("DIGIT ONE"); # OUTPUT: «1␤»
```

<a id="名称别名--name-aliases"></a>
## 名称别名 / Name aliases

名称别名主要用于没有正式名称的码点、缩写或更正（Unicode 名称永不更改）。他们的完整名单见[此处](https://www.unicode.org/Public/UCD/latest/ucd/NameAliases.txt)。

Name Aliases are used mainly for codepoints without an official name, for abbreviations, or for corrections (Unicode names never change). For full list of them see [here](https://www.unicode.org/Public/UCD/latest/ucd/NameAliases.txt).

没有任何官方名称的控制代码：

Control codes without any official name:

```Raku
say "\c[ALERT]";     # Not visible (U+0007 control code (also accessible as \a)) 
say "\c[LINE FEED]"; # Not visible (U+000A same as "\n")
```

更正：

Corrections:

```Raku
say "\c[LATIN CAPITAL LETTER GHA]"; # OUTPUT: «Ƣ␤» 
say "Ƣ".uniname; # OUTPUT: «LATIN CAPITAL LETTER OI␤» 
# This one is a spelling mistake that was corrected in a Name Alias: 
say "\c[PRESENTATION FORM FOR VERTICAL RIGHT WHITE LENTICULAR BRACKET]".uniname;
# OUTPUT: «PRESENTATION FORM FOR VERTICAL RIGHT WHITE LENTICULAR BRAKCET␤»
```

缩写：

Abbreviations:

```Raku
say "\c[ZWJ]".uniname;  # OUTPUT: «ZERO WIDTH JOINER␤» 
say "\c[NBSP]".uniname; # OUTPUT: «NO-BREAK SPACE␤»
```

<a id="命名序列--named-sequences"></a>
## 命名序列 / Named sequences

你还可以使用任何[命名序列](https://www.unicode.org/Public/UCD/latest/ucd/NamedSequences.txt)，这些不是单个代码点，而是它们的序列。[从 2017.02 Rakudo 开始]

You can also use any of the [Named Sequences](https://www.unicode.org/Public/UCD/latest/ucd/NamedSequences.txt), these are not single codepoints, but sequences of them. [Starting in Rakudo 2017.02]

```Raku
say "\c[LATIN CAPITAL LETTER E WITH VERTICAL LINE BELOW AND ACUTE]";      # OUTPUT: «É̩␤» 
say "\c[LATIN CAPITAL LETTER E WITH VERTICAL LINE BELOW AND ACUTE]".ords; # OUTPUT: «(201 809)␤»
```

<a id="表情序列--emoji-sequences"></a>
### 表情序列 / Emoji sequences

Raku 支持表情序列。所有这些文件见：[Emoji ZWJ 序列](https://www.unicode.org/Public/emoji/4.0/emoji-zwj-sequences.txt) 和 [Emoji 序列](https://www.unicode.org/Public/emoji/4.0/emoji-sequences.txt)。请注意，任何带有逗号的名称都应该删除它们的逗号，因为 Raku 使用逗号来分隔相同 `\c` 序列中的不同代码点/序列。

Raku supports Emoji sequences. For all of them see: [Emoji ZWJ Sequences](https://www.unicode.org/Public/emoji/4.0/emoji-zwj-sequences.txt) and [Emoji Sequences](https://www.unicode.org/Public/emoji/4.0/emoji-sequences.txt). Note that any names with commas should have their commas removed, since Raku uses commas to separate different codepoints/sequences inside the same `\c` sequence.

```Raku
say "\c[woman gesturing OK]";         # OUTPUT: «🙆‍♀️␤» 
say "\c[family: man woman girl boy]"; # OUTPUT: «👨‍👩‍👧‍👦␤»
```
