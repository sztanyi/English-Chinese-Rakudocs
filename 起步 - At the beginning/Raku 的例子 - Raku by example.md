原文：https://docs.raku.org/language/101-basics

# Perl 6 by example P6-101

A basic introductory example of a Perl 6 program

Suppose that you host a table tennis tournament. The referees tell you the results of each game in the format `Player1 Player2 | 3:2`, which means that `Player1` won against `Player2` by 3 to 2 sets. You need a script that sums up how many matches and sets each player has won to determine the overall winner.

The input data (stored in a file called `scores.txt`) looks like this:

```Perl6
Beth Ana Charlie Dave
Ana Dave | 3:0
Charlie Beth | 3:1
Ana Beth | 2:3
Dave Charlie | 3:0
Ana Charlie | 3:1
Beth Dave | 0:3
```

The first line is the list of players. Every subsequent line records a result of a match.

Here's one way to solve that problem in Perl 6:

```Perl6
use v6;
 
my $file  = open 'scores.txt';
my @names = $file.get.words;
 
my %matches;
my %sets;
 
for $file.lines -> $line {
    next unless $line; # ignore any empty lines 
 
    my ($pairing, $result) = $line.split(' | ');
    my ($p1, $p2)          = $pairing.words;
    my ($r1, $r2)          = $result.split(':');
 
    %sets{$p1} += $r1;
    %sets{$p2} += $r2;
 
    if $r1 > $r2 {
        %matches{$p1}++;
    } else {
        %matches{$p2}++;
    }
}
 
my @sorted = @names.sort({ %sets{$_} }).sort({ %matches{$_} }).reverse;
 
for @sorted -> $n {
    say "$n has won %matches{$n} matches and %sets{$n} sets";
}
```

This produces the output:

```Perl6
Ana has won 2 matches and 8 sets
Dave has won 2 matches and 6 sets
Charlie has won 1 matches and 4 sets
Beth has won 1 matches and 4 sets
```

## `v6`

Every Perl 6 program should begin with a line similar to `use v6;`. This line tells the compiler which version of Perl the program expects. Should you accidentally run the file with Perl 5, you'll get a helpful error message. 6.c is an example of a Perl 6 version.

## `statement`

A Perl 6 program consists of zero or more statements. A *statement* ends with a semicolon or a curly brace at the end of a line:

```Perl6
my $file = open 'scores.txt';
```

## `lexical` and `block`

`my` declares a lexical variable, which are visible only in the current block from the point of declaration to the end of the block. If there's no enclosing block, it's visible throughout the remainder of the file (which would effectively be the enclosing block). A block is any part of the code enclosed between curly braces `{ }`.

## `sigil` and `identifier`

A variable name begins with a *sigil*, which is a non-alpha-numeric symbol such as `$`, `@`, `%`, or `&`--or occasionally the double colon `::`. Sigils indicate the structural interface for the variable, such as whether it should be treated as a single value, a compound value, a subroutine, etc. After the sigil comes an *identifier*, which may consist of letters, digits and the underscore. Between letters you can also use a dash `-` or an apostrophe `'`, so `isn't` and `double-click` are valid identifiers.

## `scalar`

Sigils indicate the default access method for a variable. Variables with the `@` sigil are accessed positionally; variables with the `%`sigil are accessed by string key. The `$` sigil, however, indicates a general scalar container that can hold any single value and be accessed in any manner. A scalar can even contain a compound object like an `Array` or a `Hash`; the `$` sigil signifies that it should be treated as a single value, even in a context that expects multiple values (as with an `Array` or `Hash`).

## `filehandle` and `assignment`

The built-in function `open` opens a file, here named `scores`, and returns a *filehandle*--an object representing that file. The equality sign `=` *assigns* that filehandle to the variable on the left, which means that `$file` now stores the filehandle.

## `string literal`

`'scores.txt'` is a *string literal*. A string is a piece of text, and a string literal is a string which appears directly in the program. In this line, it's the argument provided to `open`.

```Perl6
my @names = $file.get.words;
```

## [`array`](), [`method`]() and [`invocant`]()

The right-hand side calls a *method* --a named group of behavior-- named `get` on the filehandle stored in `$file`. The `get`method reads and returns one line from the file, removing the line ending. If you print the contents of `$file` after calling `get`, you will see that the first line is no longer in there. `words` is also a method, called on the string returned from `get`. `words`decomposes its *invocant*--the string on which it operates--into a list of words, which here means strings separated by whitespace. It turns the single string `'Beth Ana Charlie Dave'` into the list of strings `'Beth', 'Ana', 'Charlie', 'Dave'`.

