原文：https://rakudocs.github.io/language/nativecall

# 原生调用协议 / Native calling interface

调用遵循 C 语言调用约定的动态库

Call into dynamic libraries that follow the C calling convention

<!-- MarkdownTOC -->

- [开始 / Getting started](#%E5%BC%80%E5%A7%8B--getting-started)
- [更名 / Changing names](#%E6%9B%B4%E5%90%8D--changing-names)
- [传递和返回值 / Passing and returning values](#%E4%BC%A0%E9%80%92%E5%92%8C%E8%BF%94%E5%9B%9E%E5%80%BC--passing-and-returning-values)
- [详细说明原生表示 / Specifying the native representation](#%E8%AF%A6%E7%BB%86%E8%AF%B4%E6%98%8E%E5%8E%9F%E7%94%9F%E8%A1%A8%E7%A4%BA--specifying-the-native-representation)
- [指针的基本使用 / Basic use of pointers](#%E6%8C%87%E9%92%88%E7%9A%84%E5%9F%BA%E6%9C%AC%E4%BD%BF%E7%94%A8--basic-use-of-pointers)
- [函数指针 / Function pointers](#%E5%87%BD%E6%95%B0%E6%8C%87%E9%92%88--function-pointers)
- [数组 / Arrays](#%E6%95%B0%E7%BB%84--arrays)
    - [CArray 方法 / CArray methods](#carray-%E6%96%B9%E6%B3%95--carray-methods)
- [结构体 / Structs](#%E7%BB%93%E6%9E%84%E4%BD%93--structs)
    - [CUnions](#cunions)
    - [嵌入 CStruct 和 CUnion / Embedding CStructs and CUnions](#%E5%B5%8C%E5%85%A5-cstruct-%E5%92%8C-cunion--embedding-cstructs-and-cunions)
    - [内存管理注意事项 / Notes on memory management](#%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86%E6%B3%A8%E6%84%8F%E4%BA%8B%E9%A1%B9--notes-on-memory-management)
        - [在你的 Raku 代码中 / In your Raku code...](#%E5%9C%A8%E4%BD%A0%E7%9A%84-raku-%E4%BB%A3%E7%A0%81%E4%B8%AD--in-your-raku-code)
        - [在你的 C 代码中 / In your C code...](#%E5%9C%A8%E4%BD%A0%E7%9A%84-c-%E4%BB%A3%E7%A0%81%E4%B8%AD--in-your-c-code)
- [类型化指针 / Typed pointers](#%E7%B1%BB%E5%9E%8B%E5%8C%96%E6%8C%87%E9%92%88--typed-pointers)
- [字符串 / Strings](#%E5%AD%97%E7%AC%A6%E4%B8%B2--strings)
    - [显式内存管理 / Explicit memory management](#%E6%98%BE%E5%BC%8F%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86--explicit-memory-management)
    - [缓冲区和二进制大对象 / Buffers and blobs](#%E7%BC%93%E5%86%B2%E5%8C%BA%E5%92%8C%E4%BA%8C%E8%BF%9B%E5%88%B6%E5%A4%A7%E5%AF%B9%E8%B1%A1--buffers-and-blobs)
- [函数参数 / Function arguments](#%E5%87%BD%E6%95%B0%E5%8F%82%E6%95%B0--function-arguments)
- [库路径和名称 / Library paths and names](#%E5%BA%93%E8%B7%AF%E5%BE%84%E5%92%8C%E5%90%8D%E7%A7%B0--library-paths-and-names)
    - [ABI/API 版本 / ABI/API version](#abiapi-%E7%89%88%E6%9C%AC--abiapi-version)
    - [例程 / Routine](#%E4%BE%8B%E7%A8%8B--routine)
    - [调用标准库 / Calling into the standard library](#%E8%B0%83%E7%94%A8%E6%A0%87%E5%87%86%E5%BA%93--calling-into-the-standard-library)
- [导出变量 / Exported variables](#%E5%AF%BC%E5%87%BA%E5%8F%98%E9%87%8F--exported-variables)
- [C++ 支持 / C++ support](#c-%E6%94%AF%E6%8C%81--c-support)
- [帮助程序函数 / Helper functions](#%E5%B8%AE%E5%8A%A9%E7%A8%8B%E5%BA%8F%E5%87%BD%E6%95%B0--helper-functions)
    - [nativecast 子例程 / sub nativecast](#nativecast-%E5%AD%90%E4%BE%8B%E7%A8%8B--sub-nativecast)
    - [cglobal 子例程 / sub cglobal](#cglobal-%E5%AD%90%E4%BE%8B%E7%A8%8B--sub-cglobal)
    - [nativesizeof 子例程 / sub nativesizeof](#nativesizeof-%E5%AD%90%E4%BE%8B%E7%A8%8B--sub-nativesizeof)
    - [explicitly-manage 子例程 / sub explicitly-manage](#explicitly-manage-%E5%AD%90%E4%BE%8B%E7%A8%8B--sub-explicitly-manage)
- [例子 / Examples](#%E4%BE%8B%E5%AD%90--examples)
    - [PostgreSQL](#postgresql)
    - [MySQL](#mysql)
    - [微软 Windows 系统 / Microsoft Windows](#%E5%BE%AE%E8%BD%AF-windows-%E7%B3%BB%E7%BB%9F--microsoft-windows)
    - [调用 C 函数的简短教程 / Short tutorial on calling a C function](#%E8%B0%83%E7%94%A8-c-%E5%87%BD%E6%95%B0%E7%9A%84%E7%AE%80%E7%9F%AD%E6%95%99%E7%A8%8B--short-tutorial-on-calling-a-c-function)

<!-- /MarkdownTOC -->

<a id="%E5%BC%80%E5%A7%8B--getting-started"></a>
# 开始 / Getting started

`NativeCall` 最简单的用法如下：

The simplest imaginable use of `NativeCall` would look something like this:

```Raku
use NativeCall;
sub some_argless_function() is native('something') { * }
some_argless_function();
```

第一行导入各种特性和类型。下一行看起来像是一个有点扭曲的相对普通的 Raku 子声明。我们使用 "native" 特性来指定函数实际上是在原生库中定义的。将为你添加特定于平台的扩展名（例如，`.so` 或 `.dll`），以及任何常用前缀（例如，'lib'）。

The first line imports various traits and types. The next line looks like a relatively ordinary Raku sub declaration—with a twist. We use the "native" trait in order to specify that the sub is actually defined in a native library. The platform-specific extension (e.g., `.so` or `.dll`), as well as any customary prefixes (e.g., 'lib') will be added for you.

第一次调用“某些无参数函数”时，将加载 "libsomething"，并在其中找到 "some_argless_function"。然后再调用这个找到的函数。由于保留了符号句柄，因此后续调用将更快。

The first time you call "some_argless_function", the "libsomething" will be loaded and the "some_argless_function" will be located in it. A call will then be made. Subsequent calls will be faster, since the symbol handle is retained.

当然，大多数函数都接受参数或返回值，但是你所能做的其他一切只是添加到这个简单的模式中，声明一个 Raku 函数，用你想要调用的符号命名它，并用 "native" 特性标记它。

Of course, most functions take arguments or return values—but everything else that you can do is just adding to this simple pattern of declaring a Raku sub, naming it after the symbol you want to call and marking it with the "native" trait.

你还需要声明和使用原生类型。有关详细信息，请查看[原生类型页面](https://rakudocs.github.io/language/nativetypes)。

You will also need to declare and use native types. Please check [the native types page](https://rakudocs.github.io/language/nativetypes) for more information.

<a id="%E6%9B%B4%E5%90%8D--changing-names"></a>
# 更名 / Changing names

有时，你希望 Raku 子例程的名称与你正在加载的库中使用的名称不同。可能名称很长，或者大小写不同，或者在你试图创建的模块上下文中很麻烦。

Sometimes you want the name of your Raku subroutine to be different from the name used in the library you're loading. Maybe the name is long or has different casing or is otherwise cumbersome within the context of the module you are trying to create.

NativeCall 提供了一个 `symbol` 特性，用于指定库中原生例程的名称，该名称可能与 Raku 子例程的名称不同。

NativeCall provides a `symbol` trait for you to specify the name of the native routine in your library that may be different from your Raku subroutine name.

```Raku
unit module Foo;
use NativeCall;
our sub init() is native('foo') is symbol('FOO_INIT') { * }
```

在 `libfoo` 内部有一个名为 `FOO_INIT` 的例程，但是，由于我们正在创建一个名为 Foo 的模块，我们宁愿将该例程称为 `Foo::init`，所以我们使用 `symbol` 特性来指定 `libfoo` 中符号的名称，并根据需要调用子例程（"init"）。

Inside of `libfoo` there is a routine called `FOO_INIT` but, since we're creating a module called Foo and we'd rather call the routine as `Foo::init`, we use the `symbol` trait to specify the name of the symbol in `libfoo` and call the subroutine whatever we want ("init" in this case).

<a id="%E4%BC%A0%E9%80%92%E5%92%8C%E8%BF%94%E5%9B%9E%E5%80%BC--passing-and-returning-values"></a>
# 传递和返回值 / Passing and returning values

普通的 Raku 签名和 'returns' 特性用于传递原生函数期望的参数类型及其返回的内容。下面是一个例子。

Normal Raku signatures and the `returns` trait are used in order to convey the type of arguments a native function expects and what it returns. Here is an example.

```Raku
use NativeCall;
sub add(int32, int32) returns int32 is native("calculator") { * }
```

这里，我们声明了函数接受两个 32 位整数并返回一个 32 位整数。你可以在[原生类型](https://rakudocs.github.io/language/nativetypes)页面中找到可以传递的其他类型。请注意，缺少 `returns` 特性用于指示 `void` 返回类型。*不要*在指针参数化之外的任何地方使用 `void` 类型。

Here, we have declared that the function takes two 32-bit integers and returns a 32-bit integer. You can find the other types that you may pass in the [native types](https://rakudocs.github.io/language/nativetypes) page. Note that the lack of a `returns` trait is used to indicate `void` return type. Do *not*use the `void` type anywhere except in the Pointer parameterization.

对于字符串，还有一个附加的 `encoded` 特性来提供一些关于如何进行封送处理的额外提示。

For strings, there is an additional `encoded` trait to give some extra hints on how to do the marshaling.

```Raku
use NativeCall;
sub message_box(Str is encoded('utf8')) is native('gui') { * }
```

要指定如何封送字符串返回类型，只需将此特性应用于例程本身。

To specify how to marshal string return types, just apply this trait to the routine itself.

```Raku
use NativeCall;
sub input_box() returns Str is encoded('utf8') is native('gui') { * }
```

请注意，可以通过传递 Str 类型对象来传递 `NULL` 字符串指针；类型对象也将表示 `NULL` 返回。

Note that a `NULL` string pointer can be passed by passing the Str type object; a `NULL` return will also be represented by the type object.

如果 C 函数要求字符串的生存期超过函数调用，则必须手动对参数进行编码，并将其作为 `CArray[uint8]` 传递：

If the C function requires the lifetime of a string to exceed the function call, the argument must be manually encoded and passed as `CArray[uint8]`:

```Raku
use NativeCall;

# C prototype is void set_foo(const char *) 
sub set_foo(CArray[uint8]) is native('foo') { * }

# C prototype is void use_foo(void) 
sub use_foo() is native('foo') { * } # will use pointer stored by set_foo() 
 
my $string = "FOO";

# The lifetime of this variable must be equal to the required lifetime of 
# the data passed to the C function. 
my $array = CArray[uint8].new($string.encode.list);
 
set_foo($array);
# ... 
use_foo();
# It's fine if $array goes out of scope starting from here.
```

<a id="%E8%AF%A6%E7%BB%86%E8%AF%B4%E6%98%8E%E5%8E%9F%E7%94%9F%E8%A1%A8%E7%A4%BA--specifying-the-native-representation"></a>
# 详细说明原生表示 / Specifying the native representation

在使用原生函数时，有时需要指定将使用哪种原生数据结构。使用 `is repr` 来指定。

When working with native functions, sometimes you need to specify what kind of native data structure is going to be used. `is repr` is the term employed for that.

```Raku
use NativeCall;
 
class timespec is repr('CStruct') {
    has uint32 $.tv_sec;
    has long $.tv_nanosecs;
}
 
sub clock_gettime(uint32 $clock-id, timespec $tspec --> uint32) is native { * };
 
my timespec $this-time .=new;
 
my $result = clock_gettime( 0, $this-time);
 
say "$result, $this-time"; # OUTPUT: «0, timespec<65385480>␤» 
```

我们调用的原始函数 [clock_gettime](https://linux.die.net/man/3/clock_gettime) 使用指向 `timespec` 结构的指针作为第二个参数。我们在这里将其声明为 [class](https://rakudocs.github.io/syntax/class)，但将其表示形式指定为 `is repr('CStruct')`，以指示它对应于 C 数据结构。当我们创建该类的对象时，我们创建的正是 `clock_gettime` 所期望的指针类型。这样，可以无缝地将数据传输到原生接口或从原生接口传输数据。

The original function we are calling, [clock_gettime](https://linux.die.net/man/3/clock_gettime), uses a pointer to the `timespec` struct as second argument. We declare it as a [class](https://rakudocs.github.io/syntax/class) here, but specify its representation as `is repr('CStruct')`, to indicate it corresponds to a C data structure. When we create an object of that class, we are creating exactly the kind of pointer `clock_gettime` expects. This way, data can be transferred seamlessly to and from the native interface.

<a id="%E6%8C%87%E9%92%88%E7%9A%84%E5%9F%BA%E6%9C%AC%E4%BD%BF%E7%94%A8--basic-use-of-pointers"></a>
# 指针的基本使用 / Basic use of pointers

当原生函数的签名需要指向某个原生类型（`int32`，`uint32`，等等）的指针时，只需声明参数 `is rw`:

When the signature of your native function needs a pointer to some native type (`int32`, `uint32`, etc.) all you need to do is declare the argument `is rw` :

```Raku
use NativeCall;
# C prototype is void my_version(int *major, int *minor) 
sub my_version(int32 is rw, int32 is rw) is native('foo') { * }
my_version(my int32 $major, my int32 $minor); # Pass a pointer to
```

有时你需要从 C 库中获取一个指针（例如库句柄）。你不在乎它指的是什么-你只需要抓住它。Pointer 类型为此而生。

Sometimes you need to get a pointer (for example, a library handle) back from a C library. You don't care about what it points to - you just need to keep hold of it. The Pointer type provides for this.

```Raku
use NativeCall;
sub Foo_init() returns Pointer is native("foo") { * }
sub Foo_free(Pointer) is native("foo") { * }
```

这是可行的，但你可能会喜欢使用名字比 Pointer 更好的类型事实证明，任何具有表示 "CPointer" 的类都可以充当这个角色。这意味着你可以通过编写这样的类来公开处理句柄的库：

This works out OK, but you may fancy working with a type named something better than Pointer. It turns out that any class with the representation "CPointer" can serve this role. This means you can expose libraries that work on handles by writing a class like this:

```Raku
use NativeCall;
 
class FooHandle is repr('CPointer') {
    # Here are the actual NativeCall functions. 
    sub Foo_init() returns FooHandle is native("foo") { * }
    sub Foo_free(FooHandle) is native("foo") { * }
    sub Foo_query(FooHandle, Str) returns int8 is native("foo") { * }
    sub Foo_close(FooHandle) returns int8 is native("foo") { * }
 
    # Here are the methods we use to expose it to the outside world. 
    method new {
        Foo_init();
    }
 
    method query(Str $stmt) {
        Foo_query(self, $stmt);
    }
 
    method close {
        Foo_close(self);
    }
 
    # Free data when the object is garbage collected. 
    submethod DESTROY {
        Foo_free(self);
    }
}
```

请注意，CPointer 表示只能保存 C 指针。这意味着类不能有额外的属性。然而，对于简单的库来说，这可能是一个向其公开面向对象接口的好方法。

Note that the CPointer representation can do nothing more than hold a C pointer. This means that your class cannot have extra attributes. However, for simple libraries this may be a neat way to expose an object oriented interface to it.

当然，你可以始终拥有一个空类：

Of course, you can always have an empty class:

```Raku
class DoorHandle is repr('CPointer') { }
```

像使用指针一样使用这个类，但有可能获得更好的类型安全性和更可读的代码。

And just use the class as you would use Pointer, but with potential for better type safety and more readable code.

类型对象再次用于表示空指针。

Once again, type objects are used to represent NULL pointers.

<a id="%E5%87%BD%E6%95%B0%E6%8C%87%E9%92%88--function-pointers"></a>
# 函数指针 / Function pointers

C 库可以将指向 C 函数的指针公开为函数的返回值和结构（如结构和联合）的成员。

C libraries can expose pointers to C functions as return values of functions and as members of Structures like, e.g., structs and unions.

调用函数 "f" 返回的函数指针 "$fptr" 的示例，使用定义所需函数参数和返回值的签名：

Example of invoking a function pointer "$fptr" returned by a function "f", using a signature defining the desired function parameters and return value:

```Raku
sub f() returns Pointer is native('mylib') { * }
 
my $fptr    = f();
my &newfunc = nativecast(:(Str, size_t --> int32), $fptr);
 
say newfunc("test", 4);
```

<a id="%E6%95%B0%E7%BB%84--arrays"></a>
# 数组 / Arrays

NativeCall 对数组有一些支持。它被限制使用机器大小的整数、双精度数和字符串、大小数值类型、指针数组、结构数组和数组的数组。

NativeCall has some support for arrays. It is constrained to work with machine-size integers, doubles and strings, sized numeric types, arrays of pointers, arrays of structs, and arrays of arrays.

Raku 数组除了支持惰性之外，在内存中的布局与C数组截然不同。因此，NativeCall 库提供了一种更为原始的 CArray 类型，在使用 C 数组时必须使用它。

Raku arrays, which support amongst other things laziness, are laid out in memory in a radically different way to C arrays. Therefore, the NativeCall library offers a much more primitive CArray type, which you must use if working with C arrays.

下面是传递 C 数组的示例。

Here is an example of passing a C array.

```Raku
sub RenderBarChart(Str, int32, CArray[Str], CArray[num64]) is native("chart") { * }
my @titles := CArray[Str].new;
@titles[0]  = 'Me';
@titles[1]  = 'You';
@titles[2]  = 'Hagrid';
my @values := CArray[num64].new;
@values[0]  = 59.5e0;
@values[1]  = 61.2e0;
@values[2]  = 180.7e0;
RenderBarChart('Weights (kg)', 3, @titles, @values);
```

请注意，绑定用于 `@titles`，*而不是*赋值！如果你赋值，你将把这些值放入一个 Raku 数组中，它将不起作用。如果这一切都让你抓狂了，那就忘了你对 `@` 符号有任何了解，在使用 NativeCall 时只需一直使用 `$`。

Note that binding was used to `@titles`, *not* assignment! If you assign, you are putting the values into a Raku array, and it will not work out. If this all freaks you out, forget you ever knew anything about the `@` sigil and just use `$` all the way when using NativeCall.

```Raku
use NativeCall;
my $titles = CArray[Str].new;
$titles[0] = 'Me';
$titles[1] = 'You';
$titles[2] = 'Hagrid';
```

获取数组的返回值的效果是一样的。

Getting return values for arrays works out just the same.

某些库 API 可能将数组作为缓冲区，该缓冲区将由 C 函数填充，例如，返回实际填充的项目数：

Some library APIs may take an array as a buffer that will be populated by the C function and, for instance, return the actual number of items populated:

```Raku
use NativeCall;
sub get_n_ints(CArray[int32], int32) returns int32 is native('ints') { * }
```

在这些情况下，在将 CArray 传递给原生子程序之前，填充元素的数量是很重要的，否则 C 函数可能会在 Raku 的内存中堆积，从而导致可能无法预测的行为：

In these cases it is important that the CArray has at least the number of elements that are going to be populated before passing it to the native subroutine, otherwise the C function may stomp all over Raku's memory leading to possibly unpredictable behavior:

```Raku
my $number_of_ints = 10;
my $ints = CArray[int32].allocate($number_of_ints); # instantiates an array with 10 elements 
my $n = get_n_ints($ints, $number_of_ints);
```

*注*： `allocate` 在 Rakudo 2018.05 中引入。在此之前，必须使用此机制将数组扩展到多个元素：

*Note*: `allocate` was introduced in Rakudo 2018.05. Before that, you had to use this mechanism to extend an array to a number of elements:

```Raku
my $ints = CArray[int32].new;
my $number_of_ints = 10;
$ints[$number_of_ints - 1] = 0; # extend the array to 10 items 
```

要理解数组的内存管理是很重要的。当你自己创建一个数组时，你可以根据需要向它添加元素，并且它将根据需要进行扩展。但是，这可能会导致它在内存中被移动（但是，对现有元素的分配永远不会导致这种情况）。这意味着，如果在将数组传递到 C 库后，再操作数组，你最好知道自己在做什么。

The memory management of arrays is important to understand. When you create an array yourself, then you can add elements to it as you wish and it will be expanded for you as required. However, this may result in it being moved in memory (assignments to existing elements will never cause this, however). This means you'd best know what you're doing if you twiddle with an array after passing it to a C library.

相反，当 C 库向你返回一个数组时，内存就不能由 NativeCall 管理，而且它不知道数组的结束位置。想必，库 API 中的某些内容告诉了你这一点（例如，你知道当你看到一个空元素时，不应该再进一步阅读）。请注意，NativeCall 在这里不能为你提供任何保护—做错误的事情，你将得到一个 segfault 或导致内存损坏。这不是 NativeCall 的缺点，这是又大又坏的原生世界的工作方式。害怕了？来，拥抱一下。祝你好运！

By contrast, when a C library returns an array to you, then the memory can not be managed by NativeCall, and it doesn't know where the array ends. Presumably, something in the library API tells you this (for example, you know that when you see a null element, you should read no further). Note that NativeCall can offer you no protection whatsoever here - do the wrong thing, and you will get a segfault or cause memory corruption. This isn't a shortcoming of NativeCall, it's the way the big bad native world works. Scared? Here, have a hug. Good luck!

<a id="carray-%E6%96%B9%E6%B3%95--carray-methods"></a>
## CArray 方法 / CArray methods

除了每个 Raku 实例上可用的常规方法之外，`CArray` 还提供了以下方法，从 Raku 的角度来看，这些方法可以用来和它进行交互：

Besides the usual methods available on every Raku instance, `CArray` provides the following methods that can be used to interact with the it from the Raku point of view:

- `elems` 提供了数组中的元素数；
- `at-pos` 在给定位置提供特定元素（从零开始）；
- `list` 提供从原生数组迭代器生成数组中元素的[列表](https://rakudocs.github.io/type/List)。

- `elems` provides the number of elements within the array;
- `AT-POS` provides a specific element at the given position (starting from zero);
- `list` provides the [List](https://rakudocs.github.io/type/List) of elements within the array building it from the native array iterator.

例如，考虑以下简单的代码：

As an example, consider the following simple piece of code:

```Raku
use NativeCall;
 
my $native-array = CArray[int32].new( 1, 2, 3, 4, 5 );
say 'Number of elements: ' ~ $native-array.elems;
 
# walk the array 
for $native-array.list -> $elem {
    say "Current element is: $elem";
}
 
# get every element by its index-based position 
for 0..$native-array.elems - 1 -> $position {
    say "Element at position $position is "
          ~ $native-array.AT-POS( $position );
}
 
```

产生以下输出

that produces the following output

```Raku
Number of elements: 5
Current element is: 1
Current element is: 2
Current element is: 3
Current element is: 4
Current element is: 5
Element at position 0 is 1
Element at position 1 is 2
Element at position 2 is 3
Element at position 3 is 4
Element at position 4 is 5
```

<a id="%E7%BB%93%E6%9E%84%E4%BD%93--structs"></a>
# 结构体 / Structs

由于表示多态性，可以声明一个外观正常的 Raku 类，该类在底层以 C 编译器将它们放在类似结构定义中的方式存储其属性。只需使用 "repr" 特性：

Thanks to representation polymorphism, it's possible to declare a normal looking Raku class that, under the hood, stores its attributes in the same way a C compiler would lay them out in a similar struct definition. All it takes is a quick use of the "repr" trait:

```Raku
class Point is repr('CStruct') {
    has num64 $.x;
    has num64 $.y;
}
```

属性只能是 NativeCall 知道如何封送到结构字段中的类型。当前，结构可以包含机器大小的整数、双精度数、字符串和其他 NativeCall 对象（CArrays，以及使用 CPointer 和 CStruct repr 的对象）。除此之外，你可以对一个类执行通常的一组操作；你甚至可以让一些属性来自角色或从另一个类继承它们。当然，方法也很好。疯狂吧！

The attributes can only be of the types that NativeCall knows how to marshal into struct fields. Currently, structs can contain machine-sized integers, doubles, strings, and other NativeCall objects (CArrays, and those using the CPointer and CStruct reprs). Other than that, you can do the usual set of things you would with a class; you could even have some of the attributes come from roles or have them inherited from another class. Of course, methods are completely fine too. Go wild!

CStruct 对象通过引用传递给原生函数，原生函数还必须通过引用返回 CStruct 对象。这些引用的内存管理规则非常类似于数组的规则，但更简单，因为从未调整结构的大小。当你创建一个结构时，内存是为你管理的，当指向 CStruct 实例的变量消失时，当 GC 遇到它时，内存将被释放。当基于 CStruct 的类型用作原生函数的返回类型时，GC 不会为你管理内存。

CStruct objects are passed to native functions by reference and native functions must also return CStruct objects by reference. The memory management rules for these references are very much like the rules for arrays, though simpler since a struct is never resized. When you create a struct, the memory is managed for you and when the variable(s) pointing to the instance of a CStruct go away, the memory will be freed when the GC gets to it. When a CStruct-based type is used as the return type of a native function, the memory is not managed for you by the GC.

NativeCall 当前不将对象成员放入容器中，因此为其分配新值（with=）不起作用。相反，你必须将新值绑定到私有成员：

NativeCall currently doesn't put object members in containers, so assigning new values to them (with =) doesn't work. Instead, you have to bind new values to the private members:

```Raku
class MyStruct is repr('CStruct') {
    has CArray[num64] $!arr;
    has Str $!str;
    has Point $!point; # Point is a user-defined class 
 
    submethod TWEAK {
        my $arr := CArray[num64].new;
        $arr[0] = 0.9e0;
        $arr[1] = 0.2e0;
        $!arr := $arr;
        $!str := 'Raku is fun';
        $!point := Point.new;
    }
}
```

正如你现在所预测的，空指针由结构类型的类型对象表示。

As you may have predicted by now, a NULL pointer is represented by the type object of the struct type.

<a id="cunions"></a>
## CUnions

同样，可以声明一个 Raku 类，它以 C 编译器在类似的 `union` 定义中对其属性进行布局的方式存储其属性；使用 `CUnion` 表示：

Likewise, it is possible to declare a Raku class that stores its attributes the same way a C compiler would lay them out in a similar `union` definition; using the `CUnion` representation:

```Raku
use NativeCall;
 
class MyUnion is repr('CUnion') {
    has int32 $.flags32;
    has int64 $.flags64;
}
 
say nativesizeof(MyUnion.new);  # OUTPUT: «8␤» 
                                # ie. max(sizeof(MyUnion.flags32), sizeof(MyUnion.flags64)) 
```

<a id="%E5%B5%8C%E5%85%A5-cstruct-%E5%92%8C-cunion--embedding-cstructs-and-cunions"></a>
## 嵌入 CStruct 和 CUnion / Embedding CStructs and CUnions

CStruct 和 CUnion 可以依次被周围的 CStruct 和 CUnion 所引用或嵌入。要说前者，我们像往常一样使用 `has`，而要说后者，我们使用 `HAS` 声明符：

CStructs and CUnions can be in turn referenced by—or embedded into—a surrounding CStruct and CUnion. To say the former we use `has` as usual, and to do the latter we use the `HAS` declarator instead:

```Raku
class MyStruct is repr('CStruct') {
    has Point $.point;  # referenced 
    has int32 $.flags;
}
 
say nativesizeof(MyStruct.new);  # OUTPUT: «16␤» 
                                 # ie. sizeof(struct Point *) + sizeof(int32_t) 
 
class MyStruct2 is repr('CStruct') {
    HAS Point $.point;  # embedded 
    has int32 $.flags;
}
 
say nativesizeof(MyStruct2.new);  # OUTPUT: «24␤» 
                                  # ie. sizeof(struct Point) + sizeof(int32_t) 
```

<a id="%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86%E6%B3%A8%E6%84%8F%E4%BA%8B%E9%A1%B9--notes-on-memory-management"></a>
## 内存管理注意事项 / Notes on memory management

当分配用作结构的结构时，请确保在 C 函数中分配自己的内存。如果要将结构传递到需要提前分配 `Str`/`char*` 的 C 函数中，请确保在将结构传递到函数之前为 `Str` 类型的变量分配一个容器。

When allocating a struct for use as a struct, make sure that you allocate your own memory in your C functions. If you're passing a struct into a C function which needs a `Str`/`char*` allocated ahead of time, be sure to assign a container for a variable of type `Str` prior to passing your struct into the function.

<a id="%E5%9C%A8%E4%BD%A0%E7%9A%84-raku-%E4%BB%A3%E7%A0%81%E4%B8%AD--in-your-raku-code"></a>
### 在你的 Raku 代码中 / In your Raku code...

```Raku
class AStringAndAnInt is repr("CStruct") {
  has Str $.a_string;
  has int32 $.an_int32;
 
  sub init_struct(AStringAndAnInt is rw, Str, int32) is native('simple-struct') { * }
 
  submethod BUILD(:$a_string, :$an_int) {
    init_struct(self, $a_string, $an_int);
  }
}
 
```

在这段代码中，我们首先设置成员 `$.a_string` 和 `$.an_int32`。在此之后，我们声明 `init_struct()` 函数为了 `init()` 方法可以将其进行包装；然后从 `BUILD` 调用此函数，以便在返回创建的对象之前有效地分配值。

In this code we first set up our members, `$.a_string` and `$.an_int32`. After that we declare our `init_struct()` function for the `init()` method to wrap around; this function is then called from `BUILD` to effectively assign the values before returning the created object.

<a id="%E5%9C%A8%E4%BD%A0%E7%9A%84-c-%E4%BB%A3%E7%A0%81%E4%B8%AD--in-your-c-code"></a>
### 在你的 C 代码中 / In your C code...

```C
typedef struct a_string_and_an_int32_t_ {
  char *a_string;
  int32_t an_int32;
} a_string_and_an_int32_t;
 
```

这是结构。注意这里有一个 `char *`。

Here's the structure. Notice how we've got a `char *` there.

```C
void init_struct(a_string_and_an_int32_t *target, char *str, int32_t int32) {
  target->an_int32 = int32;
  target->a_string = strdup(str);
 
  return;
}
 
```

在这个函数中，我们通过按值分配一个整数并通过引用传递字符串来初始化 C 结构。函数在复制字符串时，在结构中分配指向 <char *a_string> 的内存。（注意，你还必须管理内存的释放，以避免内存泄漏。）

In this function we initialize the C structure by assigning an integer by value, and passing the string by reference. The function allocates memory that it points <char *a_string> to within the structure as it copies the string. (Note you will also have to manage deallocation of the memory as well to avoid memory leaks.)

```Raku
# A long time ago in a galaxy far, far away... 
my $foo = AStringAndAnInt.new(a_string => "str", an_int => 123);
say "foo is {$foo.a_string} and {$foo.an_int32}";
# OUTPUT: «foo is str and 123␤» 
```

<a id="%E7%B1%BB%E5%9E%8B%E5%8C%96%E6%8C%87%E9%92%88--typed-pointers"></a>
# 类型化指针 / Typed pointers

你可以通过将类型作为参数传递来键入 `Pointer`。它可以与原生类型一起使用，也可以与 `CArray` 和 `CStruct` 定义的类型一起使用。即使对 NativeCall 调用 `new`，也不会隐式地为其分配内存。对于返回指针的 C 例程，或者是嵌入在 `CStruct` 中的指针，它最有用。

You can type your `Pointer` by passing the type as a parameter. It works with the native type but also with `CArray` and `CStruct` defined types. NativeCall will not implicitly allocate the memory for it even when calling `new` on them. It's mostly useful in the case of a C routine returning a pointer, or if it's a pointer embedded in a `CStruct`.

```Raku
use NativeCall;
sub strdup(Str $s --> Pointer[Str]) is native {*}
my Pointer[Str] $p = strdup("Success!");
say $p.deref;
```

你必须调用 `Pointer` 上的 `.deref` 才能访问嵌入的类型。在上面的示例中，声明指针的类型可以避免取消引用时的类型转换错误。请注意，原始的 [`strdup`](https://en.cppreference.com/w/c/experimental/dynamic/strdup) 返回指向 `char` 的指针；我们使用的是 `Pointer<Str>`。

You have to call `.deref` on `Pointer`s to access the embedded type. In the example above, declaring the type of the pointer avoids typecasting error when dereferenced. Please note that the original [`strdup`](https://en.cppreference.com/w/c/experimental/dynamic/strdup) returns a pointer to `char`; we are using `Pointer<Str>`.

```Raku
my Pointer[int32] $p; #For a pointer on int32; 
my Pointer[MyCstruct] $p2 = some_c_routine();
my MyCstruct $mc = $p2.deref;
say $mc.field1;
```

原生函数返回指向元素数组的指针是很常见的。类型化指针可以作为数组解引用以获取单个元素。

It's quite common for a native function to return a pointer to an array of elements. Typed pointers can be dereferenced as an array to obtain individual elements.

```Raku
my $n = 5;
# returns a pointer to an array of length $n 
my Pointer[Point] $plot = some_other_c_routine($n);
# display the 5 elements in the array 
for 1 .. $n -> $i {
    my $x = $plot[$i - 1].x;
    my $y = $plot[$i - 1].y;
    say "$i: ($x, $y)";
}
```

还可以更新指针以引用数组中的连续元素：

Pointers can also be updated to reference successive elements in the array:

```Raku
my Pointer[Point] $elem = $plot;
# show differences between successive points 
for 1 ..^ $n {
    my Point $lo = $elem.deref;
    ++$elem; # equivalent to $elem = $elem.add(1); 
    my Point $hi = (++$elem).deref;
    my $dx = $hi.x = $lo.x;
    my $dy = $hi.y = $lo.y;
    say "$_: delta ($dx, $dy)";
}
```

void 指针也可以通过声明它们 `Pointer[void]` 来使用。有关主题的详细信息，请参阅[原生类型文档](https://rakudocs.github.io/language/nativetypes#The_void_type)。

Void pointers can also be used by declaring them `Pointer[void]`. Please consult [the native types documentation](https://rakudocs.github.io/language/nativetypes#The_void_type) for more information on the subject.

<a id="%E5%AD%97%E7%AC%A6%E4%B8%B2--strings"></a>
# 字符串 / Strings

<a id="%E6%98%BE%E5%BC%8F%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86--explicit-memory-management"></a>
## 显式内存管理 / Explicit memory management

假设有一些 C 代码缓存传递的字符串，比如：

Let's say there is some C code that caches strings passed, like so:

```C
#include <stdlib.h> 
 
static char *__VERSION;
 
char *
get_version()
{
    return __VERSION;
}
 
char *
set_version(char *version)
{
    if (__VERSION != NULL) free(__VERSION);
    __VERSION = version;
    return __VERSION;
}
```

如果你要为 `get_version` 和 `set_version` 编写绑定，它们最初会像这样，但不会按预期工作：

If you were to write bindings for `get_version` and `set_version`, they would initially look like this, but will not work as intended:

```Raku
sub get_version(--> Str)     is native('./version') { * }
sub set_version(Str --> Str) is native('./version') { * }
 
say set_version('1.0.0'); # 1.0.0 
say get_version;          # Differs on each run 
say set_version('1.0.1'); # Double free; segfaults 
```

这段代码在第二个 `set_version` 调用中出错，因为它试图释放垃圾收集器完成后第一个调用传递的字符串。如果垃圾收集器不释放传递给原生函数的字符串，请将 `explicitly-manage` 与它一起使用：

This code segfaults on the second `set_version` call because it tries to free the string passed on the first call after the garbage collector had already done so. If the garbage collector shouldn't free a string passed to a native function, use `explicitly-manage` with it:

```Raku
say set_version(explicitly-manage('1.0.0')); # 1.0.0 
say get_version;                             # 1.0.0 
say set_version(explicitly-manage('1.0.1')); # 1.0.1 
say get_version;                             # 1.0.1 
```

记住，显式管理字符串的所有内存管理必须由 C 库本身或通过 NativeCall API 来处理，以防止内存泄漏。

Bear in mind all memory management for explicitly managed strings must be handled by the C library itself or through the NativeCall API to prevent memory leaks.

<a id="%E7%BC%93%E5%86%B2%E5%8C%BA%E5%92%8C%E4%BA%8C%E8%BF%9B%E5%88%B6%E5%A4%A7%E5%AF%B9%E8%B1%A1--buffers-and-blobs"></a>
## 缓冲区和二进制大对象 / Buffers and blobs

[Blob](https://rakudocs.github.io/type/Blob) 和 [Buf](https://rakudocs.github.io/type/Buf) 是 Raku 存储二进制数据的方法。我们可以使用它们与原生函数和数据结构交换数据，尽管不是直接的。我们必须使用 [`nativecast`](https://rakudocs.github.io/routine/nativecast)。

[Blob](https://rakudocs.github.io/type/Blob)s and [Buf](https://rakudocs.github.io/type/Buf)s are the Raku way of storing binary data. We can use them for interchange of data with native functions and data structures, although not directly. We will have to use [`nativecast`](https://rakudocs.github.io/routine/nativecast).

```Raku
my $blob = Blob.new(0x22, 0x33);
my $src = nativecast(Pointer, $blob);
```

然后，这个 `$src` 可以用作接受指针的任何原生函数的参数。相反，不直接支持将 `Pointer` 指向的值放入 `Buf` 或使用它初始化 `Blob`。你可能希望使用 [`NativeHelpers::Blob`](https://github.com/salortiz/NativeHelpers-Blob) 执行此类操作。

This `$src` can then be used as an argument for any native function that takes a Pointer. The opposite, putting values pointed to by a `Pointer` into a `Buf` or using it to initialize a `Blob` is not directly supported. You might want to use [`NativeHelpers::Blob`](https://github.com/salortiz/NativeHelpers-Blob) to do this kind of operations.

```Raku
my $esponja = blob-from-pointer( $inter, :2elems, :type(Blob[int8]));
say $esponja;
```

<a id="%E5%87%BD%E6%95%B0%E5%8F%82%E6%95%B0--function-arguments"></a>
# 函数参数 / Function arguments

NativeCall 还支持将函数作为参数的本机函数。其中一个例子是在事件驱动系统中使用函数指针作为回调。通过nativeCall绑定这些函数时，只需提供与[代码参数约束]相同的签名（https://rakudocs.github.io/type/signature constraining_signatures_of_callables）。但是，对于 nativeCall，从 rakudo 2019.07 开始，函数参数和签名之间的空格以及普通签名文本的冒号被省略，如下所示：

NativeCall also supports native functions that take functions as arguments. One example of this is using function pointers as callbacks in an event-driven system. When binding these functions via NativeCall, one needs only provide the equivalent signature as [a constraint on the code parameter](https://rakudocs.github.io/type/Signature#Constraining_signatures_of_Callables). In the case of NativeCall, however, as of Rakudo 2019.07, a space between the function argument and the signature, and the colon of a normal Signature literal is omitted, as in:

```Raku
use NativeCall;
# void SetCallback(int (*callback)(const char *)) 
my sub SetCallback(&callback (Str --> int32)) is native('mylib') { * }
```

注意：原生代码负责以这种方式传递给 Raku 回调的值的内存管理。换句话说，NativeCall 不会释放传递给回调的字符串。

Note: the native code is responsible for memory management of values passed to Raku callbacks this way. In other words, NativeCall will not free() strings passed to callbacks.

<a id="%E5%BA%93%E8%B7%AF%E5%BE%84%E5%92%8C%E5%90%8D%E7%A7%B0--library-paths-and-names"></a>
# 库路径和名称 / Library paths and names

`native` 特性接受库名、完整路径或返回这两者之一的子例程。当使用库名称时，假定名称前面加上 "lib" 和 ".so"（或在 Windows 上加上 ".dll"），并将在 LD_LIBRARY_PATH（Windows 为 PATH）环境变量的路径中进行搜索。

The `native` trait accepts the library name, the full path, or a subroutine returning either of the two. When using the library name, the name is assumed to be prepended with "lib" and appended with ".so" (or just appended with ".dll" on Windows), and will be searched for in the paths in the LD_LIBRARY_PATH (PATH on Windows) environment variable.

```Raku
use NativeCall;
constant LIBMYSQL = 'mysqlclient';
constant LIBFOO = '/usr/lib/libfoo.so.1';
sub LIBBAR {
    my $path = qx/pkg-config --libs libbar/.chomp;
    $path ~~ s/\/[[\w+]+ % \/]/\0\/bar/;
    $path
}
# and later 
 
sub mysql_affected_rows returns int32 is native(LIBMYSQL) {*};
sub bar is native(LIBFOO) {*}
sub baz is native(LIBBAR) {*}
```

你还可以放置不完整的路径，如 './foo'，NativeCall 将根据平台规范自动放置正确的扩展名。如果希望抑制此扩展，只需将字符串作为代码块体传递。

You can also put an incomplete path like './foo' and NativeCall will automatically put the right extension according to the platform specification. If you wish to suppress this expansion, simply pass the string as the body of a block.

```Raku
sub bar is native({ './lib/Non Standard Naming Scheme' }) {*}
```

注意：编译时对 `native` 特性和 `constant` 进行评估。不要编写依赖于动态变量的常量，例如：

BE CAREFUL: the `native` trait and `constant` are evaluated at compile time. Don't write a constant that depends on a dynamic variable like:

```Raku
# WRONG: 
constant LIBMYSQL = %*ENV<P6LIB_MYSQLCLIENT> || 'mysqlclient';
```

这将保留编译时给定的值。模块将被预编译，`LIBMYSQL` 将保留模块预编译时获取的值。

This will keep the value given at compile time. A module will be precompiled and `LIBMYSQL` will keep the value it acquires when the module gets precompiled.

<a id="abiapi-%E7%89%88%E6%9C%AC--abiapi-version"></a>
## ABI/API 版本 / ABI/API version

如果编写 `native('foo')` NativeCall，将在类 Unix 系统下搜索 libfoo.so（OS X 上的 libfoo.dynlib，Win32 上的 foo.dll）。在大多数现代系统中，它将要求你或模块的用户安装开发包，建议始终向共享库提供 API/ABI版本，因此 libfoo.so 结尾通常是开发包提供的符号链接。

If you write `native('foo')` NativeCall will search libfoo.so under Unix like system (libfoo.dynlib on OS X, foo.dll on win32). In most modern system it will require you or the user of your module to install the development package because it's recommended to always provide an API/ABI version to a shared library, so libfoo.so ends often being a symbolic link provided only by a development package.

为了避免这种情况发生，`native` 特性允许你指定API/ABI 版本。它可以是完整版本，也可以只是其中的一部分。（尽量坚持主版本，有些 BSD 代码不关心次版本。）

To avoid that, the `native` trait allows you to specify the API/ABI version. It can be a full version or just a part of it. (Try to stick to Major version, some BSD code does not care for Minor.)

```Raku
use NativeCall;
sub foo1 is native('foo', v1) {*} # Will try to load libfoo.so.1 
sub foo2 is native('foo', v1.2.3) {*} # Will try to load libfoo.so.1.2.3 
 
my List $lib = ('foo', 'v1');
sub foo3 is native($lib) {*}
```

<a id="%E4%BE%8B%E7%A8%8B--routine"></a>
## 例程 / Routine

`native` 特性还接受 `Callable` 作为参数，允许你提供自己的方法来处理它将查找要加载的库文件的方式。

The `native` trait also accepts a `Callable` as argument, allowing you to provide your own way to handle the way it will find the library file to load.

```Raku
use NativeCall;
sub foo is native(sub {'libfoo.so.42'}) {*}
```

它只在第一次调用 sub 时调用。

It will only be called at the first invocation of the sub.

<a id="%E8%B0%83%E7%94%A8%E6%A0%87%E5%87%86%E5%BA%93--calling-into-the-standard-library"></a>
## 调用标准库 / Calling into the standard library

如果你想从标准库或你自己的程序调用已经加载的 C 函数，可以省略该值，`is native` 中的值也一样。

If you want to call a C function that's already loaded, either from the standard library or from your own program, you can omit the value, so `is native`.

例如，在类 Unix 的操作系统上，可以使用以下代码打印当前用户的主目录：

For example on a UNIX-like operating system, you could use the following code to print the home directory of the current user:

```Raku
use NativeCall;
my class PwStruct is repr('CStruct') {
    has Str $.pw_name;
    has Str $.pw_passwd;
    has uint32 $.pw_uid;
    has uint32 $.pw_gid;
    has Str $.pw_gecos;
    has Str $.pw_dir;
    has Str $.pw_shell;
}
sub getuid()              returns uint32   is native { * };
sub getpwuid(uint32 $uid) returns PwStruct is native { * };
 
say getpwuid(getuid()).pw_dir;
```

当然，`$*HOME` 是一个简单得多的方法：—）

Though of course `$*HOME` is a much easier way :-)

<a id="%E5%AF%BC%E5%87%BA%E5%8F%98%E9%87%8F--exported-variables"></a>
# 导出变量 / Exported variables

库导出的变量（也称为“全局”或“外部”变量）可以使用 `cglobal` 访问。例如：

Variables exported by a library – also named "global" or "extern" variables – can be accessed using `cglobal`. For example:

```Raku
my $var := cglobal('libc.so.6', 'errno', int32)
```

此代码绑定到 `$var` 一个新的 [Proxy](https://rakudocs.github.io/type/Proxy) 对象，该对象将其所有访问重定向到由 "libc.so.6" 库导出的名为 "errno" 的整数变量。

This code binds to `$var` a new [Proxy](https://rakudocs.github.io/type/Proxy) object that redirects all its accesses to the integer variable named "errno" as exported by the "libc.so.6" library.

<a id="c-%E6%94%AF%E6%8C%81--c-support"></a>
# C++ 支持 / C++ support

NativeCall 支持使用 C++ 类和方法，如在 <https://github.com/rakudo/rakudo/blob/master/t/04-nativecall/13-cpp-mangling.t>（及其关联 C++ 文件）中所示。请注意，目前它还没有 C 支持那样经过测试和开发。

NativeCall offers support to use classes and methods from C++ as shown in <https://github.com/rakudo/rakudo/blob/master/t/04-nativecall/13-cpp-mangling.t> (and its associated C++ file). Note that at the moment it's not as tested and developed as C support.

<a id="%E5%B8%AE%E5%8A%A9%E7%A8%8B%E5%BA%8F%E5%87%BD%E6%95%B0--helper-functions"></a>
# 帮助程序函数 / Helper functions

`NativeCall` 库导出多个子例程以帮助你处理来自本机库的数据。

The `NativeCall` library exports several subroutines to help you work with data from native libraries.

<a id="nativecast-%E5%AD%90%E4%BE%8B%E7%A8%8B--sub-nativecast"></a>
## nativecast 子例程 / sub nativecast

```Raku
sub nativecast($target-type, $source) is export(:DEFAULT)
```

这将将指针 `$source` 强制转换为 `$target-type` 的对象。源指针通常是通过调用返回指针的原生子例程或作为 `struct` 的成员获得的，例如，在 `C` 库定义中可以将其指定为 `void *`，但也可以从指针强制转换为更具体的类型一个。

This will *cast* the Pointer `$source` to an object of `$target-type`. The source pointer will typically have been obtained from a call to a native subroutine that returns a pointer or as a member of a `struct`, this may be specified as `void *` in the `C` library definition for instance, but you may also cast from a pointer to a less specific type to a more specific one.

在特殊情况下，如果将[签名](https://rakudocs.github.io/type/Signature)作为 `$target-type` 提供，则将返回一个 `subroutine`，它将调用由 `$source` 指向的原生函数，方法与用 `native` 特性声明的子例程相同。这在[函数指针](https://rakudocs.github.io/language/nativecall#Function_pointers)中描述。

As a special case, if a [Signature](https://rakudocs.github.io/type/Signature) is supplied as `$target-type` then a `subroutine` will be returned which will call the native function pointed to by `$source` in the same way as a subroutine declared with the `native` trait. This is described in [Function Pointers](https://rakudocs.github.io/language/nativecall#Function_pointers).

<a id="cglobal-%E5%AD%90%E4%BE%8B%E7%A8%8B--sub-cglobal"></a>
## cglobal 子例程 / sub cglobal

```Raku
sub cglobal($libname, $symbol, $target-type) is export is rw
```

这将返回一个 [Proxy](https://rakudocs.github.io/type/Proxy) 对象，该对象提供对指定库公开的名为 `$symbol` 的 `extern` 的访问。库的指定方式与 `native` 特性相同。

This returns a [Proxy](https://rakudocs.github.io/type/Proxy) object that provides access to the `extern` named `$symbol` that is exposed by the specified library. The library can be specified in the same ways that they can be to the `native` trait.

<a id="nativesizeof-%E5%AD%90%E4%BE%8B%E7%A8%8B--sub-nativesizeof"></a>
## nativesizeof 子例程 / sub nativesizeof

```Raku
sub nativesizeof($obj) is export(:DEFAULT)
```

这将返回所提供对象的字节大小，可以认为它等同于  **C** 中的 `sizeof`。对象可以是内置的原生类型，如 `int64` 或 `num64`、`CArray` 或具有 `repr`、`CStruct`、`CUnion` 或 `CPointer` 的类。

This returns the size in bytes of the supplied object, it can be thought of as being equivalent to `sizeof` in **C**. The object can be a builtin native type such as `int64` or `num64`, a `CArray` or a class with the `repr` `CStruct`, `CUnion` or `CPointer`.

<a id="explicitly-manage-%E5%AD%90%E4%BE%8B%E7%A8%8B--sub-explicitly-manage"></a>
## explicitly-manage 子例程 / sub explicitly-manage

```Raku
sub explicitly-manage($str) is export(:DEFAULT)
```

这将返回给定 `Str` 的 `CStr` 对象。如果返回的字符串传递给 NativeCall 子例程，则运行时的垃圾收集器将不会释放该字符串。

This returns a `CStr` object for the given `Str`. If the string returned is passed to a NativeCall subroutine, it will not be freed by the runtime's garbage collector.

<a id="%E4%BE%8B%E5%AD%90--examples"></a>
# 例子 / Examples

一些特定的例子，以及在特定平台中使用上述例子的说明。

Some specific examples, and instructions to use examples above in particular platforms.

<a id="postgresql"></a>
## PostgreSQL

[DBIish](https://github.com/perl6/DBIish/blob/master/examples/pg.p6) 中的 PostgreSQL 示例使用原生调用库，而 `is native` 则使用 Windows 中的原生 `_putenv` 函数调用。

The PostgreSQL examples in [DBIish](https://github.com/perl6/DBIish/blob/master/examples/pg.p6) make use of the NativeCall library and `is native` to use the native `_putenv` function call in Windows.

<a id="mysql"></a>
## MySQL

**注意：**请记住，自 Stretch 版本以来，Debian 已经用 Mariadb 替换了 MySQL，因此如果要安装 MySQL，请使用 [MySQL APT repository](https://dev.mysql.com/downloads/repo/apt/) 而不是默认的存储库。

**NOTE:** Please bear in mind that, under the hood, Debian has substituted MySQL with MariaDB since the Stretch version, so if you want to install MySQL, use [MySQL APT repository](https://dev.mysql.com/downloads/repo/apt/) instead of the default repository.

要使用 [DBIish](https://github.com/perl6/DBIish/blob/master/examples/mysql.p6) 中的 MySQL 示例，你需要在本地安装 MySQL 服务器；在 Debian-esque 系统上，它可以安装如下内容：

To use the MySQL example in [DBIish](https://github.com/perl6/DBIish/blob/master/examples/mysql.p6), you'll need to install MySQL server locally; on Debian-esque systems it can be installed with something like:

```Shell
wget https://dev.mysql.com/get/mysql-apt-config_0.8.10-1_all.deb
sudo dpkg -i mysql-apt-config_0.8.10-1_all.deb # Don't forget to select 5.6.x 
sudo apt-get update
sudo apt-get install mysql-community-server -y
sudo apt-get install libmysqlclient18 -y
```

在尝试示例之前，请按照以下步骤准备系统：

Prepare your system along these lines before trying out the examples:

```Shell
$ mysql -u root -p
SET PASSWORD = PASSWORD('sa');
DROP DATABASE test;
CREATE DATABASE test;
```

<a id="%E5%BE%AE%E8%BD%AF-windows-%E7%B3%BB%E7%BB%9F--microsoft-windows"></a>
## 微软 Windows 系统 / Microsoft Windows

以下是 Windows API 调用的示例：

Here is an example of a Windows API call:

```Raku
use NativeCall;
 
sub MessageBoxA(int32, Str, Str, int32)
    returns int32
    is native('user32')
    { * }
 
MessageBoxA(0, "We have NativeCall", "ohai", 64);
```

<a id="%E8%B0%83%E7%94%A8-c-%E5%87%BD%E6%95%B0%E7%9A%84%E7%AE%80%E7%9F%AD%E6%95%99%E7%A8%8B--short-tutorial-on-calling-a-c-function"></a>
## 调用 C 函数的简短教程 / Short tutorial on calling a C function

这是一个调用标准函数并在 Raku 程序中使用返回信息的示例。

This is an example for calling a standard function and using the returned information in a Raku program.

`getaddrinfo` 是一个 POSIX 标准函数，用于获取有关网络节点的网络信息，例如 `google.com`。它是一个有趣的函数，因为它演示了 NativeCall 的许多元素。

`getaddrinfo` is a POSIX standard function for obtaining network information about a network node, e.g., `google.com`. It is an interesting function to look at because it illustrates a number of the elements of NativeCall.

Linux 手册提供了关于 C 可调用函数的以下信息：

The Linux manual provides the following information about the C callable function:

```C
int getaddrinfo(const char *node, const char *service,
       const struct addrinfo *hints,
       struct addrinfo **res);
```

函数返回响应代码 0 = error，1 = success。数据从 `addrinfo` 元素的链接列表中提取，第一个元素由 `res` 指向。

The function returns a response code 0 = error, 1 = success. The data are extracted from a linked list of `addrinfo` elements, with the first element pointed to by `res`.

从 NativeCall 类型表中，我们知道 `int` 是 `int32`。我们还知道 `char *` 是 `Str` 的 C 形式之一，它简单地映射到 Str。但是 `addrinfo` 是一个结构，这意味着我们需要编写自己的类型类。但是，函数声明很简单：

From the table of NativeCall Types we know that an `int` is `int32`. We also know that a `char *` is one of the forms C for a C `Str`, which maps simply to Str. But `addrinfo` is a structure, which means we will need to write our own Type class. However, the function declaration is straightforward:

```C
sub getaddrinfo( Str $node, Str $service, Addrinfo $hints, Pointer $res is rw )
    returns int32
    is native
    { * }
```

注意 $res 是由函数编写的，所以它必须标记为 rw。因为库是标准 POSIX，所以库名称可以是类型定义或空值。

Note that $res is to be written by the function, so it must be labeled as rw. Since the library is standard POSIX, the library name can be the Type definition or null.

我们现在必须处理结构 Addrinfo。Linux 手册提供了以下信息：

We now have to handle structure Addrinfo. The Linux Manual provides this information:

```C
struct addrinfo {
               int              ai_flags;
               int              ai_family;
               int              ai_socktype;
               int              ai_protocol;
               socklen_t        ai_addrlen;
               struct sockaddr *ai_addr;
               char            *ai_canonname;
               struct addrinfo *ai_next;
           };
```

`int, char*` 部分很简单。一些研究表明，`socklen_t` 可以依赖于体系结构，但至少是 32 位的无符号整数。所以 `socklen_t` 可以映射到 `uint32` 类型。

The `int, char*` parts are straightforward. Some research indicates that `socklen_t` can be architecture dependent, but is an unsigned integer of at least 32 bits. So `socklen_t` can be mapped to the `uint32` type.

复杂的情况是 `sockaddr`，这取决于 `ai_socktype` 是否是未定义的、是 INET 还是 INET6（标准 v4 IP 地址还是 v6 地址）。

The complication is `sockaddr` which differs depending on whether `ai_socktype` is undefined, INET, or INET6 (a standard v4 IP address or a v6 address).

因此，我们创建了一个 Raku `class` 来映射到 C `struct addrinfo`；在这里，我们还为 `SockAddr` 创建了另一个类，这是它所需要的。

So we create a Raku `class` to map to the C `struct addrinfo`; while we're at it, we also create another class for `SockAddr` which is needed for it.

```Raku
class SockAddr is repr('CStruct') {
    has int32    $.sa_family;
    has Str      $.sa_data;
}
 
class Addrinfo is repr('CStruct') {
    has int32     $.ai_flags;
    has int32     $.ai_family;
    has int32     $.ai_socktype;
    has int32     $.ai_protocol;
    has int32     $.ai_addrlen;
    has SockAddr  $.ai_addr       is rw;
    has Str       $.ai_cannonname is rw;
    has Addrinfo  $.ai_next       is rw;
 
}
```

最后三个属性上的 `is rw` 表示这些属性在 C 中定义为指针。

The `is rw` on the last three attributes reflects that these were defined in C to be pointers.

这里映射到 C `Struct` 的重要内容是类的状态部分的结构，即属性。但是，类可以有方法，`NativeCall` 不“触摸”它们以映射到 C。这意味着我们可以向类添加额外的方法以更可读的方式解包属性，例如，

The important thing here for mapping to a C `Struct` is the structure of the state part of the class, that is the attributes. However, a class can have methods and `NativeCall` does not 'touch' them for mapping to C. This means that we can add extra methods to the class to unpack the attributes in a more readable manner, e.g.,

```Raku
method flags {
    do for AddrInfo-Flags.enums { .key if $!ai_flags +& .value }
}
```

通过定义适当的 `enum`，`flags` 将返回一个键字符串，而不是一个位压缩整数。

By defining an appropriate `enum`, `flags` will return a string of keys rather than a bit packed integer.

`sockaddr` 结构中最有用的信息是节点的地址，这取决于套接字的家族。因此，我们可以将方法 `address` 添加到 Raku 类中，该类根据家族解释地址。

The most useful information in the `sockaddr` structure is the address of node, which depends on the family of the Socket. So we can add method `address` to the Raku class that interprets the address depending on the family.

为了获得一个人类可读的 IP 地址，有一个 C 函数 `inet_ntop`，它返回一个 `char *` 给定一个缓冲区，并带有 `addrinfo`。

In order to get a human readable IP address, there is the C function `inet_ntop` which returns a `char *` given a buffer with the `addrinfo`.

把所有这些放在一起，可以得到以下程序：

Putting all these together, leads to the following program:

```Raku
#!/usr/bin/env perl6 
 
use v6;
use NativeCall;
 
constant \INET_ADDRSTRLEN = 16;
constant \INET6_ADDRSTRLEN = 46;
 
enum AddrInfo-Family (
    AF_UNSPEC                   => 0;
    AF_INET                     => 2;
    AF_INET6                    => 10;
);
 
enum AddrInfo-Socktype (
    SOCK_STREAM                 => 1;
    SOCK_DGRAM                  => 2;
    SOCK_RAW                    => 3;
    SOCK_RDM                    => 4;
    SOCK_SEQPACKET              => 5;
    SOCK_DCCP                   => 6;
    SOCK_PACKET                 => 10;
);
 
enum AddrInfo-Flags (
    AI_PASSIVE                  => 0x0001;
    AI_CANONNAME                => 0x0002;
    AI_NUMERICHOST              => 0x0004;
    AI_V4MAPPED                 => 0x0008;
    AI_ALL                      => 0x0010;
    AI_ADDRCONFIG               => 0x0020;
    AI_IDN                      => 0x0040;
    AI_CANONIDN                 => 0x0080;
    AI_IDN_ALLOW_UNASSIGNED     => 0x0100;
    AI_IDN_USE_STD3_ASCII_RULES => 0x0200;
    AI_NUMERICSERV              => 0x0400;
);
 
sub inet_ntop(int32, Pointer, Blob, int32 --> Str)
    is native {}
 
class SockAddr is repr('CStruct') {
    has uint16 $.sa_family;
}
 
class SockAddr-in is repr('CStruct') {
    has int16 $.sin_family;
    has uint16 $.sin_port;
    has uint32 $.sin_addr;
 
    method address {
        my $buf = buf8.allocate(INET_ADDRSTRLEN);
        inet_ntop(AF_INET, Pointer.new(nativecast(Pointer,self)+4),
            $buf, INET_ADDRSTRLEN)
    }
}
 
class SockAddr-in6 is repr('CStruct') {
    has uint16 $.sin6_family;
    has uint16 $.sin6_port;
    has uint32 $.sin6_flowinfo;
    has uint64 $.sin6_addr0;
    has uint64 $.sin6_addr1;
    has uint32 $.sin6_scope_id;
 
    method address {
        my $buf = buf8.allocate(INET6_ADDRSTRLEN);
        inet_ntop(AF_INET6, Pointer.new(nativecast(Pointer,self)+8),
            $buf, INET6_ADDRSTRLEN)
    }
}
 
class Addrinfo is repr('CStruct') {
    has int32 $.ai_flags;
    has int32 $.ai_family;
    has int32 $.ai_socktype;
    has int32 $.ai_protocol;
    has uint32 $.ai_addrNativeCalllen;
    has SockAddr $.ai_addr is rw;
    has Str $.ai_cannonname is rw;
    has Addrinfo $.ai_next is rw;
 
    method flags {
        do for AddrInfo-Flags.enums { .key if $!ai_flags +& .value }
    }
 
    method family {
        AddrInfo-Family($!ai_family)
    }
 
    method socktype {
        AddrInfo-Socktype($!ai_socktype)
    }
 
    method address {
        given $.family {
            when AF_INET {
                nativecast(SockAddr-in, $!ai_addr).address
            }
            when AF_INET6 {
                nativecast(SockAddr-in6, $!ai_addr).address
            }
        }
    }
}
 
sub getaddrinfo(Str $node, Str $service, Addrinfo $hints,
                Pointer $res is rw --> int32)
    is native {};
 
sub freeaddrinfo(Pointer)
    is native {}
 
sub MAIN() {
    my Addrinfo $hint .= new(:ai_flags(AI_CANONNAME));
    my Pointer $res .= new;
    my $rv = getaddrinfo("google.com", Str, $hint, $res);
    say "return val: $rv";
    if ( ! $rv ) {
        my $addr = nativecast(Addrinfo, $res);
        while $addr {
            with $addr {
                say "Name: ", $_ with .ai_cannonname;
                say .family, ' ', .socktype;
                say .address;
                $addr = .ai_next;
            }
        }
    }
    freeaddrinfo($res);
}
```

这将产生以下输出：

This produces the following output:

```Raku
return val: 0
Name: google.com
AF_INET SOCK_STREAM
216.58.219.206
AF_INET SOCK_DGRAM
216.58.219.206
AF_INET SOCK_RAW
216.58.219.206
AF_INET6 SOCK_STREAM
2607:f8b0:4006:800::200e
AF_INET6 SOCK_DGRAM
2607:f8b0:4006:800::200e
AF_INET6 SOCK_RAW
2607:f8b0:4006:800::200e
```
