原文：https://docs.perl6.org/language/regexes

# 正则 / Regexes

与字符串匹配的模式

Pattern matching against strings

正则表达式，简称为 *regexes*，是一组描述文本模式的字符。模式匹配是将这些模式与实际文本匹配的过程。

Regular expressions, *regexes* for short, are a sequence of characters that describe a pattern of text. Pattern matching is the process of matching those patterns to actual text.

# 词法约定 / Lexical conventions

Perl 6 编写正则有特殊的语法：

Perl 6 has special syntax for writing regexes:

```Perl6
m/abc/;         # 对变量 $_ 进行匹配的正则 / a regex that is immediately matched against $_ 
rx/abc/;        # 一个正则对象，允许在正则前面使用副词 / a Regex object; allow adverbs to be used before regex 
/abc/;          # 一个正则对象，'rx/ /' 操作符的简写 / a Regex object; shorthand version of 'rx/ /' operator 
```

前两个例子可以不使用斜杠作为分隔符：

For the first two examples, delimiters other than the slash can be used:

```Perl6
m{abc};
rx{abc};
```

请注意，冒号和圆括号不能作为分隔符；分号与副词冲突，例如 `rx:i/abc/`（大小写不敏感正则），圆括号会被当做函数调用。

Note that neither the colon nor round parentheses can be delimiters; the colon is forbidden because it clashes with adverbs, such as `rx:i/abc/` (case insensitive regexes), and round parentheses indicate a function call instead.

`m/ /` 和 `/ /` 分隔符之间差异的例子：

Example of difference between `m/ /` and `/ /` operators:

```Perl6
my $match;
$_ = "abc";
$match = m/.+/; say $match; say $match.^name; # OUTPUT: «｢abc｣␤Match␤» 
$match =  /.+/; say $match; say $match.^name; # OUTPUT: «/.+/␤Regex␤» 
```

正则里的空格一般是被忽略的（ 除非使用副词 `:s` 或者它的全称 `:sigspace` ）。

Whitespace in regexes is generally ignored (except with the `:s` or, completely, `:sigspace` adverb).

正则表达式里的正则是生效的：

Comments work within a regular expression:

```Perl6
/ word #`(match lexical "word") / 
```

# 字面量 / Literals

正则最简单的情况是匹配一个字符串字面量：

The simplest case for a regex is a match against a string literal:

```Perl6
if 'properly' ~~ / perl / {
    say "'properly' contains 'perl'";
}
```

字母数字和下划线 `_` 按字面值匹配。所有其它字符要么使用反斜线转义(例如, `\:` 匹配一个冒号), 要么用引号引起来:

Alphanumeric characters and the underscore `_` are matched literally. All other characters must either be escaped with a backslash (for example, `\:` to match a colon), or be within quotes:

```Perl6
/ 'two words' /;     # 匹配包括空格的 'two words' / matches 'two words' including the blank 
/ "a:b"       /;     # 匹配包括冒号的 'a:b' / matches 'a:b' including the colon 
/ '#' /;             # 匹配一个井号 / matches a hash character 
```

字符串是从左往右搜索的, 所以如果只有部分字符串匹配正则表达式也足够:

Strings are searched left to right, so it is enough if only part of the string matches the regex:

```Perl6
if 'Life, the Universe and Everything' ~~ / and / {
    say ~$/;            # OUTPUT: «and␤» 
    say $/.prematch;    # OUTPUT: «Life, the Universe ␤» 
    say $/.postmatch;   # OUTPUT: « Everything␤» 
    say $/.from;        # OUTPUT: «19␤» 
    say $/.to;          # OUTPUT: «22␤» 
};
```

匹配结果存储在 `$/` 变量中并且也从匹配中返回。如果匹配成功, 那么返回结果是 [Match](https://docs.perl6.org/type/Match) 类型, 否则它就是 [Nil](https://docs.perl6.org/type/Nil)。

Match results are stored in the `$/` variable and are also returned from the match. The result is of type [Match](https://docs.perl6.org/type/Match) if the match was successful; otherwise it is [Nil](https://docs.perl6.org/type/Nil).

# 通配符 / Wildcards

在正则中未转义的 `.` 匹配任一字符。

An unescaped dot `.` in a regex matches any single character.

所以，这些都匹配：

So, these all match:

```Perl6
'perl' ~~ /per./;       # matches the whole string 
'perl' ~~ / per . /;    # the same; whitespace is ignored 
'perl' ~~ / pe.l /;     # the . matches the r 
'speller' ~~ / pe.l/;   # the . matches the first l 
```

下面这个不匹配：

This doesn't match:

```Perl6
'perl' ~~ /. per /;
```

因为在目标字符串中 `per` 前面没有要匹配的字符。

because there's no character to match before `per` in the target string.

请注意现在 `.` 确实匹配*任一*字符，有就是说，它匹配 `\n`。所以下面的文本是匹配的：

Note that `.` now does match **any** single character, that is, it matches `\n`. So the text below match:

```Perl6
my $text = qq:to/END/ 
  Although I am a
  multi-line text,
  now can be matched
  with /.*/.
  END
  ;
 
