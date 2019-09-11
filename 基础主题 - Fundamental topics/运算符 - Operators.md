原文：https://docs.perl6.org/language/operators

# 运算符 / Operators

常见的 Perl 6 中缀、前缀、后缀等等！

Common Perl 6 infixes, prefixes, postfixes, and more!

有关如何定义新运算符，请参见[创建运算符](https://docs.perl6.org/language/optut)。

See [creating operators](https://docs.perl6.org/language/optut) on how to define new operators.
<!-- MarkdownTOC -->

- [运算符优先级 / Operator precedence](#%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--operator-precedence)
- [运算符分类 / Operator classification](#%E8%BF%90%E7%AE%97%E7%AC%A6%E5%88%86%E7%B1%BB--operator-classification)
- [元运算符 / Metaoperators](#%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6--metaoperators)
- [替换运算符 / Substitution operators](#%E6%9B%BF%E6%8D%A2%E8%BF%90%E7%AE%97%E7%AC%A6--substitution-operators)
    - [`s///` 就地替换 / `s///` in-place substitution](#s-%E5%B0%B1%E5%9C%B0%E6%9B%BF%E6%8D%A2--s-in-place-substitution)
    - [`S///` 非破坏性替换 / `S///` non-destructive substitution](#s-%E9%9D%9E%E7%A0%B4%E5%9D%8F%E6%80%A7%E6%9B%BF%E6%8D%A2--s-non-destructive-substitution)
    - [`tr///` 就地转写 / `tr///` in-place transliteration](#tr-%E5%B0%B1%E5%9C%B0%E8%BD%AC%E5%86%99--tr-in-place-transliteration)
    - [`TR///` 非破坏性转写 / `TR///` non-destructive transliteration](#tr-%E9%9D%9E%E7%A0%B4%E5%9D%8F%E6%80%A7%E8%BD%AC%E5%86%99--tr-non-destructive-transliteration)
- [赋值运算符 / Assignment operators](#%E8%B5%8B%E5%80%BC%E8%BF%90%E7%AE%97%E7%AC%A6--assignment-operators)
- [否定关系运算符 / Negated relational operators](#%E5%90%A6%E5%AE%9A%E5%85%B3%E7%B3%BB%E8%BF%90%E7%AE%97%E7%AC%A6--negated-relational-operators)
- [反向运算符 / Reversed operators](#%E5%8F%8D%E5%90%91%E8%BF%90%E7%AE%97%E7%AC%A6--reversed-operators)
- [超运算符 / Hyper operators](#%E8%B6%85%E8%BF%90%E7%AE%97%E7%AC%A6--hyper-operators)
- [归约元运算符 / Reduction metaoperators](#%E5%BD%92%E7%BA%A6%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6--reduction-metaoperators)
- [交叉运算符 / Cross operators](#%E4%BA%A4%E5%8F%89%E8%BF%90%E7%AE%97%E7%AC%A6--cross-operators)
- [Zip 元运算符 / Zip metaoperator](#zip-%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6--zip-metaoperator)
- [序列运算符 / Sequential operators](#%E5%BA%8F%E5%88%97%E8%BF%90%E7%AE%97%E7%AC%A6--sequential-operators)
- [元运算符嵌套 / Nesting of metaoperators](#%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6%E5%B5%8C%E5%A5%97--nesting-of-metaoperators)
- [术语优先级 / Term precedence](#%E6%9C%AF%E8%AF%AD%E4%BC%98%E5%85%88%E7%BA%A7--term-precedence)
    - [术语 `` / term ``](#%E6%9C%AF%E8%AF%AD--term-)
    - [术语 `( )` / term `( )`](#%E6%9C%AF%E8%AF%AD----term--)
    - [术语 `{ }` term `{ }`](#%E6%9C%AF%E8%AF%AD---term--)
    - [环缀运算符 `[ ]` / circumfix `[ ]`](#%E7%8E%AF%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6----circumfix--)
- [术语 / Terms](#%E6%9C%AF%E8%AF%AD--terms)
- [方法后缀优先级 / Method postfix precedence](#%E6%96%B9%E6%B3%95%E5%90%8E%E7%BC%80%E4%BC%98%E5%85%88%E7%BA%A7--method-postfix-precedence)
    - [后环缀运算符 `[ ]` / postcircumfix `[ ]`](#%E5%90%8E%E7%8E%AF%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6----postcircumfix--)
    - [后环缀 `{ }` / postcircumfix `{ }`](#%E5%90%8E%E7%8E%AF%E7%BC%80----postcircumfix--)
    - [后环缀 `` / postcircumfix ``](#%E5%90%8E%E7%8E%AF%E7%BC%80--postcircumfix-)
    - [后环缀 `` / postcircumfix ``](#%E5%90%8E%E7%8E%AF%E7%BC%80--postcircumfix--1)
    - [后环缀 `« »` / postcircumfix `« »`](#%E5%90%8E%E7%8E%AF%E7%BC%80-%C2%AB-%C2%BB--postcircumfix-%C2%AB-%C2%BB)
    - [后环缀 `( )` / postcircumfix `( )`](#%E5%90%8E%E7%8E%AF%E7%BC%80----postcircumfix---1)
    - [方法运算符 `.` / methodop `.`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop-)
    - [方法运算符 `.&` / methodop `.&`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--1)
    - [方法运算符 `.=` / methodop `.=`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--2)
    - [方法运算符 `.^` / methodop `.^`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6-%5E--methodop-%5E)
    - [方法运算符 `.?` / methodop `.?`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--3)
    - [方法运算符 `.+` / methodop `.+`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--4)
    - [方法运算符 `.*` / methodop `.*`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--5)
    - [方法运算符 `».` / `>>.` - methodop `».` / methodop `>>.`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6-%C2%BB-----methodop-%C2%BB--methodop-)
    - [方法运算符 `.postfix` / `.postcircumfix` - methodop `.postfix` / `.postcircumfix`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6-postfix--postcircumfix---methodop-postfix--postcircumfix)
    - [methodop `.:`](#methodop-)
    - [methodop `.::`](#methodop--1)
    - [postfix `,=`](#postfix-)
- [Autoincrement precedence](#autoincrement-precedence)
    - [prefix](#prefix)
    - [prefix](#prefix-1)
    - [postfix](#postfix)
    - [postfix `--`](#postfix---)
- [Exponentiation precedence](#exponentiation-precedence)
    - [infix `**`](#infix-)
- [Symbolic unary precedence](#symbolic-unary-precedence)
    - [prefix `?`](#prefix-)
    - [prefix `!`](#prefix--1)
    - [prefix `+`](#prefix--2)
    - [prefix `-`](#prefix--)
    - [prefix `~`](#prefix-%7E)
    - [prefix `|`](#prefix-%7C)
    - [prefix `+^`](#prefix-%5E)
    - [prefix `~^`](#prefix-%7E%5E)
    - [prefix `?^`](#prefix-%5E-1)
    - [prefix `^`](#prefix-%5E-2)
- [Dotty infix precedence](#dotty-infix-precedence)
    - [infix `.=`](#infix--1)
    - [infix `.`](#infix--2)
- [Multiplicative precedence](#multiplicative-precedence)
    - [infix `*`](#infix--3)
    - [infix `/`](#infix--4)
    - [infix `div`](#infix-div)
    - [infix `%`](#infix-%25)
    - [infix `%%`](#infix-%25%25)
    - [infix `mod`](#infix-mod)
    - [infix `+&`](#infix--5)
    - [infix `+<`](#infix--6)
    - [infix `+>`](#infix--7)
    - [infix `~&`](#infix-%7E)
    - [infix `~<`](#infix-%7E-1)
    - [infix `~>`](#infix-%7E-2)
    - [infix `gcd`](#infix-gcd)
    - [infix `lcm`](#infix-lcm)
- [Additive precedence](#additive-precedence)
    - [infix `+`](#infix--8)
    - [infix `-`](#infix--)
    - [infix `+|`](#infix-%7C)
    - [infix `+^`](#infix-%5E)
    - [infix `~|`](#infix-%7E%7C)
    - [infix `~^`](#infix-%7E%5E)
    - [infix `?^`](#infix-%5E-1)
    - [infix `?|`](#infix-%7C-1)
- [Replication precedence](#replication-precedence)
    - [infix `x`](#infix-x)
    - [infix `xx`](#infix-xx)
- [Concatenation](#concatenation)
    - [infix `~`](#infix-%7E-3)
    - [infix `∘`](#infix-%E2%88%98)
- [Junctive AND \(all\) precedence](#junctive-and-all-precedence)
    - [infix `&`](#infix--9)
    - [infix `(&)`, infix `∩`](#infix--infix-%E2%88%A9)
    - [infix `(.)`, infix `⊍`](#infix--infix-%E2%8A%8D)
- [Junctive OR \(any\) precedence](#junctive-or-any-precedence)
    - [infix `|`](#infix-%7C-2)
    - [infix `(|)`, infix `∪`](#infix-%7C-infix-%E2%88%AA)
    - [infix `(+)`, infix `⊎`](#infix--infix-%E2%8A%8E)
    - [infix `(-)`, infix `∖`](#infix---infix-%E2%88%96)
    - [infix `^`](#infix-%5E-2)
    - [infix `(^)`, infix `⊖`](#infix-%5E-infix-%E2%8A%96)
- [Named unary precedence](#named-unary-precedence)
    - [prefix `temp`](#prefix-temp)
    - [prefix `let`](#prefix-let)
- [Nonchaining binary precedence](#nonchaining-binary-precedence)
    - [infix `does`](#infix-does)
    - [infix `but`](#infix-but)
    - [infix `cmp`](#infix-cmp)
    - [infix `coll`](#infix-coll)
    - [infix `unicmp`](#infix-unicmp)
    - [infix `leg`](#infix-leg)
    - [infix ``](#infix--10)
    - [infix `..`](#infix--11)
    - [infix `..^`](#infix-%5E-3)
    - [infix `^..`](#infix-%5E-4)
    - [infix `^..^`](#infix-%5E%5E)
- [Chaining binary precedence](#chaining-binary-precedence)
    - [infix `==`](#infix--12)
    - [infix `!=`](#infix--13)
    - [infix `≠`](#infix-%E2%89%A0)
    - [infix `<`](#infix--14)
    - [infix `<=`](#infix--15)
    - [infix `≤`](#infix-%E2%89%A4)
    - [infix `>`](#infix--16)
    - [infix `>=`](#infix--17)
    - [infix `≥`](#infix-%E2%89%A5)
    - [infix `eq`](#infix-eq)
    - [infix `ne`](#infix-ne)
    - [infix `gt`](#infix-gt)
    - [infix `ge`](#infix-ge)
    - [infix `lt`](#infix-lt)
    - [infix `le`](#infix-le)
    - [infix `before`](#infix-before)
    - [infix `after`](#infix-after)
    - [infix `eqv`](#infix-eqv)
    - [infix `===`](#infix--18)
    - [infix `=:=`](#infix--19)
    - [infix `~~`](#infix-%7E%7E)
    - [infix `=~=`](#infix-%7E-4)
    - [infix \(elem\), infix ∈»](#infix-elem-infix-%E2%88%88%C2%BB)
    - [infix `∉`](#infix-%E2%88%89)
    - [infix \(cont\), infix ∋»](#infix-cont-infix-%E2%88%8B%C2%BB)
    - [infix `∌`](#infix-%E2%88%8C)
    - [infix `(<)`, infix `⊂`](#infix--infix-%E2%8A%82)
    - [infix `⊄`](#infix-%E2%8A%84)
    - [infix `(<=)`, infix `⊆`](#infix--infix-%E2%8A%86)
    - [infix `⊈`](#infix-%E2%8A%88)
    - [infix `(>)`, infix `⊃`](#infix--infix-%E2%8A%83)
    - [infix `⊅`](#infix-%E2%8A%85)
    - [infix `(>=)`, infix `⊇`](#infix--infix-%E2%8A%87)
    - [infix `⊉`](#infix-%E2%8A%89)
- [Tight AND precedence](#tight-and-precedence)
    - [infix `&&`](#infix--20)
- [Tight OR precedence](#tight-or-precedence)
    - [infix `||`](#infix-%7C%7C)
    - [infix `^^`](#infix-%5E%5E-1)
    - [infix `//`](#infix--21)
    - [infix `min`](#infix-min)
    - [infix `max`](#infix-max)
    - [infix `minmax`](#infix-minmax)
- [Conditional operator precedence](#conditional-operator-precedence)
    - [infix `?? !!`](#infix---1)
    - [infix `ff`](#infix-ff)
    - [infix `^ff`](#infix-%5Eff)
    - [infix `ff^`](#infix-ff%5E)
    - [infix `^ff^`](#infix-%5Eff%5E)
    - [infix `fff`](#infix-fff)
    - [infix `^fff`](#infix-%5Efff)
    - [infix `fff^`](#infix-fff%5E)
    - [infix `^fff^`](#infix-%5Efff%5E)
- [Item assignment precedence](#item-assignment-precedence)
    - [infix `=`](#infix--22)
    - [infix `=>`](#infix--23)
- [Loose unary precedence](#loose-unary-precedence)
    - [prefix `not`](#prefix-not)
    - [prefix `so`](#prefix-so)
- [Comma operator precedence](#comma-operator-precedence)
    - [infix `,`](#infix--24)
    - [infix `:`](#infix--25)
- [List infix precedence](#list-infix-precedence)
    - [infix `Z`](#infix-z)
    - [infix `X`](#infix-x-1)
    - [infix `...`](#infix--26)
- [List prefix precedence](#list-prefix-precedence)
    - [infix `=`](#infix--27)
    - [infix `:=`](#infix--28)
    - [infix `::=`](#infix--29)
    - [listop `...`](#listop-)
    - [listop `!!!`](#listop--1)
    - [listop `???`](#listop--2)
    - [Reduction operators](#reduction-operators)
- [Loose AND precedence](#loose-and-precedence)
    - [infix](#infix)
    - [infix](#infix-1)
    - [infix](#infix-2)
- [Loose OR precedence](#loose-or-precedence)
    - [infix `or`](#infix-or)
    - [infix `orelse`](#infix-orelse)
    - [infix `xor`](#infix-xor)
- [Sequencer precedence](#sequencer-precedence)
    - [infix `==>`](#infix--30)
    - [infix `<==`](#infix--31)
- [Identity](#identity)

<!-- /MarkdownTOC -->

<a id="%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--operator-precedence"></a>
# 运算符优先级 / Operator precedence

在像 `1 + 2 * 3` 这样的表达式中，首先计算 `2 * 3`，因为中缀 `*` 比 `+` 具有更高的**优先级**。

In an expression like `1 + 2 * 3`, the `2 * 3` is evaluated first because the infix `*` has tighter **precedence** than the `+`.

下表总结了 Perl 6 中从最高到最低的优先级：

The following table summarizes the precedence levels in Perl 6, from tightest to loosest:

| A    | Level            | Examples                                                     |
| ---- | ---------------- | ------------------------------------------------------------ |
| N    | Terms            | 42 3.14 "eek" qq["foo"] $x :!verbose @$array rand time now ∅ |
| L    | Method postfix   | .meth .+ .? .* .() .[] .{} .<> .«» .:: .= .^ .:              |
| N    | Autoincrement    | ++ --                                                        |
| R    | Exponentiation   | **                                                           |
| L    | Symbolic unary   | ! + - ~ ? \| \|\| +^ ~^ ?^ ^                                 |
| L    | Dotty infix      | .= .                                                         |
| L    | Multiplicative   | * × / ÷ % %% +& +< +> ~& ~< ~> ?& div mod gcd lcm            |
| L    | Additive         | + - − +\| +^ ~\| ~^ ?\| ?^                                   |
| L    | Replication      | x xx                                                         |
| X    | Concatenation    | ~ o ∘                                                        |
| X    | Junctive and     | & (&) (.) ∩ ⊍                                                |
| X    | Junctive or      | \| ^ (\|) (^) (+) (-) ∪ ⊖ ⊎ ∖                                |
| L    | Named unary      | temp let                                                     |
| N    | Structural infix | but does <=> leg unicmp cmp coll .. ..^ ^.. ^..^             |
| C    | Chaining infix   | != ≠ == < <= ≤ > >= ≥ eq ne lt le gt ge ~~ === eqv !eqv =~= ≅ (elem) (cont) (<) (>) (<=) (>=) (<+) (>+) ∈ ∉ ∋ ∌ ⊂ ⊄ ⊃ ⊅ ⊆ ⊈ ⊇ ⊉ ≼ ≽ |
| X    | Tight and        | &&                                                           |
| X    | Tight or         | \|\| ^^ // min max                                           |
| R    | Conditional      | ?? !! ff ff^ ^ff ^ff^ fff fff^ ^fff ^fff^                    |
| R    | Item assignment  | = => += -= **= xx=                                           |
| L    | Loose unary      | so not                                                       |
| X    | Comma operator   | , :                                                          |
| X    | List infix       | Z minmax X X~ X* Xeqv ... … ...^ …^                          |
| R    | List prefix      | print push say die map substr ... [+] [*] any Z=             |
| X    | Loose and        | and andthen notandthen                                       |
| X    | Loose or         | or xor orelse                                                |
| X    | Sequencer        | <==, ==>, <<==, ==>>                                         |
| N    | Terminator       | ; {...}, unless, extra ), ], }                               |

下面用两个 `！` 符号表示具有相同优先级的任何一对运算符，上面阐述的二元运算符的结合性解释如下：

Using two `!` symbols below generically to represent any pair of operators that have the same precedence, the associativities specified above for binary operators are interpreted as follows:

| A    | Assoc | Meaning of $a ! $b ! $c |
| ---- | ----- | ----------------------- |
| L    | left  | ($a ! $b) ! $c          |
| R    | right | $a ! ($b ! $c)          |
| N    | non   | ILLEGAL                 |
| C    | chain | ($a ! $b) and ($b ! $c) |
| X    | list  | infix:<!>($a; $b; $c)   |

对于一元运算符，解释为：

For unary operators this is interpreted as:

| A    | Assoc | Meaning of !$a! |
| ---- | ----- | --------------- |
| L    | left  | (!$a)!          |
| R    | right | !($a!)          |
| N    | non   | ILLEGAL         |

在下面的运算符描述中，假定默认为左结合。

In the operator descriptions below, a default associativity of *left* is assumed.

<a id="%E8%BF%90%E7%AE%97%E7%AC%A6%E5%88%86%E7%B1%BB--operator-classification"></a>
# 运算符分类 / Operator classification

运算符可以出现在与术语相关的几个位置：

Operators can occur in several positions relative to a term:

| +term         | prefix        |
| ------------- | ------------- |
| term1 + term2 | infix         |
| term++        | postfix       |
| (term)        | circumfix     |
| term1[term2]  | postcircumfix |
| .+(term)      | method        |

每个运算符（方法运算符除外）也可用作子例程。例程的名称由运算符类别构成，后跟冒号，然后是由构成运算符的符号构成的列表引号构造：

Each operator (except method operators) is also available as a subroutine. The name of the routine is formed from the operator category, followed by a colon, then a list quote construct with the symbol(s) that make up the operator:

```Perl6
infix:<+>(1, 2);                # same as 1 + 2 
circumfix:«[ ]»(<a b c>);       # same as [<a b c>]
```

作为特殊情况，*listop*（列表运算符）可以作为一个术语或前缀。子例程调用是最常见的列表运算符。其他情况还包括元归约中缀运算符（`[+]1、2、3`）和 [前缀 ...](https://docs.perl6.org/language/operators#prefix_...)等存根运算符。

As a special case, a *listop* (list operator) can stand either as a term or as a prefix. Subroutine calls are the most common listops. Other cases include meta-reduced infix operators (`[+] 1, 2, 3`) and the [prefix ...](https://docs.perl6.org/language/operators#prefix_...) etc. stub operators.

定义自定义运算符包含在[定义运算符函数](https://docs.perl6.org/language/functions#Defining_operators)中。

Defining custom operators is covered in [Defining operators functions](https://docs.perl6.org/language/functions#Defining_operators).

<a id="%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6--metaoperators"></a>
# 元运算符 / Metaoperators

元运算符可以与其他运算符或子例程一起参数化，就像函数可以将函数作为参数一样。要使用子例程作为参数，请在其名称前加上 `&`。Perl 6 将在后台生成实际的组合运算符，允许将该机制应用于用户定义的运算符。要消除链式元运算符的歧义，请将内部运算符括在方括号中。接下来，我们将介绍一些具有不同语义的元运算符。

Metaoperators can be parameterized with other operators or subroutines in the same way as functions can take functions as parameters. To use a subroutine as a parameter, prefix its name with a `&`. Perl 6 will generate the actual combined operator in the background, allowing the mechanism to be applied to user defined operators. To disambiguate chained metaoperators, enclose the inner operator in square brackets. There are quite a few metaoperators with different semantics as explained, next.

<a id="%E6%9B%BF%E6%8D%A2%E8%BF%90%E7%AE%97%E7%AC%A6--substitution-operators"></a>
# 替换运算符 / Substitution operators

每个替换运算符分为两种主要形式：小写形式（例如，`s///`）执行*就地*（即*破坏性*）替换行为；大写形式（例如，`S///`）提供*非破坏性*行为。

Each substitution operator comes into two main forms: a lowercase one (e.g., `s///`) that performs *in-place* (i.e., *destructive* behavior; and an uppercase form (e.g., `S///`) that provides a *non-destructive* behavior.

<a id="s-%E5%B0%B1%E5%9C%B0%E6%9B%BF%E6%8D%A2--s-in-place-substitution"></a>
## `s///` 就地替换 / `s///` in-place substitution

```Perl6
my $str = 'old string';
$str ~~ s/o .+ d/new/;
say $str; # OUTPUT: «new string␤»
```

`s///` 对 `$_` 主题变量进行操作，就地更改。它使用给定的 [`Regex`](https://docs.perl6.org/type/Regex) 查找要替换的部分，并将其更改为提供的替换字符串。将 `$/` 设置为 [`Match`](https://docs.perl6.org/type/Match) 对象，或者，如果进行了多个匹配，则设置为一组 `Match` 对象的。返回值为 `$/`。

`s///` operates on the `$_` topical variable, changing it in place. It uses the given [`Regex`](https://docs.perl6.org/type/Regex) to find portions to replace and changes them to the provided replacement string. Sets `$/` to the [`Match`](https://docs.perl6.org/type/Match) object or, if multiple matches were made, a [`List`](https://docs.perl6.org/type/List) of `Match` objects. Returns `$/`.

通常将此运算符与 `~~` 智能匹配运算符一起使用，因为它将左侧别名设为 `$_`，而 `s///` 使用 `$_`。

It's common to use this operator with the `~~` smartmatch operator, as it aliases left-hand side to `$_`, which `s///` uses.

正则捕获可以在替换部分中引用；它使用与 [`.subst` 方法](https://docs.perl6.org/routine/subst)相同的副词，这些副词位于 `s` 和开头的 `/` 之间，用可选空格分隔：

Regex captures can be referenced in the replacement part; it takes the same adverbs as the [`.subst` method](https://docs.perl6.org/routine/subst), which go between the `s` and the opening `/`, separated with optional whitespace:

```Perl6
my $str = 'foo muCKed into the lEn';
 
# replace second 'o' with 'x' 
$str ~~ s:2nd/o/x/;
 
# replace 'M' or 'L' followed by non-whitespace stuff with 'd' 
# and lower-cased version of that stuff: 
$str ~~ s :g :i/<[ML]> (\S+)/d{lc $0}/;
 
say $str; # OUTPUT: «fox ducked into the den␤»
```

也可以使用不同的分隔符：

You can also use a different delimiter:

```Perl6
my $str = 'foober';
$str ~~ s!foo!fox!;
$str ~~ s{b(.)r} = " d$0n";
say $str; # OUTPUT: «fox den␤»
```

非成对字符可以简单地替换原来的斜杠。成对的字符，如大括号，只在匹配部分使用，替换部分以赋值（任何东西：字符串、例程调用等）的形式给出。

Non-paired characters can simply replace the original slashes. Paired characters, like curly braces, are used only on the match portion, with the substitution given by assignment (of anything: a string, a routine call, etc.).

<a id="s-%E9%9D%9E%E7%A0%B4%E5%9D%8F%E6%80%A7%E6%9B%BF%E6%8D%A2--s-non-destructive-substitution"></a>
## `S///` 非破坏性替换 / `S///` non-destructive substitution

```Perl6
say S/o .+ d/new/ with 'old string';      # OUTPUT: «new string␤» 
S:g/« (.)/$0.uc()/.say for <foo bar ber>; # OUTPUT: «Foo␤Bar␤Ber␤»
```

`S///` 使用与 `s///` 运算符相同的语义，只是它保留原始字符串不变，*返回运算结果字符串*而不是 `$/`（`$/` 仍设置为与 `s///` 相同的值）。

`S///` uses the same semantics as the `s///` operator, except it leaves the original string intact and *returns the resultant string* instead of `$/` (`$/` still being set to the same values as with `s///`).

**注意：**由于结果是作为返回值获得的，因此将此运算符与 `~~ ` 智能匹配运算符一起使用是错误的，并将发出警告。若要对不是此运算符使用的 `$_` 的变量执行替换，请将其别名为 `$_` 使用 `given`、`with`，或任何其他方式。或者，使用 [`.subst` 方法](https://docs.perl6.org/routine/subst)。

**Note:** since the result is obtained as a return value, using this operator with the `~~` smartmatch operator is a mistake and will issue a warning. To execute the substitution on a variable that isn't the `$_` this operator uses, alias it to `$_` with `given`, `with`, or any other way. Alternatively, use the [`.subst` method](https://docs.perl6.org/routine/subst).

<a id="tr-%E5%B0%B1%E5%9C%B0%E8%BD%AC%E5%86%99--tr-in-place-transliteration"></a>
## `tr///` 就地转写 / `tr///` in-place transliteration

```Perl6
my $str = 'old string';
$str ~~ tr/dol/wne/;
say $str; # OUTPUT: «new string␤»
```

`tr///` 对 `$_` 主题变量进行操作并对其。它的行为类似于使用单个[键值对](https://docs.perl6.org/type/Pair)参数调用的 [`Str.trans`](https://docs.perl6.org/routine/trans)，其中键是匹配部分（上面示例中的字符 `dol`），值是替换部分（上面示例中的字符 `wne`）。接受与 [`Str.trans`](https://docs.perl6.org/routine/trans) 相同的副词。返回 [StrDistance](https://docs.perl6.org/type/StrDistance) 对象，该对象测量原始值与返回结果字符串之间的距离。

`tr///` operates on the `$_` topical variable and changes it in place. It behaves similar to [`Str.trans`](https://docs.perl6.org/routine/trans) called with a single [Pair](https://docs.perl6.org/type/Pair) argument, where key is the matching part (characters `dol` in the example above) and value is the replacement part (characters `wne` in the example above). Accepts the same adverbs as [`Str.trans`](https://docs.perl6.org/routine/trans). Returns the [StrDistance](https://docs.perl6.org/type/StrDistance) object that measures the distance between original value and the resultant string.

```Perl6
my $str = 'old string';
$str ~~ tr:c:d/dol st//;
say $str; # OUTPUT: «ring␤»
```

<a id="tr-%E9%9D%9E%E7%A0%B4%E5%9D%8F%E6%80%A7%E8%BD%AC%E5%86%99--tr-non-destructive-transliteration"></a>
## `TR///` 非破坏性转写 / `TR///` non-destructive transliteration

```Perl6
with 'old string' {
    say TR/dol/wne/; # OUTPUT: «new string␤» 
}
```

`TR///` 的行为与 `tr///` 运算符相同，只是它保持 `$_` 值不变，而是返回结果字符串。

`TR///` behaves the same as the `tr///` operator, except that it leaves the `$_` value untouched and instead returns the resultant string.

```Perl6
say TR:d/dol // with 'old string'; # OUTPUT: «string␤»
```

<a id="%E8%B5%8B%E5%80%BC%E8%BF%90%E7%AE%97%E7%AC%A6--assignment-operators"></a>
# 赋值运算符 / Assignment operators

中缀运算符可以与赋值运算符组合，以修改值并一次性将结果应用于容器。如果可能的话，容器将被自动激活。一些例子：

Infix operators can be combined with the assignment operator to modify a value and apply the result to a container in one go. Containers will be autovivified if possible. Some examples:

```Perl6
my $a = 32;
$a += 10;     # 42 
$a -= 2;      # 40 
 
$a = 3;
$a min= 5;    # still 3 
$a min= 2;    # 2 
 
my $s = 'a';
$s ~= 'b';    # 'ab'
```

此行为将自动扩展为包括自定义的中缀运算符。

This behavior is automatically extended to include custom-defined infix operators.

```Perl6
sub infix:<space-concat> ($a, $b) { $a ~ " " ~ $b };
my $a = 'word1';
$a space-concat= 'word2';     # RESULT: «'word1 word2'»
```

虽然不是严格意义上的运算符，但方法可以以相同的方式使用。

Although not strictly operators, methods can be used in the same fashion.

```Perl6
my Real $a = 1/2;
$a = 3.14;
$a .= round;      # RESULT: «3»
```

<a id="%E5%90%A6%E5%AE%9A%E5%85%B3%E7%B3%BB%E8%BF%90%E7%AE%97%E7%AC%A6--negated-relational-operators"></a>
# 否定关系运算符 / Negated relational operators 

返回 `Bool` 的关系运算符的结果可以用前缀 `!` 否定。为避免与 `!!` 运算符的视觉混淆，不能修改已经以 `!` 开头的任何运算符.

The result of a relational operator returning `Bool` can be negated by prefixing with `!`. To avoid visual confusion with the `!!` operator, you may not modify any operator already beginning with `!`.

`!==` 和 `!eq` 的简写形式为 `!=` 和 `ne`。

There are shortcuts for `!==` and `!eq`, namely `!=` and `ne`.

```Perl6
my $a = True;
say so $a != True;    # OUTPUT: «False␤» 
my $i = 10;
 
my $release = Date.new(:2015year, :12month, :24day);
my $today = Date.today;
say so $release !before $today;     # OUTPUT: «False␤»
```

<a id="%E5%8F%8D%E5%90%91%E8%BF%90%E7%AE%97%E7%AC%A6--reversed-operators"></a>
# 反向运算符 / Reversed operators 

任何中缀运算符将它的两个参数用前缀 `R` 反转调用。操作数的关联性也会反转。

Any infix operator may be called with its two arguments reversed by prefixing with `R`. Associativity of operands is reversed as well.

```Perl6
say 4 R/ 12;               # OUTPUT: «3␤» 
say [R/] 2, 4, 16;         # OUTPUT: «2␤» 
say [RZ~] <1 2 3>,<4 5 6>  # OUTPUT: «(41 52 63)␤»
```

<a id="%E8%B6%85%E8%BF%90%E7%AE%97%E7%AC%A6--hyper-operators"></a>
# 超运算符 / Hyper operators

超运算符包括 `«` 和 `»`，以及它们的 ASCII 变体 `<<` 和 `>>`。它们对一个或两个列表应用由 `«` 和/或 `»` 括起来的给定运算符（对于一元运算符，在运算符前面或后面），返回结果列表，其中 `«` 或 `»` 的箭头部分指向较短的列表。单个元素会被转换为列表，因此也可以使用它们。如果其中一个列表短于另一个列表，则操作员将在较短列表上循环，直到处理完较长列表中的所有元素。

Hyper operators include `«` and `»`, with their ASCII variants `<<` and `>>`. They apply a given operator enclosed (or preceded or followed, in the case of unary operators) by `«` and/or `»` to one or two lists, returning the resulting list, with the pointy part of `«` or `»` aimed at the shorter list. Single elements are turned to a list, so they can be used too. If one of the lists is shorter than the other, the operator will cycle over the shorter list until all elements of the longer list are processed.

```Perl6
say (1, 2, 3) »*» 2;          # OUTPUT: «(2 4 6)␤» 
say (1, 2, 3, 4) »~» <a b>;   # OUTPUT: «(1a 2b 3a 4b)␤» 
say (1, 2, 3) »+« (4, 5, 6);  # OUTPUT: «(5 7 9)␤» 
say (&sin, &cos, &sqrt)».(0.5);
# OUTPUT: «(0.479425538604203 0.877582561890373 0.707106781186548)␤»
```

最后一个示例演示了超运算符如何应用于后环缀运算符（在本例中为 .() ）。

The last example illustrates how postcircumfix operators (in this case .()) can also be hypered.

```Perl6
my @a = <1 2 3>;
my @b = <4 5 6>;
say (@a,@b)»[1]; # OUTPUT: «(2 5)␤»
```

在本例中，超运算符应用于[后环缀运算符[]](https://docs.perl6.org/language/operators#circumfix_[_])。

In this case, it's the [postcircumfix[]](https://docs.perl6.org/language/operators#circumfix_[_]) which is being hypered.

赋值元运算符可以被超运算符化。

Assignment metaoperators can be *hyped*.

```Perl6
my @a = 1, 2, 3;
say @a »+=» 1;    # OUTPUT: «[2 3 4]␤» 
my ($a, $b, $c);
(($a, $b), $c) «=» ((1, 2), 3);
say "$a, $c";       #  OUTPUT: «1, 3␤»
```

一元运算符的超级形式有指向运算符的尖位和待操作列表的钝端。

Hyper forms of unary operators have the pointy bit aimed at the operator and the blunt end at the list to be operated on.

```Perl6
my @wisdom = True, False, True;
say !« @wisdom;     # OUTPUT: «[False True False]␤» 
 
my @a = 1, 2, 3;
@a»++;              # OUTPUT: «(2, 3, 4)␤»
```

超运算符在嵌套数组上是递归定义的。

Hyper operators are defined recursively on nested arrays.

```Perl6
say -« [[1, 2], 3]; # OUTPUT: «[[-1 -2] -3]␤»
```

此外，可以以无序、并发的方式调用方法。结果列表将按顺序排列。请注意，所有超运算符都是并行运算的的候选人，如果这些方法有副作用，有你哭的时候。优化器完全控制超运算符，这就是用户无法定义它们的原因。

Also, methods can be called in an out of order, concurrent fashion. The resulting list will be in order. Note that all hyper operators are candidates for parallelism and will cause tears if the methods have side effects. The optimizer has full reign over hyper operators, which is the reason that they cannot be defined by the user.

```Perl6
class CarefulClass { method take-care {} }
my CarefulClass @objs;
my @results = @objs».take-care();
 
my @slops;        # May Contain Nuts 
@slops».?this-method-may-not-exist();
```

超运算符可以使用哈希。箭头方向指示是否要在结果哈希中忽略缺少的键。封闭运算符对两个散列中都有键的所有值进行操作。

Hyper operators can work with hashes. The pointy direction indicates if missing keys are to be ignored in the resulting hash. The enclosed operator operates on all values that have keys in both hashes.

| %foo «+» %bar;     | intersection of keys                                         |
| ------------------ | ------------------------------------------------------------ |
| %foo »+« %bar;     | union of keys                                                |
| %outer »+» %inner; | only keys of %inner that exist in %outer will occur in the result |

```Perl6
my %outer = 1, 2, 3 Z=> <a b c>;
my %inner = 1, 2 Z=> <x z>;
say %outer «~» %inner;          # OUTPUT: «{"1" => "ax", "2" => "bz"}␤»
```

超运算符可以将用户定义的运算符作为其运算符参数。

Hyper operators can take user-defined operators as their operator argument.

```Perl6
sub pretty-file-size (Int $size --> Str) {
    # rounding version of infix:</>(Int, Int) 
    sub infix:<r/>(Int \i1, Int \i2) {
        round(i1 / i2, 0.1)
    }
 
    # we build a vector of fractions of $size and zip that with the fitting prefix 
    for $size «[r/]« (2**60, 2**50, 2**40, 2**30, 2**20, 2**10)
              Z      <EB     PB     TB     GB     MB     KB> -> [\v,\suffix] {
        # starting with the biggest suffix, 
        # we take the first that is 0.5 of that suffix or bigger 
        return v ~ ' ' ~ suffix if v > 0.4
    }
    # this be smaller or equal then 0.4 KB 
    return $size.Str;
}
 
for 60, 50, 40, 30, 20, 10 -> $test {
    my &a = { (2 ** $test) * (1/4, 1/2, 1, 10, 100).pick * (1..10).pick };
    print pretty-file-size(a.Int) xx 2, ' ';
}
 
# OUTPUT: «10 EB 4 EB 2 PB 5 PB 0.5 PB 4 TB 300 GB 4.5 GB 50 MB 200 MB 9 KB 0.6 MB␤»
```

超运算符是否下放到子列表中取决于链的内部运算符的[节点性](https://docs.perl6.org/language/typesystem#trait_is_nodal)。对于超方法调用运算符（».），目标方法的节点性是重要的。

Whether hyperoperators descend into child lists depends on the [nodality](https://docs.perl6.org/language/typesystem#trait_is_nodal) of the inner operator of a chain. For the hyper method call operator (».), the nodality of the target method is significant.

```Perl6
say (<a b>, <c d e>)».elems;        # OUTPUT: «(2 3)␤» 
say (<a b>, <c d e>)».&{ .elems };  # OUTPUT: «((1 1) (1 1 1))␤»
```

您可以将超级运算符链接起来，以对列表的列表进行解构。

You can chain hyper operators to destructure a List of Lists.

```Perl6
my $neighbors = ((-1, 0), (0, -1), (0, 1), (1, 0));
my $p = (2, 3);
say $neighbors »>>+<<» ($p, *);   # OUTPUT: «((1 3) (2 2) (2 4) (3 3))␤»
```

<a id="%E5%BD%92%E7%BA%A6%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6--reduction-metaoperators"></a>
# 归约元运算符 / Reduction metaoperators

归约元运算符 `[]`，使用给定的中缀运算符归约一个列表。它给出的结果与 [reduce](https://docs.perl6.org/routine/reduce) 例程相同-有关详细信息，请参见此处。

The reduction metaoperator, `[ ]`, reduces a list with the given infix operator. It gives the same result as the [reduce](https://docs.perl6.org/routine/reduce) routine - see there for details.

```Perl6
# These two are equivalent: 
say [+] 1, 2, 3;                # OUTPUT: «6␤» 
say reduce &infix:<+>, 1, 2, 3; # OUTPUT: «6␤»
```

方括号和运算符之间不允许有空格。要包装函数而不是运算符，请提供另一层方括号：

No whitespace is allowed between the square brackets and the operator. To wrap a function instead of an operator, provide an additional layer of square brackets:

```Perl6
sub plus { $^a + $^b };
say [[&plus]] 1, 2, 3;          # OUTPUT: «6␤»
```

参数列表不展开即遍历。这意味着您可以将嵌套列表传递给列表中缀运算符的缩减形式：

The argument list is iterated without flattening. This means that you can pass a nested list to the reducing form of a list infix operator:

```Perl6
say [X~] (1, 2), <a b>;         # OUTPUT: «(1a 1b 2a 2b)␤»
```

相当于 `1, 2 X~ <a b>`。

which is equivalent to `1, 2 X~ <a b>`.

默认情况下，只返回缩减的最终结果。在换行运算符前面加上 `\`，以返回所有中间值的惰性列表。这被称为“三角形减少”。如果非元部分已经包含一个 `\` 值，请用 `[]` 引用它（例如 `[\[\x]`）。

By default, only the final result of the reduction is returned. Prefix the wrapped operator with a `\`, to return a lazy list of all intermediate values instead. This is called a "triangular reduce". If the non-meta part contains a `\` already, quote it with `[]` (e.g. `[\[\x]]`).

```Perl6
my @n = [\~] 1..*;
say @n[^5];         # OUTPUT: «(1 12 123 1234 12345)␤»
```

<a id="%E4%BA%A4%E5%8F%89%E8%BF%90%E7%AE%97%E7%AC%A6--cross-operators"></a>
# 交叉运算符 / Cross operators

交叉元运算符 `X` 将按交叉积的顺序对所有列表应用给定的中缀运算符，以便最右边的运算符变化最快。

The cross metaoperator, `X`, will apply a given infix operator in order of cross product to all lists, such that the rightmost operator varies most quickly.

```Perl6
1..3 X~ <a b> # RESULT: «<1a, 1b, 2a, 2b, 3a, 3b>␤»
```

<a id="zip-%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6--zip-metaoperator"></a>
# Zip 元运算符 / Zip metaoperator 

zip 元运算符（它与 [Z](https://docs.perl6.org/language/operators#infix_Z) 不同）将对从其参数中左、右各取一个元素组成的键值对应用给定的中缀运算符。返回结果列表。

The zip metaoperator (which is not the same thing as [Z](https://docs.perl6.org/language/operators#infix_Z)) will apply a given infix operator to pairs taken one left, one right, from its arguments. The resulting list is returned.

```Perl6
my @l = <a b c> Z~ 1, 2, 3;     # RESULT: «[a1 b2 c3]␤»
```

如果其中一个操作数过早用完元素，则 zip 运算符将停止。无限列表可用于重复元素。最后一个元素为 `*` 的列表将无限期地重复其最后第二个元素。

If one of the operands runs out of elements prematurely, the zip operator will stop. An infinite list can be used to repeat elements. A list with a final element of `*` will repeat its 2nd last element indefinitely.

```Perl6
my @l = <a b c d> Z~ ':' xx *;  # RESULT: «<a: b: c: d:>» 
   @l = <a b c d> Z~ 1, 2, *;   # RESULT: «<a1 b2 c2 d2>»
```

如果未指定中缀运算符，则默认情况下将使用 `,`（逗号运算符）：

If an infix operator is not given, the `,` (comma operator) will be used by default:

```Perl6
my @l = 1 Z 2;  # RESULT: «[(1 2)]»
```

<a id="%E5%BA%8F%E5%88%97%E8%BF%90%E7%AE%97%E7%AC%A6--sequential-operators"></a>
# 序列运算符 / Sequential operators 

序列元运算符 `S` 将禁止优化器执行任何并发或重新排序。支持大多数简单的中缀运算符。

The sequential metaoperator, `S`, will suppress any concurrency or reordering done by the optimizer. Most simple infix operators are supported.

```Perl6
say so 1 S& 2 S& 3;  # OUTPUT: «True␤»
```

<a id="%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6%E5%B5%8C%E5%A5%97--nesting-of-metaoperators"></a>
# 元运算符嵌套 / Nesting of metaoperators

为了避免在链接元运算符时出现歧义，请使用方括号帮助编译器理解您。

To avoid ambiguity when chaining metaoperators, use square brackets to help the compiler understand you.

```Perl6
my @a = 1, 2, 3;
my @b = 5, 6, 7;
@a X[+=] @b;
say @a;         # OUTPUT: «[19 20 21]␤»
```

<a id="%E6%9C%AF%E8%AF%AD%E4%BC%98%E5%85%88%E7%BA%A7--term-precedence"></a>
# 术语优先级 / Term precedence

<a id="%E6%9C%AF%E8%AF%AD--term-"></a>
## 术语 `< >` / term `< >`

引用词语构造将内容按空白分解，并返回单词的[列表](https://docs.perl6.org/type/List)。如果一个单词看起来像数字字面量或键值对字面量，它将被转换为适当的数字。

The quote-words construct breaks up the contents on whitespace and returns a [List](https://docs.perl6.org/type/List) of the words. If a word looks like a number literal or a `Pair` literal, it's converted to the appropriate number.

```Perl6
say <a b c>[1];   # OUTPUT: «b␤»
```

<a id="%E6%9C%AF%E8%AF%AD----term--"></a>
## 术语 `( )` / term `( )`

分组运算符。

The grouping operator.

空组 `()` 创建一个[空列表](https://docs.perl6.org/type/List#index-entry-()_empty_list)。非空表达式周围的括号只是简单地构造表达式，但没有附加的语义。

An empty group `()` creates an [empty list](https://docs.perl6.org/type/List#index-entry-()_empty_list). Parentheses around non-empty expressions simply structure the expression, but do not have additional semantics.

在参数列表中，将括号放在参数周围可防止将其解释为命名参数。

In an argument list, putting parenthesis around an argument prevents it from being interpreted as a named argument.

```Perl6
multi sub p(:$a!) { say 'named'      }
multi sub p($a)   { say 'positional' }
p a => 1;           # OUTPUT: «named␤» 
p (a => 1);         # OUTPUT: «positional␤»
```

<a id="%E6%9C%AF%E8%AF%AD---term--"></a>
## 术语 `{ }` term `{ }`

[代码块](https://docs.perl6.org/type/Block) 或者[哈希](https://docs.perl6.org/type/Hash)的构造器。

[Block](https://docs.perl6.org/type/Block) or [Hash](https://docs.perl6.org/type/Hash) constructor.

如果内容为空或者包含以[键值对](https://docs.perl6.org/type/Pair)字面量或 `%` 标记的变量开头的单个列表，并且不使用 [`$_` 变量](https://docs.perl6.org/syntax/$_)或占位符参数，则构造器返回一个[哈希](https://docs.perl6.org/type/Hash)。否则它将构造一个[代码块](https://docs.perl6.org/type/Block)。

If the content is empty, or contains a single list that starts with a [Pair](https://docs.perl6.org/type/Pair) literal or `%`-sigiled variable, and the [`$_` variable](https://docs.perl6.org/syntax/$_) or placeholder parameters are not used, the constructor returns a [Hash](https://docs.perl6.org/type/Hash). Otherwise it constructs a [Block](https://docs.perl6.org/type/Block).

若要强制构造[代码块](https://docs.perl6.org/type/Block)，请在左大括号后加分号。要始终确保获得一个 [Hash](https://docs.perl6.org/type/Hash) ，可以改用 `%( )` 或 [hash](https://docs.perl6.org/routine/hash) 例程：

To force construction of a [Block](https://docs.perl6.org/type/Block), follow the opening brace with a semicolon. To always ensure you end up with a [Hash](https://docs.perl6.org/type/Hash), you can use `%( )` coercer or [hash](https://docs.perl6.org/routine/hash) routine instead:

```Perl6
{}.^name.say;        # OUTPUT: «Hash␤» 
{;}.^name.say;       # OUTPUT: «Block␤» 
 
{:$_}.^name.say;     # OUTPUT: «Block␤» 
%(:$_).^name.say;    # OUTPUT: «Hash␤» 
hash(:$_).^name.say; # OUTPUT: «Hash␤»
```

<a id="%E7%8E%AF%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6----circumfix--"></a>
## 环缀运算符 `[ ]` / circumfix `[ ]`

[数组](https://docs.perl6.org/type/Array)构造器返回一个在列表上下文中不展平的逐项[数组](https://docs.perl6.org/type/Array)。看这个：

The [Array](https://docs.perl6.org/type/Array) constructor returns an itemized [Array](https://docs.perl6.org/type/Array) that does not flatten in list context. Check this:

```Perl6
say .perl for [3,2,[1,0]]; # OUTPUT: «3␤2␤$[1, 0]␤»
```

此数组是逐项列出的，即每个元素都构成一个项，如数组最后一个元素 [(列表) 条目上下文化器](https://docs.perl6.org/type/Any#index-entry-%24_%28item_contextualizer%29)。

This array is itemized, in the sense that every element constitutes an item, as shown by the `$` preceding the last element of the array, the [(list) item contextualizer](https://docs.perl6.org/type/Any#index-entry-%24_%28item_contextualizer%29).

<a id="%E6%9C%AF%E8%AF%AD--terms"></a>
# 术语 / Terms

术语有自己的[扩展文档](https://docs.perl6.org/language/terms)。

Terms have their [own extended documentation](https://docs.perl6.org/language/terms).

<a id="%E6%96%B9%E6%B3%95%E5%90%8E%E7%BC%80%E4%BC%98%E5%85%88%E7%BA%A7--method-postfix-precedence"></a>
# 方法后缀优先级 / Method postfix precedence

<a id="%E5%90%8E%E7%8E%AF%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6----postcircumfix--"></a>
## 后环缀运算符 `[ ]` / postcircumfix `[ ]`

```Perl6
sub postcircumfix:<[ ]>(@container, **@index,
                        :$k, :$v, :$kv, :$p, :$exists, :$delete)
```

用于对 @container 的零个或多个元素进行位置访问的通用接口，也称为“数组索引运算符”。

Universal interface for positional access to zero or more elements of a @container, a.k.a. "array indexing operator".

```Perl6
my @alphabet = 'a' .. 'z';
say @alphabet[0];                   # OUTPUT: «a␤» 
say @alphabet[1];                   # OUTPUT: «b␤» 
say @alphabet[*-1];                 # OUTPUT: «z␤» 
say @alphabet[100]:exists;          # OUTPUT: «False␤» 
say @alphabet[15, 4, 17, 11].join;  # OUTPUT: «perl␤» 
say @alphabet[23 .. *].perl;        # OUTPUT: «("x", "y", "z")␤» 
 
@alphabet[1, 2] = "B", "C";
say @alphabet[0..3].perl            # OUTPUT: «("a", "B", "C", "d")␤»
```

请参阅[下标](https://docs.perl6.org/language/subscripts)，了解有关此运算符行为的更详细解释以及如何在自定义类型中实现对它的支持。

See [Subscripts](https://docs.perl6.org/language/subscripts), for a more detailed explanation of this operator's behavior and for how to implement support for it in custom types.

<a id="%E5%90%8E%E7%8E%AF%E7%BC%80----postcircumfix--"></a>
## 后环缀 `{ }` / postcircumfix `{ }`

```Perl6
sub postcircumfix:<{ }>(%container, **@key,
                        :$k, :$v, :$kv, :$p, :$exists, :$delete)
```

用于关联访问哈希容器的零个或多个元素的通用接口，也称为“哈希索引运算符”。

Universal interface for associative access to zero or more elements of a %container, a.k.a. "hash indexing operator".

```Perl6
my %color = kiwi => "green", banana => "yellow", cherry => "red";
say %color{"banana"};                 # OUTPUT: «yellow␤» 
say %color{"cherry", "kiwi"}.perl;    # OUTPUT: «("red", "green")␤» 
say %color{"strawberry"}:exists;      # OUTPUT: «False␤» 
 
%color{"banana", "lime"} = "yellowish", "green";
%color{"cherry"}:delete;
say %color;             # OUTPUT: «banana => yellowish, kiwi => green, lime => green␤»
```

请参阅[后环缀 `< >`](https://docs.perl6.org/routine/%3C%20%3E#(Operators)_postcircumfix_%3C_%3E) 和[后环缀 `« »`](https://docs.perl6.org/routine/%C2%AB%20%C2%BB#(Operators)_postcircumfix_%C2%AB_%C2%BB) 以获取方便的快捷方式，以及[下标](https://docs.perl6.org/language/subscripts)以获取有关此操作符行为的更详细解释，以及如何在自定义类型中实现对其的支持。

See [`postcircumfix < >`](https://docs.perl6.org/routine/%3C%20%3E#(Operators)_postcircumfix_%3C_%3E) and [`postcircumfix « »`](https://docs.perl6.org/routine/%C2%AB%20%C2%BB#(Operators)_postcircumfix_%C2%AB_%C2%BB) for convenient shortcuts, and [Subscripts](https://docs.perl6.org/language/subscripts) for a more detailed explanation of this operator's behavior and how to implement support for it in custom types.

<a id="%E5%90%8E%E7%8E%AF%E7%BC%80--postcircumfix-"></a>
## 后环缀 `<>` / postcircumfix `<>`

反容器化运算符，它从容器中提取值并使其独立于容器类型。

Decontainerization operator, which extracts the value from a container and makes it independent of the container type.

```Perl6
use JSON::Tiny;
 
my $config = from-json('{ "files": 3, "path": "/home/perl6/perl6.pod6" }');
say $config.perl;      # OUTPUT: «${:files(3), :path("/home/perl6/perl6.pod6")}» 
my %config-hash = $config<>;
say %config-hash.perl; # OUTPUT: «{:files(3), :path("/home/perl6/perl6.pod6")}» 
```

在这两种情况下，它都是一个哈希，可以像这样使用；但是，在第一种情况下，它是在item上下文中，在第二种情况下，它被提取到适当的上下文中。

It's a `Hash` in both cases, and it can be used like that; however, in the first case it was in item context, and in the second case it has been extracted to its proper context.

<a id="%E5%90%8E%E7%8E%AF%E7%BC%80--postcircumfix--1"></a>
## 后环缀 `< >` / postcircumfix `< >`

[后环缀 `{ }`](https://docs.perl6.org/routine/%7B%20%7D#(Operators)_postcircumfix_{_}) 的快捷方式，该快捷方式使用与同名的[引用词运算符](https://docs.perl6.org/routine/%3C%20%3E#circumfix_%3C_%3E)相同的规则引用其参数。

Shortcut for [`postcircumfix { }`](https://docs.perl6.org/routine/%7B%20%7D#(Operators)_postcircumfix_{_}) that quotes its argument using the same rules as the [quote-words operator](https://docs.perl6.org/routine/%3C%20%3E#circumfix_%3C_%3E) of the same name.

```Perl6
my %color = kiwi => "green", banana => "yellow", cherry => "red";
say %color<banana>;               # OUTPUT: «yellow␤» 
say %color<cherry kiwi>.perl;     # OUTPUT: «("red", "green")␤» 
say %color<strawberry>:exists;    # OUTPUT: «False␤»
```

从技术上讲，它不是一个真正的运算符；是语法糖在编译时变成了 `{ }` 后环缀运算符。

Technically, not a real operator; it's syntactic sugar that's turned into the `{ }` postcircumfix operator at compile-time.

<a id="%E5%90%8E%E7%8E%AF%E7%BC%80-%C2%AB-%C2%BB--postcircumfix-%C2%AB-%C2%BB"></a>
## 后环缀 `« »` / postcircumfix `« »`

[后环缀 `{ }`](https://docs.perl6.org/routine/%7B%20%7D#(Operators)_postcircumfix_{_})的快捷方式，该快捷方式使用与同名的[引用词插值运算符](https://docs.perl6.org/language/quoting#Word_quoting_with_interpolation_and_quote_protection:_%C2%AB_%C2%BB)相同的规则引用其参数。

Shortcut for [`postcircumfix { }`](https://docs.perl6.org/routine/%7B%20%7D#(Operators)_postcircumfix_{_}) that quotes its argument using the same rules as the [interpolating quote-words operator](https://docs.perl6.org/language/quoting#Word_quoting_with_interpolation_and_quote_protection:_%C2%AB_%C2%BB) of the same name.

```Perl6
my %color = kiwi => "green", banana => "yellow", cherry => "red";
my $fruit = "kiwi";
say %color«cherry "$fruit"».perl;   # OUTPUT: «("red", "green")␤»
```

从技术上讲，它不是一个真正的运算符；是语法糖在编译时变成了 `{ }` 后环缀运算符。

Technically, not a real operator; it's syntactic sugar that's turned into the `{ }` postcircumfix operator at compile-time.

<a id="%E5%90%8E%E7%8E%AF%E7%BC%80----postcircumfix---1"></a>
## 后环缀 `( )` / postcircumfix `( )`

函数调用运算符将调用者视为[可调用的](https://docs.perl6.org/type/Callable)并使用括号之间的表达式作为参数调用它。

The call operator treats the invocant as a [Callable](https://docs.perl6.org/type/Callable) and invokes it, using the expression between the parentheses as arguments.

请注意，后面跟着一对圆括号的标识符始终被解析为子例程调用。

Note that an identifier followed by a pair of parentheses is always parsed as a subroutine call.

如果希望对象响应调用运算符，请实现方法 `CALL-ME`。

If you want your objects to respond to the call operator, implement a `method CALL-ME`.

<a id="%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop-"></a>
## 方法运算符 `.` / methodop `.`

用于调用一个方法的运算符，格式为 `$invocant.method`。

The operator for calling one method, `$invocant.method`.

从技术上讲，不是真正的运算符；它是编译器中的句法特例。

Technically, not a real operator; it's syntax special-cased in the compiler.

<a id="%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--1"></a>
## 方法运算符 `.&` / methodop `.&`

调用子例程（至少有一个位置参数）的运算符，如方法。调用者将绑定到第一个位置参数。

The operator to call a subroutine (with at least one positional argument), such as a method. The invocant will be bound to the first positional argument.

从技术上讲，不是真正的运算符；它是编译器中的句法特例。

Technically, not a real operator; it's syntax special-cased in the compiler.

```Perl6
my sub f($invocant){ "The arg has a value of $invocant" }
42.&f;
# OUTPUT: «The arg has a value of 42␤» 
 
42.&(-> $invocant { "The arg has a value of $invocant" });
# OUTPUT: «The arg has a value of 42␤»
```

<a id="%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--2"></a>
## 方法运算符 `.=` / methodop `.=`

一个变异的方法调用。`$invocant.=method` 是 `$invocant = $invocant.method` 的语法糖，类似于 [=](https://docs.perl6.org/routine/=)。

A mutating method call. `$invocant.=method` desugars to `$invocant = $invocant.method`, similar to [=](https://docs.perl6.org/routine/=) .

从技术上讲，不是真正的运算符；它是编译器中的句法特例。

Technically, not a real operator; it's syntax special-cased in the compiler.

<a id="%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6-%5E--methodop-%5E"></a>
## 方法运算符 `.^` / methodop `.^`

元方法调用。`$invocant.^method` 对调用者 `$invocant` 的元类调用方法 `method`。为 `$invocant.HOW.method($invocant, ...)` 的语法糖。有关详细信息，请参阅[元对象协议文档](https://docs.perl6.org/language/mop)。

A meta-method call. `$invocant.^method` calls `method` on `$invocant`'s metaclass. It desugars to `$invocant.HOW.method($invocant, ...)`. See [the meta-object protocol documentation](https://docs.perl6.org/language/mop) for more information.

从技术上讲，不是真正的运算符；它是编译器中的句法特例。

Technically, not a real operator; it's syntax special-cased in the compiler.

<a id="%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--3"></a>
## 方法运算符 `.?` / methodop `.?`

安全调用运算符。`$invocant.?method` 对调用者 `$invocant` 调用方法 `method` 如果它有这样一个名称的方法。否则返回 [Nil](https://docs.perl6.org/type/Nil)。

Safe call operator. `$invocant.?method` calls method `method` on `$invocant` if it has a method of such name. Otherwise it returns [Nil](https://docs.perl6.org/type/Nil).

从技术上讲，不是真正的运算符；它是编译器中的句法特例。

Technically, not a real operator; it's syntax special-cased in the compiler.

<a id="%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--4"></a>
## 方法运算符 `.+` / methodop `.+`

`$foo.+meth` 遍历方法解析顺序并调用所有名为 `meth` 的方法，如果类型与 `$foo` 的类型相同，则调用名为 `meth` 的子方法。这些可能是多分派方法，在这种情况下，将调用匹配的候选者。

`$foo.+meth` walks the MRO and calls all the methods called `meth` and submethods called `meth` if the type is the same as type of `$foo`. Those methods might be multis, in which case the matching candidate would be called.

之后，返回结果的[列表](https://docs.perl6.org/type/List)。如果找不到这样的方法，它将抛出 [X::Method::NotFound](https://docs.perl6.org/type/X::Method::NotFound) 异常。

After that, a [List](https://docs.perl6.org/type/List) of the results are returned. If no such method was found, it throws a [X::Method::NotFound](https://docs.perl6.org/type/X::Method::NotFound) exception.

```Perl6
class A {
  method foo { say "from A"; }
}
class B is A {
  multi method foo { say "from B"; }
  multi method foo(Str) { say "from B (Str)"; }
}
class C is B is A {
  multi method foo { say "from C"; }
  multi method foo(Str) { say "from C (Str)"; }
}
 
say C.+foo; # OUTPUT: «from C␤from B␤from A␤(True True True)␤»
```

<a id="%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--5"></a>
## 方法运算符 `.*` / methodop `.*`

`$foo.*meth` 遍历方法解析顺序并调用所有名为 `meth` 的方法，如果类型与 `$foo` 的类型相同，则调用名为 `meth` 的子方法。这些可能是多分派方法，在这种情况下，将调用匹配的候选者。

`$foo.*meth` walks the MRO and calls all the methods called `meth` and submethods called `meth` if the type is the same as type of `$foo`. Those methods might be multis, in which case the matching candidate would be called.

之后，返回结果的[列表](https://docs.perl6.org/type/List)。如果找不到这样的方法，返回空列表。

After that, a [List](https://docs.perl6.org/type/List) of the results are returned. If no such method was found, an empty [List](https://docs.perl6.org/type/List) is returned.

技术上，后缀 `.+` 首先调用 `.*`。阅读后缀 `.+` 部分查看示例。

Technically, postfix `.+` calls `.*` at first. Read postfix `.+` section to see examples.

<a id="%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6-%C2%BB-----methodop-%C2%BB--methodop-"></a>
## 方法运算符 `».` / `>>.` - methodop `».` / methodop `>>.`

这是超级方法调用运算符。将对列表中的所有元素无序地调用方法但是有序地返回返回值列表。

This is the hyper method call operator. Will call a method on all elements of a `List` out of order and return the list of return values in order.

```Perl6
my @a = <a b c>;
my @b = @a».ord;                  # OUTPUT: «[97, 98, 99]␤»

# 方法的第一个参数是调用者
# The first parameter of a method is the invocant. 
sub foo(Str:D $c){ $c.ord * 2 };

# 所以我们可以假装有一个带子例程的方法调用，这个子例程有一个很好的第一个位置参数。
# So we can pretend to have a method call with a sub that got a good 
# first positional argument.
say @a».&foo;

# 代码块具有一个隐式位置参数，该参数落在 $_ 中。对于方法调用，后者可以省略。
# Blocks have an implicit positional arguments that lands in $_. The latter can 
# be omitted for method calls.
say @a».&{ .ord};
```

超级方法调用可能看起来与执行 [map](https://docs.perl6.org/routine/map)调用相同，但是除了向编译器提示它可以并行化调用外，该行为还受调用的[方法的节点性](https://docs.perl6.org/routine/is%20nodal)影响，取决于执行调用时使用的是 [nodemap](https://docs.perl6.org/routine/nodemap) 或 [deepmap](https://docs.perl6.org/routine/deepmap) 语义。

Hyper method calls may appear to be the same as doing a [map](https://docs.perl6.org/routine/map) call, however along with being a hint to the compiler that it can parallelize the call, the behavior is also affected by [nodality of the method](https://docs.perl6.org/routine/is%20nodal) being invoked, depending on which either [nodemap](https://docs.perl6.org/routine/nodemap) or [deepmap](https://docs.perl6.org/routine/deepmap) semantics are used to perform the call.

通过查找[可调用](https://docs.perl6.org/type/Callable)是否提供了 `nodal` 方法来检查节点性。如果超运算符应用于某个方法，则该[可调用](https://docs.perl6.org/type/Callable)是该方法的名称，在[列表](https://docs.perl6.org/type/List)类型中查找；如果超运算符应用于某个例程（例如 `».&foo`），则该例程的功能与[可调用](https://docs.perl6.org/type/Callable)相同。如果[可调用](https://docs.perl6.org/type/Callable)被确定为提供 `nodal` 方法，则使用 [nodemap](https://docs.perl6.org/routine/nodemap) 语义执行超调用，否则使用 [duckmap](https://docs.perl6.org/routine/duckmap) 语义。

The nodality is checked by looking up whether the [Callable](https://docs.perl6.org/type/Callable) provides `nodal` method. If the hyper is applied to a method, that [Callable](https://docs.perl6.org/type/Callable) is that method name, looked up on [List](https://docs.perl6.org/type/List) type; if the hyper is applied to a routine (e.g. `».&foo`), that routine functions as that [Callable](https://docs.perl6.org/type/Callable). If the [Callable](https://docs.perl6.org/type/Callable) is determined to provide `nodal` method, [nodemap](https://docs.perl6.org/routine/nodemap) semantics are used to perform the hyper call, otherwise [duckmap](https://docs.perl6.org/routine/duckmap) semantics are used.

注意避免出现预期副作用的[常见错误](https://docs.perl6.org/language/traps#Using_%C2%BB_and_map_interchangeably)。以下 `say` *不能*保证按顺序产生输出：

Take care to avoid a [common mistake](https://docs.perl6.org/language/traps#Using_%C2%BB_and_map_interchangeably) of expecting side-effects to occur in order. The following `say` is **not** guaranteed to produce the output in order:

```Perl6
@a».say;  # WRONG! Could produce a␤b␤c␤ or c␤b␤a␤ or any other order 
```

<a id="%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6-postfix--postcircumfix---methodop-postfix--postcircumfix"></a>
## 方法运算符 `.postfix` / `.postcircumfix` - methodop `.postfix` / `.postcircumfix`

In most cases, a dot may be placed before a postfix or postcircumfix:

```Perl6
my @a;
@a[1, 2, 3];
@a.[1, 2, 3]; # Same
```

This can be useful for visual clarity or brevity. For example, if an object's attribute is a function, putting a pair of parentheses after the attribute name will become part of the method call. So, either two pairs of parentheses must be used or a dot has to come before the parentheses to separate it from the method call.

```Perl6
class Operation {
    has $.symbol;
    has &.function;
}
my $addition = Operation.new(:symbol<+>, :function{ $^a + $^b });
say $addition.function()(1, 2);   # OUTPUT: «3␤» 
# OR 
say $addition.function.(1, 2);    # OUTPUT: «3␤»
```

If the postfix is an identifier, however, it will be interpreted as a normal method call.

```Perl6
1.i # No such method 'i' for invocant of type 'Int' 
```

Technically, not a real operator; it's syntax special-cased in the compiler.

<a id="methodop-"></a>
## methodop `.:`

An operator in prefix form can still be called like a method, that is, using the `.` methodop notation, by preceding it by a colon. For example:

```Perl6
my $a = 1;
say ++$a;       # OUTPUT: «2␤» 
say $a.:<++>;   # OUTPUT: «3␤»
```

Technically, not a real operator; it's syntax special-cased in the compiler, that is why it's classified as a *methodop*.

<a id="methodop--1"></a>
## methodop `.::`

A class-qualified method call, used to call a method as defined in a parent class or role, even after it has been redefined in the child class.

```Perl6
class Bar {
    method baz { 42 }
}
class Foo is Bar {
    method baz { "nope" }
}
say Foo.Bar::baz;       # OUTPUT: «42␤»
```

<a id="postfix-"></a>
## postfix `,=`

Creates an object that concatenates, in a class-dependent way, the contents of the variable on the left hand side and the expression on the right hand side:

```Perl6
my %a = :11a, :22b;
%a ,= :33x;
say %a # OUTPUT: «{a => 11, b => 22, x => 33}␤»
```

<a id="autoincrement-precedence"></a>
# Autoincrement precedence

<a id="prefix"></a>
## prefix 

```Perl6
multi sub prefix:<++>($x is rw) is assoc<non>
```

This is the . Increments its argument by one and returns the updated value.

```Perl6
my $x = 3;
say ++$x;   # OUTPUT: «4␤» 
say $x;     # OUTPUT: «4␤»
```

It works by calling the [succ](https://docs.perl6.org/routine/succ) method (for *successor*) on its argument, which gives custom types the freedom to implement their own increment semantics.

<a id="prefix-1"></a>
## prefix 

```Perl6
multi sub prefix:<-->($x is rw) is assoc<non>
```

Decrements its argument by one and returns the updated value.

```Perl6
my $x = 3;
say --$x;   # OUTPUT: «2␤» 
say $x;     # OUTPUT: «2␤»
```

It works by calling the [pred](https://docs.perl6.org/routine/pred) method (for *predecessor*) on its argument, which gives custom types the freedom to implement their own decrement semantics.

<a id="postfix"></a>
## postfix 

```Perl6
multi sub postfix:<++>($x is rw) is assoc<non>
```

Increments its argument by one and returns the original value.

```Perl6
my $x = 3;
say $x++;   # OUTPUT: «3␤» 
say $x;     # OUTPUT: «4␤»
```

It works by calling the [succ](https://docs.perl6.org/routine/succ) method (for *successor*) on its argument, which gives custom types the freedom to implement their own increment semantics.

Note that this does not necessarily return its argument; e.g., for undefined values, it returns 0:

```Perl6
my $x;
say $x++;   # OUTPUT: «0␤» 
say $x;     # OUTPUT: «1␤»
```

Increment on [Str](https://docs.perl6.org/type/Str) will increment the number part of a string and assign the resulting string to the container. A `is rw`-container is required.

```Perl6
my $filename = "somefile-001.txt";
say $filename++ for 1..3;
# OUTPUT: «somefile-001.txt␤somefile-002.txt␤somefile-003.txt␤»
```

<a id="postfix---"></a>
## postfix `--` 

```Perl6
multi sub postfix:<-->($x is rw) is assoc<non>
```

Decrements its argument by one and returns the original value.

```Perl6
my $x = 3;
say $x--;   # OUTPUT: «3␤» 
say $x;     # OUTPUT: «2␤»
```

It works by calling the [pred](https://docs.perl6.org/routine/pred) method (for *predecessor*) on its argument, which gives custom types the freedom to implement their own decrement semantics.

Note that this does not necessarily return its argument;e.g., for undefined values, it returns 0:

```Perl6
my $x;
say $x--;   # OUTPUT: «0␤» 
say $x;     # OUTPUT: «-1␤»
```

Decrement on [Str](https://docs.perl6.org/type/Str) will decrement the number part of a string and assign the resulting string to the container. A `is rw`-container is required. Crossing 0 is prohibited and throws `X::AdHoc`.

```Perl6
my $filename = "somefile-003.txt";
say $filename-- for 1..3;
# OUTPUT: «somefile-003.txt␤somefile-002.txt␤somefile-001.txt␤»
```

<a id="exponentiation-precedence"></a>
# Exponentiation precedence

<a id="infix-"></a>
## infix `**`

```Perl6
multi sub infix:<**>(Any, Any --> Numeric:D) is assoc<right>
```

The exponentiation operator coerces both arguments to [Numeric](https://docs.perl6.org/type/Numeric) and calculates the left-hand-side raised to the power of the right-hand side.

If the right-hand side is a non-negative integer and the left-hand side is an arbitrary precision type ([Int](https://docs.perl6.org/type/Int), [FatRat](https://docs.perl6.org/type/FatRat)), then the calculation is carried out without loss of precision.

Unicode superscripts will behave in exactly the same way.

```Perl6
sub squared( Int $num ) { $num² };
say squared($_) for ^5; OUTPUT: «0␤1␤4␤9␤16␤»
```

It also works for sequences of several Unicode superscript numbers:

```Perl6
sub twenty-second-power( Int $num ) { $num²² };
say twenty-second-power($_) for ^5; # OUTPUT: «0␤1␤4194304␤31381059609␤17592186044416␤»
```

<a id="symbolic-unary-precedence"></a>
# Symbolic unary precedence

<a id="prefix-"></a>
## prefix `?`

```Perl6
multi sub prefix:<?>(Mu --> Bool:D)
```

Boolean context operator.

Coerces the argument to [Bool](https://docs.perl6.org/type/Bool) by calling the `Bool` method on it. Note that this collapses [Junction](https://docs.perl6.org/type/Junction)s.

<a id="prefix--1"></a>
## prefix `!`

```Perl6
multi sub prefix:<!>(Mu --> Bool:D)
```

Negated boolean context operator.

Coerces the argument to [Bool](https://docs.perl6.org/type/Bool) by calling the `Bool` method on it, and returns the negation of the result. Note that this collapses [Junction](https://docs.perl6.org/type/Junction)s.

<a id="prefix--2"></a>
## prefix `+`

```Perl6
multi sub prefix:<+>(Any --> Numeric:D)
```

Numeric context operator.

Coerces the argument to [Numeric](https://docs.perl6.org/type/Numeric) by calling the `Numeric` method on it.

<a id="prefix--"></a>
## prefix `-`

```Perl6
multi sub prefix:<->(Any --> Numeric:D)
```

Negative numeric context operator.

Coerces the argument to [Numeric](https://docs.perl6.org/type/Numeric) by calling the `Numeric` method on it, and then negates the result.

<a id="prefix-%7E"></a>
## prefix `~`

```Perl6
multi sub prefix:<~>(Any --> Str:D)
```

String context operator.

Coerces the argument to [Str](https://docs.perl6.org/type/Str) by calling the [Str](https://docs.perl6.org/type/List#method_Str) method on it.

<a id="prefix-%7C"></a>
## prefix `|`

Flattens objects of type [Capture](https://docs.perl6.org/type/Capture), [Pair](https://docs.perl6.org/type/Pair), [List](https://docs.perl6.org/type/List), [Map](https://docs.perl6.org/type/Map) and [Hash](https://docs.perl6.org/type/Hash) into an argument list.

```Perl6
sub slurpee( |args ){
    say args.perl
};
slurpee( <a b c d>, { e => 3 }, 'e' => 'f' => 33 )
# OUTPUT: «\(("a", "b", "c", "d"), {:e(3)}, :e(:f(33)))␤»
```

Please see the [`Signature` page, specially the section on Captures](https://docs.perl6.org/type/Signature#Capture_parameters) for more information on the subject.

Outside of argument lists, it returns a [Slip](https://docs.perl6.org/type/Slip), which makes it flatten into the outer list. Inside [argument list](https://docs.perl6.org/language/list#Argument_list_(Capture)_context) [`Positional`s](https://docs.perl6.org/type/Positional) are turned into positional arguments and [`Associative`s](https://docs.perl6.org/type/Associative) are turned into named arguments.

<a id="prefix-%5E"></a>
## prefix `+^`

```Perl6
multi sub prefix:<+^>(Any --> Int:D)
```

Integer bitwise negation operator: Coerces the argument to [Int](https://docs.perl6.org/type/Int) and does a bitwise negation on the result, assuming [two's complement](https://en.wikipedia.org/wiki/Two%27s_complement).

<a id="prefix-%7E%5E"></a>
## prefix `~^`

Coerces the argument to a non-variable-encoding string buffer type (e.g. `buf8`, `buf16`, `buf32`) and then flips each bit in that buffer.

Please note that this has not yet been implemented.

<a id="prefix-%5E-1"></a>
## prefix `?^`

```Perl6
multi sub prefix:<?^>(Mu --> Bool:D)
```

Boolean bitwise negation operator: Coerces the argument to [Bool](https://docs.perl6.org/type/Bool) and then does a bit flip, which makes it the same as `prefix:<!> `.

<a id="prefix-%5E-2"></a>
## prefix `^`

```Perl6
multi sub prefix:<^>(Any --> Range:D)
```

*upto* operator.

Coerces the argument to [Numeric](https://docs.perl6.org/type/Numeric), and generates a range from 0 up to (but excluding) the argument.

```Perl6
say ^5;         # OUTPUT: «0..^5␤» 
for ^5 { }      # 5 iterations
```

<a id="dotty-infix-precedence"></a>
# Dotty infix precedence

These operators are like their Method Postfix counterparts, but require surrounding whitespace (before and/or after) to distinguish them.

<a id="infix--1"></a>
## infix `.=`

Calls the right-side method on the value in the left-side container, replacing the resulting value in the left-side container.

In most cases, this behaves identically to the postfix mutator, but the precedence is lower:

```Perl6
my $a = -5;
say ++$a.=abs;
# OUTPUT: «6␤» 
say ++$a .= abs;
# OUTPUT: «Cannot modify an immutable Int␤ 
#           in block <unit> at <tmp> line 1␤␤» 
```

<a id="infix--2"></a>
## infix `.`

Calls the following method (whose name must be alphabetic) on the left-side invocant.

Note that the infix form of the operator has a slightly lower precedence than postfix `.meth`.

```Perl6
say -5.abs;      # like: -(5.abs) 
# OUTPUT: «-5␤» 
say -5 . abs;    # like: (-5) . abs 
# OUTPUT: «5␤» 
say -5 .abs;     # following whitespace is optional 
# OUTPUT: «5␤»
```

<a id="multiplicative-precedence"></a>
# Multiplicative precedence

<a id="infix--3"></a>
## infix `*`

```Perl6
multi sub infix:<*>(Any, Any --> Numeric:D)
```

Multiplication operator.

Coerces both arguments to [Numeric](https://docs.perl6.org/type/Numeric) and multiplies them. The result is of the wider type. See [Numeric](https://docs.perl6.org/type/Numeric) for details.

<a id="infix--4"></a>
## infix `/`

```Perl6
multi sub infix:</>(Any, Any --> Numeric:D)
```

Division operator.

Coerces both argument to [Numeric](https://docs.perl6.org/type/Numeric) and divides the left through the right number. Division of [Int](https://docs.perl6.org/type/Int) values returns [Rat](https://docs.perl6.org/type/Rat), otherwise the "wider type" rule described in [Numeric](https://docs.perl6.org/type/Numeric) holds.

<a id="infix-div"></a>
## infix `div`

```Perl6
multi sub infix:<div>(Int:D, Int:D --> Int:D)
```

Integer division operator. Rounds down.

<a id="infix-%25"></a>
## infix `%`

```Perl6
multi sub infix:<%>($x, $y --> Numeric:D)
```

Modulo operator. Coerces to [Numeric](https://docs.perl6.org/type/Numeric) first.

Generally the following identity holds:

```Perl6
my ($x, $y) = 1,2;
$x % $y == $x - floor($x / $y) * $y
```

<a id="infix-%25%25"></a>
## infix `%%`

```Perl6
multi sub infix:<%%>($a, $b --> Bool:D)
```

Divisibility operator. Returns `True` if `$a % $b == 0`.

<a id="infix-mod"></a>
## infix `mod`

```Perl6
multi sub infix:<mod>(Int:D $a, Int:D $b --> Int:D)
```

Integer modulo operator. Returns the remainder of an integer modulo operation.

<a id="infix--5"></a>
## infix `+&`

```Perl6
multi sub infix:<+&>($a, $b --> Int:D)
```

Numeric bitwise *AND* operator. Coerces both arguments to [Int](https://docs.perl6.org/type/Int) and does a bitwise *AND* operation assuming two's complement.

<a id="infix--6"></a>
## infix `+<`

```Perl6
multi sub infix:<< +< >>($a, $b --> Int:D)
```

Integer bit shift to the left.

<a id="infix--7"></a>
## infix `+>`

```Perl6
multi sub infix:<< +> >>($a, $b --> Int:D)
```

Integer bit shift to the right.

<a id="infix-%7E"></a>
## infix `~&`

Coerces each argument to a non-variable-encoding string buffer type (e.g. `buf8`, `buf16`, `buf32`) and then performs a numeric bitwise AND on corresponding integers of the two buffers, padding the shorter buffer with zeroes.

<a id="infix-%7E-1"></a>
## infix `~<`

Coerces the left argument to a non-variable-encoding string buffer type (e.g. `buf8`, `buf16`, `buf32`) and then performs a numeric bitwise left shift on the bits of the buffer.

Please note that this has not yet been implemented.

<a id="infix-%7E-2"></a>
## infix `~>`

Coerces the left argument to a non-variable-encoding string buffer type (e.g. `buf8`, `buf16`, `buf32`) and then performs a numeric bitwise right shift on the bits of the buffer.

Please note that this has not yet been implemented.

<a id="infix-gcd"></a>
## infix `gcd`

```Perl6
multi sub infix:<gcd>($a, $b --> Int:D)
```

Coerces both arguments to [Int](https://docs.perl6.org/type/Int) and returns the greatest common divisor. If one of its arguments is 0, the other is returned (when both arguments are 0, the operator returns 0).

<a id="infix-lcm"></a>
## infix `lcm`

```Perl6
multi sub infix:<lcm>($a, $b --> Int:D)
```

Coerces both arguments to [Int](https://docs.perl6.org/type/Int) and returns the least common multiple; that is, the smallest integer that is evenly divisible by both arguments.

<a id="additive-precedence"></a>
# Additive precedence

<a id="infix--8"></a>
## infix `+`

```Perl6
multi sub infix:<+>($a, $b --> Numeric:D)
```

Addition operator.

Coerces both arguments to [Numeric](https://docs.perl6.org/type/Numeric) and adds them.

<a id="infix--"></a>
## infix `-`

```Perl6
multi sub infix:<->($a, $b --> Numeric:D)
```

Subtraction operator.

Coerces both arguments to [Numeric](https://docs.perl6.org/type/Numeric) and subtracts the second from the first.

<a id="infix-%7C"></a>
## infix `+|`

```Perl6
multi sub infix:<+|>($a, $b --> Int:D)
```

Integer bitwise OR operator: Coerces both arguments to [Int](https://docs.perl6.org/type/Int) and does a bitwise *OR* (inclusive OR) operation.

<a id="infix-%5E"></a>
## infix `+^`

```Perl6
multi sub infix:<+^>($a, $b --> Int:D)
```

Integer bitwise XOR operator: Coerces both arguments to [Int](https://docs.perl6.org/type/Int) and does a bitwise *XOR* (exclusive OR) operation.

<a id="infix-%7E%7C"></a>
## infix `~|`

Coerces each argument to a non-variable-encoding string buffer type (e.g. `buf8`, `buf16`, `buf32`) and then performs a numeric bitwise OR on corresponding integers of the two buffers, padding the shorter buffer with zeroes.

<a id="infix-%7E%5E"></a>
## infix `~^`

Coerces each argument to a non-variable-encoding string buffer type (e.g. `buf8`, `buf16`, `buf32`) and then performs a numeric bitwise XOR on corresponding integers of the two buffers, padding the shorter buffer with zeroes.

<a id="infix-%5E-1"></a>
## infix `?^`

```Perl6
multi sub infix:<?^>(Mu $x = Bool::False)
multi sub infix:<?^>(Mu \a, Mu \b)
```

Boolean bitwise XOR operator: Coerces the argument(s) to [Bool](https://docs.perl6.org/type/Bool) and performs logical XOR on them: it will return True if and only if just one of the argument is true. It returns identity on a single argument.

<a id="infix-%7C-1"></a>
## infix `?|`

```Perl6
multi sub infix:<?|>($a, $b --> Bool:D)
```

Boolean logical OR operator.

Coerces both arguments to [Bool](https://docs.perl6.org/type/Bool) and does a logical *OR* (inclusive OR) operation.

<a id="replication-precedence"></a>
# Replication precedence

<a id="infix-x"></a>
## infix `x`

```Perl6
sub infix:<x>($a, $b --> Str:D)
```

String repetition operator.

Repeats the string `$a` `$b` times, if necessary coercing `$a` to [`Str`](https://docs.perl6.org/type/Str) and `$b` [`Int`](https://docs.perl6.org/type/Int). Returns an empty string if `$b <= 0 `. An exception `X::Numeric::CannotConvert` will be thrown if `$b` is `-Inf` or `NaN`.

```Perl6
say 'ab' x 3;           # OUTPUT: «ababab␤» 
say 42 x 3;             # OUTPUT: «424242␤» 
 
my $a = 'a'.IO;
my $b = 3.5;
say $a x $b;            # OUTPUT: «aaa␤»
```

List repetition operator

<a id="infix-xx"></a>
## infix `xx`

Defined as:

```Perl6
multi sub infix:<xx>()
multi sub infix:<xx>(Mu \x)
multi sub infix:<xx>(&x, Num:D() $n)
multi sub infix:<xx>(&x, Whatever)
multi sub infix:<xx>(&x, Bool:D $b)
multi sub infix:<xx>(&x, Int:D $n)
multi sub infix:<xx>(Mu \x, Num:D() $n)
multi sub infix:<xx>(Mu \x, Whatever)
multi sub infix:<xx>(Mu \x, Bool:D $b)
multi sub infix:<xx>(Mu \x, Int:D $n)
```

In general, it returns a Sequence of `$a` repeated and evaluated `$b` times (`$b` is coerced to [Int](https://docs.perl6.org/type/Int)). If `$b <= 0 `, the empty list is returned. It will return an error with no operand, and return the operand itself with a single operand. An exception `X::Numeric::CannotConvert` will be thrown if `$b` is `-Inf` or `NaN`.

The left-hand side is evaluated for each repetition, so

```Perl6
say [1, 2] xx 5;
# OUTPUT: «([1 2] [1 2] [1 2] [1 2] [1 2])␤»
```

returns five distinct arrays (but with the same content each time), and

```Perl6
rand xx 3
```

returns three pseudo random numbers that are determined independently.

The right-hand side can be `*`, in which case a lazy, infinite list is returned. If it's a `Bool`, a `Seq` with a single element is returned if it's `True`.

<a id="concatenation"></a>
# Concatenation

Same as the rest of the infix operators, these can be combined with metaoperators such as [assignment](https://docs.perl6.org/language/operators#Assignment_operators), for instance.

<a id="infix-%7E-3"></a>
## infix `~`

```Perl6
multi sub infix:<~>(Any,   Any)
multi sub infix:<~>(Str:D, Str:D)
multi sub infix:<~>(Buf:D, Buf:D)
```

This is the string concatenation operator, which coerces both arguments to [Str](https://docs.perl6.org/type/Str) and concatenates them. If both arguments are [Buf](https://docs.perl6.org/type/Buf), a combined buffer is returned.

```Perl6
say 'ab' ~ 'c';     # OUTPUT: «abc␤»
```

<a id="infix-%E2%88%98"></a>
## infix `∘`

```Perl6
multi sub infix:<∘>()
multi sub infix:<∘>(&f)
multi sub infix:<∘>(&f, &g --> Block:D)
```

The function composition operator `infix:<∘>` or `infix:<o>` combines two functions, so that the left function is called with the return value of the right function. If the [`.count`](https://docs.perl6.org/routine/count) of the left function is greater than 1, the return value of the right function will be [slipped](https://docs.perl6.org/type/Slip) into the left function.

Both `.count` and `.arity` of the right-hand side will be maintained.

```Perl6
sub f($p){ say 'f'; $p / 2 }
sub g($p){ say 'g'; $p * 2 }
 
my &composed = &f ∘ &g;
say composed 2; # OUTPUT: «g␤f␤2␤» 
# equivalent to: 
say 2.&g.&f;
# or to: 
say f g 2;
sub f($a, $b, $c) { [~] $c, $b, $a }
sub g($str){ $str.comb }
my &composed = &f ∘ &g;
say composed 'abc'; # OUTPUT: «cba␤» 
# equivalent to: 
say f |g 'abc';
```

The single-arg candidate returns the given argument as is. The zero-arg candidate returns an identity routine that simply returns its argument.

```Perl6
my &composed = [∘] &uc;
say composed 'foo'; # OUTPUT: «FOO␤» 
 
my &composed = [∘];
say composed 'foo'; # OUTPUT: «foo␤»
```

<a id="junctive-and-all-precedence"></a>
# Junctive AND (all) precedence

<a id="infix--9"></a>
## infix `&`

```Perl6
multi sub infix:<&>($a, $b --> Junction:D) is assoc<list>
```

All junction operator.

Creates an *all* [Junction](https://docs.perl6.org/type/Junction) from its arguments. See [Junction](https://docs.perl6.org/type/Junction) for more details.

<a id="infix--infix-%E2%88%A9"></a>
## infix `(&)`, infix `∩`

```Perl6
multi sub infix:<(&)>(**@p)
multi sub infix:<∩>(**@p)
```

Intersection operator.

Returns the **intersection** of all of its arguments. This creates a new [Set](https://docs.perl6.org/type/Set) that contains only the elements common to all of the arguments if none of the arguments are a [Bag](https://docs.perl6.org/type/Bag), [BagHash](https://docs.perl6.org/type/BagHash), [Mix](https://docs.perl6.org/type/Mix) or [MixHash](https://docs.perl6.org/type/MixHash).

```Perl6
say <a b c> (&) <b c d>; # OUTPUT: «set(b c)␤» 
<a b c d> ∩ <b c d e> ∩ <c d e f>; # OUTPUT: «set(c d)␤» 
```

If any of the arguments are [Baggy](https://docs.perl6.org/type/Baggy) or [Mixy](https://docs.perl6.org/type/Mixy)>, the result is a new `Bag` (or `Mix`) containing the common elements, each weighted by the largest *common* weight (which is the minimum of the weights of that element over all arguments).

```Perl6
say <a a b c a> (&) bag(<a a b c c>); # OUTPUT: «Bag(a(2), b, c)␤» 
```

`∩` is equivalent to `(&)`, at codepoint U+2229 (INTERSECTION).

<a id="infix--infix-%E2%8A%8D"></a>
## infix `(.)`, infix `⊍`

```Perl6
multi sub infix:<(.)>(**@p)
multi sub infix:<⊍>(**@p)
```

Baggy multiplication operator.

Returns the Baggy **multiplication** of its arguments, i.e., a [Bag](https://docs.perl6.org/type/Bag) that contains each element of the arguments with the weights of the element across the arguments multiplied together to get the new weight. Returns a [Mix](https://docs.perl6.org/type/Mix) if any of the arguments is a [Mixy](https://docs.perl6.org/type/Mixy).

```Perl6
say <a b c> (.) <a b c d>; # OUTPUT: «Bag(a, b, c)␤» 
                           # Since 1 * 0 == 0, in the case of 'd' 
say <a a b c a d> ⊍ bag(<a a b c c>); # OUTPUT: «Bag(a(6), b, c(2))␤» 
```

`⊍` is equivalent to `(.)`, at codepoint U+228D (MULTISET MULTIPLICATION).

<a id="junctive-or-any-precedence"></a>
# Junctive OR (any) precedence

<a id="infix-%7C-2"></a>
## infix `|`

```Perl6
multi sub infix:<|>($a, $b --> Junction:D) is assoc<list>
```

Creates an *any* [Junction](https://docs.perl6.org/type/Junction) from its arguments.

```Perl6
my $three-letters = /<[a b c]>/ | /<[i j k]>/ | /<[x y z]>/;
say $three-letters.perl; # OUTPUT: «any(/<[a b c]>/, /<[i j k]>/, /<[x y z]>/)␤» 
say 'b' ~~ $three-letters; # OUTPUT: «True␤»
```

This first creates an `any` `Junction` of three regular expressions (every one of them matching any of 3 letters), and then uses smartmatching to check whether the letter `b` matches any of them, resulting in a positive match. See also [Junction](https://docs.perl6.org/type/Junction) for more details.

<a id="infix-%7C-infix-%E2%88%AA"></a>
## infix `(|)`, infix `∪`

```Perl6
multi sub infix:<(|)>(**@p)
multi sub infix:<∪>(**@p)
```

Union operator.

Returns the **union** of all of its arguments. This creates a new [Set](https://docs.perl6.org/type/Set) that contains all the elements its arguments contain if none of the arguments are a [Bag](https://docs.perl6.org/type/Bag), [BagHash](https://docs.perl6.org/type/BagHash), [Mix](https://docs.perl6.org/type/Mix) or [MixHash](https://docs.perl6.org/type/MixHash).

```Perl6
say <a b d> ∪ bag(<a a b c>); # OUTPUT: «Bag(a(2), b, c, d)␤» 
```

If any of the arguments are [Baggy](https://docs.perl6.org/type/Baggy) or [Mixy](https://docs.perl6.org/type/Mixy)>, the result is a new `Bag` (or `Mix`) containing all the elements, each weighted by the *highest* weight that appeared for that element.

```Perl6
say <a b d> ∪ bag(<a a b c>); # OUTPUT: «Bag(a(2), b, c, d)␤» 
```

`∪` is equivalent to `(|)`, at codepoint U+222A (UNION).

<a id="infix--infix-%E2%8A%8E"></a>
## infix `(+)`, infix `⊎`

```Perl6
multi sub infix:<(+)>(**@p)
multi sub infix:<⊎>(**@p)
```

Baggy addition operator.

Returns the Baggy **addition** of its arguments. This creates a new [Bag](https://docs.perl6.org/type/Bag) from each element of the arguments with the weights of the element added together to get the new weight, if none of the arguments are a [Mix](https://docs.perl6.org/type/Mix) or [MixHash](https://docs.perl6.org/type/MixHash).

```Perl6
say <a a b c a d> (+) <a a b c c>; # OUTPUT: «Bag(a(5), b(2), c(3), d)␤» 
```

If any of the arguments is a [Mixy](https://docs.perl6.org/type/Mixy), the result is a new `Mix`.

```Perl6
say <a b c> (+) (a => 2.5, b => 3.14).Mix; # OUTPUT: «Mix(a(3.5), b(4.14), c)␤» 
```

`⊎` is equivalent to `(+)`, at codepoint U+228E (MULTISET UNION).

<a id="infix---infix-%E2%88%96"></a>
## infix `(-)`, infix `∖`

```Perl6
multi sub infix:<(-)>(**@p)
multi sub infix:<∖>(**@p)
```

Set difference operator.

Returns the **set difference** of all its arguments. This creates a new [Set](https://docs.perl6.org/type/Set) that contains all the elements the first argument has but the rest of the arguments don't, i.e., of all the elements of the first argument, minus the elements from the other arguments. But only if none of the arguments are a [Bag](https://docs.perl6.org/type/Bag), [BagHash](https://docs.perl6.org/type/BagHash), [Mix](https://docs.perl6.org/type/Mix) or [MixHash](https://docs.perl6.org/type/MixHash).

```Perl6
say <a a b c a d> (-) <a a b c c>; # OUTPUT: «set(d)␤» 
say <a b c d e> (-) <a b c> (-) <a b d>; # OUTPUT: «set(e)␤» 
```

If any of the arguments are [Baggy](https://docs.perl6.org/type/Baggy) or [Mixy](https://docs.perl6.org/type/Mixy)>, the result is a new `Bag` (or `Mix`) containing all the elements remaining after the first argument with its weight subtracted by the weight of that element in each of the other arguments.

```Perl6
say <a a b c a d> (-) bag(<a b c c>); # OUTPUT: «Bag(a(2), d)␤» 
say <a a b c a d>  ∖  mix(<a b c c>); # OUTPUT: «Mix(a(2), c(-1), d)␤» 
```

`∖` is equivalent to `(-)`, at codepoint U+2216 (SET MINUS).

<a id="infix-%5E-2"></a>
## infix `^`

```Perl6
multi sub infix:<^>($a, $b --> Junction:D) is assoc<list>
```

One junction operator.

Creates a *one* [Junction](https://docs.perl6.org/type/Junction) from its arguments. See [Junction](https://docs.perl6.org/type/Junction) for more details.

<a id="infix-%5E-infix-%E2%8A%96"></a>
## infix `(^)`, infix `⊖`

```Perl6
multi sub infix:<(^)>($a, $b)
multi sub infix:<⊖>($a,$b)
 
multi sub infix:<(^)>(**@p)
multi sub infix:<⊖>(**@p)
```

Symmetric set difference operator.

Returns the **symmetric set difference** of all its arguments. This creates a new [Set](https://docs.perl6.org/type/Set) made up of all the elements that `$a` has but `$b` doesn't and all the elements `$b` has but `$a` doesn't if none of the arguments are a [Bag](https://docs.perl6.org/type/Bag), [BagHash](https://docs.perl6.org/type/BagHash), [Mix](https://docs.perl6.org/type/Mix) or [MixHash](https://docs.perl6.org/type/MixHash). Equivalent to `($a ∖ $b) ∪ ($b ∖ $a)`.

```Perl6
say <a b> (^) <b c>; # OUTPUT: «set(a c)␤» 
```

If any of the arguments are [Baggy](https://docs.perl6.org/type/Baggy) or [Mixy](https://docs.perl6.org/type/Mixy)>, the result is a new `Bag` (or `Mix`).

```Perl6
say <a b> ⊖ bag(<b c>); # OUTPUT: «Bag(a, c)␤» 
```

`⊖` is equivalent to `(^)`, at codepoint U+2296 (CIRCLED MINUS).

<a id="named-unary-precedence"></a>
# Named unary precedence

<a id="prefix-temp"></a>
## prefix `temp`

```Perl6
sub prefix:<temp>(Mu $a is rw)
```

"temporizes" the variable passed as the argument. The variable begins with the same value as it had in the outer scope, but can be assigned new values in this scope. Upon exiting the scope, the variable will be restored to its original value.

```Perl6
my $a = "three";
say $a; # OUTPUT: «three␤» 
{
    temp $a;
    say $a; # OUTPUT: «three␤» 
    $a = "four";
    say $a; # OUTPUT: «four␤» 
}
say $a; # OUTPUT: «three␤»
```

You can also assign immediately as part of the call to temp:

```Perl6
temp $a = "five";
```

Be warned the `temp` effects get removed once the block is left. If you were to access the value from, say, within a [Promise](https://docs.perl6.org/type/Promise) after the `temp` was undone, you'd get the original value, not the `temp` one:

```Perl6
my $v = "original";
{
    temp $v = "new one";
    start {
        say "[PROMISE] Value before block is left: `$v`";
        sleep 1;
        say "[PROMISE] Block was left while we slept; value is now `$v`";
    }
    sleep ½;
    say "About to leave the block; value is `$v`";
}
say "Left the block; value is now `$v`";
sleep 2;
 
# OUTPUT: 
# PROMISE
# About to leave the block; value is `new one` 
# Left the block; value is now `original` 
# PROMISE
```

<a id="prefix-let"></a>
## prefix `let`

```Perl6
sub prefix:<let>(Mu $a is rw)
```

Refers to a variable in an outer scope whose value will be restored if the block exits unsuccessfully, implying that the block returned a defined object.

```Perl6
my $name = "Jane Doe";
 
{
    let $name = prompt("Say your name ");
    die if !$name;
    CATCH {
        default { say "No name entered" }
    }
    say "We have $name";
}
 
say "We got $name";
```

This code provides a default name for `$name`. If the user exits from the prompt or simply does not provide a valid input for `$name`; `let` will restore the default value provided at the top. If user input is valid, it will keep that.

<a id="nonchaining-binary-precedence"></a>
# Nonchaining binary precedence

<a id="infix-does"></a>
## infix `does`

```Perl6
sub infix:<does>(Mu $obj, Mu $role) is assoc<non>
```

Mixes `$role` into `$obj` at runtime. Requires `$obj` to be mutable.

Similar to [but](https://docs.perl6.org/routine/but) operator, the `$role` can instead be an instantiated object, in which case, the operator will create a role for you automatically. The role will contain a single method named the same as `$obj.^name` and that returns `$obj`:

```Perl6
my $o = class { method Str { "original" } }.new;
put $o;            # OUTPUT: «original␤» 
$o does "modded";
put $o;            # OUTPUT: «modded␤»
```

If methods of the same name are present already, the last mixed in role takes precedence.

<a id="infix-but"></a>
## infix `but`

```Perl6
multi sub infix:<but>(Mu $obj1, Mu   $role) is assoc<non>
multi sub infix:<but>(Mu $obj1, Mu:D $obj2) is assoc<non>
```

Creates a copy of `$obj` with `$role` mixed in. Since `$obj` is not modified, `but` can be used to created immutable values with mixins.

Instead of a role, you can provide an instantiated object. In this case, the operator will create a role for you automatically. The role will contain a single method named the same as `$obj.^name` and that returns `$obj`:

```Perl6
my $forty-two = 42 but 'forty two';
say $forty-two+33;    # OUTPUT: «75␤» 
say $forty-two.^name; # OUTPUT: «Int+{<anon|1>}␤» 
say $forty-two.Str;   # OUTPUT: «forty two␤» 
```

Calling `^name` shows that the variable is an `Int` with an anonymous object mixed in. However, that object is of type `Str`, so the variable, through the mixin, is endowed with a method with that name, which is what we use in the last sentence.

We can also mixin classes, even created on the fly.

```Perl6
my $s = 12 but class Warbles { method hi { 'hello' } }.new;
say $s.Warbles.hi;    # OUTPUT: «hello␤» 
say $s + 42;          # OUTPUT: «54␤» 
```

To access the mixed-in class, as above, we use the class name as is shown in the second sentence. If methods of the same name are present already, the last mixed in role takes precedence. A list of methods can be provided in parentheses separated by comma. In this case conflicts will be reported at runtime.

<a id="infix-cmp"></a>
## infix `cmp`

```Perl6
multi sub infix:<cmp>(Any,       Any)
multi sub infix:<cmp>(Real:D,    Real:D)
multi sub infix:<cmp>(Str:D,     Str:D)
multi sub infix:<cmp>(Version:D, Version:D)
```

Generic, "smart" three-way comparator.

Compares strings with string semantics, numbers with number semantics, [Pair](https://docs.perl6.org/type/Pair) objects first by key and then by value etc.

if `$a eqv $b`, then `$a cmp $b` always returns `Order::Same`.

```Perl6
say (a => 3) cmp (a => 4);   # OUTPUT: «Less␤» 
say 4        cmp 4.0;        # OUTPUT: «Same␤» 
say 'b'      cmp 'a';        # OUTPUT: «More␤»
```

<a id="infix-coll"></a>
## infix `coll`

Defined as:

```Perl6
multi sub infix:<coll>(Str:D \a, Str:D \b --> Order:D)
multi sub infix:<coll>(Cool:D \a, Cool:D \b --> Order:D)
multi sub infix:<coll>(Pair:D \a, Pair:D \b --> Order:D)
```

`coll` is a sorting operator that takes pairs of `Str`s, `Cool`s or `Pair`s and returns an `Order` that uses the `$*COLLATION` order. The default behavior disregards diacritic marks and capitalization, for instance.

```Perl6
say "b" cmp "à";  # OUTPUT: «Less␤» 
say "b" coll "à"; # OUTPUT: «More␤»
```

In the first case, lexicographic or codepoint order is taken into account. In the second, which uses `coll`, the diacritic is not considered and sorting happens according to intuitive order.

**NOTE:** These are not yet implemented in the JVM.

<a id="infix-unicmp"></a>
## infix `unicmp`

Defined as:

```Perl6
multi sub infix:<unicmp>(Str:D \a, Str:D \b --> Order:D)
multi sub infix:<unicmp>(Pair:D \a, Pair:D \b --> Order:D)
multi sub infix:<coll>(Pair:D \a, Pair:D \b --> Order:D)
```

Unlike the cmp operator which sorts according to codepoint, `unicmp` and `coll` sort according to how most users would expect, that is, disregarding aspects of the particular character like capitalization.

```Perl6
say 'a' unicmp 'Z'; # Less 
say 'a' coll 'Z';   # Less 
say 'a' cmp 'Z';    # More
```

The main difference between `coll` and `unicmp` is that the behavior of the former can be changed by the [`$*COLLATION`](https://docs.perl6.org/type/Any#index-entry-%24*COLLATION-%24*COLLATION) dynamic variable.

**NOTE:** These are not yet implemented in the JVM.

<a id="infix-leg"></a>
## infix `leg`

```Perl6
multi sub infix:<leg>(Any,   Any)
multi sub infix:<leg>(Str:D, Str:D)
```

String three-way comparator. Short for *less, equal or greater?*.

Coerces both arguments to [Str](https://docs.perl6.org/type/Str) and then does a lexicographic comparison.

```Perl6
say 'a' leg 'b';       # OUTPUT: «Less␤» 
say 'a' leg 'a';       # OUTPUT: «Same␤» 
say 'b' leg 'a';       # OUTPUT: «More␤»
```

<a id="infix--10"></a>
## infix `<=>`

```Perl6
multi sub infix:«<=>»($a, $b --> Order:D) is assoc<non>
```

Numeric three-way comparator.

Coerces both arguments to [Real](https://docs.perl6.org/type/Real) and then does a numeric comparison.

<a id="infix--11"></a>
## infix `..`

```Perl6
multi sub infix:<..>($a, $b --> Range:D) is assoc<non>
```

Range operator

Constructs a [Range](https://docs.perl6.org/type/Range) from the arguments.

<a id="infix-%5E-3"></a>
## infix `..^`

```Perl6
multi sub infix:<..^>($a, $b --> Range:D) is assoc<non>
```

Right-open range operator.

Constructs a [Range](https://docs.perl6.org/type/Range) from the arguments, excluding the end point.

<a id="infix-%5E-4"></a>
## infix `^..`

```Perl6
multi sub infix:<^..>($a, $b --> Range:D) is assoc<non>
```

Left-open range operator.

Constructs a [Range](https://docs.perl6.org/type/Range) from the arguments, excluding the start point.

<a id="infix-%5E%5E"></a>
## infix `^..^`

```Perl6
multi sub infix:<^..^>($a, $b --> Range:D) is assoc<non>
```

Open range operator

Constructs a [Range](https://docs.perl6.org/type/Range) from the arguments, excluding both start and end point.

<a id="chaining-binary-precedence"></a>
# Chaining binary precedence

<a id="infix--12"></a>
## infix `==`

```Perl6
multi sub infix:<==>(Any, Any)
multi sub infix:<==>(Int:D, Int:D)
multi sub infix:<==>(Num:D, Num:D)
multi sub infix:<==>(Rational:D, Rational:D)
multi sub infix:<==>(Real:D, Real:D)
multi sub infix:<==>(Complex:D, Complex:D)
multi sub infix:<==>(Numeric:D, Numeric:D)
```

Numeric equality operator.

Coerces both arguments to [Numeric](https://docs.perl6.org/type/Numeric) (if necessary); returns `True` if they are equal.

<a id="infix--13"></a>
## infix `!=`

```Perl6
sub infix:<!=>(Mu, Mu --> Bool:D)
```

Numeric inequality operator.

Coerces both arguments to [Numeric](https://docs.perl6.org/type/Numeric) (if necessary); returns `True` if they are distinct.

Is an alias to `!==`.

<a id="infix-%E2%89%A0"></a>
## infix `≠`

Numeric inequality operator.

Equivalent to [!=](https://docs.perl6.org/routine/!=), at codepoint U+2260 (NOT EQUAL TO).

<a id="infix--14"></a>
## infix `<`

```Perl6
multi sub infix:«<»(Int:D, Int:D)
multi sub infix:«<»(Num:D, Num:D)
multi sub infix:«<»(Real:D, Real:D)
```

Numeric less than operator.

Coerces both arguments to [Real](https://docs.perl6.org/type/Real) (if necessary); returns `True` if the first argument is smaller than the second.

<a id="infix--15"></a>
## infix `<=`

```Perl6
multi sub infix:«<=»(Int:D, Int:D)
multi sub infix:«<=»(Num:D, Num:D)
multi sub infix:«<=»(Real:D, Real:D)
```

Numeric less than or equal to operator.

Coerces both arguments to [Real](https://docs.perl6.org/type/Real) (if necessary); returns `True` if the first argument is smaller than or equal to the second.

<a id="infix-%E2%89%A4"></a>
## infix `≤`

Numeric less than or equal to operator.

Equivalent to [<=](https://docs.perl6.org/language/routine/%3C=), at codepoint U+2264 (LESS-THAN OR EQUAL TO).

<a id="infix--16"></a>
## infix `>`

```Perl6
multi sub infix:«>»(Int:D, Int:D)
multi sub infix:«>»(Num:D, Num:D)
multi sub infix:«>»(Real:D, Real:D)
```

Numeric greater than operator.

Coerces both arguments to [Real](https://docs.perl6.org/type/Real) (if necessary); returns `True` if the first argument is larger than the second.

<a id="infix--17"></a>
## infix `>=`

```Perl6
multi sub infix:«>=»(Int:D, Int:D)
multi sub infix:«>=»(Num:D, Num:D)
multi sub infix:«>=»(Real:D, Real:D)
```

Numeric greater than or equal to operator.

Coerces both arguments to [Real](https://docs.perl6.org/type/Real) (if necessary); returns `True` if the first argument is larger than or equal to the second.

<a id="infix-%E2%89%A5"></a>
## infix `≥`

Numeric greater than or equal to operator.

Equivalent to [>=](https://docs.perl6.org/routine/%3E=), at codepoint U+2265 (GREATER-THAN OR EQUAL TO).

<a id="infix-eq"></a>
## infix `eq`

```Perl6
multi sub infix:<eq>(Any,   Any)
multi sub infix:<eq>(Str:D, Str:D)
```

String equality operator.

Coerces both arguments to [Str](https://docs.perl6.org/type/Str) (if necessary); returns `True` if both are equal.

Mnemonic: *equal*

<a id="infix-ne"></a>
## infix `ne`

```Perl6
multi sub infix:<ne>(Mu,    Mu)
multi sub infix:<ne>(Str:D, Str:D)
```

String inequality operator.

Coerces both arguments to [Str](https://docs.perl6.org/type/Str) (if necessary); returns `False` if both are equal.

Mnemonic: *not equal*

<a id="infix-gt"></a>
## infix `gt`

```Perl6
multi sub infix:<gt>(Mu,    Mu)
multi sub infix:<gt>(Str:D, Str:D)
```

String greater than operator.

Coerces both arguments to [Str](https://docs.perl6.org/type/Str) (if necessary); returns `True` if the first is larger than the second, as determined by lexicographic comparison.

Mnemonic: *greater than*

<a id="infix-ge"></a>
## infix `ge`

```Perl6
multi sub infix:<ge>(Mu,    Mu)
multi sub infix:<ge>(Str:D, Str:D)
```

String greater than or equal to operator.

Coerces both arguments to [Str](https://docs.perl6.org/type/Str) (if necessary); returns `True` if the first is equal to or larger than the second, as determined by lexicographic comparison.

Mnemonic: *greater or equal*

<a id="infix-lt"></a>
## infix `lt`

```Perl6
multi sub infix:<lt>(Mu,    Mu)
multi sub infix:<lt>(Str:D, Str:D)
```

String less than operator.

Coerces both arguments to [Str](https://docs.perl6.org/type/Str) (if necessary); returns `True` if the first is smaller than the second, as determined by lexicographic comparison.

Mnemonic: *less than*

<a id="infix-le"></a>
## infix `le`

```Perl6
multi sub infix:<le>(Mu,    Mu)
multi sub infix:<le>(Str:D, Str:D)
```

String less than or equal to operator.

Coerces both arguments to [Str](https://docs.perl6.org/type/Str) (if necessary); returns `True` if the first is equal to or smaller than the second, as determined by lexicographic comparison.

Mnemonic: *less or equal*

<a id="infix-before"></a>
## infix `before`

```Perl6
multi sub infix:<before>(Any,       Any)
multi sub infix:<before>(Real:D,    Real:D)
multi sub infix:<before>(Str:D,     Str:D)
multi sub infix:<before>(Version:D, Version:D)
```

Generic ordering, uses the same semantics as [cmp](https://docs.perl6.org/routine/cmp). Returns `True` if the first argument is smaller than the second.

<a id="infix-after"></a>
## infix `after`

```Perl6
multi sub infix:<after>(Any,       Any)
multi sub infix:<after>(Real:D,    Real:D)
multi sub infix:<after>(Str:D,     Str:D)
multi sub infix:<after>(Version:D, Version:D)
```

Generic ordering, uses the same semantics as [cmp](https://docs.perl6.org/routine/cmp). Returns `True` if the first argument is larger than the second.

<a id="infix-eqv"></a>
## infix `eqv`

```Perl6
sub infix:<eqv>(Any, Any)
```

Equivalence operator. Returns `True` if the two arguments are structurally the same, i.e. from the same type and (recursively) contain equivalent values.

```Perl6
say [1, 2, 3] eqv [1, 2, 3];    # OUTPUT: «True␤» 
say Any eqv Any;                # OUTPUT: «True␤» 
say 1 eqv 2;                    # OUTPUT: «False␤» 
say 1 eqv 1.0;                  # OUTPUT: «False␤»
```

Lazy [`Iterables`](https://docs.perl6.org/type/Iterable) cannot be compared, as they're assumed to be infinite. However, the operator will do its best and return `False` if the two lazy `Iterables` are of different types or if only one `Iterable` is lazy.

```Perl6
say (1…∞) eqv (1…∞).List; # Both lazy, but different types;   OUTPUT: «False␤» 
say (1…∞) eqv (1…3);      # Same types, but only one is lazy; OUTPUT: «False␤» 
(try say (1…∞) eqv (1…∞)) # Both lazy and of the same type. Cannot compare; throws. 
    orelse say $!.^name;  # OUTPUT: «X::Cannot::Lazy␤»
```

The default `eqv` operator even works with arbitrary objects. E.g., `eqv` will consider two instances of the same object as being structurally equivalent:

```Perl6
my class A {
    has $.a;
}
say A.new(a => 5) eqv A.new(a => 5);  # OUTPUT: «True␤»
```

Although the above example works as intended, the `eqv` code might fall back to a slower code path in order to do its job. One way to avoid this is to implement an appropriate infix `eqv` operator:

```Perl6
my class A {
    has $.a;
}
multi infix:<eqv>(A $l, A $r) { $l.a eqv $r.a }
say A.new(a => 5) eqv A.new(a => 5);            # OUTPUT: «True␤»
```

Note that `eqv` does not work recursively on every kind of container type, e.g. `Set`:

```Perl6
my class A {
    has $.a;
}
say Set(A.new(a => 5)) eqv Set(A.new(a => 5));  # OUTPUT: «False␤»
```

Even though the contents of the two sets are `eqv`, the sets are not. The reason is that `eqv` delegates the equality check to the `Set` object which relies on element-wise `===` comparison. Turning the class `A` into a [value type](https://docs.perl6.org/type/ValueObjAt) by giving it a `WHICH` method produces the expected behavior:

```Perl6
my class A {
    has $.a;
    method WHICH {
        ValueObjAt.new: "A|$!a.WHICH()"
    }
}
say Set(A.new(a => 5)) eqv Set(A.new(a => 5));  # OUTPUT: «True␤»
```

<a id="infix--18"></a>
## infix `===`

```Perl6
sub infix:<===>(Any, Any)
```

Value identity operator. Returns `True` if both arguments are the same object, disregarding any containerization.

```Perl6
my class A { };
my $a = A.new;
say $a === $a;              # OUTPUT: «True␤» 
say A.new === A.new;        # OUTPUT: «False␤» 
say A === A;                # OUTPUT: «True␤»
```

For value types, `===` behaves like `eqv`:

```Perl6
say 'a' === 'a';            # OUTPUT: «True␤» 
say 'a' === 'b';            # OUTPUT: «False␤» 
 
my $b = 'a';
say $b === 'a';             # OUTPUT: «True␤» 
 
# different types 
say 1 === 1.0;              # OUTPUT: «False␤»
```

`===` uses the [WHICH](https://docs.perl6.org/routine/WHICH) method to obtain the object identity.

If you want to create a class that should act as a value type, then that class must create an instance method `WHICH`, that should return a [ValueObjAt](https://docs.perl6.org/type/ValueObjAt) object that won't change for the lifetime of the object.

<a id="infix--19"></a>
## infix `=:=`

```Perl6
multi sub infix:<=:=>(Mu \a, Mu \b)
```

Container identity operator. Returns `True` if both arguments are bound to the same container. If it returns `True`, it generally means that modifying one will also modify the other.

```Perl6
my ($a, $b) = (1, 3);
say $a =:= $b;      # OUTPUT: «False␤» 
$b = 2;
say $a;             # OUTPUT: «1␤» 
$b := $a;
say $a =:= $b;      # OUTPUT: «True␤» 
$a = 5;
say $b;             # OUTPUT: «5␤»
```

<a id="infix-%7E%7E"></a>
## infix `~~`

The smartmatch operator aliases the left-hand side to `$_`, then evaluates the right-hand side and calls `.ACCEPTS($_)` on it. The semantics are left to the type of the right-hand side operand.

Here is a partial list of some of the built-in smartmatching functionality. For full details, see [ACCEPTS](https://docs.perl6.org/routine/ACCEPTS) documentation for the type on the right-hand side of the operator.

| Right-hand side | Comparison semantics         |
| --------------- | ---------------------------- |
| Mu:U            | type check                   |
| Str             | string equality              |
| Numeric         | numeric equality             |
| Regex           | regex match                  |
| Callable        | boolean result of invocation |
| Set/Bag         | equal element values         |
| Any:D           | object identity              |

<a id="infix-%7E-4"></a>
## infix `=~=`

```Perl6
multi sub infix:<=~=>(Any, Any)
multi sub infix:<=~=>(Int:D, Int:D)
multi sub infix:<=~=>(Num:D, Num:D)
multi sub infix:<=~=>(Rational:D, Rational:D)
multi sub infix:<=~=>(Real:D, Real:D)
multi sub infix:<=~=>(Complex:D, Complex:D)
multi sub infix:<=~=>(Numeric:D, Numeric:D)
```

The approximately-equal operator `≅`, whose ASCII variant is `=~=`, calculates the relative difference between the left-hand and right-hand sides and returns `True` if the difference is less than `$*TOLERANCE` (which defaults to 1e-15). However, if either side is zero then it checks that the absolute difference between the sides is less than `$*TOLERANCE`. Note that this operator is not arithmetically symmetrical (doesn't do ± Δ):

```Perl6
my $x = 1;
say ($x + $*TOLERANCE) =~= $x;   # OUTPUT: «False␤» 
say ($x - $*TOLERANCE) =~= $x;   # OUTPUT: «True␤»
```

The tolerance is supposed to be modifiable via an adverb:

```Perl6
my ($x, $y) = 42, 42.1;
say $x =~= $y :tolerance(.1);
```

However, this is not yet implemented. The same effect can be achieved by assigning to $*TOLERANCE.

```Perl6
{
    my $*TOLERANCE = .1;
    say 11 =~= 10;        # OUTPUT: «True␤» 
}
```

Note that setting $*TOLERANCE = 0 will cause all comparisons to fail.

```Perl6
{
    my $*TOLERANCE = 0;
    say 1 =~= 1;          # OUTPUT: «False␤» 
}
```

<a id="infix-elem-infix-%E2%88%88%C2%BB"></a>
## infix (elem), infix ∈»

```Perl6
multi sub infix:<(elem)>($a,$b --> Bool:D)
multi sub infix:<∈>($a,$b --> Bool:D)
```

Membership operator.

Returns `True` if `$a` is an **element** of `$b`.

```Perl6
say 2 (elem) (1, 2, 3); # OUTPUT: «True␤» 
say 4 ∈ (1, 2, 3); # OUTPUT: «False␤» 
```

`∈` is equivalent to `(elem)`, at codepoint U+2208 (ELEMENT OF).

<a id="infix-%E2%88%89"></a>
## infix `∉`

```Perl6
multi sub infix:<∉>($a,$b --> Bool:D)
```

Non-membership operator.

Returns `True` if `$a` is **not** an **element** of `$b`. Equivalent to `!(elem)`.

```Perl6
say 4 ∉ (1, 2, 3); # OUTPUT: «True␤» 
say 2 !(elem) (1, 2, 3); # OUTPUT: «False␤» 
```

`∉` is codepoint U+2209 (NOT AN ELEMENT OF).

<a id="infix-cont-infix-%E2%88%8B%C2%BB"></a>
## infix (cont), infix ∋»

```Perl6
multi sub infix:<(cont)>($a,$b --> Bool:D)
multi sub infix:<∋>($a,$b --> Bool:D)
```

Membership operator.

Returns `True` if `$a` is an **element** of `$b`.

```Perl6
say (1,2,3) (cont) 2; # OUTPUT: «True␤» 
say (1, 2, 3) ∋ 4; # OUTPUT: «False␤» 
```

`∋` is equivalent to `(cont)`, at codepoint U+220B (CONTAINS AS MEMBER).

<a id="infix-%E2%88%8C"></a>
## infix `∌`

```Perl6
multi sub infix:<∌>($a,$b --> Bool:D)
```

Non-membership operator.

Returns `True` if `$a` is **not** an **element** of `$b`. Equivalent to `!(cont)`.

```Perl6
say (1,2,3) ∌ 4; # OUTPUT: «True␤» 
say (1,2,3) !(cont) 2; # OUTPUT: «False␤» 
```

`∉` is codepoint U+220C (DOES NOT CONTAIN AS MEMBER).

<a id="infix--infix-%E2%8A%82"></a>
## infix `(<)`, infix `⊂`

```Perl6
multi sub infix:<< (<) >>($a,$b --> Bool:D)
multi sub infix:<⊂>($a,$b --> Bool:D)
```

Subset of operator.

Returns `True` if `$a` is a **strict subset** of `$b`, i.e., that all the elements of `$a` are elements of `$b` but `$a` is a smaller set than `$b`.

```Perl6
say (1,2,3) (<) (2,3,1); # OUTPUT: «False␤» 
say (2,3) (<) (2,3,1); # OUTPUT: «True␤» 
say 4 ⊂ (1,2,3); # OUTPUT: «False␤» 
```

`⊂` is equivalent to `(<)`, at codepoint U+2282 (SUBSET OF).

<a id="infix-%E2%8A%84"></a>
## infix `⊄`

```Perl6
multi sub infix:<⊄>($a,$b --> Bool:D)
```

Not a subset of operator.

Returns `True` if `$a` is **not** a `strict subset` of `$b`. Equivalent to `!(<)`.

```Perl6
say (1,2,3) ⊄ (2,3,1); # OUTPUT: «True␤» 
say (2,3) ⊄ (2,3,1); # OUTPUT: «False␤» 
say 4 !(<) (1,2,3); # OUTPUT: «True␤» 
```

`⊄` is codepoint U+2284 (NOT A SUBSET OF).

<a id="infix--infix-%E2%8A%86"></a>
## infix `(<=)`, infix `⊆`

```Perl6
multi sub infix:<< (<=) >>($a,$b --> Bool:D)
multi sub infix:<⊆>($a,$b --> Bool:D)
```

Subset of or equal to operator.

Returns `True` if `$a` is a **subset** of `$b`, i.e., that all the elements of `$a` are elements of `$b` but `$a` is a smaller or equal sized set than `$b`.

```Perl6
say (1,2,3) (<=) (2,3,1); # OUTPUT: «True␤» 
say (2,3) (<=) (2,3,1); # OUTPUT: «True␤» 
say 4 ⊆ (1,2,3); # OUTPUT: «False␤» 
```

`⊆` is equivalent to `(<=)`, at codepoint U+2286 (SUBSET OF OR EQUAL TO).

<a id="infix-%E2%8A%88"></a>
## infix `⊈`

```Perl6
multi sub infix:<⊈>($a,$b --> Bool:D)
```

Not a subset of nor equal to operator.

Returns `True` if `$a` is **not** a `subset` of `$b`. Equivalent to `!(<=)`.

```Perl6
say (1,2,3) ⊄ (2,3,1); # OUTPUT: «True␤» 
say (2,3) ⊄ (2,3,1); # OUTPUT: «False␤» 
say 4 !(<=) (1,2,3); # OUTPUT: «True␤» 
```

`⊈` is codepoint U+2288 (NEITHER A SUBSET OF NOR EQUAL TO).

<a id="infix--infix-%E2%8A%83"></a>
## infix `(>)`, infix `⊃`

```Perl6
multi sub infix:<< (>) >>($a,$b --> Bool:D)
multi sub infix:<⊃>($a,$b --> Bool:D)
```

Superset of operator.

Returns `True` if `$a` is a **strict superset** of `$b`, i.e., that all the elements of `$b` are elements of `$a` but `$a` is a larger set than `$b`.

```Perl6
say (1,2,3) (>) (2,3,1); # OUTPUT: «False␤» 
say (1,2,3) (>) (2,3); # OUTPUT: «True␤» 
say 4 ⊃ (1,2,3); # OUTPUT: «False␤» 
```

`⊃` is equivalent to `(>)`, at codepoint U+2283 (SUPERSET OF).

<a id="infix-%E2%8A%85"></a>
## infix `⊅`

```Perl6
multi sub infix:<⊅>($a,$b --> Bool:D)
```

Not a superset of operator.

Returns `True` if `$a` is **not** a `strict superset` of `$b`. Equivalent to `!(>)`.

```Perl6
say (1,2,3) ⊅ (2,3,1); # OUTPUT: «True␤» 
say (1,2,3) ⊅ (2,3); # OUTPUT: «False␤» 
say 4 !(>) (1,2,3); # OUTPUT: «True␤» 
```

`⊅` is codepoint U+2285 (NOT A SUPERSET OF).

<a id="infix--infix-%E2%8A%87"></a>
## infix `(>=)`, infix `⊇`

```Perl6
multi sub infix:<< (>=) >>($a,$b --> Bool:D)
multi sub infix:<⊇>($a,$b --> Bool:D)
```

Superset of or equal to operator.

Returns `True` if `$a` is a **superset** of `$b`, i.e., that all the elements of `$b` are elements of `$a` but `$a` is a larger or equal sized set than `$b`.

```Perl6
say (1,2,3) (>=) (2,3,1); # OUTPUT: «True␤» 
say (1,2,3) (>=) (2,3); # OUTPUT: «True␤» 
say 4 ⊇ (1,2,3); # OUTPUT: «False␤» 
```

`⊇` is equivalent to `(>=)`, at codepoint U+2287 (SUPERSET OF OR EQUAL TO).

<a id="infix-%E2%8A%89"></a>
## infix `⊉`

```Perl6
multi sub infix:<⊉>($a,$b --> Bool:D)
```

Not a superset of nor equal to operator.

Returns `True` if `$a` is **not** a `superset` of `$b`. Equivalent to `!(>=)`.

```Perl6
say (1,2,3) ⊉ (2,3,1); # OUTPUT: «False␤» 
say (1,2,3) ⊉ (2,3); # OUTPUT: «False␤» 
say 4 !(>=) (1,2,3); # OUTPUT: «True␤» 
```

`⊉` is codepoint U+2289 (NEITHER A SUPERSET OF OR EQUAL TO).

<a id="tight-and-precedence"></a>
# Tight AND precedence

<a id="infix--20"></a>
## infix `&&`

Returns the first argument that evaluates to `False` in boolean context, otherwise returns the last argument.

Note that this short-circuits, i.e. if one of the arguments evaluates to a false value, the arguments to the right are never evaluated.

```Perl6
sub a { 1 }
sub b { 0 }
sub c { die "never called" };
say a() && b() && c();      # OUTPUT: «0␤»
```

<a id="tight-or-precedence"></a>
# Tight OR precedence

<a id="infix-%7C%7C"></a>
## infix `||`

Returns the first argument that evaluates to `True` in boolean context, otherwise returns the last argument.

Note that this short-circuits; i.e., if one of the arguments evaluates to a true value, the remaining arguments are not evaluated.

```Perl6
sub a { 0 }
sub b { 1 }
sub c { die "never called" };
say a() || b() || c();      # OUTPUT: «1␤»
```

<a id="infix-%5E%5E-1"></a>
## infix `^^`

Short-circuit exclusive-or. Returns the true argument if there is one (and only one). Returns the last argument if all arguments are false. Returns `Nil` when more than one argument is true.

This operator short-circuits in the sense that it does not evaluate any arguments after a 2nd true result.

```Perl6
say 0 ^^ 42;                             # OUTPUT: «42␤» 
say '' ^^ 0;                             # OUTPUT: «0␤» 
say 0 ^^ 42 ^^ 1 ^^ die "never called";  # OUTPUT: «Nil␤»
```

Note that the semantics of this operator may not be what you assume: infix `^^` flips to the first true value it finds and then flips to Nil *forever* after the second, no matter how many more true values there are. (In other words, it has "find the one true value" semantics, not "boolean parity" semantics.)

<a id="infix--21"></a>
## infix `//`

The defined-or operator or infix // returns the first defined operand, or else the last operand. Short-circuits.

```Perl6
say Any // 0 // 42;         # OUTPUT: «0␤»
```

<a id="infix-min"></a>
## infix `min`

Returns the smallest of the arguments, as determined by [cmp](https://docs.perl6.org/routine/cmp) semantics.

```Perl6
my $foo = 42;
$foo min= 0   # read as: $foo decreases to 0
```

<a id="infix-max"></a>
## infix `max`

Returns the largest of the arguments, as determined by [cmp](https://docs.perl6.org/routine/cmp) semantics.

```Perl6
my $foo = -42;
$foo max= 0   # read as: $foo increases to 0
```

<a id="infix-minmax"></a>
## infix `minmax`

Returns the [Range](https://docs.perl6.org/type/Range) starting from the lowest to the highest of the values, as determined by the [cmp](https://docs.perl6.org/routine/cmp) semantics. For instance:

```Perl6
# numeric comparison 
10 minmax 3;     # 3..10 
 
# string comparison 
'10' minmax '3'; # "10".."3" 
'z' minmax 'k';  # "k".."z" 
```

If the lowest and highest values coincide, the operator returns a [Range](https://docs.perl6.org/type/Range) made by the same value:

```Perl6
1 minmax 1;  # 1..1 
```

When applied to [List](https://docs.perl6.org/type/List)s, the operator evaluates the lowest and highest values among all available values:

```Perl6
(10,20,30) minmax (0,11,22,33);       # 0..33 
('a','b','z') minmax ('c','d','w');   # "a".."z" 
```

Similarly, when applied to [Hash](https://docs.perl6.org/type/Hash)es, it performs a [cmp](https://docs.perl6.org/routine/cmp) way comparison:

```Perl6
my %winner = points => 30, misses => 10;
my %loser = points => 20, misses => 10;
%winner cmp %loser;      # More 
%winner minmax %loser;
# ${:misses(10), :points(20)}..${:misses(10), :points(30)} 
```

<a id="conditional-operator-precedence"></a>
# Conditional operator precedence

<a id="infix---1"></a>
## infix `?? !!`

Also called *ternary* or *conditional* operator, `$condition ?? $true !! $false` evaluates `$condition` and returns the expression right behind ??, in this case `$true` if it is `True`, otherwise evaluates and returns the expression behind !!, `$false` in this case.

<a id="infix-ff"></a>
## infix `ff`

```Perl6
sub infix:<ff>(Mu $a, Mu $b)
```

Also called the *flipflop operator*, compares both arguments to `$_` (that is, `$_ ~~ $a` and `$_ ~~ $b`). Evaluates to `False` until the left-hand smartmatch is `True`, at which point it evaluates to `True` until the right-hand smartmatch is `True`.

In effect, the left-hand argument is the "start" condition and the right-hand is the "stop" condition. This construct is typically used to pick up only a certain section of lines. For example:

```Perl6
my $excerpt = q:to/END/;
Here's some unimportant text.
=begin code
    This code block is what we're after.
    We'll use 'ff' to get it.
=end code
More unimportant text.
END

my @codelines = gather for $excerpt.lines {
    take $_ if "=begin code" ff "=end code"
}
# this will print four lines, starting with "=begin code" and ending with
# "=end code"
say @codelines.join("\n");
```

After matching the start condition, the operator will then match the same `$_` to the stop condition and act accordingly if successful. In this example, only the first element is printed:

```Perl6
for <AB C D B E F> {
    say $_ if /A/ ff /B/;  # OUTPUT: «AB␤» 
}
```

If you only want to test against a start condition and have no stop condition, `*` can be used as such.

```Perl6
for <A B C D E> {
    say $_ if /C/ ff *;    # OUTPUT: «C␤D␤E␤» 
}
```

For the `sed`-like version, which does *not* try `$_` on the stop condition after succeeding on the start condition, see [fff](https://docs.perl6.org/routine/fff).

This operator cannot be overloaded, as it's handled specially by the compiler.

<a id="infix-%5Eff"></a>
## infix `^ff`

```Perl6
sub infix:<^ff>(Mu $a, Mu $b)
```

Works like [ff](https://docs.perl6.org/routine/ff), except it does not return `True` for items matching the start condition (including items also matching the stop condition).

A comparison:

```Perl6
my @list = <A B C>;
say $_ if /A/ ff /C/ for @list;    # OUTPUT: «A␤B␤C␤» 
say $_ if /A/ ^ff /C/ for @list;   # OUTPUT: «B␤C␤»
```

The sed-like version can be found in [`^fff`](https://docs.perl6.org/routine/$CIRCUMFLEX_ACCENTfff).

This operator cannot be overloaded, as it's handled specially by the compiler.

<a id="infix-ff%5E"></a>
## infix `ff^`

```Perl6
sub infix:<ff^>(Mu $a, Mu $b)
```

Works like [ff](https://docs.perl6.org/routine/ff), except it does not return `True` for items matching the stop condition (including items that first matched the start condition).

```Perl6
my @list = <A B C>;
say $_ if /A/ ff /C/ for @list;    # OUTPUT: «A␤B␤C␤» 
say $_ if /A/ ff^ /C/ for @list;   # OUTPUT: «A␤B␤»
```

The sed-like version can be found in [fff^](https://docs.perl6.org/routine/fff$CIRCUMFLEX_ACCENT).

This operator cannot be overloaded, as it's handled specially by the compiler.

<a id="infix-%5Eff%5E"></a>
## infix `^ff^`

```Perl6
sub infix:<^ff^>(Mu $a, Mu $b)
```

Works like [ff](https://docs.perl6.org/routine/ff), except it does not return `True` for items matching either the stop or start condition (or both).

```Perl6
my @list = <A B C>;
say $_ if /A/ ff /C/ for @list;    # OUTPUT: «A␤B␤C␤» 
say $_ if /A/ ^ff^ /C/ for @list;  # OUTPUT: «B␤»
```

The sed-like version can be found in [`^fff^`](https://docs.perl6.org/routine/$CIRCUMFLEX_ACCENTfff$CIRCUMFLEX_ACCENT).

This operator cannot be overloaded, as it's handled specially by the compiler.

<a id="infix-fff"></a>
## infix `fff`

```Perl6
sub infix:<fff>(Mu $a, Mu $b)
```

Performs a sed-like flipflop operation, wherein it returns `False` until the left argument smartmatches against `$_`, then returns `True` until the right argument smartmatches against `$_`.

Works similarly to [ff](https://docs.perl6.org/routine/ff), except that it only tries one argument per invocation. That is, if `$_` smartmatches the left argument, `fff` will **not** then try to match that same `$_` against the right argument.

```Perl6
for <AB C D B E F> {
    say $_ if /A/ fff /B/;         # OUTPUT: «AB␤C␤D␤B␤» 
}
```

The non-sed-like flipflop (which after successfully matching the left argument against `$_` will try that same `$_` against the right argument and act accordingly). See [ff](https://docs.perl6.org/routine/ff).

This operator cannot be overloaded, as it's handled specially by the compiler.

<a id="infix-%5Efff"></a>
## infix `^fff`

```Perl6
sub infix:<^fff>(Mu $a, Mu $b)
```

Like [fff](https://docs.perl6.org/routine/fff), except it does not return true for matches to the left argument.

```Perl6
my @list = <A B C>;
say $_ if /A/ fff /C/ for @list;   # OUTPUT: «A␤B␤C␤» 
say $_ if /A/ ^fff /C/ for @list;  # OUTPUT: «B␤C␤»
```

For the non-sed version, see [`^ff`](https://docs.perl6.org/routine/$CIRCUMFLEX_ACCENTff).

This operator cannot be overloaded, as it's handled specially by the compiler.

<a id="infix-fff%5E"></a>
## infix `fff^`

```Perl6
sub infix:<fff^>(Mu $a, Mu $b)
```

Like [fff](https://docs.perl6.org/routine/fff), except it does not return true for matches to the right argument.

```Perl6
my @list = <A B C>;
say $_ if /A/ fff /C/ for @list;   # OUTPUT: «A␤B␤C␤» 
say $_ if /A/ fff^ /C/ for @list;  # OUTPUT: «A␤B␤»
```

For the non-sed version, see [ff^](https://docs.perl6.org/routine/ff$CIRCUMFLEX_ACCENT).

This operator cannot be overloaded, as it's handled specially by the compiler.

<a id="infix-%5Efff%5E"></a>
## infix `^fff^`

```Perl6
sub infix:<^fff^>(Mu $a, Mu $b)
```

Like [fff](https://docs.perl6.org/routine/fff), except it does not return true for matches to either the left or right argument.

```Perl6
my @list = <A B C>;
say $_ if /A/ fff /C/ for @list;   # OUTPUT: «A␤B␤C␤» 
say $_ if /A/ ^fff^ /C/ for @list; # OUTPUT: «B␤»
```

For the non-sed version, see [`^ff^`](https://docs.perl6.org/routine/$CIRCUMFLEX_ACCENTff$CIRCUMFLEX_ACCENT).

This operator cannot be overloaded, as it's handled specially by the compiler.

<a id="item-assignment-precedence"></a>
# Item assignment precedence

<a id="infix--22"></a>
## infix `=`

```Perl6
    sub infix:<=>(Mu $a is rw, Mu $b)
```

Called the *item assignment operator*, it Places the value of the right-hand side into the container on the left-hand side. Its exact semantics are left to the container type on the left-hand side.

(Note that item assignment and list assignment have different precedence levels, and the syntax of the left-hand side decides whether an equal sign `=` is parsed as item assignment or list assignment operator).

<a id="infix--23"></a>
## infix `=>`

```Perl6
sub infix:«=>»($key, Mu $value --> Pair:D)
```

[Pair](https://docs.perl6.org/type/Pair) constructor.

Constructs a [Pair](https://docs.perl6.org/type/Pair) object with the left-hand side as the key and the right-hand side as the value.

Note that the `=> `operator is syntactically special-cased, in that it allows unquoted identifier on the left-hand side.

```Perl6
my $p = a => 1;
say $p.key;         # OUTPUT: «a␤» 
say $p.value;       # OUTPUT: «1␤»
```

A [Pair](https://docs.perl6.org/type/Pair) within an argument list with an unquoted identifier on the left is interpreted as a named argument.

See [the Terms language documentation](https://docs.perl6.org/language/terms#Pair) for more ways to create `Pair` objects.

<a id="loose-unary-precedence"></a>
# Loose unary precedence

<a id="prefix-not"></a>
## prefix `not`

```Perl6
multi sub prefix:<not>(Mu $x --> Bool:D)
```

Evaluates its argument in boolean context (and thus collapses [Junction](https://docs.perl6.org/type/Junction)s), and negates the result. Please note that `not` is easy to misuse. See [traps](https://docs.perl6.org/language/traps#Loose_boolean_operators).

<a id="prefix-so"></a>
## prefix `so`

```Perl6
multi sub prefix:<so>(Mu $x --> Bool:D)
```

Evaluates its argument in boolean context (and thus collapses [Junction](https://docs.perl6.org/type/Junction)s), and returns the result.

<a id="comma-operator-precedence"></a>
# Comma operator precedence

<a id="infix--24"></a>
## infix `,`

```Perl6
sub infix:<,>(*@a --> List:D) is assoc<list>
```

Constructs a higher-order [Cool](https://docs.perl6.org/type/Cool) from its arguments.

```Perl6
my @list = :god('Þor'), ['is',"mighty"];
say @list;      # OUTPUT: «[god => Þor [is mighty]]␤» 
my %hash = :god('Þor'), :is("mighty");
say %hash.perl; # OUTPUT: «{:god("Þor"), :is("mighty")}␤» 
my %a = :11a, :22b;
say %(%a, :33x);  # OUTPUT: «{a => 11, b => 22, x => 33}␤»
```

In the first case it returns a [List](https://docs.perl6.org/type/List), in the second case, since the arguments are [Pair](https://docs.perl6.org/type/Pair)s, it builds a [Hash](https://docs.perl6.org/type/Hash).

It can also be used for constructing variables from other variables, collating elements of different types, in this case a [Hash](https://docs.perl6.org/type/Hash) and a [Pair](https://docs.perl6.org/type/Pair):

```Perl6
my %features = %hash, :wields("hammer");
say %features;  # OUTPUT: «{god => Þor, is => mighty, wields => hammer}␤» 
```

The comma is also used syntactically as the separator of arguments in calls.

<a id="infix--25"></a>
## infix `:`

Used as an argument separator just like infix `,` and marks the argument to its left as the invocant. That turns what would otherwise be a function call into a method call.

```Perl6
substr('abc': 1);       # same as 'abc'.substr(1)
```

Infix `:` is only allowed after the first argument of a non-method call. In other positions, it's a syntax error.

<a id="list-infix-precedence"></a>
# List infix precedence

<a id="infix-z"></a>
## infix `Z`

```Perl6
sub infix:<Z>(**@lists --> Seq:D) is assoc<chain>
```

The Zip operator interleaves the lists passed to `Z` like a zipper, taking index-corresponding elements from each operand. The returned `Seq` contains nested lists, each with a value from every operand in the chain. If one of the operands runs out of elements prematurely, the zip operator will stop.

```Perl6
say (1, 2 Z <a b c> Z <+ ->).perl;
# OUTPUT: «((1, "a", "+"), (2, "b", "-")).Seq␤» 
for <a b c> Z <1 2 3 4> -> [$l, $r] {
    say "$l:$r"
}
# OUTPUT: «a:1␤b:2␤c:3␤» 
```

The `Z` operator also exists as a metaoperator, in which case the inner lists are replaced by the value from applying the operator to the list:

```Perl6
say 100, 200 Z+ 42, 23;             # OUTPUT: «(142 223)␤» 
say 1..3 Z~ <a b c> Z~ 'x' xx 3;    # OUTPUT: «(1ax 2bx 3cx)␤»
```



<a id="infix-x-1"></a>
## infix `X`

Defined as:

```Perl6
multi sub infix:<X>(+lol, :&with! --> Seq:D)
multi sub infix:<X>(+lol --> Seq:D)
```

Creates a cross product from all the lists, ordered so that the rightmost elements vary most rapidly, and returns a `Seq`:

```Perl6
1..3 X <a b c> X 9
# produces ((1 a 9) (1 b 9) (1 c 9) 
#           (2 a 9) (2 b 9) (2 c 9) 
#           (3 a 9) (3 b 9) (3 c 9))
```

The `X` operator also exists as a metaoperator, in which case the inner lists are replaced by the value from applying the operator to the list:

```Perl6
1..3 X~ <a b c> X~ 9
# produces (1a9 1b9 1c9 2a9 2b9 2c9 3a9 3b9 3c9)
```

<a id="infix--26"></a>
## infix `...` 

```Perl6
multi sub infix:<...>(**@) is assoc<list>
multi sub infix:<...^>(**@) is assoc<list>
```

The sequence operator, which can be written either as `...` or as `…` (with variants `...^` and `…^`) will produce (possibly lazy) generic sequences on demand.

The left-hand side will always include the initial elements; it may include a generator too (after the first element or elements). The right-hand side will have an endpoint, which can be `Inf` or `*` for "infinite" lists (that is, *lazy* lists whose elements are only produced on demand), an expression which will end the sequence when `True`, or other elements such as [Junctions](https://docs.perl6.org/type/Junction).

The sequence operator invokes the generator with as many arguments as necessary. The arguments are taken from the initial elements and the already generated elements. The default generator is `*.`[succ](https://docs.perl6.org/routine/succ) or `*.`[pred](https://docs.perl6.org/routine/pred), depending on how the end points compare:

```Perl6
say 1 ... 4;        # OUTPUT: «(1 2 3 4)␤» 
say 4 ... 1;        # OUTPUT: «(4 3 2 1)␤» 
say 'a' ... 'e';    # OUTPUT: «(a b c d e)␤» 
say 'e' ... 'a';    # OUTPUT: «(e d c b a)␤»
```

An endpoint of `*` ([Whatever](https://docs.perl6.org/type/Whatever)), `Inf` or `∞` generates on demand an infinite sequence, with a default generator of `*.succ`

```Perl6
say (1 ... *)[^5];  # OUTPUT: «(1 2 3 4 5)␤»
```

Custom generators need to be the last element of the list before the '...' operator. This one takes two arguments, and generates the eight first Fibonacci numbers

```Perl6
say (1, 1, -> $a, $b { $a + $b } ... *)[^8]; # OUTPUT: «(1 1 2 3 5 8 13 21)␤» 
# same but shorter 
say (1, 1, * + * ... *)[^8];                 # OUTPUT: «(1 1 2 3 5 8 13 21)␤» 
```

Of course the generator can also take only one argument.

```Perl6
say 5, { $_ * 2 } ... 40;                # OUTPUT: «5 10 20 40␤»
```

There must be at least as many initial elements as arguments to the generator.

Without a generator and with more than one initial element and all initial elements numeric, the sequence operator tries to deduce the generator. It knows about arithmetic and geometric sequences.

```Perl6
say 2, 4, 6 ... 12;     # OUTPUT: «(2 4 6 8 10 12)␤» 
say 1, 2, 4 ... 32;     # OUTPUT: «(1 2 4 8 16 32)␤»
```

If the endpoint is not `*`, it's smartmatched against each generated element and the sequence is terminated when the smartmatch succeeded. For the `...` operator, the final element is included, for the `...^` operator it's excluded.

This allows you to write

```Perl6
say 1, 1, * + * ...^ *>= 100;
```

to generate all Fibonacci numbers up to but excluding 100.

The `...` operators consider the initial values as "generated elements" as well, so they are also checked against the endpoint:

```Perl6
my $end = 4;
say 1, 2, 4, 8, 16 ... $end;
# OUTPUT: «(1 2 4)␤»
```

<a id="list-prefix-precedence"></a>
# List prefix precedence

<a id="infix--27"></a>
## infix `=`

In this context, it acts as the list assignment operator. Its exact semantics are left to the container type on the left-hand side. See [Array](https://docs.perl6.org/type/Array) and [Hash](https://docs.perl6.org/type/Hash) for common cases.

The distinction between item assignment and list assignment is determined by the parser depending on the syntax of the left-hand side.

<a id="infix--28"></a>
## infix `:=`

Binding operator. Whereas `$x = $y` puts the value in `$y` into `$x`, `$x := $y` makes `$x` and `$y` the same thing.

```Perl6
my $a = 42;
my $b = $a;
$b++;
say $a;
```

This will output 42, because `$a` and `$b` both contained the number `42`, but the [containers](https://docs.perl6.org/language/containers#Binding) were different.

```Perl6
my $a = 42;
my $b := $a;
$b++;
say $a;
```

This will output 43, since `$b` and `$a` both represented the same object.

If type constrains on variables or containers are present a type check will be performed at runtime. On failure `X::TypeCheck::BindingType` will be thrown.

Please note that `:=` is a compile time operator. As such it can not be referred to at runtime and thus can't be used as an argument to metaoperators.

<a id="infix--29"></a>
## infix `::=`

Read-only binding operator, not yet implemented in Rakudo. See [`infix :=`](https://docs.perl6.org/routine/:=).

<a id="listop-"></a>
## listop `...`

Called the *yada, yada, yada* operator or *stub* operator, if it's the only statement in a routine or type, it marks that routine or type as a stub (which is significant in the context of pre-declaring types and composing roles).

If the `...` statement is executed, it calls [fail](https://docs.perl6.org/routine/fail), with the default message `Stub code executed`.

<a id="listop--1"></a>
## listop `!!!`

If it's the only statement in a routine or type, it marks that routine or type as a stub (which is significant in the context of pre-declaring types and composing roles).

If the `!!!` statement is executed, it calls [die](https://docs.perl6.org/routine/die), with the default message `Stub code executed`.

<a id="listop--2"></a>
## listop `???`

If it's the only statement in a routine or type, it marks that routine or type as a stub (which is significant in the context of pre-declaring types and composing roles).

If the `???` statement is executed, it calls [warn](https://docs.perl6.org/routine/warn), with the default message `Stub code executed`.

<a id="reduction-operators"></a>
## Reduction operators

Any infix operator (except for non-associating operators) can be surrounded by square brackets in term position to create a list operator that reduces using that operation.

```Perl6
say [+] 1, 2, 3;      # 1 + 2 + 3 = 6 
my @a = (5, 6);
say [*] @a;           # 5 * 6 = 30
```

Reduction operators have the same associativity as the operators they are based on.

```Perl6
say [-] 4, 3, 2;      # 4-3-2 = (4-3)-2 = -1 
say [**] 4, 3, 2;     # 4**3**2 = 4**(3**2) = 262144
```

<a id="loose-and-precedence"></a>
# Loose AND precedence

<a id="infix"></a>
## infix 

Same as [infix &&](https://docs.perl6.org/language/operators#infix_%26%26), except with looser precedence.

Short-circuits so that it returns the first operand that evaluates to `False`, otherwise returns the last operand. Note that `and` is easy to misuse, see [traps](https://docs.perl6.org/language/traps#Loose_boolean_operators).

<a id="infix-1"></a>
## infix 

The `andthen` operator returns [`Empty`](https://docs.perl6.org/type/Slip#index-entry-Empty-Empty) upon encountering the first [undefined](https://docs.perl6.org/routine/defined) argument, otherwise the last argument. Last argument is returned as-is, without being checked for definedness at all. Short-circuits. The result of the left side is bound to `$_` for the right side, or passed as arguments if the right side is a [`Callable`](https://docs.perl6.org/type/Callable), whose [count](https://docs.perl6.org/routine/count) must be `0` or `1`.

A handy use of this operator is to alias a routine's return value to `$_` and to do additional manipulation with it, such as printing or returning it to caller. Since the `andthen` operator short-circuits, statements on the right-hand side won't get executed, unless left-hand side is defined (tip: [Failures](https://docs.perl6.org/type/Failure) are never defined, so you can handle them with this operator).

```Perl6
sub load-data {
    rand  > .5 or return; # simulated load data failure; return Nil 
    (rand > .3 ?? 'error' !! 'good data') xx 10 # our loaded data 
}
load-data.first: /good/ andthen say "$_ is good";
# OUTPUT: «(good data is good)␤» 
 
load-data() andthen .return; # return loaded data, if it's defined 
die "Failed to load data!!";
```

The above example will print `good data is good` only if the subroutine returned any items that match `/good/` and will die unless loading data returned a defined value. The aliasing behavior lets us pipe the values across the operator.

The `andthen` operator is a close relative of [`with` statement modifier](https://docs.perl6.org/syntax/with%20orwith%20without), and some compilers compile `with` to `andthen`, meaning these two lines have equivalent behavior:

```Perl6
.say with 42;
42 andthen .say;
```

<a id="infix-2"></a>
## infix 

The `notandthen` operator returns [`Empty`](https://docs.perl6.org/type/Slip#index-entry-Empty-Empty) upon encountering the first [defined](https://docs.perl6.org/routine/defined) argument, otherwise the last argument. Last argument is returned as-is, without being checked for definedness at all. Short-circuits. The result of the left side is bound to `$_` for the right side, or passed as arguments if the right side is a [`Callable`](https://docs.perl6.org/type/Callable), whose [count](https://docs.perl6.org/routine/count) must be `0` or `1`.

At first glance, [notandthen](https://docs.perl6.org/routine/notandthen) might appear to be the same thing as the [orelse](https://docs.perl6.org/routine/orelse) operator. The difference is subtle: [notandthen](https://docs.perl6.org/routine/notandthen) returns [`Empty`](https://docs.perl6.org/type/Slip#index-entry-Empty-Empty) when it encounters a [defined](https://docs.perl6.org/routine/defined) item (that isn't the last item), whereas [orelse](https://docs.perl6.org/routine/orelse) returns that item. In other words, [notandthen](https://docs.perl6.org/routine/notandthen) is a means to act when items aren't defined, whereas [orelse](https://docs.perl6.org/routine/orelse) is a means to obtain the first defined item:

```Perl6
sub all-sensors-down     { [notandthen] |@_, True             }
sub first-working-sensor { [orelse]     |@_, 'default sensor' }
 
all-sensors-down Nil, Nil, Nil
  and say 'OMG! All sensors are down!'; # OUTPUT:«OMG! All sensors are down!␤» 
say first-working-sensor Nil, Nil, Nil; # OUTPUT:«default sensor␤» 
 
all-sensors-down Nil, 42, Nil
  and say 'OMG! All sensors are down!'; # No output 
say first-working-sensor Nil, 42, Nil;  # OUTPUT:«42␤» 
```

The `notandthen` operator is a close relative of [`without` statement modifier](https://docs.perl6.org/syntax/with%20orwith%20without), and some compilers compile `without` to `notandthen`, meaning these two lines have equivalent behavior:

```Perl6
sub good-things { fail }
 
'boo'.say without good-things;
good-things() notandthen 'boo'.say;
```

<a id="loose-or-precedence"></a>
# Loose OR precedence

<a id="infix-or"></a>
## infix `or`

Same as [infix `||`](https://docs.perl6.org/routine/%7C%7C), except with looser precedence.

Returns the first argument that evaluates to `True` in boolean context, or otherwise the last argument, it short-circuits. Please note that `or` is easy to misuse. See [traps](https://docs.perl6.org/language/traps#Loose_boolean_operators).



<a id="infix-orelse"></a>
## infix `orelse`

The `orelse` operator is similar to `infix //`, except with looser precedence and `$_` aliasing.

Returns the first defined argument, or else the last argument. Last argument is returned as-is, without being checked for definedness at all. Short-circuits. The result of the left side is bound to `$_` for the right side, or passed as an argument if the right side is a [`Callable`](https://docs.perl6.org/type/Callable), whose [count](https://docs.perl6.org/routine/count) must be `0` or `1`.

This operator is useful for handling [Failures](https://docs.perl6.org/type/Failure) returned by routines since the expected value is usually [defined](https://docs.perl6.org/routine/defined) and [Failure](https://docs.perl6.org/type/Failure) never is:

```Perl6
sub meows { ++$ < 4 ?? fail 'out of meows!' !! '🐱' }
 
sub meows-processor1 { meows() orelse .return } # return handled Failure 
sub meows-processor2 { meows() orelse fail $_ } # return re-armed Failure 
sub meows-processor3 {
    # Use non-Failure output, or else print a message that stuff's wrong 
    meows() andthen .say orelse ‘something's wrong’.say;
}
 
say "{.^name}, {.handled}"  # OUTPUT: «Failure, True␤» 
    given meows-processor1;
say "{.^name}, {.handled}"  # OUTPUT: «Failure, False␤» 
    given meows-processor2;
meows-processor3;           # OUTPUT: «something's wrong␤» 
meows-processor3;           # OUTPUT: «🐱␤»
```

<a id="infix-xor"></a>
## infix `xor`

Same as [infix `^^`](https://docs.perl6.org/routine/$CIRCUMFLEX_ACCENT$CIRCUMFLEX_ACCENT), except with looser precedence.

Returns the operand that evaluates to `True` in boolean context, if and only if the other operand evaluates to `False` in boolean context. If both operands evaluate to `False`, returns the last argument. If both operands evaluate to `True`, returns `Nil`.

When chaining, returns the operand that evaluates to `True`, if and only if there is one such operand. If more than one operand is true, it short-circuits after evaluating the second and returns `Nil`. If all operands are false, returns the last one.

<a id="sequencer-precedence"></a>
# Sequencer precedence

<a id="infix--30"></a>
## infix `==>`

This feed operator takes the result from the left and passes it to the next (right) routine as the last parameter.

```Perl6
my @array = (1, 2, 3, 4, 5);
@array ==> sum() ==> say();   # OUTPUT: «15␤»
```

This simple example, above, is the equivalent of writing:

```Perl6
my @array = (1, 2, 3, 4, 5);
say(sum(@array));             # OUTPUT: «15␤»
```

Or if using methods:

```Perl6
my @array = (1, 2, 3, 4, 5);
@array.sum.say;               # OUTPUT: «15␤»
```

The precedence is very loose so you will need to use parentheses to assign the result or you can even just use another feed operator! In the case of routines/methods that take a single argument or where the first argument is a block, it's often required that you call with parentheses (though this is not required for the very last routine/method).

This "traditional" structure, read bottom-to-top, with the last two lines creating the data structure that is going to be processed

```Perl6
my @fractions = <TWO THREE FOUR FIVE SEVEN> »~» " " X~ <FIFTHS SIXTHS EIGHTHS>;
my @result = map { .uniparse },                    # (3) Converts to unicode 
    grep { .uniparse },                            # (2) Checks if it parses 
    map( {"VULGAR FRACTION " ~ $^þ }, @fractions); # (1) Adds string to input 
 
# @result is [⅖ ⅗ ⅜ ⅘ ⅚ ⅝ ⅞]
```

Now we use the feed operator (left-to-right) with parentheses, read top-to-bottom

```Perl6
my @result = (
    <TWO THREE FOUR FIVE SEVEN> »~» " " X~ <FIFTHS SIXTHS EIGHTHS> # (1) Input 
    ==> map( {"VULGAR FRACTION " ~ $^þ } )                         # (2) Converts to Unicode name 
    ==> grep({ .uniparse })                                        # (3) Filters only real names 
    ==> map( { .uniparse} );                                       # (4) Converts to unicode 
);
```

For illustration, method chaining equivalent, read top-to-bottom, using the same sequence as above

```Perl6
my @result = ( <TWO THREE FOUR FIVE SEVEN> »~» " " X~ <FIFTHS SIXTHS EIGHTHS>)
    .map( {"VULGAR FRACTION " ~ $^þ } )
    .grep({ .uniparse })
    .map({ .uniparse });
```

Although in this particular case the result is the same, the feed operator `==>` more clearly shows intent with arrow pointing in the direction of the data flow. To assign without the need of parentheses use another feed operator

```Perl6
my @result;
<people of earth>
    ==> map({ .tc })
    ==> grep /<[PE]>/
    ==> sort()
    ==> @result;
```

It can be useful to capture a partial result, however, unlike the leftward feed operator, it does require parentheses or a semicolon

```Perl6
my @result;
<people of earth>
    ==> map({ .tc })
    ==> my @caps; @caps   # also could wrap in parentheses instead 
    ==> grep /<[PE]>/
    ==> sort()
    ==> @result;
```

The feed operator lets you construct method-chaining-like patterns out of routines and the results of methods on unrelated data. In method-chaining, you are restricted to the methods available on the data or the result of previous method call. With feed operators, that restriction is gone. The resulting code could also be seen to be more readable than a series of method calls broken over multiple lines.

Note: In the future, this operator will see some change as it gains the ability to run list operations in parallel. It will enforce that the **left** operand is enclosable as a closure (that can be cloned and run in a subthread).

<a id="infix--31"></a>
## infix `<==`

This leftward feed operator takes the result from the right and passes it to the previous (left) routine as the last parameter. This elucidates the right-to-left dataflow for a series of list manipulating functions.

```Perl6
# Traditional structure, read bottom-to-top 
my @result =
    sort                   # (4) Sort, result is <Earth People> 
    grep { /<[PE]>/ },     # (3) Look for P or E 
    map { .tc },           # (2) Capitalize the words 
    <people of earth>;     # (1) Start with the input 
 
# Feed (right-to-left) with parentheses, read bottom-to-top 
my @result = (
    sort()                 # (4) Sort, result is <Earth People> 
    <== grep({ /<[PE]>/ }) # (3) Look for P or E 
    <== map({ .tc })       # (2) Capitalize the words 
    <== <people of earth>  # (1) Start with the input 
);
 
# To assign without parentheses, use another feed operator 
my @result
    <== sort()              # (4) Sort, result is <Earth People> 
    <== grep({ /<[PE]>/ })  # (3) Look for P or E 
    <== map({ .tc })        # (2) Capitalize the words 
    <== <people of earth>;  # (1) Start with the input 
 
# It can be useful to capture a partial result 
my @result
    <== sort()
    <== grep({ /<[PE]>/ })
    <== my @caps            # unlike ==>, there's no need for additional statement
    <== map({ .tc })
    <== <people of earth>;
```

Unlike the rightward feed operator, the result is not closely mappable to method-chaining. However, compared to the traditional structure above where each argument is separated by a line, the resulting code is more demonstrative than commas. The leftward feed operator also allows you to "break into" the statement and capture an intermediary result which can be extremely useful for debugging or to take that result and create another variation on the final result.

Note: In the future, this operator will see some change as it gains the ability to run list operations in parallel. It will enforce that the **right** operand is enclosable as a closure (that can be cloned and run in a subthread).

<a id="identity"></a>
# Identity

In general, infix operators can be applied to a single or no element without yielding an error, generally in the context of a [reduce](https://docs.perl6.org/routine/reduce) operation.

```Perl6
say [-] ()  # OUTPUT: «0␤»
```

The design documents specify that this should return [an identity value](https://en.wikipedia.org/wiki/Identity_element), and that an identity value [must be specified for every operator](http://design.perl6.org/S03.html#Reduction_operators). In general, the identity element returned should be intuitive. However, here is a table that specifies how it is defined for operator classes in Perl 6, which corresponds to the table in the above definition in the types and operators defined by the language:

| Operator class | Identity value          |
| -------------- | ----------------------- |
| Equality       | Bool::True              |
| Arithmetic +   | 0                       |
| Arithmetic *   | 1                       |
| Comparison     | True                    |
| Bitwise        | 0                       |
| Stringy        | ''                      |
| Sets           | Empty set or equivalent |
| Or-like Bool   | False                   |
| And-like Bool  | True                    |

For instance, union of an empty list will return an empty set:

```Perl6
say [∪];  # OUTPUT: «set()␤»
```

This only applies to operators where empty or 0 is always a valid operand. For instance, applying it to division will yield an exception.

```Perl6
say [%] ();  # OUTPUT: «(exit code 1) No zero-arg meaning for infix:<%>␤ 
```
