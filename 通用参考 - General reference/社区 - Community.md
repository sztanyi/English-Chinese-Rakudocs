原文：https://docs.raku.org/language/community

# 社区 / Community

关于为 Raku 做贡献和使用 Raku 的人们的信息

Information about the people working on and using Raku

<!-- MarkdownTOC -->

- [概述 / Overview](#%E6%A6%82%E8%BF%B0--overview)
- [Raku 社区 / The Raku community](#raku-%E7%A4%BE%E5%8C%BA--the-raku-community)
  - [在线社区 / Online communities](#%E5%9C%A8%E7%BA%BF%E7%A4%BE%E5%8C%BA--online-communities)
  - [IRC 机器人 / IRC bots](#irc-%E6%9C%BA%E5%99%A8%E4%BA%BA--irc-bots)
  - [线下社区 / Offline communities](#%E7%BA%BF%E4%B8%8B%E7%A4%BE%E5%8C%BA--offline-communities)
  - [其他资源 / Other resources](#%E5%85%B6%E4%BB%96%E8%B5%84%E6%BA%90--other-resources)
- [Raku 周刊 / Raku Weekly](#raku-%E5%91%A8%E5%88%8A--raku-weekly)
- [Raku Advent 日历 / Raku Advent calendar](#raku-advent-%E6%97%A5%E5%8E%86--raku-advent-calendar)

<!-- /MarkdownTOC -->


<a id="%E6%A6%82%E8%BF%B0--overview"></a>
# 概述 / Overview

“Perl 5 是我对 Perl 的改写。我希望 Perl 6 是社区对 Perl 的改写，并且是属于社区的。” - Larry Wall（2000 年左右）

"Perl 5 was my rewrite of Perl. I want Perl 6 to be the community's rewrite of Perl and of the community." - Larry Wall (circa 2000)

“我赞成这种改变（社区驱动把 Perl 6 更名为 Raku，因为它反映了一种古老的智慧：‘没有人把新布补在旧衣服上，因为补丁会从衣服上拉开，使撕裂更严重。人们也不会把新酒倒进旧酒皮里。如果他们这样做，皮就会破裂，酒就会耗尽，酒皮就会被毁。不，他们把新酒倒在新酒皮上，两者都保存了下来。-拉里·沃尔（[2019](https://github.com/perl6/problem-solving/pull/89#pullrequestreview-300789072)

"I am in favor of this change [a community driven renaming from Perl 6 to Raku, because it reflects an ancient wisdom: 'No one sews a patch of unshrunk cloth on an old garment, for the patch will pull away from the garment, making the tear worse. Neither do people pour new wine into old wineskins. If they do, the skins will burst; the wine will run out and the wineskins will be ruined. No, they pour new wine into new wineskins, and both are preserved.'" - Larry Wall ([2019](https://github.com/perl6/problem-solving/pull/89#pullrequestreview-300789072))

<a id="raku-%E7%A4%BE%E5%8C%BA--the-raku-community"></a>
# Raku 社区 / The Raku community

<a id="%E5%9C%A8%E7%BA%BF%E7%A4%BE%E5%8C%BA--online-communities"></a>
## 在线社区 / Online communities

`#raku` 频道是在 2019 年 10 月创建的，随着它成为默认频道，它将变得更加活跃。最终，与 `#perl6` 的连接将重定向到 `#raku`，但历史日志将保留在 `#perl6` 频道上。在 `freenode.net` 上的 [`#raku`](https://raku.org/community/irc) 频道一直有很多开发人员，他们乐于提供支持和回答问题，或者只是把它作为一个友好的地方闲逛。请查看此 [IRC lingo](http://www.ircbeginner.com/ircinfo/abbreviations.html) 资源，以了解那里经常使用的缩写。[StackOverflow](https://stackoverflow.com/questions/tagged/raku?tab=Newest) 也是一个很好的资源，可以提出问题，帮助他人解决 Raku 的问题和挑战。更多的资源可以在 [raku.org 社区页面](https://raku.org/community/)找到。

The `#raku` channel was created in October 2019, and will become more active as it becomes the default channel. Eventually, connections to the `#perl6` will be redirected to `#raku`, but the historical logs will remain on the `#perl6` channel. The [`#raku`](https://raku.org/community/irc) channel on `freenode.net` has always had a large presence with many developers, who are happy to provide support and answer questions, or just use it as a friendly place to hang out. Check out this [IRC lingo](http://www.ircbeginner.com/ircinfo/abbreviations.html) resource for the abbreviations frequently used there. [StackOverflow](https://stackoverflow.com/questions/tagged/perl6) is also a great resource for asking questions and helping others with their Raku problems and challenges. More resources can be found in the [raku.org community page](https://raku.org/community/).

<a id="irc-%E6%9C%BA%E5%99%A8%E4%BA%BA--irc-bots"></a>
## IRC 机器人 / IRC bots

IRC 频道有一些非常有趣的机器人。这是一个完整的列表，有机器人的名称，到更多信息的链接和简短的描述。

The IRC channel has some very interesting bots. This is a full list with the name of the bot, a link to more information and a short description.

- **benchable** ([details](https://github.com/Raku/whateverable/wiki/Benchable))

  用于在给定的 Rakudo 提交上对代码进行基准测试的IRC 机器人。它可以用它的全名（‘benchable6’）或它的短名（‘bench’）来称呼。它将运行给定的代码五次，并返回所花费的最小时间。

  An IRC bot for benchmarking code at a given commit of Rakudo. It can be addressed by its full name ('benchable6') or its short name ('bench'). It will run the given code five times and return the minimum amount of time taken.

- **bisectable** ([details](https://github.com/Raku/whateverable/wiki/Bisectable))

  这个机器人是为了帮助你找到什么东西坏了。如果你想知道某件事是否曾经工作过，请使用 Committable 代替。

  This bot is meant to help you find when something got broken. If you want to know if something has ever worked use Committable instead.

- **bloatable** ([details](https://github.com/Raku/whateverable/wiki/Bloatable))

  一个用于在 MoarVM 的 libmoar.so 文件上运行 bloaty 的 IRC 机器人。它可以用它的全名（‘bloatable6’）或它的短名（‘bloat’ 或 ‘bloaty’）来称呼。它将运行 bloaty，并从 MoarVM 的不同修订中传递一个或多个 libmoar.so 文件。

  An IRC bot for running bloaty on libmoar.so files of MoarVM. It can be addressed by its full name ('bloatable6') or its short name ('bloat' or 'bloaty'). It will run bloaty and pass one or more libmoar.so files from different revisions of MoarVM.

- **buggable** ([details](https://github.com/raku-community-modules/perl6-buggable))
  
  RT 队列搜索和实用程序机器人。
  
  RT queue search and utility bot.

- **camelia**
  
  Raku 代码评估机器人。我们使用这个来现场测试其他人可能感兴趣的代码；它会在频道上回答。`raku: my $a` 将对 Rakudo 和 niecza 的最新修订进行测试，`nqp: say('foo')` 将测试 nqp，`std: my $a` 将使用 STD.pm6 解析表达式。对于其他编译器，请尝试 `camelia: help`。

  Raku code evaluation bot. We use this for live testing of code that may be of interest to others; it chats back to the channel. `perl6: my $a` will result in a test against the latest revisions of rakudo and niecza, `nqp: say('foo')` will test nqp, `std: my $a` will parse the expression using STD.pm6. For other compilers, try `camelia: help`.

- **committable** ([details](https://github.com/Raku/whateverable/wiki/Committable))

  一个 IRC 机器人，用于在给定的 Rakudo 提交上运行代码。它可以用它的全名（‘committable6’）或它的短名（‘commit’，‘c’）来称呼。

  An IRC bot for running code at a given commit of Rakudo. It can be addressed by its full name ('committable6') or its short names ('commit', 'c').

- **coverable** ([details](https://github.com/Raku/whateverable/wiki/Coverable))
  
  用于创建在运行你给它的代码时被击中的 Rakudo（和 NQP）源代码的覆盖报告。第一个选项是提交，第二个（可选）选项是筛选你想要的 MoarVM 生成的覆盖日志的行，第三个是要运行的代码。

  An IRC bot for creating a coverage report of the Rakudo (and NQP) source lines that were hit while running the code you give it. The first option is the commit, the second (optional) option is the filter for what lines of the MoarVM-generated coverage log you want, the third is the code to run.

- **Geth** ([details](https://github.com/perl6/geth))

  宣布致力于与 Raku 有关的各种项目，例如实现 Raku 和一些 [Raku 拥有的仓库](https://github.com/raku/)。

  Announces commits made to various projects relevant to Raku, such as implementations of Raku and some of the [repositories owned by Raku](https://github.com/perl6/).

- **evalable** ([details](https://github.com/Raku/whateverable/wiki/Evalable))
  
  evalable 只是默认为 `HEAD` 的 Committable。

  Evalable is just Committable that defaults to `HEAD`.

- **greppable** ([details](https://github.com/Raku/whateverable/wiki/Greppable))

  用于在模块生态系统中进行搜索。它可以用它的全名（‘greppable6’）或它的短名（‘grep’）来称呼。

  An IRC bot for grepping through the module ecosystem. It can be addressed by its full name ('greppable6') or its short name ('grep').

- **huggable** ([details](https://github.com/raku-community-modules/huggable))

  让我们在频道里互相拥抱。

  Let's you `.hug` people in the channel.

- **ilbot** ([details](https://github.com/moritz/ilbot))
  
  IRC 日志机器人。

  IRC logging bot.

- **nativecallable** ([details](https://github.com/Raku/whateverable/wiki/Nativecallable))

  用于从 C 定义生成 Raku NativeCall 代码。它可以用它的全名（‘nativecallable6’）或它的短名（‘nativecall’）来称呼。机器人正在使用 `App::GPTrixie` 进行转换。

  an IRC bot for generating Perl 6 NativeCall code from C definitions. It can be addressed by its full name ('nativecallable6') or its short name ('nativecall'). The bot is using `App::GPTrixie` to do the conversion.

- **notable** ([details](https://github.com/Raku/whateverable/wiki/Notable))

  一个用于记录的 IRC 机器人。它可以用它的全名（‘notable6’）或它的短名（‘note’）来称呼。还有 “weekly:” 的简称。

  an IRC bot for for noting things. It can be addressed by its full name ('notable6') or its short name ('note'). There is also a “weekly:” shortcut.

- **quotable** ([details](https://github.com/Raku/whateverable/wiki/Quotable))
  
  一个用于在 IRC 日志中搜索消息的 IRC 机器人.它可以用它的全名（‘quotable6’）或它的短名（‘quote’）来称呼。

  An IRC bot for searching messages in the IRC log. It can be addressed by its full name ('quotable6') or its short name ('quote').

- **releasable** ([details](https://github.com/Raku/whateverable/wiki/Releasable))
  
  用于获取即将发布的信息。它可以用它的全名（'releasable6'）或它的短名（‘release’）来称呼。

  An IRC bot for getting information about the upcoming release. It can be addressed by its full name ('releasable6') or its short name ('release').

  作为一个用户，你可能只对它唯一的命令 “status” 感兴趣。它告诉你下一个版本将在什么时候发生，以及有多少个拦截器。

  As a user, you are probably only interested in its only command “status”. It tells when the next release is going to happen and how many blockers are there.

- **reportable** ([details](https://github.com/Raku/whateverable/wiki/Reportable))
  
  用于生成关于 Rakudo RT 和 GitHub 问题跟踪器变化的报告（这些问题被解决、更新、拒绝等）。它可以用它的全名（‘reportable6’）或它的短名（‘report’）来称呼。它定期获取问题跟踪器的快照，然后你可以要求它为两个给定的快照生成报告。

  An IRC bot for generating reports of changes in rakudo RT and GitHub issue trackers (which issues were resolved, updated, rejected, etc.). It can be addressed by its full name ('reportable6') or its short name ('report'). It takes snapshots of issue trackers periodically, and then you can ask it to generate a report for two given snapshots.

  另见： [Weekly, Monthly and Yearly reports](https://github.com/rakudo/rakudo/wiki/Ticket-updates)

  See also: [Weekly, Monthly and Yearly reports](https://github.com/rakudo/rakudo/wiki/Ticket-updates)

- **shareable** ([details](https://github.com/Raku/whateverable/wiki/Shareable))

  用于由 Whatever 公开提供的 rakudo 构建。它可以用它的全名（‘shareable6’）来称呼。

  An IRC bot for making rakudo builds produced by Whateverable publicly available. It can be addressed by its full name ('shareable6').

  请注意，构建将位于 `/tmp/everyable/rakudo-moar/SOME-SHA/`。而且，从今天起，这些文件只有在 linux x86_64 上才对你有用。

  Note that the build will be located in `/tmp/whateverable/rakudo-moar/SOME-SHA/`. Also, as of today these files are only useful for you if you're on linux x86_64.

- **SourceBaby** ([details](https://github.com/zoffixznet/perl6-sourceable))
  
  核心源代码定位器

  Core source code locator

- **squashable** ([details](https://github.com/Raku/whateverable/wiki/Squashable))
  
  Monthly Bug Squash Day（a.k.a. Community Bug SQUASHathon）IRC 机器人。它可以用它的全名（‘quashable6’）或它的短名（‘quash’）来称呼。它可以告诉你下一个事件什么时候发生，以及活动事件的当前状态是什么。此外，它还将宣布代码仓库的变更。

  An IRC bot for the Monthly Bug Squash Day (a.k.a. Community Bug SQUASHathon). It can be addressed by its full name ('squashable6') or its short name ('squash'). It can tell you when the next event is going to happen and what's the current status of the active event. Also, it will also announce changes to the repo.

- **statisfiable** ([details](https://github.com/Raku/whateverable/wiki/Statisfiable))
  
  一个 IRC 机器人，可以收集统计跨拉库多建设。它可以用它的全名（‘statisfiable6’）或它的短名（‘stat’）来称呼。对于大多数命令，它将用一个具有图表和原始数据的 gist 进行回复。请注意，统计数据是缓存的，但它需要一些时间来生成图表，所以要有耐心。

  An IRC bot that can gather stats across rakudo builds. It can be addressed by its full name ('statisfiable6') or its short name ('stat'). For most commands it will reply with a gist that has a graph and the raw data. Note that stats are cached, but it takes some time for it to generate the graph, so be patient.

- **synopsebot6** ([details](https://github.com/perl6/synopsebot))

  创建到概要的链接，并将 RT 票证编号的提及转换为可点击的 RT 链接。

  Creates links to the synopses and turns mentions of RT ticket numbers into clickable RT links.

- **tellable** ([details](https://github.com/Raku/whateverable/wiki/Tellable))
  
  用于将消息传递给当前脱机的用户。你也可以用它来看看最后一次有人说话是什么时候。

  An IRC bot for passing messages to users who are currently offline. You can also use it to see when was the last time somebody talked.

- **Undercover** ([details](https://github.com/zoffixznet/undercover))
  
  非常类似于 SourceBaby，除了指向 [rakudo.party](https://wtf.rakudo.party/) 表示代码的压力测试覆盖范围。

  Very similar to SourceBaby, except points to [rakudo.party](https://wtf.rakudo.party/) indicating stress test coverage of code.

- **undersightable** ([details](https://github.com/Raku/whateverable/wiki/Undersightable))

  用于检查重要的东西是否正确运行（网站已启动，机器人在线，发布的 tarball 是正确的等）。它可以用它的全名（‘undersightable6’）来称呼。

  An IRC bot for checking that important things are operating correctly (websites are up, bots are online, released tarballs are correct, etc.). It can be addressed by its fullname ('undersightable6').

- **unicodable** ([details](https://github.com/Raku/whateverable/wiki/Unicodable))

  一个用于获取关于 Unicode 字符的有趣信息的 IRC 机器人。它可以用它的全名（‘Unicodable6’）或它的短名（‘u’）来称呼。

  An IRC bot for getting interesting information about Unicode characters. It can be addressed by its full name ('unicodable6') or its short name ('u').

- **PufferBot** ([details](https://github.com/Kaiepi/p6-RakudoBot))

  用于测试 OpenBSD 上的 Rakudo 构建。它可以用它的全名（“PufferBot”）来寻址。只在 [perl6-dev](https://webchat.freenode.net/?channels=#raku-dev) 进行会谈。

  An IRC bot for testing builds of Rakudo on OpenBSD. It can be addressed by its full name ('PufferBot'). Talks only in [perl6-dev](https://webchat.freenode.net/?channels=#raku-dev).

- **BeastieBot** ([details](https://github.com/Kaiepi/p6-RakudoBot))

  一个用于测试 FreeBSD 上的 Rakudo 构建的 IRC 机器人。它可以用它的全名（“BeastieBot”）来称呼。只在 [perl6-dev](https://webchat.freenode.net/?channels=#raku-dev) 进行会谈。

  An IRC bot for testing builds of Rakudo on FreeBSD. It can be addressed by its full name ('BeastieBot'). Talks only in [perl6-dev](https://webchat.freenode.net/?channels=#raku-dev).

<a id="%E7%BA%BF%E4%B8%8B%E7%A4%BE%E5%8C%BA--offline-communities"></a>
## 线下社区 / Offline communities

Raku 也是 [Perl 会议](https://www.perl.org/events.html) 和 [Perl Monger 会议](https://www.pm.org/) 和[其他会议](https://perl.meetup.com/)的共同话题。如果你喜欢面对面的会议，这些都是热情推荐的！

Raku is also a common topic at [Perl conferences](https://www.perl.org/events.html) and [Perl Monger meetings](https://www.pm.org/) and [other meetups](https://perl.meetup.com/). If you prefer in-person meetings, these are warmly recommended!

<a id="%E5%85%B6%E4%BB%96%E8%B5%84%E6%BA%90--other-resources"></a>
## 其他资源 / Other resources

[Camelia](https://raku.org/)，这只翅膀上有 P 和 6 的多色蝴蝶，是这个多元化和欢迎社区的象征。

[Camelia](https://raku.org/), the multi-color butterfly with P 6 in her wings, is the symbol of this diverse and welcoming community.

<a id="raku-%E5%91%A8%E5%88%8A--raku-weekly"></a>
# Raku 周刊 / Raku Weekly

伊丽莎白·马蒂杰森通常在 [“Raku 周刊”博客](https://p6weekly.wordpress.com/)上发表文章，总结 Raku 的帖子、推特、评论和其他有趣的花絮。如果你想让一个资源知道 Raku 社区现在发生了什么，这是你最好的资源。

Elizabeth Mattijsen usually posts in [the "Raku Weekly" blog](https://p6weekly.wordpress.com/), a summary of Raku posts, tweets, comments and other interesting tidbits. If you want a single resource to know what is going on in the Raku community now, this is your best resource.

<a id="raku-advent-%E6%97%A5%E5%8E%86--raku-advent-calendar"></a>
# Raku Advent 日历 / Raku Advent calendar

Raku 社区每年 12 月都会出版一本[Advent Calendar](https://perl6advent.wordpress.com/)，每天都有 Raku 教程，直到圣诞节。组织和任务是通过不同的 Raku 频道和 [Perl6/Advent](https://github.com/perl6/advent)存储库完成的。如果你想参加，它的组织在 10 月底开始，所以请查看上面的频道以保持最新。

The Raku community publishes every December an [Advent Calendar](https://perl6advent.wordpress.com/), with Raku tutorials every day until Christmas. Organization and assignment of days is done through the different Raku channels and the [Perl6/advent](https://github.com/perl6/advent) repository. If you want to participate, its organization starts by the end of October, so check out the channels above to keep up to date.
