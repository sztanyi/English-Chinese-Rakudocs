原文：https://docs.raku.org/language/module-packages

# 模组包 / Module packages

为代码重用创建模块包

Creating module packages for code reuse

*注意*“模块”是 Raku 中一个过载的术语；本文件侧重于使用 `module` 声明器。

*N.B.* "Module" is an overloaded term in Raku; this document focuses on use of the `module` declarator.

# 模组是什么 / What are modules?

Modules, like classes and grammars, are a kind of [package](https://docs.raku.org/language/packages). Module objects are instances of the `ModuleHOW` metaclass; this provides certain capabilities useful for creating namespaces, versioning, delegation and data encapsulation (see also [class](https://docs.raku.org/syntax/class) and [role](https://docs.raku.org/syntax/role)).

To create a module, use the `module` declarator:

```Raku
module M {}
say M.HOW;   # OUTPUT: «Perl6::Metamodel::ModuleHOW.new␤»
```

Here we define a new module named `M`; introspection with `HOW` confirms that the metaclass underlying `M` is `Perl6::Metamodel::ModuleHOW`.

## When to use modules

Modules are primarily useful for encapsulating code and data that do not belong inside a class or role definition. Module contents (classes, subroutines, variables, etc.) can be exported from a module with the `is export` trait; these are available in the caller's namespace once the module has been imported with `import` or `use`. A module can also selectively expose symbols within its namespace for qualified reference via `our`.

## Working with modules

To illustrate module scoping and export rules, let's begin by defining a simple module `M`:

```Raku
module M {
  sub greeting ($name = 'Camelia') { "Greetings, $name!" }
  our sub loud-greeting (--> Str)  { greeting().uc       }
  sub friendly-greeting is export  { greeting('friend')  }
}
```

Recall that subroutines are lexically scoped unless otherwise specified (declarator [`sub`](https://docs.raku.org/syntax/sub) is equivalent to `my sub`), so `greeting` in the above example is lexically scoped to the module and inaccessible outside of it. We've also defined `loud-greeting` with the `our` declarator, which means that in addition to being lexically scoped it is aliased in the module's symbol table. Finally, `friendly-greeting` is marked for export; it will be registered in the *caller's* symbol table when the module is imported:

```Raku
import M;               # import the module 
say M::loud-greeting;   # OUTPUT: «GREETINGS, CAMELIA!␤» 
say friendly-greeting;  # OUTPUT: «Greetings, friend!␤» 
```

# Modules on disk

While `.pm` and `.pm6` files (hereafter: `.pm6`) are sometimes referred to as "modules", they are really just normal files that are loaded and compiled when you write `need`, `use` or `require`.

For a `.pm6` file to provide a module in the sense that we've been using, it needs to declare one with `module` as documented above. For example, by placing module `M` inside `Foo.pm6`, we can load and use the module as follows:

```Raku
use Foo;                # find Foo.pm6, run need followed by import 
say M::loud-greeting;   # OUTPUT: «GREETINGS, CAMELIA!␤» 
say friendly-greeting;  # OUTPUT: «Greetings, friend!␤» 
```

Note the decoupling between file and module names—a `.pm6` file can declare zero or more modules with arbitrary identifiers.

## File and module naming

Often we want a `.pm6` file to provide a *single* module and nothing more. Here a common convention is for the file basename to match the module name. Returning to `Foo.pm6`, it is apparent that it only provides a single module, `M`; in this case, we might want to rename `M` to `Foo`. The amended file would then read:

```Raku
module Foo {
  sub greeting ($name = 'Camelia') { "Greetings, $name!" }
  our sub loud-greeting (--> Str)  { greeting().uc       }
  sub friendly-greeting is export  { greeting('friend')  }
}
```

which can be used more consistently by the caller (note the relationship between the `use Foo` and `Foo::`):

```Raku
use Foo;
say Foo::loud-greeting;  # OUTPUT: «GREETINGS, CAMELIA!␤» 
say friendly-greeting;   # OUTPUT: «Greetings, friend!␤» 
```

If `Foo.pm6` is placed deeper within the source tree, e.g. at `lib/Utils/Foo.pm6`, we can elect to name the module `Utils::Foo` to maintain consistency.

### The `unit` keyword

Files that only provide a single module can be written more concisely with the `unit` keyword; `unit module` specifies that the rest of the compilation unit is part of the declared module. Here's `Foo.pm6` rewritten with `unit`:

```Raku
unit module Foo;
 
sub greeting ($name = 'Camelia') { "Greetings, $name!" }
our sub loud-greeting (--> Str)  { greeting().uc       }
sub friendly-greeting is export  { greeting('friend')  }
```

Everything following the unit declaration is part of the `Foo` module specification.

(Note that `unit` can also be used with `class`, `grammar` and `role`.)

## What happens if I omit `module`?

To better understand what the `module` declarator is doing in `Foo.pm6`, let's contrast it with a variant file, `Bar.pm6`, that omits the declaration. The subroutine definitions below are almost identical (the only difference is in the body of `greeting`, modified for clarity):

```Raku
sub greeting ($name = 'Camelia') { "Greetings from Bar, $name!" }
our sub loud-greeting (--> Str)  { greeting().uc                }
sub friendly-greeting is export  { greeting('friend')           }
```

As a reminder, here's how we used `Foo.pm6` before,

```Raku
use Foo;
say Foo::loud-greeting;  # OUTPUT: «GREETINGS, CAMELIA!␤» 
say friendly-greeting;   # OUTPUT: «Greetings, friend!␤» 
```

and here's how we use `Bar.pm6`,

```Raku
use Bar;
say loud-greeting;       # OUTPUT: «GREETINGS FROM BAR, CAMELIA!␤» 
say friendly-greeting;   # OUTPUT: «Greetings from Bar, friend!␤» 
```

Note the use of `loud-greeting` rather than `Bar::loud-greeting` as `Bar` is not a known symbol (we didn't create a `module` of that name in `Bar.pm6`). But why is `loud-greeting` callable even though we didn't mark it for export? The answer is simply that `Bar.pm6` doesn't create a new package namespace—`$?PACKAGE` is still set to `GLOBAL`—so when we declare `loud-greeting` as `our`, it is registered in the `GLOBAL` symbol table.

### Lexical aliasing and safety

Thankfully, Raku protects us from accidentally clobbering call site definitions (e.g. builtins). Consider the following addition to `Bar.pm6`:

```Raku
our sub say ($ignored) { print "oh dear\n" }
```

This creates a lexical alias, hiding the `say` builtin *inside* `Bar.pm6` but leaving the caller's `say` unchanged. Consequently, the following call to `say` still works as expected:

```Raku
use Bar;
say 'Carry on, carry on...';  # OUTPUT: «Carry on, carry on...␤» 
```
