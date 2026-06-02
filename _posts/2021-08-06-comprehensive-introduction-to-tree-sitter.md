---
layout: post
title: A Comprehensive Introduction to Tree-sitter
excerpt: >
  Tree-sitter is a parser generator tool and an incremental parsing library. It can build a concrete syntax tree for a
  source file and efficiently update the syntax tree as the source file is edited.
---

Check out the [tree-sitter](https://github.com/tree-sitter/tree-sitter) repo on GitHub and their
[documentation](https://tree-sitter.github.io/tree-sitter/) if you're unfamiliar with the project. TL;DR from the
GitHub repo:

> Tree-sitter is a parser generator tool and an incremental parsing library. It can build a concrete syntax tree for a
> source file and efficiently update the syntax tree as the source file is edited.

Tree-sitter allows you to write a [grammar.js](https://github.com/Shopify/tree-sitter-liquid/blob/main/grammar.js) file
that describes the grammar of a programming language. It generates a complete parser for your language with no
dependencies in a file called [src/parser.c](https://github.com/Shopify/tree-sitter-liquid/blob/main/src/parser.c). It
also generates bindings for various languages like
[Rust](https://github.com/tree-sitter/tree-sitter/blob/master/lib/binding_rust/README.md) and
[WASM](https://github.com/tree-sitter/tree-sitter/blob/master/lib/binding_web/README.md).

Use an [S-expression](https://en.wikipedia.org/wiki/S-expression) syntax to query the
[AST](https://tree-sitter.github.io/tree-sitter/creating-parsers#command-parse) from a tree-sitter parser. The
documentation includes a [playground](https://tree-sitter.github.io/tree-sitter/playground) where you can write code,
see the output AST, and query it with an S-expression.

**Try these out in the playground**

```ruby
# Code
class A
	def foo
    puts 'hi'
  end
end

A.new
A.foo
```

```scheme
(call method: (identifier) @function.name)
(constant) @constant
(method name: (identifier) @function.declaration)
[
  "def"
  "class"
  "end"
] @keyword
```

We can use [multiple parsers](https://tree-sitter.github.io/tree-sitter/using-parsers#multi-language-documents) on a
single source file because they work on ranges within a file. For example, a file that includes
[HTML](https://github.com/tree-sitter/tree-sitter-html),
[javascript](https://github.com/tree-sitter/tree-sitter-javascript),
[CSS](https://github.com/tree-sitter/tree-sitter-css), and [Liquid](https://github.com/Shopify/tree-sitter-liquid).

Tree-sitter is not an alternative to [language servers](https://microsoft.github.io/language-server-protocol/). They
serve a different purpose and have properties that make them better at some tasks than tree-sitter and properties that
make them worse at others. Generally speaking, tree-sitter works on a per-file basis and language servers work at the
project level. Language servers each have their dependencies and communicate via RPC with the client in the editor.
Tree-sitter has no dependencies and is much faster. It also provides an AST that allows arbitrary analysis.

## How does a tree-sitter Parser Work?

<div class="aspect-w-16 aspect-h-9">
  <iframe src="https://www.youtube-nocookie.com/embed/Jes3bD6P0To" title="YouTube video player" frameborder="0"
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
  allowfullscreen></iframe>
</div>

This section is taken from the Strange Loop Conference talk *Tree-sitter - a new parsing system for programming tools*
by Max Brunsfeld.

Tree-sitter is an incremental generalized left-right (GLR) Parser. Let's look at each term individually to understand
what they mean.

### What is an LR Parser?

An LR parser will read a line of text from left to right without any backtracking. The parser uses a lexer function to
read each character and group them into tokens. Then it uses a parse table to decide how to group those tokens into
trees.

Take the following program as an example, `x * y + z`. In grade school, math teachers instruct students about the order
of operations. They learn first to evaluate `x * y` and then add `z` to the result. A parser will convert the program
into a syntax tree for a computer to understand. The Figure 1 shows the parser at the start of the program. In Figure 2,
3, and 4 the parser pushes each token onto the stack. The vertical bar represents the location of the parser.


<figure class="flex flex-col flex-nowrap content-around">
  <img src="/assets/images/graphs/tree-sitter-parsing-program-0.svg" alt="Figure 1: Initial state of the parser.">
  <figcaption>{{ "***Figure 1: Initial state of the parser.***" | markdownify }}</figcaption>
</figure>

{%- assign figure-a =
  "/assets/images/graphs/tree-sitter-parsing-program-1.svg," | append:
  "/assets/images/graphs/tree-sitter-parsing-program-2.svg," | append:
  "/assets/images/graphs/tree-sitter-parsing-program-3.svg," | split: "," -%}

{%- assign figure-b =
  "/assets/images/graphs/tree-sitter-parsing-part-0.svg," | append:
  "/assets/images/graphs/tree-sitter-parsing-part-1.svg," | append:
  "/assets/images/graphs/tree-sitter-parsing-part-2.svg," | split: "," -%}

{%- assign captions =
  "***Figure 2: The state of the parser after it pushes the first token `x` onto the stack.***;" | append:
  "***Figure 3: The state of the parser after it pushes the second token `*` onto the stack.***;" | append:
  "***Figure 4: The state of the parser after it pushes the third token `y` onto the stack.***;" | split: ";" -%}

{% for i in (0..2) -%}
<figure class="flex flex-col flex-nowrap content-around">
  <img src="{{ figure-a[i] }}" alt="{{ captions[i] | replace_first: ":", "a:" }}">
  <div class="flex flex-row flex-nowrap items-center pl-8 sm:pl-16">
    <span class="font-bold text-2xl">Stack:</span>
    <img src="{{ figure-b[i] }}" alt="{{ captions[i] | replace_first: ":", "b:" }}">
  </div>
  <figcaption>{{ captions[i] | markdownify }}</figcaption>
</figure>
{%- endfor %}

The parse table will indicate that the parser needs to perform a different action when encountering the "+" token. The
reduction action tells the parser to pop tokens off the stack, group them into a tree, and push the tree back onto the
stack. Figure 5 below displays the stack after the reduction. Figure 6 and 7 show the parser pushing the rest of the
tokens onto the stack.

{%- assign figure-a =
  "/assets/images/graphs/tree-sitter-parsing-program-3.svg," | append:
  "/assets/images/graphs/tree-sitter-parsing-program-4.svg," | append:
  "/assets/images/graphs/tree-sitter-parsing-program-5.svg," | split: "," -%}

{%- assign figure-b =
  "/assets/images/graphs/tree-sitter-parsing-part-3.svg," | append:
  "/assets/images/graphs/tree-sitter-parsing-part-4.svg," | append:
  "/assets/images/graphs/tree-sitter-parsing-part-5.svg," | split: "," -%}

{%- assign captions =
  "***Figure 5: The state of the parser after the first reduce action. It pops each token off the stack and builds a tree.***;" | append:
  "***Figure 6: The state of the parser after it pushes the fourth token `+` onto the stack.***;" | append:
  "***Figure 7: The state of the parser after it pushes the fifth and final token `z` onto the stack.***;" | split: ";" -%}

{% for i in (0..2) %}
<figure class="flex flex-col flex-nowrap content-around">
  <img src="{{ figure-a[i] }}" alt="{{ captions[i] | replace_first: ":", "a:" }}">
  <div class="flex flex-row flex-nowrap items-center pl-8 sm:pl-16">
    <span class="font-bold text-2xl">Stack:</span>
    <img src="{{ figure-b[i] }}" alt="{{ captions[i] | replace_first: ":", "b:" }}">
  </div>
  <figcaption>{{ captions[i] | markdownify }}</figcaption>
</figure>
{% endfor %}

The parse table will indicate that the parser needs to perform a final reduction when it reaches the end of the program.
In Figure 8 the final syntax tree is the last element left on the stack.

<figure class="flex flex-col flex-nowrap content-around">
  <img src="/assets/images/graphs/tree-sitter-parsing-program-5.svg" alt="Figure 8a: The state of the parser after the final reduce action. It pops off the tokens of the preceding tree and constructs a new tree.">
  <div class="flex flex-row flex-nowrap items-center pl-8 sm:pl-16">
    <span class="font-bold text-2xl">Stack:</span>
    <img src="/assets/images/graphs/tree-sitter-parsing-part-6.svg" alt="Figure 8b: The state of the parser after the final reduce action. It pops off the tokens of the preceding tree and constructs a new tree.">
  </div>
  <figcaption>{{ "***Figure 8: The state of the parser after the final reduce action. It pops off the tokens of the
  preceding tree and constructs a new tree.***" | markdownify }}</figcaption>
</figure>

### What is a Generalized LR Parser?

A limitation of LR parsing comes from not being able to backtrack. It makes it hard to parse languages with ambiguity.

```javascript
x = (y);       // parenthesized expression
x = (y) => z;  // arrow function
```

GLR parsing is a technique to handle ambiguity in a language. It forks the parse stack into two branches so the parser
can try both interpretations.

Take the example of the arrow function above, `x = (y) => z`. Figure 9 displays the state of the parser right before we
fork the parse stack after reaching the identifier `y`. In Figure 10, 11, and 12 the forked parse stack independently
shows tokens pushed onto the stack and the reductions of the trees. Figure 13 shows the parser after chopping off the
invalid branch when it encountered the arrow token.

{%- assign captions =
  "Figure 9: The state of the parser after reaching the identifier `y`.;" | append:
  "Figure 10: The state of the parser after forking the parse stack.;" | append:
  "Figure 11: The state of the parser after both forks push the closing parenthesis onto the stack.;" | append:
  "Figure 12: The state of the parser after a reduction in the top branch.;" | append:
  "Figure 13: The state of the parser after chopping off the invalid branch when the arrow token was encountered.;" | split: ";" -%}

{% for i in (0..4) %}
  {% assign src = "/assets/images/graphs/tree-sitter-glr-" | append: i | append: ".svg" %}
  {% assign caption = captions[i] %}

  {% include figure.html src=src caption=caption %}
{% endfor %}

Tree-sitter also uses GLR parsing for error recovery. When typing in an editor, errors are present whenever the current
piece of code isn't complete. The following code snippets show two similar examples. First, we have a for statement with
an out-of-place keyword `if` after the keyword `for`. Second, we have an if statement with an out-of-place keyword `for`
before it. Using GLR parsing tree-sitter can build valid syntax trees for both examples with error nodes in the correct
place.

```c
for if (let x = 0; x < 5; x++) y()
```

{% include figure.html
  src="/assets/images/graphs/tree-sitter-glr-error-1.svg"
  caption="Figure 14: The syntax tree of the for statement showing the location of the invalid `if` keyword."
%}

```c
for if (x) y()
```

{% include figure.html
  src="/assets/images/graphs/tree-sitter-glr-error-0.svg"
  caption="Figure 15: The syntax tree of the if statement showing the location of the invalid “for” keyword."
%}

### What is Incremental Parsing?

> Tree-sitter can be embedded in text editors because it is fast enough to parse an entire file on every keystroke

An incremental parser will parse the program once. When editing, the parser does not have to parse the entire source
file again. It can use the position of the modified text and walk the current syntax tree. As it walks the tree, it
marks the nodes that contain the location of the modified text. It starts in an empty state and reuses the nodes of the
previous tree that haven't changed in the new tree.

Suppose we change the following code to add a new argument d to the method call c. The nodes highlighted in green are
the nodes marked by the parser. The parser can reuse all the other nodes in the tree

```javascript
var a = new B();
a.c(d);
//  ^
//  The modification.
return a;
```

{% include figure.html
  src="/assets/images/graphs/tree-sitter-incremental-1.svg"
  caption="Figure 16: The syntax tree of the program after the edit, highlighting nodes that are marked by tree-sitter.
  It is a pseudocode equivalent for a diagram and not an accurate representation of the tree built by tree-sitter."
%}

## How to build a parser

You can find everything you need to build a parser with tree-sitter in the
[documentation](https://tree-sitter.github.io/tree-sitter/creating-parsers). The next section walks through an example
to help get a head start on creating a parser. Find the source code for the full parser on
[GitHub](https://github.com/DerekStride/tree-sitter-math).

Find the test files in the `test/corpus` directory. The other file we need to modify is `grammar.js`. Below you'll find
the code to declare that an expression can be either a number or a variable.

```javascript
module.exports = grammar({
  name: 'math',

  rules: {
    expression: $ => $._expression,
    _expression: $ => choice(
      $.variable,
      $.number,
    ),

    number: _ => /\d+(\.\d+)?/,
    variable: _ => /([a-zA-Z$][0-9a-zA-Z_]*)/,
  }
});
```

Note: the line expression: `$ => $._expression` will allow us to keep the syntax tree cleaner. A Node whose name begins
with an underscore is anonymous and not part of the final syntax tree.

To support addition, define a new node called `sum`.

```javascript
sum: $ => prec.left(
  seq(
    field("left", $._expression),
    "+",
    field("right", $._expression),
  ),
),
```

The `prec.left` function tells tree-sitter how to resolve ambiguities that arise from multiple additions. It's telling
the parser to evaluate sums left to right. Below is the error message tree-sitter would output without adding the
precedence function. Take the equation `x + y + z`, in the possible interpretations below the first means `(x + y) + z`
and the second means `x + (y + z)`. Since addition is [commutative](https://en.wikipedia.org/wiki/Commutative_property)
we could have also chosen `prec.right`.

```
Unresolved conflict for symbol sequence:

  _expression '+' _expression • '+' …

Possible interpretations:

  1: (sum _expression '+' _expression) • '+' …
  2: _expression '+' (sum _expression • '+' _expression)
```

A source of error arises if we try to add support for multiplication. Suppose we add the following node product. In the
equation `z + x * y`, we would output the wrong syntax tree.

```javascript
product: $ => prec.left(
  seq(
    field("left", $._expression),
    "*",
    field("right", $._expression),
  ),
),
```

The following code snippet is a tree-sitter test. The test name lives between a header denoted by equal signs. Following
the header is the source code and the expected tree separated by dashes. Given the code examples above, the tree-sitter
test below would fail. The reason the test fails is that multiplication and addition have the same precedence.

```
=========================
Multiplication & addition
=========================

z + x * y

-------------------------

(expression
 (sum
  left: (variable)
  right: (product
    left: (variable)
    right: (variable))))
```

By default, every rule in our grammar has a precedence of 0. We could increase the precedence of multiplication to 1.
However, the cleaner solution is to attach a name to our levels of precedence. Define precedences at the start of the
module before we define our rules. Then add those names as the first argument to our precedence functions. Check out
this [commit](https://github.com/DerekStride/tree-sitter-math/commit/5a6f4549aafe325e33b9d9ed967c61d70177f06a) for a
cleaner diff.

```diff
+ precedences: _ => [
+   [
+     "multiplication",
+     "addition",
+   ],
+ ],

sum: $ => prec.left(
+  "addition",

product: $ => prec.left(
+  "multiplication",
```

Now rules, ambiguities, and precedence should make more sense. Be sure to check out the [GitHub
repo](https://github.com/DerekStride/tree-sitter-math) for a reference implementation of the order of operations for
addition, subtraction, multiplication, division, exponents, and parenthesized expressions.

## How to interact with the AST

Use the S-expression query syntax to interact with a syntax tree produced by a tree-sitter parser. The S-expressions can
define capture groups. Use these captures as the base unit of work. A piece of code that works with captures is language
agnostic. For example, tree-sitter can be used for faster and semantically correct syntax highlighting. In neovim, you
can specify captures to change the parser used for highlighting. Tree-sitter can provide syntax highlighting for
languages other than that of the open file.

For example, see this [pull request](https://github.com/nvim-treesitter/nvim-treesitter/pull/1190) to nvim-treesitter.
Nvim-treesitter uses the capture groups `@content` and `@language` to specify injected code and its language for syntax
highlighting. In ruby, if a heredoc contains code it's common to delimit the heredoc with tags indicating the language
contained in the string. Here is an example:

```ruby
MY_HTML = <<~HTML
  <title>This is a title</title>
  <div class="example-class">
    <span>This is a span</span>
  </div>
HTML
```

The [pull request](https://github.com/nvim-treesitter/nvim-treesitter/pull/1190) mentioned above added a variant of the
simplified query below. It defined the `@content` and `@language` capture groups for ruby. It was easy to add support
for a new language because the code performing syntax highlighting works on the capture groups.

[Syntax highlighting](https://tree-sitter.github.io/tree-sitter/syntax-highlighting) is not the only superpower of
tree-sitter. Structural editing of source code is easy with access to a syntax tree. I highly recommend neovim users
checkout [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter). At the time of writing this post, that
project enables novel features and performance improvements on existing vim features. Other plugins exist that allow
even more control of the syntax tree like
[nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) and
[nvim-treesitter-refactor](https://github.com/nvim-treesitter/nvim-treesitter-refactor).

## The future of editing code

The tools used to edit source code continue to get more sophisticated. Features that once
only lived in custom-built interactive development environments (IDEs) are making their way into lightweight
alternatives like VSCode and Vim. Language Servers bring the IDE experience to any editor with an LSP client.
Tree-sitter allows language-agnostic tools to be powered by querying its syntax trees. Tree-sitter is a step in the
right direction.

The ability for a developer to translate their thoughts into code, reorganize it, and refactor it relies on great tools
like tree-sitter.
