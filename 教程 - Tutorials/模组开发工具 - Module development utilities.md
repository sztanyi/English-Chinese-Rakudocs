原文：https://docs.raku.org/language/modules-extra

# 模组开发工具 - Module development utilities

什么能帮助你编写/测试/改进你的模组？

What can help you write/test/improve your module(s)

这里是一个模组列表，你可以在 Raku 生态系统中找到，目的是使开发 Raku 模组的体验更有趣。

Here is a list of modules that you can find in the Raku ecosystem which aim to make the experience of developing Raku modules more fun.

<!-- MarkdownTOC -->

- [模组构建器和创作工具 / Module builder and authoring tools](#模组构建器和创作工具--module-builder-and-authoring-tools)
- [测试 / Tests](#测试--tests)
- [NativeCall](#nativecall)
- [样本模块 / Sample modules](#样本模块--sample-modules)

<!-- /MarkdownTOC -->


<a id="模组构建器和创作工具--module-builder-and-authoring-tools"></a>
# 模组构建器和创作工具 / Module builder and authoring tools

一些模组和工具可以帮助你生成作为模组发行版一部分的文件。

Some modules and tools to help you with generating files that are part of a module distribution.

- [App::Assixt](https://modules.raku.org/dist/App::Assixt) 模组开发者助手
- [App::Mi6](https://modules.raku.org/dist/App::Mi6) Raku 最小创作工具
- [META6](https://modules.raku.org/dist/META6) 用 Raku `META` 文件做事
- [Module::Skeleton](https://bitbucket.org/rightfold/module-skeleton) 生成模组骨架
- [p6doc](https://modules.raku.org/dist/p6doc) 生成文档最终产品

- [App::Assixt](https://modules.raku.org/dist/App::Assixt) The module developer's assistant
- [App::Mi6](https://modules.raku.org/dist/App::Mi6) Minimal authoring tool for Raku
- [META6](https://modules.raku.org/dist/META6) Do things with Raku `META` files
- [Module::Skeleton](https://bitbucket.org/rightfold/module-skeleton) Generate a skeleton module
- [p6doc](https://modules.raku.org/dist/p6doc) Generate documentation end-products

<a id="测试--tests"></a>
# 测试 / Tests

模组质量测试。

Some tests of module quality.

- [Test::META](https://modules.raku.org/dist/Test::META) 测试 META6.json 文件
- [Test::Output](https://modules.raku.org/dist/Test::Output) 测试程序生成的 STDOUT 和 STDERR 输出
- [Test::Screen](https://modules.raku.org/dist/Proc::Screen) 使用 **GNU 屏幕**测试全屏 VT 应用程序
- [Test::When](https://modules.raku.org/dist/Test::When) 控制测试运行的时间(作者测试、在线测试等)。

- [Test::META](https://modules.raku.org/dist/Test::META) Test your META6.json file
- [Test::Output](https://modules.raku.org/dist/Test::Output) Test the output to STDOUT and STDERR your program generates
- [Test::Screen](https://modules.raku.org/dist/Proc::Screen) Use **GNU screen** to test full screen VT applications
- [Test::When](https://modules.raku.org/dist/Test::When) Control when your tests are run (author testing, online testing, etc.)

<a id="nativecall"></a>
# NativeCall

这里有一些模组可以帮助你使用 NativeCall。

Here some modules to help you work with NativeCall.

- [NativeHelpers::Array](https://modules.raku.org/dist/NativeHelpers::Array) 提供处理 CArray 的子例程
- [App::GPTrixie](https://modules.raku.org/dist/App::GPTrixie) 从 C 头文件生成 NativeCall 代码
- [NativeCall::TypeDiag](https://modules.raku.org/dist/NativeCall::TypeDiag) 提供测试 CStruct 的子例程

- [NativeHelpers::Array](https://modules.raku.org/dist/NativeHelpers::Array) Provides routines to deal with CArray
- [App::GPTrixie](https://modules.raku.org/dist/App::GPTrixie) Generate NativeCall code from C headers file
- [NativeCall::TypeDiag](https://modules.raku.org/dist/NativeCall::TypeDiag) Provides routines to test your CStruct

<a id="样本模块--sample-modules"></a>
# 样本模块 / Sample modules

仅作为极简示例、安装程序测试或骨架存在的模块。

Modules that exist only as minimalist examples, tests for installers, or skeletons.

- [foo](https://modules.raku.org/dist/Foo) 一个具有两个不同版本的发行版的模块

- [Foo](https://modules.raku.org/dist/Foo) A module with two distributions of different versions
