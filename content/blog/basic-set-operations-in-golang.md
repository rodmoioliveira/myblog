+++
title = "Basic set operations in Golang"
description = "Sets are a fundamental mathematical construct and serve as a convenient data structure when writing computer programs. As an abstract data type, sets are a missing feature in the Go language. However, they can be easily implemented with maps."
date = 2021-11-29
slug = "basic-set-operations-in-golang"
draft = false
[extra]
references = "content/blog/basic-set-operations-in-golang.bibtex"
katex_enable = true
katex_auto_render = true
+++

### What are sets?

In mathematics, a set is a collection of unique and unsorted elements. The
conventional way to write down a set is to list the elements inside curly
braces, like this \\( \\\{ 1,2,3 \\\} \\). The elements inside a set should only
appear once, because any element is either in the set or not. This means that the
sets \\( \\\{ \text{dog}, \text{dog}, \text{cat} \\\} \\) and \\( \\\{
\text{dog}, \text{cat} \\\} \\) are equal. Also, the order of the elements
inside a set is meaningless, so \\( \\\{ a,b,c \\\} \\) and \\( \\\{ c,b,a \\\}
\\) are the same set written in two different ways.

Sets are a fundamental mathematical construct and serve as a convenient data
structure when writing computer programs. Some languages implement sets by
default. But in others, like Go, you have to implement yourself.

### Abstract Data Type

