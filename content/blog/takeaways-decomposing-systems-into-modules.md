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
judgments about the right way of writing software which, in many cases, are
presented as an objective truth about what is good software architecture.

Disagreements normally happen because the participants have failed to establish
a common ground on what the process of modularization should do. Should it
simplify the code, improve the comprehensibility of the system, increase
flexibility, speed development process, which one? Maybe all of them? Sometimes
the contenders engage in philosophical disputes about how much things should be
put together or separated. They are the same thing, they are related things, or
they are separate things? Frequently, people have different opinions on that.
Some people like to spread code across as many files as possible. Others tend to
pile the code into a single file with thousands of lines of code. It's quite
maddening.

Thankfully, some bright people wrote good advice on the matter. The seminal
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

Whether of not these benefits can be harvested is dependent upon the criteria
used in dividing the system into modules. The process of deciding on how to
slice the system into different parts is called *modularization*.

### Modularizations are not modules

*Modularization* is a process that consists of all the design decisions that had
to be made before the work on a module can begin. In the article, two approaches
were introduced for the modularization process: the first one represents the
functional approach, with is the more common one; the second represents the
information hiding approach. A KWIC Index Production System was chosen as toy
problem to illustrate the modularization process.

### Keyword In Context Indexes

[H. P. Luhn](https://en.wikipedia.org/wiki/Hans_Peter_Luhn) and his colleagues
at IBM, striving for a speedy method of organizing specialized indexes to
technical literature, proposed the utilization of keyword-in-context
([KWIC](https://en.wikipedia.org/wiki/Key_Word_in_Context)) indexes in 1960. The
idea was to improve the dissemination and retrieval of information among
scientists and researchers. The broadcast of new information should be fast to
mitigate its perishable nature, and the KWIC method could readily be provided by
automatic processing. {{ reference(citationKey="Luhn1960", p="159-161") }}

The KWIC is an index of selected keywords listed with their surrounding words in
alphabetical order. KWIC indexing is grounded on three principles: (1) titles
are generally informative; (2) the keywords selected from the title can guide
the researcher to a publication likely to contain the desired information; and
(3) although the meaning of an isolated keyword may be ambiguous, the context
words surrounding it aids to explain its meaning. {{
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

To produce a KWIC index, we must define a list of non-significant words and a
list of titles. Let's introduce an example for clarification's sake. For
instance, the following input:

```text
IGNORE
on, the, to, be, in, into, and, used, for
--
TITLES
On the Criteria to Be Used in Decomposing Systems into Modules
Advanced Indexing and Abstracting Practices
Keyword-in-context index for technical literature (kwic index)
```

Might produce the following KWIC index:

```text
ABSTRACTING     Advanced Indexing and ABSTRACTING Practices
ADVANCED        ADVANCED Indexing and Abstracting Practices
CONTEXT         Keyword-in-CONTEXT index for technical literature (kwic index)
CRITERIA        On the CRITERIA to Be Used in Decomposing Systems into Modules
DECOMPOSING     On the Criteria to Be Used in DECOMPOSING Systems into Modules
INDEX           Keyword-in-context INDEX for technical literature (kwic index)
INDEX           Keyword-in-context index for technical literature (kwic INDEX)
INDEXING        Advanced INDEXING and Abstracting Practices
KEYWORD         KEYWORD-in-context index for technical literature (kwic index)
KWIC            Keyword-in-context index for technical literature (KWIC index)
LITERATURE      Keyword-in-context index for technical LITERATURE (kwic index)
MODULES         On the Criteria to Be Used in Decomposing Systems into MODULES
PRACTICES       Advanced Indexing and Abstracting PRACTICES
SYSTEMS         On the Criteria to Be Used in Decomposing SYSTEMS into Modules
TECHNICAL       Keyword-in-context index for TECHNICAL literature (kwic index)
```

### Two decomposition examples

### Information hiding

### References
