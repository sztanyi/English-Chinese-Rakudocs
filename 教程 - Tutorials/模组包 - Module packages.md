原文：https://docs.raku.org/language/module-packages

# 模组包 / Module packages

为代码重用创建模块包

Creating module packages for code reuse

*注意*“模块”是 Raku 中一个过载的术语；本文件侧重于使用 `module` 声明器。

*N.B.* "Module" is an overloaded term in Raku; this document focuses on use of the `module` declarator.

<!-- MarkdownTOC -->

- [模组是什么 / What are modules?](#模组是什么--what-are-modules)
  - [何时使用模块 / When to use modules](#何时使用模块--when-to-use-modules)
  - [使用模块 / Working with modules](#使用模块--working-with-modules)
- [磁盘上的模块 / Modules on disk](#磁盘上的模块--modules-on-disk)
  - [文件和模块命名 / File and module naming](#文件和模块命名--file-and-module-naming)
    - [`unit` 关键字 / The `unit` keyword](#unit-关键字--the-unit-keyword)
  - [如果省略 `module` 会发生什么？ / What happens if I omit `module`?](#如果省略-module-会发生什么？--what-happens-if-i-omit-module)
    - [词法别名与安全 / Lexical aliasing and safety](#词法别名与安全--lexical-aliasing-and-safety)

<!-- /MarkdownTOC -->

<a id="模组是什么--what-are-modules"></a>
# 模组是什么 / What are modules?

模块，如类和语法，是一种[包](https://docs.raku.org/language/packages)。模块对象是 `ModuleHOW` 元类的实例；这为创建命名空间、版本控制、委托和数据封装提供了一些有用的功能（另请参阅[类](https://docs.raku.org/syntax/class)和[角色])(https://docs.raku.org/syntax/role)）。

Modules, like classes and grammars, are a kind of [package](https://docs.raku.org/language/packages). Module objects are instances of the `ModuleHOW` metaclass; this provides certain capabilities useful for creating namespaces, versioning, delegation and data encapsulation (see also [class](https://docs.raku.org/syntax/class) and [role](https://docs.raku.org/syntax/role)).

若要创建模块，请使用 `module` 声明符：

To create a module, use the `module` declarator:

```Raku
module M {}
say M.HOW;   # OUTPUT: «Perl6::Metamodel::ModuleHOW.new␤»
```

在这里，我们定义了一个名为 `M` 的新模块；带有 `HOW` 的内省确认了在 `M` 背后的元类是 `Perl6::Metamodel::ModuleHOW`。

Here we define a new module named `M`; introspection with `HOW` confirms that the metaclass underlying `M` is `Perl6::Metamodel::ModuleHOW`.

<a id="何时使用模块--when-to-use-modules"></a>
## 何时使用模块 / When to use modules

模块主要用于封装不属于类或角色定义的代码和数据。模块内容（类、子例程、变量等）。可以从具有 `is export` 特性的模块导出；一旦模块使用 `import` 或  `use` 被导入了，则这些选项在调用方的命名空间中可用。模块还可以通过 `our` 选择性地暴露其命名空间内的符号以获得合格的参考。

Modules are primarily useful for encapsulating code and data that do not belong inside a class or role definition. Module contents (classes, subroutines, variables, etc.) can be exported from a module with the `is export` trait; these are available in the caller's namespace once the module has been imported with `import` or `use`. A module can also selectively expose symbols within its namespace for qualified reference via `our`.

<a id="使用模块--working-with-modules"></a>
## 使用模块 / Working with modules

为了说明模块范围和导出规则，我们首先定义一个简单的模块 `M`：

To illustrate module scoping and export rules, let's begin by defining a simple module `M`:

```Raku
module M {
  sub greeting ($name = 'Camelia') { "Greetings, $name!" }
  our sub loud-greeting (--> Str)  { greeting().uc       }
  sub friendly-greeting is export  { greeting('friend')  }
}
```

回想一下，除非另有规定，子例程为词法作用域（声明器 [`sub`](https://docs.raku.org/syntax/sub) 等效于 `my sub`），因此在上面的示例中 `greeting` 在词汇上限定为模块的作用域，并且在模块之外无法访问。我们还用 `our` 声明符定义了 `loud-greeting`，这意味着除了词法作用域之外，它还在模块的符号表中别名。最后，`friendly-greeting` 标记为导出；在导入模块时，它将在*调用方的*符号表中注册：

Recall that subroutines are lexically scoped unless otherwise specified (declarator [`sub`](https://docs.raku.org/syntax/sub) is equivalent to `my sub`), so `greeting` in the above example is lexically scoped to the module and inaccessible outside of it. We've also defined `loud-greeting` with the `our` declarator, which means that in addition to being lexically scoped it is aliased in the module's symbol table. Finally, `friendly-greeting` is marked for export; it will be registered in the *caller's* symbol table when the module is imported:

```Raku
import M;               # import the module 
say M::loud-greeting;   # OUTPUT: «GREETINGS, CAMELIA!␤» 
say friendly-greeting;  # OUTPUT: «Greetings, friend!␤» 
```

<a id="磁盘上的模块--modules-on-disk"></a>
# 磁盘上的模块 / Modules on disk

虽然 `.pm` 和 `.pm6` 文件（以下称 `.pm6`）有时被称为"模块"，但它们实际上只是在写 `need`、 `use` 或 `require` 时加载和编译的正常文件。

While `.pm` and `.pm6` files (hereafter: `.pm6`) are sometimes referred to as "modules", they are really just normal files that are loaded and compiled when you write `need`, `use` or `require`.

对于 `.pm6` 文件，要在我们使用的意义上提供一个模块，它需要使用 `module` 声明一个“模块”，如上面所记录的。例如，通过将模块 `M` 置于 `Foo.pm6` 内部，我们可以按如下方式加载和使用模块：

For a `.pm6` file to provide a module in the sense that we've been using, it needs to declare one with `module` as documented above. For example, by placing module `M` inside `Foo.pm6`, we can load and use the module as follows:

```Raku
use Foo;                # find Foo.pm6, run need followed by import 
say M::loud-greeting;   # OUTPUT: «GREETINGS, CAMELIA!␤» 
say friendly-greeting;  # OUTPUT: «Greetings, friend!␤» 
```

注意文件和模块名称之间的解耦 -`.pm6` 文件可以声明具有任意标识符的零个或多个模块。

Note the decoupling between file and module names—a `.pm6` file can declare zero or more modules with arbitrary identifiers.

<a id="文件和模块命名--file-and-module-naming"></a>
## 文件和模块命名 / File and module naming

通常，我们想要一个 `.pm6` 文件来提供一个*单一*模块，仅此而已。在这里，一个常见的约定是文件名与模块名匹配。说回到 `Foo.pm6` 时，很明显，它只提供了一个模块 `M`；在本例中，我们可能希望将 `M` 重命名为 `Foo`。修改后的文件内容如下：

Often we want a `.pm6` file to provide a *single* module and nothing more. Here a common convention is for the file basename to match the module name. Returning to `Foo.pm6`, it is apparent that it only provides a single module, `M`; in this case, we might want to rename `M` to `Foo`. The amended file would then read:

```Raku
module Foo {
  sub greeting ($name = 'Camelia') { "Greetings, $name!" }
  our sub loud-greeting (--> Str)  { greeting().uc       }
  sub friendly-greeting is export  { greeting('friend')  }
}
```

调用者可以更一致地使用（注意 `use Foo` 和 `Foo::` 之间的关系）：

which can be used more consistently by the caller (note the relationship between the `use Foo` and `Foo::`):

```Raku
use Foo;
say Foo::loud-greeting;  # OUTPUT: «GREETINGS, CAMELIA!␤» 
say friendly-greeting;   # OUTPUT: «Greetings, friend!␤» 
```

如果 `Foo.pm6` 放置在源码树种更深的放置中，例如在 `lib/Utils/Foo.pm6`，我们可以选择将模块命名为 `Utils::Foo` 以保持一致性。

If `Foo.pm6` is placed deeper within the source tree, e.g. at `lib/Utils/Foo.pm6`, we can elect to name the module `Utils::Foo` to maintain consistency.

<a id="unit-关键字--the-unit-keyword"></a>
### `unit` 关键字 / The `unit` keyword

仅提供单个模块的文件可以用 `unit` 关键字更简洁地编写；`unit module` 指定编译单元的其余部分是所声明的模块的一部分。此处为 `Foo.pm6`，用 `unit` 重写：

Files that only provide a single module can be written more concisely with the `unit` keyword; `unit module` specifies that the rest of the compilation unit is part of the declared module. Here's `Foo.pm6` rewritten with `unit`:

```Raku
unit module Foo;

sub greeting ($name = 'Camelia') { "Greetings, $name!" }
our sub loud-greeting (--> Str)  { greeting().uc       }
sub friendly-greeting is export  { greeting('friend')  }
```

unit 声明之后的所有内容都是 `Foo` 模块规范的一部分。

Everything following the unit declaration is part of the `Foo` module specification.

（请注意，`unit` 也可以与 `class`、 `grammar` 和 `role` 一起使用。)

(Note that `unit` can also be used with `class`, `grammar` and `role`.)

<a id="如果省略-module-会发生什么？--what-happens-if-i-omit-module"></a>
## 如果省略 `module` 会发生什么？ / What happens if I omit `module`?

为了更好地理解 `module` 声明器在 `Foo.pm6` 中所做的事情，让我们将其与省略声明的变体文件 `Bar.pm6` 进行对比。下面的子例程定义几乎是相同的（唯一的区别是 `greeting` 的正文，为了清楚起见对其作了修改）：

To better understand what the `module` declarator is doing in `Foo.pm6`, let's contrast it with a variant file, `Bar.pm6`, that omits the declaration. The subroutine definitions below are almost identical (the only difference is in the body of `greeting`, modified for clarity):

```Raku
sub greeting ($name = 'Camelia') { "Greetings from Bar, $name!" }
our sub loud-greeting (--> Str)  { greeting().uc                }
sub friendly-greeting is export  { greeting('friend')           }
```

作为提醒，这里是我们以前使用的 `Foo.pm6` 的方式，

As a reminder, here's how we used `Foo.pm6` before,

```Raku
use Foo;
say Foo::loud-greeting;  # OUTPUT: «GREETINGS, CAMELIA!␤» 
say friendly-greeting;   # OUTPUT: «Greetings, friend!␤» 
```

以下是我们如何使用 `Bar.pm6`，

and here's how we use `Bar.pm6`,

```Raku
use Bar;
say loud-greeting;       # OUTPUT: «GREETINGS FROM BAR, CAMELIA!␤» 
say friendly-greeting;   # OUTPUT: «Greetings from Bar, friend!␤» 
```

注意 `loud-greeting` 而不是 `Bar::loud-greeting` 的用法，因为 `Bar` 不是已知的符号（我们没有在 `Bar.pm6` 中创建那个名称的 `module`）。但是为什么 `loud-greeting` 是可以调用的，即使我们没有标记它的出口呢？答案仅仅是 `Bar.pm6` 不创建新的包命名空间--`$?PACKAGE` 仍然被设置为 `GLOBAL`--因此，当我们将 `loud-greeting` 声明为 `our` 时，它将注册在 `GLOBAL` 符号表中。

Note the use of `loud-greeting` rather than `Bar::loud-greeting` as `Bar` is not a known symbol (we didn't create a `module` of that name in `Bar.pm6`). But why is `loud-greeting` callable even though we didn't mark it for export? The answer is simply that `Bar.pm6` doesn't create a new package namespace—`$?PACKAGE` is still set to `GLOBAL`—so when we declare `loud-greeting` as `our`, it is registered in the `GLOBAL` symbol table.

<a id="词法别名与安全--lexical-aliasing-and-safety"></a>
### 词法别名与安全 / Lexical aliasing and safety

值得庆幸的是，Raku 保护我们免受意外调用站点定义（例如，内置）。请考虑以下添加到 `Bar.pm6`：

Thankfully, Raku protects us from accidentally clobbering call site definitions (e.g. builtins). Consider the following addition to `Bar.pm6`:

```Raku
our sub say ($ignored) { print "oh dear\n" }
```

这创建了一个词法别名，将内置函数 `say` 隐藏至 `Bar.pm6` 但是让调用者的 `say` 不变。因此，以下 `say` 的调用仍按预期运行：

This creates a lexical alias, hiding the `say` builtin *inside* `Bar.pm6` but leaving the caller's `say` unchanged. Consequently, the following call to `say` still works as expected:

```Raku
use Bar;
say 'Carry on, carry on...';  # OUTPUT: «Carry on, carry on...␤» 
```
