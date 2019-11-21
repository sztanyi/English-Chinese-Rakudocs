原文：https://docs.raku.org/language/modules-core

# 核心模块 / Core modules

可能对模块作者有用的核心模块

Core modules that may be useful to module authors

Rakudo 实现包含了一些你可能想要使用的模块。下面是它们的列表，以及它们的源代码的链接。

The Rakudo implementation has a few modules included you may want to use. The following is a list of them, along with links to their source code.

<!-- MarkdownTOC -->

- [`CompUnit::*` 模块和角色 / `CompUnit::*` modules and roles](#compunit-%E6%A8%A1%E5%9D%97%E5%92%8C%E8%A7%92%E8%89%B2--compunit-modules-and-roles)
- [`NativeCall` 模块 / `NativeCall` modules](#nativecall-%E6%A8%A1%E5%9D%97--nativecall-modules)
- [其他模块 / Other modules](#%E5%85%B6%E4%BB%96%E6%A8%A1%E5%9D%97--other-modules)

<!-- /MarkdownTOC -->

<a id="compunit-%E6%A8%A1%E5%9D%97%E5%92%8C%E8%A7%92%E8%89%B2--compunit-modules-and-roles"></a>
## `CompUnit::*` 模块和角色 / `CompUnit::*` modules and roles 

这些模块主要由发行版构建工具使用，不是给最终用户使用的（至少在 6.c 版本之前）。

These modules are mostly used by distribution build tools, and are not intended to be used (at least until version 6.c) by the final user.

- [`CompUnit::Repository::Staging`](https://github.com/rakudo/rakudo/blob/master/lib/CompUnit/Repository/Staging.pm6).
- [`CompUnit::Repository::(FileSystem|Installation|AbsolutePath|Unknown|NQP|Perl6|RepositoryRegistry)`](https://github.com/rakudo/rakudo/blob/master/src/core/CompUnit/RepositoryRegistry.pm6).

<a id="nativecall-%E6%A8%A1%E5%9D%97--nativecall-modules"></a>
## `NativeCall` 模块 / `NativeCall` modules

- [`NativeCall`](https://github.com/rakudo/rakudo/blob/master/lib/NativeCall.pm6) Native Calling Interface ([docs](https://docs.raku.org/language/nativecall.html))
- [`NativeCall::Types`](https://github.com/rakudo/rakudo/blob/master/lib/NativeCall/Types.pm6) Used by `NativeCall`
- [`NativeCall::Compiler::GNU`](https://github.com/rakudo/rakudo/blob/master/lib/NativeCall/Compiler/GNU.pm6) Used by `NativeCall`
- [`NativeCall::Compiler::MSVC`](https://github.com/rakudo/rakudo/blob/master/lib/NativeCall/Compiler/MSVC.pm6) Used by `NativeCall`

<a id="%E5%85%B6%E4%BB%96%E6%A8%A1%E5%9D%97--other-modules"></a>
## 其他模块 / Other modules

- [`Pod::To::Text`](https://github.com/rakudo/rakudo/blob/master/lib/Pod/To/Text.pm6) Used by several external modules
- [`Test`](https://github.com/rakudo/rakudo/blob/master/lib/Test.pm6) Test routines ([docs](https://docs.raku.org/language/testing))
- [`experimental`](https://github.com/rakudo/rakudo/blob/master/lib/experimental.pm6)
- [`newline`](https://github.com/rakudo/rakudo/blob/master/lib/newline.pm6)
