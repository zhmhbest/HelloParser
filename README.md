# Parser

## Preparation for Flex &amp; Bison

- [cygwin](https://cygwin.com/install.html)
- [mingw-w64](https://sourceforge.net/projects/mingw-w64/files/mingw-w64/)
- [win32 flex](http://gnuwin32.sourceforge.net/packages/flex.htm)
- [win32 bison](http://gnuwin32.sourceforge.net/packages/bison.htm)

## Lexical analysis

It helps you to convert a sequence of characters into a sequence of tokens.

## Syntax analysis

The parser’s job is to figure out the relationship among the input tokens. A common way to display such relationships is a **parse tree**.

### Chomsky

$$G=(V_N, V_T, P, S)$$

- $V_N$: non-terminal symbol set
- $V_T$: terminal symbol set
- $P$: production set
- $S$: start symbol

| Type | Grammar | Restrict |
| -: | :- | :- |
| 0 | PSG(Phrase Structure Grammar)  | $∀α→β∈P$，$α$ contains at least one non-terminal character. |
| 1 | CSG(Context-Sensitive Grammar) | $∀α→β∈P$，$\vertα\vert≤\vertβ\vert$ |
| 2 | CFG(Context-Free Grammar)      | $∀α→β∈P$，$\vertα\vert≤\vertβ\vert$，$α∈V_N$ |
| 3 | RG(Regular Grammar)            | Right Linear：$A→w{\vert}wB$；Left Linear：$A→w{\vert}Bw$ |

### Top-Down

Starting from the beginning symbol, **derive** the given sentence according to the production rules.

- LL(1)

### Bottom-Up

**Reduce** from the given sentence to the beginning symbol of the grammar.

- LR(0)
- SLR(1)
- LALR(1)
- LR(1)
