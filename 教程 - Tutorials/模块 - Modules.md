原文：https://docs.raku.org/language/modules

# 模块 / Modules

如何创建、使用和分发 Raku 模块

How to create, use, and distribute Raku modules

# 创建和使用模块 / Creating and using modules

模块通常是一个或一组揭露 Raku 构造的源文件。

A module is usually a source file or set of source files that expose Raku constructs.

[[1]](https://docs.raku.org/language/modules#fn-1)

模块通常是软件包（[类](https://docs.raku.org/language/objects#Classes)、[角色](https://docs.raku.org/language/objects#Roles)、[语法](https://docs.raku.org/type/Grammar)）、[子例程](https://docs.raku.org/language/functions)，有时是[变量](https://docs.raku.org/language/variables)。在 Raku *模块*中，还可以引用使用 `module` 关键字声明的包的类型（请参见[模块包](https://docs.raku.org/language/module-packages)和下面的示例），但此处我们主要指的是作为命名空间中的一组源文件的"模块"。

Modules are typically packages ([classes](https://docs.raku.org/language/objects#Classes), [roles](https://docs.raku.org/language/objects#Roles), [grammars](https://docs.raku.org/type/Grammar)), [subroutines](https://docs.raku.org/language/functions), and sometimes [variables](https://docs.raku.org/language/variables). In Raku *module* can also refer to a type of package declared with the `module` keyword (see [Module Packages](https://docs.raku.org/language/module-packages) and the examples below) but here we mostly mean "module" as a set of source files in a namespace.

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

## 基本结构 / Basic structure

Raku 中的模块分布（在*关联源码文件集合*的意义上）具有与 Perl 族语言中的任何分布相同的结构：存在一个主项目目录，包含一个 `README` 和一个 `LICENSE` 文件，用于源文件的“lib”目录，这些文件可以单独地称为模块和/或可以自己定义带有 `module` 关键字的模块 [[3]](https://docs.raku.org/language/modules#fn-3)，用于测试的 `t` 目录，以及可执行文件和脚本的 `bin` 目录。

Module distributions (in the *set of related source files* sense) in Raku have the same structure as any distribution in the Perl family of languages: there is a main project directory containing a `README` and a `LICENSE` file, a `lib` directory for the source files, which may be individually referred to as modules and/or may themselves define modules with the `module` keyword [[3]](https://docs.raku.org/language/modules#fn-3) , a `t` directory for tests, and possibly a `bin` directory for executable programs and scripts.

源文件通常使用 `.pm6` 扩展名，脚本或可执行文件使用 `.p6`。测试文件使用 `.t` 扩展名。包含文档的文件使用 `.pod6` 扩展名。

Source files generally use the `.pm6` extension, and scripts or executables use the `.p6`. Test files use the `.t` extension. Files which contain documentation use the `.pod6` extension.

# 加载与基本引入 / Loading and basic importing

加载模块使在加载程序的文件范围内声明的相同命名空间中的包可用。从模块导入使导出的符号在导入语句的词法范围中可用。

Loading a module makes the packages in the same namespace declared within available in the file scope of the loader. Importing from a module makes the symbols exported available in the lexical scope of the importing statement.

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

`MyModule::Class` 将在加载 `MyModule` 时定义，您可以直接使用它的完全限定名（FQN）使用它。通过这种方式定义的类和其他类型不会自动导出；如果要使用它的短名称，则需要显式导出它：

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

## `use`

`use` 在编译时从计算单元加载并导入。它将查找以 `.pm6` 结尾的文件（`.pm`也受支持，但不受鼓励）。运行时将在哪里查找模块，请看[这](https://docs.raku.org/language/modules#Finding_installed_modules)。

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

还请参阅[选择性导入](https://docs.raku.org/language/modules#Exporting_and_selective_importing)以限制您导入的内容。

See also [selective importing](https://docs.raku.org/language/modules#Exporting_and_selective_importing) to restrict what you import.

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

加载模块提供的符号不会导入当前范围。例如，您可以用[动态查看](https://docs.raku.org/language/packages#index-entry-::()) 或 [动态子集](https://docs.raku.org/language/typesystem#subset)来使用它们，通过提供符号的完全限定名：

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

## 词法模块加载 / Lexical module loading

Raku 非常注意避免全局状态，即无论您在模块中做什么，它都不应该影响其他代码。例如，这就是为什么默认情况下子例程定义在词法 （`my`）作用域内。如果您希望其他人看到它们，则需要明确地使它们 `our` 作用域或导出它们。

Raku takes great care to avoid global state, i.e. whatever you do in your module, it should not affect other code. For instance, that's why subroutine definitions are lexically (`my`) scoped by default. If you want others to see them, you need to explicitly make them `our` scoped or export them.

默认情况下类是导出的。它基于这样一种假设，当无法访问模块包含的类时，加载模块不会有多大用处。因此，加载的类只在首先加载它们的作用域 [[4]](https://docs.raku.org/language/modules#fn-4) 中注册。这意味着我们必须在实际使用它的每一个范围中 `use` 一个类。

Classes are exported by default on the assumption that loading a module will not be of much use when you cannot access the classes it contains. Loaded classes are thus registered only in the scope which loaded them in the first place [[4]](https://docs.raku.org/language/modules#fn-4). This means that we will have to `use` a class in every scope in which we actually employ it.

```Raku
use Foo;           # Foo has "use Bar" somewhere. 
use Bar;
my $foo = Foo.new;
my $bar = Bar.new;
```

## 导出和选择性导入 / Exporting and selective importing

### is export

包、子例程、变量、常量和枚举是通过使用 [is export](https://docs.raku.org/routine/is%20export) 特性来导出的（还请注意用于指示作者和版本的标记）。

Packages, subroutines, variables, constants, and enums are exported by marking them with the [is export](https://docs.raku.org/routine/is%20export) trait (also note the tags available for indicating authors and versions).

```Raku
unit module MyModule:ver<1.0.3>:auth<John Hancock (jhancock@example.com)>;
our $var is export = 3;
sub foo is export { ... };
constant FOO is export = "foobar";
enum FooBar is export <one two three>;

# 对于 multi 方法，如果声明 proto，只需要标记用 is proto
# for multi methods, if you declare a proto you 
# only need to mark the proto with is export 
proto sub quux(Str $x, |) is export { * };
multi sub quux(Str $x) { ... };
multi sub quux(Str $x, $y) { ... };
 
# for multi methods, you only need to mark one with is export 
# but the code is most consistent if all are marked 
multi sub quux(Str $x) is export { ... };
multi sub quux(Str $x, $y) is export { ... };
 
# Packages like classes can be exported too 
class MyClass is export {};
 
# If a subpackage is in the namespace of the current package 
# it doesn't need to be explicitly exported 
class MyModule::MyClass {};
```

As with all traits, if applied to a routine, `is export` should appear after any argument list.

```Raku
sub foo(Str $string) is export { ... }
```

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

**Note**: there currently is no way for the user to import a single object if the module author hasn't made provision for that, and it is not an easy task at the moment (see [RT #127305](https://rt.perl.org/Public/Bug/Display.html?id=127305)). One way the author can provide such access is to give each `export` trait its own unique tag. (And the tag can be the object name!). Then the user can either (1) import all objects:

```Raku
use Foo :ALL;
```

or (2) import one or more objects selectively:

```Raku
use Foo :bar, :s5;
```

Notes:

\1. The `:MANDATORY` tag on an exported sub ensures it will be exported no matter whether the using program adds any tag or not.

\2. All exported subs without an explicit tag are implicitly `:DEFAULT`.

\3. The space after the module name and before the tag is mandatory.

\4. Multiple import tags may be used (separated by commas). For example:

```Raku
# main.p6 
use lib 'lib';
use MyModule :day, :night; # pants, sunglasses, torch 
```

\5. Multiple tags may be used in the `export` trait, but they must all be separated by either commas, or whitespace, but not both.

```Raku
sub foo() is export(:foo :s2 :net) {}
sub bar() is export(:bar, :s3, :some) {}
```

### UNIT::EXPORT::*

Beneath the surface, `is export` is adding the symbols to a `UNIT` scoped package in the `EXPORT` namespace. For example, `is export(:FOO)` will add the target to the `UNIT::EXPORT::FOO` package. This is what Raku is really using to decide what to import.

```Raku
unit module MyModule;
 
sub foo is export { ... }
sub bar is export(:other) { ... }
```

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

### EXPORT 

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

Note, `EXPORT` can't be declared inside a package because it is part of the compunit rather than the package.

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

## Introspection

To list exported symbols of a module first query the export tags supported by the module.

```Raku
use URI::Escape;
say URI::Escape::EXPORT::.keys;
# OUTPUT: «(DEFAULT ALL)␤»
```

Then use the tag you like and pick the symbol by its name.

```Raku
say URI::Escape::EXPORT::DEFAULT::.keys;
# OUTPUT: «(&uri-escape &uri-unescape &uri_escape &uri_unescape)␤» 
my &escape-uri = URI::Escape::EXPORT::DEFAULT::<&uri_escape>;
```

Be careful *not* to put `sub EXPORT` after [`unit` declarator](https://docs.raku.org/syntax/unit). If you do so, it'll become just a sub inside your package, rather than the special export sub:

```Raku
unit module Bar;
sub EXPORT { %(Foo => &say) } # WRONG!!! Sub is scoped wrong 
sub EXPORT { %(Foo => &say) } # RIGHT!!! Sub is outside the module 
unit module Bar;
```

## Finding installed modules

It is up to the module installer to know where `compunit` expects modules to be placed. There will be a location provided by the [distribution](https://docs.raku.org/routine/distribution) and in the current home directory. In any case, letting the module installer deal with your modules is a safe bet.

```Raku
cd your-module-dir
zef --force install .
```

A user may have a collection of modules not found in the normal ecosystem, maintained by a module or package manager, but needed regularly. Instead of using the `use lib` pragma one can use the `PERL6LIB` environment variable to point to module locations. For example:

```Raku
export PERL6LIB=/path/to/my-modules,/path/to/more/modules
```

Note that the comma (',') is used as the directory separator.

The include path will be searched recursively for any modules when Rakudo is started. Directories that start with a dot are ignored and symlinks are followed.

# Distributing modules

If you've written a Raku module and would like to share it with the community, we'd be delighted to have it listed in the [Raku modules directory](https://modules.perl6.org/). `:)`

Currently there are two different module ecosystems (module distribution networks) available:

- **CPAN** This is the same ecosystem Perl5 is using. Modules are uploaded as *.zip* or *.tar.gz* files on [PAUSE](https://pause.perl.org/).
- **p6c** Up until recently the only ecosystem. It is based on Github repositories which are directly accessed. It has only limited capability for versioning.

The process of sharing your module consists of two steps, preparing the module and uploading the module to one of the ecosystems.

## Preparing the module

For a module to work in any of the ecosystems, it needs to follow a certain structure. Here is how to do that:

- Create a project directory named after your module. For example, if your module is `Vortex::TotalPerspective`, then create a project directory named `Vortex-TotalPerspective`.

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

  If your project contains other modules that help the main module do its job, they should go in your lib directory like so:

  ```
  lib
  └── Vortex
      ├── TotalPerspective.pm6
      └── TotalPerspective
          ├── FairyCake.pm6
          └── Gargravarr.pm6
  ```

- If you have any additional files (such as templates or a dynamic library) that you wish to have installed so you can access them at runtime, they should be placed in a `resources` sub-directory of your project, e.g.:

  ```
  resources
  └── templates
          └── default-template.mustache
  ```

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

  The additional file can then be accessed inside module code:

  ```
  my $template-text = %?RESOURCES<templates/default-template.mustache>.slurp;
  # Note that %?RESOURCES provides a C<IO> path object 
  ```

- The `README.md` file is a [markdown-formatted](https://help.github.com/articles/markdown-basics/) text file, which will later be automatically rendered as HTML by GitHub/GitLab for modules kept in those ecosystems or by [modules.perl6.org](https://modules.perl6.org/) website for modules kept on [CPAN](https://docs.raku.org/language/faq#index-entry-CPAN_(FAQ)).

- Regarding the `LICENSE` file, if you have no other preference, you might just use the same one that Rakudo Raku uses. Just copy/paste the raw form of [its license](https://github.com/rakudo/rakudo/blob/master/LICENSE) into your own `LICENSE` file.

- The license field in META6.json should be one of the standardized names listed here: <https://spdx.org/licenses/>. In the case of the **Artistic 2.0** license, which is what many of our ecosystem modules use, its identifier is `Artistic-2.0`. Having standardized identifiers make it easy for humans and computers alike to know which license was actually used by looking at the metadata!

- If you can't find your license on `spdx.org` or you use your own license, you should put the license's name in the license field. For more details see <https://design.perl6.org/S22.html#license>.

- If you don't yet have any tests, you can leave out the `t` directory and `basic.t` file for now. For more information on how to write tests (for now), you might have a look at how other modules use `Test`.

- To document your modules, use [Raku Pod](https://docs.raku.org/language/pod) markup inside them. Module documentation is most appreciated and will be especially important once the Raku module directory (or some other site) begins rendering Pod docs as HTML for easy browsing. If you have extra docs (in addition to the Pod docs in your module(s)), create a `doc` directory for them. Follow the same folder structure as the `lib` directory like so:

  ```
  doc
  └── Vortex
      └── TotalPerspective.pod6
  ```

  [[5\]](https://docs.raku.org/language/modules#fn-5)

  If your module requires extra processing during installation to fully integrate with and use non-Perl operating system resources, you may need to add a `Build.pm6` file (a "build hook") to the top-level directory. It will be used by the `zef` installer as the first step in the installation process. See the README for `zef` for a brief example. Also see various usage scenarios in existing ecosystem modules such as `zef` itself.

- Make your `META6.json` file look something like this:

  ```
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

  The attributes in this file are analyzed by the [`META6`](https://github.com/jonathanstowe/META6) class. They are divided into optional, mandatory and *customary*. Mandatory are the ones you need to insert into your file, and customary are those used by the current Raku ecosystem and possibly displayed on the module page if it's published, but you have no obligation to use it.

  For choosing a version numbering scheme, try and use "major.minor.patch" (see [the spec on versioning](https://design.perl6.org/S11.html#Versioning) for further details). This will go into the `version` key of `META6.json`. This field is optional, but used by installation to match against installed version, if one exists. The `description` field is also mandatory, and includes a short description of the module.

  The `name` key is compulsory, and `zef` will fail if you do not include it. Even if you have created a META6.json file just to express the dependencies for a series of scripts, this section must be included.

  Optionally, you can set an `api` field. Incrementing this indicates that the interface provided by your module is not backwards compatible with a previous version. You can use it if you want to adhere to [Semantic Versioning](https://semver.org/). A best practice is to simply keep the `api` field to the same value as your major version number. A dependency can then depend on your module by including a `:api` part, which will ensure backwards incompatible releases will not be pulled in.

  The `auth` section identifies the author in GitHub or other repository hosting site, such as Bitbucket or GitLab. This field is *customary*, since it's used to identify the author in the ecosystem, and opens the possibility of having modules with the same name and different authors.

  The `authors` section includes a list of all the module authors. In the case there is only one author, a single element list must be supplied. This field is optional.

  In the `provides` section, include all the namespaces provided by your distribution and that you wish to be installed; only module files that are explicitly included here will be installed and available with `use` or `require` in other programs. This field is mandatory.

  Set `perl` version to the minimum perl version your module works with. This field is mandatory. Use `6.c` if your module is valid for Christmas release and newer ones, use `6.d` if it requires, at least, the Diwali version.

  The `resources` section is optional, but, if present, should contain a list of the files in your `resources` directory that you wish to be installed. These will be installed with hashed names alongside your library files. Their installed location can be determined through the `%?RESOURCES` `Hash` indexed on the name provided. The `tags` section is also optional. It is used to describe the module in the Raku ecosystem.

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

  In general, the array form will be more than enough for most cases.

  Finally, `source-url` indicates the URL of the repository where the module is developed; this is one of the customary modules if you are going to publish it in the module ecosystem. The current module ecosystem will link this URL from the project description. [[6\]](https://docs.raku.org/language/modules#fn-6)

  The [`Test::META` module](https://github.com/jonathanstowe/Test-META/) can help you check the correctness of the META6.json file; this module will check for all the mandatory fields and that the type used for all of them is correct.

  There are more fields described in the [`META` design documents](https://design.perl6.org/S22.html#META6.json), but not all of these are implemented by existing package managers. Hence you should stick to the fields described in the above example block to ensure compatibility with existing package managers such as `zef`. You can also check [Moritz Lenz's repository of all modules for examples](https://github.com/moritz/perl6-all-modules/search?l=JSON&q=META6.json&type=), but bear in mind that some of them might use fields, such as `source-type` above, which are currently ignored.

- If you want to test your module you can use the following command to install the module directly from the module folder you just created.

  ```
  zef install ./your-module-folder
  ```

  Note that doing so precompiles and installs your module. If you make changes to the source, you'll need to re-install the module. (See `use lib` pragma, `-I` command line switch, or `PERL6LIB` env variable, to include a path to your module source while developing it, so you don't have to install it at all).

## Upload your module to CPAN

Uploading a module to CPAN is the preferred way of distributing Raku modules.

A prerequisite for this is a [PAUSE](https://pause.perl.org/) user account. If you don't have an account already, you can create one [here](https://pause.perl.org/pause/query?ACTION=request_id) The process takes about 5 minutes and some e-mail back and forth.

- Create a package of your module:

  ```
  cd your-module-folder
  tar czf Vortex-TotalPerspective-0.0.1.tar.gz \
    --transform s/^\./Vortex-TotalPerspective-0.0.1/ --exclude-vcs\
    --exclude=.[^/]*
  ```

  If you use git you can also use the following command to create a package directly for a given commit.

  ```
  git archive --prefix=Vortex-TotalPerspective-0.0.1/ \
    -o ../Vortex-TotalPerspective-0.0.1.tar.gz HEAD
  ```

- Go to [PAUSE](https://pause.perl.org/), log in and navigate to `Upload a file to CPAN`.

- Make sure you select `Perl6` as the *Target Directory*. For your first upload, you have to enter the string `Perl6` in the text field. On subsequent uploads, you can select the `Perl6` directory from the selection box right below the input field.

- Select your file and click *Upload*! If everything was fine with your dist, you should see your module tar file in your `Perl6` directory along with both a `META` and a `README` file named after your module filename.

  *Make sure you have a META6.json file in your dist and that the dist version you're uploading is higher than the currently uploaded version. Those are the most common upload errors.*

## Upload your module to p6c

If you want to use the *p6c* ecosystem you need to use git for your module's version control. The instructions herein assume that you have a [GitHub](https://github.com/) account so that your module can be shared from its GitHub repository, however another provider such as [GitLab](https://about.gitlab.com/) should work as long as it works in a similar way.

- Put your project under git version control if you haven't done so already.
- Once you're happy with your project, create a repository for it on GitHub. See [GitHub's help docs](https://help.github.com/) if necessary. Your GitHub repository should be named the same as your project directory. Immediately after creating the GitHub repo, GitHub shows you how to configure your local repository to know about your GitHub repository.
- Push your project to GitHub.
- Consider setting up automated testing (see <https://docs.travis-ci.com/user/languages/perl6>).
- Create a PR on [ecosystem](https://github.com/perl6/ecosystem) adding your module to META.list, or ping someone on IRC (#perl6 at freenode) to get help having it added.
- After the pull request has been accepted, wait for an hour. If your module doesn't show up on <https://modules.perl6.org/>, please view the log file at <https://modules.perl6.org/update.log> to see if it identifies an error with your module or `meta` file.

**That's it! Thanks for contributing to the Raku community!**

If you'd like to try out installing your module, use the zef module installer tool which is included with Rakudo Star Raku:

```Raku
zef install Vortex::TotalPerspective
```

This will download your module to its own working directory (`~/.zef`), build it there, and install the module into your local Raku installation directory.

To use `Vortex::TotalPerspective` from your scripts, just write `use Vortex::TotalPerspective`, and your Raku implementation will know where to look for the module file(s).

# Modules and tools related to module authoring

You can find a list of modules and tools that aim to improve the experience of writing/test modules at [Modules Extra](https://docs.raku.org/language/modules-extra)

## Contact information

To discuss module development in general, or if your module would fill a need in the ecosystem, naming, etc., you can use the [perl6 on irc.freenode.net](irc://irc.freenode.net/#perl6) IRC channel.

To discuss toolchain specific questions, you can use the [perl6-toolchain on irc.freenode.net](irc://irc.freenode.net/#perl6-toolchain) IRC channel. A repository to discuss tooling issues is also available at <https://github.com/perl6/toolchain-bikeshed>.

[[↑\]](https://docs.raku.org/language/modules#fn-ref-1) Technically a module is a set of *compunits* which are usually files but could come from anywhere as long as there is a *compunit repository* that can provide it. See [S11](https://design.perl6.org/S11.html).[[↑\]](https://docs.raku.org/language/modules#fn-ref-2) If it's installed, it will reinstall only if the version of the module is newer than the one installed[[↑\]](https://docs.raku.org/language/modules#fn-ref-3) As [synopsis S11](https://design.perl6.org/S11.html#Units) says: Confusing? Yes it is.[[↑\]](https://docs.raku.org/language/modules#fn-ref-4) This change was introduced in late 2016. If you are using versions older than this, behavior will be different[[↑\]](https://docs.raku.org/language/modules#fn-ref-5) Note, described above is a minimal project directory. If your project contains scripts that you'd like distributed along with your module(s), put them in a `bin` directory. If you'd like a graphical logo to appear next to your module at the module directory, create a `logotype` directory and put into it a `logo_32x32.png` file. At some point, you might also consider adding `CONTRIBUTORS`, `NEWS`, `TODO`, or other files.[[↑\]](https://docs.raku.org/language/modules#fn-ref-6) Some old modules also provide a `source-type` field, which was used to indicate the kind of source control system, generally `git`, which can be used to download the module. However, this field is nowadays ignored by `zef` and the rest of the tools.
