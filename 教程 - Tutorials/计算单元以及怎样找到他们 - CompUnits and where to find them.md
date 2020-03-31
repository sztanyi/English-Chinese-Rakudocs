原文：https://docs.raku.org/language/compilation

# 计算单元以及怎样找到他们 / CompUnits and where to find them

如何和何时编译 Raku 模块，它们存储在哪里，以及如何以编译的形式访问它们。

How and when Raku modules are compiled, where they are stored, and how to access them in compiled form.

<!-- MarkdownTOC -->

- [概述 / Overview](#%E6%A6%82%E8%BF%B0--overview)
- [介绍 / Introduction](#%E4%BB%8B%E7%BB%8D--introduction)
    - [Why change?](#why-change)
    - [Long names](#long-names)
    - [$*REPO](#%24repo)
    - [Repositories](#repositories)
    - [Resources](#resources)
    - [Dependencies](#dependencies)
    - [Precomp stores](#precomp-stores)
    - [Credit](#credit)

<!-- /MarkdownTOC -->


<a id="%E6%A6%82%E8%BF%B0--overview"></a>
# 概述 / Overview

作为 Perl 语系的一员，Raku 的程序往往更多地处于解释-编译频谱的解释端上层。 在本教程中，一个被“解释”的程序意味着源代码，即人类可读的文本，如 `say 'hello world';`，立即被 `Raku` 程序处理成可以由计算机执行的代码，任何中间阶段都存储在内存中。

Programs in Raku, as a member of the Perl language family, tend at the top level to be more at the interpreted end of the interpreted-compiled spectrum. In this tutorial, an 'interpreted' program means that the source code, namely the human-readable text such as `say 'hello world';`, is immediately processed by the `Raku` program into code that can be executed by the computer, with any intermediate stages being stored in memory.

相比之下，编译后的程序首先将人类可读源处理成机器可执行的代码，并将此代码的某种形式存储在光盘上。 为了执行程序，机器可读的版本被加载到内存中，然后由计算机运行。

A compiled program, by contrast, is one where the human readable source is first processed into machine-executable code and some form of this code is stored 'on disc'. In order to execute the program, the machine-readable version is loaded into memory and then run by the computer.

汇编和解释形式都有优点。 简单地说，被解释的程序可以很快地“加速”，源码也会很快改变。 编译程序可能是复杂的，需要很长时间才能预处理成机器可读代码，但对用户来说，它们运行时要快得多，用户只能看到加载和运行时间，看不到编译时间。

Both compiled and interpreted forms have advantages. Briefly, interpreted programs can be 'whipped up' quickly and the source changed quickly. Compiled programs can be complex and take a significant time to pre-process into machine-readable code, but then running them is much faster for a user, who only 'sees' the loading and running time, not the compilation time.

`Raku` 有两种范式。 在上层 Raku 程序被解释执行，但如果将代码分离成模块，它将被编译，然后在必要时加载预处理版本。 在实践中，由社区编写的模块只需要由用户在“安装”时预先编译一次，例如由模块管理器（如 `Zef`）安装。 然后，开发人员可以在自己的程序中使用。 其效果是使 `Raku` 上层程序快速运行。

`Raku` has both paradigms. At the **top level** a Raku program is interpreted, but if code that is separated out into a Module will be compiled and the preprocessed version is then loaded when necessary. In practice, Modules that have been written by the community will only need to be precompiled once by a user when they are 'installed', for example by a Module manager such as `zef`. Then they can be `use`d by a developer in her own program. The effect is to make `Raku` top level programs run quickly.

`Perl` 语系的一大优点是能够将一个由称职的程序员编写的模块组成的整个生态系统集成到一个小程序中。 这种力量被广泛复制，现在是所有语言的常态。 `Raku` 更进一步地进行集成，使得 `Raku` 程序将以其他语言编写的系统库集成到 `Raku` 程序中相对容易，参见 [NativeCall](https://docs.raku.org/language/nativecall)。

One of the great strengths of the `Perl` family of languages was the ability to integrate a whole ecosystem of modules written by competent programmers into a small program. This strength was widely copied and is now the norm for all languages. `Raku` takes integration even further, making it relatively easy for `Raku` programs to incorporate system libraries written in other languages into `Raku` programs, see [Native Call](https://docs.raku.org/language/nativecall).

`Perl` 和其他语言的经验是，模组的分发本质产生了若干实际困难：

The experience from `Perl` and other languages is that the distributive nature of Modules generate several practical difficulties:

- 当 API 得到改进时，一个流行的模块可能会经过几次迭代，而不能保证有反向兼容性。 因此，如果程序依赖于某些特定的函数或返回，则必须有一种方法来指定*版本*。
- 一个模块可能是由鲍勃编写的，他是一个非常能干的程序员，他在生活中继续前进，使模块无法维护，所以爱丽丝接管了。 这意味着相同的模块，具有相同的名称，以及相同的通用 API 可能在野外有两个版本。 或者，两个开发人员（例如爱丽丝和鲍勃）最初在一个模块上合作，然后拆伙开发。 因此，有时需要有一种方法来定义模块的**作者**。
- 一个模块可以随着时间的推移而增强，维护人员保持两个版本的最新，但具有不同的 API。 因此，可能需要定义所需的 **API**。
- 在开发新程序时，开发人员可能希望在本地安装爱丽丝和鲍勃编写的模块。 因此，不可能只安装一个单一名称的模块的一个版本。

- a popular module may go through several iterations as the API gets improved, without a guarantee that there is backward compatibility. So, if a program relies on some specific function or return, then there has to be a way to specify the **Version**.
- a module may have been written by Bob, a very competent programmer, who moves on in life, leaving the module unmaintained, so Alice takes over. This means that the same module, with the same name, and the same general API may have have two versions in the wild. Alternatively, two developers (e.g., Alice and Bob) who initially cooperated on a module, then part company about its development. Consequently, it sometimes is necessary for there to be a way to define the **Auth** of the module.
- a module may be enhanced over time and the maintainer keeps two versions up to date, but with different APIs. So it is may be necessary to define the **API** required.
- when developing a new program a developer may want to have the modules written by both Alice and Bob installed locally. So it is not possible simply to have only one version of a module with a single name installed.

`Raku` 允许所有这些可能性，允许多个版本、多个权限和多个 API 存在、安装和本地可用。 用特定属性访问类和模块的方式在[其他地方](https://docs.raku.org/language/typesystem#Versioning_and_authorship)解释。 本教程是关于 `Raku` 如何处理这些可能性的。

`Raku` enables all of these possibilities, allowing for multiple versions, multiple authorities, and multiple APIs to be present, installed, and available locally. The way classes and modules can be accessed with specific attributes is explained [elsewhere](https://docs.raku.org/language/typesystem#Versioning_and_authorship). This tutorial is about how `Raku` handles these possibilities.

<a id="%E4%BB%8B%E7%BB%8D--introduction"></a>
# 介绍 / Introduction

在考虑 `Raku` 框架之前，让我们看看 `Perl` 或 `Python` 语言如何处理模块的安装和加载。

Before considering the `Raku` framework, let's have a look at how languages like `Perl` or `Python` handle module installation and loading.

```Raku
ACME::Foo::Bar -> ACME/Foo/Bar.pm
os.path -> os/path.py
```

In those languages, module names have a 1:1 relation with filesystem paths. We simply replace the double colons or periods with slashes and add a `.pm` or `.py`.

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

Each of these include directories is checked for whether it contains a relative path determined from the module name. If the shoe fits, the file is loaded.

Of course that's a bit of a simplified version. Both languages support caching compiled versions of modules. So instead of just the `.pm` file `Perl` first looks for a `.pmc` file. And `Python` first looks for `.pyc` files.

Module installation in both cases means mostly copying files into locations determined by the same simple mapping. The system is easy to explain, easy to understand, simple and robust.

<a id="why-change"></a>
## Why change?

Why would `Raku` need another framework? The reason is there are features that those languages lack, namely:

- Unicode module names
- Modules published under the same names by different authors
- Having multiple versions of a module installed

The set of 26 Latin characters is too restrictive for virtually all real modern languages, including English, which have diacritics for many commonly-used words.

With a 1:1 relation between module names and filesystem paths, you enter a world of pain once you try to support Unicode on multiple platforms and filesystems.

Then there's sharing module names between multiple authors. This one may or may not work out well in practice. I can imagine using it for example for publishing a module with some fix until the original author includes the fix in the "official" version.

Finally there's multiple versions. Usually people who need certain versions of modules reach for local::lib or containers or some home grown workarounds. They all have their own disadvantages. None of them would be necessary if applications could just say, hey I need good old, trusty version 2.9 or maybe a bug fix release of that branch.

If you had any hopes of continuing using the simple name mapping solution, you probably gave up at the versioning requirement. Because, how would you find version 3.2 of a module when looking for a 2.9 or higher?

Popular ideas included collecting information about installed modules in JSON files but when those turned out to be toe-nail growing slow, text files were replace by putting the metadata into SQLite databases. However, these ideas can be easily shot down by introducing another requirement: distribution packages.

Packages for Linux distributions are mostly just archives containing some files plus some metadata. Ideally the process of installing such a package means just unpacking the files and updating the central package database. Uninstalling means deleting the files installed this way and again updating the package database. Changing existing files on install and uninstall makes packagers' lives much harder, so we really want to avoid that. Also the names of the installed files may not depend on what was previously installed. We must know at the time of packaging what the names are going to be.

<a id="long-names"></a>
## Long names

```Raku
Foo::Bar:auth<cpan:nine>:ver<0.3>:api<1>
```

Step 0 in getting us back out of this mess is to define a long name. A full module name in `Raku` consists of the short-name, auth, version and API

At the same time, the thing you install is usually not a single module but a distribution which probably contains one or more modules. Distribution names work just the same way as module names. Indeed, distributions often will just be called after their main module. An important property of distributions is that they are immutable. `Foo:auth<cpan:nine>:ver<0.3>:api<1> `will always be the name for exactly the same code.

<a id="%24repo"></a>
## $*REPO

In `Perl` and `Python` you deal with include paths pointing to filesystem directories. In `Raku` we call such directories "repositories" and each of these repositories is governed by an object that does the `CompUnit::Repository` role. Instead of an `B<@INC>` array, there's the `$*REPO` variable. It contains a single repository object. This object has a **next-repo** attribute that may contain another repository. In other words: repositories are managed as a *linked list*. The important difference to the traditional array is, that when going through the list, each object has a say in whether to pass along a request to the next-repo or not. `Raku` sets up a standard set of repositories, i.e. the "perl", "vendor" and "site" repositories, just like you know them from `Perl`. In addition, we set up a "home" repository for the current user.

Repositories must implement the `need` method. A `use` or `require` statement in `Raku` code is basically translated to a call to `B<$*REPO>`'s `need` method. This method may in turn delegate the request to the next-repo.

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

<a id="repositories"></a>
## Repositories

Rakudo comes with several classes that can be used for repositories. The most important ones are `CompUnit::Repository::FileSystem` and `CompUnit::Repository::Installation`. The FileSystem repo is meant to be used during module development and actually works just like `Perl` when looking for a module. It doesn't support versions or `auth`s and simply maps the short-name to a filesystem path.

The Installation repository is where the real smarts are. When requesting a module, you will usually either do it via its exact long name, or you say something along the lines of "give me a module that matches this filter." Such a filter is given by way of a `CompUnit::DependencySpecification` object which has fields for

- short-name,
- auth-matcher,
- version-matcher and
- api-matcher.

When looking through candidates, the Installation repository will smartmatch a module's long name against this DependencySpecification or rather the individual fields against the individual matchers. Thus a matcher may be some concrete value, a version range, or even a regex (though an arbitrary regex, such as `.*`, would not produce a useful result, but something like `3.20.1+` will only find candidates higher than 3.20.1).

Loading the metadata of all installed distributions would be prohibitively slow. The current implementation of the `Raku` framework uses the filesystem as a kind of database. However, another implementation may use another strategy. The following description shows how one implementation works and is included here to illustrate what is happening.

We store not only a distribution's files but also create indices for speeding up lookups. One of these indices comes in the form of directories named after the short-name of installed modules. However most of the filesystems in common use today cannot handle Unicode names, so we cannot just use module names directly. This is where the now infamous SHA-1 hashes enter the game. The directory names are the ASCII encoded SHA-1 hashes of the UTF-8 encoded module short-names.

In these directories we find one file per distribution that contains a module with a matching short name. These files again contain the ID of the dist and the other fields that make up the long name: auth, version, and api. So by reading these files we have a usually short list of auth-version-api triplets which we can match against our DependencySpecification. We end up with the winning distribution's ID, which we use to look up the metadata, stored in a JSON encoded file. This metadata contains the name of the file in the sources/ directory containing the requested module's code. This is what we can load.

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

It's not only source files that are stored and found this way. Distributions may also contain arbitrary resource files. These could be images, language files or shared libraries that are compiled on installation. They can be accessed from within the module through the `%?RESOURCES` hash

As long as you stick to the standard layout conventions for distributions, this even works during development without installing anything.

A nice result of this architecture is that it's fairly easy to create special purpose repositories.

<a id="dependencies"></a>
## Dependencies

Luckily precompilation at least works quite well in most cases. Yet it comes with its own set of challenges. Loading a single module is easy. The fun starts when a module has dependencies and those dependencies have again dependencies of their own.

When loading a precompiled file in `Raku` we need to load the precompiled files of all its dependencies, too. And those dependencies **must** be precompiled, we cannot load them from source files. Even worse, the precomp files of the dependencies **must** be exactly the same files we used for precompiling our module in the first place.

To top it off, precompiled files work only with the exact `Raku` binary, that was used for compilation.

All of that would still be quite manageable if it weren't for an additional requirement: as a user you expect a new version of a module you just installed to be actually used, don't you?

In other words: if you upgrade a dependency of a precompiled module, we have to detect this and precompile the module again with the new dependency.

<a id="precomp-stores"></a>
## Precomp stores

Now remember that while we have a standard repository chain, the user may prepend additional repositories by way of `-I` on the command line or "use lib" in the code.

These repositories may contain the dependencies of precompiled modules.

Our first solution to this riddle was that each repository gets its own precomp store where precompiled files are stored. We only ever load precomp files from the precomp store of the very first repository in the chain because this is the only repository that has direct or at least indirect access to all the candidates.

If this repository is a FileSystem repository, we create a precomp store in a `.precomp` directory.

While being the safe option, this has the consequence that whenever you use a new repository, we will start out without access to precompiled files.

Instead, we will precompile the modules used when they are first loaded.

<a id="credit"></a>
## Credit

This tutorial is based on a `niner` [talk](http://niner.name/talks/A%20look%20behind%20the%20curtains%20-%20module%20loading%20in%20Perl%206/).
