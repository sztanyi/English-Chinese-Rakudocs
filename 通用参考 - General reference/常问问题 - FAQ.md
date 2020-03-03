原文：https://docs.raku.org/language/faq

# 常问问题 / FAQ

关于 Raku 的常问问题

Frequently asked questions about Raku

<!-- MarkdownTOC -->

- [一般问题 / General](#%E4%B8%80%E8%88%AC%E9%97%AE%E9%A2%98--general)
    - [Raku、 Rakudo 和 Perl 6 的区别是什么? / What's the difference between Raku, Rakudo and Perl 6?](#raku%E3%80%81-rakudo-%E5%92%8C-perl-6-%E7%9A%84%E5%8C%BA%E5%88%AB%E6%98%AF%E4%BB%80%E4%B9%88--whats-the-difference-between-raku-rakudo-and-perl-6)
    - [Raku 是什么时候发布的？ / 发布时间 When was Raku released?](#raku-%E6%98%AF%E4%BB%80%E4%B9%88%E6%97%B6%E5%80%99%E5%8F%91%E5%B8%83%E7%9A%84%EF%BC%9F--%E5%8F%91%E5%B8%83%E6%97%B6%E9%97%B4-when-was-raku-released)
    - [是否有 Raku 版本 6.0.0？ / Is there a Raku version 6.0.0?](#%E6%98%AF%E5%90%A6%E6%9C%89-raku-%E7%89%88%E6%9C%AC-600%EF%BC%9F--is-there-a-raku-version-600)
    - [v6.d 是在什么时候发布的？ / When was v6.d released?](#v6d-%E6%98%AF%E5%9C%A8%E4%BB%80%E4%B9%88%E6%97%B6%E5%80%99%E5%8F%91%E5%B8%83%E7%9A%84%EF%BC%9F--when-was-v6d-released)
    - [作为一个 Raku 用户，我应该安装什么？ / As a Raku user, what should I install?](#%E4%BD%9C%E4%B8%BA%E4%B8%80%E4%B8%AA-raku-%E7%94%A8%E6%88%B7%EF%BC%8C%E6%88%91%E5%BA%94%E8%AF%A5%E5%AE%89%E8%A3%85%E4%BB%80%E4%B9%88%EF%BC%9F--as-a-raku-user-what-should-i-install)
    - [作为一个高级用户，我想跟踪 Rakudo 的发展。 / As an advanced user I want to track Rakudo development.](#%E4%BD%9C%E4%B8%BA%E4%B8%80%E4%B8%AA%E9%AB%98%E7%BA%A7%E7%94%A8%E6%88%B7%EF%BC%8C%E6%88%91%E6%83%B3%E8%B7%9F%E8%B8%AA-rakudo-%E7%9A%84%E5%8F%91%E5%B1%95%E3%80%82--as-an-advanced-user-i-want-to-track-rakudo-development)
    - [哪里可以找到有关 Raku 的好文档？ / Where can I find good documentation on Raku?](#%E5%93%AA%E9%87%8C%E5%8F%AF%E4%BB%A5%E6%89%BE%E5%88%B0%E6%9C%89%E5%85%B3-raku-%E7%9A%84%E5%A5%BD%E6%96%87%E6%A1%A3%EF%BC%9F--where-can-i-find-good-documentation-on-raku)
    - [我能买些关于 Raku 的书吗 / Can I get some books about Raku?](#%E6%88%91%E8%83%BD%E4%B9%B0%E4%BA%9B%E5%85%B3%E4%BA%8E-raku-%E7%9A%84%E4%B9%A6%E5%90%97--can-i-get-some-books-about-raku)
    - [Raku 的技术规范是什么？ / What is the Raku specification?](#raku-%E7%9A%84%E6%8A%80%E6%9C%AF%E8%A7%84%E8%8C%83%E6%98%AF%E4%BB%80%E4%B9%88%EF%BC%9F--what-is-the-raku-specification)
    - [Is there a glossary of Raku related terms? / 是否有与 Raku 相关的术语表？](#is-there-a-glossary-of-raku-related-terms--%E6%98%AF%E5%90%A6%E6%9C%89%E4%B8%8E-raku-%E7%9B%B8%E5%85%B3%E7%9A%84%E6%9C%AF%E8%AF%AD%E8%A1%A8%EF%BC%9F)
    - [我是 Perl 5 程序员。哪里有 Perl 5 与 Raku 的不同点的清单？ / I'm a Perl 5 programmer. Where is a list of differences between Perl 5 and Raku?](#%E6%88%91%E6%98%AF-perl-5-%E7%A8%8B%E5%BA%8F%E5%91%98%E3%80%82%E5%93%AA%E9%87%8C%E6%9C%89-perl-5-%E4%B8%8E-raku-%E7%9A%84%E4%B8%8D%E5%90%8C%E7%82%B9%E7%9A%84%E6%B8%85%E5%8D%95%EF%BC%9F--im-a-perl-5-programmer-where-is-a-list-of-differences-between-perl-5-and-raku)
    - [I'm a Ruby programmer looking for quickstart type docs? / 我是一个 Ruby 程序员在寻找快速启动类型的文档](#im-a-ruby-programmer-looking-for-quickstart-type-docs--%E6%88%91%E6%98%AF%E4%B8%80%E4%B8%AA-ruby-%E7%A8%8B%E5%BA%8F%E5%91%98%E5%9C%A8%E5%AF%BB%E6%89%BE%E5%BF%AB%E9%80%9F%E5%90%AF%E5%8A%A8%E7%B1%BB%E5%9E%8B%E7%9A%84%E6%96%87%E6%A1%A3)
- [模组 / Modules](#%E6%A8%A1%E7%BB%84--modules)
    - [是否有一个 CPAN（第三方库模块存储库）供 Raku 使用？ / Is there a CPAN \(repository of third party library modules\) for Raku?](#%E6%98%AF%E5%90%A6%E6%9C%89%E4%B8%80%E4%B8%AA-cpan%EF%BC%88%E7%AC%AC%E4%B8%89%E6%96%B9%E5%BA%93%E6%A8%A1%E5%9D%97%E5%AD%98%E5%82%A8%E5%BA%93%EF%BC%89%E4%BE%9B-raku-%E4%BD%BF%E7%94%A8%EF%BC%9F--is-there-a-cpan-repository-of-third-party-library-modules-for-raku)
    - [是否有用于 Raku 的 Perldoc（命令行文档查看器）？ / Is there a perldoc \(command line documentation viewer\) for Raku?](#%E6%98%AF%E5%90%A6%E6%9C%89%E7%94%A8%E4%BA%8E-raku-%E7%9A%84-perldoc%EF%BC%88%E5%91%BD%E4%BB%A4%E8%A1%8C%E6%96%87%E6%A1%A3%E6%9F%A5%E7%9C%8B%E5%99%A8%EF%BC%89%EF%BC%9F--is-there-a-perldoc-command-line-documentation-viewer-for-raku)
    - [我可以使用来自 Raku 的 Perl 5 模块吗？ / Can I use Perl 5 modules from Raku?](#%E6%88%91%E5%8F%AF%E4%BB%A5%E4%BD%BF%E7%94%A8%E6%9D%A5%E8%87%AA-raku-%E7%9A%84-perl-5-%E6%A8%A1%E5%9D%97%E5%90%97%EF%BC%9F--can-i-use-perl-5-modules-from-raku)
    - [我可以在 Raku 中使用 C 和 C++ 吗？ / Can I use C and C++ from Raku?](#%E6%88%91%E5%8F%AF%E4%BB%A5%E5%9C%A8-raku-%E4%B8%AD%E4%BD%BF%E7%94%A8-c-%E5%92%8C-c-%E5%90%97%EF%BC%9F--can-i-use-c-and-c-from-raku)
    - [nativecall 找不到 `libfoo.so`，而我只有 `libfoo.so.1.2`！ / Nativecall can't find `libfoo.so` and I only have `libfoo.so.1.2`!](#nativecall-%E6%89%BE%E4%B8%8D%E5%88%B0-libfooso%EF%BC%8C%E8%80%8C%E6%88%91%E5%8F%AA%E6%9C%89-libfooso12%EF%BC%81--nativecall-cant-find-libfooso-and-i-only-have-libfooso12)
    - [所有传统的 UNIX 库函数都去了哪里？ / Where have all the traditional UNIX library functions gone?](#%E6%89%80%E6%9C%89%E4%BC%A0%E7%BB%9F%E7%9A%84-unix-%E5%BA%93%E5%87%BD%E6%95%B0%E9%83%BD%E5%8E%BB%E4%BA%86%E5%93%AA%E9%87%8C%EF%BC%9F--where-have-all-the-traditional-unix-library-functions-gone)
    - [Rakudo 有核心标准库吗？ / Does Rakudo have a core standard library?](#rakudo-%E6%9C%89%E6%A0%B8%E5%BF%83%E6%A0%87%E5%87%86%E5%BA%93%E5%90%97%EF%BC%9F--does-rakudo-have-a-core-standard-library)
    - [是否有类似 `B::Deparse` 的东西/我怎样才能得到 AST？ / Is there something like `B::Deparse`/How can I get hold of the AST?](#%E6%98%AF%E5%90%A6%E6%9C%89%E7%B1%BB%E4%BC%BC-bdeparse-%E7%9A%84%E4%B8%9C%E8%A5%BF%E6%88%91%E6%80%8E%E6%A0%B7%E6%89%8D%E8%83%BD%E5%BE%97%E5%88%B0-ast%EF%BC%9F--is-there-something-like-bdeparsehow-can-i-get-hold-of-the-ast)
    - [什么是预编译？ / What is precompilation?](#%E4%BB%80%E4%B9%88%E6%98%AF%E9%A2%84%E7%BC%96%E8%AF%91%EF%BC%9F--what-is-precompilation)
    - [我能在模块之间有循环依赖关系吗？ / Can I have circular dependencies between modules?](#%E6%88%91%E8%83%BD%E5%9C%A8%E6%A8%A1%E5%9D%97%E4%B9%8B%E9%97%B4%E6%9C%89%E5%BE%AA%E7%8E%AF%E4%BE%9D%E8%B5%96%E5%85%B3%E7%B3%BB%E5%90%97%EF%BC%9F--can-i-have-circular-dependencies-between-modules)
- [语言特性 / Language features](#%E8%AF%AD%E8%A8%80%E7%89%B9%E6%80%A7--language-features)
    - [如何打印 Raku 数据结构（与 Perl5 的 Data::Dumper 或者其他模块类似） / How can I dump Raku data structures \(like Perl 5 Data::Dumper and similar\)?](#%E5%A6%82%E4%BD%95%E6%89%93%E5%8D%B0-raku-%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84%EF%BC%88%E4%B8%8E-perl5-%E7%9A%84-datadumper-%E6%88%96%E8%80%85%E5%85%B6%E4%BB%96%E6%A8%A1%E5%9D%97%E7%B1%BB%E4%BC%BC%EF%BC%89--how-can-i-dump-raku-data-structures-like-perl-5-datadumper-and-similar)
    - [如何在 Raku 提示符（REPL）中获取命令行历史记录？ / How can I get command line history in the Raku prompt \(REPL\)?](#%E5%A6%82%E4%BD%95%E5%9C%A8-raku-%E6%8F%90%E7%A4%BA%E7%AC%A6%EF%BC%88repl%EF%BC%89%E4%B8%AD%E8%8E%B7%E5%8F%96%E5%91%BD%E4%BB%A4%E8%A1%8C%E5%8E%86%E5%8F%B2%E8%AE%B0%E5%BD%95%EF%BC%9F--how-can-i-get-command-line-history-in-the-raku-prompt-repl)
    - [为什么 Rakudo 编译器如此多抱歉？ / Why is the Rakudo compiler so apologetic?](#%E4%B8%BA%E4%BB%80%E4%B9%88-rakudo-%E7%BC%96%E8%AF%91%E5%99%A8%E5%A6%82%E6%AD%A4%E5%A4%9A%E6%8A%B1%E6%AD%89%EF%BC%9F--why-is-the-rakudo-compiler-so-apologetic)
    - [什么是 `(Any)`？ / What is `(Any)`?](#%E4%BB%80%E4%B9%88%E6%98%AF-any%EF%BC%9F--what-is-any)
    - [`so` 是什么？ / What is `so`?](#so-%E6%98%AF%E4%BB%80%E4%B9%88%EF%BC%9F--what-is-so)
    - [在函数签名中的 `:D` 和 `:U` 是什么？ / What are those `:D` and `:U` things in signatures?](#%E5%9C%A8%E5%87%BD%E6%95%B0%E7%AD%BE%E5%90%8D%E4%B8%AD%E7%9A%84-d-%E5%92%8C-u-%E6%98%AF%E4%BB%80%E4%B9%88%EF%BC%9F--what-are-those-d-and-u-things-in-signatures)
    - [在函数签名中的 `-->` 是什么？ / What is the `-->` thing in the signature?](#%E5%9C%A8%E5%87%BD%E6%95%B0%E7%AD%BE%E5%90%8D%E4%B8%AD%E7%9A%84----%E6%98%AF%E4%BB%80%E4%B9%88%EF%BC%9F--what-is-the----thing-in-the-signature)
    - [我怎样才能从 Junction 中提取值？ / How can I extract the values from a Junction?](#%E6%88%91%E6%80%8E%E6%A0%B7%E6%89%8D%E8%83%BD%E4%BB%8E-junction-%E4%B8%AD%E6%8F%90%E5%8F%96%E5%80%BC%EF%BC%9F--how-can-i-extract-the-values-from-a-junction)
    - [如果 Str 是不可变的，`s///` 是怎样工作的？ 如果 Int 是不可变的，`$i++` 是怎样工作的？ / If Str is immutable, how does `s///` work? If Int is immutable, how does `$i++` work?](#%E5%A6%82%E6%9E%9C-str-%E6%98%AF%E4%B8%8D%E5%8F%AF%E5%8F%98%E7%9A%84%EF%BC%8Cs-%E6%98%AF%E6%80%8E%E6%A0%B7%E5%B7%A5%E4%BD%9C%E7%9A%84%EF%BC%9F-%E5%A6%82%E6%9E%9C-int-%E6%98%AF%E4%B8%8D%E5%8F%AF%E5%8F%98%E7%9A%84%EF%BC%8C%24i-%E6%98%AF%E6%80%8E%E6%A0%B7%E5%B7%A5%E4%BD%9C%E7%9A%84%EF%BC%9F--if-str-is-immutable-how-does-s-work-if-int-is-immutable-how-does-%24i-work)
    - [数组引用和自动取消引用是怎么回事？ 我需要 `@` 标记吗？ / What's up with array references and automatic dereferencing? Do I need the `@` sigil?](#%E6%95%B0%E7%BB%84%E5%BC%95%E7%94%A8%E5%92%8C%E8%87%AA%E5%8A%A8%E5%8F%96%E6%B6%88%E5%BC%95%E7%94%A8%E6%98%AF%E6%80%8E%E4%B9%88%E5%9B%9E%E4%BA%8B%EF%BC%9F-%E6%88%91%E9%9C%80%E8%A6%81--%E6%A0%87%E8%AE%B0%E5%90%97%EF%BC%9F--whats-up-with-array-references-and-automatic-dereferencing-do-i-need-the--sigil)
    - [为什么要用标记符？ 你不能没有他们吗？ / Why sigils? Couldn't you do without them?](#%E4%B8%BA%E4%BB%80%E4%B9%88%E8%A6%81%E7%94%A8%E6%A0%87%E8%AE%B0%E7%AC%A6%EF%BC%9F-%E4%BD%A0%E4%B8%8D%E8%83%BD%E6%B2%A1%E6%9C%89%E4%BB%96%E4%BB%AC%E5%90%97%EF%BC%9F--why-sigils-couldnt-you-do-without-them)
    - [“类型 Str 不支持关联索引。” / "Type Str does not support associative indexing."](#%E2%80%9C%E7%B1%BB%E5%9E%8B-str-%E4%B8%8D%E6%94%AF%E6%8C%81%E5%85%B3%E8%81%94%E7%B4%A2%E5%BC%95%E3%80%82%E2%80%9D--type-str-does-not-support-associative-indexing)
    - [Raku 有协程吗？ 那 `yield` 呢？ / Does Raku have coroutines? What about `yield`?](#raku-%E6%9C%89%E5%8D%8F%E7%A8%8B%E5%90%97%EF%BC%9F-%E9%82%A3-yield-%E5%91%A2%EF%BC%9F--does-raku-have-coroutines-what-about-yield)
    - [为什么不能通过新方法初始化私有属性，如何解决此问题？ / Why can't I initialize private attributes from the new method, and how can I fix this?](#%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E8%83%BD%E9%80%9A%E8%BF%87%E6%96%B0%E6%96%B9%E6%B3%95%E5%88%9D%E5%A7%8B%E5%8C%96%E7%A7%81%E6%9C%89%E5%B1%9E%E6%80%A7%EF%BC%8C%E5%A6%82%E4%BD%95%E8%A7%A3%E5%86%B3%E6%AD%A4%E9%97%AE%E9%A2%98%EF%BC%9F--why-cant-i-initialize-private-attributes-from-the-new-method-and-how-can-i-fix-this)
    - [`say`、 `put` 和 `print` 有何区别？ / How and why do `say`, `put` and `print` differ?](#say%E3%80%81-put-%E5%92%8C-print-%E6%9C%89%E4%BD%95%E5%8C%BA%E5%88%AB%EF%BC%9F--how-and-why-do-say-put-and-print-differ)
    - [`token` 和 `rule` 的区别是什么？ / What's the difference between `token` and `rule` ?](#token-%E5%92%8C-rule-%E7%9A%84%E5%8C%BA%E5%88%AB%E6%98%AF%E4%BB%80%E4%B9%88%EF%BC%9F--whats-the-difference-between-token-and-rule-)
    - [`die` 和 `fail` 有什么区别？ / What's the difference between `die` and `fail`?](#die-%E5%92%8C-fail-%E6%9C%89%E4%BB%80%E4%B9%88%E5%8C%BA%E5%88%AB%EF%BC%9F--whats-the-difference-between-die-and-fail)
    - [`Pointer` 和 `OpaquePointer` 有什么区别？ / What's the difference between `Pointer` and `OpaquePointer`?](#pointer-%E5%92%8C-opaquepointer-%E6%9C%89%E4%BB%80%E4%B9%88%E5%8C%BA%E5%88%AB%EF%BC%9F--whats-the-difference-between-pointer-and-opaquepointer)
    - [您可以在标识符中有冒号对。理由是什么？ / You can have colonpairs in identifiers. What's the justification?](#%E6%82%A8%E5%8F%AF%E4%BB%A5%E5%9C%A8%E6%A0%87%E8%AF%86%E7%AC%A6%E4%B8%AD%E6%9C%89%E5%86%92%E5%8F%B7%E5%AF%B9%E3%80%82%E7%90%86%E7%94%B1%E6%98%AF%E4%BB%80%E4%B9%88%EF%BC%9F--you-can-have-colonpairs-in-identifiers-whats-the-justification)
    - [大多数人是如何输入 Unicode 字符的？ / How do most people enter unicode characters?](#%E5%A4%A7%E5%A4%9A%E6%95%B0%E4%BA%BA%E6%98%AF%E5%A6%82%E4%BD%95%E8%BE%93%E5%85%A5-unicode-%E5%AD%97%E7%AC%A6%E7%9A%84%EF%BC%9F--how-do-most-people-enter-unicode-characters)
- [Raku 实现 / Raku implementation](#raku-%E5%AE%9E%E7%8E%B0--raku-implementation)
    - [有哪些 Raku 实现可用？ / What Raku implementations are available?](#%E6%9C%89%E5%93%AA%E4%BA%9B-raku-%E5%AE%9E%E7%8E%B0%E5%8F%AF%E7%94%A8%EF%BC%9F--what-raku-implementations-are-available)
    - [Rakudo 用什么语言写的？ / What language is Rakudo written in?](#rakudo-%E7%94%A8%E4%BB%80%E4%B9%88%E8%AF%AD%E8%A8%80%E5%86%99%E7%9A%84%EF%BC%9F--what-language-is-rakudo-written-in)
    - [NQP 是用什么语言写的？ / What language is NQP written in?](#nqp-%E6%98%AF%E7%94%A8%E4%BB%80%E4%B9%88%E8%AF%AD%E8%A8%80%E5%86%99%E7%9A%84%EF%BC%9F--what-language-is-nqp-written-in)
    - [Raku 是 Lisp 吗？ / Is Raku Lisp?](#raku-%E6%98%AF-lisp-%E5%90%97%EF%BC%9F--is-raku-lisp)
    - [我能把我的脚本编译成一个独立的可执行文件吗？ / Can I compile my script to a standalone executable?](#%E6%88%91%E8%83%BD%E6%8A%8A%E6%88%91%E7%9A%84%E8%84%9A%E6%9C%AC%E7%BC%96%E8%AF%91%E6%88%90%E4%B8%80%E4%B8%AA%E7%8B%AC%E7%AB%8B%E7%9A%84%E5%8F%AF%E6%89%A7%E8%A1%8C%E6%96%87%E4%BB%B6%E5%90%97%EF%BC%9F--can-i-compile-my-script-to-a-standalone-executable)
- [Raku 发布 / Raku distribution](#raku-%E5%8F%91%E5%B8%83--raku-distribution)
    - [下一个版本的 Rakudo Star 什么时候发布？ / When will the next version of Rakudo Star be released?](#%E4%B8%8B%E4%B8%80%E4%B8%AA%E7%89%88%E6%9C%AC%E7%9A%84-rakudo-star-%E4%BB%80%E4%B9%88%E6%97%B6%E5%80%99%E5%8F%91%E5%B8%83%EF%BC%9F--when-will-the-next-version-of-rakudo-star-be-released)
- [元问题和宣传 / Metaquestions and advocacy](#%E5%85%83%E9%97%AE%E9%A2%98%E5%92%8C%E5%AE%A3%E4%BC%A0--metaquestions-and-advocacy)
    - [为什么 Raku 最初被称为 Perl 6？ / Why was Raku originally called Perl 6?](#%E4%B8%BA%E4%BB%80%E4%B9%88-raku-%E6%9C%80%E5%88%9D%E8%A2%AB%E7%A7%B0%E4%B8%BA-perl-6%EF%BC%9F--why-was-raku-originally-called-perl-6)
    - [Raku 什么时候准备好？现在准备好了吗？ / When will Raku be ready? Is it ready now?](#raku-%E4%BB%80%E4%B9%88%E6%97%B6%E5%80%99%E5%87%86%E5%A4%87%E5%A5%BD%EF%BC%9F%E7%8E%B0%E5%9C%A8%E5%87%86%E5%A4%87%E5%A5%BD%E4%BA%86%E5%90%97%EF%BC%9F--when-will-raku-be-ready-is-it-ready-now)
    - [我为什么要学 Raku？它有什么好的？ / Why should I learn Raku? What's so great about it?](#%E6%88%91%E4%B8%BA%E4%BB%80%E4%B9%88%E8%A6%81%E5%AD%A6-raku%EF%BC%9F%E5%AE%83%E6%9C%89%E4%BB%80%E4%B9%88%E5%A5%BD%E7%9A%84%EF%BC%9F--why-should-i-learn-raku-whats-so-great-about-it)
    - [Raku 对我来说够快吗？ / Is Raku fast enough for me?](#raku-%E5%AF%B9%E6%88%91%E6%9D%A5%E8%AF%B4%E5%A4%9F%E5%BF%AB%E5%90%97%EF%BC%9F--is-raku-fast-enough-for-me)

<!-- /MarkdownTOC -->


<a id="%E4%B8%80%E8%88%AC%E9%97%AE%E9%A2%98--general"></a>
# 一般问题 / General

<a id="raku%E3%80%81-rakudo-%E5%92%8C-perl-6-%E7%9A%84%E5%8C%BA%E5%88%AB%E6%98%AF%E4%BB%80%E4%B9%88--whats-the-difference-between-raku-rakudo-and-perl-6"></a>
## Raku、 Rakudo 和 Perl 6 的区别是什么? / What's the difference between Raku, Rakudo and Perl 6?

正确地说，[Rakudo](https://rakudo.org/) 是 Raku 的一种实现.它是目前正在开发的，但是过去已经有了其他的实现，将来可能还会有其他的实现。Raku 是语言的定义。在谈论当前的解释器时，Rakudo 和 Raku 可以互换使用。“Perl6” 是 2019 年 10 月前用于 “Raku” 的名称。

Properly speaking, [Rakudo](https://rakudo.org/) is an implementation of Raku. It's currently the one that's being developed, but there have been other implementations in the past and there will likely be others in the future. Raku is the definition of the language. When talking about the current interpreter, Rakudo and Raku can be used interchangeably. "Perl 6" is the name that was used for "Raku" before October 2019.

<a id="raku-%E6%98%AF%E4%BB%80%E4%B9%88%E6%97%B6%E5%80%99%E5%8F%91%E5%B8%83%E7%9A%84%EF%BC%9F--%E5%8F%91%E5%B8%83%E6%97%B6%E9%97%B4-when-was-raku-released"></a>
## Raku 是什么时候发布的？ / 发布时间 When was Raku released?

Rakudo 2015.12 实现版本于 2015 年 12 月 25 日发布。

The Rakudo 2015.12 implementation version was released on December 25th 2015.

<a id="%E6%98%AF%E5%90%A6%E6%9C%89-raku-%E7%89%88%E6%9C%AC-600%EF%BC%9F--is-there-a-raku-version-600"></a>
## 是否有 Raku 版本 6.0.0？ / Is there a Raku version 6.0.0?

没有。第一个稳定的语言规范版本是 v6.c（“Christmas”）。语言规范的未来版本可能有小版本（例如，v6.d.2）或主版本（例如，v6.e）。

No. The first stable language specification version is v6.c ("Christmas"). Future versions of the spec may have point releases (e.g., v6.d.2) or major releases (e.g., v6.e).

运行 `perl6 -v` 将显示编译器实现的语言版本：

Running `perl6 -v` will display the language version your compiler implements:

```Raku
$ perl6 -v
This is Rakudo version 2017.07 built on MoarVM version 2017.07
implementing Raku.c.
```

<a id="v6d-%E6%98%AF%E5%9C%A8%E4%BB%80%E4%B9%88%E6%97%B6%E5%80%99%E5%8F%91%E5%B8%83%E7%9A%84%EF%BC%9F--when-was-v6d-released"></a>
## v6.d 是在什么时候发布的？ / When was v6.d released?

该 v6.d 规范是在[排灯节 2018](https://en.wikipedia.org/wiki/Diwali)上发布的，这是 2018 年 11 月 6 日至 7 日，在一个方便的时区。在 2018.11 的 Rakudo 编译器版本中默认启用了 6.d。

The v6.d Specification was released on [Diwali 2018](https://en.wikipedia.org/wiki/Diwali), which was November 6–7 2018, in a convenient time zone. 6.d was enabled by default in the Rakudo compiler release of 2018.11.

绝大多数的 6.d 功能已经在 Rakudo 编译器中实现并可用，而不需要任何特殊的杂种，因为它们与 6.c 规范不冲突。如果文件顶部有 `use v6.d` 指令，则自动提供一小组的功能和行为。其余的大约 3100 个新提交的语言规范只是澄清以前未定义的行为。

The vast majority of 6.d features were already implemented and available in the Rakudo compiler without requiring any special pragmas, as they did not conflict with the 6.c specification. A smaller set of features and behaviors is available automatically if you have the `use v6.d` pragma at the top of the file. The rest of about 3100 new commits to the language specification simply clarify previously undefined behavior.

<a id="%E4%BD%9C%E4%B8%BA%E4%B8%80%E4%B8%AA-raku-%E7%94%A8%E6%88%B7%EF%BC%8C%E6%88%91%E5%BA%94%E8%AF%A5%E5%AE%89%E8%A3%85%E4%BB%80%E4%B9%88%EF%BC%9F--as-a-raku-user-what-should-i-install"></a>
## 作为一个 Raku 用户，我应该安装什么？ / As a Raku user, what should I install?

Mac 用户可以从 <https://rakudo.org/downloads/star> 下载使用在最新的 Rakudo Star DMG 二进制安装器

Mac users can use the latest Rakudo Star DMG binary installer at <https://rakudo.org/downloads/star>

Windows 用户可以使用 Rakudo Star MSI 二进制安装程序.您将需要 Windows Git 和 Strawberry Perl 5 使用 zef 安装库模块。

Windows users can use the Rakudo Star MSI binary installer. You will need Windows Git and Strawberry Perl 5 to use zef to install library modules.

Linux 用户可能想下载 Rakudo Star，并按照在 <https://www.raku.org/downloads/> 的编译说明操作。

Linux users probably want to download Rakudo Star and follow the compilation instructions at <https://www.raku.org/downloads/>.

应该有 Linux 和 Mac 二进制文件可以从供应商和第三方获得，尽管供应商版本可能已经过时。应避免 2015.12 Rakudo 之前发布的版本。

There should be Linux and Mac binaries available from vendors and third parties, although vendor versions may be outdated. Versions before Rakudo release of 2015.12 should be avoided.

官方 Rakudo Star docker镜像在 <https://hub.docker.com/_/rakudo-star/>

There's an official Rakudo Star docker image at <https://hub.docker.com/_/rakudo-star/>

<a id="%E4%BD%9C%E4%B8%BA%E4%B8%80%E4%B8%AA%E9%AB%98%E7%BA%A7%E7%94%A8%E6%88%B7%EF%BC%8C%E6%88%91%E6%83%B3%E8%B7%9F%E8%B8%AA-rakudo-%E7%9A%84%E5%8F%91%E5%B1%95%E3%80%82--as-an-advanced-user-i-want-to-track-rakudo-development"></a>
## 作为一个高级用户，我想跟踪 Rakudo 的发展。 / As an advanced user I want to track Rakudo development.

一种选择是克隆[存储库](https://github.com/rakudo/rakudo)并构建它。这将安装正在进行的工作，这是最小的测试，并可能包含严重的错误。如果您有兴趣为 Rakudo Raku 编译器做贡献，您可能会发现 [Z-Script 帮助工具](https://github.com/zoffixznet/z)很有用。

An option is to clone [the repository](https://github.com/rakudo/rakudo) and build it. This will install work in progress which is minimally-tested and may contain severe bugs. If you're interested in contributing to the Rakudo Raku compiler, you may find the [Z-Script helper tool](https://github.com/zoffixznet/z) useful.

若要安装最后一个正式的每月版本，请查看在 <https://raw.githubusercontent.com/rakudo/rakudo/master/VERSION> 的标记或设置[助手命令](https://github.com/zoffixznet/r#table-of-contents)。

To install the last official monthly release, check out the tag visible at <https://raw.githubusercontent.com/rakudo/rakudo/master/VERSION> or set up [a helper command](https://github.com/zoffixznet/r#table-of-contents).

一些用户选择使用 [rakudobrew](https://github.com/tadzik/rakudobrew)，它允许安装多个版本的 rakudo。一定要[阅读它的文档](https://github.com/tadzik/rakudobrew#making-new-scripts-available)。

Some users choose to use [rakudobrew](https://github.com/tadzik/rakudobrew), which allows installation of multiple versions of rakudo. Be sure to [read its documentation](https://github.com/tadzik/rakudobrew#making-new-scripts-available).

在这两种情况下，您可能还需要从[生态系统](https://modules.raku.org/) 中安装 [`zef`](https://modules.raku.org/dist/zef:github) 和 [`p6doc`](https://modules.raku.org/dist/p6doc:github)。

In either case you will probably need to also install [`zef`](https://modules.raku.org/dist/zef:github) and [`p6doc`](https://modules.raku.org/dist/p6doc:github) from the [ecosystem](https://modules.raku.org/).

<a id="%E5%93%AA%E9%87%8C%E5%8F%AF%E4%BB%A5%E6%89%BE%E5%88%B0%E6%9C%89%E5%85%B3-raku-%E7%9A%84%E5%A5%BD%E6%96%87%E6%A1%A3%EF%BC%9F--where-can-i-find-good-documentation-on-raku"></a>
## 哪里可以找到有关 Raku 的好文档？ / Where can I find good documentation on Raku?

请参阅[官方文献网站](https://docs.raku.org/)（特别是其[“语言”部分](https://docs.raku.org/language)）以及[参考资料页](https://raku.org/resources/)。你也可以参考这个[备忘单]（https://htmlpreview.github.io/?https://github.com/perl6/mu/blob/master/docs/Perl6/Cheatsheet/cheatsheet.html）.

See [the official documentation website](https://docs.raku.org/) (especially its ["Language" section](https://docs.raku.org/language)) as well as the [Resources page](https://raku.org/resources/). You can also consult this [great cheatsheet](https://htmlpreview.github.io/?https://github.com/perl6/mu/blob/master/docs/Perl6/Cheatsheet/cheatsheet.html).

[perl6book.com](https://perl6book.com/) 包含电子书的列表。

[perl6book.com](https://perl6book.com/) contains a list of dead tree and electronic books.

阅读第三方文章时要注意出版日期。在 2015 年 12 月之前发表的任何东西都可能描述了 Raku 的预发布版。

Be mindful of publication dates when reading third-party articles. Anything published before December, 2015 likely describes a pre-release version of Raku.

你总是可以[在我们的帮助聊天中从一个活人那里得到帮助](https://webchat.freenode.net/?channels=#raku)或[搜索聊天日志](https://colabti.org/irclogger/irclogger_log_search/raku)找到以前的对话和讨论。

You can always [get help from a live human in our help chat](https://webchat.freenode.net/?channels=#raku) or [search the chat logs](https://colabti.org/irclogger/irclogger_log_search/raku) to find previous conversations and discussions.

<a id="%E6%88%91%E8%83%BD%E4%B9%B0%E4%BA%9B%E5%85%B3%E4%BA%8E-raku-%E7%9A%84%E4%B9%A6%E5%90%97--can-i-get-some-books-about-raku"></a>
## 我能买些关于 Raku 的书吗 / Can I get some books about Raku?

这里有一些书，按字母顺序排列：

Here are some available books, in alphabetical order:

- [Learning Raku](https://www.learningperl6.com/), by brian d foy
- [Learning to program with Raku: First Steps](https://www.amazon.com/gp/product/B07221XCVL), by JJ Merelo
- [Metagenomics](https://www.gitbook.com/book/kyclark/metagenomics/details), by Ken Youens-Clark
- [Parsing with Perl 6 Regexes and Grammars](https://smile.amazon.com/dp/1484232275/), by Moritz Lenz
- [Perl 6 at a Glance](https://deeptext.media/perl6-at-a-glance/), by Andrew Shitov
- [Perl 6 Fundamentals](https://www.apress.com/us/book/9781484228982), by Moritz Lenz
- [Perl 6 Deep Dive](https://www.packtpub.com/application-development/perl-6-deep-dive), by Andrew Shitov
- [Think Perl 6: How to Think Like a Computer Scientist](https://greenteapress.com/wp/think-perl-6/), by Laurent Rosenfeld.

已出版或正在出版的书籍清单载于 [`raku.org`](https://raku.org/resources/)。

A list of books published or in progress is maintained in [`raku.org`](https://raku.org/resources/).

<a id="raku-%E7%9A%84%E6%8A%80%E6%9C%AF%E8%A7%84%E8%8C%83%E6%98%AF%E4%BB%80%E4%B9%88%EF%BC%9F--what-is-the-raku-specification"></a>
## Raku 的技术规范是什么？ / What is the Raku specification?

规范中指的是 Raku 的官方测试套件。它被称为 [`roast`](https://github.com/perl6/roast)，并在 GitHub 上托管。任何通过测试的编译器都被认为实现了那个版本的 Raku 规范。

The specification refers to the official test suite for Raku. It's called [`roast`](https://github.com/perl6/roast) and is hosted on github. Any compiler that passes the tests is deemed to implement that version of the Raku specification.

Roast 的 `master` 分支与最新的发展相对应，这还不一定是任何规范的一部分。其他分支对应于特定的版本；例如，“6.c-errata”。

Roast's `master` branch corresponds to the latest development that isn't necessarily part of any specification yet. Other branches correspond to specific versions; for example, "6.c-errata".

因此，`6.c-errata` 是一个已发布的语言版本，除了修复测试中的错误（“errata”）外，我们不会更改，而 master 是未发布的正在进行的工作，可能成为下一个语言版本。它目前的状态不一定是下一个语言版本的行为的规定，因为新的添加将被审查，以纳入版本。

So `6.c-errata` is a released language version we don't change other than to fix errors in tests (the "errata") whereas master is the unreleased work-in-progress that may become the next language version. Its current state is not necessarily prescriptive of the next language version's behavior since new additions will be reviewed for inclusion into the release.

<a id="is-there-a-glossary-of-raku-related-terms--%E6%98%AF%E5%90%A6%E6%9C%89%E4%B8%8E-raku-%E7%9B%B8%E5%85%B3%E7%9A%84%E6%9C%AF%E8%AF%AD%E8%A1%A8%EF%BC%9F"></a>
## Is there a glossary of Raku related terms? / 是否有与 Raku 相关的术语表？

有，见 [glossary](https://docs.raku.org/language/glossary)。

Yes, see [glossary](https://docs.raku.org/language/glossary).

<a id="%E6%88%91%E6%98%AF-perl-5-%E7%A8%8B%E5%BA%8F%E5%91%98%E3%80%82%E5%93%AA%E9%87%8C%E6%9C%89-perl-5-%E4%B8%8E-raku-%E7%9A%84%E4%B8%8D%E5%90%8C%E7%82%B9%E7%9A%84%E6%B8%85%E5%8D%95%EF%BC%9F--im-a-perl-5-programmer-where-is-a-list-of-differences-between-perl-5-and-raku"></a>
## 我是 Perl 5 程序员。哪里有 Perl 5 与 Raku 的不同点的清单？ / I'm a Perl 5 programmer. Where is a list of differences between Perl 5 and Raku?

在[文档的语言部分](https://docs.raku.org/language)中有几个 *Perl 5 到 Raku* 指南，其中最值得注意的是[概述](https://docs.raku.org/language/5to6-nutshell)。

There are several *Perl 5 to Raku* guides in the [Language section of the documentation](https://docs.raku.org/language), most notable of which is the [Overview](https://docs.raku.org/language/5to6-nutshell).

<a id="im-a-ruby-programmer-looking-for-quickstart-type-docs--%E6%88%91%E6%98%AF%E4%B8%80%E4%B8%AA-ruby-%E7%A8%8B%E5%BA%8F%E5%91%98%E5%9C%A8%E5%AF%BB%E6%89%BE%E5%BF%AB%E9%80%9F%E5%90%AF%E5%8A%A8%E7%B1%BB%E5%9E%8B%E7%9A%84%E6%96%87%E6%A1%A3"></a>
## I'm a Ruby programmer looking for quickstart type docs? / 我是一个 Ruby 程序员在寻找快速启动类型的文档

请参阅 [rb-nutshell](https://docs.raku.org/language/rb-nutshell) 指南。

See the [rb-nutshell](https://docs.raku.org/language/rb-nutshell) guide.

<a id="%E6%A8%A1%E7%BB%84--modules"></a>
# 模组 / Modules

<a id="%E6%98%AF%E5%90%A6%E6%9C%89%E4%B8%80%E4%B8%AA-cpan%EF%BC%88%E7%AC%AC%E4%B8%89%E6%96%B9%E5%BA%93%E6%A8%A1%E5%9D%97%E5%AD%98%E5%82%A8%E5%BA%93%EF%BC%89%E4%BE%9B-raku-%E4%BD%BF%E7%94%A8%EF%BC%9F--is-there-a-cpan-repository-of-third-party-library-modules-for-raku"></a>
## 是否有一个 CPAN（第三方库模块存储库）供 Raku 使用？ / Is there a CPAN (repository of third party library modules) for Raku?

是的，它和 Perl5 是一个 [CPAN](https://cpan.org/) ！唯一的区别是当使用 [PAUSE](https://pause.perl.org/) 上传模块时，上传的模块显示在 [modules.raku.org](https://modules.raku.org/) 上，而不是 [MetaCPAN](https://metacpan.org/)。[`App::Mi6` 工具](https://modules.raku.org/l/App::Mi6)可以简化上传过程.[`zef` 模块安装程序](https://github.com/ugexe/zef)自动检查 CPAN 上一个模块的最新版本以及我们的[基于 GitHub 的生态系统](https://github.com/perl6/ecosystem/)。

Yes, it's the same [CPAN](https://cpan.org/) as for Perl 5! The only difference is when using [PAUSE](https://pause.perl.org/) to upload the module, the uploaded modules shows up on [modules.raku.org](https://modules.raku.org/) instead of [MetaCPAN](https://metacpan.org/). The [`App::Mi6` tool](https://modules.raku.org/l/App::Mi6) can simplify the uploading process. The [`zef` module installer](https://github.com/ugexe/zef) automatically check for latest versions of a module on CPAN as well as our [GitHub-based ecosystem](https://github.com/perl6/ecosystem/).

<a id="%E6%98%AF%E5%90%A6%E6%9C%89%E7%94%A8%E4%BA%8E-raku-%E7%9A%84-perldoc%EF%BC%88%E5%91%BD%E4%BB%A4%E8%A1%8C%E6%96%87%E6%A1%A3%E6%9F%A5%E7%9C%8B%E5%99%A8%EF%BC%89%EF%BC%9F--is-there-a-perldoc-command-line-documentation-viewer-for-raku"></a>
## 是否有用于 Raku 的 Perldoc（命令行文档查看器）？ / Is there a perldoc (command line documentation viewer) for Raku?

是的，它被称为 `p6doc`，并以这个名字存在于生态系统中。它与 Rakudo Star 捆绑在一起，但如果您正在使用 Rakudo 每月发布，则需要手动安装 `zef`。

Yes, it's called `p6doc` and is present in the ecosystem under that name. It comes bundled in with Rakudo Star but needs to be manually installed with `zef` if you are using a Rakudo monthly release.

<a id="%E6%88%91%E5%8F%AF%E4%BB%A5%E4%BD%BF%E7%94%A8%E6%9D%A5%E8%87%AA-raku-%E7%9A%84-perl-5-%E6%A8%A1%E5%9D%97%E5%90%97%EF%BC%9F--can-i-use-perl-5-modules-from-raku"></a>
## 我可以使用来自 Raku 的 Perl 5 模块吗？ / Can I use Perl 5 modules from Raku?

是的，有 [Inline::Perl5](https://github.com/niner/Inline-Perl5/)，它能使用大多数 Perl 5 模块。它甚至可以运行 Perl 5 Catalyst 和 DBI 模组。

Yes, with [Inline::Perl5](https://github.com/niner/Inline-Perl5/), which works well with most Perl 5 modules. It can even run Perl 5 Catalyst and DBI.

<a id="%E6%88%91%E5%8F%AF%E4%BB%A5%E5%9C%A8-raku-%E4%B8%AD%E4%BD%BF%E7%94%A8-c-%E5%92%8C-c-%E5%90%97%EF%BC%9F--can-i-use-c-and-c-from-raku"></a>
## 我可以在 Raku 中使用 C 和 C++ 吗？ / Can I use C and C++ from Raku?

[Nativecall](https://docs.raku.org/language/nativecall) 让这个变得特别简单。

[Nativecall](https://docs.raku.org/language/nativecall) makes this particularly easy.

<a id="nativecall-%E6%89%BE%E4%B8%8D%E5%88%B0-libfooso%EF%BC%8C%E8%80%8C%E6%88%91%E5%8F%AA%E6%9C%89-libfooso12%EF%BC%81--nativecall-cant-find-libfooso-and-i-only-have-libfooso12"></a>
## nativecall 找不到 `libfoo.so`，而我只有 `libfoo.so.1.2`！ / Nativecall can't find `libfoo.so` and I only have `libfoo.so.1.2`!

在大多数 Linux 系统中，共享库的安装方式是，对于一个特定的 `libfoo`，将有一个 `libfoo.so.x.y.z` 的真实文件，然后是一组软连接 `libfoo.so` 和 `libfoo.so.x`。例如，`ls /usr/local/lib/libxxhash.so*` 返回：

In most Linux systems, shared libraries will be installed in such a way that, for a specific `libfoo`, there will be a `libfoo.so.x.y.z` real file, and then a set of symlinks `libfoo.so` and `libfoo.so.x`. for instance, `ls /usr/local/lib/libxxhash.so*` returns:

```Raku
/usr/local/lib/libxxhash.so -> libxxhash.so.0.6.5
/usr/local/lib/libxxhash.so.0 -> libxxhash.so.0.6.5
/usr/local/lib/libxxhash.so.0.6.5
```

一般而言，在 Linux 中安装 `libfo-dev` 或 `libfo-devel`（取决于发行版）将安装共享库*并*为您设置这些软连接。但在某些情况下，你只会有，就像在问题中一样，`libfo.so.1.2`.

In general, installing a `libfoo-dev` or `libfoo-devel` (depending on the distro) in Linux will install the shared library *and* set up those symlinks for you. But in some cases, you will only have, as in the question, `libfoo.so.1.2`.

在这种情况下，只需使用显式设置 ABI/API 版本的 `is native` 版本，如[手册](https://docs.raku.org/language/nativecall#ABI/API_version)所示：

In that case, just use the version of `is native` that explicitly sets the ABI/API version, as indicated in [the manual](https://docs.raku.org/language/nativecall#ABI/API_version):

```Raku
sub call-foo() is native('foo',v1.2);
```

<a id="%E6%89%80%E6%9C%89%E4%BC%A0%E7%BB%9F%E7%9A%84-unix-%E5%BA%93%E5%87%BD%E6%95%B0%E9%83%BD%E5%8E%BB%E4%BA%86%E5%93%AA%E9%87%8C%EF%BC%9F--where-have-all-the-traditional-unix-library-functions-gone"></a>
## 所有传统的 UNIX 库函数都去了哪里？ / Where have all the traditional UNIX library functions gone?

使用 [NativeCall](https://docs.raku.org/language/nativecall) 访问它们是相当容易的。

It's fairly easy to use [NativeCall](https://docs.raku.org/language/nativecall) to access them.

生态系统模块 [POSIX](https://github.com/cspencer/perl6-posix) 也可用.

An ecosystem module [POSIX](https://github.com/cspencer/perl6-posix) is also available.

<a id="rakudo-%E6%9C%89%E6%A0%B8%E5%BF%83%E6%A0%87%E5%87%86%E5%BA%93%E5%90%97%EF%BC%9F--does-rakudo-have-a-core-standard-library"></a>
## Rakudo 有核心标准库吗？ / Does Rakudo have a core standard library?

[Rakudo Star distribution](https://rakudo.raku.org/downloads/) 确实有[许多有用的模组](https://github.com/rakudo/star/tree/master/modules)。

[Rakudo Star distribution](https://rakudo.raku.org/downloads/) does come with [many useful modules](https://github.com/rakudo/star/tree/master/modules).

只有 Rakudo 编译器的版本包括[几个最基本的模块](https://docs.raku.org/language/modules-core)。

Rakudo compiler-only release includes [only a couple of the most basic modules](https://docs.raku.org/language/modules-core).

在[生态系统](https://modules.raku.org/)中可以找到更多的模块。

Many more modules can be found in the [ecosystem](https://modules.raku.org/).

<a id="%E6%98%AF%E5%90%A6%E6%9C%89%E7%B1%BB%E4%BC%BC-bdeparse-%E7%9A%84%E4%B8%9C%E8%A5%BF%E6%88%91%E6%80%8E%E6%A0%B7%E6%89%8D%E8%83%BD%E5%BE%97%E5%88%B0-ast%EF%BC%9F--is-there-something-like-bdeparsehow-can-i-get-hold-of-the-ast"></a>
## 是否有类似 `B::Deparse` 的东西/我怎样才能得到 AST？ / Is there something like `B::Deparse`/How can I get hold of the AST?

使用 `--target=optimize` 命令行选项查看程序的 AST，例如，`perl6 --target=optimize -e 'say "hi"'`。

Use `--target=optimize` command line option to view the AST of your program, e.g., `perl6 --target=optimize -e 'say "hi"'`

目标 `optimize` 在静态优化器完成工作后给出 AST，而目标 `ast` 在该步骤之前给出 AST。要获取可用目标的完整列表，请运行 `perl6 --stagestats -e ""`

The target `optimize` gives the AST after the static optimizer does its job, while target `ast` gives the AST before that step. To get the full list of available targets, run `perl6 --stagestats -e ""`

<a id="%E4%BB%80%E4%B9%88%E6%98%AF%E9%A2%84%E7%BC%96%E8%AF%91%EF%BC%9F--what-is-precompilation"></a>
## 什么是预编译？ / What is precompilation?

当您第一次加载模块时，Rakudo 将其编译为字节码。然后，Rakudo 都将编译后的字节码存储在磁盘上并使用它，因为这往往要快得多。

When you load a module for the first time, Rakudo compiles it into bytecode. Then, Rakudo both stores the compiled bytecode on disk and uses it, because that tends to be significantly faster.

<a id="%E6%88%91%E8%83%BD%E5%9C%A8%E6%A8%A1%E5%9D%97%E4%B9%8B%E9%97%B4%E6%9C%89%E5%BE%AA%E7%8E%AF%E4%BE%9D%E8%B5%96%E5%85%B3%E7%B3%BB%E5%90%97%EF%BC%9F--can-i-have-circular-dependencies-between-modules"></a>
## 我能在模块之间有循环依赖关系吗？ / Can I have circular dependencies between modules?

不，你不能有循环依赖，你应该得到一个 `Circular module loading detected` 错误，如果你的模块之间有这种情况的话。

No, you can't have circular dependencies, and you should get a `Circular module loading detected` error if you have them between your modules.

很可能您可以使用[角色](https://docs.raku.org/language/objects#Roles)完成您正在尝试的任务。而不是 `A.pm6` 依赖 `B.pm6` 并且 `B.pm6` 依赖 `A.pm6`，您可以使用 `A-Role.pm6` 和 `B-Role.pm6`，以及 `A.pm6` 和 `B.pm6` 中的类分别实现这些角色。然后，您可以依赖 `A-Role.pm6` 和 `B-Role.pm6` 而没有循环依赖。

Very likely you can accomplish what you are trying to do using [roles](https://docs.raku.org/language/objects#Roles). Instead of `A.pm6` depending on `B.pm6` and `B.pm6` depending on `A.pm6`, you can have `A-Role.pm6` and `B-Role.pm6` and classes in `A.pm6` and `B.pm6` implementing these roles respectively. Then you can depend on `A-Role.pm6` and `B-Role.pm6` without the need for the circular dependency.

循环依赖在 Raku 中不起作用的原因之一是一个传递解析。解析 B 的时候我们要知道 A 是什么意思，解析 A 的时候我们要知道 B 是什么意思，这显然是一个无限循环。

One of the reasons why circular dependencies do not work in Raku is one pass parsing. We have to know what A means when we parse B, and we have to know what B means when we parse A, which is clearly an infinite loop.

请注意，Raku 没有一个文件一个类的限制，单个编译单元（例如文件）中的循环依赖是可能的。因此，另一种可能的解决方案是将类移动到同一个编译单元中。

Note that Raku has no “1 file = 1 class” limitation, and circular dependencies within a single compilation unit (e.g., file) are possible through stubbing. Therefore another possible solution is to move classes into the same compilation unit.

<a id="%E8%AF%AD%E8%A8%80%E7%89%B9%E6%80%A7--language-features"></a>
# 语言特性 / Language features

<a id="%E5%A6%82%E4%BD%95%E6%89%93%E5%8D%B0-raku-%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84%EF%BC%88%E4%B8%8E-perl5-%E7%9A%84-datadumper-%E6%88%96%E8%80%85%E5%85%B6%E4%BB%96%E6%A8%A1%E5%9D%97%E7%B1%BB%E4%BC%BC%EF%BC%89--how-can-i-dump-raku-data-structures-like-perl-5-datadumper-and-similar"></a>
## 如何打印 Raku 数据结构（与 Perl5 的 Data::Dumper 或者其他模块类似） / How can I dump Raku data structures (like Perl 5 Data::Dumper and similar)?

典型的选项是使用 [say](https://docs.raku.org/routine/say) 例程，该例程使用 [gist](https://docs.raku.org/routine/gist) 方法，该方法给出了被打印对象的“要点”。更详细的输出可以通过调用 [perl](https://docs.raku.org/routine/perl) 方法（很快就会被弃用，改为 `$obj.raku`，自 Rakudo2019.11 发布以来可用）来获得，该方法通常返回在 [EVAL](https://docs.raku.org/routine/EVAL) 中可用的对象的表示。

Typical options are to use the [say](https://docs.raku.org/routine/say) routine that uses the [gist](https://docs.raku.org/routine/gist) method which gives the "gist" of the object being dumped. More detailed output can be obtained by calling the [perl](https://docs.raku.org/routine/perl) method (soon to be deprecated in favor of `$obj.raku`, available since the Rakudo 2019.11 release) that typically returns an object's representation in [EVAL](https://docs.raku.org/routine/EVAL)-able code.

如果您正在使用 [rakudo](https://rakudo.org/) 实现，您可以使用 [rakudo 指定的 `dd` 例程](https://docs.raku.org/programs/01-debugging#Dumper_function_dd) 进行打印，其输出类似于 [perl](https://docs.raku.org/routine/perl) 方法，但具有更多信息。

If you're using the [rakudo](https://rakudo.org/) implementation, you can use the [rakudo-specific `dd` routine](https://docs.raku.org/programs/01-debugging#Dumper_function_dd) for dumping, whose output is similar to [perl](https://docs.raku.org/routine/perl), but with more information.

例如：

Examples:

```Raku
my $foo = %( foo => 'bar' );
say $foo.perl;   # OUTPUT: «${:foo("bar")}␤» 
say $foo;        # OUTPUT: «{foo => bar}␤» 
 
# non-standard routine available in rakudo implementation: 
dd $foo;         # OUTPUT: «Hash $foo = ${:foo("bar")}␤» 
```

还有[几个生态系统模块](https://modules.raku.org/s/dump)提供了对数据结构如何打印的更多控制，包括对彩色输出的支持。

There are also [several ecosystem modules](https://modules.raku.org/s/dump) that provide more control over how data structures are dumped, including support for colored output.

<a id="%E5%A6%82%E4%BD%95%E5%9C%A8-raku-%E6%8F%90%E7%A4%BA%E7%AC%A6%EF%BC%88repl%EF%BC%89%E4%B8%AD%E8%8E%B7%E5%8F%96%E5%91%BD%E4%BB%A4%E8%A1%8C%E5%8E%86%E5%8F%B2%E8%AE%B0%E5%BD%95%EF%BC%9F--how-can-i-get-command-line-history-in-the-raku-prompt-repl"></a>
## 如何在 Raku 提示符（REPL）中获取命令行历史记录？ / How can I get command line history in the Raku prompt (REPL)?

从生态系统中安装 [Linenoise](https://github.com/hoelzro/p6-linenoise/).

Install [Linenoise](https://github.com/hoelzro/p6-linenoise/) from the ecosystem.

类 UNIX 的系统的另一个选择是安装 `rlwrap`。在 Debian 系统上可以通过运行：

An alternative for UNIX-like systems is to install `rlwrap`. This can be done on Debian-ish systems by running:

```Raku
sudo apt-get install rlwrap
```

<a id="%E4%B8%BA%E4%BB%80%E4%B9%88-rakudo-%E7%BC%96%E8%AF%91%E5%99%A8%E5%A6%82%E6%AD%A4%E5%A4%9A%E6%8A%B1%E6%AD%89%EF%BC%9F--why-is-the-rakudo-compiler-so-apologetic"></a>
## 为什么 Rakudo 编译器如此多抱歉？ / Why is the Rakudo compiler so apologetic?

如果在输出中输出 SORRY！错误是编译时间错误。否则，这是运行时错误。

If SORRY! is present in the output, the error is a compile time error. Otherwise, it's a runtime error.

Example:

```Raku
sub foo( Int $a, Int $b ) {...}
foo(1)     # ===SORRY!=== Error while compiling ... 
say 1/0;   # Attempt to divide 1 by zero using div 
```

<a id="%E4%BB%80%E4%B9%88%E6%98%AF-any%EF%BC%9F--what-is-any"></a>
## 什么是 `(Any)`？ / What is `(Any)`?

[`Any`](https://docs.raku.org/type/Any) 是大多数对象所继承的顶级类。在没有显式类型约束的变量和参数上，任何类型的对象都是[默认值](https://docs.raku.org/type/Attribute#Trait_is_default)，这意味着当您使用 [`say` 例程](https://docs.raku.org/routine/say)等方法输出一个没有任何值的变量时，您可能会看到 `(Any)` 打印出来：

[`Any`](https://docs.raku.org/type/Any) is a top level class most objects inherit from. The `Any` type object is [the default value](https://docs.raku.org/type/Attribute#Trait_is_default) on variables and parameters without an explicit type constraint, which means you'll likely see `(Any)` printed when you output a [gist](https://docs.raku.org/routine/gist) of a variable without any value by using, for instance, the [`say` routine](https://docs.raku.org/routine/say):

```Raku
my $foo;
say $foo; # OUTPUT: «(Any)␤» 
 
my Int $baz;
say $baz; # OUTPUT: «(Int)␤» 
 
my $bar = 70;
say $bar; # OUTPUT: «70␤» 
```

若要测试变量是否有任何定义值，请参见 [DEFINITE](https://docs.raku.org/language/classtut#index-entry-.DEFINITE) 和 [defined](https://docs.raku.org/routine/defined) 例程。还有其他几个关于确定性的检验，例如 [`with`、 `orwith` 和 `without`](https://docs.raku.org/syntax/with%20orwith%20without) 语句，[`//`](https://docs.raku.org/routine/$SOLIDUS$SOLIDUS)、 [andthen](https://docs.raku.org/routine/andthen)、 [notandthen](https://docs.raku.org/routine/notandthen) 和 [orelse](https://docs.raku.org/routine/orelse) 运算符，以及[类型约束微笑表情符](https://docs.raku.org/type/Signature#Constraining_defined_and_undefined_values)。

To test whether a variable has any defined values, see [DEFINITE](https://docs.raku.org/language/classtut#index-entry-.DEFINITE) and [defined](https://docs.raku.org/routine/defined) routines. Several other constructs exist that test for definiteness, such as [`with`, `orwith`, and `without`](https://docs.raku.org/syntax/with%20orwith%20without) statements, [`//`](https://docs.raku.org/routine/$SOLIDUS$SOLIDUS), [andthen](https://docs.raku.org/routine/andthen), [notandthen](https://docs.raku.org/routine/notandthen), and [orelse](https://docs.raku.org/routine/orelse) operators, as well as [type constraint smileys](https://docs.raku.org/type/Signature#Constraining_defined_and_undefined_values).

<a id="so-%E6%98%AF%E4%BB%80%E4%B9%88%EF%BC%9F--what-is-so"></a>
## `so` 是什么？ / What is `so`?

`so` 是一个松散的优先操作符，强制类型转换为 [Bool](https://docs.raku.org/type/Bool)。

`so` is a loose precedence operator that coerces to [Bool](https://docs.raku.org/type/Bool).

它与 `?` 前缀运算符具有相同的语义，就像 `and` 是 `&&` 的低优先级版本一样。

It has the same semantics as the `?` prefix operator, just like `and` is the low-precedence version of `&&`.

例如：

Example:

```Raku
say so 1|2 == 2;    # OUTPUT: «True␤» 
```

在这个例子中，比较的结果（这是一个 [Junction](https://docs.raku.org/type/Junction)，在打印之前转换为 Bool。

In this example, the result of the comparison (which is a [Junction](https://docs.raku.org/type/Junction)), is converted to Bool before being printed.

<a id="%E5%9C%A8%E5%87%BD%E6%95%B0%E7%AD%BE%E5%90%8D%E4%B8%AD%E7%9A%84-d-%E5%92%8C-u-%E6%98%AF%E4%BB%80%E4%B9%88%EF%BC%9F--what-are-those-d-and-u-things-in-signatures"></a>
## 在函数签名中的 `:D` 和 `:U` 是什么？ / What are those `:D` and `:U` things in signatures?

在 Raku 中，类和其他类型是对象，并通过自己类型的类型检查。

In Raku, classes and other types are objects and pass type checks of their own type.

例如，如果你声明一个变量

For example, if you declare a variable

```Raku
my Int $x = 42;
```

然后，不仅可以将整数（即 Int 类的实例）赋值给它，而且还可以将 `Int` 类型对象本身赋值：

then not only can you assign integers (that is, instances of class Int) to it, but the `Int` type object itself:

```Raku
$x = Int
```

如果你想排除类型对象，你可以附加 `:D`，它代表“确定的”：

If you want to exclude type objects, you can append the `:D` type smiley, which stands for "definite":

```Raku
my Int:D $x = 42;
$x = Int;
 
# dies with: 
# Type check failed in assignment to $x; 
# expected Int:D but got Int 
```

同样，`:U` 约束为未定义的值，即类型对象。

Likewise, `:U` constrains to undefined values, that is, type objects.

To explicitly allow either type objects or instances, you can use `:_`.

<a id="%E5%9C%A8%E5%87%BD%E6%95%B0%E7%AD%BE%E5%90%8D%E4%B8%AD%E7%9A%84----%E6%98%AF%E4%BB%80%E4%B9%88%EF%BC%9F--what-is-the----thing-in-the-signature"></a>
## 在函数签名中的 `-->` 是什么？ / What is the `-->` thing in the signature?

[-->](https://docs.raku.org/type/Signature#Constraining_return_types) 是返回值约束，是一个类型或者一个确定的值。

[-->](https://docs.raku.org/type/Signature#Constraining_return_types) is a return constraint, either a type or a definite value.

类型约束的例子：

Example of a type constraint:

```Raku
sub divide-to-int( Int $a, Int $b --> Int ) {
        return ($a / $b).narrow;
}
 
divide-to-int(3, 2)
# Type check failed for return value; expected Int but got Rat 
```

返回确定值的例子：

Example of a definite return value:

```Raku
sub discard-random-number( --> 42 ) { rand }
say discard-random-number;
# OUTPUT: «42␤» 
```

在这种情况下，由于签名中已经指定了返回值，最终值将被丢弃。

In this case, the final value is thrown away because the return value is already specified in the signature.

<a id="%E6%88%91%E6%80%8E%E6%A0%B7%E6%89%8D%E8%83%BD%E4%BB%8E-junction-%E4%B8%AD%E6%8F%90%E5%8F%96%E5%80%BC%EF%BC%9F--how-can-i-extract-the-values-from-a-junction"></a>
## 我怎样才能从 Junction 中提取值？ / How can I extract the values from a Junction?

如果您想从 [Junction](https://docs.raku.org/type/Junction) 中提取值（本征态），您可能做错了什么，应该使用 [Set](https://docs.raku.org/type/Set)。

If you want to extract the values (eigenstates) from a [Junction](https://docs.raku.org/type/Junction), you are probably doing something wrong and should be using a [Set](https://docs.raku.org/type/Set) instead.

Junction 的意思是作为匹配者，而不是进行代数计算。

Junctions are meant as matchers, not for doing algebra with them.

如果你确实想这样做，你可以滥用自动线程：

If you want to do it anyway, you can abuse autothreading for that:

```Raku
sub eigenstates(Mu $j) {
    my @states;
    -> Any $s { @states.push: $s }.($j);
    @states;
}
 
say eigenstates(1|2|3).join(', ');
# prints 1, 2, 3 or a permutation thereof 
```

<a id="%E5%A6%82%E6%9E%9C-str-%E6%98%AF%E4%B8%8D%E5%8F%AF%E5%8F%98%E7%9A%84%EF%BC%8Cs-%E6%98%AF%E6%80%8E%E6%A0%B7%E5%B7%A5%E4%BD%9C%E7%9A%84%EF%BC%9F-%E5%A6%82%E6%9E%9C-int-%E6%98%AF%E4%B8%8D%E5%8F%AF%E5%8F%98%E7%9A%84%EF%BC%8C%24i-%E6%98%AF%E6%80%8E%E6%A0%B7%E5%B7%A5%E4%BD%9C%E7%9A%84%EF%BC%9F--if-str-is-immutable-how-does-s-work-if-int-is-immutable-how-does-%24i-work"></a>
## 如果 Str 是不可变的，`s///` 是怎样工作的？ 如果 Int 是不可变的，`$i++` 是怎样工作的？ / If Str is immutable, how does `s///` work? If Int is immutable, how does `$i++` work?

在 Raku 中，许多基本类型的值是不可变的，但持有它们的变量不是。`s///` 运算符在一个变量上工作，它将一个新创建的字符串对象放入其中。同样，`$i++` 工作在 `$i` 变量上，而不仅仅是它的值。

In Raku, values of many basic types are immutable, but the variables holding them are not. The `s///` operator works on a variable, into which it puts a newly created string object. Likewise, `$i++` works on the `$i` variable, not just on the value in it.

知道这一点，您就不会尝试更改文字字符串（例如 `'hello' ~~ s/h/H/;`），但你可能会不小心用 `map` 做了一些等效的事情，如下所示。

Knowing this, you would not try to change a literal string (e.g. like `'hello' ~~ s/h/H/;`), but you might accidentally do something equivalent using `map` as follows.

```Raku
my @foo = <hello world>.map: { s/h/H/ };
 
# dies with 
# Cannot modify an immutable Str (hello) 
 
my @bar = <hello world>».subst-mutate: 'h', 'H';
 
# dies with 
# Cannot resolve caller subst-mutate(Str: Str, Str); 
# the following candidates match the type but require 
# mutable arguments: ... 
```

使用返回新值的例程或运算符，而不是修改原来的值：

Instead of modifying the original value in place, use a routine or operator that returns a new value:

```Raku
my @foo = <hello world>.map: { S/h/H/ };  # ['Hello','world'] 
my @bar = <hello world>».subst: 'h', 'H'; # ['Hello','world'] 
```

有关更多信息，请参见 [containers](https://docs.raku.org/language/containers) 上的文档。

See the documentation on [containers](https://docs.raku.org/language/containers) for more information.

<a id="%E6%95%B0%E7%BB%84%E5%BC%95%E7%94%A8%E5%92%8C%E8%87%AA%E5%8A%A8%E5%8F%96%E6%B6%88%E5%BC%95%E7%94%A8%E6%98%AF%E6%80%8E%E4%B9%88%E5%9B%9E%E4%BA%8B%EF%BC%9F-%E6%88%91%E9%9C%80%E8%A6%81--%E6%A0%87%E8%AE%B0%E5%90%97%EF%BC%9F--whats-up-with-array-references-and-automatic-dereferencing-do-i-need-the--sigil"></a>
## 数组引用和自动取消引用是怎么回事？ 我需要 `@` 标记吗？ / What's up with array references and automatic dereferencing? Do I need the `@` sigil?

在 Raku 中，几乎所有内容都是引用，因此谈论获取引用没有多大意义。 标量变量也可以直接包含数组：

In Raku, nearly everything is a reference, so talking about taking references doesn't make much sense. Scalar variables can also contain arrays directly:

```Raku
my @a = 1, 2, 3;
say @a;                 # OUTPUT: «[1 2 3]␤» 
say @a.^name;           # OUTPUT: «Array␤» 
 
my $scalar = @a;
say $scalar;            # OUTPUT: «[1 2 3]␤» 
say $scalar.^name;      # OUTPUT: «Array␤» 
```

最大的区别是标量内部的数组在列表上下文中充当一个值，而数组将很高兴地迭代。

The big difference is that arrays inside a scalar act as one value in list context, whereas arrays will be happily iterated over.

```Raku
my @a = 1, 2, 3;
my $s = @a;
 
for @a { ... }          # loop body executed 3 times 
for $s { ... }          # loop body executed only once 
 
my @flat = flat @a, @a;
say @flat.elems;            # OUTPUT: «6␤» 
 
my @nested = flat $s, $s;
say @nested.elems;          # OUTPUT: «2␤» 
```

您可以使用  `@( ... )` 或通过在表达式上调用 `.list` 来强制列表上下文，而可以使用 `$( ... )` 或对表达式调用 `.item` 方法来强制单条目上下文。

You can force list context with `@( ... )` or by calling the `.list` method on an expression, and item context with `$( ... )` or by calling the `.item` method on an expression.

请参阅 [*Perl 6：符号、变量和容器*](https://perl6advent.wordpress.com/2017/12/02/)文章以了解更多信息。

See the [*Perl 6: Sigils, Variables, and Containers*](https://perl6advent.wordpress.com/2017/12/02/) article to learn more.

<a id="%E4%B8%BA%E4%BB%80%E4%B9%88%E8%A6%81%E7%94%A8%E6%A0%87%E8%AE%B0%E7%AC%A6%EF%BC%9F-%E4%BD%A0%E4%B8%8D%E8%83%BD%E6%B2%A1%E6%9C%89%E4%BB%96%E4%BB%AC%E5%90%97%EF%BC%9F--why-sigils-couldnt-you-do-without-them"></a>
## 为什么要用标记符？ 你不能没有他们吗？ / Why sigils? Couldn't you do without them?

有以下几个原因：

- 它们使将变量插值到字符串变得容易
- 它们为不同的变量和标记符形成了微命名空间，从而避免了名称冲突
- 它们可以轻松区分单数/复数
- 它们像使用强制性名词标记的自然语言一样工作，因此我们的大脑可以处理它
- 它们不是强制性的，因为您可以声明无名字的名称（如果您不介意歧义的话）

There are several reasons:

- they make it easy to interpolate variables into strings
- they form micro-namespaces for different variables and twigils, thus avoiding name clashes
- they allow easy single/plural distinction
- they work like natural languages that use mandatory noun markers, so our brains are built to handle it
- they aren't mandatory, since you can declare sigilless names (if you don't mind the ambiguity)

<a id="%E2%80%9C%E7%B1%BB%E5%9E%8B-str-%E4%B8%8D%E6%94%AF%E6%8C%81%E5%85%B3%E8%81%94%E7%B4%A2%E5%BC%95%E3%80%82%E2%80%9D--type-str-does-not-support-associative-indexing"></a>
## “类型 Str 不支持关联索引。” / "Type Str does not support associative indexing."

您可能试图混合使用字符串插值和关键字符，例如 HTML 标签：

You likely tried to mix string interpolation and key characters, like HTML tags:

```Raku
my $foo = "abc";
say "$foo<html-tag>";
```

Raku 认为 `$foo` 是哈希，而 `<html-tag>` 是字符串文本哈希键。 使用闭包帮助它了解您。

Raku thinks `$foo` is a Hash and `<html-tag>` is a string literal hash key. Use a closure to help it to understand you.

```Raku
my $foo = "abc";
say "{$foo}<html-tag>";
```

<a id="raku-%E6%9C%89%E5%8D%8F%E7%A8%8B%E5%90%97%EF%BC%9F-%E9%82%A3-yield-%E5%91%A2%EF%BC%9F--does-raku-have-coroutines-what-about-yield"></a>
## Raku 有协程吗？ 那 `yield` 呢？ / Does Raku have coroutines? What about `yield`?

Raku 没有像 Python 那样的 `yield` 语句，但是它通过惰性列表提供了类似的功能。 有两种流行的方法可以编写返回延迟列表的例程：

Raku has no `yield` statement like Python does, but it does offer similar functionality through lazy lists. There are two popular ways to write routines that return lazy lists:

```Raku
# first method, gather/take 
my @values = gather while have_data() {
    # do some computations 
    take some_data();
    # do more computations 
}
 
# second method, use .map or similar method 
# on a lazy list 
my @squares = (1..*).map(-> \x { x² });
```

<a id="%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E8%83%BD%E9%80%9A%E8%BF%87%E6%96%B0%E6%96%B9%E6%B3%95%E5%88%9D%E5%A7%8B%E5%8C%96%E7%A7%81%E6%9C%89%E5%B1%9E%E6%80%A7%EF%BC%8C%E5%A6%82%E4%BD%95%E8%A7%A3%E5%86%B3%E6%AD%A4%E9%97%AE%E9%A2%98%EF%BC%9F--why-cant-i-initialize-private-attributes-from-the-new-method-and-how-can-i-fix-this"></a>
## 为什么不能通过新方法初始化私有属性，如何解决此问题？ / Why can't I initialize private attributes from the new method, and how can I fix this?

以下代码示例中的 `say` 语句

The `say` statement in the following code sample

```Raku
class A {
    has $!x;
    method show-x {
        return $!x;
    }
}
say A.new(x => 5).show-x;
```

不会打印 5。私有属性是*私有的*，这意味着外界看不见。 如果默认构造函数可以初始化它们，则它们将泄漏到公共 API 中。 因此，在此特定代码示例中，默认构造函数未在对象构造期间初始化属性 `$!x`。

does not print 5. Private attributes are *private*, which means invisible to the outside world. If the default constructor could initialize them, they would leak into the public API. Thus, in this particular code sample the attribute `$!x` isn't initialized during object construction by the default constructor.

如果您仍想使用默认构造函数初始化私有属性，则可以添加一个 `submethod BUILD` 来实现此任务：

If you still want to initialize private attributes with the default constructor, you can add a `submethod BUILD` to achieve such task:

```Raku
class B {
    has $!x;
    submethod BUILD(:$!x) { }
    method show-x {
        return $!x;
    }
}
say B.new(x => 5).show-x;
```

`BUILD` 由默认构造函数调用（有关更多详细信息，请间接参见[对象创建](https://docs.raku.org/language/objects#Object_construction)），其中包含用户传递给构造函数的所有命名参数 。 `:$!x` 是名为 `x` 的命名参数，当使用名为 `x` 的命名参数调用时，其值绑定到属性 `$!x`。

`BUILD` is called by the default constructor (indirectly, see [Object Construction](https://docs.raku.org/language/objects#Object_construction) for more details) with all the named arguments that the user passes to the constructor. `:$!x` is a named parameter with name `x`, and when called with a named argument of name `x`, its value is bound to the attribute `$!x`.

但是，您不应该这样做。 如果属性被声明为私有，则不应将其暴露于类之外的环境中（例如，在对象构建期间）。 另一方面，如果该属性是公共属性，则使用 `$ .x` 声明它没有任何缺点，因为默认情况下外部视图是只读的，并且您仍然可以使用 `$!x` 在内部访问它。 。

However, you shouldn't do that. If the attribute is declared as private, then it shouldn't be exposed to the environment outside the class (e.g., during object construction). On the other hand, if the attribute is public, there is no downside to declaring it that way with `$.x` since the external view is read-only by default, and you can still access it internally with `$!x`.

<a id="say%E3%80%81-put-%E5%92%8C-print-%E6%9C%89%E4%BD%95%E5%8C%BA%E5%88%AB%EF%BC%9F--how-and-why-do-say-put-and-print-differ"></a>
## `say`、 `put` 和 `print` 有何区别？ / How and why do `say`, `put` and `print` differ?

最明显的区别是 `say `和 `put` 在输出的末尾添加了换行符，而 `print` 则不会。

The most obvious difference is that `say` and `put` append a newline at the end of the output, and `print` does not.

但是还有另一个区别：`print` 和 `put` 通过传递给它们的每个项目调用 `Str` 方法将其参数转换为字符串，而`say`使用`gist`方法。 您也可以为自己的类创建的`gist`方法旨在创建用于人类解释的`Str`。 因此，可以自由地忽略有关对象的信息，这些信息对于理解对象的本质不重要。

But there's another difference: `print` and `put` convert their arguments to a string by calling the `Str` method on each item passed to them while `say` uses the `gist` method. The `gist` method, which you can also create for your own classes, is intended to create a `Str` for human interpretation. So it is free to leave out information about the object deemed unimportant to understanding the essence of the object.

换句话说，`$obj.Str` 提供了字符串表示形式，`$obj.gist` 提供了适合于人类快速识别的对象的简短摘要，以及 `$obj.perl`（$obj.raku`）给出了 Raku 式的表示形式，可以从中重新创建对象。

Or phrased differently, `$obj.Str` gives a string representation, `$obj.gist` provides a short summary of that object suitable for fast recognition by a human, and `$obj.perl` (`$obj.raku`) gives a Raku-ish representation from which the object could be re-created.

例如，当在类型对象（也称为“未定义值”）上调用 `Str` 方法时，该类型将被字符串化为一个空字符串，并引发警告。 另一方面，`gist` 方法在括号之间返回类型的名称（以表明该值中除了类型之外没有任何内容）。

For example, when the `Str` method is invoked on a type object, also known as an "undefined value", the type is stringified to an empty string and a `warn`ing is thrown. On the other hand, the `gist` method returns the name of the type between parentheses (to indicate there's nothing in that value except the type).

```Raku
my Date $x;     # $x now contains the Date type object 
print $x;       # empty string plus warning 
say $x;         # OUTPUT: «(Date)␤» 
```

如果要显示对象的调试版本，则最好使用[特定于 rakudo 的 `dd` 例程](https://docs.raku.org/programs/01-debugging#Dumper_function_dd)。 它本质上执行 `$obj.perl`（`$obj.raku`）并在 STDERR 而非 STDOUT 上显示，因此不会干扰程序的任何“正常”输出。

If you'd like to show a debugging version of an object, it is probably better to use the [rakudo-specific `dd` routine](https://docs.raku.org/programs/01-debugging#Dumper_function_dd). It essentially does a `$obj.perl` (`$obj.raku`) and shows that on STDERR rather than STDOUT, so it won't interfere with any "normal" output of your program.

简而言之，`say` 是针对偶然的人类解释而优化的，`dd 是针对偶然的调试输出而优化的，而 `print` 和 `put` 更普遍地适合于产生输出。

In short, `say` is optimized for casual human interpretation, `dd` is optimized for casual debugging output and `print` and `put` are more generally suitable for producing output.

因此，`put` 是 `print` 和 `say` 的混合体； 像 `print` 一样，它会在对象上调用 `Str` 方法。 和 `say` 一样，它在输出的末尾添加一个换行符。

`put` is thus a hybrid of `print` and `say`; like `print`, it calls the `Str` method on the object. And like `say`, it adds a newline at the end of the output.

<a id="token-%E5%92%8C-rule-%E7%9A%84%E5%8C%BA%E5%88%AB%E6%98%AF%E4%BB%80%E4%B9%88%EF%BC%9F--whats-the-difference-between-token-and-rule-"></a>
## `token` 和 `rule` 的区别是什么？ / What's the difference between `token` and `rule` ?

`regex`、 `token` 和 `rule` 引入了正则，但语义略有不同。

`regex`, `token` and `rule` introduce regexes, but with slightly different semantics.

`token` 意味着启用 `:ratchet` 或 `:r` 修饰符，这防止了规则的回溯。

`token` implies the `:ratchet` or `:r` modifier, which prevents the rule from backtracking.

`rule` 意味着启用 `:ratchet` 和 `:sigspace`（简称 `:s`）修饰符，这意味着规则不会回溯，它将正则文本中的空格视为 `<.ws>` 调用（即匹配空格，除两个字符间外，空格是可选的）。在正则的开始和每个分支的开始的空白被忽略。

`rule` implies both the `:ratchet` and `:sigspace` (short `:s`) modifier, which means a rule doesn't backtrace, and it treats whitespace in the text of the regex as `<.ws>` calls (i.e., matches whitespace, which is optional except between two word characters). Whitespace at the start of the regex and at the start of each branch of an alternation is ignored.

`regex` 声明一个普通的正则，没有任何隐含的修饰符。

`regex` declares a plain regex without any implied modifiers.

<a id="die-%E5%92%8C-fail-%E6%9C%89%E4%BB%80%E4%B9%88%E5%8C%BA%E5%88%AB%EF%BC%9F--whats-the-difference-between-die-and-fail"></a>
## `die` 和 `fail` 有什么区别？ / What's the difference between `die` and `fail`?

`die` 抛出异常。

`die` throws an exception.

`fail` 返回 `Failure` 对象。（如果调用方声明 `use fatal;` 在调用词法作用域中 `fail` 引发异常而不是返回异常）

`fail` returns a `Failure` object. (If the caller has declared `use fatal;` in the calling lexical scope, `fail` throws an exception instead of returning it.)

`Failure` 是“未被抛出的”或“懒惰”的异常。它是一个包含异常的对象，如果尝试将 `Failure` 用作普通对象或在 sink 上下文中忽略它，则抛出异常。

A `Failure` is an "unthrown" or "lazy" exception. It's an object that contains the exception, and throws the exception if you try to use the `Failure` as an ordinary object or ignore it in sink context.

`Failure` 从 `defined` 检查中返回 `False`，您可以使用 `exception` 方法提取异常。

A `Failure` returns `False` from a `defined` check, and you can extract the exception with the `exception` method.

<a id="pointer-%E5%92%8C-opaquepointer-%E6%9C%89%E4%BB%80%E4%B9%88%E5%8C%BA%E5%88%AB%EF%BC%9F--whats-the-difference-between-pointer-and-opaquepointer"></a>
## `Pointer` 和 `OpaquePointer` 有什么区别？ / What's the difference between `Pointer` and `OpaquePointer`?

`OpaquePointer` 不推荐使用并被 `Pointer` 替换了。

`OpaquePointer` is deprecated and has been replaced with `Pointer`.

<a id="%E6%82%A8%E5%8F%AF%E4%BB%A5%E5%9C%A8%E6%A0%87%E8%AF%86%E7%AC%A6%E4%B8%AD%E6%9C%89%E5%86%92%E5%8F%B7%E5%AF%B9%E3%80%82%E7%90%86%E7%94%B1%E6%98%AF%E4%BB%80%E4%B9%88%EF%BC%9F--you-can-have-colonpairs-in-identifiers-whats-the-justification"></a>
## 您可以在标识符中有冒号对。理由是什么？ / You can have colonpairs in identifiers. What's the justification?

[标识符可以包括冒号对，这些对成为其名称的一部分](https://docs.raku.org/language/syntax#Identifiers)。根据[拉里沃尔对这个问题的回答](https://github.com/perl6/doc/issues/1753#issuecomment-362875676)，*我们已经有了冒号对机制，所以使用它来扩展任何需要引用唯一但非标准字符的名称（或其他信息，并对这些字符进行独特的字符串）是一种不费吹灰之力的方法。

[Identifiers can include colon pairs, which become part of their name](https://docs.raku.org/language/syntax#Identifiers). According to [Larry Wall's answer to the issue](https://github.com/perl6/doc/issues/1753#issuecomment-362875676), *We already had the colon pair mechanism available, so it was a no-brainer to use that to extend any name that needs to be able to quote uniquefying but non-standard characters (or other information with a unique stringification to such characters)*.

<a id="%E5%A4%A7%E5%A4%9A%E6%95%B0%E4%BA%BA%E6%98%AF%E5%A6%82%E4%BD%95%E8%BE%93%E5%85%A5-unicode-%E5%AD%97%E7%AC%A6%E7%9A%84%EF%BC%9F--how-do-most-people-enter-unicode-characters"></a>
## 大多数人是如何输入 Unicode 字符的？ / How do most people enter unicode characters?

它取决于操作系统、窗口环境和/或编辑器。[输入 Unicode 字符的页面](https://docs.raku.org/language/unicode_entry)指定如何在最流行的操作系统和编辑器中完成。

It depends on the operating system, windowing environment and/or editors. [This page on entering Unicode characters](https://docs.raku.org/language/unicode_entry) specifies how it is done in the most popular operating systems and editors.

<a id="raku-%E5%AE%9E%E7%8E%B0--raku-implementation"></a>
# Raku 实现 / Raku implementation

<a id="%E6%9C%89%E5%93%AA%E4%BA%9B-raku-%E5%AE%9E%E7%8E%B0%E5%8F%AF%E7%94%A8%EF%BC%9F--what-raku-implementations-are-available"></a>
## 有哪些 Raku 实现可用？ / What Raku implementations are available?

目前最好的开发是乐天多（使用多个虚拟机后端）。历史上的实现包括 Niecza (用 .NET 写成) 和 Pugs（用 Haskell 写成）。其他名单列于 [Raku 编译器](https://www.raku.org/compilers/)

Currently the best developed is Rakudo (using multiple Virtual Machine backends). Historic implementations include Niecza (.NET) and Pugs (Haskell). Others are listed at [Raku Compilers](https://www.raku.org/compilers/)

<a id="rakudo-%E7%94%A8%E4%BB%80%E4%B9%88%E8%AF%AD%E8%A8%80%E5%86%99%E7%9A%84%EF%BC%9F--what-language-is-rakudo-written-in"></a>
## Rakudo 用什么语言写的？ / What language is Rakudo written in?

一个简短的回答是，Rakudo 几乎完全是用 Raku 写的。一个更详细的答案是，Rakudo 是用 Raku 和 NQP（“Not Quite Perl”）的混合体写成的。对于虚拟机来说，NQP 是一个轻量级的类 Raku 环境；它被设计成一种使用 Raku 语法为虚拟机（如 MoarVM 和 JVM）创建编译器和库的高级方法。

A short answer is that Rakudo is written almost entirely in Raku. A more detailed answer is that Rakudo is written in a mixture of Raku and NQP ("Not Quite Perl"). NQP is a lightweight Raku-like environment for virtual machines; it's designed to be a high-level way to create compilers and libraries for virtual machines (such as MoarVM and JVM) using Raku syntax.

<a id="nqp-%E6%98%AF%E7%94%A8%E4%BB%80%E4%B9%88%E8%AF%AD%E8%A8%80%E5%86%99%E7%9A%84%EF%BC%9F--what-language-is-nqp-written-in"></a>
## NQP 是用什么语言写的？ / What language is NQP written in?

NQP 是（1）NQP 代码的混合，（2）底层虚拟机使用的任何语言，（3）一些第三方 C 和 Java 库，（4）一些由构建过程的早期运行创建的引导文件。

NQP is a mixture of (1) NQP code, (2) whatever language the underlying virtual machine is using, (3) some third-party C and Java libraries, and (4) some bootstrapping files created by earlier runs of the build process.

<a id="raku-%E6%98%AF-lisp-%E5%90%97%EF%BC%9F--is-raku-lisp"></a>
## Raku 是 Lisp 吗？ / Is Raku Lisp?

```Raku
(not (not Nil))
```

<a id="%E6%88%91%E8%83%BD%E6%8A%8A%E6%88%91%E7%9A%84%E8%84%9A%E6%9C%AC%E7%BC%96%E8%AF%91%E6%88%90%E4%B8%80%E4%B8%AA%E7%8B%AC%E7%AB%8B%E7%9A%84%E5%8F%AF%E6%89%A7%E8%A1%8C%E6%96%87%E4%BB%B6%E5%90%97%EF%BC%9F--can-i-compile-my-script-to-a-standalone-executable"></a>
## 我能把我的脚本编译成一个独立的可执行文件吗？ / Can I compile my script to a standalone executable?

像 [`App::InstallerMaker::WiX`](https://modules.raku.org/dist/App::InstallerMaker::WiX) 这样的工具允许您创建一个安装程序来打包编译器和脚本。但是，当前可用的编译器还不支持创建独立的可执行文件。

Tools like [`App::InstallerMaker::WiX`](https://modules.raku.org/dist/App::InstallerMaker::WiX) allow you to create an installer that will package the compiler and your script. However, the currently available compilers do not support creating a standalone executable yet.

如果你想帮忙，*MoarVM* 后端的 *Rakudo* 编译器在 <https://github.com/MoarVM/MoarVM/issues/875> 已经开了 issue，作为讨论的地方。

If you wish to help out, the *Rakudo* compiler on *MoarVM* backend has <https://github.com/MoarVM/MoarVM/issues/875> issue opened as a place to discuss this problem.

<a id="raku-%E5%8F%91%E5%B8%83--raku-distribution"></a>
# Raku 发布 / Raku distribution

<a id="%E4%B8%8B%E4%B8%80%E4%B8%AA%E7%89%88%E6%9C%AC%E7%9A%84-rakudo-star-%E4%BB%80%E4%B9%88%E6%97%B6%E5%80%99%E5%8F%91%E5%B8%83%EF%BC%9F--when-will-the-next-version-of-rakudo-star-be-released"></a>
## 下一个版本的 Rakudo Star 什么时候发布？ / When will the next version of Rakudo Star be released?

Rakudo Star 通常每季度发布一次，发布公告张贴在 [rakudo.org](https://rakudo.org/posts) 上。

A Rakudo Star release is typically produced quarterly, with release announcements [posted on rakudo.org](https://rakudo.org/posts).

<a id="%E5%85%83%E9%97%AE%E9%A2%98%E5%92%8C%E5%AE%A3%E4%BC%A0--metaquestions-and-advocacy"></a>
# 元问题和宣传 / Metaquestions and advocacy

<a id="%E4%B8%BA%E4%BB%80%E4%B9%88-raku-%E6%9C%80%E5%88%9D%E8%A2%AB%E7%A7%B0%E4%B8%BA-perl-6%EF%BC%9F--why-was-raku-originally-called-perl-6"></a>
## 为什么 Raku 最初被称为 Perl 6？ / Why was Raku originally called Perl 6?

...与其他名字不一样的是，它并不意味着在其他语言中较大的数字的全部含义。

… As opposed to some other name that didn't imply all the things that the higher number might indicate on other languages.

简短的回答是，这是拉里在[规则 1](https://perldoc.perl.org/5.12.4/perlhack.html#DESCRIPTION) 下的选择。

The short answer is that it was Larry's choice under [Rule 1](https://perldoc.perl.org/5.12.4/perlhack.html#DESCRIPTION).

社区将 Perl 5 和 Raku 视为姐妹语言 - 他们有很多共同点，解决许多相同的问题空间，但 Raku 并不打算取代 Perl 5。事实上，这两种语言是相互配合的。

The community considers Perl 5 and Raku sister languages - they have a lot in common, address many of the same problem spaces, but Raku is not intended to replace Perl 5. In fact, both languages interoperate with each other.

<a id="raku-%E4%BB%80%E4%B9%88%E6%97%B6%E5%80%99%E5%87%86%E5%A4%87%E5%A5%BD%EF%BC%9F%E7%8E%B0%E5%9C%A8%E5%87%86%E5%A4%87%E5%A5%BD%E4%BA%86%E5%90%97%EF%BC%9F--when-will-raku-be-ready-is-it-ready-now"></a>
## Raku 什么时候准备好？现在准备好了吗？ / When will Raku be ready? Is it ready now?

编程语言及其编译器的准备与否不是一个非黑即白的决定。随着语言和实现的发展，它们越来越可用。根据您的需要，Raku 及其编译器对你而言可能准备好了，也可能没有准备好。

Readiness of programming languages and their compilers is not a binary decision. As the language and the implementations evolve, they grow steadily more usable. Depending on your needs, Raku and its compilers may or may not be ready for you.

也就是说，6.c 版本（2015 年圣诞节）是作为一种语言的 Raku 的第一个正式版本，以及一个验证套件和一个通过验证的编译器。

That said, version 6.c (Christmas 2015) is the first official release of Raku as a language, along with a validation suite and a compiler that passes it.

<a id="%E6%88%91%E4%B8%BA%E4%BB%80%E4%B9%88%E8%A6%81%E5%AD%A6-raku%EF%BC%9F%E5%AE%83%E6%9C%89%E4%BB%80%E4%B9%88%E5%A5%BD%E7%9A%84%EF%BC%9F--why-should-i-learn-raku-whats-so-great-about-it"></a>
## 我为什么要学 Raku？它有什么好的？ / Why should I learn Raku? What's so great about it?

Raku 将许多伟大的思想结合起来，这些思想通常在其他编程语言中找不到。虽然其他几种语言提供了其中的一些功能，但没有一种提供所有这些功能。

Raku unifies many great ideas that aren't usually found in other programming languages. While several other languages offer some of these features, none of them offer all of them.

- Raku 提供过程式、 面向对象和函数式的编程方法。
- 易于使用的一致语法，对数据结构使用不变的标记。 
- 基于全字素的 Unicode 支持，包括 Annex #29。
- 干净的，更可读的正则表达式；可用性提升一个级别，具有更多的功能。命名正则表达式提高了易用性。
- Junction 便于检查多种可能性；例如，`$a == 1|3|42`（`$a` 是否等于 1 或 3 或 42？）。
- 动态变量提供了全局变量的词法作用域替代方案。
- 强调可组成性和词汇范围界定，以防止“远距离行动”；例如，导入总是以词汇为范围。
- 易于理解的一致的作用域的规则和闭包。
- 强大的面向对象编程，具有类和角色（一切都可以看作是一个对象）。继承。子类。代码重用。
- 对物体和元物体的反省（海龟一直向下）。
- 允许元编程而不需要生成/解析代码的元对象协议。
- 子程序和方法签名，以便于解压缩位置参数和命名参数。
- 对具有不同签名的相同名称的子程序/方法进行多次调度，其依据是参数的个数、类型和可选的附加代码。
- 对未知子程序/不可能的调度的编译时错误报告。
- 可选的渐进式类型检查，无需额外的运行时费用。带有可选的类型注释。
- 基于编译器/运行时状态内省的高级错误报告。这意味着更有用、更精确的错误消息。
- 相位器（如 `BEGIN` / `END`）允许在进入/退出、第一次/最后一次/下一次遍历时和更多特殊上下文中执行代码。
- 用于隐式和显式并发处理的高级并发模型，远远超过原始线程和锁。Raku 的并发提供了一组丰富的（可组合的）工具。
- 多核计算机的使用越来越多，Raku 可以使用这些计算机要归功于并行性，隐式（例如，`>>`. 方法）和显式（`start { code }`）的。这一点很重要，因为摩尔定律即将结束..
- 提供结构化语言支持，以便为异步执行代码进行编程。
- Supply 使得在某件事发生时（如定时器、信号或文件系统事件）执行代码。
- `react` / `whenever` / `supply` 关键字允许方便地构建交互式、 事件驱动的应用程序.
- 在可能的情况下进行惰性求值，在需要或必要时进行急切的求值。这意味着，例如，存在懒惰列表，甚至无限懒惰列表，如 Fibonacci 序列，或所有素数。
- 原生数据类型可以更快地加工，更接近硬件速度。
- 使用 [NativeCall](https://docs.raku.org/language/nativecall) 使与 C / C++ 中的外部库交互变得相当容易。
- 使用 [Inline::Perl5](https://modules.raku.org/dist/Inline::Perl5:cpan:NINE) 和 [Inline::Python](https://modules.raku.org/dist/Inline::Python) 使得与 Perl 5 (CPAN) / Python 模组交互变得相当容易。 
- 可以同时安装和加载多个版本的模块。
- 由于更简单的更新/升级政策，简化了系统管理。
- 更简单的数值计算，不会因 [Rat](https://docs.raku.org/type/Rat) 而造成精度损失。
- 用于解析数据或代码的可扩展 grammar（Raku 用来解析自己）。
- Raku 是一种非常易变的语言（定义自己的功能、 操作符、 特性和数据类型，为您修改解析器）。
- 大量可供选择的数据类型，加上创建自己类型的可能性。
- 具有适当边界检查的多维形状和/或原生数组。
- 在语法解析过程中的任何时候执行代码，或在发生某种匹配时执行代码。
- 添加自定义运算符或添加特征就像编写子程序一样简单。
- 在任何操作符上自动生成超操作符（系统或自定义添加）。
- 在各种后端运行。目前为 MoarVM 与 JVM， JavaScript 正在开发中，更多的可能随之而来。
- 执行过程中热码路径的运行时优化（JIT）。
- 运行在小型（例如 RaspberryPi）和大型多处理器硬件上。
- 垃圾收集基础：没有及时销毁，所以没有必要重新计算。使用相位器及时采取行动。
- 方法可以在运行时混合到任何实例化对象中；例如，允许添加带外数据。
- `MAIN` 子程序可使用的简易命令行接口，具有多重分派函数和自动生成使用信息。
- 较少的代码行允许更紧凑的程序创建。哈夫曼编码命名允许更好的可读性。
- 用简单的迭代器接口定义的惰性列表，任何类都可以通过提供最简的一个方法来提供。
- Raku 的座右铭始终与 Perl 的口号相同：“Perl 是与众不同的。简而言之，Perl 是为了让轻松的工作变得容易，而不是让艰难的工作变得不可能” 和 “不止一种方法”。现在有了更多 - Ofun 加入进来。

- Raku offers procedural, object-oriented AND functional programming methodologies.
- Easy to use consistent syntax, using invariable sigils for data-structures.
- Full grapheme based Unicode support, including Annex #29.
- Clean, more readable regular expressions; taken to the next level of usability, with a lot more functionality. Named regular expressions improve ease of use.
- Junctions allowing easy checking of multiple possibilities; e.g., `$a == 1|3|42` (Is `$a` equal to 1 or 3 or 42?).
- Dynamic variables provide a lexically scoped alternative to global variables.
- Emphasis on composability and lexical scoping to prevent “action at a distance”; e.g., imports are always lexically scoped.
- Easy to understand consistent scoping rules and closures.
- Powerful object orientation, with classes and roles (everything can be seen as an object). Inheritance. Subtyping. Code-reuse.
- Introspection into objects and metaobjects (turtles all the way down).
- MetaObject Protocol allowing for metaprogramming without needing to generate / parse code.
- Subroutine and method signatures for easy unpacking of positional and named parameters.
- Multi dispatch for identically named subroutines/methods with different signatures, based on arity, types and optional additional code.
- Compile time error reporting on unknown subroutines / impossible dispatch.
- Optional gradual type-checking at no additional runtime cost. With optional type annotations.
- Advanced error reporting based on introspection of the compiler/runtime state. This means more useful, more precise error messages.
- Phasers (like `BEGIN` / `END`) allow code to be executed at scope entry / exit, loop first / last / next and many more special contexts.
- High level concurrency model, both for implicit as well as explicit multi-processing, which goes way beyond primitive threads and locks. Raku's concurrency offers a rich set of (composable) tools.
- Multiple-core computers are getting used more and more, and with Raku these can be used thanks to parallelism, both implicit (e.g., with the `>>`. method) and explicit ( `start { code }` ). This is important, because Moore's Law is ending.
- Structured language support is provided to enable programming for asynchronous execution of code.
- Supplies allow code to be executed when something happens (like a timer, or a signal, or a filesystem event).
- `react` / `whenever` / `supply` keywords allows easy construction of interactive, event driven applications.
- Lazy evaluation when possible, eager evaluation when wanted or necessary. This means, for example, lazy lists, and even infinite lazy lists, like the Fibonacci sequence, or all prime numbers.
- Native data types for faster, closer to the metal, processing.
- Interfacing to external libraries in C / C++ is fairly easy with [NativeCall](https://docs.raku.org/language/nativecall).
- Interfacing with Perl 5 (CPAN) / Python modules is fairly easy with [Inline::Perl5](https://modules.raku.org/dist/Inline::Perl5:cpan:NINE) and [Inline::Python](https://modules.raku.org/dist/Inline::Python)
- Can have multiple versions of a module installed and loaded simultaneously.
- System administration simplified due to simpler update/upgrade policies.
- Simple numeric computation without precision loss because of [Rat](https://docs.raku.org/type/Rat)s (rational numbers).
- Extensible grammars for parsing data or code (which Raku uses to parse itself).
- Raku is a very mutable language (define your own functions, operators, traits and data-types, which modify the parser for you).
- Large selection of data-types, plus the possibility to create your own types.
- Multi-dimensional shaped and/or native arrays with proper bounds checking.
- Execute code at any time during parsing of a grammar, or when a certain match occurred.
- Adding a custom operator or adding a trait is as simple as writing a subroutine.
- Automatic generation of hyper-operators on any operator (system or custom added).
- Runs on a variety of back-ends. Currently MoarVM & JVM, JavaScript in development, more may follow.
- Runtime optimization of hot code paths during execution (JIT).
- Runs on small (e.g., Raspberry Pi) and large multi-processor hardware.
- Garbage collection based: no timely destruction, so no ref-counting necessary. Use phasers for timely actions.
- Methods can be mixed into any instantiated object at runtime; e.g., to allow adding out-of-band data.
- Easy command-line interface accessible by `MAIN` subroutine with multiple dispatch and automated usage message generation.
- Fewer lines of code allow for more compact program creation. Huffman-coding of names allows for better readability.
- Lazy lists defined with a simple iterator interface, which any class can supply by minimally supplying a single method.
- Raku's mottos remain the same as they have been for Perl all along: “Perl is different. In a nutshell, Perl is designed to make the easy jobs easy, without making the hard jobs impossible.” and “There Is More Than One Way To Do It”. Now with even more -Ofun added.

<a id="raku-%E5%AF%B9%E6%88%91%E6%9D%A5%E8%AF%B4%E5%A4%9F%E5%BF%AB%E5%90%97%EF%BC%9F--is-raku-fast-enough-for-me"></a>
## Raku 对我来说够快吗？ / Is Raku fast enough for me?

这取决于你在做什么。Rakudo 的发展理念是“让它工作起来，然后让它快速工作。”对某些事情来说已经很快了，但需要为其他人工作。由于 Raku 为 JIT 提供了很多其他动态语言所没有的线索，我们认为我们将有很多改进性能的空间。

That depends on what you are doing. Rakudo has been developed with the philosophy of "make it work right then make it work fast." It's fast for some things already but needs work for others. Since Raku provides lots of clues to the JIT that other dynamic languages don't, we think we'll have a lot of headroom for performance improvements.

以下粗略的基准，加上所有关于这些事情的通常警告，表明如果包括大武器，即如果充分使用 Raku 特性，Raku 可以比 Perl 5 更快；同时，如果只使用一般的特性，Perl 5 可以更快。在将 Raku 语言与其他语言进行比较时，也可以观察到类似的情况。 

The following crude benchmarks, with all the usual caveats about such things, show that Raku can be faster than Perl 5 for similar tasks if the big weaponry is included, that is, if Raku features are used to its full extent; at the same time, Perl 5 can be faster if only the bare bones are included. Similar situation can be observed when comparing Raku to other languages.

在你的系统上试试。你可能会感到惊喜！

Try it on your system. You may be pleasantly surprised!

例如：

Examples:

```Raku
# Raku version 
use v6.c;
 
class Foo { has $.i is rw };
 
for 1..1_000_000 -> $i {
    my $obj = Foo.new;
    $obj.i = $i;
}
# Perl 5 version 
package Foo;
use Moose;
 
has i => (is => 'rw');
 
__PACKAGE__->meta->make_immutable;
 
for my $i (1..1_000_000) {
    my $obj = Foo->new;
    $obj->i($i);
}
 
1;
 
# Another Perl 5 version that offers bare-bones set of features 
# compared to Moose/Raku's version but those are not needed in this 
# specific, simple program anyway. 
package Foo;
use Mojo::Base -base;
 
has 'i';
 
for my $i (1..1_000_000) {
    my $obj = Foo->new;
    $obj->i($i);
}
 
1;
```

您可能也想使用这个程序来比较性能。它在两种语言下工作，只要 `perl -Mbigint` 被用于调用 Perl 5。

You might want to use this program for comparing performance, too. It works under both languages, as long as `perl -Mbigint` is used for invocation for Perl 5.

```Raku
my ($prev, $current) = (1, 0);
 
for (0..100_000) {
    ($prev, $current) = ($current, $prev + $current);
}
print $current;
```

从 [/language/faq](https://github.com/perl6/doc/blob/master/doc/Language/faq.pod6) 中生成. [Debug: 关闭]

Generated from [/language/faq](https://github.com/perl6/doc/blob/master/doc/Language/faq.pod6). [Debug: off]

这是一项正在进行的工作，记录 Raku 的文档（以前称为 Perl 6），并已知是不完整的。

This is a work in progress to document Raku (formerly known as Perl 6), and known to be incomplete.

[请报告任何问题](https://github.com/Raku/doc/blob/master/CONTRIBUTING.md#reporting-bugs)。感谢你的贡献。

[Please report any issues](https://github.com/Raku/doc/blob/master/CONTRIBUTING.md#reporting-bugs).Your contribution is appreciated.

本文件是根据 [Artistic License 2.0](https://raw.githubusercontent.com/Raku/doc/master/LICENSE) 的条款提供的。Camelia 图像是[版权 2009 年拉里沃尔]。](https://raw.githubusercontent.com/perl6/mu/master/misc/camelia.txt)

This documentation is provided under the terms of the [Artistic License 2.0](https://raw.githubusercontent.com/Raku/doc/master/LICENSE). The Camelia image is [copyright © 2009 by Larry Wall.](https://raw.githubusercontent.com/perl6/mu/master/misc/camelia.txt)
