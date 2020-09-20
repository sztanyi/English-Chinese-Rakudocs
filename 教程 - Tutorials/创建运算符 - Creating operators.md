原文：https://docs.raku.org/language/optut

# 创建运算符 / Creating operators

关于如何声明运算符和创建新运算符的简短教程。

A short tutorial on how to declare operators and create new ones.

运算符的声明方式是使用 `sub` 关键字，后面跟着 `prefix`、`infix`、`postfix`、`circumfix` 或 `postcircumfix`；然后是引号结构中的冒号和运算符名称。对于（后）环缀运算符，用空格分隔这两个部分。

Operators are declared by using the `sub` keyword followed by `prefix`, `infix`, `postfix`, `circumfix`, or `postcircumfix`; then a colon and the operator name in a quote construct. For (post-)circumfix operators separate the two parts by white space.

```Raku
sub hello {
    say "Hello, world!";
}

say &hello.^name;   # OUTPUT: «Sub␤» 
hello;              # OUTPUT: «Hello, world!␤» 

my $s = sub ($a, $b) { $a + $b };
say $s.^name;       # OUTPUT: «Sub␤» 
say $s(2, 5);       # OUTPUT: «7␤» 

# Alternatively we could create a more 
# general operator to sum n numbers 
sub prefix:<Σ>( *@number-list ) {
    [+] @number-list
}

say Σ (13, 16, 1); # OUTPUT: «30␤» 

sub infix:<:=:>( $a is rw, $b is rw ) {
    ($a, $b) = ($b, $a)
}

my ($num, $letter) = ('A', 3);
say $num;          # OUTPUT: «A␤» 
say $letter;       # OUTPUT: «3␤» 

# Swap two variables' values 
$num :=: $letter;

say $num;          # OUTPUT: «3␤» 
say $letter;       # OUTPUT: «A␤» 

sub postfix:<!>( Int $num where * >= 0 ) { [*] 1..$num }
say 0!;            # OUTPUT: «1␤» 
say 5!;            # OUTPUT: «120␤» 

sub postfix:<♥>( $a ) { say „I love $a!“ }
42♥;               # OUTPUT: «I love 42!␤» 

sub postcircumfix:<⸨ ⸩>( Positional $a, Whatever ) {
    say $a[0], '…', $a[*-1]
}

[1,2,3,4]⸨*⸩;      # OUTPUT: «1…4␤» 

constant term:<♥> = "♥"; # We don't want to quote "love", do we? 
sub circumfix:<α ω>( $a ) {
    say „$a is the beginning and the end.“
};

α♥ω;               # OUTPUT: «♥ is the beginning and the end.␤»
```

这些运算符使用[扩展标识符](https://docs.raku.org/syntax/identifiers#Extended_identifiers)句法；也就是说，可以使用任何类型的代码点引用它们。

These operators use the [extended identifier](https://docs.raku.org/syntax/identifiers#Extended_identifiers) syntax; that is what enables the use of any kind of codepoint to refer to them.
