原文：https://docs.raku.org/type/Promise

# Promise 类 / class Promise

一个异步计算单元的状态/结果

Status/result of an asynchronous computation

```Raku
my enum PromiseStatus (:Planned(0), :Kept(1), :Broken(2));
class Promise {}
```

*Promise* 用于处理可能尚未完成的计算结果。它允许用户在计算完成后执行代码 （通过 `then` 方法），延迟一定时间后执行代码，合并 promise 并等待计算完成后的结果。

A *Promise* is used to handle the result of a computation that might not have finished. It allows the user to execute code once the computation is done (with the `then` method), execution after a time delay (with `in`), combining promises, and waiting for results.

```Raku
my $p = Promise.start({ sleep 2; 42});
$p.then({ say .result });   # will print 42 once the block finished 
say $p.status;              # OUTPUT: «Planned␤» 
$p.result;                  # waits for the computation to finish 
say $p.status;              # OUTPUT: «Kept␤» 
```

使用 promise 有两个典型使用场景。第一个是对类型对象使用一个工厂方法（`start`, `in`, `at`, `anyof`, `allof`, `kept`, `broken`），这些方法会确保 promise 被自动 kept 或者 broken，而你不能对他们调用 `break` 或者 `keep` 方法来改变状态。

There are two typical scenarios for using promises. The first is to use a factory method (`start`, `in`, `at`, `anyof`, `allof`, `kept`, `broken`) on the type object; those will make sure that the promise is automatically kept or broken for you, and you can't call `break` or `keep` on these promises yourself.

第二个方法是使用 `Promise.new` 新建 promise。如果你希望只有你能够 keep 或者 break promise，你可以使用 `vow` 方法来获得一个唯一的句柄，并对句柄调用 `keep` 或者 `break` 来改变 promise 的状态：

The second is to create your promises yourself with `Promise.new`. If you want to ensure that only your code can keep or break the promise, you can use the `vow` method to get a unique handle, and call `keep` or `break` on it:

```Raku
sub async-get-with-promise($user-agent, $url) {
    my $p = Promise.new;
    my $v = $p.vow;
 
    # do an asynchronous call on a fictive user agent, 
    # and return the promise: 
    $user-agent.async-get($url,
            on-error => -> $error {
                $v.break($error);
            },
            on-success => -> $response {
                $v.keep($response);
            }
    );
    return $p;
}
```

