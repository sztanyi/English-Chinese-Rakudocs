原文：https://docs.raku.org/language/unicode_ascii

# Unicode 与 ASCII 符号 / Unicode versus ASCII symbols

Unicode 符号及其 ASCII 等价物

Unicode symbols and their ASCII equivalents

以下 Unicode 符号可以在 Raku 中使用，而无需加载任何其他模组。其中一些具有只用输入 ASCII 字符的等效符号。

The following Unicode symbols can be used in Raku without needing to load any additional modules. Some of them have equivalents which can be typed with ASCII-only characters.

下面引用 Unicode 码点的各种属性。最终列表可以在这里找到：<https://www.unicode.org/Public/UCD/latest/ucd/PropList.txt>。

Reference is made below to various properties of unicode codepoints. The definitive list can be found here: <https://www.unicode.org/Public/UCD/latest/ucd/PropList.txt>.

<!-- MarkdownTOC -->

- [字母数字符 / Alphabetic characters](#%E5%AD%97%E6%AF%8D%E6%95%B0%E5%AD%97%E7%AC%A6--alphabetic-characters)
- [数字字符 / Numeric characters](#%E6%95%B0%E5%AD%97%E5%AD%97%E7%AC%A6--numeric-characters)
- [数值 / Numeric values](#%E6%95%B0%E5%80%BC--numeric-values)
- [空白字符 / Whitespace characters](#%E7%A9%BA%E7%99%BD%E5%AD%97%E7%AC%A6--whitespace-characters)
- [其他可接受的单码点 / Other acceptable single codepoints](#%E5%85%B6%E4%BB%96%E5%8F%AF%E6%8E%A5%E5%8F%97%E7%9A%84%E5%8D%95%E7%A0%81%E7%82%B9--other-acceptable-single-codepoints)
    - [原子运算符 / Atomic operators](#%E5%8E%9F%E5%AD%90%E8%BF%90%E7%AE%97%E7%AC%A6--atomic-operators)
- [多码点 / Multiple codepoints](#%E5%A4%9A%E7%A0%81%E7%82%B9--multiple-codepoints)

<!-- /MarkdownTOC -->

<a id="%E5%AD%97%E6%AF%8D%E6%95%B0%E5%AD%97%E7%AC%A6--alphabetic-characters"></a>
# 字母数字符 / Alphabetic characters

任何具有 `Ll`（字母、小写）、`Lu`（字母、大写）、`Lt`（字母、标题）、`Lm`（字母、修饰符）或 `Lo`（字母、其他）属性的代码点，都可以像 ASCII 范围中的任何其他字母字符一样使用。

Any codepoint that has the `Ll` (Letter, lowercase), `Lu` (Letter, uppercase), `Lt` (Letter, titlecase), `Lm` (Letter, modifier), or the `Lo` (Letter, other) property can be used just like any other alphabetic character from the ASCII range.

```Raku
my $Δ = 1;
$Δ++;
say $Δ;
```

<a id="%E6%95%B0%E5%AD%97%E5%AD%97%E7%AC%A6--numeric-characters"></a>
# 数字字符 / Numeric characters

任何具有 `Nd`（数字，十进制数字）属性的代码点，都可以用作任何数字中的数字。例如：

Any codepoint that has the `Nd` (Number, decimal digit) property, can be used as a digit in any number. For example:

```Raku
my $var = １９; # U+FF11 U+FF19 
say $var + 2;  # OUTPUT: «21␤»
```

<a id="%E6%95%B0%E5%80%BC--numeric-values"></a>
# 数值 / Numeric values

任何具有 `No`（数字，其他）或 `Nl`（数字，字母）属性的代码点都可以单独用作数值，如 ½ 和 ⅓。（这些不是十进制数字字符，所以不能合并。）例如：

Any codepoint that has the `No` (Number, other) or `Nl` (Number, letter) property can be used standalone as a numeric value, such as ½ and ⅓. (These aren't decimal digit characters, so can't be combined.) For example:

```Raku
my $var = ⅒ + 2 + Ⅻ; # here ⅒ is No and Rat and Ⅻ is Nl and Int 
say $var;            # OUTPUT: «14.1␤»
```

<a id="%E7%A9%BA%E7%99%BD%E5%AD%97%E7%AC%A6--whitespace-characters"></a>
# 空白字符 / Whitespace characters

除了空格和制表符外，你还可以使用任何具有 `Zs`（分隔符，空格）、`Zl`（分隔符，行）或 `Zp`（分隔符，段落）属性的 Unicode 空白字符。

Besides spaces and tabs you can use any other unicode whitespace character that has the `Zs` (Separator, space), `Zl` (Separator, line), or `Zp` (Separator, paragraph) property.

<a id="%E5%85%B6%E4%BB%96%E5%8F%AF%E6%8E%A5%E5%8F%97%E7%9A%84%E5%8D%95%E7%A0%81%E7%82%B9--other-acceptable-single-codepoints"></a>
# 其他可接受的单码点 / Other acceptable single codepoints

此列表包含在 Raku 中具有特殊意义的单个代码点[及其他们的 ASCII 等效项]。

This list contains the single codepoints [and their ASCII equivalents] that have a special meaning in Raku.

| Symbol | Codepoint | ASCII   | Remarks                                                      |
| ------ | --------- | ------- | ------------------------------------------------------------ |
| «      | U+00AB    | <<      | as part of «» or .« or regex left word boundary              |
| ¯      | U+00AF    | -       | (must use explicit number) as part of exponentiation (macron is an alternative way of writing a minus) |
| ²      | U+00B2    | **2     | can be combined with ⁰..⁹                                    |
| ³      | U+00B3    | **3     | can be combined with ⁰..⁹                                    |
| ¹      | U+00B9    | **1     | can be combined with ⁰..⁹                                    |
| »      | U+00BB    | >>      | as part of «» or .» or regex right word boundary             |
| ×      | U+00D7    | *       |                                                              |
| ÷      | U+00F7    | /       |                                                              |
| π      | U+03C0    | pi      | 3.14159_26535_89793_238e0                                    |
| τ      | U+03C4    | tau     | 6.28318_53071_79586_476e0                                    |
| ‘      | U+2018    | '       | as part of ‘’ or ’‘                                          |
| ’      | U+2019    | '       | as part of ‘’ or ‚’ or ’‘                                    |
| ‚      | U+201A    | '       | as part of ‚‘ or ‚’                                          |
| “      | U+201C    | "       | as part of “” or ”“                                          |
| ”      | U+201D    | "       | as part of “” or ”“ or ””                                    |
| „      | U+201E    | "       | as part of „“ or „”                                          |
| …      | U+2026    | ...     |                                                              |
| ⁰      | U+2070    | **0     | can be combined with ⁰..⁹                                    |
| ⁴      | U+2074    | **4     | can be combined with ⁰..⁹                                    |
| ⁵      | U+2075    | **5     | can be combined with ⁰..⁹                                    |
| ⁶      | U+2076    | **6     | can be combined with ⁰..⁹                                    |
| ⁷      | U+2077    | **7     | can be combined with ⁰..⁹                                    |
| ⁸      | U+2078    | **8     | can be combined with ⁰..⁹                                    |
| ⁹      | U+2079    | **9     | can be combined with ⁰..⁹                                    |
| ⁺      | U+207A    | +       | (must use explicit number) as part of exponentiation         |
| ⁻      | U+207B    | -       | (must use explicit number) as part of exponentiation         |
| ∅      | U+2205    | set()   | (empty set)                                                  |
| ∈      | U+2208    | (elem)  |                                                              |
| ∉      | U+2209    | !(elem) |                                                              |
| ∋      | U+220B    | (cont)  |                                                              |
| ∌      | U+220C    | !(cont) |                                                              |
| −      | U+2212    | -       |                                                              |
| ∖      | U+2216    | (-)     |                                                              |
| ∘      | U+2218    | o       |                                                              |
| ∞      | U+221E    | Inf     |                                                              |
| ∩      | U+2229    | (&)     |                                                              |
| ∪      | U+222A    | (\|)    |                                                              |
| ≅      | U+2245    | =~=     |                                                              |
| ≠      | U+2260    | !=      |                                                              |
| ≤      | U+2264    | <=      |                                                              |
| ≥      | U+2265    | >=      |                                                              |
| ⊂      | U+2282    | (<)     |                                                              |
| ⊃      | U+2283    | (>)     |                                                              |
| ⊄      | U+2284    | !(<)    |                                                              |
| ⊅      | U+2285    | !(>)    |                                                              |
| ⊆      | U+2286    | (<=)    |                                                              |
| ⊇      | U+2287    | (>=)    |                                                              |
| ⊈      | U+2288    | !(<=)   |                                                              |
| ⊉      | U+2289    | !(>=)   |                                                              |
| ⊍      | U+228D    | (.)     |                                                              |
| ⊎      | U+228E    | (+)     |                                                              |
| ⊖      | U+2296    | (^)     |                                                              |
| 𝑒      | U+1D452   | e       | 2.71828_18284_59045_235e0                                    |
| ｢      | U+FF62    | Q//     | as part of ｢｣ (Note: Q// variant cannot be used bare in regexes) |
| ｣      | U+FF63    | Q//     | as part of ｢｣ (Note: Q// variant cannot be used bare in regexes) |

<a id="%E5%8E%9F%E5%AD%90%E8%BF%90%E7%AE%97%E7%AC%A6--atomic-operators"></a>
## 原子运算符 / Atomic operators

原子运算符中含有 `U+269B ⚛ ATOM SYMBOL`。它们的 ASCII 等价物是普通子程序，而不是运算符：

The atomic operators have `U+269B ⚛ ATOM SYMBOL` incorporated into them. Their ASCII equivalents are ordinary subroutines, not operators:

```Raku
my atomicint $x = 42;
$x⚛++;                # Unicode version 
atomic-fetch-inc($x); # ASCII version
```

ASCII 替代品如下：

The ASCII alternatives are as follows:

| Symbol | ASCII            | Remarks                              |
| ------ | ---------------- | ------------------------------------ |
| ⚛=     | atomic-assign    |                                      |
| ⚛      | atomic-fetch     | this is the prefix:<⚛> operator      |
| ⚛+=    | atomic-add-fetch |                                      |
| ⚛-=    | atomic-sub-fetch |                                      |
| ⚛−=    | atomic-sub-fetch | this operator uses U+2212 minus sign |
| ++⚛    | atomic-inc-fetch |                                      |
| ⚛++    | atomic-fetch-inc |                                      |
| --⚛    | atomic-dec-fetch |                                      |
| ⚛--    | atomic-fetch-dec |                                      |

<a id="%E5%A4%9A%E7%A0%81%E7%82%B9--multiple-codepoints"></a>
# 多码点 / Multiple codepoints

此列表包含需要为其 ASCII 等价物特殊组合的多个代码点运算符。注意，代码点显示为空格分隔，但在使用时应作为相邻的码点输入。

This list contains multiple-codepoint operators that require special composition for their ASCII equivalents. Note the codepoints are shown space-separated but should be entered as adjacent codepoints when used.

| Symbol | Codepoints      | ASCII   | Since | Remarks        |
| ------ | --------------- | ------- | ----- | -------------- |
| »=»    | U+00BB = U+00BB | >>[=]>> | v6.c  | uses ASCII '=' |
| «=«    | U+00AB = U+00AB | <<[=]<< | v6.c  | uses ASCII '=' |
| «=»    | U+00AB = U+00BB | <<[=]>> | v6.c  | uses ASCII '=' |
| »=«    | U+00BB = U+00AB | >>[=]<< | v6.c  | uses ASCII '=' |
