原文：https://docs.raku.org/language/performance

# 性能 / Performance

测量和改进运行时或编译时性能

Measuring and improving runtime or compile-time performance

这个页面是关于 Raku 上下文中的[计算机性能](https://en.wikipedia.org/wiki/Computer_performance)。

This page is about [computer performance](https://en.wikipedia.org/wiki/Computer_performance) in the context of Raku.
<!-- MarkdownTOC -->

- [首先，分析你的代码 / First, profile your code](#首先，分析你的代码--first-profile-your-code)
  - [用 `now - INIT now` 计时 / Time with `now - INIT now`](#用-now---init-now-计时--time-with-now---init-now)
  - [局部分析 / Profile locally](#局部分析--profile-locally)
  - [分析编译过程 / Profile compiling](#分析编译过程--profile-compiling)
  - [创建或查看基准 / Create or view benchmarks](#创建或查看基准--create-or-view-benchmarks)
  - [共享问题 / Share problems](#共享问题--share-problems)
- [解决问题 / Solve problems](#解决问题--solve-problems)
  - [逐行 / Line by line](#逐行--line-by-line)
  - [逐个例程 / Routine by routine](#逐个例程--routine-by-routine)
  - [加快类型检查和调用解析 / Speed up type-checks and call resolution](#加快类型检查和调用解析--speed-up-type-checks-and-call-resolution)
  - [选择更好的算法 / Choose better algorithms](#选择更好的算法--choose-better-algorithms)
    - [将顺序/阻塞代码改为并行/非阻塞代码 - Change sequential/blocking code to parallel/non-blocking](#将顺序阻塞代码改为并行非阻塞代码---change-sequentialblocking-code-to-parallelnon-blocking)
  - [使用现有的高性能代码 / Use existing high performance code](#使用现有的高性能代码--use-existing-high-performance-code)
  - [使 Rakudo 编译器生成更快的代码 / Make the Rakudo compiler generate faster code](#使-rakudo-编译器生成更快的代码--make-the-rakudo-compiler-generate-faster-code)
  - [还需要更多的想法？ / Still need more ideas?](#还需要更多的想法？--still-need-more-ideas)
- [得不到你想要的结果？ / Not getting the results you need/want?](#得不到你想要的结果？--not-getting-the-results-you-needwant)

<!-- /MarkdownTOC -->

<a id="首先，分析你的代码--first-profile-your-code"></a>
# 首先，分析你的代码 / First, profile your code

**确保你没有在错误的代码上浪费时间**：通过分析代码的性能来确定你的[“关键的 3%”](https://en.wikiquote.org/wiki/Donald_Knuth)。本文档的其余部分将向你展示如何做到这一点。

**Make sure you're not wasting time on the wrong code**: start by identifying your ["critical 3%"](https://en.wikiquote.org/wiki/Donald_Knuth) by profiling your code's performance. The rest of this document shows you how to do that.

<a id="用-now---init-now-计时--time-with-now---init-now"></a>
## 用 `now - INIT now` 计时 / Time with `now - INIT now`

`now - INIT now` 形式的表达式，其中 `INIT` 是一个 [Raku 程序运行时的相位器](https://docs.raku.org/language/phasers)，为计时代码片段提供了一个很好的习语。

Expressions of the form `now - INIT now`, where `INIT` is a [phase in the running of a Raku program](https://docs.raku.org/language/phasers), provide a great idiom for timing code snippets.

使用 `m: your code goes here` 的格式在 [raku 通道用 evalbot](https://docs.raku.org/language/glossary#camelia) 写代码，例如：

Use the `m: your code goes here` [raku channel evalbot](https://docs.raku.org/language/glossary#camelia) to write lines like:

```Raku
m: say now - INIT now
rakudo-moar abc1234: OUTPUT«0.0018558␤»
```

`INIT` 左边的 `now` 运行 0.0018558 秒比 `INIT` 右侧的 `now` 晚，因为后者发生在 [INIT 阶段](https://docs.raku.org/language/phasers#INIT)。

The `now` to the left of `INIT` runs 0.0018558 seconds *later* than the `now` to the right of the `INIT` because the latter occurs during [the INIT phase](https://docs.raku.org/language/phasers#INIT).

<a id="局部分析--profile-locally"></a>
## 局部分析 / Profile locally

当使用 [MoarVM](https://moarvm.org/) 后端时，[Rakudo](https://rakudo.org/) 编译器的 `--profile` 命令行选项将概要文件数据写入到 HTML 文件中。

When using the [MoarVM](https://moarvm.org/) backend, the [Rakudo](https://rakudo.org/) compiler's `--profile` command line option writes the profile data to an HTML file.

该文件将打开 “Overview” 部分，其中提供了有关程序运行方式的一些总体数据，例如，总运行时、垃圾收集所花费的时间。你将在这里获得的一个重要信息是被解释的调用帧（即代码块）中被解释的百分比（最慢，红色），[spesh](https://docs.raku.org/language/glossary#index-entry-Spesh)（更快，以橙色表示），以及弹跳（以绿色表示最快）。

This file will open to the "Overview" section, which gives some overall data about how the program ran, e.g., total runtime, time spent doing garbage collection. One important piece of information you'll get here is percentage of the total call frames (i.e., blocks) that were interpreted (slowest, in red), [speshed](https://docs.raku.org/language/glossary#index-entry-Spesh) (faster, in orange), and jitted (fastest, in green).

下一节，“Routines”，可能是你花的时间最多的地方。它有一个可排序和可过滤的例程（或代码块）名称+文件+行，它运行的次数，包含的时间（在从它调用的所有例程中花费在该例程中的时间），独占时间（仅用于该例程的时间），以及它是被解释的、 spesh 还是 JIT 的（与 “Overview” 页面相同的颜色代码）。按排他性时间排序是知道从哪里开始优化的好方法。以 `SETTING::src/core/` 或 `gen/moar/` 开头的文件名的例程来自编译器，查看自己代码中的内容的一个好方法是将你分析的脚本的文件名放在 "Name" 搜索框中。

The next section, "Routines", is probably where you'll spend the most time. It has a sortable and filterable table of routine (or block) name+file+line, the number of times it ran, the inclusive time (time spent in that routine + time spent in all routines called from it), exclusive time (just the time spent in that routine), and whether it was interpreted, speshed, or jitted (same color code as the "Overview" page). Sorting by exclusive time is a good way to know where to start optimizing. Routines with a filename that starts like `SETTING::src/core/` or `gen/moar/` are from the compiler, a good way to just see the stuff from your own code is to put the filename of the script you profiled in the "Name" search box.

“Call Graph” 部分给出了与 “Routines” 部分相同的大部分信息的火焰图表示。

The "Call Graph" section gives a flame graph representation of much of the same information as the "Routines" section.

“Allocations” 部分为你提供了有关分配的不同类型的数量以及哪个例程在执行分配。

The "Allocations" section gives you information about the amount of different types that were allocated, as well as which routines did the allocating.

"GC" 部分提供了发生的有关所有垃圾收集的详细信息。

The "GC" section gives you detailed information about all the garbage collections that occurred.

“OSR / Deopt” 部分为你提供了关于堆栈替换（OSR）的信息，这是例程从解释升级到 spesh 或 jit 的时候。Deopt 的情况正好相反，当 spesh 或 jit 代码时，必须将其“降级”为被解释。

The "OSR / Deopt" section gives you information about On Stack Replacements (OSRs), which is when routines are "upgraded" from interpreted to speshed or jitted. Deopts are the opposite, when speshed or jitted code has to be "downgraded" to being interpreted.

如果分析文件数据太大，浏览器打开文件可能需要很长时间。在这种情况下，使用 `--profile=filename` 选项将输出输出到扩展名为 `.json` 的文件，然后使用 [QT 查看器](https://github.com/tadzik/p6profiler-qt)打开文件。

If the profile data is too big, it could take a long time for a browser to open the file. In that case, output to a file with a `.json` extension using the `--profile=filename` option, then open the file with the [Qt viewer](https://github.com/tadzik/p6profiler-qt).

要处理更大的概要文件，请将其输出到扩展名为 `.sql` 的文件中。这将把概要文件数据写成一系列 SQL 语句，适合在 SQLite 中打开。

To deal with even larger profiles, output to a file with a `.sql` extension. This will write the profile data as a series of SQL statements, suitable for opening in SQLite.

```Raku
# create a profile 
perl6 --profile=demo.sql -e 'say (^20).combinations(3).elems'
 
# create a SQLite database 
sqlite3 demo.sqlite
 
# load the profile data 
sqlite> .read demo.sql
 
# the query below is equivalent to the default view of the "Routines" tab in the HTML profile 
sqlite> select
      case when r.name = "" then "<anon>" else r.name end as name,
      r.file,
      r.line,
      sum(entries) as entries,
      sum(case when rec_depth = 0 then inclusive_time else 0 end) as inclusive_time,
      sum(exclusive_time) as exclusive_time
    from
      calls c,
      routines r
    where
      c.id = r.id
    group by
      c.id
    order by
      inclusive_time desc
    limit 30;
```

正在开发中的下一代分析器是 [moarperf](https://github.com/timo/moarperf)，与原始分析器相比它可以接受 .sql 或者 SQLite 文件并有各种新功能。但是，它与相对独立的原始分析器有更多的依赖关系，因此在使用它之前，你必须先安装一些模组。

The in-progress, next-gen profiler is [moarperf](https://github.com/timo/moarperf), which can accept .sql or SQLite files and has a bunch of new functionality compared to the original profiler. However, it has more dependencies than the relatively stand-alone original profiler, so you'll have to install some modules before using it.

要了解如何解释分析信息，请使用 `prof-m: your code goes here`（上面解释过），并在 IRC 通道上提问。

To learn how to interpret the profile info, use the `prof-m: your code goes here` evalbot (explained above) and ask questions on the IRC channel.

<a id="分析编译过程--profile-compiling"></a>
## 分析编译过程 / Profile compiling

如果要分析编译代码所需的时间和内存，请使用 Rakudo 的 `--profile-compile` 或 `--profile-stage` 选项。

If you want to profile the time and memory it takes to compile your code, use Rakudo's `--profile-compile` or `--profile-stage` options.

<a id="创建或查看基准--create-or-view-benchmarks"></a>
## 创建或查看基准 / Create or view benchmarks

使用 [perl6-bench](https://github.com/japhb/perl6-bench)。

Use [perl6-bench](https://github.com/japhb/perl6-bench).

如果你为多个编译器运行 perl6-bench（通常是 Perl 5、Raku 或 NQP 的版本），则每个编译器的结果都会在相同的图形上可视化地覆盖，以提供快速和容易的比较。

If you run perl6-bench for multiple compilers (typically, versions of Perl 5, Raku, or NQP), results for each are visually overlaid on the same graphs, to provide for quick and easy comparison.

<a id="共享问题--share-problems"></a>
## 共享问题 / Share problems

一旦你使用了上述技术来识别要改进的代码，你就可以开始解决（并与其他人分享）问题：

Once you've used the above techniques to identify the code to improve, you can then begin to address (and share) the problem with others:

- 对于每个问题，将其提炼为一行代码或其主旨，或者提供性能编号，或者使代码片段足够小，以便可以使用 `prof-m: your code or gist URL goes here` 来对其进行分析。
- 考虑一下你所需要/想要的最低提速(或减少内存什么的)，并考虑与实现这个目标相关的成本。就人们的时间和精力而言，改进的价值是什么？
- 让其他人知道你的 Raku 用例是在生产环境中还是只是为了好玩。

- For each problem, distill it down to a one-liner or the gist and either provide performance numbers or make the snippet small enough that it can be profiled using `prof-m: your code or gist URL goes here`.
- Think about the minimum speed increase (or ram reduction or whatever) you need/want, and think about the cost associated with achieving that goal. What's the improvement worth in terms of people's time and energy?
- Let others know if your Raku use-case is in a production setting or just for fun.

<a id="解决问题--solve-problems"></a>
# 解决问题 / Solve problems

这是值得重复的：**确保你没有在错误的代码上浪费时间**。首先确定代码的[“关键的 3%”](https://en.wikiquote.org/wiki/Donald_Knuth)。

This bears repeating: **make sure you're not wasting time on the wrong code**. Start by identifying the ["critical 3%"](https://en.wikiquote.org/wiki/Donald_Knuth) of your code.

<a id="逐行--line-by-line"></a>
## 逐行 / Line by line

一种快速、有趣、高效的尝试逐行改进代码的方法是使用 [raku](https://docs.raku.org/language/glossary#IRC) 的 evalbot [camelia](https://docs.raku.org/language/glossary#camelia) 与其他人协作。

A quick, fun, productive way to try improve code line-by-line is to collaborate with others using the [raku](https://docs.raku.org/language/glossary#IRC) evalbot [camelia](https://docs.raku.org/language/glossary#camelia).

<a id="逐个例程--routine-by-routine"></a>
## 逐个例程 / Routine by routine

使用多分派，你可以在现有例程的“旁边”加入新的变体：

With multi-dispatch, you can drop in new variants of routines "alongside" existing ones:

```Raku
# existing code generically matches a two arg foo call: 
multi sub foo(Any $a, Any $b) { ... }
 
# new variant takes over for a foo("quux", 42) call: 
multi sub foo("quux", Int $b) { ... }
```

拥有多个 `foo` 定义的调用开销通常是微不足道的（尽管请参阅下面关于 `where` 的讨论），因此如果你的新定义比以前存在的一组定义更有效地处理其特定情况，那么你可能只是使你的代码在这种情况下效率更高。

The call overhead of having multiple `foo` definitions is generally insignificant (though see discussion of `where` below), so if your new definition handles its particular case more efficiently than the previously existing set of definitions, then you probably just made your code that much more efficient for that case.

<a id="加快类型检查和调用解析--speed-up-type-checks-and-call-resolution"></a>
## 加快类型检查和调用解析 / Speed up type-checks and call resolution

大多数 [`where` 子句](https://docs.raku.org/type/Signature#Type_constraints)、 大多数[子集](https://design.perl6.org/S12.html#Types_and_Subtypes)、 强制动态（运行时）类型检查和对任何*可能*匹配的调用的调用解析。这比编译时更慢，或者至少更晚。

Most [`where` clauses](https://docs.raku.org/type/Signature#Type_constraints) – and thus most [subsets](https://design.perl6.org/S12.html#Types_and_Subtypes) – force dynamic (runtime) type checking and call resolution for any call it *might* match. This is slower, or at least later, than compile-time.

方法调用通常被尽可能晚地解析（在运行时动态地），而子例程调用通常在编译时被静态解析。

Method calls are generally resolved as late as possible (dynamically at runtime), whereas sub calls are generally resolved statically at compile-time.

<a id="选择更好的算法--choose-better-algorithms"></a>
## 选择更好的算法 / Choose better algorithms

做出大性能改进最可靠的技术，无论是语言或编译器，是选择一个更合适的算法。

One of the most reliable techniques for making large performance improvements, regardless of language or compiler, is to pick a more appropriate algorithm.

一个典型的例子是 [Boyer-Moore](https://en.wikipedia.org/wiki/Boyer%E2%80%93Moore_string_search_algorithm) 算法。要匹配大字符串中的一个小字符串，一个明显的方法是比较这两个字符串的第一个字符，然后，如果它们匹配，比较第二个字符，或者，如果它们不匹配，比较小字符串的第一个字符和大字符串中的第二个字符，以此类推。相反，Boyer-Moore 算法首先将小字符串的*最后*字符与大字符串中相应的定位字符进行比较。对于大多数字符串，Boyer-Moore 算法在快了接近 N 倍的速度，其中 N 是小字符串的长度。

A classic example is [Boyer-Moore](https://en.wikipedia.org/wiki/Boyer%E2%80%93Moore_string_search_algorithm). To match a small string in a large string, one obvious way to do it is to compare the first character of the two strings and then, if they match, compare the second characters, or, if they don't match, compare the first character of the small string with the second character in the large string, and so on. In contrast, the Boyer-Moore algorithm starts by comparing the *last* character of the small string with the correspondingly positioned character in the large string. For most strings, the Boyer-Moore algorithm is close to N times faster algorithmically, where N is the length of the small string.

接下来的几节讨论了算法改进的两大类，它们在 Raku 中特别容易实现。有关这个一般性主题的更多信息，请阅读[算法效率](https://en.wikipedia.org/wiki/Algorithmic_efficiency)上的 wikipedia 页面，特别是末尾的“请参阅”一节。

The next couple sections discuss two broad categories for algorithmic improvement that are especially easy to accomplish in Raku. For more on this general topic, read the wikipedia page on [algorithmic efficiency](https://en.wikipedia.org/wiki/Algorithmic_efficiency), especially the 'See also' section near the end.

<a id="将顺序阻塞代码改为并行非阻塞代码---change-sequentialblocking-code-to-parallelnon-blocking"></a>
### 将顺序/阻塞代码改为并行/非阻塞代码 - Change sequential/blocking code to parallel/non-blocking

这是另一种非常重要的算法改进。

This is another very important class of algorithmic improvement.

参见 [Raku 中的并行、并发和异步](https://jnthn.net/papers/2015-yapcasia-concurrency.pdf#page=17)和/或[匹配视频](https://www.youtube.com/watch?v=JpqnNCx7wVY&list=PLRuESFRW2Fa77XObvk7-BYVFwobZHdXdK&index=8)。

See the slides for [Parallelism, Concurrency, and Asynchrony in Raku](https://jnthn.net/papers/2015-yapcasia-concurrency.pdf#page=17) and/or [the matching video](https://www.youtube.com/watch?v=JpqnNCx7wVY&list=PLRuESFRW2Fa77XObvk7-BYVFwobZHdXdK&index=8).

<a id="使用现有的高性能代码--use-existing-high-performance-code"></a>
## 使用现有的高性能代码 / Use existing high performance code

在 Raku 和 [Nativecall](https://docs.raku.org/language/nativecall) 中可以使用大量高性能的 C 库，从而很容易为它们创建包装。对 C++ 库也有实验性的支持。

There are plenty of high performance C libraries that you can use within Raku and [NativeCall](https://docs.raku.org/language/nativecall) makes it easy to create wrappers for them. There's experimental support for C++ libraries, too.

如果你想[在 Raku 中使用 Perl 5 模组](https://stackoverflow.com/a/27206428/1077672)，可以混合 Raku 类型和[元对象协议](https://docs.raku.org/language/mop)。

If you want to [use Perl 5 modules in Raku](https://stackoverflow.com/a/27206428/1077672), mix in Raku types and the [Metaobject Protocol](https://docs.raku.org/language/mop).

更广泛地说，Raku 是为了与其他语言顺利地互操作而设计的，并且有许多[模组，旨在帮助使用来自其他语言的库](https://modules.perl6.org/#q=inline)。

More generally, Raku is designed to smoothly interoperate with other languages and there are a number of [modules aimed at facilitating the use of libs from other langs](https://modules.perl6.org/#q=inline).

<a id="使-rakudo-编译器生成更快的代码--make-the-rakudo-compiler-generate-faster-code"></a>
## 使 Rakudo 编译器生成更快的代码 / Make the Rakudo compiler generate faster code

到目前为止，编译器关注的焦点一直是正确性，而不是它生成代码的速度，也不是它生成的代码运行的速度或倾斜速度。但这会最终改变。你可以在 freenode IRC 通道 #raku 和 #moarvm 上与编译器开发人员讨论预期的内容。更好的是，你可以自己贡献：

To date, the focus for the compiler has been correctness, not how fast it generates code or how fast or lean the code it generates runs. But that's expected to change, eventually... You can talk to compiler devs on the freenode IRC channels #raku and #moarvm about what to expect. Better still, you can contribute yourself:

- Rakudo 主要使用 Raku 编写。因此，如果你可以编写 Raku，那么你可以在编译器上 hack，包括优化任何影响代码速度的现有高级代码（以及其他人）的任何大型代码。
- 大部分编译器是用一种名为 [NQP](https://github.com/perl6/nqp) 的小语言编写的，它基本上是 Raku 的一个子集。如果你可以编写 Raku，那么你也可以很容易地学习使用和改进中级 NQP 代码，至少从纯语言的角度来看是这样。要深入了解 NQP 和 Rakudo，可以从[NQP 和内部课程](https://edumentab.github.io/rakudo-and-nqp-internals-course/)开始。
- 如果低级别 C hacking 是你的乐趣，请查看 [MoarVM](https://moarvm.org/) 并访问 freenode IRC 通道 #moarvm ([logs](https://colabti.org/irclogger/irclogger_logs/moarvm))。

- Rakudo is largely written in Raku. So if you can write Raku, then you can hack on the compiler, including optimizing any of the large body of existing high-level code that impacts the speed of your code (and everyone else's).
- Most of the rest of the compiler is written in a small language called [NQP](https://github.com/perl6/nqp) that's basically a subset of Raku. If you can write Raku, you can fairly easily learn to use and improve the mid-level NQP code too, at least from a pure language point of view. To dig into NQP and Rakudo's guts, start with [NQP and internals course](https://edumentab.github.io/rakudo-and-nqp-internals-course/).
- If low-level C hacking is your idea of fun, checkout [MoarVM](https://moarvm.org/) and visit the freenode IRC channel #moarvm ([logs](https://colabti.org/irclogger/irclogger_logs/moarvm)).

<a id="还需要更多的想法？--still-need-more-ideas"></a>
## 还需要更多的想法？ / Still need more ideas?

目前一些已知的 Rakudo 性能弱点还没有在本页面中讨论过，包括一般地使用 gather/take、junction、正则表达式和字符串处理。

Some known current Rakudo performance weaknesses not yet covered in this page include the use of gather/take, junctions, regexes, and string handling in general.

如果你认为某些主题需要在这个页面上有更多介绍，请提交一个 PR 或告诉别人你的想法。谢谢。:)

If you think some topic needs more coverage on this page, please submit a PR or tell someone your idea. Thanks. :)

<a id="得不到你想要的结果？--not-getting-the-results-you-needwant"></a>
# 得不到你想要的结果？ / Not getting the results you need/want?

如果你在此页面上尝试了所有内容，请考虑在 #raku 于编译器开发者讨论，这样我们就可以从你的用例和迄今为止发现的内容中学习。

If you've tried everything on this page to no avail, please consider discussing things with a compiler dev on #raku, so we can learn from your use-case and what you've found out about it so far.

一旦开发人员知道了你的困境，就允许有足够的时间进行知情的响应（几天或几周，取决于你问题的确切性质和潜在的解决方案）。

Once a dev knows of your plight, allow enough time for an informed response (a few days or weeks, depending on the exact nature of your problem and potential solutions).

如果*那*还没有解决，请考虑在[我们的用户体验代码库](https://github.com/perl6/user-experience/issues)上提交一个关于你的体验的问题。

If *that* hasn't worked out, please consider filing an issue about your experience at [our user experience repo](https://github.com/perl6/user-experience/issues) before moving on.

谢谢。 :)

Thanks. :)
