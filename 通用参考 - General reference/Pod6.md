原文：https://docs.raku.org/language/pod

# Pod6

一种易于使用的标记语言，用于记录 Raku 模块和程序的文档

An easy-to-use markup language for documenting Raku modules and programs

Pod6 是一种易于使用的标记语言。它可以用于编写语言文档，用于记录程序和模块的文档，以及其他类型的文档。

Pod6 is an easy-to-use markup language. It can be used for writing language documentation, for documenting programs and modules, as well as for other types of document composition.

每个 Pod6 文件都必须以 `=begin pod` 开头，以 `=end pod` 结尾。这两个分隔符之间的所有内容都将被处理并用于生成文档。

Every Pod6 document has to begin with `=begin pod` and end with `=end pod`. Everything between these two delimiters will be processed and used to generate documentation.

```Raku
=begin pod
 
A very simple Pod6 document

=end pod
```

# 代码块结构 / Block structure

一个 Pod6 文档可以由多个 Pod6 块组成。定义块有四种方法：分隔、段落、缩写和声明；前三种方法产生相同的结果，但第四种方法不同。您可以使用哪种形式最方便您的特定文档任务。

A Pod6 document may consist of multiple Pod6 blocks. There are four ways to define a block: delimited, paragraph, abbreviated, and declarator; the first three yield the same result but the fourth differs. You can use whichever form is most convenient for your particular documentation task.

## 分隔块 / Delimited blocks

分隔块以 `=begin` 和 `=end` 标记为界，两者后面都有一个有效的 Raku 标识符，即块的 `typename`。保留完全小写（例如：`=begin head1`）或完全大写（例如：`=begin SYNOPSIS`）的类型名称。

Delimited blocks are bounded by `=begin` and `=end` markers, both of which are followed by a valid Raku identifier, which is the `typename` of the block. Typenames that are entirely lowercase (for example: `=begin head1`) or entirely uppercase (for example: `=begin SYNOPSIS`) are reserved.

```Raku
=begin head1
Top Level Heading
=end head1
```

### 配置信息 / Configuration information

在类型名称之后，`=begin` 标记行的其余部分被视为块的配置信息。这些信息被不同类型的块以不同的方式使用，但总是使用 Raku 风格的选项键值对指定。即：

After the typename, the rest of the `=begin` marker line is treated as configuration information for the block. This information is used in different ways by different types of blocks, but is always specified using Raku-ish option pairs. That is, any of:

| Value is...     | Specify with...          | Or with...          | Or with...        |
| --------------- | ------------------------ | ------------------- | ----------------- |
| List            | :key[$e1, $e2, ...]      | :key($e1, $e2, ...) | :key<$e1 $e2 ...> |
| Hash            | :key{$k1=>$v1, $k2=>$v2} |                     |                   |
| Boolean (true)  | :key                     | :key(True)          | :key[True]        |
| Boolean (false) | :!key                    | :key(False)         | :key[False]       |
| String          | :key<str>                | :key('str')         | :key("str")       |
| Int             | :key(42)                 | :key[42]            | :42key            |
| Number          | :key(2.3)                | :key[2.3]           |                   |

其中 '$e1, $e2, ...' 是类型为 String、 Int、 Number 或 Boolean 的列表元素。列表可能有混合元素类型。注意，一个元素列表被转换为其元素的类型（String、 Int、 Number 或 Boolean）。还请注意，如有需要，可使用 “bigints”。

Where '$e1, $e2, ...' are list elements of type String, Int, Number, or Boolean. Lists may have mixed element types. Note that one-element lists are converted to the type of their element (String, Int, Number, or Boolean). Also note that "bigints" can be used if required.

对于哈希，'$k1, $k2, ...' 是类型 Str 的键，'$v1, $v2, ...' 是 String、 Int、 Number 或 Boolean。

For hashes, '$k1, $k2, ...' are keys of type Str and '$v1, $v2, ...' are values of type String, Int, Number, or Boolean.

