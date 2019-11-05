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
- [Learning by example - a REST contrivance](#learning-by-example---a-rest-contrivance)
    - [Adding some flexibility](#adding-some-flexibility)
    - [Inheriting from a grammar](#inheriting-from-a-grammar)
    - [Adding some constraints](#adding-some-constraints)
    - [Putting our RESTful grammar together](#putting-our-restful-grammar-together)
- [Grammar actions](#grammar-actions)
    - [Grammars by example with actions](#grammars-by-example-with-actions)
    - [Keeping grammars with actions tidy with `make` and `made`](#keeping-grammars-with-actions-tidy-with-make-and-made)
    - [Add actions directly](#add-actions-directly)

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

正则表达式（[正则表达式](https://docs.raku.org/language/regexes)）对于在字符串中查找模式非常有效。但是，对于某些任务，比如一次找到多个模式，或者组合模式，或者测试可能围绕字符串正则表达式的模式，仅仅这样做是不够的。

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

作为这样的类，语法由定义正则表达式、标记或规则的方法组成。这些都是各种不同类型的匹配方法。一旦定义了语法，就调用它并传入一个字符串进行解析。

As such classes, grammars are made up of methods that define a regex, a token, or a rule. These are all varieties of different types of match methods. Once you have a grammar defined, you call it and pass in a string for parsing.

```Raku
my $matchObject = G.parse($string);
```

现在，你可能想知道，如果我定义了所有这些只返回结果的正则表达式，这对解析另一个字符串中可能在前面或后面的字符串，或者需要从这些正则表达式中组合的内容有何帮助。这就是语法动作的来源。

Now, you may be wondering, if I have all these regexes defined that just return their results, how does that help with parsing strings that may be ahead or backwards in another string, or things that need to be combined from many of those regexes... And that's where grammar actions come in.

对于语法中匹配的每一个“方法”，都会得到一个可用于对该匹配进行操作的操作。您还可以获得一个总体操作，用于将所有匹配项绑定在一起并构建数据结构。默认情况下，此总体方法称为 `TOP`。

For every "method" you match in your grammar, you get an action you can use to act on that match. You also get an overarching action that you can use to tie together all your matches and to build a data structure. This overarching method is called `TOP` by default.

<a id="%E6%8A%80%E6%9C%AF%E6%A6%82%E8%BF%B0--the-technical-overview"></a>
## 技术概述 / The technical overview

如前所述，语法使用 *grammar* 关键字声明，其“方法”使用 *regex* 或 *token* 或 *rule* 声明。

As already mentioned, grammars are declared using the *grammar* keyword and its "methods" are declared with *regex*, or *token*, or *rule*.

- regex 方法很慢但很彻底，它们会回头看看字符串，然后真正尝试。
- token 方法比 regex 方法快，并且忽略空白。
- rule 方法与 token 方法相同，只是不忽略空白。

- Regex methods are slow but thorough, they will look back in the string and really try.
- Token methods are faster than regex methods and ignore whitespace.
- Rule methods are the same as token methods except whitespace is not ignored.

当一个方法（regex、token 或 rule）在语法中匹配时，匹配的字符串被放入[匹配对象](https://docs.raku.org/type/Match)中，其键为方法名相同。

When a method (regex, token or rule) matches in the grammar, the string matched is put into a [match object](https://docs.raku.org/type/Match) and keyed with the same name as the method.

```Raku
grammar G {
    token TOP { <thingy> .* }
    token thingy { 'clever_text_keyword' }
}
```

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

The two first output lines show that `$match` contains a `Match` objects with the results of the parsing; but those results are also assigned to the [match variable `$/`](https://docs.raku.org/syntax/$$SOLIDUS). Either match object can be keyed, as indicated above, by `thingy` to return the match for that particular `token`.

The `TOP` method (whether regex, token, or rule) is the overarching pattern that must match everything (by default). If the parsed string doesn't match the TOP regex, your returned match object will be empty (`Nil`).

As you can see above, in `TOP`, the `<thingy>` token is mentioned. The `<thingy>` is defined on the next line. That means that `'clever_text_keyword'` **must** be the first thing in the string, or the grammar parse will fail and we'll get an empty match. This is great for recognizing a malformed string that should be discarded.

<a id="learning-by-example---a-rest-contrivance"></a>
# Learning by example - a REST contrivance

Let's suppose we'd like to parse a URI into the component parts that make up a RESTful request. We want the URIs to work like this:

- The first part of the URI will be the "subject", like a part, or a product, or a person.
- The second part of the URI will be the "command", the standard CRUD functions (create, retrieve, update, or delete).
- The third part of the URI will be arbitrary data, perhaps the specific ID we'll be working with or a long list of data separated by "/"'s.
- When we get a URI, we'll want 1-3 above to be placed into a data structure that we can easily work with (and later enhance).

So, if we have "/product/update/7/notify", we would want our grammar to give us a match object that has a `subject` of "product", a `command` of "update", and `data` of "7/notify".

We'll start by defining a grammar class and some match methods for the subject, command, and data. We'll use the token declarator since we don't care about whitespace.

```Raku
grammar REST {
    token subject { \w+ }
    token command { \w+ }
    token data    { .* }
}
```

So far, this REST grammar says we want a subject that will be just *word* characters, a command that will be just *word* characters, and data that will be everything else left in the string.

Next, we'll want to arrange these matching tokens within the larger context of the URI. That's what the TOP method allows us to do. We'll add the TOP method and place the names of our tokens within it, together with the rest of the patterns that makes up the overall pattern. Note how we're building a larger regex from our named regexes.

```Raku
grammar REST {
    token TOP     { '/' <subject> '/' <command> '/' <data> }
    token subject { \w+ }
    token command { \w+ }
    token data    { .* }
}
```

With this code, we can already get the three parts of our RESTful request:

```Raku
my $match = REST.parse('/product/update/7/notify');
say $match;
 
# OUTPUT: «｢/product/update/7/notify｣␤ 
#          subject => ｢product｣ 
#          command => ｢update｣ 
#          data => ｢7/notify｣» 
```

The data can be accessed directly by using `$match<subject>` or `$match<command>` or `$match<data>` to return the values parsed. They each contain match objects that you can work further with, such as coercing into a string ( `$match<command>.Str` ).

<a id="adding-some-flexibility"></a>
## Adding some flexibility

So far, the grammar will handle retrieves, deletes and updates. However, a *create* command doesn't have the third part (the *data* portion). This means the grammar will fail to match if we try to parse a create URI. To avoid this, we need to make that last *data* position match optional, along with the '/' preceding it. This is accomplished by adding a question mark to the grouped '/' and *data* components of the TOP token, to indicate their optional nature, just like a normal regex.

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

We're getting some extra junk in the match object now, with those slashes. There's techniques to clean that up that we'll get to later.

<a id="inheriting-from-a-grammar"></a>
## Inheriting from a grammar

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

Will output exactly the same as the code above. Symptomatic of the difference between Classes and Roles, a conflict like defining `token quote` twice using Role composition will result in an error:

```Raku
grammar Quoted-Quotes does Letters does Quote-Quotes does Quote-Other { ... }
# OUTPUT: ... Error while compiling ... Method 'quote' must be resolved ... 
```

<a id="adding-some-constraints"></a>
## Adding some constraints

We want our RESTful grammar to allow for CRUD operations only. Anything else we want to fail to parse. That means our "command" above should have one of four values: create, retrieve, update or delete.

There are several ways to accomplish this. For example, you could change the command method:

```Raku
token command { \w+ }
 
# …becomes… 
 
token command { 'create'|'retrieve'|'update'|'delete' }
```

For a URI to parse successfully, the second part of the string between '/'s must be one of those CRUD values, otherwise the parsing fails. Exactly what we want.

There's another technique that provides greater flexibility and improved readability when options grow large: *proto-regexes*.

To utilize these proto-regexes (multimethods, in fact) to limit ourselves to the valid CRUD options, we'll replace `token command` with the following:

```Raku
proto token command {*}
token command:sym<create>   { <sym> }
token command:sym<retrieve> { <sym> }
token command:sym<update>   { <sym> }
token command:sym<delete>   { <sym> }
```

The `sym` keyword is used to create the various proto-regex options. Each option is named (e.g., `sym<update>`), and for that option's use, a special `<sym>` token is auto-generated with the same name.

The `<sym>` token, as well as other user-defined tokens, may be used in the proto-regex option block to define the specific *match condition*. Regex tokens are compiled forms and, once defined, cannot subsequently be modified by adverb actions (e.g., `:i`). Therefore, as it's auto-generated, the special `<sym>` token is useful only where an exact match of the option name is required.

If, for one of the proto-regex options, a match condition occurs, then the whole proto's search terminates. The matching data, in the form of a match object, is assigned to the parent proto token. If the special `<sym>` token was employed and formed all or part of the actual match, then it's preserved as a sub-level in the match object, otherwise it's absent.

Using proto-regex like this gives us a lot of flexibility. For example, instead of returning `<sym>`, which in this case is the entire string that was matched, we could instead enter our own string, or do other funny stuff. We could do the same with the `token subject` method and limit it also to only parsing correctly on valid subjects (like 'part' or 'people', etc.).

<a id="putting-our-restful-grammar-together"></a>
## Putting our RESTful grammar together

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

Note that since `<data>` matches nothing on the second string, `$m<data>` will be `Nil`, then using it in string context in the `say` function warns.

With just this part of a grammar, we're getting almost everything we're looking for. The URIs get parsed and we get a data structure with the data.

The *data* token returns the entire end of the URI as one string. The 4 is fine. However from the '7/notify', we only want the 7. To get just the 7, we'll use another feature of grammar classes: *actions*.

<a id="grammar-actions"></a>
# Grammar actions

Grammar actions are used within grammar classes to do things with matches. Actions are defined in their own classes, distinct from grammar classes.

You can think of grammar actions as a kind of plug-in expansion module for grammars. A lot of the time you'll be happy using grammars all by their own. But when you need to further process some of those strings, you can plug in the Actions expansion module.

To work with actions, you use a named parameter called `actions` which should contain an instance of your actions class. With the code above, if our actions class called REST-actions, we would parse the URI string like this:

```Raku
my $matchObject = REST.parse($uri, actions => REST-actions.new);
 
#   …or if you prefer… 
 
my $matchObject = REST.parse($uri, :actions(REST-actions.new));
```

If you *name your action methods with the same name as your grammar methods* (tokens, regexes, rules), then when your grammar methods match, your action method with the same name will get called automatically. The method will also be passed the corresponding match object (represented by the `$/` variable).

Let's turn to an example.

<a id="grammars-by-example-with-actions"></a>
## Grammars by example with actions

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

Recall that we want to further process the data token "7/notify", to get the 7. To do this, we'll create an action class that has a method with the same name as the named token. In this case, our token is named `data` so our method is also named `data`.

```Raku
class REST-actions
{
    method data($/) { $/.split('/') }
}
```

Now when we pass the URI string through the grammar, the *data token match* will be passed to the *REST-actions' data method*. The action method will split the string by the '/' character and the first element of the returned list will be the ID number (7 in the case of "7/notify").

But not really; there's a little more.

<a id="keeping-grammars-with-actions-tidy-with-make-and-made"></a>
## Keeping grammars with actions tidy with `make` and `made`

If the grammar calls the action above on data, the data method will be called, but nothing will show up in the big `TOP` grammar match result returned to our program. In order to make the action results show up, we need to call [make](https://docs.raku.org/routine/make) on that result. The result can be many things, including strings, array or hash structures.

You can imagine that the `make` places the result in a special contained area for a grammar. Everything that we `make` can be accessed later by [made](https://docs.raku.org/routine/made).

So instead of the REST-actions class above, we should write:

```Raku
class REST-actions
{
    method data($/) { make $/.split('/') }
}
```

When we add `make` to the match split (which returns a list), the action will return a data structure to the grammar that will be stored separately from the `data` token of the original grammar. This way, we can work with both if we need to.

If we want to access just the ID of 7 from that long URI, we access the first element of the list returned from the `data` action that we `made`:

```Raku
my $uri = '/product/update/7/notify';
 
my $match = REST.parse($uri, actions => REST-actions.new);
 
say $match<data>.made[0];  # OUTPUT: «7␤» 
say $match<command>.Str;   # OUTPUT: «update␤» 
```

Here we call `made` on data, because we want the result of the action that we `made` (with `make`) to get the split array. That's lovely! But, wouldn't it be lovelier if we could `make` a friendlier data structure that contained all of the stuff we want, rather than having to coerce types and remember arrays?

Just like Grammar's `TOP`, which matches the entire string, actions have a TOP method as well. We can `make` all of the individual match components, like `data` or `subject` or `command`, and then we can place them in a data structure that we will `make` in TOP. When we return the final match object, we can then access this data structure.

To do this, we add the method `TOP` to the action class and `make` whatever data structure we like from the component pieces.

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

Here in the `TOP` method, the `subject` remains the same as the subject we matched in the grammar. Also, `command` returns the valid `<sym>` that was matched (create, update, retrieve, or delete). We coerce each into `.Str`, as well, since we don't need the full match object.

We want to make sure to use the `made` method on the `$<data>` object, since we want to access the split one that we `made` with `make` in our action, rather than the proper `$<data>` object.

After we `make` something in the `TOP` method of a grammar action, we can then access all the custom values by calling the `made` method on the grammar result object. The code now becomes

```Raku
my $uri = '/product/update/7/notify';
 
my $match = REST.parse($uri, actions => REST-actions.new);
 
my $rest = $match.made;
say $rest<data>[0];   # OUTPUT: «7␤» 
say $rest<command>;   # OUTPUT: «update␤» 
say $rest<subject>;   # OUTPUT: «product␤» 
```

If the complete return match object is not needed, you could return only the made data from your action's `TOP`.

```Raku
my $uri = '/product/update/7/notify';
 
my $rest = REST.parse($uri, actions => REST-actions.new).made;
 
say $rest<data>[0];   # OUTPUT: «7␤» 
say $rest<command>;   # OUTPUT: «update␤» 
say $rest<subject>;   # OUTPUT: «product␤» 
```

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

Now we can do this instead:

```Raku
my $uri = '/product/update/7/notify';
 
my $rest = REST.parse($uri, actions => REST-actions.new).made;
 
say $rest<command>;    # OUTPUT: «update␤» 
say $rest<subject>;    # OUTPUT: «product␤» 
say $rest<subject-id>; # OUTPUT: «7␤» 
```

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

<a id="add-actions-directly"></a>
## Add actions directly

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

This example is a reduced portion of a parser. Let's focus more on the feature it shows.

First, we can add actions inside the grammar itself, and such actions are performed once the control flow of the regex arrives at them. Note that action object's method will always be performed after the whole regex item matched. Second, it shows what `make` really does, which is no more than a sugar of `$/.made = ...`. And this trick introduces a way to pass messages from within a regex item.

Hopefully this has helped introduce you to the grammars in Raku and shown you how grammars and grammar action classes work together. For more information, check out the more advanced [Perl Grammar Guide](https://docs.raku.org/language/grammars).

For more grammar debugging, see [Grammar::Debugger](https://github.com/jnthn/grammar-debugger). This provides breakpoints and color-coded MATCH and FAIL output for each of your grammar tokens.