say $text ~~ / .* /;
# OUTPUT «｢Although I am a␤multi-line text,␤now can be matched␤with /.*/␤｣» 
```

# 字符类 / Character classes

## 带反斜杠的字符类 / Backslashed character classes

存在类似 `\w` 形式的字符类。其否定为大写形式字符 `\W`。

There are predefined character classes of the form `\w`. Its negation is written with an upper-case letter, `\W`.

### `\n` 和 `\N`

`\n` matches a single, logical newline character. `\N` matches a single character that's not a logical newline.

What is considered as a single newline character is defined via the compile time variable [`$?NL`](https://docs.perl6.org/language/variables#index-entry-%24%3FNL), and the [newline pragma](https://docs.perl6.org/language/pragmas); therefore, `\n` is supposed to be able to match either a Unix-like newline `"\n"`, a Microsoft Windows style one `"\r\n"`, or one in the Mac style `"\r"`.

### `\t` 和 `\T`

`\t` 匹配一个制表符 `U+0009`。`\T` 匹配一个非制表符的字符。

`\t` matches a single tab/tabulation character, `U+0009`. `\T` matches a single character that is not a tab.

注意，像 `U+000B VERTICAL TABULATION` 注意的非主流制表符不包括在这里。

Note that exotic tabs like the `U+000B VERTICAL TABULATION` character are not included here.

### `\h` 和 `\H`

`\h` 匹配一个水平空白符。`\H`匹配一个非水平空白符的字符。

`\h` matches a single horizontal whitespace character. `\H` matches a single character that is not a horizontal whitespace character.

水平空白符的例子有：

Examples for horizontal whitespace characters are

```Perl6
U+0020 SPACE
U+00A0 NO-BREAK SPACE
U+0009 CHARACTER TABULATION
U+2001 EM QUAD
```

像换行符那样的垂直空白符被显式地排除了；他们可以被 `\v` 匹配；`\s` 匹配任何类型的空白符。

Vertical whitespace such as newline characters are explicitly excluded; those can be matched with `\v`; `\s` matches any kind of whitespace.

### `\v` 和 `\V`

`\v` 匹配单个垂直空白符字符。`\V` 匹配非垂直空白符字符。

`\v` matches a single vertical whitespace character. `\V` matches a single character that is not vertical whitespace.

垂直空白符的例子：

Examples for vertical whitespace characters:

```Perl6
U+000A LINE FEED
U+000B VERTICAL TABULATION
U+000C FORM FEED
U+000D CARRIAGE RETURN
U+0085 NEXT LINE
U+2028 LINE SEPARATOR
U+2029 PARAGRAPH SEPARATOR
```

`\s` 匹配任何类型的空白符，不仅仅垂直空白符。

Use `\s` to match any kind of whitespace, not just vertical whitespace.

### `\s` 和 `\S`

`\s` matches a single whitespace character. `\S` matches a single character that is not whitespace.

```Perl6
say $/.prematch if 'Match the first word.' ~~ / \s+ /;
# OUTPUT: «Match␤» 
```

### `\d` 和 `\D`

`\d` 匹配单个数字（Unicode 属性 `N`）而 `\D` 匹配单个非数字的字符。

`\d` matches a single digit (Unicode property `N`) and `\D` matches a single character that is not a digit.

```Perl6
'ab42' ~~ /\d/ and say ~$/;     # OUTPUT: «4␤» 
'ab42' ~~ /\D/ and say ~$/;     # OUTPUT: «a␤» 
```

注意，不仅仅只有阿拉伯数字（通常用于拉丁字母中）匹配 `\d`，还可以是来自其他字母系统的数字。

Note that not only the Arabic digits (commonly used in the Latin alphabet) match `\d`, but also digits from other scripts.

数字例子：

Examples for digits are:

```Perl6
U+0035 5 DIGIT FIVE
U+0BEB ௫ TAMIL DIGIT FIVE
U+0E53 ๓ THAI DIGIT THREE
U+17E5 ៥ KHMER DIGIT FIVE
```

### `\w` 和 `\W`

`\w` 匹配单个单词字符，例如：一个字母（Unicode 类别 L），一个数字或者一个下划线。`\W` 匹配一个非单词字符的字符

`\w` matches a single word character, i.e. a letter (Unicode category L), a digit or an underscore. `\W` matches a single character that is not a word character.

单词字符的例子：

Examples of word characters:

```Perl6
0041 A LATIN CAPITAL LETTER A
0031 1 DIGIT ONE
03B4 δ GREEK SMALL LETTER DELTA
03F3 ϳ GREEK LETTER YOT
0409 Љ CYRILLIC CAPITAL LETTER LJE
```

## 预定义的字符串类 / Predefined character classes

| Class    | Shorthand | Description                                       |
| -------- | --------- | ------------------------------------------------- |
| <alnum>  | \w        | <alpha> plus <digit>                              |
| <alpha>  |           | Alphabetic characters including _                 |
| <blank>  | \h        | Horizontal whitespace                             |
| <cntrl>  |           | Control characters                                |
| <digit>  | \d        | Decimal digits                                    |
| <graph>  |           | <alnum> plus <punct>                              |
| <ident>  |           | Identifier. Also a default rule.                  |
| <lower>  | <:Ll>     | Lowercase characters                              |
| <print>  |           | <graph> plus <space>, but no <cntrl>              |
| <punct>  |           | Punctuation and Symbols (only Punct beyond ASCII) |
| <same>   |           | Matches between two identical characters          |
| <space>  | \s        | Whitespace                                        |
| <upper>  | <:Lu>     | Uppercase characters                              |
| <wb>     |           | Word boundary                                     |
| <ws>     |           | Whitespace. This is actually a default rule.      |
| <ww>     |           | Within word                                       |
| <xdigit> |           | Hexadecimal digit [0-9A-Fa-f]                     |

注意字符类 `<same>`、 `<wb>` 以及 `<ww>` 也称作零长度断言，他们不会真的匹配某个字符。

Note that the character classes `<same>`, `<wb>` and `<ww>` are so called zero-width assertions, which do not really match a character.

## Unicode 属性 / Unicode properties

到目前为止提到的字符类大多是为了方便；另一种方法是使用 Unicode 字符属性。他们是以 `<:property>` 的形式出现，其中 `property` 可以是一个短的或者长的 Unicode 通用类别名。他们使用键值对语法。

The character classes mentioned so far are mostly for convenience; another approach is to use Unicode character properties. These come in the form `<:property>`, where `property` can be a short or long Unicode General Category name. These use pair syntax.

要匹配 Unicode 属性可以使用智能匹配或者 [`uniprop`](https://docs.perl6.org/routine/uniprop)：

To match against a Unicode property you can use either smartmatch or [`uniprop`](https://docs.perl6.org/routine/uniprop):

```Perl6
"a".uniprop('Script');                 # OUTPUT: «Latin␤» 
"a" ~~ / <:Script<Latin>> /;           # OUTPUT: «｢a｣␤» 
"a".uniprop('Block');                  # OUTPUT: «Basic Latin␤» 
"a" ~~ / <:Block('Basic Latin')> /;    # OUTPUT: «｢a｣␤» 
```

下面这些是用作匹配的 Unicode 通用类别：

These are the Unicode general categories used for matching:

| Short | Long                    |
| ----- | ----------------------- |
| C     | Other                   |
| Cc    | Control or cntrl        |
| Cf    | Format                  |
| Cn    | Unassigned              |
| Co    | Private_Use             |
| Cs    | Surrogate               |
| L     | Letter                  |
| LC    | Cased_Letter            |
| Ll    | Lowercase_Letter        |
| Lm    | Modifier_Letter         |
| Lo    | Other_Letter            |
| Lt    | Titlecase_Letter        |
| Lu    | Uppercase_Letter        |
| M     | Mark                    |
| Mc    | Spacing_Mark            |
| Me    | Enclosing_Mark          |
| Mn    | Nonspacing_Mark         |
| N     | Number                  |
| Nd    | Decimal_Number or digit |
| Nl    | Letter_Number           |
| No    | Other_Number            |
| P     | Punctuation or punct    |
| Pc    | Connector_Punctuation   |
| Pd    | Dash_Punctuation        |
| Pe    | Close_Punctuation       |
| Pf    | Final_Punctuation       |
| Pi    | Initial_Punctuation     |
| Po    | Other_Punctuation       |
| Ps    | Open_Punctuation        |
| S     | Symbol                  |
| Sc    | Currency_Symbol         |
| Sk    | Modifier_Symbol         |
| Sm    | Math_Symbol             |
| So    | Other_Symbol            |
| Z     | Separator               |
| Zl    | Line_Separator          |
| Zp    | Paragraph_Separator     |
| Zs    | Space_Separator         |

例如， `<:Lu>` 匹配一个大写字母。

For example, `<:Lu>` matches a single, upper-case letter.

它的对立面格式是 `<:!property>`。因此，`<:!Lu>` 匹配一个不是大写的字母。

Its negation is this: `<:!property>`. So, `<:!Lu>` matches a single character that is not an upper-case letter.

不同类别可以利用中缀运算符一起使用：

Categories can be used together, with an infix operator:

| Operator | Meaning        |
| -------- | -------------- |
| +        | set union      |
| -        | set difference |

匹配一个小写字母或者一个数字，写为 `<:Ll+:N>`、`<:Ll+:Number>` 或者 `<+ :Lowercase_Letter + :Number>`。

To match either a lower-case letter or a number, write `<:Ll+:N>` or `<:Ll+:Number>` or `<+ :Lowercase_Letter + :Number>`.

可以将类别或者类别的子集编组，例如：

It's also possible to group categories and sets of categories with parentheses; for example:

```Perl6
say $0 if 'perl6' ~~ /\w+(<:Ll+:N>)/ # OUTPUT: «｢6｣␤» 
```

## 枚举字符类和范围 / Enumerated character classes and ranges

有时，现有的通配符和字符类是不够的。幸运的是，定义自己的也较简单。你可以在 `<[ ]>` 中放置任意数量的字符和字符范围（在端点之间用两个点表示），可以有空格。

Sometimes the pre-existing wildcards and character classes are not enough. Fortunately, defining your own is fairly simple. Within `<[ ]>`, you can put any number of single characters and ranges of characters (expressed with two dots between the end points), with or without whitespace.

```Perl6
"abacabadabacaba" ~~ / <[ a .. c 1 2 3 ]>* /;
# Unicode hex codepoint range 
"ÀÁÂÃÄÅÆ" ~~ / <[ \x[00C0] .. \x[00C6] ]>* /;
# Unicode named codepoint range 
"αβγ" ~~ /<[\c[GREEK SMALL LETTER ALPHA]..\c[GREEK SMALL LETTER GAMMA]]>*/;
```

在 `< >` 中，你可以使用 `+` 和 `-` 添加或删除多个范围定义，甚至混合在上面的一些 Unicode 类别中。你还可以在 `[ ]` 之间为字符类编写反斜杠形式。

Within the `< >` you can use `+` and `-` to add or remove multiple range definitions and even mix in some of the Unicode categories above. You can also write the backslashed forms for character classes between the `[ ]`.

```Perl6
/ <[\d] - [13579]> /;
# starts with \d and removes odd ASCII digits, but not quite the same as 
/ <[02468]> /;
# because the first one also contains "weird" unicodey digits 
```

你也可以在列表中包含 Unicode 属性：

You can include Unicode properties in the list as well:

```Perl6
/<:Zs + [\x9] - [\xA0]>/
# Any character with "Zs" property, or a tab, but not a newline 
```

你可以使用 `\` 转义正则表达式中有意义的字符：

You can use `\` to escape characters that would have some meaning in the regular expression:

```Perl6
say "[ hey ]" ~~ /<-[ \] \[ \s ]>+/; # OUTPUT: «｢hey｣␤» 
```

否定一个字符类，请在左尖括号后加一个 `-` 号：

To negate a character class, put a `-` after the opening angle bracket:

```Perl6
say 'no quotes' ~~ /  <-[ " ]> + /;  # matches characters except " 
```

分析以引号分隔的字符串的常见模式涉及否定的字符类：

A common pattern for parsing quote-delimited strings involves negated character classes:

```Perl6
say '"in quotes"' ~~ / '"' <-[ " ]> * '"'/;
```

这个正则首先匹配一个引号，然后匹配任何不是引号的字符，然后再匹配一个引号。上述例子中的 `*` 和 `+` 的含义将在下一节的量词中解释。

This regex first matches a quote, then any characters that aren't quotes, and then a quote again. The meaning of `*` and `+` in the examples above are explained in the next section on quantifiers.

正如你可以使用 `-` 来设置单个值的集合差和否定一样，你也可以在前面显式地放一个 `+`：

Just as you can use the `-` for both set difference and negation of a single value, you can also explicitly put a `+` in front:

```Perl6
/ <+[123]> /  # same as <[123]> 
```

# 量词 / Quantifiers

量词使前面的元素匹配可变的次数。例如，`a+` 匹配一个或多个 `a` 字符。

A quantifier makes the preceding atom match a variable number of times. For example, `a+` matches one or more `a` characters.

量词比连接更紧密，因此 `ab+` 匹配一个 `a`，后跟一个或多个 `b`。这与引号括起来的引用不同，`'ab'+` 匹配 `ab`、 `abab` 和 `ababab` 等字符。

Quantifiers bind tighter than concatenation, so `ab+` matches one `a` followed by one or more `b`s. This is different for quotes, so `'ab'+` matches the strings `ab`, `abab`, `ababab` etc.

## 一个或多个: `+` / One or more: `+`

`+` 量词使前面的元素匹配一次或多次，没有上限。

The `+` quantifier makes the preceding atom match one or more times, with no upper limit.

例如，要匹配 `key=value` 字符串的话，你可以这样写正则：

For example, to match strings of the form `key=value`, you can write a regex like this:

```Perl6
/ \w+ '=' \w+ /
```

## 零个或多个: `*` / Zero or more: `*`

`*` 量词使前面的元素匹配零次或者多次，没有上限。

The `*` quantifier makes the preceding atom match zero or more times, with no upper limit.

例如，允许 `a` 和 `b` 之间有可选的空白符，你可以写为：

For example, to allow optional whitespace between `a` and `b` you can write:

```Perl6
/ a \s* b /
```

## 零个或一个: `?` / Zero or one: `?`

`?` 量词使前面的元素匹配量词或者一次。

The `?` quantifier makes the preceding atom match zero or once.

例如，匹配 `dog` 或者 `dogs`，你可以写为：

For example, to match `dog` or `dogs`, you can write:

```Perl6
/ dogs? /
```

## 通用量词: `** min..max` / General quantifier: `** min..max`

要对一个元素进行任意次数的量化，请使用 `**` 量词，该量词在其右侧接受一个 [Int](https://docs.perl6.org/type/Int) 或 [Range](https://docs.perl6.org/type/Range)。如果指定了 [Range](https://docs.perl6.org/type/Range)，则两个端点指定要匹配的最小和最大次数。

To quantify an atom an arbitrary number of times, use the `**` quantifier, which takes a single [Int](https://docs.perl6.org/type/Int) or a [Range](https://docs.perl6.org/type/Range) on the right-hand side that specifies the number of times to match. If [Range](https://docs.perl6.org/type/Range) is specified, the end-points specify the minimum and maximum number of times to match.

```Perl6
say 'abcdefg' ~~ /\w ** 4/;      # OUTPUT: «｢abcd｣␤» 
say 'a'       ~~ /\w **  2..5/;  # OUTPUT: «Nil␤» 
say 'abc'     ~~ /\w **  2..5/;  # OUTPUT: «｢abc｣␤» 
say 'abcdefg' ~~ /\w **  2..5/;  # OUTPUT: «｢abcde｣␤» 
say 'abcdefg' ~~ /\w ** 2^..^5/; # OUTPUT: «｢abcd｣␤» 
say 'abcdefg' ~~ /\w ** ^3/;     # OUTPUT: «｢ab｣␤» 
say 'abcdefg' ~~ /\w ** 1..*/;   # OUTPUT: «｢abcdefg｣␤» 
```

只支持量词右侧的基本字面量语法，以避免与其他正则构造混淆。如果需要使用更复杂的表达式，例如由变量构成的 [Range](https://docs.perl6.org/type/Range)，请将 [Range](https://docs.perl6.org/type/Range) 括在大括号中：

Only basic literal syntax for the right-hand side of the quantifier is supported, to avoid ambiguities with other regex constructs. If you need to use a more complex expression, for example, a [Range](https://docs.perl6.org/type/Range) made from variables, enclose the [Range](https://docs.perl6.org/type/Range) into curly braces:

```Perl6
my $start = 3;
say 'abcdefg' ~~ /\w ** {$start .. $start+2}/; # OUTPUT: «｢abcde｣␤» 
say 'abcdefg' ~~ /\w ** {π.Int}/;              # OUTPUT: «｢abc｣␤» 
```

负数值被当做零：

Negative values are treated like zero:

```Perl6
say 'abcdefg' ~~ /\w ** {-Inf}/;     # OUTPUT: «｢｣␤» 
say 'abcdefg' ~~ /\w ** {-42}/;      # OUTPUT: «｢｣␤» 
say 'abcdefg' ~~ /\w ** {-10..-42}/; # OUTPUT: «｢｣␤» 
say 'abcdefg' ~~ /\w ** {-42..-10}/; # OUTPUT: «｢｣␤» 
```

如果结果值为 `Inf` 或 `NaN`，或结果 [Range](https://docs.perl6.org/type/Range)为空、非数字、包含 `NaN` 终结点或最小有效终结点为 `Inf`，则将引发 `X::Syntax::Regex::QuantifierValue` 异常：

If then, the resultant value is `Inf` or `NaN` or the resultant [Range](https://docs.perl6.org/type/Range) is empty, non-Numeric, contains `NaN` end-points, or has minimum effective end-point as `Inf`, the `X::Syntax::Regex::QuantifierValue` exception will be thrown:

```Perl6
(try say 'abcdefg' ~~ /\w ** {42..10}/  )
    orelse say ($!.^name, $!.empty-range);
    # OUTPUT: «(X::Syntax::Regex::QuantifierValue True)␤» 
(try say 'abcdefg' ~~ /\w ** {Inf..Inf}/)
    orelse say ($!.^name, $!.inf);
    # OUTPUT: «(X::Syntax::Regex::QuantifierValue True)␤» 
(try say 'abcdefg' ~~ /\w ** {NaN..42}/ )
    orelse say ($!.^name, $!.non-numeric-range);
    # OUTPUT: «(X::Syntax::Regex::QuantifierValue True)␤» 
(try say 'abcdefg' ~~ /\w ** {"a".."c"}/)
    orelse say ($!.^name, $!.non-numeric-range);
    # OUTPUT: «(X::Syntax::Regex::QuantifierValue True)␤» 
(try say 'abcdefg' ~~ /\w ** {Inf}/)
    orelse say ($!.^name, $!.inf);
    # OUTPUT: «(X::Syntax::Regex::QuantifierValue True)␤» 
(try say 'abcdefg' ~~ /\w ** {NaN}/)
    orelse say ($!.^name, $!.non-numeric);
    # OUTPUT: «(X::Syntax::Regex::QuantifierValue True)␤» 
```

## 修改过的量词：`%`, `%%` / Modified quantifier: `%`, `%%`

为了更容易地匹配逗号分割那样的值, 你可以在以上任何一个量词后面加上一个 `%` 修饰符以指定某个修饰符必须出现在每一次匹配之间。例如, `a+ % ','` 会匹配 `a` 、`a,a` 或 `a,a,a` 等等。如果还要匹配末尾的分隔符（ `a,` 或者 `a,a,` ）, 那么使用 %% 代替 %。

To more easily match things like comma separated values, you can tack on a `%` modifier to any of the above quantifiers to specify a separator that must occur between each of the matches. For example, `a+ % ','` will match `a` or `a,a` or `a,a,a`, etc. To also match trailing delimiters ( `a,` or `a,a,` ), you can use `%%` instead of `%`.

量词与 `%` 交互，并控制可以成功匹配的总重复次数，因此 `a* % ','` 也与空字符串匹配。如果想要匹配用逗号分隔的词，需要嵌套一个普通量词和一个修改过的量词：

The quantifier interacts with `%` and controls the number of overall repetitions that can match successfully, so `a* % ','` also matches the empty string. If you want match words delimited by commas, you might need to nest an ordinary and a modified quantifier:

```Perl6
say so 'abc,def' ~~ / ^ [\w+] ** 1 % ',' $ /;  # Output: «False» 
say so 'abc,def' ~~ / ^ [\w+] ** 2 % ',' $ /;  # Output: «True» 
```

## 阻止回溯: `:` / Preventing backtracking: `:`

你可以在正则表达式中通过为量词附加一个 `:` 修饰符来阻止回溯:

You can prevent backtracking in regexes by attaching a `:` modifier to the quantifier:

```Perl6
my $str = "ACG GCT ACT An interesting chain";
say $str ~~ /<[ACGT\s]>+ \s+ (<[A..Z a..z \s]>+)/;
# OUTPUT: «｢ACG GCT ACT An interesting chain｣␤ 0 => ｢An interesting chain｣␤» 
say $str ~~ /<[ACGT\s]>+: \s+ (<[A..Z a..z \s]>+)/;
# OUTPUT: «Nil␤» 
```

在第二种情况下，`An` 中的 `A` 已经被正则模式“吸收”，从而阻止了模式第二部分在 `\s+` 之后的匹配。一般来说，我们想要的是相反的：防止回溯来精确匹配我们正在寻找的。

In the second case, the `A` in `An` had already been "absorbed" by the pattern, preventing the matching of the second part of the pattern, after `\s+`. Generally we will want the opposite: prevent backtracking to match precisely what we are looking for.

在大多数情况下，出于效率原因，你会希望防止回溯，例如：

In most cases, you will want to prevent backtracking for efficiency reasons, for instance here:

```Perl6
say $str ~~ m:g/[(<[ACGT]> **: 3) \s*]+ \s+ (<[A..Z a..z \s]>+)/;
# OUTPUT: 
# (｢ACG GCT ACT An interesting chain｣ 
# 0 => ｢ACG｣ 
# 0 => ｢GCT｣ 
# 0 => ｢ACT｣ 
# 1 => ｢An interesting chain｣) 
```

不过，在这种情况下，不使用 `**` 后面的 `:` 效果是一样的。最好创建不会被回溯的 *token*：

Although in this case, eliminating the `:` from behind `**` would make it behave exactly in the same way. The best use is to create *tokens* that will not be backtracked:

```Perl6
$_ = "ACG GCT ACT IDAQT";
say  m:g/[(\w+:) \s*]+ (\w+) $$/;
# OUTPUT: 
# (｢ACG GCT ACT IDAQT｣ 
# 0 => ｢ACG｣ 
# 0 => ｢GCT｣ 
# 0 => ｢ACT｣ 
# 1 => ｢IDAQT｣) 
```

没有 `\w+` 后的 `:` 的话，*ID* 部分的捕获就只剩下 `T` 了，因为正则模式会往前匹配所有的东西，留下一个字母来匹配行末的 `\w+` 表达式。

Without the `:` following `\w+`, the *ID* part captured would have been simply `T`, since the pattern would go ahead and match everything, leaving a single letter to match the `\w+` expression at the end of the line.

## 贪婪与节俭量词： `?` / Greedy versus frugal quantifiers: `?`

默认情况下，量词是贪婪的：

By default, quantifiers request a greedy match:

```Perl6
'abababa' ~~ /a .* a/ && say ~$/;   # OUTPUT: «abababa␤» 
```

量词后接 `?` 开启节俭匹配：

You can attach a `?` modifier to the quantifier to enable frugal matching:

```Perl6
'abababa' ~~ /a .*? a/ && say ~$/;   # OUTPUT: «aba␤» 
```

也可以用在通用量词上开启节俭匹配：

You can also enable frugal matching for general quantifiers:

```Perl6
say '/foo/o/bar/' ~~ /\/.**?{1..10}\//;  # OUTPUT: «｢/foo/｣␤» 
say '/foo/o/bar/' ~~ /\/.**!{1..10}\//;  # OUTPUT: «｢/foo/o/bar/｣␤» 
```

显式开启贪婪匹配可以在量词后使用 `!`。

Greedy matching can be explicitly requested with the `!` modifier.

# 备选项: `||` / Alternation: `||`

匹配多个可能的备选项中的一个，将他们用 `||` 分隔；第一个匹配上的备选项胜出。

To match one of several possible alternatives, separate them by `||`; the first matching alternative wins.

例如，`ini` 文件有如下形式：

For example, `ini` files have the following form:

```Perl6
[section]
key = value
```

因此，如果你分析一行 `ini` 文件，它可能是一个章节名或者键值对，其正则可能是（近似地）：

Hence, if you parse a single line of an `ini` file, it can be either a section or a key-value pair and the regex would be (to a first approximation):

```Perl6
/ '[' \w+ ']' || \S+ \s* '=' \s* \S* /
```

也就是说，要么是由方括号包围的单词，要么是由非空格字符组成的字符串，后面是零个或多个空格，后面是等号 `=`，后面是可选空格，后面是另一个非空格字符字符串。

That is, either a word surrounded by square brackets, or a string of non-whitespace characters, followed by zero or more spaces, followed by the equals sign `=`, followed again by optional whitespace, followed by another string of non-whitespace characters.

作为第一个分支的空字符串将忽略，以允许你一致地格式化分支。你可以将前面的示例编写为

An empty string as the first branch is ignored, to allow you to format branches consistently. You could have written the previous example as

```Perl6
/
|| '[' \w+ ']'
|| \S+ \s* '=' \s* \S*
/
```

即使在非回溯语境下，备选项操作符 `||` 会按顺序尝试所有的分支直到找到第一个匹配的。

Even in non-backtracking contexts, the alternation operator `||` tries all the branches in order until the first one matches.

# 最长的备选项： `|` / Longest alternation: `|`

简而言之，在用 `|` 分隔的正则分支中，最长的 token 匹配获胜，与正则中的文本顺序无关。然而，`|` 真正做的不止这些。它不决定哪个分支在完成整个匹配后获胜，而是遵循[最长令牌匹配（LTM）策略](https://design.perl6.org/S05.html#Longest-token_matching)。

In short, in regex branches separated by `|`, the longest token match wins, independent of the textual ordering in the regex. However, what `|` really does is more than that. It does not decide which branch wins after finishing the whole match, but follows the [longest-token matching (LTM) strategy](https://design.perl6.org/S05.html#Longest-token_matching).

简言之，`|` 的作用是：

Briefly, what `|` does is this:

-首先，选择具有最长声明性前缀的分支。

- First, select the branch which has the longest declarative prefix.

```Perl6
say "abc" ~~ /ab | a.* /;                 # Output: ⌜abc⌟ 
say "abc" ~~ /ab | a {} .* /;             # Output: ⌜ab⌟ 
say "if else" ~~ / if | if <.ws> else /;  # Output: ｢if｣ 
say "if else" ~~ / if | if \s+   else /;  # Output: ｢if else｣ 
```

如上所示，`a.*` 是声明性前缀，而 `a {} .*` 以 `{}` 结尾，则其声明性前缀为 `a`。注意，非声明性元素终止声明性前缀。如果要在 `rule` 中应用 `|`，这一点非常重要，它会自动启用 `:s`，并且 `<.ws>` 意外终止声明性前缀。

As is shown above, `a.*` is a declarative prefix, while `a {} .*` terminates at `{}`, then its declarative prefix is `a`. Note that non-declarative atoms terminate declarative prefix. This is quite important if you want to apply `|` in a `rule`, which automatically enables `:s`, and `<.ws>` accidentally terminates declarative prefix.

-如果是平局，选择具有最高精度的匹配。

- If it's a tie, select the match with the highest specificity.

```Perl6
say "abc" ~~ /a. | ab { print "win" } /;  # Output: win｢ab｣ 
```

当两个备选方案在同一长度上匹配时，平局由精度来打破。也就是说，`ab` 作为一个精确的匹配，比使用字符类的 `a.` 更好。

When two alternatives match at the same length, the tie is broken by specificity. That is, `ab`, as an exact match, counts as closer than `a.`, which uses character classes.

-如果仍然是平局，使用额外的平局打破者。

- If it's still a tie, use additional tie-breakers.

```Perl6
say "abc" ~~ /a\w| a. { print "lose" } /; # Output: ⌜ab⌟ 
```

如果上面的破局者不起作用，那么文本上较早的选项优先。

If the tie breaker above doesn't work, then the textually earlier alternative takes precedence.

更多细节，见 [LTM 策略](https://design.perl6.org/S05.html#Longest-token_matching)。

For more details, see [the LTM strategy](https://design.perl6.org/S05.html#Longest-token_matching).

## 引用的列表是 LTM 匹配项 / Quoted lists are LTM matches

在正则中使用引用列表等同于指定列表元素的最长匹配备选项。因此，以下匹配：

Using a quoted list in a regex is equivalent to specifying the longest-match alternation of the list's elements. So, the following match:

```Perl6
say 'food' ~~ /< f fo foo food >/;      # OUTPUT: «｢food｣␤» 
```

等同于：

is equivalent to:

```Perl6
say 'food' ~~ / f | fo | foo | food /;  # OUTPUT: «｢food｣␤» 
```

注意，第一个 `<` 后面的空格在这里很重要： 无空格的 `<food>` 意为调用命名 rule `food` 而 `< food >` 和 `< food>` 是引用列表，包含一个元素 `'food'`。

Note that the space after the first `<` is significant here: `<food>` calls the named rule `food` while `< food >` and `< food>` specify quoted lists with a single element, `'food'`.

作为第一个分支的空字符串将忽略，以允许你一致地格式化分支：

If the first branch is an empty string, it is ignored. This allows you to format your regexes consistently:

```Perl6
/
| f
| fo
| foo
| food
/
```

数组也可以插入到正则中以达到相同的效果：

Arrays can also be interpolated into a regex to achieve the same effect:

```Perl6
my @increasingly-edible = <f fo foo food>;
say 'food' ~~ /@increasingly-edible/;   # OUTPUT: «｢food｣␤» 
```

这在下面的[正则插值](https://docs.perl6.org/language/regexes#Regex_interpolation)中有进一步的记录。

This is documented further under [Regex Interpolation](https://docs.perl6.org/language/regexes#Regex_interpolation), below.

# 连接： `&&` / Conjunction: `&&`

如果所有以 `&&` 分隔的段与目标字符串的相同子字符串匹配，则成功匹配。这些段从左到右进行计算。

Matches successfully if all `&&`-delimited segments match the same substring of the target string. The segments are evaluated left to right.

这对于扩充现有的正则很有用。例如，如果有一个与带引号的字符串匹配的 regex `quoted`，则 `/ <quoted> && <-[x]>* /` 与不包含字符 `x` 的带引号的字符串匹配。

This can be useful for augmenting an existing regex. For example if you have a regex `quoted` that matches a quoted string, then `/ <quoted> && <-[x]>* /` matches a quoted string that does not contain the character `x`.

注意，对于不消费字符的 lookahead 正则，你不能轻易获得相同的行为。 因为当引用的字符串停止匹配时，lookahead 不会停止查找。

Note that you cannot easily obtain the same behavior with a lookahead, that is, a regex doesn't consume characters, because a lookahead doesn't stop looking when the quoted string stops matching.

```Perl6
say 'abc' ~~ / <?before a> && . /;    # OUTPUT: «Nil␤» 
say 'abc' ~~ / <?before a> . && . /;  # OUTPUT: «｢a｣␤» 
say 'abc' ~~ / <?before a> . /;       # OUTPUT: «｢a｣␤» 
say 'abc' ~~ / <?before a> .. /;      # OUTPUT: «｢ab｣␤» 
```

与 `||` 类似，第一个空分支会被忽略。

Just like with `||`, empty first branches are ignored.

# 连接： `&` / Conjunction: `&`

就像正则中的 `&&`，如果所有以 `&` 分隔的段与目标字符串的同一部分匹配，则成功匹配。

Much like `&&` in a regex, it matches successfully if all segments separated by `&` match the same part of the target string.

`&`（与 `&&` 不同）被认为是声明性的，并且理论上所有的段都可以并行计算，或者按照编译器选择的任何顺序计算。

`&` (unlike `&&`) is considered declarative, and notionally all the segments can be evaluated in parallel, or in any order the compiler chooses.

就像 `||` 和 `&`，第一个分支为空的话会被忽略。

Just like with `||` and `&`, empty first branches are ignored.

# 定位符 / Anchors

正则表达式在整个字符串中搜索匹配项。有时候这不是你想要的。定位符只在字符串中的特定位置匹配，因此将正则匹配定位到该位置。

Regexes search an entire string for matches. Sometimes this is not what you want. Anchors match only at certain positions in the string, thereby anchoring the regex match to that position.

## 字符串开始和结束 / Start of string and end of string

`^` 定位符只匹配字符串的开头：

The `^` anchor only matches at the start of the string:

```Perl6
say so 'properly' ~~ /  perl/;    # OUTPUT: «True␤» 
say so 'properly' ~~ /^ perl/;    # OUTPUT: «False␤» 
say so 'perly'    ~~ /^ perl/;    # OUTPUT: «True␤» 
say so 'perl'     ~~ /^ perl/;    # OUTPUT: «True␤» 
```

`$` 定位符只匹配字符串的结尾：

The `$` anchor only matches at the end of the string:

```Perl6
say so 'use perl' ~~ /  perl  /;   # OUTPUT: «True␤» 
say so 'use perl' ~~ /  perl $/;   # OUTPUT: «True␤» 
say so 'perly'    ~~ /  perl $/;   # OUTPUT: «False␤» 
```

你可以组合两个定位符：

You can combine both anchors:

```Perl6
say so 'use perl' ~~ /^ perl $/;   # OUTPUT: «False␤» 
say so 'perl'     ~~ /^ perl $/;   # OUTPUT: «True␤» 
```

请记住，`^` 匹配**字符串**的开头，而不是**行**的开头。同样，`$` 匹配**字符串**的结尾，而不是**行**的结尾。

Keep in mind that `^` matches the start of a **string**, not the start of a **line**. Likewise, `$` matches the end of a **string**, not the end of a **line**.

以下是多行字符串：

The following is a multi-line string:

```Perl6
my $str = chomp q:to/EOS/; 
   Keep it secret
   and keep it safe
   EOS
 
# 'safe' is at the end of the string 
say so $str ~~ /safe   $/;   # OUTPUT: «True␤» 
 
# 'secret' is at the end of a line, not the string 
say so $str ~~ /secret $/;   # OUTPUT: «False␤» 

# 'Keep' is at the start of the string 
say so $str ~~ /^Keep   /;   # OUTPUT: «True␤» 

# 'and' is at the start of a line -- not the string 
say so $str ~~ /^and    /;   # OUTPUT: «False␤» 
```

## 行开始和结束 / Start of line and end of line

`^^` 定位符在逻辑行的开头匹配。也就是说，要么在字符串的开头，要么在换行符之后。但是，它在字符串末尾不匹配，即使它以换行符结尾。 

The `^^` anchor matches at the start of a logical line. That is, either at the start of the string, or after a newline character. However, it does not match at the end of the string, even if it ends with a newline character.

`$$` 定位符与逻辑行的末尾匹配。也就是说，在换行符之前，或者在最后一个字符不是换行符的字符串末尾。

The `$$` anchor matches at the end of a logical line. That is, before a newline character, or at the end of the string when the last character is not a newline character.

要理解下面的示例，重要的是要知道 `q:to/EOS/...EOS` [heredoc](https://docs.perl6.org/language/quoting#Heredocs%3A_%3Ato) 语法将前导缩进删除到与 `EOS` 标记相同的级别，以便第一行、第二行和最后一行没有前导空格，并且第三行和第四行各有两个前导空格。

To understand the following example, it's important to know that the `q:to/EOS/...EOS` [heredoc](https://docs.perl6.org/language/quoting#Heredocs%3A_%3Ato) syntax removes leading indention to the same level as the `EOS` marker, so that the first, second and last lines have no leading space and the third and fourth lines have two leading spaces each.

```Perl6
my $str = q:to/EOS/; 
    There was a young man of Japan
    Whose limericks never would scan.
      When asked why this was,
      He replied "It's because I always try to fit
    as many syllables into the last line as ever I possibly can."
    EOS
 
# 'There' is at the start of string 
say so $str ~~ /^^ There/;        # OUTPUT: «True␤» 
 
# 'limericks' is not at the start of a line 
say so $str ~~ /^^ limericks/;    # OUTPUT: «False␤» 
 
# 'as' is at start of the last line 
say so $str ~~ /^^ as/;            # OUTPUT: «True␤» 
 
# there are blanks between start of line and the "When" 
say so $str ~~ /^^ When/;         # OUTPUT: «False␤» 
 
# 'Japan' is at end of first line 
say so $str ~~ / Japan $$/;       # OUTPUT: «True␤» 
 
# there's a . between "scan" and the end of line 
say so $str ~~ / scan $$/;        # OUTPUT: «False␤» 
 
# matched at the last line 
say so $str ~~ / '."' $$/;        # OUTPUT: «True␤» 
```

## 词边界 / Word boundary

要匹配任何单词边界，请使用 `<|w>` 或 `<?wb>` 这在其他语言中类似于 `\b`。要匹配相反的字符，任何不绑定单词的字符，请使用 `<!|w>` 或 `<!wb>`。这在其他语言中类似于 `\B`。

To match any word boundary, use `<|w>` or `<?wb>`. This is similar to `\b` in other languages. To match the opposite, any character that is not bounding a word, use `<!|w>` or `<!wb>`. This is similar to `\B` in other languages.

这些都是零宽度正则元素。

These are both zero-width regex elements.

```Perl6
say "two-words" ~~ / two<|w>\-<|w>words /;    # OUTPUT: «｢two-words｣␤» 
say "twowords" ~~ / two<!|w><!|w>words /;     # OUTPUT: «｢twowords｣» 
```

## 左右词边界 / Left and right word boundary

`<<` 匹配左侧的词边界。它匹配左边的一个非单词字符，或者字符串开头，右边有一个单词字符的位置。

`<<` matches a left word boundary. It matches positions where there is a non-word character at the left, or the start of the string, and a word character to the right.

`>>` 匹配右侧的词边界。它匹配左边有一个字字符，右边有一个非字字符，或者字符串末尾的位置。

`>>` matches a right word boundary. It matches positions where there is a word character at the left and a non-word character at the right, or the end of the string.

这些都是零宽度正则元素。

These are both zero-width regex elements.

```Perl6
my $str = 'The quick brown fox';
say so ' ' ~~ /\W/;               # OUTPUT: «True␤» 
say so $str ~~ /br/;              # OUTPUT: «True␤» 
say so $str ~~ /<< br/;           # OUTPUT: «True␤» 
say so $str ~~ /br >>/;           # OUTPUT: «False␤» 
say so $str ~~ /own/;             # OUTPUT: «True␤» 
say so $str ~~ /<< own/;          # OUTPUT: «False␤» 
say so $str ~~ /own >>/;          # OUTPUT: «True␤» 
say so $str ~~ /<< The/;          # OUTPUT: «True␤» 
say so $str ~~ /fox >>/;          # OUTPUT: «True␤» 
```

你还可以使用变体 `«` 和 `»`：

You can also use the variants `«` and `»` :

```Perl6
my $str = 'The quick brown fox';
say so $str ~~ /« own/;          # OUTPUT: «False␤» 
say so $str ~~ /own »/;          # OUTPUT: «True␤» 
```

来看下 `<|w>` 和 `«`，`»`之间的区别：

To see the difference between `<|w>` and `«`, `»`:

```Perl6
say "stuff here!!!".subst(:g, />>/, '|');   # OUTPUT: «stuff| here|!!!␤» 
say "stuff here!!!".subst(:g, /<</, '|');   # OUTPUT: «|stuff |here!!!␤» 
say "stuff here!!!".subst(:g, /<|w>/, '|'); # OUTPUT: «|stuff| |here|!!!␤» 
```

## 定位符概述 / Summary of anchors

定位符是零宽度正则元素。因此，它们不使用输入字符串的字符，也就是说，正则引擎尝试匹配的当前位置不会前进。一个好的心理模型是，它们匹配的位置在字符串的两个字符之间，或者在输入字符串的第一个字符之前，或者在最后一个字符之后。

Anchors are zero-width regex elements. Hence they do not use up a character of the input string, that is, they do not advance the current position at which the regex engine tries to match. A good mental model is that they match between two characters of an input string, or before the first, or after the last character of an input string.

| Anchor  | Description         | Examples             |
| ------- | ------------------- | -------------------- |
| $       | End of string       | "two\nlines⏏"        |
| $$      | End of line         | "two⏏\nlines⏏"       |
| <!wb>   | Not a word boundary | "t⏏w⏏o w⏏o⏏r⏏d⏏s~⏏!" |
| <!ww>   | Not within word     | "⏏two⏏ ⏏words⏏~⏏!⏏"  |
| << or « | Left word boundary  | "⏏two ⏏words"        |
| <?wb>   | Any word boundary   | "⏏two⏏ ⏏words⏏~!"    |
| <?ww>   | Within word         | "t⏏w⏏o w⏏o⏏r⏏d⏏s~!"  |
| >> or » | Right word boundary | "two⏏ words⏏"        |
| ^       | Start of string     | "⏏two\nlines"        |
| ^^      | Start of line       | "⏏two\n⏏lines"       |

# 零宽度断言 / Zero-width assertions

 零宽度断言可以帮助你实施自己的定位符。

Zero-Width Assertions can help you implement your own anchor.

零宽度断言将另一个正则转换为定位符，使它们不消耗输入字符串的字符。有两种变体：向前看和向后看断言。

A zero-width assertion turns another regex into an anchor, making them consume no characters of the input string. There are two variants: lookahead and lookbehind assertions.

从技术上讲，定位符也是零宽度断言，它们既可以向前看，也可以向后看。

Technically, anchors are also zero-width assertions, and they can look both ahead and behind.

## 向前看断言 / Lookahead assertions

要检查某个模式是否出现在另一个模式之前，请通过 `before` 断言使用向前看断言。其形式如下：

To check that a pattern appears before another pattern, use a lookahead assertion via the `before` assertion. This has the form:

```Perl6
<?before pattern>
```

因此，要搜索字符串 `foo`（紧跟字符串 `bar`），请使用以下正则：

Thus, to search for the string `foo` which is immediately followed by the string `bar`, use the following regexp:

```Perl6
/ foo <?before bar> /
```

例如：

For example:

```Perl6
say "foobar" ~~ / foo <?before bar> /;  # OUTPUT: «foo␤» 
```

但是，如果你想寻找一个模式**不是**立即跟随某个模式，那么你需要使用向前看断言的否定，格式是：

However, if you want to search for a pattern which is **not** immediately followed by some pattern, then you need to use a negative lookahead assertion, this has the form:

```Perl6
<!before pattern>
```

在下面的示例中，所有不在 `bar` 之前出现的 `foo` 将匹配：

In the following example, all occurrences of `foo` which is not before `bar` would match with

```Perl6
say "foobaz" ~~ / foo <!before bar> /;  # OUTPUT: «foo␤» 
```

向前看断言也可以用于其他模式，如字符范围、内插变量、下标等。在这种情况下，使用 `？` 或者 `！` 对于否定形式就够用了。例如，以下各行产生的结果完全相同：

Lookahead assertions can be used also with other patterns, like characters ranges, interpolated variables, subscripts and so on. In such cases it does suffice to use a `?`, or a `!` for the negate form. For instance, the following lines all produce the very same result:

```Perl6
say 'abcdefg' ~~ rx{ abc <?before def> };        # OUTPUT: ｢abc｣ 
say 'abcdefg' ~~ rx{ abc <?[ d..f ]> };          # OUTPUT: ｢abc｣ 
my @ending_letters = <d e f>;
say 'abcdefg' ~~ rx{ abc <?@ending_letters> };   # OUTPUT: ｢abc｣ 
```

向前看断言的一个实际用途是在替换中，在你只希望替换特定上下文中的正则匹配项时。例如，你可能只想替换后面跟着单位的数字（如 *kg*），而不替换其他数字：

A practical use of lookahead assertions is in substitutions, where you only want to substitute regex matches that are in a certain context. For example, you might want to substitute only numbers that are followed by a unit (like *kg*), but not other numbers:

```Perl6
my @units = <kg m km mm s h>;
$_ = "Please buy 2 packs of sugar, 1 kg each";
s:g[\d+ <?before \s* @units>] = 5 * $/;
say $_;         # OUTPUT: Please buy 2 packs of sugar, 5 kg each 
```

因为向前看断言不是匹配对象的一部分，所以单位没有被替换。

Since the lookahead is not part of the match object, the unit is not substituted.

## 向后看断言 / Lookbehind assertions

要检查模式是否出现在另一个模式之后，请通过 `after` 断言使用向后看断言。其格式如下：

To check that a pattern appears after another pattern, use a lookbehind assertion via the `after` assertion. This has the form:

```Perl6
<?after pattern>
```

因此，搜索在字符串 `foo` 之后的 `bar` 字符串，使用如下正则：

Therefore, to search for the string `bar` immediately preceded by the string `foo`, use the following regexp:

```Perl6
/ <?after foo> bar /
```

例如：

For example:

```Perl6
say "foobar" ~~ / <?after foo> bar /;   # OUTPUT: «bar␤» 
```

但是，如果你想寻找一个模式，而这个模式**不是**在某个模式之后的，那么你就需要使用向后看断言的否定，格式是：

However, if you want to search for a pattern which is **not** immediately preceded by some pattern, then you need to use a negative lookbehind assertion, this has the form:

```Perl6
<!after pattern>
```

因此，下列正则匹配所有在其后没有 `foo` 字符串的 `bar`。

Hence all occurrences of `bar` which do not have `foo` before them would be matched by

```Perl6
say "fotbar" ~~ / <!after foo> bar /;    # OUTPUT: «bar␤» 
```

与向前看的情况一样，零宽度断言不*消耗*字符，如下所示：

These are, as in the case of lookahead, zero-width assertions which do not *consume* characters, like here:

```Perl6
say "atfoobar" ~~ / (.**3) .**2 <?after foo> bar /;
# OUTPUT: «｢atfoobar｣␤ 0 => ｢atf｣␤» 
```

在这里，我们捕获 `bar` 前 5 个字符中的前 3 个，但前提是 `bar` 前面有 `foo`。断言为零宽度的事实允许我们使用断言中的部分字符进行捕获。

where we capture the first 3 of the 5 characters before bar, but only if `bar` is preceded by `foo`. The fact that the assertion is zero-width allows us to use part of the characters in the assertion for capture.

# 分组与捕获 / Grouping and capturing

在常规（非正则）Perl 6 中，可以使用括号将事物分组在一起，通常是为了覆盖运算符优先级：

In regular (non-regex) Perl 6, you can use parentheses to group things together, usually to override operator precedence:

```Perl6
say 1 + 4 * 2;     # OUTPUT: «9␤», parsed as 1 + (4 * 2) 
say (1 + 4) * 2;   # OUTPUT: «10␤» 
```

在正则中也有同样的分组功能：

The same grouping facility is available in regexes:

```Perl6
/ a || b c /;      # matches 'a' or 'bc' 
/ ( a || b ) c /;  # matches 'ac' or 'bc' 
```

同样的分组也适用于量词：

The same grouping applies to quantifiers:

```Perl6
/ a b+ /;          # matches an 'a' followed by one or more 'b's 
/ (a b)+ /;        # matches one or more sequences of 'ab' 
/ (a || b)+ /;     # matches a string of 'a's and 'b's, except empty string 
```

未量化的捕获生成一个 [Match](https://docs.perl6.org/type/Match) 对象。当捕获被量化时（除了用 `？` 量词）捕获变为 [Match](https://docs.perl6.org/type/Match) 对象的列表。

An unquantified capture produces a [Match](https://docs.perl6.org/type/Match) object. When a capture is quantified (except with the `?` quantifier) the capture becomes a list of [Match](https://docs.perl6.org/type/Match) objects instead.

## 捕获 / Capturing

圆括号不只是分组，它们还*捕获*；也就是说，它们使组内匹配的字符串可用作变量，也可用作结果 [Match](https://docs.perl6.org/type/Match) 对象的元素：

The round parentheses don't just group, they also *capture*; that is, they make the string matched within the group available as a variable, and also as an element of the resulting [Match](https://docs.perl6.org/type/Match) object:

```Perl6
my $str =  'number 42';
if $str ~~ /'number ' (\d+) / {
    say "The number is $0";         # OUTPUT: The number is 42 
    # or 
    say "The number is $/[0]";      # OUTPUT: The number is 42 
}
```

括号对从左到右编号，从零开始。

Pairs of parentheses are numbered left to right, starting from zero.

```Perl6
if 'abc' ~~ /(a) b (c)/ {
    say "0: $0; 1: $1";             # OUTPUT: «0: a; 1: c␤» 
}
```

`$0` 和 `$1` 等语法是简略的表达形式。通过将匹配对象 `$/` 用作列表，这些捕获可以使用 `$/` 得到，因此 `$0` 实际上是 `$/[0]` 的语法糖。

The `$0` and `$1` etc. syntax is shorthand. These captures are canonically available from the match object `$/` by using it as a list, so `$0` is actually syntactic sugar for `$/[0]`.

将匹配对象强制为列表提供了以编程方式访问所有元素的简单方法：

Coercing the match object to a list gives an easy way to programmatically access all elements:

```Perl6
if 'abc' ~~ /(a) b (c)/ {
    say $/.list.join: ', '  # OUTPUT: «a, c␤» 
}
```

## 非捕获分组 / Non-capturing grouping

正则中的括号执行双重角色：它们将正则元素分组在内部，并捕获与内部子正则匹配的元素。

The parentheses in regexes perform a double role: they group the regex elements inside and they capture what is matched by the sub-regex inside.

要仅获取分组行为，可以使用方括号 `[ ... ]`。 默认情况下，它不会捕获。

To get only the grouping behavior, you can use square brackets `[ ... ]` which, by default, don't capture.

```Perl6
if 'abc' ~~ / [a||b] (c) / {
    say ~$0;                # OUTPUT: «c␤» 
}
```

如果不需要捕获，请使用非捕获 `[ ... ]` 分组，使用它的好处是：

If you do not need the captures, using non-capturing `[ ... ]` groups provides the following benefits:

- 它们更清楚地传达了正则的意图;
- 它们使计算捕获组变得更容易;
- 它们使匹配变得快一点.

- they more cleanly communicate the regex intent;
- they make it easier to count the capturing groups that do mean;
- they make matching a bit faster.

## 匹配数 / Capture numbers

如上所述，捕获从左到右进行编号。虽然原则上是正确的，但这也过于简单化了。

It is stated above that captures are numbered from left to right. While true in principle, this is also over simplification.

为了完整起见，列出了以下规则。当你发现自己经常使用它们时，应该考虑使用命名捕获（可能还有子规则）。

The following rules are listed for the sake of completeness. When you find yourself using them regularly, it's worth considering named captures (and possibly subrules) instead.

备选项重置捕获计数：

Alternations reset the capture count:

```Perl6
/ (x) (y)  || (a) (.) (.) /
# $0  $1      $0  $1  $2 
```

例子：

Example:

```Perl6
if 'abc' ~~ /(x)(y) || (a)(.)(.)/ {
    say ~$1;        # OUTPUT: «b␤» 
}
```

如果两个或更多备选项有不同数量的捕获，捕获数最多的备选项决定下一个捕获的索引：

If two (or more) alternations have a different number of captures, the one with the most captures determines the index of the next capture:

```Perl6
if 'abcd' ~~ / a [ b (.) || (x) (y) ] (.) / {
    #                 $0     $0  $1    $2 
    say ~$2;            # OUTPUT: «d␤» 
}
```

捕获可以嵌套，在这种情况下，它们是按级别编号的；级别 0 将使用捕获变量，但它将成为一个列表，其余级别将作为该列表的元素。

Captures can be nested, in which case they are numbered per level; level 0 gets to use the capture variables, but it will become a list with the rest of the levels behaving as elements of that list

```Perl6
if 'abc' ~~ / ( a (.) (.) ) / {
    say "Outer: $0";                # OUTPUT: Outer: abc 
    say "Inner: $0[0] and $0[1]";   # OUTPUT: Inner: b and c 
}
```

如果需要从另一个捕获中引用捕获，请首先将其存储在变量中：

If you need to refer to a capture from within another capture, store it in a variable first:

这些捕获变量仅在正则之外可用。

These capture variables are only available outside the regex.

```Perl6
# ！！错误！！ $0 指的是第二个捕获*里面*的捕获
# !!WRONG!! The $0 refers to a capture *inside* the second capture 
say "11" ~~ /(\d) ($0)/; # OUTPUT: «Nil␤» 
```

为了使它们在正则中可用，需要在匹配项后面插入一个代码块；如果没有任何有意义的操作，则此代码块可能为空：

In order to make them available inside the regex, you need to insert a code block behind the match; this code block may be empty if there's nothing meaningful to do:

```Perl6
# 正确： $0 存入了第二个捕获之外的变量中，在它被使用在第二个捕获里面之前
# CORRECT: $0 is saved into a variable outside the second capture 
# before it is used inside
say "11" ~~ /(\d) {} :my $c = $0; ($c)/; # OUTPUT: «｢11｣␤ 0 => ｢1｣␤ 1 => ｢1｣␤» 
say "Matched $c"; # OUTPUT: «␤Matched 1␤» 
```

此代码块发布正则内的捕获，以便将其分配给其他变量或用于后续匹配

This code block publishes the capture inside the regex, so that it can be assigned to other variables or used for subsequent matches

```Perl6
say "11" ~~ /(\d) {} $0/; # OUTPUT: «｢11｣␤ 0 => ｢1｣␤» 
```

`:my` 使 `$c` 变量确定在正则之内以及正则所在的范围。在这种情况下，我们可以在下一句话中使用它来显示正则中匹配的内容。这可用于在正则表达式内部进行调试，例如：

`:my` helps scoping the `$c` variable within the regex and beyond; in this case we can use it in the next sentence to show what has been matched inside the regex. This can be used for debugging inside regular expressions, for instance:

```Perl6
my $paragraph="line\nline2\nline3";
$paragraph ~~ rx| :my $counter = 0; ( \V* { ++$counter } ) *%% \n |;
say "Matched $counter lines"; # OUTPUT: «Matched 3 lines␤» 
```

由于 `:my` 代码块只是声明，因此匹配项变量 `$/` 或编号的匹配项（如 `$0`）在它们中不可用，除非它们以前是通过插入空代码块（或任何代码块）发布的：

Since `:my` blocks are simply declarations, the match variable `$/` or numbered matches such as `$0` will not be available in them unless they are previously published by inserting the empty block (or any block):

```Perl6
"aba" ~~ / (a) b {} :my $c = $/; /;
say $c; # OUTPUT: «｢ab｣␤ 0 => ｢a｣␤» 
```

任何其他代码块也将显示变量并使其在声明中可用：

Any other code block will also reveal the variables and make them available in declarations:

```Perl6
"aba" ~~ / (a) {say "Check so far ", ~$/} b :my $c = ~$0; /;
# OUTPUT: «Check so far a␤» 
say "Capture $c"; # OUTPUT: «Capture a␤» 
```

与类中的 [`our`](https://docs.perl6.org/syntax/our) 类似，`:our` 可用于 [Grammar](https://docs.perl6.org/type/Grammar) 中声明可通过其完全限定名从 grammar 外部访问的变量：

The `:our`, similarly to [`our`](https://docs.perl6.org/syntax/our) in classes, can be used in [Grammar](https://docs.perl6.org/type/Grammar)s to declare variables that can be accessed, via its fully qualified name, from outside the grammar:

```Perl6
grammar HasOur {
    token TOP {
        :our $our = 'Þor';
        $our \s+ is \s+ mighty
    }
}
 
say HasOur.parse('Þor is mighty'); # OUTPUT: «｢Þor is mighty｣␤» 
say $HasOur::our;                  # OUTPUT: «Þor␤» 
```

解析成功后，我们使用变量 `$our` 的完全限定名称来访问其值，该值只能是 `Þor`。

Once the parsing has been done successfully, we use the FQN name of the `$our` variable to access its value, that can be none other than `Þor`.

## 命名捕获 / Named captures

Instead of numbering captures, you can also give them names. The generic, and slightly verbose, way of naming captures is like this:

```Perl6
if 'abc' ~~ / $<myname> = [ \w+ ] / {
    say ~$<myname>      # OUTPUT: «abc␤» 
}
```

The square brackets in the above example, which don't usually capture, will now capture its grouping with the given name.

The access to the named capture, `$<myname>`, is a shorthand for indexing the match object as a hash, in other words: `$/{ 'myname' }` or `$/<myname>`.

We can also use parentheses in the above example, but they will work exactly the same as square brackets. The captured group will only be accessible by its name as a key from the match object and not from its position in the list with `$/[0]` or `$0`.

Named captures can also be nested using regular capture group syntax:

```Perl6
if 'abc-abc-abc' ~~ / $<string>=( [ $<part>=[abc] ]* % '-' ) / {
    say ~$<string>;          # OUTPUT: «abc-abc-abc␤» 
    say ~$<string><part>;    # OUTPUT: «abc abc abc␤» 
    say ~$<string><part>[0]; # OUTPUT: «abc␤» 
}
```

Coercing the match object to a hash gives you easy programmatic access to all named captures:

```Perl6
if 'count=23' ~~ / $<variable>=\w+ '=' $<value>=\w+ / {
    my %h = $/.hash;
    say %h.keys.sort.join: ', ';        # OUTPUT: «value, variable␤» 
    say %h.values.sort.join: ', ';      # OUTPUT: «23, count␤» 
    for %h.kv -> $k, $v {
        say "Found value '$v' with key '$k'";
        # outputs two lines: 
        #   Found value 'count' with key 'variable' 
        #   Found value '23' with key 'value' 
    }
}
```

A more convenient way to get named captures is by using named regex as discussed in the [Subrules](https://docs.perl6.org/language/regexes#Subrules) section.

## Capture markers: `<( )>`

A `<(` token indicates the start of the match's overall capture, while the corresponding `)>` token indicates its endpoint. The `<(`is similar to other languages \K to discard any matches found before the `\K`.

```Perl6
say 'abc' ~~ / a <( b )> c/;            # OUTPUT: «｢b｣␤» 
say 'abc' ~~ / <(a <( b )> c)>/;        # OUTPUT: «｢bc｣␤» 
```

As in the example above, you can see `<(` sets the start point and `)>` sets the endpoint; since they are actually independent of each other, the inner-most start point wins (the one attached to `b`) and the outer-most end wins (the one attached to `c`).

# Substitution

Regular expressions can also be used to substitute one piece of text for another. You can use this for anything, from correcting a spelling error (e.g., replacing 'Perl Jam' with 'Pearl Jam'), to reformatting an ISO8601 date from `yyyy-mm-ddThh:mm:ssZ` to `mm-dd-yy h:m {AM,PM}` and beyond.

Just like the search-and-replace editor's dialog box, the `s/ / /` operator has two sides, a left and right side. The left side is where your matching expression goes, and the right side is what you want to replace it with.

## Lexical conventions

Substitutions are written similarly to matching, but the substitution operator has both an area for the regex to match, and the text to substitute:

```Perl6
s/replace/with/;           # a substitution that is applied to $_ 
$str ~~ s/replace/with/;   # a substitution applied to a scalar 
```

The substitution operator allows delimiters other than the slash:

```Perl6
s|replace|with|;
s!replace!with!;
s,replace,with,;
```

Note that neither the colon `:` nor balancing delimiters such as `{}` or `()` can be substitution delimiters. Colons clash with adverbs such as `s:i/Foo/bar/` and the other delimiters are used for other purposes.

If you use balancing curly braces, square brackets, or parentheses, the substitution works like this instead:

```Perl6
s[replace] = 'with';
```

The right-hand side is now a (not quoted) Perl 6 expression, in which `$/` is available as the current match:

```Perl6
$_ = 'some 11 words 21';
s:g[ \d+ ] =  2 * $/;
.say;                    # OUTPUT: «some 22 words 42␤» 
```

Like the `m//` operator, whitespace is ignored in the regex part of a substitution. Comments, as in Perl 6 in general, start with the hash character `#` and go to the end of the current line.

## Replacing string literals

The simplest thing to replace is a string literal. The string you want to replace goes on the left-hand side of the substitution operator, and the string you want to replace it with goes on the right-hand side; for example:

```Perl6
$_ = 'The Replacements';
s/Replace/Entrap/;
.say;                    # OUTPUT: «The Entrapments␤» 
```

Alphanumeric characters and the underscore are literal matches, just as in its cousin the `m//` operator. All other characters must be escaped with a backslash `\` or included in quotes:

```Perl6
$_ = 'Space: 1999';
s/Space\:/Party like it's/;
.say                        # OUTPUT: «Party like it's 1999␤» 
```

Note that the matching restrictions only apply to the left-hand side of the substitution expression.

By default, substitutions are only done on the first match:

```Perl6
$_ = 'There can be twly two';
s/tw/on/;                     # replace 'tw' with 'on' once 
.say;                         # OUTPUT: «There can be only two␤» 
```

## Wildcards and character classes

Anything that can go into the `m//` operator can go into the left-hand side of the substitution operator, including wildcards and character classes. This is handy when the text you're matching isn't static, such as trying to match a number in the middle of a string:

```Perl6
$_ = "Blake's 9";
s/\d+/7/;         # replace any sequence of digits with '7' 
.say;             # OUTPUT: «Blake's 7␤» 
```

Of course, you can use any of the `+`, `*` and `?` modifiers, and they'll behave just as they would in the `m//` operator's context.

## Capturing groups

Just as in the match operator, capturing groups are allowed on the left-hand side, and the matched contents populate the `$0`..`$n` variables and the `$/` object:

```Perl6
$_ = '2016-01-23 18:09:00';
s/ (\d+)\-(\d+)\-(\d+) /today/;   # replace YYYY-MM-DD with 'today' 
.say;                             # OUTPUT: «today 18:09:00␤» 
"$1-$2-$0".say;                   # OUTPUT: «01-23-2016␤» 
"$/[1]-$/[2]-$/[0]".say;          # OUTPUT: «01-23-2016␤» 
```

Any of these variables `$0`, `$1`, `$/` can be used on the right-hand side of the operator as well, so you can manipulate what you've just matched. This way you can separate out the `YYYY`, `MM` and `DD` parts of a date and reformat them into `MM-DD-YYYY`order:

```Perl6
$_ = '2016-01-23 18:09:00';
s/ (\d+)\-(\d+)\-(\d+) /$1-$2-$0/;    # transform YYYY-MM-DD to MM-DD-YYYY 
.say;                                 # OUTPUT: «01-23-2016 18:09:00␤» 
```

Named capture can be used too:

```Perl6
$_ = '2016-01-23 18:09:00';
s/ $<y>=(\d+)\-$<m>=(\d+)\-$<d>=(\d+) /$<m>-$<d>-$<y>/;
.say;                                 # OUTPUT: «01-23-2016 18:09:00␤» 
```

Since the right-hand side is effectively a regular Perl 6 interpolated string, you can reformat the time from `HH:MM` to `h:MM {AM,PM}` like so:

```Perl6
$_ = '18:38';
s/(\d+)\:(\d+)/{$0 % 12}\:$1 {$0 < 12 ?? 'AM' !! 'PM'}/;
.say;                                 # OUTPUT: «6:38 PM␤» 
```

Using the modulo `%` operator above keeps the sample code under 80 characters, but is otherwise the same as `$0 < 12 ?? $0 !! $0 - 12 `. When combined with the power of the Parser Expression Grammars that **really** underlies what you're seeing here, you can use "regular expressions" to parse pretty much any text out there.

## Common adverbs

The full list of adverbs that you can apply to regular expressions can be found elsewhere in this document ([section Adverbs](https://docs.perl6.org/language/regexes#Adverbs)), but the most common are probably `:g` and `:i`.

- Global adverb `:g`

Ordinarily, matches are only made once in a given string, but adding the `:g` modifier overrides that behavior, so that substitutions are made everywhere possible. Substitutions are non-recursive; for example:

```Perl6
$_ = q{I can say "banana" but I don't know when to stop};
s:g/na/nana,/;    # substitute 'nana,' for 'na' 
.say;             # OUTPUT: «I can say "banana,nana," but I don't ...␤» 
```

Here, `na` was found twice in the original string and each time there was a substitution. The substitution only applied to the original string, though. The resulting string was not impacted.

- Insensitive adverb `:i`

Ordinarily, matches are case-sensitive. `s/foo/bar/` will only match `'foo'` and not `'Foo'`. If the adverb `:i` is used, though, matches become case-insensitive.

```Perl6
$_ = 'Fruit';
s/fruit/vegetable/;
.say;                          # OUTPUT: «Fruit␤» 
 
s:i/fruit/vegetable/;
.say;                          # OUTPUT: «vegetable␤» 
```

For more information on what these adverbs are actually doing, refer to the [section Adverbs](https://docs.perl6.org/language/regexes#Adverbs) section of this document.

These are just a few of the transformations you can apply with the substitution operator. Some of the simpler uses in the real world include removing personal data from log files, editing MySQL timestamps into PostgreSQL format, changing copyright information in HTML files and sanitizing form fields in a web application.

As an aside, novices to regular expressions often get overwhelmed and think that their regular expression needs to match every piece of data in the line, including what they want to match. Write just enough to match the data you're looking for, no more, no less.

# Tilde for nesting structures

The `~` operator is a helper for matching nested subrules with a specific terminator as the goal. It is designed to be placed between an opening and closing delimiter pair, like so:

```Perl6
/ '(' ~ ')' <expression> /
```

However, it mostly ignores the left argument, and operates on the next two atoms (which may be quantified). Its operation on those next two atoms is to "twiddle" them so that they are actually matched in reverse order. Hence the expression above, at first blush, is merely shorthand for:

```Perl6
/ '(' <expression> ')' /
```

But beyond that, when it rewrites the atoms it also inserts the apparatus that will set up the inner expression to recognize the terminator, and to produce an appropriate error message if the inner expression does not terminate on the required closing atom. So it really does pay attention to the left delimiter as well, and it actually rewrites our example to something more like:

```Perl6
$<OPEN> = '(' <SETGOAL: ')'> <expression> [ $GOAL || <FAILGOAL> ]
```

FAILGOAL is a special method that can be defined by the user and it will be called on parse failure:

```Perl6
grammar A { token TOP { '[' ~ ']' \w+  };
            method FAILGOAL($goal) {
                die "Cannot find $goal near position {self.pos}"
            }
}
 
say A.parse: '[good]';  # OUTPUT: «｢[good]｣␤» 
A.parse: '[bad';        # will throw FAILGOAL exception 
CATCH { default { put .^name, ': ', .Str } };
# OUTPUT: «X::AdHoc: Cannot find ']'  near position 4␤» 
```

Note that you can use this construct to set up expectations for a closing construct even when there's no opening delimiter:

```Perl6
"3)"  ~~ / <?> ~ ')' \d+ /;  # RESULT: «｢3)｣» 
"(3)" ~~ / <?> ~ ')' \d+ /;  # RESULT: «｢3)｣» 
```

Here `<?>` successfully matches the null string.

The order of the regex capture is original:

```Perl6
"abc" ~~ /a ~ (c) (b)/;
say $0; # OUTPUT: «｢c｣␤» 
say $1; # OUTPUT: «｢b｣␤» 
```

# Subrules

Just like you can put pieces of code into subroutines, you can also put pieces of regex into named rules.

```Perl6
my regex line { \N*\n }
if "abc\ndef" ~~ /<line> def/ {
    say "First line: ", $<line>.chomp;      # OUTPUT: «First line: abc␤» 
}
```

A named regex can be declared with `my regex named-regex { body here }`, and called with `<named-regex>`. At the same time, calling a named regex installs a named capture with the same name.

To give the capture a different name from the regex, use the syntax `<capture-name=named-regex>`. If no capture is desired, a leading dot or ampersand will suppress it: `<.named-regex>` if it is a method declared in the same class or grammar, `<&named-regex>` for a regex declared in the same lexical context.

Here's more complete code for parsing `ini` files:

```Perl6
my regex header { \s* '[' (\w+) ']' \h* \n+ }
my regex identifier  { \w+ }
my regex kvpair { \s* <key=identifier> '=' <value=identifier> \n+ }
my regex section {
    <header>
    <kvpair>*
}
 
my $contents = q:to/EOI/; 
    [passwords]
        jack=password1
        joy=muchmoresecure123
    [quotas]
        jack=123
        joy=42
EOI
 
my %config;
if $contents ~~ /<section>*/ {
    for $<section>.list -> $section {
        my %section;
        for $section<kvpair>.list -> $p {
            %section{ $p<key> } = ~$p<value>;
        }
        %config{ $section<header>[0] } = %section;
    }
}
say %config.perl;
 
# OUTPUT: «{:passwords(${:jack("password1"), :joy("muchmoresecure123")}), 
#           :quotas(${:jack("123"), :joy("42")})}» 
```

Named regexes can and should be grouped in [grammars](https://docs.perl6.org/language/grammars). A list of predefined subrules is listed in [S05-regex](https://design.perl6.org/S05.html#Predefined_Subrules) of design documents.

# Regex interpolation

Instead of using a literal pattern for a regex match you can use a variable that holds that pattern.

This variable can then be 'interpolated' which means it is used as though it is the pattern that it holds.

```Perl6
my Str $pattern = 'camelia';
say 'camelia' ~~ / $pattern /;             # OUTPUT: «｢camelia｣␤» 
```

If the variable to be interpolated is statically typed as a `Str` or `str` and only interpolated literally, then the compiler can optimize it and it runs much faster (like `$pattern` above ).

Sometimes you may want to match a generated string in a regex. This can be done in the following way:

```Perl6
my Str $pattern = 'ailemac';
say 'camelia' ~~ / $($pattern.flip) /;     # OUTPUT: «｢camelia｣␤» 
```

There are four ways you can interpolate a string into regex as a pattern. That is using `$pattern`, `$($pattern)`, `<$pattern>` or `<{$pattern.method}>`.

Note that the two examples above interpolate the string lexically, while `<$pattern>` and `<{$pattern.method}>` causes [implicit EVAL](https://docs.perl6.org/language/traps#%3C%7B%24x%7D%3E_vs_%24%28%24x%29%3A_Implicit_EVAL), which is a known trap.

Here are examples showing all four ways:

```Perl6
my Str $text = 'camelia';
my Str $pattern0 = 'camelia';
my     $pattern1 = 'ailemac';
my str $pattern2 = '\w+';
 
say $text ~~ / $pattern0 /;                # OUTPUT: «｢camelia｣␤» 
say $text ~~ / $($pattern0) /;             # OUTPUT: «｢camelia｣␤» 
say $text ~~ / $($pattern1.flip) /;        # OUTPUT: «｢camelia｣␤» 
say 'ailemacxflip' ~~ / $pattern1.flip /;  # OUTPUT: «｢ailemacxflip｣␤» 
say '\w+' ~~ / $pattern2 /;                # OUTPUT: «｢\w+｣␤» 
say '\w+' ~~ / $($pattern2) /;             # OUTPUT: «｢\w+｣␤» 
 
say $text ~~ / <{$pattern1.flip}> /;       # OUTPUT: «｢camelia｣␤» 
# say $text ~~ / <$pattern1.flip> /;       # !!Compile Error!! 
say $text ~~ / <$pattern2> /;              # OUTPUT: «｢camelia｣␤» 
say $text ~~ / <{$pattern2}> /;            # OUTPUT: «｢camelia｣␤» 
```

When an array variable is interpolated into a regex, the regex engine handles it like a `|` alternative of the regex elements (see the documentation on [embedded lists](https://docs.perl6.org/language/regexes#Quoted_lists_are_LTM_matches), above). The interpolation rules for individual elements are the same as for scalars, so strings and numbers match literally, and [/type/Regex](https://docs.perl6.org/type/Regex) objects match as regexes. Just as with ordinary `|` interpolation, the longest match succeeds:

```Perl6
my @a = '2', 23, rx/a.+/;
say ('b235' ~~ /  b @a /).Str;      # OUTPUT: «b23» 
```

The use of hashes in regexes is reserved.

## Regex boolean condition check

The special operator `<?{}>` allows the evaluation of a boolean expression that can perform a semantic evaluation of the match before the regular expression continues. In other words, it is possible to check in a boolean context a part of a regular expression and therefore invalidate the whole match (or allow it to continue) even if the match succeeds from a syntactic point of view.

In particular the `<?{}>` operator requires a `True` value in order to allow the regular expression to match, while its negated form `<!{}>` requires a `False` value.

In order to demonstrate the above operator, please consider the following example that involves a simple IPv4 address matching:

```Perl6
my $localhost = '127.0.0.1';
my regex ipv4-octet { \d ** 1..3 <?{ True }> }
$localhost ~~ / ^ <ipv4-octet> ** 4 % "." $ /;
say $/<ipv4-octet>;   # OUTPUT: [｢127｣ ｢0｣ ｢0｣ ｢1｣] 
```

The `octet` regular expression matches against a number made by one up to three digits. Each match is driven by the result of the `<?{}>`, that being the fixed value of `True` means that the regular expression match has to be always considered as good. As a counter-example, using the special constant value `False` will invalidate the match even if the regular expression matches from a syntactic point of view:

```Perl6
my $localhost = '127.0.0.1';
my regex ipv4-octet { \d ** 1..3 <?{ False }> }
$localhost ~~ / ^ <ipv4-octet> ** 4 % "." $ /;
say $/<ipv4-octet>;   # OUTPUT: Nil 
```

From the above examples, it should be clear that it is possible to improve the semantic check, for instance ensuring that each *octet* is really a valid IPv4 octet:

```Perl6
my $localhost = '127.0.0.1';
my regex ipv4-octet { \d ** 1..3 <?{ $/.Int <= 255 && $/.Int >= 0 }> }
$localhost ~~ / ^ <ipv4-octet> ** 4 % "." $ /;
say $/<ipv4-octet>;   # OUTPUT: [｢127｣ ｢0｣ ｢0｣ ｢1｣] 
```

Please note that it is not required to evaluate the regular expression in-line, but also a regular method can be called to get the boolean value:

```Perl6
my $localhost = '127.0.0.1';
sub check-octet ( Int $o ){ $o <= 255 && $o >= 0 }
my regex ipv4-octet { \d ** 1..3 <?{ &check-octet( $/.Int ) }> }
$localhost ~~ / ^ <ipv4-octet> ** 4 % "." $ /;
say $/<ipv4-octet>;   # OUTPUT: [｢127｣ ｢0｣ ｢0｣ ｢1｣] 
```

Of course, being `<!{}>` the negation form of `<?{}>` the same boolean evaluation can be rewritten in a negated form:

```Perl6
my $localhost = '127.0.0.1';
sub invalid-octet( Int $o ){ $o < 0 || $o > 255 }
my regex ipv4-octet { \d ** 1..3 <!{ &invalid-octet( $/.Int ) }> }
$localhost ~~ / ^ <ipv4-octet> ** 4 % "." $ /;
say $/<ipv4-octet>;   # OUTPUT: [｢127｣ ｢0｣ ｢0｣ ｢1｣] 
```

# Adverbs

Adverbs, which modify how regexes work and provide convenient shortcuts for certain kinds of recurring tasks, are combinations of one or more letters preceded by a colon `:`.

The so-called *regex* adverbs apply at the point where a regex is defined; additionally, *matching* adverbs apply at the point that a regex matches against a string and *substitution* adverbs are applied exclusively in substitutions.

This distinction often blurs, because matching and declaration are often textually close but using the method form of matching, that is, `.match`, makes the distinction clear.

```Perl6
say "Abra abra CADABRA" ~~ m:exhaustive/:i a \w+ a/;
# OUTPUT: «(｢Abra｣ ｢abra｣ ｢ADABRA｣ ｢ADA｣ ｢ABRA｣)␤» 
my $regex = /:i a \w+ a /;
say "Abra abra CADABRA".match($regex,:ex);
# OUTPUT: «(｢Abra｣ ｢abra｣ ｢ADABRA｣ ｢ADA｣ ｢ABRA｣)␤» 
```

In the first example, the matching adverb (`:exhaustive`) is contiguous to the regex adverb (`:i`), and as a matter of fact, the "definition" and the "matching" go together; however, by using `match` it becomes clear than `:i` is only used when defining the `$regex` variable, and `:ex` (short for `:exhaustive`) as an argument when matching. As a matter of fact, matching adverbs cannot even be used in the definition of a regex:

```Perl6
my $regex = rx:ex/:i a \w+ a /;
# ===SORRY!=== Error while compiling (...)␤Adverb ex not allowed on rx 
```

Regex adverbs like `:i` go into the definition line and matching adverbs like `:overlap` (which can be abbreviated to `:ov`) are appended to the match call:

```Perl6
my $regex = /:i . a/;
for 'baA'.match($regex, :overlap) -> $m {
    say ~$m;
}
# OUTPUT: «ba␤aA␤» 
```

## Regex adverbs

The adverbs that appear at the time of a regex declaration are part of the actual regex and influence how the Perl 6 compiler translates the regex into binary code.

For example, the `:ignorecase` (`:i`) adverb tells the compiler to ignore the distinction between upper case, lower case and title case letters.

So `'a' ~~ /A/` is false, but `'a' ~~ /:i A/` is a successful match.

Regex adverbs can come before or inside a regex declaration and only affect the part of the regex that comes afterwards, lexically. Note that regex adverbs appearing before the regex must appear after something that introduces the regex to the parser, like 'rx' or 'm' or a bare '/'. This is NOT valid:

```Perl6
my $rx1 = :i/a/;      # adverb is before the regex is recognized => exception 
```

but these are valid:

```Perl6
my $rx1 = rx:i/a/;     # before 
my $rx2 = m:i/a/;      # before 
my $rx3 = /:i a/;      # inside 
```

These two regexes are equivalent:

```Perl6
my $rx1 = rx:i/a/;      # before 
my $rx2 = rx/:i a/;     # inside 
```

Whereas these two are not:

```Perl6
my $rx3 = rx/a :i b/;   # matches only the b case insensitively 
my $rx4 = rx/:i a b/;   # matches completely case insensitively 
```

Square brackets and parentheses limit the scope of an adverb:

```Perl6
/ (:i a b) c /;         # matches 'ABc' but not 'ABC' 
/ [:i a b] c /;         # matches 'ABc' but not 'ABC' 
```

When two adverbs are used together, they keep their colon at the front

```Perl6
"þor is Þor" ~~ m:g:i/þ/;  # OUTPUT: «(｢þ｣ ｢Þ｣)␤» 
```

That implies that when there are two vowels together after a `:`, they correspond to the same adverb, as in `:ov` or `:P5`.

### Ignoremark

The `:ignoremark` or `:m` adverb instructs the regex engine to only compare base characters, and ignore additional marks such as combining accents:

```Perl6
say so 'a' ~~ rx/ä/;                # OUTPUT: «False» 
say so 'a' ~~ rx:ignoremark /ä/;    # OUTPUT: «True» 
say so 'ỡ' ~~ rx:ignoremark /o/;    # OUTPUT: «True> 
```

### Ratchet

The `:ratchet` or `:r` adverb causes the regex engine to not backtrack (see [backtracking](https://docs.perl6.org/language/regexes#Backtracking)). Mnemonic: a [ratchet](https://en.wikipedia.org/wiki/Ratchet_%28device%29) only moves in one direction and can't backtrack.

Without this adverb, parts of a regex will try different ways to match a string in order to make it possible for other parts of the regex to match. For example, in `'abc' ~~ /\w+ ./`, the `\w+` first eats up the whole string, `abc` but then the `.` fails. Thus `\w+`gives up a character, matching only `ab`, and the `.` can successfully match the string `c`. This process of giving up characters (or in the case of alternations, trying a different branch) is known as backtracking.

```Perl6
say so 'abc' ~~ / \w+ . /;        # OUTPUT: «True␤» 
say so 'abc' ~~ / :r \w+ . /;     # OUTPUT: «False␤» 
```

Ratcheting can be an optimization, because backtracking is costly. But more importantly, it closely corresponds to how humans parse a text. If you have a regex `my regex identifier { \w+ }` and `my regex keyword { if | else | endif }`, you intuitively expect the `identifier` to gobble up a whole word and not have it give up its end to the next rule, if the next rule otherwise fails.

For example, you don't expect the word `motif` to be parsed as the identifier `mot` followed by the keyword `if`. Instead, you expect `motif` to be parsed as one identifier; and if the parser expects an `if` afterwards, best that it should fail than have it parse the input in a way you don't expect.

Since ratcheting behavior is often desirable in parsers, there's a shortcut to declaring a ratcheting regex:

```Perl6
my token thing { ... };
# short for 
my regex thing { :r ... };
```

### Sigspace

The **:sigspace** or **:s** adverb makes whitespace significant in a regex.

```Perl6
say so "I used Photoshop®"   ~~ m:i/   photo shop /;      # OUTPUT: «True␤»
say so "I used a photo shop" ~~ m:i:s/ photo shop /;   # OUTPUT: «True␤»
say so "I used Photoshop®"   ~~ m:i:s/ photo shop /;   # OUTPUT: «False␤»
```

`m:s/ photo shop /` acts the same as `m/ photo <.ws> shop <.ws> /`. By default, `<.ws> `makes sure that words are separated, so `a b` and `^&` will match `<.ws> `in the middle, but `ab` won't.

Where whitespace in a regex turns into `<.ws>` depends on what comes before the whitespace. In the above example, whitespace in the beginning of a regex doesn't turn into `<.ws>`, but whitespace after characters does. In general, the rule is that if a term might match something, whitespace after it will turn into `<.ws>`.

In addition, if whitespace comes after a term but *before* a quantifier (`+`, `*`, or `?`), `<.ws>` will be matched after every match of the term. So, `foo +` becomes `[ foo <.ws> ]+`. On the other hand, whitespace *after* a quantifier acts as normal significant whitespace; e.g., "`foo+ `" becomes `foo+ <.ws>`.

In all, this code:

```Perl6
rx :s {
    ^^
    {
        say "No sigspace after this";
    }
    <.assertion_and_then_ws>
    characters_with_ws_after+
    ws_separated_characters *
    [
    | some "stuff" .. .
    | $$
    ]
    :my $foo = "no ws after this";
    $foo
}
```

Becomes:

```Perl6
rx {
    ^^ <.ws>
    {
        say "No space after this";
    }
    <.assertion_and_then_ws> <.ws>
    characters_with_ws_after+ <.ws>
    [ws_separated_characters <.ws>]* <.ws>
    [
    | some <.ws> "stuff" <.ws> .. <.ws> . <.ws>
    | $$ <.ws>
    ] <.ws>
    :my $foo = "no ws after this";
    $foo <.ws>
}
```

If a regex is declared with the `rule` keyword, both the `:sigspace` and `:ratchet` adverbs are implied.

Grammars provide an easy way to override what `<.ws>` matches:

```Perl6
grammar Demo {
    token ws {
        <!ww>       # only match when not within a word 
        \h*         # only match horizontal whitespace 
    }
    rule TOP {      # called by Demo.parse; 
        a b '.'
    }
}
 
# doesn't parse, whitespace required between a and b 
say so Demo.parse("ab.");                 # OUTPUT: «False␤» 
say so Demo.parse("a b.");                # OUTPUT: «True␤» 
say so Demo.parse("a\tb .");              # OUTPUT: «True␤» 
 
# \n is vertical whitespace, so no match 
say so Demo.parse("a\tb\n.");             # OUTPUT: «False␤» 
```

When parsing file formats where some whitespace (for example, vertical whitespace) is significant, it's advisable to override `ws`.

### Perl 5 compatibility adverb

The **:Perl5** or **:P5** adverb switch the Regex parsing and matching to the way Perl 5 regexes behave:

```
so 'hello world' ~~ m:Perl5/^hello (world)/;   # OUTPUT: «True␤» 
so 'hello world' ~~ m/^hello (world)/;         # OUTPUT: «False␤» 
so 'hello world' ~~ m/^ 'hello ' ('world')/;   # OUTPUT: «True␤» 
```

The regular behavior is recommended and more idiomatic in Perl 6 of course, but the **:Perl5** adverb can be useful when compatibility with Perl5 is required.

## Matching adverbs

In contrast to regex adverbs, which are tied to the declaration of a regex, matching adverbs only make sense when matching a string against a regex.

They can never appear inside a regex, only on the outside – either as part of an `m/.../` match or as arguments to a match method.

### Positional adverbs

Positional adverbs make the expression match only the string in the indicated position:

```Perl6
my $data = "f fo foo fooo foooo fooooo foooooo";
say $data ~~ m:nth(4)/fo+/;   # OUTPUT: «｢foooo｣␤» 
say $data ~~ m:1st/fo+/;      # OUTPUT: «｢fo｣␤» 
say $data ~~ m:3rd/fo+/;      # OUTPUT: «｢fooo｣␤» 
say $data ~~ m:nth(1,3)/fo+/; # OUTPUT: «(｢fo｣ ｢fooo｣)␤» 
```

As you can see, the adverb argument can also be a list. There's actually no difference between the `:nth` adverb and the rest. You choose them only based on legibility. From 6.d, you can also use `Junction`s as arguments.

```Perl6
my $data = "f fo foo fooo foooo fooooo foooooo";
say $data ~~ m:st(1|8)/fo+/;  # OUTPUT: «True␤» 
```

In this case, one of them exists (1), so it returns True. Observe that we have used `:st`. As said above, it's functionally equivalent, although obviously less legible than using `:nth`, so this last form is advised.

### Continue

The `:continue` or short `:c` adverb takes an argument. The argument is the position where the regex should start to search. By default, it searches from the start of the string, but `:c` overrides that. If no position is specified for `:c`, it will default to `0` unless `$/` is set, in which case, it defaults to `$/.to`.

```Perl6
given 'a1xa2' {
    say ~m/a./;         # OUTPUT: «a1␤» 
    say ~m:c(2)/a./;    # OUTPUT: «a2␤» 
}
```

*Note:* unlike `:pos`, a match with :continue() will attempt to match further in the string, instead of failing:

```Perl6
say "abcdefg" ~~ m:c(3)/e.+/; # OUTPUT: «｢efg｣␤» 
say "abcdefg" ~~ m:p(3)/e.+/; # OUTPUT: «False␤» 
```

### Exhaustive

To find all possible matches of a regex – including overlapping ones – and several ones that start at the same position, use the `:exhaustive` (short `:ex`) adverb.

```Perl6
given 'abracadabra' {
    for m:exhaustive/ a .* a / -> $match {
        say ' ' x $match.from, ~$match;
    }
}
```

The above code produces this output:

```Perl6
    abracadabra
    abracada
    abraca
    abra
       acadabra
       acada
       aca
         adabra
         ada
           abra
```

### Global

Instead of searching for just one match and returning a [Match object](https://docs.perl6.org/type/Match), search for every non-overlapping match and return them in a [List](https://docs.perl6.org/type/List). In order to do this, use the `:global` adverb:

```Perl6
given 'several words here' {
    my @matches = m:global/\w+/;
    say @matches.elems;         # OUTPUT: «3␤» 
    say ~@matches[2];           # OUTPUT: «here␤» 
}
```

`:g` is shorthand for `:global`.

### Pos

Anchor the match at a specific position in the string:

```Perl6
given 'abcdef' {
    my $match = m:pos(2)/.*/;
    say $match.from;        # OUTPUT: «2␤» 
    say ~$match;            # OUTPUT: «cdef␤» 
}
```

`:p` is shorthand for `:pos`.

*Note:* unlike `:continue`, a match anchored with :pos() will fail, instead of attempting to match further down the string:

```Perl6
say "abcdefg" ~~ m:c(3)/e.+/; # OUTPUT: «｢efg｣␤» 
say "abcdefg" ~~ m:p(3)/e.+/; # OUTPUT: «False␤» 
```

### Overlap

To get several matches, including overlapping matches, but only one (the longest) from each starting position, specify the `:overlap` (short `:ov`) adverb:

```Perl6
given 'abracadabra' {
    for m:overlap/ a .* a / -> $match {
        say ' ' x $match.from, ~$match;
    }
}
```

produces

```Perl6
    abracadabra
       acadabra
         adabra
           abra
```

## Substitution adverbs

You can apply matching adverbs (such as `:global`, `:pos` etc.) to substitutions. In addition, there are adverbs that only make sense for substitutions, because they transfer a property from the matched string to the replacement string.

### Samecase

The `:samecase` or `:ii` substitution adverb implies the `:ignorecase` adverb for the regex part of the substitution, and in addition carries the case information to the replacement string:

```Perl6
$_ = 'The cat chases the dog';
s:global:samecase[the] = 'a';
say $_;                 # OUTPUT: «A cat chases a dog» 
```

Here you can see that the first replacement string `a` got capitalized, because the first string of the matched string was also a capital letter.

### Samemark

The `:samemark` or `:mm` adverb implies `:ignoremark` for the regex, and in addition, copies the markings from the matched characters to the replacement string:

```Perl6
given 'äộñ' {
    say S:mm/ a .+ /uia/;           # OUTPUT: «üị̂ã» 
}
```

### Samespace

The `:samespace` or `:ss` substitution modifier implies the `:sigspace` modifier for the regex, and in addition, copies the whitespace from the matched string to the replacement string:

```Perl6
say S:samespace/a ./c d/.perl given "a b";      # OUTPUT: «"c d"» 
say S:samespace/a ./c d/.perl given "a\tb";     # OUTPUT: «"c\td"» 
say S:samespace/a ./c d/.perl given "a\nb";     # OUTPUT: «"c\nd"» 
```

The `ss/.../.../` syntactic form is a shorthand for `s:samespace/.../.../`.

# Backtracking

Perl 6 defaults to *backtracking* when evaluating regular expressions. Backtracking is a technique that allows the engine to try different matching in order to allow every part of a regular expression to succeed. This is costly, because it requires the engine to usually eat up as much as possible in the first match and then adjust going backwards in order to ensure all regular expression parts have a chance to match.

In order to better understand backtracking, consider the following example:

```Perl6
my $string = 'PostgreSQL is an SQL database!';
say $string ~~ /(.+)(SQL) (.+) $1/; # OUTPUT: ｢PostgreSQL is an SQL｣ 
```

What happens in the above example is that the string has to be matched against the second occurrence of the word *SQL*, eating all characters before and leaving out the rest.

Since it is possible to execute a piece of code within a regular expression, it is also possible to inspect the [Match](https://docs.perl6.org/type/Match) object within the regular expression itself:

```Perl6
my $iteration = 0;
sub show-captures( Match $m ){
    my Str $result_split;
    say "\n=== Iteration {++$iteration} ===";
    for $m.list.kv -> $i, $capture {
        say "Capture $i = $capture";
        $result_split ~= '[' ~ $capture ~ ']';
    }
 
    say $result_split;
}
 
$string ~~ /(.+)(SQL) (.+) $1 (.+) { show-captures( $/ );  }/;
```

The `show-captures` method will dump all the elements of `$/` producing the following output:

```Perl6
=== Iteration 1 ===
Capture 0 = Postgre
Capture 1 = SQL
Capture 2 =  is an
[Postgre][SQL][ is an ]
```

showing that the string has been split around the second occurrence of *SQL*, that is the repetition of the first capture (`$/[1]`).

With that in place, it is now possible to see how the engine backtracks to find the above match: it does suffice to move the `show-captures` in the middle of the regular expression, in particular before the repetition of the first capture `$1` to see it in action:

```Perl6
my $iteration = 0;
sub show-captures( Match $m ){
    my Str $result-split;
    say "\n=== Iteration {++$iteration} ===";
    for $m.list.kv -> $i, $capture {
        say "Capture $i = $capture";
        $result-split ~= '[' ~ $capture ~ ']';
    }
 
    say $result-split;
}
 
$string ~~ / (.+)(SQL) (.+) { show-captures( $/ );  } $1 /;
```

The output will be much more verbose and will show several iterations, with the last one being the *winning*. The following is an excerpt of the output:

```Perl6
=== Iteration 1 ===
Capture 0 = PostgreSQL is an
Capture 1 = SQL
Capture 2 =  database!
[PostgreSQL is an ][SQL][ database!]
 
=== Iteration 2 ===
Capture 0 = PostgreSQL is an
Capture 1 = SQL
Capture 2 =  database
[PostgreSQL is an ][SQL][ database]
 
...
 
=== Iteration 24 ===
Capture 0 = Postgre
Capture 1 = SQL
Capture 2 =  is an
[Postgre][SQL][ is an ]
```

In the first iteration the *SQL* part of *PostgreSQL* is kept within the word: that is not what the regular expression asks for, so there's the need for another iteration. The second iteration will move back, in particular one character back (removing thus the final *!*) and try to match again, resulting in a fail since again the *SQL* is still kept within *PostgreSQL*. After several iterations, the final result is match.

It is worth noting that the final iteration is number *24*, and that such number is exactly the distance, in number of chars, from the end of the string to the first *SQL* occurrence:

```Perl6
say $string.chars - $string.index: 'SQL'; # OUTPUT: 23 
```

Since there are 23 chars from the very end of the string to the very first *S* of *SQL* the backtracking engine will need 23 "useless" matches to find the right one, that is will need 24 steps to get the final result.

Backtracking is a costly machinery, therefore it is possible to disable it in those cases where the matching can be found *forward* only.

With regards to the above example, disabling backtracking means the regular expression will not have any chance to match:

```Perl6
say $string ~~ /(.+)(SQL) (.+) $1/;      # OUTPUT: ｢PostgreSQL is an SQL｣ 
say $string ~~ / :r (.+)(SQL) (.+) $1/;  # OUTPUT: Nil 
```

The fact is that, as shown in the *iteration 1* output, the first match of the regular expression engine will be `PostgreSQL is an `, `SQL`, `database` that does not leave out any room for matching another occurrence of the word *SQL* (as `$1` in the regular expression). Since the engine is not able to get backward and change the path to match, the regular expression fails.

It is worth noting that disabling backtracking will not prevent the engine to try several ways to match the regular expression. Consider the following slightly changed example:

```Perl6
my $string = 'PostgreSQL is an SQL database!';
say $string ~~ / (SQL) (.+) $1 /; # OUTPUT: Nil 
```

Since there is no specification for a character before the word *SQL*, the engine will match against the rightmost word *SQL*and go forward from there. Since there is no repetition of *SQL* remaining, the match fails. It is possible, again, to inspect what the engine performs introducing a dumping piece of code within the regular expression:

```Perl6
my $iteration = 0;
sub show-captures( Match $m ){
    my Str $result-split;
    say "\n=== Iteration {++$iteration} ===";
    for $m.list.kv -> $i, $capture {
        say "Capture $i = $capture";
        $result-split ~= '[' ~ $capture ~ ']';
    }
 
    say $result-split;
}
 
$string ~~ / (SQL) (.+) { show-captures( $/ ); } $1 /;
```

that produces a rather simple output:

```Perl6
=== Iteration 1 ===
Capture 0 = SQL
Capture 1 =  is an SQL database!
[SQL][ is an SQL database!]
 
=== Iteration 2 ===
Capture 0 = SQL
Capture 1 =  database!
[SQL][ database!]
```

Even using the [:r](https://docs.perl6.org/language/regexes#Ratchet) adverb to prevent backtracking will not change things:

```Perl6
my $iteration = 0;
sub show-captures( Match $m ){
    my Str $result-split;
    say "\n=== Iteration {++$iteration} ===";
    for $m.list.kv -> $i, $capture {
        say "Capture $i = $capture";
        $result-split ~= '[' ~ $capture ~ ']';
    }
 
    say $result-split;
}
 
$string ~~ / :r (SQL) (.+) { show-captures( $/ ); } $1 /;
```

and the output will remain the same:

```Perl6
=== Iteration 1 ===
Capture 0 = SQL
Capture 1 =  is an SQL database!
[SQL][ is an SQL database!]
 
=== Iteration 2 ===
Capture 0 = SQL
Capture 1 =  database!
[SQL][ database!]
```

This demonstrate that disabling backtracking does not mean disabling possible multiple iterations of the matching engine, but rather disabling the backward matching tuning.

# `$/` changes each time a regular expression is matched

It is worth noting that each time a regular expression is used, the [Match object](https://docs.perl6.org/type/Match) returned (i.e., `$/`) is reset. In other words, `$/`always refers to the very last regular expression matched:

```Perl6
my $answer = 'a lot of Stuff';
say 'Hit a capital letter!' if $answer ~~ / <[A..Z>]> /;
say $/;  # OUTPUT: ｢S｣ 
say 'hit an x!' if $answer ~~ / x /;
say $/;  # OUTPUT: Nil 
```

The reset of `$/` applies independently from the scope where the regular expression is matched:

```Perl6
my $answer = 'a lot of Stuff';
if $answer ~~ / <[A..Z>]> / {
   say 'Hit a capital letter';
   say $/;  # OUTPUT: ｢S｣ 
}
say $/;  # OUTPUT: ｢S｣ 
 
if True {
  say 'hit an x!' if $answer ~~ / x /;
  say $/;  # OUTPUT: Nil 
}
 
say $/;  # OUTPUT: Nil 
```

The very same concept applies to named captures:

```Perl6
my $answer = 'a lot of Stuff';
if $answer ~~ / $<capital>=<[A..Z>]> / {
   say 'Hit a capital letter';
   say $/<capital>; # OUTPUT: ｢S｣ 
}
 
say $/<capital>;    # OUTPUT: ｢S｣ 
say 'hit an x!' if $answer ~~ / $<x>=x /;
say $/<x>;          # OUTPUT: Nil 
say $/<capital>;    # OUTPUT: Nil 
```

# 最佳实践和成功案例 / Best practices and gotchas

[最佳实践和成功案例](https://docs.perl6.org/language/regexes-best-practices) 提供有关如何在编写正则表达式和语法时避免常见陷阱的有用信息。

The [Regexes: Best practices and gotchas](https://docs.perl6.org/language/regexes-best-practices) provides useful information on how to avoid common pitfalls when writing regexes and grammars.