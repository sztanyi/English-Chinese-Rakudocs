# 引文构造 / Quoting constructs

在 Raku 中编写字符串、单词列表和正则表达式

Writing strings, word lists, and regexes in Raku

# Q 语言 / The Q lang

字符串通常用某种形式的引用构造在 Raku 代码中表示。其中最简约的是 `Q`，可通过快捷方式 `｢…｣` 使用，或通过 `Q`，后面跟着围绕你的文本的任何一对分隔符。然而，大多数时候，你最需要的是‘…’`或‘’…‘`，下文将更详细地介绍。

Strings are usually represented in Raku code using some form of quoting construct. The most minimalistic of these is `Q`, usable via the shortcut `｢…｣`, or via `Q` followed by any pair of delimiters surrounding your text. Most of the time, though, the most you'll need is `'…'` or `"…"`, described in more detail in the following sections.

## 文本字符串：Q / Literal strings: Q

```Raku
Q[A literal string]
｢More plainly.｣
Q ^Almost any non-word character can be a delimiter!^
Q ｢｢Delimiters can be repeated/nested if they are adjacent.｣｣
```

分隔符可以嵌套，但在普通的 `Q` 形式中，反斜杠转义是不允许的。换句话说，基本的 `Q` 字符串是尽可能的字面意思。

Delimiters can be nested, but in the plain `Q` form, backslash escapes aren't allowed. In other words, basic `Q` strings are as literal as possible.

