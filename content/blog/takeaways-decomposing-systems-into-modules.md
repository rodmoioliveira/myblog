+++
title = "Takeaways: Decomposing Systems into Modules "
description = ""
date = 2021-11-30
slug = "takeaways-decompose-systems-into-modules"
draft = true
+++

There's a lot of discussion on why and how we should modularize our systems.
Some provoke heated debates, often driven by personal preferences and subjective
judgments about the right way of writing software. These, in many cases, are
presented as an objective truth about what is good software architecture.

Often, these disagreements happen because the participants have failed to
establish a common ground on what the process of modularization should do.
Should simplify the code, improve the comprehensibility of the system, increase
flexibility, speed development process, what? Sometimes the contenders engage in
philosophical disputes about how much the things should be put together or
separated. They are the same thing, they are related things, or they are
separate things? Frequently, people have different opinions on that. Some people
like to spread code across as many files as possible. Others tend to pile the
code into a single file with thousands of lines of code. It's quite maddening.

Hopefully, some bright people wrote good advice on the matter. The seminal
article [On the Criteria To Be Used in Decomposing Systems into
Modules](http://citeseer.ist.psu.edu/viewdoc/summary?doi=10.1.1.132.7232) from
1972, written by [David Lorge
Parnas](https://en.wikipedia.org/wiki/David_Parnas), is a must-read and pretty
enlightening.

### Expected benefits

Accordingly to Parnas, these are the three expected benefits of modular
programming:

1. **managerial** - work could be parallelized among different teams because
   each one is responsible for one module, with little need for communication.
2. **flexibility** - changes in one module shouldn't promote changes in other
   modules.
3. **comprehensibility** - the whole system should be more comprehensible
   because it can be studied one module at the time.

(1) managerial - development time should be shortened because separate groups
would work on each module with little need for communication: (2) product
flexibility - it should be possible to make drastic changes to one module
without a need to change others; (3) comprehensibility - it should be possible
to study the system one module at a time. The whole system can therefore be
better designed because it is better understood. {{ reference(id=1, type="text") }}

### Keyword In Context (KWIC)

{% quote(font="Parnas 72") %}
The KWIC index system accepts an ordered set of lines, each line is an ordered
set of words, and each word is an ordered set of characters. Any line may be
"circularly shifted" by repeatedly removing the first word and appending it at
the end of the line. The KWIC index system outputs a listing of all circular
shifts of all lines in alphabetical order.
{% end %}

### Two decomposition examples

### Information hiding

### References

- {{ reference(id=1, type="foot") }}
- - D. L. Parnas. 1972. On the criteria to be used in decomposing systems into modules. Commun. ACM 15, 12 (Dec. 1972), 1053–1058. [https://doi.org/10.1145/361598.361623](https://doi.org/10.1145/361598.361623)
- {{ reference(id=2, type="foot") }}
- - Atlantic Publishers & Distributors. 1989. Advanced Indexing and Abstracting Practices. [https://books.google.com.br/books?id=nIUkl7bLzYUC](https://books.google.com.br/books?id=nIUkl7bLzYUC)
- {{ reference(id=3, type="foot") }}
- - Luhn, H.P. (1960), Keyword-in-context index for technical literature (kwic index). Amer. Doc., 11: 288-295. [https://doi.org/10.1002/asi.5090110403](https://doi.org/10.1002/asi.5090110403)
- {{ reference(id=4, type="foot") }}
- - https://en.wikipedia.org/wiki/Key_Word_in_Context - overview
- {{ reference(id=5, type="foot") }}
- - Example de input and output - https://users.cs.duke.edu/~ola/ipc/kwic.html
