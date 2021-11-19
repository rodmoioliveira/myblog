+++
title = "Basic set operations in Golang"
description = "As an abstract data type, sets are a missing feature in the Go language. But can be easily implemented using maps."
date = 2021-11-19
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

Sets are a fundamental mathematical construct and serve as a handy data
structure when writing computer programs. Some languages implement sets by
default. But in others, like Go, you have to implement yourself.

### Abstract Data Type

As an [abstract data type](https://en.wikipedia.org/wiki/Abstract_data_type),
sets are a missing feature in the Go language. However they can be easily
implemented by using [maps](https://tour.golang.org/moretypes/19). Let's
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
elements were printed out inside curly braces in arbitrary order.

### Basic set operations

We'll implement some basic set operations in Golang, like **membership**
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
through complements.

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

The empty set (\\( \varnothing \\)) is an identity operand for unions, and the
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
these relations, we can transform otherwise hard problems into trivial
operations. For instance, there's a clever way to count the number of n-bit
sequences that can be yielded from an n-bit unit of data used. To understand how
it works, we have to comprehend the following mathematical concepts within set
theory: **cardinality**, **product of sets**, **power sets**, and **bijections**.

#### Cardinality

The cardinality or size of a set \\(A\\), denoted \\(|A|\\), is the number of
elements in \\(A\\) when that number is finite:

\\[ A = \\\{0,1\\\} \Rightarrow |A| = 2 \\]

#### Product of sets

The product of two sets \\(A\\) and \\(B\\), denoted \\(A \times B\\), is the set of
all ordered pairs of elements in \\(A\\) and elements in \\(B\\). In set-builder
notation it is:

\\[ A \times B = \\\{(a,b) : a \in A \text{ and } b \in B\\\} \\]

A product of \\(n\\) copies of a set \\(A\\) is denoted \\(A^n\\). In
set-builder notation:

\\[ A^n = \\\{(a_1, \cdots, a_n) : a_i \in A \text{ for every } i \\\} \\]

The cardinality of the product of sets is rule by \\( |A \times B| =
2^{|A||B|}\\) and \\( |A^{n}| = 2^n \\).

#### Power Set

The power set of the set \\(A\\), denoted \\( \mathcal{P}(A) \\), is the set of
all the subsets \\(B\\) in the set \\(A\\). In set-builder notation it is:

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

\\[ |A| = n \ \ \text{ implies } \ \  | \mathcal{P}(A) | = | \\\{0,1\\\}^n | =
2^{n} \\]

And that there's a bijection between them:

\\[ \mathcal{P}(A) \text{ bij } \\\{0,1\\\}^n \\]

Let \\(A\\) be a three-elements set \\( \\\{a_1,a_2,a_3 \\\} \\). The \\(
\mathcal{P}(A) \\) has eight different subsets:

\\[ \varnothing, \\\{a_1 \\\}, \\\{a_2 \\\}, \\\{a_3 \\\},\\\{a_1,a_2 \\},
\newline \\\{a_2,a_3 \\}, \\\{a_1,a_3 \\}, \\\{a_1,a_2,a_3 \\} \\]

Let \\( a_1,a_2, \cdots, a_n \\) be the elements of \\( A \\). The bijection
maps each subset of \\( S \subseteq A \\) to the bit sequence \\( (b_1, \cdots,
b_n) \\) defined by the rule that:

\\[ b_i = 1 \iff a_i \in S \\]

For example, if \\(n = 10\\), then the subset \\(\\\{a_2,a_3,a_7,a_9\\\}\\) maps
to a 10-bit sequence as follows:

\\[ \begin{align*} \text{subset: } \\\{\ \ \ ,a_2, a_3,\ \ \ ,\ \ \ ,\ \ ,a_7,\ \ , a_9,\ \ \\\} \newline
\text{sequence: } (\ \ 0,\ 1,\ 1,\ 0,\ 0,\ 0,\ 1,\ 0,\ 1,\ 0) \end{align*} \\]

Here is the map from the subsets of the set \\(A = \\\{a_1,a_2,a_3\\\}\\) to the
product set of 3-bit sequences:

| \\(\mathcal{P}(A)\\)      | \\( \\\{0,1\\\}^3 \\) | \\(\text{binary}\\) | \\(\text{decimal}\\) |
|-|-|-|-|
| \\( \varnothing \\)				| \\( (0,0,0) \\)       | \\( 000_2 \\)       | \\(0_{10}\\)         |
| \\(\\\{a_3\\\}\\)					| \\( (0,0,1) \\)       | \\( 001_2 \\)       | \\(1_{10}\\)         |
| \\(\\\{a_2\\\}\\)					| \\( (0,1,0) \\)       | \\( 010_2 \\)       | \\(2_{10}\\)         |
| \\(\\\{a_2,a_3\\\}\\)		  | \\( (0,1,1) \\)       | \\( 011_2 \\)       | \\(3_{10}\\)         |
| \\(\\\{a_1\\\}\\)				  | \\( (1,0,0) \\)       | \\( 100_2 \\)       | \\(4_{10}\\)         |
| \\(\\\{a_1,a_3\\\}\\)		  | \\( (1,0,1) \\)       | \\( 101_2 \\)       | \\(5_{10}\\)         |
| \\(\\\{a_1,a_2\\\}\\)		  | \\( (1,1,0) \\)       | \\( 110_2 \\)       | \\(6_{10}\\)         |
| \\(\\\{a_1,a_2,a_3\\\}\\) | \\( (1,1,1) \\)       | \\( 111_2 \\)       | \\(7_{10}\\)         |

With this knowledge, it's very easy to count the number of values that can be
represented by any given `int` type in Golang:

| \\(\text{type}\\)      |\\( \| \\\{0,1\\\}^n \| \\) | \\(\text{n-bit sequences}\\)
|-|-|-|
| \\(\text{int8}	\\)    |\\( 2^8 \\)                 | \\( 256 \\)
| \\(\text{int16} \\)    |\\( 2^{16} \\)              | \\( 65536\\)
| \\(\text{int32} \\)    |\\( 2^{32} \\)              | \\( 4294967296 \\)
| \\(\text{int64} \\)    |\\( 2^{64} \\)              | \\( 1.8446744e+19 \\)

It's precisely in this bijection from product sets to power sets that we rely on
when we use a bit set data structure.

#### Bit set

A bit set is just a n-bit sequence. Bit sets be used in Golang with [bitwise
operators](https://yourbasic.org/golang/bitwise-operator-cheat-sheet/) to
execute several set operations. To see them in action, we'll propose a simple
problem. Let's suppose that we have \\(n\\) workers within a company, and we
would like to known, for any two workers, how many days of the week they work
together. This problem can be easily solved using bit sets.

First, let's define a set \\(W\\) whose elements, \\( w_1, w_2, \cdots, w_i\\),
represent a day of the week:

\\[ \begin{aligned} W = \\\{ \ w_1 \, \ w_2 \,\ w_3 \,\ w_4 \,\ w_5 \,\ w_6 \,\ w_7 \ \\\} \ \ \newline
= \\\{ \text{sun},\text{mon},\text{tue},\text{wed},\text{thu},\text{fri},\text{sat} \\\} \end{aligned} \\]

The power set of \\(W\\), denoted \\( \mathcal{P}(W) \\), is the set of all
possible subsets of \\(W\\). Let \\( \mathcal{P}(W) \\) be our schedule set,
which contains all possible sequences of work schedules derived from the seven
days of the week. What's the cardinality of \\( \mathcal{P}(W) \\)? The answer
is:

\\[ |W| = 7 \ \  \text{ implies } \ \  | \mathcal{P}(W) | = 2^7 = 128 \\]

We have \\(128\\) possible working schedules in our schedule set \\(
\mathcal{P}(W) \\), and it one of them can be encoded as an 7-bit sequence. The
rule for encoding each one of the subsets \\(S \subseteq W \\) to a sequence
\\((d_1, \cdots, d_7)\\) is defined by:

\\[ d_i = 1 \iff w_i \in S \\]

Let's construct the encode sequence for the subset \\( \varnothing \subseteq W \\):

\\[ d_1 = 0 \iff w_1 \notin \varnothing \newline
	  d_2 = 0 \iff w_2 \notin \varnothing \newline
	  d_3 = 0 \iff w_3 \notin \varnothing \newline
	  d_4 = 0 \iff w_4 \notin \varnothing \newline
	  d_5 = 0 \iff w_5 \notin \varnothing \newline
	  d_6 = 0 \iff w_6 \notin \varnothing \newline
	  d_7 = 0 \iff w_7 \notin \varnothing \\]

The encoding sequence for the empty set \\( \varnothing \\) is \\(
(0,0,0,0,0,0,0) \\). Let's do another one: how about the bit-sequence of the
subset \\( \\\{ \text{mon},\text{tue},\text{thu} \\\} \in W \\)?

\\[ d_1 = 0 \iff w_1 \notin \\\{ \text{mon},\text{tue},\text{thu} \\\}  \newline
	  d_2 = 1 \iff w_2 \in \\\{ \text{mon},\text{tue},\text{thu} \\\}  \newline
	  d_3 = 1 \iff w_3 \in \\\{ \text{mon},\text{tue},\text{thu} \\\}  \newline
	  d_4 = 0 \iff w_4 \notin \\\{ \text{mon},\text{tue},\text{thu} \\\}  \newline
	  d_5 = 1 \iff w_5 \in \\\{ \text{mon},\text{tue},\text{thu} \\\}  \newline
	  d_6 = 0 \iff w_6 \notin \\\{ \text{mon},\text{tue},\text{thu} \\\}  \newline
	  d_7 = 0 \iff w_7 \notin \\\{ \text{mon},\text{tue},\text{thu} \\\}  \\]

The bit-sequence for the subset \\( \\\{ \text{mon},\text{tue},\text{thu} \\\}
\in W \\) is \\( (0,1,1,0,1,0,0) \\).

```go
package main

import (
	"fmt"
	"math/bits"
)

const (
	sat uint8 = 1 << iota // (0b0000001) -> {sat}
	fri                   // (0b0000010) -> {fri}
	thu                   // (0b0000100) -> {thu}
	wed                   // (0b0001000) -> {wed}
	tue                   // (0b0010000) -> {tue}
	mon                   // (0b0100000) -> {mon}
	sun                   // (0b1000000) -> {sun}

	noWork byte = byte(0b0000000) // -> Empty Set
)
```

```go
bob := noWork | sun | thu | fri | sat
alice := noWork | mon | tue | thu | sat
daysWorkingTogether := alice & bob
```

### References
