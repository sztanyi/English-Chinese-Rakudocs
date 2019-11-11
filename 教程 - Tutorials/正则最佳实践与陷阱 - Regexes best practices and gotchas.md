原文：https://docs.raku.org/language/concurrency

# 正则：最佳实践与陷阱 / Regexes: best practices and gotchas

关于正则表达式和语法的一些技巧

Some tips on regexes and grammars

为了帮助使用健壮的正则表达式和语法，这里有一些代码布局和可读性的最佳实践，实际匹配的内容，以及避免常见的陷阱。

To help with robust regexes and grammars, here are some best practices for code layout and readability, what to actually match, and avoiding common pitfalls.

<!-- MarkdownTOC -->

- [代码布局 / Code layout](#%E4%BB%A3%E7%A0%81%E5%B8%83%E5%B1%80--code-layout)
- [保持小一点 / Keep it small](#%E4%BF%9D%E6%8C%81%E5%B0%8F%E4%B8%80%E7%82%B9--keep-it-small)
- [匹配什么 / What to match](#%E5%8C%B9%E9%85%8D%E4%BB%80%E4%B9%88--what-to-match)
- [匹配空格 / Matching whitespace](#%E5%8C%B9%E9%85%8D%E7%A9%BA%E6%A0%BC--matching-whitespace)

<!-- /MarkdownTOC -->

<a id="%E4%BB%A3%E7%A0%81%E5%B8%83%E5%B1%80--code-layout"></a>
# 代码布局 / Code layout

如果没有 `:sigspace` 副词，Raku 正则表达式中的空白就没有意义。利用这个优势，在增加可读性的地方插入空白。此外，必要时插入注释。

Without the `:sigspace` adverb, whitespace is not significant in Raku regexes. Use that to your own advantage and insert whitespace where it increases readability. Also, insert comments where necessary.

紧凑版本

Compare the very compact

```Raku
my regex float { <[+-]>?\d*'.'\d+[e<[+-]>?\d+]? }
```

更高可读性版本

to the more readable

```Raku
my regex float {
     <[+-]>?        # optional sign 
     \d*            # leading digits, optional 
     '.'
     \d+
     [              # optional exponent 
        e <[+-]>?  \d+
     ]?
}
```

根据经验，在原子周围和组内使用空白；在原子后面直接放置量词；垂直对齐左括号和右括号和圆括号。

As a rule of thumb, use whitespace around atoms and inside groups; put quantifiers directly after the atom; and vertically align opening and closing square brackets and parentheses.

在圆括号或方括号内使用替换项列表时，请对齐垂直条：

When you use a list of alternations inside parentheses or square brackets, align the vertical bars:

```Raku
my regex example {
    <preamble>
    [
    || <choice_1>
    || <choice_2>
    || <choice_3>
    ]+
    <postamble>
}
```

<a id="%E4%BF%9D%E6%8C%81%E5%B0%8F%E4%B8%80%E7%82%B9--keep-it-small"></a>
# 保持小一点 / Keep it small

正则表达式通常比常规代码更紧凑因为它们用这么少的资源做了这么多，所以保持正则简短。

Regexes are often more compact than regular code. Because they do so much with so little, keep regexes short.

当你可以命名正则的一部分时，通常最好将其放入一个单独的名为 regex 的文件中。

When you can name a part of a regex, it's usually best to put it into a separate, named regex.

例如，可以从前面获取浮点数正则：

For example, you could take the float regex from earlier:

```Raku
my regex float {
     <[+-]>?        # optional sign 
     \d*            # leading digits, optional 
     '.'
     \d+
     [              # optional exponent 
        e <[+-]>?  \d+
     ]?
}
```

把它分解成几个部分：

And decompose it into parts:

```Raku
my token sign { <[+-]> }
my token decimal { \d+ }
my token exponent { 'e' <sign>? <decimal> }
my regex float {
    <sign>?
    <decimal>?
    '.'
    <decimal>
    <exponent>?
}
```

这很有帮助，特别是当正则变得更加复杂时。例如，你可能希望在指数存在时使小数点成为可选。

That helps, especially when the regex becomes more complicated. For example, you might want to make the decimal point optional in the presence of an exponent.

```Raku
my regex float {
    <sign>?
    [
    || <decimal>?  '.' <decimal> <exponent>?
    || <decimal> <exponent>
    ]
}
```

<a id="%E5%8C%B9%E9%85%8D%E4%BB%80%E4%B9%88--what-to-match"></a>
# 匹配什么 / What to match

通常输入数据格式没有明确的规范，或者程序员不知道该规范那么，在你期望的事情上保持自由是件好事，但前提是不存在任何可能的歧义。

Often the input data format has no clear-cut specification, or the specification is not known to the programmer. Then, it's good to be liberal in what you expect, but only so long as there are no possible ambiguities.

例如，在配置文件中：

For example, in `ini` files:

```Raku
[section]
key=value
```

节标题中可以有什么内容？只允许使用一个词可能限制性太强。有人可能会写 `[two words]`，或者使用破折号等。与其问里面允许什么，不如问：*不允许什么？*

What can be inside the section header? Allowing only a word might be too restrictive. Somebody might write `[two words]`, or use dashes, etc. Instead of asking what's allowed on the inside, it might be worth asking instead: *what's not allowed?*

显然，不允许使用右方括号，因为 `[a]b]` 将是不明确的。同样的道理，方括号也应该禁止打开。这就留给我们

Clearly, closing square brackets are not allowed, because `[a]b]` would be ambiguous. By the same argument, opening square brackets should be forbidden. This leaves us with

```Raku
token header { '[' <-[ \[\] ]>+ ']' }
```

如果你只处理一行，那就没问题了。但是如果你正在处理一个完整的文件，正则表达式会突然解析成

which is fine if you are only processing one line. But if you're processing a whole file, suddenly the regex parses

```Raku
[with a
newline in between]
```

这可能不是个好主意。一种妥协写法是

which might not be a good idea. A compromise would be

```Raku
token header { '[' <-[ \[\] \n ]>+ ']' }
```

然后，从节标题中除去前导和尾随空格以及制表符。

and then, in the post-processing, strip leading and trailing spaces and tabs from the section header.

<a id="%E5%8C%B9%E9%85%8D%E7%A9%BA%E6%A0%BC--matching-whitespace"></a>
# 匹配空格 / Matching whitespace

`:sigspace` 副词（或者使用 `rule` 声明符而不是 `token` 或 `regex`）对于隐式解析可能出现在许多地方的空白非常方便。

The `:sigspace` adverb (or using the `rule` declarator instead of `token` or `regex`) is very handy for implicitly parsing whitespace that can appear in many places.

回到解析 `ini` 文件的例子，我们有

Going back to the example of parsing `ini` files, we have

```Raku
my regex kvpair { \s* <key=identifier> '=' <value=identifier> \n+ }
```

这可能不像我们希望的那样自由，因为用户可能会在等号周围放置空格那么，我们可以试试这个：

which is probably not as liberal as we want it to be, since the user might put spaces around the equals sign. So, then we may try this:

```Raku
my regex kvpair { \s* <key=identifier> \s* '=' \s* <value=identifier> \n+ }
```

但这看起来很笨拙，所以我们尝试其他方法：

But that's looking unwieldy, so we try something else:

```Raku
my rule kvpair { <key=identifier> '=' <value=identifier> \n+ }
```

但是等等！值后面的隐式空白匹配耗尽了所有空白，包括换行符，因此 `\n+` 没有任何可以匹配的内容（而且 `rule` 还禁用了回溯，因此匹配没戏）。

But wait! The implicit whitespace matching after the value uses up all whitespace, including newline characters, so the `\n+` doesn't have anything left to match (and `rule` also disables backtracking, so no luck there).

因此，将隐式空白的定义重新定义为输入格式中不重要的空白是很重要的。

Therefore, it's important to redefine your definition of implicit whitespace to whitespace that is not significant in the input format.

这可以通过重新定义标记 `ws` 来工作；但是，它只适用于 [grammar](https://docs.raku.org/language/grammars)：

This works by redefining the token `ws`; however, it only works for [grammars](https://docs.raku.org/language/grammars):

```Raku
grammar IniFormat {
    token ws { <!ww> \h* }
    rule header { \s* '[' (\w+) ']' \n+ }
    token identifier  { \w+ }
    rule kvpair { \s* <key=identifier> '=' <value=identifier> \n+ }
    token section {
        <header>
        <kvpair>*
    }
 
    token TOP {
        <section>*
    }
}
 
my $contents = q:to/EOI/; 
    [passwords]
        jack = password1
        joy = muchmoresecure123
    [quotas]
        jack = 123
        joy = 42
EOI
say so IniFormat.parse($contents);
```

除了将所有正则表达式放入 grammar 并将其转换为 token（因为它们无论如何都不需要回溯）之外，有趣的点是

Besides putting all regexes into a grammar and turning them into tokens (because they don't need to backtrack anyway), the interesting new bit is

```Raku
token ws { <!ww> \h* }
```

它调用隐式空白分析。不在两个单词字符之间时匹配（`<！ww>`，在单词里的否定断言），以及零个或多个水平空格字符对水平空白的限制很重要，因为换行符（垂直空白）分隔记录，不应该隐式匹配。

which gets called for implicit whitespace parsing. It matches when it's not between two word characters (`<!ww>`, negated "within word" assertion), and zero or more horizontal space characters. The limitation to horizontal whitespace is important, because newlines (which are vertical whitespace) delimit records and shouldn't be matched implicitly.

不过，仍有一些与空白相关的问题潜伏着。正则表达式 `\n+` 与类似 `"\n \n"` 的字符串不匹配，因为两个换行符之间有一个空格。若要允许此类输入字符串，请将 `\n+` 替换为 `\n\s*`。

Still, there's some whitespace-related trouble lurking. The regex `\n+` won't match a string like `"\n \n"`, because there's a blank between the two newlines. To allow such input strings, replace `\n+` with `\n\s*`.
