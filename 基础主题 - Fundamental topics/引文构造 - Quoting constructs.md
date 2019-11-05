原文：https://docs.raku.org/language/quoting

# 引文构造 / Quoting constructs

在 Raku 中编写字符串、单词列表和正则表达式

Writing strings, word lists, and regexes in Raku
<!-- MarkdownTOC -->

- [Q 语言 / The Q lang](#q-%E8%AF%AD%E8%A8%80--the-q-lang)
  - [字符串文本：Q / Literal strings: Q](#%E5%AD%97%E7%AC%A6%E4%B8%B2%E6%96%87%E6%9C%AC%EF%BC%9Aq--literal-strings-q)
  - [转义： q / Escaping: q](#%E8%BD%AC%E4%B9%89%EF%BC%9A-q--escaping-q)
  - [字符串插值： qq / Interpolation: qq](#%E5%AD%97%E7%AC%A6%E4%B8%B2%E6%8F%92%E5%80%BC%EF%BC%9A-qq--interpolation-qq)
  - [词引文: qw / Word quoting: qw](#%E8%AF%8D%E5%BC%95%E6%96%87-qw--word-quoting-qw)
  - [词引文:  / Word quoting:](#%E8%AF%8D%E5%BC%95%E6%96%87--word-quoting)
  - [引号保护词引文：qww / Word quoting with quote protection: qww](#%E5%BC%95%E5%8F%B7%E4%BF%9D%E6%8A%A4%E8%AF%8D%E5%BC%95%E6%96%87%EF%BC%9Aqww--word-quoting-with-quote-protection-qww)
  - [字符串插值词引文：qqw / Word quoting with interpolation: qqw](#%E5%AD%97%E7%AC%A6%E4%B8%B2%E6%8F%92%E5%80%BC%E8%AF%8D%E5%BC%95%E6%96%87%EF%BC%9Aqqw--word-quoting-with-interpolation-qqw)
  - [字符串插值词以及引号保护词引文：qqww / Word quoting with interpolation and quote protection: qqww](#%E5%AD%97%E7%AC%A6%E4%B8%B2%E6%8F%92%E5%80%BC%E8%AF%8D%E4%BB%A5%E5%8F%8A%E5%BC%95%E5%8F%B7%E4%BF%9D%E6%8A%A4%E8%AF%8D%E5%BC%95%E6%96%87%EF%BC%9Aqqww--word-quoting-with-interpolation-and-quote-protection-qqww)
  - [字符串插值词以及引号保护词引文：« » / Word quoting with interpolation and quote protection: « »](#%E5%AD%97%E7%AC%A6%E4%B8%B2%E6%8F%92%E5%80%BC%E8%AF%8D%E4%BB%A5%E5%8F%8A%E5%BC%95%E5%8F%B7%E4%BF%9D%E6%8A%A4%E8%AF%8D%E5%BC%95%E6%96%87%EF%BC%9A%C2%AB-%C2%BB--word-quoting-with-interpolation-and-quote-protection-%C2%AB-%C2%BB)
  - [Shell 引文：qx / Shell quoting: qx](#shell-%E5%BC%95%E6%96%87%EF%BC%9Aqx--shell-quoting-qx)
  - [带字符串插值的 Shell 引文：qqx / Shell quoting with interpolation: qqx](#%E5%B8%A6%E5%AD%97%E7%AC%A6%E4%B8%B2%E6%8F%92%E5%80%BC%E7%9A%84-shell-%E5%BC%95%E6%96%87%EF%BC%9Aqqx--shell-quoting-with-interpolation-qqx)
  - [Heredocs: :to](#heredocs-to)
  - [反引文 / Unquoting](#%E5%8F%8D%E5%BC%95%E6%96%87--unquoting)
- [正则 / Regexes](#%E6%AD%A3%E5%88%99--regexes)

<!-- /MarkdownTOC -->

<a id="q-%E8%AF%AD%E8%A8%80--the-q-lang"></a>
# Q 语言 / The Q lang

字符串通常用某种形式的引用构造在 Raku 代码中表示。其中最简约的是 `Q`，可通过快捷方式 `｢…｣` 使用，或通过 `Q`，后面跟着围绕你的文本的任何一对分隔符。然而，大多数时候，你最需要的是‘…’`或‘’…‘`，下文将更详细地介绍。

Strings are usually represented in Raku code using some form of quoting construct. The most minimalistic of these is `Q`, usable via the shortcut `｢…｣`, or via `Q` followed by any pair of delimiters surrounding your text. Most of the time, though, the most you'll need is `'…'` or `"…"`, described in more detail in the following sections.

<a id="%E5%AD%97%E7%AC%A6%E4%B8%B2%E6%96%87%E6%9C%AC%EF%BC%9Aq--literal-strings-q"></a>
## 字符串文本：Q / Literal strings: Q

```Raku
Q[A literal string]
｢More plainly.｣
Q ^Almost any non-word character can be a delimiter!^
Q ｢｢Delimiters can be repeated/nested if they are adjacent.｣｣
```

分隔符可以嵌套，但在普通的 `Q` 形式中，反斜杠转义是不允许的。换句话说，基本的 `Q` 字符串是尽可能的字面意思。

Delimiters can be nested, but in the plain `Q` form, backslash escapes aren't allowed. In other words, basic `Q` strings are as literal as possible.

在 `Q`、`q` 或 `qq` 之后不允许使用某些分隔符。不允许使用[标识符](https://docs.raku.org/language/syntax#Identifiers)中允许的任何字符，因为在这种情况下，引用构造连同这些字符一起被解释为标识符。此外，`( )` 是不允许的，因为它被解释为函数调用。如果你仍然希望使用这些字符作为分隔符，请用空格将它们与 `Q`、`q` 或 `qq` 分隔开。请注意，一些自然语言在字符串的右侧使用左分隔引号。`Q` 不支持这些，因为它依赖 Unicode 属性区分左分隔符和右分隔符。

Some delimiters are not allowed immediately after `Q`, `q`, or `qq`. Any characters that are allowed in [identifiers](https://docs.raku.org/language/syntax#Identifiers) are not allowed to be used, since in such a case, the quoting construct together with such characters are interpreted as an identifier. In addition, `( )` is not allowed because that is interpreted as a function call. If you still wish to use those characters as delimiters, separate them from `Q`, `q`, or `qq` with a space. Please note that some natural languages use a left delimiting quote on the right side of a string. `Q` will not support those as it relies on unicode properties to tell left and right delimiters apart.

```Raku
Q'this will not work!'
Q(this won't work either!)
```

上面的例子将产生一个错误。不过，这是可行的。

The examples above will produce an error. However, this will work

```Raku
Q (this is fine, because of space after Q)
Q 'and so is this'
Q<Make sure you <match> opening and closing delimiters>
Q{This is still a closing curly brace → \}
```

这些例子输出：

These examples produce:

```Raku
this is fine, because of space after Q
and so is this
Make sure you <match> opening and closing delimiters
This is still a closing curly brace → \
```

引用结构的行为可以用副词来修改，详见后面的章节。

The behavior of quoting constructs can be modified with adverbs, as explained in detail in later sections.

| Short | Long        | Meaning                                                    |
| ----- | ----------- | ---------------------------------------------------------- |
| :x    | :exec       | Execute as command and return results                      |
| :w    | :words      | Split result on words (no quote protection)                |
| :ww   | :quotewords | Split result on words (with quote protection)              |
| :q    | :single     | Interpolate \\, \qq[...] and escaping the delimiter with \ |
| :qq   | :double     | Interpolate with :s, :a, :h, :f, :c, :b                    |
| :s    | :scalar     | Interpolate $ vars                                         |
| :a    | :array      | Interpolate @ vars                                         |
| :h    | :hash       | Interpolate % vars                                         |
| :f    | :function   | Interpolate & calls                                        |
| :c    | :closure    | Interpolate {...} expressions                              |
| :b    | :backslash  | Enable backslash escapes (\n, \qq, \$foo, etc)             |
| :to   | :heredoc    | Parse result as heredoc terminator                         |
| :v    | :val        | Convert to allomorph if possible                           |

<a id="%E8%BD%AC%E4%B9%89%EF%BC%9A-q--escaping-q"></a>
## 转义： q / Escaping: q

```Raku
'Very plain';
q[This back\slash stays];
q[This back\\slash stays]; # Identical output 
q{This is not a closing curly brace → \}, but this is → };
Q :q $There are no backslashes here, only lots of \$\$\$>!$;
'(Just kidding. There\'s no money in that string)';
'No $interpolation {here}!';
Q:q!Just a literal "\n" here!;
```

`q` 形式允许转义字符，否则这些字符将使用反斜杠结束字符串。反斜杠本身也可以转义，如上面的第三个例子所示。通常的形式是 `'…' `或 `q` 后面跟着分隔符，但它也可作为 `Q` 上的副词，如上文第五个和最后一个例子所示。

The `q` form allows for escaping characters that would otherwise end the string using a backslash. The backslash itself can be escaped, too, as in the third example above. The usual form is `'…'` or `q` followed by a delimiter, but it's also available as an adverb on `Q`, as in the fifth and last example above.

这些示例产生：

These examples produce:

```Raku
Very plain
This back\slash stays
This back\slash stays
This is not a closing curly brace → } but this is →
There are no backslashes here, only lots of $$$!
(Just kidding. There's no money in that string)
No $interpolation {here}!
Just a literal "\n" here
```

`\qq[...]` 转义序列为字符串的一部分启用了[`qq` 字符串插值](https://docs.raku.org/language/quoting#Interpolation:_qq)。当字符串中有 HTML 标记时，使用此转义序列非常方便，以避免将尖括号解释为散列键：

The `\qq[...]` escape sequence enables [`qq` interpolation](https://docs.raku.org/language/quoting#Interpolation:_qq) for a portion of the string. Using this escape sequence is handy when you have HTML markup in your strings, to avoid interpretation of angle brackets as hash keys:

```Raku
my $var = 'foo';
say '<code>$var</code> is <var>\qq[$var.uc()]</var>';
# OUTPUT: «<code>$var</code> is <var>FOO</var>␤»
```

<a id="%E5%AD%97%E7%AC%A6%E4%B8%B2%E6%8F%92%E5%80%BC%EF%BC%9A-qq--interpolation-qq"></a>
## 字符串插值： qq / Interpolation: qq

```Raku
my $color = 'blue';
say "My favorite color is $color!"
My favorite color is blue!
```

`qq` 形式--通常用双引号写--允许反斜杠序列和变量进行插值，即可以在字符串中写入变量，以便将变量的内容插入到字符串中。还可以在 `qq`-引号字符串中转义变量：

The `qq` form – usually written using double quotes – allows for interpolation of backslash sequences and variables, i.e., variables can be written within the string so that the content of the variable is inserted into the string. It is also possible to escape variables within a `qq`-quoted string:

```Raku
say "The \$color variable contains the value '$color'";
The $color variable contains the value 'blue'
```

`qq` 的另一个特性是能够使用大括号从字符串内插入 Raku 代码：

Another feature of `qq` is the ability to interpolate Raku code from within the string, using curly braces:

```Raku
my ($x, $y, $z) = 4, 3.5, 3;
say "This room is $x m by $y m by $z m.";
say "Therefore its volume should be { $x * $y * $z } m³!";
This room is 4 m by 3.5 m by 3 m.
Therefore its volume should be 42 m³!
```

默认情况下，只有 `$` 标记的变量才能正常内插。这样，当你编写 `"documentation@perl6.org"` 时，就不会插入 `@perl6` 变量。如果这是你想要做的，那么在变量名后面添加一个 `[]`：

By default, only variables with the `$` sigil are interpolated normally. This way, when you write `"documentation@perl6.org"`, you aren't interpolating the `@perl6` variable. If that's what you want to do, append a `[]` to the variable name:

```Raku
my @neighbors = "Felix", "Danielle", "Lucinda";
say "@neighbors[] and I try our best to coexist peacefully."
Felix Danielle Lucinda and I try our best to coexist peacefully.
```

通常，方法调用更合适。只要它们在调用后有括号，就允许在 `qq` 引号中使用。因此，以下代码将起作用：

Often a method call is more appropriate. These are allowed within `qq` quotes as long as they have parentheses after the call. Thus the following code will work:

```Raku
say "@neighbors.join(', ') and I try our best to coexist peacefully."
Felix, Danielle, Lucinda and I try our best to coexist peacefully.
```

然而 `"@example.com"` 输出 `@example.com`。

However, `"@example.com"` produces `@example.com`.

调用一个子例程，使用 `&` 标记。

To call a subroutine, use the `&`-sigil.

```Raku
say "abc&uc("def")ghi";
# OUTPUT: «abcDEFghi␤»
```

对后环缀运算符也生效，因此 [下标](https://docs.raku.org/language/subscripts) 也能插值。

Postcircumfix operators and therefore [subscripts](https://docs.raku.org/language/subscripts) are interpolated as well.

```Raku
my %h = :1st; say "abc%h<st>ghi";
# OUTPUT: «abc1ghi␤»
```

要输入 Unicode 序列，请在字符的十六进制代码或字符列表中使用 `\x` 或 `\x[]`。

To enter unicode sequences, use `\x` or `\x[]` with the hex-code of the character or a list of characters.

```Raku
my $s = "I \x2665 Raku!";
say $s;
# OUTPUT: «I ♥ Raku!␤» 
 
$s = "I really \x[2661,2665,2764,1f495] Raku!";
say $s;
# OUTPUT: «I really ♡♥❤💕 Raku!␤»
```

你也可以在 [\c[]](https://docs.raku.org/language/unicode#Entering_unicode_codepoints_and_codepoint_sequences) 中使用 [unicode](https://docs.raku.org/language/unicode#Entering_unicode_codepoints_and_codepoint_sequences)、[命名序列](https://docs.raku.org/language/unicode#Named_sequences)以及[名称别名](https://docs.raku.org/language/unicode#Name_aliases)。

You can also use [unicode names](https://docs.raku.org/language/unicode#Entering_unicode_codepoints_and_codepoint_sequences) , [named sequences](https://docs.raku.org/language/unicode#Named_sequences) and [name aliases](https://docs.raku.org/language/unicode#Name_aliases) with [\c[]](https://docs.raku.org/language/unicode#Entering_unicode_codepoints_and_codepoint_sequences).

```Raku
my $s = "Camelia \c[BROKEN HEART] my \c[HEAVY BLACK HEART]!";
say $s;
# OUTPUT: «Camelia 💔 my ❤!␤»
```

字符串插入未定义值将引发一个控制异常，该异常可以在当前块中用 [CONTROL](https://docs.raku.org/language/phasers#CONTROL) 捕获。

Interpolation of undefined values will raise a control exception that can be caught in the current block with [CONTROL](https://docs.raku.org/language/phasers#CONTROL).

```Raku
sub niler {Nil};
my Str $a = niler;
say("$a.html", "sometext");
say "alive"; # this line is dead code 
CONTROL { .die };
```

<a id="%E8%AF%8D%E5%BC%95%E6%96%87-qw--word-quoting-qw"></a>
## 词引文: qw / Word quoting: qw 

```Raku
qw|! @ # $ % ^ & * \| < > | eqv '! @ # $ % ^ & * | < >'.words.list;
q:w { [ ] \{ \} } eqv ('[', ']', '{', '}');
Q:w | [ ] { } | eqv ('[', ']', '{', '}');
```

`:w` 形式通常写成 `qw`，将字符串拆分为"词"。在此背景下，单词被定义为由空格分隔的非空格字符序列.`q:w` 和 `qw` 形式继承 `q`  和单引号字符串分隔符的插值和转义语义，而 `Qw` 和 `Q:w` 继承 `Q` 的非转义语义。

The `:w` form, usually written as `qw`, splits the string into "words". In this context, words are defined as sequences of non-whitespace characters separated by whitespace. The `q:w` and `qw` forms inherit the interpolation and escape semantics of the `q` and single quote string delimiters, whereas `Qw` and `Q:w` inherit the non-escaping semantics of the `Q` quoter.

这种形式优先用于字符串列表中的许多引号和逗号。例如，你可以在其中编写：

This form is used in preference to using many quotation marks and commas for lists of strings. For example, where you could write:

```Raku
my @directions = 'left', 'right,', 'up', 'down';
```

这样更容易书写和阅读：

It's easier to write and to read this:

```Raku
my @directions = qw|left right up down|;
```

<a id="%E8%AF%8D%E5%BC%95%E6%96%87--word-quoting"></a>
## 词引文: < > / Word quoting: < > 

```Raku
say <a b c> eqv ('a', 'b', 'c');   # OUTPUT: «True␤»
say <a b 42> eqv ('a', 'b', '42'); # OUTPUT: «False␤», the 42 became an IntStr allomorph
say < 42 > ~~ Int; # OUTPUT: «True␤»
say < 42 > ~~ Str; # OUTPUT: «True␤»
```

尖括号引用类似于 `qw`，但是有了额外的特性，你可以构造[语素变体](https://docs.raku.org/language/glossary#index-entry-Allomorph)或特定数字的文字：

The angle brackets quoting is like `qw`, but with extra feature that lets you construct [allomorphs](https://docs.raku.org/language/glossary#index-entry-Allomorph) or literals of certain numbers:

```Raku
say <42 4/2 1e6 1+1i abc>.perl;
# OUTPUT: «(IntStr.new(42, "42"), RatStr.new(2.0, "4/2"), NumStr.new(1000000e0, "1e6"), ComplexStr.new(<1+1i>, "1+1i"), "abc")␤»
```

要构建 [`Rat`](https://docs.raku.org/type/Rat) 或者 [`Complex`](https://docs.raku.org/type/Complex)，使用尖括号包围数字，不能有多余空格：

To construct a [`Rat`](https://docs.raku.org/type/Rat) or [`Complex`](https://docs.raku.org/type/Complex) literal, use angle brackets around the number, without any extra spaces:

```Raku
say <42/10>.^name;   # OUTPUT: «Rat␤» 
say <1+42i>.^name;   # OUTPUT: «Complex␤» 
say < 42/10 >.^name; # OUTPUT: «RatStr␤» 
say < 1+42i >.^name; # OUTPUT: «ComplexStr␤»
```

与 `42/10` 和 `1+42i` 相比，不会进行除法（或加法）操作。这对于常规签名中的文本很有用，例如：

Compared to `42/10` and `1+42i`, there's no division (or addition) operation involved. This is useful for literals in routine signatures, for example:

```Raku
sub close-enough-π (<355/113>) {
    say "Your π is close enough!"
}
close-enough-π 710/226; # OUTPUT: «Your π is close enough!␤» 
# WRONG: can't do this, since it's a division operation 
sub compilation-failure (355/113) {}
```

<a id="%E5%BC%95%E5%8F%B7%E4%BF%9D%E6%8A%A4%E8%AF%8D%E5%BC%95%E6%96%87%EF%BC%9Aqww--word-quoting-with-quote-protection-qww"></a>
## 引号保护词引文：qww / Word quoting with quote protection: qww

词引用的 `qw` 形式将按字面量处理引号，将它们留在结果的词中：

The `qw` form of word quoting will treat quote characters literally, leaving them in the resulting words:

```Raku
say qw{"a b" c}.perl; # OUTPUT: «("\"a", "b\"", "c")␤»
```

因此，如果你希望将引用的子字符串保留为结果单词中的单个项，则需要使用 `qww` 变体：

Thus, if you wish to preserve quoted sub-strings as single items in the resulting words you need to use the `qww` variant:

```Raku
say qww{"a b" c}.perl; # OUTPUT: «("a b", "c")␤»
```

<a id="%E5%AD%97%E7%AC%A6%E4%B8%B2%E6%8F%92%E5%80%BC%E8%AF%8D%E5%BC%95%E6%96%87%EF%BC%9Aqqw--word-quoting-with-interpolation-qqw"></a>
## 字符串插值词引文：qqw / Word quoting with interpolation: qqw

`qw` 形式的词引文不进行变量插值：

The `qw` form of word quoting doesn't interpolate variables:

```Raku
my $a = 42; say qw{$a b c};  # OUTPUT: «$a b c␤»
```

因此，如果希望在引用的字符串中插入变量，则需要使用 `qqw` 变体：

Thus, if you wish for variables to be interpolated within the quoted string, you need to use the `qqw` variant:

```Raku
my $a = 42;
my @list = qqw{$a b c};
say @list;                # OUTPUT: «[42 b c]␤»
```

请注意，变量插值发生在分词之前：

Note that variable interpolation happens before word splitting:

```Raku
my $a = "a b";
my @list = qqw{$a c};
.say for @list; # OUTPUT: «a␤b␤c␤»
```

<a id="%E5%AD%97%E7%AC%A6%E4%B8%B2%E6%8F%92%E5%80%BC%E8%AF%8D%E4%BB%A5%E5%8F%8A%E5%BC%95%E5%8F%B7%E4%BF%9D%E6%8A%A4%E8%AF%8D%E5%BC%95%E6%96%87%EF%BC%9Aqqww--word-quoting-with-interpolation-and-quote-protection-qqww"></a>
## 字符串插值词以及引号保护词引文：qqww / Word quoting with interpolation and quote protection: qqww

词引文的 `qqw` 形式将按字面量处理引号，将它们留在结果词中：

The `qqw` form of word quoting will treat quote characters literally, leaving them in the resulting words:

```Raku
my $a = 42; say qqw{"$a b" c}.perl;  # OUTPUT: «("\"42", "b\"", "c")␤»
```

因此，如果希望将引用的子字符串保留为结果词中的单个项，则需要使用 `qqww` 变体：

Thus, if you wish to preserve quoted sub-strings as single items in the resulting words you need to use the `qqww` variant:

```Raku
my $a = 42; say qqww{"$a b" c}.perl; # OUTPUT: «("42 b", "c")␤»
```

引号保护发生在插值之前，插值发生在分词之前，因此来自内插变量的引号只是文字引号字符：

Quote protection happens before interpolation, and interpolation happens before word splitting, so quotes coming from inside interpolated variables are just literal quote characters:

```Raku
my $a = "1 2";
say qqww{"$a" $a}.perl; # OUTPUT: «("1 2", "1", "2")␤» 
my $b = "1 \"2 3\"";
say qqww{"$b" $b}.perl; # OUTPUT: «("1 \"2 3\"", "1", "\"2", "3\"")␤»
```

<a id="%E5%AD%97%E7%AC%A6%E4%B8%B2%E6%8F%92%E5%80%BC%E8%AF%8D%E4%BB%A5%E5%8F%8A%E5%BC%95%E5%8F%B7%E4%BF%9D%E6%8A%A4%E8%AF%8D%E5%BC%95%E6%96%87%EF%BC%9A%C2%AB-%C2%BB--word-quoting-with-interpolation-and-quote-protection-%C2%AB-%C2%BB"></a>
## 字符串插值词以及引号保护词引文：« » / Word quoting with interpolation and quote protection: « »

这种方式的引用与 `qqww` 类似，但是有构建[语素变体](https://docs.raku.org/language/glossary#index-entry-Allomorph)的额外好处（使其功能上等价于 [qq:ww:v](https://docs.raku.org/language/quoting#index-entry-%3Aval_%28quoting_adverb%29)）。`« »` 的 ASCII 等价为双尖括号 `<< >>`。

This style of quoting is like `qqww`, but with the added benefit of constructing [allomorphs](https://docs.raku.org/language/glossary#index-entry-Allomorph) (making it functionally equivalent to [qq:ww:v](https://docs.raku.org/language/quoting#index-entry-%3Aval_%28quoting_adverb%29)). The ASCII equivalent to `« »` are double angle brackets `<< >>`.

```Raku
# Allomorph Construction 
my $a = 42; say «  $a b c    ».perl;  # OUTPUT: «(IntStr.new(42, "42"), "b", "c")␤» 
my $a = 42; say << $a b c   >>.perl;  # OUTPUT: «(IntStr.new(42, "42"), "b", "c")␤» 
 
# Quote Protection 
my $a = 42; say «  "$a b" c  ».perl;  # OUTPUT: «("42 b", "c")␤» 
my $a = 42; say << "$a b" c >>.perl;  # OUTPUT: «("42 b", "c")␤»
```

<a id="shell-%E5%BC%95%E6%96%87%EF%BC%9Aqx--shell-quoting-qx"></a>
## Shell 引文：qx / Shell quoting: qx

要将字符串作为外部程序运行，不仅可以将字符串传递给 `shell` 或 `run` 函数，还可以使用 shell 引文。然而，也有一些微妙之处需要考虑。`qx` *不*插值变量。因此

To run a string as an external program, not only is it possible to pass the string to the `shell` or `run` functions but one can also perform shell quoting. There are some subtleties to consider, however. `qx` quotes *don't* interpolate variables. Thus

```Raku
my $world = "there";
say qx{echo "hello $world"}
```

单纯打印 `hello`。然而，如果你在调用 `perl6` 之前声明了一个环境变量，这将在 `qx` 中可用，例如

prints simply `hello`. Nevertheless, if you have declared an environment variable before calling `perl6`, this will be available within `qx`, for instance

```Raku
WORLD="there" perl6
> say qx{echo "hello $WORLD"}
```

将打印 `hello there`。

will now print `hello there`.

返回调用 `qx` 的结果，因此可以将此信息赋值给一个变量，供以后使用：

The result of calling `qx` is returned, so this information can be assigned to a variable for later use:

```Raku
my $output = qx{echo "hello!"};
say $output;    # OUTPUT: «hello!␤»
```

用其他方式执行外部命令也可以参阅 [shell](https://docs.raku.org/routine/shell)、[run](https://docs.raku.org/routine/run) 以及 [Proc::Async](https://docs.raku.org/type/Proc::Async)。

See also [shell](https://docs.raku.org/routine/shell), [run](https://docs.raku.org/routine/run) and [Proc::Async](https://docs.raku.org/type/Proc::Async) for other ways to execute external commands.

<a id="%E5%B8%A6%E5%AD%97%E7%AC%A6%E4%B8%B2%E6%8F%92%E5%80%BC%E7%9A%84-shell-%E5%BC%95%E6%96%87%EF%BC%9Aqqx--shell-quoting-with-interpolation-qqx"></a>
## 带字符串插值的 Shell 引文：qqx / Shell quoting with interpolation: qqx

如果希望在外部命令中使用 Raku 变量的内容，则应该使用 `qqx` shell 引文结构：

If one wishes to use the content of a Raku variable within an external command, then the `qqx` shell quoting construct should be used:

```Raku
my $world = "there";
say qqx{echo "hello $world"};  # OUTPUT: «hello there␤»
```

同样，外部命令的输出可以保存在一个变量中：

Again, the output of the external command can be kept in a variable:

```Raku
my $word = "cool";
my $option = "-i";
my $file = "/usr/share/dict/words";
my $output = qqx{grep $option $word $file};
# runs the command: grep -i cool /usr/share/dict/words 
say $output;      # OUTPUT: «Cooley␤Cooley's␤Coolidge␤Coolidge's␤cool␤...»
```

还请参阅 [run](https://docs.raku.org/routine/run) 和 [Proc::Async](https://docs.raku.org/type/Proc::Async) 以获得执行外部命令的更好方法。

See also [run](https://docs.raku.org/routine/run) and [Proc::Async](https://docs.raku.org/type/Proc::Async) for better ways to execute external commands.

<a id="heredocs-to"></a>
## Heredocs: :to

编写多行字符串文字的一种方便方法是 *heredocs*，它允许你自己选择分隔符：

A convenient way to write multi-line string literals are *heredocs*, which let you choose the delimiter yourself:

```Raku
say q:to/END/; 
Here is
some multi-line
string
END
```

heredoc 的内容总是从下一行开始，所以你可以（并且应该）标记结束行。

The contents of the heredoc always begin on the next line, so you can (and should) finish the line.

```Raku
my $escaped = my-escaping-function(q:to/TERMINATOR/, language => 'html'); 
Here are the contents of the heredoc.
Potentially multiple lines.
TERMINATOR
```

如果终止符缩进，则从字符串文本中删除该缩进量。所以这个 heredoc

If the terminator is indented, that amount of indention is removed from the string literals. Therefore this heredoc

```Raku
say q:to/END/; 
    Here is
    some multi line
        string
    END
```

输出：

produces this output:

```Raku
Here is
some multi line
    string
```

Heredoc 包括终止符前面的换行符。

Heredocs include the newline from before the terminator.

要允许对变量进行插值，可以使用 `qq` 形式，如果不是已定义变量的标记，则必须转义元字符 `{\` 以及 `$`。例如：

To allow interpolation of variables use the `qq` form, but you will then have to escape metacharacters `{\` as well as `$` if it is not the sigil for a defined variable. For example:

```Raku
my $f = 'db.7.3.8';
my $s = qq:to/END/; 
option \{
    file "$f";
};
END
say $s;
```

输出:

would produce:

```Raku
option {
    file "db.7.3.8";
};
```

你可以在同一行中开始多个 Heredoc。

You can begin multiple Heredocs in the same line.

```Raku
my ($first, $second) = qq:to/END1/, qq:to/END2/; 
  FIRST
  MULTILINE
  STRING
  END1
   SECOND
   MULTILINE
   STRING
   END2 
```

<a id="%E5%8F%8D%E5%BC%95%E6%96%87--unquoting"></a>
## 反引文 / Unquoting

字符串文本允许使用转义序列对嵌入的引文构造进行字符串插值，如下所示：

Literal strings permit interpolation of embedded quoting constructs by using the escape sequences such as these:

```Raku
my $animal="quaggas";
say 'These animals look like \qq[$animal]'; # OUTPUT: «These animals look like quaggas␤» 
say 'These animals are \qqw[$animal or zebras]'; # OUTPUT: «These animals are quaggas or zebras␤»
```

在本例中，`\qq` 将执行双引号字符串插值，`\qqw` 为支持字符串插值的词引文。可以以上述方式转义其他引文构造，允许在字符串文本中进行插值。

In this example, `\qq` will do double-quoting interpolation, and `\qqw` word quoting with interpolation. Escaping any other quoting construct as above will act in the same way, allowing interpolation in literal strings.

<a id="%E6%AD%A3%E5%88%99--regexes"></a>
# 正则 / Regexes

有关引文在正则中应用的信息，请参阅[正则表达式文档](https://docs.raku.org/language/regexes)。

For information about quoting as applied in regexes, see the [regular expression documentation](https://docs.raku.org/language/regexes).
