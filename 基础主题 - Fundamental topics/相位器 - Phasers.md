原文：https://docs.raku.org/language/phasers

# 相位器 / Phasers

程序执行阶段和相应的相位块

Program execution phases and corresponding phaser blocks

程序的生存期(执行时间线)被分成几个阶段。*相位器*是在特定执行阶段调用的代码块。

The lifetime (execution timeline) of a program is broken up into phases. A *phaser* is a block of code called during a specific execution phase.

<!-- MarkdownTOC -->

- [相位器 / Phasers](#相位器--phasers)
  - [执行顺序 / Execution order](#执行顺序--execution-order)
- [程序执行相位器 / Program execution phasers](#程序执行相位器--program-execution-phasers)
  - [BEGIN](#begin)
  - [CHECK](#check)
  - [INIT](#init)
  - [END](#end)
- [代码块相位器 / Block phasers](#代码块相位器--block-phasers)
  - [ENTER](#enter)
  - [LEAVE](#leave)
  - [KEEP](#keep)
  - [UNDO](#undo)
  - [PRE](#pre)
  - [POST](#post)
- [循环相位器 / Loop phasers](#循环相位器--loop-phasers)
  - [FIRST](#first)
  - [NEXT](#next)
  - [LAST](#last)
- [异常处理相位器 / Exception handling phasers](#异常处理相位器--exception-handling-phasers)
  - [CATCH](#catch)
  - [CONTROL](#control)
- [对象相位器 / Object phasers](#对象相位器--object-phasers)
  - [COMPOSE \(尚未实施\) / COMPOSE \(Not yet implemented\)](#compose-尚未实施--compose-not-yet-implemented)
- [异步相位器 / Asynchronous phasers](#异步相位器--asynchronous-phasers)
  - [LAST](#last-1)
  - [QUIT](#quit)
  - [CLOSE](#close)
- [DOC 相位器 / DOC phasers](#doc-相位器--doc-phasers)
  - [DOC](#doc)

<!-- /MarkdownTOC -->


<a id="相位器--phasers"></a>
# 相位器 / Phasers

相位块只是包含它的闭包的一个特性，并在适当的时候自动调用。这些自动调用的块被称为*相位器*，因为它们通常标志着从计算的一个阶段到另一个阶段的过渡。例如，在编译一个编译单元的末尾调用一个 `CHECK` 块。还可以安装其他类型的相位器；它们会在适当的不同时间自动调用，其中一些会响应各种控制异常和退出值。例如，某个代码块的退出成功与否，可能会调用一些相位器，在本例中，*成功*是通过返回定义的值或列表来定义的，在此过程中没有任何 `Failure` 或异常。

A phaser block is just a trait of the closure containing it, and is automatically called at the appropriate moment. These auto-called blocks are known as *phasers*, since they generally mark the transition from one phase of computing to another. For instance, a `CHECK` block is called at the end of compiling a compilation unit. Other kinds of phasers can be installed as well; these are automatically called at various times as appropriate, and some of them respond to various control exceptions and exit values. For instance, some phasers might be called if the exit from a block is successful or not, with *success* in this case defined by returning with a defined value or list without any `Failure` or exception in the process.

以下是一个总结：

Here is a summary:

```Raku
  BEGIN {...} #  * at compile time, as soon as possible, only ever runs once / 编译时运行一次，尽量早地运行
  CHECK {...} #  * at compile time, as late as possible, only ever runs once / 编译时运行一次，尽量晚地运行
   INIT {...} #  * at runtime, as soon as possible, only ever runs once / 运行时运行一次，尽量早地运行
    END {...} #  at runtime, as late as possible, only ever runs once / 运行时运行一次，尽量晚地运行
    DOC [BEGIN|CHECK|INIT] {...} # only in documentation mode / 仅在文档模式下
 
  ENTER {...} #  * at every block entry time, repeats on loop blocks. / 在进入每个代码块时，在循环代码块中重复
  LEAVE {...} #  at every block exit time (even stack unwinds from exceptions) / 退出代码块时
   KEEP {...} #  at every successful block exit, part of LEAVE queue / 成功退出代码块时，LEAVE 队列的一部分
   UNDO {...} #  at every unsuccessful block exit, part of LEAVE queue / 非成功退出代码块时，LEAVE 队列的一部分
 
  FIRST {...} #  at loop initialization time, before any ENTER / 循环初始时，在 ENTER 之前
   NEXT {...} #  at loop continuation time, before any LEAVE / 循环继续时，在 LEAVE 之前
   LAST {...} #  at loop termination time, after any LEAVE / 循环终止时，在 LEAVE 之后
 
    PRE {...} #  assert precondition at every block entry, before ENTER / 断言先决条件在每个代码块入口，在 ENTER 之前
   POST {...} #  assert postcondition at every block exit, after LEAVE / 断言先决条件在每个代码块出口，在 LEAVE 之后
 
  CATCH {...} #  catch exceptions, before LEAVE / 捕获异常，在 LEAVE 之前
CONTROL {...} #  catch control exceptions, before LEAVE / 捕获控制一次，在 LEAVE 之前
 
   LAST {...} #  supply tapped by whenever-block is done, runs very last / supply 被 whenever 代码块利用完时，最后一个
   QUIT {...} #  catch async exceptions within a whenever-block, runs very last / 在 whenever 代码块中捕获异步异常，最后一个
 
COMPOSE {...} #  when a role is composed into a class (Not yet implemented) / 当角色被编入类时（尚未实现）
  CLOSE {...} #  appears in a supply block, called when the supply is closed / 出现在 supply 代码块中，当 supply 被关闭时调用
```

标记为 `*` 的相位器具有一个运行时值，如果计算时间早于其周围表达式，则只需保存其结果，以便稍后在计算表达式的其余部分时在表达式中使用：

Phasers marked with a `*` have a runtime value, and if evaluated earlier than their surrounding expression, they simply save their result for use in the expression later when the rest of the expression is evaluated:

```Raku
my $compiletime = BEGIN { now };
our $random = ENTER { rand };
```

与其他语句前缀一样，这些产生值的构造可以放在代码块或语句的前面：

As with other statement prefixes, these value-producing constructs may be placed in front of either a block or a statement:

```Raku
my $compiletime = BEGIN now;
our $random = ENTER rand;
```

这些相位器中的大多数接受代码块或函数引用。语句形式对于将在词汇作用域上的声明公开给周围的词法作用域特别有用，而不会在块中“捕获”它。

Most of these phasers will take either a block or a function reference. The statement form can be particularly useful to expose a lexically scoped declaration to the surrounding lexical scope without "trapping" it inside a block.

这些声明具有与前面示例相同范围的相同变量，但在指定的时间作为一个整体运行语句：

These declare the same variables with the same scope as the preceding example, but run the statements as a whole at the indicated time:

```Raku
BEGIN my $compiletime = now;
ENTER our $random = rand;
```

(但是，请注意，在运行时克隆任何周围闭包时，在编译时计算的变量的值可能不会持续。)

(Note, however, that the value of a variable calculated at compile time may not persist under runtime cloning of any surrounding closure.)

大多数非产生价值的相位器也可以这样使用：

Most of the non-value-producing phasers may also be so used:

```Raku
END say my $accumulator;
```

不过，请注意

Note, however, that

```Raku
END say my $accumulator = 0;
```

在 `END` 时将变量设置为 0，因为这是在实际执行 “my” 声明的时候。只有无参的相位器才能使用语句形式。这意味着 `CATCH` 和 `CONTROL` 总是需要一个代码块，因为它们采用的参数是将 `$_` 设置为当前主题，以便内部节点能够表现为开关语句。（如果允许仅作陈述，`$_` 的临时绑定就会在 `CATCH` 或 `CONTROL` 结束后泄露出去，后果难以预测，而且很可能会造成可怕的后果。异常处理程序应该减少不确定性，而不是增加不确定性。）

sets the variable to 0 at `END` time, since that is when the "my" declaration is actually executed. Only argumentless phasers may use the statement form. This means that `CATCH` and `CONTROL` always require a block, since they take an argument that sets `$_` to the current topic, so that the innards are able to behave as a switch statement. (If bare statements were allowed, the temporary binding of `$_` would leak out past the end of the `CATCH` or `CONTROL`, with unpredictable and quite possibly dire consequences. Exception handlers are supposed to reduce uncertainty, not increase it.)

其中一些相位器还具有相应的特性，可以设置在变量上；它们使用 `will`，后面跟着小写的相位器名称。这些方法的优点是将所述变量作为其主题传递到闭包中：

Some of these phasers also have corresponding traits that can be set on variables; they use `will` followed by the name of the phaser in lowercase. These have the advantage of passing the variable in question into the closure as its topic:

```Raku
our $h will enter { .rememberit() } will undo { .forgetit() };
```

只有可以在代码块内多次发生的相位器才有资格使用每变量形式；这不包括 `CATCH` 和其他类似 `CLOSE` 或 `QUIT` 的类型。

Only phasers that can occur multiple times within a block are eligible for this per-variable form; this excludes `CATCH` and others like `CLOSE` or `QUIT`.

相位器外部块的主题仍然可以作为 `OUTER::<$_> `。返回值是否可以修改跟相位器的策略有关。特别是，不应在 `POST` 相位器内修改返回值，但 `LEAVE` 相位器可以更自由。

The topic of the block outside a phaser is still available as `OUTER::<$_> `. Whether the return value is modifiable may be a policy of the phaser in question. In particular, the return value should not be modified within a `POST` phaser, but a `LEAVE` phaser could be more liberal.

在方法的词法作用域中定义的任何相位词都是一个闭包，关住了 `self` 和普通词法。(或者等效地，一个实现可以简单地将所有这样的相位器转换为子方法，其准备好的调用者是当前对象。)

Any phaser defined in the lexical scope of a method is a closure that closes over `self` as well as normal lexicals. (Or equivalently, an implementation may simply turn all such phasers into submethods whose primed invocant is the current object.)

当多个相位器计划同时运行时，一般的解绑原则是初始化相位器按声明的顺序执行，而终结相位器按相反的顺序执行，因为设置和拆卸通常希望以彼此相反的顺序执行。

When multiple phasers are scheduled to run at the same moment, the general tiebreaking principle is that initializing phasers execute in order declared, while finalizing phasers execute in the opposite order, because setup and teardown usually want to happen in the opposite order from each other.

<a id="执行顺序--execution-order"></a>
## 执行顺序 / Execution order

编译开始

Compilation begins

```Raku
      BEGIN {...} #  at compile time, As soon as possible, only ever runs once 
      CHECK {...} #  at compile time, As late as possible, only ever runs once 
    COMPOSE {...} #  when a role is composed into a class (Not yet implemented) 
```

执行开始

Execution begins

```Raku
       INIT {...} #  at runtime, as soon as possible, only ever runs once 
```

在代码块执行开始之前

Before block execution begins

```Raku
        PRE {...} #  assert precondition at every block entry, before ENTER 
```

循环执行开始

Loop execution begins

```Raku
      FIRST {...} #  at loop initialization time, before any ENTER 
```

代码块执行开始

Block execution begins

```Raku
      ENTER {...} #  at every block entry time, repeats on loop blocks. 
```

异常可能会发生

Exception maybe happens

```Raku
      CATCH {...} #  catch exceptions, before LEAVE 
    CONTROL {...} #  catch control exceptions, before LEAVE 
```

循环结束，继续或完成

End of loop, either continuing or finished

```Raku
       NEXT {...} #  at loop continuation time, before any LEAVE 
       LAST {...} #  at loop termination time, after any LEAVE 
```

代码块结束

End of block

```Raku
      LEAVE {...} #  when blocks exits, even stack unwinds from exceptions 
       KEEP {...} #  at every successful block exit, part of LEAVE queue 
       UNDO {...} #  at every unsuccessful block exit, part of LEAVE queue 
```

代码块后条件

Postcondition for block

```Raku
       POST {...} #  assert postcondition at every block exit, after LEAVE 
```

异步 whenever-代码块完成

Async whenever-block is complete

```Raku
       LAST {...} #  if ended normally with done, runs once after block 
       QUIT {...} #  catch async exceptions 
```

程序终止

Program terminating

```Raku
        END {...} #  at runtime, ALAP, only ever runs once 
```

<a id="程序执行相位器--program-execution-phasers"></a>
# 程序执行相位器 / Program execution phasers

<a id="begin"></a>
## BEGIN

在编译时运行，在相位器中的代码编译完毕后马上运行，只运行一次。

Runs at compile time, as soon as the code in the phaser has compiled, only runs once.

返回值可在以后的阶段中使用：

The return value is available for use in later phases:

```Raku
say "About to print 3 things";
for ^3 {
    say ^10 .pick ~ '-' ~ BEGIN { say  "Generating BEGIN value"; ^10 .pick }
}
# OUTPUT: 
# Generating BEGIN value 
# About to print 3 things 
# 3-3 
# 4-3 
# 6-3
```

相位器中的 `^10 .pick` 只生成一次，然后在运行时由循环重新使用。注意在 `BEGIN` 代码块中的 [say](https://docs.raku.org/routine/say) 是如何在循环上方的 [say](https://docs.raku.org/routine/say) 之前执行的。

The `^10 .pick` in the phaser is generated only once and is then re-used by the loop during runtime. Note how the [say](https://docs.raku.org/routine/say) in the `BEGIN` block is executed before the [say](https://docs.raku.org/routine/say) that is above the loop.

<a id="check"></a>
## CHECK

在编译时运行，尽可能晚，只运行一次。

Runs at compile time, as late as possible, only runs once.

可以有一个返回值，返回值可在以后的阶段中使用。

Can have a return value that is provided even in later phases.

在运行时生成的代码仍然可以触发 `CHECK` 和 `INIT` 相位器，当然，这些相位器不能做需要回到过去的事情。那样做你需要一个虫洞。。。

Code that is generated at runtime can still fire off `CHECK` and `INIT` phasers, though of course those phasers can't do things that would require travel back in time. You need a wormhole for that.

<a id="init"></a>
## INIT

在主执行过程中编译后运行，尽可能快，只运行一次。它可以有一个返回值，返回值可在以后的阶段中使用。

Runs after compilation during main execution, as soon as possible, only runs once. It can have a return value that is provided even in later phases.

当相位器在不同的模组中时，`INIT` 和 `END` 相位器被视为与在使用模组中的 `use` 声明类似。（但是，如果该模组不止一次使用，则依赖此顺序是错误的，因为只在第一次注意到时相位器才配置。）

When phasers are in different modules, the `INIT` and `END` phasers are treated as if declared at `use` time in the using module. (It is erroneous to depend on this order if the module is used more than once, however, since the phasers are only installed the first time they're noticed.)

在运行时生成的代码仍然可以触发 `CHECK` 和 `INIT` 相位器，当然，这些相位器不能做需要回到过去的事情。你需要一个虫洞。。。

Code that is generated at runtime can still fire off `CHECK` and `INIT` phasers, though of course those phasers can't do things that would require travel back in time. You need a wormhole for that.

`INIT` 只对克隆闭包的所有副本运行一次。

An `INIT` only runs once for all copies of a cloned closure.

<a id="end"></a>
## END

在主执行过程中编译后运行，尽可能晚，只运行一次。

Runs after compilation during main execution, as late as possible, only runs once.

当相位器在不同的模组中时，`INIT` 和 `END` 相位器被视为与在使用模组中的 `use` 声明类似。（但是，如果该模组不止一次使用，则依赖此顺序是错误的，因为只在第一次注意到时相位器才配置。）

When phasers are in different modules, the `INIT` and `END` phasers are treated as if declared at `use` time in the using module. (It is erroneous to depend on this order if the module is used more than once, however, since the phasers are only installed the first time they're noticed.)

<a id="代码块相位器--block-phasers"></a>
# 代码块相位器 / Block phasers

在代码块的上下文中执行具有自己的阶段。

Execution in the context of a block has its own phases.

离开块的相位器会等待直到调用堆栈实际解除才运行。只有在某些异常处理程序决定以这种方式处理异常后才会解除。也就是说，仅仅因为一个异常被抛出一个堆栈帧，并不意味着我们已经正式离开了这个块，因为异常可能是可以恢复的。无论如何，无论异常是否可以恢复，都会指定异常处理程序在失败代码的动态范围内运行。只有在异常未恢复时才会调用堆栈。

Block-leaving phasers wait until the call stack is actually unwound to run. Unwinding happens only after some exception handler decides to handle the exception that way. That is, just because an exception is thrown past a stack frame does not mean we have officially left the block yet, since the exception might be resumable. In any case, exception handlers are specified to run within the dynamic scope of the failing code, whether or not the exception is resumable. The stack is unwound and the phasers are called only if an exception is not resumed.

这些情况可以在块内多次发生。所以它们并不是真正的特征，确切地说，它们将自己添加到存储在实际特征中的列表中。如果你检查块的 `ENTER` 特性，你会发现它实际上是一个位相器列表，而不是单个位相器。

These can occur multiple times within the block. So they aren't really traits, exactly--they add themselves onto a list stored in the actual trait. If you examine the `ENTER` trait of a block, you'll find that it's really a list of phasers rather than a single phaser.

所有这些相位块都可以看到任何先前声明的词法变量，即使这些变量在调用闭包时还没有详细说明（在这种情况下，变量计算为一个未定义的值）。

All of these phaser blocks can see any previously declared lexical variables, even if those variables have not been elaborated yet when the closure is invoked (in which case the variables evaluate to an undefined value.)

<a id="enter"></a>
## ENTER

在每个块入口时间运行，在循环块上重复。

Runs at every block entry time, repeats on loop blocks.

可以有一个返回值，返回值可在以后的阶段中使用。

Can have a return value that is provided even in later phases.

从 `ENTER` 相位器抛出的异常将中止 `ENTER` 队列，但从 `LEAVE` 相位器抛出的异常不会。

An exception thrown from an `ENTER` phaser will abort the `ENTER` queue, but one thrown from a `LEAVE` phaser will not.

<a id="leave"></a>
## LEAVE

在每个块退出时运行（甚至堆栈从异常中展开），除非程序突然退出（例如使用 [`exit`](https://docs.raku.org/routine/exit)）。

Runs at every block exit time (even stack unwinds from exceptions), except when the program exits abruptly (e.g. with [`exit`](https://docs.raku.org/routine/exit)).

一定要在任何 `CATCH` 和 `CONTROL` 相位器之后对某一区块的 `LEAVE` 相位器进行评估。这包括`LEAVE` 变体、`KEEP`  和 `UNDO`。`POST` 相位器评估发生在其他所有事情之后，以保证即使是 `LEAVE` 相位器也不会违反后条件。

`LEAVE` phasers for a given block are necessarily evaluated after any `CATCH` and `CONTROL` phasers. This includes the `LEAVE` variants, `KEEP` and `UNDO`. `POST` phasers are evaluated after everything else, to guarantee that even `LEAVE` phasers can't violate postconditions.

从 `ENTER` 相位器抛出的异常将中止 `ENTER` 队列，但从 `LEAVE` 相位器抛出的异常不会。

An exception thrown from an `ENTER` phaser will abort the `ENTER` queue, but one thrown from a `LEAVE` phaser will not.

如果 `POST` 失败或任何类型的 `LEAVE` 块在堆栈展开时抛出异常，则展开继续并收集要处理的异常。当展开完成时，将从该点抛出所有新异常。

If a `POST` fails or any kind of `LEAVE` block throws an exception while the stack is unwinding, the unwinding continues and collects exceptions to be handled. When the unwinding is completed all new exceptions are thrown from that point.

```Raku
sub answer() {
    LEAVE say „I say after the return value.“;
 
    42 # this is the return value 
}
```

**注：**要注意 `LEAVE` 相位器直接出现在例程代码块中，因为即使试图用错误的参数调用例程，它们也会被执行：

**Note:** be mindful of `LEAVE` phasers directly in blocks of routines, as they will get executed even when an attempt to call the routine with wrong arguments is made:

```Raku
sub foo (Int) {
    say "Hello!";
    LEAVE say "oh noes!"
}
try foo rand; # OUTPUT: «oh noes!␤»
```

尽管子例程的主体没有运行，因为子例程期望有一个 [Int](https://docs.raku.org/type/Int) 和 [`rand`](https://docs.raku.org/routine/rand) 并返回一个 [Num](https://docs.raku.org/type/Num)，进入代码块后就离开了(当参数绑定失败时)，所以 `LEAVE` 相位器被运行了。

Although the subroutine's body did not get run, because the sub expects an [Int](https://docs.raku.org/type/Int) and [`rand`](https://docs.raku.org/routine/rand) returned a [Num](https://docs.raku.org/type/Num), its block was entered and left (when param binding failed), and so the `LEAVE` phaser *was* run.

<a id="keep"></a>
## KEEP

在每个成功的代码块出口处运行，作为 LEAVE 队列的一部分（共享相同的执行顺序）。

Runs at every successful block exit, as part of the LEAVE queue (shares the same order of execution).

<a id="undo"></a>
## UNDO

在每个未成功的代码块出口处运行，作为 LEAVE 队列的一部分(共享相同的执行顺序)。

Runs at every unsuccessful block exit, as part of the LEAVE queue (shares the same order of execution).

<a id="pre"></a>
## PRE

在每个代码块入口断言一个先决条件。在 ENTER 阶段之前运行。

Asserts a precondition at every block entry. Runs before the ENTER phase.

`PRE` 相位器在任何 `ENTER` 或 `FIRST` 之前发射。

`PRE` phasers fire off before any `ENTER` or `FIRST`.

The exceptions thrown by failing `PRE` and `POST` phasers cannot be caught by a `CATCH` in the same block, which implies that `POST` phaser are not run if a `PRE` phaser fails.

<a id="post"></a>
## POST

在每个代码块条目中断言一个后置条件。在 LEAVE 阶段之后。

Asserts a postcondition at every block entry. Runs after the LEAVE phase.

对于正常退出范围时运行的 `KEEP` 和 `POST` 等相位器，该范围的返回值（如果有的话）可作为相位器中的当前主题。

For phasers such as `KEEP` and `POST` that are run when exiting a scope normally, the return value (if any) from that scope is available as the current topic within the phaser.

`POST` 块可以通过两种方式之一进行定义。相应的 `POST` 被定义为单独的相位器，在这种情况下，`PRE` 和 `POST` 不共享词法范围。或者，任何 `PRE` 相位器都可以将其相应的 `POST` 定义为在 `PRE` 的词法范围上关闭的嵌入式相位块。

The `POST` block can be defined in one of two ways. Either the corresponding `POST` is defined as a separate phaser, in which case `PRE` and `POST` share no lexical scope. Alternately, any `PRE` phaser may define its corresponding `POST` as an embedded phaser block that closes over the lexical scope of the `PRE`.

如果 `POST` 失败或任何类型的 `LEAVE` 块在堆栈展开时抛出异常，则展开继续并收集要处理的异常。当展开完成时，将从该点抛出所有新异常。

If a `POST` fails or any kind of `LEAVE` block throws an exception while the stack is unwinding, the unwinding continues and collects exceptions to be handled. When the unwinding is completed all new exceptions are thrown from that point.

失败的 `PRE` 和 `POST` 相位器引发的异常不能被同一块中的 `CATCH` 捕获，这意味着如果 `PRE` 相位器失败，就不会运行 `POST` 相位器。

The exceptions thrown by failing `PRE` and `POST` phasers cannot be caught by a `CATCH` in the same block, which implies that `POST` phaser are not run if a `PRE` phaser fails.

<a id="循环相位器--loop-phasers"></a>
# 循环相位器 / Loop phasers

`FIRST`、`NEXT` 和 `LAST` 只有在循环的词法范围内才有意义，并且只能发生在这种循环块的顶层。

`FIRST`, `NEXT`, and `LAST` are meaningful only within the lexical scope of a loop, and may occur only at the top level of such a loop block.

<a id="first"></a>
## FIRST

在 ENTER 之前，在循环初始化时运行。

Runs at loop initialization, before ENTER.

<a id="next"></a>
## NEXT

在 LEAVE 之前，当循环继续运行时（或者通过 `next`，或者因为你到达循环的底部并继续循环）。

Runs when loop is continued (either through `next` or because you got to the bottom of the loop and are looping back around), before LEAVE.

只有当循环块的结束正常到达或执行显式 `next` 时，`NEXT` 才会执行。与 `LEAVE` 不同，如果循环块通过 `next` 抛出的控制异常以外的任何异常退出，则不执行 `NEXT` 相位器。特别是，`last` 绕过了 `NEXT` 相位器。

A `NEXT` executes only if the end of the loop block is reached normally, or an explicit `next` is executed. In distinction to `LEAVE` phasers, a `NEXT` phaser is not executed if the loop block is exited via any exception other than the control exception thrown by `next`. In particular, a `last` bypasses evaluation of `NEXT` phasers.

<a id="last"></a>
## LAST

当一个循环由于满足条件而结束时，或者当它使用 `last` 或 `return` 退出时运行；它在 `LEAVE` 之后执行。

Runs when a loop is finished because the condition is met, or when it exits using `last` or `return`; it is executed after `LEAVE`.

<a id="异常处理相位器--exception-handling-phasers"></a>
# 异常处理相位器 / Exception handling phasers

<a id="catch"></a>
## CATCH

当当前代码块在 LEAVE 阶段之前引发异常时运行。

Runs when an exception is raised by the current block, before the LEAVE phase.

<a id="control"></a>
## CONTROL

当控制异常由当前代码块引发时，在离开阶段之前运行。由 `return`、 `fail`、 `redo`、 `next`、 `last`、 `done`、 `emit`、 `take`、 `warn`、 `proceed` 和 `succeed` 抛出。

Runs when a control exception is raised by the current block, before the LEAVE phase. It is raised by `return`, `fail`, `redo`, `next`, `last`, `done`, `emit`, `take`, `warn`, `proceed` and `succeed`.

```Raku
say elems gather {
    CONTROL {
        when CX::Warn { say "WARNING!!! $_"; .resume }
        when CX::Take { say "Don't take my stuff"; .resume }
        when CX::Done { say "Done"; .resume }
    }
    warn 'people take stuff here';
    take 'keys';
    done;
}
# OUTPUT: 
# WARNING!!! people take stuff here 
# Don't take my stuff 
# Done 
# 0
```

<a id="对象相位器--object-phasers"></a>
# 对象相位器 / Object phasers

<a id="compose-尚未实施--compose-not-yet-implemented"></a>
## COMPOSE (尚未实施) / COMPOSE (Not yet implemented)

将角色合成类时运行。

Runs when a role is composed into a class.

<a id="异步相位器--asynchronous-phasers"></a>
# 异步相位器 / Asynchronous phasers

<a id="last-1"></a>
## LAST

当一个 [Supply](https://docs.raku.org/type/Supply) 以调用 `done` 结束，或者当一个 `supply` 代码块正常退出时运行。`whenever` 代码块后运行，它被放置在完成前。

Runs when a [Supply](https://docs.raku.org/type/Supply) finishes with a call to `done` or when a `supply` block exits normally. It runs completely after the `whenever` block it is placed within finishes.

此相位器重复使用名称 `LAST`，但其工作方式与 `LAST` 循环相位器不同。此相位器类似于设置 `done` 例程，同时使用 `tap` 消费 supply。

This phaser reuses the name `LAST`, but works differently from the `LAST` loop phaser. This phaser is similar to setting the `done` routine while tapping a supply with `tap`.

<a id="quit"></a>
## QUIT

当 [Supply](https://docs.raku.org/type/Supply) 在异常情况下提前终止时运行。它运行在 `whenever` 代码块之后，它被放置在完成之前。

Runs when a [Supply](https://docs.raku.org/type/Supply) terminates early with an exception. It runs after the `whenever` block it is placed within finishes.

这个相位类似于设置 `quit` 例程，同时使用 `tap` 消费 supply。

This phaser is similar to setting the `quit` routine while tapping a Supply with `tap`.

<a id="close"></a>
## CLOSE

出现在 supply 代码块。当 supply 关闭时调用。

Appears in a supply block. Called when the supply is closed.

<a id="doc-相位器--doc-phasers"></a>
# DOC 相位器 / DOC phasers

<a id="doc"></a>
## DOC

`BEGIN` 、`CHECK` 和 `INIT` 只有在以 `DOC` 关键字作为前缀的文档模式下才能运行。当使用 `--doc` 运行时，编译器会在文档中。

The phasers `BEGIN`, `CHECK` and `INIT` are run only in documentation mode when prefixed with the `DOC` keyword. The compiler is in documentation when run with `--doc`.

```Raku
DOC INIT { say 'init'  }  # prints 'init' at initialization time when in documentation mode.
```