As an [abstract data type](https://en.wikipedia.org/wiki/Abstract_data_type),
sets are a missing feature in the Go language. However, they can be easily
implemented with [maps](https://tour.golang.org/moretypes/19). Let's
implement the `Set` type with three methods: `MakeSet` to create new sets,
`Size` to get the set's cardinality and, `ToString` to print its string
representation:

```go
package main

import (
	"fmt"
	"strings"
)

type (
	SetItem    interface{}
	SetSlice   []SetItem
	Set        map[SetItem]membership
	membership struct{}
)

func MakeSet(si ...SetItem) (s Set) {
	s = make(map[SetItem]membership)

	for _, v := range si {
		s[v] = membership{}
	}

	return
}

func (s Set) Size() int {
	return len(s)
}

func (s Set) ToString() string {
	r := make([]string, 0, s.Size())

	for k := range s {
		r = append(r, fmt.Sprintf("%v", k))
	}

	return fmt.Sprintf("{%v}", strings.Join(r, ","))
}
```

Now that we have a minimal implementation for the `Set` type, we can create a
new set and print its elements like this:

```go
set := MakeSet("cat", "cat", "frog", "dog", "cow")
fmt.Println(set.ToString()) // {frog,dog,cow,cat}
fmt.Println(set.ToString()) // {dog,cow,cat,frog}
```

As you can see, all the duplicate elements were removed from the set, and its
elements were printed inside curly braces in arbitrary order.

### Basic set operations

We'll implement some basic set operations in Golang, such as **membership**
assertion, **union**, **intersection**, **difference**, **symmetric
difference**, and **subset** assertion.  Along the way, we'll provide the
mathematical definition for each one of those operations to better understand
them.

#### Membership

The most simple set operation is to assert element membership. The expression
\\( e \in A \\) asserts that \\(e\\) is an element of the set \\(A\\). The
expression \\(y \notin A \\) means that \\(y\\) is not an element of the set
\\(A\\). Let's write a method called `Contains` for the `Set` type to verify if
any given element belongs to it:

```go
func (s Set) Contains(si SetItem) (ok bool) {
	_, ok = s[si]

	return
}
```

Now let's build a new set and test for membership:

```go
set = MakeSet("cat", "dog", "cow")

ok := set.Contains("cat")
fmt.Println(ok) // true

ok = set.Contains("buffalo")
fmt.Println(ok) // false
```

Easy peasy, let's continue.

#### Union

The union of sets \\( A \\) and \\( B \\), denoted by the expression \\( A \cup
B \\), is the set that includes exactly the elements appearing in \\( A \\) or
\\( B \\) or both. And it could be written in [set-builder
notation](https://www.mathsisfun.com/sets/set-builder-notation.html) as:

\\[ A \cup B = \\\{x : x \in A \ \text{or} \  x \in B\\\} \\]

Let's create a `Union` method for the `Set` type to compute the union of two
sets:

```go
func (s Set) Union(other Set) (set Set) {
	set = MakeSet()

	for k := range s {
		set[k] = membership{}
	}

	for k := range other {
		set[k] = membership{}
	}

	return
}
```

The result of the union of two sets \\( A = \\\{ \text{cat}, \text{dog},
\text{cow} \\\} \\) and \\( B = \\\{ \text{cat}, \text{duck}, \text{bull} \\\}
\\) can be expressed as \\( A \cup B = \\\{
\text{cat},\text{dog},\text{cow},\text{duck},\text{bull} \\\} \\). Let's test
our implementation:

```go
A := MakeSet("cat", "dog", "cow")
B := MakeSet("cat", "duck", "bull")

U := A.Union(B)
fmt.Println(U.ToString())
// {cat,dog,cow,duck,bull}
```

So far so good?

#### Intersection

The intersection of \\( A \\) and \\( B \\), denoted by the expression \\( A
\cap B \\), is a set of all elements that appear in both \\( A \\) and \\( B
\\). And it could be written in set-builder notation as:

\\[ A \cap B = \\\{x : x \in A\ \text{and} \ x \in B\\\} \\]

Let's implement an `Intersection` method for the `Set` type to yield the
elements of the intersection of two sets:

```go
func (s Set) Intersection(other Set) (set Set) {
	set = MakeSet()

	for k := range s {
		if ok := other.Contains(k); ok {
			set[k] = membership{}
		}
	}

	return
}
```

The result of the intersection of the sets \\( A = \\\{ \text{cat}, \text{dog},
\text{cow} \\\} \\) and \\( B = \\\{ \text{cat}, \text{duck}, \text{bull} \\\}
\\) can be presented as \\( A \cap B = \\\{ \text{cat} \\\} \\). In our Go code,
that operation is expressed as follows:

```go
A = MakeSet("cat", "dog", "cow")
B = MakeSet("cat", "duck", "bull")

I := A.Intersection(B)
fmt.Println(I.ToString())
// {cat}
```

It works just as expected.

#### Difference and Complement

The difference of \\( A \\) and \\( B \\), or the complement of \\( B \\) in \\(
A \\), denoted by the expression \\( A \setminus B \\), is a set of all elements
that appear in \\( A \\) but not in \\( B \\). And it could be written in
set-builder notation as:

\\[ A \setminus B = \\\{x : x \in A\ \text{and} \ x \notin B \\\} \\]

Let's write a `Difference` method for the `Set` type to compute the difference
between two sets:

```go
func (s Set) Difference(other Set) (set Set) {
	set = MakeSet()

	for k := range s {
		if ok := other.Contains(k); !ok {
			set[k] = membership{}
		}
	}

	return
}
```

The result of the difference of the sets \\( A = \\\{ \text{cat}, \text{dog},
\text{cow} \\\} \\) and \\( B = \\\{ \text{cat}, \text{duck}, \text{bull} \\\}
\\) can be written as \\( A \setminus B = \\\{\text{dog}, \text{cow} \\\} \\).
Let's check if our code is correct:

```go
A = MakeSet("cat", "dog", "cow")
B = MakeSet("cat", "duck", "bull")

D := A.Difference(B)
fmt.Println(D.ToString())
// {dog,cow}
```

Perfect!

#### Symmetric Difference

The symmetric difference of \\( A \\) and \\( B \\), denoted by the expression
\\( A \ominus B \\), is a set of all elements that appear in \\( A \\) or in
\\( B \\) but not in both. And it could be written in set-builder notation as:

\\[ A \ominus B = \\\{ x : x \in A \setminus B \text{ or} \in B \setminus A \\\}
\\]

Let's write a `SymmetricDifference` method for the `Set` type to compute the
symmetric difference between two sets:

```go
func (s Set) SymmetricDifference(other Set) (set Set) {
	set = MakeSet()

	for k := range s {
		if ok := other.Contains(k); !ok {
			set[k] = membership{}
		}
	}

	for k := range other {
		if ok := s.Contains(k); !ok {
			set[k] = membership{}
		}
	}

	return
}
```

The result of the symmetric difference of the sets \\( A = \\\{ \text{cat},
\text{dog}, \text{cow} \\\} \\) and \\( B = \\\{ \text{cat}, \text{duck},
\text{bull} \\\} \\) can be defined as \\( A \ominus B = \\\{ \text{dog},
\text{cow}, \text{duck}, \text{bull} \\\} \\). Let's try it in our code:

```go
A = MakeSet("cat", "dog", "cow")
B = MakeSet("cat", "duck", "bull")

SD := A.SymmetricDifference(B)
fmt.Println(SD.ToString())
// {dog,cow,duck,bull}
```

Great!

#### Subset

The expression \\( A \subseteq B \\) indicates that set \\( A \\) is a subset of
set \\( B \\), which means every element of \\( A \\) is also an element of
\\( B \\). It could be written in set-builder notation as:

\\[ A \subseteq B \iff A \cap B = A \\]

Let's implement a `SubsetOf` method for the `Set` type to assert if a given set
is a subset of another set:

```go
func (s Set) SubsetOf(other Set) bool {
	if s.Size() > other.Size() {
		return false
	}

	for k := range s {
		if _, exists := other[k]; !exists {
			return false
		}
	}

	return true
}
```

For the sets \\( A = \\\{ \text{cat}, \text{dog}, \text{cow} \\\} \\) and \\( B
= \\\{ \text{cat}, \text{dog} \\\} \\), we can assert that \\( B \subseteq A \\)
is \\( \text{true} \\), but \\( A \subseteq B \\) is \\( \text{false} \\). Let's test it:

```go
A = MakeSet("cat", "dog", "cow")
B = MakeSet("cat", "dog")

fmt.Println(B.SubsetOf(A)) // true
fmt.Println(A.SubsetOf(B)) // false
```

Mission accomplished! Due to that, we had implemented the basic set operations
supported for sets as an abstract data type. All the code for this
implementation can be found in this
[gist](https://gist.github.com/rodmoioliveira/65281facd4117c37957a2373c5323892).
Now we can get familiar with some fundamental set properties that we should be
aware of.

### Set Identities

Sets have some properties that hold true for all subsets of any given set. These
properties are called set identities and are presented down below. In the
following examples, consider that the sets \\( A \\), \\( B\\), \\( C \\) are
subsets of a universal set \\( U \\).

#### Antisymmetric

A binary relation \\(R\\) on a set \\(A\\) is antisymmetric if there is no pair
of distinct elements of \\(A\\) each of which is related by \\(R\\) to the
other. More formally, \\(R\\) is antisymmetric precisely if:

\\[ \forall (x,y) \in A:(xRy \text{ and } yRx) \Rightarrow x = y \\]

For sets, the subset relation is antisymmetric:

\\[ A \subseteq B \text{ and }  B \subseteq A \Rightarrow A = B \\]

#### Associative

Associativity is a property of some binary operations, which means that
rearranging the parentheses in an expression will not change the result. Union
and intersection are associative:

\\[ A \cup \left( {B \cup C} \right) = \left( {A \cup B} \right) \cup C \newline
A \cap \left( {B \cap C} \right) = \left( {A \cap B} \right) \cap C \\]

#### Commutative

A binary operation is commutative if changing the order of the operands does not
change the result. Union and intersection are commutative:

\\[ A \cup B = B \cup A \newline A \cap B = B \cap A \\]

#### Complement

In set theory, the complement of a set \\( A \\), denoted by \\( A^c \\), is a
set of all the elements that aren't in \\( A \\):

\\[ A \cup {A ^ c} = U \newline A \cap {A ^ c} = \varnothing \newline {U ^ c} =
\varnothing \newline {\varnothing ^ c} = U \\]

#### De Morgan's Laws

De Morgan's Laws describe how mathematical statements and concepts are related
through their opposites, which explain how to distribute NOT's(\\(\neg\\)) over
AND's(\\(\\land\\)) and OR's(\\(\lor\\)):

\\[ \neg (P \land Q) \iff  (\neg P) \lor (\neg Q) \newline \neg (P \lor Q) \iff
(\neg P) \land (\neg Q) \\]

In set theory, De Morgan's Laws relate the intersection and union of sets
through complements:

\\[ ( A \cup B )^c = A^c \cap B^c \newline ( A \cap B )^c = A^c \cup B^c \\]

#### Distributive

The distributive property tells us how to solve expressions in which more than
one binary relation is involved. For example, given a set \\( A \\) and two
binary operators \\( * \\) and \\( + \\) on \\( A \\), the distributive law
asserts that multiplication (\\( * \\)) distributes over addition (\\( + \\)) in
elementary arithmetic:

\\[ x * (y + z) = x * y + x * z \\]

For sets, intersection distributes over union and vice-versa:

\\[ A \cup \left( {B \cap C} \right) = \left( {A \cup B} \right) \cap \left( {A
\cup C} \right) \newline A \cap \left( {B \cup C} \right) = \left( {A \cap B}
\right) \cup \left( {A \cap C} \right) \\]

#### Double Complement

The complement of the complement of a set \\( A \\) is itself \\( A \\):

\\[ ( A^c )^c = A \\]

#### Idempotent

Idempotence is the property of certain operations in mathematics whereby they
can be applied multiple times without changing the result beyond the initial
value:

\\[ A \cup A = A \newline A \cap A = A \\]

#### Identity

The empty set (\\( \varnothing \\)) is the identity operand for unions, and the
universal set (\\( U \\)) is the identity operand for intersections:

\\[ A \cup \varnothing = A \newline A \cap U = A \\]

#### Transitive

In mathematics, a relation \\(R\\) on a set \\(A\\) is transitive if, for all
elements \\(a\\), \\(b\\), \\(c\\) in \\(A\\), whenever \\(R\\) relates \\(a\\)
to \\(b\\) and \\(b\\) to \\(c\\), then \\(R\\) also relates \\(a\\) to \\(c\\):

\\[ \forall (a,b,c) \in A:(aRb \text{ and } bRc) \Rightarrow aRc \\]

For sets, the subset relation is transitive:

\\[ ( A \subseteq B ) \text{ and } ( B \subseteq C ) \Rightarrow  ( A \subseteq
C ) \\]

### Counting bit sequences

Sets are great for counting things because we can establish relations between
different sets, which can be useful to count infinite sets. If we could find
relationships between countable things, we can transform otherwise tough
problems into trivial operations. For instance, there's a clever way to count
the number of n-bit sequences that can be yielded from utilizing an n-bit unit
of data. Therefore, questions like how many values a 64-integer type can
represent are easily answered.

To understand how it works, we have to comprehend the following mathematical
concepts within set theory: **cardinality**, **product of sets**, **power
sets**, and **bijections**.

#### Cardinality

The cardinality or size of a set \\(A\\), denoted \\(|A|\\), is the number of
elements in \\(A\\) when that number is finite:

\\[ A = \\\{0,1\\\} \Rightarrow |A| = 2 \\]

Easy enough, right?

#### Product of sets

The cross product of two sets \\(A\\) and \\(B\\), denoted \\(A \times B\\), is
the set of all ordered pairs of elements in \\(A\\) and elements in \\(B\\):

\\[ A \times B = \\\{(a,b) : a \in A \text{ and } b \in B\\\} \\]

A product of \\(n\\) copies of a set \\(A\\) is denoted \\(A^n\\):

\\[ A^n = \\\{(a_1, \cdots, a_n) : a_i \in A \text{ for every } i \\\} \\]

The cardinality of the cross product of sets is calculated by these rules:

\\[ \begin{align*} |A \times B| &= |A||B| \newline |A^{n}| &= |A|^n \end{align*} \\]

For example, the cross product of the sets \\( A = \\\{a,b\\\} \\) and \\( B =
\\\{1,2,3\\\} \\), denoted \\(A \times B\\), is equal to:

\\[ \\\{ (a,1),(a,2),(a,3),(b,1),(b,2),(b,3) \\\} \\]

Which is not the same that the cross product of \\( B \times A \\):

\\[ \\\{ (1,a), (1,b), (2,a), (2,b), (3,a), (3,b) \\\} \\]

#### Power Set

The power set of the set \\(A\\), denoted \\( \mathcal{P}(A) \\), is the set of
all the subsets \\(B\\) in the set \\(A\\):

\\[ \mathcal{P}(A) = \\\{B : B \subseteq A  \\\} \\]

Here's an example for the set \\( L = \\\{ \text{bat}, \text{frog} \\\} \\):

\\[ \mathcal{P}(L) = \\\{ \varnothing, \\\{\text{bat} \\\}, \\\{\text{frog} \\\},
\\\{\text{bat}, \text{frog} \\} \\\} \\]

The cardinality of the power sets of any given set \\(A\\) is defined as
\\(|\mathcal{P}(A)| = 2^{|A|}\\).

#### Bijection

A bijection is a function between the elements of two sets, where each element
of one set is paired with exactly one element of the other set. A bijective
function mean that the sets being mapped have the same cardinality:

\\[ \text{if } f : A \rightarrow B \text{ is a bijection } \Rightarrow |A| = |B|
\\]

#### Counting subsets of a finite set

As a consequence of the bijection rule above, and the cardinalities of power
sets and product sets, we can demonstrate that there's a bijection that maps the
elements of \\( \mathcal{P}(A) \\) to elements in \\( \\\{0,1\\\}^n \\), the
product set of n-bit sequences. More formally, we want to prove that power sets
and product sets have the same cardinality:

\\[ |A| = n  \implies | \mathcal{P}(A) | = | \\\{0,1\\\}^n | =
2^{n} \\]

And that there's a bijection between them:

\\[ \mathcal{P}(A) \text{ bij } \\\{0,1\\\}^n \\]

\\( \text{Prove:} \\) Let \\( a_1,a_2, \cdots, a_n \\) be the elements of \\( A
\\). The bijection that maps each subset \\( S \subseteq A \\) to the bit
sequence \\( (b_1, \cdots, b_n) \\) is defined by the rule:

\\[\tag{1.0} a_i \in S \iff  b_i = 1\\]

Therefore, if \\(n = 3\\), then the subset \\(\\\{a_2,a_3\\\}
\subseteq A \\) maps to a 3-bit sequence as follows:

\\[ \begin{aligned}
		a_1			\notin  \\\{ a_2,a_3 \\\} \iff b_1    = 0 \newline
	  a_2 		\in		  \\\{ a_2,a_3 \\\} \iff b_2    = 1 \newline
	  a_3 		\in		  \\\{ a_2,a_3 \\\} \iff b_3    = 1 \newline \end{aligned} \\]

In fact, all subsets \\( S \subseteq A \\) can be mapped to a 3-bit sequence
using the rule \\((1.0)\\) as follows:

|| \\(\mathcal{P}(A)\\)						    | \\( \\\{0,1\\\}^3 \\) | \\(\text{binary}\\) | \\(\text{decimal}\\) |
|-|-|-|-|-|
|\\(1\\) | \\( \varnothing \\)				| \\( (0,0,0) \\)       | \\( 000_2 \\)       | \\(0_{10}\\)         |
|\\(2\\) | \\(\\\{a_3\\\}\\)					| \\( (0,0,1) \\)       | \\( 001_2 \\)       | \\(1_{10}\\)         |
|\\(3\\) | \\(\\\{a_2\\\}\\)					| \\( (0,1,0) \\)       | \\( 010_2 \\)       | \\(2_{10}\\)         |
|\\(4\\) | \\(\\\{a_2,a_3\\\}\\)		  | \\( (0,1,1) \\)       | \\( 011_2 \\)       | \\(3_{10}\\)         |
|\\(5\\) | \\(\\\{a_1\\\}\\)				  | \\( (1,0,0) \\)       | \\( 100_2 \\)       | \\(4_{10}\\)         |
|\\(6\\) | \\(\\\{a_1,a_3\\\}\\)		  | \\( (1,0,1) \\)       | \\( 101_2 \\)       | \\(5_{10}\\)         |
|\\(7\\) | \\(\\\{a_1,a_2\\\}\\)		  | \\( (1,1,0) \\)       | \\( 110_2 \\)       | \\(6_{10}\\)         |
|\\(8\\) | \\(\\\{a_1,a_2,a_3\\\}\\)  | \\( (1,1,1) \\)       | \\( 111_2 \\)       | \\(7_{10}\\)         |

As you can see, both sets \\( \mathcal{P}(A) \\) and \\( \\\{0,1\\\}^n \\) have
the same cardinality, which is \\(8\\). More importantly, we've demonstrated
that there's a bijection between them, because each element of \\(
\mathcal{P}(A) \\) is paired with exactly one element of \\( \\\{0,1\\\}^n \\).
\\(\blacksquare \\)

With this knowledge, it's very easy to count the number of values that can be
represented by any given n-bit integer type in Golang:

| \\(\text{type}\\)      |\\( \| \\\{0,1\\\}^n \| \\) | \\(\text{n-bit sequences}\\)
|-|-|-|
| \\(\text{int8}	\\)    |\\( 2^8 \\)                 | \\( 256 \\)
| \\(\text{int16} \\)    |\\( 2^{16} \\)              | \\( 65536\\)
| \\(\text{int32} \\)    |\\( 2^{32} \\)              | \\( 4294967296 \\)
| \\(\text{int64} \\)    |\\( 2^{64} \\)              | \\( 1.8446744e+19 \\)

It's precisely in this bijection, between product sets and power sets, that we rely
on when we use a bit set data structure in our programs.

#### Bit sets

A bit set is just an n-bit vector in which the \\(\text{nth}\\) byte represents
if any given \\(\text{nth}\\) element is present in the set. Bit sets can be
used in Golang with [bitwise
operators](https://yourbasic.org/golang/bitwise-operator-cheat-sheet/) to
execute several set operations.  To see them in action, we'll propose a simple
problem.

#### Working together

Let's suppose that we have \\(n\\) workers within a company, and we would like
to know: *for any two workers, how many days of the week do they work together?*
This problem can be easily solved using bit sets. Before we start, for clarity's
sake, let's depict the problem mathematically. First, let's define a set \\(W\\)
whose elements, \\( w_1, w_2, \cdots, w_i\\), represent days of the week:

\\[ \begin{align*} W &= \\\{ \ w_1, \ w_2,\ w_3,\ w_4,\ w_5,\ w_6,\ w_7 \\\} \ \ \newline
&= \\\{ \text{sun},\text{mon},\text{tue},\text{wed},\text{thu},\text{fri},\text{sat} \\\} \end{align*} \\]

The power set of \\(W\\), denoted \\( \mathcal{P}(W) \\), is the set of all
possible subsets of \\(W\\). Let \\( \mathcal{P}(W) \\) be our schedule set,
which contains all possible sequences of work schedules that a worker might take
in a week. What's the cardinality of \\( \mathcal{P}(W) ?\\) The answer is:

\\[ |W| = 7 \ \  \text{ implies } \ \  | \mathcal{P}(W) | = 2^7 = 128 \\]

We have \\(128\\) possible work schedules in our schedule set \\(
\mathcal{P}(W) \\), and it one of them can be encoded as a 7-bit sequence. The
rule for encoding each one of the subsets \\(S \subseteq W \\) to a sequence
\\((d_1, \cdots, d_7)\\) is defined by:

\\[ w_i \in S \iff  d_i = 1 \\]

Let's construct the bit sequence for the subset \\( \varnothing \subseteq W
\\):

\\[ w_1 \notin \varnothing \iff d_1 = 0 \newline
	  w_2 \notin \varnothing \iff d_2 = 0 \newline
	  w_3 \notin \varnothing \iff d_3 = 0 \newline
	  w_4 \notin \varnothing \iff d_4 = 0 \newline
	  w_5 \notin \varnothing \iff d_5 = 0 \newline
	  w_6 \notin \varnothing \iff d_6 = 0 \newline
	  w_7 \notin \varnothing \iff d_7 = 0 \\]

The bit sequence for \\( \varnothing \\) is \\( (0,0,0,0,0,0,0) \\). Let's try
another one: how about the bit sequence of the subset \\( \\\{
\text{mon},\text{tue},\text{thu} \\\} \subseteq W \\)?

\\[ w_1 \notin \\\{ \text{mon},\text{tue},\text{thu} \\\} \iff d_1 = 0 \newline
	  w_2 \in		 \\\{ \text{mon},\text{tue},\text{thu} \\\} \iff d_2 = 1 \newline
	  w_3 \in		 \\\{ \text{mon},\text{tue},\text{thu} \\\} \iff d_3 = 1 \newline
	  w_4 \notin \\\{ \text{mon},\text{tue},\text{thu} \\\} \iff d_4 = 0 \newline
	  w_5 \in		 \\\{ \text{mon},\text{tue},\text{thu} \\\} \iff d_5 = 1 \newline
	  w_6 \notin \\\{ \text{mon},\text{tue},\text{thu} \\\} \iff d_6 = 0 \newline
	  w_7 \notin \\\{ \text{mon},\text{tue},\text{thu} \\\} \iff d_7 = 0 \\]

The bit-sequence for the subset \\( \\\{ \text{mon},\text{tue},\text{thu} \\\}
\subseteq W \\) is \\( (0,1,1,0,1,0,0) \\). As you can see, the bit sequence
representation of the work schedules is really convenient. Hence, we can use
them to encode the work schedule of all \\(n\\) workers within the company.

Bit sequences can be easily construct in Golang using the [iota constant
generator](https://golang.org/ref/spec#Iota). Let's begin by creating bit
sequences for all the subsets \\( S \subseteq W\\) whose cardinalities are equal
to \\(1\\). In other words, let's create bit sequences for all the work
schedules that have just one day:

```go
package main

import (
	"fmt"
	"math/bits"
)

const (
	sat uint8 = 1 << iota // (0b00000001) -> {sat}
	fri                   // (0b00000010) -> {fri}
	thu                   // (0b00000100) -> {thu}
	wed                   // (0b00001000) -> {wed}
	tue                   // (0b00010000) -> {tue}
	mon                   // (0b00100000) -> {mon}
	sun                   // (0b01000000) -> {sun}
)
```

We have used the [iota constant generator](https://golang.org/ref/spec#Iota)
with the binary *shift left* operator `<<` to create seven bit sets. Notice that
the operation `x << k` consists in shifting the bytes of \\(x\\) by \\(k\\)
bits, dropping off the \\(k\\) most significant bits and then filling the right
end with \\(k\\) zeros.  Down below, we present a detailed table of the binary
*shift left* operation.  The **bolded digits** indicate the values that were
dropped from the left end, and *italicized digits* indicate the values that were
filled from the right end:

| operation			 | input										 | output |
|-|-|-|
| x	<< \\( 0 \\) | \\( 00000001 \\)					 | \\( 00000001 \\)
| x << \\( 1 \\) | \\( \textbf{0}0000001 \\) | \\( 0000001\textit{0} \\)
| x << \\( 2 \\) | \\( \textbf{00}000001 \\) | \\( 000001\textit{00} \\)
| x << \\( 3 \\) | \\( \textbf{000}00001 \\) | \\( 00001\textit{000} \\)
| x << \\( 4 \\) | \\( \textbf{0000}0001 \\) | \\( 0001\textit{0000} \\)
| x << \\( 5 \\) | \\( \textbf{00000}001 \\) | \\( 001\textit{00000} \\)
| x << \\( 6 \\) | \\( \textbf{000000}01 \\) | \\( 01\textit{000000} \\)

So now that we have created all the bit sequences for the work schedules with
a single day, we can unite them to create some work schedules for our
workers. Take Bob and Alice, for example. They just returned from vacation
and must choose the days they're going to work this week. Fortunately, the
company they work for is highly flexible about work schedules, which is
great, isn't it? So Bob decides to work four days this week: *Sunday*,
*Tuesday*, *Friday*, and *Saturday*. And Alice decides to begin with a
three-day work schedule: *Tuesday*, *Tuesday*, and *Saturday*. Both
workers can have theirs work schedules represented as a set:

\\[ \begin{align*} \text{Bob} &= \\\{ \text{sun} \\\} \cup \\\{ \text{thu} \\\}
\cup \\\{ \text{fri} \\\} \cup \\\{ \text{sat} \\\} \newline \text{Alice} &= \\\{
\text{tue} \\\} \cup \\\{ \text{thu} \\\} \cup \\\{ \text{sat} \\\} \end{align*}
\\]

Well, let's implement that. We'll create two variables `bob` and `alice` and use the
binary *or* operator `|` to union the work days of each one of them in a bit
set:

```go
bob := sun | thu | fri | sat // (0b01000111)
alice := tue | thu | sat     // (0b00010101)
```

Great! The bit sequence for Bob is \\( ( 1,0,0,0,1,1,1  ) \\) which represent
the set \\( \\\{ \text{sun}, \text{thu}, \text{fri}, \text{sat} \\\} \\). For
Alice, the bit sequence is \\( (0,0,1,0,1,0,1) \\) which maps to the set \\(
\\\{ \text{tue}, \text{thu}, \text{sat} \\\} \\). Now we've to know how many
days they work together. To answer that, we must intersect both sets, like this:

\\[ \text{Bob} \cap \text{Alice} = \\\{ \text{thu}, \text{sat} \\\} \\]

How might we do that within our code? We have to use the binary *and* operator
`&` to intersect the two sets:

```go
daysWorkingTogether := alice & bob // (0b00000101)
```

Perfect! The bit sequence \\( (0,0,0,0,1,0,1) \\) stands for the set \\( \\\{
\text{thu}, \text{sat} \\\} \\). Finally, to get the cardinality of the bit set
`daysWorkingTogether`, we need to calculate its [hamming
weight](https://en.wikipedia.org/wiki/Hamming_weight). Which, in this case,
means counting how many ones exist within the bit set. To do that, we can use
the function [OnesCount](https://pkg.go.dev/math/bits#OnesCount) from the
package [math/bits](https://pkg.go.dev/math/bits) package:

```go
cardinality := bits.OnesCount8(daysWorkingTogether) // 2
```

Great work! Bob and Alice work two days together. Go, team! If you are
interested in the code for the working together problem, it's in this
[gist](https://gist.github.com/rodmoioliveira/ac0cf7e41aca59c83cce4b4f8f1efe76).

In summary, sets are the building blocks of mathematics and are an essential data
structure to understand when writing computer programs. Sets provide an
efficient way to check membership in a group and to compute the union and
intersection of groups of objects. They also support various implementations,
such as maps, bit vectors, and [Bloom
filters](https://en.wikipedia.org/wiki/Bloom_filter).

### References
