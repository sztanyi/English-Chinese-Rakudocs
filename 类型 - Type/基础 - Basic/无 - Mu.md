# Mu 类 / class Mu

Raku 类层次结构的根类。

The root of the Raku type hierarchy.

<!-- MarkdownTOC -->

- [Methods](#methods)
    - [method iterator](#method-iterator)
    - [method defined ](#method-defined-)
    - [routine defined](#routine-defined)
    - [routine isa](#routine-isa)
    - [routine does](#routine-does)
    - [routine Bool](#routine-bool)
    - [method Capture](#method-capture)
    - [method Str](#method-str)
    - [routine gist](#routine-gist)
    - [method raku](#method-raku)
    - [method raku](#method-raku-1)
    - [method item](#method-item)
    - [method self](#method-self)
    - [method clone](#method-clone)
    - [method new](#method-new)
    - [method bless](#method-bless)
    - [method CREATE](#method-create)
    - [method print](#method-print)
    - [method put](#method-put)
    - [method say](#method-say)
    - [method ACCEPTS](#method-accepts)
    - [method WHICH](#method-which)
    - [method WHERE](#method-where)
    - [method WHY](#method-why)
    - [trait is export](#trait-is-export)
    - [method return](#method-return)
    - [method return-rw](#method-return-rw)
    - [method emit](#method-emit)
    - [method take](#method-take)
    - [routine take](#routine-take)
    - [routine take-rw](#routine-take-rw)
    - [method so](#method-so)
    - [method not](#method-not)
- [Type Graph](#type-graph)

<!-- /MarkdownTOC -->


```Raku
class Mu { }
```

The root of the Raku type hierarchy. For the origin of the name, see [https://en.wikipedia.org/wiki/Mu_%28negative%29](https://en.wikipedia.org/wiki/Mu_(negative)). One can also say that there are many undefined values in Raku, and `Mu` is the *most undefined* value.

Note that most classes do not derive from `Mu` directly, but rather from [Any](https://docs.raku.org/type/Any).

<a id="methods"></a>
# Methods

<a id="method-iterator"></a>
## method iterator

Defined as:

```Raku
method iterator(--> Iterator)
```

Coerces the invocant to a `list` by applying its [`.list`](https://docs.raku.org/routine/list) method and uses [`iterator`](https://docs.raku.org/type/Iterable#method_iterator) on it.

```Raku
my $it = Mu.iterator;
say $it.pull-one; # OUTPUT: «(Mu)␤» 
say $it.pull-one; # OUTPUT: «IterationEnd␤»
```

<a id="method-defined-"></a>
## method defined 

Declared as

```Raku
multi method defined(   --> Bool:D)
```

Returns `False` on a type object, and `True` otherwise.

```Raku
say Int.defined;                # OUTPUT: «False␤» 
say 42.defined;                 # OUTPUT: «True␤»
```

A few types (like [Failure](https://docs.raku.org/type/Failure)) override `defined` to return `False` even for instances:

```Raku
sub fails() { fail 'oh noe' };
say fails().defined;            # OUTPUT: «False␤»
```

<a id="routine-defined"></a>
## routine defined

Declared as

```Raku
multi sub defined(Mu --> Bool:D)
```

invokes the `.defined` method on the object and returns its result.

<a id="routine-isa"></a>
## routine isa

```Raku
multi method isa(Mu $type     --> Bool:D)
multi method isa(Str:D $type  --> Bool:D)
```

Returns `True` if the invocant is an instance of class `$type`, a subset type or a derived class (through inheritance) of `$type`. [`does`](https://docs.raku.org/routine/does#(Mu)_routine_does) is similar, but includes roles.

```Raku
my $i = 17;
say $i.isa("Int");   # OUTPUT: «True␤» 
say $i.isa(Any);     # OUTPUT: «True␤» 
role Truish {};
my $but-true = 0 but Truish;
say $but-true.^name;        # OUTPUT: «Int+{Truish}␤» 
say $but-true.does(Truish); # OUTPUT: «True␤» 
say $but-true.isa(Truish);  # OUTPUT: «False␤»
```

<a id="routine-does"></a>
## routine does

```Raku
method does(Mu $type --> Bool:D)
```

Returns `True` if and only if the invocant conforms to type `$type`.

```Raku
my $d = Date.new('2016-06-03');
say $d.does(Dateish);             # True    (Date does role Dateish) 
say $d.does(Any);                 # True    (Date is a subclass of Any) 
say $d.does(DateTime);            # False   (Date is not a subclass of DateTime) 
```

Unlike [`isa`](https://docs.raku.org/routine/isa#(Mu)_routine_isa), which returns `True` only for superclasses, `does` includes both superclasses and roles.

```Raku
say $d.isa(Dateish); # OUTPUT: «False␤» 
```

Using the smartmatch operator [~~](https://docs.raku.org/routine/~~) is a more idiomatic alternative.

```Raku
my $d = Date.new('2016-06-03');
say $d ~~ Dateish;                # OUTPUT: «True␤» 
say $d ~~ Any;                    # OUTPUT: «True␤» 
say $d ~~ DateTime;               # OUTPUT: «False␤»
```

<a id="routine-bool"></a>
## routine Bool

```Raku
multi sub    Bool(Mu --> Bool:D)
multi method Bool(   --> Bool:D)
```

Returns `False` on the type object, and `True` otherwise.

Many built-in types override this to be `False` for empty collections, the empty [string](https://docs.raku.org/type/Str) or numerical zeros

```Raku
say Mu.Bool;                    # OUTPUT: «False␤» 
say Mu.new.Bool;                # OUTPUT: «True␤» 
say [1, 2, 3].Bool;             # OUTPUT: «True␤» 
say [].Bool;                    # OUTPUT: «False␤» 
say %( hash => 'full' ).Bool;   # OUTPUT: «True␤» 
say {}.Bool;                    # OUTPUT: «False␤» 
say "".Bool;                    # OUTPUT: «False␤» 
say 0.Bool;                     # OUTPUT: «False␤» 
say 1.Bool;                     # OUTPUT: «True␤» 
say "0".Bool;                   # OUTPUT: «True␤»
```

<a id="method-capture"></a>
## method Capture

Declared as:

```Raku
method Capture(Mu:D: --> Capture:D)
```

Returns a [Capture](https://docs.raku.org/type/Capture) with named arguments corresponding to invocant's public attributes:

```Raku
class Foo {
    has $.foo = 42;
    has $.bar = 70;
    method bar { 'something else' }
}.new.Capture.say; # OUTPUT: «\(:bar("something else"), :foo(42))␤»
```

<a id="method-str"></a>
## method Str

```Raku
multi method Str(--> Str)
```

Returns a string representation of the invocant, intended to be machine readable. Method `Str` warns on type objects, and produces the empty string.

```Raku
say Mu.Str;   # Use of uninitialized value of type Mu in string context. 
my @foo = [2,3,1];
say @foo.Str  # OUTPUT: «2 3 1␤»
```

<a id="routine-gist"></a>
## routine gist

```Raku
multi sub    gist(+args --> Str)
multi method gist(   --> Str)
```

Returns a string representation of the invocant, optimized for fast recognition by humans. As such lists will be truncated at 100 elements. Use `.raku` to get all elements.

The default `gist` method in `Mu` re-dispatches to the [raku](https://docs.raku.org/routine/raku) method for defined invocants, and returns the type name in parenthesis for type object invocants. Many built-in classes override the case of instances to something more specific that may truncate output.

`gist` is the method that [say](https://docs.raku.org/routine/say) calls implicitly, so `say $something` and `say $something.gist` generally produce the same output.

```Raku
say Mu.gist;        # OUTPUT: «(Mu)␤» 
say Mu.new.gist;    # OUTPUT: «Mu.new␤»
```

<a id="method-raku"></a>
## method raku

```Raku
multi method raku(Mu: --> Str)
```

Returns a Raku-ish representation of the object (i.e., can usually be re-evaluated with [EVAL](https://docs.raku.org/routine/EVAL) to regenerate the object). The exact output of `raku` is implementation specific, since there are generally many ways to write a Raku expression that produces a particular value. Since the change of name to Raku, this method is deprecated and might disappear in the near future. Use `.raku` instead.

<a id="method-raku-1"></a>
## method raku

```Raku
multi method raku(Mu:U:)
multi method raku(Mu:D:)
```

For type objects, returns its name if `.raku` has not been redefined from Mu, or calls `.raku` on the name of the type object otherwise.

```Raku
say Str.raku;          # OUTPUT: «Str␤»
```

For plain objects, it will conventionally return a representation of the object that can be used via EVAL to reconstruct the value of the object.

```Raku
say (1..3).Set.raku;  # OUTPUT: «Set.new(1,2,3)␤»
```

<a id="method-item"></a>
## method item

```Raku
method item(Mu \item:) is raw
```

Forces the invocant to be evaluated in item context and returns the value of it.

```Raku
say [1,2,3].item.raku;          # OUTPUT: «$[1, 2, 3]␤» 
say %( apple => 10 ).item.raku; # OUTPUT: «${:apple(10)}␤» 
say "abc".item.raku;            # OUTPUT: «"abc"␤»
```

<a id="method-self"></a>
## method self

```Raku
method self(--> Mu)
```

Returns the object it is called on.

<a id="method-clone"></a>
## method clone

```Raku
multi method clone(Mu:U: *%twiddles)
multi method clone(Mu:D: *%twiddles)
```

This method will clone type objects, or die if it's invoked with any argument.

```Raku
say Num.clone( :yes )
# OUTPUT: «(exit code 1) Cannot set attribute values when cloning a type object␤  in block <unit>␤␤» 
```

If invoked with value objects, it creates a shallow clone of the invocant, including shallow cloning of private attributes. Alternative values for *public* attributes can be provided via named arguments with names matching the attributes' names.

```Raku
class Point2D {
    has ($.x, $.y);
    multi method gist(Point2D:D:) {
        "Point($.x, $.y)";
    }
}
 
my $p = Point2D.new(x => 2, y => 3);
 
say $p;                     # OUTPUT: «Point(2, 3)␤» 
say $p.clone(y => -5);      # OUTPUT: «Point(2, -5)␤» 
```

Note that `.clone` does not go the extra mile to shallow-copy `@.` and `%.` sigiled attributes and, if modified, the modifications will still be available in the original object:

```Raku
class Foo {
    has $.foo is rw = 42;
    has &.boo is rw = { say "Hi" };
    has @.bar       = <a b>;
    has %.baz       = <a b c d>;
}
 
my $o1 = Foo.new;
with my $o2 = $o1.clone {
    .foo = 70;
    .bar = <Z Y>;
    .baz = <Z Y X W>;
    .boo = { say "Bye" };
}
 
# Hash and Array attribute modifications in clone appear in original as well: 
say $o1;
# OUTPUT: «Foo.new(foo => 42, bar => ["Z", "Y"], baz => {:X("W"), :Z("Y")}, …␤» 
say $o2;
# OUTPUT: «Foo.new(foo => 70, bar => ["Z", "Y"], baz => {:X("W"), :Z("Y")}, …␤» 
$o1.boo.(); # OUTPUT: «Hi␤» 
$o2.boo.(); # OUTPUT: «Bye␤» 
```

To clone those, you could implement your own `.clone` that clones the appropriate attributes and passes the new values to `Mu.clone`, for example, via [`nextwith`](https://docs.raku.org/language/functions#sub_nextwith).

```Raku
class Bar {
    has $.quux;
    has @.foo = <a b>;
    has %.bar = <a b c d>;
    method clone { nextwith :foo(@!foo.clone), :bar(%!bar.clone), |%_  }
}
 
my $o1 = Bar.new( :42quux );
with my $o2 = $o1.clone {
    .foo = <Z Y>;
    .bar = <Z Y X W>;
}
 
# Hash and Array attribute modifications in clone do not affect original: 
say $o1;
# OUTPUT: «Bar.new(quux => 42, foo => ["a", "b"], bar => {:a("b"), :c("d")})␤» 
say $o2;
# OUTPUT: «Bar.new(quux => 42, foo => ["Z", "Y"], bar => {:X("W"), :Z("Y")})␤» 
```

The `|%_` is needed to slurp the rest of the attributes that would have been copied via shallow copy.

<a id="method-new"></a>
## method new

```Raku
multi method new(*%attrinit)
multi method new($, *@)
```

Default method for constructing (create + initialize) new objects of a class. This method expects only named arguments which are then used to initialize attributes with accessors of the same name.

Classes may provide their own `new` method to override this default.

`new` triggers an object construction mechanism that calls submethods named `BUILD` in each class of an inheritance hierarchy, if they exist. See [the documentation on object construction](https://docs.raku.org/language/objects#Object_construction) for more information.

<a id="method-bless"></a>
## method bless

```Raku
method bless(*%attrinit --> Mu:D)
```

Low-level object construction method, usually called from within `new`, implicitly from the default constructor, or explicitly if you create your own constructor. `bless` creates a new object of the same type as the invocant, using the named arguments to initialize attributes and returns the created object.

It is usually invoked within custom `new` method implementations:

```Raku
class Point {
    has $.x;
    has $.y;
    multi method new($x, $y) {
        self.bless(:$x, :$y);
    }
}
my $p = Point.new(-1, 1);
```

In this example we are declaring this `new` method to avoid the extra syntax of using pairs when creating the object. `self.bless` returns the object, which is in turn returned by `new`. `new` is declared as a `multi method` so that we can still use the default constructor like this: `Point.new( x => 3, y => 8 )`.

For more details see [the documentation on object construction](https://docs.raku.org/language/objects#Object_construction).

<a id="method-create"></a>
## method CREATE

```Raku
method CREATE(--> Mu:D)
```

Allocates a new object of the same type as the invocant, without initializing any attributes.

```Raku
say Mu.CREATE.defined;  # OUTPUT: «True␤»
```

<a id="method-print"></a>
## method print

```Raku
multi method print(--> Bool:D)
```

Prints value to `$*OUT` after stringification using `.Str` method without adding a newline at end.

```Raku
"abc\n".print;          # OUTPUT: «abc␤»
```

<a id="method-put"></a>
## method put

```Raku
multi method put(--> Bool:D)
```

Prints value to `$*OUT`, adding a newline at end, and if necessary, stringifying non-`Str` object using the `.Str` method.

```Raku
"abc".put;              # OUTPUT: «abc␤»
```

<a id="method-say"></a>
## method say

```Raku
multi method say()
```

Will [`say`](https://docs.raku.org/type/IO::Handle#method_say) to [standard output](https://docs.raku.org/language/variables#index-entry-$*OUT).

```Raku
say 42;                 # OUTPUT: «42␤»
```

What `say` actually does is, thus, deferred to the actual subclass. In [most cases](https://docs.raku.org/routine/say) it calls [`.gist`](https://docs.raku.org/routine/gist) on the object, returning a compact string representation.

In non-sink context, `say` will always return `True`.

```Raku
say (1,[1,2],"foo",Mu).map: so *.say ;
# OUTPUT: «1␤[1 2]␤foo␤(Mu)␤(True True True True)␤»
```

However, this behavior is just conventional and you shouldn't trust it for your code. It's useful, however, to explain certain behaviors.

`say` is first printing out in `*.say`, but the outermost `say` is printing the `True` values returned by the `so` operation.

<a id="method-accepts"></a>
## method ACCEPTS

```Raku
multi method ACCEPTS(Mu:U: $other)
```

`ACCEPTS` is the method that smartmatching with the [infix ~~](https://docs.raku.org/routine/~~) operator and given/when invokes on the right-hand side (the matcher).

The `Mu:U` multi performs a type check. Returns `True` if `$other` conforms to the invocant (which is always a type object or failure).

```Raku
say 42 ~~ Mu;           # OUTPUT: «True␤» 
say 42 ~~ Int;          # OUTPUT: «True␤» 
say 42 ~~ Str;          # OUTPUT: «False␤»
```

Note that there is no multi for defined invocants; this is to allow autothreading of [junctions](https://docs.raku.org/type/Junction), which happens as a fallback mechanism when no direct candidate is available to dispatch to.

<a id="method-which"></a>
## method WHICH

```Raku
multi method WHICH(--> ObjAt:D)
```

Returns an object of type [ObjAt](https://docs.raku.org/type/ObjAt) which uniquely identifies the object. Value types override this method which makes sure that two equivalent objects return the same return value from `WHICH`.

```Raku
say 42.WHICH eq 42.WHICH;       # OUTPUT: «True␤»
```

<a id="method-where"></a>
## method WHERE

```Raku
method WHERE(--> Int)
```

Returns an `Int` representing the memory address of the object. Please note that in the Rakudo implementation of Raku, and possibly other implementations, the memory location of an object is **NOT** fixed for the lifetime of the object. So it has limited use for applications, and is intended as a debugging tool only.

<a id="method-why"></a>
## method WHY

```Raku
multi method WHY(Mu: --> Pod::Block::Declarator)
```

Returns the attached Pod::Block::Declarator.

For instance:

```Raku
#| Initiate a specified spell normally 
sub cast(Spell $s) {
  do-raw-magic($s);
}
#= (do not use for class 7 spells) 
say &cast.WHY;
# OUTPUT: «Initiate a specified spell normally␤(do not use for class 7 spells)␤» 
```

See [Pod declarator blocks](https://docs.raku.org/language/pod#Declarator_blocks) for details about attaching Pod to variables, classes, functions, methods, etc.

<a id="trait-is-export"></a>
## trait is export

```Raku
multi sub trait_mod:<is>(Mu:U \type, :$export!)
```

Marks a type as being exported, that is, available to external users.

```Raku
my class SomeClass is export { }
```

A user of a module or class automatically gets all the symbols imported that are marked as `is export`.

See [Exporting and Selective Importing Modules](https://docs.raku.org/language/modules#Exporting_and_selective_importing) for more details.

<a id="method-return"></a>
## method return

```Raku
method return()
```

The method `return` will stop execution of a subroutine or method, run all relevant [phasers](https://docs.raku.org/language/phasers#Block_phasers) and provide invocant as a return value to the caller. If a return [type constraint](https://docs.raku.org/type/Signature#Constraining_return_types) is provided it will be checked unless the return value is `Nil`. A control exception is raised and can be caught with [CONTROL](https://docs.raku.org/language/phasers#CONTROL).

```Raku
sub f { (1|2|3).return };
say f(); # OUTPUT: «any(1, 2, 3)␤»
```

<a id="method-return-rw"></a>
## method return-rw

Same as method [`return`](https://docs.raku.org/type/Mu#method_return) except that `return-rw` returns a writable container to the invocant (see more details here: [`return-rw`](https://docs.raku.org/language/control#return-rw)).

<a id="method-emit"></a>
## method emit

```Raku
method emit()
```

Emits the invocant into the enclosing [supply](https://docs.raku.org/language/concurrency#index-entry-supply_(on-demand)) or [react](https://docs.raku.org/language/concurrency#index-entry-react) block.

```Raku
react { whenever supply { .emit for "foo", 42, .5 } {
    say "received {.^name} ($_)";
}}
 
# OUTPUT: 
# received Str (foo) 
# received Int (42) 
# received Rat (0.5)
```

<a id="method-take"></a>
## method take

```Raku
method take()
```

Returns the invocant in the enclosing [gather](https://docs.raku.org/language/control#gather/take) block.

```Raku
sub insert($sep, +@list) {
    gather for @list {
        FIRST .take, next;
        take slip $sep, .item
    }
}
 
say insert ':', <a b c>;
# OUTPUT: «(a : b : c)␤»
```

<a id="routine-take"></a>
## routine take

```Raku
sub take(\item)
```

Takes the given item and passes it to the enclosing `gather` block.

```Raku
#| randomly select numbers for lotto 
my $num-selected-numbers = 6;
my $max-lotto-numbers = 49;
gather for ^$num-selected-numbers {
    take (1 .. $max-lotto-numbers).pick(1);
}.say;    # six random values
```

<a id="routine-take-rw"></a>
## routine take-rw

```Raku
sub take-rw(\item)
```

Returns the given item to the enclosing `gather` block, without introducing a new container.

```Raku
my @a = 1...3;
sub f(@list){ gather for @list { take-rw $_ } };
for f(@a) { $_++ };
say @a;
# OUTPUT: «[2 3 4]␤»
```

<a id="method-so"></a>
## method so

```Raku
method so()
```

Evaluates the item in Boolean context (and thus, for instance, collapses Junctions), and returns the result. It is the opposite of `not`, and equivalent to the [`?` operator](https://docs.raku.org/language/operators#prefix_?).

One can use this method similarly to the English sentence: "If that is **so**, then do this thing". For instance,

```Raku
my @args = <-a -e -b -v>;
my $verbose-selected = any(@args) eq '-v' | '-V';
if $verbose-selected.so {
    say "Verbose option detected in arguments";
} # OUTPUT: «Verbose option detected in arguments␤»
```

The `$verbose-selected` variable in this case contains a [`Junction`](https://docs.raku.org/type/Junction), whose value is `any(any(False, False), any(False, False), any(False, False), any(True, False))`. That is actually a *truish* value; thus, negating it will yield `False`. The negation of that result will be `True`. `so` is performing all those operations under the hood.

<a id="method-not"></a>
## method not

```Raku
method not()
```

Evaluates the item in Boolean context (leading to final evaluation of Junctions, for instance), and negates the result. It is the opposite of `so` and its behavior is equivalent to the [`!` operator](https://docs.raku.org/language/operators#prefix_!).

```Raku
my @args = <-a -e -b>;
my $verbose-selected = any(@args) eq '-v' | '-V';
if $verbose-selected.not {
    say "Verbose option not present in arguments";
} # OUTPUT: «Verbose option not present in arguments␤»
```

Since there is also a [prefix version of `not`](https://docs.raku.org/language/operators#prefix_not), this example reads better as:

```Raku
my @args = <-a -e -b>;
my $verbose-selected = any(@args) eq '-v' | '-V';
if not $verbose-selected {
    say "Verbose option not present in arguments";
} # OUTPUT: «Verbose option not present in arguments␤»
```

<a id="type-graph"></a>
# Type Graph

Type relations for `Mu`

MuJunctionAny

[Expand above chart](https://docs.raku.org/images/type-graph-Mu.svg)
