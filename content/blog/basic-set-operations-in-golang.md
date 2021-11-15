+++
title = "Basic set operations in Golang"
description = ""
date = 2021-11-30
slug = "basic-set-operations-in-golang"
draft = true
+++

### What are sets?

In mathematics, a set is a collection of elements. The conventional way to write
down a set is to list the elements inside curly-braces, like this \\( \\\{ 1,2,3
\\\} \\). The elements inside a set should only appear once, because any element
is either in the set or not. Also, the order of the elements inside a
set is meaningless, so \\( \\\{ 1,2 \\\} \\) and \\( \\\{ 2,1 \\\} \\) are the
same set written two different ways.

### Abstract Data Type

Sets, as an [abstract data
type](https://en.wikipedia.org/wiki/Abstract_data_type), are a missing feature in
the Go language, but they can be easily implemented using
[maps](https://tour.golang.org/moretypes/19). Let's implement the `Set` type
with two methods: `MakeSet` to create new sets and, `ToString` to print its
string representation:

```go
type (
	// SetItem represent a item present in a Set.
	SetItem interface{}
	// SetSlice is a slice of items present in a Set.
	SetSlice []SetItem
	// Set is just a set.
	Set map[SetItem]membership

	membership struct{}
)

// MakeSet creates a new Set.
func MakeSet(si ...SetItem) (s Set) {
	s = make(map[SetItem]membership)
	for _, v := range si {
		s[v] = membership{}
	}

	return
}

// ToString returns a string representation
// of the set in arbitrary order.
func (s Set) ToString() string {
	r := make([]string, 0, s.Size())
	for k := range s {
		r = append(r, fmt.Sprintf("%v", k))
	}

	return fmt.Sprintf("{%v}", strings.Join(r, ","))
}
```

Now we can instantiate a new set and print its string representation like this:

```go
set := coll.MakeSet("cat", "cat", "frog", "dog", "cow")
fmt.Println(set.ToString()) // {frog,dog,cow,cat}
```

As you can see, all the duplicate elements were remove from the set, and its
elements are printed out inside curly-braces.

### Membership

The most simple set operation is to assert element membership. The expression
\\( e \in A \\) asserts that \\(e\\) is an element of the set \\(A\\). The
expression \\(y \notin A \\) means that \\(y\\) is not an element of the set
\\(A\\). Let's write a method called `Contains` for the `Set` type to verify if
any given element belong to it:

```go
// Contains returns true if the set contains a value.
func (s Set) Contains(si SetItem) (ok bool) {
	_, ok = s[si]

	return
}
```

Now let's create a new set and test for membership:

```go
set := coll.MakeSet("cat", "dog", "cow")

ok := set.Contains("cat")
fmt.Println(ok) // true

ok = set.Contains("buffalo")
fmt.Println(ok) // false
```

Easy peasy. Let's move on to other important set operations.

### Union

The union of sets \\( A \\) and \\( B \\), denoted \\( A \cup B \\), includes
exactly the elements appearing in \\( A \\) or \\( B \\) or both. And could be
defined in [set builder
notation](https://www.mathsisfun.com/sets/set-builder-notation.html) as:

\\[ A \cup B = \\\{x \in U \ | \  x \in A \ \lor \  x \in B\\\} \\]

Let's write an `Union` method for the `Set` type to compute the union of two sets:

```go
// Union returns the set of values that are in s or in other,
// without duplicates.
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
B = \\\{ cat, duck, bull \\\} \\) can be defined as \\( A \cup B = \\\{
cat,dog,cow,duck,bull \\\} \\). Let's test our implementation:

```go
A := coll.MakeSet("cat", "dog", "cow")
B := coll.MakeSet("cat", "duck", "bull")

U := A.Union(B)
fmt.Println(U.ToString())
// {cat,dog,cow,duck,bull}
```

All good so far.

### Intersection

The intersection of \\( A \\) and \\( B \\), denoted \\( A \cap B \\), consists
of all elements that appear in both \\( A \\) and \\( B \\). And could be
defined is set builder notation as:

\\[ A \cap B = \\\{x \in U \ | \ x \in A\ \land x \in B\\\} \\]

Let's write an `Intersection` method for the `Set` type to yield the elements of
the intersection of two sets:

```go
// Intersection returns the set of values that are both in s and other.
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
and \\( B = \\\{ cat, duck, bull \\\} \\) can be defined as \\( A \cap B = \\\{
cat \\\} \\). In our Go code, this operation is expressed as:

```go
A := coll.MakeSet("cat", "dog", "cow")
B := coll.MakeSet("cat", "duck", "bull")

I := A.Intersection(B)
fmt.Println(I.ToString())
// {cat}
```

### Subset

{% katex(block=true) %}
$$ \text{(definition)}\ \newline A \subseteq B \iff A \cap B=A. $$
$$ \text{(example)}\    \newline \{ 1,2 \} \subseteq \{ 1,2,3 \} $$
{% end %}

```go
// SubsetOf returns true if s is a subset of other.
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

### Difference

{% katex(block=true) %}
$$ \text{(definition)}\ \newline A \setminus B = \{x \, |\, x \in A\, \land x \notin B\} $$
$$ \text{(example)}\    \newline \{ 1,2,3 \} \setminus \{ 3,4,5 \} = \{1,2\} $$
{% end %}

```go
// Difference returns the set of values that are in s but not in other.
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

### Symmetric Difference

{% katex(block=true) %}
$$ \text{(definition)}\ \newline A \triangle B = (A \setminus B) \cup (B \setminus A) $$
$$ \text{(example)}\    \newline \{ 1,2,3 \} \triangle \{ 3,4,5 \} = \{1,2,4,5\} $$
{% end %}

```go
// SymmetricDifference returns the set of values that are in s or in other but
// not in both.
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

* [wikipedia](https://en.wikipedia.org/wiki/Set_(mathematics))
* [set builder notation](https://www.mathsisfun.com/sets/set-builder-notation.html)
* [katex](https://katex.org/docs/supported.html)
* [katex suport table](https://katex.org/docs/support_table.html)
* [List of LaTeX mathematical symbols](https://oeis.org/wiki/List_of_LaTeX_mathematical_symbols#Set_and.2For_logic_notation)
* [symmetric-difference](https://www.landonlehman.com/post/symmetric-difference/)

