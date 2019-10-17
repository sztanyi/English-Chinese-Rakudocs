原文：https://rakudocs.github.io/language/operators

# 运算符 / Operators

常见的 Raku 中缀、前缀、后缀运算符等等！

Common Raku infixes, prefixes, postfixes, and more!

有关如何定义新运算符，请参见[创建运算符](https://rakudocs.github.io/language/optut)。

See [creating operators](https://rakudocs.github.io/language/optut) on how to define new operators.
<!-- MarkdownTOC -->

- [运算符优先级 / Operator precedence](#%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--operator-precedence)
- [运算符分类 / Operator classification](#%E8%BF%90%E7%AE%97%E7%AC%A6%E5%88%86%E7%B1%BB--operator-classification)
- [元运算符 / Metaoperators](#%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6--metaoperators)
- [替换运算符 / Substitution operators](#%E6%9B%BF%E6%8D%A2%E8%BF%90%E7%AE%97%E7%AC%A6--substitution-operators)
    - [`s///` 就地替换 - `s///` in-place substitution](#s-%E5%B0%B1%E5%9C%B0%E6%9B%BF%E6%8D%A2---s-in-place-substitution)
    - [`S///` 非破坏性替换 - `S///` non-destructive substitution](#s-%E9%9D%9E%E7%A0%B4%E5%9D%8F%E6%80%A7%E6%9B%BF%E6%8D%A2---s-non-destructive-substitution)
    - [`tr///` 就地转写 - `tr///` in-place transliteration](#tr-%E5%B0%B1%E5%9C%B0%E8%BD%AC%E5%86%99---tr-in-place-transliteration)
    - [`TR///` 非破坏性转写 - `TR///` non-destructive transliteration](#tr-%E9%9D%9E%E7%A0%B4%E5%9D%8F%E6%80%A7%E8%BD%AC%E5%86%99---tr-non-destructive-transliteration)
- [赋值运算符 / Assignment operators](#%E8%B5%8B%E5%80%BC%E8%BF%90%E7%AE%97%E7%AC%A6--assignment-operators)
- [否定关系型运算符 / Negated relational operators](#%E5%90%A6%E5%AE%9A%E5%85%B3%E7%B3%BB%E5%9E%8B%E8%BF%90%E7%AE%97%E7%AC%A6--negated-relational-operators)
- [反转运算符 / Reversed operators](#%E5%8F%8D%E8%BD%AC%E8%BF%90%E7%AE%97%E7%AC%A6--reversed-operators)
- [超运算符 / Hyper operators](#%E8%B6%85%E8%BF%90%E7%AE%97%E7%AC%A6--hyper-operators)
- [归约元运算符 / Reduction metaoperators](#%E5%BD%92%E7%BA%A6%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6--reduction-metaoperators)
- [交叉运算符 / Cross operators](#%E4%BA%A4%E5%8F%89%E8%BF%90%E7%AE%97%E7%AC%A6--cross-operators)
- [Zip 元运算符 / Zip metaoperator](#zip-%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6--zip-metaoperator)
- [序列运算符 / Sequential operators](#%E5%BA%8F%E5%88%97%E8%BF%90%E7%AE%97%E7%AC%A6--sequential-operators)
- [元运算符的嵌套 / Nesting of metaoperators](#%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6%E7%9A%84%E5%B5%8C%E5%A5%97--nesting-of-metaoperators)
- [术语优先级 / Term precedence](#%E6%9C%AF%E8%AF%AD%E4%BC%98%E5%85%88%E7%BA%A7--term-precedence)
    - [术语 `` / term ``](#%E6%9C%AF%E8%AF%AD--term-)
    - [术语 `( )` / term `( )`](#%E6%9C%AF%E8%AF%AD----term--)
    - [术语 `{ }` term `{ }`](#%E6%9C%AF%E8%AF%AD---term--)
    - [环缀运算符 `[ ]` / circumfix `[ ]`](#%E7%8E%AF%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6----circumfix--)
- [术语 / Terms](#%E6%9C%AF%E8%AF%AD--terms)
- [方法后缀优先级 / Method postfix precedence](#%E6%96%B9%E6%B3%95%E5%90%8E%E7%BC%80%E4%BC%98%E5%85%88%E7%BA%A7--method-postfix-precedence)
    - [后环缀运算符 `[ ]` / postcircumfix `[ ]`](#%E5%90%8E%E7%8E%AF%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6----postcircumfix--)
    - [后环缀运算符 `{ }` / postcircumfix `{ }`](#%E5%90%8E%E7%8E%AF%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6----postcircumfix---1)
    - [后环缀运算符 `` / postcircumfix ``](#%E5%90%8E%E7%8E%AF%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6--postcircumfix-)
    - [后环缀运算符 `` / postcircumfix ``](#%E5%90%8E%E7%8E%AF%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6--postcircumfix--1)
    - [后环缀运算符 `« »` / postcircumfix `« »`](#%E5%90%8E%E7%8E%AF%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%C2%AB-%C2%BB--postcircumfix-%C2%AB-%C2%BB)
    - [后环缀运算符 `( )` / postcircumfix `( )`](#%E5%90%8E%E7%8E%AF%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6----postcircumfix---2)
    - [方法运算符 `.` / methodop `.`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop-)
    - [方法运算符 `.&` / methodop `.&`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--1)
    - [方法运算符 `.=` / methodop `.=`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--2)
    - [方法运算符 `.^` / methodop `.^`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6-%5E--methodop-%5E)
    - [方法运算符 `.?` / methodop `.?`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--3)
    - [方法运算符 `.+` / methodop `.+`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--4)
    - [方法运算符 `.*` / methodop `.*`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--5)
    - [方法运算符 `».` / `>>.` - methodop `».` / methodop `>>.`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6-%C2%BB-----methodop-%C2%BB--methodop-)
    - [方法运算符 `.postfix` / `.postcircumfix` - methodop `.postfix` / `.postcircumfix`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6-postfix--postcircumfix---methodop-postfix--postcircumfix)
    - [方法运算符 `.:` / methodop `.:`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--6)
    - [方法运算符 `.::` / methodop `.::`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--7)
    - [方法运算符 `,=` / postfix `,=`](#%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---postfix-)
- [自增运算符优先级 / Autoincrement precedence](#%E8%87%AA%E5%A2%9E%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--autoincrement-precedence)
    - [前缀运算符 `++` / prefix `++`](#%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---prefix-)
    - [前缀运算符 `--` / prefix `--`](#%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-----prefix---)
    - [前缀运算符 `++` / prefix `++`](#%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---prefix--1)
    - [后缀运算符 `--` / postfix `--`](#%E5%90%8E%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-----postfix---)
- [指数优先级 / Exponentiation precedence](#%E6%8C%87%E6%95%B0%E4%BC%98%E5%85%88%E7%BA%A7--exponentiation-precedence)
    - [中缀运算符 `**` / infix `**`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix-)
- [一元运算符优先级 / Symbolic unary precedence](#%E4%B8%80%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--symbolic-unary-precedence)
    - [前缀运算符 `?` / prefix `?`](#%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---prefix--2)
    - [前缀运算符 `!` / prefix `!`](#%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---prefix--3)
    - [前缀运算符 `+` / prefix `+`](#%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---prefix--4)
    - [前缀运算符 `-` / prefix `-`](#%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6----prefix--)
    - [前缀运算符 `~` / prefix `~`](#%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7E--prefix-%7E)
    - [前缀运算符 `|` / prefix `|`](#%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7C--prefix-%7C)
    - [前缀运算符 `+^` / prefix `+^`](#%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E--prefix-%5E)
    - [前缀运算符 `~^` / prefix `~^`](#%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7E%5E--prefix-%7E%5E)
    - [前缀运算符 `?^` / prefix `?^`](#%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E--prefix-%5E-1)
    - [前缀运算符 `^` / prefix `^`](#%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E--prefix-%5E-2)
- [带点中缀运算符优先级 / Dotty infix precedence](#%E5%B8%A6%E7%82%B9%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--dotty-infix-precedence)
    - [中缀运算符 `.=` / infix `.=`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--1)
    - [中缀运算符 `.` / infix `.`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--2)
- [乘法优先级 / Multiplicative precedence](#%E4%B9%98%E6%B3%95%E4%BC%98%E5%85%88%E7%BA%A7--multiplicative-precedence)
    - [中缀运算符 `*` / infix `*`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--3)
    - [中缀运算符 `/` - infix `/`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6----infix-)
    - [中缀运算符 `div` / infix `div`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-div--infix-div)
    - [中缀运算符 `%` / infix `%`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%25--infix-%25)
    - [中缀运算符 `%%` / infix `%%`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%25%25--infix-%25%25)
    - [中缀运算符 `mod` / infix `mod`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-mod--infix-mod)
    - [中缀运算符 `+&` / infix `+&`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--4)
    - [中缀运算符 `+<` / infix `+<`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--5)
    - [中缀运算符 `+>` / infix `+>`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--6)
    - [中缀运算符 `~&` / infix `~&`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7E--infix-%7E)
    - [中缀运算符 `~<` / infix `~<`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7E--infix-%7E-1)
    - [中缀运算符 `~>` / infix `~>`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7E--infix-%7E-2)
    - [中缀运算符 `gcd` / infix `gcd`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-gcd--infix-gcd)
    - [中缀运算符 `lcm` / infix `lcm`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-lcm--infix-lcm)
- [加法优先级 / Additive precedence](#%E5%8A%A0%E6%B3%95%E4%BC%98%E5%85%88%E7%BA%A7--additive-precedence)
    - [中缀运算符 `+` / infix `+`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--7)
    - [中缀运算符 `-` / infix `-`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6----infix--)
    - [中缀运算符 `+|` / infix `+|`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7C--infix-%7C)
    - [中缀运算符 `+^` / infix `+^`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E--infix-%5E)
    - [中缀运算符 `~|` / infix `~|`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7E%7C--infix-%7E%7C)
    - [中缀运算符 `~^` / infix `~^`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7E%5E--infix-%7E%5E)
    - [中缀运算符 `?^` / infix `?^`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E--infix-%5E-1)
    - [中缀运算符 `?|` / infix `?|`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7C--infix-%7C-1)
- [复制运算符优先级 / Replication precedence](#%E5%A4%8D%E5%88%B6%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--replication-precedence)
    - [中缀运算符 `x` / infix `x`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-x--infix-x)
    - [中缀运算符 `xx` / infix `xx`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-xx--infix-xx)
- [连接操作符 / Concatenation](#%E8%BF%9E%E6%8E%A5%E6%93%8D%E4%BD%9C%E7%AC%A6--concatenation)
    - [中缀运算符 `~` / infix `~`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7E--infix-%7E-3)
    - [中缀运算符 `∘` / infix `∘`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%88%98--infix-%E2%88%98)
- [Junction 与运算符优先级 / Junctive AND \(all\) precedence](#junction-%E4%B8%8E%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--junctive-and-all-precedence)
    - [中缀运算符 `&` / infix `&`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--8)
    - [中缀运算符 `(&)`, 中缀运算符 `∩` / infix `(&)`, infix `∩`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6--%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%88%A9--infix--infix-%E2%88%A9)
    - [中缀运算符 `(.)`， 中缀运算符 `⊍` / infix `(.)`, infix `⊍`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%EF%BC%8C-%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%8D--infix--infix-%E2%8A%8D)
- [Junction 或运算符优先级 / Junctive OR \(any\) precedence](#junction-%E6%88%96%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--junctive-or-any-precedence)
    - [中缀运算符 `|` / infix `|`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7C--infix-%7C-2)
    - [中缀运算符 `(|)`，中缀运算符 `∪` / infix `(|)`, infix `∪`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7C%EF%BC%8C%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%88%AA--infix-%7C-infix-%E2%88%AA)
    - [中缀运算符 `(+)`，中缀运算符 `⊎` / infix `(+)`, infix `⊎`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%EF%BC%8C%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%8E--infix--infix-%E2%8A%8E)
    - [中缀运算符 `(-)`，中缀运算符 `∖` / infix `(-)`, infix `∖`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6--%EF%BC%8C%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%88%96--infix---infix-%E2%88%96)
    - [中缀运算符 `(^)` / infix `^`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E--infix-%5E-2)
    - [中缀运算符 `(^)`，中缀运算符 `⊖` / infix `(^)`, infix `⊖`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E%EF%BC%8C%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%96--infix-%5E-infix-%E2%8A%96)
- [命名一元运算符优先级 / Named unary precedence](#%E5%91%BD%E5%90%8D%E4%B8%80%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--named-unary-precedence)
    - [前缀运算符 `temp` / prefix `temp`](#%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-temp--prefix-temp)
    - [前缀运算符 `let` / prefix `let`](#%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-let--prefix-let)
- [非链式二元运算符优先级 / Nonchaining binary precedence](#%E9%9D%9E%E9%93%BE%E5%BC%8F%E4%BA%8C%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--nonchaining-binary-precedence)
    - [中缀运算符 `does` / infix `does`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-does--infix-does)
    - [中缀运算符 `but` / infix `but`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-but--infix-but)
    - [中缀运算符 `cmp` / infix `cmp`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-cmp--infix-cmp)
    - [中缀运算符 `coll` / infix `coll`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-coll--infix-coll)
    - [中缀运算符 `unicmp` / infix `unicmp`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-unicmp--infix-unicmp)
    - [中缀运算符 `leg` / infix `leg`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-leg--infix-leg)
    - [中缀运算符 `` / infix ``](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6--infix-)
    - [中缀运算符 `..` / infix `..`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--9)
    - [中缀运算符 `..^` / infix `..^`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E--infix-%5E-3)
    - [中缀运算符 `^..` / infix `^..`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E--infix-%5E-4)
    - [中缀运算符 `^..^` / infix `^..^`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E%5E--infix-%5E%5E)
- [链式二元运算符优先级 / Chaining binary precedence](#%E9%93%BE%E5%BC%8F%E4%BA%8C%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--chaining-binary-precedence)
    - [中缀运算符 `==` / infix `==`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--10)
    - [中缀运算符 `!=` / infix `!=`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--11)
    - [中缀运算符 `≠` / infix `≠`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%89%A0--infix-%E2%89%A0)
    - [中缀运算符 `<` / infix `<`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--12)
    - [中缀运算符 `<=` / infix `<=`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--13)
    - [中缀运算符 `≤` / infix `≤`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%89%A4--infix-%E2%89%A4)
    - [中缀运算符 `>` / infix `>`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--14)
    - [中缀运算符 `>=` / infix `>=`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--15)
    - [中缀运算符 `≥` / infix `≥`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%89%A5--infix-%E2%89%A5)
    - [中缀运算符 `eq` / infix `eq`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-eq--infix-eq)
    - [中缀运算符 `ne` / infix `ne`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-ne--infix-ne)
    - [中缀运算符 `gt` / infix `gt`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-gt--infix-gt)
    - [中缀运算符 `ge` / infix `ge`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-ge--infix-ge)
    - [中缀运算符 `lt` / infix `lt`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-lt--infix-lt)
    - [中缀运算符 `le` / infix `le`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-le--infix-le)
    - [中缀运算符 `before` / infix `before`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-before--infix-before)
    - [中缀运算符 `after` / infix `after`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-after--infix-after)
    - [中缀运算符 `eqv` / infix `eqv`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-eqv--infix-eqv)
    - [中缀运算符 `===` / infix `===`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--16)
    - [中缀运算符 `=:=` / infix `=:=`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--17)
    - [中缀运算符 `~~` / infix `~~`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7E%7E--infix-%7E%7E)
    - [中缀运算符 `=~=` / infix `=~=`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7E--infix-%7E-4)
    - [中缀运算符 \(elem\)，中缀运算符 ∈» / infix \(elem\), infix ∈»](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-elem%EF%BC%8C%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%88%88%C2%BB--infix-elem-infix-%E2%88%88%C2%BB)
    - [中缀运算符 `∉` / infix `∉`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%88%89--infix-%E2%88%89)
    - [中缀运算符 \(cont\)，中缀运算符 ∋» / infix \(cont\), infix ∋»](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-cont%EF%BC%8C%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%88%8B%C2%BB--infix-cont-infix-%E2%88%8B%C2%BB)
    - [中缀运算符 `∌` / infix `∌`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%88%8C--infix-%E2%88%8C)
    - [中缀运算符 `(<)`, 中缀运算符 `⊂` / infix `(<)`, infix `⊂`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6--%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%82--infix--infix-%E2%8A%82)
    - [中缀运算符 `⊄` / infix `⊄`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%84--infix-%E2%8A%84)
    - [中缀运算符 `(<=)`, 中缀运算符 `⊆` / infix `(<=)`, infix `⊆`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6--%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%86--infix--infix-%E2%8A%86)
    - [中缀运算符 `⊈` / infix `⊈`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%88--infix-%E2%8A%88)
    - [中缀运算符 `(>)`, 中缀运算符  `⊃` / infix `(>)`, infix `⊃`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6--%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%83--infix--infix-%E2%8A%83)
    - [中缀运算符 `⊅` / infix `⊅`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%85--infix-%E2%8A%85)
    - [中缀运算符 `(>=)`，中缀运算符 `⊇` / infix `(>=)`, infix `⊇`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%EF%BC%8C%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%87--infix--infix-%E2%8A%87)
    - [中缀运算符 `⊉` / infix `⊉`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%89--infix-%E2%8A%89)
- [逻辑与操作符优先级 / Tight AND precedence](#%E9%80%BB%E8%BE%91%E4%B8%8E%E6%93%8D%E4%BD%9C%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--tight-and-precedence)
    - [中缀运算符 `&&` / infix `&&`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--18)
- [逻辑或操作符优先级 / Tight OR precedence](#%E9%80%BB%E8%BE%91%E6%88%96%E6%93%8D%E4%BD%9C%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--tight-or-precedence)
    - [中缀运算符 `||` / infix `||`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7C%7C--infix-%7C%7C)
    - [中缀运算符 `^^` / infix `^^`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E%5E--infix-%5E%5E-1)
    - [中缀运算符 `//` / infix `//`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--19)
    - [中缀运算符 `min` / infix `min`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-min--infix-min)
    - [中缀运算符 `max` / infix `max`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-max--infix-max)
    - [中缀运算符 `minmax` / infix `minmax`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-minmax--infix-minmax)
- [条件运算符优先级 / Conditional operator precedence](#%E6%9D%A1%E4%BB%B6%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--conditional-operator-precedence)
    - [中缀运算符  `?? !!` / infix `?? !!`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6----infix---1)
    - [中缀运算符  `ff` / infix `ff`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-ff--infix-ff)
    - [中缀运算符  `^ff` / infix `^ff`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5Eff--infix-%5Eff)
    - [中缀运算符  `ff^` / infix `ff^`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-ff%5E--infix-ff%5E)
    - [中缀运算符  `^ff^` / infix `^ff^`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5Eff%5E--infix-%5Eff%5E)
    - [中缀运算符  `fff` / infix `fff`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-fff--infix-fff)
    - [中缀运算符  `^fff` / infix `^fff`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5Efff--infix-%5Efff)
    - [中缀运算符 `fff^` / infix `fff^`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-fff%5E--infix-fff%5E)
    - [中缀运算符  `^fff^` / infix `^fff^`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5Efff%5E--infix-%5Efff%5E)
- [项目赋值运算符优先级 / Item assignment precedence](#%E9%A1%B9%E7%9B%AE%E8%B5%8B%E5%80%BC%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--item-assignment-precedence)
    - [中缀运算符 `=` / infix `=`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--20)
    - [中缀运算符 `=>` / infix `=>`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--21)
- [松散的一元运算符优先权 / Loose unary precedence](#%E6%9D%BE%E6%95%A3%E7%9A%84%E4%B8%80%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E6%9D%83--loose-unary-precedence)
    - [前缀运算符 `not` / prefix `not`](#%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-not--prefix-not)
    - [前缀运算符 `so` / prefix `so`](#%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-so--prefix-so)
- [逗号运算符优先级 / Comma operator precedence](#%E9%80%97%E5%8F%B7%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--comma-operator-precedence)
    - [中缀运算符 `,` / infix `,`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--22)
    - [中缀运算符 `:` / infix `:`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--23)
- [列表中缀运算符优先级 / List infix precedence](#%E5%88%97%E8%A1%A8%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--list-infix-precedence)
    - [中缀运算符 `Z` / infix `Z`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-z--infix-z)
    - [中缀运算符 `X` / infix `X`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-x--infix-x-1)
    - [中缀运算符 `...` / infix `...`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--24)
- [列表前缀优先级 / List prefix precedence](#%E5%88%97%E8%A1%A8%E5%89%8D%E7%BC%80%E4%BC%98%E5%85%88%E7%BA%A7--list-prefix-precedence)
    - [中缀运算符 `=` / infix `=`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--25)
    - [中缀运算符 `:=` / infix `:=`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--26)
    - [中缀运算符 `::=` / infix `::=`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--27)
    - [列表运算符 `...` / listop `...`](#%E5%88%97%E8%A1%A8%E8%BF%90%E7%AE%97%E7%AC%A6---listop-)
    - [列表运算符 `!!!` / listop `!!!`](#%E5%88%97%E8%A1%A8%E8%BF%90%E7%AE%97%E7%AC%A6---listop--1)
    - [列表运算符 `???` / listop `???`](#%E5%88%97%E8%A1%A8%E8%BF%90%E7%AE%97%E7%AC%A6---listop--2)
    - [归约运算符 / Reduction operators](#%E5%BD%92%E7%BA%A6%E8%BF%90%E7%AE%97%E7%AC%A6--reduction-operators)
- [宽松的与运算符优先级 / Loose AND precedence](#%E5%AE%BD%E6%9D%BE%E7%9A%84%E4%B8%8E%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--loose-and-precedence)
    - [中缀运算符 `and` / infix `and`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-and--infix-and)
    - [中缀运算符 `andthen` / infix `andthen`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-andthen--infix-andthen)
    - [中缀运算符 `notandthen` / infix `notandthen`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-notandthen--infix-notandthen)
- [宽松的或运算符优先级 / Loose OR precedence](#%E5%AE%BD%E6%9D%BE%E7%9A%84%E6%88%96%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--loose-or-precedence)
    - [中缀运算符 `or` / infix `or`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-or--infix-or)
    - [中缀运算符 `orelse` / infix `orelse`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-orelse--infix-orelse)
    - [中缀运算符 `xor` / infix `xor`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-xor--infix-xor)
- [序列器优先级 / Sequencer precedence](#%E5%BA%8F%E5%88%97%E5%99%A8%E4%BC%98%E5%85%88%E7%BA%A7--sequencer-precedence)
    - [中缀运算符 `==>` / infix `==>`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--28)
    - [中缀运算符 `<==` / infix `<==`](#%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--29)
- [标识 / Identity](#%E6%A0%87%E8%AF%86--identity)

<!-- /MarkdownTOC -->

<a id="%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--operator-precedence"></a>
# 运算符优先级 / Operator precedence

在像 `1 + 2 * 3` 这样的表达式中，首先计算 `2 * 3`，因为中缀运算符 `*` 比 `+` 具有更高的**优先级**。

In an expression like `1 + 2 * 3`, the `2 * 3` is evaluated first because the infix `*` has tighter **precedence** than the `+`.

下表总结了 Raku 中从最高到最低的优先级：

The following table summarizes the precedence levels in Raku, from tightest to loosest:

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

在下面的运算符描述中，假定默认为*左*结合。

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

每个运算符（方法运算符除外）也可用作子例程。例程的名称由运算符类别构成，后跟冒号，然后是由运算符符号和列表引号构成：

Each operator (except method operators) is also available as a subroutine. The name of the routine is formed from the operator category, followed by a colon, then a list quote construct with the symbol(s) that make up the operator:

```Raku
infix:<+>(1, 2);                # same as 1 + 2 
circumfix:«[ ]»(<a b c>);       # same as [<a b c>]
```

作为特殊情况，列表运算符可以作为一个术语或前缀。子例程调用是最常见的列表运算符。其他情况还包括元归约中缀运算符（`[+]1、2、3`）和[前缀 ...](https://rakudocs.github.io/language/operators#prefix_...) 等存根运算符。

As a special case, a *listop* (list operator) can stand either as a term or as a prefix. Subroutine calls are the most common listops. Other cases include meta-reduced infix operators (`[+] 1, 2, 3`) and the [prefix ...](https://rakudocs.github.io/language/operators#prefix_...) etc. stub operators.

定义自定义运算符在文档[定义运算符函数](https://rakudocs.github.io/language/functions#Defining_operators)中会介绍。

Defining custom operators is covered in [Defining operators functions](https://rakudocs.github.io/language/functions#Defining_operators).

<a id="%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6--metaoperators"></a>
# 元运算符 / Metaoperators

元运算符可以与其他运算符或子例程一起参数化，就像函数可以将函数作为参数一样。要使用子例程作为参数，请在其名称前加上 `&`。Raku 将在后台生成实际的组合运算符，允许将该机制应用于用户定义的运算符。要消除链式元运算符的歧义，请将内部运算符括在方括号中。接下来，我们将介绍一些具有不同语义的元运算符。

Metaoperators can be parameterized with other operators or subroutines in the same way as functions can take functions as parameters. To use a subroutine as a parameter, prefix its name with a `&`. Raku will generate the actual combined operator in the background, allowing the mechanism to be applied to user defined operators. To disambiguate chained metaoperators, enclose the inner operator in square brackets. There are quite a few metaoperators with different semantics as explained, next.

<a id="%E6%9B%BF%E6%8D%A2%E8%BF%90%E7%AE%97%E7%AC%A6--substitution-operators"></a>
# 替换运算符 / Substitution operators

每个替换运算符分为两种主要形式：小写形式（例如，`s///`）执行*就地*（即*破坏性*）替换行为；大写形式（例如，`S///`）提供*非破坏性*行为。

Each substitution operator comes into two main forms: a lowercase one (e.g., `s///`) that performs *in-place* (i.e., *destructive* behavior; and an uppercase form (e.g., `S///`) that provides a *non-destructive* behavior.

<a id="s-%E5%B0%B1%E5%9C%B0%E6%9B%BF%E6%8D%A2---s-in-place-substitution"></a>
## `s///` 就地替换 - `s///` in-place substitution

```Raku
my $str = 'old string';
$str ~~ s/o .+ d/new/;
say $str; # OUTPUT: «new string␤»
```

`s///` 对 `$_` 主题变量进行操作，就地更改。它使用给定的 [`Regex`](https://rakudocs.github.io/type/Regex) 查找要替换的部分，并将其更改为提供的替换字符串。将 `$/` 设置为 [`Match`](https://rakudocs.github.io/type/Match) 对象，或者，如果进行了多个匹配，则设置为一组 `Match` 对象的。返回值为 `$/`。

`s///` operates on the `$_` topical variable, changing it in place. It uses the given [`Regex`](https://rakudocs.github.io/type/Regex) to find portions to replace and changes them to the provided replacement string. Sets `$/` to the [`Match`](https://rakudocs.github.io/type/Match) object or, if multiple matches were made, a [`List`](https://rakudocs.github.io/type/List) of `Match` objects. Returns `$/`.

通常将此运算符与 `~~` 智能匹配运算符一起使用，因为它将 `$_` 设置为左侧的别名 ，而 `s///` 使用 `$_`。

It's common to use this operator with the `~~` smartmatch operator, as it aliases left-hand side to `$_`, which `s///` uses.

正则捕获可以在替换部分中引用；它使用与 [`.subst` 方法](https://rakudocs.github.io/routine/subst)相同的副词，这些副词位于 `s` 和开头的 `/` 之间，用可选空格分隔：

Regex captures can be referenced in the replacement part; it takes the same adverbs as the [`.subst` method](https://rakudocs.github.io/routine/subst), which go between the `s` and the opening `/`, separated with optional whitespace:

```Raku
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

```Raku
my $str = 'foober';
$str ~~ s!foo!fox!;
$str ~~ s{b(.)r} = " d$0n";
say $str; # OUTPUT: «fox den␤»
```

非成对字符可以简单地替换原来的斜杠。成对的字符，如大括号，只在匹配部分使用，替换部分以赋值（任何东西：字符串、例程调用等）的形式给出。

Non-paired characters can simply replace the original slashes. Paired characters, like curly braces, are used only on the match portion, with the substitution given by assignment (of anything: a string, a routine call, etc.).

<a id="s-%E9%9D%9E%E7%A0%B4%E5%9D%8F%E6%80%A7%E6%9B%BF%E6%8D%A2---s-non-destructive-substitution"></a>
## `S///` 非破坏性替换 - `S///` non-destructive substitution

```Raku
say S/o .+ d/new/ with 'old string';      # OUTPUT: «new string␤» 
S:g/« (.)/$0.uc()/.say for <foo bar ber>; # OUTPUT: «Foo␤Bar␤Ber␤»
```

`S///` 使用与 `s///` 运算符相同的语义，只是它保留原始字符串不变，*返回运算结果字符串*而不是 `$/`（`$/` 仍设置为与 `s///` 相同的值）。

`S///` uses the same semantics as the `s///` operator, except it leaves the original string intact and *returns the resultant string* instead of `$/` (`$/` still being set to the same values as with `s///`).

**注意：**由于结果是作为返回值获得的，因此将此运算符与 `~~ ` 智能匹配运算符一起使用是错误的，并将发出警告。若要对不是此运算符使用的 `$_` 变量执行替换，请使用 `given`、`with`，或任何其他方式将其别名设置为 `$_`。或者，使用 [`.subst` 方法](https://rakudocs.github.io/routine/subst)。

**Note:** since the result is obtained as a return value, using this operator with the `~~` smartmatch operator is a mistake and will issue a warning. To execute the substitution on a variable that isn't the `$_` this operator uses, alias it to `$_` with `given`, `with`, or any other way. Alternatively, use the [`.subst` method](https://rakudocs.github.io/routine/subst).

<a id="tr-%E5%B0%B1%E5%9C%B0%E8%BD%AC%E5%86%99---tr-in-place-transliteration"></a>
## `tr///` 就地转写 - `tr///` in-place transliteration

```Raku
my $str = 'old string';
$str ~~ tr/dol/wne/;
say $str; # OUTPUT: «new string␤»
```

`tr///` 对 `$_` 主题变量进行操作并对其进行就地变更。它的行为类似于使用单个 [Pair](https://rakudocs.github.io/type/Pair) 参数调用的 [`Str.trans`](https://rakudocs.github.io/routine/trans)，其中键是匹配部分（上面示例中的字符 `dol`），值是替换部分（上面示例中的字符 `wne`）。接受与 [`Str.trans`](https://rakudocs.github.io/routine/trans) 相同的副词。返回 [StrDistance](https://rakudocs.github.io/type/StrDistance) 对象，该对象测量原始值与返回结果字符串之间的距离。

`tr///` operates on the `$_` topical variable and changes it in place. It behaves similar to [`Str.trans`](https://rakudocs.github.io/routine/trans) called with a single [Pair](https://rakudocs.github.io/type/Pair) argument, where key is the matching part (characters `dol` in the example above) and value is the replacement part (characters `wne` in the example above). Accepts the same adverbs as [`Str.trans`](https://rakudocs.github.io/routine/trans). Returns the [StrDistance](https://rakudocs.github.io/type/StrDistance) object that measures the distance between original value and the resultant string.

```Raku
my $str = 'old string';
$str ~~ tr:c:d/dol st//;
say $str; # OUTPUT: «ring␤»
```

<a id="tr-%E9%9D%9E%E7%A0%B4%E5%9D%8F%E6%80%A7%E8%BD%AC%E5%86%99---tr-non-destructive-transliteration"></a>
## `TR///` 非破坏性转写 - `TR///` non-destructive transliteration

```Raku
with 'old string' {
    say TR/dol/wne/; # OUTPUT: «new string␤» 
}
```

`TR///` 的行为与 `tr///` 运算符相同，只是它保持 `$_` 值不变，而是返回结果字符串。

`TR///` behaves the same as the `tr///` operator, except that it leaves the `$_` value untouched and instead returns the resultant string.

```Raku
say TR:d/dol // with 'old string'; # OUTPUT: «string␤»
```

<a id="%E8%B5%8B%E5%80%BC%E8%BF%90%E7%AE%97%E7%AC%A6--assignment-operators"></a>
# 赋值运算符 / Assignment operators

中缀运算符可以与赋值运算符组合，以修改值并一次性将结果应用于容器。如果可能的话，容器将被自动生动化。一些例子：

Infix operators can be combined with the assignment operator to modify a value and apply the result to a container in one go. Containers will be autovivified if possible. Some examples:

```Raku
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

```Raku
sub infix:<space-concat> ($a, $b) { $a ~ " " ~ $b };
my $a = 'word1';
$a space-concat= 'word2';     # RESULT: «'word1 word2'»
```

虽然不是严格意义上的运算符，但方法可以以相同的方式使用。

Although not strictly operators, methods can be used in the same fashion.

```Raku
my Real $a = 1/2;
$a = 3.14;
$a .= round;      # RESULT: «3»
```

<a id="%E5%90%A6%E5%AE%9A%E5%85%B3%E7%B3%BB%E5%9E%8B%E8%BF%90%E7%AE%97%E7%AC%A6--negated-relational-operators"></a>
# 否定关系型运算符 / Negated relational operators 

返回 `Bool` 的关系运算符的结果可以用前缀 `!` 否定。为避免与 `!!` 运算符的视觉混淆，不能修改已经以 `!` 开头的任何运算符.

The result of a relational operator returning `Bool` can be negated by prefixing with `!`. To avoid visual confusion with the `!!` operator, you may not modify any operator already beginning with `!`.

`!==` 和 `!eq` 的简写形式为 `!=` 和 `ne`。

There are shortcuts for `!==` and `!eq`, namely `!=` and `ne`.

```Raku
my $a = True;
say so $a != True;    # OUTPUT: «False␤» 
my $i = 10;
 
my $release = Date.new(:2015year, :12month, :24day);
my $today = Date.today;
say so $release !before $today;     # OUTPUT: «False␤»
```

<a id="%E5%8F%8D%E8%BD%AC%E8%BF%90%E7%AE%97%E7%AC%A6--reversed-operators"></a>
# 反转运算符 / Reversed operators 

任何中缀运算符将它的两个参数用前缀 `R` 反转调用。操作数的关联性也会反转。

Any infix operator may be called with its two arguments reversed by prefixing with `R`. Associativity of operands is reversed as well.

```Raku
say 4 R/ 12;               # OUTPUT: «3␤» 
say [R/] 2, 4, 16;         # OUTPUT: «2␤» 
say [RZ~] <1 2 3>,<4 5 6>  # OUTPUT: «(41 52 63)␤»
```

<a id="%E8%B6%85%E8%BF%90%E7%AE%97%E7%AC%A6--hyper-operators"></a>
# 超运算符 / Hyper operators

超运算符包括 `«` 和 `»`，以及它们的 ASCII 变体 `<<` 和 `>>`。它们对一个或两个列表应用由 `«` 和/或 `»` 括起来的给定运算符（对于一元运算符，在运算符前面或后面），返回结果列表，其中 `«` 或 `»` 的箭头部分指向较短的列表。单个元素会被转换为列表，因此也可以使用它们。如果其中一个列表短于另一个列表，则操作员将在较短列表上循环，直到处理完较长列表中的所有元素。

Hyper operators include `«` and `»`, with their ASCII variants `<<` and `>>`. They apply a given operator enclosed (or preceded or followed, in the case of unary operators) by `«` and/or `»` to one or two lists, returning the resulting list, with the pointy part of `«` or `»` aimed at the shorter list. Single elements are turned to a list, so they can be used too. If one of the lists is shorter than the other, the operator will cycle over the shorter list until all elements of the longer list are processed.

```Raku
say (1, 2, 3) »*» 2;          # OUTPUT: «(2 4 6)␤» 
say (1, 2, 3, 4) »~» <a b>;   # OUTPUT: «(1a 2b 3a 4b)␤» 
say (1, 2, 3) »+« (4, 5, 6);  # OUTPUT: «(5 7 9)␤» 
say (&sin, &cos, &sqrt)».(0.5);
# OUTPUT: «(0.479425538604203 0.877582561890373 0.707106781186548)␤»
```

最后一个示例演示了超运算符如何应用于后环缀运算符（在本例中为 .() ）。

The last example illustrates how postcircumfix operators (in this case .()) can also be hypered.

```Raku
my @a = <1 2 3>;
my @b = <4 5 6>;
say (@a,@b)»[1]; # OUTPUT: «(2 5)␤»
```

在本例中，超运算符应用于[后环缀运算符[]](https://rakudocs.github.io/language/operators#circumfix_[_])。

In this case, it's the [postcircumfix[]](https://rakudocs.github.io/language/operators#circumfix_[_]) which is being hypered.

赋值元运算符可以被超运算符化。

Assignment metaoperators can be *hyped*.

```Raku
my @a = 1, 2, 3;
say @a »+=» 1;    # OUTPUT: «[2 3 4]␤» 
my ($a, $b, $c);
(($a, $b), $c) «=» ((1, 2), 3);
say "$a, $c";       #  OUTPUT: «1, 3␤»
```

一元运算符的超级形式将尖端指向运算符，钝端指向待操作列表。

Hyper forms of unary operators have the pointy bit aimed at the operator and the blunt end at the list to be operated on.

```Raku
my @wisdom = True, False, True;
say !« @wisdom;     # OUTPUT: «[False True False]␤» 
 
my @a = 1, 2, 3;
@a»++;              # OUTPUT: «(2, 3, 4)␤»
```

超运算符在嵌套数组上是递归定义的。

Hyper operators are defined recursively on nested arrays.

```Raku
say -« [[1, 2], 3]; # OUTPUT: «[[-1 -2] -3]␤»
```

此外，可以以无序、并发的方式调用方法。结果列表将按顺序排列。请注意，所有超运算符都是并行运算的的候选人，但是如果这些方法有副作用，有你哭的时候。优化器完全控制超运算符，这就是用户无法定义它们的原因。

Also, methods can be called in an out of order, concurrent fashion. The resulting list will be in order. Note that all hyper operators are candidates for parallelism and will cause tears if the methods have side effects. The optimizer has full reign over hyper operators, which is the reason that they cannot be defined by the user.

```Raku
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

```Raku
my %outer = 1, 2, 3 Z=> <a b c>;
my %inner = 1, 2 Z=> <x z>;
say %outer «~» %inner;          # OUTPUT: «{"1" => "ax", "2" => "bz"}␤»
```

超运算符可以将用户定义的运算符作为其运算符参数。

Hyper operators can take user-defined operators as their operator argument.

```Raku
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

超运算符是否下放到子列表中取决于链的内部运算符的[节点性](https://rakudocs.github.io/language/typesystem#trait_is_nodal)。对于超方法调用运算符（».），目标方法的节点性是重要的。

Whether hyperoperators descend into child lists depends on the [nodality](https://rakudocs.github.io/language/typesystem#trait_is_nodal) of the inner operator of a chain. For the hyper method call operator (».), the nodality of the target method is significant.

```Raku
say (<a b>, <c d e>)».elems;        # OUTPUT: «(2 3)␤» 
say (<a b>, <c d e>)».&{ .elems };  # OUTPUT: «((1 1) (1 1 1))␤»
```

你可以将超级运算符链接起来，以对列表的列表进行解构。

You can chain hyper operators to destructure a List of Lists.

```Raku
my $neighbors = ((-1, 0), (0, -1), (0, 1), (1, 0));
my $p = (2, 3);
say $neighbors »>>+<<» ($p, *);   # OUTPUT: «((1 3) (2 2) (2 4) (3 3))␤»
```

<a id="%E5%BD%92%E7%BA%A6%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6--reduction-metaoperators"></a>
# 归约元运算符 / Reduction metaoperators

归约元运算符 `[]`，使用给定的中缀运算符归约一个列表。它给出的结果与 [reduce](https://rakudocs.github.io/routine/reduce) 例程相同-有关详细信息，请参见此处。

The reduction metaoperator, `[ ]`, reduces a list with the given infix operator. It gives the same result as the [reduce](https://rakudocs.github.io/routine/reduce) routine - see there for details.

```Raku
# These two are equivalent: 
say [+] 1, 2, 3;                # OUTPUT: «6␤» 
say reduce &infix:<+>, 1, 2, 3; # OUTPUT: «6␤»
```

方括号和运算符之间不允许有空格。要包装函数而不是运算符，请提供另一层方括号：

No whitespace is allowed between the square brackets and the operator. To wrap a function instead of an operator, provide an additional layer of square brackets:

```Raku
sub plus { $^a + $^b };
say [[&plus]] 1, 2, 3;          # OUTPUT: «6␤»
```

参数列表不展开即遍历。这意味着你可以将嵌套列表传递给列表中缀运算符的缩减形式：

The argument list is iterated without flattening. This means that you can pass a nested list to the reducing form of a list infix operator:

```Raku
say [X~] (1, 2), <a b>;         # OUTPUT: «(1a 1b 2a 2b)␤»
```

相当于 `1, 2 X~ <a b>`。

which is equivalent to `1, 2 X~ <a b>`.

默认情况下，只返回缩减的最终结果。在换行运算符前面加上 `\`，以返回所有中间值的惰性列表。这被称为“三角形减少”。如果非元部分已经包含一个 `\` 值，请用 `[]` 引用它（例如 `[\[\x]`）。

By default, only the final result of the reduction is returned. Prefix the wrapped operator with a `\`, to return a lazy list of all intermediate values instead. This is called a "triangular reduce". If the non-meta part contains a `\` already, quote it with `[]` (e.g. `[\[\x]]`).

```Raku
my @n = [\~] 1..*;
say @n[^5];         # OUTPUT: «(1 12 123 1234 12345)␤»
```

<a id="%E4%BA%A4%E5%8F%89%E8%BF%90%E7%AE%97%E7%AC%A6--cross-operators"></a>
# 交叉运算符 / Cross operators

交叉元运算符 `X` 将按交叉积的顺序对所有列表应用给定的中缀运算符，以便最右边的运算符变化最快。

The cross metaoperator, `X`, will apply a given infix operator in order of cross product to all lists, such that the rightmost operator varies most quickly.

```Raku
1..3 X~ <a b> # RESULT: «<1a, 1b, 2a, 2b, 3a, 3b>␤»
```

<a id="zip-%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6--zip-metaoperator"></a>
# Zip 元运算符 / Zip metaoperator 

zip 元运算符（它与 [Z](https://rakudocs.github.io/language/operators#infix_Z) 不同）将对从其参数中左、右各取一个元素组成的键值对应用给定的中缀运算符。返回结果列表。

The zip metaoperator (which is not the same thing as [Z](https://rakudocs.github.io/language/operators#infix_Z)) will apply a given infix operator to pairs taken one left, one right, from its arguments. The resulting list is returned.

```Raku
my @l = <a b c> Z~ 1, 2, 3;     # RESULT: «[a1 b2 c3]␤»
```

如果其中一个操作数过早用完元素，则 zip 运算符将停止。无限列表可用于重复元素。最后一个元素为 `*` 的列表将无限期地重复其最后第二个元素。

If one of the operands runs out of elements prematurely, the zip operator will stop. An infinite list can be used to repeat elements. A list with a final element of `*` will repeat its 2nd last element indefinitely.

```Raku
my @l = <a b c d> Z~ ':' xx *;  # RESULT: «<a: b: c: d:>» 
   @l = <a b c d> Z~ 1, 2, *;   # RESULT: «<a1 b2 c2 d2>»
```

如果未指定中缀运算符，则默认情况下将使用 `,`（逗号运算符）：

If an infix operator is not given, the `,` (comma operator) will be used by default:

```Raku
my @l = 1 Z 2;  # RESULT: «[(1 2)]»
```

<a id="%E5%BA%8F%E5%88%97%E8%BF%90%E7%AE%97%E7%AC%A6--sequential-operators"></a>
# 序列运算符 / Sequential operators 

序列元运算符 `S` 将禁止优化器执行任何并发或重新排序。支持大多数简单的中缀运算符。

The sequential metaoperator, `S`, will suppress any concurrency or reordering done by the optimizer. Most simple infix operators are supported.

```Raku
say so 1 S& 2 S& 3;  # OUTPUT: «True␤»
```

<a id="%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6%E7%9A%84%E5%B5%8C%E5%A5%97--nesting-of-metaoperators"></a>
# 元运算符的嵌套 / Nesting of metaoperators

为了避免在链接元运算符时出现歧义，请使用方括号帮助编译器理解你。

To avoid ambiguity when chaining metaoperators, use square brackets to help the compiler understand you.

```Raku
my @a = 1, 2, 3;
my @b = 5, 6, 7;
@a X[+=] @b;
say @a;         # OUTPUT: «[19 20 21]␤»
```

<a id="%E6%9C%AF%E8%AF%AD%E4%BC%98%E5%85%88%E7%BA%A7--term-precedence"></a>
# 术语优先级 / Term precedence

<a id="%E6%9C%AF%E8%AF%AD--term-"></a>
## 术语 `< >` / term `< >`

引用词语构造将内容按空白分解，并返回单词的[列表](https://rakudocs.github.io/type/List)。如果一个单词看起来像数字字面量或键值对字面量，它将被转换为适当的数字。

The quote-words construct breaks up the contents on whitespace and returns a [List](https://rakudocs.github.io/type/List) of the words. If a word looks like a number literal or a `Pair` literal, it's converted to the appropriate number.

```Raku
say <a b c>[1];   # OUTPUT: «b␤»
```

<a id="%E6%9C%AF%E8%AF%AD----term--"></a>
## 术语 `( )` / term `( )`

分组运算符。

The grouping operator.

空组 `()` 创建一个[空列表](https://rakudocs.github.io/type/List#index-entry-()_empty_list)。非空表达式周围的括号只是简单地构造表达式，但没有附加的语义。

An empty group `()` creates an [empty list](https://rakudocs.github.io/type/List#index-entry-()_empty_list). Parentheses around non-empty expressions simply structure the expression, but do not have additional semantics.

在参数列表中，将括号放在参数周围可防止将其解释为命名参数。

In an argument list, putting parenthesis around an argument prevents it from being interpreted as a named argument.

```Raku
multi sub p(:$a!) { say 'named'      }
multi sub p($a)   { say 'positional' }
p a => 1;           # OUTPUT: «named␤» 
p (a => 1);         # OUTPUT: «positional␤»
```

<a id="%E6%9C%AF%E8%AF%AD---term--"></a>
## 术语 `{ }` term `{ }`

[代码块](https://rakudocs.github.io/type/Block) 或者[哈希](https://rakudocs.github.io/type/Hash)的构造器。

[Block](https://rakudocs.github.io/type/Block) or [Hash](https://rakudocs.github.io/type/Hash) constructor.

如果内容为空或者包含以[键值对](https://rakudocs.github.io/type/Pair)字面量或 `%` 标记的变量开头的单个列表，并且不使用 [`$_` 变量](https://rakudocs.github.io/syntax/$_)或占位符参数，则构造器返回一个[哈希](https://rakudocs.github.io/type/Hash)。否则它将构造一个[代码块](https://rakudocs.github.io/type/Block)。

If the content is empty, or contains a single list that starts with a [Pair](https://rakudocs.github.io/type/Pair) literal or `%`-sigiled variable, and the [`$_` variable](https://rakudocs.github.io/syntax/$_) or placeholder parameters are not used, the constructor returns a [Hash](https://rakudocs.github.io/type/Hash). Otherwise it constructs a [Block](https://rakudocs.github.io/type/Block).

若要强制构造[代码块](https://rakudocs.github.io/type/Block)，请在左大括号后加分号。要始终确保获得一个 [Hash](https://rakudocs.github.io/type/Hash) ，可以改用 `%( )` 或 [hash](https://rakudocs.github.io/routine/hash) 例程：

To force construction of a [Block](https://rakudocs.github.io/type/Block), follow the opening brace with a semicolon. To always ensure you end up with a [Hash](https://rakudocs.github.io/type/Hash), you can use `%( )` coercer or [hash](https://rakudocs.github.io/routine/hash) routine instead:

```Raku
{}.^name.say;        # OUTPUT: «Hash␤» 
{;}.^name.say;       # OUTPUT: «Block␤» 
 
{:$_}.^name.say;     # OUTPUT: «Block␤» 
%(:$_).^name.say;    # OUTPUT: «Hash␤» 
hash(:$_).^name.say; # OUTPUT: «Hash␤»
```

<a id="%E7%8E%AF%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6----circumfix--"></a>
## 环缀运算符 `[ ]` / circumfix `[ ]`

[数组](https://rakudocs.github.io/type/Array)构造器返回一个在列表上下文中不展平的逐项[数组](https://rakudocs.github.io/type/Array)。看这个：

The [Array](https://rakudocs.github.io/type/Array) constructor returns an itemized [Array](https://rakudocs.github.io/type/Array) that does not flatten in list context. Check this:

```Raku
say .perl for [3,2,[1,0]]; # OUTPUT: «3␤2␤$[1, 0]␤»
```

此数组是逐项列出的，即每个元素都构成一个项，如数组最后一个元素 [(列表) 条目上下文化器](https://rakudocs.github.io/type/Any#index-entry-%24_%28item_contextualizer%29)。

This array is itemized, in the sense that every element constitutes an item, as shown by the `$` preceding the last element of the array, the [(list) item contextualizer](https://rakudocs.github.io/type/Any#index-entry-%24_%28item_contextualizer%29).

<a id="%E6%9C%AF%E8%AF%AD--terms"></a>
# 术语 / Terms

术语有自己的[扩展文档](https://rakudocs.github.io/language/terms)。

Terms have their [own extended documentation](https://rakudocs.github.io/language/terms).

<a id="%E6%96%B9%E6%B3%95%E5%90%8E%E7%BC%80%E4%BC%98%E5%85%88%E7%BA%A7--method-postfix-precedence"></a>
# 方法后缀优先级 / Method postfix precedence

<a id="%E5%90%8E%E7%8E%AF%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6----postcircumfix--"></a>
## 后环缀运算符 `[ ]` / postcircumfix `[ ]`

```Raku
sub postcircumfix:<[ ]>(@container, **@index,
                        :$k, :$v, :$kv, :$p, :$exists, :$delete)
```

用于对数组容器的零个或多个元素进行位置访问的通用接口，也称为“数组索引运算符”。

Universal interface for positional access to zero or more elements of a @container, a.k.a. "array indexing operator".

```Raku
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

请参阅[下标](https://rakudocs.github.io/language/subscripts)，了解有关此运算符行为的更详细解释以及如何在自定义类型中实现对它的支持。

See [Subscripts](https://rakudocs.github.io/language/subscripts), for a more detailed explanation of this operator's behavior and for how to implement support for it in custom types.

<a id="%E5%90%8E%E7%8E%AF%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6----postcircumfix---1"></a>
## 后环缀运算符 `{ }` / postcircumfix `{ }`

```Raku
sub postcircumfix:<{ }>(%container, **@key,
                        :$k, :$v, :$kv, :$p, :$exists, :$delete)
```

用于关联访问哈希容器的零个或多个元素的通用接口，也称为“哈希索引运算符”。

Universal interface for associative access to zero or more elements of a %container, a.k.a. "hash indexing operator".

```Raku
my %color = kiwi => "green", banana => "yellow", cherry => "red";
say %color{"banana"};                 # OUTPUT: «yellow␤» 
say %color{"cherry", "kiwi"}.perl;    # OUTPUT: «("red", "green")␤» 
say %color{"strawberry"}:exists;      # OUTPUT: «False␤» 
 
%color{"banana", "lime"} = "yellowish", "green";
%color{"cherry"}:delete;
say %color;             # OUTPUT: «banana => yellowish, kiwi => green, lime => green␤»
```

请参阅[后环缀 `< >`](https://rakudocs.github.io/routine/%3C%20%3E#(Operators)_postcircumfix_%3C_%3E) 和[后环缀 `« »`](https://rakudocs.github.io/routine/%C2%AB%20%C2%BB#(Operators)_postcircumfix_%C2%AB_%C2%BB) 以获取方便的快捷方式，以及[下标](https://rakudocs.github.io/language/subscripts)以获取有关此操作符行为的更详细解释，以及如何在自定义类型中实现对其的支持。

See [`postcircumfix < >`](https://rakudocs.github.io/routine/%3C%20%3E#(Operators)_postcircumfix_%3C_%3E) and [`postcircumfix « »`](https://rakudocs.github.io/routine/%C2%AB%20%C2%BB#(Operators)_postcircumfix_%C2%AB_%C2%BB) for convenient shortcuts, and [Subscripts](https://rakudocs.github.io/language/subscripts) for a more detailed explanation of this operator's behavior and how to implement support for it in custom types.

<a id="%E5%90%8E%E7%8E%AF%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6--postcircumfix-"></a>
## 后环缀运算符 `<>` / postcircumfix `<>`

反容器化运算符，它从容器中提取值并使其独立于容器类型。

Decontainerization operator, which extracts the value from a container and makes it independent of the container type.

```Raku
use JSON::Tiny;
 
my $config = from-json('{ "files": 3, "path": "/home/perl6/perl6.pod6" }');
say $config.perl;      # OUTPUT: «${:files(3), :path("/home/perl6/perl6.pod6")}» 
my %config-hash = $config<>;
say %config-hash.perl; # OUTPUT: «{:files(3), :path("/home/perl6/perl6.pod6")}» 
```

在这两种情况下，它都是一个哈希，可以像这样使用；但是，在第一种情况下，它是在item上下文中，在第二种情况下，它被提取到适当的上下文中。

It's a `Hash` in both cases, and it can be used like that; however, in the first case it was in item context, and in the second case it has been extracted to its proper context.

<a id="%E5%90%8E%E7%8E%AF%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6--postcircumfix--1"></a>
## 后环缀运算符 `< >` / postcircumfix `< >`

[后环缀 `{ }`](https://rakudocs.github.io/routine/%7B%20%7D#(Operators)_postcircumfix_{_}) 的快捷方式，该快捷方式使用与同名的[引用词运算符](https://rakudocs.github.io/routine/%3C%20%3E#circumfix_%3C_%3E)相同的规则引用其参数。

Shortcut for [`postcircumfix { }`](https://rakudocs.github.io/routine/%7B%20%7D#(Operators)_postcircumfix_{_}) that quotes its argument using the same rules as the [quote-words operator](https://rakudocs.github.io/routine/%3C%20%3E#circumfix_%3C_%3E) of the same name.

```Raku
my %color = kiwi => "green", banana => "yellow", cherry => "red";
say %color<banana>;               # OUTPUT: «yellow␤» 
say %color<cherry kiwi>.perl;     # OUTPUT: «("red", "green")␤» 
say %color<strawberry>:exists;    # OUTPUT: «False␤»
```

从技术上讲，它不是一个真正的运算符；是语法糖在编译时变成了 `{ }` 后环缀运算符。

Technically, not a real operator; it's syntactic sugar that's turned into the `{ }` postcircumfix operator at compile-time.

<a id="%E5%90%8E%E7%8E%AF%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%C2%AB-%C2%BB--postcircumfix-%C2%AB-%C2%BB"></a>
## 后环缀运算符 `« »` / postcircumfix `« »`

[后环缀 `{ }`](https://rakudocs.github.io/routine/%7B%20%7D#(Operators)_postcircumfix_{_})的快捷方式，该快捷方式使用与同名的[引用词插值运算符](https://rakudocs.github.io/language/quoting#Word_quoting_with_interpolation_and_quote_protection:_%C2%AB_%C2%BB)相同的规则引用其参数。

Shortcut for [`postcircumfix { }`](https://rakudocs.github.io/routine/%7B%20%7D#(Operators)_postcircumfix_{_}) that quotes its argument using the same rules as the [interpolating quote-words operator](https://rakudocs.github.io/language/quoting#Word_quoting_with_interpolation_and_quote_protection:_%C2%AB_%C2%BB) of the same name.

```Raku
my %color = kiwi => "green", banana => "yellow", cherry => "red";
my $fruit = "kiwi";
say %color«cherry "$fruit"».perl;   # OUTPUT: «("red", "green")␤»
```

从技术上讲，它不是一个真正的运算符；是语法糖在编译时变成了 `{ }` 后环缀运算符。

Technically, not a real operator; it's syntactic sugar that's turned into the `{ }` postcircumfix operator at compile-time.

<a id="%E5%90%8E%E7%8E%AF%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6----postcircumfix---2"></a>
## 后环缀运算符 `( )` / postcircumfix `( )`

函数调用运算符将调用者视为[可调用的](https://rakudocs.github.io/type/Callable)并使用括号之间的表达式作为参数调用它。

The call operator treats the invocant as a [Callable](https://rakudocs.github.io/type/Callable) and invokes it, using the expression between the parentheses as arguments.

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

```Raku
my sub f($invocant){ "The arg has a value of $invocant" }
42.&f;
# OUTPUT: «The arg has a value of 42␤» 
 
42.&(-> $invocant { "The arg has a value of $invocant" });
# OUTPUT: «The arg has a value of 42␤»
```

<a id="%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--2"></a>
## 方法运算符 `.=` / methodop `.=`

一个变异的方法调用。`$invocant.=method` 是 `$invocant = $invocant.method` 的语法糖，类似于 [=](https://rakudocs.github.io/routine/=)。

A mutating method call. `$invocant.=method` desugars to `$invocant = $invocant.method`, similar to [=](https://rakudocs.github.io/routine/=) .

从技术上讲，不是真正的运算符；它是编译器中的句法特例。

Technically, not a real operator; it's syntax special-cased in the compiler.

<a id="%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6-%5E--methodop-%5E"></a>
## 方法运算符 `.^` / methodop `.^`

元方法调用。`$invocant.^method` 对调用者 `$invocant` 的元类调用方法 `method`。为 `$invocant.HOW.method($invocant, ...)` 的语法糖。有关详细信息，请参阅[元对象协议文档](https://rakudocs.github.io/language/mop)。

A meta-method call. `$invocant.^method` calls `method` on `$invocant`'s metaclass. It desugars to `$invocant.HOW.method($invocant, ...)`. See [the meta-object protocol documentation](https://rakudocs.github.io/language/mop) for more information.

从技术上讲，不是真正的运算符；它是编译器中的句法特例。

Technically, not a real operator; it's syntax special-cased in the compiler.

<a id="%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--3"></a>
## 方法运算符 `.?` / methodop `.?`

安全调用运算符。`$invocant.?method` 对调用者 `$invocant` 调用方法 `method` 如果它有这样一个名称的方法。否则返回 [Nil](https://rakudocs.github.io/type/Nil)。

Safe call operator. `$invocant.?method` calls method `method` on `$invocant` if it has a method of such name. Otherwise it returns [Nil](https://rakudocs.github.io/type/Nil).

从技术上讲，不是真正的运算符；它是编译器中的句法特例。

Technically, not a real operator; it's syntax special-cased in the compiler.

<a id="%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--4"></a>
## 方法运算符 `.+` / methodop `.+`

`$foo.+meth` 遍历方法解析顺序并调用所有名为 `meth` 的方法，如果类型与 `$foo` 的类型相同，则调用名为 `meth` 的子方法。这些可能是多分派方法，在这种情况下，将调用匹配的候选者。

`$foo.+meth` walks the MRO and calls all the methods called `meth` and submethods called `meth` if the type is the same as type of `$foo`. Those methods might be multis, in which case the matching candidate would be called.

之后，返回结果的[列表](https://rakudocs.github.io/type/List)。如果找不到这样的方法，它将抛出 [X::Method::NotFound](https://rakudocs.github.io/type/X::Method::NotFound) 异常。

After that, a [List](https://rakudocs.github.io/type/List) of the results are returned. If no such method was found, it throws a [X::Method::NotFound](https://rakudocs.github.io/type/X::Method::NotFound) exception.

```Raku
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

之后，返回结果的[列表](https://rakudocs.github.io/type/List)。如果找不到这样的方法，返回空列表。

After that, a [List](https://rakudocs.github.io/type/List) of the results are returned. If no such method was found, an empty [List](https://rakudocs.github.io/type/List) is returned.

技术上，后缀 `.+` 首先调用 `.*`。阅读后缀 `.+` 部分查看示例。

Technically, postfix `.+` calls `.*` at first. Read postfix `.+` section to see examples.

<a id="%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6-%C2%BB-----methodop-%C2%BB--methodop-"></a>
## 方法运算符 `».` / `>>.` - methodop `».` / methodop `>>.`

这是超级方法调用运算符。将对列表中的所有元素无序地调用方法但是有序地返回返回值列表。

This is the hyper method call operator. Will call a method on all elements of a `List` out of order and return the list of return values in order.

```Raku
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

超级方法调用可能看起来与执行 [map](https://rakudocs.github.io/routine/map)调用相同，但是除了向编译器提示它可以并行化调用外，该行为还受调用的[方法的节点性](https://rakudocs.github.io/routine/is%20nodal)影响，取决于执行调用时使用的是 [nodemap](https://rakudocs.github.io/routine/nodemap) 或 [deepmap](https://rakudocs.github.io/routine/deepmap) 语义。

Hyper method calls may appear to be the same as doing a [map](https://rakudocs.github.io/routine/map) call, however along with being a hint to the compiler that it can parallelize the call, the behavior is also affected by [nodality of the method](https://rakudocs.github.io/routine/is%20nodal) being invoked, depending on which either [nodemap](https://rakudocs.github.io/routine/nodemap) or [deepmap](https://rakudocs.github.io/routine/deepmap) semantics are used to perform the call.

通过查找[可调用](https://rakudocs.github.io/type/Callable)是否提供了 `nodal` 方法来检查节点性。如果超运算符应用于某个方法，则该[可调用](https://rakudocs.github.io/type/Callable)是该方法的名称，在[列表](https://rakudocs.github.io/type/List)类型中查找；如果超运算符应用于某个例程（例如 `».&foo`），则该例程的功能与[可调用](https://rakudocs.github.io/type/Callable)相同。如果[可调用](https://rakudocs.github.io/type/Callable)被确定为提供 `nodal` 方法，则使用 [nodemap](https://rakudocs.github.io/routine/nodemap) 语义执行超调用，否则使用 [duckmap](https://rakudocs.github.io/routine/duckmap) 语义。

The nodality is checked by looking up whether the [Callable](https://rakudocs.github.io/type/Callable) provides `nodal` method. If the hyper is applied to a method, that [Callable](https://rakudocs.github.io/type/Callable) is that method name, looked up on [List](https://rakudocs.github.io/type/List) type; if the hyper is applied to a routine (e.g. `».&foo`), that routine functions as that [Callable](https://rakudocs.github.io/type/Callable). If the [Callable](https://rakudocs.github.io/type/Callable) is determined to provide `nodal` method, [nodemap](https://rakudocs.github.io/routine/nodemap) semantics are used to perform the hyper call, otherwise [duckmap](https://rakudocs.github.io/routine/duckmap) semantics are used.

注意避免出现预期副作用的[常见错误](https://rakudocs.github.io/language/traps#Using_%C2%BB_and_map_interchangeably)。以下 `say` *不能*保证按顺序产生输出：

Take care to avoid a [common mistake](https://rakudocs.github.io/language/traps#Using_%C2%BB_and_map_interchangeably) of expecting side-effects to occur in order. The following `say` is **not** guaranteed to produce the output in order:

```Raku
@a».say;  # WRONG! Could produce a␤b␤c␤ or c␤b␤a␤ or any other order 
```

<a id="%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6-postfix--postcircumfix---methodop-postfix--postcircumfix"></a>
## 方法运算符 `.postfix` / `.postcircumfix` - methodop `.postfix` / `.postcircumfix`

在大多数情况下，点号可以放在后缀或后环缀：

In most cases, a dot may be placed before a postfix or postcircumfix:

```Raku
my @a;
@a[1, 2, 3];
@a.[1, 2, 3]; # Same
```

这对视觉清晰度或简洁性很有用。例如，如果一个对象的属性是一个函数，在属性名后面放一对圆括号将成为方法调用的一部分。因此，要么必须使用两对括号，要么必须在括号前面加一个点，以将其与方法调用分开。

This can be useful for visual clarity or brevity. For example, if an object's attribute is a function, putting a pair of parentheses after the attribute name will become part of the method call. So, either two pairs of parentheses must be used or a dot has to come before the parentheses to separate it from the method call.

```Raku
class Operation {
    has $.symbol;
    has &.function;
}
my $addition = Operation.new(:symbol<+>, :function{ $^a + $^b });
say $addition.function()(1, 2);   # OUTPUT: «3␤» 
# OR
say $addition.function.(1, 2);    # OUTPUT: «3␤»
```

但是，如果后缀是一个标识符，它将被解释为一个普通的方法调用。

If the postfix is an identifier, however, it will be interpreted as a normal method call.

```Raku
1.i # No such method 'i' for invocant of type 'Int' 
```

从技术上讲，不是真正的运算符；它是编译器中的句法特例。

Technically, not a real operator; it's syntax special-cased in the compiler.

<a id="%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--6"></a>
## 方法运算符 `.:` / methodop `.:`

前缀形式的运算符仍然可以像方法一样调用，即使用 `.` 方法运算符符号，在它前面加一个冒号。例如：

An operator in prefix form can still be called like a method, that is, using the `.` methodop notation, by preceding it by a colon. For example:

```Raku
my $a = 1;
say ++$a;       # OUTPUT: «2␤» 
say $a.:<++>;   # OUTPUT: «3␤»
```

从技术上讲，不是真正的运算符；它是编译器中的句法特例，这就是为什么它被归类为一个*方法运算符*。

Technically, not a real operator; it's syntax special-cased in the compiler, that is why it's classified as a *methodop*.

<a id="%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---methodop--7"></a>
## 方法运算符 `.::` / methodop `.::`

类限定的方法调用，用于调用在父类或角色中定义的方法，即使在子类中重新定义了该方法。

A class-qualified method call, used to call a method as defined in a parent class or role, even after it has been redefined in the child class.

```Raku
class Bar {
    method baz { 42 }
}
class Foo is Bar {
    method baz { "nope" }
}
say Foo.Bar::baz;       # OUTPUT: «42␤»
```

<a id="%E6%96%B9%E6%B3%95%E8%BF%90%E7%AE%97%E7%AC%A6---postfix-"></a>
## 方法运算符 `,=` / postfix `,=`

创建一个对象，该对象以依赖于类的方式连接左侧变量和右侧表达式的内容：

Creates an object that concatenates, in a class-dependent way, the contents of the variable on the left hand side and the expression on the right hand side:

```Raku
my %a = :11a, :22b;
%a ,= :33x;
say %a # OUTPUT: «{a => 11, b => 22, x => 33}␤»
```

<a id="%E8%87%AA%E5%A2%9E%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--autoincrement-precedence"></a>
# 自增运算符优先级 / Autoincrement precedence

<a id="%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---prefix-"></a>
## 前缀运算符 `++` / prefix `++`

```Raku
multi sub prefix:<++>($x is rw) is assoc<non>
```

这是。将其参数增加一并返回更新后的值。

This is the . Increments its argument by one and returns the updated value.

```Raku
my $x = 3;
say ++$x;   # OUTPUT: «4␤» 
say $x;     # OUTPUT: «4␤»
```

它通过在参数上调用 [succ](https://rakudocs.github.io/routine/succ)（意为 *successor*） 方法来工作，该方法允许自定义类型自由实现自己的增量语义。

It works by calling the [succ](https://rakudocs.github.io/routine/succ) method (for *successor*) on its argument, which gives custom types the freedom to implement their own increment semantics.

<a id="%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-----prefix---"></a>
## 前缀运算符 `--` / prefix `--`

```Raku
multi sub prefix:<-->($x is rw) is assoc<non>
```

将其参数递减一并返回更新后的值。

Decrements its argument by one and returns the updated value.

```Raku
my $x = 3;
say --$x;   # OUTPUT: «2␤» 
say $x;     # OUTPUT: «2␤»
```

它的工作方式是在参数上调用 [pred](https://rakudocs.github.io/routine/pred)（意为 *precondence*）方法，这给了自定义类型实现自减语义的自由。

It works by calling the [pred](https://rakudocs.github.io/routine/pred) method (for *predecessor*) on its argument, which gives custom types the freedom to implement their own decrement semantics.

<a id="%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---prefix--1"></a>
## 前缀运算符 `++` / prefix `++`

```Raku
multi sub postfix:<++>($x is rw) is assoc<non>
```

将其参数增加一并返回原始值。

Increments its argument by one and returns the original value.

```Raku
my $x = 3;
say $x++;   # OUTPUT: «3␤» 
say $x;     # OUTPUT: «4␤»
```

它通过在参数上调用 [succ](https://rakudocs.github.io/routine/succ) 方法来工作，该方法允许自定义类型自由实现自增语义。

It works by calling the [succ](https://rakudocs.github.io/routine/succ) method (for *successor*) on its argument, which gives custom types the freedom to implement their own increment semantics.

注意，这不一定返回其参数；例如，对于未定义的值，它返回 0：

Note that this does not necessarily return its argument; e.g., for undefined values, it returns 0:

```Raku
my $x;
say $x++;   # OUTPUT: «0␤» 
say $x;     # OUTPUT: «1␤»
```

[Str](https://rakudocs.github.io/type/Str) 上的增量将增加字符串的数字部分，并将结果字符串分配给容器。`is rw` 容器是必需的。

Increment on [Str](https://rakudocs.github.io/type/Str) will increment the number part of a string and assign the resulting string to the container. A `is rw`-container is required.

```Raku
my $filename = "somefile-001.txt";
say $filename++ for 1..3;
# OUTPUT: «somefile-001.txt␤somefile-002.txt␤somefile-003.txt␤»
```

<a id="%E5%90%8E%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-----postfix---"></a>
## 后缀运算符 `--` / postfix `--` 

```Raku
multi sub postfix:<-->($x is rw) is assoc<non>
```

将其参数递减一并返回原始值。

Decrements its argument by one and returns the original value.

```Raku
my $x = 3;
say $x--;   # OUTPUT: «3␤» 
say $x;     # OUTPUT: «2␤»
```

它的工作方式是在参数上调用 [pred](https://rakudocs.github.io/routine/pred) 方法，这给了自定义类型实现自己自减语义的自由。

It works by calling the [pred](https://rakudocs.github.io/routine/pred) method (for *predecessor*) on its argument, which gives custom types the freedom to implement their own decrement semantics.

注意，这不一定返回其参数；例如，对于未定义的值，它返回 0：

Note that this does not necessarily return its argument;e.g., for undefined values, it returns 0:

```Raku
my $x;
say $x--;   # OUTPUT: «0␤» 
say $x;     # OUTPUT: «-1␤»
```

[Str](https://rakudocs.github.io/type/Str) 上的减量将减少字符串的数字部分，并将结果字符串分配给容器。`is rw` 容器是必需的。数字部分减到小于 0 是被禁止的并会抛出 `X::AdHoc` 异常。

Decrement on [Str](https://rakudocs.github.io/type/Str) will decrement the number part of a string and assign the resulting string to the container. A `is rw`-container is required. Crossing 0 is prohibited and throws `X::AdHoc`.

```Raku
my $filename = "somefile-003.txt";
say $filename-- for 1..3;
# OUTPUT: «somefile-003.txt␤somefile-002.txt␤somefile-001.txt␤»
```

<a id="%E6%8C%87%E6%95%B0%E4%BC%98%E5%85%88%E7%BA%A7--exponentiation-precedence"></a>
# 指数优先级 / Exponentiation precedence

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix-"></a>
## 中缀运算符 `**` / infix `**`

```Raku
multi sub infix:<**>(Any, Any --> Numeric:D) is assoc<right>
```

指数运算符将两个参数强制转换为[数值](https://rakudocs.github.io/type/Numeric)，并计算左边数值的对于右边数值的指数。

The exponentiation operator coerces both arguments to [Numeric](https://rakudocs.github.io/type/Numeric) and calculates the left-hand-side raised to the power of the right-hand side.

如果右边是非负整数，左边是任意精度类型（[Int](https://rakudocs.github.io/type/Int)、[FatRat](https://rakudocs.github.io/type/FatRat)），则执行计算时不会损失精度。

If the right-hand side is a non-negative integer and the left-hand side is an arbitrary precision type ([Int](https://rakudocs.github.io/type/Int), [FatRat](https://rakudocs.github.io/type/FatRat)), then the calculation is carried out without loss of precision.

Unicode 上标将以完全相同的方式运行。

Unicode superscripts will behave in exactly the same way.

```Raku
sub squared( Int $num ) { $num² };
say squared($_) for ^5; OUTPUT: «0␤1␤4␤9␤16␤»
```

它也适用于多个 Unicode 上标数字的序列：

It also works for sequences of several Unicode superscript numbers:

```Raku
sub twenty-second-power( Int $num ) { $num²² };
say twenty-second-power($_) for ^5; # OUTPUT: «0␤1␤4194304␤31381059609␤17592186044416␤»
```

<a id="%E4%B8%80%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--symbolic-unary-precedence"></a>
# 一元运算符优先级 / Symbolic unary precedence

<a id="%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---prefix--2"></a>
## 前缀运算符 `?` / prefix `?`

```Raku
multi sub prefix:<?>(Mu --> Bool:D)
```

布尔值上下文运算符。

Boolean context operator.

通过调用参数的 `Bool` 方法将其强制为 [Bool](https://rakudocs.github.io/type/Bool)。注意，这会折叠 [Junction](https://rakudocs.github.io/type/Junction) 类型。

Coerces the argument to [Bool](https://rakudocs.github.io/type/Bool) by calling the `Bool` method on it. Note that this collapses [Junction](https://rakudocs.github.io/type/Junction)s.

<a id="%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---prefix--3"></a>
## 前缀运算符 `!` / prefix `!`

```Raku
multi sub prefix:<!>(Mu --> Bool:D)
```

否认布尔上下文运算符。

Negated boolean context operator.

通过调用参数的 `Bool` 方法将其强制为 [Bool](https://rakudocs.github.io/type/Bool) 类型。注意，这会折叠 [Junction](https://rakudocs.github.io/type/Junction) 类型。

通过调用参数的 `Bool` 方法将其强制为 [Bool](https://rakudocs.github.io/type/Bool) 类型，并返回结果的否定值。注意，这会折叠[Junction](https://rakudocs.github.io/type/Junction) 类型。

Coerces the argument to [Bool](https://rakudocs.github.io/type/Bool) by calling the `Bool` method on it, and returns the negation of the result. Note that this collapses [Junction](https://rakudocs.github.io/type/Junction)s.

<a id="%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---prefix--4"></a>
## 前缀运算符 `+` / prefix `+`

```Raku
multi sub prefix:<+>(Any --> Numeric:D)
```

数值上下文运算符。

Numeric context operator.

通过调用参数上的 `Numeric` 方法将其强制为[数值](https://rakudocs.github.io/type/Numeric)。

Coerces the argument to [Numeric](https://rakudocs.github.io/type/Numeric) by calling the `Numeric` method on it.

<a id="%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6----prefix--"></a>
## 前缀运算符 `-` / prefix `-`

```Raku
multi sub prefix:<->(Any --> Numeric:D)
```

否定数值上下文运算符。

Negative numeric context operator.

通过调用参数上的 `Numeric` 方法将其强制为[数值](https://rakudocs.github.io/type/Numeric)，并返回结果的否定值。

Coerces the argument to [Numeric](https://rakudocs.github.io/type/Numeric) by calling the `Numeric` method on it, and then negates the result.

<a id="%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7E--prefix-%7E"></a>
## 前缀运算符 `~` / prefix `~`

```Raku
multi sub prefix:<~>(Any --> Str:D)
```

字符串上下文运算符。

String context operator.

通过调用 [Str](https://rakudocs.github.io/type/Str) 方法，将参数强制为 [Str](https://rakudocs.github.io/type/Str) 类型。

Coerces the argument to [Str](https://rakudocs.github.io/type/Str) by calling the [Str](https://rakudocs.github.io/type/List#method_Str) method on it.

<a id="%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7C--prefix-%7C"></a>
## 前缀运算符 `|` / prefix `|`

将类型为 [Capture](https://rakudocs.github.io/type/Capture)、[Pair](https://rakudocs.github.io/type/Pair)、[List](https://rakudocs.github.io/type/List)、[Map](https://rakudocs.github.io/type/Map) 和 [Hash](https://rakudocs.github.io/type/Hash) 的对象展平成参数列表。

Flattens objects of type [Capture](https://rakudocs.github.io/type/Capture), [Pair](https://rakudocs.github.io/type/Pair), [List](https://rakudocs.github.io/type/List), [Map](https://rakudocs.github.io/type/Map) and [Hash](https://rakudocs.github.io/type/Hash) into an argument list.

```Raku
sub slurpee( |args ){
    say args.perl
};
slurpee( <a b c d>, { e => 3 }, 'e' => 'f' => 33 )
# OUTPUT: «\(("a", "b", "c", "d"), {:e(3)}, :e(:f(33)))␤»
```

有关此主题的详细信息，请参阅 [`Signature` 页面，特别是有关捕获的部分](https://rakudocs.github.io/type/Signature#Capture_parameters)。

Please see the [`Signature` page, specially the section on Captures](https://rakudocs.github.io/type/Signature#Capture_parameters) for more information on the subject.

在参数列表之外，它返回一个 [Slip](https://rakudocs.github.io/type/Slip)，这使得它扁平化为外部列表。在[参数列表](https://rakudocs.github.io/language/list#Argument_list_(Capture)_context)中，[`Positional`](https://rakudocs.github.io/type/Positional) 部分将变为位置参数，[`Associative`](https://rakudocs.github.io/type/Associative) 部分变为命名参数。

Outside of argument lists, it returns a [Slip](https://rakudocs.github.io/type/Slip), which makes it flatten into the outer list. Inside [argument list](https://rakudocs.github.io/language/list#Argument_list_(Capture)_context) [`Positional`s](https://rakudocs.github.io/type/Positional) are turned into positional arguments and [`Associative`s](https://rakudocs.github.io/type/Associative) are turned into named arguments.

<a id="%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E--prefix-%5E"></a>
## 前缀运算符 `+^` / prefix `+^`

```Raku
multi sub prefix:<+^>(Any --> Int:D)
```

整数位求反运算符：将参数强制为 [Int](https://rakudocs.github.io/type/Int)，并对结果进行位求反，假定[二的补码](https://en.wikipedia.org/wiki/Two%27s_complement)。

Integer bitwise negation operator: Coerces the argument to [Int](https://rakudocs.github.io/type/Int) and does a bitwise negation on the result, assuming [two's complement](https://en.wikipedia.org/wiki/Two%27s_complement).

<a id="%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7E%5E--prefix-%7E%5E"></a>
## 前缀运算符 `~^` / prefix `~^`

将参数强制为非变量编码字符串缓冲区类型（例如 `buf8`、`buf16`、`buf32`），然后翻转该缓冲区中的每个位。

Coerces the argument to a non-variable-encoding string buffer type (e.g. `buf8`, `buf16`, `buf32`) and then flips each bit in that buffer.

请注意，这一点尚未实现。。。

Please note that this has not yet been implemented.

<a id="%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E--prefix-%5E-1"></a>
## 前缀运算符 `?^` / prefix `?^`

```Raku
multi sub prefix:<?^>(Mu --> Bool:D)
```

布尔位求反运算符：将参数强制为 [Bool](https://rakudocs.github.io/type/Bool)，然后进行位翻转，使其与 `prefix:<!>` 相同。

Boolean bitwise negation operator: Coerces the argument to [Bool](https://rakudocs.github.io/type/Bool) and then does a bit flip, which makes it the same as `prefix:<!>`.

<a id="%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E--prefix-%5E-2"></a>
## 前缀运算符 `^` / prefix `^`

```Raku
multi sub prefix:<^>(Any --> Range:D)
```

*upto* 运算符.

*upto* operator.

将参数强制为[数值](https://rakudocs.github.io/type/Numeric)，并生成从 0 到（但不包括）参数的范围。

Coerces the argument to [Numeric](https://rakudocs.github.io/type/Numeric), and generates a range from 0 up to (but excluding) the argument.

```Raku
say ^5;         # OUTPUT: «0..^5␤» 
for ^5 { }      # 5 iterations
```

<a id="%E5%B8%A6%E7%82%B9%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--dotty-infix-precedence"></a>
# 带点中缀运算符优先级 / Dotty infix precedence

这些运算符与它们的方法后缀对应项类似，但需要周围的空白（在和/或之后）来区分它们。

These operators are like their Method Postfix counterparts, but require surrounding whitespace (before and/or after) to distinguish them.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--1"></a>
## 中缀运算符 `.=` / infix `.=`

对左侧容器中的值调用右侧方法，替换左侧容器中的结果值。

Calls the right-side method on the value in the left-side container, replacing the resulting value in the left-side container.

在大多数情况下，其行为与后缀赋值函数相同，但优先级较低：

In most cases, this behaves identically to the postfix mutator, but the precedence is lower:

```Raku
my $a = -5;
say ++$a.=abs;
# OUTPUT: «6␤» 
say ++$a .= abs;
# OUTPUT: «Cannot modify an immutable Int␤ 
#           in block <unit> at <tmp> line 1␤␤» 
```

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--2"></a>
## 中缀运算符 `.` / infix `.`

调用左侧调用者右侧的方法（其名称必须是字母）。

Calls the following method (whose name must be alphabetic) on the left-side invocant.

注意，运算符的中缀形式的优先级略低于后缀 `.meth`。

Note that the infix form of the operator has a slightly lower precedence than postfix `.meth`.

```Raku
say -5.abs;      # like: -(5.abs) 
# OUTPUT: «-5␤» 
say -5 . abs;    # like: (-5) . abs 
# OUTPUT: «5␤» 
say -5 .abs;     # following whitespace is optional 
# OUTPUT: «5␤»
```

<a id="%E4%B9%98%E6%B3%95%E4%BC%98%E5%85%88%E7%BA%A7--multiplicative-precedence"></a>
# 乘法优先级 / Multiplicative precedence

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--3"></a>
## 中缀运算符 `*` / infix `*`

```Raku
multi sub infix:<*>(Any, Any --> Numeric:D)
```

乘法运算符。

Multiplication operator.

将两个参数强制转换为[数值](https://rakudocs.github.io/type/Numeric)并将它们相乘。结果是较宽的类型。有关详细信息，请参见[数值](https://rakudocs.github.io/type/Numeric)。

Coerces both arguments to [Numeric](https://rakudocs.github.io/type/Numeric) and multiplies them. The result is of the wider type. See [Numeric](https://rakudocs.github.io/type/Numeric) for details.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6----infix-"></a>
## 中缀运算符 `/` - infix `/`

```Raku
multi sub infix:</>(Any, Any --> Numeric:D)
```

除法运算符。

Division operator.

将两个参数强制转换为[数值](https://rakudocs.github.io/type/Numeric)并将左数除以右数。[Int](https://rakudocs.github.io/type/Int) 的除法返回 [Rat](https://rakudocs.github.io/type/Rat) 值，否则[数值](https://rakudocs.github.io/type/Numeric)中描述的“较宽类型”规则适用。

Coerces both argument to [Numeric](https://rakudocs.github.io/type/Numeric) and divides the left through the right number. Division of [Int](https://rakudocs.github.io/type/Int) values returns [Rat](https://rakudocs.github.io/type/Rat), otherwise the "wider type" rule described in [Numeric](https://rakudocs.github.io/type/Numeric) holds.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-div--infix-div"></a>
## 中缀运算符 `div` / infix `div`

```Raku
multi sub infix:<div>(Int:D, Int:D --> Int:D)
```

整数除法运算符。向下舍入。

Integer division operator. Rounds down.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%25--infix-%25"></a>
## 中缀运算符 `%` / infix `%`

```Raku
multi sub infix:<%>($x, $y --> Numeric:D)
```

模运算符。首先强制为[数值](https://rakudocs.github.io/type/Numeric)。

Modulo operator. Coerces to [Numeric](https://rakudocs.github.io/type/Numeric) first.

一般来说，以下标识成立：

Generally the following identity holds:

```Raku
my ($x, $y) = 1,2;
$x % $y == $x - floor($x / $y) * $y
```

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%25%25--infix-%25%25"></a>
## 中缀运算符 `%%` / infix `%%`

```Raku
multi sub infix:<%%>($a, $b --> Bool:D)
```

可除性运算符。如果 `$a % $b == 0`，则返回 `True`。

Divisibility operator. Returns `True` if `$a % $b == 0`.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-mod--infix-mod"></a>
## 中缀运算符 `mod` / infix `mod`

```Raku
multi sub infix:<mod>(Int:D $a, Int:D $b --> Int:D)
```

整数模运算符。返回整数模运算的剩余部分。

Integer modulo operator. Returns the remainder of an integer modulo operation.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--4"></a>
## 中缀运算符 `+&` / infix `+&`

```Raku
multi sub infix:<+&>($a, $b --> Int:D)
```

数值按位*与*运算符。将两个参数强制为 [Int](https://rakudocs.github.io/type/Int)，并假设二的补码，执行按位*与*操作。

Numeric bitwise *AND* operator. Coerces both arguments to [Int](https://rakudocs.github.io/type/Int) and does a bitwise *AND* operation assuming two's complement.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--5"></a>
## 中缀运算符 `+<` / infix `+<`

```Raku
multi sub infix:<< +< >>($a, $b --> Int:D)
```

整数位向左移位。

Integer bit shift to the left.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--6"></a>
## 中缀运算符 `+>` / infix `+>`

```Raku
multi sub infix:<< +> >>($a, $b --> Int:D)
```

整数位向右移位。

Integer bit shift to the right.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7E--infix-%7E"></a>
## 中缀运算符 `~&` / infix `~&`

将每个参数强制为非变量编码字符串缓冲区类型（例如 `buf8`、`buf16`、`buf32`），然后对两个缓冲区的相应整数执行逐位与运算，用零填充较短的缓冲区。
Coerces each argument to a non-variable-encoding string buffer type (e.g. `buf8`, `buf16`, `buf32`) and then performs a numeric bitwise AND on corresponding integers of the two buffers, padding the shorter buffer with zeroes.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7E--infix-%7E-1"></a>
## 中缀运算符 `~<` / infix `~<`

将左参数强制为非变量编码字符串缓冲区类型（例如 `buf8`、`buf16`、`buf32`），然后对缓冲区的位执行数值按位左移。

Coerces the left argument to a non-variable-encoding string buffer type (e.g. `buf8`, `buf16`, `buf32`) and then performs a numeric bitwise left shift on the bits of the buffer.

请注意，这一点尚未实现。

Please note that this has not yet been implemented.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7E--infix-%7E-2"></a>
## 中缀运算符 `~>` / infix `~>`

将左参数强制为非变量编码字符串缓冲区类型（例如 `buf8`、`buf16`、`buf32`），然后对缓冲区的位执行数字按位左移。

Coerces the left argument to a non-variable-encoding string buffer type (e.g. `buf8`, `buf16`, `buf32`) and then performs a numeric bitwise right shift on the bits of the buffer.

请注意，这一点尚未实现。

Please note that this has not yet been implemented.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-gcd--infix-gcd"></a>
## 中缀运算符 `gcd` / infix `gcd`

```Raku
multi sub infix:<gcd>($a, $b --> Int:D)
```

将两个参数强制为 [Int](https://rakudocs.github.io/type/Int) 并返回最大公约数。如果其中一个参数为 0，则返回另一个参数（当两个参数均为 0 时，运算符返回 0）。

Coerces both arguments to [Int](https://rakudocs.github.io/type/Int) and returns the greatest common divisor. If one of its arguments is 0, the other is returned (when both arguments are 0, the operator returns 0).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-lcm--infix-lcm"></a>
## 中缀运算符 `lcm` / infix `lcm`

```Raku
multi sub infix:<lcm>($a, $b --> Int:D)
```

将两个参数强制为 [Int](https://rakudocs.github.io/type/Int) 并返回最小公倍数；也就是说，可由两个参数除尽的最小整数。

Coerces both arguments to [Int](https://rakudocs.github.io/type/Int) and returns the least common multiple; that is, the smallest integer that is evenly divisible by both arguments.

<a id="%E5%8A%A0%E6%B3%95%E4%BC%98%E5%85%88%E7%BA%A7--additive-precedence"></a>
# 加法优先级 / Additive precedence

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--7"></a>
## 中缀运算符 `+` / infix `+`

```Raku
multi sub infix:<+>($a, $b --> Numeric:D)
```

加法运算符。

Addition operator.

将两个参数强制为[Numeric](https://rakudocs.github.io/type/Numeric)并将它们相加。

Coerces both arguments to [Numeric](https://rakudocs.github.io/type/Numeric) and adds them.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6----infix--"></a>
## 中缀运算符 `-` / infix `-`

```Raku
multi sub infix:<->($a, $b --> Numeric:D)
```

减法运算符。

Subtraction operator.

将两个参数强制为 [Numeric](https://rakudocs.github.io/type/Numeric)并从第一个参数中减去第二个参数。

Coerces both arguments to [Numeric](https://rakudocs.github.io/type/Numeric) and subtracts the second from the first.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7C--infix-%7C"></a>
## 中缀运算符 `+|` / infix `+|`

```Raku
multi sub infix:<+|>($a, $b --> Int:D)
```

整数按位或运算符：将两个参数强制为 [Int](https://rakudocs.github.io/type/Int)，并执行按位*或*操作。

Integer bitwise OR operator: Coerces both arguments to [Int](https://rakudocs.github.io/type/Int) and does a bitwise *OR* (inclusive OR) operation.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E--infix-%5E"></a>
## 中缀运算符 `+^` / infix `+^`

```Raku
multi sub infix:<+^>($a, $b --> Int:D)
```

整数位异或运算符：将两个参数强制为 [Int](https://rakudocs.github.io/type/Int)，并执行位*异或*操作。

Integer bitwise XOR operator: Coerces both arguments to [Int](https://rakudocs.github.io/type/Int) and does a bitwise *XOR* (exclusive OR) operation.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7E%7C--infix-%7E%7C"></a>
## 中缀运算符 `~|` / infix `~|`

将每个参数强制为非变量编码字符串缓冲区类型（例如 `buf8`、`buf16`、`buf32`），然后对两个缓冲区的相应整数执行逐位或数字运算，用零填充较短的缓冲区。

Coerces each argument to a non-variable-encoding string buffer type (e.g. `buf8`, `buf16`, `buf32`) and then performs a numeric bitwise OR on corresponding integers of the two buffers, padding the shorter buffer with zeroes.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7E%5E--infix-%7E%5E"></a>
## 中缀运算符 `~^` / infix `~^`

将每个参数强制为非变量编码字符串缓冲区类型（例如 `buf8`、`buf16`、`buf32`），然后对两个缓冲区的相应整数执行数字位异或，用零填充较短的缓冲区。

Coerces each argument to a non-variable-encoding string buffer type (e.g. `buf8`, `buf16`, `buf32`) and then performs a numeric bitwise XOR on corresponding integers of the two buffers, padding the shorter buffer with zeroes.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E--infix-%5E-1"></a>
## 中缀运算符 `?^` / infix `?^`

```Raku
multi sub infix:<?^>(Mu $x = Bool::False)
multi sub infix:<?^>(Mu \a, Mu \b)
```

布尔位异或运算符：将参数强制为 [Bool](https://rakudocs.github.io/type/Bool) 并对其执行逻辑异或：只有其中一个参数为真值时，它才会返回真值。它返回单个参数的标识。

Boolean bitwise XOR operator: Coerces the argument(s) to [Bool](https://rakudocs.github.io/type/Bool) and performs logical XOR on them: it will return True if and only if just one of the argument is true. It returns identity on a single argument.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7C--infix-%7C-1"></a>
## 中缀运算符 `?|` / infix `?|`

```Raku
multi sub infix:<?|>($a, $b --> Bool:D)
```

布尔逻辑或运算符。

Boolean logical OR operator.

将两个参数强制为 [Bool](https://rakudocs.github.io/type/Bool) 并执行逻辑*或*操作。

Coerces both arguments to [Bool](https://rakudocs.github.io/type/Bool) and does a logical *OR* (inclusive OR) operation.

<a id="%E5%A4%8D%E5%88%B6%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--replication-precedence"></a>
# 复制运算符优先级 / Replication precedence

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-x--infix-x"></a>
## 中缀运算符 `x` / infix `x`

```Raku
sub infix:<x>($a, $b --> Str:D)
```

字符串复制运算符。

String repetition operator.

重复字符串 `$a` `$b` 次，如果需要，强制将 `$a` 转换为 [`Str`](https://rakudocs.github.io/type/Str) 和 `$b` 转换为 [`Int`](https://rakudocs.github.io/type/Int)。如果 `$b` 小于 0，则返回空字符串。如果 `$b` 是 `-Inf` 或 `NaN`，则将引发异常 `X::Numeric::CannotConvert`。

Repeats the string `$a` `$b` times, if necessary coercing `$a` to [`Str`](https://rakudocs.github.io/type/Str) and `$b` [`Int`](https://rakudocs.github.io/type/Int). Returns an empty string if `$b <= 0`. An exception `X::Numeric::CannotConvert` will be thrown if `$b` is `-Inf` or `NaN`.

```Raku
say 'ab' x 3;           # OUTPUT: «ababab␤» 
say 42 x 3;             # OUTPUT: «424242␤» 
 
my $a = 'a'.IO;
my $b = 3.5;
say $a x $b;            # OUTPUT: «aaa␤»
```

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-xx--infix-xx"></a>
## 中缀运算符 `xx` / infix `xx`

列表重复运算符

List repetition operator

定义：

Defined as:

```Raku
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

一般来说，它返回一个重复的 `$a` 序列并计算 `$b` 次（`$b` 被强制为 [Int](https://rakudocs.github.io/type/Int)）。如果 `$b` 小于 0，则返回空列表。它将返回一个没有操作数的错误，并用一个操作数返回操作数本身。如果 `$b` 是 `-Inf` 或 `NaN`，则将引发异常 `X::Numeric::CannotConvert`。

In general, it returns a Sequence of `$a` repeated and evaluated `$b` times (`$b` is coerced to [Int](https://rakudocs.github.io/type/Int)). If `$b <= 0`, the empty list is returned. It will return an error with no operand, and return the operand itself with a single operand. An exception `X::Numeric::CannotConvert` will be thrown if `$b` is `-Inf` or `NaN`.

运算符左手边的子项每次都重复计算，所以

The left-hand side is evaluated for each repetition, so

```Raku
say [1, 2] xx 5;
# OUTPUT: «([1 2] [1 2] [1 2] [1 2] [1 2])␤»
```

返回五个不同的数组（但每次都有相同的内容），并且

returns five distinct arrays (but with the same content each time), and

```Raku
rand xx 3
```

返回三个独立确定的伪随机数。

returns three pseudo random numbers that are determined independently.

右边可以是 `*`，在这种情况下，将返回一个惰性的无限列表。

The right-hand side can be `*`, in which case a lazy, infinite list is returned. If it's a `Bool`, a `Seq` with a single element is returned if it's `True`.

<a id="%E8%BF%9E%E6%8E%A5%E6%93%8D%E4%BD%9C%E7%AC%A6--concatenation"></a>
# 连接操作符 / Concatenation

与其他中缀运算符一样，这些运算符可以与元运算符组合，例如[赋值运算符](https://rakudocs.github.io/language/operators#Assignment_operators)。

Same as the rest of the infix operators, these can be combined with metaoperators such as [assignment](https://rakudocs.github.io/language/operators#Assignment_operators), for instance.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7E--infix-%7E-3"></a>
## 中缀运算符 `~` / infix `~`

```Raku
multi sub infix:<~>(Any,   Any)
multi sub infix:<~>(Str:D, Str:D)
multi sub infix:<~>(Buf:D, Buf:D)
```

这是字符串连接运算符，它将两个参数强制转换为 [Str](https://rakudocs.github.io/type/Str) 并连接它们。如果两个参数都是 [Buf](https://rakudocs.github.io/type/Buf)，则返回一个组合缓冲区。

This is the string concatenation operator, which coerces both arguments to [Str](https://rakudocs.github.io/type/Str) and concatenates them. If both arguments are [Buf](https://rakudocs.github.io/type/Buf), a combined buffer is returned.

```Raku
say 'ab' ~ 'c';     # OUTPUT: «abc␤»
```

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%88%98--infix-%E2%88%98"></a>
## 中缀运算符 `∘` / infix `∘`

```Raku
multi sub infix:<∘>()
multi sub infix:<∘>(&f)
multi sub infix:<∘>(&f, &g --> Block:D)
```

函数合成运算符 `infix:<∘>` 或 `infix:<o>` 组合了两个函数，因此使用右函数的返回值调用左函数。如果左函数的 [`.count`](https://rakudocs.github.io/routine/count)（即参数个数） 大于 1，则右边函数的返回值将 [slipped](https://rakudocs.github.io/type/Slip)（展平） 给到左边函数。

The function composition operator `infix:<∘>` or `infix:<o>` combines two functions, so that the left function is called with the return value of the right function. If the [`.count`](https://rakudocs.github.io/routine/count) of the left function is greater than 1, the return value of the right function will be [slipped](https://rakudocs.github.io/type/Slip) into the left function.

右手边函数的 `.count` 和 `.arity` 都将保持不变。

Both `.count` and `.arity` of the right-hand side will be maintained.

```Raku
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
say f | g 'abc';
```

单个参数候选者按原样返回给定参数。零参数候选者返回一个标识例程，该例程只返回其参数。

The single-arg candidate returns the given argument as is. The zero-arg candidate returns an identity routine that simply returns its argument.

```Raku
my &composed = [∘] &uc;
say composed 'foo'; # OUTPUT: «FOO␤» 
 
my &composed = [∘];
say composed 'foo'; # OUTPUT: «foo␤»
```

<a id="junction-%E4%B8%8E%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--junctive-and-all-precedence"></a>
# Junction 与运算符优先级 / Junctive AND (all) precedence

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--8"></a>
## 中缀运算符 `&` / infix `&`

```Raku
multi sub infix:<&>($a, $b --> Junction:D) is assoc<list>
```

All junction 类型运算符。

All junction operator.

从其参数创建一个 *all* [Junction](https://rakudocs.github.io/type/Junction)。请参阅 [Junction](https://rakudocs.github.io/type/Junction) 了解更多详细信息。

Creates an *all* [Junction](https://rakudocs.github.io/type/Junction) from its arguments. See [Junction](https://rakudocs.github.io/type/Junction) for more details.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6--%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%88%A9--infix--infix-%E2%88%A9"></a>
## 中缀运算符 `(&)`, 中缀运算符 `∩` / infix `(&)`, infix `∩`

```Raku
multi sub infix:<(&)>(**@p)
multi sub infix:<∩>(**@p)
```

集合交运算符。

Intersection operator.

返回其所有参数的**交集**。这将创建一个新的[集合](https://rakudocs.github.io/type/Set)，如果所有参数都不是 [Bag](https://rakudocs.github.io/type/Bag)、[BagHash](https://rakudocs.github.io/type/BagHash)、[Mix](https://rakudocs.github.io/type/Mix) 或 [MixHash](https://rakudocs.github.io/type/MixHash)。

Returns the **intersection** of all of its arguments. This creates a new [Set](https://rakudocs.github.io/type/Set) that contains only the elements common to all of the arguments if none of the arguments are a [Bag](https://rakudocs.github.io/type/Bag), [BagHash](https://rakudocs.github.io/type/BagHash), [Mix](https://rakudocs.github.io/type/Mix) or [MixHash](https://rakudocs.github.io/type/MixHash).

```Raku
say <a b c> (&) <b c d>; # OUTPUT: «set(b c)␤» 
<a b c d> ∩ <b c d e> ∩ <c d e f>; # OUTPUT: «set(c d)␤» 
```

如果任何参数是 [Baggy](https://rakudocs.github.io/type/Baggy) 或 [Mixy](https://rakudocs.github.io/type/Mixy)，则结果是一个包含公共元素的新 `Bag`（或 `Mix`），每个元素的权重都是最大的*公共*权重（即该元素在所有参数上的权重的最小值）。

If any of the arguments are [Baggy](https://rakudocs.github.io/type/Baggy) or [Mixy](https://rakudocs.github.io/type/Mixy)>, the result is a new `Bag` (or `Mix`) containing the common elements, each weighted by the largest *common* weight (which is the minimum of the weights of that element over all arguments).

```Raku
say <a a b c a> (&) bag(<a a b c c>); # OUTPUT: «Bag(a(2), b, c)␤» 
```

`∩` 相当于 `(&)`，在代码点 U+2229 处。

`∩` is equivalent to `(&)`, at codepoint U+2229 (INTERSECTION).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%EF%BC%8C-%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%8D--infix--infix-%E2%8A%8D"></a>
## 中缀运算符 `(.)`， 中缀运算符 `⊍` / infix `(.)`, infix `⊍`

```Raku
multi sub infix:<(.)>(**@p)
multi sub infix:<⊍>(**@p)
```

Baggy（Bag 类型的）乘法运算符。

Baggy multiplication operator.

返回其参数的 Baggy **乘法**，即一个 [Bag](https://rakudocs.github.io/type/Bag)，该参数包含参数的每个元素，元素在参数之间的权重相乘得到新的权重。如果任何参数是 [Mixy](https://rakudocs.github.io/type/Mixy)，则返回 [Mix](https://rakudocs.github.io/type/Mix)。

Returns the Baggy **multiplication** of its arguments, i.e., a [Bag](https://rakudocs.github.io/type/Bag) that contains each element of the arguments with the weights of the element across the arguments multiplied together to get the new weight. Returns a [Mix](https://rakudocs.github.io/type/Mix) if any of the arguments is a [Mixy](https://rakudocs.github.io/type/Mixy).

```Raku
say <a b c> (.) <a b c d>; # OUTPUT: «Bag(a, b, c)␤» 
                           # Since 1 * 0 == 0, in the case of 'd' 
say <a a b c a d> ⊍ bag(<a a b c c>); # OUTPUT: «Bag(a(6), b, c(2))␤» 
```

`⊍` 相当于 `(.)`，在代码点 U+228D 处。

`⊍` is equivalent to `(.)`, at codepoint U+228D (MULTISET MULTIPLICATION).

<a id="junction-%E6%88%96%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--junctive-or-any-precedence"></a>
# Junction 或运算符优先级 / Junctive OR (any) precedence

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7C--infix-%7C-2"></a>
## 中缀运算符 `|` / infix `|`

```Raku
multi sub infix:<|>($a, $b --> Junction:D) is assoc<list>
```

从其参数创建 *any* [Junction](https://rakudocs.github.io/type/Junction)。

Creates an *any* [Junction](https://rakudocs.github.io/type/Junction) from its arguments.

```Raku
my $three-letters = /<[a b c]>/ | /<[i j k]>/ | /<[x y z]>/;
say $three-letters.perl; # OUTPUT: «any(/<[a b c]>/, /<[i j k]>/, /<[x y z]>/)␤» 
say 'b' ~~ $three-letters; # OUTPUT: «True␤»
```

这首先创建三个正则表达式的 `any` `Junction`（每个正则表达式都匹配三个字母中的任意一个），然后使用智能匹配检查字母 `b` 是否匹配其中任何一个，从而得到正匹配。有关更多详细信息，请参见 [Junction](https://rakudocs.github.io/type/Junction)。

This first creates an `any` `Junction` of three regular expressions (every one of them matching any of 3 letters), and then uses smartmatching to check whether the letter `b` matches any of them, resulting in a positive match. See also [Junction](https://rakudocs.github.io/type/Junction) for more details.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7C%EF%BC%8C%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%88%AA--infix-%7C-infix-%E2%88%AA"></a>
## 中缀运算符 `(|)`，中缀运算符 `∪` / infix `(|)`, infix `∪`

```Raku
multi sub infix:<(|)>(**@p)
multi sub infix:<∪>(**@p)
```

集合并运算符。

Union operator.

返回其所有参数的**并集**。这将创建一个新的[集合](https://rakudocs.github.io/type/Set)，其中包含其参数包含的所有元素（如果没有参数是 [Bag](https://rakudocs.github.io/type/Bag)、[BagHash](https://rakudocs.github.io/type/BagHash)、[Mix](https://rakudocs.github.io/type/Mix) 或 [MixHash](https://rakudocs.github.io/type/MixHash)。

Returns the **union** of all of its arguments. This creates a new [Set](https://rakudocs.github.io/type/Set) that contains all the elements its arguments contain if none of the arguments are a [Bag](https://rakudocs.github.io/type/Bag), [BagHash](https://rakudocs.github.io/type/BagHash), [Mix](https://rakudocs.github.io/type/Mix) or [MixHash](https://rakudocs.github.io/type/MixHash).

```Raku
say <a b d> ∪ bag(<a a b c>); # OUTPUT: «Bag(a(2), b, c, d)␤» 
```

如果任何参数是 [Baggy](https://rakudocs.github.io/type/Baggy) 或 [Mixy](https://rakudocs.github.io/type/Mixy)，则结果是一个包含所有元素的新 `Bag`（或 `Mix`），每个元素都由该元素出现的*最高*权重加权。

If any of the arguments are [Baggy](https://rakudocs.github.io/type/Baggy) or [Mixy](https://rakudocs.github.io/type/Mixy), the result is a new `Bag` (or `Mix`) containing all the elements, each weighted by the *highest* weight that appeared for that element.

```Raku
say <a b d> ∪ bag(<a a b c>); # OUTPUT: «Bag(a(2), b, c, d)␤» 
```

`∪` 相当于 `(|)`，在代码点 U+222A 处。

`∪` is equivalent to `(|)`, at codepoint U+222A (UNION).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%EF%BC%8C%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%8E--infix--infix-%E2%8A%8E"></a>
## 中缀运算符 `(+)`，中缀运算符 `⊎` / infix `(+)`, infix `⊎`

```Raku
multi sub infix:<(+)>(**@p)
multi sub infix:<⊎>(**@p)
```

Baggy（Bag 类型的） 加法运算符。

Baggy addition operator.

返回其参数的 Baggy **和**。这将从参数的每个元素创建一个新的 [Bag](https://rakudocs.github.io/type/Bag)，如果没有参数是 [Mix](https://rakudocs.github.io/type/Mix) 或 [MixHash](https://rakudocs.github.io/type/MixHash)，则将元素的权重相加以获得新的权重。

Returns the Baggy **addition** of its arguments. This creates a new [Bag](https://rakudocs.github.io/type/Bag) from each element of the arguments with the weights of the element added together to get the new weight, if none of the arguments are a [Mix](https://rakudocs.github.io/type/Mix) or [MixHash](https://rakudocs.github.io/type/MixHash).

```Raku
say <a a b c a d> (+) <a a b c c>; # OUTPUT: «Bag(a(5), b(2), c(3), d)␤» 
```

如果任何参数是 [Mixy](https://rakudocs.github.io/type/Mixy)，则结果是一个新的 `Mix`。

If any of the arguments is a [Mixy](https://rakudocs.github.io/type/Mixy), the result is a new `Mix`.

```Raku
say <a b c> (+) (a => 2.5, b => 3.14).Mix; # OUTPUT: «Mix(a(3.5), b(4.14), c)␤» 
```

`⊎` 相当于 `(+)`，在代码点 U+228E 处。

`⊎` is equivalent to `(+)`, at codepoint U+228E (MULTISET UNION).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6--%EF%BC%8C%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%88%96--infix---infix-%E2%88%96"></a>
## 中缀运算符 `(-)`，中缀运算符 `∖` / infix `(-)`, infix `∖`

```Raku
multi sub infix:<(-)>(**@p)
multi sub infix:<∖>(**@p)
```

集合差运算符。

Set difference operator.

返回其所有参数的**集合差**。这将创建一个新的[集合](https://rakudocs.github.io/type/Set)，其中包含第一个参数拥有的所有元素，但其他参数没有，即第一个参数的所有元素减去其他参数的元素。但前提是没有参数是 [Bag](https://rakudocs.github.io/type/Bag)、[BagHash](https://rakudocs.github.io/type/BagHash)、[Mix](https://rakudocs.github.io/type/Mix) 或 [MixHash](https://rakudocs.github.io/type/MixHash)。

Returns the **set difference** of all its arguments. This creates a new [Set](https://rakudocs.github.io/type/Set) that contains all the elements the first argument has but the rest of the arguments don't, i.e., of all the elements of the first argument, minus the elements from the other arguments. But only if none of the arguments are a [Bag](https://rakudocs.github.io/type/Bag), [BagHash](https://rakudocs.github.io/type/BagHash), [Mix](https://rakudocs.github.io/type/Mix) or [MixHash](https://rakudocs.github.io/type/MixHash).

```Raku
say <a a b c a d> (-) <a a b c c>; # OUTPUT: «set(d)␤» 
say <a b c d e> (-) <a b c> (-) <a b d>; # OUTPUT: «set(e)␤» 
```

如果任何参数是 [Baggy](https://rakudocs.github.io/type/Baggy) 或 [Mixy](https://rakudocs.github.io/type/Mixy)，则结果是一个新的 `Bag`（或 `Mix`）包含第一个参数之后剩余的所有元素，其权重减去其他每个参数中该元素的权重。

If any of the arguments are [Baggy](https://rakudocs.github.io/type/Baggy) or [Mixy](https://rakudocs.github.io/type/Mixy), the result is a new `Bag` (or `Mix`) containing all the elements remaining after the first argument with its weight subtracted by the weight of that element in each of the other arguments.

```Raku
say <a a b c a d> (-) bag(<a b c c>); # OUTPUT: «Bag(a(2), d)␤» 
say <a a b c a d>  ∖  mix(<a b c c>); # OUTPUT: «Mix(a(2), c(-1), d)␤» 
```

`∖` 相当于 `(-)`，在代码点 U+2216 处。

`∖` is equivalent to `(-)`, at codepoint U+2216 (SET MINUS).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E--infix-%5E-2"></a>
## 中缀运算符 `(^)` / infix `^`

```Raku
multi sub infix:<^>($a, $b --> Junction:D) is assoc<list>
```

One junction 运算符.

One junction operator.

从其参数创建一个 *one* [Junction](https://rakudocs.github.io/type/Junction)。请参阅 [Junction](https://rakudocs.github.io/type/Junction) 了解更多详细信息。

Creates a *one* [Junction](https://rakudocs.github.io/type/Junction) from its arguments. See [Junction](https://rakudocs.github.io/type/Junction) for more details.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E%EF%BC%8C%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%96--infix-%5E-infix-%E2%8A%96"></a>
## 中缀运算符 `(^)`，中缀运算符 `⊖` / infix `(^)`, infix `⊖`

```Raku
multi sub infix:<(^)>($a, $b)
multi sub infix:<⊖>($a,$b)
 
multi sub infix:<(^)>(**@p)
multi sub infix:<⊖>(**@p)
```

对称集合差运算符。

Symmetric set difference operator.

返回其所有参数的**对称集合差**。这将创建一个新的[集合](https://rakudocs.github.io/type/Set)，由 `$a` 中有但 `$b` 中没有的所有元素和 `$b` 中有但 `$a` 中没有的所有元素组成，如果参数都不是 [Bag](https://rakudocs.github.io/type/Bag)、[BagHash](https://rakudocs.github.io/type/BagHash)、[Mix](https://rakudocs.github.io/type/Mix) 或 [MixHash](https://rakudocs.github.io/type/MixHash)。相当于 `($a ∖ $b) ∪ ($b ∖ $a)`。

Returns the **symmetric set difference** of all its arguments. This creates a new [Set](https://rakudocs.github.io/type/Set) made up of all the elements that `$a` has but `$b` doesn't and all the elements `$b` has but `$a` doesn't if none of the arguments are a [Bag](https://rakudocs.github.io/type/Bag), [BagHash](https://rakudocs.github.io/type/BagHash), [Mix](https://rakudocs.github.io/type/Mix) or [MixHash](https://rakudocs.github.io/type/MixHash). Equivalent to `($a ∖ $b) ∪ ($b ∖ $a)`.

```Raku
say <a b> (^) <b c>; # OUTPUT: «set(a c)␤» 
```

如果任何参数是 [Baggy](https://rakudocs.github.io/type/Baggy) 或 [Mixy](https://rakudocs.github.io/type/Mixy)，则结果是一个新的 `Bag`（或 `Mix`）。

If any of the arguments are [Baggy](https://rakudocs.github.io/type/Baggy) or [Mixy](https://rakudocs.github.io/type/Mixy), the result is a new `Bag` (or `Mix`).

```Raku
say <a b> ⊖ bag(<b c>); # OUTPUT: «Bag(a, c)␤» 
```

`⊖` 相当于 `(^)`，在代码点 U+2296 处。

`⊖` is equivalent to `(^)`, at codepoint U+2296 (CIRCLED MINUS).

<a id="%E5%91%BD%E5%90%8D%E4%B8%80%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--named-unary-precedence"></a>
# 命名一元运算符优先级 / Named unary precedence

<a id="%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-temp--prefix-temp"></a>
## 前缀运算符 `temp` / prefix `temp`

```Raku
sub prefix:<temp>(Mu $a is rw)
```

“临时化”作为参数传递的变量。变量以与外部作用域中相同的值开头，但可以在此作用域中分配新值。退出作用域后，变量将还原为其原始值。

"temporizes" the variable passed as the argument. The variable begins with the same value as it had in the outer scope, but can be assigned new values in this scope. Upon exiting the scope, the variable will be restored to its original value.

```Raku
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

你还可以在调用 temp 时立即赋值：

You can also assign immediately as part of the call to temp:

```Raku
temp $a = "five";
```

请注意，一旦离开 `temp` 所在的代码块，`temp` 效果就会被移除。如果要在 `temp` 效果消失后从 [Promise](https://rakudocs.github.io/type/Promise) 中访问该值，你将获得原始值，而不是 `temp`：

Be warned the `temp` effects get removed once the block is left. If you were to access the value from, say, within a [Promise](https://rakudocs.github.io/type/Promise) after the `temp` was undone, you'd get the original value, not the `temp` one:

```Raku
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

<a id="%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-let--prefix-let"></a>
## 前缀运算符 `let` / prefix `let`

```Raku
sub prefix:<let>(Mu $a is rw)
```

引用外部作用域中的变量，如果代码块以失败退出，该变量的值将被还原，这意味着代码块返回了定义的对象。

Refers to a variable in an outer scope whose value will be restored if the block exits unsuccessfully, implying that the block returned a defined object.

```Raku
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

此代码为 `$name` 提供默认名称。如果用户退出输入提示或只是没有为 `$name` 提供有效输入，`let` 将恢复顶部提供的默认值。如果用户输入是有效的，代码块不会终止，`$name` 将保持输入值。

This code provides a default name for `$name`. If the user exits from the prompt or simply does not provide a valid input for `$name`; `let` will restore the default value provided at the top. If user input is valid, it will keep that.

<a id="%E9%9D%9E%E9%93%BE%E5%BC%8F%E4%BA%8C%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--nonchaining-binary-precedence"></a>
# 非链式二元运算符优先级 / Nonchaining binary precedence

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-does--infix-does"></a>
## 中缀运算符 `does` / infix `does`

```Raku
sub infix:<does>(Mu $obj, Mu $role) is assoc<non>
```

在运行时将角色 `$role` 混入对象 `$obj`。需要对象 `$obj` 是可修改的。

Mixes `$role` into `$obj` at runtime. Requires `$obj` to be mutable.

类似于 [but](https://rakudocs.github.io/routine/but) 操作符，角色 `$role` 可以改为一个实例化对象，在这种情况下，操作符将自动为你创建一个角色。角色将包含一个名为 `$obj.^name` 的方法，该方法返回 `$obj`：

Similar to [but](https://rakudocs.github.io/routine/but) operator, the `$role` can instead be an instantiated object, in which case, the operator will create a role for you automatically. The role will contain a single method named the same as `$obj.^name` and that returns `$obj`:

```Raku
my $o = class { method Str { "original" } }.new;
put $o;            # OUTPUT: «original␤» 
$o does "modded";
put $o;            # OUTPUT: «modded␤»
```

如果已经存在同名的方法，则以最后一个混入角色为准。

If methods of the same name are present already, the last mixed in role takes precedence.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-but--infix-but"></a>
## 中缀运算符 `but` / infix `but`

```Raku
multi sub infix:<but>(Mu $obj1, Mu   $role) is assoc<non>
multi sub infix:<but>(Mu $obj1, Mu:D $obj2) is assoc<non>
```

创建一个混入角色 `$role` 的 `$obj` 对象副本。因为对象 `$obj` 没有被修改，`but` 可以用于用角色混入方法创建不可变的值。

Creates a copy of `$obj` with `$role` mixed in. Since `$obj` is not modified, `but` can be used to created immutable values with mixins.

`but` 右边参数可以提供实例化的对象，而不是角色。在这种情况下，操作员将自动为你创建角色。角色将包含一个名为 `$obj.^name` 的方法，该方法返回 `$obj`：

Instead of a role, you can provide an instantiated object. In this case, the operator will create a role for you automatically. The role will contain a single method named the same as `$obj.^name` and that returns `$obj`:

```Raku
my $forty-two = 42 but 'forty two';
say $forty-two+33;    # OUTPUT: «75␤» 
say $forty-two.^name; # OUTPUT: «Int+{<anon|1>}␤» 
say $forty-two.Str;   # OUTPUT: «forty two␤» 
```

调用 `^name` 表明变量是一个 `Int`，其中混合了匿名对象。但是，这个对象是 `Str` 类型的，所以通过角色混入，变量被赋予了一个具有该名称的方法，这就是我们在最后一句中使用的方法。

Calling `^name` shows that the variable is an `Int` with an anonymous object mixed in. However, that object is of type `Str`, so the variable, through the mixin, is endowed with a method with that name, which is what we use in the last sentence.

我们也可以混合类，甚至可以动态创建。

We can also mixin classes, even created on the fly.

```Raku
my $s = 12 but class Warbles { method hi { 'hello' } }.new;
say $s.Warbles.hi;    # OUTPUT: «hello␤» 
say $s + 42;          # OUTPUT: «54␤» 
```

要访问混进去的类，如上所述，我们使用第二句话中所示的类名。如果已经存在同名的方法，则以最后一个混入角色为准。可以在用逗号分隔的括号中提供方法列表。在这种情况下，将在运行时报告冲突。

To access the mixed-in class, as above, we use the class name as is shown in the second sentence. If methods of the same name are present already, the last mixed in role takes precedence. A list of methods can be provided in parentheses separated by comma. In this case conflicts will be reported at runtime.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-cmp--infix-cmp"></a>
## 中缀运算符 `cmp` / infix `cmp`

```Raku
multi sub infix:<cmp>(Any,       Any)
multi sub infix:<cmp>(Real:D,    Real:D)
multi sub infix:<cmp>(Str:D,     Str:D)
multi sub infix:<cmp>(Version:D, Version:D)
```

通用，“智能”三路比较器。

Generic, "smart" three-way comparator.

用字符串语义比较字符串，用数字语义比较数字，[Pair](https://rakudocs.github.io/type/Pair) 对象首先按键比较，然后按值比较等等。

Compares strings with string semantics, numbers with number semantics, [Pair](https://rakudocs.github.io/type/Pair) objects first by key and then by value etc.

如果 `$a eqv $b` 为真值，则 `$a cmp $b` 总是返回 `Order::Same`。

if `$a eqv $b`, then `$a cmp $b` always returns `Order::Same`.

```Raku
say (a => 3) cmp (a => 4);   # OUTPUT: «Less␤» 
say 4        cmp 4.0;        # OUTPUT: «Same␤» 
say 'b'      cmp 'a';        # OUTPUT: «More␤»
```

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-coll--infix-coll"></a>
## 中缀运算符 `coll` / infix `coll`

定义：

Defined as:

```Raku
multi sub infix:<coll>(Str:D \a, Str:D \b --> Order:D)
multi sub infix:<coll>(Cool:D \a, Cool:D \b --> Order:D)
multi sub infix:<coll>(Pair:D \a, Pair:D \b --> Order:D)
```

`coll` 是一个排序运算符，它接受对 `Str`、`Cool` 或 `Pair` 对，并返回使用 `$*COLLATION` 排序规则的 `Order`。例如，默认行为忽略变音符号和大写。

`coll` is a sorting operator that takes pairs of `Str`s, `Cool`s or `Pair`s and returns an `Order` that uses the `$*COLLATION` order. The default behavior disregards diacritic marks and capitalization, for instance.

```Raku
say "b" cmp "à";  # OUTPUT: «Less␤» 
say "b" coll "à"; # OUTPUT: «More␤»
```

在第一种情况下，考虑字典顺序或码位顺序。第二种是使用 `coll`，不考虑变音符号，按照直觉顺序进行排序。

In the first case, lexicographic or codepoint order is taken into account. In the second, which uses `coll`, the diacritic is not considered and sorting happens according to intuitive order.

**注意：**这些还没有在 JVM 中实现。

**NOTE:** These are not yet implemented in the JVM.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-unicmp--infix-unicmp"></a>
## 中缀运算符 `unicmp` / infix `unicmp`

定义：

Defined as:

```Raku
multi sub infix:<unicmp>(Str:D \a, Str:D \b --> Order:D)
multi sub infix:<unicmp>(Pair:D \a, Pair:D \b --> Order:D)
multi sub infix:<coll>(Pair:D \a, Pair:D \b --> Order:D)
```

与根据码位进行排序的 cmp 运算符不同，`unicmp` 和 `coll` 根据大多数用户的预期进行排序，也就是说，不考虑特定字符的大小写等方面。

Unlike the cmp operator which sorts according to codepoint, `unicmp` and `coll` sort according to how most users would expect, that is, disregarding aspects of the particular character like capitalization.

```Raku
say 'a' unicmp 'Z'; # Less 
say 'a' coll 'Z';   # Less 
say 'a' cmp 'Z';    # More
```

`coll` 和 `unicmp` 的主要区别在于前者的行为可以通过 [`$*COLLATION`](https://rakudocs.github.io/type/Any#index-entry-%24*COLLATION-%24*COLLATION) 动态变量来更改。

The main difference between `coll` and `unicmp` is that the behavior of the former can be changed by the [`$*COLLATION`](https://rakudocs.github.io/type/Any#index-entry-%24*COLLATION-%24*COLLATION) dynamic variable.

**注意：**这些还没有在 JVM 中实现。

**NOTE:** These are not yet implemented in the JVM.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-leg--infix-leg"></a>
## 中缀运算符 `leg` / infix `leg`

```Raku
multi sub infix:<leg>(Any,   Any)
multi sub infix:<leg>(Str:D, Str:D)
```

字符串三向比较器。*less、equal 或 greater？* 的简称。

String three-way comparator. Short for *less, equal or greater?*.

将两个参数强制为 [Str](https://rakudocs.github.io/type/Str)，然后进行词典比较。

Coerces both arguments to [Str](https://rakudocs.github.io/type/Str) and then does a lexicographic comparison.

```Raku
say 'a' leg 'b';       # OUTPUT: «Less␤» 
say 'a' leg 'a';       # OUTPUT: «Same␤» 
say 'b' leg 'a';       # OUTPUT: «More␤»
```

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6--infix-"></a>
## 中缀运算符 `<=>` / infix `<=>`

```Raku
multi sub infix:«<=>»($a, $b --> Order:D) is assoc<non>
```

数值三向比较器。

Numeric three-way comparator.

将两个参数强制转换为[实数](https://rakudocs.github.io/type/Real)类型，然后进行数值比较。

Coerces both arguments to [Real](https://rakudocs.github.io/type/Real) and then does a numeric comparison.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--9"></a>
## 中缀运算符 `..` / infix `..`

```Raku
multi sub infix:<..>($a, $b --> Range:D) is assoc<non>
```

范围运算符

Range operator

从参数构造一个[范围](https://rakudocs.github.io/type/Range)。

Constructs a [Range](https://rakudocs.github.io/type/Range) from the arguments.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E--infix-%5E-3"></a>
## 中缀运算符 `..^` / infix `..^`

```Raku
multi sub infix:<..^>($a, $b --> Range:D) is assoc<non>
```

右开范围运算符。

Right-open range operator.

从参数构造[范围](https://rakudocs.github.io/type/Range)，不包括终点。

Constructs a [Range](https://rakudocs.github.io/type/Range) from the arguments, excluding the end point.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E--infix-%5E-4"></a>
## 中缀运算符 `^..` / infix `^..`

```Raku
multi sub infix:<^..>($a, $b --> Range:D) is assoc<non>
```

左开范围运算符。

Left-open range operator.

从参数构造[范围](https://rakudocs.github.io/type/Range)，不包括起点。

Constructs a [Range](https://rakudocs.github.io/type/Range) from the arguments, excluding the start point.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E%5E--infix-%5E%5E"></a>
## 中缀运算符 `^..^` / infix `^..^`

```Raku
multi sub infix:<^..^>($a, $b --> Range:D) is assoc<non>
```

开放范围运算符

Open range operator

从参数构造[范围](https://rakudocs.github.io/type/Range)，不包括起点和终点。

Constructs a [Range](https://rakudocs.github.io/type/Range) from the arguments, excluding both start and end point.

<a id="%E9%93%BE%E5%BC%8F%E4%BA%8C%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--chaining-binary-precedence"></a>
# 链式二元运算符优先级 / Chaining binary precedence

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--10"></a>
## 中缀运算符 `==` / infix `==`

```Raku
multi sub infix:<==>(Any, Any)
multi sub infix:<==>(Int:D, Int:D)
multi sub infix:<==>(Num:D, Num:D)
multi sub infix:<==>(Rational:D, Rational:D)
multi sub infix:<==>(Real:D, Real:D)
multi sub infix:<==>(Complex:D, Complex:D)
multi sub infix:<==>(Numeric:D, Numeric:D)
```

数值相等运算符。

Numeric equality operator.

将两个参数强制为[数值](https://rakudocs.github.io/type/Numeric)（如果需要）；如果它们相等，则返回真值。

Coerces both arguments to [Numeric](https://rakudocs.github.io/type/Numeric) (if necessary); returns `True` if they are equal.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--11"></a>
## 中缀运算符 `!=` / infix `!=`

```Raku
sub infix:<!=>(Mu, Mu --> Bool:D)
```

数值不相等运算符。

Numeric inequality operator.

将两个参数强制为[数值](https://rakudocs.github.io/type/Numeric)（如果需要）；如果它们是不同的，则返回真值。

Coerces both arguments to [Numeric](https://rakudocs.github.io/type/Numeric) (if necessary); returns `True` if they are distinct.

是 `!==` 的别名。

Is an alias to `!==`.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%89%A0--infix-%E2%89%A0"></a>
## 中缀运算符 `≠` / infix `≠`

数值不相等运算符。

Numeric inequality operator.

相当于 [!=](https://rakudocs.github.io/routine/!=)，在码位 U+2260。

Equivalent to [!=](https://rakudocs.github.io/routine/!=), at codepoint U+2260 (NOT EQUAL TO).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--12"></a>
## 中缀运算符 `<` / infix `<`

```Raku
multi sub infix:«<»(Int:D, Int:D)
multi sub infix:«<»(Num:D, Num:D)
multi sub infix:«<»(Real:D, Real:D)
```

数值小于运算符。

Numeric less than operator.

将两个参数强制为[实数](https://rakudocs.github.io/type/Real)（如果需要）；如果第一个参数小于第二个参数，则返回真值。

Coerces both arguments to [Real](https://rakudocs.github.io/type/Real) (if necessary); returns `True` if the first argument is smaller than the second.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--13"></a>
## 中缀运算符 `<=` / infix `<=`

```Raku
multi sub infix:«<=»(Int:D, Int:D)
multi sub infix:«<=»(Num:D, Num:D)
multi sub infix:«<=»(Real:D, Real:D)
```

数值小于或等于运算符。

Numeric less than or equal to operator.

将两个参数强制为[实数](https://rakudocs.github.io/type/Real)（如果需要）；如果第一个参数小于或等于第二个参数，则返回真值。

Coerces both arguments to [Real](https://rakudocs.github.io/type/Real) (if necessary); returns `True` if the first argument is smaller than or equal to the second.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%89%A4--infix-%E2%89%A4"></a>
## 中缀运算符 `≤` / infix `≤`

数值小于或等于运算符。

Numeric less than or equal to operator.

相当于 [<=](https://rakudocs.github.io/language/routine/%3C=)，在码位 U+2264。

Equivalent to [<=](https://rakudocs.github.io/language/routine/%3C=), at codepoint U+2264 (LESS-THAN OR EQUAL TO).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--14"></a>
## 中缀运算符 `>` / infix `>`

```Raku
multi sub infix:«>»(Int:D, Int:D)
multi sub infix:«>»(Num:D, Num:D)
multi sub infix:«>»(Real:D, Real:D)
```

数值大于运算符。

Numeric greater than operator.

将两个参数强制为[实数](https://rakudocs.github.io/type/Real)（如果需要）；如果第一个参数大于第二个参数，则返回真值。

Coerces both arguments to [Real](https://rakudocs.github.io/type/Real) (if necessary); returns `True` if the first argument is larger than the second.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--15"></a>
## 中缀运算符 `>=` / infix `>=`

```Raku
multi sub infix:«>=»(Int:D, Int:D)
multi sub infix:«>=»(Num:D, Num:D)
multi sub infix:«>=»(Real:D, Real:D)
```

数值大于或等于运算符。

Numeric greater than or equal to operator.

将两个参数强制为[实数](https://rakudocs.github.io/type/Real)（如果需要）；如果第一个参数大于或等于第二个参数，则返回真值。

Coerces both arguments to [Real](https://rakudocs.github.io/type/Real) (if necessary); returns `True` if the first argument is larger than or equal to the second.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%89%A5--infix-%E2%89%A5"></a>
## 中缀运算符 `≥` / infix `≥`

数值大于或等于运算符。

Numeric greater than or equal to operator.

相当于 [>=](https://rakudocs.github.io/routine/%3E=)，在码位 U+2265。

Equivalent to [>=](https://rakudocs.github.io/routine/%3E=), at codepoint U+2265 (GREATER-THAN OR EQUAL TO).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-eq--infix-eq"></a>
## 中缀运算符 `eq` / infix `eq`

```Raku
multi sub infix:<eq>(Any,   Any)
multi sub infix:<eq>(Str:D, Str:D)
```

字符串等于运算符。

String equality operator.

将两个参数强制为 [Str](https://rakudocs.github.io/type/Str)（如果需要）；如果两个参数相等，则返回真值。

Coerces both arguments to [Str](https://rakudocs.github.io/type/Str) (if necessary); returns `True` if both are equal.

助记符：*等于*

Mnemonic: *equal*

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-ne--infix-ne"></a>
## 中缀运算符 `ne` / infix `ne`

```Raku
multi sub infix:<ne>(Mu,    Mu)
multi sub infix:<ne>(Str:D, Str:D)
```

字符串不等于运算符。

String inequality operator.

将两个参数强制为 [Str](https://rakudocs.github.io/type/Str)（如果需要）；如果两个参数相等，则返回假值。

Coerces both arguments to [Str](https://rakudocs.github.io/type/Str) (if necessary); returns `False` if both are equal.

助记符：*不等于*

Mnemonic: *not equal*

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-gt--infix-gt"></a>
## 中缀运算符 `gt` / infix `gt`

```Raku
multi sub infix:<gt>(Mu,    Mu)
multi sub infix:<gt>(Str:D, Str:D)
```

字符串大于运算符。

String greater than operator.

将两个参数强制为 [Str](https://rakudocs.github.io/type/Str)（如果需要）；如果第一个参数大于第二个，则返回假值，取决于词典比较。

Coerces both arguments to [Str](https://rakudocs.github.io/type/Str) (if necessary); returns `True` if the first is larger than the second, as determined by lexicographic comparison.

助记符：*大于*

Mnemonic: *greater than*

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-ge--infix-ge"></a>
## 中缀运算符 `ge` / infix `ge`

```Raku
multi sub infix:<ge>(Mu,    Mu)
multi sub infix:<ge>(Str:D, Str:D)
```

字符串大于或等于运算符。

String greater than or equal to operator.

将两个参数强制为 [Str](https://rakudocs.github.io/type/Str)（如果需要）；如果第一个参数大于第二个，则返回真值，取决于词典比较。

Coerces both arguments to [Str](https://rakudocs.github.io/type/Str) (if necessary); returns `True` if the first is equal to or larger than the second, as determined by lexicographic comparison.

助记符：*大于或等于*

Mnemonic: *greater or equal*

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-lt--infix-lt"></a>
## 中缀运算符 `lt` / infix `lt`

```Raku
multi sub infix:<lt>(Mu,    Mu)
multi sub infix:<lt>(Str:D, Str:D)
```

字符串小于运算符。

String less than operator.

将两个参数强制为 [Str](https://rakudocs.github.io/type/Str)（如果需要）；如果第一个参数小于第二个，则返回真值，取决于词典比较。

Coerces both arguments to [Str](https://rakudocs.github.io/type/Str) (if necessary); returns `True` if the first is smaller than the second, as determined by lexicographic comparison.

助记符：*小于*

Mnemonic: *less than*

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-le--infix-le"></a>
## 中缀运算符 `le` / infix `le`

```Raku
multi sub infix:<le>(Mu,    Mu)
multi sub infix:<le>(Str:D, Str:D)
```

字符串小于或等于运算符。

String less than or equal to operator.

将两个参数强制为 [Str](https://rakudocs.github.io/type/Str)（如果需要）；如果第一个参数等于或小于第二个，则返回真值，取决于词典比较。

Coerces both arguments to [Str](https://rakudocs.github.io/type/Str) (if necessary); returns `True` if the first is equal to or smaller than the second, as determined by lexicographic comparison.

助记符：*小于或等于*

Mnemonic: *less or equal*

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-before--infix-before"></a>
## 中缀运算符 `before` / infix `before`

```Raku
multi sub infix:<before>(Any,       Any)
multi sub infix:<before>(Real:D,    Real:D)
multi sub infix:<before>(Str:D,     Str:D)
multi sub infix:<before>(Version:D, Version:D)
```

通用排序，使用与 [cmp](https://rakudocs.github.io/routine/cmp) 运算符相同的语义。如果第一个参数小于第二个参数，则返回真值。

Generic ordering, uses the same semantics as [cmp](https://rakudocs.github.io/routine/cmp). Returns `True` if the first argument is smaller than the second.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-after--infix-after"></a>
## 中缀运算符 `after` / infix `after`

```Raku
multi sub infix:<after>(Any,       Any)
multi sub infix:<after>(Real:D,    Real:D)
multi sub infix:<after>(Str:D,     Str:D)
multi sub infix:<after>(Version:D, Version:D)
```

通用排序，使用与 [cmp](https://rakudocs.github.io/routine/cmp) 运算符相同的语义。如果第一个参数大于第二个参数，则返回真值。

Generic ordering, uses the same semantics as [cmp](https://rakudocs.github.io/routine/cmp). Returns `True` if the first argument is larger than the second.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-eqv--infix-eqv"></a>
## 中缀运算符 `eqv` / infix `eqv`

```Raku
sub infix:<eqv>(Any, Any)
```

等价运算符。如果两个参数在结构上相同，即来自同一类型且（递归地）包含等效值，则返回真值。

Equivalence operator. Returns `True` if the two arguments are structurally the same, i.e. from the same type and (recursively) contain equivalent values.

```Raku
say [1, 2, 3] eqv [1, 2, 3];    # OUTPUT: «True␤» 
say Any eqv Any;                # OUTPUT: «True␤» 
say 1 eqv 2;                    # OUTPUT: «False␤» 
say 1 eqv 1.0;                  # OUTPUT: «False␤»
```

不能比较惰性 [`Iterables`](https://rakudocs.github.io/type/Iterable) 类型，因为它们被认为是无限的。但是，如果两个惰性 `Iterable` 是不同类型的，或者只有一个 `Iterable` 是惰性的，则运算符将尽力返回假值。

Lazy [`Iterables`](https://rakudocs.github.io/type/Iterable) cannot be compared, as they're assumed to be infinite. However, the operator will do its best and return `False` if the two lazy `Iterables` are of different types or if only one `Iterable` is lazy.

```Raku
say (1…∞) eqv (1…∞).List; # Both lazy, but different types;   OUTPUT: «False␤» 
say (1…∞) eqv (1…3);      # Same types, but only one is lazy; OUTPUT: «False␤» 
(try say (1…∞) eqv (1…∞)) # Both lazy and of the same type. Cannot compare; throws. 
    orelse say $!.^name;  # OUTPUT: «X::Cannot::Lazy␤»
```

默认的 `eqv` 运算符甚至可以用于任意对象。例如，`eqv` 将同一对象的两个实例视为在结构上等效：

The default `eqv` operator even works with arbitrary objects. E.g., `eqv` will consider two instances of the same object as being structurally equivalent:

```Raku
my class A {
    has $.a;
}
say A.new(a => 5) eqv A.new(a => 5);  # OUTPUT: «True␤»
```

尽管上面的示例按预期工作，`eqv` 代码可能会返回到较慢的代码路径以完成其工作。避免这种情况的一种方法是实现适当的中缀 `eqv` 运算符：

Although the above example works as intended, the `eqv` code might fall back to a slower code path in order to do its job. One way to avoid this is to implement an appropriate infix `eqv` operator:

```Raku
my class A {
    has $.a;
}
multi infix:<eqv>(A $l, A $r) { $l.a eqv $r.a }
say A.new(a => 5) eqv A.new(a => 5);            # OUTPUT: «True␤»
```

请注意，`eqv` 不是对每种容器类型都递归地比较，例如 `Set`：

Note that `eqv` does not work recursively on every kind of container type, e.g. `Set`:

```Raku
my class A {
    has $.a;
}
say Set(A.new(a => 5)) eqv Set(A.new(a => 5));  # OUTPUT: «False␤»
```

即使这两个集合的内容是相等的，但集合本身不相等。原因是 `eqv` 将相等性检查委托给 `Set` 对象，该对象依赖于元素以 `===` 比较。给它一个 `WHICH` 方法将类 `A` 转换为 [value 类型](https://rakudocs.github.io/type/ValueObjAt)来产生预期的行为：

Even though the contents of the two sets are `eqv`, the sets are not. The reason is that `eqv` delegates the equality check to the `Set` object which relies on element-wise `===` comparison. Turning the class `A` into a [value type](https://rakudocs.github.io/type/ValueObjAt) by giving it a `WHICH` method produces the expected behavior:

```Raku
my class A {
    has $.a;
    method WHICH {
        ValueObjAt.new: "A|$!a.WHICH()"
    }
}
say Set(A.new(a => 5)) eqv Set(A.new(a => 5));  # OUTPUT: «True␤»
```

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--16"></a>
## 中缀运算符 `===` / infix `===`

```Raku
sub infix:<===>(Any, Any)
```

值标识运算符。如果两个参数是同一个对象，则返回真值，而不考虑任何容器化。

Value identity operator. Returns `True` if both arguments are the same object, disregarding any containerization.

```Raku
my class A { };
my $a = A.new;
say $a === $a;              # OUTPUT: «True␤» 
say A.new === A.new;        # OUTPUT: «False␤» 
say A === A;                # OUTPUT: «True␤»
```

对于值类型，`===` 的行为类似于 `eqv`：

For value types, `===` behaves like `eqv`:

```Raku
say 'a' === 'a';            # OUTPUT: «True␤» 
say 'a' === 'b';            # OUTPUT: «False␤» 
 
my $b = 'a';
say $b === 'a';             # OUTPUT: «True␤» 
 
# different types 
say 1 === 1.0;              # OUTPUT: «False␤»
```

`===` 使用 [WHICH](https://rakudocs.github.io/routine/WHICH) 方法获取对象标识。

`===` uses the [WHICH](https://rakudocs.github.io/routine/WHICH) method to obtain the object identity.

如果你想创建一个应该作为值类型的类，那么该类必须创建一个实例方法 `WHICH`，它应该返回一个在对象生命周期内不会改变的 [ValueObjAt](https://rakudocs.github.io/type/ValueObjAt) 对象。

If you want to create a class that should act as a value type, then that class must create an instance method `WHICH`, that should return a [ValueObjAt](https://rakudocs.github.io/type/ValueObjAt) object that won't change for the lifetime of the object.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--17"></a>
## 中缀运算符 `=:=` / infix `=:=`

```Raku
multi sub infix:<=:=>(Mu \a, Mu \b)
```

容器标识运算符。如果两个参数绑定到同一容器，则返回真值。如果返回真值，通常意味着修改一个也将修改另一个。

Container identity operator. Returns `True` if both arguments are bound to the same container. If it returns `True`, it generally means that modifying one will also modify the other.

```Raku
my ($a, $b) = (1, 3);
say $a =:= $b;      # OUTPUT: «False␤» 
$b = 2;
say $a;             # OUTPUT: «1␤» 
$b := $a;
say $a =:= $b;      # OUTPUT: «True␤» 
$a = 5;
say $b;             # OUTPUT: «5␤»
```

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7E%7E--infix-%7E%7E"></a>
## 中缀运算符 `~~` / infix `~~`

智能匹配运算符将左边的别名设为 `$_`，然后对右边求值并调用 `.ACCEPTS($_)`。语义留给右侧操作数的类型。

The smartmatch operator aliases the left-hand side to `$_`, then evaluates the right-hand side and calls `.ACCEPTS($_)` on it. The semantics are left to the type of the right-hand side operand.

下面是一些内置智能匹配功能的部分列表。有关完整的详细信息，请参见 [ACCEPTS](https://rakudocs.github.io/routine/ACCEPTS) 操作员右侧类型的文档。

Here is a partial list of some of the built-in smartmatching functionality. For full details, see [ACCEPTS](https://rakudocs.github.io/routine/ACCEPTS) documentation for the type on the right-hand side of the operator.

| Right-hand side | Comparison semantics         |
| --------------- | ---------------------------- |
| Mu:U            | type check                   |
| Str             | string equality              |
| Numeric         | numeric equality             |
| Regex           | regex match                  |
| Callable        | boolean result of invocation |
| Set/Bag         | equal element values         |
| Any:D           | object identity              |

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7E--infix-%7E-4"></a>
## 中缀运算符 `=~=` / infix `=~=`

```Raku
multi sub infix:<=~=>(Any, Any)
multi sub infix:<=~=>(Int:D, Int:D)
multi sub infix:<=~=>(Num:D, Num:D)
multi sub infix:<=~=>(Rational:D, Rational:D)
multi sub infix:<=~=>(Real:D, Real:D)
multi sub infix:<=~=>(Complex:D, Complex:D)
multi sub infix:<=~=>(Numeric:D, Numeric:D)
```

近似相等运算符 `≅`（其 ASCII 变体为 `=~=`）计算左侧和右侧之间的相对差，如果差小于 `$*TOLERANCE`（默认为 1e-15），则返回真值。但是，如果两边都是零，那么它会检查两边之间的绝对差是否小于 `$*TOLERANCE`。注意，该运算符不是算术对称的（不做 ± Δ）：

The approximately-equal operator `≅`, whose ASCII variant is `=~=`, calculates the relative difference between the left-hand and right-hand sides and returns `True` if the difference is less than `$*TOLERANCE` (which defaults to 1e-15). However, if either side is zero then it checks that the absolute difference between the sides is less than `$*TOLERANCE`. Note that this operator is not arithmetically symmetrical (doesn't do ± Δ):

```Raku
my $x = 1;
say ($x + $*TOLERANCE) =~= $x;   # OUTPUT: «False␤» 
say ($x - $*TOLERANCE) =~= $x;   # OUTPUT: «True␤»
```

公差应该可以通过副词修改：

The tolerance is supposed to be modifiable via an adverb:

```Raku
my ($x, $y) = 42, 42.1;
say $x =~= $y :tolerance(.1);
```

然而，这一点尚未实现。同样的效果也可以通过赋值 $*TOLERANCE 来实现。

However, this is not yet implemented. The same effect can be achieved by assigning to $*TOLERANCE.

```Raku
{
    my $*TOLERANCE = .1;
    say 11 =~= 10;        # OUTPUT: «True␤» 
}
```

Note that setting $*TOLERANCE = 0 will cause all comparisons to fail.

请注意，设置 $*TOLERANCE = 0 将导致所有比较失败。

```Raku
{
    my $*TOLERANCE = 0;
    say 1 =~= 1;          # OUTPUT: «False␤» 
}
```

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-elem%EF%BC%8C%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%88%88%C2%BB--infix-elem-infix-%E2%88%88%C2%BB"></a>
## 中缀运算符 (elem)，中缀运算符 ∈» / infix (elem), infix ∈»

```Raku
multi sub infix:<(elem)>($a,$b --> Bool:D)
multi sub infix:<∈>($a,$b --> Bool:D)
```

成员运算符。

Membership operator.

如果 `$a` 是 `$b` 的*成员*则返回真值。

Returns `True` if `$a` is an **element** of `$b`.

```Raku
say 2 (elem) (1, 2, 3); # OUTPUT: «True␤» 
say 4 ∈ (1, 2, 3); # OUTPUT: «False␤» 
```

`∈` 等同于 `(elem)`，在码位 U+2208。

`∈` is equivalent to `(elem)`, at codepoint U+2208 (ELEMENT OF).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%88%89--infix-%E2%88%89"></a>
## 中缀运算符 `∉` / infix `∉`

```Raku
multi sub infix:<∉>($a,$b --> Bool:D)
```

非成员运算符。

Non-membership operator.

如果 `$a` 不是 `$b` 的*成员*则返回真值。相当于 `!(elem)`。

Returns `True` if `$a` is **not** an **element** of `$b`. Equivalent to `!(elem)`.

```Raku
say 4 ∉ (1, 2, 3); # OUTPUT: «True␤» 
say 2 !(elem) (1, 2, 3); # OUTPUT: «False␤» 
```

`∉` 在码位 U+2209。

`∉` is codepoint U+2209 (NOT AN ELEMENT OF).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-cont%EF%BC%8C%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%88%8B%C2%BB--infix-cont-infix-%E2%88%8B%C2%BB"></a>
## 中缀运算符 (cont)，中缀运算符 ∋» / infix (cont), infix ∋»

```Raku
multi sub infix:<(cont)>($a,$b --> Bool:D)
multi sub infix:<∋>($a,$b --> Bool:D)
```

成员运算符。

Membership operator.

如果 `$b` 是 `$a` 的*成员*则返回真值。

Returns `True` if `$a` is an **element** to `$b`.

```Raku
say (1,2,3) (cont) 2; # OUTPUT: «True␤» 
say (1, 2, 3) ∋ 4; # OUTPUT: «False␤» 
```

`∈` 等同于 `(cont)`，在码位 U+220B。

`∋` is equivalent to `(cont)`, at codepoint U+220B (CONTAINS AS MEMBER).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%88%8C--infix-%E2%88%8C"></a>
## 中缀运算符 `∌` / infix `∌`

```Raku
multi sub infix:<∌>($a,$b --> Bool:D)
```

非成员运算符。

Non-membership operator.

如果 `$b` 不是 `$a` 的*成员*则返回真值。相当于 `!(cont)`。

Returns `True` if `$a` is **not** an **element** to `$b`. Equivalent to `!(cont)`.

```Raku
say (1,2,3) ∌ 4; # OUTPUT: «True␤» 
say (1,2,3) !(cont) 2; # OUTPUT: «False␤» 
```

`∉` 在码位 U+220C。

`∉` is codepoint U+220C (DOES NOT CONTAIN AS MEMBER).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6--%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%82--infix--infix-%E2%8A%82"></a>
## 中缀运算符 `(<)`, 中缀运算符 `⊂` / infix `(<)`, infix `⊂`

```Raku
multi sub infix:<< (<) >>($a,$b --> Bool:D)
multi sub infix:<⊂>($a,$b --> Bool:D)
```

子集运算符。

Subset of operator.

如果 `$a` 是 `$b` 的一个*严格子集*，则返回真值，即 `$a` 的所有元素都是 `$b` 的元素，但 `$a` 的集合小于 `$b`。

Returns `True` if `$a` is a **strict subset** of `$b`, i.e., that all the elements of `$a` are elements of `$b` but `$a` is a smaller set than `$b`.

```Raku
say (1,2,3) (<) (2,3,1); # OUTPUT: «False␤» 
say (2,3) (<) (2,3,1); # OUTPUT: «True␤» 
say 4 ⊂ (1,2,3); # OUTPUT: «False␤» 
```

`⊂` 等同于 `(<)`，在码位 U+2282。

`⊂` is equivalent to `(<)`, at codepoint U+2282 (SUBSET OF).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%84--infix-%E2%8A%84"></a>
## 中缀运算符 `⊄` / infix `⊄`

```Raku
multi sub infix:<⊄>($a,$b --> Bool:D)
```

非子集运算符。

Not a subset of operator.

如果 `$a` *不*是 `$b` 的一个*严格子集*，则返回真值。相当于 `!(<)`。

Returns `True` if `$a` is **not** a `strict subset` of `$b`. Equivalent to `!(<)`.

```Raku
say (1,2,3) ⊄ (2,3,1); # OUTPUT: «True␤» 
say (2,3) ⊄ (2,3,1); # OUTPUT: «False␤» 
say 4 !(<) (1,2,3); # OUTPUT: «True␤» 
```

`⊄` 在码位 U+2284。

`⊄` is codepoint U+2284 (NOT A SUBSET OF).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6--%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%86--infix--infix-%E2%8A%86"></a>
## 中缀运算符 `(<=)`, 中缀运算符 `⊆` / infix `(<=)`, infix `⊆`

```Raku
multi sub infix:<< (<=) >>($a,$b --> Bool:D)
multi sub infix:<⊆>($a,$b --> Bool:D)
```

包含于运算符。

Subset of or equal to operator.

如果 `$a` 是 `$b` 的**子集**，则返回真值，即 `$a` 的所有元素都是 `$b` 的元素，但 `$a` 的集合大小小于或等于 `$b` 的集合。

Returns `True` if `$a` is a **subset** of `$b`, i.e., that all the elements of `$a` are elements of `$b` but `$a` is a smaller or equal sized set than `$b`.

```Raku
say (1,2,3) (<=) (2,3,1); # OUTPUT: «True␤» 
say (2,3) (<=) (2,3,1); # OUTPUT: «True␤» 
say 4 ⊆ (1,2,3); # OUTPUT: «False␤» 
```

`⊆` 等同于 `(<=)`，在码位 U+2286。

`⊆` is equivalent to `(<=)`, at codepoint U+2286 (SUBSET OF OR EQUAL TO).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%88--infix-%E2%8A%88"></a>
## 中缀运算符 `⊈` / infix `⊈`

```Raku
multi sub infix:<⊈>($a,$b --> Bool:D)
```

不包含于运算符。

Not a subset of nor equal to operator.

如果 `$a` 不是 `$b` 的**子集**，则返回真值。相当于 `!(<=)`。

Returns `True` if `$a` is **not** a `subset` of `$b`. Equivalent to `!(<=)`.

```Raku
say (1,2,3) ⊄ (2,3,1); # OUTPUT: «True␤» 
say (2,3) ⊄ (2,3,1); # OUTPUT: «False␤» 
say 4 !(<=) (1,2,3); # OUTPUT: «True␤» 
```

`⊈` 在码位 U+2288。

`⊈` is codepoint U+2288 (NEITHER A SUBSET OF NOR EQUAL TO).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6--%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%83--infix--infix-%E2%8A%83"></a>
## 中缀运算符 `(>)`, 中缀运算符  `⊃` / infix `(>)`, infix `⊃`

```Raku
multi sub infix:<< (>) >>($a,$b --> Bool:D)
multi sub infix:<⊃>($a,$b --> Bool:D)
```

超集运算符。

Superset of operator.

如果 `$a` 是 `$b` 的**严格超集**，则返回真值，即 `$b` 的所有元素都是 `$a` 的元素，但 `$a` 的集合大于 `$b`。

Returns `True` if `$a` is a **strict superset** of `$b`, i.e., that all the elements of `$b` are elements of `$a` but `$a` is a larger set than `$b`.

```Raku
say (1,2,3) (>) (2,3,1); # OUTPUT: «False␤» 
say (1,2,3) (>) (2,3); # OUTPUT: «True␤» 
say 4 ⊃ (1,2,3); # OUTPUT: «False␤» 
```

`⊃` 等同于 `(>)`，在码位 U+2283。

`⊃` is equivalent to `(>)`, at codepoint U+2283 (SUPERSET OF).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%85--infix-%E2%8A%85"></a>
## 中缀运算符 `⊅` / infix `⊅`

```Raku
multi sub infix:<⊅>($a,$b --> Bool:D)
```

非超集运算符。

Not a superset of operator.

如果 `$a` 不是 `$b` 的**严格超集**，则返回真值。相当于 `!(>)`

Returns `True` if `$a` is **not** a `strict superset` of `$b`. Equivalent to `!(>)`.

```Raku
say (1,2,3) ⊅ (2,3,1); # OUTPUT: «True␤» 
say (1,2,3) ⊅ (2,3); # OUTPUT: «False␤» 
say 4 !(>) (1,2,3); # OUTPUT: «True␤» 
```

`⊅` 在码位 U+2285。

`⊅` is codepoint U+2285 (NOT A SUPERSET OF).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%EF%BC%8C%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%87--infix--infix-%E2%8A%87"></a>
## 中缀运算符 `(>=)`，中缀运算符 `⊇` / infix `(>=)`, infix `⊇`

```Raku
multi sub infix:<< (>=) >>($a,$b --> Bool:D)
multi sub infix:<⊇>($a,$b --> Bool:D)
```

超集或等于运算符。

Superset of or equal to operator.

如果 `$a` 是 `$b` 的**超集**，则返回真值，即 `$b` 的所有元素都是 `$a` 的元素，但 `$a` 的集合大小大于或等于 `$b`。

Returns `True` if `$a` is a **superset** of `$b`, i.e., that all the elements of `$b` are elements of `$a` but `$a` is a larger or equal sized set than `$b`.

```Raku
say (1,2,3) (>=) (2,3,1); # OUTPUT: «True␤» 
say (1,2,3) (>=) (2,3); # OUTPUT: «True␤» 
say 4 ⊇ (1,2,3); # OUTPUT: «False␤» 
```

`⊇` 等同于 `(>=)`，在码位 U+2287。

`⊇` is equivalent to `(>=)`, at codepoint U+2287 (SUPERSET OF OR EQUAL TO).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%E2%8A%89--infix-%E2%8A%89"></a>
## 中缀运算符 `⊉` / infix `⊉`

```Raku
multi sub infix:<⊉>($a,$b --> Bool:D)
```

非超集也不等于运算符。

Not a superset of nor equal to operator.

如果 `$a` *不*是 `$b` 的超集。相当于 `!(>=)`。

Returns `True` if `$a` is **not** a `superset` of `$b`. Equivalent to `!(>=)`.

```Raku
say (1,2,3) ⊉ (2,3,1); # OUTPUT: «False␤» 
say (1,2,3) ⊉ (2,3); # OUTPUT: «False␤» 
say 4 !(>=) (1,2,3); # OUTPUT: «True␤» 
```

`⊉` 在码位 U+2289。

`⊉` is codepoint U+2289 (NEITHER A SUPERSET OF OR EQUAL TO).

<a id="%E9%80%BB%E8%BE%91%E4%B8%8E%E6%93%8D%E4%BD%9C%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--tight-and-precedence"></a>
# 逻辑与操作符优先级 / Tight AND precedence

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--18"></a>
## 中缀运算符 `&&` / infix `&&`

返回在布尔上下文中计算结果为假值的第一个参数，否则返回最后一个参数。

Returns the first argument that evaluates to `False` in boolean context, otherwise returns the last argument.

请注意，这种运算符有短路效果，即如果其中一个参数的计算结果为错误值，则永远不会计算右侧的参数。

Note that this short-circuits, i.e. if one of the arguments evaluates to a false value, the arguments to the right are never evaluated.

```Raku
sub a { 1 }
sub b { 0 }
sub c { die "never called" };
say a() && b() && c();      # OUTPUT: «0␤»
```

<a id="%E9%80%BB%E8%BE%91%E6%88%96%E6%93%8D%E4%BD%9C%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--tight-or-precedence"></a>
# 逻辑或操作符优先级 / Tight OR precedence

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%7C%7C--infix-%7C%7C"></a>
## 中缀运算符 `||` / infix `||`

返回在布尔上下文中计算结果为真值的第一个参数，否则返回最后一个参数。

Returns the first argument that evaluates to `True` in boolean context, otherwise returns the last argument.

请注意，这种运算符有短路效果；即，如果其中一个参数的计算结果为真值，则不计算其余参数。

Note that this short-circuits; i.e., if one of the arguments evaluates to a true value, the remaining arguments are not evaluated.

```Raku
sub a { 0 }
sub b { 1 }
sub c { die "never called" };
say a() || b() || c();      # OUTPUT: «1␤»
```

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5E%5E--infix-%5E%5E-1"></a>
## 中缀运算符 `^^` / infix `^^`

短路异或。如果有一个（并且只有一个）真值，则返回真值参数。如果所有参数都为假值，则返回最后一个参数。当多个参数为真值时返回 `Nil`。

Short-circuit exclusive-or. Returns the true argument if there is one (and only one). Returns the last argument if all arguments are false. Returns `Nil` when more than one argument is true.

此运算符短路效果为在第二个真结果之后不计算任何参数。

This operator short-circuits in the sense that it does not evaluate any arguments after a 2nd true result.

```Raku
say 0 ^^ 42;                             # OUTPUT: «42␤» 
say '' ^^ 0;                             # OUTPUT: «0␤» 
say 0 ^^ 42 ^^ 1 ^^ die "never called";  # OUTPUT: «Nil␤»
```

注意，这个操作符的语义可能不是你所假设的：中缀运算符 `^^` 翻到它找到的第一个真值，然后在第二个真值之后永为 Nil，不管还有多少真值。（换句话说，它有“查找一个真实值”语义，而不是“布尔奇偶性”语义。）

Note that the semantics of this operator may not be what you assume: infix `^^` flips to the first true value it finds and then flips to Nil *forever* after the second, no matter how many more true values there are. (In other words, it has "find the one true value" semantics, not "boolean parity" semantics.)

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--19"></a>
## 中缀运算符 `//` / infix `//`

已定义否则运算符或中缀运算符 // 返回第一个定义的操作数，否则返回最后一个操作数。有短路计算效果。

The defined-or operator or infix // returns the first defined operand, or else the last operand. Short-circuits.

```Raku
say Any // 0 // 42;         # OUTPUT: «0␤»
```

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-min--infix-min"></a>
## 中缀运算符 `min` / infix `min`

返回由 [cmp](https://rakudocs.github.io/routine/cmp) 语义确定的最小参数。

Returns the smallest of the arguments, as determined by [cmp](https://rakudocs.github.io/routine/cmp) semantics.

```Raku
my $foo = 42;
$foo min= 0   # read as: $foo decreases to 0
```

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-max--infix-max"></a>
## 中缀运算符 `max` / infix `max`

返回由 [cmp](https://rakudocs.github.io/routine/cmp) 语义确定的最大参数。

Returns the largest of the arguments, as determined by [cmp](https://rakudocs.github.io/routine/cmp) semantics.

```Raku
my $foo = -42;
$foo max= 0   # read as: $foo increases to 0
```

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-minmax--infix-minmax"></a>
## 中缀运算符 `minmax` / infix `minmax`

返回 [Range](https://rakudocs.github.io/type/Range) 从值的最低到最高，由 [cmp](https://rakudocs.github.io/routine/cmp) 语义决定。例如：

Returns the [Range](https://rakudocs.github.io/type/Range) starting from the lowest to the highest of the values, as determined by the [cmp](https://rakudocs.github.io/routine/cmp) semantics. For instance:

```Raku
# numeric comparison 
10 minmax 3;     # 3..10 
 
# string comparison 
'10' minmax '3'; # "10".."3" 
'z' minmax 'k';  # "k".."z" 
```

如果最低值和最高值重合，则运算符返回由相同值生成的 [Range](https://rakudocs.github.io/type/Range)：

If the lowest and highest values coincide, the operator returns a [Range](https://rakudocs.github.io/type/Range) made by the same value:

```Raku
1 minmax 1;  # 1..1 
```

应用于 [List](https://rakudocs.github.io/type/List) 时，运算符计算所有可用值中的最低值和最高值：

When applied to [List](https://rakudocs.github.io/type/List)s, the operator evaluates the lowest and highest values among all available values:

```Raku
(10,20,30) minmax (0,11,22,33);       # 0..33 
('a','b','z') minmax ('c','d','w');   # "a".."z" 
```

类似地，当应用于 [Hash](https://rakudocs.github.io/type/Hash) 时，它执行 [cmp](https://rakudocs.github.io/routine/cmp) 方式比较：

Similarly, when applied to [Hash](https://rakudocs.github.io/type/Hash)es, it performs a [cmp](https://rakudocs.github.io/routine/cmp) way comparison:

```Raku
my %winner = points => 30, misses => 10;
my %loser = points => 20, misses => 10;
%winner cmp %loser;      # More 
%winner minmax %loser;
# ${:misses(10), :points(20)}..${:misses(10), :points(30)} 
```

<a id="%E6%9D%A1%E4%BB%B6%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--conditional-operator-precedence"></a>
# 条件运算符优先级 / Conditional operator precedence

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6----infix---1"></a>
## 中缀运算符  `?? !!` / infix `?? !!`

也称为*三元*或*条件*运算符，`$condition ?? $true !! $false` 计算 `$condition` 并返回 ?? 后面的表达式，在本例中，返回 `$true` 如果是 `$condition` 为真值，否则求值并返回 !! 后面的表达式，在本例中返回 `$false`。

Also called *ternary* or *conditional* operator, `$condition ?? $true !! $false` evaluates `$condition` and returns the expression right behind ??, in this case `$true` if it is `True`, otherwise evaluates and returns the expression behind !!, `$false` in this case.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-ff--infix-ff"></a>
## 中缀运算符  `ff` / infix `ff`

```Raku
sub infix:<ff>(Mu $a, Mu $b)
```

也称为*触发器*运算符，将这两个参数与 `$_`（即 `$_ ~~ $a` 和 `$_ ~~ $b`）进行比较。计算结果为 `False`，直到左侧智能匹配返回为 `True`，此时计算结果为 `True`，直到右侧智能匹配为 `True`。

Also called the *flipflop operator*, compares both arguments to `$_` (that is, `$_ ~~ $a` and `$_ ~~ $b`). Evaluates to `False` until the left-hand smartmatch is `True`, at which point it evaluates to `True` until the right-hand smartmatch is `True`.

实际上，左边的参数是“开始”条件，右边的参数是“停止”条件。此构造通常仅用于拾取特定的行。例如：

In effect, the left-hand argument is the "start" condition and the right-hand is the "stop" condition. This construct is typically used to pick up only a certain section of lines. For example:

```Raku
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

匹配开始条件后，运算符将把相同的 `$_` 匹配到停止条件，如果成功，则相应地执行操作。在本例中，仅打印第一个元素：

After matching the start condition, the operator will then match the same `$_` to the stop condition and act accordingly if successful. In this example, only the first element is printed:

```Raku
for <AB C D B E F> {
    say $_ if /A/ ff /B/;  # OUTPUT: «AB␤» 
}
```

如果你只想对开始条件进行测试，并且没有停止条件，则可以使用 `*`。

If you only want to test against a start condition and have no stop condition, `*` can be used as such.

```Raku
for <A B C D E> {
    say $_ if /C/ ff *;    # OUTPUT: «C␤D␤E␤» 
}
```

对于类似 `sed` 的版本，在开始条件成功后，不对停止条件尝试 `$_`，请参见 [fff](https://rakudocs.github.io/routine/fff)。

For the `sed`-like version, which does *not* try `$_` on the stop condition after succeeding on the start condition, see [fff](https://rakudocs.github.io/routine/fff).

这个运算符不能重载，因为它是由编译器特别处理的。

This operator cannot be overloaded, as it's handled specially by the compiler.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5Eff--infix-%5Eff"></a>
## 中缀运算符  `^ff` / infix `^ff`

```Raku
sub infix:<^ff>(Mu $a, Mu $b)
```

工作方式与 [ff](https://rakudocs.github.io/routine/ff) 类似，但对于与开始条件匹配的项（包括也与停止条件匹配的项），它不返回 `True`。

Works like [ff](https://rakudocs.github.io/routine/ff), except it does not return `True` for items matching the start condition (including items also matching the stop condition).

对比：

A comparison:

```Raku
my @list = <A B C>;
say $_ if /A/ ff /C/ for @list;    # OUTPUT: «A␤B␤C␤» 
say $_ if /A/ ^ff /C/ for @list;   # OUTPUT: «B␤C␤»
```

sed 类版本可以在 [`^fff`](https://rakudocs.github.io/routine/$CIRCUMFLEX_ACCENTfff) 中找到。

The sed-like version can be found in [`^fff`](https://rakudocs.github.io/routine/$CIRCUMFLEX_ACCENTfff).

这个运算符不能重载，因为它是由编译器特别处理的。

This operator cannot be overloaded, as it's handled specially by the compiler.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-ff%5E--infix-ff%5E"></a>
## 中缀运算符  `ff^` / infix `ff^`

```Raku
sub infix:<ff^>(Mu $a, Mu $b)
```

工作方式与 [ff](https://rakudocs.github.io/routine/ff) 类似，但对于与停止条件匹配的项（包括首先与开始条件匹配的项），它不返回 `True`。

Works like [ff](https://rakudocs.github.io/routine/ff), except it does not return `True` for items matching the stop condition (including items that first matched the start condition).

```Raku
my @list = <A B C>;
say $_ if /A/ ff /C/ for @list;    # OUTPUT: «A␤B␤C␤» 
say $_ if /A/ ff^ /C/ for @list;   # OUTPUT: «A␤B␤»
```

sed 类版本可以在 [fff^](https://rakudocs.github.io/routine/fff$CIRCUMFLEX_ACCENT) 中找到。

The sed-like version can be found in [fff^](https://rakudocs.github.io/routine/fff$CIRCUMFLEX_ACCENT).

这个运算符不能重载，因为它是由编译器特别处理的。

This operator cannot be overloaded, as it's handled specially by the compiler.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5Eff%5E--infix-%5Eff%5E"></a>
## 中缀运算符  `^ff^` / infix `^ff^`

```Raku
sub infix:<^ff^>(Mu $a, Mu $b)
```

工作方式类似于 [ff](https://rakudocs.github.io/routine/ff)，但对于与停止或启动条件（或两者）匹配的项，它不返回 `True`。

Works like [ff](https://rakudocs.github.io/routine/ff), except it does not return `True` for items matching either the stop or start condition (or both).

```Raku
my @list = <A B C>;
say $_ if /A/ ff /C/ for @list;    # OUTPUT: «A␤B␤C␤» 
say $_ if /A/ ^ff^ /C/ for @list;  # OUTPUT: «B␤»
```

sed 类版本可以在 [`^fff^`](https://rakudocs.github.io/routine/$CIRCUMFLEX_ACCENTfff$CIRCUMFLEX_ACCENT) 中找到。

The sed-like version can be found in [`^fff^`](https://rakudocs.github.io/routine/$CIRCUMFLEX_ACCENTfff$CIRCUMFLEX_ACCENT).

这个运算符不能重载，因为它是由编译器特别处理的。

This operator cannot be overloaded, as it's handled specially by the compiler.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-fff--infix-fff"></a>
## 中缀运算符  `fff` / infix `fff`

```Raku
sub infix:<fff>(Mu $a, Mu $b)
```

执行类似 sed 的触发器操作，它返回 `False`，直到 `$_` 智能匹配左参数，然后返回 `True`，直到 `$_` 智能匹配右参数。

Performs a sed-like flipflop operation, wherein it returns `False` until the left argument smartmatches against `$_`, then returns `True` until the right argument smartmatches against `$_`.

与 [ff](https://rakudocs.github.io/routine/ff) 类似，只是它每次调用只尝试一个参数。也就是说，如果 `$_` 智能匹配左参数，`fff` 将**不**尝试将相同的 `$_` 与右参数匹配。

Works similarly to [ff](https://rakudocs.github.io/routine/ff), except that it only tries one argument per invocation. That is, if `$_` smartmatches the left argument, `fff` will **not** then try to match that same `$_` against the right argument.

```Raku
for <AB C D B E F> {
    say $_ if /A/ fff /B/;         # OUTPUT: «AB␤C␤D␤B␤» 
}
```

非 sed 类型的触发器（在成功地将左参数与 `$_` 匹配之后，将尝试对右参数使用相同的 `$_`，并相应地执行操作）。见 [ff](https://rakudocs.github.io/routine/ff)。

The non-sed-like flipflop (which after successfully matching the left argument against `$_` will try that same `$_` against the right argument and act accordingly). See [ff](https://rakudocs.github.io/routine/ff).

这个运算符不能重载，因为它是由编译器特别处理的。

This operator cannot be overloaded, as it's handled specially by the compiler.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5Efff--infix-%5Efff"></a>
## 中缀运算符  `^fff` / infix `^fff`

```Raku
sub infix:<^fff>(Mu $a, Mu $b)
```

与 [fff](https://rakudocs.github.io/routine/fff) 类似，但对于左参数的匹配，它不返回真值。

Like [fff](https://rakudocs.github.io/routine/fff), except it does not return true for matches to the left argument.

```Raku
my @list = <A B C>;
say $_ if /A/ fff /C/ for @list;   # OUTPUT: «A␤B␤C␤» 
say $_ if /A/ ^fff /C/ for @list;  # OUTPUT: «B␤C␤»
```

对于非 sed 版本，请参见 [`^ff`](https://rakudocs.github.io/routine/$CIRCUMFLEX_ACCENTff)。

For the non-sed version, see [`^ff`](https://rakudocs.github.io/routine/$CIRCUMFLEX_ACCENTff).

这个运算符不能重载，因为它是由编译器特别处理的。

This operator cannot be overloaded, as it's handled specially by the compiler.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-fff%5E--infix-fff%5E"></a>
## 中缀运算符 `fff^` / infix `fff^`

```Raku
sub infix:<fff^>(Mu $a, Mu $b)
```

与 [fff](https://rakudocs.github.io/routine/fff) 类似，只不过对于右参数的匹配不返回真值。

Like [fff](https://rakudocs.github.io/routine/fff), except it does not return true for matches to the right argument.

```Raku
my @list = <A B C>;
say $_ if /A/ fff /C/ for @list;   # OUTPUT: «A␤B␤C␤» 
say $_ if /A/ fff^ /C/ for @list;  # OUTPUT: «A␤B␤»
```

对于非 sed 版本，请参见 [ff^](https://rakudocs.github.io/routine/ff$CIRCUMFLEX_ACCENT)。

For the non-sed version, see [ff^](https://rakudocs.github.io/routine/ff$CIRCUMFLEX_ACCENT).

这个运算符不能重载，因为它是由编译器特别处理的。

This operator cannot be overloaded, as it's handled specially by the compiler.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-%5Efff%5E--infix-%5Efff%5E"></a>
## 中缀运算符  `^fff^` / infix `^fff^`

```Raku
sub infix:<^fff^>(Mu $a, Mu $b)
```

与 [fff](https://rakudocs.github.io/routine/fff) 类似，但对于左参数或右参数的匹配，它不返回真值。

Like [fff](https://rakudocs.github.io/routine/fff), except it does not return true for matches to either the left or right argument.

```Raku
my @list = <A B C>;
say $_ if /A/ fff /C/ for @list;   # OUTPUT: «A␤B␤C␤» 
say $_ if /A/ ^fff^ /C/ for @list; # OUTPUT: «B␤»
```

对于非 sed 版本，请参见 [`^ff^`](https://rakudocs.github.io/routine/$CIRCUMFLEX_ACCENTff$CIRCUMFLEX_ACCENT)。

For the non-sed version, see [`^ff^`](https://rakudocs.github.io/routine/$CIRCUMFLEX_ACCENTff$CIRCUMFLEX_ACCENT).

这个运算符不能重载，因为它是由编译器特别处理的。

This operator cannot be overloaded, as it's handled specially by the compiler.

<a id="%E9%A1%B9%E7%9B%AE%E8%B5%8B%E5%80%BC%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--item-assignment-precedence"></a>
# 项目赋值运算符优先级 / Item assignment precedence

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--20"></a>
## 中缀运算符 `=` / infix `=`

```Raku
    sub infix:<=>(Mu $a is rw, Mu $b)
```

称为*项目赋值运算符*，它将右侧的值放入左侧的容器中。它的确切语义留给左侧的容器类型。

Called the *item assignment operator*, it Places the value of the right-hand side into the container on the left-hand side. Its exact semantics are left to the container type on the left-hand side.

（注意，项赋值和列表赋值具有不同的优先级，左侧的语法决定等号 `=` 是被解析为项赋值还是列表赋值运算符）。

(Note that item assignment and list assignment have different precedence levels, and the syntax of the left-hand side decides whether an equal sign `=` is parsed as item assignment or list assignment operator).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--21"></a>
## 中缀运算符 `=>` / infix `=>`

```Raku
sub infix:«=>»($key, Mu $value --> Pair:D)
```

[Pair](https://rakudocs.github.io/type/Pair) 构造器.

[Pair](https://rakudocs.github.io/type/Pair) constructor.

构造一个 [Pair](https://rakudocs.github.io/type/Pair) 对象，左侧为键，右侧为值。

Constructs a [Pair](https://rakudocs.github.io/type/Pair) object with the left-hand side as the key and the right-hand side as the value.

注意 `=>` 操作符是语法上特殊的案例，因为它允许在左侧使用未加引号的标识符。

Note that the `=> `operator is syntactically special-cased, in that it allows unquoted identifier on the left-hand side.

```Raku
my $p = a => 1;
say $p.key;         # OUTPUT: «a␤» 
say $p.value;       # OUTPUT: «1␤»
```

参数列表中的一个 [Pair](https://rakudocs.github.io/type/Pair) 在左边有一个未被引用的标识符，它被解释为一个命名参数。

A [Pair](https://rakudocs.github.io/type/Pair) within an argument list with an unquoted identifier on the left is interpreted as a named argument.

有关创建 `Pair` 对象的更多方法，请参见[术语语言文档](https://rakudocs.github.io/language/terms#Pair)。

See [the Terms language documentation](https://rakudocs.github.io/language/terms#Pair) for more ways to create `Pair` objects.

<a id="%E6%9D%BE%E6%95%A3%E7%9A%84%E4%B8%80%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E6%9D%83--loose-unary-precedence"></a>
# 松散的一元运算符优先权 / Loose unary precedence

<a id="%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-not--prefix-not"></a>
## 前缀运算符 `not` / prefix `not`

```Raku
multi sub prefix:<not>(Mu $x --> Bool:D)
```

在布尔上下文中计算其参数（从而折叠 [Junction](https://rakudocs.github.io/type/Junction)），并对结果求反。请注意，`not` 很容易被误用。请参阅[陷阱](https://rakudocs.github.io/language/traps#Loose_boolean_operators)。

Evaluates its argument in boolean context (and thus collapses [Junction](https://rakudocs.github.io/type/Junction)s), and negates the result. Please note that `not` is easy to misuse. See [traps](https://rakudocs.github.io/language/traps#Loose_boolean_operators).

<a id="%E5%89%8D%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-so--prefix-so"></a>
## 前缀运算符 `so` / prefix `so`

```Raku
multi sub prefix:<so>(Mu $x --> Bool:D)
```

在布尔上下文中计算其参数（从而折叠 [Junction](https://rakudocs.github.io/type/Junction)），并返回结果。

Evaluates its argument in boolean context (and thus collapses [Junction](https://rakudocs.github.io/type/Junction)s), and returns the result.

<a id="%E9%80%97%E5%8F%B7%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--comma-operator-precedence"></a>
# 逗号运算符优先级 / Comma operator precedence

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--22"></a>
## 中缀运算符 `,` / infix `,`

```Raku
sub infix:<,>(*@a --> List:D) is assoc<list>
```

从参数构造一个高阶 [Cool](https://rakudocs.github.io/type/Cool) 对象。

Constructs a higher-order [Cool](https://rakudocs.github.io/type/Cool) from its arguments.

```Raku
my @list = :god('Þor'), ['is',"mighty"];
say @list;      # OUTPUT: «[god => Þor [is mighty]]␤» 
my %hash = :god('Þor'), :is("mighty");
say %hash.perl; # OUTPUT: «{:god("Þor"), :is("mighty")}␤» 
my %a = :11a, :22b;
say %(%a, :33x);  # OUTPUT: «{a => 11, b => 22, x => 33}␤»
```

在第一种情况下，它返回一个 [List](https://rakudocs.github.io/type/List)，在第二种情况下，由于参数是 [Pair](https://rakudocs.github.io/type/Pair)，它构建一个 [Hash](https://rakudocs.github.io/type/Hash)。

In the first case it returns a [List](https://rakudocs.github.io/type/List), in the second case, since the arguments are [Pair](https://rakudocs.github.io/type/Pair)s, it builds a [Hash](https://rakudocs.github.io/type/Hash).

它还可用于从其他变量构造变量，排序不同类型的元素，在本例中为 [Hash](https://rakudocs.github.io/type/Hash) 和 [Pair](https://rakudocs.github.io/type/Pair)：

It can also be used for constructing variables from other variables, collating elements of different types, in this case a [Hash](https://rakudocs.github.io/type/Hash) and a [Pair](https://rakudocs.github.io/type/Pair):

```Raku
my %features = %hash, :wields("hammer");
say %features;  # OUTPUT: «{god => Þor, is => mighty, wields => hammer}␤» 
```

逗号在语法上也用作调用中参数的分隔符。

The comma is also used syntactically as the separator of arguments in calls.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--23"></a>
## 中缀运算符 `:` / infix `:`

用作参数分隔符，就像中缀运算符 `,` 一样，并将其左侧的参数标记为调用者。这将原本是函数调用的内容转换为方法调用。

Used as an argument separator just like infix `,` and marks the argument to its left as the invocant. That turns what would otherwise be a function call into a method call.

```Raku
substr('abc': 1);       # same as 'abc'.substr(1)
```

只有在非方法调用的第一个参数之后才允许中缀运算符 `:`。在其他位置，这是一个语法错误。

Infix `:` is only allowed after the first argument of a non-method call. In other positions, it's a syntax error.

<a id="%E5%88%97%E8%A1%A8%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--list-infix-precedence"></a>
# 列表中缀运算符优先级 / List infix precedence

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-z--infix-z"></a>
## 中缀运算符 `Z` / infix `Z`

```Raku
sub infix:<Z>(**@lists --> Seq:D) is assoc<chain>
```

Zip 运算符像拉链一样交错传递给 `Z` 的列表，从每个操作数中获取与索引对应的元素。返回的 `Seq` 包含嵌套列表，每个列表都有链中每个操作数的值。如果其中一个操作数过早用完元素，则 zip 运算符将停止。

The Zip operator interleaves the lists passed to `Z` like a zipper, taking index-corresponding elements from each operand. The returned `Seq` contains nested lists, each with a value from every operand in the chain. If one of the operands runs out of elements prematurely, the zip operator will stop.

```Raku
say (1, 2 Z <a b c> Z <+ ->).perl;
# OUTPUT: «((1, "a", "+"), (2, "b", "-")).Seq␤» 
for <a b c> Z <1 2 3 4> -> [$l, $r] {
    say "$l:$r"
}
# OUTPUT: «a:1␤b:2␤c:3␤» 
```

`Z` 运算符也作为元运算符存在，在这种情况下，内部列表将替换为将运算符应用于列表时的值：

The `Z` operator also exists as a metaoperator, in which case the inner lists are replaced by the value from applying the operator to the list:

```Raku
say 100, 200 Z+ 42, 23;             # OUTPUT: «(142 223)␤» 
say 1..3 Z~ <a b c> Z~ 'x' xx 3;    # OUTPUT: «(1ax 2bx 3cx)␤»
```

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-x--infix-x-1"></a>
## 中缀运算符 `X` / infix `X`

定义为：

Defined as:

```Raku
multi sub infix:<X>(+lol, :&with! --> Seq:D)
multi sub infix:<X>(+lol --> Seq:D)
```

从所有列表中创建一个交叉积，按顺序排列，以便最右边的元素变化最快，并返回一个 `Seq`：

Creates a cross product from all the lists, ordered so that the rightmost elements vary most rapidly, and returns a `Seq`:

```Raku
1..3 X <a b c> X 9
# produces ((1 a 9) (1 b 9) (1 c 9) 
#           (2 a 9) (2 b 9) (2 c 9) 
#           (3 a 9) (3 b 9) (3 c 9))
```

`X` 运算符也作为元运算符存在，在这种情况下，内部列表将替换为将运算符应用于列表的值：

The `X` operator also exists as a metaoperator, in which case the inner lists are replaced by the value from applying the operator to the list:

```Raku
1..3 X~ <a b c> X~ 9
# produces (1a9 1b9 1c9 2a9 2b9 2c9 3a9 3b9 3c9)
```

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--24"></a>
## 中缀运算符 `...` / infix `...` 

```Raku
multi sub infix:<...>(**@) is assoc<list>
multi sub infix:<...^>(**@) is assoc<list>
```

序列运算符（可以写为 `...` 或 `…`（带有变体 `...^` 和 `…^`）将按需生成（可能是惰性的）通用序列。

The sequence operator, which can be written either as `...` or as `…` (with variants `...^` and `…^`) will produce (possibly lazy) generic sequences on demand.

左侧始终包含初始元素；它也可能包含生成器（在第一个或多个元素之后）。右边将有一个端点，对于“无限”列表（即只按需生成元素的*惰性*列表），可以是 `*` 或 `*`，当为 `True` 时将结束序列的表达式，或者其他元素，如 [Junctions](https://rakudocs.github.io/type/Junction)。

The left-hand side will always include the initial elements; it may include a generator too (after the first element or elements). The right-hand side will have an endpoint, which can be `Inf` or `*` for "infinite" lists (that is, *lazy* lists whose elements are only produced on demand), an expression which will end the sequence when `True`, or other elements such as [Junctions](https://rakudocs.github.io/type/Junction).

序列运算符使用所需的参数调用生成器。参数取自初始元素和已生成的元素。根据端点的比较方式，默认生成器为 `*.`[succ](https://rakudocs.github.io/routine/succ) 或 `*.`[pred](https://rakudocs.github.io/routine/pred)：

The sequence operator invokes the generator with as many arguments as necessary. The arguments are taken from the initial elements and the already generated elements. The default generator is `*.`[succ](https://rakudocs.github.io/routine/succ) or `*.`[pred](https://rakudocs.github.io/routine/pred), depending on how the end points compare:

```Raku
say 1 ... 4;        # OUTPUT: «(1 2 3 4)␤» 
say 4 ... 1;        # OUTPUT: «(4 3 2 1)␤» 
say 'a' ... 'e';    # OUTPUT: «(a b c d e)␤» 
say 'e' ... 'a';    # OUTPUT: «(e d c b a)␤»
```

`*` ([Whatever](https://rakudocs.github.io/type/Whatever)) 、`Inf` 或 `∞` 的端点按需生成无限序列，默认生成器为 `*.succ`。

An endpoint of `*` ([Whatever](https://rakudocs.github.io/type/Whatever)), `Inf` or `∞` generates on demand an infinite sequence, with a default generator of `*.succ`

```Raku
say (1 ... *)[^5];  # OUTPUT: «(1 2 3 4 5)␤»
```

自定义生成器必须是列表中 '...' 运算符之前的最后一个元素。这个生成器接受两个参数，并生成前八个斐波那契数。

Custom generators need to be the last element of the list before the '...' operator. This one takes two arguments, and generates the eight first Fibonacci numbers

```Raku
say (1, 1, -> $a, $b { $a + $b } ... *)[^8]; # OUTPUT: «(1 1 2 3 5 8 13 21)␤» 
# same but shorter 
say (1, 1, * + * ... *)[^8];                 # OUTPUT: «(1 1 2 3 5 8 13 21)␤» 
```

当然，生成器也可以只接受一个参数。

Of course the generator can also take only one argument.

```Raku
say 5, { $_ * 2 } ... 40;                # OUTPUT: «5 10 20 40␤»
```

必须至少有与生成器的参数一样多的初始元素。

There must be at least as many initial elements as arguments to the generator.

如果没有生成器，且有多个初始元素且所有初始元素都是数字，则序列运算符将尝试推断生成器。它知道算术和几何序列。

Without a generator and with more than one initial element and all initial elements numeric, the sequence operator tries to deduce the generator. It knows about arithmetic and geometric sequences.

```Raku
say 2, 4, 6 ... 12;     # OUTPUT: «(2 4 6 8 10 12)␤» 
say 1, 2, 4 ... 32;     # OUTPUT: «(1 2 4 8 16 32)␤»
```

如果端点不是 `*`，则它与每个生成的元素进行智能匹配，并且当智能匹配成功时，序列终止。对于 `...` 运算符，包含最后一个元素，对于 `...^` 运算符，不包含最后一个元素。

If the endpoint is not `*`, it's smartmatched against each generated element and the sequence is terminated when the smartmatch succeeded. For the `...` operator, the final element is included, for the `...^` operator it's excluded.

这允许你这样写：

This allows you to write

```Raku
say 1, 1, * + * ...^ *>= 100;
```

生成所有小于 100 的斐波那契数。

to generate all Fibonacci numbers up to but excluding 100.

The `...` operators consider the initial values as "generated elements" as well, so they are also checked against the endpoint:

```Raku
my $end = 4;
say 1, 2, 4, 8, 16 ... $end;
# OUTPUT: «(1 2 4)␤»
```

<a id="%E5%88%97%E8%A1%A8%E5%89%8D%E7%BC%80%E4%BC%98%E5%85%88%E7%BA%A7--list-prefix-precedence"></a>
# 列表前缀优先级 / List prefix precedence

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--25"></a>
## 中缀运算符 `=` / infix `=`

在此上下文中，它充当列表赋值运算符。它的确切语义留给左侧的容器类型。常见情况见[数组](https://rakudocs.github.io/type/Array)和[散列](https://rakudocs.github.io/type/Hash)。

In this context, it acts as the list assignment operator. Its exact semantics are left to the container type on the left-hand side. See [Array](https://rakudocs.github.io/type/Array) and [Hash](https://rakudocs.github.io/type/Hash) for common cases.

单条目赋值和列表赋值之间的区别由解析器根据左侧的语法决定。

The distinction between item assignment and list assignment is determined by the parser depending on the syntax of the left-hand side.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--26"></a>
## 中缀运算符 `:=` / infix `:=`

绑定运算符。虽然 `$x = $y`将 `$y` 中的值放入 `$x`，`$x := $y` 使 `$x` 和 `$y` 相同。

Binding operator. Whereas `$x = $y` puts the value in `$y` into `$x`, `$x := $y` makes `$x` and `$y` the same thing.

```Raku
my $a = 42;
my $b = $a;
$b++;
say $a;
```

这将输出42，因为 `$a` 和 `$b` 都包含数字 `42`，但[容器](https://rakudocs.github.io/language/containers#Binding)不同。

This will output 42, because `$a` and `$b` both contained the number `42`, but the [containers](https://rakudocs.github.io/language/containers#Binding) were different.

```Raku
my $a = 42;
my $b := $a;
$b++;
say $a;
```

这将输出 43，因为 `$b` 和 `$a` 都表示同一个对象。

This will output 43, since `$b` and `$a` both represented the same object.

如果变量或容器上存在类型约束，则将在运行时执行类型检查。失败时，将抛出 `X::TypeCheck::BindingType` 异常。

If type constrains on variables or containers are present a type check will be performed at runtime. On failure `X::TypeCheck::BindingType` will be thrown.

请注意，`:=` 是编译时运算符。因此，它不能在运行时引用，因此不能用作元运算符的参数。

Please note that `:=` is a compile time operator. As such it can not be referred to at runtime and thus can't be used as an argument to metaoperators.

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--27"></a>
## 中缀运算符 `::=` / infix `::=`

只读绑定运算符，尚未在 Rakudo 中实现。请参见 [`infix :=`](https://rakudocs.github.io/routine/:=)。

Read-only binding operator, not yet implemented in Rakudo. See [`infix :=`](https://rakudocs.github.io/routine/:=).

<a id="%E5%88%97%E8%A1%A8%E8%BF%90%E7%AE%97%E7%AC%A6---listop-"></a>
## 列表运算符 `...` / listop `...`

称为 *yada, yada, yada* 运算符或 *stub* 运算符，如果它是例程或类型中的唯一语句，则它将该例程或类型标记为 stub（在预声明类型和组合角色的上下文中是重要的）。

Called the *yada, yada, yada* operator or *stub* operator, if it's the only statement in a routine or type, it marks that routine or type as a stub (which is significant in the context of pre-declaring types and composing roles).

如果执行了 `...` 语句，它将调用 [fail](https://rakudocs.github.io/routine/fail)，并显示默认消息 `Stub code executed`。

If the `...` statement is executed, it calls [fail](https://rakudocs.github.io/routine/fail), with the default message `Stub code executed`.

<a id="%E5%88%97%E8%A1%A8%E8%BF%90%E7%AE%97%E7%AC%A6---listop--1"></a>
## 列表运算符 `!!!` / listop `!!!`

如果它是例程或类型中的唯一语句，它会将该例程或类型标记为 stub（在预声明类型和组合角色的上下文中这是重要的）。

If it's the only statement in a routine or type, it marks that routine or type as a stub (which is significant in the context of pre-declaring types and composing roles).

如果 `!!!` 语句被执行，它调用 [die](https://rakudocs.github.io/routine/die)，默认消息是 `Stub code executed`。

If the `!!!` statement is executed, it calls [die](https://rakudocs.github.io/routine/die), with the default message `Stub code executed`.

<a id="%E5%88%97%E8%A1%A8%E8%BF%90%E7%AE%97%E7%AC%A6---listop--2"></a>
## 列表运算符 `???` / listop `???`

如果它是例程或类型中的唯一语句，它会将该例程或类型标记为 stub（在预声明类型和组合角色的上下文中这是重要的）。

If it's the only statement in a routine or type, it marks that routine or type as a stub (which is significant in the context of pre-declaring types and composing roles).

如果 `???` 语句被执行，它调用 [warn](https://rakudocs.github.io/routine/warn)，默认消息是 `Stub code executed`。

If the `???` statement is executed, it calls [warn](https://rakudocs.github.io/routine/warn), with the default message `Stub code executed`.

<a id="%E5%BD%92%E7%BA%A6%E8%BF%90%E7%AE%97%E7%AC%A6--reduction-operators"></a>
## 归约运算符 / Reduction operators

任何中缀运算符（非关联运算符除外）都可以在术语位置用方括号括起来，以创建一个列表运算符，减少使用该运算符的次数。

Any infix operator (except for non-associating operators) can be surrounded by square brackets in term position to create a list operator that reduces using that operation.

```Raku
say [+] 1, 2, 3;      # 1 + 2 + 3 = 6 
my @a = (5, 6);
say [*] @a;           # 5 * 6 = 30
```

归约运算符与它们所基于的运算符具有相同的关联性。

Reduction operators have the same associativity as the operators they are based on.

```Raku
say [-] 4, 3, 2;      # 4-3-2 = (4-3)-2 = -1 
say [**] 4, 3, 2;     # 4**3**2 = 4**(3**2) = 262144
```

<a id="%E5%AE%BD%E6%9D%BE%E7%9A%84%E4%B8%8E%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--loose-and-precedence"></a>
# 宽松的与运算符优先级 / Loose AND precedence

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-and--infix-and"></a>
## 中缀运算符 `and` / infix `and`

与[中缀运算符 &&](https://rakudocs.github.io/language/operators#infix_%26%26) 相同，但优先级较低。

Same as [infix &&](https://rakudocs.github.io/language/operators#infix_%26%26), except with looser precedence.

返回计算结果为 `False` 的第一个操作数，否则返回最后一个操作数。注意 `and` 很容易被误用，请参见[陷阱](https://rakudocs.github.io/language/traps#Loose_boolean_operators)。

Short-circuits so that it returns the first operand that evaluates to `False`, otherwise returns the last operand. Note that `and` is easy to misuse, see [traps](https://rakudocs.github.io/language/traps#Loose_boolean_operators).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-andthen--infix-andthen"></a>
## 中缀运算符 `andthen` / infix `andthen`

当遇到第一个[未定义](https://rakudocs.github.io/routine/defined)参数时，`andthen` 运算符返回 [`Empty`](https://rakudocs.github.io/type/Slip#index-entry-Empty-Empty)，否则返回最后一个参数。最后一个参数按原样返回，不检查其是否定义。左边的计算结果绑定到右边的 `$_` 上，或者如果右边是一个 [`Callable`](https://rakudocs.github.io/type/Callable) 作为参数传递，其[函数参数个数](https://rakudocs.github.io/routine/count) 必须是 `0` 或 `1`。

The `andthen` operator returns [`Empty`](https://rakudocs.github.io/type/Slip#index-entry-Empty-Empty) upon encountering the first [undefined](https://rakudocs.github.io/routine/defined) argument, otherwise the last argument. Last argument is returned as-is, without being checked for definedness at all. Short-circuits. The result of the left side is bound to `$_` for the right side, or passed as arguments if the right side is a [`Callable`](https://rakudocs.github.io/type/Callable), whose [count](https://rakudocs.github.io/routine/count) must be `0` or `1`.

此运算符的一个方便用法是将例程的返回值别名为 `$_`，并对其进行其他操作，例如打印或将其返回给调用方。由于 `andthen` 运算符有短路效果，除非定义了左侧，否则不会执行右侧的语句（提示：[Failures](https://rakudocs.github.io/type/Failure) 从来没有定义，因此可以使用此运算符处理它们）。

A handy use of this operator is to alias a routine's return value to `$_` and to do additional manipulation with it, such as printing or returning it to caller. Since the `andthen` operator short-circuits, statements on the right-hand side won't get executed, unless left-hand side is defined (tip: [Failures](https://rakudocs.github.io/type/Failure) are never defined, so you can handle them with this operator).

```Raku
sub load-data {
    rand  > .5 or return; # simulated load data failure; return Nil 
    (rand > .3 ?? 'error' !! 'good data') xx 10 # our loaded data 
}
load-data.first: /good/ andthen say "$_ is good";
# OUTPUT: «(good data is good)␤» 
 
load-data() andthen .return; # return loaded data, if it's defined 
die "Failed to load data!!";
```

只有当子例程返回与 `/good/` 匹配的任何条目时，上面的示例才会打印 `good data is good`，并且除非加载数据返回定义的值，否则程序将退出。别名行为允许我们在操作符之间通过管道传递值。

The above example will print `good data is good` only if the subroutine returned any items that match `/good/` and will die unless loading data returned a defined value. The aliasing behavior lets us pipe the values across the operator.

`andthen` 运算符是 [`with` 语句修饰符](https://rakudocs.github.io/syntax/with%20orwith%20without)的近亲，有些编译器将 `with` 编译为 `andthen`，这意味着这两行具有相同的行为：

The `andthen` operator is a close relative of [`with` statement modifier](https://rakudocs.github.io/syntax/with%20orwith%20without), and some compilers compile `with` to `andthen`, meaning these two lines have equivalent behavior:

```Raku
.say with 42;
42 andthen .say;
```

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-notandthen--infix-notandthen"></a>
## 中缀运算符 `notandthen` / infix `notandthen`

`notandthen` 运算符在遇到第一个[已定义](https://rakudocs.github.io/routine/defined)参数时返回 [`Empty`](https://rakudocs.github.io/type/Slip#index-entry-Empty-Empty)，否则返回最后一个参数。最后一个参数按原样返回，不检查其定义。左边的结果绑定到右边的 `$_` 上，或者如果右边是一个 [`Callable`](https://rakudocs.github.io/type/Callable) 则左边的结果作为参数传递，其[函数参数个数](https://rakudocs.github.io/routine/count)必须是 `0` 或 `1`。

The `notandthen` operator returns [`Empty`](https://rakudocs.github.io/type/Slip#index-entry-Empty-Empty) upon encountering the first [defined](https://rakudocs.github.io/routine/defined) argument, otherwise the last argument. Last argument is returned as-is, without being checked for definedness at all. Short-circuits. The result of the left side is bound to `$_` for the right side, or passed as arguments if the right side is a [`Callable`](https://rakudocs.github.io/type/Callable), whose [count](https://rakudocs.github.io/routine/count) must be `0` or `1`.

乍一看，[notandthen](https://rakudocs.github.io/routine/notandthen) 可能看起来与 [orelse](https://rakudocs.github.io/routine/orelse) 运算符相同。区别很微妙：[notandthen](https://rakudocs.github.io/routine/notandthen) 在遇到[定义的](https://rakudocs.github.io/routine/defined)项（这不是最后一个项）时返回 [`Empty`](https://rakudocs.github.io/type/Slip#index-entry-Empty-Empty)，而 [orelse](https://rakudocs.github.io/routine/orelse) 返回该定义的项。换句话说，[notandthen](https://rakudocs.github.io/routine/notandthen) 是一种在未定义项时执行的方法，而 [orelse](https://rakudocs.github.io/routine/orelse) 是获取第一个定义项的方法：

At first glance, [notandthen](https://rakudocs.github.io/routine/notandthen) might appear to be the same thing as the [orelse](https://rakudocs.github.io/routine/orelse) operator. The difference is subtle: [notandthen](https://rakudocs.github.io/routine/notandthen) returns [`Empty`](https://rakudocs.github.io/type/Slip#index-entry-Empty-Empty) when it encounters a [defined](https://rakudocs.github.io/routine/defined) item (that isn't the last item), whereas [orelse](https://rakudocs.github.io/routine/orelse) returns that item. In other words, [notandthen](https://rakudocs.github.io/routine/notandthen) is a means to act when items aren't defined, whereas [orelse](https://rakudocs.github.io/routine/orelse) is a means to obtain the first defined item:

```Raku
sub all-sensors-down     { [notandthen] |@_, True             }
sub first-working-sensor { [orelse]     |@_, 'default sensor' }
 
all-sensors-down Nil, Nil, Nil
  and say 'OMG! All sensors are down!'; # OUTPUT:«OMG! All sensors are down!␤» 
say first-working-sensor Nil, Nil, Nil; # OUTPUT:«default sensor␤» 
 
all-sensors-down Nil, 42, Nil
  and say 'OMG! All sensors are down!'; # No output 
say first-working-sensor Nil, 42, Nil;  # OUTPUT:«42␤» 
```

`notandthen` 运算符是 [`without` 语句修饰符](https://rakudocs.github.io/syntax/with%20orwith%20without)，一些编译器编译 `without` 为 `notandthen`，这意味着下面这两行具有相同的行为：

The `notandthen` operator is a close relative of [`without` statement modifier](https://rakudocs.github.io/syntax/with%20orwith%20without), and some compilers compile `without` to `notandthen`, meaning these two lines have equivalent behavior:

```Raku
sub good-things { fail }
 
'boo'.say without good-things;
good-things() notandthen 'boo'.say;
```

<a id="%E5%AE%BD%E6%9D%BE%E7%9A%84%E6%88%96%E8%BF%90%E7%AE%97%E7%AC%A6%E4%BC%98%E5%85%88%E7%BA%A7--loose-or-precedence"></a>
# 宽松的或运算符优先级 / Loose OR precedence

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-or--infix-or"></a>
## 中缀运算符 `or` / infix `or`

与 [infix `||`](https://rakudocs.github.io/routine/%7C%7C) 相同，但优先级较低。

Same as [infix `||`](https://rakudocs.github.io/routine/%7C%7C), except with looser precedence.

返回在布尔上下文中计算为 `True` 的第一个参数，或者最后一个参数，它有短路效果。请注意 `or` 很容易被误用。请参阅[陷阱](https://rakudocs.github.io/language/traps#Loose_boolean_operators)。

Returns the first argument that evaluates to `True` in boolean context, or otherwise the last argument, it short-circuits. Please note that `or` is easy to misuse. See [traps](https://rakudocs.github.io/language/traps#Loose_boolean_operators).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-orelse--infix-orelse"></a>
## 中缀运算符 `orelse` / infix `orelse`

`orelse` 操作符类似于 `中缀运算符 //`，除了具有较宽松的优先级和 `$_` 别名。

The `orelse` operator is similar to `infix //`, except with looser precedence and `$_` aliasing.

返回第一个定义的参数，否则返回最后一个参数。最后一个参数按原样返回，不检查其定义。左边的结果绑定到右边的 `$_` 上，或者如果右边是一个 [`Callable`](https://rakudocs.github.io/type/Callable) 则左边的结果作为参数传递，其[函数参数个数](https://rakudocs.github.io/routine/count)必须是 `0` 或 `1`。

Returns the first defined argument, or else the last argument. Last argument is returned as-is, without being checked for definedness at all. Short-circuits. The result of the left side is bound to `$_` for the right side, or passed as an argument if the right side is a [`Callable`](https://rakudocs.github.io/type/Callable), whose [count](https://rakudocs.github.io/routine/count) must be `0` or `1`.

此运算符对于处理例程返回的 [Failure](https://rakudocs.github.io/type/Failure) 非常有用，因为预期值通常是[定义的](https://rakudocs.github.io/routine/defined)和 [Failure](https://rakudocs.github.io/type/Failure) 从不是：

This operator is useful for handling [Failures](https://rakudocs.github.io/type/Failure) returned by routines since the expected value is usually [defined](https://rakudocs.github.io/routine/defined) and [Failure](https://rakudocs.github.io/type/Failure) never is:

```Raku
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

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6-xor--infix-xor"></a>
## 中缀运算符 `xor` / infix `xor`

与 [infix `^^`](https://rakudocs.github.io/routine/$CIRCUMFLEX_ACCENT$CIRCUMFLEX_ACCENT) 相同，但优先级较低。

Same as [infix `^^`](https://rakudocs.github.io/routine/$CIRCUMFLEX_ACCENT$CIRCUMFLEX_ACCENT), except with looser precedence.

返回在布尔上下文中计算为 `True` 的操作数，如果且仅当其他操作数在布尔上下文中计算为 `False` 时返回。如果两个操作数都被评估为 `False`，则返回最后一个参数。如果两个操作数都被评估为 `True`，返回 `Nil`。

Returns the operand that evaluates to `True` in boolean context, if and only if the other operand evaluates to `False` in boolean context. If both operands evaluate to `False`, returns the last argument. If both operands evaluate to `True`, returns `Nil`.

当链接时，返回计算为 `True` 的操作数，当且仅当有一个这样的操作数时。如果多于一个操作数为真，则在评估第二操作数后短路并返回 `Nil`。如果所有操作数都为假，则返回最后一个操作数。

When chaining, returns the operand that evaluates to `True`, if and only if there is one such operand. If more than one operand is true, it short-circuits after evaluating the second and returns `Nil`. If all operands are false, returns the last one.

<a id="%E5%BA%8F%E5%88%97%E5%99%A8%E4%BC%98%E5%85%88%E7%BA%A7--sequencer-precedence"></a>
# 序列器优先级 / Sequencer precedence

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--28"></a>
## 中缀运算符 `==>` / infix `==>`

这个 feed 操作符从左边取结果，并把它传递给下一个（右）例程作为最后一个参数。

This feed operator takes the result from the left and passes it to the next (right) routine as the last parameter.

```Raku
my @array = (1, 2, 3, 4, 5);
@array ==> sum() ==> say();   # OUTPUT: «15␤»
```

上面这个简单的例子相当于写：

This simple example, above, is the equivalent of writing:

```Raku
my @array = (1, 2, 3, 4, 5);
say(sum(@array));             # OUTPUT: «15␤»
```

或者如果使用方法：

Or if using methods:

```Raku
my @array = (1, 2, 3, 4, 5);
@array.sum.say;               # OUTPUT: «15␤»
```

优先级非常松散，因此您需要使用括号来分配结果，或者您甚至可以使用另一个 feed 运算符！如果例程/方法只接受一个参数，或者第一个参数是块，则通常需要用括号调用（尽管最后一个例程/方法不需要这样做）。

The precedence is very loose so you will need to use parentheses to assign the result or you can even just use another feed operator! In the case of routines/methods that take a single argument or where the first argument is a block, it's often required that you call with parentheses (though this is not required for the very last routine/method).

这个“传统”结构，从底部读到顶部，用最后两行创建要处理的数据结构。

This "traditional" structure, read bottom-to-top, with the last two lines creating the data structure that is going to be processed

```Raku
my @fractions = <TWO THREE FOUR FIVE SEVEN> »~» " " X~ <FIFTHS SIXTHS EIGHTHS>;
my @result = map { .uniparse },                    # (3) Converts to unicode 
    grep { .uniparse },                            # (2) Checks if it parses 
    map( {"VULGAR FRACTION " ~ $^þ }, @fractions); # (1) Adds string to input 
 
# @result is [⅖ ⅗ ⅜ ⅘ ⅚ ⅝ ⅞]
```

现在我们使用 feed 操作符（从左到右）和括号，从上到下阅读

Now we use the feed operator (left-to-right) with parentheses, read top-to-bottom

```Raku
my @result = (
    <TWO THREE FOUR FIVE SEVEN> »~» " " X~ <FIFTHS SIXTHS EIGHTHS> # (1) Input 
    ==> map( {"VULGAR FRACTION " ~ $^þ } )                         # (2) Converts to Unicode name 
    ==> grep({ .uniparse })                                        # (3) Filters only real names 
    ==> map( { .uniparse} );                                       # (4) Converts to unicode 
);
```

为便于说明，方法链等效代码，自上而下阅读，使用与上述相同的顺序。

For illustration, method chaining equivalent, read top-to-bottom, using the same sequence as above

```Raku
my @result = ( <TWO THREE FOUR FIVE SEVEN> »~» " " X~ <FIFTHS SIXTHS EIGHTHS>)
    .map( {"VULGAR FRACTION " ~ $^þ } )
    .grep({ .uniparse })
    .map({ .uniparse });
```

虽然在这种特殊情况下，结果是相同的，但是 feed 操作符 `==>` 更清楚地显示了箭头指向数据流的方向的意图。若要在不需要括号的情况下赋值，请使用另一个 feed 运算符

Although in this particular case the result is the same, the feed operator `==>` more clearly shows intent with arrow pointing in the direction of the data flow. To assign without the need of parentheses use another feed operator

```Raku
my @result;
<people of earth>
    ==> map({ .tc })
    ==> grep /<[PE]>/
    ==> sort()
    ==> @result;
```

捕获部分结果可能很有用，但是，与向左 feed 运算符不同，它需要括号或分号

It can be useful to capture a partial result, however, unlike the leftward feed operator, it does require parentheses or a semicolon

```Raku
my @result;
<people of earth>
    ==> map({ .tc })
    ==> my @caps; @caps   # also could wrap in parentheses instead 
    ==> grep /<[PE]>/
    ==> sort()
    ==> @result;
```

feed 运算符允许您根据例程和不相关数据的方法的结果构造方法链模式。在方法链中，您仅限于数据上可用的方法或先前方法调用的结果。有了 feed 运算符，这个限制就没有了。所得到的代码也可以比多行中断的一系列方法调用更可读。

The feed operator lets you construct method-chaining-like patterns out of routines and the results of methods on unrelated data. In method-chaining, you are restricted to the methods available on the data or the result of previous method call. With feed operators, that restriction is gone. The resulting code could also be seen to be more readable than a series of method calls broken over multiple lines.

注意：在将来，这个运算符将看到一些变化，因为它获得了并行运行列表操作的能力。它将强制**左**操作数作为闭包封装（可以在子线程中克隆和运行）。

Note: In the future, this operator will see some change as it gains the ability to run list operations in parallel. It will enforce that the **left** operand is enclosable as a closure (that can be cloned and run in a subthread).

<a id="%E4%B8%AD%E7%BC%80%E8%BF%90%E7%AE%97%E7%AC%A6---infix--29"></a>
## 中缀运算符 `<==` / infix `<==`

这个向左的 feed 运算符从右边取结果，并将其传递给上一个（左）例程作为最后一个参数。这说明了一系列列表操作函数的从右到左的数据流。

This leftward feed operator takes the result from the right and passes it to the previous (left) routine as the last parameter. This elucidates the right-to-left dataflow for a series of list manipulating functions.

```Raku
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

与向右 feed 操作符不同，其结果与方法链不密切相关。但是，与上面的传统结构（每个参数用一行分隔）相比，生成的代码比逗号更具示范性。左向 feed 操作符还允许您“闯入”语句并捕获中间结果，这对于调试或获取该结果并在最终结果上创建另一个变体非常有用。

Unlike the rightward feed operator, the result is not closely mappable to method-chaining. However, compared to the traditional structure above where each argument is separated by a line, the resulting code is more demonstrative than commas. The leftward feed operator also allows you to "break into" the statement and capture an intermediary result which can be extremely useful for debugging or to take that result and create another variation on the final result.

注意：在将来，这个运算符将看到一些变化，因为它获得了并行运行列表操作的能力。它将强制将**右**操作数作为闭包封装（可以在子线程中克隆和运行）。

Note: In the future, this operator will see some change as it gains the ability to run list operations in parallel. It will enforce that the **right** operand is enclosable as a closure (that can be cloned and run in a subthread).

<a id="%E6%A0%87%E8%AF%86--identity"></a>
# 标识 / Identity

一般来说，中缀运算符可以应用于单个元素或空元素，而不会产生错误，通常在 [reduce](https://rakudocs.github.io/routine/reduce) 操作的上下文中。

In general, infix operators can be applied to a single or no element without yielding an error, generally in the context of a [reduce](https://rakudocs.github.io/routine/reduce) operation.

```Raku
say [-] ()  # OUTPUT: «0␤»
```

设计文档阐述了这应该返回[标识值](https://en.wikipedia.org/wiki/Identity_element)，[并且必须为每个操作员指定](http://design.perl6.org/S03.html#Reduction_operators)一个标识值。一般来说，返回的标识元素应该是直观的。但是，这里有一个表，它阐述了如何在 Raku 中定义运算符类，该表对应于上述表中的定义，他们是由语言定义的类型和运算符：

The design documents specify that this should return [an identity value](https://en.wikipedia.org/wiki/Identity_element), and that an identity value [must be specified for every operator](http://design.perl6.org/S03.html#Reduction_operators). In general, the identity element returned should be intuitive. However, here is a table that specifies how it is defined for operator classes in Raku, which corresponds to the table in the above definition in the types and operators defined by the language:

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

例如，空列表的并集将返回空集：

For instance, union of an empty list will return an empty set:

```Raku
say [∪];  # OUTPUT: «set()␤»
```

这仅适用于对空或 0 始终是有效操作数的运算符。例如，将其应用于除法将产生一个异常。

This only applies to operators where empty or 0 is always a valid operand. For instance, applying it to division will yield an exception.

```Raku
say [%] ();  # OUTPUT: «(exit code 1) No zero-arg meaning for infix:<%>␤ 
```
