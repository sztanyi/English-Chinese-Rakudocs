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

We ensure that we're using Raku, via the `use v6.c` pragma, then we load the `Test` module and specify where our libraries are. We then specify how many tests we *plan* to run (such that the testing framework can tell us if more or fewer tests were run than we expected) and when finished with the tests, we use *done-testing* to tell the framework we are done.

## Thread safety

Note that routines in `Test` module are *not* thread-safe. This means you should not attempt to use the testing routines in multiple threads simultaneously, as the [TAP](https://testanything.org/) output might come out of order and confuse the program interpreting it.

There are no current plans to make it thread safe. If threaded-testing is crucial to you, you may find some suitable [ecosystem modules](https://modules.raku.org/search/?q=Test) to use instead of `Test` for your testing needs.

# Running tests

Tests can be run individually by specifying the test filename on the command line:

```Raku
$ perl6 t/test-filename.t
```

To run all tests in the directory recursively, [prove6](https://modules.raku.org/dist/App::Prove6) application can be used.

You have to install it before using with zef:

```Raku
$ zef install App::Prove6
```

You can run `prove6` in a distribution directory this way:

```Raku
$ prove6 --lib t/
```

The `t/` argument specified directory that contains tests and the `--lib` option is passed to include `lib` directory into Raku distribution path, it is an equivalent of `-Ilib` argument of `perl6` command.

For more documentation regarding `prove6` usage refer to [its page](https://modules.raku.org/dist/App::Prove6).

To abort the test suite upon first failure, set the `PERL6_TEST_DIE_ON_FAIL` environmental variable:

```Raku
$ PERL6_TEST_DIE_ON_FAIL=1 perl6 t/test-filename.t
```

The same variable can be used within the test file. Set it before loading the `Test` module:

```Raku
BEGIN %*ENV<PERL6_TEST_DIE_ON_FAIL> = 1;
use Test;
...
```

# Test plans

Tests plans use [`plan`](https://docs.raku.org/type/Test#plan) for declaring how many plans are going to be done or, as might be the case, skipped. If no plan is declared, [`done-testing`](https://docs.raku.org/type/Test#done-testing) is used to declare the end of the tests.

# Testing return values

The `Test` module exports various functions that check the return value of a given expression and produce standardized test output.

In practice, the expression will often be a call to a function or method that you want to unit-test. [`ok`](https://docs.raku.org/type/Test#ok) and [`nok`](https://docs.raku.org/type/Test#nok) will match `True` and `False`. However, where possible it's better to use one of the specialized comparison test functions below, because they can print more helpful diagnostics output in case the comparison fails.

## By string comparison

[`is`](https://docs.raku.org/type/Test#is) and [`nok`](https://docs.raku.org/type/Test#isnt) test for equality using the proper operator, depending on the object (or class) it's handled.

## By approximate numeric comparison

[`is-approx`](https://docs.raku.org/type/Test#is-approx) compares numbers with a certain precision, which can be absolute or relative. It can be useful for numeric values whose precision will depend on the internal representation.

## By structural comparison

Structures can be also compared using [`is-deeply`](https://docs.raku.org/type/Test#is-deeply), which will check that internal structures of the objects compared is the same.

## By arbitrary comparison

You can use any kind of comparison with [`cmp-ok`](https://docs.raku.org/type/Test#cmp-ok), which takes as an argument the function or operator that you want to be used for comparing.

## By object type

[`isa-ok`](https://docs.raku.org/type/Test#isa-ok) tests whether an object is of a certain type.

## By method name

[`can-ok`](https://docs.raku.org/type/Test#can-ok) is used on objects to check whether they have that particular method.

## By role

- does-ok($variable, $role, $description?)

[`does-ok`](https://docs.raku.org/type/Test#does-ok) checks whether the given variable can do a certain [Role](https://docs.raku.org/language/objects#Roles).

## By regex

[`like`](https://docs.raku.org/type/Test#like) and [`unlike`](https://docs.raku.org/type/Test#unlike) check using regular expressions; in the first case passes if a match exists, in the second case when it does not.

# Testing modules

Modules are tentatively loaded with [`use-ok`](https://docs.raku.org/type/Test#use-ok), which fails if they fail to load.

# Testing exceptions

[`dies-ok`](https://docs.raku.org/type/Test#dies-ok) and [`lives-ok`](https://docs.raku.org/type/Test#lives-ok) are opposites ways of testing code; the first checks that it throws an exception, the second that it does not; [`throws-like`](https://docs.raku.org/type/Test#throws-like) checks that the code throws the specific exception it gets handed as an argument; [`fails-like`](https://docs.raku.org/type/Test#fails-like), similarly, checks if the code returns a specific type of [Failure](https://docs.raku.org/type/Failure). [`eval-dies-ok`](https://docs.raku.org/type/Test#eval-dies-ok) and [`eval-lives-ok`](https://docs.raku.org/type/Test#eval-lives-ok) work similarly on strings that are evaluated prior to testing.

# Grouping tests

The result of a group of subtests is only `ok` if all subtests are `ok`; they are grouped using [`subtest`](https://docs.raku.org/type/Test#subtest).

# Skipping tests

Sometimes tests just aren't ready to be run, for instance a feature might not yet be implemented, in which case tests can be marked as [`todo`](https://docs.raku.org/type/Test#todo). Or it could be the case that a given feature only works on a particular platform - in which case one would [`skip`](https://docs.raku.org/type/Test#skip) the test on other platforms; [`skip-rest`](https://docs.raku.org/type/Test#skip-rest) will skip the remaining tests instead of a particular number given as argument; [`bail-out`](https://docs.raku.org/type/Test#bail-out) will simply exit the tests with a message.

# Manual control

If the convenience functionality documented above does not suit your needs, you can use the following functions to manually direct the test harness output; [`pass`](https://docs.raku.org/type/Test#pass) will say a test has passed, and [`diag`](https://docs.raku.org/type/Test#diag) will print a (possibly) informative message.
