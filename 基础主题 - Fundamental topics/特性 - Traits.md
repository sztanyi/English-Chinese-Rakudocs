# Traits

Compile-time specification of behavior made easy

In Perl 6, *traits* are compiler hooks attached to objects and classes that modify their default behavior, functionality or representation. As such compiler hooks, they are defined in compile time, although they can be used in runtime.

Several traits are already defined as part of the language or the Rakudo compiler by using the `trait_mod` keyword. They are listed, and explained, next.

# The 

Defined as

```Perl6
proto sub trait_mod:<is>(Mu $, |) {*}
```

`is` applies to any kind of scalar object, and can take any number of named or positional arguments. It is the most commonly used trait, and takes the following forms, depending on the type of the first argument.

## `is` applied to classes.

The most common form, involving two classes, one that is being defined and the other existing, [defines parenthood](https://docs.perl6.org/syntax/is). `A is B`, if both are classes, defines A as a subclass of B.

[`is DEPRECATED`](https://docs.perl6.org/type/Attribute#trait_is_DEPRECATED) can be applied to classes, Attributes or Routines, marks them as deprecated and issues a message, if provided.

Several instances of `is` are translated directly into attributes for the class they refer to: `rw`, `nativesize`, `ctype`, `unsigned`, `hidden`, `array_type`.

The Uninstantiable representation trait is not so much related to the representation as related to what can be done with a specific class; it effectively prevents the creation of instances of the class in any possible way.

```Perl6
constant @IMM = <Innie Minnie Moe>;

class don't-instantiate is repr('Uninstantiable') {
    my $.counter;

    method imm () {
        return @IMM[ $.counter++ mod @IMM.elems ];
    }
}
say don't-instantiate.imm for ^10;
```

Uninstantiable classes can still be used via their class variables and methods, as above. However, trying to instantiate them this way: `my $do-instantiate = don't-instantiate.new;` will yield the error `You cannot create an instance of this type (don't-instantiate)`.

## `is repr` and native representations.

Since the `is` trait refers, in general, to the nature of the class or object they are applied to, they are used extensively in [native calls](https://docs.perl6.org/language/nativecall) to [specify the representation](https://docs.perl6.org/language/nativecall#Specifying_the_native_representation) of the data structures that are going to be handled by the native functions via the `is repr` suffix; at the same time, `is native` is used for the routines that are actually implemented via native functions. These are the representations that can be used:

- CStruct corresponds to a `struct` in the C language. It is a composite data structure which includes different and heterogeneous lower-level data structures; see [this](https://docs.perl6.org/language/nativecall#Structs) for examples and further explanations.
- CPPStruct, similarly, correspond to a `struct` in C++. However, this is Rakudo specific for the time being.
- CPointer is a pointer in any of these languages. It is a dynamic data structure that must be instantiated before being used, can be [used](https://docs.perl6.org/language/nativecall#Basic_use_of_pointers) for classes whose methods are also native.
- CUnion is going to use the same representation as an `union` in C; see [this](https://docs.perl6.org/language/nativecall#CUnions) for an example.

On the other hand, P6opaque is the default representation used for all objects in Perl 6.

```Perl6
class Thar {};
say Thar.REPR;    #OUTPUT: «P6opaque␤»
```

The [metaobject protocol](https://docs.perl6.org/language/mop) uses it by default for every object and class unless specified otherwise; for that reason, it is in general not necessary unless you are effectively working with that interface.

## `is` on routines

The `is` trait can be used on the definition of methods and routines to establish [precedence](https://docs.perl6.org/language/functions#Precedence) and [associativity](https://docs.perl6.org/language/functions#Associativity). They act as a [sub defined using `trait_mod`](https://docs.perl6.org/type/Sub#Traits) which take as argument the types and names of the traits that are going to be added. In the case of subroutines, traits would be a way of adding functionality which cuts across class and role hierarchies, or can even be used to add behaviors to independently defined routines.

