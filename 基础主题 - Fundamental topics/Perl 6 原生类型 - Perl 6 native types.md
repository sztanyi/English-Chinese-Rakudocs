# Perl 6 原生类型 / Perl 6 native types

使用编译器和硬件提供给您的类型。

Using the types the compiler and hardware make available to you

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

通常，这些变量将以与常规标量变量相同的方式运行，在称为[*自动装箱*](https://docs.perl6.org/language/numerics#Auto-boxing)的行为中；但是，存在一些差异，因为您实际上声明的是它们的表示方式，而不是它们的实际类型。第一个问题是，它们的类型实际上是它们的等效类型，而不是它们的原生类型。

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

And also that they will always have a default value, unlike their non-native counterparts:

```Perl6
say (my Str $); # OUTPUT: «(Str)␤» 
say (my str $); # OUTPUT: «␤» 
say (my num $); # OUTPUT: «0␤»
```

**Note**: In v6.c, the default value for `num` would have been a NaN.

This is due to the fact that Natives don't know their types because they're just values, without any metadata. In [multi-dispatch](https://docs.perl6.org/language/glossary#Multi-Dispatch), you can have a native candidate, but you cannot differentiate different sizes of the same native type. That is, you can have an [Int](https://docs.perl6.org/type/Int) and [int](https://docs.perl6.org/type/int) candidates, but there would be an ambiguity between, for instance [int](https://docs.perl6.org/type/int), [atomicint](https://docs.perl6.org/type/atomicint) or [int64](https://docs.perl6.org/language/nativetypes#index-entry-int64) candidates.

They cannot be bound either. Trying to do `my num $numillo := 3.5` will raise the exception `Cannot bind to natively typed variable '$variable-name'; use assignment instead`.

Native types can also be composite.

```Perl6
my int @intillos = ^10_000_000;
say [+] @intillos; # OUTPUT: «49999995000000␤»
```

In this case, *native*ness extends to the composite type, which will be `array`

```Perl6
my num @many-pi  = ^8 »*» π ; say @many-pi.^name;  # OUTPUT: «array[num]␤»
```

Native `array`s are [Iterable](https://docs.perl6.org/type/Iterable), but they are not a subclass of List. However, they behave similarly to [Array](https://docs.perl6.org/type/Array)s; for instance, they can be shaped:

```Perl6
my str @letter-pairs[10] = 'a'..'j' Z~ 'A'..'J';
say @letter-pairs.perl;
# OUTPUT: «array[str].new(:shape(10,), ["aA", "bB", "cC", "dD", "eE", "fF", "gG", "hH", "iI", "jJ"])␤» 
```



# Types with native representation and size

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

These types have a fixed size representation which is independent of the platform, and thus can be used safely for those native calls. Nothing prevents us from using them in any other environment, if we so wish. In the same way as the types above, this size will have to be taken into account when assigning values to variables of this type:

```Perl6
my byte $intillo = 257;
say $intillo; # OUTPUT: «1␤»
```

Since `byte` is able to hold only 8 bits, it will *wrap over* and assign the result of the original value modulo 256, which is what is shown.

The main difference between types with declared native size and those without is the use of is nativesize in their declaration. For instance, `int8` is declared in this way:

```Perl6
my native int8 is repr('P6int') is Int is nativesize(8) { }
```

Indicating that it will use, besides an integer representation (`P6int`), a native size of only 8 bits. This trait, however, is not intended to be used in your programs since it is not part of the Perl 6 specification.



# The `void` type

The native `void` type corresponds to the C `void` type. Although, being a valid type, you can use it in expressions:

```Perl6
use NativeCall;
my void $nothing;
say $nothing.perl; # OUTPUT: «NativeCall::Types::void␤»
```

In practice, it is an `Uninstantiable` type that can rarely be used by itself, and in fact it is [explicitly forbidden in `return` types](https://docs.perl6.org/language/nativecall#Passing_and_returning_values). However, it is generally found in typed pointers representing the equivalent to the `void *` pointer in C.

```Perl6
sub malloc( int32 $size --> Pointer[void] ) is native { * };
my Pointer[void] $for-malloc = malloc( 32 );
say $for-malloc.perl;
```

You can also [nativecast](https://docs.perl6.org/routine/nativecast) [Blob](https://docs.perl6.org/type/Blob)s to this kind of pointer in case you need to work with them in native functions that use the type

```Perl6
use NativeCall;
my Pointer[void] $native = nativecast(Pointer[void], Blob.new(0x22, 0x33));
```

However, outside that, the functionality it offers is quite limited, since pointers to void cannot be dereferenced:

```Perl6
use NativeCall;
my Pointer[void] $native = nativecast(Pointer[void], Buf.new(0x22, 0x33));
say $native.deref; # ERROR OUTPUT: «Internal error: unhandled target type␤» 
```

# *Atomic* types

In this context, *atomic* refers to safe operation under threading. Perl 6 provides a type, [`atomicint`](https://docs.perl6.org/type/atomicint), and [some operations](https://docs.perl6.org/type/atomicint#Routines) which, together, guarantee this. Please check [the atomic operations section on the Numerics page](https://docs.perl6.org/language/numerics#Atomic_operations) for more information on this.

# Rakudo specific native types

The types described in this section are Rakudo specific, so they are not guaranteed to be in other implementations or remain the same in future versions.

| long      | (long in C)                  |
| --------- | ---------------------------- |
| longlong  | (longlong in C)              |
| ulong     | (long and unsigned in C)     |
| ulonglong | (longlong and unsigned in C) |
| size_t    | (size_t and unsigned in C)   |
| ssize_t   | (size_t in C)                |
| bool      | (bool in C)                  |

You can use them in the same way they would be used in native C:

```Perl6
use NativeCall;
 
my $just-an-array = CArray[int32].new( 1, 2, 3, 4, 5 );
 
loop ( my size_t $i = 0; $i < $just-an-array.elems; $i++ ) {
    say $just-an-array[$i];
}
```

Which would print the five elements of the array, as it should be expected.
