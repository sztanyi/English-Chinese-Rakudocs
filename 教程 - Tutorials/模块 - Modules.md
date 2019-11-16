原文：https://docs.raku.org/language/modules

# 模块 / Modules

如何创建、使用和分发 Raku 模块

How to create, use, and distribute Raku modules

<!-- MarkdownTOC -->

- [创建和使用模块 / Creating and using modules](#%E5%88%9B%E5%BB%BA%E5%92%8C%E4%BD%BF%E7%94%A8%E6%A8%A1%E5%9D%97--creating-and-using-modules)
  - [寻找和安装模块 / Looking for and installing modules.](#%E5%AF%BB%E6%89%BE%E5%92%8C%E5%AE%89%E8%A3%85%E6%A8%A1%E5%9D%97--looking-for-and-installing-modules)
  - [基本结构 / Basic structure](#%E5%9F%BA%E6%9C%AC%E7%BB%93%E6%9E%84--basic-structure)
- [加载与基本引入 / Loading and basic importing](#%E5%8A%A0%E8%BD%BD%E4%B8%8E%E5%9F%BA%E6%9C%AC%E5%BC%95%E5%85%A5--loading-and-basic-importing)
  - [`need`](#need)
  - [`use`](#use)
  - [`require`](#require)
  - [词法模块加载 / Lexical module loading](#%E8%AF%8D%E6%B3%95%E6%A8%A1%E5%9D%97%E5%8A%A0%E8%BD%BD--lexical-module-loading)
  - [导出和选择性导入 / Exporting and selective importing](#%E5%AF%BC%E5%87%BA%E5%92%8C%E9%80%89%E6%8B%A9%E6%80%A7%E5%AF%BC%E5%85%A5--exporting-and-selective-importing)
    - [is export](#is-export)
    - [UNIT::EXPORT::*](#unitexport)
    - [EXPORT](#export)
  - [内省 / Introspection](#%E5%86%85%E7%9C%81--introspection)
  - [查找已安装的模块 / Finding installed modules](#%E6%9F%A5%E6%89%BE%E5%B7%B2%E5%AE%89%E8%A3%85%E7%9A%84%E6%A8%A1%E5%9D%97--finding-installed-modules)
- [发布模块 / Distributing modules](#%E5%8F%91%E5%B8%83%E6%A8%A1%E5%9D%97--distributing-modules)
  - [准备模块 / Preparing the module](#%E5%87%86%E5%A4%87%E6%A8%A1%E5%9D%97--preparing-the-module)
  - [将模块上传到 CPAN / Upload your module to CPAN](#%E5%B0%86%E6%A8%A1%E5%9D%97%E4%B8%8A%E4%BC%A0%E5%88%B0-cpan--upload-your-module-to-cpan)
  - [将模块上传到 p6c / Upload your module to p6c](#%E5%B0%86%E6%A8%A1%E5%9D%97%E4%B8%8A%E4%BC%A0%E5%88%B0-p6c--upload-your-module-to-p6c)
- [与模块创作相关的模块和工具 / Modules and tools related to module authoring](#%E4%B8%8E%E6%A8%A1%E5%9D%97%E5%88%9B%E4%BD%9C%E7%9B%B8%E5%85%B3%E7%9A%84%E6%A8%A1%E5%9D%97%E5%92%8C%E5%B7%A5%E5%85%B7--modules-and-tools-related-to-module-authoring)
  - [联系信息 / Contact information](#%E8%81%94%E7%B3%BB%E4%BF%A1%E6%81%AF--contact-information)

<!-- /MarkdownTOC -->


<a id="%E5%88%9B%E5%BB%BA%E5%92%8C%E4%BD%BF%E7%94%A8%E6%A8%A1%E5%9D%97--creating-and-using-modules"></a>
# 创建和使用模块 / Creating and using modules

模块通常是一个或一组揭露 Raku 构造的源文件。

A module is usually a source file or set of source files that expose Raku constructs.

[[1]](https://docs.raku.org/language/modules#fn-1)

模块通常是软件包（[类](https://docs.raku.org/language/objects#Classes)、[角色](https://docs.raku.org/language/objects#Roles)、[语法](https://docs.raku.org/type/Grammar)）、[子例程](https://docs.raku.org/language/functions)，有时是[变量](https://docs.raku.org/language/variables)。在 Raku *模块*中，还可以引用使用 `module` 关键字声明的包的类型（请参见[模块包](https://docs.raku.org/language/module-packages)和下面的示例），但此处我们主要指的是作为命名空间中的一组源文件的"模块"。

Modules are typically packages ([classes](https://docs.raku.org/language/objects#Classes), [roles](https://docs.raku.org/language/objects#Roles), [grammars](https://docs.raku.org/type/Grammar)), [subroutines](https://docs.raku.org/language/functions), and sometimes [variables](https://docs.raku.org/language/variables). In Raku *module* can also refer to a type of package declared with the `module` keyword (see [Module Packages](https://docs.raku.org/language/module-packages) and the examples below) but here we mostly mean "module" as a set of source files in a namespace.

<a id="%E5%AF%BB%E6%89%BE%E5%92%8C%E5%AE%89%E8%A3%85%E6%A8%A1%E5%9D%97--looking-for-and-installing-modules"></a>
## 寻找和安装模块 / Looking for and installing modules.

[`zef`](https://github.com/ugexe/zef) 是用于在 Raku 中安装模块的应用程序。模块列在 [Raku 生态系统](https://modules.perl6.org/) 中，可以在那里搜索，也可以从命令行使用 `zef search` 搜索：

[`zef`](https://github.com/ugexe/zef) is the application used for installing modules in Raku. Modules are listed in [the Raku ecosystem](https://modules.perl6.org/) and can be searched there or from the command line using `zef search`:

```Raku
zef search WWW
```

将返回包含 WWW 的模块列表。然后,

will return a list of modules that includes WWW in their name, for instance. Then,

```Raku
zef install WWW
```

如果尚未安装，将使用该特定名称安装模块。[[2]](https://docs.raku.org/language/modules#fn-2)

will install the module with that particular name, if it is not already installed. [[2\]](https://docs.raku.org/language/modules#fn-2)

<a id="%E5%9F%BA%E6%9C%AC%E7%BB%93%E6%9E%84--basic-structure"></a>
## 基本结构 / Basic structure

Raku 中的模块分布（在*关联源码文件集合*的意义上）具有与 Perl 族语言中的任何分布相同的结构：存在一个主项目目录，包含一个 `README` 和一个 `LICENSE` 文件，用于源文件的“lib”目录，这些文件可以单独地称为模块和/或可以自己定义带有 `module` 关键字的模块 [[3]](https://docs.raku.org/language/modules#fn-3)，用于测试的 `t` 目录，以及可执行文件和脚本的 `bin` 目录。

Module distributions (in the *set of related source files* sense) in Raku have the same structure as any distribution in the Perl family of languages: there is a main project directory containing a `README` and a `LICENSE` file, a `lib` directory for the source files, which may be individually referred to as modules and/or may themselves define modules with the `module` keyword [[3]](https://docs.raku.org/language/modules#fn-3) , a `t` directory for tests, and possibly a `bin` directory for executable programs and scripts.

源文件通常使用 `.pm6` 扩展名，脚本或可执行文件使用 `.p6`。测试文件使用 `.t` 扩展名。包含文档的文件使用 `.pod6` 扩展名。

Source files generally use the `.pm6` extension, and scripts or executables use the `.p6`. Test files use the `.t` extension. Files which contain documentation use the `.pod6` extension.

<a id="%E5%8A%A0%E8%BD%BD%E4%B8%8E%E5%9F%BA%E6%9C%AC%E5%BC%95%E5%85%A5--loading-and-basic-importing"></a>
# 加载与基本引入 / Loading and basic importing

加载模块使在加载程序的文件范围内声明的相同命名空间中的包可用。从模块导入使导出的符号在导入语句的词法范围中可用。

Loading a module makes the packages in the same namespace declared within available in the file scope of the loader. Importing from a module makes the symbols exported available in the lexical scope of the importing statement.

<a id="need"></a>
## `need`

`need` 在编译时加载 `compunit`。

`need` loads a `compunit` at compile time.

```Raku
need MyModule;
```

也可以使用在定义的命名空间中的任何包。

Any packages in the namespace defined within will also be available.

```Raku
# MyModule.pm6 
unit module MyModule;

class Class {}
```

`MyModule::Class` 将在加载 `MyModule` 时定义，你可以直接使用它的完全限定名（FQN）使用它。通过这种方式定义的类和其他类型不会自动导出；如果要使用它的短名称，则需要显式导出它：

`MyModule::Class` will be defined when `MyModule` is loaded, and you can use it directly employing its fully qualified name (FQN). Classes and other types defined that way are not automatically exported; you will need to explicitly export it if you want to use it by its short name:

```Raku
# MyModule.pm6 
unit module MyModule;

class Class is export {}
```

然后

And then

```Raku
use MyModule;
 
my $class = Class.new();
say $class.perl;
```

<a id="use"></a>
## `use`

`use` 在编译时从编译单元加载并导入。它将查找以 `.pm6` 结尾的文件（`.pm`也受支持，但不受鼓励）。运行时将在哪里查找模块，请看[这](https://docs.raku.org/language/modules#Finding_installed_modules)。

`use` loads and then imports from a compunit at compile time. It will look for files that end in `.pm6` (`.pm` is also supported, but discouraged). See [here](https://docs.raku.org/language/modules#Finding_installed_modules) for where the runtime will look for modules.

```Raku
use MyModule;
```

等同于：

This is equivalent to:

```Raku
need MyModule;
import MyModule;
```

还请参阅[选择性导入](https://docs.raku.org/language/modules#Exporting_and_selective_importing)以限制你导入的内容。

See also [selective importing](https://docs.raku.org/language/modules#Exporting_and_selective_importing) to restrict what you import.

<a id="require"></a>
## `require`

`require` 在运行时加载一个计算单元并导入明确的符号。

`require` loads a compunit and imports definite symbols at runtime.

```Raku
say "loading MyModule";
require MyModule;
```

如果将计算单元名称放入间接查找中，则它可以位于运行时变量中。

The compunit name can be in a runtime variable if you put it inside an indirect lookup.

```Raku
my $name = 'MyModule';
require ::($name);
```

加载模块提供的符号不会导入当前范围。例如，你可以用[动态查看](https://docs.raku.org/language/packages#index-entry-::()) 或 [动态子集](https://docs.raku.org/language/typesystem#subset)来使用它们，通过提供符号的完全限定名：

The symbols provided by the loaded module will not be imported into the current scope. You may use [dynamic lookup](https://docs.raku.org/language/packages#index-entry-::()) or [dynamic subsets](https://docs.raku.org/language/typesystem#subset) to use them by providing the fully qualified name of a symbol, for instance:

```Raku
require ::("Test");
my &mmk = ::("Test::EXPORT::DEFAULT::&ok");
mmk('oi‽'); # OUTPUT: «ok 1 - ␤»
```

`ok` 的全限定名是 `Test::EXPORT::DEFAULT::&ok`。我们将其别名为 `mmk`，以便在当前范围内使用 `Test` 提供的符号。

The FQN of `ok` is `Test::EXPORT::DEFAULT::&ok`. We are aliasing it to `mmk` so that we can use that symbol provided by `Test` in the current scope.

要导入符号，必须在编译时定义它们。**注：** `require` 在词汇范围内：

To import symbols you must define them at compile time. **NOTE:** `require` is lexically scoped:

```Raku
sub do-something {
   require MyModule <&something>;
   say ::('MyModule'); # MyModule symbol exists here 
   something() # &something will be defined here 
}
say ::('MyModule'); # This will NOT contain the MyModule symbol 
do-something();
# &something will not be defined here
```

如果 `MyModule` 不导出 `&something` 那么 `require` 就会失败。

If `MyModule` doesn't export `&something` then `require` will fail.

带有编译时符号的 `require` 将安装占位符 `package`，该占位符 `package` 将更新为已加载的模块、类或包。请注意，占位符将被保留，**即使需要加载模块失败。**这意味着检查是否加载这样的模块是错误的：

A `require` with compile-time symbol will install a placeholder `package` that will be updated to the loaded module, class, or package. Note that the placeholder will be kept, **even if require failed to load the module.** This means that checking if a module loaded like this is wrong:

```Raku
# *** WRONG: *** 
try require Foo;
if ::('Foo') ~~ Failure { say "Failed to load Foo!"; }
# *** WRONG: ***
```

由于包是编译时安装的导致 `::('Foo')` 永远不是 `Failure`。正确的方法是：

As the compile-time installed package causes `::('Foo')` to never be a `Failure`. The correct way is:

```Raku
# Use return value to test whether loading succeeded: 
(try require Foo) === Nil and say "Failed to load Foo!";
 
# Or use a runtime symbol lookup with require, to avoid compile-time 
# package installation: 
try require ::('Foo');
if ::('Foo') ~~ Failure {
    say "Failed to load Foo!";
}
```

<a id="%E8%AF%8D%E6%B3%95%E6%A8%A1%E5%9D%97%E5%8A%A0%E8%BD%BD--lexical-module-loading"></a>
## 词法模块加载 / Lexical module loading

Raku 非常注意避免全局状态，即无论你在模块中做什么，它都不应该影响其他代码。例如，这就是为什么默认情况下子例程定义在词法 （`my`）作用域内。如果你希望其他人看到它们，则需要明确地使它们 `our` 作用域或导出它们。

Raku takes great care to avoid global state, i.e. whatever you do in your module, it should not affect other code. For instance, that's why subroutine definitions are lexically (`my`) scoped by default. If you want others to see them, you need to explicitly make them `our` scoped or export them.

默认情况下类是导出的。它基于这样一种假设，当无法访问模块包含的类时，加载模块不会有多大用处。因此，加载的类只在首先加载它们的作用域 [[4]](https://docs.raku.org/language/modules#fn-4) 中注册。这意味着我们必须在实际使用它的每一个范围中 `use` 一个类。

Classes are exported by default on the assumption that loading a module will not be of much use when you cannot access the classes it contains. Loaded classes are thus registered only in the scope which loaded them in the first place [[4]](https://docs.raku.org/language/modules#fn-4). This means that we will have to `use` a class in every scope in which we actually employ it.

```Raku
use Foo;           # Foo has "use Bar" somewhere. 
use Bar;
my $foo = Foo.new;
my $bar = Bar.new;
```

<a id="%E5%AF%BC%E5%87%BA%E5%92%8C%E9%80%89%E6%8B%A9%E6%80%A7%E5%AF%BC%E5%85%A5--exporting-and-selective-importing"></a>
## 导出和选择性导入 / Exporting and selective importing

<a id="is-export"></a>
### is export

包、子例程、变量、常量和枚举是通过使用 [is export](https://docs.raku.org/routine/is%20export) 特性来导出的（还请注意用于指示作者和版本的标记）。

Packages, subroutines, variables, constants, and enums are exported by marking them with the [is export](https://docs.raku.org/routine/is%20export) trait (also note the tags available for indicating authors and versions).

```Raku
unit module MyModule:ver<1.0.3>:auth<John Hancock (jhancock@example.com)>;
our $var is export = 3;
sub foo is export { ... };
constant FOO is export = "foobar";
enum FooBar is export <one two three>;

# 对于原型 multi 方法，只需要用 is export 标记
# for multi methods, if you declare a proto you 
# only need to mark the proto with is export 
proto sub quux(Str $x, |) is export { * };
multi sub quux(Str $x) { ... };
multi sub quux(Str $x, $y) { ... };

# 对于 multi 方法，只需要用 is export 标记其中的一个
# 但是代码更具一致性如果所有的方法都标记
# for multi methods, you only need to mark one with is export 
# but the code is most consistent if all are marked 
multi sub quux(Str $x) is export { ... };
multi sub quux(Str $x, $y) is export { ... };

# 包也可以到处，如类
# Packages like classes can be exported too 
class MyClass is export {};

# 如果子包在当前包的命名空间，不需要明确导出
# If a subpackage is in the namespace of the current package 
# it doesn't need to be explicitly exported
class MyModule::MyClass {};
```

与所有特性一样，如果应用于例程，`is export` 应在任何参数列表后出现。

As with all traits, if applied to a routine, `is export` should appear after any argument list.

```Raku
sub foo(Str $string) is export { ... }
```

你可以将命名参数传递给 `is export`，以分组用于导出的符号，以便导入者选择。有三个预定义的标签：`ALL`、`DEFAULT` 和 `MANDATORY`。

You can pass named parameters to `is export` to group symbols for exporting so that the importer can pick and choose. There are three predefined tags: `ALL`, `DEFAULT` and `MANDATORY`.

```Raku
# lib/MyModule.pm6 
unit module MyModule;
sub bag        is export             { ... }
# objects with tag ':MANDATORY' are always exported 
sub pants      is export(:MANDATORY) { ... }
sub sunglasses is export(:day)       { ... }
sub torch      is export(:night)     { ... }
sub underpants is export(:ALL)       { ... }
# main.p6 
use lib 'lib';
use MyModule;          # bag, pants 
use MyModule :DEFAULT; # the same 
use MyModule :day;     # pants, sunglasses 
use MyModule :night;   # pants, torch 
use MyModule :ALL;     # bag, pants, sunglasses, torch, underpants 
```

**注**：如果模块作者没有为此做好准备，目前用户无法导入单个对象，这目前并不是一项容易的任务（参见 [RT #127305](https://rt.perl.org/Public/Bug/Display.html?id=127305)）作者可以提供这种访问的一种方式是给每个 `export` 特性赋予自己独特的标签。（标记可以是对象名！）然后用户可以（1）导入所有对象：

**Note**: there currently is no way for the user to import a single object if the module author hasn't made provision for that, and it is not an easy task at the moment (see [RT #127305](https://rt.perl.org/Public/Bug/Display.html?id=127305)). One way the author can provide such access is to give each `export` trait its own unique tag. (And the tag can be the object name!). Then the user can either (1) import all objects:

```Raku
use Foo :ALL;
```

或者（2）有选择性地导入一个或者多个对象：

or (2) import one or more objects selectively:

```Raku
use Foo :bar, :s5;
```

注意：

Notes:

1. 导出子例程中的 `:MANDATORY` 标记确保无论使用程序是否使用任何标记，都将会导出该标记。
2. 所有没有显式标记的导出子例程都隐式为 `:DEFAULT`。
3. 模块名称后面和标记之前的空格是强制性的。
4. 可以使用多个导入标记（用逗号分隔）。例如：

1. The `:MANDATORY` tag on an exported sub ensures it will be exported no matter whether the using program adds any tag or not.
2. All exported subs without an explicit tag are implicitly `:DEFAULT`.
3. The space after the module name and before the tag is mandatory.
4. Multiple import tags may be used (separated by commas). For example:

```Raku
# main.p6 
use lib 'lib';
use MyModule :day, :night; # pants, sunglasses, torch 
```

5. 在 `export` 特性中可以使用多个标签，但它们都必须用逗号或空格分隔，但不能两者兼用。

5. Multiple tags may be used in the `export` trait, but they must all be separated by either commas, or whitespace, but not both.

```Raku
sub foo() is export(:foo :s2 :net) {}
sub bar() is export(:bar, :s3, :some) {}
```

<a id="unitexport"></a>
### UNIT::EXPORT::*

在表面之下，`is export` 是将符号添加到 `EXPORT` 命名空间中的 `UNIT` 作用域包中。例如，`is export(:FOO)` 将把目标添加到 `UNIT::EXPORT::FOO` 包中。这就是 Raku 真正用来决定导入什么的方法。

Beneath the surface, `is export` is adding the symbols to a `UNIT` scoped package in the `EXPORT` namespace. For example, `is export(:FOO)` will add the target to the `UNIT::EXPORT::FOO` package. This is what Raku is really using to decide what to import.

```Raku
unit module MyModule;
 
sub foo is export { ... }
sub bar is export(:other) { ... }
```

相当于：

Is the same as:

```Raku
unit module MyModule;
 
my package EXPORT::DEFAULT {
    our sub foo { ... }
}
 
my package EXPORT::other {
    our sub bar { ... }
}
```

在大多数情况下，`is export` 就足够了，但是当你想动态生成导出的符号时，`EXPORT` 包是有用的。例如：

For most purposes, `is export` is sufficient but the `EXPORT` packages are useful when you want to produce the exported symbols dynamically. For example:

```Raku
# lib/MyModule.pm6 
unit module MyModule;
 
my package EXPORT::DEFAULT {
   for <zero one two three four>.kv -> $number, $name {
      for <sqrt log> -> $func {
         OUR::{'&' ~ $func ~ '-of-' ~ $name } := sub { $number."$func"() };
      }
   }
}
 
# main.p6 
use MyModule;
say sqrt-of-four; # OUTPUT: «2␤» 
say log-of-zero;  # OUTPUT: «-Inf␤» 
```

<a id="export"></a>
### EXPORT 

你可以使用 `EXPORT` 子例程导出任意符号。`EXPORT` 必须返回一个 [Map](https://docs.raku.org/type/Map)，其中键是符号名，值是所需的值。名称应该包括关联类型的标记（如果有的话）。

You can export arbitrary symbols with an `EXPORT` sub. `EXPORT` must return a [Map](https://docs.raku.org/type/Map), where the keys are the symbol names and the values are the desired values. The names should include the sigil (if any) for the associated type.

```Raku
# lib/MyModule.pm6 
 
class MyModule::Class { }
 
sub EXPORT {
    %(
      '$var'      => 'one',
      '@array'    => <one two three>,
      '%hash'     => %( one => 'two', three => 'four' ),
      '&doit'     => sub { say 'Greetings from exported sub' },
      'ShortName' => MyModule::Class
    )
}
# main.p6 
use lib 'lib';
use MyModule;
say $var;          # OUTPUT: «one␤» 
say @array;        # OUTPUT: «(one two three)␤» 
say %hash;         # OUTPUT: «{one => two, three => four}␤» 
doit();            # OUTPUT: «Greetings from exported sub␤» 
say ShortName.new; # OUTPUT: «MyModule::Class.new␤» 
```

注：`EXPORT` 不能在包中声明，因为它是编译单元而不是包的一部分。

Note, `EXPORT` can't be declared inside a package because it is part of the compunit rather than the package.

鉴于 `UNIT::EXPORT` 包处理传递给 `use` 的命名参数，而 `EXPORT` 子例程处理位置参数。如果将位置参数传递给 `use`，它们将被传递给 `EXPORT`。如果传递位置参数，则模块不再导出默认符号。你仍然可以通过将 `:DEFAULT` 传递给 `use` 以及你的位置参数显式地导入它们。

Whereas `UNIT::EXPORT` packages deal with the named parameters passed to `use`, the `EXPORT` sub handles positional parameters. If you pass positional parameters to `use`, they will be passed to `EXPORT`. If a positional is passed, the module no longer exports default symbols. You may still import them explicitly by passing `:DEFAULT` to `use` along with your positional parameters.

```Raku
# lib/MyModule 
 
class MyModule::Class {}
 
sub EXPORT($short_name?) {
    %(
      do $short_name => MyModule::Class if $short_name
    )
}

sub always is export(:MANDATORY) { say "works" }

#import with :ALL or :DEFAULT to get 
sub shy is export { say "you found me!" }
# main.p6 
use lib 'lib';
use MyModule 'foo';
say foo.new(); # OUTPUT: «MyModule::Class.new␤» 
 
always();      # OK   - is imported 
shy();         # FAIL - won't be imported 
```

你可以将 `EXPORT` 与类型捕获结合起来，以获得有趣的效果。此示例创建一个 `?` 后缀，它只在 [Cool](https://docs.raku.org/type/Cool) 上工作。

You can combine `EXPORT` with type captures for interesting effect. This example creates a `?` postfix which will only work on [Cool](https://docs.raku.org/type/Cool)s.

```Raku
# lib/MakeQuestionable.pm6 
sub EXPORT(::Questionable) {
    my multi postfix:<?>(Questionable $_) { .so };
    %(
      '&postfix:<?>' => &postfix:<?>,
    )
}
use MakeQuestionable Cool;
say ( 0?, 1?, {}?, %( a => "b" )? ).join(' '); # OUTPUT: «False True False True␤» 
```

<a id="%E5%86%85%E7%9C%81--introspection"></a>
## 内省 / Introspection

要列出模块导出的符号，首先查询模块支持的导出标记。

To list exported symbols of a module first query the export tags supported by the module.

```Raku
use URI::Escape;
say URI::Escape::EXPORT::.keys;
# OUTPUT: «(DEFAULT ALL)␤»
```

然后使用你喜欢的标记，并按其名称选择符号。

Then use the tag you like and pick the symbol by its name.

```Raku
say URI::Escape::EXPORT::DEFAULT::.keys;
# OUTPUT: «(&uri-escape &uri-unescape &uri_escape &uri_unescape)␤» 
my &escape-uri = URI::Escape::EXPORT::DEFAULT::<&uri_escape>;
```

小心*不要*在 [`unit` declarator](https://docs.raku.org/syntax/unit) 之后加上 `sub EXPORT` 如果你这样做，它将成为你的包内的一个子例程，而不是特殊的导出子例程：

Be careful *not* to put `sub EXPORT` after [`unit` declarator](https://docs.raku.org/syntax/unit). If you do so, it'll become just a sub inside your package, rather than the special export sub:

```Raku
unit module Bar;
sub EXPORT { %(Foo => &say) } # WRONG!!! Sub is scoped wrong 
sub EXPORT { %(Foo => &say) } # RIGHT!!! Sub is outside the module 
unit module Bar;
```

<a id="%E6%9F%A5%E6%89%BE%E5%B7%B2%E5%AE%89%E8%A3%85%E7%9A%84%E6%A8%A1%E5%9D%97--finding-installed-modules"></a>
## 查找已安装的模块 / Finding installed modules

这取决于模块安装程序知道 `compunit` 期望模块放置在哪里。[distribution](https://docs.raku.org/routine/distribution) 将在当前主目录中提供一个位置。无论如何，让模块安装程序处理你的模块是一个安全的选择。

It is up to the module installer to know where `compunit` expects modules to be placed. There will be a location provided by the [distribution](https://docs.raku.org/routine/distribution) and in the current home directory. In any case, letting the module installer deal with your modules is a safe bet.

```Raku
cd your-module-dir
zef --force install .
```

用户可能有一组在正常生态系统中找不到的模块，这些模块由模块或包管理器维护，但定期需要。可以使用 `PERL6LIB` 环境变量来指向模块位置，而不是使用 `use lib` 指令。例如：

A user may have a collection of modules not found in the normal ecosystem, maintained by a module or package manager, but needed regularly. Instead of using the `use lib` pragma one can use the `PERL6LIB` environment variable to point to module locations. For example:

```Raku
export PERL6LIB=/path/to/my-modules,/path/to/more/modules
```

注意，逗号用作目录分隔符。

Note that the comma (',') is used as the directory separator.

在启动 Rakudo 时，将递归地搜索包含路径以查找任何模块。以点开始的目录将被忽略，并遵循符号链接。

The include path will be searched recursively for any modules when Rakudo is started. Directories that start with a dot are ignored and symlinks are followed.

<a id="%E5%8F%91%E5%B8%83%E6%A8%A1%E5%9D%97--distributing-modules"></a>
# 发布模块 / Distributing modules

如果你编写了一个 Raku 模块并希望与社区共享，我们很高兴将它列在 [Raku modules directory](https://modules.perl6.org/) 中。

If you've written a Raku module and would like to share it with the community, we'd be delighted to have it listed in the [Raku modules directory](https://modules.perl6.org/). `:)`

目前有两种不同的模块生态系统（模块分配网络）：

Currently there are two different module ecosystems (module distribution networks) available:

- **CPAN** 这是 Perl 正在使用的一个生态系统。模块被上传为 *.zip* 或 *.tar.gz* 文件到 [PAUSE](https://pause.perl.org/) 上。
- **p6c** 直到最近才成为唯一的生态系统。它基于可直接访问的 Github 存储库。它在版本控制方面的能力有限。

- **CPAN** This is the same ecosystem Perl is using. Modules are uploaded as *.zip* or *.tar.gz* files on [PAUSE](https://pause.perl.org/).
- **p6c** Up until recently the only ecosystem. It is based on Github repositories which are directly accessed. It has only limited capability for versioning.

共享你的模块的过程包括两个步骤：准备模块并将模块上载到一个生态系统。

The process of sharing your module consists of two steps, preparing the module and uploading the module to one of the ecosystems.

<a id="%E5%87%86%E5%A4%87%E6%A8%A1%E5%9D%97--preparing-the-module"></a>
## 准备模块 / Preparing the module

一个模块要在任何一个生态系统中工作，它都需要遵循一定的结构。这样做：

For a module to work in any of the ecosystems, it needs to follow a certain structure. Here is how to do that:

- 创建一个以模块命名的项目目录。例如，如果你的模块是 `Vortex::TotalPerspective`，那么创建一个名为 `Vortex-TotalPerspective` 的项目目录。

- Create a project directory named after your module. For example, if your module is `Vortex::TotalPerspective`, then create a project directory named `Vortex-TotalPerspective`.

- 使项目目录看起来如下：

- Make your project directory look like this:

  ```
  Vortex-TotalPerspective/
  ├── lib
  │   └── Vortex
  │       └── TotalPerspective.pm6
  ├── LICENSE
  ├── META6.json
  ├── README.md
  └── t
      └── basic.t
  ```

如果你的项目包含帮助主模块完成其工作的其他模块，它们应该位于 lib 目录中，如下所示：

If your project contains other modules that help the main module do its job, they should go in your lib directory like so:

  ```
  lib
  └── Vortex
      ├── TotalPerspective.pm6
      └── TotalPerspective
          ├── FairyCake.pm6
          └── Gargravarr.pm6
  ```

- 如果你希望安装任何其他文件（例如模板或动态库），以便在运行时访问它们，则应将它们放在项目的 `resources` 子目录中，例如：

- If you have any additional files (such as templates or a dynamic library) that you wish to have installed so you can access them at runtime, they should be placed in a `resources` sub-directory of your project, e.g.:

  ```
  resources
  └── templates
          └── default-template.mustache
  ```

然后必须在 `META6.json` 中引用该文件（详见下文 `META6.json`），以便向程序提供发布路径。

The file must then be referenced in `META6.json` (see below for more on `META6.json`) so that the distribution path can be provided to the program.

```
{
    "name" : "Vortex::TotalPerspective",
    "provides" : {
        "Vortex::TotalPerspective" : "lib/Vortex/TotalPerspective.pm6"
    },
    "resources": [ "templates/default-template.mustache"]
}
```

然后，可以在模块代码中访问附加文件：

The additional file can then be accessed inside module code:

```
my $template-text = %?RESOURCES<templates/default-template.mustache>.slurp;
# Note that %?RESOURCES provides a C<IO> path object 
```

- `README.md` 文件是一个 [markdown 格式](https://help.github.com/articles/markdown-basics/)的文本文件。它将由 GitHub/GitLab 对保存在这些生态系统中模块自动呈现为 HTML，或者由 [modules.perl6.org](https://modules.perl6.org/) 网站将保存在 [CPAN](https://docs.raku.org/language/faq#index-entry-CPAN_(FAQ)) 上的模块自动呈现为HTML。

- The `README.md` file is a [markdown-formatted](https://help.github.com/articles/markdown-basics/) text file, which will later be automatically rendered as HTML by GitHub/GitLab for modules kept in those ecosystems or by [modules.perl6.org](https://modules.perl6.org/) website for modules kept on [CPAN](https://docs.raku.org/language/faq#index-entry-CPAN_(FAQ)).

- 关于 `LICENSE` 文件，如果你没有其他偏好，可以用 Rakudo Raku 使用的文件。只需将[其 license](https://github.com/rakudo/rakudo/blob/master/LICENSE) 的原始形式复制/粘贴到你自己的 `LICENSE` 文件中即可。

- Regarding the `LICENSE` file, if you have no other preference, you might just use the same one that Rakudo Raku uses. Just copy/paste the raw form of [its license](https://github.com/rakudo/rakudo/blob/master/LICENSE) into your own `LICENSE` file.

- META6.json 中的许可字段应该是此处列出的标准化名称之一：<https://spdx.org/licenses/>。在我们的许多生态系统模块使用的 **Artistic 2.0** 许可证的情况下，它的标识符是 `Artistic-2.0`。有了标准化的标识符，人类和计算机都可以很容易地通过查看元数据来了解实际使用的许可证！

- The license field in META6.json should be one of the standardized names listed here: <https://spdx.org/licenses/>. In the case of the **Artistic 2.0** license, which is what many of our ecosystem modules use, its identifier is `Artistic-2.0`. Having standardized identifiers make it easy for humans and computers alike to know which license was actually used by looking at the metadata!

- 如果你无法在 `spdx.org` 上找到你的许可证，或者使用你自己的许可证，你应该将许可证的名称放在许可字段中。有关更多细节，请参见。

- If you can't find your license on `spdx.org` or you use your own license, you should put the license's name in the license field. For more details see <https://design.perl6.org/S22.html#license>.

- 如果你尚未进行任何测试，则可以暂时省略 `t` 目录和 `basic.t` 文件。有关如何编写测试的更多信息（目前而言），你可以查看其他模块是如何使用 `Test` 的。

- If you don't yet have any tests, you can leave out the `t` directory and `basic.t` file for now. For more information on how to write tests (for now), you might have a look at how other modules use `Test`.

- 要记录你的模块，请在其中使用 [Raku Pod](https://docs.raku.org/language/pod) 标记。模块文档最重要，一旦 Raku 模块目录（或某个其他站点）开始将 POD 文档呈现为 HTML 以方便浏览，这将是特别重要的。如果你有额外的文档（除了模块中的 Pod 文档外），请为其创建一个 `doc` 目录。按照与 `lib` 目录相同的文件夹结构如下：

- To document your modules, use [Raku Pod](https://docs.raku.org/language/pod) markup inside them. Module documentation is most appreciated and will be especially important once the Raku module directory (or some other site) begins rendering Pod docs as HTML for easy browsing. If you have extra docs (in addition to the Pod docs in your module(s)), create a `doc` directory for them. Follow the same folder structure as the `lib` directory like so:

```
doc
└── Vortex
    └── TotalPerspective.pod6
```

[[5]](https://docs.raku.org/language/modules#fn-5)

如果你的模块在安装过程中需要额外的处理才能与非 Raku 操作系统资源完全集成和使用，则可能需要将 `Build.pm6` 文件（一个 “build 钩子”）添加到顶层目录中。它将作为安装过程中的第一步被 `zef` 安装程序使用。关于一个简短的例子，请参见自述文件中的 `zef`。还可以在现有的生态系统模块中看到各种使用情景，如 `zef` 本身。

If your module requires extra processing during installation to fully integrate with and use non-Raku operating system resources, you may need to add a `Build.pm6` file (a "build hook") to the top-level directory. It will be used by the `zef` installer as the first step in the installation process. See the README for `zef` for a brief example. Also see various usage scenarios in existing ecosystem modules such as `zef` itself.

- Make your `META6.json` file look something like this:

```Raku
{
    "perl" : "6.c",
    "name" : "Vortex::TotalPerspective",
    "api"  : "1",
    "auth" : "github:SomeAuthor",
    "version" : "0.0.1",
    "description" : "Wonderful simulation to get some perspective.",
    "authors" : [ "Your Name" ],
    "license" : "Artistic-2.0",
    "provides" : {
        "Vortex::TotalPerspective" : "lib/Vortex/TotalPerspective.pm6"
    },
    "depends" : [ ],
    "build-depends" : [ ],
    "test-depends" : [ ],
    "resources" : [ ],
    "tags": [
      "Vortex", "Total", "Perspective"
    ],
    "source-url" : "git://github.com/you/Vortex-TotalPerspective.git"
}
```

该文件中的属性由 [`META6`](https://github.com/jonathanstowe/META6) 类分析。属性类别分为可选、必须和*客制*属性。必须项是你需要插入到你的文件的，定制是那些当前 Raku 生态系统使用的，并可能显示在模块页面，如果它已经发布，但你可以不用使用它。

The attributes in this file are analyzed by the [`META6`](https://github.com/jonathanstowe/META6) class. They are divided into optional, mandatory and *customary*. Mandatory are the ones you need to insert into your file, and customary are those used by the current Raku ecosystem and possibly displayed on the module page if it's published, but you have no obligation to use it.

要选择版本编号方案，请尝试并使用 "major.minor.patch" 的方式（请参见[关于版本控制的规范](https://design.perl6.org/S11.html#Versioning)以了解更多详细信息）。这与 `META6.json` 文件中的 `version` 键有关。这个字段是可选的，如果这个字段存在，会被安装程序用来匹配已安装的版本。 文件中 `description` 字段是必须的，包括模组的一小段描述。

For choosing a version numbering scheme, try and use "major.minor.patch" (see [the spec on versioning](https://design.perl6.org/S11.html#Versioning) for further details). This will go into the `version` key of `META6.json`. This field is optional, but used by installation to match against installed version, if one exists. The `description` field is also mandatory, and includes a short description of the module.

`name` 键是必须的，如果不包括它，则 `zef` 将失败。即使你只创建了一个 META6.json 文件来表示一系列脚本的依赖项，也必须包括本节。

The `name` key is compulsory, and `zef` will fail if you do not include it. Even if you have created a META6.json file just to express the dependencies for a series of scripts, this section must be included.

可选地，可以设置一个 `api` 字段。递增该值指示你的模块提供的接口与上一版本不向下兼容。如果要坚持[语义版本控制](https://semver.org/)，可以使用它。最佳做法是简单地将 `api` 字段保持为与主版本号相同的值。然后，依赖关系可以通过包括 `:api` 部分来依赖你的模块，这将确保不会将向后不兼容的版本拉入。

Optionally, you can set an `api` field. Incrementing this indicates that the interface provided by your module is not backwards compatible with a previous version. You can use it if you want to adhere to [Semantic Versioning](https://semver.org/). A best practice is to simply keep the `api` field to the same value as your major version number. A dependency can then depend on your module by including a `:api` part, which will ensure backwards incompatible releases will not be pulled in.

`auth` 部分将作者标识为 Github 或其他存储库托管站点，如 BitBucket 或 GitLab。此字段为*客制化*的，因为它用于标识生态系统中的作者，使具有相同名称但不同作者的模块变得可能。

The `auth` section identifies the author in GitHub or other repository hosting site, such as Bitbucket or GitLab. This field is *customary*, since it's used to identify the author in the ecosystem, and opens the possibility of having modules with the same name and different authors.

`authors` 部分包括所有模块作者的名单。在只有一个作者的情况下，必须提供一个单元素列表。此字段是可选的。

The `authors` section includes a list of all the module authors. In the case there is only one author, a single element list must be supplied. This field is optional.

在 `provides` 一节中，包含发行版提供的所有名称空间和你希望安装的名称空间；只有此处明确包含的模块文件才能在其他程序中安装和使用。这个字段是强制性的。

In the `provides` section, include all the namespaces provided by your distribution and that you wish to be installed; only module files that are explicitly included here will be installed and available with `use` or `require` in other programs. This field is mandatory.

`perl` 键设置为模块使用的最低 Raku 版本。这个字段是强制性的。如果你的模块对圣诞节版本有效，请使用 `6.c`，如果你的模块需要排灯节版本，请使用 `6.d`。

Set `perl` version to the minimum perl version your module works with. This field is mandatory. Use `6.c` if your module is valid for Christmas release and newer ones, use `6.d` if it requires, at least, the Diwali version.

`resources` 部分是可选的，但如果存在，则应该包含希望安装的 `resources` 目录中的文件列表。这些文件将在库文件旁边安装散列名称。它们的安装位置可以通过提供的名称上的 `%?RESOURCES` `Hash` 索引来确定。`tags` 部分也是可选的。它用于描述 Raku 生态系统中的模块。

The `resources` section is optional, but, if present, should contain a list of the files in your `resources` directory that you wish to be installed. These will be installed with hashed names alongside your library files. Their installed location can be determined through the `%?RESOURCES` `Hash` indexed on the name provided. The `tags` section is also optional. It is used to describe the module in the Raku ecosystem.

`depends`、`build-depends` 和 `test-depends` 部分包括在安装的这些阶段中使用的不同模块。所有都是可选的，但它们显然必须包含在这些特定阶段中需要的模块。这些依赖关系可能使用 [`Version`](https://docs.raku.org/type/Version) 规范字符串；`zef` 将检查这些模块的存在和版本，并在需要时安装或升级这些模块。

The `depends`, `build-depends`, and `test-depends` sections include different modules that are used in those phases of the of installation. All are optional, but they must obviously contain the modules that are going to be needed in those particular phases. These dependencies might optionally use [`Version`](https://docs.raku.org/type/Version) specification strings; `zef` will check for the presence and versions of these modules and install or upgrade them if needed.

```
//...
"depends": [
       "URI",
       "File::Temp",
       "JSON::Fast",
       "Pod::To::BigPage:ver<0.5.0+>",
       "Pod::To::HTML:ver<0.6.1+>",
       "OO::Monitors",
       "File::Find",
       "Test::META"
],
//...
```

此外，`depends` 可以是上面的数组，也可以是使用 `runtime` 和 `build` 两个键的散列，它们的函数应该是自描述的，并且是使用的，例如在 [`Inline::Python`](https://github.com/niner/Inline-Python/blob/master/META6.json) 中。

Additionally, `depends` can be either an array as above or a hash that uses two keys, `runtime` and `build`, whose function should be self-descriptive, and which are used, for instance, [in `Inline::Python`](https://github.com/niner/Inline-Python/blob/master/META6.json):

```
//...
"depends" : {
        "build": {
            "requires": [
                "Distribution::Builder::MakeFromJSON",
                {
                    "from" : "bin",
                    "name" : {
                        "by-distro.name" : {
                            "macosx" : "python2.7-config",
                            "debian" : "python2.7-config",
                            "" : "python2-config"
                        }
                    }
                }
            ]
        },
        "runtime": {
            "requires": [
                "python2.7:from<native>"
            ]
        }
}, // ...
```

一般来说，数组表单在大多数情况下都是足够的。

In general, the array form will be more than enough for most cases.

最后，`source-url` 表示开发该模块的存储库的 URL；如果要在模块生态系统中发布它，这是通常的模块之一。当前模块生态系统将从项目描述链接此 URL。[[6]](https://docs.raku.org/language/modules#fn-6)

Finally, `source-url` indicates the URL of the repository where the module is developed; this is one of the customary modules if you are going to publish it in the module ecosystem. The current module ecosystem will link this URL from the project description. [[6]](https://docs.raku.org/language/modules#fn-6)

[`Test::META` 模组](https://github.com/jonathanstowe/Test-META/)可以帮助你检查 META6.json 文件的正确性；这个模块将检查所有的强制字段，并且检查所有这些字段使用的类型都是正确的。

The [`Test::META` module](https://github.com/jonathanstowe/Test-META/) can help you check the correctness of the META6.json file; this module will check for all the mandatory fields and that the type used for all of them is correct.

在[ `META` 设计文档](https://design.perl6.org/S22.html#META6.json)中有更多的字段描述，但并不是所有这些字段都是由现有的包管理器实现的。因此，你应该坚持以上示例块中描述的字段，以确保与现有包管理器（如 `zef`）的兼容性。例如你还可以查看 [Moritz Lenz 所有模组存储库](https://github.com/moritz/perl6-all-modules/search?l=JSON&q=META6.json&type=)，但是请记住，它们中的一些可能使用字段，例如上面的 `source-type`，这些字段目前被忽略了。

There are more fields described in the [`META` design documents](https://design.perl6.org/S22.html#META6.json), but not all of these are implemented by existing package managers. Hence you should stick to the fields described in the above example block to ensure compatibility with existing package managers such as `zef`. You can also check [Moritz Lenz's repository of all modules for examples](https://github.com/moritz/perl6-all-modules/search?l=JSON&q=META6.json&type=), but bear in mind that some of them might use fields, such as `source-type` above, which are currently ignored.

- 如果你想要测试你的模块，可以使用以下命令直接从刚才创建的模块文件夹安装模块。

- If you want to test your module you can use the following command to install the module directly from the module folder you just created.

```
zef install ./your-module-folder
```

请注意，这样做可以预编译和安装你的模块。如果对源代码进行更改，则需要重新安装模块。（请参阅 `use lib` 指令、`-I` 命令行开关或 `PERL6LIB` 环境变量，以便在开发模块源时包含到模块源的路径，这样你就不必安装它）。

Note that doing so precompiles and installs your module. If you make changes to the source, you'll need to re-install the module. (See `use lib` pragma, `-I` command line switch, or `PERL6LIB` env variable, to include a path to your module source while developing it, so you don't have to install it at all).

<a id="%E5%B0%86%E6%A8%A1%E5%9D%97%E4%B8%8A%E4%BC%A0%E5%88%B0-cpan--upload-your-module-to-cpan"></a>
## 将模块上传到 CPAN / Upload your module to CPAN

将模块上传到 CPAN 是分发 Raku 模块的首选方式。

Uploading a module to CPAN is the preferred way of distributing Raku modules.

一个先决条件是 [PAUSE](https://pause.perl.org/) 用户帐户。如果你还没有一个帐户，你可以[在这里](https://pause.perl.org/pause/query?ACTION=request_id)创建一个。过程大约需要 5 分钟，一些电子邮件来回。

A prerequisite for this is a [PAUSE](https://pause.perl.org/) user account. If you don't have an account already, you can create one [here](https://pause.perl.org/pause/query?ACTION=request_id). The process takes about 5 minutes and some e-mail back and forth.

- 创建一个模块包：

- Create a package of your module:

```
cd your-module-folder
tar czf Vortex-TotalPerspective-0.0.1.tar.gz \
  --transform s/^\./Vortex-TotalPerspective-0.0.1/ --exclude-vcs\
  --exclude=.[^/]*
```

如果使用 git，还可以使用以下命令直接为给定提交创建包。

If you use git you can also use the following command to create a package directly for a given commit.

```
git archive --prefix=Vortex-TotalPerspective-0.0.1/ \
  -o ../Vortex-TotalPerspective-0.0.1.tar.gz HEAD
```

- 转到 [PAUSE](https://pause.perl.org/)，登录并导航到 `Upload a file to CPAN`。

- Go to [PAUSE](https://pause.perl.org/), log in and navigate to `Upload a file to CPAN`.

- 确保选择 `Perl6` 作为*目标目录*。在第一次上传时，你必须在文本字段中输入字符串 `Perl6`。在随后的上传中，你可以在输入字段下面的选择框中选择 `Perl6` 目录。

- Make sure you select `Perl6` as the *Target Directory*. For your first upload, you have to enter the string `Perl6` in the text field. On subsequent uploads, you can select the `Perl6` directory from the selection box right below the input field.

- 选择你的文件并单击 *Upload*！如果你的Dist没有问题，你应该看到你的 `Perl6` 目录中的模块 tar 文件以及以模块文件名命名的 `META` 和 `README` 文件。

- Select your file and click *Upload*! If everything was fine with your dist, you should see your module tar file in your `Perl6` directory along with both a `META` and a `README` file named after your module filename.

*确保你的分发文件中有一个 META6.json 文件，并且你要上传的分发版本高于当前上传的版本。这些是最常见的上传错误*。

*Make sure you have a META6.json file in your dist and that the dist version you're uploading is higher than the currently uploaded version. Those are the most common upload errors.*

<a id="%E5%B0%86%E6%A8%A1%E5%9D%97%E4%B8%8A%E4%BC%A0%E5%88%B0-p6c--upload-your-module-to-p6c"></a>
## 将模块上传到 p6c / Upload your module to p6c

如果要使用 *p6c* 生态系统，则需要使用 git 做为你的模块的版本控制。此处的说明假定你有一个 [GitHub](https://github.com/) 帐户，以便你的模块可以从其 GigThub 存储库中共享，但是，其他的供应商如 [GitLab](https://about.gitlab.com/) 也可以，只要它以类似的方式运作。

If you want to use the *p6c* ecosystem you need to use git for your module's version control. The instructions herein assume that you have a [GitHub](https://github.com/) account so that your module can be shared from its GitHub repository, however another provider such as [GitLab](https://about.gitlab.com/) should work as long as it works in a similar way.

- 如果你尚未完成，请将项目置于 Git 版本控制之下。
- 一旦你对你的项目感到满意，就在 GitHub 上为它创建一个存储库。如有必要，参见 [GitHub 的帮助文档](https://help.github.com/)。你的 GitHub 存储库应该与你的项目目录命名相同。在创建 GitHub 存储库之后，GitHub 将向你展示如何配置本地存储库以了解 GitHub 存储库。
- 把你的项目推到 GitHub。
- 考虑建立自动测试（参考 <https://docs.travis-ci.com/user/languages/perl6>）。
- 在[生态系统](https://github.com/perl6/ecosystem)上创建 PR，将你的模块添加到 META.list 中，或在 IRC（Freenode 的 #Raku）上 ping 某个人，以获得帮助。
- pull 请求被接受后，等待一小时。如果你的模块在 <https://modules.raku.org/> 中未出现，请查看日志文件，看看它是否标识了你的模块或 `meta` 文件的错误。

- Put your project under git version control if you haven't done so already.
- Once you're happy with your project, create a repository for it on GitHub. See [GitHub's help docs](https://help.github.com/) if necessary. Your GitHub repository should be named the same as your project directory. Immediately after creating the GitHub repo, GitHub shows you how to configure your local repository to know about your GitHub repository.
- Push your project to GitHub.
- Consider setting up automated testing (see <https://docs.travis-ci.com/user/languages/perl6>).
- Create a PR on [ecosystem](https://github.com/perl6/ecosystem) adding your module to META.list, or ping someone on IRC (#perl6 at freenode) to get help having it added.
- After the pull request has been accepted, wait for an hour. If your module doesn't show up on <https://modules.perl6.org/>, please view the log file at <https://modules.perl6.org/update.log> to see if it identifies an error with your module or `meta` file.

**就这样!感谢您对 Raku 社区的贡献！**

**That's it! Thanks for contributing to the Raku community!**

如果您想尝试安装模块，请使用 Rakudo Star Raku 附带的 zef 模块安装程序工具：

If you'd like to try out installing your module, use the zef module installer tool which is included with Rakudo Star Raku:

```Raku
zef install Vortex::TotalPerspective
```

这将下载您的模块到它自己的工作目录（`~/.zef`），在那里构建它，并将该模块安装到您的本地 Raku 安装目录中。

This will download your module to its own working directory (`~/.zef`), build it there, and install the module into your local Raku installation directory.

要从脚本中使用 `Vortex::TotalPerspective`，只需编写 `use Vortex::TotalPerspective`，您的 Raku 实现将知道在何处查找模块文件。

To use `Vortex::TotalPerspective` from your scripts, just write `use Vortex::TotalPerspective`, and your Raku implementation will know where to look for the module file(s).

<a id="%E4%B8%8E%E6%A8%A1%E5%9D%97%E5%88%9B%E4%BD%9C%E7%9B%B8%E5%85%B3%E7%9A%84%E6%A8%A1%E5%9D%97%E5%92%8C%E5%B7%A5%E5%85%B7--modules-and-tools-related-to-module-authoring"></a>
# 与模块创作相关的模块和工具 / Modules and tools related to module authoring

您可以在[额外模组](https://docs.raku.org/language/modules-extra)]中找到旨在提高编写/测试模块经验的模块和工具列表。

You can find a list of modules and tools that aim to improve the experience of writing/test modules at [Modules Extra](https://docs.raku.org/language/modules-extra)

<a id="%E8%81%94%E7%B3%BB%E4%BF%A1%E6%81%AF--contact-information"></a>
## 联系信息 / Contact information

要讨论一般的模块开发，或者如果您的模块能够满足生态系统、命名等方面的需求，您可以使用 [irc.freenode.net 的 perl6](irc://irc.freenode.net/#perl6) IRC 频道。

To discuss module development in general, or if your module would fill a need in the ecosystem, naming, etc., you can use the [perl6 on irc.freenode.net](irc://irc.freenode.net/#perl6) IRC channel.

要讨论工具链特定的问题，您可以使用在 [irc.freenode.net 上的 perl6-toolchain](irc://irc.freenode.net/#perl6-toolchain) IRC 频道。还提供了一个讨论工具问题的存储库 <https://github.com/perl6/toolchain-bikeshed>。

To discuss toolchain specific questions, you can use the [perl6-toolchain on irc.freenode.net](irc://irc.freenode.net/#perl6-toolchain) IRC channel. A repository to discuss tooling issues is also available at <https://github.com/perl6/toolchain-bikeshed>.

1. [[↑]](https://docs.raku.org/language/modules#fn-ref-1) 技术上，一个模块是一组*编译单元*，它们通常是文件，只要有一个可以提供*编译单元的存储库*，就可以从任何地方来。参见 [S11](https://design.raku.org/S11.html)。
2. [[↑]](https://docs.raku.org/language/modules#fn-ref-2) 如果模组安装了，只有当模块的版本比已安装的版本更新时，它才会重新安装。
3. [[↑]](https://docs.raku.org/language/modules#fn-ref-3) 如[概要 S11](https://design.raku.org/S11.html#Units) 所说：混淆？是的。
4. [[↑]](https://docs.raku.org/language/modules#fn-ref-4) 这一变化是在 2016 年末引入的。如果使用的版本早于此，则行为将不同。
5. [[↑]](https://docs.raku.org/language/modules#fn-ref-5) 注意，上面描述的是一个最小的项目目录。如果项目包含要与模块一起分发的脚本，请将它们放在 `bin` 目录中。如果您希望在模块目录下的模块旁边显示图形徽标，请创建 `logotype` 目录并将 `logo_32x32.png` 文件放入其中。在某些情况下，您还可以考虑添加 `CONTRIBUTORS`、`NEWS`、`TODO` 或其他文件。
6. [[↑]](https://docs.raku.org/language/modules#fn-ref-6) 一些旧的模块还提供了一个 `source-type` 字段，用于指示源代码管理系统的类型，通常是 `git`，该字段可用于下载模块。然而，这个领域现在被 `zef` 和其他工具所忽略。

1. [[↑]](https://docs.raku.org/language/modules#fn-ref-1) Technically a module is a set of *compunits* which are usually files but could come from anywhere as long as there is a *compunit repository* that can provide it. See [S11](https://design.raku.org/S11.html).
2. [[↑]](https://docs.raku.org/language/modules#fn-ref-2) If it's installed, it will reinstall only if the version of the module is newer than the one installed
3. [[↑]](https://docs.raku.org/language/modules#fn-ref-3) As [synopsis S11](https://design.perl6.org/S11.html#Units) says: Confusing? Yes it is.
4. [[↑]](https://docs.raku.org/language/modules#fn-ref-4) This change was introduced in late 2016. If you are using versions older than this, behavior will be different.
5. [[↑]](https://docs.raku.org/language/modules#fn-ref-5) Note, described above is a minimal project directory. If your project contains scripts that you'd like distributed along with your module(s), put them in a `bin` directory. If you'd like a graphical logo to appear next to your module at the module directory, create a `logotype` directory and put into it a `logo_32x32.png` file. At some point, you might also consider adding `CONTRIBUTORS`, `NEWS`, `TODO`, or other files.
6. [[↑]](https://docs.raku.org/language/modules#fn-ref-6) Some old modules also provide a `source-type` field, which was used to indicate the kind of source control system, generally `git`, which can be used to download the module. However, this field is nowadays ignored by `zef` and the rest of the tools.
