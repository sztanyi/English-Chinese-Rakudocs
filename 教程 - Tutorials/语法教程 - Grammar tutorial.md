原文：https://docs.raku.org/language/grammar_tutorial

# 语法教程 / Grammar tutorial

语法概论

An introduction to grammars

<!-- MarkdownTOC -->

- [开始之前 / Before we start](#%E5%BC%80%E5%A7%8B%E4%B9%8B%E5%89%8D--before-we-start)
    - [为什么是语法？ / Why grammars?](#%E4%B8%BA%E4%BB%80%E4%B9%88%E6%98%AF%E8%AF%AD%E6%B3%95%EF%BC%9F--why-grammars)
    - [我什么时候用语法？ / When would I use grammars?](#%E6%88%91%E4%BB%80%E4%B9%88%E6%97%B6%E5%80%99%E7%94%A8%E8%AF%AD%E6%B3%95%EF%BC%9F--when-would-i-use-grammars)
    - [语法的广义概念 / The broad concept of grammars](#%E8%AF%AD%E6%B3%95%E7%9A%84%E5%B9%BF%E4%B9%89%E6%A6%82%E5%BF%B5--the-broad-concept-of-grammars)
- [变得更技术性 / Getting more technical](#%E5%8F%98%E5%BE%97%E6%9B%B4%E6%8A%80%E6%9C%AF%E6%80%A7--getting-more-technical)
    - [概念概述 / The conceptual overview](#%E6%A6%82%E5%BF%B5%E6%A6%82%E8%BF%B0--the-conceptual-overview)
    - [技术概述 / The technical overview](#%E6%8A%80%E6%9C%AF%E6%A6%82%E8%BF%B0--the-technical-overview)
- [案例学习 - REST 设计 / Learning by example - a REST contrivance](#%E6%A1%88%E4%BE%8B%E5%AD%A6%E4%B9%A0---rest-%E8%AE%BE%E8%AE%A1--learning-by-example---a-rest-contrivance)
    - [增加一些灵活性 / Adding some flexibility](#%E5%A2%9E%E5%8A%A0%E4%B8%80%E4%BA%9B%E7%81%B5%E6%B4%BB%E6%80%A7--adding-some-flexibility)
    - [从语法继承 / Inheriting from a grammar](#%E4%BB%8E%E8%AF%AD%E6%B3%95%E7%BB%A7%E6%89%BF--inheriting-from-a-grammar)
    - [添加一些约束 / Adding some constraints](#%E6%B7%BB%E5%8A%A0%E4%B8%80%E4%BA%9B%E7%BA%A6%E6%9D%9F--adding-some-constraints)
    - [把我们的 RESTful 语法放在一起 / Putting our RESTful grammar together](#%E6%8A%8A%E6%88%91%E4%BB%AC%E7%9A%84-restful-%E8%AF%AD%E6%B3%95%E6%94%BE%E5%9C%A8%E4%B8%80%E8%B5%B7--putting-our-restful-grammar-together)
- [语法动作 / Grammar actions](#%E8%AF%AD%E6%B3%95%E5%8A%A8%E4%BD%9C--grammar-actions)
    - [有动作的语法示例 / Grammars by example with actions](#%E6%9C%89%E5%8A%A8%E4%BD%9C%E7%9A%84%E8%AF%AD%E6%B3%95%E7%A4%BA%E4%BE%8B--grammars-by-example-with-actions)
    - [用 `make` 和 `made` 保持语法与动作的整洁 / Keeping grammars with actions tidy with `make` and `made`](#%E7%94%A8-make-%E5%92%8C-made-%E4%BF%9D%E6%8C%81%E8%AF%AD%E6%B3%95%E4%B8%8E%E5%8A%A8%E4%BD%9C%E7%9A%84%E6%95%B4%E6%B4%81--keeping-grammars-with-actions-tidy-with-make-and-made)
    - [直接添加动作 / Add actions directly](#%E7%9B%B4%E6%8E%A5%E6%B7%BB%E5%8A%A0%E5%8A%A8%E4%BD%9C--add-actions-directly)

<!-- /MarkdownTOC -->


<a id="%E5%BC%80%E5%A7%8B%E4%B9%8B%E5%89%8D--before-we-start"></a>
# 开始之前 / Before we start

<a id="%E4%B8%BA%E4%BB%80%E4%B9%88%E6%98%AF%E8%AF%AD%E6%B3%95%EF%BC%9F--why-grammars"></a>
## 为什么是语法？ / Why grammars?

语法分析字符串并从这些字符串返回数据结构。语法可以用来准备一个程序执行，决定一个程序是否可以运行（如果它是一个有效的程序），把一个网页分解成各个组成部分，或者识别一个句子的不同部分，等等。

Grammars parse strings and return data structures from those strings. Grammars can be used to prepare a program for execution, to determine if a program can run at all (if it's a valid program), to break down a web page into constituent parts, or to identify the different parts of a sentence, among other things.

<a id="%E6%88%91%E4%BB%80%E4%B9%88%E6%97%B6%E5%80%99%E7%94%A8%E8%AF%AD%E6%B3%95%EF%BC%9F--when-would-i-use-grammars"></a>
## 我什么时候用语法？ / When would I use grammars?

如果要驯服或解释字符串，语法将提供执行该任务的工具。

If you have strings to tame or interpret, grammars provide the tools to do the job.

这个字符串可能是一个文件，你希望将其分成几个部分；可能是一个协议，如 SMTP，你需要指定哪些“命令”来自于用户提供的数据；可能是你正在设计自己的特定域语言。语法可以帮助你。

The string could be a file that you're looking to break into sections; perhaps a protocol, like SMTP, where you need to specify which "commands" come after what user-supplied data; maybe you're designing your own domain specific language. Grammars can help.

<a id="%E8%AF%AD%E6%B3%95%E7%9A%84%E5%B9%BF%E4%B9%89%E6%A6%82%E5%BF%B5--the-broad-concept-of-grammars"></a>
## 语法的广义概念 / The broad concept of grammars

正则表达式（[Regexes](https://docs.raku.org/language/regexes)）对于在字符串中查找模式非常有效。但是，对于某些任务，比如一次找到多个模式，或者组合模式，或者测试可能围绕字符串正则表达式的模式，仅仅这样做是不够的。

Regular expressions ([Regexes](https://docs.raku.org/language/regexes)) work well for finding patterns in strings. However, for some tasks, like finding multiple patterns at once, or combining patterns, or testing for patterns that may surround strings regular expressions, alone, are not enough.

使用 HTML 时，可以定义语法来识别 HTML 标记，包括开头和结尾元素以及中间的文本。然后，可以将这些元素组织到数据结构中，如数组或散列。

When working with HTML, you could define a grammar to recognize HTML tags, both the opening and closing elements, and the text in between. You could then organize these elements into data structures, such as arrays or hashes.

<a id="%E5%8F%98%E5%BE%97%E6%9B%B4%E6%8A%80%E6%9C%AF%E6%80%A7--getting-more-technical"></a>
# 变得更技术性 / Getting more technical

<a id="%E6%A6%82%E5%BF%B5%E6%A6%82%E8%BF%B0--the-conceptual-overview"></a>
## 概念概述 / The conceptual overview

语法是一门特殊的类。除了使用 *grammar* 关键字而不是 *class* 之外，你可以像其他任何类一样声明和定义语法。

Grammars are a special kind of class. You declare and define a grammar exactly as you would any other class, except that you use the *grammar* keyword instead of *class*.

```Raku
grammar G { ... }
```

作为这样的类，语法由定义正则表达式、标记或规则的方法组成。这些都是各种不同类型的匹配方法。一旦定义了一个语法，就可以传入一个字符串用 parse 方法进行解析。

As such classes, grammars are made up of methods that define a regex, a token, or a rule. These are all varieties of different types of match methods. Once you have a grammar defined, you call it and pass in a string for parsing.

```Raku
my $matchObject = G.parse($string);
```

现在，你可能想知道，如果我定义了所有这些只返回结果的正则表达式，这对解析另一个字符串中可能在前面或后面的字符串，或者需要从这些正则表达式中组合的内容有何帮助。这就是语法动作的来源。

Now, you may be wondering, if I have all these regexes defined that just return their results, how does that help with parsing strings that may be ahead or backwards in another string, or things that need to be combined from many of those regexes... And that's where grammar actions come in.

对于语法中匹配的每一个“方法”，都会得到一个可用于对该匹配进行操作的操作。你还可以获得一个总体操作，用于将所有匹配项绑定在一起并构建数据结构。默认情况下，此总体方法称为 `TOP`。

For every "method" you match in your grammar, you get an action you can use to act on that match. You also get an overarching action that you can use to tie together all your matches and to build a data structure. This overarching method is called `TOP` by default.

<a id="%E6%8A%80%E6%9C%AF%E6%A6%82%E8%BF%B0--the-technical-overview"></a>
## 技术概述 / The technical overview

如前所述，语法使用 *grammar* 关键字声明，其“方法”使用 *regex*、*token* 或 *rule* 声明。

As already mentioned, grammars are declared using the *grammar* keyword and its "methods" are declared with *regex*, or *token*, or *rule*.

- regex 方法很慢但很彻底，它会回头看字符串，很努力地尝试匹配。
- token 方法比 regex 方法快，并且忽略空白。
- rule 方法与 token 方法相同，只是不忽略空白。

<br/>

- Regex methods are slow but thorough, they will look back in the string and really try.
- Token methods are faster than regex methods and ignore whitespace.
- Rule methods are the same as token methods except whitespace is not ignored.

当一个方法（regex、token 或 rule）在语法中匹配时，匹配的字符串被放入[匹配对象](https://docs.raku.org/type/Match)中，其键与方法名相同。

When a method (regex, token or rule) matches in the grammar, the string matched is put into a [match object](https://docs.raku.org/type/Match) and keyed with the same name as the method.

```Raku
grammar G {
    token TOP { <thingy> .* }
    token thingy { 'clever_text_keyword' }
}
```

如果你要使用 `my $match = G.parse($string)`，并且你的字符串以 'clever_text_keyword' 开头，那么你将得到一个包含 'clever_text_keyword' 的匹配对象，`<thingy>` 为该对象的键。例如：

If you were to use `my $match = G.parse($string)` and your string started with 'clever_text_keyword', you would get a match object back that contained 'clever_text_keyword' keyed by the name of `<thingy>` in your match object. For instance:

```Raku
grammar G {
    token TOP { <thingy> .* }
    token thingy { 'Þor' }
}
 
my $match = G.parse("Þor is mighty");
say $match.perl;     # OUTPUT: «Match.new(made => Any, pos => 13, orig => "Þor is mighty",...» 
say $/.perl;         # OUTPUT: «Match.new(made => Any, pos => 13, orig => "Þor is mighty",...» 
say $/<thingy>.perl;
# OUTPUT: «Match.new(made => Any, pos => 3, orig => "Þor is mighty", hash => Map.new(()), list => (), from => 0)␤» 
```

前两个输出行显示 `$match` 包含一个带有解析结果的 `Match` 对象；但是这些结果也分配给[匹配变量 `$/`](https://docs.raku.org/syntax/$$SOLIDUS)。两者都可以通过键访问，如上面所示。可以通过 `thingy` 键访问以返回特定 `token` 的匹配对象。

The two first output lines show that `$match` contains a `Match` objects with the results of the parsing; but those results are also assigned to the [match variable `$/`](https://docs.raku.org/syntax/$$SOLIDUS). Either match object can be keyed, as indicated above, by `thingy` to return the match for that particular `token`.

`TOP` 方法（无论是 regex、token 还是 rule）是必须匹配一切（默认情况下）的总体模式。如果已解析的字符串与顶部正则表达式不匹配，则返回的Match对象将为空（`NIL`）。

The `TOP` method (whether regex, token, or rule) is the overarching pattern that must match everything (by default). If the parsed string doesn't match the TOP regex, your returned match object will be empty (`Nil`).

如上文所示，在 `TOP` 中，提到了 `<thingy>` token。`<thingy>` 在下一行中定义。这意味着 `'clever_text_keyword'` **必须**是字符串的开头，否则语法解析将失败，我们将得到一个空匹配。这对于识别应该丢弃的格式错误的字符串非常有用。

As you can see above, in `TOP`, the `<thingy>` token is mentioned. The `<thingy>` is defined on the next line. That means that `'clever_text_keyword'` **must** be the first thing in the string, or the grammar parse will fail and we'll get an empty match. This is great for recognizing a malformed string that should be discarded.

<a id="%E6%A1%88%E4%BE%8B%E5%AD%A6%E4%B9%A0---rest-%E8%AE%BE%E8%AE%A1--learning-by-example---a-rest-contrivance"></a>
# 案例学习 - REST 设计 / Learning by example - a REST contrivance

假设我们希望将 URI 解析为构成 RESTful 请求的组件部分。我们希望 URI 像这样工作：

Let's suppose we'd like to parse a URI into the component parts that make up a RESTful request. We want the URIs to work like this:

- URI 的第一部分将是“主题”，就像一个组件、一个产品或一个人。
- URI 的第二部分是“命令”，这是标准的 CRUD 函数（创建、检索、更新或删除）。
- URI 的第三部分将是任意数据，可能是我们将要使用的特定 ID，或者是由 "/" 分隔的一长串数据。
- 当我们得到一个 URI 时，我们希望将上面的 1-3 放在一个数据结构中，我们可以很容易地使用这个结构（并在以后进行增强）。

<br/>

- The first part of the URI will be the "subject", like a part, or a product, or a person.
- The second part of the URI will be the "command", the standard CRUD functions (create, retrieve, update, or delete).
- The third part of the URI will be arbitrary data, perhaps the specific ID we'll be working with or a long list of data separated by "/"'s.
- When we get a URI, we'll want 1-3 above to be placed into a data structure that we can easily work with (and later enhance).

因此，如果我们有 "/product/update/7/notify"，那么我们希望语法给出一个匹配的对象，该对象主题为 "product"、命令为 "update" 并且数据为 "7/notify"。

So, if we have "/product/update/7/notify", we would want our grammar to give us a match object that has a `subject` of "product", a `command` of "update", and `data` of "7/notify".

我们将通过为主题、命令和数据定义语法类和一些匹配方法而开始。我们将使用 token 声明器，因为我们不关心空白。

We'll start by defining a grammar class and some match methods for the subject, command, and data. We'll use the token declarator since we don't care about whitespace.

```Raku
grammar REST {
    token subject { \w+ }
    token command { \w+ }
    token data    { .* }
}
```

到目前为止，这个 REST 语法表示我们需要一个主题，它将是*单词*，命令也将是*单词*，而数据将是字符串中剩下的所有内容。

So far, this REST grammar says we want a subject that will be just *word* characters, a command that will be just *word* characters, and data that will be everything else left in the string.

接下来，我们希望在 URI 的更大上下文中安排这些匹配的 token。这就是 TOP 方法允许我们做的。我们将添加 TOP 方法，并将标记的名称与构成整个模式的其余模式一起放在其中。请注意，我们是如何从命名正则构建更大的正则表达式的。

Next, we'll want to arrange these matching tokens within the larger context of the URI. That's what the TOP method allows us to do. We'll add the TOP method and place the names of our tokens within it, together with the rest of the patterns that makes up the overall pattern. Note how we're building a larger regex from our named regexes.

```Raku
grammar REST {
    token TOP     { '/' <subject> '/' <command> '/' <data> }
    token subject { \w+ }
    token command { \w+ }
    token data    { .* }
}
```

有了这段代码，我们就可以得到 RESTful 请求的三个部分：

With this code, we can already get the three parts of our RESTful request:

```Raku
my $match = REST.parse('/product/update/7/notify');
say $match;
 
# OUTPUT: «｢/product/update/7/notify｣␤ 
#          subject => ｢product｣ 
#          command => ｢update｣ 
#          data => ｢7/notify｣» 
```

可以通过使用 `$match<subject>` 或 `$match<command>` 或 `$match<data>` 来直接访问数据，以返回所解析的值。它们都包含你可以进一步处理的匹配对象，例如将其转换为字符串（`$match<command>.Str`）。

The data can be accessed directly by using `$match<subject>` or `$match<command>` or `$match<data>` to return the values parsed. They each contain match objects that you can work further with, such as coercing into a string ( `$match<command>.Str` ).

<a id="%E5%A2%9E%E5%8A%A0%E4%B8%80%E4%BA%9B%E7%81%B5%E6%B4%BB%E6%80%A7--adding-some-flexibility"></a>
## 增加一些灵活性 / Adding some flexibility

到目前为止，语法将处理检索、删除和更新。但是，*create* 命令没有第三个部分（*data* 部分）。这意味着如果我们尝试解析创建 URI，则语法将失败。为了避免这种情况，我们需要使最后的 *data* 位置匹配可选，以及前面的 '/'。这通过将问号添加到 TOP token 的分组 '/' 和 *data* 组件来实现，以指示它们的可选性质，就像普通正则表达式一样。

So far, the grammar will handle retrieves, deletes and updates. However, a *create* command doesn't have the third part (the *data* portion). This means the grammar will fail to match if we try to parse a create URI. To avoid this, we need to make that last *data* position match optional, along with the '/' preceding it. This is accomplished by adding a question mark to the grouped '/' and *data* components of the TOP token, to indicate their optional nature, just like a normal regex.

所以，现在我们有：

So, now we have:

```Raku
grammar REST {
    token TOP     { '/' <subject> '/' <command> [ '/' <data> ]? }
    token subject { \w+ }
    token command { \w+ }
    token data    { .* }
}

my $m = REST.parse('/product/create');
say $m<subject>, $m<command>;

# OUTPUT: «｢product｣｢create｣␤» 
```

接下来，假设 URI 将由用户手动输入，并且用户可能会意外地在 '/' 之间放置空格。如果我们想适配这种情况，可以用允许空格的标记 slash 替换 TOP 中的 '/'。

Next, assume that the URIs will be entered manually by a user and that the user might accidentally put spaces between the '/'s. If we wanted to accommodate for this, we could replace the '/'s in TOP with a token that allowed for spaces.

```Raku
grammar REST {
    token TOP     { <slash><subject><slash><command>[<slash><data>]? }
    token subject { \w+ }
    token command { \w+ }
    token data    { .* }
 
    token slash   { \s* '/' \s* }
}

my $m = REST.parse('/ product / update /7 /notify');
say $m;

# OUTPUT: «｢/ product / update /7 /notify｣␤ 
#          slash => ｢/ ｣ 
#          subject => ｢product｣ 
#          slash => ｢ / ｣ 
#          command => ｢update｣ 
#          slash => ｢ /｣ 
#          data => ｢7 /notify｣» 
```

我们现在在匹配对象中得到了一些额外的垃圾，还有那些斜杠。有一些技术可以解决这个问题，我们稍后再谈。

We're getting some extra junk in the match object now, with those slashes. There's techniques to clean that up that we'll get to later.

<a id="%E4%BB%8E%E8%AF%AD%E6%B3%95%E7%BB%A7%E6%89%BF--inheriting-from-a-grammar"></a>
## 从语法继承 / Inheriting from a grammar

由于语法是类，所以从面向对象的角度看，它们的行为方式与任何其他类一样；具体来说，它们可以从包含一些 token 或 rule 的基类继承，这种方式如下：

Since grammars are classes, they behave, OOP-wise, in the same way as any other class; specifically, they can inherit from base classes that include some tokens or rules, this way:

```Raku
grammar Letters {
    token letters { \w+ }
}

grammar Quote-Quotes {
    token quote { "\""|"`"|"'" }
}

grammar Quote-Other {
    token quote { "|"|"/"|"¡" }
}

grammar Quoted-Quotes is Letters is Quote-Quotes {
    token TOP { ^  <quoted> $}
    token quoted { <quote>? <letters> <quote>?  }
}

grammar Quoted-Other is Letters is Quote-Other {
    token TOP { ^  <quoted> $}
    token quoted { <quote>? <letters> <quote>?  }
}

my $quoted = q{"enhanced"};
my $parsed = Quoted-Quotes.parse($quoted);
say $parsed;
#OUTPUT: 
#｢"enhanced"｣ 
# quote => ｢"｣ 
# letters => ｢enhanced｣ 
#quote => ｢"｣ 

$quoted = "|barred|";
$parsed = Quoted-Other.parse($quoted);
say $parsed;
#OUTPUT: 
#|barred|｣ 
#quote => ｢|｣ 
#letters => ｢barred｣ 
#quote => ｢|｣ 
```

本例通过改变与 `quotes` 对应的规则，使用多重继承来组成两种不同的语法。此外，在这种情况下，我们使用的是组合而不是继承，因此我们可以使用角色而不是继承。

This example uses multiple inheritance to compose two different grammars by varying the rules that correspond to `quotes`. In this case, besides, we are rather using composition than inheritance, so we could use Roles instead of inheritance.

```Raku
role Letters {
    token letters { \w+ }
}
 
role Quote-Quotes {
    token quote { "\""|"`"|"'" }
}
 
role Quote-Other {
    token quote { "|"|"/"|"¡" }
}
 
grammar Quoted-Quotes does Letters does Quote-Quotes {
    token TOP { ^  <quoted> $}
    token quoted { <quote>? <letters> <quote>?  }
}
 
grammar Quoted-Other does Letters does Quote-Other {
    token TOP { ^  <quoted> $}
    token quoted { <quote>? <letters> <quote>?  }
 
}
```

输出将与上面的代码完全相同。由于类和角色之间的差异，使用角色组合两次定义 `token quote` 这样的冲突将导致错误：

Will output exactly the same as the code above. Symptomatic of the difference between Classes and Roles, a conflict like defining `token quote` twice using Role composition will result in an error:

```Raku
grammar Quoted-Quotes does Letters does Quote-Quotes does Quote-Other { ... }
# OUTPUT: ... Error while compiling ... Method 'quote' must be resolved ... 
```

<a id="%E6%B7%BB%E5%8A%A0%E4%B8%80%E4%BA%9B%E7%BA%A6%E6%9D%9F--adding-some-constraints"></a>
## 添加一些约束 / Adding some constraints

我们希望 RESTful 语法只允许 CRUD 操作。任何我们想要分析的东西。这意味着我们上面的“命令”应该有四个值之一：创建、检索、更新或删除。

We want our RESTful grammar to allow for CRUD operations only. Anything else we want to fail to parse. That means our "command" above should have one of four values: create, retrieve, update or delete.

有好几种办法完成它。举个例子，可以将 command 方法改变：

There are several ways to accomplish this. For example, you could change the command method:

```Raku
token command { \w+ }
 
# …becomes… 
 
token command { 'create'|'retrieve'|'update'|'delete' }
```

要使 URI 成功解析，'/' 之间的字符串的第二部分必须是那些 CRUD 值之一，否则解析就会失败，这正是我们想要的。

For a URI to parse successfully, the second part of the string between '/'s must be one of those CRUD values, otherwise the parsing fails. Exactly what we want.

当选项越来越大时，还有另一种技术提供了更大的灵活性和更好的可读性：*原型正则*。

There's another technique that provides greater flexibility and improved readability when options grow large: *proto-regexes*.

为了利用这些原型正则表达式（实际上是多个方法）将自己限制在有效的 CRUD 选项上，我们将 `token command` 替换为：

To utilize these proto-regexes (multimethods, in fact) to limit ourselves to the valid CRUD options, we'll replace `token command` with the following:

```Raku
proto token command {*}
token command:sym<create>   { <sym> }
token command:sym<retrieve> { <sym> }
token command:sym<update>   { <sym> }
token command:sym<delete>   { <sym> }
```

`sym` 关键字用于创建各种原型正则选项。每个选项都被命名（例如 `sym<update>`），对于该选项，使用相同名称自动生成特殊的 `<sym>` 标记。

The `sym` keyword is used to create the various proto-regex options. Each option is named (e.g., `sym<update>`), and for that option's use, a special `<sym>` token is auto-generated with the same name.

`<sym>` 标记以及其他用户定义的标记可以用于原型正则选项块中，以定义特定*匹配条件*。正则标记为编译过的形式，并且一旦定义，则随后不能被副词操作（例如 `:i`）修改。因此，当它是自动生成时，特殊的 `<sym>` 标记仅在需要选项名称的精确匹配时才有用。

The `<sym>` token, as well as other user-defined tokens, may be used in the proto-regex option block to define the specific *match condition*. Regex tokens are compiled forms and, once defined, cannot subsequently be modified by adverb actions (e.g., `:i`). Therefore, as it's auto-generated, the special `<sym>` token is useful only where an exact match of the option name is required.

如果，对于一个原型正则选项，出现匹配条件，则整个原型的搜索将终止。匹配数据以匹配对象的形式分配给父原型 token。如果使用了特殊的 `<sym>` 标记并形成了全部或部分实际匹配，则在匹配对象中将其保存为子级别，否则将不存在。

If, for one of the proto-regex options, a match condition occurs, then the whole proto's search terminates. The matching data, in the form of a match object, is assigned to the parent proto token. If the special `<sym>` token was employed and formed all or part of the actual match, then it's preserved as a sub-level in the match object, otherwise it's absent.

使用像这样的原型正则给了我们很多灵活性。例如，与其返回 `<sym>`，在这种情况下是匹配的整个字符串，我们可以改为输入自己的字符串，或者做其他有趣的事情。我们可以用 `token subject` 方法做同样的操作，也可以限制它只正确解析有效的主题（如 'part' 或 'people' 等）。

Using proto-regex like this gives us a lot of flexibility. For example, instead of returning `<sym>`, which in this case is the entire string that was matched, we could instead enter our own string, or do other funny stuff. We could do the same with the `token subject` method and limit it also to only parsing correctly on valid subjects (like 'part' or 'people', etc.).

<a id="%E6%8A%8A%E6%88%91%E4%BB%AC%E7%9A%84-restful-%E8%AF%AD%E6%B3%95%E6%94%BE%E5%9C%A8%E4%B8%80%E8%B5%B7--putting-our-restful-grammar-together"></a>
## 把我们的 RESTful 语法放在一起 / Putting our RESTful grammar together

到目前为止，这就是我们处理 RESTful URI 的方法：

This is what we have for processing our RESTful URIs, so far:

```Raku
grammar REST
{
    token TOP { <slash><subject><slash><command>[<slash><data>]? }
 
    proto token command {*}
    token command:sym<create>   { <sym> }
    token command:sym<retrieve> { <sym> }
    token command:sym<update>   { <sym> }
    token command:sym<delete>   { <sym> }
 
    token subject { \w+ }
    token data    { .* }
    token slash   { \s* '/' \s* }
}
```

让我们看看各种 URI，看看他们如何处理我们的语法。

Let's look at various URIs and see how they work with our grammar.

```Raku
my @uris = ['/product/update/7/notify',
            '/product/create',
            '/item/delete/4'];
 
for @uris -> $uri {
    my $m = REST.parse($uri);
    say "Sub: $m<subject> Cmd: $m<command> Dat: $m<data>";
}
 
# OUTPUT: «Sub: product Cmd: update Dat: 7/notify␤ 
#          Sub: product Cmd: create Dat: ␤ 
#          Sub: item Cmd: delete Dat: 4␤» 
```

注意，由于 `<data>` 不匹配第二个字符串上的任何内容，`$m<data>` 将是 `Nil`，然后在 `say` 函数中的字符串上下文中使用它。

Note that since `<data>` matches nothing on the second string, `$m<data>` will be `Nil`, then using it in string context in the `say` function warns.

有了语法的这一部分，我们几乎得到了我们想要的一切。URI 被解析，我们用数据得到一个数据结构。

With just this part of a grammar, we're getting almost everything we're looking for. The URIs get parsed and we get a data structure with the data.

*data* 标记将 URI 的整个结尾作为一个字符串返回。4 没问题。然而，从 '7/notify' 开始，我们只需要 7。为了得到 7，我们将使用语法类的另一个特性：*动作*。

The *data* token returns the entire end of the URI as one string. The 4 is fine. However from the '7/notify', we only want the 7. To get just the 7, we'll use another feature of grammar classes: *actions*.

<a id="%E8%AF%AD%E6%B3%95%E5%8A%A8%E4%BD%9C--grammar-actions"></a>
# 语法动作 / Grammar actions

语法动作在语法类中被用来做匹配的事情。动作是在它们自己的类中定义的，与语法类不同。

Grammar actions are used within grammar classes to do things with matches. Actions are defined in their own classes, distinct from grammar classes.

你可以将语法动作看作是语法的一种插件扩展模块。很多时候，你会很高兴地使用语法本身。但是，当你需要进一步处理这些字符串时，可以插入动作扩展模块。

You can think of grammar actions as a kind of plug-in expansion module for grammars. A lot of the time you'll be happy using grammars all by their own. But when you need to further process some of those strings, you can plug in the Actions expansion module.

要处理动作，你可以使用一个名为 `actions` 的命名参数，该参数应该包含动作类的一个实例。使用上面的代码，如果我们的动作类名为 REST-Actions，我们将解析 URI 字符串，如下所示：

To work with actions, you use a named parameter called `actions` which should contain an instance of your actions class. With the code above, if our actions class called REST-actions, we would parse the URI string like this:

```Raku
my $matchObject = REST.parse($uri, actions => REST-actions.new);

#   …or if you prefer… 

my $matchObject = REST.parse($uri, :actions(REST-actions.new));
```

如果你*使用与语法方法（token、regex 以及 rule）相同的名称命名你的操作方法*，则当你的语法方法匹配时，将自动调用具有相同名称的操作方法。该方法也将通过相应的匹配对象（由 `$/` 变量表示）。

If you *name your action methods with the same name as your grammar methods* (tokens, regexes, rules), then when your grammar methods match, your action method with the same name will get called automatically. The method will also be passed the corresponding match object (represented by the `$/` variable).

让我们来举个例子。

Let's turn to an example.

<a id="%E6%9C%89%E5%8A%A8%E4%BD%9C%E7%9A%84%E8%AF%AD%E6%B3%95%E7%A4%BA%E4%BE%8B--grammars-by-example-with-actions"></a>
## 有动作的语法示例 / Grammars by example with actions

在这里，我们回到我们的语法。

Here we are back to our grammar.

```Raku
grammar REST
{
    token TOP { <slash><subject><slash><command>[<slash><data>]? }
 
    proto token command {*}
    token command:sym<create>   { <sym> }
    token command:sym<retrieve> { <sym> }
    token command:sym<update>   { <sym> }
    token command:sym<delete>   { <sym> }
 
    token subject { \w+ }
    token data    { .* }
    token slash   { \s* '/' \s* }
}
```

回想一下，我们希望进一步处理 data 标记 "7/notify"，以获得 7。为此，我们将创建一个动作类，该类具有与命名令牌同名的方法。在本例中，我们的标记名为 `data`，因此我们的方法也被命名为 `data`。

Recall that we want to further process the data token "7/notify", to get the 7. To do this, we'll create an action class that has a method with the same name as the named token. In this case, our token is named `data` so our method is also named `data`.

```Raku
class REST-actions
{
    method data($/) { $/.split('/') }
}
```

现在，当我们通过语法传递 URI 字符串时，*data 标记匹配*将传递给 *REST-actions 的 data 方法*。action 方法将字符串拆分为 '/' 字符，返回列表的第一个元素将是 ID 号（在 "7/notify" 的情况下为 7）。

Now when we pass the URI string through the grammar, the *data token match* will be passed to the *REST-actions' data method*. The action method will split the string by the '/' character and the first element of the returned list will be the ID number (7 in the case of "7/notify").

<a id="%E7%94%A8-make-%E5%92%8C-made-%E4%BF%9D%E6%8C%81%E8%AF%AD%E6%B3%95%E4%B8%8E%E5%8A%A8%E4%BD%9C%E7%9A%84%E6%95%B4%E6%B4%81--keeping-grammars-with-actions-tidy-with-make-and-made"></a>
## 用 `make` 和 `made` 保持语法与动作的整洁 / Keeping grammars with actions tidy with `make` and `made`

如果语法调用上面对 data 的动作，data 方法将被调用，但是在返回给我们程序的大 `TOP` 语法匹配结果中什么也不会显示出来。为了使动作结果显示出来，我们需要调用 [make](https://docs.raku.org/routine/make)。结果可能是许多事情，包括字符串、数组或哈希结构。

If the grammar calls the action above on data, the data method will be called, but nothing will show up in the big `TOP` grammar match result returned to our program. In order to make the action results show up, we need to call [make](https://docs.raku.org/routine/make) on that result. The result can be many things, including strings, array or hash structures.

你可以想象 `make` 将结果放置在一个特殊的语法包含区域中。`make` 出来的一切，以后都可以由 [made](https://docs.raku.org/routine/made) 访问。

You can imagine that the `make` places the result in a special contained area for a grammar. Everything that we `make` can be accessed later by [made](https://docs.raku.org/routine/made).

因此，我们不应该使用上面的 REST-actions 类，而应该写：

So instead of the REST-actions class above, we should write:

```Raku
class REST-actions
{
    method data($/) { make $/.split('/') }
}
```

当我们将 `make` 添加到匹配拆分（它返回一个列表）时，该动作将返回一个数据结构到语法，该语法将与原始语法的 `data` token 分开存储。这样，如果我们需要的话，我们可以和两者一起工作。

When we add `make` to the match split (which returns a list), the action will return a data structure to the grammar that will be stored separately from the `data` token of the original grammar. This way, we can work with both if we need to.

如果我们只想从那个长 URI 访问 7 的 ID，那么我们访问 `data` 动作用 `made` 返回的列表的第一个元素：

If we want to access just the ID of 7 from that long URI, we access the first element of the list returned from the `data` action that we `made`:

```Raku
my $uri = '/product/update/7/notify';
 
my $match = REST.parse($uri, actions => REST-actions.new);
 
say $match<data>.made[0];  # OUTPUT: «7␤» 
say $match<command>.Str;   # OUTPUT: «update␤» 
```

我们对 data 调用 `made`，因为我们希望得到动作类中同名 data 方法中使用 `make` 返回的那个拆分数组。这太可爱了！但是，如果我们能 `make` 一个包含我们想要的所有东西的更友好的数据结构，而不是强迫类型沌河和记住阵列，那岂不是更可爱吗？

Here we call `made` on data, because we want the result of the action that we `made` (with `make`) to get the split array. That's lovely! But, wouldn't it be lovelier if we could `make` a friendlier data structure that contained all of the stuff we want, rather than having to coerce types and remember arrays?

就像语法的 `TOP`（与整个字符串匹配）一样，动作也有一个 TOP 方法。我们可以 `make` 所有单独的匹配组件，如 `data`、`subject` 或 `command`，然后我们可以将它们放置在数据结构中并在 TOP 中将他们 `make`。当我们返回最终的匹配对象时，我们可以访问这个数据结构。

Just like Grammar's `TOP`, which matches the entire string, actions have a TOP method as well. We can `make` all of the individual match components, like `data` or `subject` or `command`, and then we can place them in a data structure that we will `make` in TOP. When we return the final match object, we can then access this data structure.

为此，我们将方法 `TOP` 添加到动作类中，并从组件片段中添加任何我们喜欢的数据结构。

To do this, we add the method `TOP` to the action class and `make` whatever data structure we like from the component pieces.

因此，我们的动作类变成了：

So, our action class becomes:

```Raku
class REST-actions
{
    method TOP ($/) {
        make { subject => $<subject>.Str,
               command => $<command>.Str,
               data    => $<data>.made }
    }
 
    method data($/) { make $/.split('/') }
}
```

在 `TOP` 方法中，`subject` 与我们在语法中匹配的 subject 保持不变。此外，`command` 返回匹配的有效 `<sym>` （创建、更新、检索或删除）。因为我们不需要完整的匹配对象，所以将他们用 `.Str` 方法转换为字符串。

Here in the `TOP` method, the `subject` remains the same as the subject we matched in the grammar. Also, `command` returns the valid `<sym>` that was matched (create, update, retrieve, or delete). We coerce each into `.Str`, as well, since we don't need the full match object.

我们希望确保在 `$<data>` 对象上使用 `made` 方法，因为我们希望访问我们在动作中使用 data 方法用 `make` 返回的拆分数组，而不是 `$<data>` 对象。

We want to make sure to use the `made` method on the `$<data>` object, since we want to access the split one that we `made` with `make` in our action, rather than the proper `$<data>` object.

在语法动作的 `TOP` 方法中 `make` 之后，我们就可以通过调用语法结果对象上的 `made` 方法来访问所有的自定义值。代码现在变成

After we `make` something in the `TOP` method of a grammar action, we can then access all the custom values by calling the `made` method on the grammar result object. The code now becomes

```Raku
my $uri = '/product/update/7/notify';

my $match = REST.parse($uri, actions => REST-actions.new);

my $rest = $match.made;
say $rest<data>[0];   # OUTPUT: «7␤» 
say $rest<command>;   # OUTPUT: «update␤» 
say $rest<subject>;   # OUTPUT: «product␤» 
```

如果不需要完整的返回匹配对象，则只能从动作的 `TOP` 返回已生成的数据。

If the complete return match object is not needed, you could return only the made data from your action's `TOP`.

```Raku
my $uri = '/product/update/7/notify';

my $rest = REST.parse($uri, actions => REST-actions.new).made;

say $rest<data>[0];   # OUTPUT: «7␤» 
say $rest<command>;   # OUTPUT: «update␤» 
say $rest<subject>;   # OUTPUT: «product␤» 
```

哦，我们忘了去掉那个丑陋的数组元素了吗？嗯。让我们在 `TOP` 中的语法自定义返回中新的东西。。。我们称其为 `subject-id`，并将其设置为 `<data>` 的第一个元素如何？

Oh, did we forget to get rid of that ugly array element number? Hmm. Let's make something new in the grammar's custom return in `TOP`... how about we call it `subject-id` and have it set to element 0 of `<data>`.

```Raku
class REST-actions
{
    method TOP ($/) {
        make { subject    => $<subject>.Str,
               command    => $<command>.Str,
               data       => $<data>.made,
               subject-id => $<data>.made[0] }
    }

    method data($/) { make $/.split('/') }
}
```

现在我们可以这样做：

Now we can do this instead:

```Raku
my $uri = '/product/update/7/notify';
 
my $rest = REST.parse($uri, actions => REST-actions.new).made;
 
say $rest<command>;    # OUTPUT: «update␤» 
say $rest<subject>;    # OUTPUT: «product␤» 
say $rest<subject-id>; # OUTPUT: «7␤» 
```

完整代码：

Here's the final code:

```Raku
grammar REST
{
    token TOP { <slash><subject><slash><command>[<slash><data>]? }
 
    proto token command {*}
    token command:sym<create>   { <sym> }
    token command:sym<retrieve> { <sym> }
    token command:sym<update>   { <sym> }
    token command:sym<delete>   { <sym> }
 
    token subject { \w+ }
    token data    { .* }
    token slash   { \s* '/' \s* }
}
 
 
class REST-actions
{
    method TOP ($/) {
        make { subject    => $<subject>.Str,
               command    => $<command>.Str,
               data       => $<data>.made,
               subject-id => $<data>.made[0] }
    }
 
    method data($/) { make $/.split('/') }
}
```

<a id="%E7%9B%B4%E6%8E%A5%E6%B7%BB%E5%8A%A0%E5%8A%A8%E4%BD%9C--add-actions-directly"></a>
## 直接添加动作 / Add actions directly

上面，我们将介绍如何将语法与动作对象关联起来，并在匹配对象上执行动作。然而，当我们想要处理匹配对象时，这不是唯一的方法。见下面的例子：

Above we see how to associate grammars with action objects and perform actions on the match object. However, when we want to deal with the match object, that isn't the only way. See the example below:

```Raku
grammar G {
  rule TOP { <function-define> }
  rule function-define {
    'sub' <identifier>
    {
      say "func " ~ $<identifier>.made;
      make $<identifier>.made;
    }
    '(' <parameter> ')' '{' '}'
    { say "end " ~ $/.made; }
  }
  token identifier { \w+ { make ~$/; } }
  token parameter { \w+ { say "param " ~ $/; } }
}
 
G.parse('sub f ( a ) { }');
# OUTPUT: «func f␤param a␤end f␤» 
```

此示例是解析器的缩减部分。让我们更多地关注它显示的特性。

This example is a reduced portion of a parser. Let's focus more on the feature it shows.

首先，我们可以在语法本身中添加动作，这些动作在正则表达式的控制流到达它们之后执行。注意，动作对象的方法总是在整个正则项匹配之后执行。第二，它显示了 `make` 真正做了什么，它不过是 `$/.made = ...` 的语法糖。这个技巧引入了一种从正则项中传递消息的方法。

First, we can add actions inside the grammar itself, and such actions are performed once the control flow of the regex arrives at them. Note that action object's method will always be performed after the whole regex item matched. Second, it shows what `make` really does, which is no more than a sugar of `$/.made = ...`. And this trick introduces a way to pass messages from within a regex item.

希望这有助于你了解 Raku 中的语法，并向你展示语法和语法动作类是如何协同工作的。有关更多信息，请查看 [Raku 语法指南](https://docs.raku.org/language/grammars)。

Hopefully this has helped introduce you to the grammars in Raku and shown you how grammars and grammar action classes work together. For more information, check out the more advanced [Raku Grammar Guide](https://docs.raku.org/language/grammars).

有关语法调试的更多信息，请参见 [Grammar::Debugger](https://github.com/jnthn/grammar-debugger) 模块。这为每个语法标记提供断点和颜色编码匹配以及失败输出。

For more grammar debugging, see [Grammar::Debugger](https://github.com/jnthn/grammar-debugger). This provides breakpoints and color-coded MATCH and FAIL output for each of your grammar tokens.
