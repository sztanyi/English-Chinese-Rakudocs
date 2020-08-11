原文：https://docs.raku.org/language/setbagmix

<!-- MarkdownTOC -->

- [集合、背包和混合 / Sets, bags, and mixes](#集合、背包和混合--sets-bags-and-mixes)
- [介绍 / Introduction](#介绍--introduction)
- [具有集合语义的运算符 / Operators with Set semantics](#具有集合语义的运算符--operators-with-set-semantics)
    - [返回 `Bool` 的集合运算符 / Set operators that return `Bool`](#返回-bool-的集合运算符--set-operators-that-return-bool)
        - [中缀运算符 \(elem\)，中缀运算符 ∈ / infix \(elem\), infix ∈](#中缀运算符-elem，中缀运算符-∈--infix-elem-infix-∈)
        - [中缀运算符 ∉ / infix ∉](#中缀运算符-∉--infix-∉)
        - [中缀运算符 \(cont\)，中缀运算符 ∋ / infix \(cont\), infix ∋](#中缀运算符-cont，中缀运算符-∋--infix-cont-infix-∋)
        - [中缀运算符 ∌ / infix ∌](#中缀运算符-∌--infix-∌)
        - [中缀运算符 \(<=\)，中缀运算符 ⊆ / infix \(<=\), infix ⊆](#中缀运算符-，中缀运算符-⊆--infix--infix-⊆)
        - [中缀运算符 ⊈ / infix ⊈](#中缀运算符-⊈--infix-⊈)
        - [中缀运算符 \(<\)，中缀运算符 ⊂ / infix \(<\), infix ⊂](#中缀运算符-，中缀运算符-⊂--infix--infix-⊂)
        - [中缀运算符 ⊄ / infix ⊄](#中缀运算符-⊄--infix-⊄)
        - [中缀运算符 \(>=\)，中缀运算符 ⊇ / infix \(>=\), infix ⊇](#中缀运算符-，中缀运算符-⊇--infix--infix-⊇)
        - [中缀运算符 ⊉ / infix ⊉](#中缀运算符-⊉--infix-⊉)
        - [中缀运算符 \(>\)，中缀运算符 ⊃ / infix \(>\), infix ⊃](#中缀运算符-，中缀运算符-⊃--infix--infix-⊃)
        - [中缀运算符 ⊅ / infix ⊅](#中缀运算符-⊅--infix-⊅)
    - [返回 `QuantHash` 的集合运算符 / Set operators that return a `QuantHash`](#返回-quanthash-的集合运算符--set-operators-that-return-a-quanthash)
        - [中缀运算符 \(|\)，中缀运算符 ∪ / infix \(|\), infix ∪](#中缀运算符-|，中缀运算符-∪--infix-|-infix-∪)
        - [中缀运算符 \(&\)，中缀运算符 ∩ / infix \(&\), infix ∩](#中缀运算符-，中缀运算符-∩--infix--infix-∩)
        - [中缀运算符 \(-\)，中缀运算符 ∖ / infix \(-\), infix ∖](#中缀运算符--，中缀运算符-∖--infix---infix-∖)
        - [中缀运算符 \(^\)，中缀运算符 ⊖ / infix \(^\), infix ⊖](#中缀运算符-^，中缀运算符-⊖--infix-^-infix-⊖)
    - [返回 `Baggy` 的集合运算符 / Set operators that return a `Baggy`](#返回-baggy-的集合运算符--set-operators-that-return-a-baggy)
        - [中缀运算符 \(.\)，中缀运算符 ⊍ / infix \(.\), infix ⊍](#中缀运算符-，中缀运算符-⊍--infix--infix-⊍)
        - [中缀运算符 \(+\)，中缀运算符 ⊎ / infix \(+\), infix ⊎](#中缀运算符-，中缀运算符-⊎--infix--infix-⊎)
    - [与集合运算符有关的术语 / Terms related to set operators](#与集合运算符有关的术语--terms-related-to-set-operators)
        - [术语 ∅ / term ∅](#术语-∅--term-∅)

<!-- /MarkdownTOC -->

<a id="集合、背包和混合--sets-bags-and-mixes"></a>
# 集合、背包和混合 / Sets, bags, and mixes

Raku 中去重和加权对象的无序集合

Unordered collections of unique and weighted objects in Raku

<a id="介绍--introduction"></a>
# 介绍 / Introduction

六个集合类是 [Set](https://docs.raku.org/type/Set)、[SetHash](https://docs.raku.org/type/SetHash)、[Bag](https://docs.raku.org/type/Bag)、[BagHash](https://docs.raku.org/type/BagHash)、[Mix](https://docs.raku.org/type/Mix) 和 [MixHash](https://docs.raku.org/type/MixHash)。它们都有相似的语义。

The six collection classes are [Set](https://docs.raku.org/type/Set), [SetHash](https://docs.raku.org/type/SetHash), [Bag](https://docs.raku.org/type/Bag), [BagHash](https://docs.raku.org/type/BagHash), [Mix](https://docs.raku.org/type/Mix) and [MixHash](https://docs.raku.org/type/MixHash). They all share similar semantics.

简而言之，这些类通常持有无序的对象集合，很像[对象哈希](https://docs.raku.org/type/Hash#index-entry-object_hash)。[QuantHash](https://docs.raku.org/type/QuantHash) 角色是所有这些类实现的角色：因此它们也被称为 `QuantHash`。

In a nutshell, these classes hold, in general, unordered collections of objects, much like an [object hash](https://docs.raku.org/type/Hash#index-entry-object_hash). The [QuantHash](https://docs.raku.org/type/QuantHash) role is the role that is implemented by all of these classes: therefore they are also referenced as `QuantHash`es.

`Set` and `SetHash` 还实现了[setty]（https://docs.raku.org/type/setty）角色，`Bag` 和 `BagHash` 实现了 [Baggy](https://docs.raku.org/type/Baggy) 角色，`Mix` 和 `MixHash` 实现了 [Mixy](https://docs.raku.org/type/Mixy) 角色（它本身实现了 `Baggy` 角色）。

`Set` and `SetHash` also implement the [Setty](https://docs.raku.org/type/Setty) role, `Bag` and `BagHash` implement the [Baggy](https://docs.raku.org/type/Baggy) role, `Mix` and `MixHash` implement the [Mixy](https://docs.raku.org/type/Mixy) role (which itself implements the `Baggy` role).

集合只考虑集合中的对象是否存在，背包可以容纳相同类型的几个对象，混合也允许小数（和负）权重。常规版本是不可变的，*Hash* 版本是可变的。

Sets only consider if objects in the collection are present or not, bags can hold several objects of the same kind, and mixes also allow fractional (and negative) weights. The regular versions are immutable, the *Hash* versions are mutable.

让我们详细说明一下。如果你想在容器中收集对象，但不关心这些对象的顺序，Raku 提供这些*无序*的集合类型。由于无序，这些容器在查找元素或处理重复项时比[列表](https://docs.raku.org/type/List)或[数组](https://docs.raku.org/type/Array)更有效。

Let's elaborate on that. If you want to collect objects in a container but you do not care about the order of these objects, Raku provides these *unordered* collection types. Being unordered, these containers can be more efficient than [Lists](https://docs.raku.org/type/List) or [Arrays](https://docs.raku.org/type/Array) for looking up elements or dealing with repeated items.

另一方面，如果你想要获得包含的对象（元素）**而不需要重复**，并且只关心元素*是否*在集合中，则可以使用 [Set](https://docs.raku.org/type/Set) 或 [SetHash](https://docs.raku.org/type/SetHash)。

On the other hand, if you want to get the contained objects (elements) **without duplicates** and you only care *whether* an element is in the collection or not, you can use a [Set](https://docs.raku.org/type/Set) or [SetHash](https://docs.raku.org/type/SetHash).

如果你想去掉重复项但仍然保持顺序，请查看 [List](https://docs.raku.org/type/List) 的 [unique](https://docs.raku.org/routine/unique) 例程。

If you want to get rid of duplicates but still preserve order, take a look at the [unique](https://docs.raku.org/routine/unique) routine for [List](https://docs.raku.org/type/List).

如果你想跟踪**每个对象出现的次数**，你可以使用 [Bag](https://docs.raku.org/type/Bag) 或 [BagHash](https://docs.raku.org/type/BagHash)。在这些 `Baggy` 容器中，每个元素都有一个权重（无符号整数），展示在集合中包含相同对象的次数。

If you want to keep track of the **number of times each object appeared**, you can use a [Bag](https://docs.raku.org/type/Bag) or [BagHash](https://docs.raku.org/type/BagHash). In these `Baggy` containers each element has a weight (an unsigned integer) indicating the number of times the same object has been included in the collection.

类型 [Mix](https://docs.raku.org/type/Mix) 和 [MixHash](https://docs.raku.org/type/MixHash) 类似于 [Bag](https://docs.raku.org/type/Bag) 和 [BagHash](https://docs.raku.org/type/BagHash)，但它们也允许**小数和负权重**。

The types [Mix](https://docs.raku.org/type/Mix) and [MixHash](https://docs.raku.org/type/MixHash) are similar to [Bag](https://docs.raku.org/type/Bag) and [BagHash](https://docs.raku.org/type/BagHash), but they also allow **fractional and negative weights**.

[Set](https://docs.raku.org/type/Set)、[Bag](https://docs.raku.org/type/Bag) 和 [Mix](https://docs.raku.org/type/Mix) 是*不可变*类型。使用可变变体 [SetHash](https://docs.raku.org/type/SetHash)，[MixHash](https://docs.raku.org/type/MixHash) 和 [MixHash](https://docs.raku.org/type/MixHash)，如果你想在容器被构造之后添加或移除元素。

[Set](https://docs.raku.org/type/Set), [Bag](https://docs.raku.org/type/Bag), and [Mix](https://docs.raku.org/type/Mix) are *immutable* types. Use the mutable variants [SetHash](https://docs.raku.org/type/SetHash), [BagHash](https://docs.raku.org/type/BagHash), and [MixHash](https://docs.raku.org/type/MixHash) if you want to add or remove elements after the container has been constructed.

一方面，就它们而言，相同的对象指的是同一个元素——其中使用 [WHICH](https://docs.raku.org/routine/WHICH) 方法来确定同一个元素（即与 [===](https://docs.raku.org/routine/===) 操作符检查身份相同的方式）。对于像 `Str` 这样的值类型，这意味着具有相同的值；对于诸如 `Array` 这样的引用类型，它指的是引用相同的对象实例。

For one thing, as far as they are concerned, identical objects refer to the same element – where identity is determined using the [WHICH](https://docs.raku.org/routine/WHICH) method (i.e. the same way that the [===](https://docs.raku.org/routine/===) operator checks identity). For value types like `Str`, this means having the same value; for reference types like `Array`, it means referring to the same object instance.

其次，它们提供一个类似散列的接口，其中集合的实际元素（可以是任何类型的对象）是“键”，相关的权重是“值”：

Secondly, they provide a Hash-like interface where the actual elements of the collection (which can be objects of any type) are the 'keys', and the associated weights are the 'values':

| type of $a    | value of $a{$b} if $b is an element | value of $a{$b} if $b is not an element |
| ------------- | ----------------------------------- | --------------------------------------- |
| Set / SetHash | True                                | False                                   |
| Bag / BagHash | a positive integer                  | 0                                       |
| Mix / MixHash | a non-zero real number              | 0                                       |

<a id="具有集合语义的运算符--operators-with-set-semantics"></a>
# 具有集合语义的运算符 / Operators with Set semantics

有几个中缀运算符致力于使用 `QuantHash` 语义执行通用操作。由于这个，这些运算符通常被称为“集合运算符”。

There are several infix operators devoted to performing common operations using `QuantHash` semantics. Since that is a mouthful, these operators are usually referred to as "set operators".

这并不意味着这些运算符的参数必须总是 `Set`，甚至更一般的 `QuantHash`。它仅仅意味着应用于运算符的逻辑，遵循[集合理论](https://en.wikipedia.org/wiki/Set_theory)的逻辑。

This does **not** mean that the parameters of these operators must always be `Set`, or even a more generic `QuantHash`. It just means that the logic that is applied to the operators, follows the logic of [Set Theory](https://en.wikipedia.org/wiki/Set_theory).

这些中缀运算符可以使用表示函数的 Unicode 字符（如 `∈` 或 `∪`）编写，或者用等效的 ASCII 版本（如 `(elem)` 或 <(|)> ）来编写。

These infixes can be written using the Unicode character that represents the function (like `∈` or `∪`), or with an equivalent ASCII version (like `(elem)` or <(|)>).

因此，显式地将 `Set`（或 `Bag` 或 `Mix`）对象与这些中缀运算符一起使用是不必要的。所有集合运算符都使用所有可能的参数。如有必要，强制类型转换将在内部发生：但在许多情况下，实际上并不需要。

So explicitly using `Set` (or `Bag` or `Mix`) objects with these infixes is unnecessary. All set operators work with all possible arguments. If necessary, a coercion will take place internally: but in many cases that is not actually needed.

但是，如果 `Bag` 或 `Mix` 是这些集合操作符的参数之一，那么语义将被升级为该类型（如果两种类型碰巧使用，则 `Mix` 取代 `Bag`）。

However, if a `Bag` or `Mix` is one of the parameters to these set operators, then the semantics will be upgraded to that type (where `Mix` supersedes `Bag` if both types happen to be used).

<a id="返回-bool-的集合运算符--set-operators-that-return-bool"></a>
## 返回 `Bool` 的集合运算符 / Set operators that return `Bool`

<a id="中缀运算符-elem，中缀运算符-∈--infix-elem-infix-∈"></a>
### 中缀运算符 (elem)，中缀运算符 ∈ / infix (elem), infix ∈

如果 `$a` 是 `$b` 的**元素**，则返回 `True`，否则返回 `False`。[更多信息](https://docs.raku.org/language/operators#infix_(elem),_infix_%E2%88%88)，[维基百科定义](https://en.wikipedia.org/wiki/Element_(mathematics)#Notation_and_terminology)。

Returns `True` if `$a` is an **element** of `$b`, else False. [More information](https://docs.raku.org/language/operators#infix_(elem),_infix_%E2%88%88), [Wikipedia definition](https://en.wikipedia.org/wiki/Element_(mathematics)#Notation_and_terminology).

<a id="中缀运算符-∉--infix-∉"></a>
### 中缀运算符 ∉ / infix ∉

如果`$a` 不是 `$b` 的**元素，则返回 `True`，否则返回 `False`。[更多信息](https://docs.raku.org/language/operators#infix_%E2%88%89)，[维基百科定义](https://en.wikipedia.org/wiki/Element_(mathematics)#Notation_and_terminology)。

Returns `True` if `$a` is **not** an element of `$b`, else False. [More information](https://docs.raku.org/language/operators#infix_%E2%88%89), [Wikipedia definition](https://en.wikipedia.org/wiki/Element_(mathematics)#Notation_and_terminology).

<a id="中缀运算符-cont，中缀运算符-∋--infix-cont-infix-∋"></a>
### 中缀运算符 (cont)，中缀运算符 ∋ / infix (cont), infix ∋

如果 `$a` **包含** `$b` 作为元素，则返回 `True`，否则返回 `False`。[更多信息](https://docs.raku.org/language/operators#infix_(cont),_infix_%E2%88%8B)，[维基百科定义](https://en.wikipedia.org/wiki/Element_(mathematics)#Notation_and_terminology)。

Returns `True` if `$a` **contains** `$b` as an element, else False. [More information](https://docs.raku.org/language/operators#infix_(cont),_infix_%E2%88%8B), [Wikipedia definition](https://en.wikipedia.org/wiki/Element_(mathematics)#Notation_and_terminology).

<a id="中缀运算符-∌--infix-∌"></a>
### 中缀运算符 ∌ / infix ∌

如果 `$a` **不包含** `$b` 作为元素，则返回 `True`，否则返回 `False`。[更多信息](https://docs.raku.org/language/operators#infix_%E2%88%8C)，[维基百科定义](https://en.wikipedia.org/wiki/Element_(mathematics)#Notation_and_terminology)。

Returns `True` if `$a` does **not** contain `$b`, else False. [More information](https://docs.raku.org/language/operators#infix_%E2%88%8C), [Wikipedia definition](https://en.wikipedia.org/wiki/Element_(mathematics)#Notation_and_terminology).

<a id="中缀运算符-，中缀运算符-⊆--infix--infix-⊆"></a>
### 中缀运算符 (<=)，中缀运算符 ⊆ / infix (<=), infix ⊆

如果 `$a` 是**子集**或等于 `$b`，则返回 `True`，否则返回 `False`。[更多信息](https://docs.raku.org/language/operators#infix_(%3C=),_infix_%E2%8A%86)，[维基百科定义](https://en.wikipedia.org/wiki/Subset#Definitions)。

Returns `True` if `$a` is a **subset** or is equal to `$b`, else False. [More information](https://docs.raku.org/language/operators#infix_(%3C=),_infix_%E2%8A%86), [Wikipedia definition](https://en.wikipedia.org/wiki/Subset#Definitions).

<a id="中缀运算符-⊈--infix-⊈"></a>
### 中缀运算符 ⊈ / infix ⊈

如果 `$a` 不是 `$b` 的子集也不等于 `$b`，则返回 `True`，否则返回 `False`。[更多信息](https://docs.raku.org/language/operators#infix_%E2%8A%88)，[维基百科定义](https://en.wikipedia.org/wiki/Subset#Definitions)。

Returns `True` if `$a` is **not** a **subset** nor equal to `$b`, else False. [More information](https://docs.raku.org/language/operators#infix_%E2%8A%88), [Wikipedia definition](https://en.wikipedia.org/wiki/Subset#Definitions).

<a id="中缀运算符-，中缀运算符-⊂--infix--infix-⊂"></a>
### 中缀运算符 (<)，中缀运算符 ⊂ / infix (<), infix ⊂

如果 `$a` 是 `$b` 的**严格子集**，则返回 `True`，否则返回 `False`。[更多信息](https://docs.raku.org/language/operators#infix_(%3C),_infix_%E2%8A%82)，[维基百科定义](https://en.wikipedia.org/wiki/Subset#Definitions)。

Returns `True` if `$a` is a **strict subset** of `$b`, else False. [More information](https://docs.raku.org/language/operators#infix_(%3C),_infix_%E2%8A%82), [Wikipedia definition](https://en.wikipedia.org/wiki/Subset#Definitions).

<a id="中缀运算符-⊄--infix-⊄"></a>
### 中缀运算符 ⊄ / infix ⊄

如果 `$a` **不是** `$b` 的**严格子集**，则返回 `True`，否则返回 `False`。[更多信息](https://docs.raku.org/language/operators#infix_%E2%8A%84)，[维基百科定义](https://en.wikipedia.org/wiki/Subset#Definitions)。

Returns `True` if `$a` is **not** a **strict subset** of `$b`, else False. [More information](https://docs.raku.org/language/operators#infix_%E2%8A%84), [Wikipedia definition](https://en.wikipedia.org/wiki/Subset#Definitions).

<a id="中缀运算符-，中缀运算符-⊇--infix--infix-⊇"></a>
### 中缀运算符 (>=)，中缀运算符 ⊇ / infix (>=), infix ⊇

如果 `$a` 是 `$b` 的**超集**，则返回 `True`，否则返回 `False`。[更多信息](https://docs.raku.org/language/operators#infix_(%3E=),_infix_%E2%8A%87)，[维基百科定义](https://en.wikipedia.org/wiki/Subset#Definitions)。

Returns `True` if `$a` is a **superset** of or equal to `$b`, else False. [More information](https://docs.raku.org/language/operators#infix_(%3E=),_infix_%E2%8A%87), [Wikipedia definition](https://en.wikipedia.org/wiki/Subset#Definitions).

<a id="中缀运算符-⊉--infix-⊉"></a>
### 中缀运算符 ⊉ / infix ⊉

如果 `$a` **不是** `$b` 的**超集**，则返回 `True`，否则返回 `False`。[更多信息](https://docs.raku.org/language/operators#infix_%E2%8A%89)，[维基百科定义](https://en.wikipedia.org/wiki/Subset#Definitions)。

Returns `True` if `$a` is **not** a **superset** nor equal to `$b`, else False. [More information](https://docs.raku.org/language/operators#infix_%E2%8A%89), [Wikipedia definition](https://en.wikipedia.org/wiki/Subset#Definitions).

<a id="中缀运算符-，中缀运算符-⊃--infix--infix-⊃"></a>
### 中缀运算符 (>)，中缀运算符 ⊃ / infix (>), infix ⊃

如果 `$a` 是 `$b` 的**严格超集**，则返回 `True`，否则返回 `False`。[更多信息](https://docs.raku.org/language/operators#infix_(%3E),_infix_%E2%8A%83)，[维基百科定义](https://en.wikipedia.org/wiki/Subset#Definitions)。

Returns `True` if `$a` is a **strict superset** of `$b`, else False. [More information](https://docs.raku.org/language/operators#infix_(%3E),_infix_%E2%8A%83), [Wikipedia definition](https://en.wikipedia.org/wiki/Subset#Definitions).

<a id="中缀运算符-⊅--infix-⊅"></a>
### 中缀运算符 ⊅ / infix ⊅

如果 `$a` 不是 `$b` 的**严格超集**，则返回 `True`，否则返回 `False`。[更多信息](https://docs.raku.org/language/operators#infix_%E2%8A%85)，[维基百科定义](https://en.wikipedia.org/wiki/Subset#Definitions)。

Returns `True` if `$a` is **not** a **strict superset** of `$b`, else False. [More information](https://docs.raku.org/language/operators#infix_%E2%8A%85), [Wikipedia definition](https://en.wikipedia.org/wiki/Subset#Definitions).

<a id="返回-quanthash-的集合运算符--set-operators-that-return-a-quanthash"></a>
## 返回 `QuantHash` 的集合运算符 / Set operators that return a `QuantHash`

<a id="中缀运算符-|，中缀运算符-∪--infix-|-infix-∪"></a>
### 中缀运算符 (|)，中缀运算符 ∪ / infix (|), infix ∪

返回其所有参数的**合集**。[更多信息](https://docs.raku.org/language/operators#infix_(|),_infix_%E2%88%AA)，[维基百科定义](https://en.wikipedia.org/wiki/Union_(set_theory))。

Returns the **union** of all its arguments. [More information](https://docs.raku.org/language/operators#infix_(|),_infix_%E2%88%AA), [Wikipedia definition](https://en.wikipedia.org/wiki/Union_(set_theory)).

<a id="中缀运算符-，中缀运算符-∩--infix--infix-∩"></a>
### 中缀运算符 (&)，中缀运算符 ∩ / infix (&), infix ∩

返回其所有参数的**交集**。[更多信息](https://docs.raku.org/language/operators#infix_(&),_infix_%E2%88%A9)，[维基百科定义](https://en.wikipedia.org/wiki/Union_(set_theory))。

Returns the **intersection** of all of its arguments. [More information](https://docs.raku.org/language/operators#infix_(&),_infix_%E2%88%A9), [Wikipedia definition](https://en.wikipedia.org/wiki/Intersection_(set_theory)).

<a id="中缀运算符--，中缀运算符-∖--infix---infix-∖"></a>
### 中缀运算符 (-)，中缀运算符 ∖ / infix (-), infix ∖

返回其所有参数的**集合差**。[更多信息](https://docs.raku.org/language/operators#infix_(-),_infix_%E2%88%96)，[维基百科定义](https://en.wikipedia.org/wiki/Complement_(set_theory)#Relative_complement)。

Returns the **set difference** of all its arguments. [More information](https://docs.raku.org/language/operators#infix_(-),_infix_%E2%88%96), [Wikipedia definition](https://en.wikipedia.org/wiki/Complement_(set_theory)#Relative_complement).

<a id="中缀运算符-^，中缀运算符-⊖--infix-^-infix-⊖"></a>
### 中缀运算符 (^)，中缀运算符 ⊖ / infix (^), infix ⊖

返回其所有参数的**对称差集**。[更多信息](https://docs.raku.org/language/operators#infix_(^),_infix_%E2%8A%96)，[维基百科定义](https://en.wikipedia.org/wiki/Symmetric_difference)。

Returns the **symmetric set difference** of all its arguments. [More information](https://docs.raku.org/language/operators#infix_(^),_infix_%E2%8A%96), [Wikipedia definition](https://en.wikipedia.org/wiki/Symmetric_difference).

<a id="返回-baggy-的集合运算符--set-operators-that-return-a-baggy"></a>
## 返回 `Baggy` 的集合运算符 / Set operators that return a `Baggy`

<a id="中缀运算符-，中缀运算符-⊍--infix--infix-⊍"></a>
### 中缀运算符 (.)，中缀运算符 ⊍ / infix (.), infix ⊍

返回其参数的 Baggy **乘法**。[更多信息](https://docs.raku.org/language/operators#infix_(.),_infix_%E2%8A%8D)。

Returns the Baggy **multiplication** of its arguments. [More information](https://docs.raku.org/language/operators#infix_(.),_infix_%E2%8A%8D).

<a id="中缀运算符-，中缀运算符-⊎--infix--infix-⊎"></a>
### 中缀运算符 (+)，中缀运算符 ⊎ / infix (+), infix ⊎

返回其参数的 Baggy **加法**。[更多信息](https://docs.raku.org/language/operators#infix_(+),_infix_%E2%8A%8E)。

Returns the Baggy **addition** of its arguments. [More information](https://docs.raku.org/language/operators#infix_(+),_infix_%E2%8A%8E).

<a id="与集合运算符有关的术语--terms-related-to-set-operators"></a>
## 与集合运算符有关的术语 / Terms related to set operators

<a id="术语-∅--term-∅"></a>
### 术语 ∅ / term ∅

空集。[更多信息](https://docs.raku.org/language/terms#term_%E2%88%85)，[维基百科定义](https://en.wikipedia.org/wiki/Empty_set)。

The empty set. [More information](https://docs.raku.org/language/terms#term_%E2%88%85), [Wikipedia definition](https://en.wikipedia.org/wiki/Empty_set).
