原文：https://docs.raku.org/language/enumeration

# 枚举 / Enumeration

一个使用 enum 类型的例子

An example using the enum type

`enum` 类型在 Raku 中比其他语言复杂得多，细节见 [enum 的类型说明](https://docs.raku.org/language/typesystem#enum)。

The `enum` type is much more complex in Raku than in some other languages, and the details are found in [its type description](https://docs.raku.org/language/typesystem#enum).

这个简短的文档将给出一个简单的例子，说明它的用法，就像类 C 语言中通常的做法一样。

This short document will give a simple example of its use as is the usual practice in C-like languages.

假设我们有一个程序需要写入不同的目录；我们想要一个函数，给定一个目录名，测试（1）它的存在和（2）它是否可以被程序的用户写入；这意味着从用户的角度来看，有三种可能的状态：要么你可以写入（`CanWrite`），要么没有目录。（`NoDir`）或目录存在，但无法写入（`NoWrite`）。测试的结果将决定程序接下来要采取什么行动。

Say we have a program that needs to write to various directories; we want a function that, given a directory name, tests it for (1) its existence and (2) whether it can be written to by the user of the program; this implies that there are three possible states from the user perspective: either you can write (`CanWrite`), or there is no directory (`NoDir`) or the directory exists, but you cannot write (`NoWrite`). The results of the test will determine what actions the program takes next.

```
enum DirStat <CanWrite NoDir NoWrite>;
sub check-dir-status($dir --> DirStat) {
    if $dir.IO.d {
        # dir exists, can the program user write to it? 
        my $f = "$dir/.tmp";
        spurt $f, "some text";
        CATCH {
            # 无法写入 / unable to write for some reason 
            return NoWrite;
        }
        # 成功写入目录 / if we get here we must have successfully written to the dir 
        unlink $f;
        return CanWrite;
    }
    # 目录不存在 / if we get here the dir must not exist 
    return NoDir;
}
 
# test each of three directories by a non-root user 
my $dirs =
    '/tmp',  # normally writable by any user 
    '/',     # writable only by root 
    '~/tmp'; # a non-existent dir in the user's home dir 
for $dirs -> $dir {
    my $stat = check-dir-status $dir;
    say "status of dir '$dir': $stat";
    if $stat ~~ CanWrite {
        say "  user can write to dir: $dir";
    }
}
# output 
#   status of dir '/tmp': CanWrite 
#     user can write to dir: /tmp 
#   status of dir '/': NoWrite 
#   status of dir '~/tmp': NoDir 
```