+++
title = "Basic set operations in Golang"
description = ""
date = 2021-11-30
slug = "basic-set-operations-in-golang"
draft = true
+++

### Abstract Data Type

https://en.wikipedia.org/wiki/Set_(mathematics)

{% katex(block=true) %}

   $$ S = \{ 1,2,3,4,5 \} $$

{% end %}

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

### Symmetric Difference

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
