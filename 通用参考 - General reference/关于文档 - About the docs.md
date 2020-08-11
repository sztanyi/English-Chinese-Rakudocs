原文：https://docs.raku.org/language/about

# 关于文档 / About the docs

元文档

Metadocumentation

这个文档集合代表了记录 Raku 编程语言的持续努力，其目标是全面、易于使用、易于导航，并且对新来者和有经验的 Raku 程序员都有用。

This document collection represents the on-going effort to document the Raku programming language with the goals of being comprehensive, easy to use, easy to navigate, and useful to both newcomers and experienced Raku programmers.

该文档的 HTML 版本位于 [https://docs.raku.org](https://docs.raku.org/)。

An HTML version of the documentation is located online at [https://docs.raku.org](https://docs.raku.org/).

本文档的官方来源位于 [Raku/doc on GitHub](https://github.com/Raku/doc)。

The official source for this documentation is located at [Raku/doc on GitHub](https://github.com/Raku/doc).

此特定文档是对 [GitHub 上 CONTRIBUTING 文件](https://github.com/Raku/doc/blob/master/CONTRIBUTING.md) 的快速概述。本文档还提供了编写 Raku Pod 文件的简短介绍，该文件可以呈现为 HTML 和其他格式。

This particular document is a quick overview of the process described in more detail in [CONTRIBUTING on GitHub](https://github.com/Raku/doc/blob/master/CONTRIBUTING.md). This document also provides a short introduction to writing Raku Pod files, which can be rendered into HTML and other formats.

<!-- MarkdownTOC -->

- [结构 / Structure](#结构--structure)
- [Pod 转为 HTML / Generating HTML from Pod](#pod-转为-html--generating-html-from-pod)
- [贡献 / Contributing](#贡献--contributing)
    - [添加定义 / Adding definitions](#添加定义--adding-definitions)

<!-- /MarkdownTOC -->


<a id="结构--structure"></a>
# 结构 / Structure

所有文件都写在 Raku Pod 中，并保存在 `doc/` 目录”和 `doc/Language/` 和 `doc/Type/` 子目录中。这些文件作为定义或“可记录文件”的集合处理，然后将其后处理和链接在一起。

All of the documentation is written in Raku Pod and kept in the `doc/` directory, and the `doc/Language/` and `doc/Type/` sub-directories. These files are processed as collections of definitions or "documentables", which are then post-processed and linked together.

<a id="pod-转为-html--generating-html-from-pod"></a>
# Pod 转为 HTML / Generating HTML from Pod

要从 Pod 文件生成 HTML，你需要：

To generate HTML from the Pod files, you'll need:

- Rakudo Raku 编译器的最新版本
- Raku 模块 Pod::To::HTML、Pod::To::BigPage 和 URI::Escape，所有这些都可以通过 [zef](https://github.com/ugexe/zef) 安装。例如，`zef install Pod::To::HTML` 安装 Pod::To::HTML 模组。
- [`Documentable`](https://modules.raku.org/dist/Documentable), 文档 API.
- **可选**: [GraphViz](https://www.graphviz.org/), 用于创建 Raku 类型之间关系的图表.
- **可选**: [Atom Highlights](https://github.com/atom/highlights) 以及 [language-perl6](https://atom.io/packages/language-perl6) 语法高亮。

- A recent version of the Rakudo Raku compiler
- The Raku modules Pod::To::HTML, Pod::To::BigPage, and URI::Escape which all can be installed via [zef](https://github.com/ugexe/zef). For instance, `zef install Pod::To::HTML` to install Pod::To::HTML.
- [`Documentable`](https://modules.raku.org/dist/Documentable), the document API.
- **Optional**: [GraphViz](https://www.graphviz.org/), for creating graphs of the relationships between Raku types.
- **Optional**: [Atom Highlights](https://github.com/atom/highlights) and [language-perl6](https://atom.io/packages/language-perl6), for syntax highlighting.

若要将文档生成到 `html/` 文件夹中，请运行：

To generate the documentation into the `html/` folder, run:

```Raku
documentable start -a -v --highlight
```

若要从 Web 服务器托管文档，请安装 Perl 5 和 Mojolicious::Lite；如果安装了 Perl，请运行

To host the documentation from a web server, have Perl 5 and Mojolicious::Lite installed; if you have Perl, run

```Shell
cpanm --installdeps .
```

然后执行

and then run:

```Shell
perl app.pl daemon
```

<a id="贡献--contributing"></a>
# 贡献 / Contributing

文档使用 Raku Pod 写成。

The documentation is written in Raku Pod.

有关 Raku Pod 的快速介绍，请参阅 [Raku Pod](https://docs.raku.org/language/pod)。

For a quick introduction to Raku Pod, see [Raku Pod](https://docs.raku.org/language/pod).

有关 Raku Pod 规范的详细信息，请参见 [Synopsis 26，Documentation]（https://design.raku.org/S26.html）。

For full details about the Raku Pod specification, see [Synopsis 26, Documentation](https://design.raku.org/S26.html).

<a id="添加定义--adding-definitions"></a>
## 添加定义 / Adding definitions

可使用 `=headN` Pod 指令定义 documentable，其中 `N` 大于零（例如 `=head1`、`=head2` 。。。）。

Documentables can be defined using an `=headN` Pod directive, where `N` is greater than zero (e.g., `=head1`, `=head2`, …).

该指令之后的所有段落和块，直到下一个相同级别的指令，将被视为 documentable 的一部分。所以，在：

All of the paragraphs and blocks following that directive, up until the next directive of the same level, will be considered part of the documentable. So, in:

```Raku
    =head2 My Definition

    Some paragraphs, followed by some code:

    =begin code
    my Code $examples = "amazing";
    =end code

    Mind === blown.

    =head3 Minor details about My Definition

    It's fantastic.

    =head2 And now, for something completely different

    …
```

`My Definition` documentable 延伸到 `=head2 And now…`。

The documentable My Definition extends down to the `=head2 And now…`.

documentable 可能包含其他 documentable。例如，通常包含类实现的方法。

Documentables may contain other documentables. Class documentables, for example, often contain the methods the class implements.

定义必须是以下形式之一，才能被承认为 documentable 的名称的开始，例如，þ 。首先是文件源中的代码：

Definitions must be in one of the following forms to be recognized as the start of a documentable named, say, þ. First the code in the document source:

```Raku
=item X<C<How to use the þ infix> | infix,þ> (This a special case, which 
is always considered a definition)
 
=item C<The þ Infix> 
 
=item B<The C<þ> Infix> 
 
=item C<Infix þ> 
 
=item B<Infix C<þ>> 
 
=item C<trait is cached> (A special case for the L<trait|/language/functions#Traits> documentables) 
 
```

然后是渲染页面的结果：

Then the results on the rendered page:

- `How to use the þ infix` (This is a special case, which is always considered a definition)
- `The þ Infix`
- **The þ Infix**
- `Infix þ`
- **Infix þ**
- `trait is cached` (A special case for the [trait](https://docs.raku.org/language/functions#Traits) documentables)

这些项目现在应该可以通过使用 HTML 文档中的搜索框来搜索。

These items should now be searchable by using the search field in the HTML docs.

你可以添加粗体（**B<>**）或斜体（**I<>**）的强调，有或没有代码格式（**C<>**）。由于目前的解析器的局限性，必须采取特别步骤，将 **X<>** 与其他格式代码一起使用；例如：

You can add emphasis with bold ( **B<>** ) or italicized ( **I<>** ), with or without code formatting ( **C<>** ). Due to current parser limitations, special steps have to be taken to use **X<>** with other formatting codes; for example:

```Raku
=item X<B<foo>|foo> a fancy subroutine 
```

像这样呈现

renders like this

```
- **foo** a fancy subroutine
```

请注意，管道（“|”）之后的文本没有格式。还请注意，**C<>**保留空格，并将案文逐字处理。

Notice that text after a pipe ('|') has no formatting. Also note that **C<>** preserves spaces and treats text as verbatim.
