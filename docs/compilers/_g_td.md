
#### 左递归问题

**左递归产生**：

对于产生式$P → Pa$，可能产生：

```mermaid
graph TD
    S((S));
    L0["..."]; P0((P));  R0["..."];
    P1((P));  R1["..."];
    P2((P));  R2["..."];
    style S  stroke: SpringGreen;
    style L0 stroke: SpringGreen;
    style R0 stroke: Gray;
    style P0 stroke: SpringGreen;
    style P1 stroke: SpringGreen;
    style R1 stroke: Gray;
    style P2 stroke: SpringGreen;
    style R2 stroke: Gray;

    S --> L0; S --> P0; S --> R0;
    P0 --> P1; P0 --> R1;
    P1 --> P2; P1 --> R2;
```

**左递归消除**：

| 产生式                                                       | 处理                                                         | 说明           |
| :----------------------------------------------------------- | :----------------------------------------------------------- | :------------- |
| $P → Pα {\ \vert\ } β$                                       | $P → βP'$<br>$P'→αP' {\ \vert\ } ε$                          | 直接左递归改右递归 |
| $P → Pα_1 {\ \vert\ } \cdots {\ \vert\ } Pα_m {\ \vert\ } β_1 {\ \vert\ } \cdots {\ \vert\ } β_n$ | $P → β_1P' {\ \vert\ } \cdots {\ \vert\ } β_nP'$<br>$P' → α_1P' {\ \vert\ } \cdots {\ \vert\ } α_mP' {\ \vert\ } ε$ | 直接左递归改右递归 |
| $S → Qc {\ \vert\ } c$<br>$Q → Rb {\ \vert\ } b$<br>$R → Sa {\ \vert\ } a$ | $S → Sabc {\ \vert\ } abc {\ \vert\ } bc {\ \vert\ } c$ | 间接左递归代入改直接左递归 |

#### 回溯问题

**回溯产生**：

有产生式集合$\{ S → xAy, A → ** | * \}$，分析输入串$x * y$：

<div style="display: flex; flex-direction: row; text-align: center"><div>

第1次试图匹配$**$失败

```mermaid
graph TD
    S((S)); x((x)); A((A));  y((y));
    *1((*)); *2((*));
    style S  stroke: SpringGreen;
    style x  stroke: SpringGreen;
    style A  stroke: SpringGreen;
    style *1 stroke: SpringGreen;
    style *2 stroke: Red;
    style y  stroke: Gray;

    S --> x; S --> A; S --> y;
    A --> *1; A --> *2;
```
</div><div>

第2次试图匹配$*$成功

```mermaid
graph TD
    S((S)); x((x)); A((A));  y((y));
    *1((*));
    style S  stroke: SpringGreen;
    style x  stroke: SpringGreen;
    style A  stroke: SpringGreen;
    style *1 stroke: SpringGreen;
    style y  stroke: SpringGreen;

    S --> x; S --> A; S --> y;
    A --> *1;
```
</div></div>

<!-- End Row Mermaid -->

**首符集**：

定义终结符首符集$FIRST(A)$为：

$$FIRST(A) = \{a {\ \bold|\ } A ⇒ a..., a∈V_T \}$$

若有$A⇒ε$，则规定$ε∈FIRST(A)$

**回溯避免**：

| 产生式                                                       | 限制 / 处理                                                  | 说明                                     |
| :----------------------------------------------------------- | :----------------------------------------------------------- | :--------------------------------------- |
| $A → a_1 {\ \vert\ } a_2 {\ \vert\ } \cdots {\ \vert\ } a_n$ | $FIRST(A_i) ∩ FIRST(A_j) = \emptyset$                        | $A$可以根据首符准确指派候选        |
| $A → δβ_1 {\ \vert\ } \cdots {\ \vert\ } δβ_n {\ \vert\ } γ_1 {\ \vert\ } \cdots {\ \vert\ } γ_m$ | $A → δA' {\ \vert\ } γ_1 {\ \vert\ } \cdots {\ \vert\ } γ_m$<br/>$A' → β_1 {\ \vert\ } \cdots {\ \vert\ } β_n$ | 通过反复提取左因子<br>使首符集两两不相交 |

#### 候选式冲突问题

**后续集**：

$S$为文法开始符号，定义非终结符跟随集$FOLLOW(A)$为：

$$FOLLOW(A) = \{ a {\ \bold|\ } S ⇒ ...Aa..., a∈V_T \}$$

$FOLLOW(A)$为可能在某些句型中紧跟在$A$后边的终结符号集合。

**后续集的作用**：

- $S → aA$
- $S → d$
- $A → bAS$
- $A → ε$

$FIRST(S) = \{ a, d \}$、$FIRST(A) = \{ b, ε \}$、$FLLOW(A) = \{ a, d \}$

输入$abd$有：

```mermaid
graph TD
    S((S)); a0((a)); A0((A));
    b1((b)); A1((A)); S1((S));
    ε2((ε)); d2((d));
    style S  stroke: SpringGreen;
    style a0 stroke: SpringGreen;
    style A0 stroke: SpringGreen;
    style b1 stroke: SpringGreen;
    style A1 stroke: SpringGreen;
    style S1 stroke: SpringGreen;
    style ε2 stroke: Orange;
    style d2 stroke: SpringGreen;

    S --> a0; S --> A0;
    A0 --> b1; A0 --> A1; A0 --> S1;
    A1 --> ε2;
    S1 --> d2;
```

在推出$A → ε$这一步，$d$不在$FIRST(A)$中，此时必须满足$d$在$FLLOW(A)$中

**候选冲突**：

- $S → aA$
- $S → d$
- $A → bAS$
- $A → d$
- $A → ε$

$FIRST(S) = \{ a, d \}$、$FIRST(A) = \{ b, d, ε \}$、$FLLOW(A) = \{ a, d \}$

输入$abd$有：

```mermaid
graph TD
    S((S)); a0((a)); A0((A));
    b1((b)); A1((A)); S1((S));
    ε2((ε)); d2((d));
    style S  stroke: SpringGreen;
    style a0 stroke: SpringGreen;
    style A0 stroke: SpringGreen;
    style b1 stroke: SpringGreen;
    style A1 stroke: SpringGreen;
    style S1 stroke: SpringGreen;
    style ε2 stroke: Red;
    style d2 stroke: Red;

    S --> a0; S --> A0;
    A0 --> b1; A0 --> A1; A0 --> S1;
    A1 -.-> ε2; A1 -.-> d2;
    S1 -.-> d2;
```

**冲突避免**：

当产生式含有$A → ε$时，应满足$FIRST(A) ∩ FLLOW(A) = \emptyset$。

#### LL(1)文法

**命名说明**：

|       | 说明                             |
| ----: | :------------------------------- |
|   $L$ | 从左向右扫描输入                 |
|   $L$ | 产生最左推导                     |
| $(1)$ | 最多预看一个符号即可决定分析动作 |

**文法要求**：

| 解决的问题 | 具体要求                                                     |
| ---------: | :----------------------------------------------------------- |
| 左递归问题 | 文法不含左递归                                               |
|   回溯问题 | 对于非终结符$A$的任意两个产生式$A_i$和$A_j$，若两者均不能直接推出$ε$，则应满足$FIRST(A_i) ∩ FIRST(A_j) = \emptyset$ |
| 候选是冲突 | 若存在$A → ε$，则$FIRST(A) ∩ FLLOW(A) = \emptyset$           |
