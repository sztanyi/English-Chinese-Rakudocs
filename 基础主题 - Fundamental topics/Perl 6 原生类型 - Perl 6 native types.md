原文：https://docs.perl6.org/language/nativetypes

# Perl 6 原生类型 / Perl 6 native types

使用编译器和硬件提供给你的类型。

Using the types the compiler and hardware make available to you

<!-- MarkdownTOC -->

- [具有原生表示的类型 / Types with native representation](#%E5%85%B7%E6%9C%89%E5%8E%9F%E7%94%9F%E8%A1%A8%E7%A4%BA%E7%9A%84%E7%B1%BB%E5%9E%8B--types-with-native-representation)
- [具有原生表示形式和大小的类型 / Types with native representation and size](#%E5%85%B7%E6%9C%89%E5%8E%9F%E7%94%9F%E8%A1%A8%E7%A4%BA%E5%BD%A2%E5%BC%8F%E5%92%8C%E5%A4%A7%E5%B0%8F%E7%9A%84%E7%B1%BB%E5%9E%8B--types-with-native-representation-and-size)
- [`void` 类型 / The `void` type](#void-%E7%B1%BB%E5%9E%8B--the-void-type)
- [*Atomic* 类型 / Atomic* types](#atomic-%E7%B1%BB%E5%9E%8B--atomic-types)
- [Rakudo 特定的原生类型 / Rakudo specific native types](#rakudo-%E7%89%B9%E5%AE%9A%E7%9A%84%E5%8E%9F%E7%94%9F%E7%B1%BB%E5%9E%8B--rakudo-specific-native-types)

<!-- /MarkdownTOC -->

<a id="%E5%85%B7%E6%9C%89%E5%8E%9F%E7%94%9F%E8%A1%A8%E7%A4%BA%E7%9A%84%E7%B1%BB%E5%9E%8B--types-with-native-representation"></a>
# 具有原生表示的类型 / Types with native representation

Perl 6 中的一些简单类型具有*原生*表示，表示它们将使用编译器、操作系统和机器提供的 C 语言表示。这些是可用的四种本机类型：

Some simple types in Perl 6 have a *native* representation, indicating that they will use the C language representation provided by the compiler, operating system and machine. These are the four native types available:

| int  | Equivalent to Int (with limited range)                       |
| ---- | ------------------------------------------------------------ |
| uint | Equivalent to Int (with limited range) with the unsigned trait |
| num  | Equivalent to Num                                            |
| str  | Equivalent to Str                                            |

但是，这些类型不一定具有 [NativeCall](https://docs.perl6.org/language/nativecall) 接口所需的大小(例如，Perl 6 的 `int` 可以是 8 个字节，而 C 的 `int` 只有 4 个字节)；必须使用以下类型而不是上面列出的类型 `int` 或 `num`。

However, these types do not necessarily have the size that is required by the [NativeCall](https://docs.perl6.org/language/nativecall) interface (e.g., Perl 6's `int` can be 8 bytes but C's `int` is only 4 bytes); the types below will have to be used instead of the types `int` or `num` listed above.

通常，这些变量将以与常规标量变量相同的方式运行，在称为[*自动装箱*](https://docs.perl6.org/language/numerics#Auto-boxing)的行为中；但是，存在一些差异，因为你实际上声明的是它们的表示方式，而不是它们的实际类型。第一个问题是，它们的类型实际上是它们的等效类型，而不是它们的原生类型。

In general, these variables will behave in the same way as regular scalar variables, in a behavior that is called [*auto-boxing*](https://docs.perl6.org/language/numerics#Auto-boxing); however, there are some differences, since what you are actually declaring is how they will be represented, not their actual type. The first one is that their type will be actually their equivalent type, not their native type.

```Perl6
my int $intillo = 3;
say $intillo.^name; # OUTPUT: «Int␤»
```

这显然意味着它们将匹配它们的等效（自动装箱）类型，而不是它们的原生类型：

This obviously means that they will smartmatch their equivalent (auto-boxed) type, not their native type:

```Perl6
my str $strillo = "tres";
say $strillo ~~ str; # OUTPUT: «False␤» 
say $strillo ~~ Str; # OUTPUT: «True␤»
```

而且，与它们的非原生对应方不同，它们始终具有默认值：

And also that they will always have a default value, unlike their non-native counterparts:

```Perl6
say (my Str $); # OUTPUT: «(Str)␤» 
say (my str $); # OUTPUT: «␤» 
say (my num $); # OUTPUT: «0␤»
```

**注**：在 v6.c 中，`num` 的默认值为 NaN。

**Note**: In v6.c, the default value for `num` would have been a NaN.

这是因为原生数据不知道他们的类型，因为他们只是值，没有任何元数据。在[多分派](https://docs.perl6.org/language/glossary#Multi-Dispatch)中，你可以有一个原生候选人，但你不能区分相同本机类型的不同大小。也就是说，你可以有一个 [Int](https://docs.perl6.org/type/Int) 和 [int](https://docs.perl6.org/type/int) 候选人，但在 [int](https://docs.perl6.org/type/int)、[atomicint](https://docs.perl6.org/type/atomicint) 或 [int64](https://docs.perl6.org/language/nativetypes#index-entry-int64) 之间可能存在歧义。

This is due to the fact that Natives don't know their types because they're just values, without any metadata. In [multi-dispatch](https://docs.perl6.org/language/glossary#Multi-Dispatch), you can have a native candidate, but you cannot differentiate different sizes of the same native type. That is, you can have an [Int](https://docs.perl6.org/type/Int) and [int](https://docs.perl6.org/type/int) candidates, but there would be an ambiguity between, for instance [int](https://docs.perl6.org/type/int), [atomicint](https://docs.perl6.org/type/atomicint) or [int64](https://docs.perl6.org/language/nativetypes#index-entry-int64) candidates.

他们也不能被束缚。尝试执行 `my num $numillo := 3.5` 将引发异常 `Cannot bind to natively typed variable '$variable-name'; use assignment instead`。

They cannot be bound either. Trying to do `my num $numillo := 3.5` will raise the exception `Cannot bind to natively typed variable '$variable-name'; use assignment instead`.

原生类型也可以组合。

Native types can also be composite.

```Perl6
my int @intillos = ^10_000_000;
say [+] @intillos; # OUTPUT: «49999995000000␤»
```

在这种情况下，*原生性*扩展到复合类型，它将是 `array`

In this case, *native*ness extends to the composite type, which will be `array`

```Perl6
my num @many-pi  = ^8 »*» π ; say @many-pi.^name;  # OUTPUT: «array[num]␤»
```

原生的 `array` 是 [Iterable](https://docs.perl6.org/type/Iterable)，但它们不是 List 的子类。但是，它们的行为类似于[Array](https://docs.perl6.org/type/Array)；例如，它们可以被塑造：

Native `array`s are [Iterable](https://docs.perl6.org/type/Iterable), but they are not a subclass of List. However, they behave similarly to [Array](https://docs.perl6.org/type/Array)s; for instance, they can be shaped:

```Perl6
my str @letter-pairs[10] = 'a'..'j' Z~ 'A'..'J';
say @letter-pairs.perl;
# OUTPUT: «array[str].new(:shape(10,), ["aA", "bB", "cC", "dD", "eE", "fF", "gG", "hH", "iI", "jJ"])␤» 
```

<a id="%E5%85%B7%E6%9C%89%E5%8E%9F%E7%94%9F%E8%A1%A8%E7%A4%BA%E5%BD%A2%E5%BC%8F%E5%92%8C%E5%A4%A7%E5%B0%8F%E7%9A%84%E7%B1%BB%E5%9E%8B--types-with-native-representation-and-size"></a>
# 具有原生表示形式和大小的类型 / Types with native representation and size

已经提到的具有原生表示的类型也适用于这里；它们将自动装箱到 Perl 6 类型，并且不可绑定。但是，下表中列出的这些类型具有在 [NativeCall](https://docs.perl6.org/language/nativecall#Passing_and_returning_values) 函数中可用的特性。

What has been mentioned about types with native representation also applies here; they will be auto-boxed to Perl 6 types and will not be boundable. However, these types, which are listed in the table below, have the characteristic of being usable in [NativeCall](https://docs.perl6.org/language/nativecall#Passing_and_returning_values) functions.

| int8        | (int8_t in C)   |
| ----------- | --------------- |
| int16       | (int16_t in C)  |
| int32       | (int32_t in C)  |
| int64       | (int64_t in C)  |
| byte, uint8 | (uint8_t in C)  |
| uint16      | (uint16_t in C) |
| uint32      | (uint32_t in C) |
| uint64      | (uint64_t in C) |
| num32       | (float in C)    |
| num64       | (double in C)   |

这些类型具有独立于平台的固定大小表示，因此可以安全地用于这些原生调用。没有什么能阻止我们在任何其他环境中使用它们，如果我们愿意的话。与上述类型相同，在为该类型的变量赋值时必须考虑到此大小：

These types have a fixed size representation which is independent of the platform, and thus can be used safely for those native calls. Nothing prevents us from using them in any other environment, if we so wish. In the same way as the types above, this size will have to be taken into account when assigning values to variables of this type:

```Perl6
my byte $intillo = 257;
say $intillo; # OUTPUT: «1␤»
```

由于 `byte` 只能容纳 8 位，所以它将*封装*并分配原始值模 256 的结果，这就是所示。

Since `byte` is able to hold only 8 bits, it will *wrap over* and assign the result of the original value modulo 256, which is what is shown.

声明原生大小的类型与未声明的类型之间的主要区别是在声明中使用 is nativesize。例如，以这种方式声明 `int8`：

The main difference between types with declared native size and those without is the use of is nativesize in their declaration. For instance, `int8` is declared in this way:

```Perl6
my native int8 is repr('P6int') is Int is nativesize(8) { }
```

指示除整数表示（`P6int`）外，它只使用 8 位大小的原生数据。但是，这个特性并不打算在程序中使用，因为它不是 Perl 6 规范的一部分。

Indicating that it will use, besides an integer representation (`P6int`), a native size of only 8 bits. This trait, however, is not intended to be used in your programs since it is not part of the Perl 6 specification.

<a id="void-%E7%B1%BB%E5%9E%8B--the-void-type"></a>
# `void` 类型 / The `void` type

原生 `void` 类型对应于 C `void` 类型。但是，作为一个有效类型，你可以在表达式中使用它：

The native `void` type corresponds to the C `void` type. Although, being a valid type, you can use it in expressions:

```Perl6
use NativeCall;
my void $nothing;
say $nothing.perl; # OUTPUT: «NativeCall::Types::void␤»
```

实际上，这是一种本身很少能使用的 `Uninstantiable` 类型，事实上，它[在 `return` 类型中明确禁止](https://docs.perl6.org/language/nativecall#Passing_and_returning_values)。但是，它通常在类型化指针中找到，表示相当于 C 中的 `void *` 指针。

In practice, it is an `Uninstantiable` type that can rarely be used by itself, and in fact it is [explicitly forbidden in `return` types](https://docs.perl6.org/language/nativecall#Passing_and_returning_values). However, it is generally found in typed pointers representing the equivalent to the `void *` pointer in C.

```Perl6
sub malloc( int32 $size --> Pointer[void] ) is native { * };
my Pointer[void] $for-malloc = malloc( 32 );
say $for-malloc.perl;
```

你还可以 [nativecast](https://docs.perl6.org/routine/nativecast) [Blob](https://docs.perl6.org/type/Blob)指向这类指针，以防你需要在使用该类型的本地函数中使用它们。

You can also [nativecast](https://docs.perl6.org/routine/nativecast) [Blob](https://docs.perl6.org/type/Blob)s to this kind of pointer in case you need to work with them in native functions that use the type

```Perl6
use NativeCall;
my Pointer[void] $native = nativecast(Pointer[void], Blob.new(0x22, 0x33));
```

但是，在此之外，它提供的功能非常有限，因为指向 void 的指针不能取消引用：

However, outside that, the functionality it offers is quite limited, since pointers to void cannot be dereferenced:

```Perl6
use NativeCall;
my Pointer[void] $native = nativecast(Pointer[void], Buf.new(0x22, 0x33));
say $native.deref; # ERROR OUTPUT: «Internal error: unhandled target type␤» 
```

<a id="atomic-%E7%B1%BB%E5%9E%8B--atomic-types"></a>
# *Atomic* 类型 / Atomic* types

在这种情况下，*atomic* 指的是线程下的安全操作。Perl 6 提供了一个 [`atomicint`](https://docs.perl6.org/type/atomicint) 类型和[一些原子操作](https://docs.perl6.org/type/atomicint#Routines)，它们共同保证了这一点。有关此问题的更多信息，请查看[数值页面上的原子操作部分](https://docs.perl6.org/language/numerics#Atomic_operations)。

In this context, *atomic* refers to safe operation under threading. Perl 6 provides a type, [`atomicint`](https://docs.perl6.org/type/atomicint), and [some operations](https://docs.perl6.org/type/atomicint#Routines) which, together, guarantee this. Please check [the atomic operations section on the Numerics page](https://docs.perl6.org/language/numerics#Atomic_operations) for more information on this.

<a id="rakudo-%E7%89%B9%E5%AE%9A%E7%9A%84%E5%8E%9F%E7%94%9F%E7%B1%BB%E5%9E%8B--rakudo-specific-native-types"></a>
# Rakudo 特定的原生类型 / Rakudo specific native types

本节中描述的类型是 Rakudo 特定的，因此不能保证它们在其他实现中或在未来的版本中保持不变。

The types described in this section are Rakudo specific, so they are not guaranteed to be in other implementations or remain the same in future versions.

| long      | (long in C)                  |
| --------- | ---------------------------- |
| longlong  | (longlong in C)              |
| ulong     | (long and unsigned in C)     |
| ulonglong | (longlong and unsigned in C) |
| size_t    | (size_t and unsigned in C)   |
| ssize_t   | (size_t in C)                |
| bool      | (bool in C)                  |

你可以按照在原生 C 中使用它们的方式使用它们：

You can use them in the same way they would be used in native C:

```Perl6
use NativeCall;
 
my $just-an-array = CArray[int32].new( 1, 2, 3, 4, 5 );
 
loop ( my size_t $i = 0; $i < $just-an-array.elems; $i++ ) {
    say $just-an-array[$i];
}
```

它将打印数组的五个元素，正如所期望的那样。

Which would print the five elements of the array, as it should be expected.
