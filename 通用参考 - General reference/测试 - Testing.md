原文：https://docs.raku.org/language/testing

# 测试 - Testing

在 Raku 中编写和运行测试

Writing and running tests in Raku

测试代码是软件开发的一个组成部分。测试提供代码行为的自动、可重复验证，并确保代码按预期工作。

Testing code is an integral part of software development. Tests provide automated, repeatable verifications of code behavior, and ensures your code works as expected.

在 Raku 中，[Test](https://docs.raku.org/type/Test) 模块提供了一个测试框架，也被 Raku 的官方规范测试套件使用。

In Raku, the [Test](https://docs.raku.org/type/Test) module provides a testing framework, used also by Raku's official spectest suite.

测试函数发出符合[测试任意议定书](https://testanything.org/)的输出。一般而言，它们被用于 sink 上下文：

The testing functions emit output conforming to the [Test Anything Protocol](https://testanything.org/). In general, they are used in sink context:

```Raku
ok check-name($meta, :$relaxed-name), "name has a hyphen rather than '::'"
```

但是，如果测试成功与否，则所有函数也作为布尔值返回，如果测试失败，则可用于打印消息：

but all functions also return as a Boolean if the test has been successful or not, which can be used to print a message if the test fails:

```Raku
ok check-name($meta, :$relaxed-name), "name has a hyphen rather than '::'" \
  or diag "\nTo use hyphen in name, pass :relaxed-name to check-name\n";
```

<!-- MarkdownTOC -->

- [编写测试 / Writing tests](#%E7%BC%96%E5%86%99%E6%B5%8B%E8%AF%95--writing-tests)
    - [线程安全 / Thread safety](#%E7%BA%BF%E7%A8%8B%E5%AE%89%E5%85%A8--thread-safety)
- [运行测试 / Running tests](#%E8%BF%90%E8%A1%8C%E6%B5%8B%E8%AF%95--running-tests)
- [测试计划 / Test plans](#%E6%B5%8B%E8%AF%95%E8%AE%A1%E5%88%92--test-plans)
- [测试返回值 / Testing return values](#%E6%B5%8B%E8%AF%95%E8%BF%94%E5%9B%9E%E5%80%BC--testing-return-values)
    - [按字符串比较 / By string comparison](#%E6%8C%89%E5%AD%97%E7%AC%A6%E4%B8%B2%E6%AF%94%E8%BE%83--by-string-comparison)
    - [按近似数值比较 /  By approximate numeric comparison](#%E6%8C%89%E8%BF%91%E4%BC%BC%E6%95%B0%E5%80%BC%E6%AF%94%E8%BE%83--by-approximate-numeric-comparison)
    - [按数据结构比较 / By structural comparison](#%E6%8C%89%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84%E6%AF%94%E8%BE%83--by-structural-comparison)
    - [按任意类型比较 / By arbitrary comparison](#%E6%8C%89%E4%BB%BB%E6%84%8F%E7%B1%BB%E5%9E%8B%E6%AF%94%E8%BE%83--by-arbitrary-comparison)
    - [按对象类型 / By object type](#%E6%8C%89%E5%AF%B9%E8%B1%A1%E7%B1%BB%E5%9E%8B--by-object-type)
    - [按方法名 / By method name](#%E6%8C%89%E6%96%B9%E6%B3%95%E5%90%8D--by-method-name)
    - [按角色 / By role](#%E6%8C%89%E8%A7%92%E8%89%B2--by-role)
    - [按正则 / By regex](#%E6%8C%89%E6%AD%A3%E5%88%99--by-regex)
- [测试模组 / Testing modules](#%E6%B5%8B%E8%AF%95%E6%A8%A1%E7%BB%84--testing-modules)
- [测试异常 / Testing exceptions](#%E6%B5%8B%E8%AF%95%E5%BC%82%E5%B8%B8--testing-exceptions)
- [分组测试 / Grouping tests](#%E5%88%86%E7%BB%84%E6%B5%8B%E8%AF%95--grouping-tests)
- [跳过测试 / Skipping tests](#%E8%B7%B3%E8%BF%87%E6%B5%8B%E8%AF%95--skipping-tests)
- [人工控制 / Manual control](#%E4%BA%BA%E5%B7%A5%E6%8E%A7%E5%88%B6--manual-control)

<!-- /MarkdownTOC -->


<a id="%E7%BC%96%E5%86%99%E6%B5%8B%E8%AF%95--writing-tests"></a>
# 编写测试 / Writing tests

与任何 Perl 项目一样，测试都存在于项目基本目录中的 `t` 目录下。

As with any Perl project, the tests live under the `t` directory in the project's base directory.

一个典型的测试文件看起来像这样：

A typical test file looks something like this:

```Raku
use Test;      # a Standard module included with Rakudo 
use lib 'lib';
 
plan $num-tests;
 
# .... tests 
 
done-testing;  # optional with 'plan' 
```

我们确保通过 `use v6.c` 指令使用 Raku，然后加载 `Test` 模块并指定我们的库在哪里。然后，我们指定我们*计划*运行多少测试（这样测试框架就可以告诉我们是否运行了比我们预期的更多或更少的测试），当测试完成时，我们使用 *done-testing* 来告诉我们已经完成的框架。

We ensure that we're using Raku, via the `use v6.c` pragma, then we load the `Test` module and specify where our libraries are. We then specify how many tests we *plan* to run (such that the testing framework can tell us if more or fewer tests were run than we expected) and when finished with the tests, we use *done-testing* to tell the framework we are done.

<a id="%E7%BA%BF%E7%A8%8B%E5%AE%89%E5%85%A8--thread-safety"></a>
## 线程安全 / Thread safety

请注意，`Test` 模块中的例程*不是*线程安全的。这意味着你不应该尝试在多个线程中同时使用测试例程，因为 [TAP](https://testanything.org/) 输出可能会出现顺序错误，并混淆了解释它的程序。

Note that routines in `Test` module are *not* thread-safe. This means you should not attempt to use the testing routines in multiple threads simultaneously, as the [TAP](https://testanything.org/) output might come out of order and confuse the program interpreting it.

目前没有使其线程安全的计划。如果线程测试对你至关重要，你可能会找到一些合适的[生态系统模块](https://modules.raku.org/search/?q=Test)来使用，而不是使用 `Test` 来满足你的测试需要。

There are no current plans to make it thread safe. If threaded-testing is crucial to you, you may find some suitable [ecosystem modules](https://modules.raku.org/search/?q=Test) to use instead of `Test` for your testing needs.

<a id="%E8%BF%90%E8%A1%8C%E6%B5%8B%E8%AF%95--running-tests"></a>
# 运行测试 / Running tests

通过在命令行中指定测试文件名，可以单独运行测试：

Tests can be run individually by specifying the test filename on the command line:

```Raku
$ perl6 t/test-filename.t
```

若要递归地运行目录中的所有测试，可以使用 [prove6](https://modules.raku.org/dist/App::Prove6) 应用程序。

To run all tests in the directory recursively, [prove6](https://modules.raku.org/dist/App::Prove6) application can be used.

你必须在使用之前用 zef 安装它：

You have to install it before using with zef:

```Raku
$ zef install App::Prove6
```

你可以这样在分发目录中运行 `prove6`：

You can run `prove6` in a distribution directory this way:

```Raku
$ prove6 --lib t/
```

`t/` 参数指定的包含测试的目录和 `--lib` 选项被传递到将 `lib` 目录包含到 Raku 分发路径中，它相当于 `perl6` 命令的 `-Ilib` 参数。

The `t/` argument specified directory that contains tests and the `--lib` option is passed to include `lib` directory into Raku distribution path, it is an equivalent of `-Ilib` argument of `perl6` command.

有关 `prove6` 用法的更多文件，请参阅[页面](https://modules.raku.org/dist/App::Prove6).

For more documentation regarding `prove6` usage refer to [its page](https://modules.raku.org/dist/App::Prove6).

若要在第一次失败时中止测试套件，请设置 `PERL6_TEST_DIE_ON_FAIL` 环境变量：

To abort the test suite upon first failure, set the `PERL6_TEST_DIE_ON_FAIL` environmental variable:

```Raku
$ PERL6_TEST_DIE_ON_FAIL=1 perl6 t/test-filename.t
```

在测试文件中可以使用相同的变量。 在加载 `Test` 模块之前设置：

The same variable can be used within the test file. Set it before loading the `Test` module:

```Raku
BEGIN %*ENV<PERL6_TEST_DIE_ON_FAIL> = 1;
use Test;
...
```

<a id="%E6%B5%8B%E8%AF%95%E8%AE%A1%E5%88%92--test-plans"></a>
# 测试计划 / Test plans

测试计划使用 [`plan`](https://docs.raku.org/type/Test#plan) 来声明将要做或者可能是跳过多少个计划。 如果没有声明计划，则使用 [`done-testing`](https://docs.raku.org/type/Test#done-testing) 声明测试结束。

Tests plans use [`plan`](https://docs.raku.org/type/Test#plan) for declaring how many plans are going to be done or, as might be the case, skipped. If no plan is declared, [`done-testing`](https://docs.raku.org/type/Test#done-testing) is used to declare the end of the tests.

<a id="%E6%B5%8B%E8%AF%95%E8%BF%94%E5%9B%9E%E5%80%BC--testing-return-values"></a>
# 测试返回值 / Testing return values

`Test` 模块导出检查给定表达式返回值并产生标准化测试输出的各种功能。

The `Test` module exports various functions that check the return value of a given expression and produce standardized test output.

在实践中，表达式通常是对要进行单元测试的函数或方法的调用。 [`OK`](https://docs.raku.org/type/Test#ok )和 [`NOK`](https://docs.raku.org/type/Test#NOK) 将匹配 `True` 和 `False`。 然而，如果可能的话，最好使用下面的一个专门的比较测试函数，因为它们可以打印更有用的诊断输出，以防比较失败。

In practice, the expression will often be a call to a function or method that you want to unit-test. [`ok`](https://docs.raku.org/type/Test#ok) and [`nok`](https://docs.raku.org/type/Test#nok) will match `True` and `False`. However, where possible it's better to use one of the specialized comparison test functions below, because they can print more helpful diagnostics output in case the comparison fails.

<a id="%E6%8C%89%E5%AD%97%E7%AC%A6%E4%B8%B2%E6%AF%94%E8%BE%83--by-string-comparison"></a>
## 按字符串比较 / By string comparison

使用 [`is`](https://docs.raku.org/type/Test#is) 或 [`nok`](https://docs.raku.org/type/Test#isnt) 进行等式测试，取决于它处理的对象（或类）

[`is`](https://docs.raku.org/type/Test#is) and [`nok`](https://docs.raku.org/type/Test#isnt) test for equality using the proper operator, depending on the object (or class) it's handled.

<a id="%E6%8C%89%E8%BF%91%E4%BC%BC%E6%95%B0%E5%80%BC%E6%AF%94%E8%BE%83--by-approximate-numeric-comparison"></a>
## 按近似数值比较 /  By approximate numeric comparison

[`is-approx`](https://docs.raku.org/type/Test#is-approx) 比较数字与一定的精度，这可以是绝对的或相对的。 它可以用于数值，其精度将取决于内部表示。

[`is-approx`](https://docs.raku.org/type/Test#is-approx) compares numbers with a certain precision, which can be absolute or relative. It can be useful for numeric values whose precision will depend on the internal representation.

<a id="%E6%8C%89%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84%E6%AF%94%E8%BE%83--by-structural-comparison"></a>
## 按数据结构比较 / By structural comparison

数据结构也可以使用 [`is-deeply`](https://docs.raku.org/type/Test#is-deeply) 进行比较，这将比较对象的内部结构是否相同。

Structures can be also compared using [`is-deeply`](https://docs.raku.org/type/Test#is-deeply), which will check that internal structures of the objects compared is the same.

<a id="%E6%8C%89%E4%BB%BB%E6%84%8F%E7%B1%BB%E5%9E%8B%E6%AF%94%E8%BE%83--by-arbitrary-comparison"></a>
## 按任意类型比较 / By arbitrary comparison

你可以使用 [`cmp-ok`](https://docs.raku.org/type/Test#cmp-ok) 进行任何类型的比较 ，它将你想要用于比较的函数或运算符作为参数。

You can use any kind of comparison with [`cmp-ok`](https://docs.raku.org/type/Test#cmp-ok), which takes as an argument the function or operator that you want to be used for comparing.

<a id="%E6%8C%89%E5%AF%B9%E8%B1%A1%E7%B1%BB%E5%9E%8B--by-object-type"></a>
## 按对象类型 / By object type

[`isa-ok`](https://docs.raku.org/type/Test#isa-ok) 测试一个对象是否属于某一类型。

[`isa-ok`](https://docs.raku.org/type/Test#isa-ok) tests whether an object is of a certain type.

<a id="%E6%8C%89%E6%96%B9%E6%B3%95%E5%90%8D--by-method-name"></a>
## 按方法名 / By method name

[`can-ok`](https://docs.raku.org/type/Test#can-ok) 用在对象上检查对象是否有特定的方法。

[`can-ok`](https://docs.raku.org/type/Test#can-ok) is used on objects to check whether they have that particular method.

<a id="%E6%8C%89%E8%A7%92%E8%89%B2--by-role"></a>
## 按角色 / By role

```
does-ok($variable, $role, $description?)
```

[`does-ok`](https://docs.raku.org/type/Test#does-ok) 检查给定的变量是否可以有特定的 [Role](https://docs.raku.org/language/objects#Roles)。

[`does-ok`](https://docs.raku.org/type/Test#does-ok) checks whether the given variable can do a certain [Role](https://docs.raku.org/language/objects#Roles).

<a id="%E6%8C%89%E6%AD%A3%E5%88%99--by-regex"></a>
## 按正则 / By regex

[`like`](https://docs.raku.org/type/Test#like) 与 [`unlike`](https://docs.raku.org/type/Test#unlike) 使用正则检查；在第一种情况下，如果存在匹配则通过，在第二种情况下，当它不匹配时，通过检查。

[`like`](https://docs.raku.org/type/Test#like) and [`unlike`](https://docs.raku.org/type/Test#unlike) check using regular expressions; in the first case passes if a match exists, in the second case when it does not.

<a id="%E6%B5%8B%E8%AF%95%E6%A8%A1%E7%BB%84--testing-modules"></a>
# 测试模组 / Testing modules

Modules are tentatively loaded with [`use-ok`](https://docs.raku.org/type/Test#use-ok), which fails if they fail to load.

<a id="%E6%B5%8B%E8%AF%95%E5%BC%82%E5%B8%B8--testing-exceptions"></a>
# 测试异常 / Testing exceptions

[`dies-ok`](https://docs.raku.org/type/Test#dies-ok) 和 [`lives-ok`](https://docs.raku.org/type/Test#lives-ok) 是测试代码的两种相反的方式；第一种方式检测代码异常的抛出，第二种检查异常不抛出；[`throws-like`](https://docs.raku.org/type/Test#throws-like) 检查代码是否抛出作为参数传递的特定异常；[`fails-like`](https://docs.raku.org/type/Test#fails-like) 类似地，检查代码是否返回特定类型的 [Failure](https://docs.raku.org/type/Failure)。[`eval-dies-ok`](https://docs.raku.org/type/Test#eval-dies-ok) 和 [`eval-lives-ok`](https://docs.raku.org/type/Test#eval-lives-ok) 作用于测试的字符串，有类似的效果。

[`dies-ok`](https://docs.raku.org/type/Test#dies-ok) and [`lives-ok`](https://docs.raku.org/type/Test#lives-ok) are opposites ways of testing code; the first checks that it throws an exception, the second that it does not; [`throws-like`](https://docs.raku.org/type/Test#throws-like) checks that the code throws the specific exception it gets handed as an argument; [`fails-like`](https://docs.raku.org/type/Test#fails-like), similarly, checks if the code returns a specific type of [Failure](https://docs.raku.org/type/Failure). [`eval-dies-ok`](https://docs.raku.org/type/Test#eval-dies-ok) and [`eval-lives-ok`](https://docs.raku.org/type/Test#eval-lives-ok) work similarly on strings that are evaluated prior to testing.

<a id="%E5%88%86%E7%BB%84%E6%B5%8B%E8%AF%95--grouping-tests"></a>
# 分组测试 / Grouping tests

一组子测试的结果为 `ok` 如果所有子测试都 `ok`；它们使用 [`subtest`](https://docs.raku.org/type/Test#subtest) 分组。

The result of a group of subtests is only `ok` if all subtests are `ok`; they are grouped using [`subtest`](https://docs.raku.org/type/Test#subtest).

<a id="%E8%B7%B3%E8%BF%87%E6%B5%8B%E8%AF%95--skipping-tests"></a>
# 跳过测试 / Skipping tests

有时测试还没有准备好运行，例如，可能还没有实现功能，在这种情况下，测试可以标记为 [`todo`](https://docs.raku.org/type/Test#todo)。 或者，一个特定的功能只在特定的平台上工作-在这种情况下，一个人会 [`skip`](https://docs.raku.org/type/Test#skip) 其他平台上的测试；[`skip-rest`](https://docs.raku.org/type/Test#skip-rest) 将跳过其余的测试，而不是作为参数给出的特定数字；[`bail-out`](https://docs.raku.org/type/Test#bail-out) 将简单地用消息退出测试。

Sometimes tests just aren't ready to be run, for instance a feature might not yet be implemented, in which case tests can be marked as [`todo`](https://docs.raku.org/type/Test#todo). Or it could be the case that a given feature only works on a particular platform - in which case one would [`skip`](https://docs.raku.org/type/Test#skip) the test on other platforms; [`skip-rest`](https://docs.raku.org/type/Test#skip-rest) will skip the remaining tests instead of a particular number given as argument; [`bail-out`](https://docs.raku.org/type/Test#bail-out) will simply exit the tests with a message.

<a id="%E4%BA%BA%E5%B7%A5%E6%8E%A7%E5%88%B6--manual-control"></a>
# 人工控制 / Manual control

如果上面记录的方便功能不适合你的需要，你可以使用以下功能手动指导测试线束输出；[`pass`](https://docs.raku.org/type/Test#pass) 将表示测试已经通过，[`diag`](https://docs.raku.org/type/Test#diag) 将打印（可能）通知消息。

If the convenience functionality documented above does not suit your needs, you can use the following functions to manually direct the test harness output; [`pass`](https://docs.raku.org/type/Test#pass) will say a test has passed, and [`diag`](https://docs.raku.org/type/Test#diag) will print a (possibly) informative message.
