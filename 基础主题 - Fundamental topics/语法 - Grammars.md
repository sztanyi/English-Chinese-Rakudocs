原文：https://docs.raku.org/language/grammars

# 语法 / Grammars

分析和翻译文本

Parsing and interpreting text

语法是一种强大的工具，用于解构文本，并经常返回通过解释该文本而创建的数据结构。

Grammar is a powerful tool used to destructure text and often to return data structures that have been created by interpreting that text.

例如，Raku 使用 Raku 样式的语法进行解析和执行。

For example, Raku is parsed and executed using a Raku-style grammar.

对于普通的 Raku 用户来说，更实用的例子是 [JSON::Tiny 模组](https://github.com/moritz/json)，它可以反序列化任何有效的 JSON 文件；但是，反序列化代码用不到 100 行简单的可扩展代码编写。

An example that's more practical to the common Raku user is the [JSON::Tiny module](https://github.com/moritz/json), which can deserialize any valid JSON file; however, the deserializing code is written in less than 100 lines of simple, extensible code.

如果你在学校不喜欢语法，不要方。语法允许你对正则表达式进行分组，就像类允许你对常规代码的方法进行分组一样。

If you didn't like grammar in school, don't let that scare you off grammars. Grammars allow you to group regexes, just as classes allow you to group methods of regular code.

<!-- MarkdownTOC -->

- [命名正则 / Named Regexes](#命名正则--named-regexes)
    - [规则 / Rules](#规则--rules)
- [创建语法 / Creating grammars](#创建语法--creating-grammars)
    - [原型化正则 / Proto regexes](#原型化正则--proto-regexes)
    - [特殊标记 / Special tokens](#特殊标记--special-tokens)
        - [`TOP`](#top)
        - [`ws`](#ws)
        - [`sym`](#sym)
        - [“总是成功”断言 / "Always succeed" assertion](#“总是成功”断言--always-succeed-assertion)
    - [grammar 中的方法 / Methods in grammars](#grammar-中的方法--methods-in-grammars)
    - [grammar 中的动态变量 / Dynamic variables in grammars](#grammar-中的动态变量--dynamic-variables-in-grammars)
    - [grammar 中的属性 / Attributes in grammars](#grammar-中的属性--attributes-in-grammars)
    - [传递参数给 grammar / Passing arguments into grammars](#传递参数给-grammar--passing-arguments-into-grammars)
- [Action 对象 / Action objects](#action-对象--action-objects)

<!-- /MarkdownTOC -->


<a id="命名正则--named-regexes"></a>
# 命名正则 / Named Regexes

语法的主要成分为命名[正则](https://docs.raku.org/language/regexes)。虽然 Raku 正则的语法不在本文档的范围内，但*命名*正则有一个特殊的语法，类似于子例程定义：[[1\]](https://docs.raku.org/language/grammars#fn-1)

The main ingredient of grammars is named [regexes](https://docs.raku.org/language/regexes). While the syntax of [Raku Regexes](https://docs.raku.org/language/regexes) is outside the scope of this document, *named* regexes have a special syntax, similar to subroutine definitions: [[1\]](https://docs.raku.org/language/grammars#fn-1)

```Raku
my regex number { \d+ [ \. \d+ ]? }
```

在这种情况下，我们必须使用 `my` 关键字指定正则的词法范围，因为命名正则通常在 grammar 中使用。

In this case, we have to specify that the regex is lexically scoped using the `my` keyword, because named regexes are normally used within grammars.

命名使我们能够轻松地在其他地方重用正则：

Being named gives us the advantage of being able to easily reuse the regex elsewhere:

```Raku
say so "32.51" ~~ &number;                         # OUTPUT: «True␤» 
say so "15 + 4.5" ~~ /<number>\s* '+' \s*<number>/ # OUTPUT: «True␤» 
```

**regex** 不是命名正则的唯一声明符。事实上，这是最不常见的。大多数时候使用 **token** 或者 **rule** 声明符。这两个都有*棘轮效应*，这意味着匹配引擎在匹配失败时不会备份并重试。这通常会满足你的需求，但不适用于所有情况：

**regex** isn't the only declarator for named regexes. In fact, it's the least common. Most of the time, the **token** or **rule**declarators are used. These are both *ratcheting*, which means that the match engine won't back up and try again if it fails to match something. This will usually do what you want, but isn't appropriate for all cases:

```Raku
my regex works-but-slow { .+ q }
my token fails-but-fast { .+ q }
my $s = 'Tokens won\'t backtrack, which makes them fail quicker!';
say so $s ~~ &works-but-slow; # OUTPUT: «True␤» 
say so $s ~~ &fails-but-fast; # OUTPUT: «False␤» 
                              # the entire string get taken by the .+ 
```

请注意，无回溯是有条件的，如下面的示例所示，如果匹配了某个内容，那么将永远不会进行回溯。但如果不匹配，有被 `|` 或 `||` 引入的其他候选者话，会重新尝试匹配。

Note that non-backtracking works on terms, that is, as the example below, if you have matched something, then you will never backtrack. But when you fail to match, if there is another candidate introduced by `|` or `||`, you will retry to match again.

```Raku
my token tok-a { .* d  };
my token tok-b { .* d | bd };
say so "bd" ~~ &tok-a;        # OUTPUT: «False␤» 
say so "bd" ~~ &tok-b;        # OUTPUT: «True␤» 
```

<a id="规则--rules"></a>
## 规则 / Rules

`token` 和 `rule` 声明符之间的唯一区别是，`rule` 声明符使 [`:sigspace`](https://docs.raku.org/language/regexes#Sigspace) 在 Regex 中生效：

The only difference between the `token` and `rule` declarators is that the `rule` declarator causes [`:sigspace`](https://docs.raku.org/language/regexes#Sigspace) to go into effect for the Regex:

```Raku
my token non-space-y { 'once' 'upon' 'a' 'time' }
my rule space-y { 'once' 'upon' 'a' 'time' }
say so 'onceuponatime'    ~~ &non-space-y; # OUTPUT: «True␤» 
say so 'once upon a time' ~~ &non-space-y; # OUTPUT: «False␤» 
say so 'onceuponatime'    ~~ &space-y;     # OUTPUT: «False␤» 
say so 'once upon a time' ~~ &space-y;     # OUTPUT: «True␤» 
```

<a id="创建语法--creating-grammars"></a>
# 创建语法 / Creating grammars

[Grammar](https://docs.raku.org/type/Grammar) 是类在用 `grammar` 关键字而不是 `class` 声明时自动获得的超类。Grammar 只能用于解析文本；如果希望提取复杂数据，可以在 grammar 中添加操作，或者建议将[操作对象](https://docs.raku.org/language/grammars#Action_objects)与 grammar 一起使用。如果不使用操作对象，`.parse` 返回一个 [Match](https://docs.raku.org/type/Match) 对象，并在默认情况下将[默认匹配对象 `$/`](https://docs.raku.org/syntax/$$SOLIDUS)设置为相同的值。

[Grammar](https://docs.raku.org/type/Grammar) is the superclass that classes automatically get when they are declared with the `grammar` keyword instead of `class`. Grammars should only be used to parse text; if you wish to extract complex data, you can add actions within the grammar, or an [action object](https://docs.raku.org/language/grammars#Action_objects) is recommended to be used in conjunction with the grammar. If action objects are not used, `.parse` returns a [Match](https://docs.raku.org/type/Match) object and sets, by default, the [default match object `$/`](https://docs.raku.org/syntax/$$SOLIDUS), to the same value.

<a id="原型化正则--proto-regexes"></a>
## 原型化正则 / Proto regexes

[Grammar](https://docs.raku.org/type/Grammar) 由规则、标记和正则组成；这些实际上是方法，因为 grammar 是类。

[Grammar](https://docs.raku.org/type/Grammar)s are composed of rules, tokens and regexes; these are actually methods, since grammars are classes.

它们实际上是一种特殊的类，但对于该节的其余部分，它们的行为方式与普通类相同。

They are actually a special kind of class, but for the rest of the section, they behave in the same way as a normal class would

这些方法可以共享一个共同的名称和功能，因此可以使用 [proto](https://docs.raku.org/syntax/proto)。

These methods can share a name and functionality in common, and thus can use [proto](https://docs.raku.org/syntax/proto).

例如，如果你有很多替换，那么可能很难生成可读代码或对 grammar 进行子类化。在下面的 `Actions` 类中，`method TOP` 中的三元操作不理想，并且我们添加的操作越多，它就越糟糕：

For instance, if you have a lot of alternations, it may become difficult to produce readable code or subclass your grammar. In the `Actions` class below, the ternary in `method TOP` is less than ideal and it becomes even worse the more operations we add:

```Raku
grammar Calculator {
    token TOP { [ <add> | <sub> ] }
    rule  add { <num> '+' <num> }
    rule  sub { <num> '-' <num> }
    token num { \d+ }
}
 
class Calculations {
    method TOP ($/) { make $<add> ?? $<add>.made !! $<sub>.made; }
    method add ($/) { make [+] $<num>; }
    method sub ($/) { make [-] $<num>; }
}
 
say Calculator.parse('2 + 3', actions => Calculations).made;
 
# OUTPUT: «5␤» 
```

为了使事情变得更好，我们可以在 token 上使用类似于 `:sym<...>` 副词的原型正则：

To make things better, we can use proto regexes that look like `:sym<...>` adverbs on tokens:

```Raku
grammar Calculator {
    token TOP { <calc-op> }
 
    proto rule calc-op          {*}
          rule calc-op:sym<add> { <num> '+' <num> }
          rule calc-op:sym<sub> { <num> '-' <num> }
 
    token num { \d+ }
}

class Calculations {
    method TOP              ($/) { make $<calc-op>.made; }
    method calc-op:sym<add> ($/) { make [+] $<num>; }
    method calc-op:sym<sub> ($/) { make [-] $<num>; }
}

say Calculator.parse('2 + 3', actions => Calculations).made;
 
# OUTPUT: «5␤»
```

在这种 grammar 中，多匹配模式现在已被替换为 `<calc-op>`，它本质上是我们将创建的一组值的名称。我们通过使用 `proto rule calc-op` 定义规则原型来实现这一点。在这之前的每一个匹配模式都被一个新的 `rule calc-op` 定义所取代，并且这个替换的名称附加了 `:sym<>` 副词。

In this grammar the alternation has now been replaced with `<calc-op>`, which is essentially the name of a group of values we'll create. We do so by defining a rule prototype with `proto rule calc-op`. Each of our previous alternations have been replaced by a new `rule calc-op` definition and the name of the alternation is attached with `:sym<>` adverb.

在声明操作的类中，我们现在摆脱了三元运算符，只从 `$<calc-op>` 匹配对象中获取 `.made` 值。现在，单个匹配模式的操作遵循与 grammar 中相同的命名模式：`method calc-op:sym<add>` 和 `method calc-op:sym<sub>`。

In the class that declares actions, we now got rid of the ternary operator and simply take the `.made` value from the `$<calc-op>` match object. And the actions for individual alternations now follow the same naming pattern as in the grammar: `method calc-op:sym<add>` and `method calc-op:sym<sub>`.

当你对 grammar 和动作类进行子类化时，可以看到这个方法的真正优点。假设我们要向计算器添加乘法功能：

The real beauty of this method can be seen when you subclass that grammar and actions class. Let's say we want to add a multiplication feature to the calculator:

```Raku
grammar BetterCalculator is Calculator {
    rule calc-op:sym<mult> { <num> '*' <num> }
}

class BetterCalculations is Calculations {
    method calc-op:sym<mult> ($/) { make [*] $<num> }
}

say BetterCalculator.parse('2 * 3', actions => BetterCalculations).made;
 
# OUTPUT: «6␤» 
```

我们需要添加的只是 `calc-op` 组中的附加规则和操作，这一切都要归功于原型正则。

All we had to add are additional rule and action to the `calc-op` group and the thing works—all thanks to proto regexes.

<a id="特殊标记--special-tokens"></a>
## 特殊标记 / Special tokens

<a id="top"></a>
### `TOP`

```Raku
grammar Foo {
    token TOP { \d+ }
}
```

`TOP` 标记是用 grammar 分析时尝试匹配的默认第一个标记。请注意，如果使用 [`.parse`](https://docs.raku.org/type/Grammar#method_parse) 方法进行分析，`token TOP` 将自动锚定到字符串的开头和结尾。如果你不想解析整个字符串，请查看 [`.subparse`](https://docs.raku.org/type/Grammar#method_subparse)。

The `TOP` token is the default first token attempted to match when parsing with a grammar. Note that if you're parsing with [`.parse`](https://docs.raku.org/type/Grammar#method_parse) method, `token TOP` is automatically anchored to the start and end of the string. If you don't want to parse the whole string, look up [`.subparse`](https://docs.raku.org/type/Grammar#method_subparse).

也可以使用 `rule TOP` 或者 `regex TOP`。

Using `rule TOP` or `regex TOP` are also acceptable.

可以首先使用 `:rule` 命名参数选择与 `.parse`、`.subparse` 或 `.parsefile` 匹配的其他 token。这些都是 `Grammar` 方法。

A different token can be chosen to be matched first using the `:rule` named argument to `.parse`, `.subparse`, or `.parsefile`. These are all `Grammar` methods.

<a id="ws"></a>
### `ws`

默认的 `ws` 匹配零个或多个空格字符，只要不在单词中（用代码来表示，这相当于 `regex ws { <!ww> \s* }`）：

The default `ws` matches zero or more whitespace characters, as long as that point is not within a word (in code form, that's `regex ws { <!ww> \s* }`):

```Raku
# First <.ws> matches word boundary at the start of the line 
# and second <.ws> matches the whitespace between 'b' and 'c' 
say 'ab   c' ~~ /<.ws> ab <.ws> c /; # OUTPUT: «｢ab   c｣␤» 

# Failed match: there is neither any whitespace nor a word 
# boundary between 'a' and 'b' 
say 'ab' ~~ /. <.ws> b/;             # OUTPUT: «Nil␤» 

# Successful match: there is a word boundary between ')' and 'b' 
say ')b' ~~ /. <.ws> b/;             # OUTPUT: «｢)b｣␤» 
```

请记住，我们在 `ws` 前面加了一个点以避免捕获。因为一般来说，空白是一个分隔符。

Please bear in mind that we're preceding `ws` with a dot to avoid capturing, which we are not interested in. Since in general whitespace is a separator, this is how it's mostly found.

当使用 `rule` 而不是 `token` 时，`:sigspace` 在默认情况下是启用的，并且术语和右括号/方括号后的任何空白都将变成对 `ws` 的非捕获调用，写为 `<.ws>`。 其中 `.` 表示非捕获。也就是说：

When `rule` instead of `token` is used, `:sigspace` is enabled by default and any whitespace after terms and closing parenthesis/brackets is turned into a non-capturing call to `ws`, written as `<.ws>` where `.` means non-capturing. That is to say:

```Raku
rule entry { <key> '=' <value> }
```

相当于：

Is the same as:

```Raku
token entry { <key> <.ws> '=' <.ws> <value> <.ws> }
```

你也可以重新定义默认的 `ws` token：

You can also redefine the default `ws` token:

```Raku
grammar Foo {
    rule TOP { \d \d }
}.parse: "4   \n\n 5"; # Succeeds 

grammar Bar {
    rule TOP { \d \d }
    token ws { \h*   }
}.parse: "4   \n\n 5"; # Fails 
```

甚至可以捕获它，但是需要明确使用它：

And even capture it, but you need to use it explicitly:

```Raku
grammar Foo { rule TOP {\d <ws> \d} };
my $parsed = Foo.parse: "3 3";
say $parsed<ws>; # OUTPUT: «｢｣␤» 
```

<a id="sym"></a>
### `sym`

在原型正则中可以使用 `<sym>` token 来匹配特定正则的 `:sym` 副词的字符串值：

The `<sym>` token can be used inside proto regexes to match the string value of the `:sym` adverb for that particular regex:
 
```Raku
grammar Foo {
    token TOP { <letter>+ }
    proto token letter {*}
    token letter:sym<P> { <sym> }
    token letter:sym<e> { <sym> }
    token letter:sym<r> { <sym> }
    token letter:sym<l> { <sym> }
    token letter:sym<*> {   .   }
}.parse("I ♥ Perl", actions => class {
    method TOP($/) { make $<letter>.grep(*.<sym>).join }
}).made.say; # OUTPUT: «Perl␤» 
```

当你已经用要匹配的字符串来区分原型正则时，这很有用，因为使用 `<sym>` token 可以防止重复这些字符串。

This comes in handy when you're already differentiating the proto regexes with the strings you're going to match, as using `<sym>` token prevents repetition of those strings.

<a id="“总是成功”断言--always-succeed-assertion"></a>
### “总是成功”断言 / "Always succeed" assertion

`<?>` 是*总是成功*的断言。当用作 grammar token 时，它可以用于触发 Action 类方法。在下面的 grammar 中，我们寻找阿拉伯数字，并用“总是成功”断言定义一个 `succ` token。

The `<?>` is the *always succeed* assertion. When used as a grammar token, it can be used to trigger an Action class method. In the following grammar we look for Arabic digits and define a `succ` token with the always succeed assertion.

在 action 类中，我们使用对 `succ` 方法的调用来进行设置（在本例中，我们在 `@!numbers` 中准备了一个新元素）。在 `digit` 方法中，我们将阿拉伯数字用作天成文书数字列表的索引，并将其添加到 `@!numbers` 的最后一个元素中.由于 `succ`，最后一个元素将始终是当前分析的 `digit` 数字。

In the action class, we use calls to the `succ` method to do set up (in this case, we prepare a new element in `@!numbers`). In the `digit` method, we use the Arabic digit as an index into a list of Devanagari digits and add it to the last element of `@!numbers`. Thanks to `succ`, the last element will always be the number for the currently parsed `digit` digits.

```Raku
grammar Digifier {
    rule TOP {
        [ <.succ> <digit>+ ]+
    }
    token succ   { <?> }
    token digit { <[0..9]> }
}
 
class Devanagari {
    has @!numbers;
    method digit ($/) { @!numbers.tail ~= <०  १  २  ३  ४  ५  ६  ७  ८  ९>[$/] }
    method succ  ($)  { @!numbers.push: ''     }
    method TOP   ($/) { make @!numbers[^(*-1)] }
}
 
say Digifier.parse('255 435 777', actions => Devanagari.new).made;
# OUTPUT: «(२५५ ४३५ ७७७)␤»  
```

<a id="grammar-中的方法--methods-in-grammars"></a>
## grammar 中的方法 / Methods in grammars

在 grammar 中使用方法而不是 rule 或 token 是很好的，只要它们返回一个 [Match](https://docs.raku.org/type/Match)：

It's fine to use methods instead of rules or tokens in a grammar, as long as they return a [Match](https://docs.raku.org/type/Match):

```Raku
grammar DigitMatcher {
    method TOP (:$full-unicode) {
        $full-unicode ?? self.num-full !! self.num-basic;
    }
    token num-full  { \d+ }
    token num-basic { <[0..9]>+ }
}
```

上面的 grammar 将根据解析方法提供的参数尝试不同的匹配：

The grammar above will attempt different matches depending on the arguments provided by parse methods:

```Raku
say +DigitMatcher.subparse: '12७१७९०९', args => \(:full-unicode);
# OUTPUT: «12717909␤» 
 
say +DigitMatcher.subparse: '12७१७९०९', args => \(:!full-unicode);
# OUTPUT: «12␤» 
```

<a id="grammar-中的动态变量--dynamic-variables-in-grammars"></a>
## grammar 中的动态变量 / Dynamic variables in grammars

通过在定义变量的代码行前面加前缀 `:` 可以在 token 中定义变量。在 token 的任何位置都可以放置用大括号包起来的任意代码。这对于保持 token 之间的状态很有用，可以用来改变语法解析文本的方式。在 token 中使用动态变量（变量带有 `$*`、`@*`、`&*`、`%*` 符号）级联到其后在其定义的 token 中定义的*所有* token，避免将它们作为参数从一个 token 传递到另一个 token。

Variables can be defined in tokens by prefixing the lines of code defining them with `:`. Arbitrary code can be embedded anywhere in a token by surrounding it with curly braces. This is useful for keeping state between tokens, which can be used to alter how the grammar will parse text. Using dynamic variables (variables with `$*`, `@*`, `&*`, `%*` twigils) in tokens cascades down through *all* tokens defined thereafter within the one where it's defined, avoiding having to pass them from token to token as arguments.

动态变量的一个用途是作为匹配项的 guards。此示例使用 guards 解释哪些正则类从字面上解析空白：

One use for dynamic variables is guards for matches. This example uses guards to explain which regex classes parse whitespace literally:

```Raku
grammar GrammarAdvice {
    rule TOP {
        :my Int $*USE-WS;
        "use" <type> "for" <significance> "whitespace by default"
    }
    token type {
        | "rules"   { $*USE-WS = 1 }
        | "tokens"  { $*USE-WS = 0 }
        | "regexes" { $*USE-WS = 0 }
    }
    token significance {
        | <?{ $*USE-WS == 1 }> "significant"
        | <?{ $*USE-WS == 0 }> "insignificant"
    }
}
```

这里，像 "use rules for significant whitespace by default" 这样的文本仅在提到 rule、 token 或 regex 时所分配的状态与正确的 guard 匹配时才匹配：

Here, text such as "use rules for significant whitespace by default" will only match if the state assigned by whether rules, tokens, or regexes are mentioned matches with the correct guard:

```Raku
say GrammarAdvice.subparse("use rules for significant whitespace by default");
# OUTPUT: «use rules for significant whitespace by default» 
 
say GrammarAdvice.subparse("use tokens for insignificant whitespace by default");
# OUTPUT: «use tokens for insignificant whitespace by default» 
 
say GrammarAdvice.subparse("use regexes for insignificant whitespace by default");
# OUTPUT: «use regexes for insignificant whitespace by default» 
 
say GrammarAdvice.subparse("use regexes for significant whitespace by default")
# OUTPUT: #<failed match> 
```

<a id="grammar-中的属性--attributes-in-grammars"></a>
## grammar 中的属性 / Attributes in grammars

属性可以在 grammar 中定义。但是，只能通过方法访问它们。试图从令牌中使用它们将引发异常，因为 method 是 [Match](https://docs.raku.org/type/Match)，而不是 grammar 本身。注意，从一个在 token 中调用的方法中改变一个属性将*只修改该 token 自己的匹配对象*的属性！ grammar 属性可以在解析后返回的匹配项中访问，如果公开：

Attributes may be defined in grammars. However, they can only be accessed by methods. Attempting to use them from within a token will throw an exception because tokens are methods of [Match](https://docs.raku.org/type/Match), not of the grammar itself. Note that mutating an attribute from within a method called in a token will *only modify the attribute for that token's own match object*! Grammar attributes can be accessed in the match returned after parsing if made public:

```Raku
grammar HTTPRequest {
    has Bool $.invalid;
 
    token TOP {
        <type> <path> 'HTTP/1.1' \r\n
        [<field> \r\n]+
        \r\n
        $<body>=.*
    }
 
    token type {
        | GET | POST | OPTIONS | HEAD | PUT | DELETE | TRACE | CONNECT
        | \S+ <.error>
    }
 
    token path {
        | '/' [[\w+]+ % \/] [\.\w+]?
        | '*'
        | \S+ <.error>
    }
 
    token field {
        | $<name>=\w+ : $<value>=<-[\r\n]>*
        | <-[\r\n]>+ <.error>
    }
 
    method error(--> ::?CLASS:D) {
        $!invalid = True;
        self;
    }
}
 
my $header = "MEOWS / HTTP/1.1\r\nHost: docs.raku.org\r\nsup lol\r\n\r\n";
my $/ = HTTPRequest.parse($header);
say $<type>.invalid;
# OUTPUT: True 
say $<path>.invalid;
# OUTPUT: (Bool) 
say $<field>».invalid;
# OUTPUT: [(Bool) True] 
```

<a id="传递参数给-grammar--passing-arguments-into-grammars"></a>
## 传递参数给 grammar / Passing arguments into grammars

To pass arguments into a grammar, you can use the named argument of `:args` on any of the parsing methods of grammar. The arguments passed should be in a `list`.

```Raku
grammar demonstrate-arguments {
    rule TOP ($word) {
        "I like" $word
    }
}
 
# Notice the comma after "sweets" when passed to :args to coerce it to a list 
say demonstrate-arguments.parse("I like sweets", :args(("sweets",)));
# OUTPUT: «｢I like sweets｣␤» 
```

一旦参数传入，就可以在对 grammar 中的命名正则的调用中使用它们。

Once the arguments are passed in, they can be used in a call to a named regex inside the grammar.

```Raku
grammar demonstrate-arguments-again {
    rule TOP ($word) {
        <phrase-stem><added-word($word)>
    }
 
    rule phrase-stem {
       "I like"
    }
 
    rule added-word($passed-word) {
       $passed-word
    }
}
 
say demonstrate-arguments-again.parse("I like vegetables", :args(("vegetables",)));
# OUTPUT: ｢I like vegetables｣␤» 
# OUTPUT:  «phrase-stem => ｢I like ｣␤» 
# OUTPUT:  «added-word => ｢vegetables｣␤» 
```

或者，你可以初始化动态变量，并在 grammar 中以这种方式使用任何参数。

Alternatively, you can initialize dynamic variables and use any arguments that way within the grammar.

```Raku
grammar demonstrate-arguments-dynamic {
   rule TOP ($*word, $*extra) {
      <phrase-stem><added-words>
   }
   rule phrase-stem {
      "I like"
   }
   rule added-words {
      $*word $*extra
   }
}
 
say demonstrate-arguments-dynamic.parse("I like everything else",
  :args(("everything", "else")));
# OUTPUT: «｢I like everything else｣␤» 
# OUTPUT:  «phrase-stem => ｢I like ｣␤» 
# OUTPUT:  «added-words => ｢everything else｣␤» 
```

<a id="action-对象--action-objects"></a>
# Action 对象 / Action objects

成功的 grammar 匹配为你提供了一个 [Match](https://docs.raku.org/type/Match) 对象的解析树，匹配树得到的深度越深，语法中的分支越多，浏览匹配树获得你真正感兴趣的信息就越困难。

A successful grammar match gives you a parse tree of [Match](https://docs.raku.org/type/Match) objects, and the deeper that match tree gets, and the more branches in the grammar are, the harder it becomes to navigate the match tree to get the information you are actually interested in.

为了避免深入到匹配树中，可以提供一个*操作*对象。每次成功解析语法中的命名规则后，它都会尝试调用与语法规则同名的方法，并将新创建的 [Match](https://docs.raku.org/type/Match) 对象作为位置参数。如果不存在这样的方法，则跳过它。

To avoid the need for diving deep into a match tree, you can supply an *actions* object. After each successful parse of a named rule in your grammar, it tries to call a method of the same name as the grammar rule, giving it the newly created [Match](https://docs.raku.org/type/Match) object as a positional argument. If no such method exists, it is skipped.

下面是一个精心设计的 grammar 和实际操作示例：

Here is a contrived example of a grammar and actions in action:

```Raku
grammar TestGrammar {
    token TOP { \d+ }
}
 
class TestActions {
    method TOP($/) {
        $/.make(2 + $/);
    }
}
 
my $match = TestGrammar.parse('40', actions => TestActions.new);
say $match;         # OUTPUT: «｢40｣␤» 
say $match.made;    # OUTPUT: «42␤» 
```

`TestActions` 实例作为命名参数 `actions` 传递给 [parse](https://docs.raku.org/routine/parse) 调用，当 token `TOP` 匹配成功时，它自动调用方法 `TOP`，将匹配对象作为参数传递。

An instance of `TestActions` is passed as named argument `actions` to the [parse](https://docs.raku.org/routine/parse) call, and when token `TOP` has matched successfully, it automatically calls method `TOP`, passing the match object as an argument.

为了清楚地表明参数是匹配对象，该示例使用 `$/` 作为操作方法的参数名，尽管这只是一个方便的约定，但并不是内在的。`$match` 也可以。（尽管使用 `$/` 确实提供了 `$<capture>` 作为 `$/<capture>` 的快捷方式的优势）。

To make it clear that the argument is a match object, the example uses `$/` as a parameter name to the action method, though that's just a handy convention, nothing intrinsic. `$match` would have worked too. (Though using `$/` does give the advantage of providing `$<capture>` as a shortcut for `$/<capture>`).

下面是一个稍微复杂一些的例子：

A slightly more involved example follows:

```Raku
grammar KeyValuePairs {
    token TOP {
        [<pair> \n+]*
    }
 
    token ws {
        \h*
    }
 
    rule pair {
        <key=.identifier> '=' <value=.identifier>
    }
    token identifier {
        \w+
    }
}
 
class KeyValuePairsActions {
    method pair      ($/) {
        $/.make: $<key>.made => $<value>.made
    }
    method identifier($/) {
        # subroutine `make` is the same as calling .make on $/ 
        make ~$/
    }
    method TOP ($match) {
        # can use any variable name for parameter, not just $/ 
        $match.make: $match<pair>».made
    }
}
 
my $actions = KeyValuePairsActions;
my $res = KeyValuePairs.parse(q:to/EOI/, :$actions).made; 
    second=b
    hits=42
    perl=6
    EOI
 
for @$res -> $p {
    say "Key: $p.key()\tValue: $p.value()";
}
```

这将产生以下输出：

This produces the following output:

```Raku
Key: second     Value: b
Key: hits       Value: 42
Key: perl       Value: 6
```

Rule `pair` 解析由等号分隔的 pair，它为对 token `identifier` 的两个调用起别名，以分离捕获名称，使它们更容易和直观地可用。相应的操作方法构造一个 [Pair](https://docs.raku.org/type/Pair) 对象，并使用子匹配对象的 `.made` 属性。所以它（和操作方法 `TOP` 一样）利用了这样一个事实：子匹配的操作方法调用发生在外部正则或者调用者之前。因此，操作方法按 [post-order](https://en.wikipedia.org/wiki/Tree_traversal#Post-order) 调用。

Rule `pair`, which parsed a pair separated by an equals sign, aliases the two calls to token `identifier` to separate capture names to make them available more easily and intuitively. The corresponding action method constructs a [Pair](https://docs.raku.org/type/Pair) object, and uses the `.made` property of the sub match objects. So it (like the action method `TOP` too) exploits the fact that action methods for submatches are called before those of the calling/outer regex. So action methods are called in [post-order](https://en.wikipedia.org/wiki/Tree_traversal#Post-order).

操作方法 `TOP` 只收集由 `pair` rule 的多个匹配项通过方法 `.made` 生成的所有对象，并在列表中返回它们。

The action method `TOP` simply collects all the objects that were `.made` by the multiple matches of the `pair` rule, and returns them in a list.

还请注意，`KeyValuePairsActions` 作为类型对象传递给方法 `parse`，这是可能的，因为没有任何操作方法使用属性（只有在实例中才可用）。

Also note that `KeyValuePairsActions` was passed as a type object to method `parse`, which was possible because none of the action methods use attributes (which would only be available in an instance).

在其他情况下，操作方法可能希望在属性中保持状态。当然，你必须将实例传递给方法 parse。

In other cases, action methods might want to keep state in attributes. Then of course you must pass an instance to method parse.

注意，`token` `ws` 是特殊的：当启用了 `:sigspace` 时（我们使用的是 `rule`），它将替换某些空白序列。这就是为什么等号周围的空格在 `rule pair` 中工作得很好，以及为什么在 `token TOP` 中查找的换行符在结尾 `}` 前的空格不会被吞没的原因。

Note that `token` `ws` is special: when `:sigspace` is enabled (and it is when we are using `rule`), it replaces certain whitespace sequences. This is why the spaces around the equals sign in `rule pair` work just fine and why the whitespace before closing `}`does not gobble up the newlines looked for in `token TOP`.