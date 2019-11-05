# 简介 / Brief introduction

使用 Perl 6 官方文档

Using Perl 6 official documentation

给大型语言（如 Perl6）记录文档需要平衡几个相互矛盾的目标，例如简短而全面，适合经验丰富的专业开发人员，同时也可供新来者使用。

Documenting a large language like Perl 6 has to balance several contradictory goals, such as being brief whilst being comprehensive, catering to professional developers with wide experience whilst also being accessible to newcomers to the language.

快速上手介绍，可以看这个简短的[`带注解的编码示例`](https://docs.raku.org/language/101-basics)。

For a quick hands-on introduction, there is a short [`annotated programming example`](https://docs.raku.org/language/101-basics).

有经验的程序员，有许多*迁移*指引，他们将 Perl 6 的特性与其他语言进行比较和对比。

For programmers with experience in other languages, there are a number of **Migration** guides that compare and contrast the features of Perl6 with other languages.

许多**教程**涵盖了 Perl6 特别创新的几个领域。节标题应该有助于导航其余的文档。

A number of **Tutorials** cover several areas in which Perl6 is particularly innovative. The section headers should help navigate the remaining documents.

在 Perl6.org 站点的其他地方列出了许多[`有用的资源`](https://perl6.org/resources)。其中包括文章、书籍、幻灯片演示和视频。

There are a number of [`useful resources`](https://perl6.org/resources) listed elsewhere on the perl6.org site. These include articles, books, slide presentations, and videos.

新加入 Perl 6 的人经常会提出问题指出从其他编程范例中继承的假设。建议首先回顾~~基本主题部分~~的以下主题。

It has been found that newcomers to Perl 6 often ask questions that indicate assumptions carried over from other programming paradigms. It is suggested that the following sections in the `Fundamental topics` section should be reviewed first.

- [`签名`](https://docs.raku.org/type/Signature) - 每个例程，包括子例程和方法，都有一个签名。理解签名提供的信息可以快速抓住例程的行为和效果。

- [`Signatures`](https://docs.raku.org/type/Signature) - each routine, which includes subroutines and methods, has a signature. Understanding the information given in the signature of a `sub` or `method`provides a quick way to grasp the operation and effect of the routine.

- [`容器`](http://docs.raku.org/language/containers) - 变量，就像计算机语言中的名词，是存放信息的容器。容器名字的第一个字符，如 $my-variable 中的 `$`、@an-array-of-things 中的 `@` 或者 %the-scores-in-the-competition 中的 `%`，传达了容器的信息。然而，在容器能存储什么东西上，Perl6 比其他语言要更抽象。因此，例如，一个 $scalar（标量变量） 容器可以包含一个实际上是数组的容器。

- [`Containers`](https://docs.raku.org/language/containers) - variables, which are like the nouns of a computer language, are containers in which information is stored. The first letter in the formal name of a container, such as the '$' of $my-variable, or '@' of @an-array-of-things, or '%' of %the-scores-in-the-competition, conveys information about the container. However, Perl6 is more abstract than other languages about what can be stored in a container. So, for example, a $scalar container can contain an object that is in fact an array.

- [`类与对象`](https://docs.raku.org/language/classtut) - Perl 6 基本上是基于对象的，这些对象按类和角色进行描述。与某些语言不同，Perl 6 **不强制采用**面向对象的编程实践，并且可以就好像 Perl 6 本质上是纯过程的一样编写有用的程序。然而，复杂的软件，如 Perl 6 的 Rakudo 编译器，通过使用面向对象的风格来编写，变得简单多了，这就是为什么通过查看类是什么以及角色是什么，Perl 6 文档更容易理解的原因。如果不理解类和角色，就很难理解类型，而文档的整个部分都是针对类型的。

- [`Classes and Objects`](https://docs.raku.org/language/classtut) - Perl 6 is fundamentally based on objects, which are described in terms of classes and roles. Perl 6, unlike some languages, does not **impose**object-oriented programming practices, and useful programs can be written as if Perl 6 was purely procedural in nature. However, complex software, such as the Rakudo compiler of Perl 6, is made much simpler by writing in object-oriented idioms, which is why the Perl 6 documentation is more easily understood by reviewing what a class is and what a role is. Without understanding about Classes and Roles, it would be difficult to understand Types, to which a whole section of the documentation is devoted.

- [`避免陷阱`](https://docs.raku.org/language/traps) - 一些常见的假设导致代码没有如程序员设想的那样工作。这个主题选出了一些这种类型的假设。当事情不太顺利时，值得回顾一下。

- [`Traps to Avoid`](https://docs.raku.org/language/traps) - Several common assumptions lead to code that does not work as the programmer intended. This section identifies some. It is worth reviewing when something doesn't quite work out.