字符串由单引号或双引号分隔。空格在字符串之外是不重要的。哈希键不需要引用分隔，除非它们包含重要的空格。如果在角括号内使用任何空格，则在角括号内输入的字符串将成为列表。

Strings are delimited by single or double quotes. Whitespace is not significant outside of strings. Hash keys need not be quote-delimited unless they contain significant whitespace. Strings entered inside angle brackets become lists if any whitespace is used inside the angle brackets.

当然，所有选项键和值都必须是常量，因为 Pod6 是规范语言，而不是编程语言。具体来说，选项值不能是闭包。有关各种 Raku 键值对符号的详细信息，请参阅摘要 2。

All option keys and values must, of course, be constants since Pod6 is a specification language, not a programming language. Specifically, option values cannot be closures. See Synopsis 2 for details of the various Raku pair notations.

配置部分可以在后面的行上扩展，在第一（虚拟）列中以 `=` 开头，后面跟着空格字符。[[1]](https://docs.raku.org/language/pod#fn-1)

The configuration section may be extended over subsequent lines by starting those lines with an `=` in the first (virtual) column followed by a whitespace character. [[1]](https://docs.raku.org/language/pod#fn-1)

## 段落块 / Paragraph blocks

段落块以 `=for` 标记开头，以下一个 Pod6 指令或第一空行结束。`=for` 标记后面是“块的类型名称”，另外还有上文所述分隔块中的任何配置数据。

Paragraph blocks begin by a `=for` marker and end by the next Pod6 directive or the first blank line. The `=for` marker is followed by the `typename` of the block plus, optionally, any configuration data as in the delimited blocks described above.

```Raku
=for head1
Top Level Heading
```

## 缩写块 / Abbreviated blocks

缩写块的开头是一个 `'='` 符号，紧接着是块的类型名称。以下所有数据都是块内容的一部分，因此无法为*缩写*块指定配置数据。块结束于下一个 Pod6 指令或第一个空行。

Abbreviated blocks begin by an `'='` sign, which is followed immediately by the `typename` of the block. All following data are part of the contents of the block, thus configuration data **cannot** be specified for an *abbreviated* block. The block ends at the next Pod6 directive or the first blank line.

```Raku
=head1 Top level heading 
```

## 声明块 / Declarator blocks

声明块与其他块不同之处在于没有特定类型，而是附加到某些源代码中。

Declarator blocks differ from the others by not having a specific type, instead they are attached to some source code.

声明块是由一个特别的评论来介绍的：要么是 `#|`，要么是 `#=`，后面必须紧接着一个空格或一个开口的大括号。如果后面跟着一个空格，则该块被行尾终止；如果后面跟着一个或多个开口花括号，则该块被关闭花括号的匹配序列终止。

Declarator blocks are introduced by a special comment: either `#|` or `#=`, which must be immediately followed by either a space or an opening curly brace. If followed by a space, the block is terminated by the end of line; if followed by one or more opening curly braces, the block is terminated by the matching sequence of closing curly braces.

以 `#|` 开头的块被附加到后面的代码中，以 `#=` 开头的块被附加到前面的代码中。

Blocks starting with `#|` are attached to the code after them, and blocks starting with `#=` are attached to the code before them.

由于声明块被附加到源代码中，它们可以用来记录类、角色、子例程以及通常的任何语句或块。

Since declarator blocks are attached to source code, they can be used to document classes, roles, subroutines and in general any statement or block.

`WHY` 方法可用于这些类、角色、子程序等，用来返回附加的 Pod6 值。

The `WHY` method can be used on these classes, roles, subroutines etc. to return the attached Pod6 value.

```Raku
#| Base class for magicians 
class Magician {
  has Int $.level;
  has Str @.spells;
}
 
#| Fight mechanics 
sub duel(Magician $a, Magician $b) {
}
#= Magicians only, no mortals. 
 
say Magician.WHY; # OUTPUT: «Base class for magicians␤» 
say &duel.WHY.leading; # OUTPUT: «Fight mechanics␤» 
say &duel.WHY.trailing; # OUTPUT: «Magicians only, no mortals.␤» 
```

这些声明可以扩展多个块：

These declarations can extend multiple blocks:

```Raku
#|( This is an example of stringification: 
    * Numbers turn into strings
    * Regexes operate on said strings
    * C<with> topicalizes and places result into $_
)
sub search-in-seq( Int $end, Int $number ) {
    with (^$end).grep( /^$number/ ) {
        .say for $_<>;
    }
}
#=« Uses 
    * topic
    * decont operator
»
```

通过使用一对匹配的括号结构，如 `()` 或 `«»` 可以扩展多行。但是，这种格式不会被 `raku -doc` 转换为多行显示。

By using a matched pair of parenthesis constructs such as `()` or `«»` the comments can extend multiple lines. This format, however, will not translate to a multi-line display by `raku -doc`.

# 块类型 / Block types

Pod6 提供广泛的标准块类型。

Pod6 offers a wide range of standard block types.

## 标题 / Headings

标题可以使用 `=headN` 定义，其中 N 大于零（例如，`=head1`、`=head2`。。。）。

Headings can be defined using `=headN`, where N is greater than zero (e.g., `=head1`, `=head2`, …).

```Raku
=head1 A top level heading 
 
=head2 A second level heading 
 
=head3 A third level heading 
```

## 普通段落 / Ordinary paragraphs

一个普通段落由文本组成，这些文本将在当前嵌套级别被格式化为文档，空格被压缩，行被填充，以及任何特殊的内联标记应用。

An ordinary paragraph consists of text that is to be formatted into a document at the current level of nesting, with whitespace squeezed, lines filled, and any special inline mark-up applied.

普通段落由一行或多行连续的文本组成，每一行以非空格字符开头。该段由第一空行或块指令终止。

Ordinary paragraphs consist of one or more consecutive lines of text, each of which starts with a non-whitespace character. The paragraph is terminated by the first blank line or block directive.

例如：

For example:

```Raku
=head1 This is a heading block 
 
This is an ordinary paragraph.
Its text  will   be     squeezed     and
short lines filled. It is terminated by
the first blank line.
 
This is another ordinary paragraph.
Its     text    will  also be squeezed and
short lines filled. It is terminated by
the trailing directive on the next line.
 
=head2 This is another heading block 
 
This is yet another ordinary paragraph,
at the first virtual column set by the
previous directive
```

普通段落不需要明确的标记或分隔符。

Ordinary paragraphs do not require an explicit marker or delimiters.

或者，还有一个明确的 `=para` 标记，可以用来明确标记一个段落。

Alternatively, there is also an explicit `=para` marker that can be used to explicitly mark a paragraph.

```Raku
=para
This is an ordinary paragraph.
Its text  will   be     squeezed     and
short lines filled.
```

此外，可以使用较长的 `=begin para` 和 `=end para` 形式。

In addition, the longer `=begin para` and `=end para` form can be used.

例如：

For example:

```Raku
=begin para
This is an ordinary paragraph.
Its text  will   be     squeezed     and
short lines filled.
 
This is still part of the same paragraph,
which continues until an...
=end para
```

如前一个例子所示，在 `=begin para` 和 `=end para` 分隔的块内，任何空白行都会被保留。

As demonstrated by the previous example, within a delimited `=begin para` and `=end para` block, any blank lines are preserved.

## 代码块 / Code blocks

代码块用于指定源代码，这些代码应该在没有重新说明理由、没有空格挤压和没有识别任何内联格式代码的情况下呈现。通常，这些块用于显示代码、标记或其他文本规范的示例，并使用固定宽度字体进行呈现。

Code blocks are used to specify source code, which should be rendered without re-justification, without whitespace-squeezing, and without recognizing any inline formatting codes. Typically these blocks are used to show examples of code, mark-up, or other textual specifications, and are rendered using a fixed-width font.

代码块可以隐式指定为一行或多行文本，每行文本以空格字符开头。隐式代码块然后由空白行终止。

A code block may be implicitly specified as one or more lines of text, each of which starts with a whitespace character. The implicit code block is then terminated by a blank line.

例如：

For example:

```Raku
This ordinary paragraph introduces a code block:
 
    my $name = 'John Doe';
    say $name;
```

还可以通过将代码块封装在 `=begin code` 和 `=end code` 中来显式定义代码块

Code blocks can also be explicitly defined by enclosing them in `=begin code` and `=end code`

```Raku
    =begin code
    my $name = 'John Doe';
    say $name;
    =end code
```

## 输入输出块 - I/O blocks

Pod6 提供了用于指定程序输入和输出的块。

Pod6 provides blocks for specifying the input and output of programs.

`=input` 块用于指定预先格式化的键盘输入，应在不重新说明理由或压缩空格的情况下呈现。

The `=input` block is used to specify pre-formatted keyboard input, which should be rendered without re-justification or squeezing of whitespace.

`=output` 块用于指定预先格式化的终端或文件输出，该输出也应在没有重新说明理由或空格挤压的情况下呈现。

The `=output` block is used to specify pre-formatted terminal or file output, which should also be rendered without re-justification or whitespace-squeezing.

## 列表 / Lists

### 无序列表 / Unordered lists

Pod6 中的列表被指定为一系列 `=item` 块。

Lists in Pod6 are specified as a series of `=item` blocks.

例如：

For example:

```Raku
The three suspects are:
 
=item  Happy 
=item  Sleepy 
=item  Grumpy 
```

三名嫌疑人分别是：

The three suspects are:

- Happy
- Sleepy
- Grumpy

### 定义列表 / Definition lists

定义术语或命令的列表使用 `=defn`，相当于 HTML中 的 `DL` 列表

Lists that define terms or commands use `=defn`, equivalent to the `DL` lists in HTML

```Raku
=defn Happy 
When you're not blue.
 
=defn Blue 
When you're not happy.
```

将翻译为

will be rendered as

- Happy

  When you're not blue.

- Blue

  When you're not happy.

### 多层列表 / Multi-level lists

列表可能是多层的，每一层的条目使用 `=item1`、`=item2`、`=item3` 等块指定。

Lists may be multi-level, with items at each level specified using the `=item1`, `=item2`, `=item3`, etc. blocks.

注意，`=item` 只是 `=item1` 的缩写。

Note that `=item` is just an abbreviation for `=item1`.

例如：

For example:

```Raku
=item1  Animal 
=item2     Vertebrate 
=item2     Invertebrate 
 
=item1  Phase 
=item2     Solid 
=item2     Liquid 
=item2     Gas 
```

```
- Animal

- - Vertebrate
  - Invertebrate

- Phase

- - Solid
  - Liquid
  - Gas
```

### 多段落列表 / Multi-paragraph lists

使用 `=item` 块（`=begin item` 和 `=end item`）的分隔形式，我们可以指定包含多个段落的项。

Using the delimited form of the `=item` block (`=begin item` and `=end item`), we can specify items that contain multiple paragraphs.

例如：

For example:

```Raku
Let's consider two common proverbs:
 
=begin item
I<The rain in Spain falls mainly on the plain.>
 
This is a common myth and an unconscionable slur on the Spanish
people, the majority of whom are extremely attractive.
=end item
 
=begin item
I<The early bird gets the worm.>
 
In deciding whether to become an early riser, it is worth
considering whether you would actually enjoy annelids
for breakfast.
=end item
 
As you can see, folk wisdom is often of dubious value.
```

翻译为：

Renders as:

```
Let's consider two common proverbs:

- *The rain in Spain falls mainly on the plain.*

  This is a common myth and an unconscionable slur on the Spanish people, the majority of whom are extremely attractive.

- *The early bird gets the worm.*

  In deciding whether to become an early riser, it is worth considering whether you would actually enjoy annelids for breakfast.

As you can see, folk wisdom is often of dubious value.
```

## 表格 / Tables

有关文档，请查看 [表格](https://docs.raku.org/language/tables)

Check out this page for documentation related to [Tables](https://docs.raku.org/language/tables)

## Pod6 注释 / Pod6 comments

Pod6 注释将会被 Pod6 渲染器忽略。

Pod6 comments are comments that Pod6 renderers ignore.

注释对*元*文档（记录文档的文档）有用处。单行注释使用 `=comment` 标记：

Comments are useful for *meta*documentation (documenting the documentation). Single-line comments use the `=comment` marker:

```Raku
=comment Add more here about the algorithm 
```

对于多行注释，使用分隔的 `comment` 代码块：

For multi-line comments, use a delimited `comment` block:

```Raku
=begin comment
This comment is
multi-line.
=end comment
```

## 语义块 / Semantic blocks

所有大写块类型名都保留用于指定标准文档、发布、源组件或元信息。

All uppercase block typenames are reserved for specifying standard documentation, publishing, source components, or metainformation.

```Raku
=NAME
=AUTHOR
=VERSION
=TITLE
=SUBTITLE
```

# 格式化代码 / Formatting codes

格式化代码提供了一种将内联标记添加到文本的方法。

Formatting codes provide a way to add inline mark-up to a piece of text.

所有 Pod6 格式代码都由一个大写字母和一组单尖括号或双尖括号组成；可以使用 Unicode 双尖括号。

All Pod6 formatting codes consist of a single capital letter followed immediately by a set of single or double angle brackets; Unicode double angle brackets may be used.

格式化代码可以嵌套其他格式化代码。

Formatting codes may nest other formatting codes.

提供这些代码：**B**、**C**、**E**、**I**、**K**、**L**、**N**、**P**、**R**、**T**、**U**、**V**、**X**、**Z**。

The following codes are available: **B**, **C**, **E**, **I**, **K**, **L**, **N**, **P**, **R**, **T**, **U**, **V**, **X**, and **Z**.

## 粗体 / Bold

若要用粗体设置文本格式，请将其括在 `B< >` 中

To format a text in bold enclose it in `B< >`

```Raku
Raku is B<awesome>
```

Raku is **awesome**

## Italic

To format a text in italic enclose it in `I< >`

```Raku
Raku is I<awesome>
```

Raku is *awesome*

## Underlined

To underline a text enclose it in `U< >`

```Raku
Raku is U<awesome>
```



## Code

To flag text as code and treat it verbatim enclose it in `C< >`

```Raku
C<my $var = 1; say $var;>
my $var = 1; say $var;
```

## Links

To create a link enclose it in `L< >`

A vertical bar (optional) separates label and target.

The target location can be an URL (first example) or a local Pod6 document (second example). Local file names are relative to the base of the project, not the current document.

```Raku
Raku homepage L<https://raku.org>
L<Raku homepage|https://raku.org>
```

Raku homepage [https://raku.org](https://raku.org/)

[Raku homepage](https://raku.org/)

```Raku
Structure L</language/about#Structure|/language/about#Structure>
L<Structure|/language/about#Structure>
```

Structure [/language/about#Structure](https://docs.raku.org/language/about#Structure)

[Structure](https://docs.raku.org/language/about#Structure)

To create a link to a section in the same document:

```Raku
Comments L<#Comments>
L<Comments|#Comments>
```

Comments [Comments](https://docs.raku.org/language/pod#Comments)

[Comments](https://docs.raku.org/language/pod#Comments)

## Placement links

This code is not implemented in `Pod::To::HTML`, but is partially implemented in `Pod::To::BigPage`.

A second kind of link — the `P<>` or **placement link** — works in the opposite direction. Instead of directing focus out to another document, it allows you to assimilate the contents of another document into your own.

In other words, the `P<>` formatting code takes a URI and (where possible) inserts the contents of the corresponding document inline in place of the code itself.

`P<>` codes are handy for breaking out standard elements of your documentation set into reusable components that can then be incorporated directly into multiple documents. For example:

```Raku
=COPYRIGHT
P<file:/shared/docs/std_copyright.pod>
 
=DISCLAIMER
P<http://www.MegaGigaTeraPetaCorp.com/std/disclaimer.txt>
```

might produce:

**Copyright**

This document is copyright (c) MegaGigaTeraPetaCorp, 2006. All rights reserved.

**Disclaimer**

ABSOLUTELY NO WARRANTY IS IMPLIED. NOT EVEN OF ANY KIND. WE HAVE SOLD YOU THIS SOFTWARE WITH NO HINT OF A SUGGESTION THAT IT IS EITHER USEFUL OR USABLE. AS FOR GUARANTEES OF CORRECTNESS...DON'T MAKE US LAUGH! AT SOME TIME IN THE FUTURE WE MIGHT DEIGN TO SELL YOU UPGRADES THAT PURPORT TO ADDRESS SOME OF THE APPLICATION'S MANY DEFICIENCIES, BUT NO PROMISES THERE EITHER. WE HAVE MORE LAWYERS ON STAFF THAN YOU HAVE TOTAL EMPLOYEES, SO DON'T EVEN *THINK* ABOUT SUING US. HAVE A NICE DAY.

If a renderer cannot find or access the external data source for a placement link, it must issue a warning and render the URI directly in some form, possibly as an outwards link. For example:

**Copyright**

See: `file:/shared/docs/std_copyright.pod`

**Disclaimer**

See: `http://www.MegaGigaTeraPetaCorp.com/std/disclaimer.txt`

You can use any of the following URI forms (see [Links](https://docs.raku.org/language/pod#Links)) in a placement link.

## Comments

A comment is text that is never rendered.

To create a comment enclose it in `Z< >`

```Raku
Raku is awesome Z<Of course it is!>
```

Raku is awesome

## Notes

Notes are rendered as footnotes.

To create a note enclose it in `N< >`

```Raku
Raku is multi-paradigmatic N<Supporting Procedural, Object Oriented, and Functional programming>
```



## Keyboard input

To flag text as keyboard input enclose it in `K< >`

```Raku
Enter your name K<John Doe>
```



## Replaceable

The `R<>` formatting code specifies that the contained text is a **replaceable item**, a placeholder, or a metasyntactic variable. It is used to indicate a component of a syntax or specification that should eventually be replaced by an actual value. For example:

The basic `ln` command is: `ln` source_file target_file

or:

```Raku
Then enter your details at the prompt:

=for input
    Name: your surname
      ID: your employee number
    Pass: your 36-letter password
```

## Terminal output

To flag text as terminal output enclose it in `T< >`

```Raku
Hello T<John Doe>
```



## Unicode

To include Unicode code points or HTML5 character references in a Pod6 document, enclose them in `E< >`

`E< >` can enclose a number, which is treated as the decimal Unicode value for the desired code point. It can also enclose explicit binary, octal, decimal, or hexadecimal numbers using the Raku notations for explicitly based numbers.

```Raku
Raku makes considerable use of the E<171> and E<187> characters.
 
Raku makes considerable use of the E<laquo> and E<raquo> characters.
 
Raku makes considerable use of the E<0b10101011> and E<0b10111011> characters.
 
Raku makes considerable use of the E<0o253> and E<0o273> characters.
 
Raku makes considerable use of the E<0d171> and E<0d187> characters.
 
Raku makes considerable use of the E<0xAB> and E<0xBB> characters.
```

Raku makes considerable use of the « and » characters.

## Verbatim text

This code is not implemented by `Pod::To::HTML`, but is implemented in `Pod::To::BigPage`.

The `V<>` formatting code treats its entire contents as being **verbatim**, disregarding every apparent formatting code within it. For example:

```Raku
The B<V< V<> >> formatting code disarms other codes
such as V< I<>, C<>, B<>, and M<> >.
```

Note, however that the `V<>` code only changes the way its contents are parsed, *not* the way they are rendered. That is, the contents are still wrapped and formatted like plain text, and the effects of any formatting codes surrounding the `V<>` code are still applied to its contents. For example the previous example is rendered as:

The **V<>** formatting code disarms other codes such as I<>, C<>, B<>, and M<> .

## Indexing terms

Anything enclosed in an `X<>` code is an **index entry**. The contents of the code are both formatted into the document and used as the (case-insensitive) index entry:

```Raku
An X<array> is an ordered list of scalars indexed by number,
starting with 0. A X<hash> is an unordered collection of scalar
values indexed by their associated string key.
```

You can specify an index entry in which the indexed text and the index entry are different, by separating the two with a vertical bar:

```Raku
An X<array|arrays> is an ordered list of scalars indexed by number,
starting with 0. A X<hash|hashes> is an unordered collection of
scalar values indexed by their associated string key.
```

In the two-part form, the index entry comes after the bar and is case-sensitive.

You can specify hierarchical index entries by separating indexing levels with commas:

```Raku
An X<array|arrays, definition of> is an ordered list of scalars
indexed by number, starting with 0. A X<hash|hashes, definition of>
is an unordered collection of scalar values indexed by their
associated string key.
```

You can specify two or more entries for a single indexed text, by separating the entries with semicolons:

```Raku
A X<hash|hashes, definition of; associative arrays>
is an unordered collection of scalar values indexed by their
associated string key.
```

The indexed text can be empty, creating a "zero-width" index entry:

```Raku
X<|puns, deliberate>This is called the "Orcish Maneuver"
because you "OR" the "cache".
```

# Rendering Pod

## HTML

In order to generate HTML from Pod, you need the [Pod::To::HTML module](https://github.com/perl6/Pod-To-HTML).

If it is not already installed, install it by running the following command: `zef install Pod::To::HTML`

Once installed, run the following command in the terminal:

```Raku
perl6 --doc=HTML input.pod6 > output.html
```

## Markdown

In order to generate Markdown from Pod, you need the [Pod::To::Markdown module](https://github.com/softmoth/perl6-pod-to-markdown).

If it is not already installed, install it by running the following command: `zef install Pod::To::Markdown`

Once installed, run the following command in the terminal:

```Raku
perl6 --doc=Markdown input.pod6 > output.md
```

## Text

In order to generate text from Pod, you can use the default `Pod::To::Text` module.

Using the terminal, run the following command:

```Raku
perl6 --doc=Text input.pod6 > output.txt
```

You can omit the `=Text` portion:

```Raku
perl6 --doc input.pod6 > output.txt
```

You can even embed Pod6 directly in your program and add the traditional Unix command line "--man" option to your program with a multi MAIN subroutine like this:

```Raku
multi MAIN(Bool :$man) {
    run $*EXECUTABLE, '--doc', $*PROGRAM;
}
```

Now `myprogram --man` will output your Pod6 rendered as a man page.

# Accessing Pod

In order to access Pod6 documentation from within a Raku program the special `=` twigil, as documented in the [variables section](https://docs.raku.org/language/variables#The_=_twigil), must be used.

The `=` twigil provides the introspection over the Pod6 structure, providing a [Pod::Block](https://docs.raku.org/type/Pod::Block) tree root from which it is possible to access the whole structure of the Pod6 document.

As an example, the following piece of code introspects its own Pod6 documentation:

```Raku
=begin pod
 
=head1 This is a head1 title 
 
This is a paragraph.
 
=head2 Subsection 
 
Here some text for the subsection.
 
=end pod
 
for $=pod -> $pod-item {
    for $pod-item.contents -> $pod-block {
      $pod-block.perl.say;
    }
}
```

producing the following output:

```Raku
Pod::Heading.new(level => 1, config => {}, contents => [Pod::Block::Para.new(config => {}, contents => ["This is a head1 title"])]);
Pod::Block::Para.new(config => {}, contents => ["This is a paragraph."]);
Pod::Heading.new(level => 2, config => {}, contents => [Pod::Block::Para.new(config => {}, contents => ["Subsection"])]);
Pod::Block::Para.new(config => {}, contents => ["Here some text for the subsection."]);
```

[[↑]](https://docs.raku.org/language/pod#fn-ref-1) This feature is not yet completely implemented. All configuration information currently must be provided on the same line as the `=begin` marker line or `=for name` for paragraph blocks.