[concurrency page](https://docs.raku.org/language/concurrency#Promises) 可以找到更多的示例。

Further examples can be found in the [concurrency page](https://docs.raku.org/language/concurrency#Promises).

<!-- MarkdownTOC -->

- [方法 / Methods](#方法--methods)
    - [start 方法 / method start](#start-方法--method-start)
    - [in 方法 / method in](#in-方法--method-in)
    - [at 方法 / method at](#at-方法--method-at)
    - [kept 方法 / method kept](#kept-方法--method-kept)
    - [broken 方法 / method broken](#broken-方法--method-broken)
    - [allof 方法 / method allof](#allof-方法--method-allof)
    - [anyof 方法 / method anyof](#anyof-方法--method-anyof)
    - [then 方法 / method then](#then-方法--method-then)
    - [keep 方法 / method keep](#keep-方法--method-keep)
    - [break 方法 / method break](#break-方法--method-break)
    - [result 方法 / method result](#result-方法--method-result)
    - [cause 方法 / method cause](#cause-方法--method-cause)
    - [Bool 方法 / method Bool](#bool-方法--method-bool)
    - [status 方法 / method status](#status-方法--method-status)
    - [scheduler 方法 / method scheduler](#scheduler-方法--method-scheduler)
    - [vow 方法 / method vow](#vow-方法--method-vow)
    - [Supply 方法 / method Supply](#supply-方法--method-supply)
    - [await 子例程 / sub await](#await-子例程--sub-await)
- [类型图 / Type Graph](#类型图--type-graph)

<!-- /MarkdownTOC -->


<a id="方法--methods"></a>
# 方法 / Methods

<a id="start-方法--method-start"></a>
## start 方法 / method start

```Raku
method start(Promise:U: &code, :$scheduler = $*SCHEDULER --> Promise:D)
```

创造一个新 Promise 对象，运行指定的代码对象。当代码正常终止时，promise 为 kept 状态，代码抛出异常时为 broken 状态。

Creates a new Promise that runs the given code object. The promise will be kept when the code terminates normally, or broken if it throws an exception. The return value or exception can be inspected with the `result` method.

处理这个 promise 的调度器可以以命名参数传递。

The scheduler that handles this promise can be passed as a named argument.

语句前缀 `start` 是这个方法的语法糖。

There is also a statement prefix `start` that provides syntactic sugar for this method:

```Raku
# these two are equivalent: 
my $p1 = Promise.start({ ;#`( do something here ) });
my $p2 = start { ;#`( do something here ) };
```

在 6.d 版本中，在 [sink](https://docs.raku.org/routine/sink) 上下文中使用 `start` 语句前缀会自动附加异常处理程序。如果在给定的代码中有异常发生，会打印出来异常然后程序退出就像没有 `start` 语句前缀一样。

As of the 6.d version of the language, `start` statement prefix used in [sink](https://docs.raku.org/routine/sink) context will automatically attach an exceptions handler. If an exception occurs in the given code, it will be printed and the program will then exit, like if it were thrown without any `start` statement prefixes involved.

```Raku
use v6.c;
start { die }; sleep ⅓; say "hello"; # OUTPUT: «hello␤» 
use v6.d;
start { die }; sleep ⅓; say "hello";
# OUTPUT: 
# Unhandled exception in code scheduled on thread 4 
# Died 
#     in block  at -e line 1 
```

在非 sink 上下文使用 `start` 或者自己捕获异常可以避免这个行为：

If you wish to avoid this behavior, use `start` in non-sink context or catch the exception yourself:

```Raku
# Don't sink it: 
my $ = start { die }; sleep ⅓; say "hello"; # OUTPUT: «hello␤» 
 
# Catch yourself: 
start { die; CATCH { default { say "caught" } } };
sleep ⅓;
say "hello";
# OUTPUT: «caught␤hello␤» 
```

这种行为只是在语法上存在，通过在 sink 上下文中由 `start` 代码块创建的 [Promise](https://docs.raku.org/type/Promise) 对象的替代 `.sink` 方法，从而简单地 sink [Promise](https://docs.raku.org/type/Promise)(https://docs.raku.org/type/Promise)。

This behavior exists only syntactically, by using an alternate `.sink` method for [Promise](https://docs.raku.org/type/Promise) objects created by `start` blocks in sink context, thus simply sinking a [Promise](https://docs.raku.org/type/Promise) object that was created by other means won't trigger this behavior.

<a id="in-方法--method-in"></a>
## in 方法 / method in

```Raku
method in(Promise:U: $seconds, :$scheduler = $*SCHEDULER --> Promise:D)
```

创建一个新 Promise 对象，将会在参数 `$seconds` 指定的秒内或者之后状态变为 kept。

Creates a new Promise that will be kept in `$seconds` seconds, or later.

```Raku
my $proc = Proc::Async.new('perl6', '-e', 'sleep 10; warn "end"');
 
my $result = await Promise.anyof(
    my $promise = $proc.start,  # may or may not work in time 
    Promise.in(5).then: {       # fires after 5 seconds no matter what 
        unless $promise {       # don't do anything if we were successful 
            note 'timeout';
            $proc.kill;
        }
    }
).then: { $promise.result }
# OUTPUT: «timeout␤» 
```

`$seconds` 可以是分数或负数。 负值被视为 `0` （即立即 [keeping](https://docs.raku.org/routine/keep) 返回的 [Promise](https://docs.raku.org/type/Promise))。

`$seconds` can be fractional or negative. Negative values are treated as `0` (i.e. [keeping](https://docs.raku.org/routine/keep) the returned [Promise](https://docs.raku.org/type/Promise) right away).

请注意，这些情况通常可以通过 [react 和 whenever 代码块](https://docs.raku.org/language/concurrency#index-entry-react-react)来更清楚地处理。

Please note that situations like these are often more clearly handled with a [react and whenever block](https://docs.raku.org/language/concurrency#index-entry-react-react).

<a id="at-方法--method-at"></a>
## at 方法 / method at

```Raku
method at(Promise:U: $at, :$scheduler = $*SCHEDULER --> Promise:D)
```

创建一个新的 `Promise`，它将在 `$at` 给定的时间变为 kept 状态。 这个时间可以是 [Instant](https://docs.raku.org/type/Instant) 对象、同等的 [Numeric](https://docs.raku.org/type/Numeric) 对象或者在这个时间之后尽快。

Creates a new `Promise` that will be kept `$at` the given time—which is given as an [Instant](https://docs.raku.org/type/Instant) or equivalent [Numeric](https://docs.raku.org/type/Numeric)—or as soon as possible after it.

```Raku
my $p = Promise.at(now + 2).then({ say "2 seconds later" });
# do other stuff here 
 
await $p;   # wait here until the 2 seconds are over 
```

如果给定的是过去的时间，它会被当做 [now](https://docs.raku.org/routine/now) (即立即 [keeping](https://docs.raku.org/routine/keep) 返回的 [Promise](https://docs.raku.org/type/Promise))。

If the given time is in the past, it will be treated as [now](https://docs.raku.org/routine/now) (i.e. [keeping](https://docs.raku.org/routine/keep) the returned [Promise](https://docs.raku.org/type/Promise) right away).

请注意，这些情况通常可以通过 [react 和 whenever 代码块](https://docs.raku.org/language/concurrency#index-entry-react-react)来更清楚地处理。

Please note that situations like these are often more clearly handled with a [react and whenever block](https://docs.raku.org/language/concurrency#index-entry-react-react).

<a id="kept-方法--method-kept"></a>
## kept 方法 / method kept

```Raku
multi method kept(Promise:U: \result = True --> Promise:D)
```

返回已 kept 的新 promise，具有给定值或默认值 `True`。

Returns a new promise that is already kept, either with the given value, or with the default value `True`.

<a id="broken-方法--method-broken"></a>
## broken 方法 / method broken

```Raku
multi method broken(Promise:U: --> Promise:D)
multi method broken(Promise:U: \exception --> Promise:D)
```

返回一个已经 broken 的新 promise，参数为给定值或者默认值 `X::AdHoc.new(payload => "Died")`

Returns a new promise that is already broken, either with the given value, or with the default value `X::AdHoc.new(payload => "Died")`

<a id="allof-方法--method-allof"></a>
## allof 方法 / method allof

```Raku
method allof(Promise:U: *@promises --> Promise:D)
```

返回一个新 promise，当所有作为参数传递的 promise 为 kept 或者 broken 时其为 kept 状态。单个 Promise 的结果不会反映在返回的 promise 的结果中：它只是表明所有 promise 都以某种方式完成。 如果每个 promise 的结果很重要，那么应该在 `allof` promise 状态为 kept 之后进行检查。

Returns a new promise that will be kept when all the promises passed as arguments are kept or broken. The result of the individual Promises is not reflected in the result of the returned promise: it simply indicates that all the promises have been completed in some way. If the results of the individual promises are important then they should be inspected after the `allof`promise is kept.

在下面请求 broken promise 的 `result` 将导致抛出原始异常。（你可能需要多次运行才能看到异常。）

In the following requesting the `result` of a broken promise will cause the original Exception to be thrown. (You may need to run it several times to see the exception.)

```Raku
my @promises;
for 1..5 -> $t {
    push @promises, start {
        sleep $t;
    };
}
my $all-done = Promise.allof(@promises);
await $all-done;
@promises>>.result;
say "Promises kept so we get to live another day!";
```

<a id="anyof-方法--method-anyof"></a>
## anyof 方法 / method anyof

```Raku
method anyof(Promise:U: *@promises --> Promise:D)
```

返回一个新 promise，当任一作为参数传递的 promise 为 kept 或者 broken 时其为 kept 状态。完成的 Promise 的结果不会反映在返回的 promise 的结果中，返回的 promise 的状态一定是 Kept 状态。

Returns a new promise that will be kept as soon as any of the promises passed as arguments is kept or broken. The result of the completed Promise is not reflected in the result of the returned promise which will always be Kept.

你可以使用它来等待一个 promise 在给定的秒钟内：

You can use this to wait at most a number of seconds for a promise:

```Raku
my $timeout = 5;
await Promise.anyof(
    Promise.in($timeout),
    start {
        # do a potentially long-running calculation here 
    },
);
```

<a id="then-方法--method-then"></a>
## then 方法 / method then

```Raku
method then(Promise:D: &code)
```

安排一段代码在调用者为 kept 或者 broken 状态后执行，为这个计算返回一个新的 promise。也就是说，创建一个链式 promise。

Schedules a piece of code to be run after the invocant has been kept or broken, and returns a new promise for this computation. In other words, creates a chained promise.

```Raku
my $timer = Promise.in(2);
my $after = $timer.then({ say "2 seconds are over!"; 'result' });
say $after.result;  # 2 seconds are over 
                    # result 
```

<a id="keep-方法--method-keep"></a>
## keep 方法 / method keep

```Raku
multi method keep(Promise:D: \result = True)
```

Keep 一个 promise，可设置结果。如果没有传递结果，结果为 `True`。

Keeps a promise, optionally setting the result. If no result is passed, the result will be `True`.

如果 vow 了，会抛出类型为 `X::Promise::Vowed` 的异常。更多信息见方法 `vow`。

Throws an exception of type `X::Promise::Vowed` if a vow has already been taken. See method `vow` for more information.

```Raku
my $p = Promise.new;
 
if Bool.pick {
    $p.keep;
}
else {
     $p.break;
}
```

<a id="break-方法--method-break"></a>
## break 方法 / method break

```Raku
multi method break(Promise:D: \cause = False)
```

break 一个 promise，可参数设置原因。如果没有传递原因，原因为 `False`。

Breaks a promise, optionally setting the cause. If no cause is passed, the cause will be `False`.

如果 vow 了，会抛出类型为 `X::Promise::Vowed` 的异常。更多信息见方法 `vow`。

Throws an exception of type `X::Promise::Vowed` if a vow has already been taken. See method `vow` for more information.

```Raku
my $p = Promise.new;
 
$p.break('sorry');
say $p.status;          # OUTPUT: «Broken␤» 
say $p.cause;           # OUTPUT: «sorry␤» 
```

<a id="result-方法--method-result"></a>
## result 方法 / method result

```Raku
method result(Promise:D)
```

等待 promise 状态变为 kept 或者 broken。如果为 kept，返回结果。否则将结果作为异常抛出。

Waits for the promise to be kept or broken. If it is kept, returns the result; otherwise throws the result as an exception.

<a id="cause-方法--method-cause"></a>
## cause 方法 / method cause

```Raku
method cause(Promise:D)
```

如果 promise 状态为 broken，返回结果或者异常。否则抛出类型为 `X::Promise::CauseOnlyValidOnBroken` 的异常。

If the promise was broken, returns the result (or exception). Otherwise, throws an exception of type `X::Promise::CauseOnlyValidOnBroken`.

<a id="bool-方法--method-bool"></a>
## Bool 方法 / method Bool

```Raku
multi method Bool(Promise:D:)
```

为状态为 kept 或者 broken 的 promise 返回值为 `True`，当状态为 `Planned` 时，返回值为 `False`。

Returns `True` for a kept or broken promise, and `False` for one in state `Planned`.

<a id="status-方法--method-status"></a>
## status 方法 / method status

```Raku
method status(Promise:D --> PromiseStatus)
```

放回 promise 的当前状态： `Kept`，`Broken` 或者 `Planned`:
Returns the current state of the promise: `Kept`, `Broken` or `Planned`:

```Raku
say "promise got Kept" if $promise.status ~~ Kept;
```

<a id="scheduler-方法--method-scheduler"></a>
## scheduler 方法 / method scheduler

```Raku
method scheduler(Promise:D:)
```

返回管理当前 promise 的调度器。

Returns the scheduler that manages the promise.

<a id="vow-方法--method-vow"></a>
## vow 方法 / method vow

```Raku
my class Vow {
    has Promise $.promise;
    method keep() { ... }
    method break() { ... }
}
method vow(Promise:D: --> Vow:D)
```

返回一个对象，这个对象对 promise 能否 keep 或者 break 有唯一的权威。对执行了 vow 的 promise 对象调用 `keep` 或者 `break` 方法将抛出 `X::Promise::Vowed` 异常。

Returns an object that holds the sole authority over keeping or breaking a promise. Calling `keep` or `break` on a promise that has vow taken throws an exception of type `X::Promise::Vowed`.

```Raku
my $p   = Promise.new;
my $vow = $p.vow;
$vow.keep($p);
say $p.status;          # OUTPUT: «Kept␤» 
```

<a id="supply-方法--method-supply"></a>
## Supply 方法 / method Supply

```Raku
method Supply(Promise:D:)
```

返回一个 [Supply](https://docs.raku.org/type/Supply)。 如果 promise 为 kept 状态，将 `result` 方法的结果发射出来。 promise 为 broken 状态时，
则发出 `cause` 方法的结果给到 Supply 的 tap 方法的 `quit` 命名参数对应的代码块。

Returns a [Supply](https://docs.raku.org/type/Supply) that will emit the `result` of the [Promise](https://docs.raku.org/type/Promise) being Kept or `quit` with the `cause` if the [Promise](https://docs.raku.org/type/Promise) is Broken.

<a id="await-子例程--sub-await"></a>
## await 子例程 / sub await

```Raku
multi sub await(Promise:D --> Promise)
multi sub await(*@ --> Array)
```

等待一个或者多个 promise 全部被满足，然后返回他们的值。对 [channels](https://docs.raku.org/type/Channel) 也生效。任何 broken 状态的 promise 会重新抛出他们的异常。如果一个 promise 数组传递给 await，它将按顺序返回每个 promise 的结果的数组。

Waits until one or more promises are *all* fulfilled, and then returns their values. Also works on [channels](https://docs.raku.org/type/Channel). Any broken promises will rethrow their exceptions. If a list is passed it will return a list containing the results of awaiting each item in turn.

<a id="类型图--type-graph"></a>
# 类型图 / Type Graph

Type relations for `Promise`

<svg width="94pt" height="188pt" viewBox="0.00 0.00 93.79 188.00" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g id="graph0" class="graph" transform="scale(1 1) rotate(0) translate(4 184)"><polygon fill="white" stroke="none" points="-4,4 -4,-184 89.7924,-184 89.7924,4 -4,4"></polygon><g id="node1" class="node"><g id="a_node1"><a xlink:href="https://docs.raku.org/type/Promise" xlink:title="Promise"><ellipse fill="none" stroke="#000000" cx="42.8962" cy="-18" rx="42.7926" ry="18"></ellipse><text text-anchor="middle" x="42.8962" y="-14.3" font-family="FreeSans" font-size="14.00" fill="#000000">Promise</text></a></g></g><g id="node3" class="node"><g id="a_node3"><a xlink:href="https://docs.raku.org/type/Any" xlink:title="Any"><ellipse fill="none" stroke="#000000" cx="42.8962" cy="-90" rx="27" ry="18"></ellipse><text text-anchor="middle" x="42.8962" y="-86.3" font-family="FreeSans" font-size="14.00" fill="#000000">Any</text></a></g></g><g id="edge1" class="edge"><path fill="none" stroke="#000000" d="M42.8962,-36.3034C42.8962,-44.0173 42.8962,-53.2875 42.8962,-61.8876"></path><polygon fill="#000000" stroke="#000000" points="39.3963,-61.8956 42.8962,-71.8957 46.3963,-61.8957 39.3963,-61.8956"></polygon></g><g id="node2" class="node"><g id="a_node2"><a xlink:href="https://docs.raku.org/type/Mu" xlink:title="Mu"><ellipse fill="none" stroke="#000000" cx="42.8962" cy="-162" rx="27" ry="18"></ellipse><text text-anchor="middle" x="42.8962" y="-158.3" font-family="FreeSans" font-size="14.00" fill="#000000">Mu</text></a></g></g><g id="edge2" class="edge"><path fill="none" stroke="#000000" d="M42.8962,-108.303C42.8962,-116.017 42.8962,-125.288 42.8962,-133.888"></path><polygon fill="#000000" stroke="#000000" points="39.3963,-133.896 42.8962,-143.896 46.3963,-133.896 39.3963,-133.896"></polygon></g></g></svg>

[Expand above chart](https://docs.raku.org/images/type-graph-Promise.svg)