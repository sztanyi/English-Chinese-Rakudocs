# Performance

Measuring and improving runtime or compile-time performance

Table of Contents[First, profile your code](https://rakudocs.github.io/language/performance#First,_profile_your_code)[Time with `now - INIT now`](https://rakudocs.github.io/language/performance#Time_with_now_-_INIT_now)[Profile locally](https://rakudocs.github.io/language/performance#Profile_locally)[Profile compiling](https://rakudocs.github.io/language/performance#Profile_compiling)[Create or view benchmarks](https://rakudocs.github.io/language/performance#Create_or_view_benchmarks)[Share problems](https://rakudocs.github.io/language/performance#Share_problems)[Solve problems](https://rakudocs.github.io/language/performance#Solve_problems)[Line by line](https://rakudocs.github.io/language/performance#Line_by_line)[Routine by routine](https://rakudocs.github.io/language/performance#Routine_by_routine)[Speed up type-checks and call resolution](https://rakudocs.github.io/language/performance#Speed_up_type-checks_and_call_resolution)[Choose better algorithms](https://rakudocs.github.io/language/performance#Choose_better_algorithms)[Change sequential/blocking code to parallel/non-blocking](https://rakudocs.github.io/language/performance#Change_sequential/blocking_code_to_parallel/non-blocking)[Use existing high performance code](https://rakudocs.github.io/language/performance#Use_existing_high_performance_code)[Make the Rakudo compiler generate faster code](https://rakudocs.github.io/language/performance#Make_the_Rakudo_compiler_generate_faster_code)[Still need more ideas?](https://rakudocs.github.io/language/performance#Still_need_more_ideas?)[Not getting the results you need/want?](https://rakudocs.github.io/language/performance#Not_getting_the_results_you_need/want?)

This page is about [computer performance](https://en.wikipedia.org/wiki/Computer_performance) in the context of Raku.

# First, profile your code

**Make sure you're not wasting time on the wrong code**: start by identifying your ["critical 3%"](https://en.wikiquote.org/wiki/Donald_Knuth) by profiling your code's performance. The rest of this document shows you how to do that.

## Time with `now - INIT now`

Expressions of the form `now - INIT now`, where `INIT` is a [phase in the running of a Raku program](https://rakudocs.github.io/language/phasers), provide a great idiom for timing code snippets.

Use the `m: your code goes here` [perl6 channel evalbot](https://rakudocs.github.io/language/glossary#camelia) to write lines like:

```Raku
m: say now - INIT now
rakudo-moar abc1234: OUTPUT«0.0018558␤»
```

The `now` to the left of `INIT` runs 0.0018558 seconds *later* than the `now` to the right of the `INIT` because the latter occurs during [the INIT phase](https://rakudocs.github.io/language/phasers#INIT).

## Profile locally

When using the [MoarVM](https://moarvm.org/) backend, the [Rakudo](https://rakudo.org/) compiler's `--profile` command line option writes the profile data to an HTML file.

This file will open to the "Overview" section, which gives some overall data about how the program ran, e.g., total runtime, time spent doing garbage collection. One important piece of information you'll get here is percentage of the total call frames (i.e., blocks) that were interpreted (slowest, in red), [speshed](https://rakudocs.github.io/language/glossary#index-entry-Spesh) (faster, in orange), and jitted (fastest, in green).

The next section, "Routines", is probably where you'll spend the most time. It has a sortable and filterable table of routine (or block) name+file+line, the number of times it ran, the inclusive time (time spent in that routine + time spent in all routines called from it), exclusive time (just the time spent in that routine), and whether it was interpreted, speshed, or jitted (same color code as the "Overview" page). Sorting by exclusive time is a good way to know where to start optimizing. Routines with a filename that starts like `SETTING::src/core/` or `gen/moar/` are from the compiler, a good way to just see the stuff from your own code is to put the filename of the script you profiled in the "Name" search box.

The "Call Graph" section gives a flame graph representation of much of the same information as the "Routines" section.

The "Allocations" section gives you information about the amount of different types that were allocated, as well as which routines did the allocating.

The "GC" section gives you detailed information about all the garbage collections that occurred.

The "OSR / Deopt" section gives you information about On Stack Replacements (OSRs), which is when routines are "upgraded" from interpreted to speshed or jitted. Deopts are the opposite, when speshed or jitted code has to be "downgraded" to being interpreted.

If the profile data is too big, it could take a long time for a browser to open the file. In that case, output to a file with a `.json` extension using the `--profile=filename` option, then open the file with the [Qt viewer](https://github.com/tadzik/p6profiler-qt).

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

The in-progress, next-gen profiler is [moarperf](https://github.com/timo/moarperf), which can accept .sql or SQLite files and has a bunch of new functionality compared to the original profiler. However, it has more dependencies than the relatively stand-alone original profiler, so you'll have to install some modules before using it.

To learn how to interpret the profile info, use the `prof-m: your code goes here` evalbot (explained above) and ask questions on the IRC channel.

## Profile compiling

If you want to profile the time and memory it takes to compile your code, use Rakudo's `--profile-compile` or `--profile-stage` options.

## Create or view benchmarks

Use [perl6-bench](https://github.com/japhb/perl6-bench).

If you run perl6-bench for multiple compilers (typically, versions of Perl 5, Raku, or NQP), results for each are visually overlaid on the same graphs, to provide for quick and easy comparison.

## Share problems

Once you've used the above techniques to identify the code to improve, you can then begin to address (and share) the problem with others:

- For each problem, distill it down to a one-liner or the gist and either provide performance numbers or make the snippet small enough that it can be profiled using `prof-m: your code or gist URL goes here`.
- Think about the minimum speed increase (or ram reduction or whatever) you need/want, and think about the cost associated with achieving that goal. What's the improvement worth in terms of people's time and energy?
- Let others know if your Raku use-case is in a production setting or just for fun.

# Solve problems

This bears repeating: **make sure you're not wasting time on the wrong code**. Start by identifying the ["critical 3%"](https://en.wikiquote.org/wiki/Donald_Knuth) of your code.

## Line by line

A quick, fun, productive way to try improve code line-by-line is to collaborate with others using the [perl6](https://rakudocs.github.io/language/glossary#IRC) evalbot [camelia](https://rakudocs.github.io/language/glossary#camelia).

## Routine by routine

With multi-dispatch, you can drop in new variants of routines "alongside" existing ones:

```Raku
# existing code generically matches a two arg foo call: 
multi sub foo(Any $a, Any $b) { ... }
 
# new variant takes over for a foo("quux", 42) call: 
multi sub foo("quux", Int $b) { ... }
```

The call overhead of having multiple `foo` definitions is generally insignificant (though see discussion of `where` below), so if your new definition handles its particular case more efficiently than the previously existing set of definitions, then you probably just made your code that much more efficient for that case.

## Speed up type-checks and call resolution

Most [`where` clauses](https://rakudocs.github.io/type/Signature#Type_constraints) – and thus most [subsets](https://design.perl6.org/S12.html#Types_and_Subtypes) – force dynamic (runtime) type checking and call resolution for any call it *might* match. This is slower, or at least later, than compile-time.

Method calls are generally resolved as late as possible (dynamically at runtime), whereas sub calls are generally resolved statically at compile-time.

## Choose better algorithms

One of the most reliable techniques for making large performance improvements, regardless of language or compiler, is to pick a more appropriate algorithm.

A classic example is [Boyer-Moore](https://en.wikipedia.org/wiki/Boyer%E2%80%93Moore_string_search_algorithm). To match a small string in a large string, one obvious way to do it is to compare the first character of the two strings and then, if they match, compare the second characters, or, if they don't match, compare the first character of the small string with the second character in the large string, and so on. In contrast, the Boyer-Moore algorithm starts by comparing the *last* character of the small string with the correspondingly positioned character in the large string. For most strings, the Boyer-Moore algorithm is close to N times faster algorithmically, where N is the length of the small string.

The next couple sections discuss two broad categories for algorithmic improvement that are especially easy to accomplish in Raku. For more on this general topic, read the wikipedia page on [algorithmic efficiency](https://en.wikipedia.org/wiki/Algorithmic_efficiency), especially the 'See also' section near the end.

### Change sequential/blocking code to parallel/non-blocking

This is another very important class of algorithmic improvement.

See the slides for [Parallelism, Concurrency, and Asynchrony in Raku](https://jnthn.net/papers/2015-yapcasia-concurrency.pdf#page=17) and/or [the matching video](https://www.youtube.com/watch?v=JpqnNCx7wVY&list=PLRuESFRW2Fa77XObvk7-BYVFwobZHdXdK&index=8).

## Use existing high performance code

There are plenty of high performance C libraries that you can use within Raku and [NativeCall](https://rakudocs.github.io/language/nativecall) makes it easy to create wrappers for them. There's experimental support for C++ libraries, too.

If you want to [use Perl 5 modules in Raku](https://stackoverflow.com/a/27206428/1077672), mix in Raku types and the [Metaobject Protocol](https://rakudocs.github.io/language/mop).

More generally, Raku is designed to smoothly interoperate with other languages and there are a number of [modules aimed at facilitating the use of libs from other langs](https://modules.perl6.org/#q=inline).

## Make the Rakudo compiler generate faster code

To date, the focus for the compiler has been correctness, not how fast it generates code or how fast or lean the code it generates runs. But that's expected to change, eventually... You can talk to compiler devs on the freenode IRC channels #perl6 and #moarvm about what to expect. Better still, you can contribute yourself:

- Rakudo is largely written in Raku. So if you can write Raku, then you can hack on the compiler, including optimizing any of the large body of existing high-level code that impacts the speed of your code (and everyone else's).
- Most of the rest of the compiler is written in a small language called [NQP](https://github.com/perl6/nqp) that's basically a subset of Raku. If you can write Raku, you can fairly easily learn to use and improve the mid-level NQP code too, at least from a pure language point of view. To dig into NQP and Rakudo's guts, start with [NQP and internals course](https://edumentab.github.io/rakudo-and-nqp-internals-course/).
- If low-level C hacking is your idea of fun, checkout [MoarVM](https://moarvm.org/) and visit the freenode IRC channel #moarvm ([logs](https://colabti.org/irclogger/irclogger_logs/moarvm)).

## Still need more ideas?

Some known current Rakudo performance weaknesses not yet covered in this page include the use of gather/take, junctions, regexes, and string handling in general.

If you think some topic needs more coverage on this page, please submit a PR or tell someone your idea. Thanks. :)

# Not getting the results you need/want?

If you've tried everything on this page to no avail, please consider discussing things with a compiler dev on #perl6, so we can learn from your use-case and what you've found out about it so far.

Once a dev knows of your plight, allow enough time for an informed response (a few days or weeks, depending on the exact nature of your problem and potential solutions).

If *that* hasn't worked out, please consider filing an issue about your experience at [our user experience repo](https://github.com/perl6/user-experience/issues) before moving on.

Thanks. :)