在 `Q`、`q` 或 `qq` 之后不允许使用某些分隔符。不允许使用[标识符](https://rakudocs.github.io/language/syntax#Identifiers)中允许的任何字符，因为在这种情况下，引用构造连同这些字符一起被解释为标识符。此外，`( )` 是不允许的，因为它被解释为函数调用。如果你仍然希望使用这些字符作为分隔符，请用空格将它们与 `Q`、`q` 或 `qq` 分隔开。请注意，一些自然语言在字符串的右侧使用左分隔引号。`Q` 不支持这些，因为它依赖 Unicode 属性区分左分隔符和右分隔符。

Some delimiters are not allowed immediately after `Q`, `q`, or `qq`. Any characters that are allowed in [identifiers](https://rakudocs.github.io/language/syntax#Identifiers) are not allowed to be used, since in such a case, the quoting construct together with such characters are interpreted as an identifier. In addition, `( )` is not allowed because that is interpreted as a function call. If you still wish to use those characters as delimiters, separate them from `Q`, `q`, or `qq` with a space. Please note that some natural languages use a left delimiting quote on the right side of a string. `Q` will not support those as it relies on unicode properties to tell left and right delimiters apart.

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

The `q` form allows for escaping characters that would otherwise end the string using a backslash. The backslash itself can be escaped, too, as in the third example above. The usual form is `'…'` or `q` followed by a delimiter, but it's also available as an adverb on `Q`, as in the fifth and last example above.

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

The `\qq[...]` escape sequence enables [`qq` interpolation](https://rakudocs.github.io/language/quoting#Interpolation:_qq) for a portion of the string. Using this escape sequence is handy when you have HTML markup in your strings, to avoid interpretation of angle brackets as hash keys:

```Raku
my $var = 'foo';
say '<code>$var</code> is <var>\qq[$var.uc()]</var>';
# OUTPUT: «<code>$var</code> is <var>FOO</var>␤»
```

## Interpolation: qq

```Raku
my $color = 'blue';
say "My favorite color is $color!"
My favorite color is blue!
```

The `qq` form – usually written using double quotes – allows for interpolation of backslash sequences and variables, i.e., variables can be written within the string so that the content of the variable is inserted into the string. It is also possible to escape variables within a `qq`-quoted string:

```Raku
say "The \$color variable contains the value '$color'";
The $color variable contains the value 'blue'
```

Another feature of `qq` is the ability to interpolate Raku code from within the string, using curly braces:

```Raku
my ($x, $y, $z) = 4, 3.5, 3;
say "This room is $x m by $y m by $z m.";
say "Therefore its volume should be { $x * $y * $z } m³!";
This room is 4 m by 3.5 m by 3 m.
Therefore its volume should be 42 m³!
```

By default, only variables with the `$` sigil are interpolated normally. This way, when you write `"documentation@perl6.org"`, you aren't interpolating the `@perl6` variable. If that's what you want to do, append a `[]` to the variable name:

```Raku
my @neighbors = "Felix", "Danielle", "Lucinda";
say "@neighbors[] and I try our best to coexist peacefully."
Felix Danielle Lucinda and I try our best to coexist peacefully.
```

Often a method call is more appropriate. These are allowed within `qq` quotes as long as they have parentheses after the call. Thus the following code will work:

```Raku
say "@neighbors.join(', ') and I try our best to coexist peacefully."
Felix, Danielle, Lucinda and I try our best to coexist peacefully.
```

However, `"@example.com"` produces `@example.com`.

To call a subroutine, use the `&`-sigil.

```Raku
say "abc&uc("def")ghi";
# OUTPUT: «abcDEFghi␤»
```

Postcircumfix operators and therefore [subscripts](https://rakudocs.github.io/language/subscripts) are interpolated as well.

```Raku
my %h = :1st; say "abc%h<st>ghi";
# OUTPUT: «abc1ghi␤»
```

To enter unicode sequences, use `\x` or `\x[]` with the hex-code of the character or a list of characters.

```Raku
my $s = "I \x2665 Raku!";
say $s;
# OUTPUT: «I ♥ Raku!␤» 
 
$s = "I really \x[2661,2665,2764,1f495] Raku!";
say $s;
# OUTPUT: «I really ♡♥❤💕 Raku!␤»
```

You can also use [unicode names](https://rakudocs.github.io/language/unicode#Entering_unicode_codepoints_and_codepoint_sequences) , [named sequences](https://rakudocs.github.io/language/unicode#Named_sequences) and [name aliases](https://rakudocs.github.io/language/unicode#Name_aliases) with [\c[\]](https://rakudocs.github.io/language/unicode#Entering_unicode_codepoints_and_codepoint_sequences).

```Raku
my $s = "Camelia \c[BROKEN HEART] my \c[HEAVY BLACK HEART]!";
say $s;
# OUTPUT: «Camelia 💔 my ❤!␤»
```

Interpolation of undefined values will raise a control exception that can be caught in the current block with [CONTROL](https://rakudocs.github.io/language/phasers#CONTROL).

```Raku
sub niler {Nil};
my Str $a = niler;
say("$a.html", "sometext");
say "alive"; # this line is dead code 
CONTROL { .die };
```

## Word quoting: qw 

```Raku
qw|! @ # $ % ^ & * \| < > | eqv '! @ # $ % ^ & * | < >'.words.list;
q:w { [ ] \{ \} } eqv ('[', ']', '{', '}');
Q:w | [ ] { } | eqv ('[', ']', '{', '}');
```

The `:w` form, usually written as `qw`, splits the string into "words". In this context, words are defined as sequences of non-whitespace characters separated by whitespace. The `q:w` and `qw` forms inherit the interpolation and escape semantics of the `q` and single quote string delimiters, whereas `Qw` and `Q:w` inherit the non-escaping semantics of the `Q` quoter.

This form is used in preference to using many quotation marks and commas for lists of strings. For example, where you could write:

```Raku
my @directions = 'left', 'right,', 'up', 'down';
```

It's easier to write and to read this:

```Raku
my @directions = qw|left right up down|;
```

## Word quoting: < > 

```Raku
say <a b c> eqv ('a', 'b', 'c');   # OUTPUT: «True␤»
say <a b 42> eqv ('a', 'b', '42'); # OUTPUT: «False␤», the 42 became an IntStr allomorph
say < 42 > ~~ Int; # OUTPUT: «True␤»
say < 42 > ~~ Str; # OUTPUT: «True␤»
```

The angle brackets quoting is like `qw`, but with extra feature that lets you construct [allomorphs](https://rakudocs.github.io/language/glossary#index-entry-Allomorph) or literals of certain numbers:

```Raku
say <42 4/2 1e6 1+1i abc>.perl;
# OUTPUT: «(IntStr.new(42, "42"), RatStr.new(2.0, "4/2"), NumStr.new(1000000e0, "1e6"), ComplexStr.new(<1+1i>, "1+1i"), "abc")␤»
```

To construct a [`Rat`](https://rakudocs.github.io/type/Rat) or [`Complex`](https://rakudocs.github.io/type/Complex) literal, use angle brackets around the number, without any extra spaces:

```Raku
say <42/10>.^name;   # OUTPUT: «Rat␤» 
say <1+42i>.^name;   # OUTPUT: «Complex␤» 
say < 42/10 >.^name; # OUTPUT: «RatStr␤» 
say < 1+42i >.^name; # OUTPUT: «ComplexStr␤»
```

Compared to `42/10` and `1+42i`, there's no division (or addition) operation involved. This is useful for literals in routine signatures, for example:

```Raku
sub close-enough-π (<355/113>) {
    say "Your π is close enough!"
}
close-enough-π 710/226; # OUTPUT: «Your π is close enough!␤» 
# WRONG: can't do this, since it's a division operation 
sub compilation-failure (355/113) {}
```

## Word quoting with quote protection: qww

The `qw` form of word quoting will treat quote characters literally, leaving them in the resulting words:

```Raku
say qw{"a b" c}.perl; # OUTPUT: «("\"a", "b\"", "c")␤»
```

Thus, if you wish to preserve quoted sub-strings as single items in the resulting words you need to use the `qww` variant:

```Raku
say qww{"a b" c}.perl; # OUTPUT: «("a b", "c")␤»
```

## Word quoting with interpolation: qqw

The `qw` form of word quoting doesn't interpolate variables:

```Raku
my $a = 42; say qw{$a b c};  # OUTPUT: «$a b c␤»
```

Thus, if you wish for variables to be interpolated within the quoted string, you need to use the `qqw` variant:

```Raku
my $a = 42;
my @list = qqw{$a b c};
say @list;                # OUTPUT: «[42 b c]␤»
```

Note that variable interpolation happens before word splitting:

```Raku
my $a = "a b";
my @list = qqw{$a c};
.say for @list; # OUTPUT: «a␤b␤c␤»
```

## Word quoting with interpolation and quote protection: qqww

The `qqw` form of word quoting will treat quote characters literally, leaving them in the resulting words:

```Raku
my $a = 42; say qqw{"$a b" c}.perl;  # OUTPUT: «("\"42", "b\"", "c")␤»
```

Thus, if you wish to preserve quoted sub-strings as single items in the resulting words you need to use the `qqww` variant:

```Raku
my $a = 42; say qqww{"$a b" c}.perl; # OUTPUT: «("42 b", "c")␤»
```

Quote protection happens before interpolation, and interpolation happens before word splitting, so quotes coming from inside interpolated variables are just literal quote characters:

```Raku
my $a = "1 2";
say qqww{"$a" $a}.perl; # OUTPUT: «("1 2", "1", "2")␤» 
my $b = "1 \"2 3\"";
say qqww{"$b" $b}.perl; # OUTPUT: «("1 \"2 3\"", "1", "\"2", "3\"")␤»
```

## Word quoting with interpolation and quote protection: « »

This style of quoting is like `qqww`, but with the added benefit of constructing [allomorphs](https://rakudocs.github.io/language/glossary#index-entry-Allomorph) (making it functionally equivalent to [qq:ww:v](https://rakudocs.github.io/language/quoting#index-entry-%3Aval_%28quoting_adverb%29)). The ASCII equivalent to `« »` are double angle brackets `<< >>`.

```Raku
# Allomorph Construction 
my $a = 42; say «  $a b c    ».perl;  # OUTPUT: «(IntStr.new(42, "42"), "b", "c")␤» 
my $a = 42; say << $a b c   >>.perl;  # OUTPUT: «(IntStr.new(42, "42"), "b", "c")␤» 
 
# Quote Protection 
my $a = 42; say «  "$a b" c  ».perl;  # OUTPUT: «("42 b", "c")␤» 
my $a = 42; say << "$a b" c >>.perl;  # OUTPUT: «("42 b", "c")␤»
```

## Shell quoting: qx

To run a string as an external program, not only is it possible to pass the string to the `shell` or `run` functions but one can also perform shell quoting. There are some subtleties to consider, however. `qx` quotes *don't* interpolate variables. Thus

```Raku
my $world = "there";
say qx{echo "hello $world"}
```

prints simply `hello`. Nevertheless, if you have declared an environment variable before calling `perl6`, this will be available within `qx`, for instance

```Raku
WORLD="there" perl6
> say qx{echo "hello $WORLD"}
```

will now print `hello there`.

The result of calling `qx` is returned, so this information can be assigned to a variable for later use:

```Raku
my $output = qx{echo "hello!"};
say $output;    # OUTPUT: «hello!␤»
```

See also [shell](https://rakudocs.github.io/routine/shell), [run](https://rakudocs.github.io/routine/run) and [Proc::Async](https://rakudocs.github.io/type/Proc::Async) for other ways to execute external commands.

## Shell quoting with interpolation: qqx

If one wishes to use the content of a Raku variable within an external command, then the `qqx` shell quoting construct should be used:

```Raku
my $world = "there";
say qqx{echo "hello $world"};  # OUTPUT: «hello there␤»
```

Again, the output of the external command can be kept in a variable:

```Raku
my $word = "cool";
my $option = "-i";
my $file = "/usr/share/dict/words";
my $output = qqx{grep $option $word $file};
# runs the command: grep -i cool /usr/share/dict/words 
say $output;      # OUTPUT: «Cooley␤Cooley's␤Coolidge␤Coolidge's␤cool␤...»
```

See also [run](https://rakudocs.github.io/routine/run) and [Proc::Async](https://rakudocs.github.io/type/Proc::Async) for better ways to execute external commands.

## Heredocs: :to

A convenient way to write multi-line string literals are *heredocs*, which let you choose the delimiter yourself:

```Raku
say q:to/END/; 
Here is
some multi-line
string
END
```

The contents of the heredoc always begin on the next line, so you can (and should) finish the line.

```Raku
my $escaped = my-escaping-function(q:to/TERMINATOR/, language => 'html'); 
Here are the contents of the heredoc.
Potentially multiple lines.
TERMINATOR
```

If the terminator is indented, that amount of indention is removed from the string literals. Therefore this heredoc

```Raku
say q:to/END/; 
    Here is
    some multi line
        string
    END
```

produces this output:

```Raku
Here is
some multi line
    string
 
 
```

Heredocs include the newline from before the terminator.

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

would produce:

```Raku
option {
    file "db.7.3.8";
};
```

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

## Unquoting

Literal strings permit interpolation of embedded quoting constructs by using the escape sequences such as these:

```Raku
my $animal="quaggas";
say 'These animals look like \qq[$animal]'; # OUTPUT: «These animals look like quaggas␤» 
say 'These animals are \qqw[$animal or zebras]'; # OUTPUT: «These animals are quaggas or zebras␤»
```

In this example, `\qq` will do double-quoting interpolation, and `\qqw` word quoting with interpolation. Escaping any other quoting construct as above will act in the same way, allowing interpolation in literal strings.

# Regexes

For information about quoting as applied in regexes, see the [regular expression documentation](https://rakudocs.github.io/language/regexes).
