+++
title = "Takeaways: Decomposing Systems into Modules "
description = ""
date = 2021-11-30
slug = "takeaways-decompose-systems-into-modules"
draft = true
[extra]
references = "content/blog/takeaways-decomposing-systems-into-modules.bibtex"
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
Modules](https://doi.org/10.1145/361598.361623) from 1972, written by [David
Lorge Parnas](https://en.wikipedia.org/wiki/David_Parnas), is a must-read and
pretty enlightening.

### Modular programming benefits

Accordingly to Parnas, these are the three expected benefits of modular
programming:

{% reference(citationKey="Parnas1972", p="1054") %}
(1) managerial - development time should be shortened because separate groups
would work on each module with little need for communication: (2) product
flexibility - it should be possible to make drastic changes to one module
without a need to change others; (3) comprehensibility - it should be possible
to study the system one module at a time. The whole system can therefore be
better designed because it is better understood.
{% end %}

### Keyword In Context Indexes

[H. P. Luhn](https://en.wikipedia.org/wiki/Hans_Peter_Luhn) and his colleges at
IBM, striving for a speedy method of organizing specialized indexes to technical
literature, proposed the utilization of keyword-in-context
([KWIC](https://en.wikipedia.org/wiki/Key_Word_in_Context)) indexes in 1960. The
idea was to improve the dissemination and retrieval of information among
scientists and researchers. The broadcast of new information should be fast to
diminish its perishable nature, and the KWIC method could readily be provided by
automatic processing. {{ reference(citationKey="Luhn1960", p="159-161") }}

The KWIC is an index of selected keywords listed with their surrounding words in
alphabetical order. KWIC indexing is grounded on three principles: (1) that
titles are generally informative; (2) that the keywords selected from the title
can guide the researcher to a publication likely to contain the desired
information; and (3) that although the meaning of an isolated word may be
ambiguous, the context surrounding the word aids to explain its meaning. {{
reference(citationKey="Riaz1982", p="41") }}. Here is how a KWIC index is
generated:

{% reference(citationKey="Luhn1960", p="161") %}
The process may be applied to the title of an article, its abstract or its
entire text. Keywords need only be defined as those which characterize a subject
more than others. To derive them, rules have to be established for
differentiating between what is significant and non-significant.  Since
significance is difficult to predict, it is more practical to isolate it by
rejecting all obviously non-significant or "common" words, with the risk of
admitting certain words of questionable status. Such words may subsequently be
eliminated or tolerated as so much "noise." A list of non-significant words
would include articles, conjunctions, prepositions, auxiliary verbs, certain
adjectives and words such as "report," "analysis," "theory," and the like. It
would become the task of an editor to extend this list as required. The
remaining significant or "key" words would be extracted from the text together
with a certain number of words that precede and follow them. By making the
keywords assume a fixed position within the extracted portions and by arranging
these portions in alphabetic order of the keywords, the KWIC Index is generated.
{% end %}


[input and output](https://users.cs.duke.edu/~ola/ipc/kwic.html)

```text
# Sample Input

is
the
of
and
as
a
but
::
Descent of Man
The Ascent of Man
The Old Man and The Sea
A Portrait of The Artist As a Young Man
A Man is a Man but Bubblesort IS A DOG

# Sample Output

a portrait of the ARTIST as a young man
the ASCENT of man
a man is a man but BUBBLESORT is a dog
DESCENT of man
a man is a man but bubblesort is a DOG
descent of MAN
the ascent of MAN
the old MAN and the sea
a portrait of the artist as a young MAN
a MAN is a man but bubblesort is a dog
a man is a MAN but bubblesort is a dog
the OLD man and the sea
a PORTRAIT of the artist as a young man
the old man and the SEA
a portrait of the artist as a YOUNG man
```

### Two decomposition examples

### Information hiding

### References
