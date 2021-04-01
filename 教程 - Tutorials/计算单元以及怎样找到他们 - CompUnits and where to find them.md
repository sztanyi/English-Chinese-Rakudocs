原文：https://docs.raku.org/language/compilation

# 计算单元以及怎样找到他们 / CompUnits and where to find them

如何和何时编译 Raku 模块，它们存储在哪里，以及如何以编译的形式访问它们。

How and when Raku modules are compiled, where they are stored, and how to access them in compiled form.

<!-- MarkdownTOC -->

- [概述 / Overview](#概述--overview)
- [介绍 / Introduction](#介绍--introduction)
    - [为什么改变？ / Why change?](#为什么改变？--why-change)
    - [长名 / Long names](#长名--long-names)
    - [$*REPO](#$repo)
    - [存储库 / Repositories](#存储库--repositories)
    - [Resources](#resources)
    - [依赖 / Dependencies](#依赖--dependencies)
    - [预编译存储区 / Precomp stores](#预编译存储区--precomp-stores)
    - [Credit](#credit)

<!-- /MarkdownTOC -->


<a id="概述--overview"></a>
# 概述 / Overview

作为 Perl 语系的一员，Raku 的程序往往更多地处于解释 - 编译频谱的解释端。 在本教程中，一个被“解释”的程序意味着源代码，即人类可读的文本，如 `say 'hello world';`，立即被 `Raku` 程序处理成可以由计算机执行的代码，任何中间阶段都存储在内存中。

Programs in Raku, as a member of the Perl language family, tend at the top level to be more at the interpreted end of the interpreted-compiled spectrum. In this tutorial, an 'interpreted' program means that the source code, namely the human-readable text such as `say 'hello world';`, is immediately processed by the `Raku` program into code that can be executed by the computer, with any intermediate stages being stored in memory.

相比之下，编译后的程序首先将人类可读源处理成机器可执行的代码，并将此代码的某种形式存储在光盘上。 为了执行程序，机器可读的版本被加载到内存中，然后由计算机运行。

A compiled program, by contrast, is one where the human readable source is first processed into machine-executable code and some form of this code is stored 'on disc'. In order to execute the program, the machine-readable version is loaded into memory and then run by the computer.

汇编和解释形式各有优点。 简单地说，解释型的程序可以很快地准备好，源码也会很快改变。 编译程序可能是复杂的，需要很长时间才能预处理成机器可读代码，但对用户来说，它们运行时要快得多，用户只能看到加载和运行时间，看不到编译时间。

Both compiled and interpreted forms have advantages. Briefly, interpreted programs can be 'whipped up' quickly and the source changed quickly. Compiled programs can be complex and take a significant time to pre-process into machine-readable code, but then running them is much faster for a user, who only 'sees' the loading and running time, not the compilation time.

`Raku` 有两种范式。 Raku 程序被解释执行，但如果将代码分离成模块，模块将被编译，然后在必要时加载模块的预处理版本。 在实践中，由社区编写的模块只需要由用户在“安装”时预先编译一次，例如由模块管理器（如 `Zef`）安装。 然后，开发人员可以在自己的程序中使用。 其效果是使 `Raku` 上层程序快速运行。

`Raku` has both paradigms. At the **top level** a Raku program is interpreted, but if code that is separated out into a Module will be compiled and the preprocessed version is then loaded when necessary. In practice, Modules that have been written by the community will only need to be precompiled once by a user when they are 'installed', for example by a Module manager such as `zef`. Then they can be `use`d by a developer in her own program. The effect is to make `Raku` top level programs run quickly.

`Perl` 语系的一大优点是能够将一个由称职的程序员编写的模块组成的整个生态系统集成到一个小程序中。 这种力量被广泛复制，现在是所有语言的常态。 `Raku` 更进一步地进行集成，使得 `Raku` 程序将以其他语言编写的系统库集成到 `Raku` 程序中相对容易，参见 [Native Call](https://docs.raku.org/language/nativecall)。

One of the great strengths of the `Perl` family of languages was the ability to integrate a whole ecosystem of modules written by competent programmers into a small program. This strength was widely copied and is now the norm for all languages. `Raku` takes integration even further, making it relatively easy for `Raku` programs to incorporate system libraries written in other languages into `Raku` programs, see [Native Call](https://docs.raku.org/language/nativecall).

`Perl` 和其他语言的经验是，模组的分发本质产生了若干实际困难：

The experience from `Perl` and other languages is that the distributive nature of Modules generate several practical difficulties:

- 当 API 得到改进时，一个流行的模块可能会经过几次迭代，而不能保证有反向兼容性。 因此，如果程序依赖于某些特定的函数或返回，则必须有一种方法来指定*版本*。
- 一个模块可能是由鲍勃编写的，他是一个非常能干的程序员，由于他忙于生活中其他事情，不能维护模块了，所以爱丽丝接管了。 这意味着相同的模块，具有相同的名称，以及相同的通用 API 可能在野外有两个版本。 或者，两个开发人员（例如爱丽丝和鲍勃）最初在一个模块上合作，然后拆伙开发。 因此，有时需要有一种方法来定义模块的**作者**。
- 一个模块可以随着时间的推移而增强，维护人员保持两个版本的最新，但具有不同的 API。 因此，可能需要定义所需的 **API**。
- 在开发新程序时，开发人员可能希望在本地安装爱丽丝和鲍勃编写的模块。 因此，不可能只安装一个单一名称的模块的一个版本。

<br/>

- a popular module may go through several iterations as the API gets improved, without a guarantee that there is backward compatibility. So, if a program relies on some specific function or return, then there has to be a way to specify the **Version**.
- a module may have been written by Bob, a very competent programmer, who moves on in life, leaving the module unmaintained, so Alice takes over. This means that the same module, with the same name, and the same general API may have have two versions in the wild. Alternatively, two developers (e.g., Alice and Bob) who initially cooperated on a module, then part company about its development. Consequently, it sometimes is necessary for there to be a way to define the **Auth** of the module.
- a module may be enhanced over time and the maintainer keeps two versions up to date, but with different APIs. So it is may be necessary to define the **API** required.
- when developing a new program a developer may want to have the modules written by both Alice and Bob installed locally. So it is not possible simply to have only one version of a module with a single name installed.

`Raku` 允许所有这些可能性，允许多个版本、多个作者和多个 API 存在、安装和本地可用。 用特定属性访问类和模块的方式在[其他地方](https://docs.raku.org/language/typesystem#Versioning_and_authorship)有解释说明。 本教程是关于 `Raku` 如何处理这些可能性的。

`Raku` enables all of these possibilities, allowing for multiple versions, multiple authorities, and multiple APIs to be present, installed, and available locally. The way classes and modules can be accessed with specific attributes is explained [elsewhere](https://docs.raku.org/language/typesystem#Versioning_and_authorship). This tutorial is about how `Raku` handles these possibilities.

<a id="介绍--introduction"></a>
# 介绍 / Introduction

在考虑 `Raku` 框架之前，让我们看看 `Perl` 或 `Python` 语言如何处理模块的安装和加载。

Before considering the `Raku` framework, let's have a look at how languages like `Perl` or `Python` handle module installation and loading.

```Raku
ACME::Foo::Bar -> ACME/Foo/Bar.pm
os.path -> os/path.py
```

在这些语言中，模块名称与文件系统路径有 1：1 的关系。 我们只需用斜杠替换双冒号或句号，并添加 `.pm` 或 `.py`。

In those languages, module names have a 1:1 relation with filesystem paths. We simply replace the double colons or periods with slashes and add a `.pm` or `.py`.

请注意，这些是相对路径。`Python` 和 `Perl` 都使用包含路径的列表来完成这些路径。 在 `Perl` 中它们可在全局 `@INC` 数组中使用。

Note that these are relative paths. Both `Python` and `Perl` use a list of include paths, to complete these paths. In `Perl` they are available in the global `@INC` array.

```Raku
@INC
 
/usr/lib/perl5/site_perl/5.22.1/x86_64-linux-thread-multi
/usr/lib/perl5/site_perl/5.22.1/
/usr/lib/perl5/vendor_perl/5.22.1/x86_64-linux-thread-multi
/usr/lib/perl5/vendor_perl/5.22.1/
/usr/lib/perl5/5.22.1/x86_64-linux-thread-multi
/usr/lib/perl5/5.22.1/
```

其中每个包含目录都要检查它是否包含从模块名称确定的相对路径。 如果合适，文件就会被加载。

Each of these include directories is checked for whether it contains a relative path determined from the module name. If the shoe fits, the file is loaded.

当然，这有点简化了。 两种语言都支持缓存模块的编译版本。 因此，不仅仅是 `.pm` 文件 `Perl` 首先查找一个 `.pmc` 文件。 `Python`首先查找 `.pyc` 文件。

Of course that's a bit of a simplified version. Both languages support caching compiled versions of modules. So instead of just the `.pm` file `Perl` first looks for a `.pmc` file. And `Python` first looks for `.pyc` files.

在这两种情况下，模块安装主要意味着将文件复制到由相同的简单映射确定的位置。 该系统易于解释、易于理解并且简单健壮。

Module installation in both cases means mostly copying files into locations determined by the same simple mapping. The system is easy to explain, easy to understand, simple and robust.

<a id="为什么改变？--why-change"></a>
## 为什么改变？ / Why change?

为什么 `Raku` 需要另一个框架？ 原因是这些语言缺乏以下特点：

Why would `Raku` need another framework? The reason is there are features that those languages lack, namely:

- Unicode 模组名称
- 不同作者以相同名称发布的模组
- 安装了多个版本的模块

<br/>

- Unicode module names
- Modules published under the same names by different authors
- Having multiple versions of a module installed

这套 26 个拉丁字对几乎所有真正的现代语言，包括英语，都有太多的限制，因为英语对许多常用的单词有变音符。

The set of 26 Latin characters is too restrictive for virtually all real modern languages, including English, which have diacritics for many commonly-used words.

使用模块名称和文件系统路径之间的 1:1 关系，一旦尝试在多个平台和文件系统上支持 Unicode，您将进入一个痛苦的世界。

With a 1:1 relation between module names and filesystem paths, you enter a world of pain once you try to support Unicode on multiple platforms and filesystems.

然后在多个作者之间共享模块名称。 这种方法在实践中可能很好，也可能不好。 我可以想象使用它来发布一个带有某种修复的模块，直到原始作者在“官方”版本中包含修复。

Then there's sharing module names between multiple authors. This one may or may not work out well in practice. I can imagine using it for example for publishing a module with some fix until the original author includes the fix in the "official" version.

最后会出现多个版本。 通常需要特定版本模块的人可以使用 local::lib 或容器或一些其他方式绕过。他们都有自己的缺点。如果应用程序只用说，嘿，我需要一个旧的、可信的 2.9 版本，或者可能是该分支的缺陷修复版本，那么这些都是不必要的。

Finally there's multiple versions. Usually people who need certain versions of modules reach for local::lib or containers or some home grown workarounds. They all have their own disadvantages. None of them would be necessary if applications could just say, hey I need good old, trusty version 2.9 or maybe a bug fix release of that branch.

如果您有任何希望继续使用简单的名称映射解决方案，您可能会放弃版本控制要求。 因为，在寻找 2.9 或更高版本时，您将如何找到模块的 3.2 或者更高的版本？

If you had any hopes of continuing using the simple name mapping solution, you probably gave up at the versioning requirement. Because, how would you find version 3.2 of a module when looking for a 2.9 or higher?

流行的想法包括在 JSON 文件中收集有关已安装模块的信息，但当这种方式变得缓慢时，文本文件将被替换为将元数据放入 SQLite 数据库。然而，当有分发包这个需求时，这些想法可以很容易地被毙掉。

Popular ideas included collecting information about installed modules in JSON files but when those turned out to be toe-nail growing slow, text files were replace by putting the metadata into SQLite databases. However, these ideas can be easily shot down by introducing another requirement: distribution packages.

Linux 发行版的包主要是包含一些文件和一些元数据的档案。 理想情况下，安装这样一个包的过程只意味着解压文件和更新中央包数据库。 卸载意味着删除以这种方式安装的文件，并再次更新包数据库。 在安装和卸载过程中更改现有文件会使打包机的生活更加困难，所以很想避免这种情况。 此外，已安装文件的名称可能不取决于以前安装的文件。 我们必须在包装时知道名字将是什么。

Packages for Linux distributions are mostly just archives containing some files plus some metadata. Ideally the process of installing such a package means just unpacking the files and updating the central package database. Uninstalling means deleting the files installed this way and again updating the package database. Changing existing files on install and uninstall makes packagers' lives much harder, so we really want to avoid that. Also the names of the installed files may not depend on what was previously installed. We must know at the time of packaging what the names are going to be.

<a id="长名--long-names"></a>
## 长名 / Long names

```Raku
Foo::Bar:auth<cpan:nine>:ver<0.3>:api<1>
```

让我们摆脱这种混乱的第 0 步是定义一个长名字。`Raku` 中的一个完整模块名由短名、 作者、 版本和 API 组成。

Step 0 in getting us back out of this mess is to define a long name. A full module name in `Raku` consists of the short-name, auth, version and API

同时，您安装的东西通常不是一个模块，而是一个可能包含一个或多个模块的分发。分发名称的工作方式与模块名称相同。 事实上，发行版通常只会在它们的主模块之后调用。 分布的一个重要特性是它们是不可变的。 `Foo:auth<cpan:nine>:ver<0.3>:api<1>` 将始终是完全相同代码的名称。

At the same time, the thing you install is usually not a single module but a distribution which probably contains one or more modules. Distribution names work just the same way as module names. Indeed, distributions often will just be called after their main module. An important property of distributions is that they are immutable. `Foo:auth<cpan:nine>:ver<0.3>:api<1>` will always be the name for exactly the same code.

<a id="$repo"></a>
## $*REPO

在 `Perl` 和 `Python` 中你将于指向文件系统目录的路径打交道。 在 `Raku` 中我们将这些目录称为“存储库”，其中每个存储库都由一个对象管理，该对象执行 `CompUnit::Repository` 角色。 而不是 `@INC` 数组，有 `$*REPO` 变量。 它包含一个存储库对象。 此对象具有 **next-repo** 属性，该属性可能包含另一个存储库。 换句话说：存储库被管理为*链接列表*。 与传统数组的重要区别在于，在遍历列表时，每个对象都有权决定是否将请求传递给下一个存储库。 `Raku` 建立了一套标准的存储库，即 “perl”、 “vendor” 和 “site” 存储库，就像您从 `Perl` 了解它们一样。 此外，我们还为当前用户建立了一个“家”存储库。

In `Perl` and `Python` you deal with include paths pointing to filesystem directories. In `Raku` we call such directories "repositories" and each of these repositories is governed by an object that does the `CompUnit::Repository` role. Instead of an `@INC` array, there's the `$*REPO` variable. It contains a single repository object. This object has a **next-repo** attribute that may contain another repository. In other words: repositories are managed as a *linked list*. The important difference to the traditional array is, that when going through the list, each object has a say in whether to pass along a request to the next-repo or not. `Raku` sets up a standard set of repositories, i.e. the "perl", "vendor" and "site" repositories, just like you know them from `Perl`. In addition, we set up a "home" repository for the current user.

存储库必须实现 `need` 方法。`Raku` 代码中的 `use` 或 `require` 语句基本上被转换为 `$*REPO` 的 `need` 方法的调用。 此方法可以将请求委托给下一个存储库。此方法可以将请求委托给下一个存储库。

Repositories must implement the `need` method. A `use` or `require` statement in `Raku` code is basically translated to a call to `$*REPO`'s `need` method. This method may in turn delegate the request to the next-repo.

```Raku
role CompUnit::Repository {
    has CompUnit::Repository $.next is rw;
 
    method need(CompUnit::DependencySpecification $spec,
                CompUnit::PrecompilationRepository $precomp,
                CompUnit::Store :@precomp-stores
                --> CompUnit:D
                )
        { ... }
    method loaded(
                --> Iterable
                )
        { ... }
 
    method id( --> Str )
        { ... }
}
```

<a id="存储库--repositories"></a>
## 存储库 / Repositories

Rakudo 有几个可用于存储库的类。 最重要是 `CompUnit::Repository::FileSystem` 和 `CompUnit::Repository::Installation`。文件系统存储库是指在模块开发期间使用的，实际上就像 `Perl` 在寻找模块时一样工作。它不支持版本或 `auth`，只是将短名映射到文件系统路径。

Rakudo comes with several classes that can be used for repositories. The most important ones are `CompUnit::Repository::FileSystem` and `CompUnit::Repository::Installation`. The FileSystem repo is meant to be used during module development and actually works just like `Perl` when looking for a module. It doesn't support versions or `auth`s and simply maps the short-name to a filesystem path.

Installation 存储库是真正的智能所在。在请求一个模块时，您通常要么通过它的确切长名称来执行，要么按照“给我一个与这个过滤器匹配的模块”的思路来说。这样的过滤器是通过一个 `CompUnit::DependencySpecification` 对象，该对象具有如下字段：

The Installation repository is where the real smarts are. When requesting a module, you will usually either do it via its exact long name, or you say something along the lines of "give me a module that matches this filter." Such a filter is given by way of a `CompUnit::DependencySpecification` object which has fields for

- short-name,
- auth-matcher,
- version-matcher and
- api-matcher.

当查看候选项时，Installation 存储库将模块的长名称与此 DependencySpecification 进行智能匹配，或者相反，单个字段与单个匹配器。 因此，Matcher 可能是一些具体的值、版本范围，甚至是正则（尽管是任意的正则，例如 `.*`，不会产生有用的结果，但 `3.20.1+` 匹配高于 3.20.1 的候选者）。

When looking through candidates, the Installation repository will smartmatch a module's long name against this DependencySpecification or rather the individual fields against the individual matchers. Thus a matcher may be some concrete value, a version range, or even a regex (though an arbitrary regex, such as `.*`, would not produce a useful result, but something like `3.20.1+` will only find candidates higher than 3.20.1).

加载所有已安装发行版的元数据将是令人望而却步的。`Raku` 框架的当前实现使用文件系统作为一种数据库。然而，另一种实现可能使用另一种战略。下面的描述显示了一个实现是如何工作的，并包含在这里来说明正在发生的事情。

Loading the metadata of all installed distributions would be prohibitively slow. The current implementation of the `Raku` framework uses the filesystem as a kind of database. However, another implementation may use another strategy. The following description shows how one implementation works and is included here to illustrate what is happening.

我们不仅存储发行版的文件，而且还创建索引以加速查找。其中一个索引是以安装模块的短名称命名的目录形式出现的。然而，今天常用的大多数文件系统不能处理 Unicode 名称，因此我们不能直接使用模块名称。这就是现在臭名昭著的 SHA-1 哈希进入游戏的地方。目录名称是 UTF-8 编码的模块短名的 SHA-1 散列，散列为 ASCII 编码。

We store not only a distribution's files but also create indices for speeding up lookups. One of these indices comes in the form of directories named after the short-name of installed modules. However most of the filesystems in common use today cannot handle Unicode names, so we cannot just use module names directly. This is where the now infamous SHA-1 hashes enter the game. The directory names are the ASCII encoded SHA-1 hashes of the UTF-8 encoded module short-names.

在这些目录中，我们每个发行版找到一个文件，其中包含一个具有匹配短名称的模块。 这些文件包含发行版的 ID 和组成长名称的其他字段：作者、版本和 api。 因此，通过阅读这些文件，我们有一个通常简短的 auth-version-api 三重奏列表，我们可以与我们的 DependencySpecification 相匹配。我们最终得到的是获胜的发行版的 ID，我们用来查找存储在 JSON 编码文件中的元数据。此元数据包含所请求模块代码的源/目录中文件的名称。这是我们可以装载的。

In these directories we find one file per distribution that contains a module with a matching short name. These files again contain the ID of the dist and the other fields that make up the long name: auth, version, and api. So by reading these files we have a usually short list of auth-version-api triplets which we can match against our DependencySpecification. We end up with the winning distribution's ID, which we use to look up the metadata, stored in a JSON encoded file. This metadata contains the name of the file in the sources/directory containing the requested module's code. This is what we can load.

查找源文件的名称也有点棘手，因为仍然存在 Unicode 问题，此外，安装的不同发行版可能使用相同的相对文件名。 所以至少现在，我们使用长名的 SHA-1 哈希。

Finding names for source files is again a bit tricky, as there's still the Unicode issue and in addition the same relative file names may be used by different installed distributions (think versions). So for now at least, we use SHA-1 hashes of the long-names.

<a id="resources"></a>
## Resources

```Raku
%?RESOURCES
%?RESOURCES<libraries/p5helper>
%?RESOURCES<icons/foo.png>
%?RESOURCES<schema.sql>
 
Foo
|___ lib
|     |____ Foo.rakumod
|
|___ resources
      |___ schema.sql
      |
      |___ libraries
            |____ p5helper
            |        |___
            |___ icons
                     |___ foo.png
 
```

不仅是源文件以这种方式被存储和找到。发行版也可能包含任意资源文件。这些可能是安装时编译的图像、语言文件或共享库。它们可以通过 `%?RESOURCES` 哈希从模块内访问。

It's not only source files that are stored and found this way. Distributions may also contain arbitrary resource files. These could be images, language files or shared libraries that are compiled on installation. They can be accessed from within the module through the `%?RESOURCES` hash

只要您遵守发行版的标准布局约定，这甚至在开发过程中不需要安装任何东西就可以工作。

As long as you stick to the standard layout conventions for distributions, this even works during development without installing anything.

这个体系结构的一个很好的结果是，创建特殊目的存储库相当容易。

A nice result of this architecture is that it's fairly easy to create special purpose repositories.

<a id="依赖--dependencies"></a>
## 依赖 / Dependencies

幸运的是，预编译在大多数情况下工作得很好。然而，它也面临着自己的一系列挑战。加载单个模块很容易。当一个模块有依赖关系，而这些依赖关系又有自己的依赖关系时，就变得有趣了。

Luckily precompilation at least works quite well in most cases. Yet it comes with its own set of challenges. Loading a single module is easy. The fun starts when a module has dependencies and those dependencies have again dependencies of their own.

在 `Raku` 中加载预编译文件时我们也需要加载其所有依赖项的预编译文件。这些依赖项*必须*被预编译，我们无法从源文件加载它们。更糟糕的是，依赖项的预编译文件*必须*与我们最初用于预编译模块的文件完全相同。

When loading a precompiled file in `Raku` we need to load the precompiled files of all its dependencies, too. And those dependencies **must** be precompiled, we cannot load them from source files. Even worse, the precomp files of the dependencies **must** be exactly the same files we used for precompiling our module in the first place.

为了消除它，预编译文件只对用于编译的那个 `Raku` 二进制文件有效。

To top it off, precompiled files work only with the exact `Raku` binary, that was used for compilation.

如果不是额外的需求，所有这些都是可以管理的：作为一个用户，您希望您刚刚安装的模块的新版本能够实际使用，不是吗？

All of that would still be quite manageable if it weren't for an additional requirement: as a user you expect a new version of a module you just installed to be actually used, don't you?

换句话说：如果升级预编译模块的依赖项，我们必须检测到这一点，并用新的依赖项重新编译模块。

In other words: if you upgrade a dependency of a precompiled module, we have to detect this and precompile the module again with the new dependency.

<a id="预编译存储区--precomp-stores"></a>
## 预编译存储区 / Precomp stores

现在请记住，虽然我们有一个标准的存储库链，用户可以通过 `-I` 在命令行或者在代码中使用 “use lib” 的方式预先添加额外的存储库。

Now remember that while we have a standard repository chain, the user may prepend additional repositories by way of `-I` on the command line or "use lib" in the code.

这些存储库可能包含预编译模块的依赖关系。

These repositories may contain the dependencies of precompiled modules.

我们第一个解决这个问题的方法是，每个存储库都有自己的预编译存储区，预编译文件存储在那里。 我们只从链中第一个存储库的预编译存储中加载预编译文件，因为这是唯一直接或至少间接访问所有候选的存储库。

Our first solution to this riddle was that each repository gets its own precomp store where precompiled files are stored. We only ever load precomp files from the precomp store of the very first repository in the chain because this is the only repository that has direct or at least indirect access to all the candidates.

如果这个存储库是文件系统存储库，我们将在 `.precomp` 目录中创建一个预编译存储。

If this repository is a FileSystem repository, we create a precomp store in a `.precomp` directory.

虽然这是一个安全的选项，但它的结果是，无论何时使用新的存储库，我们都会从一开始就无法访问预先编译的文件。

While being the safe option, this has the consequence that whenever you use a new repository, we will start out without access to precompiled files.

相反，我们将在第一次加载第一次加载时使用的模块。

Instead, we will precompile the modules used when they are first loaded.

<a id="credit"></a>
## Credit

本教程是基于 `niner` 的一个[演讲](http://niner.name/talks/A%20look%20behind%20the%20curtains%20-%20module%20loading%20in%20Perl%206/)。

This tutorial is based on a `niner` [talk](http://niner.name/talks/A%20look%20behind%20the%20curtains%20-%20module%20loading%20in%20Perl%206/).
