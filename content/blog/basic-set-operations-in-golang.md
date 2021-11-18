+++
title = "Basic set operations in Golang"
description = ""
date = 2021-11-30
slug = "basic-set-operations-in-golang"
draft = false
[extra]
references = "content/blog/basic-set-operations-in-golang.bibtex"
katex_enable = true
katex_auto_render = true
+++

### What are sets?

In mathematics, a set is a collection of unique and unsorted elements. The
conventional way to write down a set is to list the elements inside
curly-braces, like this \\( \\\{ 1,2,3 \\\} \\). The elements inside a set
should only appear once, because any element is either in the set or not. This
mean that the set \\( \\\{ dog, dog, cat \\\} \\) and \\( \\\{ dog, cat \\\} \\)
are equal. Also, the order of the elements inside a set is meaningless, so \\(
\\\{ a,b,c \\\} \\) and \\( \\\{ c,b,a \\\} \\) are the same set written in two
different ways.

Sets are a fundamental mathematical construct and serve as a handy data
structure when writing computer programs. In some languages, they are
implemented by default which it's quite nice. But in others, like Go, you have
to implement yourself.

### Abstract Data Type

Sets, as an [abstract data
type](https://en.wikipedia.org/wiki/Abstract_data_type), are a missing feature
in the Go language, but they can be easily implemented using
[maps](https://tour.golang.org/moretypes/19). Let's implement the `Set` type
with three methods: `MakeSet` to create new sets, `Size` to get the set's
cardinality and, `ToString` to print its string representation:

```go
type (
	SetItem interface{}
	SetSlice []SetItem
	Set map[SetItem]membership
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

As you can see, all the duplicate elements were remove from the set, and its
elements are printed out inside curly-braces in arbitrary order.

### Basic set operations

We are going to implement some basic set operation in Golang, like: *membership
assertion*, *union*, *intersection*, *difference*, *symmetric difference* and *subset
assertion*. Besides that, we'll provide the mathematical definition and formula for each
one of these operations to better understand them.

#### Membership

The most simple set operation is to assert element membership. The expression
\\( e \in A \\) asserts that \\(e\\) is an element of the set \\(A\\). The
expression \\(y \notin A \\) means that \\(y\\) is not an element of the set
\\(A\\). Let's write a method called `Contains` for the `Set` type to verify if
any given element belong to it:

```go
func (s Set) Contains(si SetItem) (ok bool) {
	_, ok = s[si]

	return
}
```

Now let's build a new set and test for membership:

```go
set := MakeSet("cat", "dog", "cow")

ok := set.Contains("cat")
fmt.Println(ok) // true

ok = set.Contains("buffalo")
fmt.Println(ok) // false
```

Easy peasy, let's continue.

#### Union

The union of sets \\( A \\) and \\( B \\), denoted by the expression \\( A \cup
B \\), is the set that includes exactly the elements appearing in \\( A \\) or
\\( B \\) or both. This could be written in [set builder
notation](https://www.mathsisfun.com/sets/set-builder-notation.html) as:

\\[ A \cup B = \\\{x : x \in A \ \text{or} \  x \in B\\\} \\]

Let's create an `Union` method for the `Set` type to compute the union of two
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

The result of the union of two sets \\( A = \\\{ cat, dog, cow \\\} \\) and \\(
B = \\\{ cat, duck, bull \\\} \\) can be expressed as \\( A \cup B = \\\{
cat,dog,cow,duck,bull \\\} \\). Let's test our implementation:

```go
A := MakeSet("cat", "dog", "cow")
B := MakeSet("cat", "duck", "bull")

U := A.Union(B)
fmt.Println(U.ToString())
// {cat,dog,cow,duck,bull}
```

All good so far.

#### Intersection

The intersection of \\( A \\) and \\( B \\), denoted by the expression \\( A
\cap B \\), is a set of all elements that appear in both \\( A \\) and \\( B
\\). And could be written in set builder notation as:

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

The result of the intersection of the sets \\( A = \\\{ cat, dog, cow \\\} \\)
and \\( B = \\\{ cat, duck, bull \\\} \\) can be presented as \\( A \cap B = \\\{
cat \\\} \\). In our Go code, this operation is expressed as:

```go
A := MakeSet("cat", "dog", "cow")
B := MakeSet("cat", "duck", "bull")

I := A.Intersection(B)
fmt.Println(I.ToString())
// {cat}
```

It works just as expected.

#### Difference and Complement

The difference of \\( A \\) and \\( B \\), or the complement of \\( B \\) in \\(
A \\), denoted by the expression \\( A \setminus B \\), is a set of all elements
that appear in \\( A \\) but not in \\( B \\). And could be written in set
builder notation as:

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

The result of the difference of the sets \\( A = \\\{ cat, dog, cow \\\} \\) and
\\( B = \\\{ cat, duck, bull \\\} \\) can be written as \\( A \setminus B =
\\\{dog,cow \\\} \\). Let's check if our code is correct:


```go
A := MakeSet("cat", "dog", "cow")
B := MakeSet("cat", "duck", "bull")

D := A.Difference(B)
fmt.Println(D.ToString())
// {dog,cow}
```

Perfect.

#### Symmetric Difference

The symmetric difference of \\( A \\) and \\( B \\), denoted by the expression
\\( A \ominus B \\), is a set of all elements that appear in \\( A \\) or in
\\( B \\) but not in both. And could be written in set builder notation as:

\\[ A \ominus B = \\\{ x : x \in A \setminus B \text{ or} \in B \setminus A \\\} \\]

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

The result of the symmetric difference of the sets \\( A = \\\{ cat, dog, cow
\\\} \\) and \\( B = \\\{ cat, duck, bull \\\} \\) can be defined as \\( A
\ominus B = \\\{ dog, cow, duck, bull \\\} \\). Let's try it in our code:

```go
A := MakeSet("cat", "dog", "cow")
B := MakeSet("cat", "duck", "bull")

SD := A.SymmetricDifference(B)
fmt.Println(SD.ToString())
// {dog,cow,duck,bull}
```

Nice.

#### Subset

The expression \\( A \subseteq B \\) indicates that set \\( A \\) is a subset of
set \\( B \\), which means that every element of \\( A \\) is also an element of
\\( B \\). This could be written as:

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

For the sets \\( A = \\\{ cat, dog, cow \\\} \\) and \\( B = \\\{ cat, dog
\\\} \\), we can assert that \\( B \subseteq A \\) is \\( true \\), but \\( A
\subseteq B \\) is \\( false \\). Let's test it:

```go
A := MakeSet("cat", "dog", "cow")
B := MakeSet("cat", "dog")

fmt.Println(B.SubsetOf(A)) // true
fmt.Println(A.SubsetOf(B)) // false
```

Good. With that we had implemented the basic set operations supported for sets
as an abstract data type. Now we can get familiar with some fundamental set
properties that we should know about.

### Set Identities

Sets have some properties that hold true for all subsets of any given set. These
properties are called set identities and are presented down below. In the follow
examples, consider that the sets \\( A \\), \\( B\\), \\( C \\) are subsets of
an universal set \\( U \\).

#### Antisymmetric

A binary relation \\(R\\) on a set \\(A\\) is antisymmetric if there is no pair
of distinct elements of \\(A\\) each of which is related by \\(R\\) to the
other. More formally, \\(R\\) is antisymmetric precisely if:

\\[ \forall x,y \in A:(xRy \text{ and } yRx) \Rightarrow x = y \\]

For sets, the subset relation is antisymmetric:

\\[ A \subseteq B \text{ and }  B \subseteq A \Rightarrow A = B \\]

#### Associative

Associativity is a property of some binary operations, which means that
rearranging the parentheses in an expression will not change the result.

\\[ A \cup \left( {B \cup C} \right) = \left( {A \cup B} \right) \cup C \newline
A \cap \left( {B \cap C} \right) = \left( {A \cap B} \right) \cap C \\]

#### Commutative

A binary operation is commutative if changing the order of the operands does not
change the result. Union and intersection are commutative operations.

\\[ A \cup B = B \cup A \newline A \cap B = B \cap A \\]

#### Complement

In set theory, the complement of a set \\( A \\), denoted by \\( A^c \\), are
all the elements that aren't in \\( A \\):

\\[ A \cup {A ^ c} = U \newline A \cap {A ^ c} = \varnothing \newline {U ^ c} =
\varnothing \newline {\varnothing ^ c} = U \\]

#### De Morgan's

De Morgan's Laws describe how mathematical statements and concepts are related
through their opposites, which explain how to distribute NOT's(\\(\neg\\)) over
AND's(\\(\\land\\)) and OR's(\\(\lor\\)):

\\[ \neg (P \land Q) \iff  (\neg P) \lor (\neg Q) \newline \neg (P \lor Q) \iff
(\neg P) \land (\neg Q) \\]

In set theory, De Morgan's Laws relate the intersection and union of sets
through complements.

\\[ ( A \cup B )^c = A^c \cap B^c \newline ( A \cap B )^c = A^c \cup B^c \\]

#### Distributive

The distributive property tells us how to solve expressions where more than one
binary relation is involved. For example, given a set \\( A \\) and two binary
operators \\( * \\) and \\( + \\) on \\( A \\), the distributive law asserts
that multiplication (\\( * \\)) distributes over addition (\\( + \\)) in
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

\\[ \forall a,b,c \in A:(aRb \text{ and } bRc) \Rightarrow aRc \\]

For sets, the subset relation is transitive:

\\[ ( A \subseteq B ) \text{ and } ( B \subseteq C ) \Rightarrow  ( A \subseteq
C ) \\]

### Solving problems with sets

...

### References
