# class Promise

Status/result of an asynchronous computation

```
my enum PromiseStatus (:Planned(0), :Kept(1), :Broken(2));
class Promise {}
```

A *Promise* is used to handle the result of a computation that might not have finished. It allows the user to execute code once the computation is done (with the `then` method), execution after a time delay (with `in`), combining promises, and waiting for results.

```
my $p = Promise.start({ sleep 2; 42});
$p.then({ say .result });   # will print 42 once the block finished 
say $p.status;              # OUTPUT: «Planned␤» 
$p.result;                  # waits for the computation to finish 
say $p.status;              # OUTPUT: «Kept␤» 
```

There are two typical scenarios for using promises. The first is to use a factory method (`start`, `in`, `at`, `anyof`, `allof`, `kept`, `broken`) on the type object; those will make sure that the promise is automatically kept or broken for you, and you can't call `break` or `keep` on these promises yourself.

The second is to create your promises yourself with `Promise.new`. If you want to ensure that only your code can keep or break the promise, you can use the `vow` method to get a unique handle, and call `keep` or `break` on it:

```
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

Further examples can be found in the [concurrency page](https://docs.perl6.org/language/concurrency#Promises).

# [Methods](https://docs.perl6.org/type/Promise#___top)

## [method start](https://docs.perl6.org/type/Promise#___top)

```
method start(Promise:U: &code, :$scheduler = $*SCHEDULER --> Promise:D)
```

Creates a new Promise that runs the given code object. The promise will be kept when the code terminates normally, or broken if it throws an exception. The return value or exception can be inspected with the `result` method.

The scheduler that handles this promise can be passed as a named argument.

There is also a statement prefix `start` that provides syntactic sugar for this method:

```
# these two are equivalent: 
my $p1 = Promise.start({ ;#`( do something here ) });
my $p2 = start { ;#`( do something here ) };
```

As of the 6.d version of the language, `start` statement prefix used in [sink](https://docs.perl6.org/routine/sink) context will automatically attach an exceptions handler. If an exception occurs in the given code, it will be printed and the program will then exit, like if it were thrown without any `start` statement prefixes involved.

```
use v6.c;
start { die }; sleep ⅓; say "hello"; # OUTPUT: «hello␤» 
use v6.d;
start { die }; sleep ⅓; say "hello";
# OUTPUT: 
# Unhandled exception in code scheduled on thread 4 
# Died 
#     in block  at -e line 1 
```

If you wish to avoid this behavior, use `start` in non-sink context or catch the exception yourself:

```
# Don't sink it: 
my $ = start { die }; sleep ⅓; say "hello"; # OUTPUT: «hello␤» 
 
# Catch yourself: 
start { die; CATCH { default { say "caught" } } };
sleep ⅓;
say "hello";
# OUTPUT: «caught␤hello␤» 
```

This behavior exists only syntactically, by using an alternate `.sink` method for [Promise](https://docs.perl6.org/type/Promise) objects created by `start` blocks in sink context, thus simply sinking a [Promise](https://docs.perl6.org/type/Promise) object that was created by other means won't trigger this behavior.

## [method in](https://docs.perl6.org/type/Promise#___top)

```
method in(Promise:U: $seconds, :$scheduler = $*SCHEDULER --> Promise:D)
```

Creates a new Promise that will be kept in `$seconds` seconds, or later.

```
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

`$seconds` can be fractional or negative. Negative values are treated as `0` (i.e. [keeping](https://docs.perl6.org/routine/keep) the returned [Promise](https://docs.perl6.org/type/Promise) right away).

Please note that situations like these are often more clearly handled with a [react and whenever block](https://docs.perl6.org/language/concurrency#index-entry-react-react).

## [method at](https://docs.perl6.org/type/Promise#___top)

```
method at(Promise:U: $at, :$scheduler = $*SCHEDULER --> Promise:D)
```

Creates a new `Promise` that will be kept `$at` the given time—which is given as an [Instant](https://docs.perl6.org/type/Instant) or equivalent [Numeric](https://docs.perl6.org/type/Numeric)—or as soon as possible after it.

```
my $p = Promise.at(now + 2).then({ say "2 seconds later" });
# do other stuff here 
 
await $p;   # wait here until the 2 seconds are over 
```

If the given time is in the past, it will be treated as [now](https://docs.perl6.org/routine/now) (i.e. [keeping](https://docs.perl6.org/routine/keep) the returned [Promise](https://docs.perl6.org/type/Promise) right away).

Please note that situations like these are often more clearly handled with a [react and whenever block](https://docs.perl6.org/language/concurrency#index-entry-react-react).

## [method kept](https://docs.perl6.org/type/Promise#___top)

```
multi method kept(Promise:U: \result = True --> Promise:D)
```

Returns a new promise that is already kept, either with the given value, or with the default value `True`.

## [method broken](https://docs.perl6.org/type/Promise#___top)

```
multi method broken(Promise:U: --> Promise:D)
multi method broken(Promise:U: \exception --> Promise:D)
```

Returns a new promise that is already broken, either with the given value, or with the default value `X::AdHoc.new(payload => "Died")`

## [method allof](https://docs.perl6.org/type/Promise#___top)

```
method allof(Promise:U: *@promises --> Promise:D)
```

Returns a new promise that will be kept when all the promises passed as arguments are kept or broken. The result of the individual Promises is not reflected in the result of the returned promise: it simply indicates that all the promises have been completed in some way. If the results of the individual promises are important then they should be inspected after the `allof`promise is kept.

In the following requesting the `result` of a broken promise will cause the original Exception to be thrown. (You may need to run it several times to see the exception.)

```
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

## [method anyof](https://docs.perl6.org/type/Promise#___top)

```
method anyof(Promise:U: *@promises --> Promise:D)
```

Returns a new promise that will be kept as soon as any of the promises passed as arguments is kept or broken. The result of the completed Promise is not reflected in the result of the returned promise which will always be Kept.

You can use this to wait at most a number of seconds for a promise:

```
my $timeout = 5;
await Promise.anyof(
    Promise.in($timeout),
    start {
        # do a potentially long-running calculation here 
    },
);
```

## [method then](https://docs.perl6.org/type/Promise#___top)

```
method then(Promise:D: &code)
```

Schedules a piece of code to be run after the invocant has been kept or broken, and returns a new promise for this computation. In other words, creates a chained promise.

```
my $timer = Promise.in(2);
my $after = $timer.then({ say "2 seconds are over!"; 'result' });
say $after.result;  # 2 seconds are over 
                    # result 
```

## [method keep](https://docs.perl6.org/type/Promise#___top)

```
multi method keep(Promise:D: \result = True)
```

Keeps a promise, optionally setting the result. If no result is passed, the result will be `True`.

Throws an exception of type `X::Promise::Vowed` if a vow has already been taken. See method `vow` for more information.

```
my $p = Promise.new;
 
if Bool.pick {
    $p.keep;
}
else {
     $p.break;
}
```

## [method break](https://docs.perl6.org/type/Promise#___top)

```
multi method break(Promise:D: \cause = False)
```

Breaks a promise, optionally setting the cause. If no cause is passed, the cause will be `False`.

Throws an exception of type `X::Promise::Vowed` if a vow has already been taken. See method `vow` for more information.

```
my $p = Promise.new;
 
$p.break('sorry');
say $p.status;          # OUTPUT: «Broken␤» 
say $p.cause;           # OUTPUT: «sorry␤» 
```

## [method result](https://docs.perl6.org/type/Promise#___top)

```
method result(Promise:D)
```

Waits for the promise to be kept or broken. If it is kept, returns the result; otherwise throws the result as an exception.

## [method cause](https://docs.perl6.org/type/Promise#___top)

```
method cause(Promise:D)
```

If the promise was broken, returns the result (or exception). Otherwise, throws an exception of type `X::Promise::CauseOnlyValidOnBroken`.

## [method Bool](https://docs.perl6.org/type/Promise#___top)

```
multi method Bool(Promise:D:)
```

Returns `True` for a kept or broken promise, and `False` for one in state `Planned`.

## [method status](https://docs.perl6.org/type/Promise#___top)

```
method status(Promise:D --> PromiseStatus)
```

Returns the current state of the promise: `Kept`, `Broken` or `Planned`:

```
say "promise got Kept" if $promise.status ~~ Kept;
```

## [method scheduler](https://docs.perl6.org/type/Promise#___top)

```
method scheduler(Promise:D:)
```

Returns the scheduler that manages the promise.

## [method vow](https://docs.perl6.org/type/Promise#___top)

```
my class Vow {
    has Promise $.promise;
    method keep() { ... }
    method break() { ... }
}
method vow(Promise:D: --> Vow:D)
```

Returns an object that holds the sole authority over keeping or breaking a promise. Calling `keep` or `break` on a promise that has vow taken throws an exception of type `X::Promise::Vowed`.

```
my $p   = Promise.new;
my $vow = $p.vow;
$vow.keep($p);
say $p.status;          # OUTPUT: «Kept␤» 
```

## [method Supply](https://docs.perl6.org/type/Promise#___top)

```
method Supply(Promise:D:)
```

Returns a [Supply](https://docs.perl6.org/type/Supply) that will emit the `result` of the [Promise](https://docs.perl6.org/type/Promise) being Kept or `quit` with the `cause` if the [Promise](https://docs.perl6.org/type/Promise) is Broken.

## [sub await](https://docs.perl6.org/type/Promise#___top)

```
multi sub await(Promise:D --> Promise)
multi sub await(*@ --> Array)
```

Waits until one or more promises are *all* fulfilled, and then returns their values. Also works on [channels](https://docs.perl6.org/type/Channel). Any broken promises will rethrow their exceptions. If a list is passed it will return a list containing the results of awaiting each item in turn.

# [Type Graph](https://docs.perl6.org/type/Promise#___top)

Type relations for `Promise`

<svg width="94pt" height="188pt" viewBox="0.00 0.00 93.79 188.00" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g id="graph0" class="graph" transform="scale(1 1) rotate(0) translate(4 184)"><polygon fill="white" stroke="none" points="-4,4 -4,-184 89.7924,-184 89.7924,4 -4,4"></polygon><g id="node1" class="node"><g id="a_node1"><a xlink:href="https://docs.perl6.org/type/Promise" xlink:title="Promise"><ellipse fill="none" stroke="#000000" cx="42.8962" cy="-18" rx="42.7926" ry="18"></ellipse><text text-anchor="middle" x="42.8962" y="-14.3" font-family="FreeSans" font-size="14.00" fill="#000000">Promise</text></a></g></g><g id="node3" class="node"><g id="a_node3"><a xlink:href="https://docs.perl6.org/type/Any" xlink:title="Any"><ellipse fill="none" stroke="#000000" cx="42.8962" cy="-90" rx="27" ry="18"></ellipse><text text-anchor="middle" x="42.8962" y="-86.3" font-family="FreeSans" font-size="14.00" fill="#000000">Any</text></a></g></g><g id="edge1" class="edge"><path fill="none" stroke="#000000" d="M42.8962,-36.3034C42.8962,-44.0173 42.8962,-53.2875 42.8962,-61.8876"></path><polygon fill="#000000" stroke="#000000" points="39.3963,-61.8956 42.8962,-71.8957 46.3963,-61.8957 39.3963,-61.8956"></polygon></g><g id="node2" class="node"><g id="a_node2"><a xlink:href="https://docs.perl6.org/type/Mu" xlink:title="Mu"><ellipse fill="none" stroke="#000000" cx="42.8962" cy="-162" rx="27" ry="18"></ellipse><text text-anchor="middle" x="42.8962" y="-158.3" font-family="FreeSans" font-size="14.00" fill="#000000">Mu</text></a></g></g><g id="edge2" class="edge"><path fill="none" stroke="#000000" d="M42.8962,-108.303C42.8962,-116.017 42.8962,-125.288 42.8962,-133.888"></path><polygon fill="#000000" stroke="#000000" points="39.3963,-133.896 42.8962,-143.896 46.3963,-133.896 39.3963,-133.896"></polygon></g></g></svg>

[Expand above chart](https://docs.perl6.org/images/type-graph-Promise.svg)