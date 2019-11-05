原文：https://docs.raku.org/language/concurrency

# 并发 / Concurrency

并发与异步编程

Concurrency and asynchronous programming

与大多数现代编程语言一样，Perl 6 被设计为支持并行、异步和 [并发](https://en.wikipedia.org/wiki/Concurrent_computing)。并行性是指同时做多件事。*异步编程*有时被称为事件驱动或反应式编程，它是关于支持由程序中其他地方触发的事件引起的程序流更改。最后，并发性是关于一些共享资源的访问和修改的协调。

In common with most modern programming languages, Perl 6 is designed to support parallelism, asynchronicity and [concurrency](https://en.wikipedia.org/wiki/Concurrent_computing). Parallelism is about doing multiple things at once. *Asynchronous programming*, which is sometimes called event driven or reactive programming, is about supporting changes in the program flow caused by events triggered elsewhere in the program. Finally, concurrency is about the coordination of access and modification of some shared resources.

Perl 6 并发设计的目的是通过下面描述的各种功能层，提供一个高级、可组合和一致的接口，不管虚拟机如何为特定的操作系统实现它。

The aim of the Perl 6 concurrency design is to provide a high-level, composable and consistent interface, regardless of how a virtual machine may implement it for a particular operating system, through layers of facilities as described below.

此外，某些 Perl 功能可能以异步方式隐式操作，因此为了确保与这些功能的可预测互操作，用户代码应尽可能避免较低级别的并发 API（例如，[Thread](https://docs.raku.org/type/Thread) 和 [Scheduler](https://docs.raku.org/type/Scheduler))，并使用更高级的接口。

Additionally, certain Perl features may implicitly operate in an asynchronous fashion, so in order to ensure predictable interoperation with these features, user code should, where possible, avoid the lower level concurrency APIs (e.g., [Thread](https://docs.raku.org/type/Thread) and [Scheduler](https://docs.raku.org/type/Scheduler)) and use the higher-level interfaces.

# 目录 / Table of Contents

<!-- MarkdownTOC -->

- [高级接口 / High-level APIs](#%E9%AB%98%E7%BA%A7%E6%8E%A5%E5%8F%A3--high-level-apis)
    - [承诺 / Promises](#%E6%89%BF%E8%AF%BA--promises)
    - [Supplies](#supplies)
        - [`whenever`](#whenever)
        - [`react`](#react)
        - [转换 supply / Transforming supplies](#%E8%BD%AC%E6%8D%A2-supply--transforming-supplies)
        - [结束一个 supply / Ending a supply](#%E7%BB%93%E6%9D%9F%E4%B8%80%E4%B8%AA-supply--ending-a-supply)
        - [supply 或者 react 代码块中的相位器 / Phasers in a supply or react block](#supply-%E6%88%96%E8%80%85-react-%E4%BB%A3%E7%A0%81%E5%9D%97%E4%B8%AD%E7%9A%84%E7%9B%B8%E4%BD%8D%E5%99%A8--phasers-in-a-supply-or-react-block)
    - [Channels](#channels)
    - [Proc::Async](#procasync)
- [低级 API / Low-level APIs](#%E4%BD%8E%E7%BA%A7-api--low-level-apis)
    - [线程 / Threads](#%E7%BA%BF%E7%A8%8B--threads)
    - [调度器 / Schedulers](#%E8%B0%83%E5%BA%A6%E5%99%A8--schedulers)
        - [线程池调度器 / ThreadPoolScheduler](#%E7%BA%BF%E7%A8%8B%E6%B1%A0%E8%B0%83%E5%BA%A6%E5%99%A8--threadpoolscheduler)
        - [当前线程调度器 / CurrentThreadScheduler](#%E5%BD%93%E5%89%8D%E7%BA%BF%E7%A8%8B%E8%B0%83%E5%BA%A6%E5%99%A8--currentthreadscheduler)
    - [锁 / Locks](#%E9%94%81--locks)
- [安全考虑 / Safety concerns](#%E5%AE%89%E5%85%A8%E8%80%83%E8%99%91--safety-concerns)

<!-- /MarkdownTOC -->


<a id="%E9%AB%98%E7%BA%A7%E6%8E%A5%E5%8F%A3--high-level-apis"></a>
# 高级接口 / High-level APIs

<a id="%E6%89%BF%E8%AF%BA--promises"></a>
## 承诺 / Promises

[Promise](https://docs.raku.org/type/Promise)（在其他编程环境中也叫做 *future*）封装了在获得 promise 时可能尚未完成或甚至尚未开始的计算结果。 `Promise` 从 `Planned` 状态开始，结果可能是 `Kept` 状态，意味着该 promise 已成功完成，或者 `Broken` 状态，意味着该 promise 失败。通常，这是用户代码需要以并发或异步方式操作的大部分功能。

A [Promise](https://docs.raku.org/type/Promise) (also called *future* in other programming environments) encapsulates the result of a computation that may not have completed or even started at the time the promise is obtained. A `Promise` starts from a `Planned` status and can result in either a `Kept` status, meaning the promise has been successfully completed, or a `Broken` status meaning that the promise has failed. Usually this is much of the functionality that user code needs to operate in a concurrent or asynchronous manner.

```Perl6
my $p1 = Promise.new;
say $p1.status;         # OUTPUT: «Planned␤» 
$p1.keep('Result');
say $p1.status;         # OUTPUT: «Kept␤» 
say $p1.result;         # OUTPUT: «Result␤» 
                        # (since it has been kept, a result is available!) 

my $p2 = Promise.new;
$p2.break('oh no');
say $p2.status;         # OUTPUT: «Broken␤» 
say $p2.result;         # dies, because the promise has been broken 
CATCH { default { say .^name, ': ', .Str } };
# OUTPUT: «X::AdHoc+{X::Promise::Broken}: oh no␤» 
```

Promise 强大在于它的可组合特性，例如通过链式调用，通常通过 [then](https://docs.raku.org/type/Promise#method_then) 方法：

Promises gain much of their power by being composable, for example by chaining, usually by the [then](https://docs.raku.org/type/Promise#method_then) method:

```Perl6
my $promise1 = Promise.new();
my $promise2 = $promise1.then(
    -> $v { say $v.result; "Second Result" }
);
$promise1.keep("First Result");
say $promise2.result;   # OUTPUT: «First Result␤Second Result␤» 
```

这里的 [then](https://docs.raku.org/type/Promise#method_then) 方法参数中的代码会在第一个 [Promise](https://docs.raku.org/type/Promise) 被 kept 或者 broken 时执行，其本身返回一个新的 [Promise](https://docs.raku.org/type/Promise)，当代码执行成功并返回结果时 Promise 为 Kept 状态 （如果代码失败则为 broken 状态）。 `keep` 方法改变 promise 的状态为 `Kept` 并设置 promise 的返回值为 `keep` 的位置参数。 `result` 方法阻塞当前线程的执行直到 promise 状态为 kept 或 broken，如果是 kept 则返回结果（即传给 `keep` 方法的值），否则它将基于传给 `break` 方法的值抛出异常。 后一种行为代码示例：

Here the [then](https://docs.raku.org/type/Promise#method_then) method schedules code to be executed when the first [Promise](https://docs.raku.org/type/Promise) is kept or broken, itself returning a new [Promise](https://docs.raku.org/type/Promise) which will be kept with the result of the code when it is executed (or broken if the code fails). `keep` changes the status of the promise to `Kept` setting the result to the positional argument. `result` blocks the current thread of execution until the promise is kept or broken, if it was kept then it will return the result (that is the value passed to `keep`), otherwise it will throw an exception based on the value passed to `break`. The latter behavior is illustrated with:

```Perl6
my $promise1 = Promise.new();
my $promise2 = $promise1.then(-> $v { say "Handled but : "; say $v.result});
$promise1.break("First Result");
try $promise2.result;
say $promise2.cause;        # OUTPUT: «Handled but : ␤First Result␤» 
```

这里的 `break` 会导致 `then` 代码块在调用起初的 promise 的 `result` 方法时抛出异常，这个异常导致第二个 promise 也 broken， 反过来又导致获取第二个 promise 结果时抛出异常。 实际的 [Exception](https://docs.raku.org/type/Exception) 对象可以通过 `cause` 方法获取。 如果 promise 没有 broken，调用 `cause` 则会抛出 [X::Promise::CauseOnlyValidOnBroken](https://docs.raku.org/type/X::Promise::CauseOnlyValidOnBroken) 异常。

Here the `break` will cause the code block of the `then` to throw an exception when it calls the `result` method on the original promise that was passed as an argument, which will subsequently cause the second promise to be broken, raising an exception in turn when its result is taken. The actual [Exception](https://docs.raku.org/type/Exception) object will then be available from `cause`. If the promise had not been broken `cause` would raise a [X::Promise::CauseOnlyValidOnBroken](https://docs.raku.org/type/X::Promise::CauseOnlyValidOnBroken) exception.

[Promise](https://docs.raku.org/type/Promise) 可以安排在未来的时间自动被 kept：

A [Promise](https://docs.raku.org/type/Promise) can also be scheduled to be automatically kept at a future time:

```Perl6
my $promise1 = Promise.in(5);
my $promise2 = $promise1.then(-> $v { say $v.status; 'Second Result' });
say $promise2.result;
```

promise 的[方法 in](https://docs.raku.org/type/Promise#method_in) 创建一个新的 promise 并且安排一个新任务在不早于提供的秒数时调用其 `keep` 方法，返回新 [Promise](https://docs.raku.org/type/Promise) 对象。

The [method in](https://docs.raku.org/type/Promise#method_in) creates a new promise and schedules a new task to call `keep` on it no earlier than the supplied number of seconds, returning the new [Promise](https://docs.raku.org/type/Promise) object.

promise 非常常用的场景是运行一段代码，代码成功返回则 keep promise，代码退出则 break。 [start 方法](https://docs.raku.org/type/Promise#method_start)为其快捷方式：

A very frequent use of promises is to run a piece of code, and keep the promise once it returns successfully, or break it when the code dies. The [start method](https://docs.raku.org/type/Promise#method_start) provides a shortcut for that:

```Perl6
my $promise = Promise.start(
    { my $i = 0; for 1 .. 10 { $i += $_ }; $i}
);
say $promise.result;    # OUTPUT: «55␤» 
```

promise 的 `result` 方法的返回值就是 start 中代码的返回值。 如果代码失败（则 promise broken），那么 `cause` 方法的返回值就会是抛出的 [Exception](https://docs.raku.org/type/Exception) 对象：

Here the `result` of the promise returned is the value returned from the code. Similarly if the code fails (and the promise is thus broken), then `cause` will be the [Exception](https://docs.raku.org/type/Exception) object that was thrown:

```Perl6
my $promise = Promise.start({ die "Broken Promise" });
try $promise.result;
say $promise.cause;
```

因为这个是非常常用的模式，Perl 6 提供了 start 关键字：

This is considered to be such a commonly required pattern that it is also provided as a keyword:

```Perl6
my $promise = start {
    my $i = 0;
    for 1 .. 10 {
        $i += $_
    }
    $i
}
my $result = await $promise;
say $result;
```

[await](https://docs.raku.org/type/Promise#sub_await) 函数几乎相当于对 `start` 关键字创建的 promise 对象调用 `result` 方法，但是它可以接受一组 promise 并返回每个 promise 的结果：

The subroutine [await](https://docs.raku.org/type/Promise#sub_await) is almost equivalent to calling `result` on the promise object returned by `start` but it will also take a list of promises and return the result of each:

```Perl6
my $p1 = start {
    my $i = 0;
    for 1 .. 10 {
        $i += $_
    }
    $i
};
my $p2 = start {
    my $i = 0;
    for 1 .. 10 {
        $i -= $_
    }
    $i
};
my @result = await $p1, $p2;
say @result;            # OUTPUT: «[55 -55]␤» 
```

Promise 的两个类方法可以融合多个 [Promise](https://docs.raku.org/type/Promise) 对象为一个新 Promise：`allof` 方法返回的 promise 为 kept 状态当参数内的 promise 状态为 kept 或者 broken：

In addition to `await`, two class methods combine several [Promise](https://docs.raku.org/type/Promise) objects into a new promise: `allof` returns a promise that is kept when all the original promises are kept or broken:

```Perl6
my $promise = Promise.allof(
    Promise.in(2),
    Promise.in(3)
);
 
await $promise;
say "All done"; # Should be not much more than three seconds later 
```

`anyof` 方法返回的 promise 为 kept 状态当参数内任一 promise 状态为 kept 或者 broken：

And `anyof` returns a new promise that will be kept when any of the original promises is kept or broken:

```Perl6
my $promise = Promise.anyof(
    Promise.in(3),
    Promise.in(8600)
);
 
await $promise;
say "All done"; # Should be about 3 seconds later 
```

然而，与 `await` 不同，原始 kept 的 promise 的结果在没有引用原始版本的情况下是得不到的，因此当任务的完成或其他任务对于使用者而言比实际结果更重要时，或者当结果已被其他方式收集。 例如，你可能希望创建一个依赖的 Promise 来检查每个原始的 promise：

Unlike `await` however the results of the original kept promises are not available without referring to the original, so these are more useful when the completion or otherwise of the tasks is more important to the consumer than the actual results, or when the results have been collected by other means. You may, for example, want to create a dependent Promise that will examine each of the original promises:

```Perl6
my @promises;
for 1..5 -> $t {
    push @promises, start {
        sleep $t;
        Bool.pick;
    };
}
say await Promise.allof(@promises).then({ so all(@promises>>.result) });
```

当所有的 promise 都 kept 时为真，否则为假。

Which will give True if all of the promises were kept with True, False otherwise.

如果你想创建一个 proimse，它能够 keep 或者 break 它自己，那么你可能不会想这个 promise 在你之前被其他代码不经意地 keep 或者 break。为此，可以使用方法 [vow](https://docs.raku.org/type/Promise#method_vow)，它返回 Vow 对象并且只有这个对象能够使 promise 被 kept 或者 broken。如果试图对这个 promise 调用 keep 或者 break 方法，那么 [X::Promise::Vowed](https://docs.raku.org/type/X::Promise::Vowed) 异常将会被抛出，只要 vow 对象是私有的，promise 的状态就是安全的：

If you are creating a promise that you intend to keep or break yourself then you probably don't want any code that might receive the promise to inadvertently (or otherwise) keep or break the promise before you do. For this purpose there is the [method vow](https://docs.raku.org/type/Promise#method_vow), which returns a Vow object which becomes the only mechanism by which the promise can be kept or broken. If an attempt to keep or break the Promise is made directly then the exception [X::Promise::Vowed](https://docs.raku.org/type/X::Promise::Vowed) will be thrown, as long as the vow object is kept private, the status of the promise is safe:

```Perl6
sub get_promise {
    my $promise = Promise.new;
    my $vow = $promise.vow;
    Promise.in(10).then({$vow.keep});
    $promise;
}

my $promise = get_promise();

# Will throw an exception 
# "Access denied to keep/break this Promise; already vowed" 
$promise.keep;
CATCH { default { say .^name, ': ', .Str } };
# OUTPUT: «X::Promise::Vowed: Access denied to keep/break this Promise; already vowed␤» 
```

使用 `in` 或者 `start` 方法返回的 promise 将会自动变为 kept 或则 broken 状态，因此对这些 promise 使用 vow 方法是不必要的。

The methods that return a promise that will be kept or broken automatically such as `in` or `start` will do this, so it is not necessary to do it for these.

<a id="supplies"></a>
## Supplies

[Supply](https://docs.raku.org/type/Supply) 是异步数据流机制，它能够被一个或者多个消费者同时消费。这种方式类似于其他编程语言的事件。可以视作开启 Perl6 *事件驱动*或者响应式设计。

A [Supply](https://docs.raku.org/type/Supply) is an asynchronous data streaming mechanism that can be consumed by one or more consumers simultaneously in a manner similar to "events" in other programming languages and can be seen as enabling *event driven* or reactive designs.

最简单的，一个 [Supply](https://docs.raku.org/type/Supply) 对象为一个消息流，它能够有多个订阅者，这些订阅者通过方法 `tap` 创建，订阅者的数据项能够被 `emit` 方法的参数替换。

At its simplest, a [Supply](https://docs.raku.org/type/Supply) is a message stream that can have multiple subscribers created with the method `tap` on to which data items can be placed with `emit`.

[Supply](https://docs.raku.org/type/Supply) 可以是 `live` 或者 `on-demand`的。 `live` 就像电视广播：那些刚开始收看的观众看不到播放过的内容。 `on-demand` 广播就像 Netflix 影片租赁公司：所有人都可以点播一个影片（正如 tap 一个 supply），永远可以从头开始看（获取所有的值），不论现在有多少观众。请注意 `on-demand` supply 不会保留历史数据，而是每次 `tap` 时，`supply` 的代码块被执行。

The [Supply](https://docs.raku.org/type/Supply) can either be `live` or `on-demand`. A `live` supply is like a TV broadcast: those who tune in don't get previously emitted values. An `on-demand` broadcast is like Netflix: everyone who starts streaming a movie (taps a supply), always starts it from the beginning (gets all the values), regardless of how many people are watching it right now. Note that no history is kept for `on-demand` supplies, instead, the `supply` block is run for each tap of the supply.

`live` [Supply](https://docs.raku.org/type/Supply) 由 [Supplier](https://docs.raku.org/type/Supplier) 工厂创建，每一个发出的值传递给了所有激活的对 Supply 调用了 tap 方法的代码块。

A `live` [Supply](https://docs.raku.org/type/Supply) is created by the [Supplier](https://docs.raku.org/type/Supplier) factory, each emitted value is passed to all the active tappers as they are added:

```Perl6
my $supplier = Supplier.new;
my $supply   = $supplier.Supply;
 
$supply.tap( -> $v { say $v });
 
for 1 .. 10 {
    $supplier.emit($_);
}
```

请注意，`tap` 方法在 [Supply](https://docs.raku.org/type/Supply) 对象上被调用，这个对象由 [Supplier](https://docs.raku.org/type/Supplier) 创建。新消息由 [Supplier](https://docs.raku.org/type/Supplier) 发出。

Note that the `tap` is called on a [Supply](https://docs.raku.org/type/Supply) object created by the [Supplier](https://docs.raku.org/type/Supplier) and new values are emitted on the [Supplier](https://docs.raku.org/type/Supplier).

`on-demand` [Supply](https://docs.raku.org/type/Supply) 由 `supply` 关键字创建：

An `on-demand` [Supply](https://docs.raku.org/type/Supply) is created by the `supply` keyword:

```Perl6
my $supply = supply {
    for 1 .. 10 {
        emit($_);
    }
}
$supply.tap( -> $v { say $v });
```

在此例中，`supply` 关键字创建的 [Supply](https://docs.raku.org/type/Supply) 对象被 tap 时，supply 代码块中的代码都会被执行。例如：

In this case the code in the supply block is executed every time the [Supply](https://docs.raku.org/type/Supply) returned by `supply` is tapped, as demonstrated by:

```Perl6
my $supply = supply {
    for 1 .. 10 {
        emit($_);
    }
}
$supply.tap( -> $v { say "First : $v" });
$supply.tap( -> $v { say "Second : $v" });
```

`tap` 方法返回一个 [Tap](https://docs.raku.org/type/Tap) 对象，这个对象可以用来获取 tap 的信息，当我们对事件不感兴趣时也可以关闭它：

The `tap` method returns a [Tap](https://docs.raku.org/type/Tap) object which can be used to obtain information about the tap and also to turn it off when we are no longer interested in the events:

```Perl6
my $supplier = Supplier.new;
my $supply   = $supplier.Supply;
 
my $tap = $supply.tap( -> $v { say $v });
 
$supplier.emit("OK");
$tap.close;
$supplier.emit("Won't trigger the tap");
```

在 supply 代码块中调用 `done` 函数会执行 tap 中定义的 `done` 回调，但是它不会阻止以后的事件被发射到数据流，或者阻止 tap 接收事件。

Calling `done` on the supply object calls the `done` callback that may be specified for any taps, but does not prevent any further events being emitted to the stream, or taps receiving them.

`interval` 方法会创建一个 `on-demand` supply，它会在指定间隔定期释放一个新事件。每个释放的事件带的数据是从 0 开始递增的整数。 下列代码输出 0 .. 5 ：

The method `interval` returns a new `on-demand` supply which periodically emits a new event at the specified interval. The data that is emitted is an integer starting at 0 that is incremented for each event. The following code outputs 0 .. 5 :

```Perl6
my $supply = Supply.interval(2);
$supply.tap(-> $v { say $v });
sleep 10;
```

`interval` 方法接受第二参数，它表示第一个事件发出之前延迟的秒数。每个 `interval` 方法创建出来的 supply，其每个 tap 都有自己从 0 开始的序列，例如：

A second argument can be supplied to `interval` which specifies a delay in seconds before the first event is fired. Each tap of a supply created by `interval` has its own sequence starting from 0, as illustrated by the following:

```Perl6
my $supply = Supply.interval(2);
$supply.tap(-> $v { say "First $v" });
sleep 6;
$supply.tap(-> $v { say "Second $v"});
sleep 10;
```

live `Supply` 保留数据直到第一个被 tap 的 supply 能被 [Supplier::Preserving](https://docs.raku.org/type/Supplier::Preserving) 创建。

A live `Supply` that keeps values until first tapped can be created with [Supplier::Preserving](https://docs.raku.org/type/Supplier::Preserving).

<a id="whenever"></a>
### `whenever`

`whenever` 关键字可以在 supply 或者 react 代码块中使用。 从 6.d 版本开始，需要在他们的词法作用域中被使用。 它引入一个代码块，当它指定的异步事件提示时将运行该代码块。 可以是一个 [Supply](https://docs.raku.org/type/Supply), [Channel](https://docs.raku.org/type/Channel), [Promise](https://docs.raku.org/type/Promise) 或者 [Iterable](https://docs.raku.org/type/Iterable)。

The `whenever` keyword can be used in supply blocks or in react blocks. From the 6.d version, it needs to be used within the lexical scope of them. It introduces a block of code that will be run when prompted by an asynchronous event that it specifies - that could be a [Supply](https://docs.raku.org/type/Supply), a [Channel](https://docs.raku.org/type/Channel), a [Promise](https://docs.raku.org/type/Promise) or an [Iterable](https://docs.raku.org/type/Iterable).

这个例子中我们监听两个 supply：

In this example we are watching two supplies.

```Perl6
my $bread-supplier = Supplier.new;
my $vegetable-supplier = Supplier.new;
 
my $supply = supply {
    whenever $bread-supplier.Supply {
        emit("We've got bread: " ~ $_);
    };
    whenever $vegetable-supplier.Supply {
        emit("We've got a vegetable: " ~ $_);
    };
}
$supply.tap( -> $v { say "$v" });
 
$vegetable-supplier.emit("Radish");   # OUTPUT: «We've got a vegetable: Radish␤» 
$bread-supplier.emit("Thick sliced"); # OUTPUT: «We've got bread: Thick sliced␤» 
$vegetable-supplier.emit("Lettuce");  # OUTPUT: «We've got a vegetable: Lettuce␤» 
```

请注意，`whenever` 中的代码应尽量小，因为任何时候都只有一个 `whenever` 代码块会被执行。

Please note that one should keep the code inside the `whenever` as small as possible, as only one `whenever` block will be executed at any time. One can use a `start` block inside the `whenever` block to run longer running code.

<a id="react"></a>
### `react`

`react` 关键字引入包含一个或者多个 `whenever` 关键字的代码块来监听异步事件。 supply 和 react 代码块之间最主要的区别在于在 react 代码块中的代码按出现的位置运行，而 supply 代码块在做任何事情前都需要被 tap。

The `react` keyword introduces a block of code containing one or more `whenever` keywords to watch asynchronous events. The main difference between a supply block and a react block is that the code in a react block runs where it appears in the code flow, whereas a supply block has to be tapped before it does anything.

另一个区别是 supply 代码块使用时可以不需要 `whenever` 关键字，但是 react 代码块至少需要使用到一个 `whenever` 。

Another difference is that a supply block can be used without the `whenever` keyword, but a react block requires at least one `whenever` to be of any real use.

```Perl6
react {
    whenever Supply.interval(2) -> $v {
        say $v;
        done() if $v == 4;
    }
}
```

`whenever` 关键字使用 [`.act`](https://docs.raku.org/type/Supply#method_act) 方法对 [Supply](https://docs.raku.org/type/Supply) 创建一个 tap。 当 `done()` 函数在其中一个 tap 中被调用时 `react` 代码块会退出。 使用 `last` 关键字退出代码块会收到这不是一个真正的循环结构的错误提示。

Here the `whenever` keyword uses [`.act`](https://docs.raku.org/type/Supply#method_act) to create a tap on the [Supply](https://docs.raku.org/type/Supply) from the provided block. The `react` block is exited when `done()` is called in one of the taps. Using `last` to exit the block would produce an error indicating that it's not really a loop construct.

`on-demand` [Supply](https://docs.raku.org/type/Supply) 也可以从将依次发出的值的列表中创建，因此第一个 `on-demand` 例子可写成：

An `on-demand` [Supply](https://docs.raku.org/type/Supply) can also be created from a list of values that will be emitted in turn, thus the first `on-demand` example could be written as:

```Perl6
react {
    whenever Supply.from-list(1..10) -> $v {
        say $v;
    }
}
```

<a id="%E8%BD%AC%E6%8D%A2-supply--transforming-supplies"></a>
### 转换 supply / Transforming supplies

可以过滤或者转换现有的 supply 对象，分别使用 `grep` 和 `map` 方法，以类似于命名列表方法的方式创建新 supply： `grep` 返回一个 supply ，以便只有在源流上发出的 `grep` 条件为真的事件才会在第二个 supply 上发出。

An existing supply object can be filtered or transformed, using the methods `grep` and `map` respectively, to create a new supply in a manner like the similarly named list methods: `grep` returns a supply such that only those events emitted on the source stream for which the `grep` condition is true is emitted on the second supply:

```Perl6
my $supplier = Supplier.new;
my $supply = $supplier.Supply;

$supply.tap(-> $v { say "Original : $v" });

my $odd_supply = $supply.grep({ $_ % 2 });
$odd_supply.tap(-> $v { say "Odd : $v" });

my $even_supply = $supply.grep({ not $_ % 2 });
$even_supply.tap(-> $v { say "Even : $v" });

for 0 .. 10 {
    $supplier.emit($_);
}
```

` map` 返回一个新的 supply，这样对于发送给原始 supply 的每个条目，条目会传给 `map` 并将表达式的结果作为新条目发送出来。

`map` returns a new supply such that for each item emitted to the original supply a new item which is the result of the expression passed to the `map` is emitted:

```Perl6
my $supplier = Supplier.new;
my $supply = $supplier.Supply;

$supply.tap(-> $v { say "Original : $v" });

my $half_supply = $supply.map({ $_ / 2 });

$half_supply.tap(-> $v { say "Half : $v" });

for 0 .. 10 {
    $supplier.emit($_);
}
```

<a id="%E7%BB%93%E6%9D%9F%E4%B8%80%E4%B8%AA-supply--ending-a-supply"></a>
### 结束一个 supply / Ending a supply

如果需要在 supply 结束时执行某个动作，你可以在 `tap` 方法中设置 `done` 和 `quit` 选项：

If you need to have an action that runs when the supply finishes, you can do so by setting the `done` and `quit` options in the call to `tap`:

```Perl6
$supply.tap: { ... },
    done => { say 'Job is done.' },
    quit => {
        when X::MyApp::Error { say "App Error: ", $_.message }
    };
```

`quit` 的工作方式代码块非常像 `CATCH`。如果异常被 `when` 或者 `default` 代码块标记，异常会被捕获和处理。否则，异常抛给更上一级的调用（与 `quit` 没有设置时表现一样）。

The `quit` block works very similar to a `CATCH`. If the exception is marked as seen by a `when` or `default` block, the exception is caught and handled. Otherwise, the exception continues to up the call tree (i.e., the same behavior as when `quit` is not set).

<a id="supply-%E6%88%96%E8%80%85-react-%E4%BB%A3%E7%A0%81%E5%9D%97%E4%B8%AD%E7%9A%84%E7%9B%B8%E4%BD%8D%E5%99%A8--phasers-in-a-supply-or-react-block"></a>
### supply 或者 react 代码块中的相位器 / Phasers in a supply or react block

如果你在 `react` 或者 `supply` 代码块语法中使用 `whenever`，你可以在 `whenever` 代码块中添加相位器处理来自被 tap 过的 supply 的 `done` 和 `quit` 消息：

If you are using the `react` or `supply` block syntax with `whenever`, you can add phasers within your `whenever` blocks to handle the `done` and `quit` messages from the tapped supply:

```Perl6
react {
    whenever $supply {
        ...; # your usual supply tap code here 
        LAST { say 'Job is done.' }
        QUIT { when X::MyApp::Error { say "App Error: ", $_.message } }
    }
}
```

此处的行为与对 `tap` 设置 `done` 和 `quit` 一样。

The behavior here is the same as setting `done` and `quit` on `tap`.

<a id="channels"></a>
## Channels

[Channel](https://docs.raku.org/type/Channel) 是一个线程安全的队列，可以有多个读取器和编写器，可以被认为在操作上类似于 FIFO 或命名管道，除了它不启用进程间通信。应该注意的是，作为一个真正的队列，发送到 [Channel](https://docs.raku.org/type/Channel) 的每个值只能先读先服务的基础上供单个阅读器使用：如果你希望多个读者能够接收发送的每个项目，你可能需要考虑 [Supply](https://docs.raku.org/type/Supply)。

A [Channel](https://docs.raku.org/type/Channel) is a thread-safe queue that can have multiple readers and writers that could be considered to be similar in operation to a "fifo" or named pipe except it does not enable inter-process communication. It should be noted that, being a true queue, each value sent to the [Channel](https://docs.raku.org/type/Channel) will only be available to a single reader on a first read, first served basis: if you want multiple readers to be able to receive every item sent you probably want to consider a [Supply](https://docs.raku.org/type/Supply).

使用方法 [send](https://docs.raku.org/type/Channel) 将条目排队到 [Channel](https://docs.raku.org/type/Channel) 上， 方法 [receive](https://docs.raku.org/type/Channel#method_receive) 从队列中删除一个条目并将其返回，如果队列为空则阻塞直到新条目被发出：

An item is queued onto the [Channel](https://docs.raku.org/type/Channel) with the [method send](https://docs.raku.org/type/Channel#method_send), and the [method receive](https://docs.raku.org/type/Channel#method_receive) removes an item from the queue and returns it, blocking until a new item is sent if the queue is empty:

```Perl6
my $channel = Channel.new;
$channel.send('Channel One');
say $channel.receive;  # OUTPUT: «Channel One␤» 
```

如果 channel 被 [close](https://docs.raku.org/type/Channel#method_close) 方法关闭，那么任何 `send` 方法都会抛出 [X::Channel::SendOnClosed](https://docs.raku.org/type/X::Channel::SendOnClosed) 异常并且 `receive` 方法会抛出 [X::Channel::ReceiveOnClosed](https://docs.raku.org/type/X::Channel::ReceiveOnClosed) 异常如果队列中已没有条目。

If the channel has been closed with the [method close](https://docs.raku.org/type/Channel#method_close) then any `send` will cause the exception [X::Channel::SendOnClosed](https://docs.raku.org/type/X::Channel::SendOnClosed) to be thrown, and a `receive` will throw a [X::Channel::ReceiveOnClosed](https://docs.raku.org/type/X::Channel::ReceiveOnClosed) if there are no more items on the queue.

[list](https://docs.raku.org/type/Channel#method_list) 方法返回 [Channel](https://docs.raku.org/type/Channel) 中所有的条目，并且将阻塞程序直到新条目在队列中，除非该 channel 已关闭。

The [method list](https://docs.raku.org/type/Channel#method_list) returns all the items on the [Channel](https://docs.raku.org/type/Channel) and will block until further items are queued unless the channel is closed:

```Perl6
my $channel = Channel.new;
await (^10).map: -> $r {
    start {
        sleep $r;
        $channel.send($r);
    }
}
$channel.close;
for $channel.list -> $r {
    say $r;
}
```

非阻塞方法 [poll](https://docs.raku.org/type/Channel#method_poll) 从 channel  中返回一个可用项，没有可用项或者 channel 被关闭则返回 [Nil](https://docs.raku.org/type/Nil)。这当然意味着必须检查 channel 以确定它是否关闭。

There is also the non-blocking [method poll](https://docs.raku.org/type/Channel#method_poll) that returns an available item from the channel or [Nil](https://docs.raku.org/type/Nil) if there is no item or the channel is closed, this does of course mean that the channel must be checked to determine whether it is closed:

```Perl6
my $c = Channel.new;
 
# Start three Promises that sleep for 1..3 seconds, and then 
# send a value to our Channel 
^3 .map: -> $v {
    start {
        sleep 3 - $v;
        $c.send: "$v from thread {$*THREAD.id}";
    }
}
 
# Wait 3 seconds before closing the channel 
Promise.in(3).then: { $c.close }
 
# Continuously loop and poll the channel, until it's closed 
my $is-closed = $c.closed;
loop {
    if $c.poll -> $item {
        say "$item received after {now - INIT now} seconds";
    }
    elsif $is-closed {
        last;
    }
 
    say 'Doing some unrelated things...';
    sleep .6;
}
 
# Doing some unrelated things... 
# Doing some unrelated things... 
# 2 from thread 5 received after 1.2063182 seconds 
# Doing some unrelated things... 
# Doing some unrelated things... 
# 1 from thread 4 received after 2.41117376 seconds 
# Doing some unrelated things... 
# 0 from thread 3 received after 3.01364461 seconds 
# Doing some unrelated things... 
```


[closed](https://docs.raku.org/type/Channel#method_closed) 方法返回一个 [Promise](https://docs.raku.org/type/Promise) 对象，channel 关闭时这个对象在 channel 被关闭时状态为 kept （此时对象在布尔上下文中为真值）。

The [method closed](https://docs.raku.org/type/Channel#method_closed) returns a [Promise](https://docs.raku.org/type/Promise) that will be kept (and consequently will evaluate to True in a boolean context) when the channel is closed.

`.poll` 方法可以与 `.receive` 方法结合使用作为缓存机制，`.poll` 没有返回值时表示需要将更多的加载至 channel：

The `.poll` method can be used in combination with `.receive` method, as a caching mechanism where lack of value returned by `.poll` is a signal that more values need to be fetched and loaded into the channel:

```Perl6
sub get-value {
    return $c.poll // do { start replenish-cache; $c.receive };
}
 
sub replenish-cache {
    for ^20 {
        $c.send: $_ for slowly-fetch-a-thing();
    }
}
```

Channel 可以取代 `whenever` 在 `react` 代码块中的位置：

Channels can be used in place of the [Supply](https://docs.raku.org/type/Supply) in the `whenever` of a `react` block described earlier:

```Perl6
my $channel = Channel.new;
my $p = start {
    react {
        whenever $channel {
            say $_;
        }
    }
}
 
await (^10).map: -> $r {
    start {
        sleep $r;
        $channel.send($r);
    }
}
 
$channel.close;
await $p;
```

也可以从 [Supply](https://docs.raku.org/type/Supply) 对象中使用 [Channel](https://docs.raku.org/type/Supply#method_Channel) 方法获取 [Channel](https://docs.raku.org/type/Channel) 对象。 这个 Channel 对象由 [Supply](https://docs.raku.org/type/Supply) 的 `tap` 提供供给。

It is also possible to obtain a [Channel](https://docs.raku.org/type/Channel) from a [Supply](https://docs.raku.org/type/Supply) using the [Channel method](https://docs.raku.org/type/Supply#method_Channel) which returns a [Channel](https://docs.raku.org/type/Channel) which is fed by a `tap`on the [Supply](https://docs.raku.org/type/Supply):

```Perl6
my $supplier = Supplier.new;
my $supply   = $supplier.Supply;
my $channel = $supply.Channel;
 
my $p = start {
    react  {
        whenever $channel -> $item {
            say "via Channel: $item";
        }
    }
}
 
await (^10).map: -> $r {
    start {
        sleep $r;
        $supplier.emit($r);
    }
}
 
$supplier.done;
await $p;
```

`Channel` 方法会返回一个不同的 [Channel](https://docs.raku.org/type/Channel) 对象，每次调用时会被提供同样的数据。这可以用来扇出 [Supply](https://docs.raku.org/type/Supply) 给一个或者多个 [Channel](https://docs.raku.org/type/Channel) 来在一个程序中提供不同的接口。

`Channel` will return a different [Channel](https://docs.raku.org/type/Channel) fed with the same data each time it is called. This could be used, for instance, to fan-out a [Supply](https://docs.raku.org/type/Supply) to one or more [Channel](https://docs.raku.org/type/Channel)s to provide for different interfaces in a program.

<a id="procasync"></a>
## Proc::Async

[Proc::Async](https://docs.raku.org/type/Proc::Async) 类用来异步运行外部程序以及与外部程序交互：

[Proc::Async](https://docs.raku.org/type/Proc::Async) builds on the facilities described to run and interact with an external program asynchronously:

```Perl6
my $proc = Proc::Async.new('echo', 'foo', 'bar');
 
$proc.stdout.tap(-> $v { print "Output: $v" });
$proc.stderr.tap(-> $v { print "Error:  $v" });
 
say "Starting...";
my $promise = $proc.start;
 
await $promise;
say "Done.";
 
# Output: 
# Starting... 
# Output: foo bar 
# Done. 
```

命令的路径以及任何参数可以提供给构造器。当 [start](https://docs.raku.org/type/Proc::Async#method_start) 方法被调用时命令才会执行，这个方法返回一个在命令退出时状态为 kept 的 [Promise](https://docs.raku.org/type/Promise)对象。程序的标准输出和标准错误管道就是 [Supply](https://docs.raku.org/type/Supply) 对象，可分别通过 Proc::Async 的 [stdout](https://docs.raku.org/type/Proc::Async#method_stdout) 以及 [stderr](https://docs.raku.org/type/Proc::Async#method_stderr) 方法获得，这些 Supply 对象可按需通过 `tap` 方法使用。

The path to the command as well as any arguments to the command are supplied to the constructor. The command will not be executed until [start](https://docs.raku.org/type/Proc::Async#method_start) is called, which will return a [Promise](https://docs.raku.org/type/Promise) that will be kept when the program exits. The standard output and standard error of the program are available as [Supply](https://docs.raku.org/type/Supply) objects from the methods [stdout](https://docs.raku.org/type/Proc::Async#method_stdout) and [stderr](https://docs.raku.org/type/Proc::Async#method_stderr) respectively which can be tapped as required.

如果你想要对程序的标准输入进行写入，你可以给 Proc::Async 构造器加上 `:w` 动词并且在命令程序开始运行后使用 [write](https://docs.raku.org/type/Proc::Async#method_write)，[print](https://docs.raku.org/type/Proc::Async#method_print) 或者 [say](https://docs.raku.org/type/Proc::Async#method_say) 方法向打开的管道写入：

If you want to write to the standard input of the program you can supply the `:w` adverb to the constructor and use the methods [write](https://docs.raku.org/type/Proc::Async#method_write), [print](https://docs.raku.org/type/Proc::Async#method_print) or [say](https://docs.raku.org/type/Proc::Async#method_say) to write to the opened pipe once the program has been started:

```Perl6
my $proc = Proc::Async.new(:w, 'grep', 'foo');
 
$proc.stdout.tap(-> $v { print "Output: $v" });
 
say "Starting...";
my $promise = $proc.start;
 
$proc.say("this line has foo");
$proc.say("this one doesn't");
 
$proc.close-stdin;
await $promise;
say "Done.";
 
# Output: 
# Starting... 
# Output: this line has foo 
# Done. 
```

有些程序（例如此例中未加文件参数的 `grep`）不会退出知道他们的标准输入管道被关闭。因此在完成写入后可以调用 [close-stdin](https://docs.raku.org/type/Proc::Async#method_close-stdin) 方法用来关闭程序的标准输入使得 `start` 方法返回的 [Promise](https://docs.raku.org/type/Promise) 对象为 kept 状态。

Some programs (such as `grep` without a file argument in this example, ) won't exit until their standard input is closed so [close-stdin](https://docs.raku.org/type/Proc::Async#method_close-stdin) can be called when you are finished writing to allow the [Promise](https://docs.raku.org/type/Promise) returned by `start` to be kept.

<a id="%E4%BD%8E%E7%BA%A7-api--low-level-apis"></a>
# 低级 API / Low-level APIs

<a id="%E7%BA%BF%E7%A8%8B--threads"></a>
## 线程 / Threads

最底层的并发接口由 [Thread](https://docs.raku.org/type/Thread) 提供。一个线程可以认为是一段最终会运行在一个处理器上的代码，它的调度几乎完全由虚拟机和/或操作系统进行安排。线程大都是不受管理的。不管出于什么目的，线程应该考虑避免在用户代码中直接使用线程。

The lowest level interface for concurrency is provided by [Thread](https://docs.raku.org/type/Thread). A thread can be thought of as a piece of code that may eventually be run on a processor, the arrangement for which is made almost entirely by the virtual machine and/or operating system. Threads should be considered, for all intents, largely un-managed and their direct use should be avoided in user code.

线程既可以先创建稍后实际运行

A thread can either be created and then actually run later:

```Perl6
my $thread = Thread.new(code => { for  1 .. 10  -> $v { say $v }});
# ... 
$thread.run;
```

或者可以在单个调用中创建和运行

Or can be created and run at a single invocation:

```Perl6
my $thread = Thread.start({ for  1 .. 10  -> $v { say $v }});
```

两种情形中，在调用 `finish` 方法后线程都会阻塞并且等待 [Thread](https://docs.raku.org/type/Thread) 对象封装的代码执行完成：

In both cases the completion of the code encapsulated by the [Thread](https://docs.raku.org/type/Thread) object can be waited on with the `finish` method which will block until the thread completes:

```Perl6
$thread.finish;
```

除此之外，没有进一步的同步或资源共享工具，我们强调线程不可能直接在用户代码中有用，这是主要原因。

Beyond that there are no further facilities for synchronization or resource sharing which is largely why it should be emphasized that threads are unlikely to be useful directly in user code.

<a id="%E8%B0%83%E5%BA%A6%E5%99%A8--schedulers"></a>
## 调度器 / Schedulers

实现了角色 [Scheduler](https://docs.raku.org/type/Scheduler) 中定义的接口的类提供并发 API 的下一个级别。调度器接口的目的是提供一种机制，以确定运行特定任务所需的资源以及何时运行该任务。大多数高级并发 API 都是建立在调度器上的，用户代码可能根本不需要使用它们。尽管有些在 [Proc::Async](https://docs.raku.org/type/Proc::Async)，[Promise](https://docs.raku.org/type/Promise) 以及 [Supply](https://docs.raku.org/type/Supply) 中的方法允许你显式地提供一个调度器。

The next level of the concurrency API is supplied by classes that implement the interface defined by the role [Scheduler](https://docs.raku.org/type/Scheduler). The intent of the scheduler interface is to provide a mechanism to determine which resources to use to run a particular task and when to run it. The majority of the higher level concurrency APIs are built upon a scheduler and it may not be necessary for user code to use them at all, although some methods such as those found in [Proc::Async](https://docs.raku.org/type/Proc::Async), [Promise](https://docs.raku.org/type/Promise) and [Supply](https://docs.raku.org/type/Supply) allow you to explicitly supply a scheduler.

当前默认全局计划程序在变量 `$*SCHEDULER` 中可用。

The current default global scheduler is available in the variable `$*SCHEDULER`.

调度程序的主接口（实际上是 [Scheduler](https://docs.raku.org/type/Scheduler) 接口所需的唯一方法）是 `cue` 方法：

The primary interface of a scheduler (indeed the only method required by the [Scheduler](https://docs.raku.org/type/Scheduler) interface) is the `cue` method:

```Perl6
method cue(:&code, Instant :$at, :$in, :$every, :$times = 1; :&catch)
```

这将在 `&code` 中安排 [Callable](https://docs.raku.org/type/Callable) 以副词确定的方式执行（如 [Scheduler](https://docs.raku.org/type/Scheduler) 中所述），使用调度器实现的执行方案。例如：

This will schedule the [Callable](https://docs.raku.org/type/Callable) in `&code` to be executed in the manner determined by the adverbs (as documented in [Scheduler](https://docs.raku.org/type/Scheduler)) using the execution scheme as implemented by the scheduler. For example:

```Perl6
my $i = 0;
my $cancellation = $*SCHEDULER.cue({ say $i++}, every => 2 );
sleep 20;
```

假设 `$*SCHEDULER` 没有从默认值更改，大约每两秒钟打印一次数字 0 到 10 （即操作系统调度容差）。在这种情况下，代码将按计划运行，直到程序正常结束，但是该方法返回一个 [Cancellation](https://docs.raku.org/type/Cancellation) 对象，可用于在正常完成之前取消计划的执行：

Assuming that the `$*SCHEDULER` hasn't been changed from the default, will print the numbers 0 to 10 approximately (i.e with operating system scheduling tolerances) every two seconds. In this case the code will be scheduled to run until the program ends normally, however the method returns a [Cancellation](https://docs.raku.org/type/Cancellation) object which can be used to cancel the scheduled execution before normal completion:

```Perl6
my $i = 0;
my $cancellation = $*SCHEDULER.cue({ say $i++}, every => 2 );
sleep 10;
$cancellation.cancel;
sleep 10;
```

应该只输出 0 到 5。

should only output 0 to 5.

尽管 [Scheduler](https://docs.raku.org/type/Scheduler) 接口明显优于 [Thread](https://docs.raku.org/type/Thread) 接口，但所有功能都可以通过更高级别的接口使用，不需要直接使用调度器，除非在上面提到的情况下，调度器可以显式地提供给某些方法。

Despite the apparent advantage the [Scheduler](https://docs.raku.org/type/Scheduler) interface provides over that of [Thread](https://docs.raku.org/type/Thread) all of functionality is available through higher level interfaces and it shouldn't be necessary to use a scheduler directly, except perhaps in the cases mentioned above where a scheduler can be supplied explicitly to certain methods.

如果库有特殊要求它可能希望提供另一种调度器的实现，例如，UI 库可能希望所有代码都在单个 UI 线程内运行，或者可能需要某些自定义优先级机制，但作为标准提供的实现和下面描述的实现应足以满足大多数用户代码。

A library may wish to provide an alternative scheduler implementation if it has special requirements, for instance a UI library may want all code to be run within a single UI thread, or some custom priority mechanism may be required, however the implementations provided as standard and described below should suffice for most user code.

<a id="%E7%BA%BF%E7%A8%8B%E6%B1%A0%E8%B0%83%E5%BA%A6%E5%99%A8--threadpoolscheduler"></a>
### 线程池调度器 / ThreadPoolScheduler

[ThreadPoolScheduler](https://docs.raku.org/type/ThreadPoolScheduler) 是默认的调度器，它维护一个按需分配的线程池，必要时创造新的线程直到最大值，这个值在调度器创建时作为参数传给调度器对象（默认是 16）。 如果超过了最大线程数，那么 `cue` 方法会将代码排队直到有新线程可用。

The [ThreadPoolScheduler](https://docs.raku.org/type/ThreadPoolScheduler) is the default scheduler, it maintains a pool of threads that are allocated on demand, creating new ones as necessary up to maximum number given as a parameter when the scheduler object was created (the default is 16.) If the maximum is exceeded then `cue` may queue the code until such time as a thread becomes available.

Rakudo 允许默认调度器中允许的最大线程数由程序启动时的环境变量 `RAKUDO_MAX_THREADS` 设置。

Rakudo allows the maximum number of threads allowed in the default scheduler to be set by the environment variable `RAKUDO_MAX_THREADS` at the time the program is started.

<a id="%E5%BD%93%E5%89%8D%E7%BA%BF%E7%A8%8B%E8%B0%83%E5%BA%A6%E5%99%A8--currentthreadscheduler"></a>
### 当前线程调度器 / CurrentThreadScheduler

[CurrentThreadScheduler](https://docs.raku.org/type/CurrentThreadScheduler) 是一个非常简单的调度器，调度代码直接运行在当前线程中。对这个调度器调用 `cue` 方法将会阻塞线程直到代码完成，将其效用限制在某些特殊情况下，如测试。

The [CurrentThreadScheduler](https://docs.raku.org/type/CurrentThreadScheduler) is a very simple scheduler that will always schedule code to be run straight away on the current thread. The implication is that `cue` on this scheduler will block until the code finishes execution, limiting its utility to certain special cases such as testing.

<a id="%E9%94%81--locks"></a>
## 锁 / Locks

[Lock](https://docs.raku.org/type/Lock) 类提供底层机制，用来在并行环境中保护共享数据，因此在高级 API 中支持线程安全发挥关键作用。在其他编程语言中有时被称为"互斥锁"。因为更高级别类（[Promise](https://docs.raku.org/type/Promise), [Supply](https://docs.raku.org/type/Supply) 以及 [Channel](https://docs.raku.org/type/Channel）在需要时会使用 [Lock](https://docs.raku.org/type/Lock)，用户没必要直接使用 [Lock](https://docs.raku.org/type/Lock)。

The class [Lock](https://docs.raku.org/type/Lock) provides the low level mechanism that protects shared data in a concurrent environment and is thus key to supporting thread-safety in the high level API, this is sometimes known as a "Mutex" in other programming languages. Because the higher level classes ([Promise](https://docs.raku.org/type/Promise), [Supply](https://docs.raku.org/type/Supply) and [Channel](https://docs.raku.org/type/Channel)) use a [Lock](https://docs.raku.org/type/Lock) where required it is unlikely that user code will need to use a [Lock](https://docs.raku.org/type/Lock) directly.

[Lock](https://docs.raku.org/type/Lock) 类的主要接口是 [protect](https://docs.raku.org/type/Lock#method_protect) 方法，用来确保代码块（通常称为“临界区”）一次只在一个线程中执行。

The primary interface to [Lock](https://docs.raku.org/type/Lock) is the method [protect](https://docs.raku.org/type/Lock#method_protect) which ensures that a block of code (commonly called a "critical section") is only executed in one thread at a time:

```Perl6
my $lock = Lock.new;
 
my $a = 0;
 
await (^10).map: {
    start {
        $lock.protect({
            my $r = rand;
            sleep $r;
            $a++;
        });
    }
}
 
say $a; # OUTPUT: «10␤» 
```

`protect` 的返回值就是代码块的返回值。

`protect` returns whatever the code block returns.

因为 `protect` 会阻止任何等待执行临界区的线程，所以代码应该尽可能快。

Because `protect` will block any threads that are waiting to execute the critical section the code should be as quick as possible.

<a id="%E5%AE%89%E5%85%A8%E8%80%83%E8%99%91--safety-concerns"></a>
# 安全考虑 / Safety concerns

有些共享数据并发问题并不明显。关于这一主题的一般性报道，请参见[博客文章](https://6guts.wordpress.com/2014/04/17/racing-to-writeness-to-wrongness-leads/)。

Some shared data concurrency issues are less obvious than others. For a good general write-up on this subject see this [blog post](https://6guts.wordpress.com/2014/04/17/racing-to-writeness-to-wrongness-leads/).

一个特别的问题是当容器自动生动化或扩展发生时。当初始分配了一个 [Array](https://docs.raku.org/type/Array) 或一个 [Hash](https://docs.raku.org/type/Hash) 条目时，底层结构将被更改，并且该操作不是异步安全的。例如，在此代码中：

One particular issue of note is when container autovivification or extension takes place. When an [Array](https://docs.raku.org/type/Array) or a [Hash](https://docs.raku.org/type/Hash) entry is initially assigned the underlying structure is altered and that operation is not async safe. For example, in this code:

```Perl6
my @array;
my $slot := @array[20];
$slot = 'foo';
```

第三行是临界区，即当数组扩展时。最简单的修复方法是使用 [Lock](https://docs.raku.org/type/Lock) 来保护关键部分。一个可能更好的解决方法是重构代码，不使用共享容器。

The third line is the critical section as that is when the array is extended. The simplest fix is to use a [Lock](https://docs.raku.org/type/Lock) to protect the critical section. A possibly better fix would be to refactor the code so that sharing a container is not necessary.

