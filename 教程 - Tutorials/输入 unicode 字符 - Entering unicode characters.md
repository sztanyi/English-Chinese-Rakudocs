原文：https://rakudocs.github.io/language/unicode_entry

# 输入 unicode 字符 / Entering unicode characters

在编辑器和 shell 中输入 Unicode 字符的方法

Input methods for unicode characters in editors and the shell

Perl 6 允许使用 Unicode 字符作为变量名。许多操作符使用 Unicode 符号（特别是 [set/bag operators](https://rakudocs.github.io/language/setbagmix#Set%252FBag_operators)）以及一些引用结构。因此，最好知道如何将这些符号输入编辑器，Perl 6 shell 和命令行，特别是如果符号不是键盘上的实际字符。

Perl 6 allows the use of unicode characters as variable names. Many operators are defined with unicode symbols (in particular the [set/bag operators](https://rakudocs.github.io/language/setbagmix#Set%252FBag_operators)) as well as some quoting constructs. Hence it is good to know how to enter these symbols into editors, the Perl 6 shell and the command line, especially if the symbols aren't available as actual characters on a keyboard.

有关在各种操作系统和环境下输入 Unicode 的一般信息，请参见 Wikipedia [Unicode 输入页面](https://en.wikipedia.org/wiki/Unicode_input)。

General information about entering unicode under various operating systems and environments can be found on the Wikipedia [unicode input page](https://en.wikipedia.org/wiki/Unicode_input).

<!-- MarkdownTOC -->

- [XCompose \(Linux\)](#xcompose-linux)
    - [使 compose 键全局生效 / Getting compose working in all programs](#%E4%BD%BF-compose-%E9%94%AE%E5%85%A8%E5%B1%80%E7%94%9F%E6%95%88--getting-compose-working-in-all-programs)
    - [ibus](#ibus)
        - [KDE](#kde)
- [WinCompose \(Windows\)](#wincompose-windows)
- [编辑器和 shell / Editors and shells](#%E7%BC%96%E8%BE%91%E5%99%A8%E5%92%8C-shell--editors-and-shells)
    - [Vim](#vim)
        - [vim-perl6](#vim-perl6)
    - [Emacs](#emacs)
    - [Unix shell](#unix-shell)
    - [Screen](#screen)
- [Perl 6 中一些有用的字符 / Some characters useful in Perl 6](#perl-6-%E4%B8%AD%E4%B8%80%E4%BA%9B%E6%9C%89%E7%94%A8%E7%9A%84%E5%AD%97%E7%AC%A6--some-characters-useful-in-perl-6)
    - [智能引号 / Smart quotes]\(https://en.wikipedia.org/wiki/Quotation_mark#Curved_quotes_and_Unicode\)](#%E6%99%BA%E8%83%BD%E5%BC%95%E5%8F%B7--smart-quoteshttpsenwikipediaorgwikiquotationmarkcurved_quotes_andunicode)
    - [书名号 / Guillemets]\(https://en.wikipedia.org/wiki/Guillemet\)](#%E4%B9%A6%E5%90%8D%E5%8F%B7--guillemetshttpsenwikipediaorgwikiguillemet)
    - [set/bag 操作符 / Set/bag operators](#setbag-%E6%93%8D%E4%BD%9C%E7%AC%A6--setbag-operators)
    - [数学符号 / Mathematical symbols](#%E6%95%B0%E5%AD%A6%E7%AC%A6%E5%8F%B7--mathematical-symbols)
    - [希腊字符 / Greek characters](#%E5%B8%8C%E8%85%8A%E5%AD%97%E7%AC%A6--greek-characters)
    - [上标和下标 / Superscripts and subscripts](#%E4%B8%8A%E6%A0%87%E5%92%8C%E4%B8%8B%E6%A0%87--superscripts-and-subscripts)

<!-- /MarkdownTOC -->


<a id="xcompose-linux"></a>
# XCompose (Linux)

Xorg 使用 [*Compose key*](https://en.wikipedia.org/wiki/Compose_key#GNU.2FLinux) 包含有向图支持。`AltGr + Shift` 的默认值可以重新映射到更简单的东西，例如 `Capslock`。在 *GNOME 2* 和 *MATE* 中，可以在 `Preferences → Keyboard → Layouts → Options → Position of Compose Key` 下设置。 因此，例如，要输入 `»+«`，你可以键入 `CAPSLOCK > > + CAPSLOCK < <`

Xorg includes digraph support using a [*Compose key*](https://en.wikipedia.org/wiki/Compose_key#GNU.2FLinux) . The default of `AltGr + Shift` can be remapped to something easier such as `Capslock`. In *GNOME 2* and *MATE* this can be setup under `Preferences → Keyboard → Layouts → Options → Position of Compose Key`. So, for example, to input `»+«` you could type `CAPSLOCK > > + CAPSLOCK < <`

*XCompose* 允许使用 `.XCompose` 文件自定义有向图序列，<https://github.com/kragen/xcompose/blob/master/dotXCompose> 是一个非常完整的文件。 在 *GNOME* 中，*XCompose* 被覆盖并替换为硬编码列表，但可以通过在你的环境中设置 `GTK_IM_MODULE=xim` 来恢复 *XCompose*。 可能还需要安装一个 xim 桥，例如 `uim-xim`。

*XCompose* allows customizing the digraph sequences using a `.XCompose` file and <https://github.com/kragen/xcompose/blob/master/dotXCompose> is an extremely complete one. In *GNOME*, *XCompose*was overridden and replaced with a hardcoded list, but it is possible to restore *XCompose* by setting `GTK_IM_MODULE=xim` in your environment. It might be necessary to install a xim bridge as well, such as `uim-xim`.

<a id="%E4%BD%BF-compose-%E9%94%AE%E5%85%A8%E5%B1%80%E7%94%9F%E6%95%88--getting-compose-working-in-all-programs"></a>
## 使 compose 键全局生效 / Getting compose working in all programs

在所有程序中使用 compose 键可能会出现问题。 在这种情况下，你可以试试 `ibus`。

You may have issues using the compose key in all programs. In that case you can try `ibus`.

```Bash
input_module=xim
export GTK_IM_MODULE=$input_module
export XMODIFIERS=@im=$input_module
export QT_IM_MODULE=$input_module
```

如果你想让它适用于所有用户，你可以把它放在一个文件 `/etc/profile.d/compose.sh` 中，这是最简单的方法，因为你不必处理不同的 GUI 环境如何设置 他们的环境变量。

If you want this to be for all users you can put this in a file `/etc/profile.d/compose.sh`, which is the easiest way, since you won't have to deal with how different GUI environments set up their environment variables.

如果你使用 KDE，可以将此文件放在 `~/.config/plasma-workspace/env/compose.sh` 中使其生效。 其他桌面环境将有所不同。 查找如何在你的环境中设置环境变量或使用上面的系统范围选项。

If you use KDE you can put this file in `~/.config/plasma-workspace/env/compose.sh` and that should work. Other desktop environments will be different. Look up how to set environment variables in yours or use the system-wide option above.

<a id="ibus"></a>
## ibus

如果使用 `xim` 输入模块输入高码点符号（例如**🐧**）时出现问题，则可以使用 ibus。 你必须安装 ibus 软件包。 然后，你必须将其设置为在加载桌面环境时启动。 需要运行的命令是：

If you have problems entering high codepoint symbols such as **🐧** using the `xim` input module, you can instead use ibus. You will have to install the ibus package for your distribution. Then you will have to set it to start on load of your Desktop environment. The command that needs to be run is:

```Bash
ibus-daemon --xim --verbose --daemonize --replace
```

设置 `--xim` 还应该允许不使用 ibus 的程序仍然使用 xim 输入法并向后兼容。

Setting `--xim` should also allow programs not using ibus to still use the xim input method and be backward compatible.

<a id="kde"></a>
### KDE

如果使用的是KDE，请打开开始菜单并输入 “Autostart”，然后单击应该是第一个结果的 **Autostart**。 在打开的设置窗口中，单击 **Add program**，键入 `ibus-daemon` 并单击 OK。 然后进入弹出窗口的 Application 选项卡。 在 `Command` 字段中，输入完整的 ibus-daemon 命令，如上所示，`--desktop` 选项设置为 `--desktop=plasma`。 单击 OK。 它现在应该在再次登录时自动启动。

If you are using KDE, open the start menu and type in “Autostart” and click **Autostart** which should be the first result. In the settings window that opens, click **Add program**, type in `ibus-daemon` and click OK. Then go into the Application tab of the window that pops up. In the `Command` field, enter in the full ibus-daemon command as shown above, with the `--desktop` option set to `--desktop=plasma`. Click OK. It should now launch automatically when you log in again.

<a id="wincompose-windows"></a>
# WinCompose (Windows)

[WinCompose](https://github.com/samhocevar/wincompose) 将 [compose 键](https://en.wikipedia.org/wiki/Compose_key) 功能添加到 Windows。 它可以通过 GitHub 上的 [WinCompose releases](https://github.com/samhocevar/wincompose/releases) 页面安装，也可以通过 [Chocolatey 包管理器]安装(https://chocolatey.org/packages/wincompose)。

[WinCompose](https://github.com/samhocevar/wincompose) adds [compose key](https://en.wikipedia.org/wiki/Compose_key) functionality to Windows. It can be installed either via the [WinCompose releases](https://github.com/samhocevar/wincompose/releases)page on GitHub, or with the [Chocolatey package manager](https://chocolatey.org/packages/wincompose).

程序安装并运行后，右键单击托盘图标并选择 `Options → Composing → Behavior → Compose Key` 以设置所需的密钥。

Once the program is installed and running, right click the tray icon and select `Options → Composing → Behavior → Compose Key` to set your desired key.

WinCompose在 `Options → Composing → Sequences` 中有多个可供选择的源。 建议启用 `XCompose` 并禁用 `Xorg`，因为有一些操作符 `Xorg` 不提供序列，而 `Xorg` 也有与 `XCompose` 中存在的操作符序列冲突的序列。 右键单击托盘图标并选择 `Show Sequences` 即可查看序列。 如果希望添加自己的序列，可以通过在 `％USERPROFILE％` 中添加/修改 `.XCompose`，或在选项菜单中编辑用户定义的序列来实现。

WinCompose has multiple sources to choose from in `Options → Composing → Sequences`. It is recommended to enable `XCompose` and disable `Xorg`, as there are a handful of operators which `Xorg` does not provide sequences for, and `Xorg` also has sequences which conflict with operator sequences present in `XCompose`. Sequences can be viewed by right clicking the tray icon and selecting `Show Sequences`. If you wish to add your own sequences, you can do so by either adding/modifying `.XCompose` in `%USERPROFILE%`, or editing user-defined sequences in the options menu.

<a id="%E7%BC%96%E8%BE%91%E5%99%A8%E5%92%8C-shell--editors-and-shells"></a>
# 编辑器和 shell / Editors and shells

<a id="vim"></a>
## Vim

在[Vim](https://www.vim.org/) 中，首先按 `Ctrl-V`（也表示为 `^V`），然后按 `u` 和要输入的 Unicode 字符的十六进制值来输入 Unicode 字符（在插入模式下）。例如，希腊字母 λ（lambda）通过组合键输入：

In [Vim](https://www.vim.org/), unicode characters are entered (in insert-mode) by pressing first `Ctrl-V` (also denoted `^V`), then `u` and then the hexadecimal value of the unicode character to be entered. For example, the Greek letter λ (lambda) is entered via the key combination:

```
^Vu03BB
```

你也可以使用 `Ctrl-K`/`^K` 和有向图输入一些字符。 因此，使用有向图的上述替代方法如下所示：

You can also use `Ctrl-K`/`^K` along with a digraph to type in some characters. So an alternative to the above using digraphs looks like this:

```
^Kl*
```

Vim 提供的有向图列表记录在[这里](http://vimdoc.sourceforge.net/htmldoc/digraph.html); 你可以使用 `:digraph` 命令添加自己的。

The list of digraphs Vim provides is documented [here](http://vimdoc.sourceforge.net/htmldoc/digraph.html); you can add your own with the `:digraph` command.

有关在 Vim 中输入特殊字符的更多信息可以在 Vim Wikia 页面上可以找到[输入特殊字符](http://vim.wikia.com/wiki/Entering_special_characters)。

Further information about entering special characters in Vim can be found on the Vim Wikia page about [entering special characters](http://vim.wikia.com/wiki/Entering_special_characters).

<a id="vim-perl6"></a>
### vim-perl6

Vim 的 [vim-perl6](https://github.com/vim-perl/vim-perl6) 插件可以配置为可选地将基于 ASCII 的操作替换为基于 Unicode 的等效操作。 这将在键入时动态转换基于 ASCII 的操作。

The [vim-perl6](https://github.com/vim-perl/vim-perl6) plugin for Vim can be configured to optionally replace ASCII based ops with their Unicode based equivalents. This will convert the ASCII based ops on the fly while typing them.

<a id="emacs"></a>
## Emacs

在 [Emacs](https://www.gnu.org/software/emacs/) 中，首先输入 `C-x 8 RET` 输入unicode字符，此时出现文本 `Unicode（名字或十六进制值）:` 在迷你缓冲区。 然后输入 Unicode 代码点十六进制数字，然后输入回车键。 unicode字符现在将出现在文档中。 因此，要输入希腊字母λ（lambda），可以使用以下组合键：

In [Emacs](https://www.gnu.org/software/emacs/), unicode characters are entered by first entering the chord `C-x 8 RET` at which point the text `Unicode (name or hex):` appears in the minibuffer. One then enters the unicode code point hexadecimal number followed by the enter key. The unicode character will now appear in the document. Thus, to enter the Greek letter λ (lambda), one uses the following key combination:

```
C-x 8 RET 3bb RET
```

有关 Unicode 及其进入 Emacs 的更多信息，请参见 [Unicode Encoding Emacs wiki页面](https://www.emacswiki.org/emacs/UnicodeEncoding)。

Further information about unicode and its entry into Emacs can be found on the [Unicode Encoding Emacs wiki page](https://www.emacswiki.org/emacs/UnicodeEncoding).

还可以通过键入以下内容来使用 [RFC 1345](https://tools.ietf.org/html/rfc1345) 字符助记符：

You can also use [RFC 1345](https://tools.ietf.org/html/rfc1345) character mnemonics by typing:

```
C-x RET C-\ rfc1345 RET
```

或者输入 `C-u C-\ rfc1345 RET`。

Or `C-u C-\ rfc1345 RET`.

要键入特殊字符，请键入 `&`，然后键入助记符。 Emacs将在回显区域显示可能的字符。 例如，可以通过键入以下内容输入希腊字母 λ（lambda）：

To type special characters, type `&` followed by a mnemonic. Emacs will show the possible characters in the echo area. For example, Greek letter λ (lambda) can be entered by typing:

```
&l*
```

可以使用 `C-\` 来切换[输入法](https://www.gnu.org/software/emacs/manual/html_node/emacs/Select-Input-Method.html)。

You can use `C-\` to toggle [input method](https://www.gnu.org/software/emacs/manual/html_node/emacs/Select-Input-Method.html).

可以使用的另一个[输入法](https://www.emacswiki.org/emacs/InputMethods)插入特殊字符是 [TeX](https://www.emacswiki.org/emacs/TeXInputMethod)。 通过键入 `C-u C-\ TeX RET` 来选择它。 你可以使用诸如 `\` 之类的前缀输入特殊字符。 例如，要输入 λ，请键入：

Another [input method](https://www.emacswiki.org/emacs/InputMethods) you can use to insert special characters is [TeX](https://www.emacswiki.org/emacs/TeXInputMethod). Select it by typing `C-u C-\ TeX RET`. You can enter a special character by using a prefix such as `\`. For example, to enter λ, type:

```
\lambda
```

要查看输入方法提供的字符和序列，请运行 `describe-input-method` 命令：

To view characters and sequences provided by an input method, run the `describe-input-method` command:

```
C-h I TeX
```

<a id="unix-shell"></a>
## Unix shell

在 bash shell 中，使用输入 `Ctrl-Shift-u` 输入 Unicode 字符，然后输入 Unicode 代码点值。 例如，要输入元素运算符（∈）的字符，请使用以下键组合（为清晰起见，添加了空格）：

At the bash shell, one enters unicode characters by using entering `Ctrl-Shift-u`, then the unicode code point value followed by enter. For instance, to enter the character for the element-of operator (∈) use the following key combination (whitespace has been added for clarity):

```
Ctrl-Shift-u 2208 Enter
```

这也是用于将 Unicode 字符输入到 `perl6` REPL 中的方法，如果已经在 Unix shell 中启动了 REPL。

This also the method one would use to enter unicode characters into the `perl6` REPL, if one has started the REPL inside a Unix shell.

<a id="screen"></a>
## Screen

[GNU Screen](https://www.gnu.org/software/screen/) 确实运行了 **digraph** 命令，但有一个相当有限的有向图表。 感谢 **bindkey** 和 **exec**，可以使用外部程序将字符插入当前屏幕窗口。

[GNU Screen](https://www.gnu.org/software/screen/) does sport a **digraph** command but with a rather limited digraph table. Thanks to **bindkey** and **exec** an external program can be used to insert characters to the current screen window.

```
bindkey ^K exec .! digraphs
```

这会将 control-k 绑定到 shell 命令 digraphs。 如果你更中意对 Perl 6 友好的有向图表
如果你喜欢[RFC 1345]（https://tools.ietf.org/html/rfc1345）上的Perl 6友好有向图表或更改，你可以使用[digraphs]（https://github.com/gfldex/digraphs） 它符合你的需求。

This will bind control-k to the shell command digraphs. You can use [digraphs](https://github.com/gfldex/digraphs) if you prefer a Perl 6 friendly digraph table over [RFC 1345](https://tools.ietf.org/html/rfc1345) or change it to your needs.

<a id="perl-6-%E4%B8%AD%E4%B8%80%E4%BA%9B%E6%9C%89%E7%94%A8%E7%9A%84%E5%AD%97%E7%AC%A6--some-characters-useful-in-perl-6"></a>
# Perl 6 中一些有用的字符 / Some characters useful in Perl 6

<a id="%E6%99%BA%E8%83%BD%E5%BC%95%E5%8F%B7--smart-quoteshttpsenwikipediaorgwikiquotationmarkcurved_quotes_andunicode"></a>
## 智能引号 / Smart quotes](https://en.wikipedia.org/wiki/Quotation_mark#Curved_quotes_and_Unicode)

这些字符在不同语言中用作引号。在 Perl 6 中，它们被用作[引用字符](https://rakudocs.github.io/language/quoting)

These characters are used in different languages as quotation marks. In Perl 6 they are used as [quoting characters](https://rakudocs.github.io/language/quoting)

这样的构造现在是可能的：

Constructs such as these are now possible:

```Perl6
say ｢What?!｣;
say ”Whoa!“;
say „This works too!”;
say „There are just too many ways“;
say “here: “no problem” at all!”; # You can nest them! 
```

这在 Shell 中非常有用：

This is very useful in shell:

```Perl6
perl6 -e 'say ‘hello world’'
```

因为你可以复制和粘贴一些代码，而不必担心引号。

since you can just copy and paste some piece of code and not worry about quotes.

<a id="%E4%B9%A6%E5%90%8D%E5%8F%B7--guillemetshttpsenwikipediaorgwikiguillemet"></a>
## 书名号 / Guillemets](https://en.wikipedia.org/wiki/Guillemet)

这些字符在法语和德语中用作引号。在 Perl 6 中，它们被用作[内插词引号](https://rakudocs.github.io/language/quoting#Word_quoting_with_interpolation_and_quote_protection%3A_qqww)、[hyper 运算符](https://rakudocs.github.io/language/operators#Hyper_operators)，以及 POD6 中尖角括号的另一种选择。

These characters are used in French and German as quotation marks. In Perl 6 they are used as [interpolation word quotes](https://rakudocs.github.io/language/quoting#Word_quoting_with_interpolation_and_quote_protection%3A_qqww), [hyper operators](https://rakudocs.github.io/language/operators#Hyper_operators) and as an angle bracket alternative in POD6.

| symbol | unicode code point | ascii equivalent |
| ------ | ------------------ | ---------------- |
| «      | U+00AB             | <<               |
| »      | U+00BB             | >>               |

因此，这样的构造现在是可能的：

Thus constructs such as these are now possible:

```Perl6
say (1, 2) »+« (3, 4);     # OUTPUT: «(4 6)␤» - element-wise add 
[1, 2, 3] »+=» 42;         # add 42 to each element of @array 
say «moo»;                 # OUTPUT: «moo␤» 
 
my $baa = "foo bar";
say «$baa $baa ber».perl;  # OUTPUT: «("foo", "bar", "foo", "bar", "ber")␤» 
```

<a id="setbag-%E6%93%8D%E4%BD%9C%E7%AC%A6--setbag-operators"></a>
## set/bag 操作符 / Set/bag operators

[set/bag 操作符](https://rakudocs.github.io/language/setbagmix#Set%252FBag_operators)都设置了与集合论相关的符号，下面列出了 Unicode 代码点及其 ASCII 等价物。要输入这样一个字符，只需输入组合字符（例如，Vim 中的 `Ctrl-V u`；Bash 中的 `Ctrl-Shift-u`），然后输入十六进制的 Unicode 代码点。

The [set/bag operators](https://rakudocs.github.io/language/setbagmix#Set%252FBag_operators) all have set-theory-related symbols, the unicode code points and their ascii equivalents are listed below. To compose such a character, it is merely necessary to enter the character composition chord (e.g. `Ctrl-V u` in Vim; `Ctrl-Shift-u` in Bash) then the unicode code point hexadecimal number.

| operator | unicode code point | ascii equivalent |
| -------- | ------------------ | ---------------- |
| ∈        | U+2208             | (elem)           |
| ∉        | U+2209             | !(elem)          |
| ∋        | U+220B             | (cont)           |
| ∌        | U+220C             | !(cont)          |
| ∖        | U+2216             | (-)              |
| ∩        | U+2229             | (&)              |
| ∪        | U+222A             | (\|)             |
| ⊂        | U+2282             | (<)              |
| ⊃        | U+2283             | (>)              |
| ⊄        | U+2284             | !(<)             |
| ⊅        | U+2285             | !(>)             |
| ⊆        | U+2286             | (<=)             |
| ⊇        | U+2287             | (>=)             |
| ⊈        | U+2288             | !(<=)            |
| ⊉        | U+2289             | !(>=)            |
| ⊍        | U+228D             | (.)              |
| ⊎        | U+228E             | (+)              |
| ⊖        | U+2296             | (^)              |

<a id="%E6%95%B0%E5%AD%A6%E7%AC%A6%E5%8F%B7--mathematical-symbols"></a>
## 数学符号 / Mathematical symbols

维基百科包含一个完整的列表 [数学运算符和 Unicode 符号](https://en.wikipedia.org/wiki/Mathematical_operators_and_symbols_in_Unicode)以及指向它们数学意义的链接。

Wikipedia contains a full list of [mathematical operators and symbols in unicode](https://en.wikipedia.org/wiki/Mathematical_operators_and_symbols_in_Unicode) as well as links to their mathematical meaning.

<a id="%E5%B8%8C%E8%85%8A%E5%AD%97%E7%AC%A6--greek-characters"></a>
## 希腊字符 / Greek characters

希腊字符可以用作变量名。有关希腊和科普特字符及其 Unicode 代码点的列表，请参阅[Unicode中的希腊语维基百科文章]（https://en.wikipedia.org/wiki/Greek_Alphabet希腊语Unicode中的希腊语）。

Greek characters may be used as variable names. For a list of Greek and Coptic characters and their unicode code points see the [Greek in Unicode Wikipedia article](https://en.wikipedia.org/wiki/Greek_alphabet#Greek_in_Unicode).

For example, to assign the value 3 to π, enter the following in Vim (whitespace added to the compose sequences for clarity):

```Perl6
my $Ctrl-V u 03C0 = 3;  # same as: my $π = 3;
say $Ctrl-V u 03C0;     # 3    same as: say $π;
```

<a id="%E4%B8%8A%E6%A0%87%E5%92%8C%E4%B8%8B%E6%A0%87--superscripts-and-subscripts"></a>
## 上标和下标 / Superscripts and subscripts

通过使用 `U+207x`、`U+208x` 和 `U+209x` 范围（不太常见），可以使用 Unicode 直接创建一组有限的[上标和下标](https://en.wikipedia.org/wiki/Superscripts_and_Subscripts)。但是，要生成平方值（2 的幂）或立方值（3 的幂），需要使用 `U+00B2` 和 `U+00B3`，因为这些是在 [Latin1 Supplement Unicode 块](https://en.wikipedia.org/wiki/Latin-1_Supplement_(Unicode_block))中定义的。

A limited set of [superscripts and subscripts](https://en.wikipedia.org/wiki/Superscripts_and_Subscripts) can be created directly in unicode by using the `U+207x`, `U+208x` and (less often) the `U+209x` ranges. However, to produce a value squared (to the power of 2) or cubed (to the power of 3), one needs to use `U+00B2` and `U+00B3` since these are defined in the [Latin1 supplement Unicode block](https://en.wikipedia.org/wiki/Latin-1_Supplement_(Unicode_block)).

因此，要在函数 `exp(x)` 的零附近编写 [Taylor Series](https://en.wikipedia.org/wiki/Taylor_series) 展开式，可以将以下内容输入到例如 vim 中：

Thus, to write the [Taylor series](https://en.wikipedia.org/wiki/Taylor_series) expansion around zero of the function `exp(x)` one would input into e.g. vim the following:

```Perl6
exp(x) = 1 + x + xCtrl-V u 00B2/2! + xCtrl-V u 00B3/3!
+ ... + xCtrl-V u 207F/n!
# which would appear as
exp(x) = 1 + x + x²/2! + x³/3! + ... + xⁿ/n!
```

或者指定列表中从 `1` 到 `k` 的元素：

Or to specify the elements in a list from `1` up to `k`:

```Perl6
ACtrl-V u 2081, ACtrl-V u 2082, ..., ACtrl-V u 2096
# which would appear as
A₁, A₂, ..., Aₖ
```