Finally, this list gets stored in the [Array](https://docs.raku.org/type/Array) `@names`. The `@` sigil marks the declared variable as an `Array`. Arrays store ordered lists.

```Perl6
my %matches;
my %sets;
```

## [`hash`]()

These two lines of code declare two hashes. The `%` sigil marks each variable as a `Hash`. A `Hash` is an unordered collection of key-value pairs. Other programming languages call that a *hash table*, *dictionary*, or *map*. You can query a hash table for the value that corresponds to a certain `$key` with `%hash{$key}`.

In the score counting program, `%matches` stores the number of matches each player has won. `%sets` stores the number of sets each player has won. Both of these hashes are indexed by the player's name.

```Perl6
for $file.lines -> $line {
    ...
}
```

## [`for`]() and [`block`]()

`for` produces a loop that runs the *block* delimited by curly braces once for each item of the list, setting the variable `$line` to the current value of each iteration. `$file.lines` produces a list of the lines read from the file `scores.txt`, starting with the second line of the file since we already called `$file.get` once, and going all the way to the end of the file.

During the first iteration, `$line` will contain the string `Ana Dave | 3:0`; during the second, `Charlie Beth | 3:1`, and so on.

```Perl6
my ($pairing, $result) = $line.split(' | ');
```

`my` can declare multiple variables simultaneously. The right-hand side of the assignment is a call to a method named `split`, passing along the string `' | '` as an argument.

`split` decomposes its invocant into a list of strings, so that joining the list items with the separator `' | '` produces the original string.

`$pairing` gets the first item of the returned list, and `$result` the second.

After processing the first line, `$pairing` will hold the string `Ana Dave` and `$result` `3:0`.

The next two lines follow the same pattern:

```Perl6
my ($p1, $p2) = $pairing.words;
my ($r1, $r2) = $result.split(':');
```

The first extracts and stores the names of the two players in the variables `$p1` and `$p2`. The second extracts the results for each player and stores them in `$r1` and `$r2`.

After processing the first line of the file, the variables contain the values: cell `'0'`

| Variable | Contents          |
| -------- | ----------------- |
| $line    | 'Ana Dave \| 3:0' |
| $pairing | 'Ana Dave'        |
| $result  | '3:0'             |
| $p1      | 'Ana'             |
| $p2      | 'Dave'            |
| $r1      | '3'               |
| $r2      | '0'               |

The program then counts the number of sets each player has won:

```Perl6
%sets{$p1} += $r1;
%sets{$p2} += $r2;
```

The `+=` assignment operator is a shortcut for:

```Perl6
%sets{$p1} = %sets{$p1} + $r1;
%sets{$p2} = %sets{$p2} + $r2;
```

## [`Any`]() and [`+=`]()

`+= $r1` means *increase the value in the variable on the left by $r1*. In the first iteration `%sets{$p1}` is not yet set, so it defaults to a special value called `Any`. The addition and incrementing operators treat `Any` as a number with the value of zero; the strings get automatically converted to numbers, as addition is a numeric operation.

## [`fat arrow`](), [`pair`]() and [`autovivification`]()

Before these two lines execute, `%sets` is empty. Adding to an entry that is not in the hash yet will cause that entry to spring into existence just-in-time, with a value starting at zero. (This is *autovivification*). After these two lines have run for the first time, `%sets` contains `'Ana' => 3, 'Dave' => 0 `. (The fat arrow `=> `separates key and value in a `Pair`.)

```Perl6
if $r1 > $r2 {
    %matches{$p1}++;
} else {
    %matches{$p2}++;
}
```

If `$r1` is numerically larger than `$r2`, `%matches{$p1}` increments by one. If `$r1` is not larger than `$r2`, `%matches{$p2}`increments. Just as in the case of `+=`, if either hash value did not exist previously, it is autovivified by the increment operation.

## [`postincrement`]() and [`preincrement`]()

`$thing++` is short for `$thing += 1` or `$thing = $thing + 1`, with the small exception that the return value of the expression is `$thing` *before* the increment, not the incremented value. As in many other programming languages, you can use `++` as a prefix. Then it returns the incremented value; `my $x = 1; say ++$x` prints `2`.

```Perl6
my @sorted = @names.sort({ %sets{$_} }).sort({ %matches{$_} }).reverse;
```

## [`variables, $_`]()

This line consists of three individually simple steps. An array's `sort` method returns a sorted version of the array's contents. However, the default sort on an array sorts by its contents. To print player names in winner-first order, the code must sort the array by the *scores* of the players, not their names. The `sort` method's argument is a *block* used to transform the array elements (the names of players) to the data by which to sort. The array items are passed in through the *topic variable* `$_`.

## [`block`]()

You have seen blocks before: both the `for` loop `-> $line { ... } `and the `if` statement worked on blocks. A block is a self-contained piece of Perl 6 code with an optional signature (the `-> $line `part).

The simplest way to sort the players by score would be `@names.sort({ %matches{$_} })`, which sorts by number of matches won. However Ana and Dave have both won two matches. That simple sort doesn't account for the number of sets won, which is the secondary criterion to decide who has won the tournament.

## [`stable sort`]()

When two array items have the same value, `sort` leaves them in the same order as it found them. Computer scientists call this a *stable sort*. The program takes advantage of this property of Perl 6's `sort` to achieve the goal by sorting twice: first by the number of sets won (the secondary criterion), then by the number of matches won.

After the first sorting step, the names are in the order `Beth Charlie Dave Ana`. After the second sorting step, it's still the same, because no one has won fewer matches but more sets than someone else. Such a situation is entirely possible, especially at larger tournaments.

`sort` sorts in ascending order, from smallest to largest. This is the opposite of the desired order. Therefore, the code calls the `.reverse` method on the result of the second sort, and stores the final list in `@sorted`.

```Perl6
for @sorted -> $n {
    say "$n has won %matches{$n} matches and %sets{$n} sets";
}
```

## [`say`](), [`print`]() and [`put`]()

To print out the players and their scores, the code loops over `@sorted`, setting `$n` to the name of each player in turn. Read this code as "For each element of sorted, set `$n` to the element, then execute the contents of the following block." `say` prints its arguments to the standard output (the screen, normally), followed by a newline. (Use `print` if you don't want the newline at the end.)

Note that `say` will truncate certain data structures by calling the `.gist` method so `put` is safer if you want exact output.

## [`interpolation`]()

When you run the program, you'll see that `say` doesn't print the contents of that string verbatim. In place of `$n` it prints the contents of the variable `$n`-- the names of players stored in `$n`. This automatic substitution of code with its contents is *interpolation*. This interpolation happens only in strings delimited by double quotes `"..."`. Single quoted strings `'...'` do not interpolate:

## [`double-quoted strings`]() and [`single-quoted strings`]()

```Perl6
my $names = 'things';
say 'Do not call me $names'; # OUTPUT: «Do not call me $names␤» 
say "Do not call me $names"; # OUTPUT: «Do not call me things␤» 
```

Double quoted strings in Perl 6 can interpolate variables with the `$` sigil as well as blocks of code in curly braces. Since any arbitrary Perl code can appear within curly braces, `Array`s and `Hash`es may be interpolated by placing them within curly braces.

Arrays within curly braces are interpolated with a single space character between each item. Hashes within curly braces are interpolated as a series of lines. Each line will contain a key, followed by a tab character, then the value associated with that key, and finally a newline.

Let's see an example of this now.

In this example, you will see some special syntax that makes it easier to make a list of strings. This is the `<...> `[quote-words](https://docs.raku.org/language/operators#index-entry-qw-quote-words-quote-words)construct. When you put words in between the < and > they are all assumed to be strings, so you do not need to wrap them each in double quotes `"..." `.

```Perl6
say "Math: { 1 + 2 }";                  # OUTPUT: «Math: 3␤» 
my @people = <Luke Matthew Mark>;
say "The synoptics are: {@people}";     # OUTPUT: «The synoptics are: Luke Matthew Mark␤» 
 
say "{%sets}␤";                         # From the table tennis tournament 
 
# Charlie 4 
# Dave    6 
# Ana     8 
# Beth    4 
```

When array and hash variables appear directly in a double-quoted string (and not inside curly braces), they are only interpolated if their name is followed by a postcircumfix -- a bracketing pair that follows a statement. It's also ok to have a method call between the variable name and the postcircumfix.

## [`Zen slice`]()

```Perl6
my @flavors = <vanilla peach>;
 
say "we have @flavors";           # OUTPUT: «we have @flavors␤» 
say "we have @flavors[0]";        # OUTPUT: «we have vanilla␤» 
# so-called "Zen slice" 
say "we have @flavors[]";         # OUTPUT: «we have vanilla peach␤» 
 
# method calls ending in postcircumfix 
say "we have @flavors.sort()";    # OUTPUT: «we have peach vanilla␤» 
 
# chained method calls: 
say "we have @flavors.sort.join(', ')";
                                # OUTPUT: «we have peach, vanilla␤» 
```

# [Exercises](https://docs.raku.org/language/101-basics#___top)

**1.** The input format of the example program is redundant: the first line containing the name of all players is not necessary, because you can find out which players participated in the tournament by looking at their names in the subsequent rows.

How can you make the program run if you do not use the `@names` variable? Hint: `%hash.keys` returns a list of all keys stored in `%hash`.

**Answer:** Remove the line `my @names = $file.get.words;`, and change:

```Perl6
my @sorted = @names.sort({ %sets{$_} }).sort({ %matches{$_} }).reverse;
```

... into:

```Perl6
my @sorted = %sets.keys.sort({ %sets{$_} }).sort({ %matches{$_} }).reverse;
```

**2.** Instead of deleting the redundant `@names` variable, you can also use it to warn if a player appears that wasn't mentioned in the first line, for example due to a typo. How would you modify your program to achieve that?

Hint: Try using [membership operators](https://docs.raku.org/routine/(elem)).

**Answer:** Change `@names` to `@valid-players`. When looping through the lines of the file, check to see that `$p1` and `$p2` are in `@valid-players`. Note that for membership operators you can also use `(elem)` and `!(elem)`.

```Perl6
...;
my @valid-players = $file.get.words;
...;
 
for $file.lines -> $line {
    my ($pairing, $result) = $line.split(' | ');
    my ($p1, $p2)          = $pairing.split(' ');
    if $p1 ∉ @valid-players {
        say "Warning: '$p1' is not on our list!";
    }
    if $p2 ∉ @valid-players {
        say "Warning: '$p2' is not on our list!";
    }
    ...
}
```