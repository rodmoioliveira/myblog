+++
title = "Basic set operations in Golang"
description = ""
date = 2021-11-30
slug = "basic-set-operations-in-golang"
draft = true
+++

### Data Type

* [wikipedia](<https://en.wikipedia.org/wiki/Set_(mathematics)>)
* [set builder notation](https://www.mathsisfun.com/sets/set-builder-notation.html)
* [katex](https://katex.org/docs/supported.html)
* [katex suport table](https://katex.org/docs/support_table.html)
* [List of LaTeX mathematical symbols](https://oeis.org/wiki/List_of_LaTeX_mathematical_symbols#Set_and.2For_logic_notation)
* [symmetric-difference](https://www.landonlehman.com/post/symmetric-difference/)

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
```

### Union

{% katex(block=true) %}
$$ \text{(definition)}\ \newline A \cup B = \{x \in U \, | \, x \in A\, \lor x \in B\} $$
$$ \text{(example)}\    \newline \{ 1,2,3 \} \cup \{ 4,5,6 \} = \{ 1,2,3,4,5,6 \} $$
{% end %}

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

### Intersection

{% katex(block=true) %}
$$ \text{(definition)}\ \newline A \cap B = \{x \in U \, | \, x \in A\, \land x \in B\} $$
$$ \text{(example)}\    \newline \{ 1,2,3 \} \cap \{ 3,4,5 \} = \{3\} $$
{% end %}

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
